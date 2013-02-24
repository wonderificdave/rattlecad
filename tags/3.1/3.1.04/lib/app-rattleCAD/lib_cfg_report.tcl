# -----------------------------------------------------------------------------------
#
#: Functions : namespace      L I B _ C F G _ R E P O R T
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
        button 	$menueFrame.bt01	-text {config_init_values.xml}			-width 30	-command { lib_file::openFile_xml etc/config_initValues.xml 		visualize}
        button 	$menueFrame.bt02	-text {config_selection_values.xml}		-width 30	-command { lib_file::openFile_xml etc/config_selectionValues.xml 	visualize}
        button 	$menueFrame.bt03	-text {template_project_20100413.xml}	-width 30	-command { lib_file::openFile_xml etc/template_project_20100413.xml visualize}
        button 	$menueFrame.bt04	-text {current Project}					-width 30	-command { lib_cfg_report::fillTree_Variable $::APPL_Project}
        button 	$menueFrame.bt05	-text {current Values}					-width 30	-command { lib_cfg_report::fillTree_Variable $frame_geometry_custom::domFrame}
        button 	$menueFrame.bt06	-text {canvasCAD}					    -width 30	-command { lib_cfg_report::fillTree_Variable $canvasCAD::__packageRoot}
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

