 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_control.tcl
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
 #	namespace:  rattleCAD::control
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval control {
 
	variable   install_dir        $::APPL_Env(BASE_Dir)
	variable   USER_Dir           [file join $install_dir user]

   
	#-------------------------------------------------------------------------
		#  manage user-settings:  language, font, ...
		#
	proc user_settings {{mode read} } {
  
		variable  USER_Dir
      
		Debug  p
      
		global APPL_Env APPL_Config
      
        # tk_messageBox -message " $APPL_Env(USER_Dir)" 
      
		set APPL_Env(USER_Init) [file join $USER_Dir _user.init]
      
        # tk_messageBox -message " user_init:  File:  $APPL_Env(USER_Init)" 
      
		switch $mode {
          
            read    { 	if {[file readable $APPL_Env(USER_Init)]} {
                             catch {source $APPL_Env(USER_Init)} err
                               # tk_messageBox -message " source $APPL_Env(USER_Init)\n $::APPL_Config(Language)\n $APPL_Config(GUI_Font)" 
                             set control::FILE_List $APPL_Config(FILE_List)
						} else {
                             # tk_messageBox -message " no $APPL_Env(USER_Init)" 
						}
						return
					}
          
			write   { 	if { [catch { set fd [open $APPL_Env(USER_Init) w ] } err ]} {
							set antwort [tk_messageBox -type retrycancel \
		                              -icon     error \
		                              -title   "ERROR: USER Settings" \
		                              -message "An ERROR occured during create operation:\n$err"]
							if {[string match "cancel" $antwort]} {
								return
							}
						} else {
							# tk_messageBox -message  " passt eh:  $APPL_Env(USER_Init)!"
						}
		  
						puts  $fd "set APPL_Config(Language)        \{[string trim $::Language(____current) {_}]\}"
						puts  $fd "set APPL_Config(GUI_Font)        \{$::APPL_Config(GUI_Font)\}"
						puts  $fd "set APPL_Config(Window_Position) \{[get_w_geometry .]\}"
						puts  $fd "set APPL_Config(FILE_List)       \{$control::FILE_List\}"
        	    
						close $fd
						return 
					}
          
			reset   { catch {file delete $APPL_Env(USER_Init)}
					}
          
          default {}
      
      }
      
	}
	
	

 	#-------------------------------------------------------------------------
		#  update parameter
	proc update_geometry_reference {domConfig xpath value} {
					variable Stem
					variable RearWheel
					variable FrontWheel
					variable BottomBracket
					variable HandleBar
					variable SeatTube
					variable Fork

			foreach	{xpath value} [list 	/root/Personal/HandleBar_Distance 	$HandleBar(Distance) \
											/root/Custom/WheelPosition/Front	$FrontWheel(DistanceBB) \
											/root/Personal/HandleBar_Height		$HandleBar(HeightBB) \
											/root/Personal/SeatTube_Angle 		$SeatTube(Angle) \
											/root/Custom/WheelPosition/Rear		$RearWheel(DistanceBB) \
											/root/Custom/BottomBracket/Depth	$BottomBracket(depth) \
											/root/Component/Fork/Rake			$Fork(Rake) \
											/root/Component/Stem/Angle			$Stem(Angle) \
											/root/Component/Stem/Length			$Stem(Length) ] \
					{
							# puts "  $xpath $value"
							set node [$domConfig selectNodes $xpath/text()]
							$node nodeValue [format "%.2f" $value]
					}
			
			
			set ::APPL_Update			[ clock milliseconds ]
			frame_geometry_custom::set_base_Parameters $domConfig
	}

	
	
	
   
   }

