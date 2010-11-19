 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_cv_custom.tcl
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
 #	namespace:  rattleCAD::cv_custom::update
 # ---------------------------------------------------------------------------
 #
 # 



	proc cv_custom::update {cv_Name} {
		
		puts "     ... cv_custom:.update  $cv_Name"
		variable 	bottomCanvasBorder
	
			# --- get updateCommand
		set updateCommand		[namespace current]::update 

			# puts " ->  $cv_Name"
			
		switch $cv_Name {
			lib_gui::cv_Custom00 {
						#
						# -- base geometry
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent					
						#
					frame_visualisation::createBaseline 		$cv_Name $xy	
						#
					createDimension								$cv_Name $xy	point_seat	
					createDimension								$cv_Name $xy	point_frame					
					createDimension								$cv_Name $xy	geometry_bg		
						#
					frame_visualisation::createFrame_Centerline	$cv_Name $xy 	{saddle seattube steerer chainstay fork}
						#
					createDimension								$cv_Name $xy	point_personal	
					createDimension								$cv_Name $xy	point_crank								
					createDimension								$cv_Name $xy	geometry_fg								
						#
				}
			lib_gui::cv_Custom01 {
						#
						# -- frame - tubing
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame ]					
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createDecoration		$cv_Name $xy	SeatPost			$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 	$updateCommand 					
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 	$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	Saddle				$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	HeadSet				$updateCommand	
					frame_visualisation::createDecoration		$cv_Name $xy 	BottleCage			$updateCommand						
					frame_visualisation::createDecoration		$cv_Name $xy 	Stem				
					frame_visualisation::createDecoration		$cv_Name $xy 	LegClearance_Rep	
						#
					createCenterline							$cv_Name $xy	Saddle
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy	frameTubing_bg	
						#
					createDimensionType							$cv_Name $xy 	RearWheel_Clearance 	
					createDimensionType							$cv_Name $xy 	LegClearance			
					createDimensionType							$cv_Name $xy 	HeadTube_Length 	$updateCommand	
					createDimensionType							$cv_Name $xy 	SeatTube_Extension	$updateCommand	
					createDimensionType							$cv_Name $xy 	SeatStay_Offset		$updateCommand	
					createDimensionType							$cv_Name $xy 	HeadTube_OffsetTT	$updateCommand	
					createDimensionType							$cv_Name $xy 	HeadTube_OffsetDT	$updateCommand	
					createDimensionType							$cv_Name $xy 	DownTube_Offset		$updateCommand	
					createDimensionType							$cv_Name $xy 	TopTube_Angle		$updateCommand						
					createDimensionType							$cv_Name $xy 	HeadSet_Bottom		$updateCommand
					createDimensionType							$cv_Name $xy 	ForkHeight			$updateCommand				
					createDimensionType							$cv_Name $xy 	Brake_Bridge		$updateCommand		
					createDimensionType							$cv_Name $xy 	Brake_Fork			$updateCommand		
					createDimensionType							$cv_Name $xy 	TopHeadTube_Angle	$updateCommand		
					createDimensionType							$cv_Name $xy 	BottleCage			$updateCommand		
					
				}
			lib_gui::cv_Custom02 {
						#
						# -- dimension summary
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent
						#
					createDimension							$cv_Name $xy 	point_seat
					createDimension							$cv_Name $xy 	point_center
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	RearWheel			
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontWheel			
					frame_visualisation::createDecoration	$cv_Name $xy 	SeatPost		
						#
					frame_visualisation::createFrame_Tubes	$cv_Name $xy					 
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	Saddle			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	Brake			$updateCommand		
					frame_visualisation::createDecoration	$cv_Name $xy 	HeadSet			
					frame_visualisation::createDecoration	$cv_Name $xy 	Stem			
					frame_visualisation::createDecoration	$cv_Name $xy 	HandleBar 		$updateCommand		
					frame_visualisation::createDecoration	$cv_Name $xy 	RearDerailleur	$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	BottleCage		$updateCommand		
					frame_visualisation::createDecoration	$cv_Name $xy 	CrankSet 		$updateCommand	
						#
					createDimension							$cv_Name $xy 	cline_angle
						#
					createDimension							$cv_Name $xy	summary_bg		
						#
					createDimension							$cv_Name $xy	summary_fg	
						#
					frame_visualisation::createBaseline 	$cv_Name $xy	black
						#
				}				
			lib_gui::cv_Custom03 {
						#
						# -- frame - drafting 
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
						#
					$cv_Name 		clean_StageContent	
						#
					createDraftingFrame							$cv_Name		$stageFormat	[expr 1/$stageScale]	$::APPL_Config(PROJECT_Name)  [frame_geometry_custom::project_attribute modified]
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 						
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	BottleCage				
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 		
					frame_visualisation::createDecoration		$cv_Name $xy 	LegClearance_Rep	
						#
					createCenterline							$cv_Name $xy
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy 	frameDrafting_bg
						#
					$cv_Name 		centerContent				{ 0  25}		{__Decoration__  __CenterLine__  __Dimension__  __Frame__  }
						#
					lib_gui::notebook_createButton				$cv_Name 		changeFormatScale
						#
				}
			lib_gui::cv_Custom04 {
						#
						# -- drafting - framejig
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
						#
					$cv_Name 		clean_StageContent	
						#
					createDraftingFrame							$cv_Name		$stageFormat	[expr 1/$stageScale]	$::APPL_Config(PROJECT_Name)  [frame_geometry_custom::project_attribute modified]
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearWheel_Rep		
					frame_visualisation::createDecoration		$cv_Name $xy 	FrontWheel_Rep		
						#
					frame_visualisation::createFrame_Tubes		$cv_Name $xy 						
						#
					frame_visualisation::createDecoration		$cv_Name $xy 	RearDerailleur_ctr 		
						#
					createCenterline							$cv_Name $xy
						#
					createDimension								$cv_Name $xy	cline_brake	
					createDimension								$cv_Name $xy	cline_framejig	
					createDimension								$cv_Name $xy 	frameJig_bg
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
					$cv_Name 		centerContent				{0  15}		{__Frame__  __Decoration__  __CenterLine__  __Dimension__}
						#
					lib_gui::notebook_createButton				$cv_Name 		changeFormatScale
						#
				}
			lib_gui::cv_Custom05 {
						#
						# -- tubemitter
						#
						# set stageScale	1
					set stageScale	[eval $cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						#
					$cv_Name 		clean_StageContent	
						#
					frame_visualisation::createTubemitter		$cv_Name { 80 190}	TopTube_Seat		
					frame_visualisation::createTubemitter		$cv_Name {200 190}	TopTube_Head	
					frame_visualisation::createTubemitter		$cv_Name { 80 105}	DownTube_Head	
					frame_visualisation::createTubemitter		$cv_Name {180 105}	SeatStay_01	
					frame_visualisation::createTubemitter		$cv_Name {250 105}	SeatStay_02	
					frame_visualisation::createTubemitter		$cv_Name {220  15}	Reference	
						# [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
						#
				}
			lib_gui::cv_Custom06 {
						#
						# -- assembly
						#
					set stageScale	[$cv_Name getNodeAttr Stage scale]
					set stageFormat	[$cv_Name getNodeAttr Stage format]
						# set factor 		[ get_FormatFactor $stageFormat ]
						#
					set xy			[ frame_geometry_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]					
					$cv_Name 		clean_StageContent				
					frame_visualisation::createBaseline 	$cv_Name $xy	
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	RearWheel			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	FrontWheel			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	SeatPost			
						#
					frame_visualisation::createFrame_Tubes	$cv_Name $xy 
					frame_visualisation::createDecoration	$cv_Name $xy 	BottleCage			$updateCommand						
						#
					frame_visualisation::createDecoration	$cv_Name $xy 	Saddle				$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	Brake				$updateCommand
					frame_visualisation::createDecoration	$cv_Name $xy 	HeadSet				
					frame_visualisation::createDecoration	$cv_Name $xy 	Stem				
					frame_visualisation::createDecoration	$cv_Name $xy 	HandleBar 			$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	RearDerailleur		$updateCommand	
					frame_visualisation::createDecoration	$cv_Name $xy 	CrankSet 			$updateCommand
						# 
				}
				
		}
		
		::update	; #for sure otherwise confuse location of canvasCad Stage

	}

	

