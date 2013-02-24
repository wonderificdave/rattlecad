#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # 
 #
 # http://wiki.tcl.tk/3884 - Richard Suchenwirth - 2002-08-13
 # http://wiki.tcl.tk/10530 - Greg Blair - 2003-09-29    
 #
 # add a converter to read SVG-Path and convert path-Elements into polygon & polyline
 #
 # http://www.w3.org/TR/SVG/expanded-toc.html
 #
 # http://www.selfsvg.info/?section=3.5
 #
 #

    package require Tk
    package require tdom
 
    

	proc mirrorPoint {p a} {
            # reflects point p on line {{0 0} a}
        
            foreach {px py} $p  {ax ay} $a  break;

            if {$px == $ax && $py == $ay} {
                # return empty an handle on calling position if points are coincindent
                # puts "  .. hot wos";
                return {}
            }
            
            
            set CONST_PI [ expr 4*atan(1) ]
                # puts "\n       ... start:      0 / 0  --   --  $px / $py  --  $ax / $ay"
        

            set alpha [expr atan2($ay,$ax)]
                # puts "       ... \$alpha $alpha   [expr $alpha * 180 / $CONST_PI]"
            

            set beta [expr atan2($py,$px)]
                # puts "       ... \$beta  $beta    [expr $beta * 180 / $CONST_PI]"


                # -- angular gap of a and p
            set delta [expr 1.0*$beta - $alpha]
                # puts "       ... \$delta $delta    [expr $delta  * 180 / $CONST_PI]"    


                # -- rotation mirrored point p
            set gamma [expr -2.0*$delta]
                # puts "       ... \$gamma $gamma    [expr $gamma  * 180 / $CONST_PI]"


                # -- new temporary position of p
                # puts "       ... temporary:  $px $py _____________________________"
            set xx [ expr hypot($px,$py) * cos($beta + $gamma) ]
            set yy [ expr hypot($px,$py) * sin($beta + $gamma) ]

            
                # puts "       ... temporary:  $xx $yy _____________________________"


            # -- new position of p
            set x [expr $ax - $xx]
            set y [expr $ay - $yy]
                # puts "       ... result:      $x $y"
            
                # puts "\n       ... start:      0 0  --  $x $y  --  $px $py  --  $ax $ay"
            return [list $x $y]                                        
    }	


    proc Bezier {xy {PRECISION 10}} {
                # puts "           -> $xy"
            set PRECISION 8
            set np [expr {[llength $xy] / 2}]
            if {$np < 4} return
            
            proc BezierSpline {a b c d mu} {
                    # --------------------------------------------------------
                    # http://www.cubic.org/~submissive/sourcerer/bezier.htm
                    # evaluate a point on a bezier-curve. mu goes from 0 to 1.0
                    # --------------------------------------------------------

                    set  ab   [Lerp $a    $b    $mu]
                    set  bc   [Lerp $b    $c    $mu]
                    set  cd   [Lerp $c    $d    $mu]
                    set  abbc [Lerp $ab   $bc   $mu]
                    set  bccd [Lerp $bc   $cd   $mu]
                    return    [Lerp $abbc $bccd $mu]
            }

            proc Lerp {a b mu} {
                    # -------------------------------------------------
                    # http://www.cubic.org/~submissive/sourcerer/bezier.htm
                    # simple linear interpolation between two points
                    # -------------------------------------------------
                    set ax [lindex $a 0]
                    set ay [lindex $a 1]
                    set bx [lindex $b 0]
                    set by [lindex $b 1]
                    return [list [expr {$ax + ($bx-$ax)*$mu}] [expr {$ay + ($by-$ay)*$mu}] ]
            }

            set idx 0
            foreach {x y} $xy {
            set X($idx) $x
            set Y($idx) $y
            incr idx
            }

            set xy {}

            set idx 0
            while {[expr {$idx+4}] <= $np} {
                set a [list $X($idx) $Y($idx)]; incr idx
                set b [list $X($idx) $Y($idx)]; incr idx
                set c [list $X($idx) $Y($idx)]; incr idx
                set d [list $X($idx) $Y($idx)];# incr idx   ;# use last pt as 1st pt of next segment
                for {set j 0} {$j <= $PRECISION} {incr j} {
                    set mu [expr {double($j) / double($PRECISION)}]
                    set pt [BezierSpline $a $b $c $d $mu]
                    lappend xy [lindex $pt 0] [lindex $pt 1]
                }
            }
                # puts "             -> $xy"
            return $xy
    }

	
	proc filterList {inputList {filter {}}} {
			set returnList {}
			foreach value $inputList {
				if {$value == $filter} {continue}
				set value     [string trim $value]
				set pointList [lappend returnList $value]
			}
			return $returnList
	}   

	

    proc absolutPath {pathDefinition {position {0 0}} } {
    
        set transform(x) [lindex $position 0]
        set transform(y) [lindex $position 1]
        
        set pathValueList   [string map { M {_M_}   Z {_Z_}   L {_L_}   H {_H_}   V {_V_}   C {_C_}   S {_S_}   Q {_Q_}   T {_T_}   A {_A_}   \
                                          m {_m_}   z {_Z_}   l {_l_}   h {_h_}   v {_v_}   c {_c_}   s {_s_}   q {_q_}   t {_t_}   a {_a_} \
                                         {-} {_-}  {,} {_} } \
                                        [string trim $pathDefinition] ]
        set pathValueList   [split $pathValueList {_ }]        
        
        
        set pathValueList [filterList $pathValueList]
            # puts "$pathDefList\n   ______pathDefList_____"
        
        
            # -- internal procedure: return 1 if $value is a control-character in SVG-path element
            #
            proc checkControl {value} {
                set controlChar [string map { M  {__}    Z  {__}    L  {__}    H  {__}    V  {__}    C  {__}    S  {__}    Q  {__}    T  {__}    A  {__}    \
                                              m  {__}    z  {__}    l  {__}    h  {__}    v  {__}    c  {__}    s  {__}    q  {__}    t  {__}    a  {__} } \
                                             $value ]
                if {$controlChar == {__}} {
                    return 1
                } else {
                    return 0
                }
            }
        
        
            # -- convert all relative values to absolute values
            #
        array \
            set penPosition    { x 0 \
                                 y 0 }
                                 
        
            # -- loop throug pathValueList
            #
        set pathValueList_abs     {}
        set listIndex            0
        while {$listIndex < [llength $pathValueList]} { 
                
                # -- get value at Position
                    #
            set value [lindex $pathValueList $listIndex]
                            
                # -- get next Index
                    #
            incr listIndex
                
                # -- check value on 
                    #
            if {[checkControl $value]} {
                    # puts "    ... $value"
                switch -exact $value {
                    M {            # puts "    $value  ... implemented yet"
                            set penPosition(x)       [expr [lindex $pathValueList $listIndex] + $transform(x)]    ; incr listIndex 
                            set penPosition(y)       [expr [lindex $pathValueList $listIndex] + $transform(y)]    ; incr listIndex
                            set pathValueList_abs    [lappend pathValueList_abs $value $penPosition(x) $penPosition(y)]
                        }
                    m {             # puts "    $value  ... implemented yet"
                            set pathValueList_abs        [lappend pathValueList_abs M]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                    # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)       [expr $x + $penPosition(x)]    ; incr listIndex 
                                set penPosition(y)       [expr $y + $penPosition(y)]    ; incr listIndex
                                set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                            }
                        }
                    l {     # puts "    $value  ... implemented yet"
                            set pathValueList_abs    [lappend pathValueList_abs L]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                    # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)       [expr $x + $penPosition(x)]    ; incr listIndex 
                                set penPosition(y)       [expr $y + $penPosition(y)]    ; incr listIndex
                                set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                            }
                        }
                    c {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs        [lappend pathValueList_abs C]
                            set bezierIndex    0
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                    # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}
                                set ctrlPosition(x)      [expr $x + $penPosition(x)]    ; incr listIndex
                                set ctrlPosition(y)      [expr $y + $penPosition(y)]    ; incr listIndex
                                set pathValueList_abs    [lappend pathValueList_abs $ctrlPosition(x) $ctrlPosition(y)]
                                incr bezierIndex
                                if {$bezierIndex > 2} {
                                    set penPosition(x)         $ctrlPosition(x) 
                                    set penPosition(y)         $ctrlPosition(y)
                                    set bezierIndex 0
                                }
                            }
                        }
                    h {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set x     [lindex $pathValueList $listIndex]
                            if {[checkControl $x]} {continue}
                            set penPosition(x)          [expr $x + $penPosition(x)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    v {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set y     [lindex $pathValueList $listIndex]
                            if {[checkControl $y]} {continue}
                            set penPosition(y)          [expr $y + $penPosition(y)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    L  {       # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                    # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)      [expr $x  + $transform(x)]    ; incr listIndex 
                                set penPosition(y)      [expr $y  + $transform(y)]    ; incr listIndex
                                set pathValueList_abs   [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                                # puts "  [checkControl $x]
                            }
                        }                    
                    H {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set x     [lindex $pathValueList $listIndex]
                            if {[checkControl $x]} {continue}
                            set penPosition(x)          [expr $x  + $transform(x)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    V {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set y     [lindex $pathValueList $listIndex]
                            if {[checkControl $y]} {continue}
                            set penPosition(y)          [expr $y  + $transform(y)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    C {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs C]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                     # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)      [expr $x + $transform(x)]    ; incr listIndex 
                                set penPosition(y)      [expr $y + $transform(y)]    ; incr listIndex
                                set pathValueList_abs   [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                                # puts "  [checkControl $x]
                            }
                        }                    
                    S {       # puts "    $value  ... implemented yet"
                            set pathValueList_abs    [lappend pathValueList_abs C]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {ctrl_x ctrl_y base_x base_y} [lrange $pathValueList $listIndex end] {
                                        # puts " ... $listIndex"
                                    if {[checkControl $ctrl_x]} {break}                           
                                    if {[checkControl $base_x]} {break}                           
                                    incr listIndex 4
                                    set ctrl_dx  [expr $ctrl_x - $penPosition(x)]
                                    set ctrl_dy  [expr $ctrl_y - $penPosition(y)]
                                    set base_dx  [expr $base_x - $penPosition(x)]
                                    set base_dy  [expr $base_y - $penPosition(y)]
                                    
                                    set ctrVector [ mirrorPoint [list $ctrl_dx $ctrl_dy] [list $base_dx $base_dy]] 
                                        # puts "  ... ctrVector  $ctrVector"
                                    set ctrl_1(x)      [expr $penPosition(x) + [lindex $ctrVector 0]]
                                    set ctrl_1(y)      [expr $penPosition(y) + [lindex $ctrVector 1]]
                                    set ctrl_2(x)      $ctrl_x
                                    set ctrl_2(y)      $ctrl_y
                                        # puts "     ---------------------------------------"
                                        # puts "      $penPosition(x) $penPosition(y)"
                                        # puts "      $ctrl_1(x) $ctrl_1(y)"
                                        # puts "      $ctrl_2(x) $ctrl_2(y)"
                                        # puts "      $base_x $base_y"
                                    set penPosition(x) $base_x
                                    set penPosition(y) $base_y
                                    set pathValueList_abs [lappend pathValueList_abs $ctrl_1(x) $ctrl_1(y) $ctrl_2(x) $ctrl_2(y) $penPosition(x) $penPosition(y)]
                            }
                        }
                    s {       # puts "    $value  ... implemented yet"
                            set pathValueList_abs    [lappend pathValueList_abs C]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {ctrl_x ctrl_y base_x base_y} [lrange $pathValueList $listIndex end] {
                                        # puts " ... $listIndex"
                                    if {[checkControl $ctrl_x]} {break}                           
                                    if {[checkControl $base_x]} {break}                           
                                    incr listIndex 4
                                    set ctrVector [ mirrorPoint [list $ctrl_x  $ctrl_y] [list $base_x $base_y]]                                     
                                            # puts "  ... ctrVector  $ctrVector"
                                    if {$ctrVector == {}} {
                                        set pathValueList_abs    [lrange $pathValueList_abs 0 end-1]
                                        set penPosition(x) [expr $penPosition(x) + $base_x]
                                        set penPosition(y) [expr $penPosition(y) + $base_y]
                                        set pathValueList_abs [lappend pathValueList_abs L $penPosition(x) $penPosition(y)]
                                            # puts "   ... exception:  $pathValueList_abs"
                                    } else {                                            
                                        set ctrl_1(x)      [expr $penPosition(x) + [lindex $ctrVector 0]]
                                        set ctrl_1(y)      [expr $penPosition(y) + [lindex $ctrVector 1]]
                                        set ctrl_2(x)      [expr $penPosition(x) + $ctrl_x]
                                        set ctrl_2(y)      [expr $penPosition(y) + $ctrl_y]
                                        set base_2(x)      [expr $penPosition(x) + $base_x]
                                        set base_2(y)      [expr $penPosition(y) + $base_y]
                                            # puts "     ---------------------------------------"
                                            # puts "      $penPosition(x) $penPosition(y)"
                                            # puts "      $ctrl_1(x) $ctrl_1(y)"
                                            # puts "      $ctrl_2(x) $ctrl_2(y)"
                                            # puts "      $base_2(x) $base_2(y)"
                                        set penPosition(x) [expr $penPosition(x) + $base_x]
                                        set penPosition(y) [expr $penPosition(y) + $base_y]
                                        set pathValueList_abs [lappend pathValueList_abs $ctrl_1(x) $ctrl_1(y) $ctrl_2(x) $ctrl_2(y) $penPosition(x) $penPosition(y)]
                                    }
                            }
                        }
                    Q -
                    T -
                    A -
                    q -
                    t -
                    a {
                        # incr listIndex
                        puts "    $value  ... not implemented yet  - $listIndex"
                    }
                    Z -
                    z {
                            # puts "    $value  ... implemented yet  - $listIndex" 
                            set pathValueList_abs    [lappend pathValueList_abs Z]                        
                    }

                    default {
                        # incr listIndex
                        puts "    $value  ... not registered yet  - $listIndex"
                    }    
                }
            
            }
        }
                    
        return $pathValueList_abs
    }


    proc simplifySVG {domSVG {parentTransform {0 0}}} {
            
            puts "\n"
            puts "  =============================================="
            puts "   -- simplifySVG"
            puts "  =============================================="
            puts "\n"

            variable flatSVG
                # puts "  ... [ $flatSVG asXML]\n"
            set root [ $flatSVG documentElement ]
                # puts "  ... [ $root asXML]\n"
            set transform(parent) $parentTransform
            foreach {transform(parent_x) transform(parent_y)} $transform(parent) break;
                # puts "       ... parent:  $transform(parent_x) / $transform(parent_y)\n"
            
            
                # puts " --- simplifySVG --"
            foreach node [$domSVG childNodes] {
                        # puts "   ... $node"
                    if {[$node nodeType] != {ELEMENT_NODE}} continue
                
                        # -- set defaults
                    set objectPoints {}


                        # -- get transform attribute
                    if {[catch {set transform(this)  [ $node getAttribute transform ]} errmsg] } {
                        set transform(this_x) 0
                        set transform(this_y) 0
                    } else {
                        set transform(this)  [ lrange [ split [ $node getAttribute transform ] (,) ] 1 2]
                        foreach {transform(this_x) transform(this_y)} $transform(this) break
                    }
                    
                        # puts "       ... this:    $transform(this_x) / $transform(this_y)"
                    set transform(this_x) [expr $transform(this_x) + $transform(parent_x)] 
                    set transform(this_y) [expr $transform(this_y) + $transform(parent_y)] 
                        # puts "         ... this:  $transform(this_x) / $transform(this_y)\n"
                    
                        # -- get nodeName
                    set nodeName [$node nodeName]
                    
                        # puts "  ... $nodeName :"
                        # puts "     ... $transform(this_x) / $transform(this_y)"

                    
                    switch -exact $nodeName {
                            g {
                                            # puts "\n\n  ... looping"
                                            # puts "   [$node asXML]"
                                        simplifySVG $node [list $transform(this_x) $transform(this_y)]
                                }
                            rect {
                                        set myNode [ $flatSVG createElement $nodeName]
                                            $myNode setAttribute x               [ expr [ $node getAttribute x ] + $transform(this_x) ]
                                            $myNode setAttribute y               [ expr [ $node getAttribute y ] + $transform(this_y) ]
                                            $myNode setAttribute width           [ $node getAttribute width  ]
                                            $myNode setAttribute height          [ $node getAttribute height ]
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            polygon {
                                        set pointList     [split [string map {, { }} [$node getAttribute points ] ] ]
										set pointList     [filterList $pointList {}]
										set valueList     {}
                                        foreach {x y} $pointList {
                                            set x          [expr $x + + $transform(this_x) ]
                                            set y          [expr $y + + $transform(this_y) ]
                                            set valueList  [lappend valueList $x,$y]
                                        }
                                        set myNode         [ $flatSVG createElement     $nodeName]
                                            $myNode setAttribute points          $valueList
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
                                        set pointList     [split [string map {, { }} [$node getAttribute points ] ] ]
										set pointList     [filterList $pointList {}]
                                        set valueList     {}
                                        foreach {x y} $pointList {
                                            set x          [expr $x + + $transform(this_x) ]
                                            set y          [expr $y + + $transform(this_y) ]
                                            set valueList  [lappend valueList $x,$y]
                                        }
                                        set myNode         [ $flatSVG createElement $nodeName]
                                            $myNode setAttribute points          $valueList
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
                                        set myNode         [ $flatSVG createElement $nodeName]
                                            $myNode setAttribute x1              [ expr [ $node getAttribute x1 ] + $transform(this_x) ]
                                            $myNode setAttribute y1              [ expr [ $node getAttribute y1 ] + $transform(this_y) ]
                                            $myNode setAttribute x2              [ expr [ $node getAttribute x2 ] + $transform(this_x) ]
                                            $myNode setAttribute y2              [ expr [ $node getAttribute y2 ] + $transform(this_y) ]
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                        # --- dont display the center_object with id="center_00"
                                        set myNode         [ $flatSVG createElement $nodeName]
                                            $myNode setAttribute cx              [ expr [ $node getAttribute cx ] + $transform(this_x) ]
                                            $myNode setAttribute cy              [ expr [ $node getAttribute cy ] + $transform(this_y) ]
                                            $myNode setAttribute rx              [ $node getAttribute rx  ]
                                            $myNode setAttribute ry              [ $node getAttribute ry  ]
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                        # --- dont display the center_object with id="center_00"
                                        set myNode         [ $flatSVG createElement $nodeName]
                                            $myNode setAttribute cx              [ expr [ $node getAttribute cx ] + $transform(this_x) ]
                                            $myNode setAttribute cy              [ expr [ $node getAttribute cy ] + $transform(this_y) ]
                                            $myNode setAttribute r               [ $node getAttribute r  ]
                                            $myNode setAttribute fill            none
                                            $myNode setAttribute stroke          black
                                            $myNode setAttribute stroke-width    0.1
                                        $root appendChild $myNode
                                }
                            path { # path d="M ......."
                                        # absolutPath
                                        set svgPath     [ absolutPath [ $node getAttribute d ] [ list $transform(this_x) $transform(this_y)] ]
                                        set splitIndex    [lsearch -exact -all $svgPath {M}]
                                        set splitIndex    [lappend splitIndex end]
                                            set i 0
                                        while {$i < [llength $splitIndex]-1} {
                                                set indexStart     [lindex $splitIndex $i]
                                                set indexEnd       [lindex $splitIndex $i+1]
                                                incr i
                                                
                                                if {$indexEnd != {end}} {set indexEnd [expr $indexEnd -1 ]}
                                                set pathSegment [lrange $svgPath $indexStart $indexEnd ]
                                                    # puts "   ... $indexStart / $indexEnd"
                                                    # puts "   ... $i   [lindex $splitIndex $i]"
                                                    # puts "      ... $pathSegment"
                                                
                                                
                                                if { [lindex $pathSegment end] == {Z} } {
                                                        set pathSegment        [string trim [string map {Z { }} $pathSegment] ]
                                                        set elementType     polygon
                                                } else {
                                                        set elementType     polyline
                                                }
                                                    # puts "\n$pathSegment\n_________pathSegment________"
                                                set objectPoints [ convertPath2Line $pathSegment ]
                                                    # puts "\n$objectPoints\n_________objectPoints________"

                                                set myNode [ $flatSVG createElement $elementType]
                                                    $myNode setAttribute points          $objectPoints
                                                    $myNode setAttribute fill            none
                                                    $myNode setAttribute stroke          black
                                                    $myNode setAttribute stroke-width    0.1
                                                $root appendChild $myNode
                                        }
                                        
                                        # puts "       ... search for:   [lsearch -exact -all $svgPath {M}]\n"

                                }        

                            default { }
                    }
                    # puts "        $nodeName:  $objectPoints"
                
            }
            
                # puts [$root asXML]
            return $root
    }


    proc convertPath2Line {pathDefinition} {
            # -------------------------------------------------
            # http://www.selfsvg.info/?section=3.5
            # 
            # -------------------------------------------------
                # puts "\n\n === new pathString =====================\n"        

                # puts "\npathString:\n  $pathString\n"            
            
                # puts " - > pathDefinition:\n$pathDefinition\n"

            
            set canvasElementType     line
            set controlString        {}
            set isClosed            {no}

                # puts " ... convertPath2Line :\n$pathString"
            set pathString  [string map { M {_M}   L {_L}   H {_H}   V {_V}   C {_C}   S {_S}   Q {_Q}   T {_T}   A {_A} }   [string trim $pathDefinition] ]
            
            set lineString  {}
            set segmentList [split $pathString {_}]
            set segmentList [filterList $segmentList]
                # puts "$segmentList\n-------------------------convertPath2Line---"
            
            
            set prevCoord_x         55
            set prevCoord_y         55
            
            set ref_x 0
            set ref_y 0
            
            set loopControl 0
            
            foreach segment $segmentList {
                
                    # puts "\n\n_____loop_______________________________________________"
                    # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
                    # puts "\n\n      <$segment>\n_____segment________"

            
                    # puts "  ... $segment"
                set segmentDef            [split [string trim $segment]]
                set segmentType         [lindex $segmentDef 0]
                set segmentCoords         [lrange $segmentDef 1 end]
                    # puts "\n$segmentType - [llength $segmentCoords] - $segmentCoords\n____type__segmentCoords__"
                    
                switch -exact $segmentType {
                    M     { #MoveTo 
                            set lineString         [ concat $lineString     $segmentCoords ]
                            set ref_x     [ lindex $segmentCoords 0 ]
                            set ref_y     [ lindex $segmentCoords 1 ]
                        }
                    L     { #LineTo - absolute
                            set lineString         [ concat $lineString     $segmentCoords ] 
                            set ref_x     [ lindex $segmentCoords end-1]
                            set ref_y     [ lindex $segmentCoords end  ]
                        } 
                    C     { # Bezier - absolute
                                # puts "\n\n  [llength $segmentCoords] - $segmentCoords\n______segmentCoords____"
                            # puts "\n( $ref_x / $ref_y )\n      ____start_position__"
                            # puts "\n$segmentType - [llength $segmentCoords] - ( $ref_x / $ref_y ) - $segmentCoords\n      ______type__segmentCoords__"
                            
                            set segmentValues    {}
                            foreach {value} $segmentCoords {
                                set segmentValues     [ lappend segmentValues $value ]                        
                            }
                            
                                # exception on to less values
                                    #     - just a line to last coordinate
                                    #                                
                            if {[llength $segmentValues] < 6 } {\
                                set ref_x     [ lindex $segmentValues end-1]
                                set ref_y     [ lindex $segmentValues end  ]
                                set lineString [ concat $lineString $ref_x $ref_y ]
                                    puts "\n\n      <[llength $segmentValues]> - $segmentValues\n_____Exception________"
                                continue
                            }
                            
                                # continue Bezier definition
                                    #     - just a line to last coordinate
                                    #                                
                            set segmentValues    [ linsert $segmentValues 0 $ref_x $ref_y ]                            
                                # puts "\n  [llength $segmentValues_abs] - $segmentValues_abs\n______segmentValues_abs____"
                            set bezierValues    [ Bezier $segmentValues]
                            set ref_x     [ lindex $bezierValues end-1]
                            set ref_y     [ lindex $bezierValues end  ]
                                # puts "           ===================="
                                # puts "           $prevCoord -> $prevCoord"
                                # puts "                 $bezierString"
                                # puts "            ===================="                            
                            set lineString         [ concat $lineString     [lrange $bezierValues 2 end] ]
                        }
                        
                        default {
                            puts "\n\n  ... whats on there?  ->  $segmentType \n\n"
                        }
                }
                
                    # incr loopControl
                    # puts "  ... $loopControl"
                
                # puts "\n( $ref_x / $ref_y )\n      ____end_position__"                
                # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
            }
            
            foreach {x y}  [split $lineString { }] {
                set pointList [lappend pointList "$x,$y"]
            }
            # puts "-> pointList:\n$pointList\n"
            return $pointList
            
    }


    proc drawSVG {domSVG canvas {transform {0 0}}} {
            
            puts "\n"
            puts "  =============================================="
            puts "   -- drawSVG"
            puts "  =============================================="
            puts "\n"

            set nodeList       [$domSVG childNodes]
            
            foreach {transform_x transform_y} $transform break;    
            
                # return
            foreach node $nodeList {
                        
                        # puts [$node asXML]
                        
                        # -- set defaults
                    set objectPoints {}
                    
                    set nodeName [$node nodeName]
					
                    switch -exact $nodeName {
                            rect {
                                        set x         [expr [$node getAttribute x] + $transform_x ]
                                        set y         [expr [$node getAttribute y] + $transform_y ]
                                        set width     [$node getAttribute  width ]
                                        set height    [$node getAttribute  height]
                                        set x2 [expr $x + $width ]
                                        set y2 [expr $y + $height]
                                        set objectPoints [list $x $y $x $y2 $x2 $y2 $x2 $y]
                                            # -- create rectangle
                                                # puts "$canvas create polygon     $objectPoints -outline black -fill white"
                                        $canvas create polygon     $objectPoints -outline black -fill {}
                                }
                            polygon {
                                        set valueList [ $node getAttribute points ]
										if {[llength $valueList] < 2} {continue}
                                        foreach {coords} $valueList {
                                            foreach {x y}  [split $coords ,] break
                                            set x     [expr $x + $transform_x ]
                                            set y     [expr $y + $transform_y ]
                                            set objectPoints [lappend objectPoints $x $y ]
                                        }
                                            # -- create polygon
                                                # puts "\n$canvas create polygon     $objectPoints -outline black -fill white"
                                        $canvas create polygon     $objectPoints -outline black -fill {}
                                }
                            polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
                                        set valueList [ $node getAttribute points ]
										if {[llength $valueList] < 2} {continue}
                                        foreach {coords} $valueList {
                                            foreach {x y}  [split $coords ,] break
                                            set x     [expr $x + $transform_x ]
                                            set y     [expr $y + $transform_y ]
                                            set objectPoints [lappend objectPoints $x $y ]
                                        }
                                            # -- create polyline
                                                # puts "$canvas create line $objectPoints -fill black"
                                        $canvas create line $objectPoints -fill black
                                }
                            line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
										set objectPoints [list	[expr [$node getAttribute x1] + $transform_x ] [expr [$node getAttribute y1] + $transform_y ] \
                                                                [expr [$node getAttribute x2] + $transform_x ] [expr [$node getAttribute y2] + $transform_y ] ]
                                            # -- create line
                                                # puts "$canvas create line $objectPoints -fill black"
										$canvas create line $objectPoints -fill black
                                    }
                            circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                        # --- dont display the center_object with id="center_00"
                                        set cx [expr [$node getAttribute cx] + $transform_x ]
                                        set cy [expr [$node getAttribute cy] + $transform_y ]
                                        set r  [$node getAttribute  r]
                                        set x1 [expr $cx - $r]
                                        set y1 [expr $cy - $r]
                                        set x2 [expr $cx + $r]
                                        set y2 [expr $cy + $r]
                                        set objectPoints [list $x1 $y1 $x2 $y2]
                                            # -- create circle
                                                # puts "$canvas create oval $objectPoints -fill black"
                                        $canvas create oval $objectPoints -outline black -fill {}
                                }
                            ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                        # --- dont display the center_object with id="center_00"
                                        set cx [expr [$node getAttribute cx] + $transform_x ]
                                        set cy [expr [$node getAttribute cy] + $transform_y ]
                                        set rx  [$node getAttribute  rx]
                                        set ry  [$node getAttribute  ry]
                                        set x1 [expr $cx - $rx]
                                        set y1 [expr $cy - $ry]
                                        set x2 [expr $cx + $rx]
                                        set y2 [expr $cy + $ry]
                                        set objectPoints [list $x1 $y1 $x2 $y2]
                                            # -- create circle
                                                # puts "$canvas create oval $objectPoints -fill black"
                                        $canvas create oval $objectPoints -outline black -fill {}
                                }
                            default {}
                    }
                
            }
    
    }


    proc recurseInsert {w node parent} {
            
			proc getAttributes node {
					if {![catch {$node attributes} res]} {set res}
			} 
				
			set domDepth [llength [split [$node toXPath] /]]			
			set nodeName [$node nodeName]
            set done 0
            if {$nodeName eq "#text" || $nodeName eq "#cdata"} {
                set text [string map {\n " "} [$node nodeValue]]
            } else {
                set text {}
                foreach att [getAttributes $node] {
                    catch {append text " $att=\"[$node getAttribute $att]\""}
                }
                set children [$node childNodes]
                if {[llength $children]==1 && [$children nodeName] eq "#text"} {
                    append text [$children nodeValue]
                    set done 1
                }
            }
            $w insert $parent end -id $node -text $nodeName -tags $node -values [list "$text" ] 
			
			case [expr $domDepth-1] {
				 0 	{	set r [format %x  0];	set g [format %x  0];	set b [format %x 15]}
				 1 	{	set r [format %x  3];	set g [format %x  0];	set b [format %x 12]}
				 2 	{	set r [format %x  6];	set g [format %x  0];	set b [format %x  9]}
				 3 	{	set r [format %x  9];	set g [format %x  0];	set b [format %x  6]}
				 4 	{	set r [format %x 12];	set g [format %x  0];	set b [format %x  3]}
				 5 	{	set r [format %x 15];	set g [format %x  0];	set b [format %x  0]}
				 6 	{	set r [format %x 12];	set g [format %x  3];	set b [format %x  0]}
				 7 	{	set r [format %x  9];	set g [format %x  6];	set b [format %x  0]}
				 8 	{	set r [format %x  6];	set g [format %x  9];	set b [format %x  0]}
				 9 	{	set r [format %x  3];	set g [format %x 12];	set b [format %x  0]}
 				10 	{	set r [format %x  0];	set g [format %x 15];	set b [format %x  0]}
				11 	{	set r [format %x  0];	set g [format %x 12];	set b [format %x  3]}
				12 	{	set r [format %x  0];	set g [format %x  9];	set b [format %x  6]}
				13 	{	set r [format %x  0];	set g [format %x  6];	set b [format %x  9]}
				14 	{	set r [format %x  0];	set g [format %x  3];	set b [format %x 12]}
				15 	{	set r [format %x  0];	set g [format %x  0];	set b [format %x 15]}
				default 
					{	set r [format %x 12];	set g [format %x 12];	set b [format %x 12]}
			}
			set fill [format "#%s%s%s%s%s%s" $r $r $g $g $b $b] 
			
			$w tag configure $node -foreground $fill
			
			#ttk::style map Treeview \
				-background [list selected "#4a6984"] \
				-foreground [list selected "#ffffff"]   

            if {$parent eq {}} {$w item $node -open 1}
            if !$done {
                foreach child [$node childNodes] {
                    recurseInsert $w $child $node
                }
            }
    }


    proc cleanupTree {w} {
            foreach childNode [$w children {} ] {
                $w detach     $childNode
                $w delete     $childNode
            }    
    }
    
    
    proc getAttributes node {
            if {![catch {$node attributes} res]} {set res}
    }    

    
    proc openSVG {{argv {}}} {
            variable resultCanvas
            variable fileName
            variable deepTree
            variable deepText
            variable flatTree
            variable flatText 
            variable flatSVG
        
            puts "\n"
            puts "  =============================================="
            puts "   -- openSVG:   $argv"
            puts "  =============================================="
            puts "\n"
    
                # --- result SVG -----------
            set flatSVG [dom createDocument svg]
            set root [$flatSVG documentElement]
            $root     setAttribute version 1.0
            $root     setAttribute xmlns "http://www.w3.org/2000/svg"


                # --- open File ------------
            if {[llength $argv] == 0} {
                set fileName [tk_getOpenFile]
            } else {
                set fileName [file join [lindex $argv 0]]
            }
            if {$fileName == {}} {return}
			
            set fp [open $fileName]
			fconfigure    $fp -encoding utf-8
            set xml [read $fp]
            close         $fp
         
            
                # --- compute results ------            
            dom parse  $xml doc
            $doc documentElement root

            set flatSVG [simplifySVG $root {0 0}]
                # set flatSVG [simplifySVG $root {50 50} ]


                # --- cleanup outputs ------            
            $resultCanvas delete all
            cleanupTree $deepTree
            $deepText delete 1.0 end
            cleanupTree $flatTree
            $flatText delete 1.0 end

                # --- fill outputs ---------
            drawSVG $flatSVG $resultCanvas {15 15}
            recurseInsert $deepTree    $root         {}
            $deepText insert end $xml
            recurseInsert $flatTree     $flatSVG     {}
            $flatText insert end [$flatSVG asXML]
            
            wm title . "simplifySVG - $fileName"
    }

    proc updateSVG {} {
            variable fileName
            openSVG $fileName
    }

        # --- store fileName --
        #
     set fileName {}

        # --- window ----------
        #
    pack [ frame .f -bg yellow] 
        
    set buttonBar    [ frame .f.bb ]
        pack $buttonBar      -expand yes -fill both 
    button $buttonBar.openSVG     -text "Open SVG"        -command openSVG
    button $buttonBar.update      -text "update"          -command updateSVG
        pack $buttonBar.openSVG $buttonBar.update -side left
        
    set nb_result    [ ttk::notebook .f.nb ]
        pack $nb_result      -expand yes -fill both   
    $nb_result add [frame $nb_result.nb_canvas]          -text "... Canvas"         
    
    $nb_result add [frame $nb_result.nb_deepText]        -text "... original SVG as Text" 
        $nb_result add [frame $nb_result.nb_deepTree]    -text "... original SVG as XML" 
    
    $nb_result add [frame $nb_result.nb_flatText]        -text "... flattened SVG as Text" 
        $nb_result add [frame $nb_result.nb_flatTree]    -text "... flattened SVG as XML" 

                # -- the canvas tab
    set canvasFrame           [ frame    $nb_result.nb_canvas.f      -relief sunken ]
        pack $canvasFrame  -expand yes -fill both -padx 15 -pady 15
    
                # -- the original deep svg structure
        set deepTreeFrame     [ frame    $nb_result.nb_deepTree.f    -relief sunken ]
        pack $deepTreeFrame    -expand yes -fill both
    set deepTextFrame         [ frame    $nb_result.nb_deepText.f    -relief sunken ]
        pack $deepTextFrame    -expand yes -fill both
    
                # -- the flattend svg structure
        set flatTreeFrame     [ frame    $nb_result.nb_flatTree.f    -relief sunken ]
        pack $flatTreeFrame    -expand yes -fill both
    set flatTextFrame         [ frame    $nb_result.nb_flatText.f    -relief sunken ]
        pack $flatTextFrame    -expand yes -fill both

        
        # --- result canvas ---
        #
    set resultCanvas [ canvas $canvasFrame.cv -width 900 -height 800 -relief sunken -bg white]
        pack   $resultCanvas -fill both -expand yes -padx 0 -pady 0
 
 
 
       # --- ttk::style - treeview ---
       #
	ttk::style map Treeview.Row  -background [ list selected gainsboro ]
		# ttk::style map Treeview.Row  -foreground [ list selected white ]
  
 
        # --- result deep svg  - treeview---
        #
	set deepTree [ ttk::treeview $deepTreeFrame.t   -columns "value" \
                                                    -yscrollcommand "$deepTreeFrame.y set" \
                                                    -xscrollcommand "$deepTreeFrame.x set" -height 40 ]
        $deepTree heading "#0"  -text "XML" -anchor w
        $deepTree column  "#0"  -width 250
        $deepTree heading value -text "Value" 
        $deepTree column  value -width 900 
    scrollbar $deepTreeFrame.x -ori hori -command  "$deepTreeFrame.t xview"
    scrollbar $deepTreeFrame.y -ori vert -command  "$deepTreeFrame.t yview"
        grid $deepTreeFrame.t $deepTreeFrame.y    -sticky news
        grid $deepTreeFrame.x                     -sticky news
        grid rowconfig    $deepTreeFrame 0 -weight 1
        grid columnconfig $deepTreeFrame 0 -weight 1

        
        # --- result flattend svg - textview ---
    set deepText [ text $deepTextFrame.txt -wrap none -xscroll "$deepTextFrame.h set" \
                                                      -yscroll "$deepTextFrame.v set" -height 50 -width 160 ]
    scrollbar $deepTextFrame.v -orient vertical   -command "$deepTextFrame.txt yview"
    scrollbar $deepTextFrame.h -orient horizontal -command "$deepTextFrame.txt xview"
        # Lay them out
        grid $deepTextFrame.txt $deepTextFrame.v  -sticky nsew
        grid $deepTextFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $deepTextFrame.txt 0 -weight 1
        grid columnconfigure $deepTextFrame.txt 0 -weight 1 


        # --- result flattend svg - treeview ---
        #
    set flatTree [ ttk::treeview $flatTreeFrame.t   -columns "value" \
                                                    -xscrollcommand "$flatTreeFrame.x set" \
                                                    -yscrollcommand "$flatTreeFrame.y set" -height 40 ]
        $flatTree heading "#0"  -text "XML" -anchor w
        $flatTree column  "#0"  -width 250
        $flatTree heading value -text "Value" 
        $flatTree column  value -width 900 
    scrollbar $flatTreeFrame.x -ori hori -command  "$flatTreeFrame.t xview"
    scrollbar $flatTreeFrame.y -ori vert -command  "$flatTreeFrame.t yview"
        grid $flatTreeFrame.t     $flatTreeFrame.y  -sticky news
        grid $flatTreeFrame.x                       -sticky news
        grid rowconfig        $flatTreeFrame 0  -weight 1
        grid columnconfig     $flatTreeFrame 0  -weight 1


        
        # --- result flattend svg - textview ---
    set flatText [ text $flatTextFrame.txt -wrap none -xscroll "$flatTextFrame.h set" \
                                                      -yscroll "$flatTextFrame.v set" -height 50 -width 160 ]
    scrollbar $flatTextFrame.v -orient vertical   -command "$flatTextFrame.txt yview"
    scrollbar $flatTextFrame.h -orient horizontal -command "$flatTextFrame.txt xview"
        # Lay them out
        grid $flatTextFrame.txt $flatTextFrame.v  -sticky nsew
        grid $flatTextFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $flatTextFrame.txt 0 -weight 1
        grid columnconfigure $flatTextFrame.txt 0 -weight 1 

        # --- compute ----------
        #
    puts " ... $argv"
    openSVG $argv
    
