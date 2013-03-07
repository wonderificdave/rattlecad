##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


	set WINDOW_Title      "cad_canvasCAD, an extension for canvas"

	  
	set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
	puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
	lappend auto_path "$APPL_ROOT_Dir"
	  
	package require 	Tk
	package require   canvasCAD
    
    
	pack [ frame .f ] -expand yes -fill both
	
		# --------------------------------------------
				# 	notebook
			pack [ ttk::notebook .f.nb] -fill both  -expand yes
	
	
		# --------------------------------------------
				# 	tab 1
			.f.nb add [frame .f.nb.f1] -text "First tab" 

			set f1_canvas  [labelframe .f.nb.f1.f_canvas   -text "board"  ]
			set f1_config  [frame      .f.nb.f1.f_config   ]

			pack  $f1_canvas  $f1_config    -side left -expand yes -fill both
			pack  configure   $f1_config    -fill y
			
			# set myCanvas [canvasCAD::newCanvas cv01  $cv_path 	"MyCanvas"  $cv_width $cv_height 	A3 0.5 $args]
			set cv01 [canvasCAD::newCanvas cv01  $f1_canvas.cv01 	"MyCanvas_01"  880  610 	A3 0.5 40 -bd 2  -bg white  -relief sunken ]
			# set cv01 [canvasCAD::newCanvas cv01  $f1_canvas.cv01  880  610   180  140 m  0.5 -bd 2  -bg white  -relief sunken ]
				
				$cv01  create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
				$cv01  create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
				$cv01  create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
				$cv01  create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
				$cv01  create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
				$cv01  create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
				$cv01  create   text		{150 90}  -text "text 150 90 360°"
				$cv01  create   vectortext	{160 30}  -text "vectorText  160 30  -size 20"  -size 20	
				$cv01  create   vectortext	{210 70}  -text "vectorText  210 70  -size 10"  -size 10
				$cv01  create   vectortext	{120 170} -text "Sonderzeichen:  grad \°, exp ^"  -size 10

				
					
	
		# --------------------------------------------
				# 	tab 2
			.f.nb add [frame .f.nb.f2] -text "Second tab"
			
			set f2_canvas  [labelframe .f.nb.f2.f_canvas   -text "board"  ]
			set f2_config  [frame      .f.nb.f2.f_config   ]

			pack  $f2_canvas  $f2_config    -side left -expand yes -fill both
			pack  configure   $f2_config    -fill y

			.f.nb select .f.nb.f2
			set cv02 [canvasCAD::newCanvas cv02  $f2_canvas.cv02 	"MyCanvas_02"  880  610 	A4 0.5 40 -bd 2  -bg white  -relief sunken ]
			# set cv02 [canvasCAD::newCanvas cv02  $f2_canvas.cv02  880  610 6.5  6.9 i 0.5 -bd 2  -bg white  -relief sunken ]
				
				$cv02  create   rectangle  	{4.5 3.1 6.2 5.0 } 	-tags {Line_01}  -fill violet   -width 2 
				$cv02  create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

				$cv02  create   text		{3.4 2.2}  -text "text  3.4 2.2"
				$cv02  create   vectortext	{4.0 1.5}  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5
				$cv02  create   vectortext	{5.0 3.0}  -text "vectorText  5.0 3.0  -size 1"  -size 1		
	
	
		# --------------------------------------------
				# 	tab 3
			.f.nb add [frame .f.nb.f3] -text "Third tab"
			
			set f3_canvas  [labelframe .f.nb.f3.f_canvas   -text "board"  ]
			set f3_config  [frame      .f.nb.f3.f_config   ]

			pack  $f3_canvas  $f3_config    -side left -expand yes -fill both
			pack  configure   $f3_config    -fill y

			button $f3_config.bt_open -text "open File" -command openFile_svg
			pack $f3_config.bt_open 
			button $f3_config.bt_fit -text "refit" -command {$cv03 refitStage}				
			pack $f3_config.bt_fit 
			button $f3_config.bt_small -text "small" -command {$cv03 scaleToCenter 0.5}
			pack $f3_config.bt_small 
			
			
			.f.nb select .f.nb.f3
			set cv03 [canvasCAD::newCanvas cv03  $f3_canvas.cv03 	"MyCanvas_03"  880  610 	A3 0.5 40 -bd 2  -bg white  -relief sunken ]
			# set cv03 [canvasCAD::newCanvas cv03  $f3_canvas.cv03  880  610 500  450 m 0.5 -bd 2  -bg white  -relief sunken ]
				
				$cv03  create   rectangle  	{4.5 3.1 6.2 5.0 } 	-tags {Line_01}  -fill violet   -width 2 
				$cv03  create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

				$cv03  create   text		{3.4 2.2}  -text "text  3.4 2.2"
				$cv03  create   vectortext	{4.0 1.5}  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5
				$cv03  create   vectortext	{5.0 3.0}  -text "vectorText  5.0 3.0  -size 1"  -size 1		
                
                
                $cv03  readSVG "$APPL_ROOT_Dir/../etc/components/crankset/shimano_FC-M770.svg"                {550 450} 0 {crankset}
                #$cv03  readSVG "shimano_crankset_XT_FC-M770_try.svg"   {250 350} 0 {crankset}
	
	
		# --------------------------------------------
				# 	tab 4
			.f.nb add [frame .f.nb.f4] -text "Fourth tab"
			
			            set f4_canvas  [labelframe .f.nb.f4.f_canvas   -text "board"  ]
			set f4_config  [frame      .f.nb.f4.f_config   ]

			pack  $f4_canvas  $f4_config    -side left -expand yes -fill both
			pack  configure   $f4_config    -fill y

			button $f4_config.bt_open -text "open File" -command openFile_svg
			pack $f4_config.bt_open 
			button $f4_config.bt_fit -text "refit" -command {$cv04 refitStage}				
			pack $f4_config.bt_fit 
			button $f4_config.bt_small -text "small" -command {$cv04 scaleToCenter 0.5}
			pack $f4_config.bt_small 
			
			
			.f.nb select .f.nb.f4
			set cv04 [canvasCAD::newCanvas cv04  $f4_canvas.cv04 	"MyCanvas_04"  880  610 	A3 0.5 40 -bd 2  -bg white  -relief sunken ]
			# set cv03 [canvasCAD::newCanvas cv03  $f3_canvas.cv03  880  610 500  450 m 0.5 -bd 2  -bg white  -relief sunken ]
            
            set string "abc°^Ø±"
            puts "  -> string: $string"
            foreach ch [split $string ""] {
				scan $ch %c asc
				set evalChar [format "%c" $asc]
                puts "    --> $ch -> $asc -> [format "%c" $asc]"
				#debug "compile $canv $fid,$asc"
				#compile $canv "$fid,$asc"
			}
            
            #exit
            
            set characterList [canvasCAD::characterList]
            foreach charID $characterList {
                puts [format "   -> %3s %c" $charID $charID]
            }
            $cv04  create   vectortext	{50.0 30.0}  -text "vectorText  50.0 30.0  -size 10"  -size 10
            $cv04  create   vectortext	{50.0 60.0}  -text "vectorText  Sonderzeichen abc°^Ø±"  -size 10
	
	
		# --------------------------------------------
				# 	final
			#.f.nb select .f.nb.f1
			ttk::notebook::enableTraversal .f.nb
			
	#-------------------------------------------------------------------------
		#  open File Type: xml
		#
	proc openFile_svg {{file {}}} {
		
		global cv03
		
		if {$file == {} } {
			set file [tk_getOpenFile]
		}
		
		$cv03 readSVG $file {120 200} 0 AB
		$cv03 readSVG $file {320 400} 
		
	}
			
			
			
			

