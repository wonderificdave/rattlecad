#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

source lib_canvas.tcl
source lib_mathematic.tcl

proc Debug {args} {}

proc resize {args} {
      lib_canvas::recenter         $::w 0.1
	}

proc finish {args} {
      lib_canvas::recenter         $::w  0.1
      lib_canvas::mirror           $::w	
      lib_canvas::mouse_bindings   $::w
      update	  
	  tk_messageBox -message "next"
	  exit
	}

 # --------------------------------------
 
	# wm minsize . 900 900
              
			  
	   set w   [canvas .cv   -width  900  -height 900  -bd 2  -bg white  -relief sunken] 
   pack   $w   -fill both  -expand yes

   update
   
   bind . <Control-r>  "resize" 
   
   # ------------------------- 
            
			 $w create polygon   \
			                 10 10  30 10  10 30 \
							 -fill white         -outline red

			 $w create line   \
			                 10 110  30 110  10 130 \
							 -fill black
			    # ---------------------------------------------
   # ------------------------- 
							 
	proc geometry {w} {

			   set colour black
			   set lw     1
			   set tag    "component"

			lib_canvas::draw_circle $w  {00}  200     [ list center ]   red $lw {}

			
			  # -- gabelbrücke verstrebung --------------			 					
			$w create polygon   \
							475 3324 363 3016 189 2725 504 2728 \
					-tags [ list $tag fork basis ]         -fill white         -outline $colour   -width $lw  

					
			  # -- tauchrohr ----------------------------
			$w create polygon   \
							 44 -697 354 -697 354 -3217 44 -3217 \
					-tags [ list $tag fork tauchrohr ]     -fill white         -outline $colour   -width $lw				 


			   # -- fork_head ---------------------------				 
			$w create polygon   \
							-184    0  -184 -225  -131 -239  -38 -406    9 -579  17 -707 \
                             381 -707   381 -335   244 -201  191 -76   177    0 \
					-tags [ list $tag fork fork_head ]   -fill white         -outline $colour   -width $lw 
			$w create line   \
                            -127 -158  -21 -274  31 -314  241 -318  30 -355  31 -530 \
					-tags [ list $tag fork fork_head ]	 -fill $colour   -width $lw 
			   # -------------
			set ForkBase    { 0 0}

					
					
			  # -- gabelbrücke --------------------------				 					
		    $w create polygon   \
                             12  270   12 2494  -23 2562  -28 2589  -29 2757  416 2757 \
                            460 2864  472 3474  542 3456  661 3388  643 3184  609 3082 \
                            572 3011  545 2954  531 2765  488 2618  445 2515  408 2420 \
                            391 2321  389 2128  389 270 \
					-tags [ list $tag fork basis brücke ]  -fill white         -outline $colour   -width $lw  			 
			$w create line   \
                             538 3012  539 3207  608 3336 \
					-tags [ list $tag fork basis brücke ]  -fill $colour    -width $lw 			 
		    $w create line   \
							 28  187    74 147    121 86   142  18  118 -66   93  -99 \
                             53 -109    53 -12    49   9    43  27   27  46    6   52 \
                            -11   51   -25  45   -40  34   -46  21  -51   6  -48 -111 \
                            -94  -99  -130 -48  -145  63  -213 174 \
					-tags [ list $tag fork basis dropout ]  -fill $colour    -width $lw 
			   # -------------
			set ForkDropout_1    { 389  270}  ;#-2069
			set ForkDropout_2    {  28  180}  ;#-2152
			set ForkDropout_3    {-213  174}  ;#-2165
			set ForkDropout_4    {  12  270}  ;#-2069
            set ForkWheelCenter  {   0    0}  ;#-2339

			
			  # lib_canvas::draw_circle $w  $ForkDropout_2    100     [ list $tag dropout dropout2 ]      $colour $lw {}
			  # lib_canvas::draw_circle $w  $ForkDropout_3    100     [ list $tag dropout dropout3 ]      $colour $lw {}
			lib_canvas::draw_circle $w  $ForkWheelCenter  100     [ list $tag dropout wheelcenter ]   $colour $lw {}
			lib_canvas::draw_circle $w  $ForkBase         100     [ list $tag forkbase ]              $colour $lw {}
					
			set ForkRake         {400    0}
			set ForkHeight       {0  4500 }
			set ForkDropout_2    [mathematic::VAdd  $ForkDropout_2  $ForkRake]
			set ForkDropout_3    [mathematic::VAdd  $ForkDropout_3  $ForkRake]
			
			
			$w move dropout   [lindex $ForkRake   0] [lindex $ForkRake   1] 			
			$w move fork_head [lindex $ForkHeight 0] [lindex $ForkHeight 1] 
			$w move tauchrohr [lindex $ForkHeight 0] [lindex $ForkHeight 1] 
			
			$w create line    [lindex $ForkDropout_1 0] [lindex $ForkDropout_1 1] \
							  [lindex $ForkDropout_2 0] [lindex $ForkDropout_2 1] \
					-tags [ list $tag fork basis dropout ]  -fill $colour    -width $lw 
			$w create line    [lindex $ForkDropout_3 0] [lindex $ForkDropout_3 1] \
							  [lindex $ForkDropout_4 0] [lindex $ForkDropout_4 1] \
					-tags [ list $tag fork basis dropout ]  -fill $colour    -width $lw 
			
			$w move $tag      [expr -[lindex $ForkRake   0]]  [lindex $ForkRake   1]
			
			$w scale $tag     0 0  0.1 0.1
		    

	}						 

	geometry $w

	# -------------------------
 

      lib_canvas::recenter         $::w  1
      lib_canvas::mirror           $::w	
      lib_canvas::mouse_bindings   $::w
							 
