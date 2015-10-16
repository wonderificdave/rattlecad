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
 # 20150923:
 #       search polygons, polylines defined by only one point
 #
 #
 #

    package require Tk
    package require tdom
 
    set APPL_ROOT_Dir [file dirname [lindex $argv0]]
    lappend auto_path "$APPL_ROOT_Dir/lib"
    
    variable exportFileName {export.svg}
    
    variable min_SegmentLength  0.4
    variable fillGeometry       {gray80}
    variable centerNode         {}
    variable trashNode          {}
    variable svg_LastHighlight  {}
    variable free_ObjectID      0
    variable file_saveCount     0
    variable tmpSVG             [dom parse "<root/>"]
    variable my_Center_Object   {}
    variable fitVector          {0 0 1}
            
    variable CONST_PI           [expr 4*atan(1)]
    
    set currentVersion "3.4.02 - AA"

    # -- handling puts
    # http://wiki.tcl.tk/1290
    proc InCommand {} {
       uplevel {puts [info level 0]}
    }

    proc newproc {name args body} {
       set body "InCommand\n$body"
       _orig_puts $name $args $body
    }

    #rename puts _orig_puts
    #rename newproc puts
    # rename proc realproc
    # rename newproc proc
    
    # -- procedures from: canvasCAD	->	vectormath.tcl
    # 
    proc pointDistance { p1 p2 } { 
            # distance from  p1  to  p2 
            set vector [ subVector $p2 $p1 ]
            set length [ expr hypot([lindex $vector 0],[lindex $vector 1]) ] 
            return $length
    }
    proc addVector {v1 v2 {scaling 1}} {
            foreach {x1 y1} $v1 {x2 y2} $v2 break
            return [list [expr {$x1 + $scaling*$x2}] [expr {$y1 + $scaling*$y2}]]
    }	 
    proc subVector {v1 v2} { return [addVector $v1 $v2 -1] }
    #
    # ----------------------------------------------
    
    
    proc flatten_nestedList { args } {
        if {[llength $args] == 0 } { return ""}
        set flatList {}
        foreach e [eval concat $args] {
            foreach ee $e { lappend flatList $ee }
        }
            # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
        return $flatList
    }  
    
    
    proc get_ObjectID {} {
        variable free_ObjectID
        incr free_ObjectID
        return [format "simplify_%s" $free_ObjectID]
    }


	proc mirrorPoint {p a} {
            # reflects point p on line {{0 0} a}
        
            foreach {px py} $p  {ax ay} $a  break;

            if {$px == $ax && $py == $ay} {
                # return empty an handle on calling position if points are coincindent
                # puts "  .. hot wos";
                return {}
            }
            
            
            variable CONST_PI
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


    proc filterList {inputList {filter {}}} {
        set returnList {}
        foreach value $inputList {
          if {$value == $filter} {continue}
          set value     [string trim $value]
          set pointList [lappend returnList $value]
        }
        return $returnList
    }   


    proc copyAttribute {node attributeName {targetNode {}}} {
        if {[$node hasAttribute $attributeName]} {
              # puts "       [$node asXML]"
            set attributeValue [$node getAttribute $attributeName]
            if {$targetNode != {}} {  
               $targetNode setAttribute $attributeName [$node getAttribute $attributeName]
            }
            return $attributeValue
        }
    }   


    proc update_Attributes {sourceNode targetNode} {
        variable svgID
        incr svgID
        if {[$sourceNode hasAttribute id]} {
            $targetNode setAttribute id [$sourceNode getAttribute id]
        } else {
            $targetNode setAttribute id [format "simplify_SVG__%06i" $svgID]
        }
        foreach attr [$sourceNode attributes] {
            if {$attr == {id}} continue
            $targetNode setAttribute $attr [$sourceNode getAttribute $attr]
        }
    }        


    proc unifyTransform {node} {
            
              # set constant Value
            variable CONST_PI
            
              # -- default Value
            set transformMatrix {1 0 0 1 0 0}
            set translateMatrix {1 0 0 1 0 0}
            set transformArg {}
            
              # -- get transform Information
            if {[catch {set transformArg  [$node getAttribute transform]} eID]} {
                #return $matrix
                set transformType {__default__}
            } else {
                # puts "      -> $transformArg"
                set transformType  [lindex [split $transformArg (]  0]
                set transformValue [lindex [split $transformArg ()] 1]
                # puts "      --> \$transformType   $transformType"
                # puts "      --> \$transformValue  $transformValue"
                if {[string first {,} $transformValue] > 0} {
                    set transformValue [string map {, { }} $transformValue]
                }
            }
            
            
              # -- define the unified translation matrix 
              #  from http://de.wikibooks.org/wiki/SVG/_Transformationen
              #
            set x [copyAttribute  $node  x]
            set y [copyAttribute  $node  y]
            if {$x != {}} {
                if {$y != {}} {
                    set translateMatrix [list 1 0 0 1 $x $y]
                } else {
                    set translateMatrix [list 1 0 0 1 $x 0]
                }
            }
              
              
              # -- define the unified transform matrix 
              #  from http://de.wikibooks.org/wiki/SVG/_Transformationen
              #  
            switch -exact $transformType {
                matrix {
                          set transformMatrix $transformValue
                      }
                translate {
                          # puts "  ---> \$transformValue $transformValue"
                        if {[llength $transformValue] == 1} {
                          set translateMatrix [list 1 0 0 1 $transformValue 0]
                        } else {
                          set translateMatrix [list 1 0 0 1 [lindex $transformValue 0] [lindex $transformValue 1]]
                        }                
                      }
                scale {
                        if {[llength $transformValue] == 1} {
                          set transformMatrix [list [lindex $transformValue 0] 0 0 [lindex $transformValue 0] 0 0]
                        } else {
                          set transformMatrix [list [lindex $transformValue 0] 0 0 [lindex $transformValue 1] 0 0]
                        }
                      }
                rotate {
                          set angleRad [expr -1.0*$transformValue*$CONST_PI/180]
                          set transformMatrix [list [expr cos($angleRad)] [expr -1.0*sin($angleRad)] \
                                                    [expr sin($angleRad)] [expr cos($angleRad)] \
                                                    0 0]
                       }
                skewX {
                          set angleRad [expr $transformValue*$CONST_PI/180]
                          set transformMatrix [list 1 0 \
                                                    [expr tan($angleRad)] 1 \
                                                    0 0]       
                }
                skewY {
                          set angleRad [expr $transformValue*$CONST_PI/180]
                          set transformMatrix [list 1 [expr tan($angleRad)] \
                                                    0 1 \
                                                    0 0]       
                }
                __default__ -
                default {
   
                }
            }

              # puts "  ---> \$transformMatrix $transformMatrix"
              # puts "  ---> \$translateMatrix $translateMatrix"

            return [list $translateMatrix $transformMatrix $transformType]
    }    


    proc matrixTransform {valueList matrix} {
            
            #  -- the art of handling the transform matrix in SVG
            #           got it from here: http://commons.oreilly.com/wiki/index.php/SVG_Essentials/Matrix_Algebra
            #       | a  c  tx |                    | a*x  c*y  tx*1 |  -> x
            #       | b  d  ty |  *  |x  y  1|  =   | b*x  d*y  ty*1 |  -> y
            #       | 0  0   1 |                    | 0*x  0*y   1*1 |  -> z (not interesting in a 2D)   
            
            # puts "    transform_SVGObject: $matrix"
        
        set valueList_Return {}
            
        foreach {a b c d e f} $matrix break

        foreach {x y} $valueList {
            # puts "\n--------------------"
            # puts "       -> $x $y"
          set new_x [ expr $a*$x + $c*$y + $e ]
          set new_y [ expr $b*$x + $d*$y + $f ]
            # puts "          x/y:  $x / $y"
            # puts "          a/b -> xt:  $a / $b -> $new_x"
            # puts "          c/d -> yt:  $c / $d -> $new_y"
          set valueList_Return [lappend valueList_Return $new_x $new_y ]
        }
        return $valueList_Return
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


    proc check_pathValues {pathValueString} {

            # puts "\n  ==== check_pathValues_new ======"
            # puts "\n ---------"
            # puts "$pathValueString"
        set pathValueString   [string map { M { M }   Z { Z }   L { L }   H { H }   V { V }   C { C }   S { S }   Q { Q }   T { T }   A { A }  \
                                            m { m }   z { Z }   l { l }   h { h }   v { v }   c { c }   s { s }   q { q }   t { t }   a { a }  , { }  } \
                                        [string trim $pathValueString] ]
            # puts "\n ---------"
            # puts "$pathValueString"
        
        set valueList {}
        foreach value $pathValueString {
              # puts "       -> $xy"
            if {[string first {10e} $value] >= 0} {
                    # ... sometimes the pathValueString contains values like: 10e-4
                    # these values does not work in tcl
                    # therfore
                    # puts "           -> check:  $xy"
                set exponent [lindex [split $value e] 1]
                set value [expr 1.0 * pow(10,$exponent)]
            }
            lappend valueList $value
        }
        return $valueList
    }


    proc checkPoly__x {node} {
                #
            variable trashNode
                #
            # puts ""
            # puts "checkPoly__x:   -> [$node asXML]"
            # puts ""
                #
                # points="52.43729999999999,-32.5785"
                #
            set nodeName        [$node nodeName]
                # puts "   -> \$nodeName          $nodeName"
                #
            switch -exact $nodeName {
                polygon  -
                polyline {
                        set pointAttribute  [$node getAttribute points]
                            # puts "   -> \$pointAttribute    $pointAttribute"
                        set pointCount      [llength $pointAttribute]
                            # puts "   -> \$pointCount        $pointCount"
                            #
                        if {$pointCount > 1} {
                            # puts "   -> \$node $node"
                            return $node
                        } else {
                            # puts "   -> \$trashNode $trashNode"
                            # puts "   -> \$node $node"
                            $trashNode appendChild $node
                            return {} 
                        }
                    }
                default {
                    return $node
                }
            }
                #
    }

    
    proc format_absPath {pathDefinition {position {0 0}} } {
    
        set transform(x) [lindex $position 0]
        set transform(y) [lindex $position 1]
        
        set pathValueList [check_pathValues $pathDefinition]
            # puts "   001 ->\$pathValueList\n  $pathValueList"
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
                            set pathValueList_abs        [lappend pathValueList_abs M]
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                    # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)      $x    ; incr listIndex 
                                set penPosition(y)      $y    ; incr listIndex
                                #set penPosition(x)      [expr $x + $transform(x)]    ; incr listIndex 
                                #set penPosition(y)      [expr $y + $transform(y)]    ; incr listIndex
                                set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                                  
                            }
                            # set penPosition(x)       [expr [lindex $pathValueList $listIndex] + $transform(x)]    ; incr listIndex 
                            # set penPosition(y)       [expr [lindex $pathValueList $listIndex] + $transform(y)]    ; incr listIndex
                            # set pathValueList_abs    [lappend pathValueList_abs $value $penPosition(x) $penPosition(y)]
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
                                set penPosition(x)      $x    ; incr listIndex 
                                set penPosition(y)      $y    ; incr listIndex
                                # set penPosition(x)      [expr $x  + $transform(x)]    ; incr listIndex 
                                # set penPosition(y)      [expr $y  + $transform(y)]    ; incr listIndex
                                set pathValueList_abs   [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                                # puts "  [checkControl $x]
                            }
                        }                    
                    H {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set x     [lindex $pathValueList $listIndex]
                            if {[checkControl $x]} {continue}
                            set penPosition(x)          $x    ; incr listIndex
                            # set penPosition(x)          [expr $x  + $transform(x)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    V {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs L]
                            set y     [lindex $pathValueList $listIndex]
                            if {[checkControl $y]} {continue}
                            set penPosition(y)          $y    ; incr listIndex
                            # set penPosition(y)          [expr $y  + $transform(y)]    ; incr listIndex
                            set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                        }
                    C {        # puts "    $value  ... implemented yet"
                            set pathValueList_abs       [lappend pathValueList_abs C]
                                    # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                            foreach {x y} [lrange $pathValueList $listIndex end] {
                                     # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                                if {[checkControl $x]} {break}                                
                                set penPosition(x)      $x    ; incr listIndex 
                                set penPosition(y)      $y    ; incr listIndex
                                # set penPosition(x)      [expr $x + $transform(x)]    ; incr listIndex 
                                # set penPosition(y)      [expr $y + $transform(y)]    ; incr listIndex
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
                    
        set partList  {}
        set valueList {}
        foreach value $pathValueList_abs {
            switch -exact $value {
                m -
                M {
                    lappend partList $valueList 
                    set valueList {}
                    lappend valueList $value
                  }
               default {
                    lappend valueList $value
                  }
            }
        }
        lappend partList $valueList

          # puts "\n   -> format_absPath:\n ===================================="
        # puts "\n--------------"
        # puts "\n         [lrange $partList 1 end]\n"
        # puts "--------------"
        return [lrange $partList 1 end]
        
        
        # return $pathValueList_abs
    }

    
    proc format_pathtoLine {pathDefinition} {
            # -------------------------------------------------
            # http://www.selfsvg.info/?section=3.5
            # 
            # -------------------------------------------------
                # puts "\n\n === new format_pathtoLine =====================\n"        

                # puts "\npathString:\n  $pathString\n"            
            
                # puts "       - > pathDefinition:\n$pathDefinition\n"

            
            set canvasElementType   line
            set controlString       {}
            set isClosed            {no}
                
            
            set segment     {}
            set segmentList {}
              # foreach element [flatten_nestedList $pathDefinition] {}
            foreach element $pathDefinition {
                  # puts "  -> $element"
                if {[string match {[A-Z]} $element]} {
                   lappend segmentList $segment
                   set segment $element
                } else {
                   lappend segment $element
                     # puts "  -> $element"
                }
            }
            lappend segmentList $segment
            set segmentList [lrange $segmentList 1 end]
            
            set prevCoord_x         55
            set prevCoord_y         55
            
            set ref_x 0
            set ref_y 0
            
            set loopControl 0
            set lineString  {}
            
              # puts "   -> \$pathDefinition: $pathDefinition"
              # puts "   -> \$segmentList:    $segmentList"
            #exit
            
            
            foreach segment $segmentList {

                
                    # puts "\n\n_____loop_______________________________________________"
                    # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
                    # puts "\n\n      <$segment>\n_____segment________"

            
                    # puts "  ... $segment"
                set segmentDef            [split [string trim $segment]]
                set segmentType           [lindex $segmentDef 0]
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
                                return
                                # continue
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
                            puts "\n\n  ... whats on there?  ->  $segmentType"
                            puts     "   ...     segmentList  ->  $segmentList \n\n"
                        }
                }
                
                    # incr loopControl
                    # puts "  ... $loopControl"
                
                # puts "\n( $ref_x / $ref_y )\n      ____end_position__"                
                # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
            }
            
            set pointList [split $lineString { }]
            return $pointList

    }



    proc simplify_Rectangle {node parentTransform {targetNode {}}} {
        variable tmpSVG
          # -- handle as polygon
        set width     [$node getAttribute width]
        set height    [$node getAttribute height]
        set pointList [list 0,0 $width,0 $width,$height 0,$height]
        $node setAttribute points $pointList
        
        set myNode [ simplify_Polygon $node $parentTransform]
        return $myNode
    }


    proc simplify_Circle {node parentTransform} {   
        
        variable tmpSVG  
          # -- handle as ellipse
        set rx     [copyAttribute $node r]
        set ry     [copyAttribute $node r]
        $node setAttribute rx $rx
        $node setAttribute ry $ry
        
        set myNode [simplify_Ellipse $node $parentTransform]
        
        return $myNode
    }    

 
    proc simplify_Line {node parentTransform} { 
        
        variable tmpSVG  
        variable flatSVG 
        variable min_SegmentLength        
        
        set transform       [unifyTransform $node]
        set translateMatrix [lindex $transform 0]
        set transformMatrix [lindex $transform 1]
        set transformType   [lindex $transform 2]
        
        puts "\n === simplify_Line ==========================\n  -> [$node asXML]"
        puts "       \$transformType   $transformType"
        puts "       \$translateMatrix $translateMatrix"   
        puts "       \$transformMatrix $transformMatrix"   
        
    
          # -- define nodeType: line
        set resultNode [$tmpSVG createElement line]
        
          # -- get shape 
        set x1  [copyAttribute $node x1]
        set y1  [copyAttribute $node y1]
        set x2  [copyAttribute $node x2] 
        set y2  [copyAttribute $node y2]
        set pointList [list $x1 $y1 $x2 $y2]

        
          # -- handle translation by given x,y
        set pointList [matrixTransform $pointList $translateMatrix]
          # puts "   -> $pointList"
        
        
          # -- handle transformation by given attribute
        set pointList [matrixTransform $pointList $transformMatrix]
          # puts "   -> $pointList"
        
          # --check relevance
        set segLength  [pointDistance [lrange $pointList 0 1] [lrange $pointList 2 3]]
        # puts "   -> \$segLength $segLength"
        if {$segLength < $min_SegmentLength} {
            puts "line,segLength:  $segLength   < $min_SegmentLength"
            puts "      ... excepted\n"
            return {}
        }        
        
        $resultNode setAttribute x1 [lindex $pointList 0]
        $resultNode setAttribute y1 [lindex $pointList 1]
        $resultNode setAttribute x2 [lindex $pointList 2]
        $resultNode setAttribute y2 [lindex $pointList 3]
        
        
          # -- create returnNode with ordered attributes
        set newNode [$tmpSVG createElement line]
        update_Attributes $resultNode $newNode

          
          # -- set defaults
        $newNode setAttribute stroke          black
        $newNode setAttribute stroke-width    0.1
        
          # -- return svg-Node
        return $newNode
    }


    proc simplify_Ellipse {node parentTransform {targetNode {}}} {   
        
        variable tmpSVG  
        variable flatSVG
        variable CONST_PI
        
        set transform       [unifyTransform $node]
        set translateMatrix [lindex $transform 0]
        set transformMatrix [lindex $transform 1]
        set transformType   [lindex $transform 2]
        
        puts "\n === simplify_Ellipse ==========================\n  -> [$node asXML]"
        puts "       \$transformType   $transformType"
        puts "       \$translateMatrix $translateMatrix"   
        puts "       \$transformMatrix $transformMatrix"   
        
    
          # -- define nodeType: polygon
        set resultNode [$tmpSVG createElement polygon]
        
        set center_x  [copyAttribute $node cx $resultNode]
        set center_y  [copyAttribute $node cy $resultNode]
        set radius_x  [copyAttribute $node rx] 
        set radius_y  [copyAttribute $node ry]
        
          # -- get the origin of the circle
        set origin_x [expr [lindex $translateMatrix 4] +[lindex $transformMatrix 4]]          
        set origin_y [expr [lindex $translateMatrix 5] +[lindex $transformMatrix 5]]          
        if {$center_x == {}} { set center_x 0 }
        if {$center_y == {}} { set center_y 0 }
        
        #set nodeID  [copyAttribute $node id]
        # if {$nodeID =={center_00}} {}
        #     set centerNode [$flatSVG createElement circle]
        #     $centerNode setAttribute cx $origin_x
        #     $centerNode setAttribute cy $origin_y
        #     $centerNode setAttribute r  15
        #     $flatSVG addChild $centerNode

        

          # -- for handling id="center_00" and origin values
        # $resultNode setAttribute cx $center_x       
        # $resultNode setAttribute cy $center_y    


          # -- define shape as polygon        
        set pointList {}
        set i 0
        set j 60
        set deltaAngle  [expr 2*$CONST_PI/$j]
        set ratioRadius [expr 1.0*$radius_y/$radius_x]
        puts "   \$deltaAngle \$ratioRadius: $deltaAngle $ratioRadius"
        while {$i < $j} {
            set angle [expr $i*$deltaAngle]
            set x     [expr $center_x + ($radius_x * cos($angle))]
            set y     [expr $center_y + $ratioRadius * ($radius_x * sin($angle))]
            lappend pointList $x $y
            incr i
        }
        
          # -- handle translation by given x,y
        set pointList [matrixTransform $pointList $translateMatrix]
          # puts "   -> $pointList"
        
        
          # -- handle transformation by given attribute
        set pointList [matrixTransform $pointList $transformMatrix]
          # puts "   -> $pointList"
        
        
          # -- convert to svg-polygon attributes
        set tmpList {}
        foreach {x y} $pointList {
            lappend tmpList "[expr  $x + [lindex $parentTransform 0]],[expr $y + [lindex $parentTransform 1]]"
        }
        $resultNode setAttribute points $tmpList
        
          # -- create returnNode with ordered attributes
        set newNode [$tmpSVG createElement polygon]
        update_Attributes $resultNode $newNode
        
          # -- set defaults
        $newNode setAttribute fill            none
        $newNode setAttribute stroke          black
        $newNode setAttribute stroke-width    0.1
        
          # -- return svg-Node
        return $newNode
    } 


    proc simplify_Polygon {node parentTransform {targetNode {}}} {
        
        variable tmpSVG  
        variable flatSVG
        
        set transform       [unifyTransform $node]
        set translateMatrix [lindex $transform 0]
        set transformMatrix [lindex $transform 1]
        set transformType   [lindex $transform 2]
        
        puts "\n\n\n === simplify_Polygon ==========================\n  -> [$node asXML]"
        puts "       \$transformType   $transformType"
        puts "       \$translateMatrix $translateMatrix"   
        puts "       \$transformMatrix $transformMatrix"
        

          # -- define nodeType: polygon
        set resultNode [$tmpSVG createElement polygon]
        
          # -- define shape as pointList
        set tmpList [$node getAttribute points]
        set pointList {}
        foreach point $tmpList {
            foreach {x y} [split $point ,] break
            lappend pointList $x $y
        }
          # puts "   -> $pointList"
        
          # -- handle translation by given x,y
        set pointList [matrixTransform $pointList $translateMatrix]
          # puts "   -> $pointList"
        
          # -- handle transformation by given attribute
        set pointList [matrixTransform $pointList $transformMatrix]
          # puts "   -> $pointList"
        
          # -- convert to svg-polygon attributes
        set tmpList {}
        foreach {x y} $pointList {
            lappend tmpList "[expr  $x + [lindex $parentTransform 0]],[expr $y + [lindex $parentTransform 1]]"
        }
        $resultNode setAttribute points $tmpList

        
          # -- create returnNode with ordered attributes
        set newNode [$tmpSVG createElement polygon]
        update_Attributes $resultNode $newNode

          # -- set defaults
        $newNode setAttribute fill            none
        $newNode setAttribute stroke          black
        $newNode setAttribute stroke-width    0.1
        
          # -- return svg-Node
        return $newNode
    }


    proc simplify_Path  {node parentTransform {targetNode {}}} {
 
        variable tmpSVG  
        variable flatSVG
        
        set transform       [unifyTransform $node]
        set translateMatrix [lindex $transform 0]
        set transformMatrix [lindex $transform 1]
        set transformType   [lindex $transform 2]
        
        puts "\n == simplify_Path ===========================\n\n  -> [$node asXML]"
        puts "       \$transformType   $transformType"
        puts "       \$translateMatrix $translateMatrix"   
        puts "       \$transformMatrix $transformMatrix"  

        foreach {a b c d e f} $translateMatrix break
        set e [expr $e + [lindex $parentTransform 0]]        
        set f [expr $f + [lindex $parentTransform 1]]    
        set translateMatrix [list $a $b $c $d $e $f]
        puts "       \$transformMatrix $transformMatrix"
        
        
        proc get_pathNode {node pathDescription translateMatrix transformMatrix nodeName } {
            variable flatSVG
            
            set newNode   [$flatSVG createElement $nodeName]
            foreach attr  [$node attributes] {
                $newNode setAttribute $attr [$node getAttribute $attr]
            }
              # puts [$newNode asXML]
            set pointList [format_pathtoLine [flatten_nestedList $pathDescription]]
              # puts "\n"
              # puts "   -> \$pointList $pointList"

            
              # -- handle translation by given x,y
            set pointList [matrixTransform $pointList $translateMatrix]
              # puts "   -> $pointList"
            
              # -- handle transformation by given attribute
            set pointList [matrixTransform $pointList $transformMatrix]
              # puts "   -> $pointList"
              
              
            set pointList_Attribute {}
            foreach {x y} $pointList {
                lappend pointList_Attribute "$x,$y"
            }  
              # puts "   -> $pointList_Attribute"

              
              # -- add Attribute points
            $newNode setAttribute     points          $pointList_Attribute
              # -- and remove Attribute d and transform, because of above transformation
            $newNode removeAttribute  d
            catch {$newNode removeAttribute  transform}

              # update_Attributes $resultNode $newNode
            $newNode setAttribute     fill            none
            $newNode setAttribute     stroke          black
            $newNode setAttribute     stroke-width    0.1
            
            if {$pointList == {}} {
              puts "\n\n\n\n"
              puts "  -> [$node asXML]"
              puts "  -> $pathDescription"
              puts "  -> [$newNode asXML]"
              puts "\n\n\n\n"
            }
            
            return $newNode
        }
        
        
        
        set splitPathCount 0
        set pathInfo [ $node getAttribute d ]
          # puts "  -> \$pathInfo $pathInfo\n"
        
        set svgPath     [ format_absPath [ $node getAttribute d ] $parentTransform ]
             # set svgPath     [format_absPath [ $node getAttribute d ]]
        foreach pathElement $svgPath {
            # puts "    00 -> \$pathElement $pathElement"
        }
        if {[llength $svgPath] > 1} {
            set newNode [$flatSVG createElement g]
            set nodeID [copyAttribute $node id $newNode]
              # $newNode setAttribute children  [llength $svgPath]
            set i 0
            foreach pathSegment $svgPath {
                set pathSegment [flatten_nestedList $pathSegment]
                    # puts "\n--<D>---- loop ----------"
                    # puts "    01 -> \$pathSegment $pathSegment"
                    # puts "   ->   ende: [lindex $pathSegment end]"
                if { [lindex $pathSegment end] == {Z} } {
                      set pathSegment [lrange $pathSegment 0 end-1]
                      # puts "    02 -> \$pathSegment $pathSegment"
                      set loopNode    [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polygon ]
                } else {
                      set loopNode    [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polyline]
                }
                if {[$loopNode hasAttribute id]} {
                      set loopID [$loopNode getAttribute id]
                      $loopNode setAttribute id [format "%s___%s" $loopID $i]
                } else {
                      $loopNode setAttribute id [get_svgID]
                }
                set loopNode [checkPoly__x $loopNode]
                if {$loopNode != {}} {
                    $newNode appendChild $loopNode
                } 
                incr i
            }
        } else {
            set pathSegment $svgPath
            set pathSegment [flatten_nestedList $svgPath]
              # puts "\n--<D>------- single -------"
              # puts "   -> \$pathSegment [llength $pathSegment] [lindex $pathSegment end]"
              # puts "   -> \$pathSegment $pathSegment"
              # puts "   ->   ende: [lindex $pathSegment end]"
            if { [lindex $pathSegment end] == {Z} } {
                set pathSegment [lrange $pathSegment 0 end-1]
                set newNode     [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polygon]
            } else {
                set newNode     [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polyline]
            }             
        }
        
        return $newNode

    }


    proc simplifySVG {domSVG {parentTransform {1 0 0 1 0 0}}} {
            
            puts "\n"
            puts "  =============================================="
            puts "   -- simplifySVG"
            puts "  =============================================="
            puts "\n"

                        
            variable detailText
            variable min_SegmentLength
            variable flatSVG
            variable fillGeometry
            variable free_ObjectID
            variable trashNode
            
            set fillGeometry {gray80}
                        
                # puts [$targetNode asXML]

                # puts "  ... [ $flatSVG asXML]\n"
            set root        [ $flatSVG documentElement ]
                # puts "  ... [ $root asXML]\n"
                
                #
                #
            set trashNode   [$root appendXML "<g id=\"trashNode_001\"></g>"]
            set trashNode   [$root find id trashNode_001]
                # puts "[$trashNode asXML]"
                # exit
                #
                
                #
            foreach node    [$domSVG childNodes] {
                add_SVGNode $node $root $parentTransform
            }
                #
                
                #
            return $root
                #
    }


    proc add_SVGNode {node targetNode parentTransform} {
                
                #
            variable detailText
            variable min_SegmentLength
            variable flatSVG
            variable fillGeometry
            variable free_ObjectID
                #

                # puts "   ... $node"
            if {[$node nodeType] != {ELEMENT_NODE}} return ;#continue
        

                # -- get nodeName
            set nodeName [$node nodeName]
            if  {[$node hasAttribute id]} {
                set nodeID   [$node getAttribute id]
            } else {
                set nodeID   [get_ObjectID]
                $node setAttribute id $nodeID 
            }

            set parentPosition [lrange $parentTransform 4 5]
            puts "       \$parentPosition $parentPosition"
            
            switch -exact $nodeName {
                    g {
                                # puts "\n\n  ... looping"
                                # puts "   [$node asXML]"
                            set myNode [$flatSVG createElement g]
                            $targetNode appendChild $myNode
                            
                            set transform       [unifyTransform $node]
                            set translateMatrix [lindex $transform 0]
                            set transformMatrix [lindex $transform 1]
                            set transformType   [lindex $transform 2]
                            catch {$node removeAttribute transform}
                            
                            puts "\n === add_SVGNode ======= $parentTransform ===================\n  -> [$node asXML]"
                            puts "       \$transformType   $transformType"
                            puts "       \$translateMatrix $translateMatrix"   
                            puts "       \$transformMatrix $transformMatrix" 

                            
                              # -- handle translation by given x,y
                            set parentPosition [matrixTransform $parentPosition $translateMatrix]
                              # puts "   -> $parentPosition"
                            
                              # -- handle transformation by given attribute
                            set parentPosition [matrixTransform $parentPosition $transformMatrix]       
                            puts "       \$parentPosition $parentPosition"
                            
                            set nodeTransform [list 1 0 0 1 [lindex $parentPosition 0] [lindex $parentPosition 1]]
                            puts "       \$nodeTransform   $nodeTransform"
                            
                            foreach childNode [$node childNodes] {
                                add_SVGNode $childNode $myNode $nodeTransform
                            }
                        }
                    rect {
                            set myNode  [simplify_Rectangle $node $parentPosition]
                            $myNode setAttribute id $nodeID
                            $targetNode appendChild $myNode 
                        }
                    polygon {
                            set myNode  [simplify_Polygon   $node $parentPosition]
                            $myNode setAttribute id $nodeID
                                #
                            set myNode [checkPoly__x $myNode]
                                #
                            if {$myNode != ""} {
                                $targetNode appendChild $myNode
                            }
                                #
                        }
                    polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
                            set polygonNode  [simplify_Polygon $node $parentPosition]
                            
                            set myNode [$flatSVG createElement polyline]
                            $myNode setAttribute id $nodeID
                            foreach attr [$polygonNode attributes] {
                                $myNode setAttribute $attr [$polygonNode getAttribute $attr]
                            }
                                #
                            set myNode [checkPoly__x $myNode]
                                #
                            if {$myNode != ""} {
                                $targetNode appendChild $myNode
                            }
                                #
                        }
                    line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
                            set myNode  [simplify_Line $node $parentPosition]
                            if {$myNode != {}} {
                                $myNode setAttribute id $nodeID
                                $targetNode appendChild $myNode
                            }                                        
                        }
                    ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                            set myNode  [simplify_Ellipse $node $parentPosition $targetNode]
                            $myNode setAttribute id $nodeID
                            $targetNode appendChild $myNode                                         
                        }
                    circle { # circle cx="58.4116" cy="120.791" r="5.04665"
                                # --- dont display the center_object with id="center_00"
                            set myNode  [simplify_Circle $node $parentPosition]
                            $myNode setAttribute id $nodeID
                            $targetNode appendChild $myNode 
                    }
                    path { # path d="M ......."
                            puts "   path: ->  $parentPosition"
                            set tmpNodes [ simplify_Path $node $parentPosition]
                            set loopID 0
                              # puts "\n\n  tmpNodes -> $tmpNodes \n\n"
                            foreach myNode $tmpNodes {
                                if {$myNode == {}} continue
                                incr loopID
                                $myNode setAttribute id [format "%s_%s" $nodeID $loopID]
                                    #
                                set myNode [checkPoly__x $myNode]
                                    #
                                if {$myNode != {}} {
                                    $targetNode appendChild $myNode
                                }
                            }
                        }        

                    default { 
                            # -- for temporary use, will never be added to $targetNode
                            set myNode [$flatSVG createElement unused ]
                        }
            }
            
            # puts "[$myNode asXML]"
            # puts "        $nodeName:  $objectPoints"
            # -- get nodeID
            if {[$node hasAttribute id]} {
                set nodeID   [$node getAttribute id]
                    # puts "  ... $nodeName / $nodeID"
            } else {
                set nodeID {... unset}  
            }
            $detailText insert 1.0 "    -> $nodeName - $nodeID\n"
            update
            

    }


    proc drawSVG {domSVG canvas {transform {0 0}}} {
                                   
            variable flatText
            variable fillGeometry
            variable centerNode
            variable free_ObjectID
            
            puts "\n"
            puts "  =============================================="
            puts "   -- drawSVG"
            puts "  =============================================="
            puts "\n"

                  
            set nodeList       [$domSVG childNodes]         
            set centerNode     {}
            set tagID 0
            
            
            foreach {transform_x transform_y} $transform break;    
            
                # return
            foreach node $nodeList {
                 if {[catch {draw_SVGNode $node $canvas $transform_x $transform_y} eID]} {
                     puts "   -> $eID"
                     tk_messageBox -title "creation Error: drawSVG" -icon error -message "\n$eID\n-----------\n[$node asXML]"
                 }
            }
            
            if {$centerNode != {}} {
                    puts   "\n     CenterNode:  \n"
                    puts   "         [$node asXML]\n"
                    set cx [copyAttribute $centerNode cx]
                    set cy [copyAttribute $centerNode cy]
                    if {$cx == {}} {
                        tk_messageBox -icon error -message "... please check coordinates cx/cy for node with id=\"center_00\"" 
                    }
                    if {$cy == {}} {
                        tk_messageBox -icon error -message "... please check coordinates cx/cy for node with id=\"center_00\"" 
                    }
                    set r  25
                    
                    set x1 [expr $cx - $r + $transform_x]
                    set y1 [expr $cy - $r + $transform_y]
                    set x2 [expr $cx + $r + $transform_x]
                    set y2 [expr $cy + $r + $transform_y]
                    set objectPoints [list $x1 $y1 $x2 $y2]

                    $canvas create oval $objectPoints -outline red -fill {} -tags __center_00__
            }
    }


    proc draw_SVGNode {node canvas transform_x transform_y} {
              
        variable flatText
        variable fillGeometry
        variable centerNode
        variable free_ObjectID

            # puts [$node asXML]
            
            # -- set defaults
        set objectPoints {}
        
            # -- get centerNode of SVG defined by id="center_00"
            #   circle or ellipse  by cx and cy attributes
            #
             #
        set nodeName [$node nodeName]
        if {[$node hasAttribute id]} {
                # puts "   -> [$node getAttribute id]"
            set tagName [$node getAttribute id]
            if {$tagName eq "center_00"} {
                    if {$centerNode != {}} {
                    tk_messageBox -icon info -message "centerNode allready exists:\n [$node asXML]" 
                    return
                } else {
                    set centerNode $node
                    puts "\n       centerNode found:"
                    puts   "         [$node asXML]\n"
                    # tk_messageBox -message "centerNode found:\n [$node asXML]" 
                    set nodeName centerNode
               }
            }
        } else {
            # -- give every node an id
            #
            incr free_ObjectID
            set  tagName  [format "_tag_%s_" $free_ObjectID]
            puts "\n   ... $tagName \n"
            $node setAttribute id $tagName
        }
        
        # -- give every node an id
            #   circle or ellipse  by cx and cy attributes
            #
        set myObject {}


        switch -exact $nodeName {
                g {
                            foreach childNode [$node childNodes] {
                                if {[catch {draw_SVGNode $childNode $canvas $transform_x $transform_y} eID]} {
                                     puts "   -> $eID"
                                     tk_messageBox -title "creation Error: draw_SVGNode" -icon error -message "\n$eID\n-----------\n[$childNode asXML]"
                                }    
                                set myObject {}
                                # break
                            }
                    }
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
                            set myObject [$canvas create polygon     $objectPoints -outline black -fill $fillGeometry -tags $tagName]
                    }
                polygon {
                            set valueList [ $node getAttribute points ]
                            if {[llength $valueList] < 2} {return}
                            foreach {coords} $valueList {
                                foreach {x y}  [split $coords ,] break
                                set x     [expr $x + $transform_x ]
                                set y     [expr $y + $transform_y ]
                                set objectPoints [lappend objectPoints $x $y ]
                            }
                                # -- create polygon
                                    # puts "\n$canvas create polygon     $objectPoints -outline black -fill white"
                            set myObject [$canvas create polygon     $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
                    }
                polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
                            set valueList [ $node getAttribute points ]
                            if {[llength $valueList] < 2} {return}
                            foreach {coords} $valueList {
                                foreach {x y}  [split $coords ,] break
                                set x     [expr $x + $transform_x ]
                                set y     [expr $y + $transform_y ]
                                set objectPoints [lappend objectPoints $x $y ]
                            }
                                # -- create polyline
                                    # puts "$canvas create line $objectPoints -fill black"
                            set myObject [$canvas create line $objectPoints -fill black  -tags $tagName]
                    }
                line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
                            set objectPoints [list	[expr [$node getAttribute x1] + $transform_x ] [expr [$node getAttribute y1] + $transform_y ] \
                                                    [expr [$node getAttribute x2] + $transform_x ] [expr [$node getAttribute y2] + $transform_y ] ]
                                # -- create line
                                    # puts "$canvas create line $objectPoints -fill black"
                            set myObject [$canvas create line $objectPoints -fill black]
                        }
                circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                # puts "[$node asXML]"
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
                            set myObject [$canvas create oval $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
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
                            set myObject [$canvas create oval $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
                    }
                default {
                            set myObject {}
                }
                # $detailText insert end 
        }
        
        if {$myObject eq {}} return
            # $canvas bind	$myObject	<ButtonPress-1> [list puts "    -> $tagName"]
            # $canvas bind	$myObject	<ButtonPress-1> [list searchrep'next $flatText $tagName]
        $canvas bind	$myObject	<ButtonPress-1> [list event_Canvas $tagName]
            # $canvas bind	$myObject	<ButtonPress-1> [list puts "    -> $tagName"; set ::Find $tagName; searchrep'next $flatText]
      
    }


    proc recursiveInsertTree {w node parent} {
            
        variable free_ObjectID
        
        proc getAttributes node {
            if {![catch {$node attributes} res]} {set res}
        } 
          
        set domDepth [llength [split [$node toXPath] /]]			
                  
                  # node Attributes
        set nodeName [$node nodeName]
        set nodeID   {}
        set done 0
        if {$nodeName eq "#text" || $nodeName eq "#cdata"} {
            set text [string map {\n " "} [$node nodeValue]]
        } else {
            set text {}
            foreach att [getAttributes $node] {
                switch -exact $att {
                    id {
                        set nodeID [$node getAttribute id]
                    }
                    default {
                        catch {append text " $att=\"[$node getAttribute $att]\""}
                    }
                }
            }
           
            set children [$node childNodes]
            if {[llength $children]==1 && [$children nodeName] eq "#text"} {
                append text "-textValue [$children nodeValue]"
                set done 1
            }
            
        }
            
            # -- set a unique ID to every treeNode
        if {$nodeID eq {}} {
            incr free_ObjectID
            set  tree_nodeID [format "_set_to_%s" $free_ObjectID]
        } else {
            set  tree_nodeID $nodeID
        }
        
        append nodeText "<$nodeName id=\"$tree_nodeID\" "
        append nodeText "$text"
        append nodeText "/>"

        
            # -- insert the treeNode
        set treeItem [$w insert $parent end -id $tree_nodeID -text $nodeName -tags $node -values [list $nodeID "$nodeText" ] ]
			
        switch -exact [expr $domDepth-1] {
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
        
        $w tag configure $treeItem -foreground $fill
			
          #ttk::style map Treeview \
            -background [list selected "#4a6984"] \
            -foreground [list selected "#ffffff"]   

                    # puts "   -> \$parent $parent"
                    # puts "   -> \$treeItem $treeItem"
                    # puts "   -> \$tree_nodeID $tree_nodeID"
                    # tk_messageBox -message  "   -> \$parent $parent"

        if {$parent eq {}} {$w item $treeItem -open 1}

        if !$done {
            foreach child [$node childNodes] {
                recursiveInsertTree $w $child $treeItem
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
            variable currentVersion
            
            
            variable exportFileName {exportFile.svg}
        
            puts "\n"
            puts "  =============================================="
            puts "   -- openSVG:   $argv"
            puts "  =============================================="
            puts "\n"
    
                # --- result SVG -----------
            set svgXML {<?xml version="1.0" encoding="UTF-8" standalone="no"?>
                <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
                <svg width="297mm" height="210mm" viewBox="0 0 297 210">
                 <defs>
                 </defs>
                </svg>} 
            set flatSVG [dom parse $svgXML]    
            
                # set flatSVG [dom createDocument svg]
                # set root [$flatSVG documentElement]
                # $root     setAttribute version 1.0
                # $root     setAttribute xmlns "http://www.w3.org/2000/svg"


                # --- open File ------------
            if {[llength $argv] == 0} {
                set fileName [tk_getOpenFile]
                set exportFileName $fileName
            } else {
                set fileName [file join [lindex $argv 0]]
            }
            if {$fileName == {}} {return}
			
            set fp [open $fileName]
			      # fconfigure    $fp -encoding utf-8
            set svg [read $fp]
            close         $fp
         
            
                # --- compute results ------            
            dom parse  $svg doc
            $doc documentElement root
            
                            
                #
            set flatSVG [simplifySVG $root]
                # set flatSVG [simplifySVG $root {50 50} ]
            $flatSVG setAttribute xmlns "http://www.w3.org/2000/svg"



                # --- cleanup outputs ------            
            $resultCanvas delete all
            cleanupTree $deepTree
            $deepText delete 1.0 end
            cleanupTree $flatTree
            $flatText delete 1.0 end

                # --- fill outputs ---------
            recursiveInsertTree $deepTree    $root         {}
            $deepText insert end $svg
            
                # --- working 
            puts [$flatSVG asXML]    
            drawSVG $flatSVG $resultCanvas {15 15}
            $flatText insert end {<?xml version="1.0" encoding="UTF-8"?>}
            $flatText insert end "\n"
            $flatText insert end [[$flatSVG ownerDocument ] asXML -doctypeDeclaration 1]
            
            updateContent
                        
            wm title . "simplifySVG $currentVersion - $fileName"
    }


    proc reloadSVG {} {
            variable fileName
            openSVG $fileName
    }


    proc updateContent {} {
            variable resultCanvas
            variable fileName
            variable deepTree
            variable deepText
            variable flatTree
            variable flatText 
            variable flatSVG
            variable currentVersion
            
            set svg [$flatText get 1.0 end]
            
            dom parse  $svg doc
            $doc documentElement root
            
            $resultCanvas delete all

            cleanupTree $flatTree

                # --- fill outputs ---------
            drawSVG $root $resultCanvas {15 15}
            recursiveInsertTree $flatTree     $root     {}
            
            fitContent
            
            wm title . "simplifySVG $currentVersion - $fileName (modified)"

            
    }


    proc fitContent {} {
            variable resultCanvas
            variable fitVector
            # variable centerNode
            
            puts "\n"
            puts "  =============================================="
            puts "   -- fitContent:   $resultCanvas"
            puts "  =============================================="
            puts "\n"
            
            set contentBBox [$resultCanvas bbox all]
            set contentWidth    [expr [lindex $contentBBox 2] - [lindex $contentBBox 0]]
            set contentHeight   [expr [lindex $contentBBox 3] - [lindex $contentBBox 1]]
            set contentCenter_x [expr [lindex $contentBBox 0] + 0.5*$contentWidth]
            set contentCenter_y [expr [lindex $contentBBox 1] + 0.5*$contentHeight]
            
            puts "   \$contentBBox  $contentBBox"
            puts "      \$contentCenter  $contentCenter_x / $contentCenter_x"
            puts "      \$contentWidth   $contentWidth"
            puts "      \$contentHeight  $contentHeight"
            
            
            set canvasWidth  [$resultCanvas cget  -width]
            set canvasHeight [$resultCanvas cget -height]
            puts "      \$canvasWidth   $canvasWidth"
            puts "      \$canvasHeight  $canvasHeight"
            
            set scale_x [expr 1.0*$canvasWidth / $contentWidth]
            set scale_y [expr 1.0*$canvasHeight / $contentHeight]
            
            set scale $scale_x
            if {$scale_y < $scale_x} {set scale $scale_y}
            
            set move_x [expr 0.5*$canvasWidth  - $contentCenter_x]
            set move_y [expr 0.5*$canvasHeight - $contentCenter_y] 
            set fitVector [list $move_x $move_y $scale]
            $resultCanvas move all $move_x $move_y
            if {$scale > 0} {
                $resultCanvas scale all [expr 0.5*$canvasWidth] [expr 0.5*$canvasHeight] $scale $scale
            }
            
            
                # -- draw centerline ----
                #     if definition exists
                #
            set centerNode [$resultCanvas gettags __center_00__]
            if {$centerNode ne {}} {
                set centerBB   [$resultCanvas bbox __center_00__]
                puts "     -> \$centerBB $centerBB"
                set c_x [expr 0.5*([lindex $centerBB 0] + [lindex $centerBB 2])]
                set c_y [expr 0.5*([lindex $centerBB 1] + [lindex $centerBB 3])]
                
                $resultCanvas delete __center_00__
                
                set objectPoints    [list	100 $c_y \
                                            [expr $canvasWidth - 100] $c_y]
 				        $resultCanvas create line $objectPoints -fill red -dash {20 1 1}
                set objectPoints    [list	$c_x 100 \
                                            $c_x [expr $canvasHeight - 100]]
 				        $resultCanvas create line $objectPoints -fill red -dash {20 1 1}
            }

    }


    proc saveContent {{mode {}}} {
            variable flatText 
            variable exportFileName
            variable file_saveCount
 
            puts "\n"
            puts "  =============================================="
            puts "   -- saveContent:   $exportFileName"
            puts "  =============================================="
            puts "\n"
            
            set systemTime [clock seconds]
            set timeString [clock format $systemTime -format %Y%m%d_%H%M%S]
            incr file_saveCount
           
            set fileName   [file rootname  [file tail $exportFileName]]
            set fileName   [format "%s_%s_%s.svg" $fileName $timeString $file_saveCount]
            
            
            set svgText [$flatText get 1.0 end]            
            dom parse  $svgText doc
            $doc documentElement root
            $root setAttribute  xmlns "http://www.w3.org/2000/svg"
             
            if {$mode eq {}} {
                set fileName [tk_getSaveFile -title "Export Content as svg" -initialdir [file normalize .] -initialfile $fileName ]
                if {$fileName eq {}} return
            }
            
            set fileId [open $fileName "w"]
                # puts -nonewline $fileId {<?xml version="1.0" encoding="UTF-8"?>}
                # puts -nonewline $fileId "\n"
            puts [encoding names]
                # fconfigure $fileId -encoding {utf-8}
                # fconfigure $fileId -encoding {iso8859-8}
                # puts -nonewline $fileId $svgText
            puts -nonewline $fileId [$doc asXML -doctypeDeclaration 1]
                # puts -nonewline $fileId [$doc asXML]
            close $fileId
            
            puts "\n         ... file saved as:"
            puts "               [file join [file normalize .] $exportFileName] \n"
    }


    proc event_flatTree {W T x y args} {
            variable flatSVG
            variable flatText
            variable detailText
            variable resultCanvas
            variable svg_LastHighlight
            variable my_Center_Object
            
            puts "\n  -> event_flatTree:  $W $T $x $y $args"
            set treeItem 	[$W selection]
            foreach itemID $treeItem {
                puts "         itemID: $itemID"
                set itemObject   [$W item $itemID]                     
                    # puts "         $itemObject"
                set svgNodeID    [$W set $itemID nodeID]
                    # puts "           -> \$svgNodeID $svgNodeID"
                searchrep'next $flatText $svgNodeID
                
                toggle_highlight_Object $svgNodeID          on          
                toggle_highlight_Object $svg_LastHighlight  off               
                set svg_LastHighlight $svgNodeID
                   # puts "\n"
            }
            
                # set selectedNode [$flatSVG getElementById $svgNodeID]
                # puts "\n   ->selectedNode: $svgNodeID"
                # puts "$selectedNode"
            
                # puts "   [$W item $itemID -text]\n"
                # puts "   [$W set $itemID nodeID]\n"
                # puts "   [$W set $itemID nodeValue]\n"
            
            
            $detailText delete 1.0 end
            
            $detailText insert end "$my_Center_Object\n"
            $detailText insert end "------------------------\n"
            $detailText insert end "Node Attributes:\n"
            $detailText insert end "------------------------\n\n"
                #$detailText insert end "   item -text:     [$W item $itemID -text]\n"
                #$detailText insert end "   item nodeID:    [$W set $itemID nodeID]\n"
                #$detailText insert end "   item nodeValue: [$W set $itemID nodeValue]\n"
            
            set nodeXML [$W set $itemID nodeValue]
            # puts "$nodeXML"
            
            set nodeSVG [dom parse $nodeXML]
            $nodeSVG documentElement root
                # puts [$nodeSVG asXML]
            foreach attr [$root attributes] {
                # puts "   -> $attr   [$root getAttribute $attr]"
                $detailText insert end "$attr:\n"
                $detailText insert end "   [$root getAttribute $attr]\n"
            }
            
            
            return
    }           


    proc event_Canvas {tagName {type {}}} {
            variable resultCanvas
            variable flatTree
            variable flatText
            variable my_Center_Object
            variable fitVector
            
              # -- create a center Circle on canvas
              #
            puts "\n    .. $tagName"
            catch {$resultCanvas delete {_my_Center_}}
            set objectCoords [$resultCanvas coords $tagName]
            set xmin  99999
            set ymin  99999
            set xmax -99999
            set ymax -99999
            foreach {x y} $objectCoords {
                if {$x < $xmin} {set xmin $x}
                if {$y < $ymin} {set ymin $y}
                if {$x > $xmax} {set xmax $x}
                if {$y > $ymax} {set ymax $y}
            }
            set center_x [expr ($xmin + $xmax)/2]
            set center_y [expr ($ymin + $ymax)/2]
            
            
            
            
            puts "         ... $xmin/$ymin $xmax/$ymax"
            $resultCanvas create oval [expr $center_x - 5]  [expr $center_y - 5]  [expr $center_x + 5]  [expr $center_y + 5] -tags  {_my_Center_}
            
              # -- fitVector
            foreach {x y scale} $fitVector break
            set canvasWidth  [$resultCanvas cget  -width]
            set canvasHeight [$resultCanvas cget -height]
            set dx  [expr ($center_x - 0.5*$canvasWidth)/$scale]
            set dy  [expr ($center_y - 0.5*$canvasHeight)/$scale]
            set cx  [expr $center_x - $dx - $x]
            set cy  [expr $center_y - $dy - $y]
            #puts 
            
            #   cx="278.8849839782714" cy="147.361163
            # puts "         ... [$resultCanvas coords $tagName]"
            # set my_Center_Object "$fitVector\ncenter:$center_x/$center_y\nc: $cx/$cy\n<circle id=\"center_00\" cx=\"$center_x\" cy=\"$center_y\" r=\"5\"/>" 
            set my_Center_Object "<circle id=\"center_00\" cx=\"$center_x\" cy=\"$center_y\" r=\"5\"/>" 
            puts $my_Center_Object
            
            
            
            # searchrep'next $flatText $tagName
            open_toNode $flatTree $tagName
            catch {$flatTree focus $tagName}
            catch {$flatTree selection set $tagName}
            catch {$flatTree see [lindex $tagName 0]}

    }


    proc open_toNode {w itemID} {
			if {$itemID != {}} {
				$w item [$w parent $itemID] -open 1
				open_toNode $w [$w parent $itemID]
			}
    }


    proc toggle_fillGeometry {} {
            variable fillGeometry
            
            if {$fillGeometry eq {}} {
                set fillGeometry gray80
            } else {
                set fillGeometry {}
            }
        
            updateContent   
    }


    proc toggle_highlight_Object {svgObject {status {on}}} {
            variable resultCanvas
            if {$status eq {on}} {
                set highlight_Color red
            } else {
                set highlight_Color black
            }
            set svgType [$resultCanvas type $svgObject]
            switch -exact $svgType {
                             g {}
                             polyline -
                             line { # set myObject [$canvas create line $objectPoints -fill black]
                                        $resultCanvas itemconfigure $svgObject -fill $highlight_Color
                                    }                           
                             rect -
                             polygon -
                             oval -
                             circle -
                             ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                         $resultCanvas itemconfigure $svgObject -outline $highlight_Color 
                                }
                             default {
                                    # tk_messageBox -message "What about $svgType"
                             }
            }
    }

                
            # -- http://wiki.tcl.tk/15612
            #    Richard Suchenwirth 2006-03-17
            #
            variable IgnoreCase 0
            variable Find {}
            variable Replace {}
            
            
            proc searchrep {t {replace 1}} {
               #variable IgnoreCase
               set w .sr
               if ![winfo exists $w] {
                   toplevel $w
                   wm title $w "Search"
                   grid [label $w.1 -text Find:] [entry $w.f -textvar ::Find] \
                           [button $w.bn -text Next \
                           -command [list searchrep'next $t]] -sticky ew
                   bind $w.f <Return> [list $w.bn invoke]
                   if $replace {
                       grid [label $w.2 -text Replace:] [entry $w.r -textvar ::Replace] \
                               [button $w.br -text Replace \
                               -command [list searchrep'rep1 $t]] -sticky ew
                       bind $w.r <Return> [list $w.br invoke]
                       grid x x [button $w.ba -text "Replace all" \
                               -command [list searchrep'all $t]] -sticky ew
                   }
                   grid x [checkbutton $w.i -text "Ignore case" -variable ::IgnoreCase] \
                           [button $w.c -text Cancel -command "destroy $w"] -sticky ew
                   grid $w.i -sticky w
                   grid columnconfigure $w 1 -weight 1
                   $t tag config hilite -background lightblue
               } else {raise $w}
            }       
            
            
            proc searchrep'next {w {searchString {}}} {
                $w tag config hilite -background lightblue
                if {$searchString ne {}} {
                    puts "   -> searchString: $searchString / $::Find"
                    set ::Find $searchString
                }
                puts "   -> searchString: $::Find"
                foreach {from to} [$w tag ranges hilite] {
                     $w tag remove hilite $from $to
                }
                set cmd [list $w search -count n -- $::Find insert+2c]
                if $::IgnoreCase {set cmd [linsert $cmd 2 -nocase]}
                set pos [eval $cmd]
                set lineNb [lindex [split $pos .] 0]
                    # puts "   ... found at $pos - $n -> $lineNb"        
                    # puts "   ... found at $pos - $n"        
                if {$pos ne ""} {
                     $w mark set insert ${lineNb}.0
                     $w see insert
                     $w tag add hilite ${lineNb}.0 [expr $lineNb +1].0-1c
                     # $w mark set insert $pos
                     # $w see insert
                     # $w tag add hilite $pos $pos+${n}c
                }
            }   
            
            
            proc searchrep'rep1 w {
               if {[$w tag ranges hilite] ne ""} {
                   $w delete insert insert+[string length $::Find]c
                   $w insert insert $::Replace
                   searchrep'next $w
                   return 1
               } else {return 0}
            }
            
            
            proc searchrep'all w {
                set go 1
                while {$go} {set go [searchrep'rep1 $w]}
            }
            
            # -- http://wiki.tcl.tk/15612
            #    Richard Suchenwirth 2006-03-17
            #
     
        
        # tk_messageBox -message "encoding system  [encoding system]"
    puts "encoding system  [encoding system]"
        
        # --- store fileName --
        #
    set fileName {}

        # --- window ----------
        #
    pack [ frame .f -bg lightblue] 
        
    set buttonBar    [ frame .f.bb ]
        pack $buttonBar      -expand yes -fill both 
    button $buttonBar.openSVG        -text " Open SVG "                -command openSVG
    button $buttonBar.reloadSVG      -text " reload SVG "              -command reloadSVG
    label  $buttonBar.sp_00          -text "           "
    button $buttonBar.fitContent     -text " fit Content "             -command fitContent
    label  $buttonBar.sp_01          -text "           "
    button $buttonBar.toggleFill     -text " toggle fill "             -command toggle_fillGeometry
    label  $buttonBar.sp_02          -text "           "
    button $buttonBar.updateContent  -text " update Content "          -command updateContent   
    label  $buttonBar.sp_03          -text "                                      "
    #button $buttonBar.saveContent    -text "   save Content   "        -command saveContent
        pack $buttonBar.openSVG $buttonBar.reloadSVG $buttonBar.sp_00 \
             $buttonBar.fitContent $buttonBar.sp_01 \
             $buttonBar.toggleFill  $buttonBar.sp_02 \
             $buttonBar.updateContent \
             -side left
        
    set nb_result    [ ttk::notebook .f.nb ]
        pack $nb_result      -expand yes -fill both   
     
    $nb_result add [frame $nb_result.nb_source]      -text "     SVG Source  "         
    $nb_result add [frame $nb_result.nb_work]        -text "     SVG Edit  "         

        
        # -- SOURCE Frame ----------------------
    set sourceFrame       [ frame $nb_result.nb_source.f     -relief flat ]    
        pack $sourceFrame    -expand yes -fill both
        # -- frame content
    set deepTreeFrame     [ frame    $sourceFrame.f_tree       -relief sunken ]
    set deepTextFrame     [ frame    $sourceFrame.f_text       -relief sunken ]
        pack $deepTreeFrame $deepTextFrame   \
                     -expand yes -fill both -padx 15 -pady 15 -side left  
             
        # -- WORKING Frame ----------------------
    set workFrame         [ frame    $nb_result.nb_work.f    -relief flat ]
        pack $workFrame    -expand yes -fill both
        # -- frame content
    set canvasFrame       [ frame    $workFrame.f_cv         -relief sunken ]
    set flatTreeFrame     [ frame    $workFrame.f_tree       -relief sunken ]
    set flatTextFrame     [ frame    $workFrame.f_text       -relief sunken ]
        pack $canvasFrame  $flatTreeFrame $flatTextFrame \
                     -expand yes -fill both -padx 15 -pady 15 -side left

        
       # --- ttk::style - treeview ---
       #
	   # ttk::style map Treeview.Row  -background [ list selected gainsboro ]
    ttk::style map Treeview.Row  -background [ list selected blue ]
    
  
 
        # --- result deep svg  - treeview---
        #
	set deepTree [ ttk::treeview $deepTreeFrame.t   \
                    -columns 		"nodeID nodeValue" \
					-displaycolumns "nodeID nodeValue" \
                    -xscrollcommand "$flatTreeFrame.x set" \
                    -yscrollcommand "$flatTreeFrame.y set" \
                    -height 30 ]
        $deepTree heading "#0"  -text "XML" -anchor w
        $deepTree column  "#0"  -width 100
        $deepTree heading nodeID 	-text "id" 
		$deepTree column  nodeID 	-width  50 -stretch no
		$deepTree heading nodeValue -text "Value" 
        $deepTree column  nodeValue -width 150 
        
    scrollbar $deepTreeFrame.x -ori hori -command  "$deepTreeFrame.t xview"
    scrollbar $deepTreeFrame.y -ori vert -command  "$deepTreeFrame.t yview"
        grid $deepTreeFrame.t $deepTreeFrame.y    -sticky news
        grid $deepTreeFrame.x                     -sticky news
        grid rowconfig    $deepTreeFrame 0 -weight 1
        grid columnconfig $deepTreeFrame 0 -weight 1

                
        # --- result flattend svg - textview ---
    set deepText [ text $deepTextFrame.txt -wrap none -xscroll "$deepTextFrame.h set" \
                                                      -yscroll "$deepTextFrame.v set" -height 46 -width 100 ]
    scrollbar $deepTextFrame.v -orient vertical   -command "$deepTextFrame.txt yview"
    scrollbar $deepTextFrame.h -orient horizontal -command "$deepTextFrame.txt xview"
        # Lay them out
        grid $deepTextFrame.txt $deepTextFrame.v  -sticky nsew
        grid $deepTextFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $deepTextFrame.txt 0 -weight 1
        grid columnconfigure $deepTextFrame.txt 0 -weight 1 

        
        # --- result canvas ---
        #
    set resultCanvas [ canvas $canvasFrame.cv -width 400 -height 600 -relief sunken -bg white]
        pack   $resultCanvas -fill both -expand yes -padx 0 -pady 0
 

        # --- result flattend svg - treeview ---
        #
    set flatTree [ ttk::treeview $flatTreeFrame.t  \
                    -columns 		"nodeID nodeValue" \
					-displaycolumns "nodeID nodeValue" \
                    -xscrollcommand "$flatTreeFrame.x set" \
                    -yscrollcommand "$flatTreeFrame.y set" \
                    -height 20 ]
        $flatTree heading "#0"  -text "XML" -anchor w
        $flatTree column  "#0"  -width 100
        $flatTree heading nodeID 	-text "id" 
		$flatTree column  nodeID 	-width  50 -stretch no
		$flatTree heading nodeValue -text "Value" 
        $flatTree column  nodeValue -width 150 
        
    scrollbar $flatTreeFrame.x -ori hori -command  "$flatTreeFrame.t xview"
    scrollbar $flatTreeFrame.y -ori vert -command  "$flatTreeFrame.t yview"
        grid $flatTreeFrame.t     $flatTreeFrame.y  -sticky news
        grid $flatTreeFrame.x                       -sticky news
        grid rowconfig        $flatTreeFrame 0  -weight 1
        grid columnconfig     $flatTreeFrame 0  -weight 1
        
    set detailText [ text $flatTreeFrame.txt -wrap none \
                                             -xscroll "$flatTreeFrame.h set" \
                                             -yscroll "$flatTreeFrame.v set" -height 6]
    scrollbar $flatTreeFrame.v -orient vertical   -command "$flatTreeFrame.txt yview"
    scrollbar $flatTreeFrame.h -orient horizontal -command "$flatTreeFrame.txt xview"
        # Lay them out
        grid $flatTreeFrame.txt $flatTreeFrame.v  -sticky nsew
        grid $flatTreeFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $flatTreeFrame.txt 0 -weight 1
        grid columnconfigure $flatTreeFrame.txt 0 -weight 1 
        
    bind $flatTree <<TreeviewSelect>> [list event_flatTree %W %T %x %y %k]    
        
        
        #grid rowconfigure    $flatTreeFrame.txt 1 -weight 1
        #grid columnconfigure $flatTreeFrame.txt 0 -weight 1

        # --- result flattend svg - textview ---
        #
    set flatText [ text $flatTextFrame.txt -wrap none -xscroll "$flatTextFrame.h set" \
                                                      -yscroll "$flatTextFrame.v set" -width 50 -height 44]
    scrollbar $flatTextFrame.v -orient vertical   -command "$flatTextFrame.txt yview"
    scrollbar $flatTextFrame.h -orient horizontal -command "$flatTextFrame.txt xview"
        # Lay them out
        grid $flatTextFrame.txt $flatTextFrame.v  -sticky nsew
        grid $flatTextFrame.h                     -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $flatTextFrame.txt 0 -weight 1
        grid columnconfigure $flatTextFrame.txt 0 -weight 1 
    button $flatTextFrame.bt_save    -text "   save Content   "        -command saveContent
        grid $flatTextFrame.bt_save              -sticky nsew -columnspan 2


        # --- compute ----------
        #
	$nb_result select  1
	update	
	#$nb_result select  0	
		
    wm title . "simplifySVG $currentVersion"
    
    puts " ... $argv"
    openSVG $argv
    
    # searchrep $flatText
    bind .  <Control-Key-f> [list searchrep $flatText]
    bind .  <Control-Key-s> [list saveContent force]
    
    
