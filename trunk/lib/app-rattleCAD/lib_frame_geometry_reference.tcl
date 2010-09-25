# -----------------------------------------------------------------------------------
#
#: Functions : namespace      F R A M E _ G E O M E T R Y _ R E F E R E N C E
#

 
 namespace eval frame_geometry_reference {
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
			variable Seat
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
			set BottomBracket(depth)	[ [ $domConfig selectNodes /root/Reference/Wheel/BottomBracket_Depth 		]  asText ]

				#
				# --- get RearWheel
			set Wheel(Diameter)			[ [ $domConfig selectNodes /root/Reference/Wheel/Diameter 			]  asText ]
			set Wheel(Radius)			[ expr 0.5 * $Wheel(Diameter) ]
			
				#
				# --- get RearWheel
			set RearWheel(Radius)		$Wheel(Radius)
			set RearWheel(DistanceBB)	[ [ $domConfig selectNodes /root/Reference/Wheel/Chainstay_Length	]  asText ]
			set RearWheel(Distance_X)	[ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($BottomBracket(depth),2)) ]
				
				#
				# --- get BottomBracket (2)
			set BottomBracket(height)	[ expr $RearWheel(Radius) - $BottomBracket(depth) ]
		
				#
				# --- get FrontWheel 
			set FrontWheel(Radius)		$Wheel(Radius)
			set FrontWheel(DistanceRW)	[ [ $domConfig selectNodes /root/Reference/Wheel/Distance			]  asText ]
			set FrontWheel(Distance_X)	[ expr $FrontWheel(DistanceRW) - $RearWheel(Distance_X) ]

				#
				# --- get HandleBar - Position
			set HandleBar(Height)		[ [ $domConfig selectNodes /root/Reference/HandleBar/Height			]  asText ]

				#
				# --- get LegClearance - Position
			set LegClearance(Length)	[ [ $domConfig selectNodes /root/Personal/InnerLeg_Length			]  asText ]
			
				#
				# --- get Stem -----------------------------
			set Stem(Angle)				[ [ $domConfig selectNodes /root/Reference/Steering/Stem/Angle		]  asText ]
			set Stem(Length)			[ [ $domConfig selectNodes /root/Reference/Steering/Stem/Length		]  asText ]

				#
				# --- get Fork -----------------------------
			set Fork(Height)			[ [ $domConfig selectNodes /root/Reference/Steering/Fork/Height		]  asText ]
			set Fork(Rake)				[ [ $domConfig selectNodes /root/Reference/Steering/Fork/Rake		]  asText ]
			
				#
				# --- get HeadTube -------------------------
			set HeadTube(Angle)			[ [ $domConfig selectNodes /root/Reference/Steering/HeadTube/Angle	]  asText ]
			set HeadTube(Length)		[ [ $domConfig selectNodes /root/Reference/Steering/HeadTube/Length	]  asText ]

				#
				# --- get TopTube --------------------------
			set TopTube(PivotPosition)	[ [ $domConfig selectNodes /root/Custom/TopTube/PivotPosition		]  asText ]
			set TopTube(Angle)			{5.00}

				#
				# --- get SeatTube -------------------------
			set Saddle(Height)			[ [ $domConfig selectNodes /root/Reference/Seat/Height 				]  asText ]
			set SeatTube(Angle)			[ [ $domConfig selectNodes /root/Reference/Seat/Angle 				]  asText ]
				
				#
				#
				# --- set basePoints Attributes
				#
			set frameCoords::RearWheel		[ list -$RearWheel(Distance_X)	$BottomBracket(depth) ]
			set frameCoords::FrontWheel		[ list $FrontWheel(Distance_X)	[expr $BottomBracket(depth) + ($FrontWheel(Radius) - $RearWheel(Radius))] ]
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
					variable HandleBar
					variable HeadSet
					variable Saddle
					variable SeatTube
					
						set help_01  [ vectormath::rotateLine {0 0}  200  [ expr 180 - $SeatTube(Angle) ] ]
						set help_02  [ list  800 [lindex $frameCoords::BB_Ground 1] ]
					set frameCoords::SeatTube_Ground	[ vectormath::intersectPoint {0 0}  $help_01  $frameCoords::BB_Ground  $help_02 ] 
						set vect_01	 [ vectormath::parallel  $frameCoords::BB_Ground	$help_02	$Saddle(Height) left]
					set frameCoords::Saddle 			[ vectormath::intersectPoint {0 0}  $help_01 [lindex $vect_01 0] [lindex $vect_01 1] ]

						set help_03	 [ vectormath::rotateLine $frameCoords::FrontWheel  [expr $Fork(Height) + $HeadTube(Length)]	[ expr 180 - $HeadTube(Angle) ] ]
					set vect_HT  [ vectormath::parallel   $frameCoords::FrontWheel	$help_03	$Fork(Rake) left ]
						set help_04	 [ lindex $vect_HT 0]
						set help_05	 [ lindex $vect_HT 1]
					set frameCoords::Steerer_Fork 		[ vectormath::addVector $help_04 [ vectormath::unifyVector  $help_04  $help_05   $Fork(Height) ] ]
					set frameCoords::Steerer_Ground		[ vectormath::intersectPoint  $help_04   $help_05   $frameCoords::BB_Ground  $help_02 ] 
					
						set st_perp	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]						
						set st_horz  [ expr $st_perp / cos((90 - $HeadTube(Angle)) * $vectormath::CONST_PI / 180) ]
						set vect_02	 [ vectormath::parallel  $help_04   $help_05	$st_perp ]
						set vect_03	 [ vectormath::parallel  $frameCoords::BB_Ground	$help_02	$HandleBar(Height) left]
					set frameCoords::HandleBar 			[ vectormath::intersectPoint  [lindex $vect_02 0] [lindex $vect_02 1]  [lindex $vect_03 0] [lindex $vect_03 1] ]
						
						set help_07  [ vectormath::intersectPerp  $help_04  $help_05  $frameCoords::HandleBar]
						set help_08  [ vectormath::rotateLine     $frameCoords::HandleBar  $Stem(Length) [expr 270 - $HeadTube(Angle) + $Stem(Angle)] ] 
					set frameCoords::Steerer_Stem		[ vectormath::intersectPoint  $help_04   $help_05  $frameCoords::HandleBar $help_08 ]

						#
						# --- set summary Length of Frame, Saddle and Stem
						set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
						set summaryHeight [ expr $BottomBracket(depth) + 40 + [lindex $frameCoords::Saddle 1] ]
					set frameCoords::FrameSize 	[ list $summaryLength $summaryHeight ]

						#
						# --- set parameter to export to geometry_custom 
					set FrontWheel(DistanceBB)		[ vectormath::length {0 0} $frameCoords::FrontWheel ]
					set HandleBar(Distance)			[ lindex $frameCoords::HandleBar 0]
					set HandleBar(HeightBB)			[ lindex $frameCoords::HandleBar 1]
			
					puts "  export to geometry_custom:"
					puts "     FrontWheel(DistanceBB)   $FrontWheel(DistanceBB)"	 	
					puts "     HandleBar(Distance)      $HandleBar(Distance)   " 	
					puts "     HandleBar(HeightBB)      $HandleBar(HeightBB)   "
	
			}
			get_basePoints
			
			
			
			#
			# --- compute tubing geometry
			#
			
				#
				# --- set HeadTube -------------------------
			proc get_HeadTube {} {
					variable HeadTube 
					variable HeadSet
					
					set frameCoords::HeadTube(direction) 		[ vectormath::unifyVector 	$frameCoords::Steerer_Fork		$frameCoords::Steerer_Stem ]
					set frameCoords::HeadTube(Fork)				[ vectormath::addVector 	$frameCoords::Steerer_Fork		$frameCoords::HeadTube(direction) ]
					set frameCoords::HeadTube(Stem)				[ vectormath::addVector 	$frameCoords::HeadTube(Fork)	$frameCoords::HeadTube(direction)	$HeadTube(Length) ]
			}
			get_HeadTube
																
				#
				# --- set DownTube ------------------------
			proc get_DownTube {} {
					variable HeadTube 
			
					set frameCoords::DownTube(BottomBracket)	{0 0}
					set frameCoords::DownTube(HeadTube)			[ vectormath::addVector		$frameCoords::HeadTube(Fork)   $frameCoords::HeadTube(direction)	35.0 ]			
					set frameCoords::DownTube(direction)		[ vectormath::unifyVector	$frameCoords::DownTube(BottomBracket)  $frameCoords::DownTube(HeadTube) ]
			}
			get_DownTube
			
				#
				# --- set TopTube -------------------------
			proc get_TopTube_SeatTube {} {
					variable TopTube 
					variable HeadTube 
					variable SeatTube 
					variable DownTube 

					set frameCoords::TopTube(HeadTube)			[ vectormath::addVector		$frameCoords::HeadTube(Stem)   $frameCoords::HeadTube(direction)	-35.0 ]
					set frameCoords::SeatTube(direction)		[ vectormath::unifyVector   {0 0} $frameCoords::Saddle ]
					set frameCoords::TopTube(direction)			[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube
					
							set help_01		[ vectormath::addVector	$frameCoords::TopTube(HeadTube)	 $frameCoords::TopTube(direction) 500 ]
					set frameCoords::TopTube(SeatTube)			[ vectormath::intersectPoint	$frameCoords::TopTube(HeadTube)  $help_01  {0 0} $frameCoords::Saddle ]
					set frameCoords::SeatTube(BottomBracket)	{0 0}	
			}
			get_TopTube_SeatTube
			
				#
				# --- set SeatStay ------------------------
			proc get_SeatStay {} {
					variable SeatStay 
					variable SeatTube 
					set frameCoords::SeatStay(SeatTube)			$frameCoords::TopTube(SeatTube)		
					set frameCoords::SeatStay(RearWheel)		$frameCoords::RearWheel
			}
			get_SeatStay
			
				#
				# --- update /root/Reference/Result/... ---
			proc update_referenceResult {domConfig} {
					variable Stem
					variable RearWheel
					variable FrontWheel
					variable BottomBracket
					variable HandleBar
					variable SeatTube
					variable Fork

					foreach	{xpath value xpathPersonal} [list 	/root/Reference/Result/HandleBar_Distance 	$HandleBar(Distance) 	/root/Personal/HandleBar_Distance	\
																/root/Reference/Result/HandleBar_Height		$HandleBar(HeightBB) 	/root/Personal/HandleBar_Height		\
																/root/Reference/Result/BottomBracket/Depth	$BottomBracket(depth) 	/root/Custom/BottomBracket/Depth	\
																/root/Reference/Result/Fork/Rake			$Fork(Rake) 			/root/Component/Fork/Rake			\
																/root/Reference/Result/SeatTube_Angle 		$SeatTube(Angle) 		/root/Personal/SeatTube_Angle		\
																/root/Reference/Result/Stem/Angle			$Stem(Angle) 			/root/Component/Stem/Angle			\
																/root/Reference/Result/Stem/Length			$Stem(Length) 			/root/Component/Stem/Length			\
																/root/Reference/Result/WheelPosition/Front	$FrontWheel(DistanceBB) /root/Custom/WheelPosition/Front	\
																/root/Reference/Result/WheelPosition/Rear	$RearWheel(DistanceBB) 	/root/Custom/WheelPosition/Rear   ] \
							{
									# puts "  $xpath $value"
									set reference 	[$domConfig selectNodes $xpath/value/text()]
									$reference nodeValue [format "%.2f" $value]
									
									set personal 	[$domConfig selectNodes $xpathPersonal/text()]
									set personalValue 	[$personal asText]

									set delta		[$domConfig selectNodes $xpath/delta/text()]
									set deltaValue	[expr $personalValue - $value]
									
									$delta nodeValue [format "%.2f" $deltaValue]
							}						
			}
			update_referenceResult $domConfig
	}


 	#-------------------------------------------------------------------------
		#  exchange project attributes
	proc update_referenceResultDelta {domConfig} {

					foreach	{xpath xpathPersonal} 		[list 	/root/Reference/Result/HandleBar_Distance 	/root/Personal/HandleBar_Distance	\
																/root/Reference/Result/HandleBar_Height		/root/Personal/HandleBar_Height		\
																/root/Reference/Result/BottomBracket/Depth	/root/Custom/BottomBracket/Depth	\
																/root/Reference/Result/Fork/Rake			/root/Component/Fork/Rake			\
																/root/Reference/Result/SeatTube_Angle 		/root/Personal/SeatTube_Angle		\
																/root/Reference/Result/Stem/Angle			/root/Component/Stem/Angle			\
																/root/Reference/Result/Stem/Length			/root/Component/Stem/Length			\
																/root/Reference/Result/WheelPosition/Front	/root/Custom/WheelPosition/Front	\
																/root/Reference/Result/WheelPosition/Rear	/root/Custom/WheelPosition/Rear   ] \
							{
									# puts "  $xpath $value"
									set personal 		[$domConfig selectNodes $xpathPersonal/text()]
									set personalValue 	[$personal asText]

									set reference		[$domConfig selectNodes $xpath/value/text()]
									set referenceValue 	[$reference asText]
									
									set delta			[$domConfig selectNodes $xpath/delta/text()]
									set deltaValue 		[expr $personalValue - $referenceValue]
									
									$delta nodeValue [format "%.2f" $deltaValue]
							}						

	}
	

 	#-------------------------------------------------------------------------
		#  exchange project attributes
	proc export_parameter_2_geometry_custom {domConfig} {

					foreach	{xpath xpathPersonal} 		[list 	/root/Reference/Result/HandleBar_Distance 	/root/Personal/HandleBar_Distance	\
																/root/Reference/Result/HandleBar_Height		/root/Personal/HandleBar_Height		\
																/root/Reference/Result/BottomBracket/Depth	/root/Custom/BottomBracket/Depth	\
																/root/Reference/Result/Fork/Rake			/root/Component/Fork/Rake			\
																/root/Reference/Result/SeatTube_Angle 		/root/Personal/SeatTube_Angle		\
																/root/Reference/Result/Stem/Angle			/root/Component/Stem/Angle			\
																/root/Reference/Result/Stem/Length			/root/Component/Stem/Length			\
																/root/Reference/Result/WheelPosition/Front	/root/Custom/WheelPosition/Front	\
																/root/Reference/Result/WheelPosition/Rear	/root/Custom/WheelPosition/Rear   ] \
							{
									# puts "  $xpath $value"
									set reference		[$domConfig selectNodes $xpath/value/text()]
									set referenceValue 	[$reference asText]
									
									set personal 		[$domConfig selectNodes $xpathPersonal/text()]
									$personal nodeValue [format "%.2f" $referenceValue]
							}						

			
			
			set ::APPL_Update			[ clock milliseconds ]
			frame_geometry_custom::set_base_Parameters $domConfig
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
				# ---  get border outside content to Stage		
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
				set BtmBracket_y		[ expr $cvBorder + 5 ] 
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
		#  create ProjectEdit Widget
 	proc createEdit { x y cv_Name updateCommand xpathList {title {Edit:}}} {
			variable _update
			variable _updateValue
			
			# --- local procedures ---
				proc create_ValueEdit {cv cv_Name cvEdit cvContentFrame index labelText textVar updateCommand xpath} {					
						#
						# --- create cvLabel, cvEntry ---
							set	cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
							set cvEntry [entry  $cvContentFrame.value_${index} -textvariable $textVar  -justify right  -relief sunken -bd 1  -width 10]
							if {$index == {oneLine}} {
								set	cvClose [button $cvContentFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
								grid	$cvLabel $cvEntry $cvClose  -sticky news
							} else {	
								grid	$cvLabel $cvEntry -sticky news
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
								frame_geometry_reference::set_base_Parameters $domDoc
								update
								after $_update(delay)
								$updateCommand $cv_Name
							}
						} else {
							while {$loopValue > $newValue } {
								set loopValue [ expr $loopValue + $gap ]
									puts "      --> $loopValue"
								$node nodeValue $loopValue
								frame_geometry_reference::set_base_Parameters $domDoc
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
			frame_geometry_reference::set_base_Parameters $domDoc
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

       proc ___bind_parent_move {toplevel_widget parent} {
            ::Debug  p  1
            if {![winfo exists $toplevel_widget]} return
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
       }
      
       proc ___closeSelectBox {source_window  target_var  cv_Name  updateCommand  xpath  cvEntry} {
            
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
 	#-------------------------------------------------------------------------
		#  return project attributes
	proc ___project_attribute {attribute } {
			variable Project
			return $Project($attribute)
	}

 	#-------------------------------------------------------------------------
		#  add vector to list of coordinates
 	proc ___coords_flip_y {coordlist} {
			set returnList {}
			foreach {x y} $coordlist {
				set new_y [expr -$y]
				set returnList [lappend returnList $x $new_y]
			}
			return $returnList
	} 

 	#-------------------------------------------------------------------------
		#  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
 	proc ___coords_get_xy {coordlist index} {
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


 
 }  

