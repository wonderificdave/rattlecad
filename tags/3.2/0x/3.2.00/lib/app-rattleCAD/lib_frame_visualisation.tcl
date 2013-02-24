 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_frame_visualisation.tcl
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
 #	namespace:  rattleCAD::frame_visualisation
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval frame_visualisation {

	variable    bottomCanvasBorder	30
	
	variable 	baseLine
	array	set	baseLine	{}


	proc createBaseline {cv_Name BB_Position geometry_type {colour {gray}}} {
	
			## -- read from domProject
		set domProject $::APPL_Project
		
			# --- get distance to Ground
		switch $geometry_type {
			reference	{	
					set BB_Ground(position)		[ frame_geometry_reference::point_position	BB_Ground  	$BB_Position] 
					set RimDiameter_Front		[ [ $domProject selectNodes /root/Reference/Wheel/Front/RimDiameter ]  asText ]
					set RimDiameter_Rear		[ [ $domProject selectNodes /root/Reference/Wheel/Rear/RimDiameter  ]  asText ]
					set FrontWheel(position)	[ frame_geometry_reference::point_position  FrontWheel  $BB_Position]
					set RearWheel(position)		[ frame_geometry_reference::point_position  RearWheel  	$BB_Position]
				}
			custom		{	
					set BB_Ground(position)		[ frame_geometry_custom::point_position  	BB_Ground  	$BB_Position] 
					set RimDiameter_Front		[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter ]  asText ]
					set RimDiameter_Rear		[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter  ]  asText ]
					set FrontWheel(position)	[ frame_geometry_custom::point_position  FrontWheel  	$BB_Position]
					set RearWheel(position)		[ frame_geometry_custom::point_position  RearWheel  	$BB_Position]
				}
		}
						
			# --- get RearWheel
		foreach {x y} $RearWheel(position) break
		set Rear(xy)				[ list [expr $x - 0.8 * 0.5 * $RimDiameter_Rear ] [lindex $BB_Ground(position) 1] ]
				
			# --- get FrontWheel
		foreach {x y} $FrontWheel(position) break
		set Front(xy)				[ list [expr $x + 0.8 * 0.5 * $RimDiameter_Front ] [lindex $BB_Ground(position) 1] ]
		
		
			# --- create line
		$cv_Name create line 	[ list  [ lindex $Rear(xy)   0 ] [ lindex $Rear(xy)   1 ] [ lindex $Front(xy)   0 ] [ lindex $Front(xy)   1 ] ]  -fill $colour 
		$cv_Name create circle 	$BB_Position  -radius 10  -outline $colour		
	}


	proc createDecoration {cv_Name BB_Position type {updateCommand {}}} {
			
			## -- read from domProject
		set domProject 	$::APPL_Project

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
		
			# --- get Rendering Style
		set Rendering(Brakes)	[[ $domProject selectNodes /root/Rendering/Brakes ]  asText ]

		# --- check existance of File --- regarding on user/etc
		proc checkFileString {fileString} {
			switch -glob $fileString {
					user:* 	{ 	set svgFile [file join $::APPL_Env(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
					etc:* 	{ 	set svgFile [file join $::APPL_Env(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
					default {	set svgFile [file join $::APPL_Env(CONFIG_Dir)/components $fileString ]}
				}
				# puts "            ... createDecoration::checkFileString $svgFile"
			if {![file exists $svgFile]} {
						# puts "           ... does not exist, therfore .."
					set svgFile [file join $::APPL_Env(CONFIG_Dir)/components default_exception.svg]
			}
				# puts "            ... createDecoration::checkFileString $svgFile"
			return $svgFile
		}

		
		switch $type {
			HandleBar {
							# --- create Handlebar -------------
						set HandleBar(position)		[ frame_geometry_custom::point_position  HandleBar  $BB_Position]
						set HandleBar(file)			[ checkFileString [ [ $domProject selectNodes /root/Component/HandleBar/File ]  asText ]]
						set HandleBar(object)		[ $cv_Name readSVG $HandleBar(file) $HandleBar(position) -5  __Decoration__ ]		
						if {$updateCommand != {}} 	{ $cv_Name bind	$HandleBar(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	file://Component/HandleBar/File	\
																							} 	{HandleBar Parameter} \
																]
								}
						}
			RearDerailleur {
							# --- create RearDerailleur --------
						set Derailleur(position)	[ frame_geometry_custom::point_position  Derailleur  $BB_Position]
						set Derailleur(file)		[ checkFileString [ [ $domProject selectNodes /root/Component/Derailleur/File ]  asText ] ]
						set Derailleur(object)		[ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  0  __Decoration__ ]		
						if {$updateCommand != {}} 	{ $cv_Name bind	$Derailleur(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	file://Component/Derailleur/File	\
																							} 	{RearDerailleur Parameter} \
																]
								}
						}
			RearDerailleur_ctr {
							# --- create RearDerailleur --------
						set Derailleur(position)	[ frame_geometry_custom::point_position  Derailleur  $BB_Position]
						foreach {x y} $Derailleur(position) break
						set x1	[expr $x + 15];		set x2	[expr $x - 15]; 	set y1	[expr $y + 15]; 	set y2	[expr $y - 15]
						$cv_Name create line  [list $x1 $y $x2 $y]   -fill gray60  -tags __Decoration__
						$cv_Name create line  [list $x $y1 $x $y2]   -fill gray60  -tags __Decoration__			
						}
			CrankSet {
							# --- create Crankset --------------
						set CrankSet(position)		$BB_Position
						set CrankSet(file)			[ checkFileString [ [ $domProject selectNodes /root/Component/CrankSet/File ]  asText ] ]	
						set CrankSet(object)		[ $cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __Decoration__ ]
						if {$updateCommand != {}} 	{ $cv_Name bind	$CrankSet(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	file://Component/CrankSet/File \
																							} 	{CrankSet Parameter} \
																]
								}
						}
			SeatPost {
							# --- create SeatPost ------------------
						set SeatPost(polygon) 		[ frame_geometry_custom::tube_values SeatPost polygon $BB_Position  ]
						set SeatPost(object)		[ $cv_Name create polygon $SeatPost(polygon) -fill white  -outline black  -tags __Decoration__ ]
							# set SeatPost(debug)		[ frame_geometry_custom::tube_values SeatPost debug $BB_Position  ]
							# set SeatPost(object)		[ $cv_Name create line $SeatPost(debug) -fill red]
						if {$updateCommand != {}} 	{ $cv_Name bind	$SeatPost(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	Component/Saddle/SeatPost/x	\
																								Component/Saddle/SeatPost/y	\
																								Component/Saddle/SeatPost/Diameter	\
																							} 	{SeatPost Parameter} \
																]
								}
						}
			
			RearBrake {
							# --- create RearBrake -----------------
							switch $Rendering(Brakes) {
								Road {
										set ss_direction	[ frame_geometry_custom::tube_values SeatStay direction ]
										set ss_angle		[ expr - [ vectormath::angle {0 1} {0 0} $ss_direction ] ]
										set RearBrake(position)		[ frame_geometry_custom::point_position  RearBrakeMount  $BB_Position]
										set RearBrake(file)			[ checkFileString [ [ $domProject selectNodes /root/Component/Brake/Rear/File ]  asText ] ]
										set RearBrake(object)		[ $cv_Name readSVG $RearBrake(file) $RearBrake(position) $ss_angle  __Decoration__ ]		
										if {$updateCommand != {}} 	{ $cv_Name bind	$RearBrake(object)	<Double-ButtonPress-1> \
																				[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																							$updateCommand { 	file://Component/Brake/Rear/File	\
																												Component/Brake/Rear/LeverLength	\
																											} 	{RearBrake Parameter} \
																				]
												}
										}
								default {}
							}
						}
						
			FrontBrake {
							# --- create FrontBrake ----------------
							switch $Rendering(Brakes) {
								Road {
										set ht_direction	[ frame_geometry_custom::tube_values HeadTube direction ]
										set ht_angle		[ expr [ vectormath::angle {0 1} {0 0} $ht_direction ] ]
										set fb_angle		[ [ $domProject selectNodes /root/Component/Fork/Crown/Brake/Angle  ]  asText ]
										set fb_angle		[ expr $ht_angle + $fb_angle ]
										set FrontBrake(position)	[ frame_geometry_custom::point_position  FrontBrakeMount  $BB_Position]
										set FrontBrake(file)		[ checkFileString [ [ $domProject selectNodes /root/Component/Brake/Front/File ]  asText ] ]
										set FrontBrake(object)		[ $cv_Name readSVG $FrontBrake(file) $FrontBrake(position) $fb_angle  __Decoration__ ]		
										if {$updateCommand != {}} 	{ $cv_Name bind	$FrontBrake(object)	<Double-ButtonPress-1> \
																				[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																							$updateCommand { 	file://Component/Brake/Front/File	\
																												Component/Brake/Front/LeverLength	\
																											} 	{FrontBrake Parameter} \
																				]
												}
										}																																			
								default {}
							}
						}
			Saddle {
							# --- create Saddle --------------------
						set Saddle(position)		[ frame_geometry_custom::point_position  Saddle  $BB_Position]
						set Saddle(file)			[ checkFileString [ [ $domProject selectNodes /root/Component/Saddle/File ]  asText ] ]
						set Saddle(object)			[ $cv_Name readSVG $Saddle(file) $Saddle(position)   0  __Decoration__ ]	
						if {$updateCommand != {}} 	{ $cv_Name bind	$Saddle(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	file://Component/Saddle/File	\
																							} 	{Saddle Parameter} \
																]
								}
						}																																			
			HeadSet {
							# --- create HeadSet --------------------
						set HeadSet(polygon) 		[ frame_geometry_custom::tube_values HeadSet polygon_bt $BB_Position  ]
						set HeadSet(object)			[ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
						if {$updateCommand != {}} 	{ $cv_Name bind	$HeadSet(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	Component/HeadSet/Height/Bottom	\
																								Component/HeadSet/Diameter		\
																							} 	{HeadSet Parameter} \
																]
								}
						set HeadSet(polygon) 		[ frame_geometry_custom::tube_values HeadSet polygon_tp $BB_Position ]
						set HeadSet(object)			[ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
						if {$updateCommand != {}} 	{ $cv_Name bind	$HeadSet(object)	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	Component/HeadSet/Height/Top	\
																								Component/HeadSet/Diameter		\
																							} 	{HeadSet Parameter} \
																]
								}
						}
			Stem {
							# --- create SeatPost ------------------
						set Stem(polygon) 			[ frame_geometry_custom::tube_values Stem polygon $BB_Position  ]
						set Stem(object)			[ $cv_Name create polygon $Stem(polygon) -fill white  -outline black  -tags __Decoration__ ]
						}									
			RearWheel {
							# --- create RearWheel -----------------
						set Hub(position)			[ frame_geometry_custom::point_position  RearWheel  $BB_Position]
						set RimDiameter				[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter ]  asText ]
						set RimHeight				[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimHeight   ]  asText ]
						set TyreHeight				[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight  ]  asText ]
						set my_Wheel				[	$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -fill white -tags __Decoration__ ]
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + 5] 				-tags __Decoration__ 
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - 5] 				-tags __Decoration__ 
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5] 	-tags __Decoration__  
														$cv_Name create circle 	$Hub(position)  -radius 45											-tags __Decoration__ 	
														$cv_Name create circle 	$Hub(position)  -radius 23											-tags __Decoration__ 
						if {$updateCommand != {}} 	{ $cv_Name bind	$my_Wheel	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	Component/Wheel/Rear/RimHeight		\
																							} 	{RearWheel Parameter} \
																]
								}
						}
			FrontWheel {
							# --- create FrontWheel ----------------
						set Hub(position)			[ frame_geometry_custom::point_position  FrontWheel  $BB_Position]
						set RimDiameter				[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter ]  asText ]
						set RimHeight				[ [ $domProject selectNodes /root/Component/Wheel/Front/RimHeight   ]  asText ]
						set TyreHeight				[ [ $domProject selectNodes /root/Component/Wheel/Front/TyreHeight  ]  asText ]
						set my_Wheel				[	$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -fill white  -tags __Decoration__]
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]					-tags __Decoration__
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - 5]                   -tags __Decoration__
														$cv_Name create circle 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]      -tags __Decoration__
														$cv_Name create circle 	$Hub(position)  -radius 20                                              -tags __Decoration__
														$cv_Name create circle 	$Hub(position)  -radius 4.5                                             -tags __Decoration__
						if {$updateCommand != {}} 	{ $cv_Name bind	$my_Wheel	<Double-ButtonPress-1> \
																[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																			$updateCommand { 	Component/Wheel/Front/RimHeight		\
																							} 	{FrontWheel Parameter} \
																]
								}
						}
			RearWheel_Rep	{
						set Hub(position)	[ frame_geometry_custom::point_position  RearWheel  $BB_Position]
						set RimDiameter		[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter ]  asText ]
						set RimHeight		[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimHeight   ]  asText ]
						set TyreHeight		[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight  ]  asText ]
						set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start -20  -extent 105 -style arc -outline gray60  -tags __Decoration__]
						set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter ]				-start -25  -extent 100 -style arc -outline gray60 -width 0.35  -tags __Decoration__]
							# set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - 5 ]			-start  30  -extent  45 -style arc -outline gray60 -width 0.35]
						}									
			FrontWheel_Rep	{
						set Hub(position)	[ frame_geometry_custom::point_position  FrontWheel  $BB_Position]
						set RimDiameter		[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter ]  asText ]
						set RimHeight		[ [ $domProject selectNodes /root/Component/Wheel/Front/RimHeight   ]  asText ]
						set TyreHeight		[ [ $domProject selectNodes /root/Component/Wheel/Front/TyreHeight  ]  asText ]
						set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start  95  -extent  85 -style arc -outline gray60 -tags __Decoration__]
						set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter ]				-start  90  -extent  80 -style arc -outline gray60 -width 0.35  -tags __Decoration__]
							# set my_Wheel		[	$cv_Name create arc 	$Hub(position)  -radius [expr 0.5 * $RimDiameter - 5 ]			-start  95  -extent  45 -style arc -outline gray60 -width 0.35]
						}	
			LegClearance_Rep {
						set LegClearance(position)	[ frame_geometry_custom::point_position  LegClearance  $BB_Position]
						$cv_Name create circle 	$LegClearance(position)  -radius 5  -outline grey60 -tags __Decoration__
						}
											
			default	{
						#set Stem(debug)		[ frame_geometry_custom::tube_values Stem debug $BB_Position  ]
						#set Stem(object)		[ $cv_Name create line $Stem(debug) -fill red]
						#$cv_Name create circle 	$RearWheel(coords)  -radius 30  -outline red	-width 1.0		
						#$cv_Name create circle 	[ list  $FrontWheel(x) $FrontWheel(y) ]  -radius 30  -outline red	-width 1.0	
						#$cv_Name create circle 	[ list  $RearWheel(x)  $RearWheel(y)  ]  -radius [ expr $RearWheel(Radius)  ]  -outline red	-width 1.0		
						#$cv_Name create circle 	[ list  $FrontWheel(x) $FrontWheel(y) ]  -radius [ expr $FrontWheel(Radius) ]  -outline red	-width 1.0
						}
		}
		

	}

	
	proc createFrame_Tubes {cv_Name BB_Position {updateCommand {}}} {
			
			## -- read from domProject
		set domProject 	$::APPL_Project
		set domInit 	$::APPL_Init

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
		
			# --- get Rendering Style
		set Rendering(Fork)		[[ $domProject selectNodes /root/Rendering/Fork  ]  asText ]

			# --- check existance of File --- regarding on user/etc
		proc checkFileString {fileString} {
			switch -glob $fileString {
					user:* 	{ 	set svgFile [file join $::APPL_Env(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
					etc:* 	{ 	set svgFile [file join $::APPL_Env(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
					default {	set svgFile [file join $::APPL_Env(CONFIG_Dir)/components $fileString ]}
				}
				# puts "            ... createDecoration::checkFileString $svgFile"
			if {![file exists $svgFile]} {
						# puts "           ... does not exist, therfore .."
					set svgFile [file join $::APPL_Env(CONFIG_Dir)/components default_exception.svg]
			}
				# puts "            ... createDecoration::checkFileString $svgFile"
			return $svgFile
		}

		
			# --- create Steerer ---------------------
		set Steerer(polygon) 		[ frame_geometry_custom::tube_values Steerer polygon $BB_Position  ]
		#set Steerer(object)			[ $cv_Name create polygon $Steerer(polygon) -fill white -outline black -tags __Frame__ ]

			# --- create Rear Dropout ----------------
		set RearWheel(position)		[ frame_geometry_custom::point_position  RearWheel  $BB_Position]
		set RearDropout(file)		[ checkFileString [ [ $domProject selectNodes /root/Component/RearDropOut/File ]  asText ] ]
		set RearDropout(object)		[ $cv_Name readSVG [file join $::APPL_Env(CONFIG_Dir)/components $RearDropout(file)] $RearWheel(position)  0  __Frame__]
		if {$updateCommand != {}} 	{ $cv_Name bind 	$RearDropout(object)	<Double-ButtonPress-1> \
														[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	file://Component/RearDropOut/File			\
																                    Component/RearDropOut/ChainStay/Offset 		\
																					Component/RearDropOut/ChainStay/OffsetPerp	\
																					Component/RearDropOut/SeatStay/Offset  		\
																					Component/RearDropOut/SeatStay/OffsetPerp  	\
																					Component/RearDropOut/Derailleur/x   		\
																					Component/RearDropOut/Derailleur/y   		\
																	} 	{RearDropout Parameter} \
														]
				}

			# --- create Fork Representation ----------------
		switch $Rendering(Fork) {
			Composite 	-
			SteelLugged {
						set ForkBlade(polygon) 		[ frame_geometry_custom::tube_values ForkBlade polygon $BB_Position  ]
						set ForkCrown(file)			[ checkFileString [ [ $domProject selectNodes /root/Component/Fork/Crown/File ] asText ] ]
						set ForkDropout(file)		[ checkFileString [ [ $domProject selectNodes /root/Component/Fork/DropOut/File ]  asText ] ]
						set ForkDropout(position)	[ frame_geometry_custom::point_position  FrontWheel  $BB_Position]
						set do_direction			[ frame_geometry_custom::tube_values ForkDropout direction ]
						set do_angle				[expr -90 + [ vectormath::angle $do_direction {0 0} {-1 0} ] ]
						}
			Suspension 	{
						set ForkBlade(polygon) 		{}
						set ForkCrown(file)			[ checkFileString [ [ $domInit    selectNodes /root/Options/Fork/Suspension/Visualization/Crown/File ] asText ] ]
						set ForkDropout(file)		[ checkFileString [ [ $domInit    selectNodes /root/Options/Fork/Suspension/Visualization/DropOut/File ]  asText ] ]
						set Suspension_ForkRake		[[ $domInit    selectNodes /root/Options/Fork/Suspension/Geometry/Rake ]  asText ]
						set Project_ForkRake		[[ $domProject selectNodes /root/Component/Fork/Rake ]  asText ]
						set do_direction			[ frame_geometry_custom::tube_values HeadTube direction ]
						set do_angle				[ vectormath::angle {0 1} {0 0} $do_direction ]
						set offset					[ expr $Project_ForkRake-$Suspension_ForkRake]
						set vct_move				[ vectormath::rotatePoint {0 0} [list 0 $offset] [expr 90 + $do_angle] ]
						set ForkDropout(position)	[ vectormath::addVector [ frame_geometry_custom::point_position  FrontWheel  $BB_Position] $vct_move]
						set updateCommand 			{}
						}
			default {}
		}
		
			# --- create Fork Blade -----------------
		set ForkBlade(object)		[ $cv_Name create polygon $ForkBlade(polygon) -fill white  -outline black -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$ForkBlade(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	list://Rendering/Fork@APPL_ForkTypes \
																					Component/Fork/Blade/Width			\
																					Component/Fork/Blade/DiameterDO		\
																					Component/Fork/Blade/TaperLength	\
																					Component/Fork/Blade/Offset			\
																				} 	{ForkBlade Parameter} \
													]
				}

			# --- create ForkCrowh -------------------
				set ht_direction	[ frame_geometry_custom::tube_values HeadTube direction ]
				set ht_angle		[ vectormath::angle {0 1} {0 0} $ht_direction ]
		set ForkCrown(position)		[ frame_geometry_custom::point_position  Steerer_Fork  $BB_Position]
		set ForkCrown(object)		[ $cv_Name readSVG [file join $::APPL_Env(CONFIG_Dir)/components $ForkCrown(file)] $ForkCrown(position) $ht_angle __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind 	$ForkCrown(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	list://Rendering/Fork@APPL_ForkTypes \
																					file://Component/Fork/Crown/File	\
																					Component/Fork/Crown/Brake/Angle 	\
																					Component/Fork/Crown/Brake/Offset 	\
																					Component/Fork/Crown/Brake/OffsetPerp \
																					Component/Fork/Crown/Blade/Offset 	\
																					Component/Fork/Crown/Blade/OffsetPerp \
																				} 	{ForkCrown Parameter} \
													]
				}
								
			# --- create Fork Dropout ---------------
		set ForkDropout(object)		[ $cv_Name readSVG [file join $::APPL_Env(CONFIG_Dir)/components $ForkDropout(file)] $ForkDropout(position) $do_angle  __Frame__] 
		if {$updateCommand != {}}	{ $cv_Name bind 	$ForkDropout(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	file://Component/Fork/DropOut/File	\
																					Component/Fork/DropOut/Offset 	\
																					Component/Fork/DropOut/OffsetPerp \
																				} 	{ForkDropout Parameter} \
													]
				}
		
				
			# --- create HeadTube --------------------
		set HeadTube(polygon) 		[ frame_geometry_custom::tube_values HeadTube polygon $BB_Position  ]
		set HeadTube(object)		[ $cv_Name create polygon $HeadTube(polygon) -fill white -outline black  -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$HeadTube(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  {	FrameTubes/HeadTube/Diameter	\
																				}	{HeadTube Parameter}
													] \
				}
				
			# --- create DownTube --------------------
		set DownTube(polygon) 		[ frame_geometry_custom::tube_values DownTube polygon $BB_Position  ]
		set DownTube(object) 		[ $cv_Name create polygon $DownTube(polygon) -fill white -outline black  -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$DownTube(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	FrameTubes/DownTube/DiameterHT  \
																					FrameTubes/DownTube/DiameterBB  \
																					FrameTubes/DownTube/TaperLength \
																				}	{DownTube Parameter}
													] \
				}
				
			# --- create SeatTube --------------------
		set SeatTube(polygon) 		[ frame_geometry_custom::tube_values SeatTube polygon $BB_Position  ]
		set SeatTube(object)		[ $cv_Name create polygon $SeatTube(polygon) -fill white -outline black  -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$SeatTube(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	FrameTubes/SeatTube/DiameterTT   \
																					FrameTubes/SeatTube/DiameterBB   \
																					FrameTubes/SeatTube/TaperLength  \
																				}	{SeatTube Parameter}
													] \
				}

			# --- create TopTube ---------------------
		set TopTube(polygon) 		[ frame_geometry_custom::tube_values TopTube polygon $BB_Position  ]
		set TopTube(object)			[ $cv_Name create polygon $TopTube(polygon) -fill white -outline black  -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$TopTube(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	FrameTubes/TopTube/DiameterHT   \
																					FrameTubes/TopTube/DiameterST   \
																					FrameTubes/TopTube/TaperLength  \
																					Custom/TopTube/Angle		\
																				} 	{TopTube Parameter}
													]
				}

			# --- create ChainStay -------------------
		set ChainStay(polygon) 		[ frame_geometry_custom::tube_values ChainStay polygon $BB_Position  ]
		set ChainStay(object)		[ $cv_Name create polygon $ChainStay(polygon) -fill white -outline black  -tags __Frame__]		
		if {$updateCommand != {}}	{ $cv_Name bind	$ChainStay(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  {	FrameTubes/ChainStay/DiameterSS		\
																					FrameTubes/ChainStay/DiameterBB		\
																					FrameTubes/ChainStay/TaperLength	\
																				} 	{Chainstay Parameter}
													]
				}

			# --- create SeatStay --------------------
		set SeatStay(polygon) 		[ frame_geometry_custom::tube_values SeatStay polygon $BB_Position  ]
		set SeatStay(object)		[ $cv_Name create polygon $SeatStay(polygon) -fill white -outline black  -tags __Frame__]
		if {$updateCommand != {}}	{ $cv_Name bind	$SeatStay(object)	<Double-ButtonPress-1> \
													[list frame_geometry_custom::createEdit  %x %y  $cv_Name  \
																$updateCommand  { 	FrameTubes/SeatStay/DiameterST   \
																					FrameTubes/SeatStay/DiameterCS   \
																					FrameTubes/SeatStay/TaperLength  \
																					Custom/SeatStay/OffsetTT     \
																				} 	{SeatStay Parameter}
													]
				}

			# --- create BottomBracket ---------------
		$cv_Name create circle  $BB_Position			-radius 20	-fill white	-tags __Frame__
		$cv_Name create circle  $ForkDropout(position)	-radius 4.5	-fill white	-tags __Frame__

			#set debug_01				[ frame_geometry_custom::tube_values ForkBlade debug $BB_Position  ]
			#$cv_Name create line    $debug_01 -fill purple -width 1 
			#$cv_Name delete 	$ForkDropout(object)
			
			#set debug_02				[ frame_geometry_custom::point_position  Debug02  $BB_Position]
			#set debug_03				[ frame_geometry_custom::point_position  Debug03  $BB_Position]
			#set debug_04				[ frame_geometry_custom::point_position  Debug04  $BB_Position]
			#set debug_05				[ frame_geometry_custom::point_position  Debug05  $BB_Position]
			#$cv_Name create circle  $debug_01 -radius 20  -outline red
			#$cv_Name create circle  $debug_02 -radius 20  -outline red
			#$cv_Name create circle  $debug_03 -radius 20  -outline blue
			#$cv_Name create circle  $debug_04 -radius 20  -outline darkblue
			#$cv_Name create circle  $debug_05 -radius 10  -outline darkblue
			#$cv_Name create line    [list $debug_01 $debug_02 $debug_03 $debug_04] -fill purple -width 1 
			#$cv_Name create line    [list $debug_01 $debug_02 $debug_03 $debug_04 $debug_05] -fill blue 
			#$cv_Name create line    [list $debug_01 $debug_02 $debug_03 $debug_04 $debug_05] -fill purple -width 1 
		
	}

	
	proc createFrame_Centerline {cv_Name BB_Position geometry_type {highlightList {}} {excludeList {}} } {
			
			## -- read from domProject
		set domProject $::APPL_Project

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
	
	
		switch $geometry_type {
			reference	{
						# --- get defining Values ----------
					set CrankSetLength		170
						# --- get defining Point coords ----------
					set BottomBracket		$BB_Position	
					set RearWheel			[ frame_geometry_reference::point_position  RearWheel			$BB_Position ]
					set FrontWheel			[ frame_geometry_reference::point_position  FrontWheel			$BB_Position ]
					set Saddle				[ frame_geometry_reference::point_position  Saddle				$BB_Position ]
					set SeatTube_Ground		[ frame_geometry_reference::point_position  SeatTube_Ground		$BB_Position ]
					set SeatStay_SeatTube	[ frame_geometry_reference::tube_values		SeatStay SeatTube	$BB_Position ]
					set SeatStay_RearWheel	[ frame_geometry_reference::tube_values		SeatStay RearWheel	$BB_Position ]
					set TopTube_SeatTube	[ frame_geometry_reference::tube_values		TopTube SeatTube	$BB_Position ]
					set TopTube_Steerer		[ frame_geometry_reference::tube_values		TopTube HeadTube	$BB_Position ]
					set Steerer_Stem		[ frame_geometry_reference::point_position  Steerer_Stem		$BB_Position ]
					set Steerer_Fork		[ frame_geometry_reference::point_position  Steerer_Fork		$BB_Position ]
					set DownTube_Steerer	[ frame_geometry_reference::tube_values		DownTube HeadTube 	$BB_Position ]
					set HandleBar			[ frame_geometry_reference::point_position  HandleBar 			$BB_Position ]
					set BaseCenter			[ frame_geometry_reference::point_position  BB_Ground			$BB_Position ]
					set Steerer_Ground		[ frame_geometry_reference::point_position  Steerer_Ground		$BB_Position ]		
					set LegClearance		[ frame_geometry_reference::point_position  LegClearance 		$BB_Position ]
					set RimDiameter_Front	[ [ $domProject selectNodes /root/Reference/Wheel/Front/RimDiameter ]  asText ]
					set TyreHeight_Front	[ [ $domProject selectNodes /root/Reference/Wheel/Front/TyreHeight  ]  asText ]
					set RimDiameter_Rear	[ [ $domProject selectNodes /root/Reference/Wheel/Rear/RimDiameter  ]  asText ]
					set TyreHeight_Rear		[ [ $domProject selectNodes /root/Reference/Wheel/Rear/TyreHeight   ]  asText ]			
				}
			custom		{
						# --- get defining Values ----------
					set CrankSetLength			[ [ $domProject selectNodes /root/Component/CrankSet/Length		 ]  asText ]
						# --- get defining Point coords ----------
					set BottomBracket		$BB_Position	
					set RearWheel			[ frame_geometry_custom::point_position  RearWheel				$BB_Position ]
					set FrontWheel			[ frame_geometry_custom::point_position  FrontWheel				$BB_Position ]
					set Saddle				[ frame_geometry_custom::point_position  Saddle					$BB_Position ]
					set SeatTube_Ground		[ frame_geometry_custom::point_position  SeatTube_Ground		$BB_Position ]
					set SeatStay_SeatTube	[ frame_geometry_custom::tube_values     SeatStay SeatTube		$BB_Position ]
					set SeatStay_RearWheel	[ frame_geometry_custom::tube_values     SeatStay RearWheel		$BB_Position ]
					set TopTube_SeatTube	[ frame_geometry_custom::tube_values     TopTube SeatTube		$BB_Position ]
					set TopTube_Steerer		[ frame_geometry_custom::tube_values  	  TopTube HeadTube		$BB_Position ]
					set Steerer_Stem		[ frame_geometry_custom::point_position  Steerer_Stem			$BB_Position ]
					set Steerer_Fork		[ frame_geometry_custom::point_position  Steerer_Fork			$BB_Position ]
					set DownTube_Steerer	[ frame_geometry_custom::tube_values  	  DownTube HeadTube 	$BB_Position ]
					set HandleBar			[ frame_geometry_custom::point_position  HandleBar 				$BB_Position ]
					set BaseCenter			[ frame_geometry_custom::point_position  BB_Ground				$BB_Position ]
					set Steerer_Ground		[ frame_geometry_custom::point_position  Steerer_Ground			$BB_Position ]		
					set LegClearance		[ frame_geometry_custom::point_position  LegClearance 			$BB_Position ]
					set RimDiameter_Front	[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter ]  asText ]
					set TyreHeight_Front	[ [ $domProject selectNodes /root/Component/Wheel/Front/TyreHeight  ]  asText ]
					set RimDiameter_Rear	[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter  ]  asText ]
					set TyreHeight_Rear		[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight   ]  asText ]
				}		
		}
			
			# ------ rearwheel representation
		$cv_Name create circle 	$RearWheel   -radius [ expr 0.5*$RimDiameter_Rear + $TyreHeight_Rear ]  	-outline gray60	-width 1.0	-tags __CenterLine__	
		$cv_Name create circle 	$RearWheel   -radius 15  -outline gray60  -tags {__CenterLine__}
			# ------ frontwheel representation
		$cv_Name create circle 	$FrontWheel  -radius [ expr 0.5*$RimDiameter_Front + $TyreHeight_Front ]  	-outline gray60	-width 1.0	-tags __CenterLine__	
		$cv_Name create circle 	$FrontWheel  -radius 15  -outline gray60  -tags {__CenterLine__}

			# ------ headtube extension to ground
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $Steerer_Fork   $Steerer_Ground  ]  	-fill gray60 				-tags __CenterLine__
			# ------ seattube extension to ground
		$cv_Name create centerline [ canvasCAD::flatten_nestedList  $BottomBracket  $SeatTube_Ground  ]  	-fill gray60 				-tags {__CenterLine__	seattube_center}

		# ------ chainstay
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $RearWheel 		$BottomBracket	 ]  	-fill gray60  -width 1.0  	-tags {__CenterLine__	chainstay}			
			# ------ seattube                                                                                                               
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $Saddle 			$BottomBracket	 ]  	-fill gray60  -width 1.0  	-tags {__CenterLine__	seattube}			
			# ------ seatstay                                                                                                               
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $SeatStay_SeatTube $RearWheel		 ]  	-fill gray60  -width 1.0  	-tags {__CenterLine__ 	seatstay}			
			# ------ toptube                                                                                                                
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $TopTube_SeatTube	$TopTube_Steerer ]  	-fill gray60  -width 1.0  	-tags {__CenterLine__	toptube}				
			# ------ steerer / stem                                                                                                         
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $HandleBar  $Steerer_Stem  $Steerer_Fork]	-fill gray60  -width 1.0  	-tags {__CenterLine__	steerer}				
			# ------ downtube                                                                                                               
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $DownTube_Steerer 	$BB_Position	]  		-fill gray60  -width 1.0  	-tags {__CenterLine__	downtube}			
			# ------ fork                                                                                                                   
		$cv_Name create line 	[ canvasCAD::flatten_nestedList  $Steerer_Fork 		$FrontWheel		]  		-fill gray60  -width 1.0  	-tags {__CenterLine__	fork}				
			                                                                                                                                
			# ------ crankset representation	                                                                                            
		$cv_Name create arc  	$BottomBracket  -radius $CrankSetLength  -start -50  -extent 120  -style arc \
																											-outline gray -width 1.0  	-tags {__CenterLine__	crankset} 			
			# ------ saddle representation	                                                                                                
				set saddle_polygon {}                                                                                                       
				foreach xy {{-120 4} {0 0} {130 -1} {140 -5} {160 -12}} {                                                                   
					set saddle_polygon [ lappend saddle_polygon [vectormath::addVector $Saddle $xy ] ]                                      
				}                                                                                                                           
		$cv_Name create line  $saddle_polygon   													   		-fill gray60  -width 1.0  	-tags {__CenterLine__	saddle}				
		
			# --- create position points
		# $cv_Name create circle 	$BottomBracket	-radius 10  -outline gray60
		# $cv_Name create circle	$HandleBar		-radius 10  -outline gray60
		# $cv_Name create circle 	$LegClearance	-radius 10  -outline gray60 
		# $cv_Name create circle 	$Saddle			-radius 10  -outline gray60 
		$cv_Name create circle 	$BaseCenter		-radius 10  -outline gray60		-tags 	__CenterLine__

		puts "  $highlightList "
			# --- highlightList
		foreach item $highlightList {
			catch {$cv_Name itemconfigure $item  -fill 		red -width 1.5 } error
			catch {$cv_Name itemconfigure $item  -outline 	red -width 1.5 } error
		}

		puts "  $excludeList "
			# --- highlightList
		foreach item $excludeList {
			catch {$cv_Name delete $item } error
		}
	}

	
	proc createTubemitter {cv_Name xy type} {
	
			## -- read from domProject
		set domProject $::APPL_Project
		
					set		minorAngle			2
					set		majorAngle			50
					
		switch $type {
			TopTube_Seat {
					set Mitter(polygon)		[ frame_geometry_custom::tube_values TopTube_Seat mitter $xy  ]
					set Mitter(header)		"TopTube / SeatTube"
					set 	minorDiameter		[ [ $domProject selectNodes /root/FrameTubes/TopTube/DiameterST		]  asText ]
					set 	minorDirection		[ frame_geometry_custom::tube_values TopTube 	direction ]
					set 	majorDiameter		[ [ $domProject selectNodes /root/FrameTubes/SeatTube/DiameterTT		]  asText ]
					set 	majorDirection		[ frame_geometry_custom::tube_values SeatTube 	direction ]
					set 	offSet				0
				}
			TopTube_Head {
					set Mitter(polygon)		[ frame_geometry_custom::tube_values TopTube_Head mitter $xy  ]
					set Mitter(header)		"TopTube / HeadTube"
					set 	minorDiameter		[ [ $domProject selectNodes /root/FrameTubes/TopTube/DiameterHT		]  asText ]
					set 	minorDirection		[ frame_geometry_custom::tube_values TopTube 	direction ]
					set 	majorDiameter		[ [ $domProject selectNodes /root/FrameTubes/HeadTube/Diameter		]  asText ]
					set 	majorDirection		[ frame_geometry_custom::tube_values HeadTube 	direction ]
					set 	offSet				0
				}
			DownTube_Head {
					set Mitter(polygon)		[ frame_geometry_custom::tube_values DownTube_Head mitter $xy  ]
					set Mitter(header)		"DownTube / HeadTube"
					set 	minorDiameter		[ [ $domProject selectNodes /root/FrameTubes/DownTube/DiameterHT		]  asText ]
					set 	minorDirection		[ frame_geometry_custom::tube_values DownTube 	direction ]
					set 	majorDiameter		[ [ $domProject selectNodes /root/FrameTubes/HeadTube/Diameter		]  asText ]
					set 	majorDirection		[ frame_geometry_custom::tube_values HeadTube 	direction ]
					set 	majorDirection		[ vectormath::unifyVector {0 0} $majorDirection -1 ]
					set 	offSet				0
				}
			SeatStay_01 {
					set Mitter(polygon)		[ frame_geometry_custom::tube_values SeatStay_01 mitter $xy  ]
					set Mitter(header)		"SeatStay / SeatTube"
					set 	minorDiameter		[ [ $domProject selectNodes /root/FrameTubes/SeatStay/DiameterST		]  asText ]
					set 	minorDirection		[ frame_geometry_custom::tube_values SeatStay 	direction ]
					set 	majorDiameter		[ [ $domProject selectNodes /root/FrameTubes/SeatTube/DiameterTT		]  asText ]
					set 	majorDirection		[ frame_geometry_custom::tube_values SeatTube 	direction ]
					set 	majorDirection		[ vectormath::unifyVector {0 0} $majorDirection -1 ]
					set 	offSet				[ format "%.2f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
				}
			SeatStay_02 {
					set Mitter(polygon)		[ frame_geometry_custom::tube_values SeatStay_02 mitter $xy  ]
					set Mitter(header)		"SeatStay / SeatTube"
					set 	minorDiameter		[ [ $domProject selectNodes /root/FrameTubes/SeatStay/DiameterST		]  asText ]
					set 	minorDirection		[ frame_geometry_custom::tube_values SeatStay 	direction ]
					set 	majorDiameter		[ [ $domProject selectNodes /root/FrameTubes/SeatTube/DiameterTT		]  asText ]
					set 	majorDirection		[ frame_geometry_custom::tube_values SeatTube 	direction ]
					set 	majorDirection		[ vectormath::unifyVector {0 0} $majorDirection -1 ]
					set 	offSet				[ format "%.2f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
				}
			default {return}
		}
		
				# --- mitter polygon
				#
		$cv_Name create polygon $Mitter(polygon) -fill white -outline black
		
				# --- polygon reference lines
				#
			set pt_01	[ vectormath::addVector $xy {0   5} ]
			set pt_02	[ vectormath::addVector $xy {0 -75} ]
		$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $pt_01 $pt_02 ]  -fill red  -width 0.25	
			set pt_03	[ frame_geometry_custom::coords_get_xy $Mitter(polygon) 0 ]
			set pt_03	[ vectormath::addVector $pt_03 {+5  20} ]
			set pt_04	[frame_geometry_custom::coords_get_xy $Mitter(polygon) end]
			set pt_04	[ vectormath::addVector $pt_04 {-5  20} ]
		$cv_Name create line 		[ canvasCAD::flatten_nestedList $pt_03 $pt_04 ]  -fill blue -width 0.25	
			set pt_05	[ vectormath::addVector $pt_03 { 0  50} ]
			set pt_06	[ vectormath::addVector $pt_04 { 0  50} ]
		$cv_Name create centerline 	[ canvasCAD::flatten_nestedList $pt_05 $pt_06 ]  -fill red  -width 0.25	
		
				# --- defining values
				#
			set Mitter(text_01)		"diameter: $minorDiameter / $majorDiameter"
					set		minorAngle			[ vectormath::angle {0 1} {0 0} $minorDirection   ]
					set		majorAngle			[ vectormath::angle {0 1} {0 0} $majorDirection   ]
					set		angle				[ expr abs($majorAngle - $minorAngle) ]
						if {$angle > 90} {set angle [expr 180 - $angle]}
					set 	angle [ format "%.2f" $angle ]
					set		angleComplement		[ format "%.2f" [ expr 180 - $angle ] ]
			set Mitter(text_02)		"angle:  $angle / $angleComplement"
			set Mitter(text_03)		"offset: $offSet"

			set textPos		[vectormath::addVector $xy {-20 -48}]
		$cv_Name create draftText $textPos  -text $Mitter(header) -size 3.5
			set textPos		[vectormath::addVector $xy {-10 -55}]
		$cv_Name create draftText $textPos  -text $Mitter(text_01) -size 2.5
			set textPos		[vectormath::addVector $xy {-10 -60}]
		$cv_Name create draftText $textPos  -text $Mitter(text_02) -size 2.5
			set textPos		[vectormath::addVector $xy {-10 -65}]
		$cv_Name create draftText $textPos  -text $Mitter(text_03) -size 2.5

		
	}
	
  }

  
