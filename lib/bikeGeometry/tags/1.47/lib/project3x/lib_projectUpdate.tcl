 ##+##########################################################################
 #

    #-------------------------------------------------------------------------
        #  check File Version 3.1 -> 3.2
        # 
        #    brings to Project Settings to the current Prerequisits of 
        #        the library
        #
    proc project::update_Project {} {
            
            variable postUpdate ;# this dict will be returned at the end
            variable projectDOM
            foreach key [dict keys $postUpdate] {
                dict unset $postUpdate $key ;   # clear the dict
            }

            set project_Version  [[$projectDOM selectNodes /root/Project/rattleCADVersion/text()] asXML]
            # puts "   -> \$project_Version $project_Version"
            
                    puts "\n"
                    puts "   -------------------------------"
                    puts "    project::update_Project"
                    puts ""
                    puts "         project_Version:  $project_Version \n"
            
            if { $project_Version < 3.2 } {    
                        #
                    puts "\n\n       -- 3.1.xx -----------"
                        #
                    project::update_ProjectVersion {3.1}
            }
            if { $project_Version < 3.3 } {    
                        #
                     puts "\n\n       -- 3.2.xx -----------"
                        #
                    project::update_ProjectVersion {3.2.22}
                    project::update_ProjectVersion {3.2.23}
                    project::update_ProjectVersion {3.2.28}
                    project::update_ProjectVersion {3.2.32}
                    project::update_ProjectVersion {3.2.40}
                    project::update_ProjectVersion {3.2.63}
                    project::update_ProjectVersion {3.2.71}
                    project::update_ProjectVersion {3.2.74}
                    project::update_ProjectVersion {3.2.76}
                        #
                    project::update_ProjectVersion {3.3.00}
            } 
                # puts " -> $project_Version < 3.4"
            if { $project_Version < 3.4 } {    
                     puts "\n\n       -- 3.3.xx -----------"
                    project::update_ProjectVersion {3.3.02}
                    project::update_ProjectVersion {3.3.03}
                    project::update_ProjectVersion {3.3.04}
                    project::update_ProjectVersion {3.3.05}
                    project::update_ProjectVersion {3.3.06}
            }
            # puts " -> $project_Version < 3.5"
            if { $project_Version < 3.5 } {    
                     puts "\n\n       -- 3.4.xx -----------"
                    project::update_ProjectVersion {3.4.00}
                    project::update_ProjectVersion {3.4.01}
                    project::update_ProjectVersion {3.4.02}
            }
            
              # -- replace old result-Definition of projectXML with the newer one
            # update_projectResult
            
            return $postUpdate
    }               


    #-------------------------------------------------------------------------
        #  replace <Result> tag with definition of templates
        #    
    proc project::update_projectResult {} {
              # variable postUpdate
              # return
            variable projectDOM
            variable resultNode

                # puts [$resultNode asXML]
                # exit

            set oldNode [$projectDOM selectNode /root/Result]
            if {$oldNode != {}} {
                  # puts "                           ... update File ... /root/Result"
                set parentNode [$oldNode parentNode]
                    # --remove old ResultNode
                $parentNode removeChild $oldNode 
                $oldNode delete
                      # -- add new ResultNode
                        # set newNode [$domTemplate selectNode /root/Result]
                        # $parentNode appendXML [$newNode asXML]
                $parentNode appendXML [$resultNode asXML]
            } else {
                $projectDOM appendXML [$resultNode asXML]
            }
    } 

 
    #-------------------------------------------------------------------------
        #  update File from Version X.XX to current Schema
        #    
    proc project::update_ProjectVersion {Version} {
    
            variable postUpdate
            variable projectDOM
            variable resultNode
            
            puts "\n"
            puts "       -------------------------------"
            puts "          project::update_ProjectVersion"
            puts "             Version:   $Version"
            
            switch -exact $Version {
            
                {3.1} {		set node {}
                            # --- /root/Personal/SeatTube_Length
                        set node [$projectDOM selectNode /root/Personal/SeatTube_Length]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Personal/SeatTube_Length"
                            set LegLength [expr 0.88 * [[$projectDOM selectNode /root/Personal/InnerLeg_Length] asText ] ]
                            set node [$projectDOM selectNode /root/Personal]
                            $node appendXML "<SeatTube_Length>$LegLength</SeatTube_Length>"
                        }

                            # --- /root/Result
                        set node [$projectDOM selectNode /root/Result]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Result"
                            set node [$projectDOM selectNode /root]
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
                        set node [$projectDOM selectNode /root/Rendering]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Rendering"
                            set node [$projectDOM selectNode /root]
                            $node appendXML "<Rendering>
                                                <Fork>SteelLugged</Fork>
                                            </Rendering>"
                        }

                    }

                {3.2.20} {	set node {}
                            # --- /root/Result/HeadTube/TopTubeAngle
                        set node [$projectDOM selectNode /root/Result/HeadTube/TopTubeAngle]
                        if {$node == {}} {
                            # puts "                           ... update File ... /root/Result/HeadTube/TopTubeAngle"
                            # set node [$projectDOM selectNode /root/Result/HeadTube]
                            # $node appendXML "<TopTubeAngle>0.00</TopTubeAngle>"
                        }
                    }

                {3.2.22} {	set node {}
                            # --- /root/Component/BottleCage
                        set node [$projectDOM selectNode /root/Component/BottleCage]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Component/BottleCage"
                            set node [$projectDOM selectNode /root/Component]
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
                            set node [$projectDOM selectNode /root/Component/BottleCage]
                            # puts "  [$node asXML]"
                        }

                            # --- /root/Rendering/BottleCage ...
                        set node [$projectDOM selectNode /root/Rendering/BottleCage]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Rendering/BottleCage"
                            set node [$projectDOM selectNode /root/Rendering]
                            $node appendXML "<BottleCage>
                                                <SeatTube>Cage</SeatTube>
                                                <DownTube>Cage</DownTube>
                                                <DownTube_Lower>off</DownTube_Lower>
                                            </BottleCage>"
                        }  

                            # --- /root/Component/Derailleur
                        set node [$projectDOM selectNode /root/Component/Derailleur/Front]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Component/Derailleur"
                            set oldNode [$projectDOM selectNode /root/Component/Derailleur/File/text()]
                            # puts " ... asXML     [$oldNode asXML]"                
                            # puts " ... nodeValue [$oldNode nodeValue]"                
                            set value [file tail [$oldNode nodeValue]]
                            set oldNode [$projectDOM selectNode /root/Component/Derailleur]
                            set node     [$projectDOM selectNode /root/Component]
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
                        set node [$projectDOM selectNode /root/Rendering/Brakes]
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Rendering/Brakes"
                            set parentNode [$node parentNode]
                            $parentNode removeChild $node
                            $node delete
                        }

                            # --- /root/Rendering/Brake ...
                        set node [$projectDOM selectNode /root/Rendering/Brake]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Rendering/Brake"
                            set node [$projectDOM selectNode /root/Rendering]
                            $node appendXML "<Brake>
                                                <Front>Road</Front>
                                                <Rear>Road</Rear>
                                            </Brake>"
                        }
                    }
                {3.2.28} {	set node {}
                            # --- /root/Result ...
                        set node [$projectDOM selectNode /root/Result]
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Result"
                            foreach childNode [ $node childNodes ] {
                                    # -- cleanup /root/Result
                                $node removeChild $childNode
                            }
                        }
                            # --- /root/Result/Tubes ...
                        set node [$projectDOM selectNode /root/Result/Tubes]
                        if {$node == {}} {
                            puts "                           ... update File ... /root/Result/Tubes"
                            set node [$projectDOM selectNode /root/Result]
                            $node appendXML "<Tubes/>"
                            set node [$projectDOM selectNode /root/Result/Tubes]
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
                            puts "                           ... update File ... /root/Result/Tubes/.../BottleCage"
                            set bottleCageXML "<BottleCage>
                                                    <Base>0.00,0.00</Base>
                                                    <Offset>0.00,0.00</Offset>
                                                </BottleCage>"                                
                            set childNode [$projectDOM selectNode /root/Result/Tubes/SeatTube]
                            $childNode appendXML $bottleCageXML
                            set childNode [$projectDOM selectNode /root/Result/Tubes/DownTube]
                            $childNode appendXML $bottleCageXML
                            $childNode appendXML "<BottleCage_Lower>
                                                    <Base>0.00,0.00</Base>
                                                    <Offset>0.00,0.00</Offset>
                                                </BottleCage_Lower>"
                            puts "                           ... update File ... /root/Result/Tubes/ChainStay/SeatStay_IS"
                            set node [$projectDOM selectNode /root/Result/Tubes/ChainStay]
                            $node appendXML "<SeatStay_IS>0.00,0.00</SeatStay_IS>"
                        }

                            # --- /root/Result/Lugs ...
                        set node [$projectDOM selectNode /root/Result]
                            puts "                           ... update File ... /root/Result/Lugs"
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
                        set node [$projectDOM selectNode /root/Result]
                            puts "                           ... update File ... /root/Result/Components"
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
                        set node [$projectDOM selectNode /root/Result]
                            puts "                           ... update File ... /root/Result/Position"
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
                        set node [$projectDOM selectNode /root/Result]
                            puts "                           ... update File ... /root/Result/Position"
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
                        set node [$projectDOM selectNode /root/Temporary/BottomBracket]
                        if {$node == {}} {
                            #puts "                           ... update File ... /root/Temporary/BottomBracket"
                            #set node [$projectDOM selectNode /root/Temporary]
                            #$node appendXML "<BottomBracket>
                            #                        <Height>0.00</Height>
                            #                </BottomBracket>"
                        }

                    }
                {3.2.40} {	set node {}
                            # --- /root/Custom/HeadTube/Angle ...
                        #$projectDOM selectNode /root/Temporary/WheelPosition/front/diagonal
                        
                        # 3.2.71 
                        set node [$projectDOM selectNode /root/Component/Brake/Front]
                        if {$node != {}} {
                            $node appendXML "<Offset>28.00</Offset>"
                        }    
                        set node [$projectDOM selectNode /root/Component/Brake/Rear]
                        if {$node != {}} {
                            $node appendXML "<Offset>30.00</Offset>"
                        }

                        # 3.2.76
                        set node [$projectDOM selectNode /root/Result]
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


                        set node [$projectDOM selectNode /root/Custom/HeadTube/Angle]
                        if {$node == {}} {
                                # ... node does not exist
                            puts "                           ... update File ... /root/Custom/HeadTube/Angle"
                            set nodeTA [$projectDOM selectNode /root/Result/Angle/HeadTube/TopTube/text()]
                            if {$nodeTA == {}} {
                                    # ... no temporary informtion, take a default
                                    set HeadTubeAngle   "73.50"
                                    $nodeTA nodeValue   $HeadTubeAngle
                                    tk_messageBox -icon warning -message "... you try to open a file of an older Version\n\n... please check HeadTube-Angle! \n\n  default: $HeadTubeAngle\n  WheelPositionFront: $WheelPositionFront"
                            } else {
                                    # ... temporary informtion, take this
                                    set HeadTubeAngle [$nodeTA nodeValue]
                                    # 3.2.76 set nodeHT [$projectDOM selectNode /root/Temporary/HeadTube/Angle/text()]
                                    set nodeHT [$projectDOM selectNode /root/Result/Length/HeadTube/Angle/text()]
                                    set HeadTubeAngle [$nodeTA nodeValue]
                                    set node [$projectDOM selectNode /root/Custom/HeadTube]
                                    if { $HeadTubeAngle > 20 } {
                                        # ... $HeadTubeAngle in a valid range
                                        $node appendXML "<Angle>$HeadTubeAngle</Angle>"
                                    } else {
                                        # ... $HeadTubeAngle in an invalid range
                                        $node appendXML "<Angle>73.50</Angle>"
                                        set nodeWP [$projectDOM selectNode /root/Custom/WheelPosition]
                                        set nodeWP [$projectDOM selectNode /root/Custom/WheelPosition/Front/text()]
                                        if { $nodeWP != {} } {
                                            set WheelPositionFront [$nodeWP nodeValue]
                                            $nodeTA nodeValue $HeadTubeAngle
                                            puts "          ... correction WheelPosition/Front: $WheelPositionFront"
                                            bikeGeometry::update_Parameter $projectDOM
                                            # 3.2.76 bikeGeometry::set_projectValue Temporary/WheelPosition/front/diagonal $WheelPositionFront update
                                            bikeGeometry::set_projectValue Result/Length/FrontWheel/diagonal $WheelPositionFront update
                                            puts "          ... correction WheelPosition/Front: $WheelPositionFront"
                                        }
                                    }
                            }
                        }
                        # set node [$projectDOM selectNode /root/Custom/HeadTube]
                        # puts "   <D> 9999 \n[$node asXML]"

                    }
                {3.2.63} {	set node {}
                        set oldNode [$projectDOM selectNode /root/Custom/WheelPosition/Front]
                        if {$oldNode != {}} {
                            puts "                           ... update File ... /root/Custom/WheelPosition/Front"
                            set node     [$projectDOM selectNode /root/Custom/WheelPosition]
                            $node removeChild $oldNode 
                            $oldNode delete
                        }
                    }
                {3.2.71} {	set node {}
                        set node [$projectDOM selectNode /root/Result/Position]
                        foreach child {BrakeShoeFront BrakeShoeRear BrakeMountFront BrakeMountRear } {
                                set removeNode [$projectDOM selectNode /root/Result/Position/$child]
                                if {$removeNode != {}} {
                                    $node removeChild $removeNode 
                                    $removeNode delete
                                }
                        }
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Result/Position/"                            
                            $node appendXML "<BrakeFront>0,0</BrakeFront>"
                            $node appendXML "<BrakeRear>0,0</BrakeRear>"
                        }

                        foreach child {Front Rear} {
                                set node [$projectDOM selectNode /root/Rendering/Brake/$child]
                                if {$node != {}} {
                                    set txtNode [$node firstChild] 
                                    set value    [$txtNode nodeValue]
                                    if {$value == "Road"} {
                                        # puts "\n   ... dawischt\n"
                                        puts "                           ... update File ... /root/Rendering/Brake/$child"                            
                                        $txtNode nodeValue "Rim"
                                    }
                                }
                        }
                    }
                {3.2.74} {	set node {}
                        set node [$projectDOM selectNode /root/Component/Fork/Crown/Brake/OffsetPerp]
                        if {$node != {}} {
                                puts "                           ... update File ... /root/Component/Fork/Crown/Brake"
                                set parentNode [$node parentNode]
                                $parentNode removeChild $node
                                $node delete
                        }
                    }

                {3.2.76} {	set node {}
                        set node [$projectDOM selectNode /root/Lugs]
                        if {$node == {}} {                     
                            puts "                           ... update File ... /root/Lugs"
                            set node [$projectDOM selectNode /root]
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
                            set node [$projectDOM selectNode /root/Lugs/SeatTube/SeatStay/MiterDiameter/text()]
                                # puts " ... $node nodeValue .."
                                # puts " ... [$node asXML] .."
                                # puts " ... [$node nodeValue] .."
                            if {[$node nodeValue] == {20.00}} {
                                    puts "                           ... update File ... /root/Lugs/SeatTube/SeatStay/MiterDiameter"
                                    set resultNode [$projectDOM selectNode /root/FrameTubes/SeatTube/DiameterTT/text()]
                                    # puts "    ... [$resultNode nodeValue] .."
                                    $node nodeValue [$resultNode nodeValue]
                            }
                        }               
                
                        set node {}
                        set node [$projectDOM selectNode /root/Component/RearDropOut]
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Lugs/RearDropOut"
                            set parentNode [$node parentNode]
                            $parentNode removeChild $node
                            set targetNode [$projectDOM selectNode /root/Lugs]
                            $targetNode appendChild $node
                        }
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Lugs/RearDropOut]
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Lugs/RearDropOut/Angle"
                            $node appendXML "<Angle>
                                                <value>67.00</value>
                                                <plus_minus>1.00</plus_minus>
                                            </Angle>" 
                        }
                        
                        set node {}
                            # --- /root/Temporary ...
                        set node [$projectDOM selectNode /root/Temporary]
                        if {$node != {}} {
                            puts "                           ... update File ... /root/Temporary"
                            set parentNode [$node parentNode]
                            $parentNode removeChild $node
                            $node delete
                        }

                    }


                {3.3.00} {
                            #
                            # -- /root/Rendering
                            #
                        set parentNode [$projectDOM selectNode /root/Rendering]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Rendering/ChainStay]
                        if {$node == {}} {                     
                                puts "                           ... update File ... /root/Rendering/ChainStay"
                                $parentNode appendXML "       <ChainStay>straight</ChainStay>"
                        }
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Rendering/RearMockup]
                        if {$node == {}} {                     
                                puts "                           ... update File ... /root/Rendering/RearMockup"
                                $parentNode appendXML " <RearMockup>
                                                            <TyreClearance>5.00</TyreClearance>
                                                            <CrankClearance>5.00</CrankClearance>
                                                            <ChainWheelClearance>5.00</ChainWheelClearance>
                                                            <CassetteClearance>3.00</CassetteClearance>
                                                        </RearMockup>"
                        }
                            
                            #
                            # -- /root/FrameTubes/ChainStay
                            #
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay]
                            
                            set value(DiameterBB)  [[ $parentNode selectNode DiameterBB/text() ] nodeValue]
                            set value(DiameterSS)  [[ $parentNode selectNode DiameterSS/text() ] nodeValue]
                            set value(TaperLength) [[ $parentNode selectNode TaperLength/text()] nodeValue]

                        foreach node [$parentNode childNodes] {
                                $parentNode removeChild $node
                                $node delete                                    
                        }
                        
                        $parentNode appendXML "<HeightBB>$value(DiameterBB)</HeightBB>"
                        $parentNode appendXML "<Height>$value(DiameterBB)</Height>"
                        $parentNode appendXML "<DiameterSS>$value(DiameterSS)</DiameterSS>"
                        $parentNode appendXML "<TaperLength>$value(TaperLength)</TaperLength>"
                        $parentNode appendXML "<Width>18.00</Width>"
                        $parentNode appendXML "<WidthBB>18.00</WidthBB>"
                        $parentNode appendXML "<Bent>
                                                    <Base_00>
                                                        <Offset>120.00</Offset>
                                                        <OffsetPerp>0.00</OffsetPerp>
                                                    </Base_00>
                                                    <Base_DO>
                                                        <Offset>60.00</Offset>
                                                        <OffsetPerp>-7.00</OffsetPerp>
                                                    </Base_DO>
                                                    <Base_BB>
                                                        <Offset>90.00</Offset>
                                                        <OffsetPerp>5.00</OffsetPerp>
                                                    </Base_BB>
                                                </Bent>"                            
                        
                            #
                            # -- /root/Lugs/BottomBracket
                            #
                        set parentNode [$projectDOM selectNode /root/Lugs]
                                 
                        set node {}
                        set node [$parentNode selectNode BottomBracket]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Lugs/BottomBracket/.."
                                $node appendXML "<Diameter>
                                                    <outside>40.00</outside>
                                                    <inside>36.00</inside>
                                                </Diameter>"
                                $node appendXML "<Width>68.00</Width>"
                        }
                        
                        set node {}
                        set node [$parentNode selectNode BottomBracket/ChainStay]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Lugs/BottomBracket/ChainStay/Offset_TopView"
                                $node appendXML " <Offset_TopView>6.00</Offset_TopView>"
                        }
                        
                        set node {}
                        set node [$parentNode selectNode RearDropOut/ChainStay]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Lugs/RearDropOut/ChainStay/Offset_TopView"
                                $node appendXML "<Offset_TopView>5.00</Offset_TopView>"
                        }
                        
                        
                            #
                            # -- /root/Component
                            #
                        set parentNode [$projectDOM selectNode /root/Component]
                        
                            # -- /root/Component/Wheel/Rear
                            #
                        set node {}
                        set node [$parentNode selectNode Wheel/Rear]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Component/Wheel/Rear ..."
                                $node appendXML "<HubWidth>130.00</HubWidth>"
                                $node appendXML "<FirstSprocket>15</FirstSprocket>"
                        }
                        
                            # -- /root/Component/Saddle
                            #
                        set node {}
                        set node [$parentNode selectNode Saddle]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Component/Saddle/Height"
                                $node appendXML "<Height>40.00</Height>"
                        }
                        
                            # -- /root/Component/SeatPost
                            #
                        set node {}
                        set node [$parentNode selectNode SeatPost]
                        if {$node == {}} {                     
                                puts "                           ... update File ... /root/Component/SeatPost"
                                set value(DiameterSP)  [[ $parentNode selectNode Saddle/SeatPost/Diameter/text() ] nodeValue]
                                        
                                set nodeSP  [$parentNode selectNode Saddle/SeatPost]
                                if {$nodeSP != {}} {                     
                                        [$nodeSP parentNode ] removeChild $nodeSP
                                        $nodeSP delete
                                }
                                set nextNode [$parentNode selectNode CrankSet]
                                set newNode  [[$parentNode ownerDocument ] createElement SeatPost]
                                $parentNode insertBefore  $newNode  $nextNode
                                $newNode appendXML "<Setback>25.00</Setback>"
                                $newNode appendXML "<Diameter>27.20</Diameter>"
                        }
                        
                            # -- /root/Component/CrankSet
                            #
                        set node {}
                        set node [$parentNode selectNode CrankSet]
                        if {$node != {}} {                     
                                puts "                           ... update File ... /root/Component/CrankSet"
                                $node appendXML "<PedalEye>17.50</PedalEye>"
                                $node appendXML "<Q-Factor>145.50</Q-Factor>"
                                $node appendXML "<ArmWidth>13.75</ArmWidth>"
                                $node appendXML "<ChainLine>43.50</ChainLine>"
                                $node appendXML "<ChainRings>39-53</ChainRings>"
                       }
                       
                       
                            #
                            # -- /root/Personal
                            #
                        #set parentNode [$projectDOM selectNode /root/Result]
                        #    puts [$parentNode asXML]
                        #    set textValue           [[ $parentNode selectNode Position/Saddle/text() ] nodeValue]
                        #    set value(SD_Height)    [expr -1.0 * [lindex [split $textValue ,] 1]]
                        #    puts "  <D> $value(SD_Height) $textValue"
                        #    exit
 
                        set parentNode [$projectDOM selectNode /root/Personal]
                                puts "                           ... update File ... /root/Personal"
                            set value(ST_Angle)     [[ $parentNode selectNode SeatTube_Angle/text()  ] nodeValue]
                            set value(ST_Length)    [[ $parentNode selectNode SeatTube_Length/text() ] nodeValue]
                            set pt_01               [ vectormath::rotatePoint {0 0} [list $value(ST_Length) 0] $value(ST_Angle) ]
                            set value(SD_Height)    [lindex $pt_01 1]
                            
                            # puts "  <D> $value(ST_Angle) $value(ST_Length)"
                        foreach nodeName {SeatTube_Angle SeatTube_Length} {
                                set node    [$parentNode selectNode $nodeName]
                                $parentNode removeChild $node
                                $node delete                                    
                        }
                            
                        $parentNode appendXML   "<Saddle_Distance>200</Saddle_Distance>"
                        $parentNode appendXML   "<Saddle_Height>$value(SD_Height)</Saddle_Height>"
                        
                        
                            #
                            # -- /root/Result
                            #
                        set parentNode [$projectDOM selectNode /root/Result]
                                puts "                           ... update File ... /root/Result"
                        foreach node [$parentNode childNodes] {
                                $parentNode removeChild $node
                                $node delete                                    
                        } 
                        # -- 0.14 -- handled by update_projectResult
                            #set templateRoot    [ lib_file::get_XMLContent $::APPL_Config(TemplateInit)]
                            #set resultNode      [ $templateRoot selectNode /root/Result]
                            # puts "[$resultNode asXML]"
                        foreach child       [ $resultNode childNodes ] {
                                catch {$parentNode appendXML [$child asXML]}
                        }
                            
                        
                            #
                            # -- update values
                            #
                        dict set postUpdate     Result      Angle/SeatTube/Direction    $value(ST_Angle) 
                    }
                       
                                
                {3.3.02} {
                            #
                            # -- /root/Component/Saddle
                            #
                        set parentNode [$projectDOM selectNode /root/Component/Saddle]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Component/Saddle/Length]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Saddle/..."
                                $parentNode appendXML "<Length>280.00</Length>"
                                $parentNode appendXML "<LengthNose>153.00</LengthNose>"
                        }
                            
                            #
                            # -- /root/Length/Saddle
                            #
                        set parentNode [$projectDOM selectNode /root/Result/Length/Saddle]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Result/Length/Saddle/Offset_BB_Nose]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Result/Length/Saddle/Offset_BB_Nose"
                                $parentNode appendXML "<Offset_BB_Nose>0.00</Offset_BB_Nose>"
                        }
                        
                            #
                            # -- /root/Position/SaddleNose
                            #
                        set parentNode [$projectDOM selectNode /root/Result/Position]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Result/Position/SaddleNose]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Result/Position/SaddleNose"
                                $parentNode appendXML "<SaddleNose>0.00,0.00</SaddleNose>"
                        }
                    }                            
                {3.3.03} {
                            #
                            # -- /root/Result/Position/SeatTubeVirtualTopTube
                            #
                        set parentNode [$projectDOM selectNode /root/Result/Position]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Result/Position/SeatTubeVirtualTopTube]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Result/Position/SeatTubeVirtualTopTube"
                                $parentNode appendXML "<SeatTubeVirtualTopTube>0.00</SeatTubeVirtualTopTube>"
                        }
                            
                            #
                            # -- /root/Result/Length/SeatTube/VirtualLength
                            #
                        set parentNode [$projectDOM selectNode /root/Result/Length/SeatTube]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Result/Length/SeatTube/VirtualLength]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Result/Length/SeatTube/VirtualLength"
                                $parentNode appendXML "<VirtualLength>0.00</VirtualLength>"
                        }
                    }                            
                {3.3.04} {    
                            #
                            # -- /root/Result/Position/SeatTubeVirtualTopTube
                            #
                        set parentNode [$projectDOM selectNode /root/Custom/SeatTube]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Custom/SeatTube/OffsetBB]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Custom/SeatTube/OffsetBB"
                                $parentNode appendXML "<OffsetBB>0.00</OffsetBB>"
                        }

                             #
                            # -- /root/Component/Logo/File)
                            #
                        set parentNode [$projectDOM selectNode /root/Component]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Component/Logo/File]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Logo/File"
                                $parentNode appendXML "<Logo>
                                                            <File>etc:logo/rattleCAD.svg</File>
                                                       </Logo>"
                        }
                    }                            
                {3.3.05} {    
                            #
                            # -- /root/Lugs/RearDropOut/Direction
                            #
                        set parentNode [$projectDOM selectNode /root/Rendering]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Rendering/RearDropOut]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Rendering/RearDropOut"
                                $parentNode appendXML "<RearDropOut>behind</RearDropOut>"
                        }                            
                            #
                            # -- /root/Lugs/RearDropOut/Direction
                            #
                        set parentNode [$projectDOM selectNode /root/Lugs/RearDropOut]
                        
                        set node {}
                        set node [$projectDOM selectNode /root/Lugs/RearDropOut/Direction]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Lugs/RearDropOut/Direction"
                                $parentNode appendXML "<Direction>horizontal</Direction>"
                        }
                        set node {}
                        set node [$projectDOM selectNode /root/Lugs/RearDropOut/RotationOffset]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Lugs/RearDropOut/RotationOffset"
                                $parentNode appendXML "<RotationOffset>0.00</RotationOffset>"
                        }

                        set node {}
                        set node [$projectDOM selectNode /root/Lugs/RearDropOut/Derailleur/x/text()]
                        if {$node != {}} {
                                puts "                           ... update File ... /root/Lugs/RearDropOut/Derailleur/x"
                                set value [$node nodeValue]
                                $node nodeValue  [expr abs($value)]
                        }
                        set node [$projectDOM selectNode /root/Lugs/RearDropOut/Derailleur/y/text()]
                        if {$node != {}} {
                                puts "                           ... update File ... /root/Lugs/RearDropOut/Derailleur/y"
                                set value [$node nodeValue]
                                $node nodeValue  [expr abs($value)]
                        }
                            #
                            # -- /root/FrameTubes/ChainStay
                            #
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay]
                        set node [$projectDOM selectNode /root/FrameTubes/ChainStay/Bent]
                        if {$node != {}} {
                                puts "                           ... update File ... /root/FrameTubes/ChainStay/Bent"
                                $parentNode removeChild $node 
                                $node delete
                        }
                            #
                            # -- /root/FrameTubes/ChainStay/CenterLine
                            #
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay]
                        set node [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/FrameTubes/ChainStay/CenterLine"
                                $parentNode appendXML  "<CenterLine>
                                                          <length_01>150.00</length_01>
                                                          <length_02>140.00</length_02>
                                                          <length_03>75.00</length_03>
                                                          <length_04>10.00</length_04>
                                                          <angle_01>9.00</angle_01>
                                                          <angle_02>-5.00</angle_02>
                                                          <angle_03>0.00</angle_03>
                                                          <radius_01>320.00</radius_01>
                                                          <radius_02>320.00</radius_02>
                                                          <radius_03>320.00</radius_03>
                                                        </CenterLine>"
                        }
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine]
                        set node [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_04]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/FrameTubes/ChainStay/CenterLine"
                                $parentNode appendXML  "<length_04>10.00</length_04>"
                                $parentNode appendXML  "<angle_03>0.00</angle_03>"
                                $parentNode appendXML  "<radius_03>320.00</radius_03>"
                        }
                        
                            #
                            # -- /root/FrameTubes/ChainStay/Profile
                            #
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay]
                        set node [$projectDOM selectNode /root/FrameTubes/ChainStay/Profile/p01]
                        if {$node != {}} {
                                puts "                           ... update File ... selectNode /root/FrameTubes/ChainStay/Profile"
                                set removeNode [$projectDOM selectNode /root/FrameTubes/ChainStay/Profile]
                                $parentNode removeChild $removeNode 
                                $removeNode delete
                        }
                        set node [$projectDOM selectNode /root/FrameTubes/ChainStay/Profile]
                        if {$node == {}} {
                                puts "                           ... update File ... selectNode /root/FrameTubes/ChainStay/Profile"
                                $parentNode appendXML  "<Profile>              
                                                          <width_00>12.50</width_00>
                                                          <length_01>150.00</length_01>
                                                          <width_01>18.00</width_01>
                                                          <length_02>150.00</length_02>
                                                          <width_02>18.00</width_02>
                                                          <length_03>75.00</length_03>
                                                          <width_03>24.00</width_03>
                                                        </Profile>"
                        }
                            #
                            # -- /root/Rendering/RearMockup
                            #
                        set parentNode [$projectDOM selectNode /root/Rendering/RearMockup]
                        set node [$projectDOM selectNode /root/Rendering/RearMockup/DiscOffset]
                        if {$node == {}} {
                                puts "                           ... update File ... selectNode /root/Rendering/RearMockup/DiscOffset"
                                $parentNode appendXML  "<DiscOffset>15.30</DiscOffset>"
                        }
                        set node [$projectDOM selectNode /root/Rendering/RearMockup/DiscWidth]
                        if {$node == {}} {
                                puts "                           ... update File ... selectNode /root/Rendering/RearMockup/DiscWidth"
                                $parentNode appendXML  "<DiscWidth>2.00</DiscWidth>"
                        }
                        set node [$projectDOM selectNode /root/Rendering/RearMockup/DiscDiameter]
                        if {$node == {}} {
                                puts "                           ... update File ... selectNode /root/Rendering/RearMockup/DiscDiameter"
                                $parentNode appendXML  "<DiscDiameter>160.00</DiscDiameter>"
                        }
                        set node [$projectDOM selectNode /root/Rendering/RearMockup/DiscClearance]
                        if {$node == {}} {
                                puts "                           ... update File ... selectNode /root/Rendering/RearMockup/DiscClearance"
                                $parentNode appendXML  "<DiscClearance>5.00</DiscClearance>"
                        }
                        
                    }                            
                {3.3.06} {
                            # -- get Fork Type
                                puts "                           ... update File ... /root/Rendering/ForkBlade"
                                puts "                                           ... /root/Component/Fork/Blade"
                        set node [$projectDOM selectNode /root/Rendering/Fork/text()]
                            # puts [$node asXML]
                        if {$node != {}} {
                            set forkRendering [$node nodeValue]
                            puts "                                           ... $forkRendering"
                              # -- older rattleCAD-Files just defines "Suspension" as Fork-Rendering
                            if {$forkRendering == "Suspension"} {
                                set forkRendering "Suspension_26"
                                $node nodeValue $forkRendering
                            }
                            
                              # -- update ForkBlade default Parameter
                            set node_Blade      [$projectDOM selectNode /root/Component/Fork/Blade]
                              #
                            $node_Blade appendXML  "<BendRadius>350.0</BendRadius>"
                            $node_Blade appendXML  "<EndLength>10.0</EndLength>"
                            set node [$projectDOM selectNode /root/Component/Fork/Blade/Offset]
                            if {$node != {}} {
                                $node_Blade removeChild $node 
                                $node delete 
                            }
                            
                            
                              # -- update ForkBlade Rendering
                            set node_Crown      [$projectDOM selectNode /root/Component/Fork/Crown/File/text()]
                            set node_Rendering  [$projectDOM selectNode /root/Rendering]
                            set node_Blade      [$projectDOM selectNode /root/Rendering/ForkBlade]
                              #
                            if {$node_Blade == {}} {
                                  $node_Rendering appendXML "<ForkBlade>straight</ForkBlade>"
                            } else {
                                    # -- fix -------
                                    # http://sourceforge.net/p/rattlecad/tickets/2/
                                if {[llength $node_Blade] > 1} {
                                        # tk_messageBox -message " do hots wos"
                                    foreach node [lrange $node_Blade 1 end] {
                                        $node_Rendering removeChild $node
                                        $node delete
                                    }
                                }
                            }
                              # puts " -- 02 ----- [[$projectDOM selectNode /root/Rendering/ForkBlade] asXML]"
                            switch -exact $forkRendering {
                                SteelCustom -
                                SteelLugged {
                                        set forkCrown       [file tail [$node_Crown nodeValue]]
                                        set bladeRendering  [$projectDOM selectNode /root/Rendering/ForkBlade/text()]
                                        set forkBlade [$bladeRendering nodeValue]
                                            puts "                                           ... $forkCrown"
                                            puts "                                           ... $forkBlade"
                                        switch -exact $forkCrown {
                                            longshen_max_36_5.svg {
                                                    $bladeRendering nodeValue "MAX"
                                                }
                                            default {
                                                      #
                                                }
                                        }
                                    }
                                default {
                                        # $node_Blade appendXML "<ForkBlade>straight</ForkBlade>"
                                    }
                              }
                        }
                    }
                {3.4.00} {
                                # -- get Fork Dropout Rendering
                                puts "                           ... update File ... /root/Rendering/ForkDropOut"
                        set node_Rendering  [$projectDOM selectNode /root/Rendering]
                        set node            [$projectDOM selectNode /root/Rendering/ForkDropOut]
                                # puts [$node asXML]
                        if {$node == {}} {
                                puts "                                           ... front"
                            $node_Rendering appendXML  "<ForkDropOut>front</ForkDropOut>"
                        }
                        
                              # -- get 5th bent-Position for ChainStay
                        set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine]                        
                        set node       [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/angle_04]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/FrameTubes/ChainStay/CenterLine/angle_04"
                                $parentNode appendXML  "<angle_04>0.00</angle_04>"
                        }                        
                        set node       [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/radius_04]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/FrameTubes/ChainStay/CenterLine/radius_04"
                                $parentNode appendXML  "<radius_04>320.00</radius_04>"
                        }                        

                        
                                # -- get TyreWidth for ChainStay Details
                        set parentNode [$projectDOM selectNode /root/Component/Wheel/Rear]
                        set node       [$projectDOM selectNode /root/Component/Wheel/Rear/TyreWidth]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Wheel/Rear/TyreWidth"
                                set tyreHeight [[$projectDOM selectNode /root/Component/Wheel/Rear/TyreHeight/text()] nodeValue] 
                                $parentNode appendXML  "<TyreWidth>$tyreHeight</TyreWidth>"
                        }                        


                                # -- get TyreWidth for ChainStay Details
                        set parentNode [$projectDOM selectNode /root/Component/Wheel/Rear]
                        set node       [$projectDOM selectNode /root/Component/Wheel/Rear/TyreWidth]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Wheel/Rear/TyreWidth"
                                set tyreHeight [[$projectDOM selectNode /root/Component/Wheel/Rear/TyreHeight/text()] nodeValue] 
                                $parentNode appendXML  "<TyreWidth>$tyreHeight</TyreWidth>"
                        }                        
                    
                        
                                # -- get TyreWidthRadius for ChainStay Details
                        set parentNode [$projectDOM selectNode /root/Component/Wheel/Rear]
                        set node       [$projectDOM selectNode /root/Component/Wheel/Rear/TyreWidthRadius]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Wheel/Rear/TyreWidth"
                                set rimDiameter [[$projectDOM selectNode /root/Component/Wheel/Rear/RimDiameter/text()] nodeValue] 
                                set tyreHeight  [[$projectDOM selectNode /root/Component/Wheel/Rear/TyreHeight/text()]  nodeValue] 
                                set tyreRadius  [expr 0.5 * ($rimDiameter + $tyreHeight)]
                                $parentNode appendXML  "<TyreWidthRadius>$tyreRadius</TyreWidthRadius>"
                        }                        
            
                  
                                # -- get Rendering Saddle/Offset
                        set parentNode [$projectDOM selectNode /root/Rendering]
                        set node       [$projectDOM selectNode /root/Rendering/Saddle]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Rendering/Saddle"
                                $parentNode appendXML  "<Saddle>
                                                            <Offset_X>0.00</Offset_X>
                                                            <Offset_Y>0.00</Offset_Y>
                                                        </Saddle>"
                        }                        
    
                    
                                # -- get Rear Derailleur Details
                        set parentNode [$projectDOM selectNode /root/Component/Derailleur/Rear]
                        set node       [$projectDOM selectNode /root/Component/Derailleur/Rear/Pulley]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/Derailleur/Rear/Pulley"
                                $parentNode appendXML  "<Pulley>
                                                            <x>-8.00</x>
                                                            <y>79.00</y>
                                                            <teeth>10</teeth>
                                                        </Pulley>"
                        }  

                    
                                # -- get SeatPost PivotOffset
                        set parentNode [$projectDOM selectNode /root/Component/SeatPost]
                        set node       [$projectDOM selectNode /root/Component/SeatPost/PivotOffset]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Component/SeatPost/PivotOffset"
                                $parentNode appendXML  "<PivotOffset>40.00</PivotOffset>"
                                  #
                                set angleNode [$projectDOM selectNode /root/Result/Angle/SeatTube/Direction/text()]
                                  # puts "  <D> -> \$angleNode [$angleNode asXML]"
                                if {$angleNode != {}} {
                                    set angle_SeatTube [$angleNode nodeValue]
                                    if {$angle_SeatTube != 0} {
                                        dict set postUpdate     Result      Angle/SeatTube/Direction    $angle_SeatTube
                                    }
                                }
                        }

                    
                                # -- set Reference
                        set parentNode [$projectDOM selectNode /root]
                        set node       [$projectDOM selectNode /root/Reference]
                        if {$node != {}} {
                                # node: Reference exists but does not contain node: HandleBar_BB 
                                set checkNode  [$projectDOM selectNode /root/Reference/HandleBar_Distance]
                                if {$checkNode == {}} {
                                    $parentNode removeChild $node
                                    $node delete
                                }
                        }                                                   
                        set node       [$projectDOM selectNode /root/Reference]
                        if {$node == {}} {
                                puts "                           ... update File ... /root/Reference"
                                $parentNode appendXML  "<Reference>
                                                            <HandleBar_Distance>543.69</HandleBar_Distance>
                                                            <HandleBar_Height>905.00</HandleBar_Height>
                                                            <SaddleNose_Distance>62.69</SaddleNose_Distance>
                                                            <SaddleNose_Height>970.00</SaddleNose_Height>
                                                        </Reference>"
                        }
                    }
                {3.4.01} {
                                # -- get Rendering Saddle/Offset
                        set node [$projectDOM selectNode /root/Component/Derailleur/Rear/Pulley/y/text()]
                        if {$node != {}} {
                                set pulleyOffset [$node nodeValue]
                                puts "                                           ... $pulleyOffset"
                                if {$pulleyOffset < 0} {
                                    set pulleyOffset [expr -1.0 * $pulleyOffset]
                                }
                                puts "                           ... update File ... /root/Component/Derailleur/Rear/Pulley/y"
                                $node nodeValue $pulleyOffset
                        } 
                                # -- set Reference
                        set referenceNode [$projectDOM selectNode   /root/FrameTubes/ChainStay/Profile/completeLength]
                        if {$referenceNode == {}} {
                            puts "                           ... update File ... /root/FrameTubes/ChainStay/CenterLine"
                            set length_01  [[$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_01/text()] nodeValue]
                            set length_02  [[$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_02/text()] nodeValue]
                            set length_03  [[$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_03/text()] nodeValue]
                            set length_04  [[$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_04/text()] nodeValue]
                            set node       [ $projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_05]
                            if {$node != {}} {
                                set length_05  [[$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_05/text()] nodeValue]
                            } else {
                                set length_05  50
                            }
                            set completeLength [expr $length_01 + $length_02 + $length_03 + $length_04 + $length_05] 
                              #
                            set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine]
                            set delNode    [$projectDOM selectNode /root/FrameTubes/ChainStay/CenterLine/length_05]
                              #
                            if {$delNode != ""} {
                                $parentNode removeChild $delNode
                                $delNode delete
                            }
                              #
                            set parentNode [$projectDOM selectNode /root/FrameTubes/ChainStay/Profile]
                              #
                            puts "                           ... update File ... /root/FrameTubes/ChainStay/Profile"
                            $parentNode appendXML  "<completeLength>$completeLength</completeLength>"
                            $parentNode appendXML  "<cuttingLeft>0.00</cuttingLeft>"
                            $parentNode appendXML  "<cuttingLength>$completeLength</cuttingLength>"
                        }
                                # -- set Component HandleBar/PivotAngle
                        set node [$projectDOM selectNode /root/Component/HandleBar/PivotAngle/text()]
                        if {$node == {}} {
                            set parentNode [$projectDOM selectNode /root/Component/HandleBar]
                              #
                            puts "                           ... update File ... /root/Component/HandleBar/PivotAngle"
                            $parentNode appendXML  "<PivotAngle>-5.00</PivotAngle>"
                        } 
                                 # -- set Component Fender/
                        set node [$projectDOM selectNode /root/Component/Fender]
                        if {$node == {}} {
                            set parentNode [$projectDOM selectNode /root/Component]
                              #
                            puts "                           ... update File ... /root/Component/Fender"
                            $parentNode appendXML  "<Fender>
                                                        <Front>
                                                            <Radius>200.00</Radius>
                                                            <Height>15.00</Height>
                                                            <OffsetAngleFront>20.00</OffsetAngleFront>
                                                            <OffsetAngle>90.00</OffsetAngle>
                                                        </Front>
                                                        <Rear>
                                                            <Radius>200.00</Radius>
                                                            <Height>15.00</Height>
                                                            <OffsetAngle>150.00</OffsetAngle>
                                                        </Rear>
                                                   </Fender>"
                        } 
                                # -- set Rendering Fender
                        set node [$projectDOM selectNode   /root/Rendering/Fender]
                        if {$node == {}} {
                            set parentNode [$projectDOM selectNode /root/Rendering]
                              #
                            puts "                           ... update File ... /root/Rendering/Fender"
                            $parentNode appendXML  "<Fender>
                                                        <Front>off</Front>
                                                        <Rear>off</Rear>
                                                    </Fender>"
                        }
                                # -- set Rendering Carrier
                        set node [$projectDOM selectNode   /root/Component/Carrier]
                        if {$node == {}} {
                            set parentNode [$projectDOM selectNode /root/Component]
                              #
                            puts "                           ... update File ... /root/Component/Carrier"
                            $parentNode appendXML  "<Carrier>
                                                        <Front>                
                                                           <File>etc:carrier/front/__blank__.svg</File>
                                                            <x>20.00</x>
                                                            <y>5.00</y>
                                                        </Front>
                                                        <Rear>
                                                            <File>etc:carrier/rear/__blank__.svg</File>
                                                            <x>15.00</x>
                                                            <y>30.00</y>
                                                        </Rear>
                                                    </Carrier>"
                        }
                    }       
                {3.4.02} {
                                # -- get Rendering Saddle/Offset
                        set node [$projectDOM selectNode /root/Custom/SeatTube/LengthVirtual/text()]
                        if {$node == {}} {
                                set sourceNode      [$projectDOM selectNode /root/Result/Length/Saddle/SeatTube_BB/text()]
                                set parentNode      [$projectDOM selectNode /root/Custom/SeatTube]
                                    # set HeadTube_End    [[$projectDOM selectNode /root/Result/Tubes/HeadTube/End/text()] nodeValue]
                                    # set help_02         [list -2 [lindex $HeadTube_End 1]]
                                    # set SeatTube_Start  [split [[$projectDOM selectNode /root/Result/Tubes/SeatTube/Start/text()] nodeValue] ,]
                                    # set SeatTube_End    [split [[$projectDOM selectNode /root/Result/Tubes/SeatTube/End/text()]   nodeValue] ,]
                                    # set SeatTube_Virt   [vectormath::intersectPoint $HeadTube_End $help_02 $SeatTube_Start $SeatTube_End ]  
                                    # set virtualLength   [vectormath::length {0 0} $SeatTube_Virt] 
                                
                                if {$sourceNode != {}} {
                                    set seatTubeLength      [$sourceNode nodeValue]
                                    set virtualLength       [expr 0.8 * $seatTubeLength]
                                } else {
                                    set virtualLength       550 
                                }
                                puts "                           ... update File ... /root/Custom/SeatTube/LengthVirtual"
                                $parentNode appendXML  "<LengthVirtual>$virtualLength</LengthVirtual>"
                        } 
                                # -- get Crankset ChainRingOffset
                        set node [$projectDOM selectNode /root/Component/CrankSet/ChainRingOffset]
                        if {$node == {}} {
                                set parentNode      [$projectDOM selectNode /root/Component/CrankSet]
                                puts "                           ... update File ... /root/Component/CrankSet/ChainRingOffset"
                                $parentNode appendXML  "<ChainRingOffset>5</ChainRingOffset>"
                        }
                    }
                
                {ab-xy} {	
                        set node {}
                        set node [$projectDOM selectNode /root/Project/rattleCADVersion/text()]
                        puts " ... [$node nodeValue] .."
                        puts " ... [$node asText] .."
                        return
                    }

                default {}
            }
    }

