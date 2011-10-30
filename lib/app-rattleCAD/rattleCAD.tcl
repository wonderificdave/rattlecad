 ##+##########################################################################
 #
 # package: rattleCAD	
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
 #	namespace:  rattleCAD
 # ---------------------------------------------------------------------------
 #
 # 

 
  package provide rattleCAD  3.2

                   
    # -- default Parameters  ----
	# source  [file join $APPL_Env(CONFIG_Dir) init_parameters.tcl]   
  
    
    
  ###########################################################################
  #
  #         F  -  U  -  N  -  C  -  T  -  I  -  O  -  N  -  S 
  #
  ###########################################################################


	proc debug_out { msg {args 0} } {
		Debug t $msg $args
	}


	#-------------------------------------------------------------------------
       #  startup intro image
       #
	proc create_intro {w {type toplevel} {cv_border 0} } {

		global APPL_Env
		
		puts "\n"
		puts "  create_intro: \$APPL_Env(IMAGE_Dir)  $APPL_Env(IMAGE_Dir)"

		
		proc intro_content {w cv_border} {
      
			global APPL_Env

			set start_image     [image create  photo  -file $::APPL_Env(IMAGE_Dir)/start_image.gif ]
			set  start_image_w  [image width   $start_image]
			set  start_image_h  [image height  $start_image]
      
			puts "      create_intro: \$start_image:  $start_image  -> $start_image_w  $start_image_h \n"

			canvas $w.cv	-width  $start_image_w \
							-height $start_image_h \
							-bd     0 \
							-bg     gray 
						 
			pack   $w.cv   -fill both  -expand yes -padx $cv_border -pady $cv_border 
      
			$w.cv create image  [expr 0.5*$start_image_w] \
								[expr 0.5*$start_image_h] \
						     -image $start_image
			
			set x [expr 0.5*$start_image_w]
			set y [expr 0.5*$start_image_h]
      
			$w.cv create text  [expr $x+ 75]  [expr $y+155]  -font "Swiss 18"  -text "Version"			      -fill white
			$w.cv create text  [expr $x+145]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Env(RELEASE_Version)."  -fill white 
			$w.cv create text  [expr $x+195]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Env(RELEASE_Revision)"  -fill white 
      
				;# --- beautify --- but i dont know the reason, why to center manually
			$w.cv move   all   1 1			
			return $w.cv
		}


		if { $type != "toplevel" } {        
			return [intro_content $w $cv_border]
		}

		toplevel $w  -bd 0

		wm withdraw		   $w  
		wm overrideredirect $w 1
		
		switch $::tcl_platform(platform) {
			"windows" { wm attributes  $w -topmost 1 }
		}

		intro_content $w $cv_border
		
		BWidget::place $w 0 0 center
		wm deiconify $w
		
		bind $w  <ButtonPress> { destroy .intro }

		return
	}


	#-------------------------------------------------------------------------
       #  load settings from etc/config_initValues.xml
       #
	proc initValues {} {
		
		set root 	$::APPL_Init
		
			# --- fill ICON - Array
			#
		foreach child [ [$root selectNodes /root/lib_gui/images] childNodes] {			
				# puts [ $child asXML ]
			set name	[ $child getAttribute {name} ]
			set source	[ $child getAttribute {src} ]
				# puts "   $name  $source"
			set lib_gui::iconArray($name) [ image create photo -file $::APPL_Env(IMAGE_Dir)/$source ]
		}
			set ::cfg_panel [image create photo -file $::APPL_Env(IMAGE_Dir)/cfg_panel.gif]

		
			# --- fill CANVAS - Array
			#
		set node	[ $root selectNodes /root/lib_gui/geometry/canvas ]
			set lib_gui::canvasGeometry(width) 	[ $node getAttribute {width} ]
			set lib_gui::canvasGeometry(height)	[ $node getAttribute {height} ]	

			
			# --- get TemplateFile - Names
			#
		set node	[ $root selectNodes /root/Template/Road ]
			set ::APPL_Env(TemplateRoad_default)  [file join $::APPL_Env(CONFIG_Dir) [$node asText] ]
		set node	[ $root selectNodes /root/Template/MTB ]
			set ::APPL_Env(TemplateMTB_default)   [file join $::APPL_Env(CONFIG_Dir) [$node asText] ]
				
				
			# --- get Template - Type to load
			#
		set node    [ $root selectNodes /root/Startup/TemplateFile ]
			set ::APPL_Env(TemplateType) [$node asText]
			
			
			# --- get Template - File to load
			#
		set ::APPL_Env(TemplateInit) [lib_file::getTemplateFile	$::APPL_Env(TemplateType)]
			
			
		
			# --- fill ListBox Values   APPL_RimList
			#
		set ::APPL_RimList {}
		set node_Rims [ $root selectNodes /root/Options/Rim ]
		foreach childNode [ $node_Rims childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					set value_01 [$childNode getAttribute inch     {}]
					set value_02 [$childNode getAttribute metric   {}]
					set value_03 [$childNode getAttribute standard {}]
					if {$value_01 == {}} {
						set value {-----------------}
					} else {
						set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
					}
				set ::APPL_RimList [lappend ::APPL_RimList  $value]
			}
		}

		
			# --- fill ListBox Values   APPL_ForkTypes
			#
		set ::APPL_ForkTypes {}
		set node_ForkTypes [ $root selectNodes /root/Options/Fork ]
		foreach childNode [ $node_ForkTypes childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_ForkTypes [lappend ::APPL_ForkTypes  [$childNode nodeName]]
			}
		}

			
			# --- fill ListBox Values   APPL_BrakeTypes
			#
		set ::APPL_BrakeTypes {}
		set node_BrakeTypes [ $root selectNodes /root/Options/Brake ]
		foreach childNode [ $node_BrakeTypes childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_BrakeTypes [lappend ::APPL_BrakeTypes  [$childNode nodeName]]
			}
		}
		
			# --- fill ListBox Values   APPL_BottleCage
			#
		set ::APPL_BottleCage {}
		set node_BottleCage [ $root selectNodes /root/Options/BottleCage ]
		foreach childNode [ $node_BottleCage childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_BottleCage [lappend ::APPL_BottleCage  [$childNode nodeName]]
			}
		}
		
			# --- fill ListBox Values   APPL_Binary_OnOff
			#
		set ::APPL_Binary_OnOff {}
		set node_Binary_OnOff [ $root selectNodes /root/Options/Binary_OnOff ]
		foreach childNode [ $node_Binary_OnOff childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_Binary_OnOff [lappend ::APPL_Binary_OnOff  [$childNode nodeName]]
			}
		}
		
			# --- fill ListBox Values   APPL_CompLocation
			#
		array unset ::APPL_CompLocation 
		set node_Locations [ $root selectNodes /root/Options/ComponentLocation ]
		foreach childNode [ $node_Locations childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					set xpath [$childNode getAttribute xpath {}]
					set dir   [$childNode getAttribute dir   {}]
				# puts "  childNode ->   [$childNode nodeName]   $xpath  $dir "
				set ::APPL_CompLocation($xpath) $dir
			}
		}
		
	}

	
	#-------------------------------------------------------------------------
       #  set Window Title
       #
	proc set_window_title { {filename {}} } {
      
			# Debug  p     
		global APPL_Config APPL_Env
      
		set  prj_name  [file tail $filename]

		set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision) - $prj_name"
		set  APPL_Config(PROJECT_Name)  "$filename"
		
			# Debug  t  "   $filename " 1      
		wm title . $APPL_Config(WINDOW_Title)
	}

	
