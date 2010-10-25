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

    # -- AppUtil  ---------------
  namespace import AppUtil::SetConfig \
                   AppUtil::GetConfig \
                   AppUtil::DelConfig \
                   AppUtil::SetDebugLevel \
                   AppUtil::Debug 

                   
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

		Debug  p

		global APPL_Env
		
		::Debug  t "   \$APPL_Env(IMAGE_Dir)  $APPL_Env(IMAGE_Dir)"

		
		proc intro_content {w cv_border} {

			Debug  p
      
			global APPL_Env

			set start_image     [image create  photo  -file $::APPL_Env(IMAGE_Dir)/start_image.gif ]
			set  start_image_w  [image width   $start_image]
			set  start_image_h  [image height  $start_image]
      
			::Debug  t "   \$start_image  $start_image  $start_image_w  $start_image_h "

			canvas $w.cv	-width  $start_image_w \
							-height $start_image_h \
							-bd     $cv_border \
							-relief sunken \
							-bg     gray 
						 
			pack   $w.cv   -fill both  -expand yes
      
			$w.cv create image  [expr 0.5*$start_image_w] \
								[expr 0.5*$start_image_h] \
						     -image $start_image
			
			set x [expr 0.5*$start_image_w]
			set y [expr 0.5*$start_image_h]
      
			$w.cv create text  [expr $x+ 85]  [expr $y+155]  -font "Swiss 18"  -text "Version"			      -fill white
			$w.cv create text  [expr $x+155]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Env(RELEASE_Version)."  -fill white 
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

		
			# --- fill CANVAS - Array
			#
		set node	[ $root selectNodes /root/lib_gui/geometry/canvas ]
			set lib_gui::canvasGeometry(width) 	[ $node getAttribute {width} ]
			set lib_gui::canvasGeometry(height)	[ $node getAttribute {height} ]	

			
			# --- get TemplateFile
			#
		set node	[ $root selectNodes /root/Template/Road ]
			set ::APPL_Env(TemplateRoad) [$node asText]
		set node	[ $root selectNodes /root/Template/MTB ]
			set ::APPL_Env(TemplateMTB)  [$node asText]
		set node    [ $root selectNodes /root/Startup/TemplateFile ]
			set type  [$node asText]
		set node	[ $root selectNodes /root/Template/$type ]
			set ::APPL_Env(TemplateFile)  [$node asText]
			
			
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
		set node_Forks [ $root selectNodes /root/Options/Fork ]
		foreach childNode [ $node_Forks childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_ForkTypes [lappend ::APPL_ForkTypes  [$childNode nodeName]]
			}
		}

			
			# --- fill ListBox Values   APPL_BrakeTypes
			#
		set ::APPL_BrakeTypes {}
		set node_Forks [ $root selectNodes /root/Options/Brake ]
		foreach childNode [ $node_Forks childNodes ] {
			if {[$childNode nodeType] == {ELEMENT_NODE}} {
					# puts "  childNode ->   [$childNode nodeName]  "
				set ::APPL_BrakeTypes [lappend ::APPL_BrakeTypes  [$childNode nodeName]]
			}
		}

			
	}

	
	#-------------------------------------------------------------------------
       #  set Window Title
       #
	proc set_window_title { {filename {}} } {
      
      Debug  p
      
      global APPL_Config APPL_Env
      
      set  prj_name  [file tail $filename]

      set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision) - $prj_name"
      set  APPL_Config(PROJECT_Name)  "$filename"
      Debug  t  "   $filename " 1
      
      wm title . $APPL_Config(WINDOW_Title)
	}






 

