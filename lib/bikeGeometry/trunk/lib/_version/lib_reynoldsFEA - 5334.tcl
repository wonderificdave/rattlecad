 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_reynoldsFE.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2012/10/28
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
 #    namespace:  bikeGeometry::lib_reynoldsFE
 # ---------------------------------------------------------------------------
 #
 # 
 
 
namespace eval bikeGeometry::lib_reynoldsFEA {

    variable targetText     {}
    variable rattleCAD_DOM  {}
    
    variable companyName        "rattleCAD"
    variable companyContact     "rattleCAD.sourceforge.net"
    variable companyEmail       "rattleCAD@sourceforge.net"
    
    variable materialName       "Reynolds 531"
    variable materialStrength   "600"
    variable materialPrecission "2"


    proc get_Content {} {
            variable targetText
            variable rattleCAD_DOM
            
            set rattleCAD_DOM  [bikeGeometry::get_projectDOM]
        
                # -- cleanup outputs ------            
            set targetText {}
            
                # -- insert Project
            insertProject
            
                # -- insert Material
            insertMaterial
            
                # -- insert Nodes
            insertNodes
                
                # -- insert AS3
            insertAS3  

                # -- return Value
            return $targetText
    }
    
    proc insertProject {} {
            variable targetText
            variable rattleCAD_DOM    
            
            variable companyName    
            variable companyContact
            variable companyEmail
            # set project_Name     [$rattleCAD_DOM selectNodes
            
            set project_Version   [[$rattleCAD_DOM selectNodes /root/Project/rattleCADVersion/text()] asXML]
            set project_Name      [[$rattleCAD_DOM selectNodes /root/Project/Name/text()] asXML]
            set project_Modified  [[$rattleCAD_DOM selectNodes /root/Project/modified/text()] asXML]
            # puts "  ... $project_Version"
            
            append targetText "Design Reference,$project_Name\n" 
            append targetText "Company,$companyName\n" 
            append targetText "Contact,$companyContact\n" 
            append targetText "Email,$companyEmail\n" 
            append targetText "Created on $project_Modified\n" 
            #append targetText "Created on 18:1:46  Sat Apr 5 2014\n"
            
            if {1 == 2} {
                # <rattleCADVersion>3.3.06.38</rattleCADVersion>
                # <Name>_template_3.3.06.38_road.xml</Name>
                # <modified>2014.02.25 10:26</modified>
                
                # Design Reference,01
                # Company,03
                # Contact,02
                # Email,04
            }
    }

    proc insertMaterial {} {
            variable targetText
            variable rattleCAD_DOM

            variable materialName      
            variable materialStrength  
            variable materialPrecission
            
            append targetText "Material,$materialName,$materialStrength,$materialPrecission\n"             
    }

    proc insertNodes {} {
            variable targetText
            variable rattleCAD_DOM
            
            set i 1
            
            append targetText "NODES\n"
            append targetText "NODE,X,Y,SUPPORT\n"
            
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
            
              # -- insertPosition
            append targetText "$i,$RearWheel_01,xy\n";  incr i
            append targetText "$i,$BottomBracket_02\n"; incr i
            append targetText "$i,$SeatStay_03\n";      incr i
            append targetText "$i,$TopTube_04\n";       incr i
            append targetText "$i,$SeatTube_05\n";      incr i
            append targetText "$i,$HeadTube_06,y\n";    incr i
            append targetText "$i,$DownTube_07\n";      incr i
            append targetText "$i,$TopTube_08\n";       incr i
            append targetText "$i,$HeadTube_09\n";      incr i
            
              # -- ChainStay-Segments
            set pointList [splitTube $BottomBracket_02 $RearWheel_01 4]
            foreach point $pointList {
                foreach {x y} $point break
                append targetText "$i,$x,$y\n";         incr i
            }
              # -- SeatTube-Segments
            set pointList [splitTube $BottomBracket_02  $SeatTube_05 5]
            foreach point $pointList {
                foreach {x y} $point break
                append targetText "$i,$x,$y\n";         incr i
            }  
              # -- SeatStay-Segments
            set pointList [splitTube $RearWheel_01      $SeatStay_03 6]
            foreach point $pointList {
                foreach {x y} $point break
                append targetText "$i,$x,$y\n";         incr i
            }  
              # -- DownTube-Segments
            set pointList [splitTube $BottomBracket_02  $DownTube_07 7]
            foreach point $pointList {
                foreach {x y} $point break
                append targetText "$i,$x,$y\n";         incr i
            }  
              # -- TopTube-Segments
            set pointList [splitTube $TopTube_04        $TopTube_08 6]
            foreach point $pointList {
                foreach {x y} $point break
                append targetText "$i,$x,$y\n";         incr i
            }  
    }

    proc insertAS3 {} {
            variable targetText
            variable rattleCAD_DOM
            
            set i 1
            
            append targetText "AS3DATA\n"
            append targetText "AS3NODES\n"    

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
            set ForkTop           [vectormath::addVector [split $HeadTube_06 ,] [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $HeadSetHeight]]
            set ForkPerp          [vectormath::addVector $ForkTop               [vectormath::unifyVector [split $HeadTube_09 ,] [split $HeadTube_06 ,] $ForkHeight   ]]
            
            set SeatTube_IS_hor   [vectormath::intersectPoint [split $BottomBracket_02 ,] [split $SeatTube_05 ,] [split $TopTube_08 ,] [list 200 [lindex [split $TopTube_08 ,] 1] ]]
                # puts "   -> $SeatTube_IS_hor"
                # exit
            set BB_WheelBase      [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $BottomBracket_02 ,] [list [lindex [split $BottomBracket_02 ,] 0] 200]]
            set Fork_WheelBase    [vectormath::intersectPoint [split $RearWheel_01 ,] [split $FrontWheel ,] [split $HeadTube_09 ,] [split $HeadTube_06 ,]]
            
