
 ##+##########################################################################
 #
 # package: canvasCAD 	->	canvasCAD_tdom.tcl
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
 #	namespace:  canvasCAD
 # ---------------------------------------------------------------------------
 #
 #


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