
            # -- Libraries  ---------------
            #
    package require Tk
    package require tdom
            #
    package require   vectormath    0.5
    package require   appUtil       
            #    
    namespace eval bikeGeometry::geometry3D {
                
            variable fileName
            variable sourceText
            variable targetText     
            
            variable targetContent  {}
            
            variable exportFileName
            variable exportDir
            
            variable exportFileExtension {scad}    
            variable rattleCAD_DOM
            
            variable importDir
            
            variable FrontHubWidth   100.00
            variable RearHubWidth    200
            variable ChainStayOffset 50
                
            variable RearDropout;   array set RearDropout {}
            variable HandleBar;     array set HandleBar {}
            variable Saddle;        array set Saddle {}
            
            set      fileName {}
    }    

    
    proc bikeGeometry::geometry3D::getContent {} {
        variable targetContent
        return $targetContent
    }
    proc bikeGeometry::geometry3D::addContent {content} {
        variable targetContent
        variable targetText
            #
        append targetContent "$content"
            #
        $targetText delete 1.0 end
        $targetText insert end $targetContent
            #
    }   
    proc bikeGeometry::geometry3D::getComplete {} {
            #
        variable rattleCAD_DOM
        variable targetContent
            #
        variable RearHubWidth
        variable ChainStayOffset
        variable height_BottomBracket
            # 
        set RearHubWidth          [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/HubWidth/text()            ] asXML]
        set ChainStayOffset       [[$rattleCAD_DOM selectNodes /root/Lugs/RearDropOut/ChainStay/Offset_TopView/text()] asXML]
        set height_BottomBracket  [split [[$rattleCAD_DOM selectNodes /root/Result/Length/BottomBracket/Height/text() ] asXML] ,] 
            #
        # create_obj _complete    
        puts "   ... now create object"
        create_obj fork
            #
        return $targetContent
            #
    }
    proc saveFile {fileName content} {
                #
                #
            puts "\n"
            puts "  =============================================="
            puts "   -- saveFile:   $fileName"
            puts "  =============================================="
            puts "\n"
                #
            # set targetContent [$targetText get 1.0 end]  
                #
            set fileId [open $fileName "w"]
                #
            puts -nonewline $fileId $content
                # puts -nonewline $fileId [$doc asXML]
            close $fileId
                #
            puts "\n         ... file saved as:"
            puts "               [file join [file normalize .] $fileName] \n"
                #
            return
                #
    }

    
    proc bikeGeometry::geometry3D::saveContent {{exportFileName {}}} {
                #
            variable targetText
            variable fileName
            variable exportFileExtension
                #
            variable exportDir
                #
            if {$exportFileName == {}} {
                set exportFileName   [file rootname  [file tail $fileName]]
                set exportFileName   [format "%s.%s"  $exportFileName $exportFileExtension]
                set myFileName [tk_getSaveFile -title "Export Content as svg" -initialdir [file normalize $exportDir] -initialfile $exportFileName ]
                if {$myFileName eq {}} return
            } else {
                set myFileName $exportFileName
            }
                #
            puts "\n"
            puts "  =============================================="
            puts "   -- saveContent:   $exportFileName"
            puts "  =============================================="
            puts "\n"
                #
            # set targetContent [$targetText get 1.0 end]  
                #
            set targetContent   [getContent] 
                #
            set fileId [open $myFileName "w"]
                #
            puts -nonewline $fileId $targetContent
                # puts -nonewline $fileId [$doc asXML]
            close $fileId
                #
            puts "\n         ... file saved as:"
            puts "               [file join [file normalize .] $myFileName] \n"
                #
            return
                #
    } 

    proc bikeGeometry::geometry3D::create_obj {type} {
            variable targetText
            variable rattleCAD_DOM
            variable importDir
            
            
        
                # -- cleanup outputs ------            
            $targetText delete 1.0 end
            
                # -- insert Base Geometry
            # insertBaseNodes
            
            switch -exact $type {
                {_complete}  {  createFrame    
                                createFork    
                                insertRim        front
                                insertRim        rear
                                insertTyre       front
                                insertTyre       rear
                                insertSeatPost
                                insertSaddle                                
                                insertStem
                                insertHandleBar
                                # insertSaddle  
                                # insert_HandleBar
                            }
                {frame}     {   createFrame}  
                {fork}      {   createFork} 
                {seatpost}  {   insertSeatPost} 
                {saddle}    {   insertSaddle  } 
                {stem}      {   insertStem}
                {handlebar} {   insertHandleBar}
                {frontrim}  {   insertRim        front}  
                {rearrim}   {   insertRim        rear} 
                {fronttyre} {   insertTyre       front}  
                {reartyre}  {   insertTyre       rear} 
                {all_other} { 
                            }
                default     {}
            }
                #
            return  
    }

    proc bikeGeometry::geometry3D::create_MeshlabProject {} {
            #
        variable rattleCAD_DOM
        variable targetText
            #
        
            #
        set position_HandleBar    [split [[$rattleCAD_DOM selectNodes /root/Result/Position/HandleBar/text() ] asXML] ,]
        set rotation_HandleBar    [split [[$rattleCAD_DOM selectNodes /root/Component/HandleBar/PivotAngle/text() ] asXML] ,]
            #
        set pos_SeatPostSaddle    [split [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatPostSaddle/text() ] asXML] ,]
            # 
        set height_BottomBracket  [split [[$rattleCAD_DOM selectNodes /root/Result/Length/BottomBracket/Height/text() ] asXML] ,]
            #
            #                
        set type_HandleBar        [[$rattleCAD_DOM selectNodes /root/Component/HandleBar/File/text() ] asXML]
            #
        switch -exact $type_HandleBar {
            *campagnolo_ergopower_11_a.svg {
                    set handleBarFile ../lib3D/grabCAD/lib_handlebar_road.stl  }
            *flatbar_sti.svg {    
                    set handleBarFile ../lib3D/NX/lib_handlebar_offroad.stl  }
            default { 
                    set handleBarFile ../lib3D/NX/lib_handlebar_offroad.stl  }            
        }
            #
        set saddleFile                ../lib3D/grabCAD/lib_saddle.stl
            
            # -- cleanup outputs ------            
        $targetText delete 1.0 end

            
        addContent [format "<!DOCTYPE MeshLabDocument>\n"]
        addContent [format "<MeshLabProject>\n"]
          #
        addContent [format "    <MeshGroup>\n"]
          #
        
          # -- Frame 
        addContent [format "        <MLMesh label=\"Frame\" filename=\"./export_frame.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        
          # -- Fork 
        addContent [format "        <MLMesh label=\"Fork\" filename=\"./export_fork.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        
          # -- Wheels 
        addContent [format "        <MLMesh label=\"Rim-Front\" filename=\"./export_frontrim.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        addContent [format "        <MLMesh label=\"Tyre-Front\" filename=\"./export_fronttyre.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        
          # -- Wheels 
        addContent [format "        <MLMesh label=\"Rim-Rear\" filename=\"./export_rearrim.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        addContent [format "        <MLMesh label=\"Tyre-Rear\" filename=\"./export_reartyre.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
        
          # -- Stem 
        addContent [format "        <MLMesh label=\"Stem\" filename=\"./export_stem.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]
          
          # -- SeatPost 
        addContent [format "        <MLMesh label=\"SeatPost\" filename=\"./export_seatpost.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]        
          
          # -- HandleBar 
        addContent [format "        <MLMesh label=\"HandleBar\" filename=\"./export_handlebar.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]        
          
          # -- Saddle 
        foreach {x z} $pos_SeatPostSaddle  break
          # 
        addContent [format "        <MLMesh label=\"Saddle\" filename=\"./export_saddle.off\">\n"]
        addContent [format "            <MLMatrix44>\n"]
        addContent [format "1 0 0 0 \n"]
        addContent [format "0 1 0 0 \n"]
        addContent [format "0 0 1 %s \n" 0] ;# $height_BottomBracket
        addContent [format "0 0 0 1 \n"]
        addContent [format "            </MLMatrix44>\n"]
        addContent [format "        </MLMesh>\n"]        
          #
        
          #
        addContent [format "    </MeshGroup>\n"]
          #
        addContent [format "    <RasterGroup/>\n"]
          #
        addContent [format "</MeshLabProject>\n"]          
              
                
    }


    proc bikeGeometry::geometry3D::insertBaseNodes {} {
            variable targetText
            variable rattleCAD_DOM
            
            variable RearHubWidth
            variable FrontHubWidth
            
            set nodeList  {}
            
            if 1 {
                      # -- getPosition
                    set RearWheel_01        [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()    ] asXML]
                    set BottomBracket_02    [[$rattleCAD_DOM selectNodes /root/Result/Position/BottomBracket/text()] asXML]
                    set SeatStay_03         [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatStay/End/text()    ] asXML]
                    set TopTube_04          [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/Start/text()   ] asXML]
                    set SeatTube_05         [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatTube/End/text()    ] asXML]
                    set HeadTube_06         [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/Start/text()  ] asXML]
                    set DownTube_07         [[$rattleCAD_DOM selectNodes /root/Result/Tubes/DownTube/End/text()    ] asXML]
                    set TopTube_08          [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/End/text()     ] asXML]
                    set HeadTube_09         [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/End/text()    ] asXML]
                    set FrontWheel          [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            }

              # -- getPosition
            set RearWheel_01        $[namespace parent]::Position(RearWheel)
            set BottomBracket_02    $[namespace parent]::Position(BottomBracket)
            set SeatStay_03         $[namespace parent]::Position(SeatStay_End)
            set TopTube_04          $[namespace parent]::Position(TopTube_Start) 
            set SeatTube_05         $[namespace parent]::Position(SeatTube_End)  
            set HeadTube_06         $[namespace parent]::Position(HeadTube_Start)
            set DownTube_07         $[namespace parent]::Position(DownTube_End)  
            set TopTube_08          $[namespace parent]::Position(TopTube_End)   
            set HeadTube_09         $[namespace parent]::Position(HeadTube_End)  
            set FrontWheel          $[namespace parent]::Position(FrontWheel)
            

            if 1 {
                    set HeadSetHeight       [[$rattleCAD_DOM selectNodes /root/Component/HeadSet/Height/Bottom/text()] asXML]
                    set ForkHeight          [[$rattleCAD_DOM selectNodes /root/Component/Fork/Height/text()          ] asXML]
                      # puts "  <D> $HeadSetHeight"
                    set ForkTop             [vectormath::addVector [split $HeadTube_06 ,] [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $HeadSetHeight]]
                    set ForkPerp            [vectormath::addVector $ForkTop               [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $ForkHeight   ]]
                    
                    set SeatTube_IS_hor     [vectormath::intersectPoint [split $BottomBracket_02 ,] [split $SeatTube_05 ,] [split $TopTube_08 ,] [list 200 [lindex [split $TopTube_08 ,] 1] ]]
                      # puts "   -> $SeatTube_IS_hor"
                    #exit
                    set BB_WheelBase        [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $BottomBracket_02 ,] [list [lindex [split $BottomBracket_02 ,] 0] 200]]
                    set Fork_WheelBase      [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $HeadTube_09 ,] [split $HeadTube_06 ,]]
                    
                    set FrontWheel          [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            }

            set HeadSetHeight       $[namespace parent]::HeadSet(Height_Bottom)
            set ForkHeight          $[namespace parent]::Geometry(Fork_Height)
              # puts "  <D> $HeadSetHeight"
            set ForkTop             [vectormath::addVector [split $HeadTube_06 ,] [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $HeadSetHeight]]
            set ForkPerp            [vectormath::addVector $ForkTop               [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $ForkHeight   ]]
            
            set SeatTube_IS_hor     [vectormath::intersectPoint [split $BottomBracket_02 ,] [split $SeatTube_05 ,] [split $TopTube_08 ,] [list 200 [lindex [split $TopTube_08 ,] 1] ]]
              # puts "   -> $SeatTube_IS_hor"
            #exit
            set BB_WheelBase        [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $BottomBracket_02 ,] [list [lindex [split $BottomBracket_02 ,] 0] 200]]
            set Fork_WheelBase      [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $HeadTube_09 ,] [split $HeadTube_06 ,]]
                        
              
            
            lappend nodeList [linsert [split  $RearWheel_01 ,]       1  0.00]       ; # 1- A
            lappend nodeList [linsert [split  $BottomBracket_02 ,]   1  0.00]       ; # 2- B
            lappend nodeList [linsert [split  $SeatStay_03 ,]        1  0.00]       ; # 3- C
            lappend nodeList [linsert [split  $TopTube_04 ,]         1  0.00]       ; # 4- D
            lappend nodeList [linsert [split  $SeatTube_05 ,]        1  0.00]       ; # 5- E 
            lappend nodeList [list    [lindex $SeatTube_IS_hor 0]       0.00  [lindex $SeatTube_IS_hor 1]]   ; # 6- F
              #  
            lappend nodeList [list    [lindex $ForkPerp 0]              0.00  [lindex $ForkPerp 1] ]         ; # 7- G
            lappend nodeList [linsert [split  $FrontWheel ,]         1  0.00]       ; # 8- H
              # 
            lappend nodeList [list    [lindex $ForkTop 0]               0.00  [lindex $ForkTop 1]]           ; # 9- I
            lappend nodeList [linsert [split  $HeadTube_06 ,]        1  0.00]       ; #10- J 
            lappend nodeList [linsert [split  $DownTube_07 ,]        1  0.00]       ; #11- K
            lappend nodeList [linsert [split  $TopTube_08  ,]        1  0.00]       ; #12- L
            lappend nodeList [linsert [split  $HeadTube_09 ,]        1  0.00]       ; #13- M
              #
            lappend nodeList [list    [lindex $BB_WheelBase   0]        0.00  [lindex $BB_WheelBase   1]]    ; #14- 99   
            lappend nodeList [list    [lindex $Fork_WheelBase 0]        0.00  [lindex $Fork_WheelBase 1]]    ; #15- 100
              #
            lappend nodeList [linsert [split  $FrontWheel ,]        1   [expr -0.5*$FrontHubWidth]]          ; #16-
            lappend nodeList [linsert [split  $FrontWheel ,]        1   [expr  0.5*$FrontHubWidth]]          ; #17-
            lappend nodeList [list    [lindex [split $FrontWheel ,] 0]   0.00 0.00] ; #18-
              #
            lappend nodeList [linsert [split  $RearWheel_01 ,]      1   [expr -0.5*$RearHubWidth ]];         ; #19-
            lappend nodeList [linsert [split  $RearWheel_01 ,]      1   [expr  0.5*$RearHubWidth ]];         ; #20-
            lappend nodeList [list    [lindex [split $RearWheel_01 ,] 0] 0.00 0.00] ; #21-

              # -- insert PositionPoints as spheres
            addContent "//\n"
            addContent "//\n"
            addContent "// BaseNodes\n"
            addContent "//\n"
            addContent "module insertBaseNodes() \{\n"
            foreach xyz $nodeList {
                foreach {x y z} $xyz break
                addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $x $y $z]
                addContent [format "        color(\"RoyalBlue\") \n" ]
                addContent [format "        sphere(r = %s)\;\n"         10] 
                addContent [format "    \}\n"]
            }
            addContent "\}\n"
            addContent "insertBaseNodes()\;\n"
            
            return
    }

    proc bikeGeometry::geometry3D::createFrame {} {
                #
            variable targetText
            variable height_BottomBracket
                #
                # -- create Tube - procedures
                #
            lappend tubeCommand         [insertFrameTube  HeadTube]
            lappend tubeCommand         [insertFrameTube  TopTube]
            lappend tubeCommand         [insertFrameTube  DownTube]
            lappend tubeCommand         [insertFrameTube  SeatTube]
            lappend tubeCommand         [insertFrameTube  BottomBracket]
                #
            lappend tubeCommand         [insertFrameTube  SeatStay   right]
            lappend tubeCommand         [insertFrameTube  SeatStay   left]
                #
            lappend tubeCommand         [insertChainStay]
                #
            lappend tubeCommand         [insertRearDropout]
                #
                #
                #
            lappend tubeCommandSubtract [insertFrameTube  BottomBracketInside]    
            lappend tubeCommandSubtract [insertFrameTube  HeadTubeInside]    
                #
                #
                
                #
                # -- build Frame
                #
            addContent "//\n"
            addContent "//\n"
            addContent "// rattleCAD - Frame\n"
            addContent "//\n"
            addContent [format "translate(\[%s,%s,%s\]) \{\n"   0 0 $height_BottomBracket]
            addContent [format "    color(\"Green\") \n" ]
            addContent [format "    difference() \{\n"]
            addContent [format "        union() \{\n"]
            foreach tubeCmd $tubeCommand {
            addContent [format "            %s\()\;\n"              $tubeCmd]
            }
            addContent [format "        \}\n"]
            addContent [format "        union() \{\n"]
            foreach tubeCmd $tubeCommandSubtract {
            addContent [format "            %s\()\;\n"              $tubeCmd]
            }
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "//\n"]

    }    

    proc bikeGeometry::geometry3D::createFork  {} {
                #
            variable targetText
            variable rattleCAD_DOM
            variable height_BottomBracket
                #
            # parray    [namespace parent]::Config 
                
            set forkType    [set [namespace parent]::Config(Fork)]
                #
            set FrontWheel  [set [namespace parent]::Position(FrontWheel)]
                #
            puts "\n   ... createFork: $forkType\n"
                # puts "   -> \$forkType $forkType"
                #           
            switch -exact $forkType {
                SteelLugged -
                SteelLuggedMAX {            
                        set bladeCommand    [insertForkBladeMax]
                        set dropOutCommand  [insertFrontDropoutMax]
                        lappend forkCommand [insertSteerer]
                    }
                Suspension_26* -
                Suspension_26 {
                        set bladeCommand    [insertForkCrownSuspension]
                        set dropOutCommand  [insertForkDropoutSuspension]
                        lappend forkCommand [insertSteerer]
                    }
                default {
                        set bladeCommand    {}
                        set dropOutCommand  {}
                        lappend forkCommand [insertSteerer]
                    }
            }
                #
            addContent [format "//\n"]
            addContent [format "//\n"]
            addContent [format "// rattleCAD - Fork\n"]
            addContent [format "//\n"]
            addContent [format "translate(\[%s,%s,%s\]) \{\n"   0 0 $height_BottomBracket]
            addContent [format "    color(\"Green\") \n" ]
            addContent [format "    union() \{\n"]
            addContent [format "        %s\()\;\n"              $bladeCommand]
            addContent [format "        %s\()\;\n"              $dropOutCommand]
            addContent [format "        mirror\(\[0,1,0\])\{\n"]
            addContent [format "            %s\()\;\n"          $bladeCommand]
            addContent [format "            %s\()\;\n"          $dropOutCommand]
            addContent [format "         \}\n"]
            
            foreach forkCmd $forkCommand {
                addContent [format "        %s\()\;\n"          $forkCmd]
            }
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "//\n"]
    
    }

    proc bikeGeometry::geometry3D::insertFrameTube {tubeName {option {}}} {
            variable targetText
            variable rattleCAD_DOM
            
            variable RearHubWidth
            variable ChainStayOffset
            variable RearDropout
            
            set nodeCount 0
            
            puts "\n   ... insertFrameTube: $tubeName\n"
            
              #
              # -- $targetText insert end $tubeProfile
              #

              #
            set profile_xy   "0.00,0.00"
            set profile_xz   "0.00,0.00"
            set polygon      [list 0,0 10,0 10,2 0,2]            
              #
            switch -exact -- $tubeName {
                {HeadTube} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,] 
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes      /root/FrameTubes/HeadTube/Diameter/text()] asXML]
                            set radius      [expr 0.5*$diameter]
                              # puts "   -> \$diameter $diameter"
                            set position  [linsert $pos_Start  1  0.00]
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction [list 0.00 $direction 0.00] 
                              # puts "   -> \$position    $position"
                              # puts "   -> \$pos_Start $pos_End"
                            set length      [vectormath::length  $pos_Start $pos_End]
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],\[0,$length\],\[$radius,$length,\],\[$radius,0\]"
                              # puts "   -> \$length $length"
                                                        
                            #set direction [expr 180 - $angle]                            
                        }
                {HeadTubeInside} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/HeadTube/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/HeadTube/Start/text()] asXML] ,] 
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/HeadTube/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/HeadTube/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/HeadTube/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes      /root/FrameTubes/HeadTube/Diameter/text()] asXML]
                            set radius      [expr 0.5*$diameter - 1.5]
                              # puts "   -> \$diameter $diameter"
                              #
                            set tubeOffset  [vectormath::unifyVector $pos_Start $pos_End 5]
                            set pos_StNew   [vectormath::subVector   $pos_Start $tubeOffset]
                              #                            
                            set position  [linsert $pos_StNew  1  0.00]
                              # set position  [linsert $pos_Start  1  0.00]
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction [list 0.00 $direction 0.00] 
                              # puts "   -> \$position    $position"
                              # puts "   -> \$pos_Start $pos_End"
                            set length      [vectormath::length  $pos_Start $pos_End]
                            set length      [expr 2.0 * $length]
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],\[0,$length\],\[$radius,$length,\],\[$radius,0\]"
                              # puts "   -> \$length $length"
                                                        
                            #set direction [expr 180 - $angle]                            
                        }
                {TopTube} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,] 
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes    /root/FrameTubes/$tubeName/DiameterST/text()] asXML]
                              #
                            set position  [linsert $pos_Start  1  0.00]
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction [list 0.00 [expr $direction - 180] 0.00]                            
                            #set direction [expr 180 - $angle]
                            set length      [vectormath::length  $pos_Start $pos_End]
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],"
                            foreach posNode $profile_xy {
                                foreach {x y} [split $posNode ,] break
                                # puts "  $x"
                                # puts "  $y"
                                append polygon     "\[$y,$x\],"
                            }
                            append polygon  "\[0,$length\]"                                                       
                        }
                {DownTube} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,]
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes      /root/FrameTubes/$tubeName/DiameterBB/text()] asXML]
                              #
                            set position  [linsert $pos_Start  1  0.00]
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction [list 0.00 $direction 0.00]                            
                              #set direction [expr 180 - $angle]
                            set length      [vectormath::length  $pos_Start $pos_End]                            
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],"
                            foreach posNode $profile_xy {
                                foreach {x y} [split $posNode ,] break
                                # puts "  $x"
                                # puts "  $y"
                                append polygon     "\[$y,$x\],"
                            }
                            append polygon  "\[0,$length\]"
                        }
                {SeatTube} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,]
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes      /root/FrameTubes/$tubeName/DiameterBB/text()] asXML]
                              #
                            set position    [linsert $pos_Start  1  0.00]
                            set tubeShape   [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction   [list 0.00 $direction 0.00]                            
                            #set direction [expr 180 - $angle]
                            set length      [vectormath::length  $pos_Start $pos_End]                            
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],"
                            foreach posNode $profile_xy {
                                foreach {x y} [split $posNode ,] break
                                # puts "  $x"
                                # puts "  $y"
                                append polygon     "\[$y,$x\],"
                            }
                            append polygon  "\[0,$length\]"
                        }
                {SeatStay} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,]
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set diameter    [[$rattleCAD_DOM     selectNodes      /root/FrameTubes/$tubeName/DiameterST/text()] asXML]
                              #
                            set position    $pos_Start
                            set tubeShape   [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                              #
                            set length      [vectormath::length  $pos_Start $pos_End] 
                              #
                            set offset_SS   [expr 0.5*$RearHubWidth + $ChainStayOffset]
                            set hlp_y      [expr $offset_SS - [expr 0.3*$diameter]]
                              # puts "  -> $length"
                              # 3D-length of SeatStay different to 2D :)
                            set length     [expr sqrt($length * $length + $hlp_y * $hlp_y)] 
                              # puts "  -> $length"
                              #
                              # puts "   .. [llength $profile_xy]" 
                            set polygon     "\[0,0\],"
                            set profileLength [llength $profile_xy]
                            for {set i 0} {$i <  [llength $profile_xy]} {incr i} {
                                set posNode [lindex $profile_xy $i]
                                foreach {x y} [split $posNode ,] break
                                    # puts "  $x"
                                    # puts "  $y"
                                if {[expr $i+1] >= [llength $profile_xy]} {
                                    set x $length
                                }                                
                                append polygon     "\[$y,$x\],"
                            }
                            append polygon  "\[0,$length\]"
                              #
                            set hlp_x       [vectormath::length   [list [lindex $pos_Start 0] 0] [list [lindex $pos_End 0] 0]]
                            set direct_SS   [vectormath::dirAngle [list 0 $offset_SS] [list $hlp_x  [expr 0.3*$diameter]]]
                              #
                            puts "      ... <D> $hlp_x / $hlp_y"
                            puts "      ... <D> [list 0 $offset_SS] [list $hlp_x  [expr 0.3*$diameter]]"
                            puts "      ... <D> \$direct_SS $direct_SS"
                              #
                            if {$option == {right}} {
                                set position  [linsert $position  1  [expr -1.0*$offset_SS]]
                                set direct_SS [expr -1.0 * $direct_SS]
                                set direction [list  0.00  $direction  $direct_SS]
                            } else {
                                set position  [linsert $position  1   $offset_SS]
                                set direction [list  0.00  $direction  $direct_SS]
                            }
                              #
                            set RearDropout(SeatStay)  [list [lindex $position 0] [lindex $position 2]]                              
                        }
                {BottomBracket} {
                            set length      [[$rattleCAD_DOM     selectNodes    /root/Lugs/$tubeName/Width/text()] asXML]
                            set diameter    [[$rattleCAD_DOM     selectNodes    /root/Lugs/$tubeName/Diameter/outside/text()] asXML]
                            set radius      [expr 0.5*$diameter]
                              #
                            # puts "  -> BottomBracket:  $length / $diameter"  
                              #
                            set direction   [list  0.00 0.00 90.00 ]                            
                              #
                            set pos_Start   [list  0.00 0.00 ] 
                            set pos_End     [list  0.00 0.00 ] 
                            set profile_xy  [list  "0,[expr 0.5*$diameter]" "$length,[expr 0.5*$diameter]"]
                            set profile_xz  $profile_xy
                              #
                            set position    [linsert $pos_Start  1  [expr 0.5*$length]]
                              # 
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                              #
                              #set direction [expr 180 - $angle] 
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],\[0,-$length\],\[$radius,-$length,\],\[$radius,0\]"
                        } 
                {BottomBracketInside} {
                            set length      [[$rattleCAD_DOM     selectNodes    /root/Lugs/BottomBracket/Width/text()] asXML]
                            set diameter    [[$rattleCAD_DOM     selectNodes    /root/Lugs/BottomBracket/Diameter/inside/text()] asXML]
                            set radius      [expr 0.5*$diameter]
                              #
                            set length      [expr 2.0*$length]
                              #
                            # puts "  -> BottomBracket:  $length / $diameter"  
                              #
                            set direction   [list  0.00 0.00 90.00 ]                            
                              #
                            set pos_Start   [list  0.00 0.00 ] 
                            set pos_End     [list  0.00 0.00 ] 
                            set profile_xy  [list  "0,[expr 0.5*$diameter]" "$length,[expr 0.5*$diameter]"]
                            set profile_xz  $profile_xy
                              #
                            set position    [linsert $pos_Start  1  [expr 0.5*$length]]
                              # 
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                              #
                              #set direction [expr 180 - $angle] 
                              # .. to become revolved about x-Axis and directed in z-axis ... !?!?
                            set polygon     "\[0,0\],\[0,-$length\],\[$radius,-$length,\],\[$radius,0\]"
                        }
                default {
                            puts "\n    <D> ... what do you want?"
                            return
                        }                
            }

            puts "\n   ... prepare Tube:\n"
            puts "            -> direction ........... $direction"
            puts "            -> position ............ $position"
            puts "            -> profile_xy .......... $profile_xy"
            puts "            -> profile_xz .......... $profile_xz"
            puts "            -> tubeShape ........... $tubeShape"
            puts "            -> length .............. $length"
            
              #
            if {$option != {}} {
                set tubeName [format "%s_%s" $tubeName $option]
            }
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> $tubeName -- create --\n"
            addContent "//\n"
              #
            addContent [format "//  $polygon\n" ]
            addContent [format "module insert_%s() \{\n" $tubeName]
            addContent [format "    translate(\[%s,%s,%s\])\n" [lindex $position  0]    [lindex $position  1] [lindex $position  2]]
            addContent [format "    rotate(\[%s,%s,%s\])\n"    [lindex $direction 0] 90-[lindex $direction 1] [lindex $direction 2]]
            addContent [format "    rotate_extrude(\$fn=60)\n" ]
            addContent [format "    polygon(points = \[\n" ]
            addContent [format "        %s\n" $polygon]
            addContent [format "    \])\;\n" ]
            addContent [format "\}\n"]
              #
            # addContent [format "insert_%s()\;\n" $tubeName]
              #
            return [format "insert_%s" $tubeName]
              #
    }

    proc bikeGeometry::geometry3D::insertChainStay {} {
            
              # tubeName position direction profile_xy profile_xz
              # variable RearDropout
            variable RearHubWidth
            variable ChainStayOffset
            
            variable targetText
            variable rattleCAD_DOM
            
            set tubeName "ChainStay"
            set segmentNumber        36
            set segmentLength        15    
                
            set direction           [[$rattleCAD_DOM selectNodes        /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
            set pos_RearWheel       [split [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()] asXML] ,]
            set pos_Start           [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/Start/text()] asXML] ,]
            set pos_End             [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
            set pos_Start_Mockup    [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/RearMockup/Start/text()] asXML] ,]
            set centerLine          [[$rattleCAD_DOM selectNodes        /root/Result/Tubes/ChainStay/RearMockup/CenterLine/text()] asXML]
            set profile_xy          [[$rattleCAD_DOM selectNodes        /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
            set profile_xz          [[$rattleCAD_DOM selectNodes        /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
              #
            set length      [vectormath::length  $pos_Start $pos_End]
            set offset_CS   [expr 0.5*$RearHubWidth + $ChainStayOffset]
            set direct_CS   [vectormath::dirAngle [list 0 15] [list $length $offset_CS]]
              #            
            set direction   [list  0.00  $direction  $direct_CS]   
              #
            set position         [linsert $pos_Start 1 [lindex $pos_Start_Mockup 1]]
              #
              
              #
            set myChainStay      [bikeGeometry::geometry3D::polyhedron::create  $centerLine $profile_xy $profile_xz $segmentNumber $segmentLength ]
              #    
            set dict_ShapePoints [dict get $myChainStay value shapepoints]   
              #    
            set dict_ShapeFaces  [dict get $myChainStay value shapefaces]   
              #

              # puts "  -> \$pos_RearWheel  $pos_RearWheel"
              # puts "  -> \$pos_Start   $pos_Start"
              # puts "  -> \$centerLine  $centerLine"
              # puts "  -> \$position    $position"
              #
           

              
              # -- ChainStay
            addContent [format "//\n"]     
            addContent [format "module insert_%s_left() \{\n" $tubeName]     
              #
            foreach {x y z} $position break
            addContent [format "    translate(v = \[%s,%s,%s\]) \{\n" $x $y $z]
                  #
                addContent [format "//\n//\n//  -- ChainStay left ---- \n"]
                addContent [format "    rotate(\[%s,%s,%s\])\n"        [lindex $direction 0]  0-[lindex $direction 1] 0]
                addContent [format "        polyhedron (\n"]
                addContent [format "            points = \[\n                " ]
                  #
                foreach key [dict keys $dict_ShapePoints] {
                    set value [dict get $dict_ShapePoints $key]
                    # puts "  - > dict_ShapePoints -> $key  -> $value"
                    addContent [format "\[%s\], " "$value"]
                }
                addContent [format "\n            \],\n" ]
                addContent [format "            faces = \[\n                " ]            
                  #
                foreach key [dict keys $dict_ShapeFaces] {
                    set value [dict get $dict_ShapeFaces $key]
                    # puts "  - > dict_ShapeFaces -> $key  -> $value"
                    addContent [format "\[%s\], " "$value"]
                }                
                addContent [format "\n            \]\n" ]
                addContent [format "        );\n" ]
                  #
                addContent [format "    \}\n" ]

                  #
            addContent [format "\}\n"]
            addContent [format "//\n"]
                  #
                  #
            

            addContent [format "//\n"]     
            addContent [format "module insert_%s() \{\n" $tubeName]     
            addContent [format "    union() \{\n" $tubeName]     
              # -- left ChainStay
            addContent [format "        insert_%s_left()\;\n"               $tubeName]
              #
              # -- right ChainStay
            addContent [format "        mirror (\[0,1,0\]) \{ insert_%s_left() \;\}\n" $tubeName]
              #
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "//\n"]
              
              #
            return [format "insert_%s" $tubeName]
              #
    }

    proc bikeGeometry::geometry3D::insertRearDropout {} {
            variable RearDropout
            variable RearHubWidth
            variable ChainStayOffset
            
            variable targetText
            variable rattleCAD_DOM
              #
              
              #
            puts "\n   ... insertRearDropout: \n"
              #     
              
              
            set dropOutWidth        6

              #
            set pos_RearWheel       [split [[$rattleCAD_DOM  selectNodes  /root/Result/Position/RearWheel/text()]    asXML] ,]
            set pos_ChainStay       [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/ChainStay/Start/text()] asXML] ,]
            set pos_SeatStay        [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/SeatStay/Start/text()]  asXML] ,]
              #
            set pos_Derailleur      [split [[$rattleCAD_DOM  selectNodes  /root/Result/Lugs/Dropout/Rear/Derailleur/text()]  asXML] ,] 
              #
            set radiusSeatStay      [expr 0.5 * [[$rattleCAD_DOM selectNodes /root/FrameTubes/SeatStay/DiameterCS/text()]  asXML]]
            set radiusChainStay     [expr 0.5 * [[$rattleCAD_DOM selectNodes /root/FrameTubes/ChainStay/DiameterSS/text()] asXML]]
            set radiusRearWheel     10
              #
              # puts "  \$pos_RearWheel $pos_RearWheel"
              # puts "  \$pos_ChainStay $pos_ChainStay"
              # puts "  \$pos_SeatStay  $pos_SeatStay"
              
              # - DropOut - Blend
            set length_Mount        [vectormath::length $pos_ChainStay  $pos_SeatStay]    
            set radius_Blend        [expr 0.5 * $length_Mount]
            set ratio_Length        [expr ($radiusSeatStay+$radius_Blend)/($radiusChainStay+$radius_Blend)]  
            set length_01           [expr $ratio_Length * $length_Mount / (1.0 + $ratio_Length)] 
            set pos_CntBlend_0      [vectormath::addVector $pos_SeatStay [vectormath::unifyVector $pos_SeatStay $pos_ChainStay $length_01]]
            set length_02           [expr $radiusSeatStay + $radius_Blend]
            set length_03           [expr sqrt($length_02*$length_02 - $length_01*$length_01)]
            set pos_tmp_0           [vectormath::addVector $pos_CntBlend_0 [vectormath::unifyVector $pos_SeatStay $pos_ChainStay $length_03]]
            set pos_Blend           [vectormath::rotatePoint $pos_CntBlend_0 $pos_tmp_0 90]
            puts "           ... $radius_Blend"
            puts "           ... $ratio_Length    <- $radiusSeatStay / $radiusChainStay"
            puts "           ... $length_01"
            puts "           ... $pos_Derailleur"    
              #
            
              # - DropOut - Hanger & AxleCutout
            set radius_HangerDerailleurMount 7.5
            set radius_Axle                  5
            set pos_CutOut                  [vectormath::cathetusPoint  $pos_Derailleur $pos_RearWheel [expr $radius_HangerDerailleurMount + $radius_Axle]]
            set pos_tmp_1                   [vectormath::addVector $pos_CutOut [vectormath::unifyVector $pos_CutOut $pos_RearWheel 15]]
            set pos_tmp_2                   [vectormath::addVector $pos_tmp_1  [vectormath::unifyVector $pos_CutOut $pos_RearWheel 7]]
            set pos_Fin                     [vectormath::rotatePoint  $pos_tmp_1 $pos_tmp_2 90]
            puts "           ... $pos_CutOut"
              #

              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> RearDropout -- create --\n"
            addContent "//\n"
              #
            addContent [format "module insertRearDropout_%s() \{\n" left]
              #
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"            0 [expr  0.5*($RearHubWidth + $dropOutWidth)] 0]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"              90 0 0]
            addContent [format "            color(\"Green\") \{\n" ]
            addContent [format "                difference() \{\n"]
            addContent [format "                    union() \{\n"]
            addContent [format "                        hull() \{\n"]
            addContent [format "                            translate(\[%s,%s,%s\]) \n"      [lindex $pos_SeatStay  0] [lindex $pos_SeatStay   1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          $radiusSeatStay    [expr $dropOutWidth - 2]  ]
            addContent [format "                            translate(\[%s,%s,%s\]) \n"      [lindex $pos_ChainStay 0] [lindex $pos_ChainStay  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          $radiusChainStay   [expr $dropOutWidth - 2]  ]
            addContent [format "                            translate(\[%s,%s,%s\]) \n"      [lindex $pos_RearWheel 0] [lindex $pos_RearWheel  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          [expr $radiusChainStay + 3]  [expr $dropOutWidth - 2]  ]
            addContent [format "                        \}\n"]
            addContent [format "                        hull() \{\n"]
            addContent [format "                            translate(\[%s,%s,%s\]) \n"      [lindex $pos_SeatStay  0] [lindex $pos_SeatStay   1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          $radiusSeatStay    [expr $dropOutWidth - 2]  ]
            addContent [format "                            translate(\[%s,%s,%s\]) \n"      [lindex $pos_RearWheel 0] [lindex $pos_RearWheel  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          [expr $radiusRearWheel+1]  [expr $dropOutWidth - 2]  ]
            addContent [format "                        \}\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"        [lindex $pos_RearWheel 0] [lindex $pos_RearWheel  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n"          $radiusRearWheel   $dropOutWidth  ]
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                    translate(\[%s,%s,%s\]) \{\n"            [lindex $pos_Blend 0] [lindex $pos_Blend  1] 0]
            addContent [format "                        cylinder(r=%s,h=%s,center=true,\$fn=50);\n"          $radius_Blend   25  ]
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
              #
              
              #
            addContent [format "module insertDropoutHanger() \{\n"]
              #
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"                       0 [expr  0.5*($RearHubWidth + $dropOutWidth)] 0]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"                      90 0 0]
            addContent [format "            difference() \{\n"]
            addContent [format "                union() \{\n"]
            addContent [format "                    hull() \{\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_RearWheel 0] [lindex $pos_RearWheel  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" [expr $radiusRearWheel+1]  [expr $dropOutWidth - 2]  ]
            addContent [format "                        \}\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_Derailleur 0] [lindex $pos_Derailleur  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" 2   [expr $dropOutWidth - 2]  ]
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                    hull() \{\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_Fin 0] [lindex $pos_Fin  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" 2   [expr $dropOutWidth - 2] ]
            addContent [format "                        \}\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_Derailleur 0] [lindex $pos_Derailleur  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" $radius_HangerDerailleurMount   [expr $dropOutWidth - 2]  ]
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                    translate(\[%s,%s,%s\]) \{\n"               [lindex $pos_Derailleur 0] [lindex $pos_Derailleur  1] 0]
            addContent [format "                        cylinder(r=%s,h=%s,center=true);\n"     $radius_HangerDerailleurMount   $dropOutWidth ]
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
              #
            addContent [format "                translate(\[%s,%s,%s\]) \{\n"               [lindex $pos_Derailleur 0] [lindex $pos_Derailleur  1] 0]
            addContent [format "                    cylinder(r=%s,h=%s,center=true);\n"     4.5   15 ]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
            
              #
            addContent [format "module insertDropoutCutOut() \{\n"]
              #
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"                       0 [expr  0.5*($RearHubWidth + $dropOutWidth)] 0]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"                      90 0 0]
            addContent [format "                    hull() \{\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_RearWheel 0] [lindex $pos_RearWheel  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" $radius_Axle  15  ]
            addContent [format "                        \}\n"]
            addContent [format "                        translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_CutOut 0] [lindex $pos_CutOut  1] 0]
            addContent [format "                            cylinder(r=%s,h=%s,center=true);\n" $radius_Axle  15  ]
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
            
              #
            addContent [format "//\n"]
            addContent [format "module insert_%s() \{\n" RearDropOut]
            addContent [format "    difference()\{\n" left]            
            addContent [format "        insertRearDropout_%s()\;\n" left]            
            addContent [format "        insertDropoutCutOut()\;\n"]            
            addContent [format "    \}\n"]
            addContent [format "    mirror (\[0,1,0\]) \{\n"]            
            addContent [format "        difference()\{\n" left]            
            addContent [format "            union()\{\n" left]            
            addContent [format "                insertRearDropout_%s()\;\n" left]            
            addContent [format "                insertDropoutHanger()\;\n"]            
            addContent [format "            \}\n"]            
            addContent [format "            insertDropoutCutOut()\;\n"]            
            addContent [format "        \}\n"]            
            addContent [format "    \}\n"]            
            addContent [format "\}\n"]            
              #
                          #
            return [format "insert_%s" RearDropOut]
              #
            # return  
              #
    }

    proc bikeGeometry::geometry3D::insertSteerer {} {
              # 
            variable rattleCAD_DOM
            variable targetText
              #
            set position_HandleBar [set [namespace parent]::Position(HandleBar)] 
            set position_Stem      [set [namespace parent]::Position(Steerer_End)]
              #
            set angle_Stem         [vectormath::dirAngle $position_Stem $position_HandleBar]
              #
            set angle_Steerer      [expr 180 - [set [namespace parent]::Geometry(HeadTube_Angle)]]
            set pos_SteererStart   [set [namespace parent]::Position(Steerer_Start)]
            set pos_SteererEnd     [set [namespace parent]::Position(Steerer_End)]
              #
              puts $angle_Steerer            
              puts $angle_Stem            
              #
            set length_Steerer     [expr [vectormath::length $pos_SteererEnd $pos_SteererStart] +12]
            set length_Stem        [vectormath::length $position_Stem $position_HandleBar]
              #
            foreach {hb_x  hb_z}   $position_HandleBar  break  
            foreach {st_x  st_z}   $position_Stem       break  
            foreach {str_x str_z}  $pos_SteererStart    break  
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Steerer -- create --\n"
            addContent "module insertSteerer() \{\n"
              #
            addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $str_x 0 $str_z]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"  0 [expr 90 - $angle_Steerer] 0]  
            addContent [format "            translate(v = \[%s, %s, %s\]) \n" 0 0 -12]
            addContent [format "            cylinder(h = %s, d = 28.6, center = false)\;\n" $length_Steerer] 
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $str_x 0 $str_z]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"  0 [expr 90 - $angle_Steerer] 0]  
            addContent [format "            translate(v = \[%s, %s, %s\]) \n" 0 0 -20]
            addContent [format "            cylinder(h = %s, d = 34.0, center = false)\;\n" 20] 
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
              #
            #$targetText insert end "insertHandleBar()\;\n"
            
              #
            return insertSteerer  
              #
    }

    proc bikeGeometry::geometry3D::insertForkBladeMax {} {
                #
            variable FrontHubWidth
                #
            variable targetText
            variable rattleCAD_DOM
                #
            set pos_BladeStart     [set [namespace parent]::Position(ForkBlade_Start)]
            set pos_BladeEnd       [set [namespace parent]::Position(ForkBlade_End)]
                #
            puts "$pos_BladeStart  / $pos_BladeEnd"  
                
                
            set pos_SteererStart   [set [namespace parent]::Position(Steerer_Start)]
            set angle_Steerer      [set [namespace parent]::Direction(HeadTube)]
                #
                # puts "  -> $pos_BladeStart"    
                # puts "  -> $pos_BladeEnd"
            set length_Blade       [vectormath::length $pos_BladeEnd $pos_BladeStart]
                #
            set length_1           230
            if {$length_Blade >= $length_1} {
                set length_2       [expr $length_Blade - $length_1]
            } else {
                set length_2       40
                set length_1       [expr $length_Blade - $length_2]
            }
                #
            set angle_BladeCorrect [vectormath::grad [expr atan(9/($length_1 + $length_2))]]  
                #
            set angle              [expr -1.0 * [vectormath::dirAngle $pos_BladeStart $pos_BladeEnd] + 90]
            set angle              [expr $angle + $angle_BladeCorrect]    
                #

                #
            foreach {x z} $pos_SteererStart break   
                #                
            addContent [format "module insertForkBladeMax_%s() \{\n" left]
                #
            addContent [format "//\n"]
            addContent [format "//  -- insertForkBladeMax\n"]
            addContent [format "//\n"]
            addContent [format "    //  -- ForkCrown\n"]
            addContent [format "    hull() \{\n"]
            addContent [format "        translate(v = \[%s, %s, %s\]) \{\n" $x 0 $z]
            addContent [format "            rotate(\[%s,%s,%s\]) \{\n"                0 -18 0]  
            addContent [format "                translate(v = \[%s, %s, %s\]) \{\n"   0 5 -3]
            addContent [format "                    scale(v = \[%s, %s, %s\]) \{\n"   1 0.5 0.2] 
            addContent [format "                        sphere(d = %s)\;\n"           25] 
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
              #
            set bladeOffsetDropout 3  
            set bladeAngle         4  
              #
            addContent [format "        translate(v = \[%s,%s,%s\]) \{\n"             [lindex $pos_BladeStart 0] [expr $FrontHubWidth/2 + $bladeOffsetDropout] [lindex $pos_BladeStart 1]]  
            addContent [format "            rotate(\[%s,%s,%s\]) \{\n"                $bladeAngle $angle 0]  
            addContent [format "                translate(v = \[%s,%s,%s\]) \{\n"     -23 0 $length_Blade]
            addContent [format "                    union() \{\n"]  
            addContent [format "                        sphere(d = 7.5, center = false)\;\n"]  
            addContent [format "                        translate(v = \[%s,%s,%s\]) \{\n"        23 0 0]
            addContent [format "                            sphere(d = 18.5, center = false)\;\n"]  
            addContent [format "                        \}\n"]
            addContent [format "                        rotate(\[%s,%s,%s\]) \{\n"               0 90 0]  
            addContent [format "                            cylinder(h = 23, d1 = 7.5, d2 = 18.5, center = false)\;\n" $length_2]  
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]  
            addContent [format "                \}\n"]  
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "    //  -- ForkBlade\n"]
            addContent [format "    translate(v = \[%s,%s,%s\]) \{\n"                 [lindex $pos_BladeStart 0] [expr $FrontHubWidth/2 + $bladeOffsetDropout] [lindex $pos_BladeStart 1]]  
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"                    $bladeAngle $angle 0]   
            addContent [format "            hull() \{\n"]  
            addContent [format "                translate(v = \[%s,%s,%s\]) \{\n"     0 0 $length_1]
            addContent [format "                    cylinder(h = %s, d = 18.5, center = false)\;\n" $length_2]  
            addContent [format "                \}\n"]
            addContent [format "                cylinder(h = %s, d1 = 14, d2 = 18.5, center = false)\;\n" $length_2]  
            addContent [format "                translate(v = \[%s,%s,%s\]) \{\n"    -23.0 0 $length_1]
            addContent [format "                    sphere(d = 7.5, center = false)\;\n"]  
            addContent [format "                    cylinder(h = %s, d = 7.5, center = false)\;\n" $length_2]  
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "//\n"]
            addContent [format "//\n"]
            addContent [format "\}"]            
            addContent [format "//\n"]
            addContent [format "//\n"]
          
              #
            return [format "insertForkBladeMax_%s" left] 
              #

    }    

    proc bikeGeometry::geometry3D::insertFrontDropoutMax {} {
                #
            variable FrontHubWidth
                #
            variable targetText
            variable rattleCAD_DOM
                #
            set dropOutWidth        5
                #
              
            set pos_BladeStart     [set [namespace parent]::Position(ForkBlade_Start)]
            set pos_BladeEnd       [set [namespace parent]::Position(ForkBlade_End)]
                # puts "  -> $pos_BladeEnd"
            set length_Blade       [vectormath::length $pos_BladeEnd $pos_BladeStart]
                #
            set length_1           230
            set length_2           [expr $length_Blade - $length_1]
                #
            set angle_BladeCorrect [vectormath::grad [expr atan(9/($length_1 + $length_2))]]  
                #
            set angle              [expr -1.0 * [vectormath::dirAngle $pos_BladeStart $pos_BladeEnd] + 90]
            set angle              [expr $angle + $angle_BladeCorrect]    
                #
              
              
              
                #
            set pos_FrontWheel     [set [namespace parent]::Position(FrontWheel)]
            set radiusFrontWheel    10
                #
                # puts "  \$pos_RearWheel $pos_RearWheel"
                # puts "  \$pos_ChainStay $pos_ChainStay"
                # puts "  \$pos_SeatStay  $pos_SeatStay"

                #
                #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> FrontDropout -- create --\n"
            addContent "//\n"
                #
            addContent [format "module insertForkDropoutMax_%s() \{\n" left]
                #
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"                            0 [expr  0.5*($FrontHubWidth + $dropOutWidth)] 0]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"                           90 0 0]
            addContent [format "            hull() \{\n"]
            addContent [format "                translate(\[%s,%s,%s\]) \n"      [lindex $pos_BladeStart  0] [lindex $pos_BladeStart  1] 0]
            addContent [format "                cylinder(r=%s,h=%s,center=true);\n"          7   [expr $dropOutWidth - 2]  ]
            addContent [format "                translate(\[%s,%s,%s\]) \n"                  [lindex $pos_FrontWheel 0] [lindex $pos_FrontWheel  1] 0]
            addContent [format "                cylinder(r=%s,h=%s,center=true);\n"          [expr $radiusFrontWheel+1] [expr $dropOutWidth - 2]  ]
            addContent [format "            \}\n"]
            #$targetText insert end [format "    translate(\[%s,%s,%s\]) \{\n"            0 1 0] ]
            #addContent [format "            rotate(\[%s,%s,%s\])\n"              90 0 0]
            addContent [format "            translate(\[%s,%s,%s\]) \{ \n"                   [lindex $pos_FrontWheel  0] [lindex $pos_FrontWheel  1] 0]
            addContent [format "                cylinder(r=%s,h=%s,center=true);\n"          $radiusFrontWheel   $dropOutWidth  ]
            addContent [format "            \}\n"]
            #$targetText insert end [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
                #
            addContent [format "\}\n"]
                #
            addContent "//\n"

                #
            return [format "insertForkDropoutMax_%s" left]  
                #
    }

    proc bikeGeometry::geometry3D::insertForkDropoutSuspension {} {
                #
            variable FrontHubWidth
                #
            variable targetText
            variable rattleCAD_DOM
                #
            set dropOutWidth        7
            set bladeDistance     125
                #
              
                #
            set pos_FrontWheel     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Position/FrontWheel/text()]    asXML] ,]
                #
            set angle_Steerer      [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/Direction/degree/text()  ] asXML]
                #
            set lenght_ForkRake    [[$rattleCAD_DOM  selectNodes  /root/Component/Fork/Rake/text()]    asXML]
                #
                    
            # puts "   \$pos_FrontWheel  $pos_FrontWheel"        
            # puts "   \$angle_Steerer   $angle_Steerer"    
            # puts "   \$lenght_ForkRake $lenght_ForkRake"    
            # puts "   \$FrontHubWidth   $FrontHubWidth"    

              #
            set radiusFrontWheel     12
            set p_00 [list 0 0]
            set p_01 [list [expr 20 - $lenght_ForkRake] 15]
            set p_02 [list [expr 20 - $lenght_ForkRake] 55]
              #
              # puts "  \$pos_RearWheel $pos_RearWheel"
              # puts "  \$pos_ChainStay $pos_ChainStay"
              # puts "  \$pos_SeatStay  $pos_SeatStay"

              #
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> SuspensionForkDropout -- create --\n"
            addContent "//\n"
              #
            addContent [format "module insertForkDropoutSuspension_%s() \{\n" left]
              #
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"           [lindex $pos_FrontWheel  0]  0  [lindex $pos_FrontWheel  1]]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"              0 [expr 90 - $angle_Steerer] 0]
            addContent [format "            union() \{\n"]
            addContent [format "                translate(\[%s,%s,%s\]) \{ \n"      0 [expr 0.5 * $FrontHubWidth] 0]
            addContent [format "                    rotate(\[%s,%s,%s\]) \{\n"              90 0 0]
            addContent [format "                            hull() \{\n"]
            addContent [format "                                translate(\[%s,%s,%s\]) \{ \n"      [lindex $p_00  0]  [lindex $p_00  1] [expr -1 * $dropOutWidth]]
            addContent [format "                                    cylinder(r=%s,h=%s,center=false);\n"          $radiusFrontWheel   $dropOutWidth  ]
            addContent [format "                                \}\n"]
            addContent [format "                                translate(\[%s,%s,%s\]) \{ \n"      [lindex $p_01  0]  [lindex $p_01  1] [expr -1 * $dropOutWidth]]
            addContent [format "                                    cylinder(r=%s,h=%s,center=false);\n"          6   $dropOutWidth  ]
            addContent [format "                                \}\n"]
            addContent [format "                                translate(\[%s,%s,%s\]) \{ \n"      [lindex $p_02  0]  [lindex $p_02  1] [expr -1 * $dropOutWidth]]
            addContent [format "                                    cylinder(r=%s,h=%s,center=false);\n"          5   $dropOutWidth  ]
            addContent [format "                                \}\n"]
            addContent [format "                            \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
              #
            addContent [format "                translate(\[%s,%s,%s\]) \{ \n"          [lindex $p_01  0] [expr 0.5 * $bladeDistance] [lindex $p_01  1]]
            addContent [format "                            cylinder(d=%s,h=%s);\n"          32   275  ]
            addContent [format "                            translate(\[%s,%s,%s\]) \{ \n"   0 0 -8]
            addContent [format "                                cylinder(d1=%s,d2=%s,h=%s,center=false);\n"   16    32   8]
            addContent [format "                            \}\n"]                                              
            addContent [format "                            translate(\[%s,%s,%s\]) \{ \n"   0 0 [expr 275 -15]]
            addContent [format "                                cylinder(d=%s,h=%s,center=false);\n"          36   15  ]
            addContent [format "                            \}\n"]
            addContent [format "                            translate(\[%s,%s,%s\]) \{ \n"   0 0 [expr 275 -23]]
            addContent [format "                                cylinder(d1=%s,d2=%s,h=%s,center=false);\n"   32    36   8]
            addContent [format "                            \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
              #
            addContent "//\n"           
              #
          
              #
            return [format "insertForkDropoutSuspension_%s" left]  
              #
    }

    proc bikeGeometry::geometry3D::insertForkCrownSuspension {} {
                #
            variable FrontHubWidth
                #
            variable targetText
            variable rattleCAD_DOM
                #
                #
            set bladeDistance     125
              
                #
            set pos_FrontWheel     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Position/FrontWheel/text()]    asXML] ,]
            set pos_SteererStart   [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/Start/text()] asXML] ,]
                #
            set angle_Steerer      [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/Direction/degree/text()  ] asXML]
                #
            set lenght_ForkRake    [[$rattleCAD_DOM  selectNodes  /root/Component/Fork/Rake/text()]    asXML]
                #
                    
                # puts "   \$pos_FrontWheel  $pos_FrontWheel"        
                # puts "   \$angle_Steerer   $angle_Steerer"    
                # puts "   \$lenght_ForkRake $lenght_ForkRake"    

            foreach {str_x str_z}  $pos_SteererStart    break  
              #
            set radiusFrontWheel     12
            set p_00 [list 0 0]
            set p_01 [list [expr 20 - $lenght_ForkRake] 15]
            set p_02 [list [expr 20 - $lenght_ForkRake] 35]
              #
              # puts "  \$pos_RearWheel $pos_RearWheel"
              # puts "  \$pos_ChainStay $pos_ChainStay"
              # puts "  \$pos_SeatStay  $pos_SeatStay"
              #
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> SuspensionForkDropout -- create --\n"
            addContent "//\n"
              #
            addContent [format "module insertForkCrownSuspension_%s() \{\n" left]
              #
            addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $str_x 0 $str_z]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"  0 [expr 90 - $angle_Steerer] 0]  
            addContent [format "            translate(v = \[%s, %s, %s\]) \n" 0 0 -30]
            addContent [format "            cylinder(h = %s, d = 34.0, center = false)\;\n" 25] 
            addContent [format "            translate(v = \[%s, %s, %s\]) \n" 20 [expr 0.5 * $bladeDistance] -60]
            addContent [format "            cylinder(h = %s, d = 34.0, center = false)\;\n" 30] 
            addContent [format "            hull() \{ \n"]
            addContent [format "                translate(v = \[%s, %s, %s\]) \n" 0 0 -20]
            addContent [format "                cylinder(h = %s, d = 30.0, center = false)\;\n" 12] 
            addContent [format "                translate(v = \[%s, %s, %s\]) \n" 20 [expr 0.5 * $bladeDistance] -58]
            addContent [format "                cylinder(h = %s, d = 30.0, center = false)\;\n" 20] 
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $str_x 0 $str_z]
            addContent [format "        rotate(\[%s,%s,%s\]) \{\n"  0 [expr 90 - $angle_Steerer] 0]  
            addContent [format "            translate(v = \[%s, %s, %s\]) \n" 20 [expr 0.5 * $bladeDistance] -340]
            addContent [format "            cylinder(h = %s, d = 29.0, center = false)\;\n" 300] 
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
              #
            addContent [format "\}\n"]
                         
              #
            addContent "//\n"           
              #
          
              #
            return [format "insertForkCrownSuspension_%s" left]  
              #
    }

    proc bikeGeometry::geometry3D::insertRim {location} {
            variable targetText
            variable rattleCAD_DOM
            variable height_BottomBracket
                
              #
            puts "\n   ... insertRim: $location\n"
              #  
              
            set fn 180
            
            switch -exact $location {
                rear {
                        set rimDiameter       [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/RimDiameter/text()]  asXML]
                        set rimRadius         [expr 0.5 * $rimDiameter]
                        set rimHeight         [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/RimHeight/text()]    asXML]
                        set position          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()]  asXML] ,]
                     }
                front {
                        set rimDiameter       [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Front/RimDiameter/text()] asXML]
                        set rimRadius         [expr 0.5 * $rimDiameter]
                        set rimHeight         [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Front/RimHeight/text()]   asXML]
                        set position          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()] asXML] ,]
                     }
                default {}
            }
            
              #
            set rimHeight_outside  5 ;# ...defined lib_cv_bikeRendering ... RearWheel, FrontWheel
              #
            set rimPolygon  [format "\[%s,-1\],\[%s,3\],\[%s,9\],\[%s,10\],\[%s,10\],\[%s,9\],\[%s,-1\]" \
                                       [expr $rimHeight_outside - $rimHeight] \
                                       [expr $rimHeight_outside - $rimHeight] \
                                       [expr $rimHeight_outside - 10 ] \
                                       [expr $rimHeight_outside - 9] \
                                       [expr $rimHeight_outside ] \
                                       [expr $rimHeight_outside + 1 ] \
                                       [expr $rimHeight_outside + 1 ] \
                                ]
              #

            
            
            set pos_x [lindex $position 0]
            set pos_y 0
            set pos_z [lindex $position 1]
            
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Wheel - Rim $location -- create --\n"
            addContent [format "//               Position: %s\n"    $position]
            addContent "//\n"
              #

              #
            addContent [format "module insertRim() \{\n" ]
            addContent [format "    rotate(\[%s,%s,%s\])\n"         90 0 0]
            addContent [format "    rotate_extrude(\$fn=%s)\n"      $fn]
            addContent [format "    translate(\[%s,%s,%s\])\n"      $rimRadius 0 0]
            addContent [format "    polygon(points = \[\n" ]
            addContent [format "        %s\n"                       $rimPolygon]
            addContent [format "    \])\;\n" ]
            addContent [format "\}\n"]
            addContent [format "//\n"]
              #
              
              #
            addContent [format "module insertRim_%s() \{\n"                 $location]
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"           0 0 $height_BottomBracket]
            addContent [format "        translate(\[%s,%s,%s\]) \{\n"       [lindex $position  0] 0 [lindex $position  1]]
            addContent [format "            color(\"DarkGray\") \{\n" ]
            addContent [format "                union() \{ \n" ]
            addContent [format "                    insertRim()\;\n" ]
            addContent [format "                    mirror (\[0,-1,0\]) \{ insertRim()\; \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "//\n"]
            addContent [format "insertRim_%s()\;\n"                         $location]            
              #

            return

    }

    proc bikeGeometry::geometry3D::insertTyre {location} {
            variable targetText
            variable rattleCAD_DOM
            variable height_BottomBracket
              # 
              
              #
            puts "\n   ... insertTyre: $location\n"
              #     
          
            set width_TyreShoulder          [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/TyreWidth/text()]        asXML]
            set height_TyreShoulder         [[$rattleCAD_DOM selectNodes /root/Result/Length/RearWheel/TyreShoulder/text()]  asXML]
              # puts "  -> \$height_TyreShoulder $height_TyreShoulder"
              # exit
              
            set fn 180
            
            switch -exact $location {
                rear {
                        set wheelDiameter     [[$rattleCAD_DOM selectNodes /root/Result/Length/RearWheel/Diameter/text()]  asXML]
                        set wheelRadius       [expr 0.5 * $wheelDiameter]
                        set shoulderRadius    [expr $wheelRadius  - $height_TyreShoulder]
                        set rimDiameter       [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/RimDiameter/text()]  asXML]
                        set rimRadius         [expr 0.5 * $rimDiameter]
                        set rimHeight         [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/RimHeight/text()]    asXML]
                        set position          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()]  asXML] ,]
                     }
                front {
                        set wheelDiameter     [[$rattleCAD_DOM selectNodes /root/Result/Length/FrontWheel/Diameter/text()] asXML]
                        set wheelRadius       [expr 0.5 * $wheelDiameter]
                        set shoulderRadius    [expr $wheelRadius  - $height_TyreShoulder]
                        set rimDiameter       [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Front/RimDiameter/text()] asXML]
                        set rimRadius         [expr 0.5 * $rimDiameter]
                        set rimHeight         [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Front/RimHeight/text()]   asXML]
                        set position          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()] asXML] ,]
                     }
                default {}
            }
            
              # puts "getTyreProfile $wheelRadius  $width_TyreShoulder  $height_TyreShoulder  [expr $rimRadius + 5] 18"
            set tyreProfile [getTyreProfile $wheelRadius  $width_TyreShoulder  $height_TyreShoulder  [expr $rimRadius + 5] 18] 
              # set tyreProfile [getTyreProfile 185 40 20 140 20]
              # getTyreProfile {tyreRadius tyreProfileWidth tyreShoulderHeight rimRadius rimWidth}              
              #
              #
            set tyrePolygon {}
            foreach xy $tyreProfile {
                append tyrePolygon [format "\[%s\]," $xy]
            }             
              #
            
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Wheel $location -- create --\n"
            addContent [format "//               Position: %s\n"                $position]
            addContent "//\n"
              #
            addContent [format "module insertWheel_%s() \{\n"                   $location]
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"               0 0 $height_BottomBracket]
            addContent [format "        translate(\[%s,%s,%s\]) \{\n"           [lindex $position  0] 0 [lindex $position  1]]
            addContent [format "            color(\"Gray\") \{\n" ]
            addContent [format "                rotate(\[%s,%s,%s\]) \{\n"      90 0 0]
            addContent [format "                    rotate_extrude(\$fn=%s)\n"  $fn]
            addContent [format "                    polygon(points = \[\n" ]
            addContent [format "                        %s\n"                   $tyrePolygon]
            addContent [format "                    \])\;\n" ]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "//\n"]
            addContent [format "insertWheel_%s()\;\n"                           $location]            
              #

            return

    }

    proc bikeGeometry::geometry3D::insertSeatPost {} {
            variable Saddle
            variable rattleCAD_DOM
            variable targetText
            variable height_BottomBracket
              #
              
              #
            puts "\n   ... insertSeatPost: \n"
              # 
              
            set pos_Saddle          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/Saddle/text()         ] asXML] ,]
            set pos_SeatPostSaddle  [split [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatPostSaddle/text() ] asXML] ,]
            set pos_SeatPostSTube   [split [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatPostSeatTube/text() ] asXML] ,]
            set lng_SeatPostSetback [split [[$rattleCAD_DOM selectNodes /root/Component/SeatPost/Setback/text()     ] asXML] ,]
            set lng_SeatPostPivot   [split [[$rattleCAD_DOM selectNodes /root/Component/SeatPost/PivotOffset/text() ] asXML] ,]
              #
            set pos_SeatTubeStart   [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatTube/Start/text()    ] asXML] ,]
            set pos_SeatTubeEnd     [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatTube/End/text()      ] asXML] ,]
              #
            set diam_SeatPost       [[$rattleCAD_DOM selectNodes /root/Component/SeatPost/Diameter/text()      ] asXML]
              #
            foreach {sd_x sd_z} $pos_Saddle          break  
            foreach {sp_x sp_z} $pos_SeatPostSaddle  break  
              #
              #
            set p_01 $pos_SeatTubeStart
            set p_02 $pos_SeatPostSTube
            set p_99 $pos_SeatPostSaddle
              #
            set p_98 [vectormath::intersectPerp $p_01 $p_02 $p_99]
              # 
            set direction   [vectormath::dirAngle     $p_01 $p_02]
            set offset_x    35
            set offset_y    [vectormath::distancePerp $p_01 $p_02 $p_99]
            set offset_l    [expr sqrt($offset_x*$offset_x + $offset_y*$offset_y)]
            set offset_dir  [vectormath::grad [expr atan($offset_y/$offset_x)]]
              # puts "    \$p_01 $p_01"
              # puts "    \$p_02 $p_02"
              # puts "    \$p_98 $p_98"
              # puts "    \$p_99 $p_99"
              # puts "    \$direction $direction"
              # puts "    \$offset_x    $offset_x"
              # puts "    \$offset_y    $offset_y"
              # puts "    \$offset_l    $offset_l"
              # puts "    \$offset_dir  $offset_dir"
              #
              #
            set position         [list [lindex $pos_SeatPostSaddle 0] 0 [lindex $pos_SeatPostSaddle 1]]
  
              #
             
              #
            set tubeName SeatPost
              #
              # -- SeatPost
              #
            # pos_SeatPostSaddle  
              #
            foreach {x y z} $position break
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> insertSeatPost -- create --\n"
            addContent [format "//               Position: %s\n" $pos_Saddle]
            addContent "//\n"
            addContent "module insertSeatPost() \{\n"
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"                                   0 0 $height_BottomBracket]
            addContent [format "        translate(v = \[%s, %s, %s\]) \{\n"                         $x $y $z]
            addContent [format "            color(\"Silver\") \{\n" ]
            addContent [format "                union() \{\n"]
            addContent [format "                    scale(v = \[1, 1, 0.5\]) \{\n"]
            addContent [format "                        rotate(\[%s,%s,%s\]) \{\n"                  90 0 0]
            addContent [format "                            cylinder(h = %s, d = %s, center = true)\;\n"  50  30] 
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                    rotate(\[%s,%s,%s\]) \{\n"                      0 [expr 90 + $direction] 180]  
            addContent [format "                        translate(v = \[%s, %s, %s\]) \{\n"         $offset_y 0 $offset_x]
            addContent [format "                            cylinder(h = %s, d = %s, center = false)\;\n"  300  $diam_SeatPost] 
            addContent [format "                        \}\n"]
            addContent [format "                        rotate(\[%s,%s,%s\]) \{\n"                  0 $offset_dir 0]
            addContent [format "                            cylinder(h = %s, d1 = %s, d2 = %s, center = false)\;\n"  [expr $offset_l - 3]  15.0 27.2] 
            addContent [format "                            translate(v = \[%s, %s, %s\]) \{\n"     0 0 [expr $offset_l - 3]] 
            addContent [format "                                cylinder(h = %s, d = %s, center = false)\;\n"  3 $diam_SeatPost] 
            addContent [format "                            \}\n"]
            addContent [format "                        \}\n"]
            addContent [format "                        translate(v = \[%s, %s, %s\]) \{\n"         $offset_y 0 $offset_x]
            addContent [format "                            sphere(d = %s)\;\n"                     $diam_SeatPost] 
            addContent [format "                        \}\n"]
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent "\}\n"
            addContent "insertSeatPost()\;\n"            
              # -- Saddle
              #
    }

    proc bikeGeometry::geometry3D::insertSaddle {} {
            variable Saddle
            variable rattleCAD_DOM
            variable targetText
            variable height_BottomBracket
              #
              
              #
            puts "\n   ... insertSaddle: \n"
              #     
          
            set pos_Saddle          [split [[$rattleCAD_DOM selectNodes /root/Result/Position/Saddle/text()         ] asXML] ,]
            set pos_SeatPostSaddle  [split [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatPostSaddle/text() ] asXML] ,]
        
              #
            set saddleFile "../lib3D/grabCAD/lib_saddle.stl"
              #
            foreach {sd_x sd_z} $pos_SeatPostSaddle          break  
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Saddle -- create --\n"
            addContent [format "//               Position: %s\n"                $pos_Saddle]
            addContent [format "//            -> Position: %s\n"                $pos_SeatPostSaddle]
            addContent [format "//\n"]
            addContent [format "module insertSaddle() \{\n"]
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"               0 0 $height_BottomBracket]
            addContent [format "        translate(v = \[%s, %s, %s\]) \{\n"     $sd_x 0 $sd_z]
            addContent [format "            color(\"Black\") \{\n" ]
            addContent [format "                import(\"%s\");"                $saddleFile]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "insertSaddle()\;\n"]                

    }

    proc bikeGeometry::geometry3D::insertStem {} {
            #variable HandleBar
            variable rattleCAD_DOM
            variable targetText
            variable height_BottomBracket
              #
              
              #
            puts "\n   ... insertStem: \n"
              # 
              
            set position_HandleBar [split [[$rattleCAD_DOM selectNodes /root/Result/Position/HandleBar/text() ] asXML] ,]
            set position_Stem      [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/End/text()  ] asXML] ,]
              #
            set angle_Stem         [vectormath::dirAngle $position_Stem $position_HandleBar]
              #
            set angle_Steerer      [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/Direction/degree/text()  ] asXML]
            set pos_SteererStart   [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/Start/text()] asXML] ,]
            set pos_SteererEnd     [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/Steerer/End/text()  ] asXML] ,]
              #
              # puts $angle_Steerer            
              # puts $angle_Stem            
              #
            set length_Steerer     [expr [vectormath::length $pos_SteererEnd $pos_SteererStart] +12]
            set length_Stem        [vectormath::length $position_Stem $position_HandleBar]
              #
            foreach {hb_x  hb_z}   $position_HandleBar  break  
            foreach {st_x  st_z}   $position_Stem       break  
            foreach {str_x str_z}  $pos_SteererStart    break  
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Stem -- create --\n"
            addContent [format "//               Position: %s\n" $position_HandleBar]
            addContent "//\n"
            addContent "module insertStem() \{\n"
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"                       0 0 $height_BottomBracket]
            addContent [format "        color(\"Silver\") \{\n" ]
            addContent [format "            union() \{\n"]
            addContent [format "                translate(v = \[%s, %s, %s\]) \{\n"     $st_x 0 $st_z]
            addContent [format "                    rotate(\[%s,%s,%s\]) \{\n"          0 [expr 90 - $angle_Steerer] 0]  
            addContent [format "                        cylinder(h = %s, d = 31.8, center = true)\;\n" 40] 
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "                translate(v = \[%s, %s, %s\]) \{\n"     $hb_x 0 $hb_z]
            addContent [format "                    rotate(\[%s,%s,%s\]) \{\n"          90 0 0]  
            addContent [format "                        cylinder(h = %s, d = 34.9, center = true)\;\n" 40] 
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "                translate(v = \[%s, %s, %s\]) \{\n" $st_x 0 $st_z]
            addContent [format "                    rotate(\[%s,%s,%s\]) \{\n"          0 [expr 90 - $angle_Stem] 0]  
            addContent [format "                        cylinder(h = %s, d = 28.6, center = false)\;\n" $length_Stem] 
            addContent [format "                    \}\n"]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
              #
            addContent "insertStem()\;\n"
              #
    }

    proc bikeGeometry::geometry3D::insertHandleBar {} {
              #
            variable rattleCAD_DOM
            variable targetText
            variable height_BottomBracket
              #
              
              #
            set type_HandleBar     [[$rattleCAD_DOM selectNodes /root/Component/HandleBar/File/text() ] asXML]
              #
            
              #
            puts "\n   ... insertHandleBar: $type_HandleBar\n"
              #
              
            set position_HandleBar [split [[$rattleCAD_DOM selectNodes /root/Result/Position/HandleBar/text() ] asXML] ,]
            set rotation_HandleBar [split [[$rattleCAD_DOM selectNodes /root/Component/HandleBar/PivotAngle/text() ] asXML] ,]
              #
            switch -glob -- $type_HandleBar {
                *cergopower*.svg -
                *campagnolo_ergopower_11_a.svg {
                        set handleBarFile "../lib3D/grabCAD/lib_handlebar_road.stl"  }
                *flatbar_sti.svg {    
                        set handleBarFile "../lib3D/NX/lib_handlebar_offroad.stl"  }
                default { 
                        set handleBarFile "../lib3D/NX/lib_handlebar_offroad.stl"  }            
            }
              #
            set position           [list [lindex $position_HandleBar 0] 0 [lindex $position_HandleBar 1]]
            set rotation           [expr -1 * $rotation_HandleBar]  
            
            
              # -- HandleBar 
            foreach {x z} $position_HandleBar  break
              # 
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> HandleBar -- create --\n"
            addContent [format "//               Position: %s\n"                $position_HandleBar]
            addContent "//\n"
            addContent "module insert_HandleBar() \{\n"
            addContent [format "    translate(\[%s,%s,%s\]) \{\n"               0 0 $height_BottomBracket]
            addContent [format "        translate(v = \[%s, %s, %s\]) \{\n"     $x 0 $z]
            addContent [format "            rotate(\[%s,%s,%s\]) \{\n"          0 $rotation 0]
            addContent [format "                color(\"Black\") \{\n" ]
            addContent [format "                    import(\"%s\");"            $handleBarFile]
            addContent [format "                \}\n"]
            addContent [format "            \}\n"]
            addContent [format "        \}\n"]
            addContent [format "    \}\n"]
            addContent [format "\}\n"]
            addContent [format "insert_HandleBar()\;\n"]                
              #
            return 
              #            
    }

    proc bikeGeometry::geometry3D::getTyreProfile {tyreRadius tyreProfileWidth tyreShoulderHeight rimRadius rimWidth} {
          #
        set nr_ProfileArcSegments      6
          #
        set input_tyreRadius    $tyreRadius
        set input_rimRadius     $rimRadius
            #set input_tyreRadius    185
            #set input_rimRadius     140
            #set tyreProfileWidth     40
            #set tyreShoulderHeight   10
            #set rimWidth             20
            
        set tyreRadius          $tyreShoulderHeight
        set rimRadius           [expr $input_rimRadius - ($input_tyreRadius - $tyreShoulderHeight)]         
          #
        set ratioWidthHeight    [expr $tyreProfileWidth / (2.0 * $tyreShoulderHeight)]
          #
        #puts "      ... \$input_tyreRadius        $input_tyreRadius"
        #puts "      ... \$input_rimRadius         $input_rimRadius"
        #puts "      ... \$tyreRadius              $tyreRadius"
        #puts "      ... \$tyreShoulderHeight      $tyreShoulderHeight"
        #puts "      ... \$rimRadius               $rimRadius"
          #
        #puts "      ... \$ratioWidthHeight    ->  $ratioWidthHeight"
          #
        #puts "      ... \$tyreProfileWidth        $tyreProfileWidth"
        #puts "      ... \$rimWidth                $rimWidth"
          #
        set p_TyreCenter        [list [expr $tyreRadius - $tyreShoulderHeight] 0]
        set p_Rim               [list $rimRadius [expr 0.5 * $rimWidth]]   
        set p_Rim_2             [list [expr $tyreRadius - $tyreShoulderHeight - $ratioWidthHeight * ([lindex $p_TyreCenter 0] - [lindex $p_Rim 0])] [lindex $p_Rim 1]]   
          #
        #puts "      ... ------------"
        #puts "      ... \$p_TyreCenter   $p_TyreCenter"
        #puts "      ... \$p_Rim          $p_Rim"
        #puts "      ... \$p_Rim_2        $p_Rim_2"
          #
          # -- Satz von Thales
        set length_MS           [vectormath::length $p_Rim_2 $p_TyreCenter]
          #
        if {[catch {set p_Tangente_2        [vectormath::cathetusPoint $p_TyreCenter $p_Rim_2 [expr 0.5 * $tyreProfileWidth] ]} eID]} {
            puts "           ... getTyreProfile: $eID"
            set p_Tangente_2 [vectormath::rotateLine $p_TyreCenter [expr 0.5 * $tyreProfileWidth] 135]
        }        
        set angle_p_Tangente_2  [vectormath::dirAngle      $p_TyreCenter $p_Tangente_2] 
          #
        #puts "      ... \$p_Tangente_2        $p_Tangente_2"
        #puts "      ... \$angle_p_Tangente_2  $angle_p_Tangente_2"
          #
        lappend tyreProfile_2 $p_Rim_2
        lappend tyreProfile_2 $p_Tangente_2
          #
        set angle_Loop          $angle_p_Tangente_2
        set angle_Delta         [expr $angle_p_Tangente_2/$nr_ProfileArcSegments]
        set i 0
        while {$i < 2* $nr_ProfileArcSegments} {
            incr i
            set this_Angle [expr $angle_Loop - $i * $angle_Delta]
            set this_Point [vectormath::rotateLine $p_TyreCenter [expr 0.5 * $tyreProfileWidth] $this_Angle]
            #puts "         ... $this_Angle  ->  $this_Point"
            lappend tyreProfile_2 $this_Point
        }
        lappend tyreProfile_2 [vectormath::mirrorPoint {0 0} {1 0} $p_Rim_2]
          #
          #
        #puts " --- \$tyreProfile_2 ---" 
          #
        foreach xy $tyreProfile_2 {
            foreach {x y} $xy break
            #puts "              -> $xy  $x $y"
            set x [expr (1.0 * $x / $ratioWidthHeight) + [expr $input_tyreRadius - $tyreShoulderHeight ]]
            lappend tyreProfile [format "%s,%s" $x $y]
        }
          #
        #puts " --- \$tyreProfile -----" 
          #
        #puts "      ... \$input_tyreRadius        $input_tyreRadius"
        #puts "      ... \$tyreShoulderHeight      $tyreShoulderHeight"
        #puts "      ... \$input_rimRadius         $input_rimRadius"
          #
        foreach xy $tyreProfile {
            # puts "              -> $xy"
        }
          #
        return $tyreProfile
        
    }   


    proc bikeGeometry::geometry3D::insert_PlaceHolder {pos} {
              #
            variable rattleCAD_DOM
            variable targetText
              #
              #
            foreach {sd_x sd_z} $pos          break  
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> Placeholder -- create --\n"
            addContent [format "//               Position: %s\n" $pos]
            addContent "//\n"
            addContent "module insertPlaceholder() \{\n"
            addContent [format "    translate(v = \[%s, %s, %s\]) \{\n" $sd_x 0 $sd_z]
            addContent [format "        sphere(r = %s)\;\n"         10] 
            addContent [format "    \}\n"]
            addContent "\}\n"
            # addContent "insertPlaceholder()\;\n"

              #
            return [format "insertPlaceholder"] 
              #            
    }

    proc bikeGeometry::geometry3D::insertObjectSTL {objectName fileName} {
            variable HandleBar
            variable rattleCAD_DOM
            variable targetText
              #
            set HandleBar(Position) [[$rattleCAD_DOM selectNodes /root/Result/Position/HandleBar/text() ] asXML]
              #
            foreach {x z} [split $HandleBar(Position) ,] break  
              #
            addContent "//\n"
            addContent "//\n"
            addContent "//     -> insertObjectSTL $objectName -- create -- $fileName \n"
            addContent "//\n"
            addContent [format "module insertObjectSTL_%s() \{\n" $objectName]
            
            #addContent [format "    scale(\"%s\")\;\n"           [file nativename $fileName]  ] 
            addContent [format "    import(\"%s\")\;\n"           [file nativename $fileName]  ] 
            addContent "\}\n"
            addContent [format "insertObjectSTL_%s()\; \n" $objectName]
    }

  