puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.28
    package require   vectormath    
    package require   appUtil
    
    #
    #
    #
set radFactor               [expr $vectormath::CONST_PI/180]
    #
#   HeadTubeAngle    68,281
set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
if 1 {
        set StemAngle           6   ; #-C5
        set ChainStay_SeatTube  64  ; #-C6
        set SeatTube_DownTube   60  ; #-C7
        set DownTube_HeadTube   61  ; #-C8
        set ChainStay_DownTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube] ; #-C9
        set ChainStay_HeadTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube - $DownTube_HeadTube]; #-C10                    
                                    
        set Stack               635   ; #-C13
        set StemLength          110   ; #-C14
        set ChainStayOffset     35    ; #-C15
        set ChainStay           410   ; #-C16
        set ForkHeight          415.2 ; #-C17
        set ForkRake            45    ; #-C18
        set BBOffset            65    ; #-C19

        puts " --------------------------"
        puts "    \$HeadTubeAngle           $HeadTubeAngle         "
        puts ""
        puts "    \$StemAngle               $StemAngle             "
        puts "    \$ChainStay_SeatTube      $ChainStay_SeatTube    "
        puts "    \$SeatTube_DownTube       $SeatTube_DownTube     "
        puts "    \$DownTube_HeadTube       $DownTube_HeadTube     "
        puts "    \$ChainStay_DownTube      $ChainStay_DownTube    "
        puts "    \$ChainStay_HeadTube      $ChainStay_HeadTube    "
        puts ""
        puts "    \$Stack                   $Stack                 "
        puts "    \$StemLength              $StemLength            "
        puts "    \$ChainStayOffset         $ChainStayOffset       "
        puts "    \$ChainStay               $ChainStay             "
        puts "    \$ForkHeight              $ForkHeight            "
        puts "    \$ForkRake                $ForkRake              "
        puts "    \$BBOffset                $BBOffset              "
        puts ""

        # -- direction - VERTICAL
        # ----------------------------------------------------
        puts " ==- VERTICAL -========================"
            #
        set grad_Vert_StemLength        [expr $HeadTubeAngle - 90 + $StemAngle]                                 ; # =D$1-90+C5
        set grad_Vert_HeadTube          $HeadTubeAngle                                                          ; # =D$1
        set grad_Vert_ChainStayOffset   [expr $HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 90]   ; # =D$1-C8+C9-90
        set grad_Vert_ChainStay         [expr $HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube]        ; # =D$1-C8+C9
        set grad_Vert_ForkHeight        $HeadTubeAngle                                                          ; # =D1
        set grad_Vert_ForkRake          [expr $HeadTubeAngle - 270]                                             ; # =D1+90-360
        set grad_Vert_BBOffset          270                                                                     ; # =270
            #   
        set rad_Vert_StemLength         [expr $radFactor * ($HeadTubeAngle - 90 + $StemAngle)]                                  ; # =D$1-90+C5
        set rad_Vert_HeadTube           [expr $radFactor *  $HeadTubeAngle]                                                     ; # =D$1
        set rad_Vert_ChainStayOffset    [expr $radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 90)]    ; # =D$1-C8+C9-90
        set rad_Vert_ChainStay          [expr $radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube)]         ; # =D$1-C8+C9
        set rad_Vert_ForkHeight         [expr $radFactor *  $HeadTubeAngle]                                                     ; # =D1
        set rad_Vert_ForkRake           [expr $radFactor * ($HeadTubeAngle - 270)]                                              ; # =D1+90-360
        set rad_Vert_BBOffset           [expr $radFactor * 270]                                                                 ; # =270
            #
        set sin_Vert_StemLength         [expr sin($radFactor * ($HeadTubeAngle - 90 + $StemAngle))]
        set sin_Vert_HeadTube           [expr sin($radFactor *  $HeadTubeAngle)] 
        set sin_Vert_ChainStayOffset    [expr sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 90))] 
        set sin_Vert_ChainStay          [expr sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube))] 
        set sin_Vert_ForkHeight         [expr sin($radFactor *  $HeadTubeAngle)] 
        set sin_Vert_ForkRake           [expr sin($radFactor * ($HeadTubeAngle - 270))] 
        set sin_Vert_BBOffset           [expr sin($radFactor * 270)] 
            #
        puts " --------------------------"
        puts "    StemLength        [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_StemLength        $rad_Vert_StemLength       $sin_Vert_StemLength     ]"
        puts "    HeadTube          [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_HeadTube          $rad_Vert_HeadTube         $sin_Vert_HeadTube       ]"
        puts "    ChainStayOffset   [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_ChainStayOffset   $rad_Vert_ChainStayOffset  $sin_Vert_ChainStayOffset]"
        puts "    ChainStay         [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_ChainStay         $rad_Vert_ChainStay        $sin_Vert_ChainStay      ]"
        puts "    ForkHeight        [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_ForkHeight        $rad_Vert_ForkHeight       $sin_Vert_ForkHeight     ]"
        puts "    ForkRake          [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_ForkRake          $rad_Vert_ForkRake         $sin_Vert_ForkRake       ]"
        puts "    BBOffset          [format {%8.4f / %-2.5f  ->  %8.4f}   $grad_Vert_BBOffset          $rad_Vert_BBOffset         $sin_Vert_BBOffset       ]"
            #
        set vert_HeadTube [expr $Stack + ( \
                                $StemLength         * $sin_Vert_StemLength        \
                            +   $ChainStayOffset    * $sin_Vert_ChainStayOffset   \
                            +   $ChainStay          * $sin_Vert_ChainStay         \
                            +   $ForkHeight         * $sin_Vert_ForkHeight        \
                            +   $ForkRake           * $sin_Vert_ForkRake          \
                            +   $BBOffset           * $sin_Vert_BBOffset          \
                        )]       
            #
        set HeadTube        [expr abs($vert_HeadTube / $sin_Vert_HeadTube)]
            #
        puts " --------------------------"
        puts "    vert_HeadTube     $vert_HeadTube   ($HeadTube)"
        puts " =========================="


        # -- direction - HeadTube
        # ----------------------------------------------------
        puts " ==- HEADTUBE -========================"
            #
        set grad_HT_StemLength          [expr 270 + $StemAngle]                                                 ; # =270+C5
        set grad_HT_HeadTube            0                                                                       ; # =0
        set grad_HT_ChainStayOffset     [expr 270 - $DownTube_HeadTube + $ChainStay_DownTube]                   ; # =-C8+C9-90
        set grad_HT_ChainStay           [expr 0 - $DownTube_HeadTube + $ChainStay_DownTube]                     ; # =-C8+C9
        set grad_HT_ForkHeight          0                                                                       ; # =0
        set grad_HT_ForkRake            90                                                                      ; # =90
        set grad_HT_BBOffset            [expr 720 - 90 - $HeadTubeAngle]                                        ; # =720-90+C1
            # 
        set rad_HT_StemLength           [expr $radFactor * (270 + $StemAngle)]                                  ; # =270+C5
        set rad_HT_HeadTube             [expr $radFactor * 0]                                                   ; # =0
        set rad_HT_ChainStayOffset      [expr $radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube)]    ; # =-C8+C9-90
        set rad_HT_ChainStay            [expr $radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube)]      ; # =-C8+C9
        set rad_HT_ForkHeight           [expr $radFactor * 0]                                                   ; # =0
        set rad_HT_ForkRake             [expr $radFactor * 90]                                                  ; # =90
        set rad_HT_BBOffset             [expr $radFactor * (720 - 90 - $HeadTubeAngle)]                         ; # =720-90+C1
            #
        set sin_HT_StemLength           [expr sin($radFactor * (270 + $StemAngle))]                 
        set sin_HT_HeadTube             [expr sin($radFactor * 0)]   ; # =0
        set sin_HT_ChainStayOffset      [expr sin($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))] 
        set sin_HT_ChainStay            [expr sin($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))]     
        set sin_HT_ForkHeight           [expr sin($radFactor * 0)]   ; # =0
        set sin_HT_ForkRake             [expr sin($radFactor * 90)]  ; # =90
        set sin_HT_BBOffset             [expr sin($radFactor * (720 - 90 - $HeadTubeAngle))]                            
            #
        set cos_HT_StemLength           [expr cos($radFactor * (270 + $StemAngle))]                 
        set cos_HT_HeadTube             [expr cos($radFactor * 0)]   ; # =0
        set cos_HT_ChainStayOffset      [expr cos($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))] 
        set cos_HT_ChainStay            [expr cos($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))]     
        set cos_HT_ForkHeight           [expr cos($radFactor * 0)]   ; # =0
        set cos_HT_ForkRake             [expr cos($radFactor * 90)]  ; # =90
        set cos_HT_BBOffset             [expr cos($radFactor * (720 - 90 - $HeadTubeAngle))] 
            #
        puts " --------------------------"
        puts "    StemLength        [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_StemLength        $rad_HT_StemLength       $cos_HT_StemLength       $sin_HT_StemLength     ]"
        puts "    HeadTube          [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_HeadTube          $rad_HT_HeadTube         $cos_HT_HeadTube         $sin_HT_HeadTube       ]"
        puts "    ChainStayOffset   [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_ChainStayOffset   $rad_HT_ChainStayOffset  $cos_HT_ChainStayOffset  $sin_HT_ChainStayOffset]"
        puts "    ChainStay         [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_ChainStay         $rad_HT_ChainStay        $cos_HT_ChainStay        $sin_HT_ChainStay      ]"
        puts "    ForkHeight        [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_ForkHeight        $rad_HT_ForkHeight       $cos_HT_ForkHeight       $sin_HT_ForkHeight     ]"
        puts "    ForkRake          [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_ForkRake          $rad_HT_ForkRake         $cos_HT_ForkRake         $sin_HT_ForkRake       ]"
        puts "    BBOffset          [format {%8.4f / %-2.5f  ->  %8.4f / %8.4f}   $grad_HT_BBOffset          $rad_HT_BBOffset         $cos_HT_BBOffset         $sin_HT_BBOffset       ]"
            #
        puts " --------------------------"
        puts "    StemLength        [expr $StemLength         * $cos_HT_StemLength     ]    [expr $StemLength         * $sin_HT_StemLength     ]"
        puts "    HeadTube          [expr $HeadTube           * $cos_HT_HeadTube       ]    [expr $HeadTube           * $sin_HT_HeadTube       ]"
        puts "    ChainStayOffset   [expr $ChainStayOffset    * $cos_HT_ChainStayOffset]    [expr $ChainStayOffset    * $sin_HT_ChainStayOffset]"
        puts "    ChainStay         [expr $ChainStay          * $cos_HT_ChainStay      ]    [expr $ChainStay          * $sin_HT_ChainStay      ]"
        puts "    ForkHeight        [expr $ForkHeight         * $cos_HT_ForkHeight     ]    [expr $ForkHeight         * $sin_HT_ForkHeight     ]"
        puts "    ForkRake          [expr $ForkRake           * $cos_HT_ForkRake       ]    [expr $ForkRake           * $sin_HT_ForkRake       ]"
        puts "    BBOffset          [expr $BBOffset           * $cos_HT_BBOffset       ]    [expr $BBOffset           * $sin_HT_BBOffset       ]"
            #
        set ht_long [expr (     $StemLength         * $cos_HT_StemLength        \
                            +   $HeadTube           * $cos_HT_HeadTube          \
                            +   $ChainStayOffset    * $cos_HT_ChainStayOffset   \
                            +   $ChainStay          * $cos_HT_ChainStay         \
                            +   $ForkHeight         * $cos_HT_ForkHeight        \
                            +   $ForkRake           * $cos_HT_ForkRake          \
                            +   $BBOffset           * $cos_HT_BBOffset          \
                        )]          
        set ht_vert [expr (     $StemLength         * $sin_HT_StemLength        \
                            +   $HeadTube           * $sin_HT_HeadTube          \
                            +   $ChainStayOffset    * $sin_HT_ChainStayOffset   \
                            +   $ChainStay          * $sin_HT_ChainStay         \
                            +   $ForkHeight         * $sin_HT_ForkHeight        \
                            +   $ForkRake           * $sin_HT_ForkRake          \
                            +   $BBOffset           * $sin_HT_BBOffset          \
                        )]       
            #
        set ht_diagonale [expr sqrt($ht_long*$ht_long + $ht_vert*$ht_vert)]
            #
        puts " --------------------------"
        puts "    ht_long           $ht_long"
        puts "    ht_vert           $ht_vert"
        puts " --------------------------"
        puts "    ht_diagonale      $ht_diagonale"
        puts " =========================="
            #
        puts ""
            #
        set rad_HT_ResultAngle      [expr atan($ht_vert/$ht_long)]
        set grad_HT_ResultAngle     [expr atan($ht_vert/$ht_long)/$radFactor]
        puts "    HT_ResultAngle        $rad_HT_ResultAngle ($grad_HT_ResultAngle)"
            #
        set rad_HeadTubeAngle_2     [expr $rad_Vert_HeadTube + $rad_HT_ResultAngle]
        set grad_HeadTubeAngle_2    [expr ($rad_Vert_HeadTube + $rad_HT_ResultAngle)/$radFactor]
        puts "    rad_HeadTubeAngle_2   $rad_HeadTubeAngle_2 ($grad_HeadTubeAngle_2)"
        set Stack_2                 [expr $ht_diagonale*sin($rad_HeadTubeAngle_2)]
        puts " --------------------------"
        puts "    Stack_2           $Stack_2"
        puts " =========================="
}


