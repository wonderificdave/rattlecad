package require Tk
 
	namespace eval canvasCAD {

		# --------------------------------------------
				# Export as global command
		namespace  export newCanvas 
		
		variable content {}
		
		proc newCanvas {w args} {		 
				variable content
				
				# create the "base" thing:
				eval canvas $w $args
				# hide the original widget command, but keep it:
				interp hide {} $w
				# Install the alias:
				interp alias {} $w {} canvasCAD::canvasCAD_ObjectMethods $w
				
				# fill content variable
				set content [lappend $content $w]
				# like the original "text" command:
				return $w
				# something new
		}
		
	
		 proc canvasCAD_ObjectMethods {self cmd args} {
				variable content
				
				puts "canvasCAD_ObjectMethods $self $cmd $args"
				puts "   $content"
				switch -- $cmd {
						super   {puts "super! $args" }
						report  {puts "report:  $content" }
						default {return [uplevel 1 [list interp invokehidden {} $self $cmd] $args]}
				}
		 }		
		
	}
	# --------------------------------------------
		# import canvasCAD to namespace ::
	namespace import canvasCAD::newCanvas	


 canvasCAD::newCanvas .c1 -width 220 -height 150 -bg white
 pack .c1 -fill both -expand 1
 #.c insert end "This is a.. (see stdout)"
 .c1 create rectangle 30 40 90 60
 
 canvasCAD::newCanvas .c2 -width 220 -height 150 -bg gray
 pack .c2 -fill both -expand 1
 #.c insert end "This is a.. (see stdout)"
 .c2 create rectangle 50 60 120 90
 
 puts "\n ----- report:  "
 .c1 report
 .c2 report
 
 
 
 
 