 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_project.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/11/26
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
 #	namespace:  rattleCAD::lib_project
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval lib_project {

   
	#-------------------------------------------------------------------------
		#  check File Version 3.1 -> 3.2
		#	
	proc check_ProjectVersion {Version} {
	
			set domProject $::APPL_Project
			puts " ... check_ProjectVersion:  $Version"
			
			switch -exact $Version {
			
				{3.1} {		set node {}
								# --- /root/Personal/SeatTube_Length
							set node [$domProject selectNode /root/Personal/SeatTube_Length]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Personal/SeatTube_Length"
								set LegLength [expr 0.88 * [[$domProject selectNode /root/Personal/InnerLeg_Length] asText ] ]
								set node [$domProject selectNode /root/Personal]
								$node appendXML "<SeatTube_Length>$LegLength</SeatTube_Length>"
							}
							
								# --- /root/Result
							set node [$domProject selectNode /root/Result]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Result"
								set node [$domProject selectNode /root]
								$node appendXML "<Result>
													<HeadTube>
														<ReachLength>0.00</ReachLength>
														<StackHeight>0.00</StackHeight>
														<Angle>0.00</Angle>
													</HeadTube>
													<SeatTube>
														<TubeLength>0.00</TubeLength>
														<TubeHeight>0.00</TubeHeight>
													</SeatTube>
													<Saddle>
														<Offset_BB>
															<horizontal>0.00</horizontal>
														</Offset_BB>
													</Saddle>
													<WheelPosition>
														<front>
															<horizontal>0.00</horizontal>
														</front>
														<rear>
															<horizontal>0.00</horizontal>
														</rear>
													</WheelPosition>
												</Result>"
							}
							
								# --- /root/Rendering
							set node [$domProject selectNode /root/Rendering]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering"
								set node [$domProject selectNode /root]
								$node appendXML "<Rendering>
													<Fork>SteelLugged</Fork>
												</Rendering>"
							}	
							
						}
						
				{3.2.20} {	set node {}								
								# --- /root/Result/HeadTube/TopTubeAngle
							set node [$domProject selectNode /root/Result/HeadTube/TopTubeAngle]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Result/HeadTube/TopTubeAngle"
								set node [$domProject selectNode /root/Result/HeadTube]
								$node appendXML "<TopTubeAngle>0.00</TopTubeAngle>"
							}
						}
						
				{3.2.22} {	set node {}								
								# --- /root/Component/BottleCage
							set node [$domProject selectNode /root/Component/BottleCage]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Component/BottleCage"
								set node [$domProject selectNode /root/Component]
								puts "  [$node asXML]"
								$node appendXML "<BottleCage>
													<SeatTube>
														<File>etc:bottle_cage/left/bottleCage.svg</File>
														<OffsetBB>150.00</OffsetBB>
													</SeatTube>
													<DownTube>
														<File>etc:bottle_cage/right/bottleCage.svg</File>
														<OffsetBB>210.00</OffsetBB>
													</DownTube>
													<DownTube_Lower>
														<File>etc:bottle_cage/left/bottleCage.svg</File>
														<OffsetBB>150.00</OffsetBB>
													</DownTube_Lower>
												</BottleCage>"
								set node [$domProject selectNode /root/Component/BottleCage]
								puts "  [$node asXML]"
							}
							
								# --- /root/Rendering/BottleCage ...
							set node [$domProject selectNode /root/Rendering/BottleCage]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering/BottleCage"
								set node [$domProject selectNode /root/Rendering]
								$node appendXML "<BottleCage>
													<SeatTube>Cage</SeatTube>
													<DownTube>Cage</DownTube>
													<DownTube_Lower>off</DownTube_Lower>
												</BottleCage>"
							}  
						}
										
				{3.2.23} {	set node {}								
								# --- /root/Rendering/Brake ...
							set node [$domProject selectNode /root/Rendering/Brakes]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering/Brakes"
								set parentNode [$node parentNode]
								$parentNode removeChild $node
							}
							
								# --- /root/Rendering/Brake ...
							set node [$domProject selectNode /root/Rendering/Brake]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering/Brake"
								set node [$domProject selectNode /root/Rendering]
								$node appendXML "<Brake>
													<Front>Road</Front>
													<Rear>Road</Rear>
												</Brake>"
							}  
						}
				{3.2.28} {	set node {}								
								# --- /root/Result ...
							set node [$domProject selectNode /root/Result]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Result"
								foreach childNode [ $node childNodes ] {
									$node removeChild $childNode
								}
							}
								# --- /root/Result/Tubes ...
							set node [$domProject selectNode /root/Result/Tubes]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Result/Tubes"
								set node [$domProject selectNode /root/Result]
								$node appendXML "<Tubes/>"
								set node [$domProject selectNode /root/Result/Tubes]
								foreach tubeName { SeatTube HeadTube DownTube TopTube Steerer ChainStay SeatStay ForkBlade } {
									$node appendXML "<$tubeName>
															<Direction>
																<polar>0.00,0.00</polar>
																<degree>0.00</degree>
																<radiant>0.00</radiant>
															</Direction>
															<Start>0.00,0.00</Start>
															<End>0.00,0.00</End>
															<Polygon>0.00,0.00</Polygon>
														</$tubeName>"
								}
								puts "        ...  $Version   ... update File ... /root/Result/Tubes/.../BottleCage"
								set bottleCageXML "<BottleCage>
														<Base>0.00,0.00</Base>
														<Offset>0.00,0.00</Offset>
													</BottleCage>"								
								set childNode [$domProject selectNode /root/Result/Tubes/SeatTube]
								$childNode appendXML $bottleCageXML
								set childNode [$domProject selectNode /root/Result/Tubes/DownTube]
								$childNode appendXML $bottleCageXML
								$childNode appendXML "<BottleCage_Lower>
														<Base>0.00,0.00</Base>
														<Offset>0.00,0.00</Offset>
													</BottleCage_Lower>"
								puts "        ...  $Version   ... update File ... /root/Result/Tubes/ChainStay/SeatStay_IS"
								set node [$domProject selectNode /root/Result/Tubes/ChainStay]
								$node appendXML "<SeatStay_IS>0.00,0.00</SeatStay_IS>"
							}
							
								# --- /root/Result/Lugs ...
							set node [$domProject selectNode /root/Result]
								puts "        ...  $Version   ... update File ... /root/Result/Lugs"
								$node appendXML "<Lugs>
													<Dropout>
														<Rear>
															<Position>0.00,0.00</Position>
															<Direction>
																<polar>0.00,0.00</polar>
																<degree>0.00</degree>
																<radiant>0.00</radiant>
															</Direction>			
															<Derailleur>0.00,0.00</Derailleur>
														</Rear>
														<Front>
															<Position>0.00,0.00</Position>
															<Direction>
																<polar>0.00,0.00</polar>
																<degree>0.00</degree>
																<radiant>0.00</radiant>
															</Direction>			
														</Front>
													</Dropout>
													<ForkCrown>
														<Position>0.00,0.00</Position>
														<Direction>
															<polar>0.00,0.00</polar>
															<degree>0.00</degree>
															<radiant>0.00</radiant>
														</Direction>			
													</ForkCrown>
												</Lugs>"
												
								# --- /root/Result/Components ...
							set node [$domProject selectNode /root/Result]
								puts "        ...  $Version   ... update File ... /root/Result/Components"
								$node appendXML "<Components>
													<SeatPost>
														<Polygon>0.00,0.00</Polygon>
													</SeatPost>
													<Stem>
														<Polygon>0.00,0.00</Polygon>
													</Stem>
													<HeadSet>
														<Bottom>
															<Polygon>0.00,0.00</Polygon>
														</Bottom>
														<Top>
															<Polygon>0.00,0.00</Polygon>
														</Top>
													</HeadSet>
												</Components>"
												
								# --- /root/Result/Position ...
							set node [$domProject selectNode /root/Result]
								puts "        ...  $Version   ... update File ... /root/Result/Position"
								$node appendXML "<Position>
													<BottomBracket>0.00,0.00</BottomBracket>
													<FrontWheel>0.00,0.00</FrontWheel>
													<RearWheel>0.00,0.00</RearWheel>
													<Saddle>0.00,0.00</Saddle>
													<SaddleProposal>0.00,0.00</SaddleProposal>
													<HandleBar>0.00,0.00</HandleBar>
													<LegClearance>0.00,0.00</LegClearance>
													<BottomBracketGround>0.00,0.00</BottomBracketGround>
													<SteererGround>0.00,0.00</SteererGround>
													<SeatTubeGround>0.00,0.00</SeatTubeGround>
													<BrakeMountFront>0.00,0.00</BrakeMountFront>
													<BrakeMountRear>0.00,0.00</BrakeMountRear>
													<SummarySize>0.00,0.00</SummarySize>
												</Position>"
												
								# --- /root/Result/TubeMitter ...
							set node [$domProject selectNode /root/Result]
								puts "        ...  $Version   ... update File ... /root/Result/Position"
								$node appendXML "<TubeMitter>
													<TopTube_Head>
														<Polygon>0.00,0.00</Polygon>
													</TopTube_Head> 
													<TopTube_Seat>
														<Polygon>0.00,0.00</Polygon>
													</TopTube_Seat> 
													<DownTube_Head>
														<Polygon>0.00,0.00</Polygon>
													</DownTube_Head>			
													<SeatStay_01>
														<Polygon>0.00,0.00</Polygon>
													</SeatStay_01> 	
													<SeatStay_02>
														<Polygon>0.00,0.00</Polygon>
													</SeatStay_02> 	
													<Reference>
														<Polygon>0.00,0.00</Polygon>
													</Reference> 	
												</TubeMitter>"
							
								# --- /root/Temporary ...
							set node [$domProject selectNode /root/Temporary]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary"
								set node [$domProject selectNode /root]
								$node appendXML "<Temporary>
													<HeadTube>
														<ReachLength>0.00</ReachLength>
														<StackHeight>0.00</StackHeight>
														<Angle>0.00</Angle>
														<TopTubeAngle>0.00</TopTubeAngle>
													</HeadTube>
													<SeatTube>
														<TubeLength>0.00</TubeLength>
														<TubeHeight>0.00</TubeHeight>
													</SeatTube>
													<Saddle>
														<Offset_BB>
															<horizontal>0.00</horizontal>
														</Offset_BB>
													</Saddle>
													<WheelPosition>
														<front>
															<horizontal>0.00</horizontal>
														</front>
														<rear>
															<horizontal>0.00</horizontal>
														</rear>
													</WheelPosition>
												</Temporary>"
								puts "[$node asXML]"				
							}

						}			
				{3.2.32} {	set node {}	
								# --- /root/Temporary/BottomBracket ...
							set node [$domProject selectNode /root/Temporary/BottomBracket]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary/BottomBracket"
								set node [$domProject selectNode /root/Temporary]
								$node appendXML "<BottomBracket>
														<Height>0.00</Height>
												</BottomBracket>"
							}

 						}	
				{3.2.40} {	set node {}	
								# --- /root/Custom/HeadTube/Angle ...
							$domProject selectNode /root/Temporary/WheelPosition/front/diagonal
							
							set node [$domProject selectNode /root/Temporary/WheelPosition/front/diagonal]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary/WheelPosition/front/diagonal"
								set node [$domProject selectNode /root/Temporary/WheelPosition/front]
								$node appendXML "<diagonal>0.00</diagonal>"
							}
							
							set node [$domProject selectNode /root/Temporary/TopTube/VirtualLength]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary/TopTube/VirtualLength"
								set node [$domProject selectNode /root/Temporary]
								$node appendXML "<TopTube>
													<VirtualLength>0.00</VirtualLength>
												</TopTube>"
							}
													set node [$domProject selectNode /root/Custom/HeadTube/Angle]
							if {$node == {}} {
									# ... node does not exist
								puts "        ...  $Version   ... update File ... /root/Custom/HeadTube/Angle"
								set nodeTA [$domProject selectNode /root/Temporary/HeadTube/Angle/text()]
								if {$nodeTA == {}} {
										# ... no temporary informtion, take a default
										set HeadTubeAngle	"73.50"
										$nodeTA nodeValue	$HeadTubeAngle
										tk_messageBox -icon warning -message "... you try to open a file of an older Version\n\n... please check HeadTube-Angle! \n\n  default: $HeadTubeAngle\n  WheelPositionFront: $WheelPositionFront"
								} else {
										# ... temporary informtion, take this
										set HeadTubeAngle [$nodeTA nodeValue]
										set nodeHT [$domProject selectNode /root/Temporary/HeadTube/Angle/text()]
										set HeadTubeAngle [$nodeTA nodeValue]
										set node [$domProject selectNode /root/Custom/HeadTube]
										if { $HeadTubeAngle > 20 } {
											# ... $HeadTubeAngle in a valid range
											$node appendXML "<Angle>$HeadTubeAngle</Angle>"
										} else {
											# ... $HeadTubeAngle in an invalid range
											$node appendXML "<Angle>73.50</Angle>"
											set nodeWP [$domProject selectNode /root/Custom/WheelPosition]
											set nodeWP [$domProject selectNode /root/Custom/WheelPosition/Front/text()]
											if { $nodeWP != {} } {
												set WheelPositionFront [$nodeWP nodeValue]
												$nodeTA nodeValue $HeadTubeAngle
												puts "  ... correction WheelPosition/Front: $WheelPositionFront"
												frame_geometry::set_base_Parameters $domProject
												frame_geometry::set_projectValue Temporary/WheelPosition/front/diagonal $WheelPositionFront update
												puts "  ... correction WheelPosition/Front: $WheelPositionFront"
											}
										}
											
											
								}
							}
							# set node [$domProject selectNode /root/Custom/HeadTube]
							# puts "   <D> 9999 \n[$node asXML]"
								
 						}

						
				{ab-xy} {	set node {}
							set node [$domProject selectNode /root/Project/rattleCADVersion/text()]
							puts " ... [$node nodeValue] .."
							puts " ... [$node asText] .."
							$node nodeValue [format "%s.%s" $::APPL_Env(RELEASE_Version) $::APPL_Env(RELEASE_Revision)] 
							return
						}

				default {}
			}
	}


	#-------------------------------------------------------------------------
		#  set value
		#
	proc setValue {xPath type args} {
	
			set domProject $::APPL_Project
			
				# puts " ... setValue:  $xPath"
				# puts "                $type"
				# puts "                $args"
			
				# -- Exception on different types of direction definitions
			switch -exact $type {
					direction 	{	
									if { [file tail $xPath] != {polar} } {
										set xPath 	[file join $xPath polar] 
									}
								}
					polygon 	{	
									if { [file tail $xPath] != {Polygon} } {
										set xPath 	[file join $xPath Polygon] 
									}
								}
			}
			
			set node	[$domProject selectNodes $xPath/text()]
			if { $node == {} } {
				puts "\n"
				puts "         --<E>--setValue----------------------------"
				puts "             ... $xPath not found in document"
				puts "         --<E>--setValue----------------------------"
				puts "\n"
				return
			}
			switch -exact $type {
					value 		{	
									$node nodeValue [lindex $args 0] 
								}
					direction 	{	
										# puts "\n   ... direction\n         ... $xPath\n  ______________________"
										# puts "            $args"
									set value 	[ flatten_nestedList [ flatten_nestedList $args ]]
										# puts "            $value"
									if {[llength $value] == 2} {
										set p0	{0 0} 
										set p1	[list [lindex $value 0] [lindex $value 1] ]
									} else {
										set p0	[list [lindex $value 0] [lindex $value 1] ]
										set p1	[list [lindex $value 2] [lindex $value 3] ]
									}
									set value	[ vectormath::unifyVector	$p0 $p1]
									set value	[format "%f,%f" [lindex $value 0] [lindex $value 1]] 
									$node nodeValue $value	
									
										# --- set angular Value - degree
									set angleDegree 0
									set xPath 	[file join [ file dirname $xPath ] degree]
									set node 	[$domProject selectNodes $xPath/text()]
									if { $node != {} } {
										set angleDegree	[format "%.9f" [ vectormath::dirAngle {0 0} $p1] ]
										$node nodeValue $angleDegree
									}
										# --- set angular Value - radiant
									set angleRadiant 0
									set xPath 	[file join [ file dirname $xPath ] radiant]
									set node 	[$domProject selectNodes $xPath/text()]
									if { $node != {} } {
											# puts "     angleDegree   $angleDegree"
										set angleRadiant	[format "%.9f" [ vectormath::rad $angleDegree] ]
											# puts "     angleRadiant  $angleRadiant"
										$node nodeValue $angleRadiant
									}
								}
					position 	{	
									set value	[ flatten_nestedList $args ]	
									$node nodeValue [format "%f,%f" [lindex $value 0] [lindex $value 1]] 
								}
					polygon 	{	
									set value {}
									foreach {x y} [flatten_nestedList $args] {
											# puts "             $x $y"
										append value [format "%f,%f " $x $y]
									}
									$node nodeValue $value
								}
					default		{	
									puts "         --<E>--setValue----------------------------"
									puts "             ... $type ... unhandled"
									puts "         --<E>--setValue----------------------------"
									puts "     ... $type ... unhandled"
								}
			}

	}
		
	#-------------------------------------------------------------------------
		#  get value
		#
	proc getValue {xPath type args} {
	
			set domProject $::APPL_Project
			
				# puts " ... getValue:  $xPath"
				# puts "                $type"
				# puts "                $args"
			
				# -- Exception on different types of direction definitions
			switch -exact $type {
					direction 	{	
									if { [file tail $xPath] != {polar} } {
										set xPath 	[file join $xPath polar] 
									}
								}
			}
			
			set node	[$domProject selectNodes $xPath/text()]
			if { $node == {} } {
				puts "\n"
				puts "         --<E>--getValue----------------------------"
				puts "             ... $xPath not found in document"
				puts "         --<E>--getValue----------------------------"
				puts "\n"
				return
			}
			switch -exact $type {
					value 		{	set value [$node nodeValue] }
					direction 	{	if {[llength $args] == 0} {
										set value [$node nodeValue]
									} else {
										if {[lindex $args 0] == {angle} } {
											puts "   \n .... will become continued \n" 									 
											set value 0.0123
										}
									}
								}
					position 	{	if {[llength $args] == 0} {
										set value [$node nodeValue]
									} else {
										set value [$node nodeValue]
										set value [lindex [split $value ,] [lindex $args 0] ]
									}
								}
					polygon 	{	if {[llength $args] == 0} {
										set value [$node nodeValue]
									} else {									
										set value [$node nodeValue]
											# puts "      ......... $value"
										set value [lindex [split $value { }] [lindex $args 0] ]
											# puts "      ......... $value"
									}
								}
			}
			return $value
			
			
			#set node [$::APPL_Project selectNode /root/Result/HeadTube/TopTubeAngle]

	}
	
	#-------------------------------------------------------------------------
		# see  http://wiki.tcl.tk/440
		#
	proc flatten_nestedList { args } {
			if {[llength $args] == 0 } { return ""}
			set flatList {}
			foreach e [eval concat $args] {
				foreach ee $e { lappend flatList $ee }
			}
				# tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
			return $flatList
	}	
		
}

