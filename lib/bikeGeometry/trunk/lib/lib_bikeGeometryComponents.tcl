 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometry_custom.tcl
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
 #    namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

        #
        # --- set SeatPost ------------------------
    proc bikeGeometry::create_SeatPost {} {
                #
            variable Polygon
            variable Position
            variable Geometry
                #
            variable Saddle
            variable SeatPost
            variable TopTube
            variable SeatTube
                #
            variable Result
                #
            set pt_00       $Position(SeatPost_SeatTube)
            set pt_99       {0 0}
                #
            set pt_01       $Position(SeatPost_Saddle)
                #
            set vct_01      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 35 ]
            set vct_05      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 20 ]
            set vct_06      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 30 ]
            set pt_02       [ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0} $Position(SeatPost_SeatTube) ]
                #
            set pt_10       $pt_01
            set pt_11       $pt_02
            set pt_12       $Position(TopTube_Start)
                #
            set pt_13       $SeatTube(DownTube)
            set vct_ST      [ vectormath::subVector $Position(TopTube_Start) $SeatTube(DownTube)] 
                #
            set pt_20       [ vectormath::addVector $Position(SeatPost_SeatTube) [ vectormath::unifyVector $Position(SeatPost_SeatTube) $SeatTube(DownTube) 75.0 ] ]
                # set pt_20 [ vectormath::addVector $Position(SeatPost_SeatTube) [ vectormath::unifyVector $Position(SeatPost_SeatTube) {0 0} 675.0 ] ]
            set vct_10      [ vectormath::parallel  $pt_12 $pt_20 [expr 0.5 * $SeatPost(Diameter)] ]
            set vct_11      [ vectormath::parallel  $pt_12 $pt_20 [expr 0.5 * $SeatPost(Diameter)] left]
            set vct_15      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $SeatPost(Diameter) -5] left]
                #
                # puts " -> SeatPost"
                
                # set polyline  "13.5989,-1.3182 13.4789,-2.5115 13.1643,-5.6659 12.5937,-9.0769 11.7884,-12.7185 10.9667,-15.7283 10.1936,-18.175 9.5246,-20.0034 8.5409,-22.3099 7.2154,-24.9485 5.5208,-27.773 3.43,-30.6374 1.5276,-32.7944 -0.3539,-34.7937 -2.347,-36.636 -4.3817,-38.2747 -6.707,-39.8938 -8.7112,-41.1006 -11.212,-42.3902 -13.5496,-43.4003 -16.29,-44.3671 -18.7682,-45.0546 -21.3969,-45.5995 -24.5756,-46.0134 -28.0195,-46.1561 -31.8065,-45.983 -34.8534,-45.5653 -37.9101,-44.8966 -40.1926,-44.227 -42.3258,-43.4623 -43.5886,-42.6367 -44.1867,-42.1325 -44.3757,-41.3807 -43.9618,-39.6722 -43.681,-38.9927 -43.2884,-38.7329 -42.7931,-38.5496 -42.283,-38.5839 -41.8194,-38.7683 -41.1634,-39.1064 -39.6321,-39.8205 -37.8997,-40.5087 -35.5587,-41.2516 -33.218,-41.7936 -30.7338,-42.162 -28.6077,-42.315 -25.9892,-42.3033 -23.1653,-42.042 -20.4089,-41.5287 -17.7059,-40.7334 -15.0552,-39.7382 -12.2211,-38.3082 -9.8302,-36.7916 -7.7268,-35.1785 -5.9291,-33.5486 -4.295,-31.8174 -2.9598,-30.1792 -1.5385,-28.1425 -0.794,-25.3638 -1.1078,-22.226 -0.794,-25.3638 -1.5385,-28.1425 -2.9598,-30.1792 -4.295,-31.8174 -5.9291,-33.5486 -7.7268,-35.1785 -9.8302,-36.7916 -12.2211,-38.3082 -15.0552,-39.7382 -17.7059,-40.7334 -20.4089,-41.5287 -23.1653,-42.042 -25.9892,-42.3033 -28.6077,-42.315 -30.7338,-42.162 -33.218,-41.7936 -35.5587,-41.2516 -37.8997,-40.5087 -39.6321,-39.8205 -41.1634,-39.1064 -41.8194,-38.7683 -42.283,-38.5839 -42.7931,-38.5496 -43.2884,-38.7329 -43.681,-38.9927 -43.4595,-38.4572 -43.1745,-38.0921 -42.8444,-37.8607 -42.3437,-37.6034 -41.6384,-37.325 -40.8501,-37.0395 -40.0765,-36.7304 -39.303,-36.3718 -38.5153,-35.9378 -37.6988,-35.4023 -34.0397,-32.9438 -30.1695,-30.1224 -26.3083,-26.7006 -21.7663,-21.7594 -18.0718,-16.7489 -16.5658,-14.4083 -15.8413,-12.8905 -15.1253,-11.0864 -14.6535,-9.7442 -14.1928,-8.2413 -13.8083,-6.6772 -13.5652,-5.1515 -13.5287,-3.7637 -13.601,1.3182"
                # set polyline  "0,50 [expr -1.0*$SeatPost(PivotOffset)],0 [expr -1.0*$SeatPost(PivotOffset)],50 "
                #
            set polyline    "12.6235,-1.2235 12.6243,-1.4196 12.5121,-2.331 12.2201,-5.2588 11.6905,-8.4246 10.9431,-11.8045 10.1805,-14.598 9.4629,-16.8689 8.842,-18.5659 7.929,-20.7067 6.6987,-23.1557 5.1259,-25.7772 3.1854,-28.4358 1.4197,-30.4377 -0.3266,-32.2934 -2.1765,-34.0033 -4.065,-35.5242 -6.2232,-37.027 -8.0833,-38.147 -10.4044,-39.344 -12.574,-40.2815 -15.1175,-41.1788 -17.4176,-41.8169 -19.8574,-42.3226 -22.8077,-42.7068 -26.0041,-42.8392 -29.519,-42.6786 -32.3469,-42.2909 -35.184,-41.6703 -37.3024,-41.0488 -39.2823,-40.339 -40.4544,-39.5728 -41.0095,-39.1048 -41.1849,-38.407 -40.8008,-36.8213 -40.5401,-36.1906 -40.3753,-36.0544 -40.1758,-35.9495 -39.946,-35.8356 -39.716,-35.7794 -39.4541,-35.7718 -39.2426,-35.8112 -39.0317,-35.8909 -38.8123,-35.9823 -38.2035,-36.2962 -36.7822,-36.9589 -35.1743,-37.5977 -33.0015,-38.2872 -30.829,-38.7902 -28.5234,-39.1322 -26.55,-39.2742 -24.1197,-39.2633 -21.4987,-39.0208 -18.9404,-38.5444 -16.4317,-37.8062 -13.9714,-36.8825 -11.341,-35.5553 -9.1219,-34.1477 -7.1697,-32.6505 -5.5012,-31.1377 -3.9845,-29.531 -2.7452,-28.0105 -1.4261,-26.1201 -0.7351,-23.5411 -1.0263,-20.6288 -0.7351,-23.5411 -1.4261,-26.1201 -2.7452,-28.0105 -3.9845,-29.531 -5.5012,-31.1377 -7.1697,-32.6505 -9.1219,-34.1477 -11.341,-35.5553 -13.9714,-36.8825 -16.4317,-37.8062 -18.9404,-38.5444 -21.4987,-39.0208 -24.1197,-39.2633 -26.55,-39.2742 -28.5234,-39.1322 -30.829,-38.7902 -33.0015,-38.2872 -35.1743,-37.5977 -36.7822,-36.9589 -38.2035,-36.2962 -38.8123,-35.9823 -39.0317,-35.8909 -39.2426,-35.8112 -39.4541,-35.7718 -39.716,-35.7794 -39.946,-35.8356 -40.1758,-35.9495 -40.3876,-36.0645 -40.5401,-36.1906 -40.3346,-35.6936 -40.07,-35.3547 -39.7637,-35.14 -39.2989,-34.9012 -38.6443,-34.6428 -37.9127,-34.3778 -37.1947,-34.0909 -36.4768,-33.7581 -35.7457,-33.3553 -34.9878,-32.8582 -31.5917,-30.5764 -27.9996,-27.9578 -24.4159,-24.7819 -20.2003,-20.1957 -16.7713,-15.5453 -15.3735,-13.3729 -14.7011,-11.9642 -14.0365,-10.2897 -13.5986,-9.044 -13.171,-7.6491 -12.8142,-6.1974 -12.5885,-4.7813 -12.5546,-3.4932 -12.6218,1.2235" 
                #

                #
            set headGeom  {}
            foreach {xy}   $polyline {
                foreach {x y} [split $xy ,] break;
                lappend headGeom $x [expr -1.0 * $y]
            }
                # -- correction of polyline position
            set headGeom    [ vectormath::addVectorPointList {0 -10} $headGeom ]
                # -- align to seattube
            set headGeom    [ vectormath::rotatePointList    {0 0} $headGeom [expr 90 - $Geometry(SeatTube_Angle)] ]
                # -- position seatpost
            set headGeom    [ vectormath::addVectorPointList  $Position(SeatPost_SeatTube)  $headGeom ]
                
                #
            set head_P1     [ lrange $headGeom 0 1 ]
            set head_P2     [ lrange $headGeom end-1 end ]
                #
            lappend          polygon     [lindex $vct_10 0]  [lindex $vct_10 1]
            lappend          polygon     $headGeom
            lappend          polygon     [lindex $vct_11 1]  [lindex $vct_11 0]
                #
            set Polygon(SeatPost)   [bikeGeometry::flatten_nestedList $polygon]
                #
    }


        #
        # --- set HeadSet -------------------------
    proc bikeGeometry::create_HeadSet {} {
                #
            variable Direction
                #
            variable Position
            variable Polygon
            variable HeadTube
            variable HeadSet
            variable Steerer
                #
            variable Result
                #
            set pt_10       $Position(HeadTube_Start)
            set pt_12       $Position(Steerer_Start)
            set pt_11       [ vectormath::addVector $pt_12 $Direction(HeadTube) [expr 0.5 * $HeadSet(Height_Bottom)]]
                #
            if {$HeadSet(Height_Bottom) > 8} {
                set vct_10      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] ]
                set vct_11      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] ]
                set vct_12      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] left]
                set vct_13      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] left]
                set polygon     [list   [lindex $vct_10 0]  [lindex $vct_11 0] \
                                        [lindex $vct_12 0]  [lindex $vct_11 0] \
                                        [lindex $vct_11 1] \
                                        [lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
            } else {
                if {$HeadSet(Height_Bottom) < 0.1} {
                    set polygon     [list 0 0 0 0]
                } else {
                    set SteererDM   28.6 ;# believe that there is no integrated Headset with this size
                    set vct_10      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] ]
                    set vct_11      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * 35 ] ]
                    set vct_12      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * 35 ] left]
                    set vct_13      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] left]
                    set polygon     [list   [lindex $vct_10 0]  [lindex $vct_10 1] \
                                            [lindex $vct_11 1]  [lindex $vct_12 1] \
                                            [lindex $vct_13 1] \
                                            [lindex $vct_10 1]  [lindex $vct_13 1] [lindex $vct_13 0] ]
                 }
            }
                #
            set Polygon(HeadSetBottom)      [bikeGeometry::flatten_nestedList $polygon]
                #
            if {$HeadSet(Height_Top) < 2} {    set HeadSet(Height_Top) 2}
            if {$HeadSet(Height_Top) > 8} {
                    set majorDM     $HeadSet(Diameter)
                    set height_00    [expr 0.5 * $HeadSet(Height_Top)]
            } else {
                    set majorDM     $HeadTube(Diameter)
                    set height_00    1
            }
            set pt_12       $Position(HeadTube_End)
            set pt_11       [ vectormath::addVector $pt_12 $Direction(HeadTube) $height_00]
            set pt_10       [ vectormath::addVector $pt_11 $Direction(HeadTube) [expr $HeadSet(Height_Top) - $height_00]]
                #
                # puts "\n\n"
                # puts "   pt_10:  $pt_10"
                # puts "   pt_11:  $pt_11"
                # puts "   pt_12:  $pt_12"
                # puts "\n\n"
                #
            set HeadSet(Stem)               $pt_10
                    set vct_10      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] ]
                    set vct_11      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] ]
                    set vct_12      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] left]
                    set vct_13      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] left]
                    set polygon     [list   [lindex $vct_10 0]  [lindex $vct_11 0] \
                                            [lindex $vct_12 0]  [lindex $vct_11 0] \
                                            [lindex $vct_11 1] \
                                            [lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
                #
            set Polygon(HeadSetTop)     [bikeGeometry::flatten_nestedList $polygon]
                #
                #
            return  
                #
    }


        #
        # --- set Stem ----------------------------
    proc bikeGeometry::create_Stem {} {
                #
            variable Direction
            variable Geometry
            variable Polygon
            variable Position
                #
            variable HeadTube
            variable HandleBar
            variable HeadSet
            variable Steerer
            variable Stem
                #
            variable Result
                #
            set pt_00       $Position(HandleBar)
            set pt_01       $Position(Steerer_End)
            set pt_02       $HeadSet(Stem)

                # -- ceck coincidence
            set checkStem           [ vectormath::checkPointCoincidence $pt_00 $pt_01]
            if {$checkStem == 0} {
                # puts "   ... no Stem required"
                set Polygon(Stem) {}
                return
            }
                #
            set Stem(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
            set angle                           [ vectormath::angle {1 0}    {0 0}    $Stem(Direction) ]
            set clamp_SVGPolygon    "-18.8336,-17.9999 -15.7635,-18.3921 -13.3549,-19.887 -11.1307,-22.1168 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.3549,19.8872 -15.7635,18.3923 -18.8336,18.0001 "
            set clamp_SVGPolygon    "-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "

                set polygon         [ string map {"," " "}  $clamp_SVGPolygon ]
                set polygon         [ coords_flip_y $polygon]
                set polygon         [ vectormath::addVectorPointList [list $Geometry(HandleBar_Distance) $Geometry(HandleBar_Height)] $polygon]
                set polygon         [ vectormath::rotatePointList $Position(HandleBar) $polygon $angle ]

            set polygonLength   [ llength $polygon  ]
            set pt_099          [ list [lindex $polygon 0] [lindex $polygon 1] ]
            set pt_000          [ list [lindex $polygon $polygonLength-2] [lindex $polygon $polygonLength-1] ]
            set stemWidth       [ vectormath::length $pt_099 $pt_000 ]
            set stemDiameter    34
            set vct_099         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] left]
            set vct_000         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] ]
            set vct_010         [ vectormath::parallel $pt_02 $pt_01 [expr 0.5 * $stemDiameter    + 4 ] ]
            set pt_095          [ vectormath::intersectPoint [lindex $vct_099 0] [lindex $vct_099 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
            set pt_50           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_095 ]
            set pt_51           [ vectormath::addVector $pt_50  [ vectormath::unifyVector {0 0} $Direction(HeadTube) 2] ]
            set pt_005          [ vectormath::intersectPoint [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
            set pt_12           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_005 ]
            set pt_11           [ vectormath::addVector $pt_12 [ vectormath::unifyVector {0 0} $Direction(HeadTube) -2] ]
            set vct_020         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] ]
            set vct_021         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] left ]
            set vct_030         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] ];# ShimDiameter from HeadSet definition above
            set vct_031         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] left ]
            set vct_040         [ vectormath::parallel [lindex  $vct_021 1] [lindex  $vct_020 1] 5  left]
                #
            set polygon         [ lappend polygon   $pt_005 \
                                                    [lindex  $vct_020 0] [lindex  $vct_021 0] [lindex  $vct_020 0] \
                                                    [lindex  $vct_030 0] [lindex  $vct_031 0] [lindex  $vct_021 0] \
                                                    [lindex  $vct_021 1] [lindex  $vct_020 1] [lindex  $vct_021 1] \
                                                    [lindex  $vct_040 0] [lindex  $vct_040 1] [lindex  $vct_020 1] \
                                                    $pt_095 ]
            set Polygon(Stem)   [bikeGeometry::flatten_nestedList $polygon]
                #
            return    
                #
    }


        #
        # --- set FenderRear ----------------------
    proc bikeGeometry::create_RearFender {} {
                #
            variable Direction
                #
            variable Geometry
            variable Direction
            variable Polygon
            variable RearFender
            variable Result
            variable ChainStay
            variable RearWheel
                #
            variable Result
                #

                #
            if {$RearFender(Radius) < $Geometry(RearWheel_Radius)} {
                set RearFender(Radius)                     [expr $Geometry(RearWheel_Radius) + 5.0]
                puts "\n                     -> <i> \$RearFender(Radius) ........... $RearFender(Radius)"
            }               
                #
            set AngleChainStay [vectormath::dirAngle $Direction(ChainStay) {0 0} ]
                #
            set AngleStart          [expr 180 + $AngleChainStay]
                #
            set polygon             [_createFender $RearFender(Radius) $AngleStart $RearFender(OffsetAngle)  $RearFender(Height)]
                #
            set Polygon(RearFender) [bikeGeometry::flatten_nestedList $polygon]
                #
            return
                #
    }


        #
        # --- set FenderFront ----------------------
    proc bikeGeometry::create_FrontFender {} {
                #
            variable Direction
                #
            variable Geometry
            variable Polygon
            variable FrontFender
            variable Result
            variable HeadTube
            variable FrontWheel
                #
            variable Result
                #
            if {$FrontFender(Radius) < $Geometry(FrontWheel_Radius)} {
                set FrontFender(Radius)                     [expr $Geometry(FrontWheel_Radius) + 5.0]
                puts "\n                     -> <i> \$FrontFender(Radius) .......... $FrontFender(Radius)"
            }
                #
            set AngleHeadTube       [vectormath::dirAngle {0 0} $Direction(HeadTube)]
                #
            set AngleStart          [expr $AngleHeadTube - $FrontFender(OffsetAngleFront)]
                #
            set polygon             [_createFender $FrontFender(Radius) $AngleStart $FrontFender(OffsetAngle)  $FrontFender(Height)]
                #
            set Polygon(FrontFender)    [bikeGeometry::flatten_nestedList $polygon]
                #
            return
                #
    }



    #-------------------------------------------------------------------------
        #  Fork Blade Polygon for suspension Fork
    proc bikeGeometry::_createFender {radius angleStart angleLength height} {
            #
        set precision 3; # mm
            #
            # puts "  -> \$radius       $radius"
            # puts "  -> \$angleStart   $angleStart"
            # puts "  -> \$angleLength  $angleLength"
            # puts "  -> \$height       $height"
            #
        set angleEnd    [expr $angleStart + $angleLength]
        set arcLength   [expr $angleLength * 2 * $radius * $vectormath::CONST_PI / 360]
        set nr_Elements [expr round ($arcLength / $precision)]
        set incrAngle   [expr $angleLength / $nr_Elements]
        
        set pointList    {}
        for {set angle $angleStart} {$angle <= $angleEnd} {set angle [expr $angle + $incrAngle]} {
            lappend pointList [vectormath::rotateLine {0 0} $radius $angle]
        }
            #
        set angleEnd    [expr $angleEnd   - 2]
        set angleStart  [expr $angleStart + 2]
        set innerRadius [expr $radius - $height]
            #
        for {set angle $angleEnd} {$angle >= $angleStart} {} {
            lappend pointList [vectormath::rotateLine {0 0} $innerRadius $angle]
            set angle [expr $angle - $incrAngle]
        }
            #
        return [bikeGeometry::flatten_nestedList $pointList]
            #
    }



    #-------------------------------------------------------------------------
        #  CrankSet
    proc bikeGeometry::create_CrankArm {} {
            #
        variable CrankSet
        variable Polygon
        variable BottomBracket
            #
        set length_PedalMount   [expr 0.5 * $CrankSet(Q-Factor)  ]
        set length_BB           [expr 0.5 * $BottomBracket(Width)]
            #
            
            # -- help points
        set pt_00       [ list [expr -1.0 * $CrankSet(Length)] [expr -1.0 *  $length_PedalMount + $CrankSet(ArmWidth) + 10] ]
        set pt_02       [ list [expr -1.0 * $CrankSet(Length)] [expr -1.0 *  $length_PedalMount] ]
        set pt_01       [ list [expr -1.0 * $CrankSet(Length)] [expr -1.0 *  $length_PedalMount + $CrankSet(ArmWidth)] ]
        set pt_03       [ list [expr -1.0 * $CrankSet(Length)] [expr -1.0 * ($length_PedalMount + 10)] ]
                
            # -- polygon points: pedal mount
        set pt_10       [ vectormath::addVector $pt_01 { 30.0 0} ]
        set pt_11       [ vectormath::addVector $pt_01 [list [expr -1.0 * $CrankSet(PedalEye)] 0] ]
        set pt_12       [ vectormath::addVector $pt_02 [list [expr -1.0 * $CrankSet(PedalEye)] 0] ]
        set pt_13       [ vectormath::addVector $pt_02 { 40.0 0} ]
        
            # -- polygon points: BottomBracket mount
            # set pt_25       [ list -35 [expr -1.0 * ($length_BB + 15) ] ]
            # set pt_24       [ list -23 [expr -1.0 * ($length_BB + 10) ] ]
            # set pt_23       [ list -23 [expr -1.0 * ($length_BB +  5) ] ]
            # set pt_22       [ list  23 [expr -1.0 * ($length_BB +  5) ] ]
            # set pt_21       [ list  21 [expr -1.0 * ($length_BB + 30) ] ]
            # set pt_20       [ list -30 [expr -1.0 * ($length_BB + 30) ] ]
                 #
            # set polygon         [ appUtil::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                     #$pt_20  $pt_21  $pt_22  $pt_23  $pt_24  $pt_25] 
            #
        set pt_26       [ list -65 [expr -1.0 * ($length_BB + 17) ] ]
        set pt_25       [ list -35 [expr -1.0 * ($length_BB + 13) ] ]
        set pt_22       [ list  22 [expr -1.0 * ($length_BB + 13) ] ]
        set pt_21       [ list  21 [expr -1.0 * ($length_BB + 30) ] ]
        set pt_20       [ list -30 [expr -1.0 * ($length_BB + 30) ] ]
            #
        set polygon         [ appUtil::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                $pt_20  $pt_21  $pt_22  $pt_25 ] 
            #
        set Polygon(CrankArm_xy)    [bikeGeometry::flatten_nestedList $polygon]
            #
        return    
            #
    }
    

