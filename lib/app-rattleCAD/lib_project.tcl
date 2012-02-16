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
 #	namespace:  rattleCAD::project
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval project {

 
	#-------------------------------------------------------------------------
	proc get_xPath {node} {
			variable xPath
			set xPath "[$node nodeName]"
			proc parentNode {node} {
					variable xPath
					#puts [$node nodeName]
					set node [$node parent]
					if {$node != {}} {
							set xPath "[$node nodeName]/$xPath"
							parentNode $node
					}
			}
			parentNode $node
			return "/$xPath"
	}
	#-------------------------------------------------------------------------
	proc add_tracing {} {
			trace add     variable [namespace current]::Personal 	write [namespace current]::trace_ProjectConfig
			trace add     variable [namespace current]::Custom   	write [namespace current]::trace_ProjectConfig
			trace add     variable [namespace current]::Lugs        write [namespace current]::trace_ProjectConfig
			trace add     variable [namespace current]::Component   write [namespace current]::trace_ProjectConfig
			trace add     variable [namespace current]::FrameTubes  write [namespace current]::trace_ProjectConfig
			trace add     variable [namespace current]::Rendering   write [namespace current]::trace_ProjectConfig
	}
	proc remove_tracing {} {
			trace remove  variable [namespace current]::Personal 	write [namespace current]::trace_ProjectConfig
			trace remove  variable [namespace current]::Custom   	write [namespace current]::trace_ProjectConfig
			trace remove  variable [namespace current]::Lugs       	write [namespace current]::trace_ProjectConfig
			trace remove  variable [namespace current]::Component   write [namespace current]::trace_ProjectConfig
			trace remove  variable [namespace current]::FrameTubes  write [namespace current]::trace_ProjectConfig
			trace remove  variable [namespace current]::Rendering   write [namespace current]::trace_ProjectConfig
	}
	#-------------------------------------------------------------------------
	proc trace_ProjectConfig {varname key operation} {
			if {$key != ""} {
					set varname ${varname}($key)
					}
			upvar $varname var
			
				puts "\n\n"
				puts "   --<trace>--------------------------"
				puts "    trace_ProjectConfig"
				puts "       varname:         $var"
				puts "       key:             $key"
				puts "       operation:       $operation"
                
                # tk_messageBox -message "trace_ProjectConfig: \n     varname:         $var \n     key:             $key \n     operation:       $operation"
			
			frame_geometry::set_base_Parameters
			cv_custom::update [lib_gui::current_canvasCAD]
			return

			#update
			# cv_custom::update  lib_gui::cv_Custom02
			catch {focus $cvEntry}
			catch {$cvEntry selection range 0 end}
	}	
	#-------------------------------------------------------------------------
	proc dom_2_runTime {projectDOM} {
			
			remove_tracing
			
				puts "\n\n"
				puts "   -------------------------------"
                puts "    project::dom_2_runTime"
                
			foreach branch [[$projectDOM selectNodes /root] childNodes] {
					
						# puts "  NodeType:  [$branch nodeType]"
					if {[$branch nodeType] != {ELEMENT_NODE}} {
							continue
					}
					set branch_Name 	[$branch nodeName]
                    
                    puts "       branch_Name:     $branch_Name"

					set branch_xPath	[get_xPath $branch]
					set myArray $branch_Name
					array unset [namespace current]::$myArray
					
					foreach node [$branch getElementsByTagName *] {
								# puts "\n-----\n[$node nodeName][$node nodeValue]"
								# puts "\n-----\n[$node nodeName] [$node nodeType] -> [$node nodeValue]"
								# puts "\n-----\n[$node nodeName] [$node nodeType]"
								# puts "     [[$node firstChild] nodeType]  [[$node firstChild] asXML]"
							if {[[$node firstChild] nodeType] == {TEXT_NODE}} {
								set xPath [get_xPath $node]
								set xPath [string range $xPath [string length $branch_xPath/] end]
									# puts "----- [$node nodeType]: $xPath "
									# puts "\n-----\n   [$node nodeType]: $xPath "
									# puts "          -> [[$node firstChild] nodeValue]"
								set [format "%s::%s(%s)" [namespace current] $myArray $xPath] [[$node firstChild] nodeValue]
							}
					}
						#parray $myArray
			}
			
			add_tracing
	}
	#-------------------------------------------------------------------------
	proc runTime_2_dom {projectDOM} {
			
				puts "\n\n"
				puts "   -------------------------------"
				puts "    project::runTime_2_dom"
                
			foreach branch [[$projectDOM selectNodes /root] childNodes] {
					
					if {[$branch nodeType] != {ELEMENT_NODE}} {
							continue
					}
                    
					set branch_Name 	[$branch nodeName]
                    puts "       branch_Name:     $branch_Name"
					set branch_xPath	[get_xPath $branch]
					set myArray $branch_Name

					foreach node [$branch getElementsByTagName *] {
								# puts "\n-----\n[$node nodeName][$node nodeValue]"
								# puts "\n-----\n[$node nodeName] [$node nodeType] -> [$node nodeValue]"
								# puts "\n-----\n[$node nodeName] [$node nodeType]"
								# puts "     [[$node firstChild] nodeType]  [[$node firstChild] asXML]"
							if {[[$node firstChild] nodeType] == {TEXT_NODE}} {
								set xPath [get_xPath $node]
								set xPath [string range $xPath [string length $branch_xPath/] end]
									# puts "----- [$node nodeType]: $xPath "
									# puts "\n-----\n   [$node nodeType]: $xPath "
									# puts "          -> [[$node firstChild] nodeValue]"
									# puts " -> $xPath"
								set textNode [$node firstChild]
									# puts "      [$textNode asXML]"
								eval set value [format "$%s::%s(%s)" [namespace current] $myArray $xPath]
									# puts "      $value"
								$textNode nodeValue $value
							}
					}
			}
	}


	#-------------------------------------------------------------------------
		#  set value
		#
		# proc setValue {xPath type args} 
	proc setValue {arrayName type args} {
	
			set _array [lindex [split $arrayName (] 0]
			set _name [lindex [split $arrayName ()] 1]
			
				# -- Exception on different types of direction definitions
			switch -exact $type {
					direction 	{	
									if { [file tail $_name] != {polar} } {
										set _name 	[file join $_name polar] 
									}
								}
					polygon 	{	
									if { [file tail $_name] != {Polygon} } {
										set _name 	[file join $_name Polygon] 
									}
								}
			}
			
				# set domProject $::APPL_Env(root_ProjectDOM)			
				# set node	[$domProject selectNodes /root/$_array/$_name/text()]
				# puts "  -> exist? ... [array names [namespace current]::$_array $_name]"
			set check_name [array names [namespace current]::$_array $_name]
			if { $check_name == {} } {
				puts "\n"
				puts "         --<E>--setValue----------------------------"
				puts "             ... $_name not found in [namespace current]::$_array"
				puts "         --<E>--setValue----------------------------"
				puts "\n"
				# eval parray [namespace current]::$_array
				return
			}

				# eval set value [format "$%s::%s(%s)" [namespace current] $_array $_name]
				# puts "            -> current value: $value \n"
			
			switch -exact $type {
					value 		{	
									eval set [format "%s::%s(%s)" [namespace current] $_array $_name] [lindex $args 0]
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
									#puts "  -- 01 --"
									eval set [format "%s::%s(%s)" [namespace current] $_array $_name] $value
									
										# --- set angular Value - degree
									set angleDegree 0
									set _name 	[file join [ file dirname $_name ] degree]
									set check_name [array names [namespace current]::$_array $_name]
									if { $check_name != {} } {
										set angleDegree	[format "%.9f" [ vectormath::dirAngle {0 0} $p1] ]
										#puts "  -- 02 --"
										eval set [format "%s::%s(%s)" [namespace current] $_array [file join [ file dirname $_name ] degree]] $angleDegree
									}
										# --- set angular Value - radiant
									set angleRadiant 0
									set _name 	[file join [ file dirname $_name ] radiant]
									set check_name [array names [namespace current]::$_array $_name]
									if { $check_name != {} } {
											# puts "     angleDegree   $angleDegree"
										set angleRadiant	[format "%.9f" [ vectormath::rad $angleDegree] ]
											# puts "     angleRadiant  $angleRadiant"
										#puts "  -- 03 --"
										eval set [format "%s::%s(%s)" [namespace current] $_array [file join [ file dirname $_name ] radiant]] $angleRadiant
									}
								}
					position 	{	
									set value	[ flatten_nestedList $args ]	
									#puts "  -- 04 --"
									eval set [format "%s::%s(%s)" [namespace current] $_array $_name] [format "%f,%f" [lindex $value 0] [lindex $value 1]]
								}
					polygon 	{	
									set value {}
									foreach {x y} [flatten_nestedList $args] {
											# puts "             $x $y"
										append value [format "%f,%f " $x $y]
									}
									#puts "  -- 05 --"
									eval set [format "%s::%s(%s)" [namespace current] $_array $_name] \"$value\"
								}
					default		{	
									puts "         --<E>--setValue----------------------------"
									puts "             ... $type ... unhandled"
									puts "         --<E>--setValue----------------------------"
									puts "     ... $type ... unhandled"
								}
			}
			
				# eval set value [format "$%s::%s(%s)" [namespace current] $_array $_name]
				# puts "            -> new value: $value \n"

	}
		
	#-------------------------------------------------------------------------
		#  get value
		#
		# proc getValue {xPath type args}
	proc getValue {arrayName type args} {
	
                # convert _array(_name) -> _array/_name
            set _array [lindex [split $arrayName (] 0]
			set _name  [lindex [split $arrayName ()] 1]
			set xPath  [format "%s/%s" $_array $_name]
			
				# -- Exception on different types of direction definitions
			switch -exact $type {
					direction 	{	
									if { [file tail $_name] != {polar} } {
										set _name 	[file join $_name polar] 
									}
								}
					polygon 	{	
									if { [file tail $_name] != {Polygon} } {
										set _name 	[file join $_name Polygon] 
									}
								}
			}

				# set domProject $::APPL_Env(root_ProjectDOM)			
				# set node	[$domProject selectNodes /root/$_array/$_name/text()]
				# puts "  -> exist? ... [array names [namespace current]::$_array $_name]"
			set check_name [array names [namespace current]::$_array $_name]
			if { $check_name == {} } {
				puts "\n"
				puts "         --<E>--getValue----------------------------"
				puts "             ... $_name not found in [namespace current]::$_array"
				puts "         --<E>--getValue----------------------------"
				puts "\n"
				return
			}
			
			eval set value [format "$%s::%s(%s)" [namespace current] $_array $_name]
				# puts "            -> current value: $value \n"
					
			switch -exact $type {
					value 		{}
					direction 	{	if {[llength $args] != 0} {
										if {[lindex $args 0] == {angle} } {
											puts "   \n .... will become continued \n" 									 
											set value 0.0123
										}
									}
								}
					position 	{	if {[llength $args] != 0} {
										set value [lindex [split $value ,] [lindex $args 0] ]
									}
								}
					polygon 	{	if {[llength $args] != 0} {
											# puts "      ......... $value"
										set value [lindex [split $value { }] [lindex $args 0] ]
											# puts "      ......... $value"
									}
								}
			}
			# puts "    ... return new: $value"
			return $value			
	}

 
	#-------------------------------------------------------------------------
		#  check File Version 3.1 -> 3.2
		#	
	proc check_ProjectVersion {Version} {
	
			set domProject $::APPL_Env(root_ProjectDOM)
			puts "   ... check_ProjectVersion:  $Version"
			
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
								# puts "        ...  $Version   ... update File ... /root/Result/HeadTube/TopTubeAngle"
								# set node [$domProject selectNode /root/Result/HeadTube]
								# $node appendXML "<TopTubeAngle>0.00</TopTubeAngle>"
							}
						}
						
				{3.2.22} {	set node {}								
								# --- /root/Component/BottleCage
							set node [$domProject selectNode /root/Component/BottleCage]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Component/BottleCage"
								set node [$domProject selectNode /root/Component]
								# puts "  [$node asXML]"
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
								# puts "  [$node asXML]"
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
							
								# --- /root/Component/Derailleur
							set node [$domProject selectNode /root/Component/Derailleur/Front]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Component/Derailleur"
								set oldNode [$domProject selectNode /root/Component/Derailleur/File/text()]
								# puts " ... asXML     [$oldNode asXML]"				
								# puts " ... nodeValue [$oldNode nodeValue]"				
								set value [file tail [$oldNode nodeValue]]
								set oldNode [$domProject selectNode /root/Component/Derailleur]
								set node 	[$domProject selectNode /root/Component]
								$node removeChild $oldNode 
								$oldNode delete 
								$node appendXML "<Derailleur>
													<Front>
														<File>etc:derailleur/front/campagnolo_qs.svg</File>
														<Distance>155.00</Distance>
														<Offset>12.00</Offset>
													</Front>
													<Rear>
														<File>etc:derailleur/rear/$value</File>
													</Rear>
												</Derailleur>"
								return
							}
							
							
						}
										
				{3.2.23} {	set node {}								
								# --- /root/Rendering/Brake ...
							set node [$domProject selectNode /root/Rendering/Brakes]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering/Brakes"
								set parentNode [$node parentNode]
								$parentNode removeChild $node
                                $node delete
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
                                        # -- cleanup /root/Result
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
													<DerailleurMountFront>0.00,0.00</DerailleurMountFront>
													<BrakeFront>0.00,0.00</BrakeFront>
													<BrakeRear>0.00,0.00</BrakeRear>
													<SummarySize>0.00,0.00</SummarySize>
												</Position>"
												
								# --- /root/Result/TubeMiter ...
							set node [$domProject selectNode /root/Result]
								puts "        ...  $Version   ... update File ... /root/Result/Position"
								$node appendXML "<TubeMiter>
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
												</TubeMiter>"
							
						}			
				{3.2.32} {	set node {}	
								# --- /root/Temporary/BottomBracket ...
							set node [$domProject selectNode /root/Temporary/BottomBracket]
							if {$node == {}} {
								#puts "        ...  $Version   ... update File ... /root/Temporary/BottomBracket"
								#set node [$domProject selectNode /root/Temporary]
								#$node appendXML "<BottomBracket>
								#						<Height>0.00</Height>
								#				</BottomBracket>"
							}

 						}	
				{3.2.40} {	set node {}	
								# --- /root/Custom/HeadTube/Angle ...
							#$domProject selectNode /root/Temporary/WheelPosition/front/diagonal
							
							# 3.2.71 
							set node [$domProject selectNode /root/Component/Brake/Front]
							if {$node != {}} {
								$node appendXML "<Offset>28.00</Offset>"
							}	
							set node [$domProject selectNode /root/Component/Brake/Rear]
							if {$node != {}} {
								$node appendXML "<Offset>30.00</Offset>"
							}	
                            
                            # 3.2.76
                            set node [$domProject selectNode /root/Result]
							if {$node != {}} {
								$node appendXML "<Length>
                                                    <HeadTube>
                                                        <ReachLength>0.00</ReachLength>
                                                        <StackHeight>0.00</StackHeight>
                                                    </HeadTube>
                                                    <TopTube>
                                                        <VirtualLength>0.00</VirtualLength>
                                                    </TopTube>
                                                    <SeatTube>
                                                        <TubeLength>0.00</TubeLength>
                                                        <TubeHeight>0.00</TubeHeight>
                                                    </SeatTube>
                                                    <Saddle>
                                                        <Offset_BB>0.00</Offset_BB>
                                                        <Offset_HB>0.00</Offset_HB>
                                                    </Saddle>
                                                    <BottomBracket>
                                                        <Height>0.00</Height>
                                                    </BottomBracket>
                                                    <FrontWheel>
                                                        <diagonal>600.00</diagonal>
                                                        <horizontal>0.00</horizontal>
                                                    </FrontWheel>
                                                    <RearWheel>
                                                        <horizontal>0.00</horizontal>
                                                    </RearWheel>
                                                 </Length>"
								$node appendXML "<Angle>
                                                    <HeadTube>
                                                        <TopTube>0.00</TopTube>
                                                        <DownTube>0.00</DownTube>
                                                    </HeadTube>
                                                    <SeatTube>
                                                        <TopTube>0.00</TopTube>
                                                        <SeatStay>0.00</SeatStay>
                                                    </SeatTube>
                                                    <BottomBracket>
                                                        <DownTube>0.00</DownTube>
                                                        <ChainStay>0.00</ChainStay>
                                                    </BottomBracket>
                                                    <SeatStay>
                                                        <ChainStay>0.00</ChainStay>
                                                    </SeatStay>
                                                </Angle>"
							}


							set node [$domProject selectNode /root/Custom/HeadTube/Angle]
							if {$node == {}} {
									# ... node does not exist
								puts "        ...  $Version   ... update File ... /root/Custom/HeadTube/Angle"
								set nodeTA [$domProject selectNode /root/Result/Angle/HeadTube/TopTube/text()]
								if {$nodeTA == {}} {
										# ... no temporary informtion, take a default
										set HeadTubeAngle	"73.50"
										$nodeTA nodeValue	$HeadTubeAngle
										tk_messageBox -icon warning -message "... you try to open a file of an older Version\n\n... please check HeadTube-Angle! \n\n  default: $HeadTubeAngle\n  WheelPositionFront: $WheelPositionFront"
								} else {
										# ... temporary informtion, take this
										set HeadTubeAngle [$nodeTA nodeValue]
										# 3.2.76 set nodeHT [$domProject selectNode /root/Temporary/HeadTube/Angle/text()]
										set nodeHT [$domProject selectNode /root/Result/Length/HeadTube/Angle/text()]
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
												puts "          ... correction WheelPosition/Front: $WheelPositionFront"
												frame_geometry::set_base_Parameters $domProject
												# 3.2.76 frame_geometry::set_projectValue Temporary/WheelPosition/front/diagonal $WheelPositionFront update
												frame_geometry::set_projectValue Result/Length/FrontWheel/diagonal $WheelPositionFront update
												puts "          ... correction WheelPosition/Front: $WheelPositionFront"
											}
										}
								}
							}
							# set node [$domProject selectNode /root/Custom/HeadTube]
							# puts "   <D> 9999 \n[$node asXML]"
								
 						}
				{3.2.63} {	set node {}			
							set oldNode [$domProject selectNode /root/Custom/WheelPosition/Front]
							if {$oldNode != {}} {
								puts "        ...  $Version   ... update File ... /root/Custom/WheelPosition/Front"
								set node 	[$domProject selectNode /root/Custom/WheelPosition]
								$node removeChild $oldNode 
								$oldNode delete
							}
						}
				{3.2.71} {	set node {}			
							set node [$domProject selectNode /root/Result/Position]
							foreach child {BrakeShoeFront BrakeShoeRear BrakeMountFront BrakeMountRear } {
									set removeNode [$domProject selectNode /root/Result/Position/$child]
									if {$removeNode != {}} {
										$node removeChild $removeNode 
										$removeNode delete
									}
							}
                            if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Result/Position/"							
                                $node appendXML "<BrakeFront>0,0</BrakeFront>"
                                $node appendXML "<BrakeRear>0,0</BrakeRear>"
                            }
							
							foreach child {Front Rear} {
									set node [$domProject selectNode /root/Rendering/Brake/$child]
									if {$node != {}} {
										set txtNode [$node firstChild] 
										set value	[$txtNode nodeValue]
										if {$value == "Road"} {
											# puts "\n   ... dawischt\n"
											puts "        ...  $Version   ... update File ... /root/Rendering/Brake/$child"							
                                            $txtNode nodeValue "Rim"
										}
									}
							}
						}
				{3.2.74} {	set node {}							
							set node [$domProject selectNode /root/Component/Fork/Crown/Brake/OffsetPerp]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Component/Fork/Crown/Brake"
								set parentNode [$node parentNode]
								$parentNode removeChild $node
                                $node delete
							}
                        }
                       
				{3.2.76} {	set node {}							
							set node [$domProject selectNode /root/Lugs]
                            if {$node == {}} {                     
                                puts "        ...  $Version   ... update File ... /root/Lugs"
                                set node [$domProject selectNode /root]
                                $node appendXML "<Lugs>
                                                    <HeadTube>
                                                        <TopTube>
                                                            <Angle>
                                                                <value>73.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                        </TopTube>
                                                        <DownTube>
                                                            <Angle>
                                                                <value>61.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                        </DownTube>
                                                    </HeadTube>
                                                    <SeatTube>
                                                        <TopTube>
                                                            <Angle>
                                                                <value>76.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                        </TopTube>
                                                        <SeatStay>
                                                            <Angle>
                                                                <value>40.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                            <MiterDiameter>20.00</MiterDiameter>
                                                        </SeatStay>
                                                    </SeatTube>
                                                    <BottomBracket>
                                                        <DownTube>
                                                            <Angle>
                                                                <value>60.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                        </DownTube>
                                                        <ChainStay>
                                                            <Angle>
                                                                <value>64.00</value>
                                                                <plus_minus>1.00</plus_minus>
                                                            </Angle>
                                                        </ChainStay>
                                                    </BottomBracket>
                                                </Lugs>"

                                    # puts "  ... debug 3.2.76 - 01"
                                set node [$domProject selectNode /root/Lugs/SeatTube/SeatStay/MiterDiameter/text()]
                                    # puts " ... $node nodeValue .."
                                    # puts " ... [$node asXML] .."
                                    # puts " ... [$node nodeValue] .."
                                if {[$node nodeValue] == {20.00}} {
                                        puts "        ...  $Version   ... update File ... /root/Lugs/SeatTube/SeatStay/MiterDiameter"
                                        set resultNode [$domProject selectNode /root/FrameTubes/SeatTube/DiameterTT/text()]
                                        # puts "    ... [$resultNode nodeValue] .."
                                        $node nodeValue [$resultNode nodeValue]
                                }
                            }               
                
                            set node {}							
							set node [$domProject selectNode /root/Component/RearDropOut]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Lugs/RearDropOut"
								set parentNode [$node parentNode]
								$parentNode removeChild $node
                                set targetNode [$domProject selectNode /root/Lugs]
                                $targetNode appendChild $node
							}
                            
                            set node {}							
							set node [$domProject selectNode /root/Lugs/RearDropOut]
                            if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Lugs/RearDropOut/Angle"
                                $node appendXML "<Angle>
                                                    <value>67.00</value>
                                                    <plus_minus>1.00</plus_minus>
                                                </Angle>" 
                            }
                            
                            set node {}	
								# --- /root/Temporary ...
							set node [$domProject selectNode /root/Temporary]
							if {$node != {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary"
								set parentNode [$node parentNode]
								$parentNode removeChild $node
                                $node delete
							}

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

