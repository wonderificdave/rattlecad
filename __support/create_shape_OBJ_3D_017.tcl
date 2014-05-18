#!/usr/bin/wish

 #

    package require Tk
    package require tdom
    
    variable fileName
    variable sourceText
    variable targetText
    
    variable exportFileExtension {obj}    
    variable rattleCAD_DOM
    
    variable project_NodeCount 0
    variable frameGeometry_Nodes_XY
    variable topTube_Nodes_XY
    variable downTube_Nodes_XY
    variable headTube_Nodes_XY
    variable seatTube_Nodes_XY
    variable chainStay_Nodes_XY
    variable seatStay_Nodes_XY
    variable nodeList_Nodes_XY
    
    variable rotationMatrix
    array set rotationMatrix {}
    
    variable FrontHubWidth   100.00
    variable RearHubWidth    200
    variable ChainStayOffset 50
    
    variable RearDropout
    array set RearDropout {}
    
    
            # -- Libraries  ---------------
    lappend auto_path      [file normalize [file dirname argv0] ]
    #lappend auto_path      [file normalize [file join [file dirname argv0] app-vectorMath]]
    puts "\n   ... $auto_path\n"
      #
    package require   vectormath    0.5
    package require   appUtil       
      #    
    
    set       fileName {}
    #set      fileName      \"[file normalize [file join [file dirname argv0] reynolds_road.xml]]\"
    #set      fileName      \"[file normalize [file join [file dirname argv0] __debug_3.4.01.60.xml]]\"
    puts "\n   ... $fileName\n"
    # exit
    
    
    proc openProject {{argv {}} args} {

            variable fileName
            variable sourceText
            variable targetText
            
            variable rattleCAD_DOM
            
            variable RearHubWidth
            variable ChainStayOffset
            
        
            puts "\n"
            puts "  =============================================="
            puts "   -- openProject:   $argv"
            puts "  =============================================="
            puts "\n"
    

                # --- open File ------------
            if {[llength $argv] == 0} {
                set fileName [tk_getOpenFile]
                set exportFileName $fileName
            } else {
                set fileName [file join [lindex ${argv} 0]]
                puts "   ... $argv"
                puts "   ... [llength $argv]"
                puts "   ... [lindex $argv 0]"
                puts "   ...   [lindex $argv 1]"
                puts "   ... $fileName"
            }
            if {$fileName == {}} {return}
			
            set fp [open ${fileName}]
			      # fconfigure    $fp -encoding utf-8
            set rattleCAD_Project [read $fp]
            close         $fp
         
            
                # --- compute results ------            
            dom parse  $rattleCAD_Project rattleCAD_DOC
            set  rattleCAD_DOM [$rattleCAD_DOC documentElement root]
            
                # --- common Values -------
            set RearHubWidth    [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/HubWidth/text()            ] asXML]
            set ChainStayOffset [[$rattleCAD_DOM selectNodes /root/Lugs/RearDropOut/ChainStay/Offset_TopView/text()] asXML]

                # --- cleanup outputs ------            
            $sourceText delete 1.0 end
            $targetText delete 1.0 end

                # --- fill outputs ---------
            $sourceText insert end $rattleCAD_Project
            
                # --- convert to OBJ-3D
            create_obj    

                # --- save Content
            saveContent   [file normalize [file join [file dirname argv0] export.obj]]       

                # 
            exit                
    }

    proc reloadProject {} {
            variable fileName
            openProject "$fileName"        
    }

    proc saveContent {{exportFileName {}}} {
            variable targetText
            variable fileName
            variable exportFileExtension
    
               
            if {$exportFileName == {}} {
                set exportFileName   [file rootname  [file tail $fileName]]
                set exportFileName   [format "%s.%s"  $exportFileName $exportFileExtension]
                set myFileName [tk_getSaveFile -title "Export Content as svg" -initialdir [file normalize .] -initialfile $exportFileName ]
                if {$myFileName eq {}} return
            } else {
                set myFileName $exportFileName
            }

            puts "\n"
            puts "  =============================================="
            puts "   -- saveContent:   $exportFileName"
            puts "  =============================================="
            puts "\n"
 

            #set myFileName [tk_getSaveFile -title "Export Content as svg" -initialdir [file normalize .] -initialfile $exportFileName ]
            #if {$myFileName eq {}} return

            
            set targetContent [$targetText get 1.0 end]            
                # dom parse  $svgText doc
                # $doc documentElement root
                # $root setAttribute  xmlns "http://www.w3.org/2000/svg"
                 

            
            set fileId [open $myFileName "w"]
                # puts -nonewline $fileId {<?xml version="1.0" encoding="UTF-8"?>}
                # puts -nonewline $fileId "\n"
            # fconfigure $fileId -translation {crlf cr}
                # puts [encoding names]
                # fconfigure $fileId -encoding {utf-8}
                # fconfigure $fileId -encoding {iso8859-8}
                # puts -nonewline $fileId $svgText
            puts -nonewline $fileId $targetContent
                # puts -nonewline $fileId [$doc asXML]
            close $fileId
            
            puts "\n         ... file saved as:"
            puts "               [file join [file normalize .] $myFileName] \n"
        
        
        
        
        
    }

    proc create_obj {} {
            variable targetText
            variable rattleCAD_DOM
            
                # -- cleanup outputs ------            
            $targetText delete 1.0 end
            
                # -- insert Base Geometry
            insertBaseNodes
            
                # -- insert DownTube
            # proc insertTube 
            #          {length  direction   position  tubeShape  precision_length  precision_shape}
            # proc insertTube 
            #          {length  direction   position tubeShape   precision_length  precision_shape}
              #
            # insertTube 400     {45 20 30}  {0 0}     {15 20}    4                 24
              #
            insertFrameTube  HeadTube
            insertFrameTube  TopTube
            insertFrameTube  DownTube
            insertFrameTube  SeatTube
            insertFrameTube  ChainStay right
            insertFrameTube  ChainStay left
            insertFrameTube  SeatStay  right
            insertFrameTube  SeatStay  left
            insertFrameTube  BottomBracket
              #
            insertRearDropout
            #insertTube 68     {90 90 90}  {0 0 0}     {20 20}    3                 3
              #
            #insertTube
            #insertFrameTube SeatTube
            #insertFrameTube HeadTube
            #insertFrameTube DownTube
            #insertFrameTube TopTube
            #insertFrameTube ChainStay
            #insertFrameTube SeatStay
            
                # -- insert DownTube
            # insertDownTube
            
            return
            
                # -- insert Material
            #insertMaterial
            
                # -- insert Nodes
            #insertNodes
                
                # -- insert AS3
            #insertAS3
    }

    
    proc insertBaseNodes {} {
            variable targetText
            variable rattleCAD_DOM
            
            variable project_NodeCount
            
            variable RearHubWidth
            variable FrontHubWidth
            
            set nodeList  {}
            
            $targetText insert end "#\n"
            $targetText insert end "# --- bicycle geometry ---\n"
            $targetText insert end "#\n"
            
              # -- getPosition
            set RearWheel_01      [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()    ] asXML]
            set BottomBracket_02  [[$rattleCAD_DOM selectNodes /root/Result/Position/BottomBracket/text()] asXML]
            set SeatStay_03       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatStay/End/text()    ] asXML]
            set TopTube_04        [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/Start/text()   ] asXML]
            set SeatTube_05       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatTube/End/text()    ] asXML]
            set HeadTube_06       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/Start/text()  ] asXML]
            set DownTube_07       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/DownTube/End/text()    ] asXML]
            set TopTube_08        [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/End/text()     ] asXML]
            set HeadTube_09       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/End/text()    ] asXML]
            set FrontWheel        [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            
            set Saddle            [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatTubeSaddle/text() ] asXML]
            set HeadSetHeight     [[$rattleCAD_DOM selectNodes /root/Component/HeadSet/Height/Bottom/text()] asXML]
            set ForkHeight        [[$rattleCAD_DOM selectNodes /root/Component/Fork/Height/text()          ] asXML]
              # puts "  <D> $HeadSetHeight"
            set ForkTop           [addVector [split $HeadTube_06 ,] [unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $HeadSetHeight]]
            set ForkPerp          [addVector $ForkTop               [unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $ForkHeight   ]]
            
            set SeatTube_IS_hor   [intersectPoint [split $BottomBracket_02 ,] [split $SeatTube_05 ,] [split $TopTube_08 ,] [list 200 [lindex [split $TopTube_08 ,] 1] ]]
              # puts "   -> $SeatTube_IS_hor"
            #exit
            set BB_WheelBase      [intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $BottomBracket_02 ,] [list [lindex [split $BottomBracket_02 ,] 0] 200]]
            set Fork_WheelBase    [intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $HeadTube_09 ,] [split $HeadTube_06 ,]]
            
            set FrontWheel        [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            
              
            
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
            lappend nodeList [list    [lindex $BB_WheelBase 0]          0.00  [lindex $BB_WheelBase   1]]    ; #14- 99   
            lappend nodeList [list    [lindex $Fork_WheelBase 0]        0.00  [lindex $Fork_WheelBase 1]]    ; #15- 100
              #
            lappend nodeList [linsert [split  $FrontWheel ,]        1   [expr -0.5*$FrontHubWidth]]          ; #16-
            lappend nodeList [linsert [split  $FrontWheel ,]        1   [expr  0.5*$FrontHubWidth]]          ; #17-
            lappend nodeList [list    [lindex [split $FrontWheel ,] 0]   0.00 0.00] ; #18-
              #
            lappend nodeList [linsert [split  $RearWheel_01 ,]      1   [expr -0.5*$RearHubWidth ]];         ; #19-
            lappend nodeList [linsert [split  $RearWheel_01 ,]      1   [expr  0.5*$RearHubWidth ]];         ; #20-
            lappend nodeList [list    [lindex [split $RearWheel_01 ,] 0] 0.00 0.00] ; #21-

            
              # -- insert Position
            foreach xyz $nodeList {
                $targetText insert end "v $xyz \n" 
            }

            
                    # -- Tube Lengths
                # set chainStayLength   [pointDistance [split $RearWheel_01 ,]     [split $BottomBracket_02 ,]]
                # set seatTubeLength    [pointDistance [split $BottomBracket_02 ,] [split $SeatTube_05 ,]     ]
                # set seatStayLength    [pointDistance [split $RearWheel_01 ,]     [split $SeatStay_03 ,]     ]
                # set downTubeLength    [pointDistance [split $BottomBracket_02 ,] [split $DownTube_07 ,]     ]
                # set topTubeLength     [pointDistance [split $TopTube_04 ,]       [split $TopTube_08  ,]     ]
                # set headTubeLength    [pointDistance [split $HeadTube_06 ,]      [split $HeadTube_09 ,]     ]
                
 

            
            $targetText insert end "#\n"
            $targetText insert end "#\n"
            $targetText insert end "# ---- rear triangle ----------\n"
            $targetText insert end "g rearTriangle\n"
            $targetText insert end "#\n"
            #$targetText insert end "f 1 2 3\n"
            $targetText insert end "#\n"
            $targetText insert end "# ---- front triangle ---------\n"
            $targetText insert end "g frontTriangle\n"
            $targetText insert end "# -- headtube - toptube/seattube\n"
            #$targetText insert end "f 4 10 13\n"
            $targetText insert end "# -- bb - downtube/headtube - toptube/headtube\n"
            #$targetText insert end "f 11 12 2\n"
            $targetText insert end "# -- seattube/top - toptube/headtube - bb\n"
            #$targetText insert end "f 6 11 2\n"
            $targetText insert end "#\n"
            $targetText insert end "# ---- fork -------------------\n"
            $targetText insert end "g fork\n"
            $targetText insert end "f 7 8 9\n"
            $targetText insert end "f 9 16 17\n"
            $targetText insert end "#\n"            
            $targetText insert end "# ---- frontwheelhub ----------\n"
            $targetText insert end "f 7 16 17\n"
            $targetText insert end "f 16 17 18\n"
            $targetText insert end "#\n"            
            $targetText insert end "# ---- rearwheelhub -----------\n"
            $targetText insert end "f 19 20 21\n"
            $targetText insert end "#\n"            

              #
            set project_NodeCount [expr $project_NodeCount + [llength $nodeList]]  
              #
              
              #            
            $targetText insert end "#    -> \$project_NodeCount $project_NodeCount \n"            
            $targetText insert end "#\n"            
              #
              
              #
            return            
              #
    }

    proc insertFrameTube {tubeName {option {}}} {
            variable targetText
            variable rattleCAD_DOM
            
            variable RearHubWidth
            variable ChainStayOffset
            
            variable project_NodeCount
            
            set nodeList  {}            
            set nodeCount 0
            
            puts "\n   ... insertFrameTube: $tubeName\n"
            
              #
              # -- $targetText insert end $tubeProfile
              #

              #
            $targetText insert end "#\n"
            $targetText insert end "#        -> last  $project_NodeCount \n"                
            $targetText insert end "#     -> $tubeName -- create --\n"
              #

              #
            set profile_xy   "0.00,0.00"
            set profile_xz   "0.00,0.00"             
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
                              # puts "   -> \$diameter $diameter"
                            set position  [linsert $pos_Start  1  0.00]
                            set tubeShape [list [expr 0.5*$diameter] [expr 0.5*$diameter]]
                            set direction [list 0.00 $direction 0.00] 
                              # puts "   -> \$position    $position"
                              # puts "   -> \$pos_Start $pos_End"
                            set length      [vectormath::length  $pos_Start $pos_End]
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
                        }
                {ChainStay} {
                            set direction   [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Direction/degree/text()] asXML]
                            set pos_Start   [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/Start/text()] asXML] ,]
                            set pos_End     [split [[$rattleCAD_DOM  selectNodes  /root/Result/Tubes/$tubeName/End/text()  ] asXML] ,]
                            set profile_xy  [[$rattleCAD_DOM      selectNodes     /root/Result/Tubes/$tubeName/RearMockup/Polygon/text()] asXML]
                            #set profile_xy  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xy/text()] asXML]
                            set profile_xz  [[$rattleCAD_DOM     selectNodes      /root/Result/Tubes/$tubeName/Profile/xz/text()] asXML]
                              #
                            set height      [[$rattleCAD_DOM     selectNodes    /root/FrameTubes/$tubeName/Height/text()] asXML]
                            set width       [[$rattleCAD_DOM     selectNodes    /root/FrameTubes/$tubeName/WidthBB/text()] asXML]
                              #
                            set position    $pos_Start
                            set tubeShape   [list [expr 0.5*$width] [expr 0.5*$height]]
                            set length      [vectormath::length  $pos_Start $pos_End]
                              #
                              #
                            set offset_CS   [expr 0.5*$RearHubWidth + $ChainStayOffset]
                            set direct_CS   [vectormath::dirAngle [list 0 15] [list $length $offset_CS]]
                              #
                            #set profile_xy  [vectormath::addVectorPointList [list 0 [expr -1.0*$offset_CS]] $profile_xy]
                              #
                            if {$option == {right}} {
                                set profile   [format_XspaceY $profile_xy]
                                set profile_xy {}
                                foreach {x y}  $profile {
                                    lappend profile_xy "$x,[expr -1.0*$y]"
                                }
                                set position  [linsert $position  1  [expr -1.0*$offset_CS]]
                                set direct_CS [expr -1.0 * $direct_CS]
                                set direction [list  0.00  $direction  $direct_CS]
                            } else {
                                set position  [linsert $position  1   $offset_CS]
                                set direction [list  0.00  $direction  $direct_CS]
                            }                          
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
                            set hlp_x       [vectormath::length   [list [lindex $pos_Start 0] 0] [list [lindex $pos_End 0] 0]]
                            set direct_SS   [vectormath::dirAngle [list 0 $offset_SS] [list $hlp_x  [expr 0.3*$diameter]]]
                              #
                            puts "      ... <D> [list 0 $offset_SS] [list $hlp_x  [expr 0.3*$diameter]]"
                            puts "      ... <D> \$direct_SS $direct_SS"
                              #
                            if {$option == {right}} {
                                set position  [linsert $position  1  [expr -1.0*$offset_SS]]
                                set direction [list  0.00  $direction  $direct_SS]
                            } else {
                                set position  [linsert $position  1   $offset_SS]
                                set direct_SS [expr -1.0 * $direct_SS]
                                set direction [list  0.00  $direction  $direct_SS]
                            }                            
                        }
                {BottomBracket} {
                            set length      [[$rattleCAD_DOM     selectNodes    /root/Lugs/$tubeName/Width/text()] asXML]
                            set diameter    [[$rattleCAD_DOM     selectNodes    /root/Lugs/$tubeName/Diameter/outside/text()] asXML]
                              #
                            puts "  -> BottomBracket:  $length / $diameter"  
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
                        }
                default {
                            puts "\n    <D> ... what do you want?"
                            return
                        }                
            }

            puts "\n   ... prepare Tube:\n"
            puts "            -> direction ........... $direction"
            puts "            -> position ............ $position"
            puts "            -> profile_xy ........... $profile_xy"
            puts "            -> profile_xz ........... $profile_xz"
            puts "            -> tubeShape ........... $tubeShape"
            puts "            -> length .............. $length"
            
            if {$tubeName != "ChainStay"} {
                insertSkeleton  $tubeName $position $direction $profile_xy $profile_xz
            } else {
                insertChainStay           $position $direction $profile_xy $profile_xz
            }
            #insertTube     $tubeName $length $position $direction $tubeShape 24 36
            #exit
              
              #
            # proc insertTube {length direction position tubeShape precision_length precision_shape}
    }

    proc insertSkeleton {tubeName position direction profile_xy profile_xz} {
              # length
              # direction {rotate_z rotate_y rotate_x}
              # tubeShape {rx ry}
              # precision_length
              # precision_shape
              
            #return {}
            
            variable targetText
            variable rattleCAD_DOM
            
            variable project_NodeCount
            
            variable RearDropout
              #
            # set project_LastCount [expr $project_NodeCount + 1]
              #
            set start     [list [lindex [split [lindex $profile_xy   0] ,] 0] 0]
            set end       [list [lindex [split [lindex $profile_xy end] ,] 0] 0]
              # 
            switch -exact $tubeName {
                ChainStay {
                          # puts "++  -> $tubeName checked "
                        set RearDropout(ChainStay) [list [lindex $position 0] [lindex $position 2]]
                    }
                SeatStay {
                          # puts "++  -> $tubeName checked "
                        set RearDropout(SeatStay)  [list [lindex $position 0] [lindex $position 2]]
                    }
                default {
                          # puts "--  -> $tubeName unchecked "
                    }
            }
              # parray  RearDropout           
              #
            $targetText insert end "#\n#\n# === $tubeName =======================================\n"
            $targetText insert end "#\ng $tubeName\n#\n"
              
              #
              # --- polygon_xz ------------
              #
            set nodeList  {}            
            set tubeNodes_Regular  {}
            set tubeNodes_Opposite {}
              #
            set polygon_xy [list $start]
            foreach node $profile_xy {
                lappend polygon_xy [split $node ,]
            }
            lappend polygon_xy $end
              #
            puts "   -> \$polygon_xy $polygon_xy"
              #
            foreach node $polygon_xy {
                foreach {x y} $node break
                lappend tubeNodes_Regular  [list $x $y 0]
                lappend tubeNodes_Opposite [list $x [expr -1.0*$y] 0]
            }
              #
            puts "   -> \$tubeNodes_Regular  $tubeNodes_Regular"
            puts "   -> \$tubeNodes_Opposite $tubeNodes_Opposite"
              #
            set tubeNodes_Regular  [positionTube $tubeNodes_Regular  $position $direction]
            set tubeNodes_Opposite [positionTube $tubeNodes_Opposite $position $direction]
              #
              #
              # --- polygon_xy -- regular -----------
              #
            $targetText insert end "# $tubeName  -- polygon_xy - regular\n# ------------------\n"
              #
            set project_LastCount [expr $project_NodeCount + 1]
              #
            foreach node $tubeNodes_Regular {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
              #   
            set shapeNode "f "
              # set project_NodeCount [expr $project_NodeCount+1]
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            for {set i $project_LastCount} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
              #
              # --- polygon_xy -- opposite ----------
              #
            $targetText insert end "# $tubeName  -- polygon_xy - opposite\n# ------------------\n"
              #
            set project_LastCount [expr $project_NodeCount + 1]
              #
            foreach node $tubeNodes_Opposite {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            } 
              #   
            set shapeNode "f "
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i $project_LastCount} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
              #              
            
            
              #
              # --- polygon_xz -----------
              #
            set nodeList  {}            
            set tubeNodes_Regular  {}
            set tubeNodes_Opposite {}
              #
            set polygon_xz [list $start]
            foreach node $profile_xz {
                lappend polygon_xz [split $node ,]
            }
            lappend polygon_xz $end
            
            puts "   -> \$polygon_xz $polygon_xz"
              #
            foreach node $polygon_xz {
                foreach {x z} $node break
                lappend tubeNodes_Regular  [list $x 0 $z ]
                lappend tubeNodes_Opposite [list $x 0 [expr -1.0*$z]]
            }
            puts "   -> \$tubeNodes_Regular $tubeNodes_Regular"
              #
            set tubeNodes_Regular  [positionTube $tubeNodes_Regular  $position $direction]
            set tubeNodes_Opposite [positionTube $tubeNodes_Opposite $position $direction]
              #
              #
              # --- polygon_xy -- regular -----------
              #
            $targetText insert end "# $tubeName  -- polygon_xz - regular\n# ------------------\n"
              #
            set project_LastCount $project_NodeCount  
              #   
            foreach node $tubeNodes_Regular {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
              #
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            set shapeNode "f "
              # set project_LastCount [expr $project_LastCount+1]
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i [expr $project_LastCount+1]} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
              #
              # --- polygon_xy -- opposite ----------
              #
            $targetText insert end "# $tubeName  -- polygon_xz - opposite\n# ------------------\n"
              #
            set project_LastCount $project_NodeCount  
              #   
            foreach node $tubeNodes_Opposite {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
              #
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            set shapeNode "f "
              # set project_LastCount [expr $project_LastCount+1]
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i [expr $project_LastCount+1]} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"

            
            return {}
    }

    proc insertChainStay {position direction profile_xy profile_xz} {
            variable RearDropout
            variable RearHubWidth
            variable ChainStayOffset
            
            variable targetText
            variable rattleCAD_DOM
                
            variable project_NodeCount
            
              #
            set RearDropout(ChainStay) [list [lindex $position 0] [lindex $position 2]]
              #

              #
            set pos_RearWheel       [split [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()] asXML] ,]
            set pos_Start           [split [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/RearMockup/Start/text()] asXML] ,]
            set centerLine          [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/RearMockup/CenterLine/text()] asXML]
            set centerLineStart     [split [lindex $centerLine end] ,]
            set centerLineEnd       [split [lindex $centerLine 0]   ,]
              #
            puts "   -> \$centerLine $centerLine"
            puts "   -> \$centerLineStart $centerLineStart"
            puts "   -> \$centerLineEnd $centerLineEnd"
            set csAngle         [vectormath::dirAngle $centerLineEnd $centerLineStart ]
            puts $csAngle
            #exit
            #set polygonChainStay    [format_XspaceY [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/RearMockup/Polygon/text()] asXML]]
            set polygonChainStay    [format_XspaceY $profile_xy]
              # set polygonChainStay    [[$rattleCAD_DOM selectNodes /root/Result/Tubes/ChainStay/RearMockup/Polygon/text()] asXML]]
              # 
            # puts "\n ============================\n  ====  insertChainStay  ==========\n "
            # puts "  -> \$polygonChainStay\n $polygonChainStay"
              #
            set chainStay_left  {}
            set chainStay_right {}
            foreach {x y} $polygonChainStay {
                  # puts "      -> $x $y"
                lappend chainStay_left  [list $x $y 0]
                # lappend chainStay_right [list $x [expr -1.0*$y] 0]
            }
              #
            puts "  -> \$direction $direction"
            puts "  -> \$position  $position"
            puts "  -> \$pos_Start $pos_Start"
            #return
              # -- take rotation about y-axis only
            set direction_xz $direction
            set direction_xy [list 0.00 [lindex $direction 1] 0.00]            
            #exit
            #set position_left  [linsert $pos_Start 2  [lindex $position 2]]           
            set position_left  $position       
              #
              # puts "  -> \$position  $position"
              # exit
            set chainStay_left  [positionTube $chainStay_left   $position_left   $direction_xy]
              #
            $targetText insert end "# ChainStay  -- bent\n# ------------------\n"
            $targetText insert end "g ChainStay_bent\n#\n"
              #
            set project_LastCount [expr $project_NodeCount + 1]
              #
            foreach node $chainStay_left {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
            set shapeNode "f "
              # set project_LastCount [expr $project_LastCount+1]
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i [expr $project_LastCount+1]} {$i <= $project_NodeCount} {incr i} {
                # puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
            
              #
              # ---------------------------------------
              #
              #
              
            set tubeName  "ChainStay"
            set start     [list [lindex [split [lindex $profile_xz   0] ,] 0] 0]
            set end       [list [lindex [split [lindex $profile_xz end] ,] 0] 0]
              
              #
              # --- polygon_xz -----------
              #
            set nodeList  {}            
            set tubeNodes_Regular  {}
            set tubeNodes_Opposite {}
              #
            set polygon_xz [list $start]
            foreach node $profile_xz {
                lappend polygon_xz [split $node ,]
            }
            lappend polygon_xz $end
            
            puts "   -> \$polygon_xz $polygon_xz"
              #
            foreach node $polygon_xz {
                foreach {x z} $node break
                lappend tubeNodes_Regular  [list $x 0 $z ]
                lappend tubeNodes_Opposite [list $x 0 [expr -1.0*$z]]
            }
            puts "   -> \$tubeNodes_Regular $tubeNodes_Regular"
              #
            set tubeNodes_Regular  [positionTube $tubeNodes_Regular  $position $direction_xz]
            set tubeNodes_Opposite [positionTube $tubeNodes_Opposite $position $direction_xz]
              #
              #
              # --- polygon_xz -- regular -----------
              #
            $targetText insert end "# $tubeName  -- polygon_xz - regular\n# ------------------\n"
              #
            set project_LastCount $project_NodeCount  
              #   
            foreach node $tubeNodes_Regular {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
              #
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            set shapeNode "f "
              # set project_LastCount [expr $project_LastCount+1]
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i [expr $project_LastCount+1]} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
              # --- polygon_xz -- opposite -----------
              #
            $targetText insert end "# $tubeName  -- polygon_xz - regular\n# ------------------\n"
              #
            set project_LastCount $project_NodeCount  
              #   
            foreach node $tubeNodes_Opposite {
                foreach {x y z} $node break
                lappend nodeList [list $x $y $z]
                $targetText insert end "v $x $y $z\n"
                incr project_NodeCount                
            }
              #
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            set shapeNode "f "
              # set project_LastCount [expr $project_LastCount+1]
              # set project_NodeCount [expr $project_NodeCount+1]
            for {set i [expr $project_LastCount+1]} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
              #
    
    }

    proc insertRearDropout {} {
            variable RearDropout
            variable RearHubWidth
            variable ChainStayOffset
            
            variable targetText
            variable rattleCAD_DOM
                
            variable project_NodeCount

              #
            set pos_RearWheel       [split [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()] asXML] ,]
              #  
            set pos_ChainStay_right [linsert $RearDropout(ChainStay) 1  [expr  0.5*$RearHubWidth]]
            set pos_SeatStay_right  [linsert $RearDropout(SeatStay)  1  [expr  0.5*$RearHubWidth]]
            set pos_RearWheel_right [linsert $pos_RearWheel          1  [expr  0.5*$RearHubWidth]]
              #
            set pos_ChainStay_left  [linsert $RearDropout(ChainStay) 1  [expr -0.5*$RearHubWidth]]
            set pos_SeatStay_left   [linsert $RearDropout(SeatStay)  1  [expr -0.5*$RearHubWidth]]
            set pos_RearWheel_left  [linsert $pos_RearWheel          1  [expr -0.5*$RearHubWidth]]
              #
              
              #
            $targetText insert end "#\n"
            $targetText insert end "#\n"
            $targetText insert end "# ---- rear dropout ----------\n"
            $targetText insert end "g rearDropout\n"
            $targetText insert end "#\n"
            $targetText insert end "v $pos_ChainStay_right \n"
            $targetText insert end "v $pos_SeatStay_right \n"
            $targetText insert end "v $pos_RearWheel_right \n"
              #
            set project_LastCount [expr $project_NodeCount + 1]
            set project_NodeCount [expr $project_NodeCount + 3]
              #
              #   
            set shapeNode "f "
              # set project_NodeCount [expr $project_NodeCount+1]
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            for {set i $project_LastCount} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
            $targetText insert end "#\n"
            $targetText insert end "v $pos_ChainStay_left \n"
            $targetText insert end "v $pos_SeatStay_left \n"
            $targetText insert end "v $pos_RearWheel_left \n"
              #
            set project_LastCount [expr $project_NodeCount + 1]
            set project_NodeCount [expr $project_NodeCount + 3]
              #
            set shapeNode "f "
              # set project_NodeCount [expr $project_NodeCount+1]
            puts "   -> \$project_LastCount $project_LastCount"
            puts "   -> \$project_NodeCount $project_NodeCount"
            for {set i $project_LastCount} {$i <= $project_NodeCount} {incr i} {
                puts "   -> \$i $i"
                append shapeNode "$i "
            }
            puts "   -> \$shapeNode $shapeNode"
            $targetText insert end "#\n$shapeNode\n#\n"
              #
    }

    proc insertTube {tubeName length position direction tubeShape precision_length precision_shape} {
              # length
              # direction {rotate_z rotate_y rotate_x}
              # tubeShape {rx ry}
              # precision_length
              # precision_shape
            
            variable targetText
            variable rattleCAD_DOM
            
            variable project_NodeCount
            
            set nodeList  {}            
            set nodeCount 0
            
            #set tubeShape              {15 20} ;# {rx ry}
            #set tubeShapePrecission    24
            #set tubeLength             500
            #set tubeLengthPrecission   4
            
            set tubeLength     $length
            set tubeDirection  $direction
            set tubePosition   $position
            set tubeShape      $tubeShape
            set tubeLengthPrecission $precision_length 
            set tubeShapePrecission  $precision_shape
            
            
                           # -- 
            $targetText insert end "#\n"
            $targetText insert end "# --- tube $tubeName ---\n"
            $targetText insert end "#\n"
            
            #set profile_DownTube  [[$rattleCAD_DOM selectNodes /root/Result/Tubes/DownTube/Polygon/text()] asXML]
              #
              # -- $targetText insert end $profile_DownTube
              #
            set shapeAngle_incr [expr 2*$vectormath::CONST_PI/$tubeShapePrecission]
            # puts "    -> $shapeAngle_incr"
            set shapeAngle 0
            set tubeRadius_Y   [lindex $tubeShape 0]
            set tubeShapeRatio [expr 1.0 * [lindex $tubeShape 1] / $tubeRadius_Y ]
              #
            puts "\n               <D> ... \$tubeShapeRatio  $tubeShapeRatio\n"
              #
            for {set i 0} {$i < $tubeShapePrecission} {incr i} {
                  # -- segment shape 
                set offset_Y   [format "%.4f" [expr $tubeRadius_Y * cos($shapeAngle)]]
                set offset_Z   [format "%.4f" [expr $tubeRadius_Y * sin($shapeAngle) * $tubeShapeRatio]]
                
                  # -- debug
                # puts "    ... $i -> $shapeAngle  ->  $offset_Y / $offset_Z"
                  # -- append to nodeList
                lappend nodeList [list $offset_Y $offset_Z ]
                incr nodeCount
                  # -- next Value
                set shapeAngle [expr $shapeAngle + $shapeAngle_incr]
            }
              #
              
              #
            set project_LastCount $project_NodeCount  
              #            

              # -- add point to result
              #
            set lengthTube_incr [expr $tubeLength / $tubeLengthPrecission ]
            set lengthTube 0
            set tubeNodes {}
              #
            for {set i 0} {$i <= $tubeLengthPrecission} {incr i} {
                set myLength [expr 1.0 * $i * $lengthTube_incr]
                # puts "    <D> -> [llength $nodeList]"
                foreach {yz} $nodeList {
                    set y [lindex $yz 0]
                    set z [lindex $yz 1]
                    lappend tubeNodes [list $myLength $y $z]
                    #$targetText insert end "v $myLength $y $z\n"
                }
                set project_NodeCount [expr $project_NodeCount + [llength $nodeList]]
            }
            
            set nodeList_positioned [positionTube $tubeNodes $tubeDirection $tubePosition ]
              # set nodeList_positioned $tubeNodes
            foreach node $nodeList_positioned {
                foreach {x y z} $node break
                $targetText insert end "v $x $y $z\n" 
            }
            
            
            
              # -- set boundingFace at start

              # --
            $targetText insert end "#\n"
            $targetText insert end "#    -> \$project_NodeCount $project_NodeCount\n"                
              # --          
            $targetText insert end "#\n"
            #$targetText insert end "g $tubeName\n"
            $targetText insert end "g $tubeName\n"
            $targetText insert end "usemtl blue\n"
            $targetText insert end "#\n"
              #
              
              #
            set profile_Face {}
            for {set x 0} {$x < $nodeCount} {incr x} {
                append profile_Face [format "%s " [expr $x + 1 + $project_LastCount]]
            }
            

            for {set i 0} {$i < $tubeLengthPrecission} {incr i} {
                $targetText insert end "# -- $i --\n"
                for {set j 0} {$j < $tubeShapePrecission} {incr j} {
                    set a [expr $project_LastCount + 1 + [expr $i * $tubeShapePrecission + $j]]
                    set c [expr $a + $tubeShapePrecission]
                    set b [expr $a + 1]
                    set d [expr $b + $tubeShapePrecission] 
                    if {[expr $j + 1] == $tubeShapePrecission} {
                        set b [expr $b - $tubeShapePrecission]
                        set d [expr $d - $tubeShapePrecission]
                    }
                    
                    $targetText insert end "#f $a \n"
                    #$targetText insert end "f $c $a $b $d\n"
                    $targetText insert end "f $c $a $b\n"
                    $targetText insert end "f $b $d $c\n"

                }

            }
            #$targetText insert end "f $profile_Face\n"
            #$targetText insert end "f 16 17 18\n"
            #$targetText insert end "f 19 20 21\n"
            #$targetText insert end "f 22 23 24\n"
            #$targetText insert end "f 25 26 27\n"
            $targetText insert end "#\n"
              #            
            
              #
            # while  
            return  
            foreach node $profile_DownTube {
                foreach {x y} [split $node ,] break
                lappend nodeList [list $x $y 0.00]
                $targetText insert end "v $x $y 0.00\n"
                incr nodeCount
            }
    }

    
    proc positionTube {nodeList position direction} {
        
        variable rotationMatrix
        
        foreach {rotate_x    rotate_y     rotate_z}     $direction break
        foreach {translate_x translate_y  translate_z}  $position  break
        
        # setRotationMatrix $rotate_x $rotate_y $rotate_z
    
        #puts "      ... \$rotationMatrix(1-1) ... [format "%3.4f"  $rotationMatrix(1-1)]"
        #puts "      ... \$rotationMatrix(1-2) ... [format "%3.4f"  $rotationMatrix(1-2)]"
        #puts "      ... \$rotationMatrix(1-3) ... [format "%3.4f"  $rotationMatrix(1-3)]"
        #puts "      ... \$rotationMatrix(2-1) ... [format "%3.4f"  $rotationMatrix(2-1)]"
        #puts "      ... \$rotationMatrix(2-2) ... [format "%3.4f"  $rotationMatrix(2-2)]"
        #puts "      ... \$rotationMatrix(2-3) ... [format "%3.4f"  $rotationMatrix(2-3)]"
        #puts "      ... \$rotationMatrix(3-1) ... [format "%3.4f"  $rotationMatrix(3-1)]"
        #puts "      ... \$rotationMatrix(3-2) ... [format "%3.4f"  $rotationMatrix(3-2)]"
        #puts "      ... \$rotationMatrix(3-3) ... [format "%3.4f"  $rotationMatrix(3-3)]"

        #puts "        --------"     
          #
        set newNodes {}
          #
        foreach node $nodeList {
              # puts "          ... $node"
            foreach {point_x point_y point_z} $node break
              #
            set newNode [rotate_3D_Point [list $point_x $point_y $point_z] $direction]
              #
            foreach {point_x point_y point_z} $newNode break
              #
            set result_x  [expr   $translate_x  +  $point_x] 
            set result_y  [expr   $translate_y  +  $point_y] 
            set result_z  [expr   $translate_z  +  $point_z]
            lappend newNodes [list $result_x  $result_y  $result_z]           
        }
        
        return $newNodes 
        
    }

        # -- format Values
    proc format_XspaceY {xyList} {
        set spaceList {}
        foreach {xy} $xyList {
            foreach {x y} [split $xy ,] break
            lappend spaceList $x $y
        }
        return $spaceList
    }    
    
    
 
          # -- http://wiki.tcl.tk/15084
          #        proc 3d_rot
          # Returns a matrix which rotates by $t radians about vector ($x,$y,$z).
        proc rotate_3D {x y z t} {
        
            set t  [vectormath::rad [expr -1.0 * $t]] ; # had to change direction of tube

            if {$x == 0 && $y == 0 && $z == 0} {
                return [list $x $y $z]
                error "Cannot rotate around zero vector"
            }
            set l [expr {sqrt($x ** 2 + $y ** 2 + $z ** 2)}]
            foreach dim {x y z} {
                set $dim [expr {[set $dim] / $l}]
            }

            set result [list]
            foreach row_expr {
                {{$x * $x + (1 - $x ** 2)      * cos($t)}
                 {$x * $y * (1 - cos($t)) - $z * sin($t)}
                 {$x * $z * (1 - cos($t)) + $y * sin($t)}}
                {{$y * $x * (1 - cos($t)) + $z * sin($t)}
                 {$y * $y + (1 - $y ** 2)      * cos($t)}
                 {$y * $z * (1 - cos($t)) - $x * sin($t)}}
                {{$z * $x * (1 - cos($t)) - $y * sin($t)}
                 {$z * $y * (1 - cos($t)) + $x * sin($t)}
                 {$z * $z + (1 - $z ** 2)      * cos($t)}}
            } {
                set row [list]
                 # foreach cell_expr [concat $row_expr [list 0]] {}
                foreach cell_expr $row_expr {
                    lappend row [expr $cell_expr]
                }
                lappend result $row
            }
            return $result
        }
        
        proc rotate_3D_Point {point direction} {
        
            set pointPos(x)    [lindex $point    0]
            set pointPos(y)    [lindex $point    1]
            set pointPos(z)    [lindex $point    2]
                 #
            set angleRot(x)    [lindex $direction 0]
            set angleRot(y)    [lindex $direction 1]
            set angleRot(z)    [lindex $direction 2]
                 #
            set newPos(x)  0
            set newPos(y)  0
            set newPos(z)  0
             
              # puts "---"
              # parray pointPos
            
              #
              # -- rotate about X-Axis
              #
            if {$angleRot(x) != 0} {
                  # puts "        -> \$angleRot(x) $angleRot(x)"
                set rotationMatrix [rotate_3D 1 0 0 $angleRot(x)]
                foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break

                  # puts "\n   -------------"
                  # puts $rotationMatrix
                
                set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
                set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
                set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
                
                  # puts "     -> $result(x)"
                  # puts "     -> $result(y)"
                  # puts "     -> $result(z)"
                
                set pointPos(x) $result(x)
                set pointPos(y) $result(y)
                set pointPos(z) $result(z)
            }
              # parray pointPos


              #
              # -- rotate about Y-Axis
              #
            if {$angleRot(y) != 0} {
                  # puts "        -> \$angleRot(y) $angleRot(y)"
                set rotationMatrix [rotate_3D 0 1 0 $angleRot(y)]
                foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break

                  # puts "\n   -------------"
                  # puts $rotationMatrix
                
                set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
                set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
                set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
                
                  # puts "     -> $result(x)"
                  # puts "     -> $result(y)"
                  # puts "     -> $result(z)"
                
                set pointPos(x) $result(x)
                set pointPos(y) $result(y)
                set pointPos(z) $result(z)
            }
              # parray pointPos


              #
              # -- rotate about Z-Axis
              #
            if {$angleRot(z) != 0} {
                  # puts "        -> \$angleRot(z) $angleRot(z)"
                set rotationMatrix [rotate_3D 0 0 1  $angleRot(z)]
                foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break

                  # puts "\n   -------------"
                  # puts $rotationMatrix
                
                set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
                set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
                set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
                
                  # puts "     -> $result(x)"
                  # puts "     -> $result(y)"
                  # puts "     -> $result(z)"
                
                set pointPos(x) $result(x)
                set pointPos(y) $result(y)
                set pointPos(z) $result(z)
            }
              # parray pointPos


              #
            return [list $pointPos(x) $pointPos(y) $pointPos(z)]
        
        }

















 
    proc setRotationMatrix {rotate_x rotate_y rotate_z} {

        # θ theta ... Winkel um z-Achse (x1-Achse)
        # ψ psi ..... Winkel um y-Achse (x2-Achse)
        # φ phi ..... Winkel um x-Achse (x3-Achse)
        
        variable rotationMatrix

          # http://de.wikipedia.org/wiki/Eulersche_Winkel
          # 1. rotate about z-axis
          # 2. rotate about y-axis
          # 1. rotate about x-axis
        set x [vectormath::rad $rotate_x]
        set y [vectormath::rad $rotate_y]
        set z [vectormath::rad $rotate_z]
          #   cos(y)*cos(z)                           -cos(y)*sin(z)                          -sin(y)
          #  -sin(x)*sin(y)*cos(z) + cox(x)*sin(z)     sin(x)*sin(y)*sin(z) + cos(x)*cox(z)   -sin(x)*cos(y) 
          #   cos(x)*sin(y)*cos(z) + sin(x)*sin(z)    -cos(x)*sin(y)*sin(z) + sin(x)*cos(z)    cos(x)*cos(y)  
        set rotationMatrix(1-1) [expr  cos($y)*cos($z)]  
        set rotationMatrix(1-2) [expr -cos($y)*sin($z)]
        set rotationMatrix(1-3) [expr  sin($y)]
        
        set rotationMatrix(2-1) [expr -sin($x)*sin($y)*cos($z) + cos($x)*sin($z)]    
        set rotationMatrix(2-2) [expr  sin($x)*sin($y)*sin($z) + cos($x)*cos($z)]  
        set rotationMatrix(2-3) [expr -sin($x)*cos($y)]

        set rotationMatrix(3-1) [expr  cos($x)*sin($y)*cos($z) + sin($x)*sin($z)]
        set rotationMatrix(3-2) [expr -cos($x)*sin($y)*sin($z) + sin($x)*cos($z)]
        set rotationMatrix(3-3) [expr  cos($x)*cos($y)]
        
        puts "      ... \$rotationMatrix(1-1) ... [format "%3.4f"  $rotationMatrix(1-1)]"
        puts "      ... \$rotationMatrix(1-2) ... [format "%3.4f"  $rotationMatrix(1-2)]"
        puts "      ... \$rotationMatrix(1-3) ... [format "%3.4f"  $rotationMatrix(1-3)]"
        puts "      ... \$rotationMatrix(2-1) ... [format "%3.4f"  $rotationMatrix(2-1)]"
        puts "      ... \$rotationMatrix(2-2) ... [format "%3.4f"  $rotationMatrix(2-2)]"
        puts "      ... \$rotationMatrix(2-3) ... [format "%3.4f"  $rotationMatrix(2-3)]"
        puts "      ... \$rotationMatrix(3-1) ... [format "%3.4f"  $rotationMatrix(3-1)]"
        puts "      ... \$rotationMatrix(3-2) ... [format "%3.4f"  $rotationMatrix(3-2)]"
        puts "      ... \$rotationMatrix(3-3) ... [format "%3.4f"  $rotationMatrix(3-3)]"

        puts "        --------"    
        
    }



    proc insertFrameTube_ {tubeName} {
            variable targetText
            variable rattleCAD_DOM
            
            variable project_NodeCount
            
            set nodeList  {}            
            set nodeCount 0
            
            set tubeProfile  [[$rattleCAD_DOM selectNodes /root/Result/Tubes/$tubeName/Polygon/text()] asXML]
              #
              # -- $targetText insert end $tubeProfile
              #

              #
            $targetText insert end "#\n"
            $targetText insert end "#     -> $tubeName -- create --\n"
            $targetText insert end "#     -> \$project_NodeCount $project_NodeCount \n"                
            $targetText insert end "#\n"
              #
              
              #
            puts "   ->  $tubeName [llength $tubeProfile] $tubeProfile"
            foreach node $tubeProfile {
                foreach {x y} [split $node ,] break
                lappend nodeList [list $x $y 0.00]
                $targetText insert end "v $x $y 0.00\n"
                incr nodeCount
            }       
              #
              
              #
            set project_LastCount $project_NodeCount
            set project_NodeCount [expr $project_NodeCount + [llength $nodeList]]  
              #            
            $targetText insert end "#\n"
            $targetText insert end "#    -> \$project_NodeCount $project_NodeCount \n"                
              #            
            $targetText insert end "#\n"
            $targetText insert end "g $tubeName\n"
            $targetText insert end "usemtl blue\n"
            $targetText insert end "#\n"
              #
              
              #
            set profile_Face {}
            for {set x 0} {$x < $nodeCount} {incr x} {
                append profile_Face [format "%s " [expr $x + 1 + $project_LastCount]]
            }
            $targetText insert end "f $profile_Face\n"
              #
              
              #
          
            $targetText insert end "#\n"            
            $targetText insert end "# -- $tubeName -- close --\n"
            $targetText insert end "#\n"
              #
              
              #
            return            
              #

    }
    proc insertDownTube {} {
            variable targetText
            variable rattleCAD_DOM
            
            variable project_NodeCount
            
            set nodeList  0            
            set nodeCount 0
            
            set profile_DownTube  [[$rattleCAD_DOM selectNodes /root/Result/Tubes/DownTube/Polygon/text()] asXML]
              #
              # -- $targetText insert end $profile_DownTube
              #

              #
            foreach node $profile_DownTube {
                foreach {x y} [split $node ,] break
                lappend nodeList [list $x $y 0.00]
                $targetText insert end "v $x $y 0.00\n"
                incr nodeCount
            }       
              #
              
              #
            $targetText insert end "#\n"
            $targetText insert end "# -- downtube --\n"
            $targetText insert end "#\n"
            $targetText insert end "g downtube\n"
            $targetText insert end "usemtl blue\n"
            $targetText insert end "#\n"
              #
              
              #
            set downTube_Face {}
            #while {$nodeCount > 0} {}
            for {set x 1} {$x <= $nodeCount} {incr x} {
                append downTube_Face [format "%s " [expr $x + $project_NodeCount]]
            }
            $targetText insert end "f $downTube_Face\n"
              #
              
              #
            set project_NodeCount [expr $project_NodeCount + [llength $nodeList]]  
              #
              
              #
            return            
              #

    }

    
    
    proc insertMaterial {} {
    
        variable topTube_XY
        variable downTube_XY
        variable headTube_XY
        variable seatTube_XY
        variable chainStay_XY
        variable seatStay_XY
        variable nodeList_XY
    
    
            variable targetText
            variable rattleCAD_DOM

            variable materialName      
            variable materialStrength  
            variable materialPrecission
            
            $targetText insert end "Material,$materialName,$materialStrength,$materialPrecission\n"             
    }
    proc insertAS3 {} {
            variable targetText
            variable rattleCAD_DOM
            
            set i 1
            
            $targetText insert end "AS3DATA\n"
            $targetText insert end "AS3NODES\n"    

              # -- getPosition
            set RearWheel_01      [[$rattleCAD_DOM selectNodes /root/Result/Position/RearWheel/text()    ] asXML]
            set BottomBracket_02  [[$rattleCAD_DOM selectNodes /root/Result/Position/BottomBracket/text()] asXML]
            set SeatStay_03       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatStay/End/text()    ] asXML]
            set TopTube_04        [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/Start/text()   ] asXML]
            set SeatTube_05       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/SeatTube/End/text()    ] asXML]
            set HeadTube_06       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/Start/text()  ] asXML]
            set DownTube_07       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/DownTube/End/text()    ] asXML]
            set TopTube_08        [[$rattleCAD_DOM selectNodes /root/Result/Tubes/TopTube/End/text()     ] asXML]
            set HeadTube_09       [[$rattleCAD_DOM selectNodes /root/Result/Tubes/HeadTube/End/text()    ] asXML]
            set FrontWheel        [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            
            set Saddle            [[$rattleCAD_DOM selectNodes /root/Result/Position/SeatTubeSaddle/text() ] asXML]
            set HeadSetHeight     [[$rattleCAD_DOM selectNodes /root/Component/HeadSet/Height/Bottom/text()] asXML]
            set ForkHeight        [[$rattleCAD_DOM selectNodes /root/Component/Fork/Height/text()          ] asXML]
              # puts "  <D> $HeadSetHeight"
            set ForkTop           [addVector [split $HeadTube_06 ,] [unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $HeadSetHeight]]
            set ForkPerp          [addVector $ForkTop               [unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $ForkHeight   ]]
            
            set SeatTube_IS_hor   [intersectPoint [split $BottomBracket_02 ,] [split $SeatTube_05 ,] [split $TopTube_08 ,] [list 200 [lindex [split $TopTube_08 ,] 1] ]]
              # puts "   -> $SeatTube_IS_hor"
            #exit
            set BB_WheelBase      [intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $BottomBracket_02 ,] [list [lindex [split $BottomBracket_02 ,] 0] 200]]
            set Fork_WheelBase    [intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $HeadTube_09 ,] [split $HeadTube_06 ,]]
            
            set FrontWheel        [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            
              # -- insert Position
            $targetText insert end "$RearWheel_01\n"      ; #A
            $targetText insert end "$BottomBracket_02\n"  ; #B
            $targetText insert end "$SeatStay_03\n"       ; #C
            $targetText insert end "$TopTube_04\n"        ; #D
            $targetText insert end "$SeatTube_05\n"       ; #E
            $targetText insert end "[lindex $SeatTube_IS_hor 0],[lindex $SeatTube_IS_hor 1]\n"   ; #F
              #
            $targetText insert end "[lindex $ForkPerp 0],[lindex $ForkPerp 1]\n"          ; #G
            $targetText insert end "$FrontWheel\n"        ; #H
              #
            $targetText insert end "[lindex $ForkTop 0],[lindex $ForkTop 1]\n"           ; #I   
            $targetText insert end "$HeadTube_06\n"       ; #J  
            $targetText insert end "$DownTube_07\n"       ; #K  
            $targetText insert end "$TopTube_08\n"        ; #L  
            $targetText insert end "$HeadTube_09\n"       ; #M
              #
            $targetText insert end "[lindex $BB_WheelBase 0],[lindex $BB_WheelBase 1]\n"      ; #99   
            $targetText insert end "[lindex $Fork_WheelBase 0],[lindex $Fork_WheelBase 1]\n"    ; #100   
              #
            
            
              # AS3SECTIONS
            $targetText insert end "AS3SECTIONS\n"
            
              # -- Tube Lengths
            set chainStayLength   [pointDistance [split $RearWheel_01 ,]     [split $BottomBracket_02 ,]]
            set seatTubeLength    [pointDistance [split $BottomBracket_02 ,] [split $SeatTube_05 ,]     ]
            set seatStayLength    [pointDistance [split $RearWheel_01 ,]     [split $SeatStay_03 ,]     ]
            set downTubeLength    [pointDistance [split $BottomBracket_02 ,] [split $DownTube_07 ,]     ]
            set topTubeLength     [pointDistance [split $TopTube_04 ,]       [split $TopTube_08  ,]     ]
            set headTubeLength    [pointDistance [split $HeadTube_06 ,]      [split $HeadTube_09 ,]     ]
            
              # -- Tube Lengths
            $targetText insert end "0,30,20,0.5,5,1,1,1,CHAIN STAY,1,0,100,50,100,50,0.8,0.8,0.5,50,$chainStayLength,0.5\n"
            $targetText insert end "0,30,20,0.5,5,1,1,2,SEAT TUBE,1,0,100,50,100,50,0.8,0.8,0.5,50,$seatTubeLength,0.5\n"
            $targetText insert end "0,30,20,0.5,5,1,1,3,SEAT STAY,1,0,100,50,100,50,0.8,0.8,0.5,50,$seatStayLength,0.5\n"
            $targetText insert end "0,30,20,0.5,5,1,1,4,DOWN TUBE,1,0,100,50,100,50,0.8,0.8,0.5,50,$downTubeLength,0.5\n"
            $targetText insert end "0,30,20,0.5,5,1,1,5,TOP TUBE,1,0,100,50,100,50,0.8,0.8,0.5,50,$topTubeLength,0.5\n"
            $targetText insert end "0,30,20,0.5,5,1,1,6,HEAD TUBE,1,0,10,15,10,15,0.8,0.8,0.5,50,$headTubeLength,0.5\n"     
    }   


    
    proc splitTube {start end number} {
            set start [split $start ,]
            set end   [split $end   ,]
              # puts "   splitTube -> $start   <- [llength $start]"
              # puts "   splitTube -> $end     <- [llength $end]"
            
            set length    [pointDistance $start $end]
            set direction [unifyVector   $start $end]
            set segment   [expr $length / $number]
            set pointList {}
            set i 0
            while {$i < $number-1} {
                incr i
                set segPoint [addVector $start $direction [expr $segment * $i]]
                lappend pointList $segPoint
            }
            return $pointList
    }
    
      # -- procedures from: canvasCAD	->	vectormath.tcl
      # 
    proc pointDistance {p1 p2} { 
            # distance from  p1  to  p2 
            set vector [ subVector $p2 $p1 ]
            set length [ expr hypot([lindex $vector 0],[lindex $vector 1]) ] 
            return $length
    }
    proc addVector {v1 v2 {scaling 1}} {
            foreach {x1 y1} $v1 {x2 y2} $v2 break
              # puts "\n  -> $x1 / $scaling / $x2     $y1 / $scaling / $y2"
            return [list [expr {$x1 + $scaling*$x2}] [expr {$y1 + $scaling*$y2}]]
    }
    proc subVector {v1 v2} { 
            return [addVector $v1 $v2 -1] 
    }	
    proc unifyVector {p1 p2 {length {1.0}}} {
            # return vector with length 1 as default
            set vector 		[ addVector $p2 $p1 -1 ] 
            set vctLength 	[ expr hypot([lindex $vector 0],[lindex $vector 1]) ]
            if {$vctLength != 0} {
                set vector		[ addVector  {0 0}  $vector  [expr $length/$vctLength] ]
            } else {
                set vector		[ addVector  {0 0}  $vector ]
            }
            return $vector                     
    }
    proc intersectPoint {p1 p2 p3 p4   {errorMode {}} } {
          # puts "   -> intersectPoint $p1 $p2 $p3 $p4"
        return [intersectPointVector $p1 [subVector $p2 $p1] $p3 [subVector $p4 $p3]  $errorMode]
    } 
    proc intersectVector {v1 v2   {errorMode {}} } {
        set p1 [lindex $v1 0]
        set p2 [lindex $v1 1]
        set p3 [lindex $v2 0]
        set p4 [lindex $v2 1]
        return [intersectPointVector $p1 [subVector $p2 $p1] $p3 [subVector $p4 $p3]  $errorMode]
    }  
    proc intersectPointVector {p1 v1 p3 v3   {errorMode {}} } {
        foreach {x1 y1} $p1 {vx1 vy1} $v1 {x3 y3} $p3 {vx3 vy3} $v3 break

        set a $vx1
        set b [expr {-1 * $vx3}]
        set c $vy1
        set d [expr {-1 * $vy3}]
        set e [expr {$x3 - $x1}]
        set f [expr {$y3 - $y1}]

        set det [expr {double($a*$d - $b*$c)}]
        if {$det == 0} {
                  switch $errorMode {
                      {}  { error "Determinant is 0" }
                      {center} {
                              puts "\n   <E>\n   <E>  Determinant is 0 \n   <E>"
                              set p4 [ center $p1 $p3 ]
                              set p5 [ addVector $p4 [list [expr 0.5 * ($vx1 + $vx3)]  [expr 0.5 * ($vy1 + $vy3)] ] ]
                              return $p5
                          }
                      default {
                              error "Determinant is 0" 
                          }
                  }
              }

        set k [expr {($d*$e - $b*$f) / $det}]
        return [addVector $p1 $v1 $k]
    }


    
    
        # tk_messageBox -message "encoding system  [encoding system]"
    puts "encoding system  [encoding system]"
        
        # --- store fileName --
        #
    # set fileName {}

        # --- window ----------
        #
    pack [ frame .f -bg lightblue] 
        
        # -- buttonBar
        #
    set buttonBar    [ frame .f.bb ]
        pack $buttonBar      -expand yes -fill both 
    button $buttonBar.openProject    -text "  open rattleCAD-Project  "    -command openProject
    button $buttonBar.reloadProject  -text " reload rattleCAD-Project "    -command reloadProject
    label  $buttonBar.sp_00          -text "           "
    button $buttonBar.saveContent  -text " export to OBJ - 3D "            -command saveContent   
    label  $buttonBar.sp_01          -text "                                      "
    button $buttonBar.exit  -text " EXIT "                        -command exit   
        pack $buttonBar.openProject $buttonBar.reloadProject $buttonBar.sp_00 \
             $buttonBar.saveContent $buttonBar.sp_01 \
             $buttonBar.exit \
             -side left


        # -- textFrame
        #
    set textFrame    [ frame .f.tf ]
        pack $textFrame      -expand yes -fill both 
        
    set sourceFrame  [ frame    $textFrame.f_source       -relief sunken ]
    set targetFrame  [ frame    $textFrame.f_target       -relief sunken ]
        pack $sourceFrame $targetFrame \
             -side left

        # -- source
    set sourceText [ text $sourceFrame.txt -wrap none -xscroll "$sourceFrame.h set" \
                                                      -yscroll "$sourceFrame.v set" -height 46 -width 80 ]
    scrollbar $sourceFrame.v -orient vertical   -command "$sourceFrame.txt yview"
    scrollbar $sourceFrame.h -orient horizontal -command "$sourceFrame.txt xview"
        # Lay them out
        grid $sourceFrame.txt $sourceFrame.v  -sticky nsew
        grid $sourceFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $sourceFrame.txt 0 -weight 1
        grid columnconfigure $sourceFrame.txt 0 -weight 1 
        
        # -- target
    set targetText [ text $targetFrame.txt -wrap none -xscroll "$targetFrame.h set" \
                                                      -yscroll "$targetFrame.v set" -height 46 -width 80 ]
    scrollbar $targetFrame.v -orient vertical   -command "$targetFrame.txt yview"
    scrollbar $targetFrame.h -orient horizontal -command "$targetFrame.txt xview"
        # Lay them out
        grid $targetFrame.txt $targetFrame.v  -sticky nsew
        grid $targetFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $targetFrame.txt 0 -weight 1
        grid columnconfigure $targetFrame.txt 0 -weight 1 
             

        # -- open File
        if {[llength $argv] > 0} {
            set fileName [lindex $argv 0]
            puts "\n   ... $fileName"
            openProject "$fileName"
        } else {
            puts "\n   ... $fileName"
            if {$fileName != {}} {
                openProject "$fileName"
            } else {
                openProject
            }
        }
        
    
    