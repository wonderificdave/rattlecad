 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_cfg_report.tcl
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
 #	namespace:  rattleCAD::lib_cfg_report
 # ---------------------------------------------------------------------------
 #
 # 


 namespace eval lib_cfg_report {
                            
	variable	treeWidget  {}
	variable 	menueFrame	{}

	#-------------------------------------------------------------------------
       #  create report widget
       #
	proc createReport {w} {
		variable treeWidget
		variable menueFrame
		
		
		pack [ frame $w.f ] -fill both -expand yes
		set menueFrame	[ frame $w.f.f_bt	-relief groove -bd 1]
		set treeFrame 	[ frame $w.f.f_tree ]
		pack 	$menueFrame \
				$treeFrame\
			-fill both 	-side left
		pack configure $treeFrame	-expand yes

        button 	$menueFrame.open	-text {Open xml-File}					-width 30	-command { lib_file::openFile_xml {}	visualize}
        button 	$menueFrame.bt01	-text {rattleCAD_init.xml}				-width 30	-command { lib_cfg_report::fillTree_Variable $::APPL_Init 				}
        button 	$menueFrame.bt02	-text {Template Road}					-width 30	-command { lib_file::openFile_xml [file join $::APPL_Env(CONFIG_Dir) $::APPL_Env(TemplateRoad)] 	visualize}
        button 	$menueFrame.bt03	-text {Template OffRoad}				-width 30	-command { lib_file::openFile_xml [file join $::APPL_Env(CONFIG_Dir) $::APPL_Env(TemplateMTB) ] 	visualize}
        button 	$menueFrame.bt04	-text {current Project}					-width 30	-command { lib_cfg_report::fillTree_Variable $::APPL_Project			}
        button 	$menueFrame.bt05	-text {current Values}					-width 30	-command { lib_cfg_report::fillTree_Variable $frame_geometry_custom::domFrame	}
        button 	$menueFrame.bt06	-text {canvasCAD}					    -width 30	-command { lib_cfg_report::fillTree_Variable $canvasCAD::__packageRoot	}
        button 	$menueFrame.clear	-text {clear Tree} 						-width 30	-command { lib_cfg_report::cleanupTree }
		pack 	$menueFrame.open \
				$menueFrame.bt01 \
				$menueFrame.bt02 \
				$menueFrame.bt03 \
				$menueFrame.bt04 \
				$menueFrame.bt06 \
				$menueFrame.clear \
				-side top


		set treeWidget 	[ Tree	$treeFrame.tree -xscrollcommand "$treeFrame.tree_x set" \
													-yscrollcommand "$treeFrame.tree_y set" ]
		scrollbar 	$treeFrame.tree_x 	-ori hori 	-command "$treeFrame.tree xview"
		scrollbar 	$treeFrame.tree_y 	-ori vert 	-command "$treeFrame.tree yview" 
			grid 	$treeFrame.tree 	$treeFrame.tree_y  -sticky news
			grid 						$treeFrame.tree_x  -sticky news

			grid 	rowconfig    	$treeFrame 0 -weight 1
			grid 	columnconfig 	$treeFrame 0 -weight 1	
	}

	
	#-------------------------------------------------------------------------
       #  cleanup Tree
       #
	proc cleanupTree {} {
		variable treeWidget
		foreach child [$treeWidget nodes root] {
			# puts "  to delete [$child nodeName]"
			$treeWidget delete $child
		}
	}


	#-------------------------------------------------------------------------
       #  fill Tree - Variable
       #
	proc fillTree_Variable {var} {
			#
			# -- define global parameters
			#
		lib_cfg_report::fillTree "$var" root
	}

		
	#-------------------------------------------------------------------------
       #  fill Tree - File
       #
	proc fillTree {node parent} {
		variable treeWidget	
		cleanupTree						
		recurseInsert $treeWidget "$node" $parent
		$treeWidget toggle $node
	}	
	   
	   
	   
	#-------------------------------------------------------------------------
       #  fill Tree - help function
       #
	proc recurseInsert {w node parent} {
 		
		set domDepth [llength [split [$node toXPath] /]]
		
		set name [$node nodeName]
		if {$name=="#text" || $name=="cdata"} {
			set mode  value
			set text [$node nodeValue]
				# set fill black
		} else {
			set mode  node
			set text $name
			if [string equal \#comment $text] {
				set text "... Comment: [$node asText]"
				puts "[$node asText]"
			} else {
				set text <$text>
			}
			set attributes {}
			foreach att [$node attributes] {
				catch {append attributes " $att=\"[$node getAttribute $att]\""}
			}
			if {$attributes != {} } { set attributes "{$attributes}" }

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
		}
		case $mode {
			node	{ 	$w insert end $parent $node -text {} -fill $fill 
						if {$attributes != {}} {
							$w itemconfigure $node   -text "$text $attributes"
						} else {
							$w itemconfigure $node   -text "$text"
						}
					}
			value	{ 	set parentText 	[ $w itemcget  $parent  -text ]
						set tmpText 	[ split  $parentText > ]
						set attributes	[ lindex $tmpText 1 ]
							# puts "  [llength $tmpText]"
						if {$attributes != {}} {
							$w itemconfigure $parent   -text "[lindex $tmpText 0]>   \"$text\"   [ lindex $tmpText 1 ]"
						} else {
							$w itemconfigure $parent   -text "[lindex $tmpText 0]>   \"$text\""
						}
					}
		}
		
		foreach child [$node childNodes] {recurseInsert $w $child $node}
	}

}

