# -----------------------------------------------------------------------------------
#
#: Functions : namespace      L I B _ T X T _ R E P O R T
#

 namespace eval lib_txt_report {
                            
	variable	textWidget	{}                  
	variable 	menueFrame	{}

	#-------------------------------------------------------------------------
       #  create report widget
       #
	proc createReport {w} {
		variable textWidget
		variable menueFrame
		
		pack [ frame $w.f ] -fill both -expand yes
		set menueFrame	[ frame $w.f.f_bt	-relief groove -bd 1]
		set textFrame 	[ frame $w.f.f_text ]
		pack 	$menueFrame \
				$textFrame\
			-fill both 	-side left
		pack configure $textFrame	-expand yes

        button 	$menueFrame.hello		-text {Hello}					-width 30	-command {}
		pack 	$menueFrame.hello \
				-side top


		set textWidget 	[ text	$textFrame.text -xscrollcommand "$textFrame.text_x set" \
													-yscrollcommand "$textFrame.text_y set" ]
		scrollbar 	$textFrame.text_x 	-ori hori 	-command "$textFrame.text xview"
		scrollbar 	$textFrame.text_y 	-ori vert 	-command "$textFrame.text yview" 
			grid 	$textFrame.text 	$textFrame.text_y  -sticky news
			grid 						$textFrame.text_x  -sticky news

			grid 	rowconfig    	$textFrame 0 -weight 1
			grid 	columnconfig 	$textFrame 0 -weight 1	
	}

	
	#-------------------------------------------------------------------------
       #  cleanup Tree
       #
	proc cleanupText {} {
		variable textWidget
	}


	#-------------------------------------------------------------------------
       #  fill Tree
       #
	proc fillText {node parent} {
		variable textWidget	
		cleanupText						
		#recurseInsert $xml_ReportTree "$node" $parent
		#$xml_ReportTree toggle $node
	}	
	   
}