            set FrontWheel        [[$rattleCAD_DOM selectNodes /root/Result/Position/FrontWheel/text()   ] asXML]
            
              # -- insert Position
            append targetText "$RearWheel_01\n"      ; #A
            append targetText "$BottomBracket_02\n"  ; #B
            append targetText "$SeatStay_03\n"       ; #C
            append targetText "$TopTube_04\n"        ; #D
            append targetText "$SeatTube_05\n"       ; #E
            append targetText "[lindex $SeatTube_IS_hor 0],[lindex $SeatTube_IS_hor 1]\n"   ; #F
              #
            append targetText "[lindex $ForkPerp 0],[lindex $ForkPerp 1]\n"          ; #G
            append targetText "$FrontWheel\n"        ; #H
              #
            append targetText "[lindex $ForkTop 0],[lindex $ForkTop 1]\n"           ; #I   
            append targetText "$HeadTube_06\n"       ; #J  
            append targetText "$DownTube_07\n"       ; #K  
            append targetText "$TopTube_08\n"        ; #L  
            append targetText "$HeadTube_09\n"       ; #M
              #
            append targetText "[lindex $BB_WheelBase 0],[lindex $BB_WheelBase 1]\n"      ; #99   
            append targetText "[lindex $Fork_WheelBase 0],[lindex $Fork_WheelBase 1]\n"    ; #100   
              #
            
            
              # AS3SECTIONS
            append targetText "AS3SECTIONS\n"
            
              # -- Tube Lengths
            set chainStayLength   [vectormath::length [split $RearWheel_01 ,]     [split $BottomBracket_02 ,]]
            set seatTubeLength    [vectormath::length [split $BottomBracket_02 ,] [split $SeatTube_05 ,]     ]
            set seatStayLength    [vectormath::length [split $RearWheel_01 ,]     [split $SeatStay_03 ,]     ]
            set downTubeLength    [vectormath::length [split $BottomBracket_02 ,] [split $DownTube_07 ,]     ]
            set topTubeLength     [vectormath::length [split $TopTube_04 ,]       [split $TopTube_08  ,]     ]
            set headTubeLength    [vectormath::length [split $HeadTube_06 ,]      [split $HeadTube_09 ,]     ]
            
              # -- Tube Diameter
            set chainStayDiameter [[$rattleCAD_DOM selectNodes /root/FrameTubes/ChainStay/HeightBB/text()  ] asXML]
            set seatTubeDiameter  [[$rattleCAD_DOM selectNodes /root/FrameTubes/SeatTube/DiameterTT/text() ] asXML]
            set seatStayDiameter  [[$rattleCAD_DOM selectNodes /root/FrameTubes/SeatStay/DiameterST/text() ] asXML]
            set downTubeDiameter  [[$rattleCAD_DOM selectNodes /root/FrameTubes/DownTube/DiameterBB/text() ] asXML]
            set topTubeDiameter   [[$rattleCAD_DOM selectNodes /root/FrameTubes/TopTube/DiameterHT/text()  ] asXML]
            set headTubeDiameter  [[$rattleCAD_DOM selectNodes /root/FrameTubes/HeadTube/Diameter/text()   ] asXML]
            
              # -- Tube Lengths
            append targetText [format "0,%s,20,0.5,5,1,1,1,%s,1,0,100,50,100,50,0.8,0.8,0.5,50,%s,0.5\n"    $chainStayDiameter {CHAIN STAY} $chainStayLength]
            append targetText [format "0,%s,20,0.5,5,1,1,2,%s,1,0,100,50,100,50,0.8,0.8,0.5,50,%s,0.5\n"    $seatTubeDiameter  {SEAT TUBE}  $seatTubeLength ]
            append targetText [format "0,%s,20,0.5,5,1,1,3,%s,1,0,100,50,100,50,0.8,0.8,0.5,50,%s,0.5\n"    $seatStayDiameter  {SEAT STAY}  $seatStayLength ]
            append targetText [format "0,%s,20,0.5,5,1,1,4,%s,1,0,100,50,100,50,0.8,0.8,0.5,50,%s,0.5\n"    $downTubeDiameter  {DOWN TUBE}  $downTubeLength ]
            append targetText [format "0,%s,20,0.5,5,1,1,5,%s,1,0,100,50,100,50,0.8,0.8,0.5,50,%s,0.5\n"    $topTubeDiameter   {TOP TUBE}   $topTubeLength  ]
            append targetText [format "0,%s,20,0.5,5,1,1,6,%s,1,0,10,15,10,15,0.8,0.8,0.5,50,%s,0.5\n"      $headTubeDiameter  {HEAD TUBE}  $headTubeLength ]
    }   


    
    proc splitTube {start end number} {
            set start [split $start ,]
            set end   [split $end   ,]
              # puts "   splitTube -> $start   <- [llength $start]"
              # puts "   splitTube -> $end     <- [llength $end]"
            
            set length    [vectormath::length $start $end]
            set direction [vectormath::unifyVector   $start $end]
            set segment   [expr $length / $number]
            set pointList {}
            set i 0
            while {$i < $number-1} {
                incr i
                set segPoint [vectormath::addVector $start $direction [expr $segment * $i]]
                lappend pointList $segPoint
            }
            return $pointList
    }
    
}