# -- direction - HeadTube
# ----------------------------------------------------
proc frame_Lug_Determination {headTubeAngle} {
            #
        # return 1    
            #
            
        # puts "\n"
        # puts " ==- COMPILE -========================="
            #
        set radFactor               [expr $vectormath::CONST_PI/180]
            #
        #   HeadTubeAngle    68,281
        set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
        set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281
            #
        set HeadTubeAngle       [expr 360 - $headTubeAngle]
            #
        puts "$HeadTubeAngle / $headTubeAngle"    
            #
        set StemAngle           6   ; #-C5
        set ChainStay_SeatTube  64  ; #-C6
        set SeatTube_DownTube   60  ; #-C7
        set DownTube_HeadTube   61  ; #-C8
        set ChainStay_DownTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube] ; #-C9
        set ChainStay_HeadTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube - $DownTube_HeadTube]; #-C10                    
            #
        set Stack               635   ; #-C13
        set StemLength          110   ; #-C14
        set ChainStayOffset     35    ; #-C15
        set ChainStay           410   ; #-C16
        set ForkHeight          415.2 ; #-C17
        set ForkRake            45    ; #-C18
        set BBOffset            65    ; #-C19
            #
        set vert_HeadTube [expr $Stack + ( \
                                $StemLength         * sin($radFactor * ($HeadTubeAngle - 90 + $StemAngle))        \
                            +   $ChainStayOffset    * sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 90))   \
                            +   $ChainStay          * sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube))        \
                            +   $ForkHeight         * sin($radFactor *  $HeadTubeAngle)        \
                            +   $ForkRake           * sin($radFactor * ($HeadTubeAngle - 270)) \
                            +   $BBOffset           * sin($radFactor * 270)                    \
                        )]       
            #
        set HeadTube        [expr abs($vert_HeadTube / sin($radFactor *  $HeadTubeAngle))]
            #
        puts "    vert_HeadTube     $vert_HeadTube   ($HeadTube)"
            #
            #
            #
        set ht_diagonale [expr sqrt ( \
                                        pow( \
                                            (   $StemLength         * cos($radFactor * (270 + $StemAngle))          \
                                            +   $HeadTube           * cos($radFactor * 0)                           \
                                            +   $ChainStayOffset    * cos($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))    \
                                            +   $ChainStay          * cos($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))      \
                                            +   $ForkHeight         * cos($radFactor * 0)                           \
                                            +   $ForkRake           * cos($radFactor * 90)                          \
                                            +   $BBOffset           * cos($radFactor * (720 - 90 - $HeadTubeAngle)) \
                                            ) \
                                        , 2) \
                                    + \
                                        pow ( \
                                            (   $StemLength         * sin($radFactor * (270 + $StemAngle))          \
                                            +   $HeadTube           * sin($radFactor * 0)                           \
                                            +   $ChainStayOffset    * sin($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))    \
                                            +   $ChainStay          * sin($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))      \
                                            +   $ForkHeight         * sin($radFactor * 0)                           \
                                            +   $ForkRake           * sin($radFactor * 90)                          \
                                            +   $BBOffset           * sin($radFactor * (720 - 90 - $HeadTubeAngle)) \
                                            ) \
                                        , 2) \
                                    ) \
                            ]
            #
        set rad_ht_resultAngle  [expr atan( \
                                            (   $StemLength         * sin($radFactor * (270 + $StemAngle))          \
                                            +   $HeadTube           * sin($radFactor * 0)                           \
                                            +   $ChainStayOffset    * sin($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))    \
                                            +   $ChainStay          * sin($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))      \
                                            +   $ForkHeight         * sin($radFactor * 0)                           \
                                            +   $ForkRake           * sin($radFactor * 90)                          \
                                            +   $BBOffset           * sin($radFactor * (720 - 90 - $HeadTubeAngle)) \
                                            ) \
                                    / \
                                            (   $StemLength         * cos($radFactor * (270 + $StemAngle))          \
                                            +   $HeadTube           * cos($radFactor * 0)                           \
                                            +   $ChainStayOffset    * cos($radFactor * (270 - $DownTube_HeadTube + $ChainStay_DownTube))    \
                                            +   $ChainStay          * cos($radFactor * (0 - $DownTube_HeadTube + $ChainStay_DownTube))      \
                                            +   $ForkHeight         * cos($radFactor * 0)                           \
                                            +   $ForkRake           * cos($radFactor * 90)                          \
                                            +   $BBOffset           * cos($radFactor * (720 - 90 - $HeadTubeAngle)) \
                                            ) \
                                    ) \
                            ]   
        set grad_ht_ResultAngle [expr $rad_ht_resultAngle / $radFactor]    
            #
        # puts " --------------------------"
        # puts "    ht_diagonale          $ht_diagonale"
        # puts "    rad_ht_resultAngle    $rad_ht_resultAngle ($grad_ht_ResultAngle)"
            #
            #
        set grad_HeadTubeAngle_2    [expr $HeadTubeAngle + $grad_ht_ResultAngle]
        set rad_HeadTubeAngle_2     [expr $radFactor *  ($HeadTubeAngle + $grad_ht_ResultAngle)]
            # puts "    rad_HeadTubeAngle_2   $rad_HeadTubeAngle_2 ($grad_HeadTubeAngle_2)"
        set Stack_2                 [expr $ht_diagonale*sin($rad_HeadTubeAngle_2)]
        # puts " --------------------------"
        puts "    Stack_2           $Stack_2"
        # puts " =========================="    
        
        return  [expr $Stack + $Stack_2]    
        
        
}       

set ht_angle 65
while {$ht_angle < 80} {
    # set angle [expr 360 - $ht_angle]
    set value [frame_Lug_Determination $ht_angle]
    # puts "  [format {%8.4f  %8.4f} $ht_angle $value]"
    set ht_angle [expr $ht_angle + 0.5]
}
