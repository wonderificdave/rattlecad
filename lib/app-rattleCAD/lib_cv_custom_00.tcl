 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_cv_custom_00.tcl
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
 #	namespace:  rattleCAD::cv_custom_00
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval cv_custom_00 {

	variable    bottomCanvasBorder	30
	
	variable 	baseLine
	array	set	baseLine	{}

	proc update {cv_Name} {
		
		variable 	bottomCanvasBorder
	
			# --- get updateCommand
		set updateCommand		[namespace current]::update 

			# puts " ->  $cv_Name"
			
		switch $cv_Name {
			__lib_gui::cv_Custom99 {
						#
						# -- geometry - of existing Frame
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_reference::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent				
						#
					frame_visualisation::createBaseline 			$cv_Name $xy	reference
						#
					createDimension_Reference						$cv_Name $xy	geometry_bg		
						#
					frame_visualisation::createFrame_Centerline		$cv_Name $xy	{saddle seattube steerer chainstay fork} {crankset}
						#
					createDimension_Reference						$cv_Name $xy	geometry_fg
						#
					lib_gui::notebook_createButton					$cv_Name 		Reference2Custom
						#
					}
			lib_gui::cv_Custom00 {
						#
						# -- base geometry
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent					
						#
					frame_visualisation::createBaseline 		$cv_Name $xy	
						#
					createDimension								$cv_Name $xy	point_seat	
					createDimension								$cv_Name $xy	point_frame					
					createDimension								$cv_Name $xy	geometry_bg		
						#
					frame_visualisation::createFrame_Centerline	$cv_Name $xy 	{saddle seattube steerer chainstay fork}
						#
					createDimension								$cv_Name $xy	point_personal	
					createDimension								$cv_Name $xy	point_crank								
					createDimension								$cv_Name $xy	geometry_fg								
						#
				}
			lib_gui::cv_Custom01 {
						#
						# -- frame - tubing
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame ]					
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createDecoration		$cv_Name $xy	SeatPost			$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 	$updateCommand 					
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 	$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	Saddle				$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	HeadSet				$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	Stem				
					frame_visualisation::createDecoration		$cv_Name $xy 	LegClearance_Rep	
						#
					createCenterline							$cv_Name $xy	Saddle
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy	frameTubing_bg	
						#
					createDimensionType							$cv_Name $xy 	RearWheel_Clearance 	
					createDimensionType							$cv_Name $xy 	LegClearance			
					createDimensionType							$cv_Name $xy 	HeadTube_Length 	$updateCommand	
					createDimensionType							$cv_Name $xy 	SeatTube_Extension	$updateCommand	
					createDimensionType							$cv_Name $xy 	SeatStay_Offset		$updateCommand	
					createDimensionType							$cv_Name $xy 	HeadTube_OffsetTT	$updateCommand	
					createDimensionType							$cv_Name $xy 	HeadTube_OffsetDT	$updateCommand	
					createDimensionType							$cv_Name $xy 	DownTube_Offset		$updateCommand	
					createDimensionType							$cv_Name $xy 	TopTube_Angle		$updateCommand						
					createDimensionType							$cv_Name $xy 	HeadSet_Bottom		$updateCommand
					createDimensionType							$cv_Name $xy 	ForkHeight			$updateCommand				
					createDimensionType							$cv_Name $xy 	Brake_Bridge		$updateCommand		
					createDimensionType							$cv_Name $xy 	Brake_Fork			$updateCommand					
				}
			lib_gui::cv_Custom02 {
						#
						# -- dimension summary
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent
						#
					createDimension							$cv_Name $xy 	point_seat
					createDimension							$cv_Name $xy 	point_center
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	RearWheel			
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontWheel			
					frame_visualisation::createDecoration	$cv_Name $xy 	SeatPost		
						#
					frame_visualisation::createFrame_Tubes	$cv_Name $xy					 
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	Saddle				
					frame_visualisation::createDecoration	$cv_Name $xy 	RearBrake			
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontBrake			
					frame_visualisation::createDecoration	$cv_Name $xy 	HeadSet			
					frame_visualisation::createDecoration	$cv_Name $xy 	Stem			
					frame_visualisation::createDecoration	$cv_Name $xy 	HandleBar 			
					frame_visualisation::createDecoration	$cv_Name $xy 	RearDerailleur		
					frame_visualisation::createDecoration	$cv_Name $xy 	CrankSet 			
						#
					createDimension							$cv_Name $xy 	cline_angle
						#
					createDimension							$cv_Name $xy	summary_bg		
						#
					createDimension							$cv_Name $xy	summary_fg	
						#
					frame_visualisation::createBaseline 	$cv_Name $xy	black
						#
				}				
			lib_gui::cv_Custom03 {
						#
						# -- frame - drafting 
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
						#
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 						
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 		
					frame_visualisation::createDecoration		$cv_Name $xy 	LegClearance_Rep	
						#
					createCenterline							$cv_Name $xy
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy 	frameDrafting_bg
						#
					createDraftingFrame							$cv_Name		$stageFormat	[expr 1/$stageScale]	$::APPL_Config(PROJECT_Name)  [frame_geometry_custom::project_attribute modified]
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
					$cv_Name 		centerContent				{-20  20}		{__Decoration__  __CenterLine__  __Dimension__  __Frame__  }
						#
					lib_gui::notebook_createButton				$cv_Name 		changeFormatScale
						#
				}
			lib_gui::cv_Custom04 {
						#
						# -- drafting - framejig
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
						#
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 						
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 		
						#
					createCenterline							$cv_Name $xy
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy	cline_framejig	
					createDimension								$cv_Name $xy 	frameJig_bg
						#
					createDraftingFrame							$cv_Name		$stageFormat	[expr 1/$stageScale]	$::APPL_Config(PROJECT_Name)  [frame_geometry_custom::project_attribute modified]
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
					$cv_Name 		centerContent				{ 10  25}		{__Frame__  __Decoration__  __CenterLine__  __Dimension__}
						#
					lib_gui::notebook_createButton				$cv_Name 		changeFormatScale
						#
				}
			lib_gui::cv_Custom05 {
						#
						# -- tubemitter
						#
						# set stageScale	1
					set stageScale	[eval $cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						#
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createTubemitter		$cv_Name { 80 190}	TopTube_Seat		
					frame_visualisation::createTubemitter		$cv_Name {200 190}	TopTube_Head	
					frame_visualisation::createTubemitter		$cv_Name { 80  90}	DownTube_Head	
					frame_visualisation::createTubemitter		$cv_Name {180  90}	SeatStay_01	
					frame_visualisation::createTubemitter		$cv_Name {250  90}	SeatStay_02	
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
				}
			lib_gui::cv_Custom06 {
						#
						# -- assembly
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent				
					frame_visualisation::createBaseline 	$cv_Name $xy	
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	RearWheel			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontWheel			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	SeatPost			
						#
					frame_visualisation::createFrame_Tubes	$cv_Name $xy 
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	Saddle				$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	RearBrake			$updateCommand
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontBrake			$updateCommand
					frame_visualisation::createDecoration	$cv_Name $xy 	HeadSet				
					frame_visualisation::createDecoration	$cv_Name $xy 	Stem				
					frame_visualisation::createDecoration	$cv_Name $xy 	HandleBar 			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	RearDerailleur		$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	CrankSet 			$updateCommand
						# 
				}
				
		}
		
		::update	; #for sure otherwise confuse location of canvasCad Stage

	}

	
	proc get_FormatFactor {stageFormat} {
			puts "  get_FormatFactor: $stageFormat"
			switch -regexp $stageFormat {
				^A[0-9] {	set factorInt	[expr 1.0 * [string index $stageFormat end] ]
							return			[expr pow(sqrt(2), $factorInt)]
						}
				default	{return 1.0}
			}
		}	


	
	proc createDimension {cv_Name BB_Position type {active {on}}} {
			
			## -- read from domProject
		set domProject $::APPL_Project

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
		
			# --- get Rendering Style
		set Rendering(Brakes)	[[ $domProject selectNodes /root/Rendering/Brakes ]  asText ]		

		
			# --- get defining Values ----------
		set RearRimDiameter		[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter	]  asText ]
		set RearTyreHeight		[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight	]  asText ]
		set FrontRimDiameter	[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter	]  asText ]
		set FrontTyreHeight		[ [ $domProject selectNodes /root/Component/Wheel/Front/TyreHeight	]  asText ]
		set ForkHeight			[ [ $domProject selectNodes /root/Component/Fork/Height				]  asText ]
		set ForkRake			[ [ $domProject selectNodes /root/Component/Fork/Rake				]  asText ]
		set StemLength			[ [ $domProject selectNodes /root/Component/Stem/Length				]  asText ]
		set StemAngle			[ [ $domProject selectNodes /root/Component/Stem/Angle				]  asText ]
		set CrankSetLength		[ [ $domProject selectNodes /root/Component/CrankSet/Length		   	]  asText ]
		set BottomBracket_Depth	[ [ $domProject selectNodes /root/Custom/BottomBracket/Depth			]  asText ]
		set OffsetPerp_SS		[ [ $domProject selectNodes /root/Component/RearDropOut/SeatStay/OffsetPerp	]  asText ]
		set OffsetPerp_CS		[ [ $domProject selectNodes /root/Component/RearDropOut/ChainStay/OffsetPerp	]  asText ]
		set OffsetPerp_DT		[ [ $domProject selectNodes /root/Custom/DownTube/OffsetBB			]  asText ]
			# --- get defining Point coords ----------
		set BottomBracket		$BB_Position	
		set RearWheel			[ frame_geometry_custom::point_position		RearWheel				$BB_Position ]
		set FrontWheel			[ frame_geometry_custom::point_position		FrontWheel				$BB_Position ]
		set Saddle				[ frame_geometry_custom::point_position 	Saddle					$BB_Position ]
		set SaddleProposal		[ frame_geometry_custom::point_position 	SaddleProposal			$BB_Position ]
		set SeatStay_SeatTube	[ frame_geometry_custom::tube_values		SeatStay SeatTube		$BB_Position ]
		set TopTube_SeatTube	[ frame_geometry_custom::tube_values		TopTube SeatTube		$BB_Position ]
		set TopTube_Steerer		[ frame_geometry_custom::tube_values		TopTube HeadTube		$BB_Position ]
		set HeadTube_Stem		[ frame_geometry_custom::tube_values		HeadTube Stem			$BB_Position ]
		set HeadTube_Fork		[ frame_geometry_custom::tube_values		HeadTube Fork			$BB_Position ]
		set Steerer_Stem		[ frame_geometry_custom::point_position		Steerer_Stem			$BB_Position ]
		set Steerer_Fork		[ frame_geometry_custom::point_position		Steerer_Fork			$BB_Position ]
		set DownTube_Steerer	[ frame_geometry_custom::tube_values		DownTube HeadTube 		$BB_Position ]
		set DownTube_BB			[ frame_geometry_custom::tube_values		DownTube BottomBracket 	$BB_Position ]
		set HandleBar			[ frame_geometry_custom::point_position  	HandleBar 				$BB_Position ]
		set LegClearance		[ frame_geometry_custom::point_position  	LegClearance 			$BB_Position ]
		set BaseCenter			[ frame_geometry_custom::point_position  	BB_Ground				$BB_Position ]	
		set Steerer_Ground		[ frame_geometry_custom::point_position  	Steerer_Ground			$BB_Position ]	
		set SeatTube_Ground		[ frame_geometry_custom::point_position  	SeatTube_Ground			$BB_Position ]	
		set SeatTube_TopTube	[ frame_geometry_custom::tube_values  	  	SeatTube TopTube		$BB_Position ]	
		set ChainSt_SeatSt_IS	[ frame_geometry_custom::point_position  	ChainSt_SeatSt_IS		$BB_Position ]	
		set RearBrakeMount		[ frame_geometry_custom::point_position  	RearBrakeMount			$BB_Position ]	
		set RearBrakeHelp		[ frame_geometry_custom::point_position  	RearBrakeHelp			$BB_Position ]	
		set RearBrakeShoe		[ frame_geometry_custom::point_position  	RearBrakeShoe			$BB_Position ]	
		set FrontBrakeMount		[ frame_geometry_custom::point_position  	FrontBrakeMount			$BB_Position ]	
		set FrontBrakeHelp		[ frame_geometry_custom::point_position  	FrontBrakeHelp			$BB_Position ]	
		set FrontBrakeShoe		[ frame_geometry_custom::point_position  	FrontBrakeShoe			$BB_Position ]	
		set FrameJig_HeadTube	[ frame_geometry_custom::point_position  	FrameJig_HeadTube		$BB_Position ]	
		set FrameJig_SeatTube	[ frame_geometry_custom::point_position  	FrameJig_SeatTube		$BB_Position ]	
			
		
			# --- help points for boot clearance -----
		set vect_90				[ vectormath::unifyVector	$BottomBracket $FrontWheel ]
		set help_91				[ vectormath::addVector		$BottomBracket 	[ vectormath::unifyVector {0 0} $vect_90 $CrankSetLength ] ]
		set help_92				[ vectormath::addVector		$FrontWheel 	[ vectormath::unifyVector {0 0} $vect_90 [ expr - ( 0.5 * $FrontRimDiameter + $FrontTyreHeight) ] ] ]
		set RearWheel_Ground	[ list [lindex $RearWheel  0] [lindex $Steerer_Ground 1] ]
		set FrontWheel_Ground	[ list [lindex $FrontWheel 0] [lindex $Steerer_Ground 1] ]

			# --- set values -------------------------
		set RearWheel_Radius	[ expr [lindex $RearWheel  1] - [lindex $BaseCenter 1] ]
		set FrontWheel_Radius	[ expr [lindex $FrontWheel 1] - [lindex $BaseCenter 1] ]
		set hb_seat_height		[ expr [lindex $Saddle 1] - [lindex $HandleBar 1] ]
		set ht_seat_height		[ expr [lindex $Saddle 1] - [lindex $HeadTube_Stem 1] ]

			# --- create dimension -------------------
		switch $type {
			point_center {
						$cv_Name create circle 	$BaseCenter		-radius 10  -outline gray50 	-width 1.0			-tags __CenterLine__	
					}
			point_personal {
						$cv_Name create circle 	$BottomBracket	-radius 20  -outline darkred 	-width 1.0			-tags __CenterLine__
						$cv_Name create circle 	$HandleBar		-radius 10  -outline darkred 	-width 1.0			-tags __CenterLine__
						$cv_Name create circle 	$Saddle			-radius 10  -outline darkred 	-width 1.0			-tags __CenterLine__
					}
			point_crank {
						$cv_Name create circle 	$help_91		-radius  6  -outline gray50 	-width 1.0			-tags __CenterLine__
					}
			point_seat {
						$cv_Name create circle 	$LegClearance	-radius  5  -outline darkred 	-width 1.0			-tags __CenterLine__		
						$cv_Name create circle 	$SaddleProposal	-radius 10  -outline gray 		-width 1.0			-tags __CenterLine__
					}
			point_frame {
						$cv_Name create circle 	$Steerer_Fork		-radius 10  -outline gray 	-width 1.0			-tags __CenterLine__
						$cv_Name create circle 	$HeadTube_Stem		-radius 10  -outline gray 	-width 1.0			-tags __CenterLine__
						$cv_Name create circle 	$SeatTube_TopTube	-radius 10  -outline gray 	-width 1.0			-tags __CenterLine__
					}
			cline_angle {
						$cv_Name create circle 	$HeadTube_Stem	-radius  5  -outline blue 		-width 1.0			-tags __CenterLine__		
						$cv_Name create circle 	$HandleBar		-radius  5  -outline darkblue	-width 1.0			-tags __CenterLine__		
						$cv_Name create circle 	$Saddle			-radius  5  -outline gray50		-width 1.0			-tags __CenterLine__					
						
						$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $Steerer_Stem $Steerer_Ground ] \
																			-fill gray50 		-width 0.25			-tags __CenterLine__	
						$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $Saddle $SeatTube_Ground ] \
																			-fill gray50 		-width 0.25			-tags __CenterLine__		
					}
			cline_brake {
						switch $Rendering(Brakes) {
								Road { 
									$cv_Name create circle 	$RearBrakeShoe		-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__
									$cv_Name create circle 	$RearBrakeMount		-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__	
									$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $RearBrakeShoe $RearBrakeHelp $RearBrakeMount] \
																						-fill gray50 		-width 0.25			-tags __CenterLine__			

									$cv_Name create circle 	$FrontBrakeShoe		-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__
									$cv_Name create circle 	$FrontBrakeMount	-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__	
									$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $FrontBrakeShoe $FrontBrakeHelp $FrontBrakeMount] \
																						-fill gray50 		-width 0.25			-tags __CenterLine__
									}
						}
					}
			cline_framejig {
							set help_fk			[ vectormath::intersectPoint   	$Steerer_Fork 	$Steerer_Stem   $FrontWheel $RearWheel ]
					
						$cv_Name create circle 	$FrameJig_HeadTube	-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__
						$cv_Name create circle 	$FrameJig_SeatTube	-radius  7  -outline gray50		-width 0.35		-tags __CenterLine__	
						$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $FrameJig_HeadTube $RearWheel] \
																			-fill gray50 		-width 0.25			-tags __CenterLine__		
						$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $RearWheel $help_fk] \
																			-fill gray50 		-width 0.25			-tags __CenterLine__		
					}
					
			__points_05 {
						$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $Saddle $SeatTube_TopTube ] \
																			-fill gray50 		-width 0.25			-tags __CenterLine__		
					}
					
			geometry_bg {
						set help_01				[ list [lindex $BottomBracket 0] [lindex $LegClearance 1] ]

						set _dim_ST_YPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $Saddle ] \
															vertical	[expr -580 * $stageScale]  [expr -130 * $stageScale]  \
															gray50 ] 
						set _dim_SD_Height		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BaseCenter  $Saddle ] \
															vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
															gray50 ] 
						set _dim_HB_Height		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar $BaseCenter ] \
															vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
															gray50 ] 
						set _dim_SD_HB_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar $Saddle ] \
															vertical	[expr  380 * $stageScale]  [expr -100 * $stageScale]  \
															gray50 ] 
						set _dim_SD_HB_Length	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $Saddle $HandleBar ] \
															horizontal	[expr  -150 * $stageScale]    0 \
															gray50 ] 
						

						set _dim_BB_Height 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket	$BaseCenter] \
															vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
															gray50 ]
						set _dim_CS_LengthX 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel_Ground  $BaseCenter ] \
															horizontal  [expr   70 * $stageScale]   0 \
															gray50 ] 
						set _dim_Wh_Distance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel_Ground  $FrontWheel_Ground ] \
															horizontal  [expr  130 * $stageScale]	0 \
															gray50 ] 
						set _dim_FW_Lag			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$FrontWheel_Ground  $Steerer_Ground ] \
															horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
															gray20 ] 
															
						set _dim_ST_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $SeatTube_TopTube ] \
															aligned		[expr -100 * $stageScale]   [expr   80 * $stageScale]  \
															gray50 ] 

						set _dim_BT_Clearance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $help_91  $help_92 ] \
															aligned		0   [expr -150 * $stageScale]  \
															gray50 ] 
															
						set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															horizontal  [expr   50 * $stageScale]    0 \
															gray50 ] 
						set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
															gray50 ] 
															
			}
				# -----------------------
			geometry_fg {

						set help_00			[ vectormath::addVector   $SeatTube_Ground {-200 0} ]
						set help_01			[ vectormath::rotatePoint $Steerer_Stem $Steerer_Fork  90 ]
						set help_02			[ vectormath::addVector   $Steerer_Stem [ vectormath::unifyVector $Steerer_Stem $help_01 [expr  50 * $stageScale] ] ]						
						set help_fk			[ vectormath::addVector   $Steerer_Fork [ vectormath::unifyVector $Steerer_Stem  $Steerer_Fork   $ForkHeight ] ]
						
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
									# set colour(result)			firebrick
									# set colour(result)			darkorange
									# set colour(result)			blue
						

																

							# --- result - level - dimensions
							#
						set _dim_ST_XPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $Saddle $BottomBracket ] \
															horizontal	[expr  -80 * $stageScale]    0 \
															$colour(result) ] 
						set _dim_FW_DistanceX	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BaseCenter  $FrontWheel ] \
															horizontal  [expr   70 * $stageScale]   0 \
															$colour(result) ] 
						set _dim_HT_Angle  		[ $cv_Name dimension  angle   	[ canvasCAD::flatten_nestedList  $Steerer_Ground  $Steerer_Fork  $BaseCenter ] \
															150   0  \
															$colour(result) ]


							# --- third - level - dimensions
							#
						set _dim_LC_Position_x	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $LegClearance  $BottomBracket ] \
															horizontal  [expr   80 * $stageScale]   0  \
															$colour(third) ] 
						set _dim_LC_Position_y	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $LegClearance  $BaseCenter ] \
															vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
															$colour(third) ] 
						set _dim_CR_Length 		[ $cv_Name dimension  radius    [ canvasCAD::flatten_nestedList  $BottomBracket  $help_91] \
															-20 		[expr  130 * $stageScale] \
															$colour(third) ] 


							# --- secondary - level - dimensions
							#
						set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket  $RearWheel ] \
															vertical    [expr  -260 * $stageScale]   [expr -90 * $stageScale]  \
															$colour(secondary) ] 
						set _dim_CS_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel  $BottomBracket] \
															aligned     [expr   100 * $stageScale]   0 \
															$colour(secondary) ] 
						set _dim_FW_Distance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket  $FrontWheel] \
															aligned     [expr   100 * $stageScale]   [expr  -30 * $stageScale] \
															$colour(secondary) ] 
						set _dim_RW_Radius 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel  $RearWheel_Ground ] \
															vertical    [expr   130 * $stageScale]    0 \
															$colour(secondary) ] 
						set _dim_FW_Radius 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $FrontWheel  $FrontWheel_Ground ] \
															vertical    [expr  -150 * $stageScale]    0 \
															$colour(secondary) ] 
						set _dim_Stem_Length	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar  $Steerer_Stem ] \
															aligned     [expr    80 * $stageScale]    0 \
															$colour(secondary) ] 
						set _dim_HT_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $Steerer_Fork  $HeadTube_Stem ] \
															aligned		[expr   100 * $stageScale]   0 \
															$colour(secondary) ] 
						
						if {$StemAngle > 0} {
							set _dim_Stem_Angle [ $cv_Name dimension  angle 	[ canvasCAD::flatten_nestedList  $Steerer_Stem  $help_02 $HandleBar ] \
															[expr $StemLength +  80]   0  \
															$colour(secondary) ]
						} else {
							set _dim_Stem_Angle [ $cv_Name dimension  angle 	[ canvasCAD::flatten_nestedList  $Steerer_Stem  $HandleBar  $help_02 ] \
															[expr $StemLength +  80]   0  \
															$colour(secondary) ]
						}
						
						set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$Steerer_Stem  $help_fk $FrontWheel ] \
															perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
															$colour(secondary) ] 																
						if {$ForkRake != 0} {
							set _dim_Fork_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$help_fk $FrontWheel $Steerer_Fork  ] \
															perpendicular [expr  (100 - $ForkRake) * $stageScale]    [expr  -10 * $stageScale] \
															$colour(secondary) ] 
						} else {
							set _dim_Fork_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$FrontWheel $Steerer_Fork  ] \
															aligned 	  [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
															$colour(secondary) ] 
						}

						

							# --- primary - level - dimensions
							#
						set _dim_HB_XPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar		$BottomBracket ] \
															horizontal  [expr   (80 + $hb_seat_height) * $stageScale ]    0 \
															$colour(primary) ] 
						set _dim_HB_YPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar		$BottomBracket ] \
															vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
															$colour(primary) ] 
						set _dim_ST_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $Saddle ] \
															aligned		[expr  100 * $stageScale]   [expr -210 * $stageScale]  \
															$colour(primary) ] 
						set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ canvasCAD::flatten_nestedList  $SeatTube_Ground	$Saddle $help_00 ] \
															150   0  \
															$colour(primary) ]
															
						

															

						if {$active == {on}} {
								$cv_Name bind $_dim_HB_XPosition	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Personal/HandleBar_Distance]
								$cv_Name bind $_dim_HB_YPosition	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Personal/HandleBar_Height]
								$cv_Name bind $_dim_ST_Length		<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Personal/SeatTube_Length]
								$cv_Name bind $_dim_HT_Length		<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  {FrameTubes/HeadTube/Length Component/HeadSet/Height/Bottom} {Head Tube Parameter}]
								$cv_Name bind $_dim_LC_Position_x	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Custom/TopTube/PivotPosition]
								$cv_Name bind $_dim_LC_Position_y	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Personal/InnerLeg_Length]
								$cv_Name bind $_dim_ST_Angle  		<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Personal/SeatTube_Angle]
								$cv_Name bind $_dim_BB_Depth   		<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Custom/BottomBracket/Depth]
								$cv_Name bind $_dim_CS_Length   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Custom/WheelPosition/Rear]
								$cv_Name bind $_dim_FW_Distance  	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Custom/WheelPosition/Front]
								$cv_Name bind $_dim_Stem_Length   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Component/Stem/Length]
								$cv_Name bind $_dim_Stem_Angle   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Component/Stem/Angle]		
								$cv_Name bind $_dim_Fork_Rake   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Component/Fork/Rake]
								$cv_Name bind $_dim_Fork_Height   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Component/Fork/Height]
								$cv_Name bind $_dim_RW_Radius   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  {list://Component/Wheel/Rear/RimDiameter@APPL_RimList Component/Wheel/Rear/TyreHeight} {Rear Wheel Parameter}]
								$cv_Name bind $_dim_FW_Radius   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  {list://Component/Wheel/Front/RimDiameter@APPL_RimList Component/Wheel/Front/TyreHeight} {Front Wheel Parameter}]
								$cv_Name bind $_dim_CR_Length   	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Component/CrankSet/Length]
								 
								 # $cv_Name bind $_dim_ST_XPosition	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  combinedValue://Saddle_OffsetX]
								$cv_Name bind $_dim_ST_XPosition	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Result/Saddle/Offset_BB/horizontal]
								$cv_Name bind $_dim_FW_DistanceX	<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Result/WheelPosition/front/horizontal]
								$cv_Name bind $_dim_HT_Angle		<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  [namespace current]::update  Result/HeadTube/Angle]
						}
			}
				# -----------------------
			frameTubing_bg {
					
							# -- Dimensions ------------------------
							#
						set _dim_ST_Length_01	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $SeatTube_TopTube ] \
															aligned  	[expr  115 * $stageScale]	0 \
															gray50 ]
						set _dim_ST_Length_02	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $TopTube_SeatTube ] \
															aligned  	[expr   75 * $stageScale]	[expr   50 * $stageScale] \
															gray50 ]
						set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															horizontal  [expr -110 * $stageScale]    0 \
															gray50 ] 
						set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
															gray50 ] 
					}
				# -----------------------
			summary_bg {
						
						set help_01				[ list [lindex $BottomBracket 0] [lindex $LegClearance 1] ]

						set _dim_ST_YPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $Saddle ] \
															vertical	[expr -580 * $stageScale]  [expr -130 * $stageScale]  \
															gray50 ] 
						set _dim_SD_Height		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BaseCenter  $Saddle ] \
															vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
															gray50 ] 
						set _dim_HB_Height		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar $BaseCenter ] \
															vertical    [expr -350 * $stageScale]  [expr  230 * $stageScale]  \
															gray50 ] 
						set _dim_SD_HB_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar $Saddle ] \
															vertical	[expr  350 * $stageScale]  [expr -100 * $stageScale]  \
															gray50 ] 
					}
				# -----------------------
			summary_fg {

						set help_00				[ vectormath::addVector $SeatTube_Ground {-200 0} ]
						set help_rw				[ vectormath::rotateLine $RearWheel 	$RearWheel_Radius 	230 ]
						set help_fw				[ vectormath::rotateLine $FrontWheel 	$FrontWheel_Radius 	-50 ]
						set help_fk				[ vectormath::addVector   $Steerer_Fork [ vectormath::unifyVector $Steerer_Stem  $Steerer_Fork   $ForkHeight ] ]

						
						set _dim_ST_XPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $Saddle $BottomBracket ] \
															horizontal	[expr  -80 * $stageScale]    0 \
															darkblue ] 
						set _dim_ST_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $Saddle ] \
															aligned		[expr  100 * $stageScale]   [expr -210 * $stageScale]  \
															darkblue ] 
						set _dim_BB_Height 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket	$BaseCenter] \
															vertical    [expr  200 * $stageScale]   [expr    30 * $stageScale]  \
															darkred ] 

						set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel $BottomBracket ] \
																				vertical    [expr 100 * $stageScale]   [expr 80 * $stageScale] \
																				gray50 ] 
						set _dim_RW_Radius 		[ $cv_Name dimension  radius   [ canvasCAD::flatten_nestedList  $RearWheel  $help_rw] \
																				0 	[expr  30 * $stageScale] \
																				gray50 ]
						set _dim_FW_Radius 		[ $cv_Name dimension  radius   [ canvasCAD::flatten_nestedList  $FrontWheel $help_fw] \
																				0 	[expr  30 * $stageScale] \
																				gray50 ]
						set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$Steerer_Stem  $help_fk $FrontWheel ] \
																				perpendicular [expr 30 * $stageScale]    [expr   80 * $stageScale] \
																				gray50 ] 																
						set _dim_CS_LengthX 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel_Ground  $BaseCenter ] \
																				horizontal  [expr   70 * $stageScale]   0 \
																				gray50 ] 
						set _dim_FW_DistanceX	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BaseCenter  $FrontWheel_Ground ] \
																				horizontal  [expr   70 * $stageScale]   0 \
																				gray50 ] 
						set _dim_Wh_Distance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel_Ground  $FrontWheel_Ground ] \
																				horizontal  [expr  130 * $stageScale]	0 \
																				gray50 ] 
						set _dim_FW_Lag			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$FrontWheel_Ground  $Steerer_Ground ] \
																				horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
																				gray50 ] 
						set _dim_FW_Distance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $FrontWheel] \
																				aligned     [expr  150 * $stageScale]   [expr  -90 * $stageScale] \
																				gray50 ] 
						set _dim_CS_Length 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $BottomBracket] \
															aligned     [expr  150 * $stageScale]   [expr   80 * $stageScale] \
															gray50 ] 
						
						set _dim_HT_Angle  		[ $cv_Name dimension  angle   	[ canvasCAD::flatten_nestedList  	$Steerer_Ground  $Steerer_Fork  $BaseCenter ] \
															120   0  \
															darkred ]
						set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ canvasCAD::flatten_nestedList  $SeatTube_Ground	$Saddle $help_00 ] \
															120   0  \
															darkred ]

						set _dim_HB_XPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar		$BottomBracket ] \
															horizontal  [expr   (80 + $hb_seat_height) * $stageScale ]    0 \
															darkred ] 
						set _dim_HB_YPosition	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $HandleBar		$BottomBracket ] \
															vertical    [expr -270 * $stageScale]    [expr  180 * $stageScale]  \
															darkred ] 
						set _dim_HT_Reach		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															horizontal  [expr   (20 + $ht_seat_height) * $stageScale ]    0 \
															darkblue ] 
						set _dim_HT_Stack		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem	$BottomBracket ] \
															vertical    [expr -280 * $stageScale]    [expr  170 * $stageScale]  \
															darkblue ] 
						set _dim_LC_Position_x	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $LegClearance  $BottomBracket ] \
															horizontal  [expr   40 * $stageScale]   0  \
															darkblue ] 
						set _dim_LC_Position_y	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $LegClearance  $BaseCenter ] \
															vertical    [expr -130 * $stageScale]   [expr   160 * $stageScale]  \
															darkblue ] 

						proc dim_LegClearance {cv_Name BB_Position stageScale} {
									set pt_01 					[ frame_geometry_custom::point_position 	LegClearance	$BB_Position  ]
									set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon		$BB_Position  ]
									set pt_09					[ frame_geometry_custom::coords_get_xy $TopTube(polygon)  9 ]
									set pt_10					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 10 ]
									set pt_is					[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
									set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_is] ] \
																aligned    [expr -60 * $stageScale]  [expr 50 * $stageScale] \
																darkred ]																				
								}
						dim_LegClearance  $cv_Name $BottomBracket $stageScale

						proc dim_RearWheel_Clearance {cv_Name BB_Position WheelRadius stageScale} {
									set pt_03 					[ frame_geometry_custom::point_position 	RearWheel	$BB_Position  ]
									set SeatTube(polygon) 		[ frame_geometry_custom::tube_values SeatTube polygon	$BB_Position  ]
									set pt_06					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 6 ]
									set pt_07					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 7 ]						
									set pt_is					[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
									set pt_rw					[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
									set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_rw $pt_is] ] \
																							aligned    [expr -50 * $stageScale]  [expr -75 * $stageScale] \
																							gray50 ]																				
								}
						dim_RearWheel_Clearance  $cv_Name $BottomBracket $RearWheel_Radius $stageScale						

					}
				# -----------------------
			frameDrafting_bg {
						
							set help_fk				[ vectormath::addVector   	$Steerer_Fork 	[ vectormath::unifyVector $Steerer_Stem  $Steerer_Fork   $ForkHeight ] ]
							set help_rw_rim			[ vectormath::rotateLine 	$RearWheel 		[expr 0.5 * $RearRimDiameter ] 70 ]
							set help_tt_c1			[ vectormath::rotateLine 	$RearWheel 		[expr 0.5 * $RearRimDiameter ] 70 ]
					
							# -- Dimensions ------------------------
							#
						set _dim_CS_Length 			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $BottomBracket] \
																					aligned     [expr   70 * $stageScale]   [expr   80 * $stageScale] \
																					darkblue ] 
						set _dim_CS_LengthX 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList		$BottomBracket  $RearWheel ] \
																					horizontal  [expr -110 * $stageScale]   0 \
																					gray30 ] 
						set _dim_BB_Depth 			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $BottomBracket] \
																					vertical	[expr  -160 * $stageScale]   [expr   80 * $stageScale] \
																					gray30 ] 
						set _dim_FW_Distance		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $FrontWheel] \
																					aligned     [expr   70 * $stageScale]   [expr  -90 * $stageScale] \
																					gray30 ] 
						set _dim_FW_DistanceX		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $FrontWheel ] \
																					horizontal  [expr  110 * $stageScale]   0 \
																					gray30 ] 
						set _dim_Wh_Distance		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $FrontWheel ] \
																					horizontal  [expr  (150 + $BottomBracket_Depth) * $stageScale]	0 \
																					gray30 ]
						set _dim_ST_Length_01		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $SeatTube_TopTube ] \
																					aligned  	[expr  -140 * $stageScale]	0 \
																					darkblue ]
						set _dim_ST_Length_02		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $TopTube_SeatTube ] \
																					aligned  	[expr  -100 * $stageScale]	0 \
																					gray30 ]
						set _dim_TT_Length			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$TopTube_SeatTube $TopTube_Steerer ] \
																					aligned  	[expr  -180 * $stageScale]	0 \
																					darkblue ]
						set _dim_DT_Length			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $DownTube_Steerer ] \
																					aligned  	[expr   120 * $stageScale]	0 \
																					darkblue ]
						set _dim_SS_Length			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $SeatStay_SeatTube ] \
																					aligned  	[expr  -160 * $stageScale]	0 \
																					darkblue ]
						set _dim_SS_ST_Offset		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$SeatTube_TopTube  $SeatStay_SeatTube ] \
																					aligned  	[expr    60 * $stageScale]	[expr   65 * $stageScale] \
																					darkblue ]
						if { $OffsetPerp_SS != 0 } {
								set _dim_SS_DO_Offset	\
													[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$SeatStay_SeatTube $ChainSt_SeatSt_IS $RearWheel] \
																					perpendicular [expr -75 * $stageScale]	[expr  -35 * $stageScale] \
																					gray30 ]
							}
						if { $OffsetPerp_CS != 0 } {
								set _dim_CS_DO_Offset	\
													[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket $ChainSt_SeatSt_IS $RearWheel] \
																					perpendicular [expr -95 * $stageScale]	[expr   35 * $stageScale] \
																					gray30 ]
							}
						set _dim_DT_Offset			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Fork  $DownTube_Steerer ] \
																					aligned  	[expr    70 * $stageScale]	[expr    0 * $stageScale] \
																					darkblue ]
						set _dim_TT_Offset			[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$TopTube_Steerer  $HeadTube_Stem ] \
																					aligned  	[expr    70 * $stageScale]	[expr  -35 * $stageScale] \
																					darkblue ]
																					
							# -- HT Stack & Reach ------------------
							#
						set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem  $BottomBracket ] \
																					horizontal  [expr  -90 * $stageScale ]    0 \
																					gray50 ] 
						set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$HeadTube_Stem		$BottomBracket ] \
																					vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
																					gray50 ] 

							# -- Fork Details ----------------------
							#
						if {$ForkRake != 0} {
							set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$Steerer_Stem  $help_fk $FrontWheel ] \
																					perpendicular [expr  50 * $stageScale]    [expr  -80 * $stageScale] \
																					gray30 ] 																
							set _dim_Fork_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$help_fk $FrontWheel $Steerer_Fork  ] \
																					perpendicular [expr  (150 - $ForkRake) * $stageScale]    [expr  -80 * $stageScale] \
																					gray30 ] 
						} else {
							set _dim_Fork_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$FrontWheel $Steerer_Fork  ] \
																					aligned 	[expr  150  * $stageScale]    [expr  -80 * $stageScale] \
																					gray30 ] 
						}
						
							# -- Centerline Angles -----------------
							#
						set _dim_Head_Top_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $TopTube_Steerer $Steerer_Stem $TopTube_SeatTube] ] \
																					130   0 \
																					darkred ]
						set _dim_Head_Down_Angle	[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $DownTube_Steerer $DownTube_BB $Steerer_Ground] ] \
																					170 -10 \
																					darkred ]
						set _dim_Seat_Top_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $TopTube_SeatTube $BottomBracket $TopTube_Steerer] ] \
																					150   0 \
																					darkred ]
						set _dim_Down_Seat_Angle	[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $BottomBracket $DownTube_Steerer $TopTube_SeatTube ] ] \
																					 90   0 \
																					darkred ]
						set _dim_Seat_CS_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $BottomBracket $TopTube_SeatTube $ChainSt_SeatSt_IS] ] \
																					 90   0 \
																					darkred ]
						set _dim_SS_CS_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $ChainSt_SeatSt_IS $BottomBracket $SeatStay_SeatTube] ] \
																					 90   0 \
																					darkred ]
							set pt_01				[ vectormath::addVector	$BottomBracket {-1 0} ]
						set _dim_SeatTube_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $BottomBracket $SeatTube_TopTube $pt_01] ] \
																					130   0 \
																					darkred ]
							set pt_01				[ vectormath::intersectPoint	$Steerer_Stem  $Steerer_Fork		$FrontWheel [vectormath::addVector	$FrontWheel {-10 0}] ]
							set pt_02				[ vectormath::addVector	$pt_01 {-1 0} ]
						set _dim_HeadTube_Angle		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $pt_02 $Steerer_Stem [vectormath::addVector	$pt_02 {-10 0}]] ] \
																					 90   0 \
																					darkred ]
																				
							# -- Rear Brake Mount ------------------
						switch $Rendering(Brakes) {
								Road {	
											set SeatStay(polygon) 		[ frame_geometry_custom::tube_values 		SeatStay polygon $BB_Position  ]
											set pt_01					[ frame_geometry_custom::coords_get_xy 	$SeatStay(polygon)  8 ]
											set pt_02					[ frame_geometry_custom::coords_get_xy 	$SeatStay(polygon)  9 ]
											set pt_03 					[ frame_geometry_custom::point_position 	RearBrakeShoe	$BB_Position  ]
											set pt_04 					[ frame_geometry_custom::point_position 	RearBrakeHelp	$BB_Position  ]
											set pt_10 					[ vectormath::intersectPerp 		$pt_01 $pt_02 $pt_04  ]
										set _dim_Brake_Offset_01	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$pt_10 $pt_04 ] \
																									aligned  	[expr   40 * $stageScale]	[expr  55 * $stageScale] \
																									gray30 ]
										set _dim_Brake_Offset_02	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$pt_03  $pt_04 ] \
																									aligned  	[expr   -50 * $stageScale]	[expr   65 * $stageScale] \
																									gray30 ]
										set _dim_Brake_Distance		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$RearWheel  $RearBrakeMount ] \
																									aligned  	[expr  -120 * $stageScale]	0 \
																									gray30 ]						
										set _dim_RW_RimRadius 		[ $cv_Name dimension  radius	[ canvasCAD::flatten_nestedList  $RearWheel	$help_rw_rim] \
																									0	[expr   30 * $stageScale] \
																									gray30 ] 
									}
						}

							# -- Cutting Length --------------------
							#
							set TopTube(polygon) 	[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $TopTube(polygon)  8 ]
							set pt_02				[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 11 ]
							set pt_03				[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 3 ]
						set _dim_TopTube_CutLength 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr 110 * $stageScale] [expr 10 * $stageScale] \
																					darkviolet ]
							set DownTube(polygon) 	[ frame_geometry_custom::tube_values DownTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $DownTube(polygon)  3 ]
						set _dim_TopTube_CutLength 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $BB_Position $pt_01] ] \
																					aligned    [expr  70 * $stageScale] [expr 10 * $stageScale] \
																					darkviolet ]
							
							
							
							# -- Tubing Details --------------------
							#
							set HeadTube(polygon) 	[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 0 ]
							set pt_02				[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 1 ]
						set _dim_HeadTube_Length 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr 90 * $stageScale]   0 \
																					darkblue ]																				

							set HeadTube(polygon) 	[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 2 ]
							set TopTube(polygon) 	[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
							set pt_02				[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 8 ]
						set _dim_HeadTube_OffsetTT 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr 50 * $stageScale] [expr 50 * $stageScale] \
																					gray30 ]

							set HeadTube(polygon) 	[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 3 ]
							set DownTube(polygon) 	[ frame_geometry_custom::tube_values DownTube polygon $BB_Position  ]
							set pt_02				[ frame_geometry_custom::coords_get_xy $DownTube(polygon) 3 ]
						set _dim_HeadTube_OffsetDT 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr -50 * $stageScale] [expr 50 * $stageScale] \
																					gray30 ]

							set TopTube(polygon) 	[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
							set pt_01				[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 11 ]
							set SeatTube(polygon) 	[ frame_geometry_custom::tube_values SeatTube polygon $BB_Position  ]
							set pt_02				[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 3 ]
						set _dim_SeatTube_Extension [ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr 65 * $stageScale] [expr -50 * $stageScale] \
																					gray30 ]

							set pt_01 				[ frame_geometry_custom::tube_values TopTube  SeatTube $BB_Position  ]
							set pt_02 				[ frame_geometry_custom::tube_values SeatStay SeatTube $BB_Position  ]
							if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
									set dim_coords	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ]
							} else {
									set dim_coords	[ canvasCAD::flatten_nestedList [list $pt_02 $pt_01] ]
							}
						set _dim_SeatStay_Offset 	[ $cv_Name dimension  length  	$dim_coords  \
																					aligned    [expr -60 * $stageScale]   [expr -50 * $stageScale] \
																					gray30 ]	
																					
						if { $OffsetPerp_DT != 0 } {
								set pt_01 				[ frame_geometry_custom::tube_values	DownTube HeadTube 		$BB_Position  ]
								set pt_02 				[ frame_geometry_custom::tube_values	DownTube BottomBracket 	$BB_Position  ]
								set pt_03 					$BB_Position 
								if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
										set dim_distance	[expr -50 * $stageScale]
										set dim_offset		[expr -50 * $stageScale]
								} else {
										set dim_distance	[expr  50 * $stageScale]
										set dim_offset		[expr  50 * $stageScale]
								}
							set _dim_DownTube_Offset 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02 $pt_03] ] \
																						{perpendicular}    $dim_distance $dim_offset \
																						gray30 ]
						}
																				
							set pt_01 				[ frame_geometry_custom::tube_values 		TopTube HeadTube $BB_Position  ]
							set pt_hlp 				[ frame_geometry_custom::tube_values 		TopTube SeatTube $BB_Position  ]
							set pt_cnt 				[ vectormath::center 	$pt_01  $pt_hlp]
							set pt_02 				[ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]
						set _dim_TopTube_Angle 		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
																					100   -30 \
																					darkred ]
																				
							set pt_01 				[ frame_geometry_custom::tube_values 		HeadTube Fork	$BB_Position  ]
							set pt_02 				[ frame_geometry_custom::point_position 	Steerer_Fork	$BB_Position  ]
						set _dim_HeadSet_Bottom 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																					aligned    [expr -150 * $stageScale]   [expr 50 * $stageScale] \
																					gray30 ]	
																				
							set RimDiameter			[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter ]  asText ]
							set TyreHeight			[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight  ]  asText ]
							set WheelRadius			[ expr 0.5 * $RimDiameter + $TyreHeight ]
							set pt_03 				[ frame_geometry_custom::point_position 	RearWheel	$BB_Position  ]
							set SeatTube(polygon) 	[ frame_geometry_custom::tube_values SeatTube polygon	$BB_Position  ]
							set pt_06				[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 6 ]
							set pt_07				[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 7 ]						
							set pt_is				[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
							set pt_rw				[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
						set _dim_RearWheel_Clear 	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_rw $pt_is] ] \
																					aligned    0  [expr 50 * $stageScale] \
																					gray50 ]	
																				

							set pt_01 				[ frame_geometry_custom::point_position 	LegClearance	$BB_Position  ]
							set TopTube(polygon) 	[ frame_geometry_custom::tube_values TopTube polygon		$BB_Position  ]
							set pt_09				[ frame_geometry_custom::coords_get_xy $TopTube(polygon)  9 ]
							set pt_10				[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 10 ]
							set pt_is				[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
						set _dim_LegClearance 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_is] ] \
																					aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
																					gray50 ]																				
					
					
					}
				# -----------------------
			frameJig_bg {
						
							set help_fk			[ vectormath::intersectPoint   	$Steerer_Fork 	$Steerer_Stem   $FrontWheel $RearWheel ]
					
							# -- Dimensions ------------------------
							#
						set _dim_Jig_length		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel  $FrameJig_HeadTube] \
																					aligned     [expr  -110 * $stageScale]   0 \
																					darkblue ] 
						set _dim_CS_LengthJig	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel  $FrameJig_SeatTube] \
																					aligned     [expr   -60 * $stageScale]   0 \
																					darkblue ] 
						set _dim_CS_Length		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel  $BottomBracket] \
																					aligned     [expr    80 * $stageScale]   0 \
																					gray30 ] 
						set _dim_CS_LengthHor	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket $RearWheel  ] \
																					horizontal  [expr  -100 * $stageScale]   0 \
																					gray30 ] 
						set _dim_BB_DepthJIg	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket  $FrameJig_SeatTube] \
																					aligned     [expr    60 * $stageScale]   0 \
																					darkblue ] 
						set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$BottomBracket  $RearWheel ] \
																					vertical    [expr -160 * $stageScale]   [expr -70 * $stageScale]  \
																					gray30 ] 
						set _dim_HT_Offset 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $FrameJig_HeadTube	$HeadTube_Fork] \
																					aligned     [expr   100 * $stageScale]   0 \
																					darkblue ] 
						set _dim_HT_Dist_x 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket	$HeadTube_Fork] \
																					horizontal  [expr   100 * $stageScale]   0 \
																					gray30 ] 
						set _dim_HT_Dist_y 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $BottomBracket	$HeadTube_Fork] \
																					vertical    [expr   320 * $stageScale]   0 \
																					gray30 ] 
						set _dim_WH_Distance	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $RearWheel	$help_fk] \
																					aligned     [expr   220 * $stageScale]   0 \
																					gray30 ] 
						set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ canvasCAD::flatten_nestedList  $FrameJig_SeatTube	$FrameJig_HeadTube $Saddle ] \
															 90   0  \
															darkred ]
							# -- Fork Details ----------------------
							#
						set _dim_HT_Fork		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  $FrameJig_HeadTube	$help_fk] \
																					aligned     [expr  -100 * $stageScale]   0 \
																					darkblue ] 
						set _dim_Fork_Height	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$help_fk $HeadTube_Fork  ] \
																					aligned 	[expr   150 * $stageScale]   0 \
																					gray30 ] 
					}
				# -----------------------
			default {
					}
		}
	
	}

	
	proc createDimensionType {cv_Name BB_Position type {updateCommand {}}} {
			
			## -- read from domProject
		set domProject $::APPL_Project

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
		
			# --- get Rendering Style
		set Rendering(Brakes)	[[ $domProject selectNodes /root/Rendering/Brakes ]  asText ]		

		
		switch $type {
			HeadTube_Length {
						set HeadTube(polygon) 		[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
						set pt_01					[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 0 ]
						set pt_02					[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 1 ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr 50 * $stageScale]   0 \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1> \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand  {	FrameTubes/HeadTube/Length		\
																						}	{HeadTube Length}]
								}
						}
			HeadTube_OffsetTT {
						set HeadTube(polygon) 		[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
						set pt_01					[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 2 ]
						set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
						set pt_02					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 8 ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr 70 * $stageScale] [expr 50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/TopTube/OffsetHT		\
																						}	{HeadTube TopTube Offset}]
								}						
						}
			HeadTube_OffsetDT {
						set HeadTube(polygon) 		[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
						set pt_01					[ frame_geometry_custom::coords_get_xy $HeadTube(polygon) 3 ]
						set DownTube(polygon) 		[ frame_geometry_custom::tube_values DownTube polygon $BB_Position  ]
						set pt_02					[ frame_geometry_custom::coords_get_xy $DownTube(polygon) 3 ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr -70 * $stageScale] [expr 50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/DownTube/OffsetHT \
																						}	{HeadTube DownTube Offset}]
								}						
						}
			SeatTube_Extension {
						set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
						set pt_01					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 11 ]
						set SeatTube(polygon) 		[ frame_geometry_custom::tube_values SeatTube polygon $BB_Position  ]
						set pt_02					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 3 ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr 50 * $stageScale] [expr -50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/SeatTube/Extension \
																						}	{SeatTube Extension}]
								}
						}
			SeatStay_Offset {
						set pt_01 					[ frame_geometry_custom::tube_values TopTube  SeatTube $BB_Position  ]
						set pt_02 					[ frame_geometry_custom::tube_values SeatStay SeatTube $BB_Position  ]
						if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
								set dim_coords	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ]
						} else {
								set dim_coords	[ canvasCAD::flatten_nestedList [list $pt_02 $pt_01] ]
						}
						set dimension 		[ $cv_Name dimension  length  	$dim_coords  \
																				aligned    [expr 70 * $stageScale]   [expr 50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/SeatStay/OffsetTT \
																						}	{SeatStay Offset TopTube}]
								}
						}
			DownTube_Offset {
						set pt_01 					[ frame_geometry_custom::tube_values	DownTube HeadTube 		$BB_Position  ]
						set pt_02 					[ frame_geometry_custom::tube_values	DownTube BottomBracket 	$BB_Position  ]
						set pt_03 					$BB_Position 
						if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
								set dim_distance	[expr  70 * $stageScale]
								set dim_offset		[expr -50 * $stageScale]
						} else {
								set dim_distance	[expr -70 * $stageScale]
								set dim_offset		[expr  50 * $stageScale]
						}
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02 $pt_03] ] \
																				{perpendicular}    $dim_distance $dim_offset \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/DownTube/OffsetBB \
																						}	{DownTube Offset BottomBracket}]
								}
						}
			TopTube_Angle {
						set pt_01 					[ frame_geometry_custom::tube_values 		TopTube HeadTube $BB_Position  ]
						set pt_hlp 					[ frame_geometry_custom::tube_values 		TopTube SeatTube $BB_Position  ]
						set pt_cnt 					[ vectormath::center 	$pt_01  $pt_hlp]
						set pt_02 					[ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]
						set dimension 		[ $cv_Name dimension  angle  	[ canvasCAD::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
																				100   -30 \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Custom/TopTube/Angle \
																						}	{TopTube Angle}]
								}
					}
			ForkHeight {
						set Steerer_Stem			[ frame_geometry_custom::point_position Steerer_Stem	$BB_Position  ]
						set Steerer_Fork			[ frame_geometry_custom::point_position Steerer_Fork	$BB_Position  ]
						set FrontWheel				[ frame_geometry_custom::point_position FrontWheel		$BB_Position  ]
						set ForkRake				[ [ $domProject selectNodes /root/Component/Fork/Rake			]  asText ]
						set ForkHeight				[ [ $domProject selectNodes /root/Component/Fork/Height			]  asText ]
						set help_fk					[ vectormath::addVector   	$Steerer_Fork 	[ vectormath::unifyVector $Steerer_Stem  $Steerer_Fork   $ForkHeight ] ]
						if {$ForkRake != 0} {
							set dimension	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$help_fk $FrontWheel $Steerer_Fork  ] \
																				perpendicular [expr  (110 - $ForkRake) * $stageScale]    [expr  -80 * $stageScale] \
																				darkblue ] 
						} else {
							set dimension	[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$FrontWheel $Steerer_Fork  ] \
																				aligned 	[expr  110  * $stageScale]    [expr  -80 * $stageScale] \
																				darkblue ] 
						}
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Component/Fork/Height \
																						}	{Fork Height}]
								}
					}
			HeadSet_Bottom {
						set pt_01 					[ frame_geometry_custom::tube_values 		HeadTube Fork	$BB_Position  ]
						set pt_02 					[ frame_geometry_custom::point_position 	Steerer_Fork	$BB_Position  ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr -110 * $stageScale]   [expr 50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																		[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																		$updateCommand 	{	Component/HeadSet/Height/Bottom \
																						}	{HeadSet Bottom Height}]
								}
					}
			Brake_Bridge {
						switch $Rendering(Brakes) {
								Road { 
											set SeatStay(polygon) 		[ frame_geometry_custom::tube_values 		SeatStay polygon $BB_Position  ]
											set pt_01					[ frame_geometry_custom::coords_get_xy 	$SeatStay(polygon)  8 ]
											set pt_02					[ frame_geometry_custom::coords_get_xy 	$SeatStay(polygon)  9 ]
											set pt_03 					[ frame_geometry_custom::point_position 	RearBrakeShoe	$BB_Position  ]
											set pt_04 					[ frame_geometry_custom::point_position 	RearBrakeHelp	$BB_Position  ]
											set pt_10 					[ vectormath::intersectPerp 		$pt_01 $pt_02 $pt_04  ]
											# $cv_Name create circle  $pt_01 	-radius 20  -outline red
											# $cv_Name create circle  $pt_02 	-radius 20  -outline blue
										set dimension		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$pt_10  $pt_04] \
																								aligned  	[expr    40 * $stageScale]	[expr -40 * $stageScale] \
																								gray50 ]
										set dimension		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$pt_03  $pt_04 ] \
																								aligned  	[expr   -50 * $stageScale]	0 \
																								darkblue ]
										if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																						[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																						$updateCommand 	{	Component/Brake/Rear/LeverLength \
																										}	{Rear Brake LeverLength}]
												}
									}
						}
					}
			Brake_Fork {
						switch $Rendering(Brakes) {
								Road { 
											set pt_03 					[ frame_geometry_custom::point_position 	FrontBrakeShoe	$BB_Position  ]
											set pt_04 					[ frame_geometry_custom::point_position 	FrontBrakeHelp	$BB_Position  ]
											# $cv_Name create circle  $pt_01 	-radius 20  -outline red
											# $cv_Name create circle  $pt_02 	-radius 20  -outline blue
										set dimension		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList  	$pt_03  $pt_04 ] \
																								aligned  	[expr   20 * $stageScale]	[expr  50 * $stageScale] \
																								darkblue ]
										if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
																						[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																						$updateCommand 	{	Component/Brake/Front/LeverLength \
																										}	{Front Brake LeverLength}]
												}
									}
						}
					}
			RearWheel_Clearance {
						set RimDiameter				[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter ]  asText ]
						set TyreHeight				[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight  ]  asText ]
						set WheelRadius				[ expr 0.5 * $RimDiameter + $TyreHeight ]
						set pt_03 					[ frame_geometry_custom::point_position 	RearWheel	$BB_Position  ]
						set SeatTube(polygon) 		[ frame_geometry_custom::tube_values SeatTube polygon	$BB_Position  ]
						set pt_06					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 6 ]
						set pt_07					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 7 ]						
						set pt_is					[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
						set pt_rw					[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_rw $pt_is] ] \
																				aligned    0  [expr 50 * $stageScale] \
																				gray50 ]																				
							#set dimension 		[ $cv_Name dimension  radius  	[ canvasCAD::flatten_nestedList [list $pt_03 $pt_rw ] ] \
							#														[expr -50 * $stageScale]  [expr 50 * $stageScale] \
							#														gray60 ]																				
					}
			LegClearance {
						set pt_01 					[ frame_geometry_custom::point_position 	LegClearance	$BB_Position  ]
						set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon		$BB_Position  ]
						set pt_09					[ frame_geometry_custom::coords_get_xy $TopTube(polygon)  9 ]
						set pt_10					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 10 ]
						set pt_is					[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_is] ] \
																				aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
																				gray50 ]																				
					}

			check_this {
						set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
						set pt_01					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 11 ]
						set pt_01a					[ frame_geometry_custom::coords_get_xy $TopTube(polygon) 11 ]
						set SeatTube(polygon) 		[ frame_geometry_custom::tube_values SeatTube polygon $BB_Position  ]
						set pt_02					[ frame_geometry_custom::coords_get_xy $SeatTube(polygon) 3 ]
						$cv_Name create circle  $pt_01 	-radius 20  -outline red
						$cv_Name create circle  $pt_02 	-radius 20  -outline blue
						set dimension 		[ $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
																				aligned    [expr 50 * $stageScale]   [expr 50 * $stageScale] \
																				darkblue ]																				
						if {$updateCommand != {}} {		$cv_Name bind 				$dimension  \
											<Double-ButtonPress-1>  [list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
											$updateCommand {	Custom/SeatStay/OffsetTT		\
																		}	{SeatStay OffsetTopTube}]
								}
					}
			default {}
		}
		
	}

	
	proc createCenterline {cv_Name BB_Position {extend_Saddle {}}} {
			
			## -- read from domProject
		set domProject $::APPL_Project

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	

			# --- get defining Point coords ----------
		set BottomBracket		$BB_Position	
		set RearWheel			[ frame_geometry_custom::point_position  RearWheel				$BB_Position ]
		set FrontWheel			[ frame_geometry_custom::point_position  FrontWheel				$BB_Position ]
		set Saddle				[ frame_geometry_custom::point_position  Saddle					$BB_Position ]
		set SeatStay_SeatTube	[ frame_geometry_custom::tube_values     SeatStay SeatTube		$BB_Position ]
		set SeatTube_TopTube	[ frame_geometry_custom::tube_values  	 SeatTube TopTube		$BB_Position ]	
		set SeatStay_RearWheel	[ frame_geometry_custom::tube_values     SeatStay RearWheel		$BB_Position ]
		set ChainStay_RearWheel	[ frame_geometry_custom::tube_values     ChainStay RearWheel	$BB_Position ]
		set TopTube_SeatTube	[ frame_geometry_custom::tube_values     TopTube SeatTube		$BB_Position ]
		set TopTube_Steerer		[ frame_geometry_custom::tube_values  	 TopTube HeadTube		$BB_Position ]
		set Steerer_Stem		[ frame_geometry_custom::point_position  Steerer_Stem			$BB_Position ]
		set Steerer_Fork		[ frame_geometry_custom::point_position  Steerer_Fork			$BB_Position ]
		set DownTube_Steerer	[ frame_geometry_custom::tube_values  	 DownTube HeadTube 		$BB_Position ]
		set DownTube_BB			[ frame_geometry_custom::tube_values  	 DownTube BottomBracket $BB_Position ]
		set HandleBar			[ frame_geometry_custom::point_position	 HandleBar 				$BB_Position ]
		set LegClearance		[ frame_geometry_custom::point_position  LegClearance 			$BB_Position ]
		set BaseCenter			[ frame_geometry_custom::point_position  BB_Ground				$BB_Position ]	
		set Steerer_Ground		[ frame_geometry_custom::point_position  Steerer_Ground			$BB_Position ]
		set ChainSt_SeatSt_IS	[ frame_geometry_custom::point_position  ChainSt_SeatSt_IS		$BB_Position ]	
		
		set help_01				[ vectormath::intersectPerp		  $Steerer_Stem $Steerer_Fork $FrontWheel ] 

		
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $Steerer_Stem   	$HandleBar 			] -fill gray60 -tags __CenterLine__
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $Steerer_Stem   	$help_01 			] -fill gray60 -tags __CenterLine__ 
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $FrontWheel		   	$help_01 			] -fill gray60 -tags __CenterLine__ 
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $DownTube_BB  		$DownTube_Steerer 	] -fill gray60 -tags __CenterLine__ 
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $TopTube_SeatTube	$TopTube_Steerer 	] -fill gray60 -tags __CenterLine__ 
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $SeatStay_SeatTube	$ChainSt_SeatSt_IS  ] -fill gray60 -tags __CenterLine__ 
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $ChainSt_SeatSt_IS	$BottomBracket		] -fill gray60 -tags __CenterLine__
		if {$extend_Saddle == {}} {
			$cv_Name create centerline [ canvasCAD::flatten_nestedList  $BottomBracket	$SeatTube_TopTube	] -fill gray60 -tags __CenterLine__ 
		} else {
			$cv_Name create centerline [ canvasCAD::flatten_nestedList  $BottomBracket	$Saddle				] -fill gray60 -tags __CenterLine__ 
		}
		
			# puts "\n =================\n"
			# puts "    $SeatStay_SeatTube	$SeatStay_RearWheel "
			# puts "\n =================\n"
						
	}

	
	proc createDraftingFrame {cv_Name DIN_Format scale projectFile date} {
			
			## -- read from domProject
		set domProject $::APPL_Project

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
		
		
		puts "  projectFile    $projectFile" 
		puts "  stageWidth     $stageWidth" 
		puts "  stageHeight    $stageHeight" 
		puts "  stageScale     $stageScale" 
	}

	
}
