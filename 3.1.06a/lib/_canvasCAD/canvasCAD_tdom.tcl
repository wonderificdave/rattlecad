# ============================================
#
#	canvasCAD_dictionary
#
# ============================================

	proc canvasCAD::getNodeRoot {pathString} {
			variable __packageRoot
			return [$__packageRoot selectNodes $pathString ]			
	}

	proc canvasCAD::setNodeAttributeRoot {pathString attribute value} {
			variable __packageRoot
			set node [$__packageRoot selectNodes $pathString ]
			return [$node setAttribute $attribute $value]
	}

	proc canvasCAD::getNodeAttributeRoot {pathString attribute} {
			variable __packageRoot
			set node [$__packageRoot selectNodes $pathString ]
			return [$node getAttribute $attribute]
	}

	proc canvasCAD::getNode {node pathString} {
			return [$node selectNodes $pathString ]			
	}

	proc canvasCAD::setNodeAttribute {node pathString attribute value} {
				# puts [$node asXML]
				# puts "pathString:  $pathString   attribute:  $attribute   value: $value"
			set node [$node selectNodes $pathString ]
				#puts [$node asXML]
			return	[$node setAttribute $attribute $value]
	}

	proc canvasCAD::getNodeAttribute {node pathString attribute} {
			set node [$node selectNodes $pathString ]
			return [$node getAttribute $attribute]
	}

	
	#-------------------------------------------------------------------------
		#  report XML
	proc canvasCAD::reportXML {parent {counter {?}}} {
		puts "\n ---- $counter ------"
		set XML [$parent asXML]
		puts $XML
		puts " ---- $counter ------\n"
	} 	
	#-------------------------------------------------------------------------
		#  report XML
	proc canvasCAD::reportXMLRoot {} {
		variable __packageRoot		
		puts "\n ---- __packageRoot ------"
		set XML [$__packageRoot asXML]
		puts $XML
		puts " ---- __packageRoot ------\n"
	} 