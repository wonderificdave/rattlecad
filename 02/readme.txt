
 
3.4.02.45  - 2015.04.26
-------------------------------------------------------------------------------
    feature:
        ... rattleCAD::view::svgEdit::create_svgEdit
    refactor:
        ... extract rattleCAD::view::create_FileEdit {}
            ... rattleCAD::view::create_ListEdit {}
        ... split procedure: init_rattleCAD {} into 
            ... init_rattleCAD {} and
            ... start_rattleCAD {}  
            ... to make it easier to create debug-routines     
        ... rattleCAD::model::file::get_componentAlternatives
            ... nornalize path
    debug:    
        ... bikeGeometry 1.47


3.4.02.44  - 2015.04.22
-------------------------------------------------------------------------------
    feature:
        ... additional dimension in ChainStay Details:
            ... angle between ChainStay and BottomBracket
            ... see proposal from Rob Tedge 
                http://sourceforge.net/p/rattlecad/discussion/1080423/thread/3b74cb9f/
            ... and "hermes"
                http://bikeboard.at/Board/showthread.php?191527-rattleCAD&p=2595552&viewfull=1#post2595552


3.4.02.43  - 2015.04.21
-------------------------------------------------------------------------------
    feature:
        ... add template:
            ... childbike_mx_dirt_24.xml
    debug:
        ... replace ChainStay-Length-Slider in ChainStay Details
        ... bikeGeometry 1.46
            ... fork visualisation


3.4.02.42  - 2015.04.20
-------------------------------------------------------------------------------
    refactor: 
        ... change of build procedure only, no internal change
            ... now using packages of ActiveState Teapot
                ... base-tk ... 8.6.3.1
                ... tdom ...... 0.8.3
                ... BWidget ... 1.9.8


3.4.02.41  - 2015.04.12
-------------------------------------------------------------------------------
    refactor: 
        ... appUtil 0.16
            ... rattleCAD::infoPanel::fill_appUtil
        ... canvasCAD 0.56
        ... remove use of snit
        ... remove use of pdf4tcl
        ... change build procedure
            ... zip contains plain rattleCAD
            ... kit contains plain rattleCAD as starkit
            ... starpacks contain kit and runtime from 
                ... http://sourceforge.net/projects/kbskit/files/kbs


3.4.02.40  - 2015.04.02
-------------------------------------------------------------------------------
    refactor: 
        ... require Tcl 8.6 now
        ... canvasCAD 0.55
            ... use snit to use pdf4tcl
            ... use pdf4tcl replacing ghostscript?
                ... http://sourceforge.net/projects/pdf4tcl/
                ... BSD License
        ... bikeGeometry 1.45
            ... update Interfaces for BaseGeometry
            ... add bikeGeometry::Geometry(Saddle_HB_x)
        ... add rattleCAD::view::setTooltip 
            ... to use ttk:button instead of BWidgets Button
        ... remove background of icons in iconbar


3.4.02.39  - 2015.04.02
-------------------------------------------------------------------------------
    refactor: pdf-print, tubeMiter
        ... canvasCAD 0.53
            ... canvasCAD::printPostScript
        ... bikeGeometry 1.44
            ... bikeGeometry::get_TubeMiterDICT 
        ... change from tclkit8513.exe
            ... to tclkit-8.6.3-win32-ix86.exe
        ... rename rattleCAD::rendering::createTubemiter
            ... to rattleCAD::tubeMiter::create
        

3.4.02.38  - 2015.03.24
-------------------------------------------------------------------------------
    debug:
        ... rear-fender edit
            ... rattleCAD::view::edit::group_FrontFender_Parameter_08
        ... remove   "wm attributes   $w -toolwindow" for MacOS and others
    refactor:
        ... add donate to the MenuBar


3.4.02.37  - 2015.03.15
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 1.43
            ... bikeGeometry::create_CrankArm 
        ... create_intro 
            ... destroy .intro if exist
        ... rattleCAD::test
            ... destroy .intro if exist


3.4.02.36  - 2015.03.10
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 1.42 
            ... bikeGeometry::create_CrankArm 


3.4.02.35  - 2015.02.24
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 1.41 
            ... bikeGeometry::create_CrankArm 


3.4.02.34  - 2015.02.21
-------------------------------------------------------------------------------
    feature:
        ... RearMocku: edit rear BrakeDisc by dimension
        ... bikeGeometry 1.40 
            ... Scalar(CrankSet/ChainRingOffset) 
            ... bikeGeometry::create_CrankArm 


3.4.02.33  - 2015.02.19
-------------------------------------------------------------------------------
    debug:
        ... display of text://ListValue(CrankSetChainRings) 


3.4.02.32  - 2015.02.14
-------------------------------------------------------------------------------
    refactor:
        ... check chainstay centerline before update
        ... bikeGeometry 1.38 
        ... vectormath   0.7 


3.4.02.31  - 2015.02.08
-------------------------------------------------------------------------------
    debug:
        ... bikeGeometry 1.37 
            ... bikeGeometry::create_Fork 


3.4.02.30  - 2015.02.08
-------------------------------------------------------------------------------
    debug:
        ... bikeGeometry 1.36 
            ... bikeGeometry::create_Fork 
            ... bikeGeometry::create_ChainStay_RearMockup 
        ... vectormath   0.6
            ... tangent_2_circles


3.4.02.29  - 2015.01.24
-------------------------------------------------------------------------------
    feature:
        ... button for rattleCAD_AddOn
            ... containing all fututre extensions based on rattleCAD
    refactor:
        ... bikeGeometry 1.35 cleanup 
        ... check ensemble rattleCAD_AddOn for custom extensions
            ... optional Button if rattleCAD_AddOn available
        ... remove 
            ... Menu -> Export -> Export openSCAD
            ... Menu -> Export -> Export ReynoldsFEA


3.4.02.28  - 2015.01.22
-------------------------------------------------------------------------------
    refactor:
        ... notebook_createButton
    feature
        ... Menu -> Export -> Export openSCAD 
            ... for extension bikeGeometry_3D


3.4.02.27  - 2015.01.17
-------------------------------------------------------------------------------
    refactor:
        ... notebook_createButton
            ... FrameConfigMode
            ... changeFormatScale
    
    
3.4.02.26  - 2015.01.17
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 1.33 cleanup 
        ... rattleCAD::cv_custom::update_BaseGeometry
        ... rattleCAD::control::frame_configMode
        ... rattleCAD::rendering::createFrame_Centerline
    debug
        ... frameConfigMode: LugAngles
        
        
3.4.02.25  - 2015.01.12
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 1.32 with different behaviour on 
            ... rattleCAD::control::frame_configMode
    debug:
        ... set SeatTube and DownTube Offset to 0 if using LugAngle Method


3.4.02.24  - 2015.01.09
-------------------------------------------------------------------------------
    refactor:
        ... cleanup rattleCAD::cv_custom::createDimension_Geometry_ ...
    
    
3.4.02.23  - 2015.01.09
-------------------------------------------------------------------------------
    feature:
        ... rename ::APPL_Config(FrameConfig) to 
            ... rattleCAD::view::gui::frame_configMethod
            ... Hybrid / Lugs / Classic / Stack & Reach (StackReach)
        ... selectable $rattleCAD::view::gui::show_backgroundDimension
            ... display of background / result / secondary dimensions
            

3.4.02.22  - 2015.01.05
-------------------------------------------------------------------------------
    feature
        ... bikeGeometry 1.31
            ... new method of frame determination in "Base Geometry" tab
            ... add ::APPL_Config(FrameConfig)      freeAngle / lugAngle
            ... Button in upper left corner
    refactor/debug
        ... rename all groupEdit Windows with index
        

3.4.02.21  - 2014.12.29
-------------------------------------------------------------------------------
    refactor/debug
        ... bikeGeometry 1.30
            ... BottomBracket Offset on DownTube and SeatTube


3.4.02.20  - 2014.12.29
-------------------------------------------------------------------------------
    refactor/debug
        ... bikeGeometry 1.29
        ... history previous/next
        ... BottleCage dimensions display in drawings 
            ... variable Array Rendering -> to local Array Config


3.4.02.19  - 2014.12.13
-------------------------------------------------------------------------------
    refactor
        ... cleanup files
        

3.4.02.18  - 2014.12.13
-------------------------------------------------------------------------------
    refactor/debug
        ... bikeGeometry 1.27
            ... set_to_project
        ... test procedure: rattleCAD::test:::runDemo 
            ... demo_01
            ... method_SeatandTopTube
            ... method_rattleCAD_HandleBarandSaddle
 

3.4.02.17  - 2014.12.08
-------------------------------------------------------------------------------
    refactor/debug
        ... bikeGeometry 1.22
        

3.4.02.16  - 2014.12.07
-------------------------------------------------------------------------------
    refactor
        ... bikeGeometry 1.21
        ... update lib_view_edit.tcl


3.4.02.15  - 2014.12.05
-------------------------------------------------------------------------------
    refactor
        ... bikeGeometry 1.20


3.4.02.14  - 2014.11.xx
-------------------------------------------------------------------------------
    refactor
        ... bikeGeometry 1.16
        ... proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_03 
           ... from FrameTubes(ChainStay/Profile/width_03) 
               to   FrameTubes(ChainStay/WidthBB) 
    debug        
        ... rattleCAD::view::edit::group_RearWheel_Parameter
            ... Component(Wheel/Rear/TyreHeight)


3.4.02.13  - 2014.11.29
-------------------------------------------------------------------------------
    refactor
        ... bikeGeometry 1.15
            ... set_ResultParameter{}


3.4.02.12  - 2014.11.25
-------------------------------------------------------------------------------
    refactor
        ... new: rattleCAD::control::get_lastValues
            ... modified:   rattleCAD::view::init_configValues		  
            ... modified:   rattleCAD::configPanel::init_configValues
    debug
        ... single_Result_SaddleNose_HB 
                ... (single_Result_Saddle_Nose_HB)
        ... single_Result_HeadTubeTopTubeAngle
                ... single_Result_HeadTube_TopTubeAngle
                

3.4.02.11  - 2014.11.23
-------------------------------------------------------------------------------
    refactor   
        ... bikeGeometry 1.13
            ... clanup/remove all references to namespaces
                ::bikeGeometry ->  get_Value, get_Option, ...
                ::project::
            ... temporary use of ::bikeGeometry::get_Value_expired 
                instead of rattleCAD::model::get_Value


3.4.02.10  - 2014.11.23
-------------------------------------------------------------------------------
    refactor   
        ... rattleCAD::test::testResultParameter


3.4.02.09  - 2014.11.22
-------------------------------------------------------------------------------
    refactor   
        ... handle Fork SteelCustom (previous SteelLugged)


3.4.02.08  - 2014.11.21
-------------------------------------------------------------------------------
    refactor   
        ... remove all references to now obsolete rattleCAD::model::getValue
        ... add rattleCAD::view::init_configValues  


3.4.02.07  - 2014.11.18
-------------------------------------------------------------------------------
    refactor     
        ... split rattleCAD::model::get_Value, new get_Option, get_Scalar
        ... split rattleCAD::model::get_Value
        ... split rattleCAD::model::get_Value, new get_BoundingBox
        ... move  rattleCAD::view::edit  
            ... to  rattleCAD::view::gui::dimension_CursorBinding
        ... split rattleCAD::rendering:: createDecoration


3.4.02.06  - 2014.11.08
-------------------------------------------------------------------------------
    refactor     
        ... cleanup bikeGeometry::get_Value
            ... new bikeGeometry::get_Scalar (atomic values)              
            ... new bikeGeometry::get_Option (prev. Redering)              


3.4.02.05  - 2014.11.07
-------------------------------------------------------------------------------
    refactor     
        ... move rattleCAD::model::setValue to rattleCAD::control
        ... split rattleCAD::model::getValue into 
                ... rattleCAD::model::get_Position
                ... rattleCAD::model::get_Polygom
                ... rattleCAD::model::get_Direction
                ... rattleCAD::model::get_Component 
            as imported procedcures from bikeGeometry


3.4.02.04  - 2014.11.04
-------------------------------------------------------------------------------
    refactor 
        ... get listBox Values from bikeGeometry
            ... clean ./etc/rattleCAD_init.xml


3.4.02.03  - 2014.11.04
-------------------------------------------------------------------------------
    refactor 
        ... move all components from rattleCAD to bikeGeometry


3.4.02.02  - 2014.11.04
-------------------------------------------------------------------------------
    refactor
        ... now in 3.4.02 ...

    
3.4.01.75  - 2014.11.03
-------------------------------------------------------------------------------
    refactoring
        ... styleguide
            ...change procedures of rattleCAD::view to full qualified names


3.4.01.74  - 2014.10.31
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 0.73 (1.03)
        ... remove references from bikeGeometry to $project::...


3.4.01.73  - 2014.10.27
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 0.72 (1.02)
            ... cleanup comments from refactoring in 0.71


3.4.01.72  - 2014.10.27
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry 0.71 (1.01)
        ... remove references from bikeGeometry to $project::...

        
3.4.01.71  - 2014.10.25
-------------------------------------------------------------------------------
    refactor:
        ... move rattleCAD::control::setValue to rattleCAD::model
        ... cleanup rattleCAD-namespace from references to bikeGeometry
        ... bikeGeometry 0.70 add procedure bikeGeometry::get_from_project
    debug:
        ... bikeGeometry::tube_miter ... correct influence of intersect. tube
        
        
3.4.01.70  - 2014.10.21
-------------------------------------------------------------------------------
    refactor: 
        ... rattleCAD::cv_custom::updateView
            ... split into subprocedures


3.4.01.69  - 2014.10.20
-------------------------------------------------------------------------------
    refactor: 
        ... bikeGeometry 0.69


3.4.01.68  - 2014.10.19
-------------------------------------------------------------------------------
    debug: 
        ... debug and reorganize creation of SeatTube and SeatPost
            ... error occurred on SeatTube Offset at BottomBracket


3.4.01.67  - 2014.10.10
-------------------------------------------------------------------------------
    debug: 
        ... updated script to check OS Environment to run rattleCAD
            ... rattleCAD_checkEnv.tcl (tested for Linux and Windows)


3.4.01.66  - 2014.10.09
-------------------------------------------------------------------------------
    feature: 
        ... add script to check OS Environment to run rattleCAD
            ... rattleCAD_checkEnv.tcl (tested for Linux and Windows)


3.4.01.65  - 2014.07.27
-------------------------------------------------------------------------------
    feature: 
        ... RearDerailleur Mount:
            ... dimension in direction of Chainstay on horizontal now 
                depending on direction of dropout (horiozontal only)


3.4.01.64  - 2014.06.21
-------------------------------------------------------------------------------
    feature: 
        ... components:
            ... selle_san_marco_concor_racing_junior_2014.svg


3.4.01.63  - 2014.06.01
-------------------------------------------------------------------------------
    feature: 
        ... update Result/Tubes/ForkBlade/
            ... bikeGeometry (0.67    bikeGeometry::get_Fork & get_ForkBlade
        ... update template Project: Road


3.4.01.62  - 2014.05.25
-------------------------------------------------------------------------------
    debug: 
        ... investigations to create 3D Shape of a project


3.4.01.61  - 2014.05.20
-------------------------------------------------------------------------------
    debug: 
        ... rear fender pivot redefined after changes in 3.4.01.60
        ... add CenterLine - Value to each /Result/Tubes/...


3.4.01.60  - 2014.05.15
-------------------------------------------------------------------------------
    feature: 
        ... add Tube Diameter to Export Reynolds FEA
        ... add Tube Profiles (xy/xz) to Result/Tubes


3.4.01.59  - 2014.05.13
-------------------------------------------------------------------------------
    feature: 
        ... add Rear Carrier: racktime Add-it
        ... Export -> Export Reynolds FEA
            ... export project geometry into reynolds' FEA  csv-Format


3.4.01.58  - 2014.05.04
-------------------------------------------------------------------------------
    feature: 
        ... add Front Carrier: Tubus Tara


3.4.01.57  - 2014.05.04
-------------------------------------------------------------------------------
    feature: 
        ... add Rear & Front Carrier


3.4.01.56  - 2014.05.02
-------------------------------------------------------------------------------
    feature: 
        ... Rear & Front Fender
    refactor:
        ... cleanup rattleCAD-namespace from references to bikeGeometry
        ... change rendering of lower headset lower then 8 mm


3.4.01.55  - 2014.04.19
-------------------------------------------------------------------------------
    refactor:
        ... createFrameJig
    feature: 
        ... createFrameJig
            ... add FrameJIG: MeisterJig (http://www.meisterjig.com/)
                ... waiting for commitment 
        ... update: rattleCAD::view::gui::notebook_createButton
            ... update on select radiobutton in 
                ... ChainStay Details, Summary, FrameJig and FrameDrafting


3.4.01.54  - 2014.04.16
-------------------------------------------------------------------------------
    feature: 
        ... change cursor to watch when rattleCAD is busy


3.4.01.52  - 2014.04.15
-------------------------------------------------------------------------------
    refactor:
        ... in  $::APPL_Config(USER_Dir)
            ... rename  _rattleCAD_<[info hostname]>.init  
                ... to  .rattleCAD_<[info hostname]>.init
    feature: 
        ... create  .rattleCAD_<[info hostname]>.Xdefaults


3.4.01.51  - 2014.04.03
-------------------------------------------------------------------------------
    feature: 
        ... pivot HandleBar in Summary
        ... move Saddle in Summary


3.4.01.50  - 2014.03.31
-------------------------------------------------------------------------------
    feature: 
        ... add  20"/406 ETRTO - BMX to favorite rim dimensions
        ... add  Result(Length/RearWheel/TyreShoulder)
    debug:
        ... handle  Component/Wheel/Rear/TyreWidthRadius 
            ... if greater then WheelRadius
            ... in bikeGeometry::check_Values


3.4.01.49  - 2014.03.23
-------------------------------------------------------------------------------
    debug:
        ... failed on open project-File of rattleCAD 3.2.78.26  
            ... fixed in bike_Geometry (0.56)
                ... project::update_Project
        ... save template didn't save in project directory


3.4.01.48  - 2014.03.08
-------------------------------------------------------------------------------
    refactor:
        ... in  $::APPL_Config(USER_Dir)
            ... rename  _rattleCAD.init  
                 ... to _rattleCAD_<[info hostname]>.init


3.4.01.47  - 2014.03.06
-------------------------------------------------------------------------------
    debug:
        ... ChainStay went out of display if last segment had negativ length


3.4.01.46  - 2014.03.05
-------------------------------------------------------------------------------
    refactor:
        ... displayed ChainStay length in ChainStay Details depending 
            on BottomBracket Position 


3.4.01.45  - 2014.03.03
-------------------------------------------------------------------------------
    cleanup:
        ... remove road_bent_fork.xml from sample - directory
    refactor:
        ... replace .../test/sample/classic_1984_SuperRecord
            ... by .../test/sample/road_classic_1984_SuperRecord
            ... now with bent stays
        ... update .../sample/... .xml ... ChainStay purpose


3.4.01.44  - 2014.03.02
-------------------------------------------------------------------------------
    debug:
        ... stabilize bent Chainstay-Edit in Chainstay-Details tab
            ... keep constant distance beetween control-points


3.4.01.43  - 2014.03.02
-------------------------------------------------------------------------------
    debug:
        ... stabilize bent Chainstay-Edit in Chainstay-Details tab
    refactor:
        ... change "Exclusion" and "ChangeLog" in Info Panel    


3.4.01.42  - 2014.02.24
-------------------------------------------------------------------------------
    feature:
        ... paul components: singlespeed dropout
    refactor:
        ... road_Fixie.xml (SingleSpeed)
        

3.4.01.41  - 2014.02.24
-------------------------------------------------------------------------------
    feature:
        ... new sample: road_Fixie.xml (SingleSpeed)
    refactor:
        ... change colour mapping for summary and mockup
        ... change direction of Component/Derailleur/Rear/Pulley/y
            ... bikeGeometry 0.50
    debug:
        ... configCorner throws Error in Frame-Jig Tab
        ... derailleur pulley teeth throws error if < 2
 

3.4.01.40  - 2014.02.23
-------------------------------------------------------------------------------
    feature:
        ... Demo -> rattleCAD-Method 
        ... Demo -> Seat/TopTube-Method 
        ... remove:
            ... Demo -> Stack and Reach         
    refactor:
        ... move   rattleCAD::gui
            ... to   rattleCAD::view::gui 


3.4.01.39  - 2014.02.23
-------------------------------------------------------------------------------
    refactor:
        ... Demo:  File -> Stack and Reach   
        ... sample files
    refactor:
        ... remove APPL_CONFIG(PROJECT_Name, PROJECT_File, PROJECT_Save)
        ... move   rattleCAD::view::get_listBoxContent 
            ... to   rattleCAD::control::get_listBoxContent
                ...  rattleCAD::model::get_ListBoxValues
                ...  rattleCAD::model::get_ComponentList
        ... add    rattleCAD::modelinit_ListBoxValues   


3.4.01.38  - 2014.02.21
-------------------------------------------------------------------------------
    debug:
        ... rattleCAD::view::updateConfig
            ... focused entry field on mouse over left entry
    refactor:
        ... add Menue -> Demo
            ... move entries Menue -> File to Menue -> Demo:
                ... File -> Samples
                ... File -> Stack and Reach
                ... File -> Demo
                ... File -> Integration Test
                ... File -> Intro-Image   


3.4.01.37  - 2014.02.21
-------------------------------------------------------------------------------
    refactor:
        ... Demo: File -> Stack and Reach
        ... bikeGeometry 0.49


3.4.01.36  - 2014.02.20
-------------------------------------------------------------------------------
    refactor:
        ... Demo: File -> Stack and Reach


3.4.01.35  - 2014.02.19
-------------------------------------------------------------------------------
    feature:
        ... setValue: set more than one value at once
        ... Demo: File -> Stack and Reach


3.4.01.34  - 2014.02.16
-------------------------------------------------------------------------------
    feature:
        ... dropout: bendixen_00.svg
    refactor:
        ... dropout: rear_dropout_ss_wild_lilies_grow.svg

    
3.4.01.33  - 2014.02.15
-------------------------------------------------------------------------------
    refactor:
	    ... canvasCAD 0.51
		... update: gui::notebook_createButton
    debug:
        ... projectNames were lost in drafting frames
    feature:
        ... add configCorner
        ... coloured visualization
    

3.4.01.32  - 2014.02.11
-------------------------------------------------------------------------------
    refactor:
	    ... replace [bikeGeometry::project_attribute modified]
		    ... by  [rattleCAD::control::getSession dateModified]
    debug:
	    ... save saved project


3.4.01.31  - 2014.02.10
-------------------------------------------------------------------------------
    debug: 
        ... history of changeList updated on save File
		... Project/modified did not update in project File
    refactor:
        ... add Array:  rattleCAD::control::Session
            ... shall replace $::APPL_Config() in the future


3.4.01.30  - 2014.02.05
-------------------------------------------------------------------------------
    debug: 
        ... update: sram_red_22_2012.svg
    feature:
        ... dont recenter display after every edit of values
        ... use the recenter button top right


3.4.01.29  - 2014.02.04
-------------------------------------------------------------------------------
    debug: 
        ... scale of drawings did not update -> lib_gui::notebook_formatCanvas


3.4.01.28  - 2014.02.02
-------------------------------------------------------------------------------
    feature: 
        ... crankset: sram_red_22_2012.svg
        ... handlebar: sram_red_2014


3.4.01.27  - 2014.02.01
-------------------------------------------------------------------------------
    debug:
        ... canvasCAD: 
            ... make test-procedures run in productive Environment


3.4.01.26  - 2014.01.31
-------------------------------------------------------------------------------
    debug:
        ... ChainStay Details: 
            ... edit Tyre Representation gave a listbox for TyreWidthRadius


3.4.01.25  - 2014.01.20
-------------------------------------------------------------------------------
    debug:
        ... ChainStay Details gave Error: lib_cvRearMockup.tcl
    feature: 
        ... ChainStay Details, adopt visualization of dropout length for 
            paragon_DR2030
        ... dropout: paragon_DR2030


3.4.01.24  - 2014.01.17
-------------------------------------------------------------------------------
    debug:
        ... dropout offset-rotation did not work for horizontal orientation
    feature:
        ... droput: visualisation in Frame Details
            ... new dropouts: 
                ... paragon_DR0022, 
                ... paragon_DR0008


3.4.01.23  - 2014.01.15
-------------------------------------------------------------------------------
    debug:
        ... prevent refit canvas on update vale, refits on first change 
            of values


3.4.01.22  - 2014.01.14
-------------------------------------------------------------------------------
    debug:
        ... prevent refit canvas on update vale


3.4.01.21  - 2014.01.12
-------------------------------------------------------------------------------
    feature:
        ... copy samples to APPL_Config(USER_Dir)/_templates/rattleCAD
    debug:
        ... configPanel -> update from comboboxes on values containing 
            " " (spaces)


3.4.01.20  - 2014.01.12
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control
            ... rattleCAD:config -> rattleCAD::configPanel
                ... remove open_configPanel
            ... cleanup rattleCAD::control::
            ... prepare rattleCAD::view::


3.4.01.19  - 2014.01.10
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control
            ... refactor configPanel -> rattleCAD:config 
            ... bikeGeometry::getObject to to rattleCAD::model::getObject


3.4.01.18  - 2014.01.09
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control
            ... move references form project:: ... to rattleCAD::control:: ... 


3.4.01.17  - 2014.01.08
-------------------------------------------------------------------------------
    debug:
        ... prevent refit canvas on update vale
        

3.4.01.16  - 2014.01.08
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control 


3.4.01.15  - 2014.01.08
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control 


3.4.01.14  - 2014.01.07
-------------------------------------------------------------------------------
    refactor:
        ... care an model/view/control 


3.4.01.13  - 2014.01.06
-------------------------------------------------------------------------------
    feature:
        ... add 36" (787) to rim-list 
        ... from Jussi and http://www.bikecult.com/works/wheelsizes.html


3.4.01.12  - 2014.01.02
-------------------------------------------------------------------------------
    debug:
        ... project::import_ProjectSubset
            ... finaly run bikeGeometry::set_base_Parameters
            ... but currently still no failure handling 
                ... if import not completly OK
        ... templates
            ... remove FrameTubes/ChainStay/Width
 

3.4.01.11  - 2013.12.23
-------------------------------------------------------------------------------
    debug:
        ... allow comments in _rattleCAD.init
            ... see 3.4.01.05  - 2013.10.21


3.4.01.10  - 2013.10.30
-------------------------------------------------------------------------------
    feature:
        ... check modification on file open


3.4.01.09  - 2013.10.30
-------------------------------------------------------------------------------
    feature:
        ... undoStack: undo/redo status in bottom line


3.4.01.08  - 2013.10.29
-------------------------------------------------------------------------------
    feature:
        ... undo/redo
    refactor:
        ... button-bar


3.4.01.07  - 2013.10.24
-------------------------------------------------------------------------------
    refactor:
        ... rattleCAD::version_info


3.4.01.06  - 2013.10.22
-------------------------------------------------------------------------------
    debug:
        ... exit rattleCAD on Linux
    feature:
        ... osEnv::find_OS_Application finds executable via Which-command
            ... therefore extension of _rattleCAD.init not required 
            ... but can override OS settings


3.4.01.05  - 2013.10.21
-------------------------------------------------------------------------------
    refactor:
        ... ps-export from canvas
            ... pdf creation
    feature:
        ... provide pdf-creation under Linux
            ... having in _rattleCAD.init
            <root>    
                ...
                <mime>
                    <mime name=".pdf">/usr/bin/evince</mime>
                </mime>
                <exec>
                    <exec name="sh">/usr/bin/sh</exec>
                    <exec name="gs">/usr/bin/gs</exec>
                </exec>
            </root>


3.4.01.04  - 2013.10.21
-------------------------------------------------------------------------------
    debug:
        ... handle undefined mimetypes in windows registry
        ... handle undefined Application in open_by_mimeType_DefaultApp


3.4.01.03  - 2013.10.20
-------------------------------------------------------------------------------
    feature:
        ... ~/rattleCAD/_rattleCAD.init
            ... configure mime types and executables
            ... best to remove your current _rattleCAD.init and update values


3.4.01.00  - 2013.10.19
-------------------------------------------------------------------------------
    refactor:
        ... deliver
            ... Version/rattleCAD.tcl
            ... rattleCAD.kit ... OS independent Tclkit, run by ActiveState Tcl
            ... rattleCAD.exe ... standalone runtime for Windows


3.4.00.98  - 2013.10.16
-------------------------------------------------------------------------------
    feature:
        ... pack rattleCAD.exe and rattleCAD.kit into the zip-File
            ... rattleCAD.exe ... standalone runtime for Windows
            ... rattleCAD.kit ... OS independent Tclkit


3.4.00.97  - 2013.10.15
-------------------------------------------------------------------------------
    refactor:
        ... build windows-starkit and OS-independent tclkit at every release


3.4.00.96  - 2013.10.13
-------------------------------------------------------------------------------
    refactor:
        ... Copy Reference


3.4.00.94  - 2013.10.10
-------------------------------------------------------------------------------
    feature:
        ... edit tyre representation in ChainStay Details
    refactor:
        ... default SadleNose Length from 153 to 150
        ... updated templates


3.4.00.93  - 2013.10.10
-------------------------------------------------------------------------------
    refactor:
        ... rename "Copy Concept" to "Copy Reference"
        ... modify dimension behaviour


3.4.00.92  - 2013.10.09
-------------------------------------------------------------------------------
    feature:
        ... new components: saddle with different mounting points


3.4.00.91  - 2013.10.09
-------------------------------------------------------------------------------
    feature:
        ... make dimension BottomBracket / Saddle in config-Panel


3.4.00.90  - 2013.10.07
-------------------------------------------------------------------------------
    feature:
        ... add SeatPost-PivotOffset
    attention: 
        ... changes behaviour of SeatTube-Angle


3.4.00.89  - 2013.10.04
-------------------------------------------------------------------------------
    feature:
        ... make dimension BottomBracket / Saddle editable in Base Concept


3.4.00.88  - 2013.09.30
-------------------------------------------------------------------------------
    feature:
        ... extended tube mitering


3.4.00.87  - 2013.09.29
-------------------------------------------------------------------------------
    feature:
        ... additional parameter for SaddleNose and Saddle mounting position


3.4.00.86  - 2013.09.29
-------------------------------------------------------------------------------
    feature:
        ... modify saddle measurement
        ... additional dimension SaddleNose - HandleBar


3.4.00.85  - 2013.09.22
-------------------------------------------------------------------------------
    debug:
        ... canvasCAD - support arc in svg-Export


3.4.00.84  - 2013.09.22
-------------------------------------------------------------------------------
    refactor:
        ... rattleCAD::version_info - packages report


3.4.00.83  - 2013.09.21
-------------------------------------------------------------------------------
    feature:
        ... mockup: chain 
    refactor:
        ... rattleCAD::rendering - checkFileString
        ... rattleCAD::rendering - createFork
        ... modify templates


3.4.00.82  - 2013.09.14
-------------------------------------------------------------------------------
    feature:
        ... crankset: sugino_XD.svg 


3.4.00.81  - 2013.09.11
-------------------------------------------------------------------------------
    feature:
        ... rear derailleur: sram_red_2012.svg ... update
        ... composite fork:  fork_crown_tusk.svg ... update

        
3.4.00.80  - 2013.09.08
-------------------------------------------------------------------------------
    debug:
        ... File -> SVG-Component: handling polyline in proc add_SVGNode
    feature:
        ... rear derailleur: sram_red_2012.svg


3.4.00.79  - 2013.09.08
-------------------------------------------------------------------------------
    debug:
        ... File -> SVG-ChainWheel: package require vectorMath


3.4.00.78  - 2013.09.02
-------------------------------------------------------------------------------
    refactor:
        ... add previous composite fork rendering: Composite/Composite_TUSK


3.4.00.77  - 2013.09.01
-------------------------------------------------------------------------------
    refactor:
        ... modified rendering of composite fork


3.4.00.76  - 2013.08.31
-------------------------------------------------------------------------------
    feature:
        ... add SELBERBRUZZLER-Logo to logo-Library


3.4.00.75  - 2013.08.29
-------------------------------------------------------------------------------
    feature:
        ... ChainStay-Details: extend visualisation with tyre and RearHub


3.4.00.74  - 2013.08.27
-------------------------------------------------------------------------------
    refactor:
        ... ChainStay-Details: position CrankArm on top


3.4.00.73  - 2013.08.27
-------------------------------------------------------------------------------
    feature:
        ... modify saddle parameterisation 


3.4.00.72  - 2013.08.26
-------------------------------------------------------------------------------
    feature:
        ... modify parameterisation of tyre-Geometry in ChainStay-Details


3.4.00.71  - 2013.08.26
-------------------------------------------------------------------------------
    refactor:
        ... move rattleCAD-libraries into rattleCAD-namespace parenthood


3.4.00.70  - 2013.08.26
-------------------------------------------------------------------------------
    refactor:
        ... switch CopyConcept-Tab by ctrl-k


3.4.00.69  - 2013.08.25
-------------------------------------------------------------------------------
    feature:
        ... editable TyreWidth in ChainStay Details


3.4.00.68  - 2013.08.17
-------------------------------------------------------------------------------
    debug:
        ... define: Component/Logo/File for components/logo" 
            in rattleCAD_init.xml to allow custom logos


3.4.00.67  - 2013.08.17
-------------------------------------------------------------------------------
    feature:
        ... additional dimensions to Copy Concept - Tab


3.4.00.66  - 2013.08.16
-------------------------------------------------------------------------------
    debug:
        ... rattleCAD did not update tabs, if a new project was loaded


3.4.00.65  - 2013.08.15
-------------------------------------------------------------------------------
    feature:
        ... reorder RimTable:
            add 584 mm as 27,5" MTB to a more prominent position


3.4.00.64  - 2013.08.11
-------------------------------------------------------------------------------
    feature:
        ... transfer geometry of an existing bike into rattleCAD
            File -> Copy Concept


3.4.00.63  - 2013.08.10
-------------------------------------------------------------------------------
    feature:
        ... allow hide/unhide tabs  lib_gui::notebook_switchTab 


3.4.00.62  - 2013.08.09
-------------------------------------------------------------------------------
    debug/feature:
        ... modify button display in canvas tabs 


3.4.00.61  - 2013.08.09
-------------------------------------------------------------------------------
    feature:
        ... supplementary angles in parameter table in frame jig drawings 
            lib_cvFrameJig.tcl

3.4.00.60  - 2013.08.05
-------------------------------------------------------------------------------
    debug/feature:
        ... personal components library and an example


3.4.00.59  - 2013.08.04
-------------------------------------------------------------------------------
    debug/feature:
        ... set APPL(GUI_Font) from "Arial 8" to "Helvetica 8" for "windows"
            and "Helvetica 10" for "macintosh"


3.4.00.58  - 2013.07.30
-------------------------------------------------------------------------------
    refactor:
        ... extract vectormath - Library out of bikeGeometry and canvasCAD


3.4.00.57  - 2013.07.29
-------------------------------------------------------------------------------
    debug:
        ... handle angle 0.00 in curved ChainStays 


3.4.00.56  - 2013.07.26
-------------------------------------------------------------------------------
    feature:
        ... additional Binding in BaseConcept to an Edit Window 
                for Stem, Fork and BottomBracket. After setting values to 0.00 
                the editable dimensions disappears    


3.4.00.55  - 2013.07.26
-------------------------------------------------------------------------------
    feature:
        ... redefinition of controlAreas for curved ChainStay     


3.4.00.54  - 2013.07.24
-------------------------------------------------------------------------------
    feature:
        ... additional editable values on editArea for curved ChainStay 
        ... additional dropout paragon_DR2010_58.svg        


3.4.00.53  - 2013.07.24
-------------------------------------------------------------------------------
    feature:
        ... change shape of editArea for curved ChainStay  


3.4.00.52  - 2013.07.23
-------------------------------------------------------------------------------
    debug/feature:
        ... add additional control to edit values of single bends
                curved ChainStay  


3.4.00.51  - 2013.07.23
-------------------------------------------------------------------------------
    feature:
        ... accelerate update of RearMockup on edit of curved ChainStay


3.4.00.50  - 2013.07.19
-------------------------------------------------------------------------------
    feature:
        ... add additional extended edit of curved ChainStay (drag circles)   


3.4.00.49  - 2013.06.17
-------------------------------------------------------------------------------
    feature:
        ... add additional Bent of ChainStay in RearMockup   


3.4.00.48  - 2013.05.23
-------------------------------------------------------------------------------
    debug:
        ... improve   .../_style/simplify_SVG.tcl


3.4.00.47  - 2013.05.20
-------------------------------------------------------------------------------
    debug:
        ... improve   .../_style/simplify_SVG.tcl


3.4.00.46  - 2013.05.18
-------------------------------------------------------------------------------
    debug:
        ... catch error if not in tclTk runtime  
               File -> SVG-Component  .../_style/simplify_SVG.tcl
               File -> SVG-ChainWheel .../_style/chainWheel_SVG.tcl


3.4.00.45  - 2013.05.18
-------------------------------------------------------------------------------
    feature:
        ... execute from: (on tclTk runtime only) 
               File -> SVG-Component  .../_style/simplify_SVG.tcl
               File -> SVG-ChainWheel .../_style/chainWheel_SVG.tcl


3.4.00.44  - 2013.05.18
-------------------------------------------------------------------------------
    feature:
        ... improve   .../_style/simplify_SVG.tcl


3.4.00.43  - 2013.05.12
-------------------------------------------------------------------------------
    feature:
        ... make frame label editable (handled as logo) 


3.4.00.42  - 2013.05.11
-------------------------------------------------------------------------------
    feature:
        ... modified navigation in ... Components tab


3.4.00.41  - 2013.05.10
-------------------------------------------------------------------------------
    feature:
        ... add Shimano DURA-ACE Components to rattleCAD
    debug:
        ... removed an exception for handlebar and saddle visualization 
               in lib_cvCustom.tcl -> update_renderCanvas


3.4.00.40  - 2013.05.05
-------------------------------------------------------------------------------
    feature:
        ... allow fork dropouts appear above or below fork blade 
               especially for: GP Wilson dropouts


3.4.00.39  - 2013.05.03
-------------------------------------------------------------------------------
    feature:
        ... add GP Wilson dropouts, 
               http://wyganowskiframes.com/?attachment_id=189 


3.4.00.38  - 2013.04.27
-------------------------------------------------------------------------------
    feature:
        ... add SuperRecord 84 Components to rattleCAD


3.4.00.37  - 2013.04.25
-------------------------------------------------------------------------------
    feature/debug:
        ... both scripts are necessary to build svg-components for rattleCAD
        ... create script: .../_style/chainWheel_SVG.tcl
        ... make it run:   .../_style/simplify_SVG.tcl


3.4.00.36  - 2013.04.16
-------------------------------------------------------------------------------
    refactor:
        ... rename package frame_visualisation to bikeRendering


3.4.00.35  - 2013.04.18
-------------------------------------------------------------------------------
    feature:
        ... parameter of Lugs(SeatTube/SeatStay/MiterDiameter) now also
               available on SeatTube and SeatStay. This parameter was currently
               available only at [check Frame Angles] in the arc between
               SeatStay and SeatTube


3.4.00.34  - 2013.04.16
-------------------------------------------------------------------------------
    feature:
        ... remove trailing 000 on dimensions
               requires canvasCAD 0.39


3.4.00.33  - 2013.04.15
-------------------------------------------------------------------------------
    feature:
        ... modify dimension precision in drafting tab to format %.2f
               requires canvasCAD 0.38
        

3.4.00.32  - 2013.03.26
-------------------------------------------------------------------------------
    debug:
        ... bikeGeometry 0.18: Fork Setting fails on 3.3.06.20 
               http://sourceforge.net/p/rattlecad/tickets/2/


3.4.00.31  - 2013.03.11
-------------------------------------------------------------------------------
    debug:
        ... runTime report in info Tab:  separate name and value in display
        

3.4.00.30  - 2013.03.10
-------------------------------------------------------------------------------
    feature:
        ... add runTime report to info Tab:  "rattleCAD - runTime"
        

3.4.00.28  - 2013.03.01
-------------------------------------------------------------------------------
    debug:
        ... template Button in buttonBar did not update Canvas
        

3.4.00.27  - 2013.03.01
-------------------------------------------------------------------------------
    debug:
        ... handling of resultNode in bikeGeometry as a default structure
        

3.4.00.26  - 2013.02.28
-------------------------------------------------------------------------------
    refactor:
        ... lib_config.tcl: Config Window
        

3.4.00.25  - 2013.02.28
-------------------------------------------------------------------------------
    refactor:
        ... call bikeGeometry::setValue instead of 
              bikeGeometry::set_projectValue 
        ... rattleCAD_Test::controlDemo: return used time
        

3.4.00.24  - 2013.02.27
-------------------------------------------------------------------------------
    refactor:
        ... some code cleanup
    debug:
        mouse binding in "... info" tab
        

3.4.00.23  - 2013.02.27
-------------------------------------------------------------------------------
    refactor:
        ... harmonize interface on bikeGeometry
            ... but there are still a few side-links
            

3.4.00.22  - 2013.02.27
-------------------------------------------------------------------------------
    debug:
        ... show angles in FrameDetails View belonging between 
              SeatTube & DownTube and SeatTube & TopTube belonging 
              to BB Offset


3.4.00.20  - 2013.02.24
-------------------------------------------------------------------------------
    refactor:
        ... bikeGeometry


3.4.00.18  - 2013.02.24
-------------------------------------------------------------------------------
    refactor:
        ... unify procedures project::setValues and project::getValues
            ... updating: rattleCAD::projectUpdate


3.4.00.17   - 2013.02.24
-------------------------------------------------------------------------------
    feature:
        ... create user-init file: _rattleCAD.init   .. in project-directory
            ... containing:  <GUI_Font>Arial 8</GUI_Font> for font and size


3.4.00.16   - 2013.02.23
-------------------------------------------------------------------------------
    refactor:
        ... extract procedures from projectUpdate::createEdit


3.4.00.15   - 2013.02.22
-------------------------------------------------------------------------------
    debug/feature:
        ... demo mode: File -> Demo


3.4.00.14   - 2013.02.22
-------------------------------------------------------------------------------
    refactor:
        ... move frame_geometry::createEdit to projectUpdate::createEdit


3.4.00.13   - 2013.02.21 
-------------------------------------------------------------------------------
    refactor:
        ... move frame_geometry::update to cv_custom::update
    debug:
        ... reset 3.4.00.12


3.4.00.12   - 2013.02.20 
-------------------------------------------------------------------------------
    feature:
        ... prevent content from reposition after update canvas
               cv_custom::update $cv_Name [default:reset/keep]


3.4.00.11   - 2013.02.20 
-------------------------------------------------------------------------------
    feature:
        ... creates .bat file to create summary-pdf in create_summaryPDF 
               more readable 


3.4.00.10   - 2013.02.19 
-------------------------------------------------------------------------------
    feature:
        ... demo mode: File -> Demo


3.4.00.09   - 2013.02.19 
-------------------------------------------------------------------------------
    update:
        ... build procedure
        ... commandLine routine
        ... rename procedure testContro to controlDemo


3.4.00.08   - 2013.02.18 
-------------------------------------------------------------------------------
    feature:
        ... run integrated test per commandLine
            ... -test loopSamples integrationTest_00 (others will follow)


3.4.00.07   - 2013.02.18 
-------------------------------------------------------------------------------
    debug:
        ... copy sample directory to zip-File
        ... check creation of %USERDIR% directory in 
                APP-Directory on Windows7


3.4.00.06   - 2013.02.17 
-------------------------------------------------------------------------------
    feature:
        ... add samples to rattleCAD and loop through them
            ... File -> Samples
        ... update Title, when update canvas is finished


3.4.00.05   - 2013.02.17 
-------------------------------------------------------------------------------
    refactor:
        ... move code to ECLIPSE and build starkit with ANT


3.3.06.34   - 2013.02.06 
-------------------------------------------------------------------------------
    Siegmund Freud:
        ... startup_image.gif: Bicycle Fame Geometry -> Bicycle Frame Geometry


3.3.06.33   - 2013.02.06 
-------------------------------------------------------------------------------
    debug:
        ... handle fork rendering on bent fork blades on reopening projects


3.3.06.32   - 2013.02.05 
-------------------------------------------------------------------------------
    feature:
        ... give exported pdf name of project and ad DIn Format to name
    debug:
        ... handle size of label "ChainStay Centerline" on different scales


3.3.06.31   - 2013.02.05 
-------------------------------------------------------------------------------
    debug:
        ... export pdf, handle exec ghostscript


3.3.06.30   - 2013.02.03 
-------------------------------------------------------------------------------
    debug:
        ... export pdf, check equal formats


3.3.06.29   - 2013.02.03 
-------------------------------------------------------------------------------
    feature:
        ... export pdf, cleanup menue frames
        ... export ps,  move timestamp to top right corner
        ... update chainstay details 


3.3.06.28   - 2013.02.03 
-------------------------------------------------------------------------------
    feature:
        ... export pdf, cleanup menue frames
        ... export ps,  move timestamp to top right corner
        ... update chainstay details 


3.3.06.27   - 2013.02.03 
-------------------------------------------------------------------------------
    feature:
        ... export pdf 
        ... reorder menue 


3.3.06.26   - 2013.02.02 
-------------------------------------------------------------------------------
    debug:
        ... adopt additional frame-jig options 


3.3.06.25   - 2013.01.31 
-------------------------------------------------------------------------------
    feature:
        ... user dependent init-file, 
        ... additional frame-jig options 


3.3.06.24   - 2013.01.27 
-------------------------------------------------------------------------------
    debug:
        ... html-Export: handle empty html-export directory


3.3.06.23   - 2013.01.27 
-------------------------------------------------------------------------------
    feature:
        ... html-Export: extend function


3.3.06.22   - 2013.01.26 
-------------------------------------------------------------------------------
    feature:
        ... html-Export:


3.3.06.20   - 2013.01.14 
-------------------------------------------------------------------------------
    debug:
        ... canvasCAD 0.29: canvasCAD_print.tcl/printPostScript:
            ... handle fileExtension
        ... export Postscript on Windows


3.3.06.18   - 2013.01.13 
-------------------------------------------------------------------------------
    debug:
        ... canvasCAD 0.28: canvasCAD_IO.tcl/polyline: stroke-dasharray
        ... internal renaming of tabs: cv_Custom00, cv_Custom10, ...


3.3.06.16   - 2013.01.02 
-------------------------------------------------------------------------------
    debug:
        ... correct visualistion of dimension of headtube - downtube offset


3.3.06.15   - 2013.01.02 
-------------------------------------------------------------------------------
    debug:
        ... correct value: Result(Tubes/SeatTube/Direction) and 
            visualistion of dimension of bottle-cage-mount


3.3.06.14   - 2013.01.01 
-------------------------------------------------------------------------------
    feature:
        ... change behaviour on seat- and downtube by 
            bottombracket/seattube offset


3.3.06.12   - 2012.12.19 
-------------------------------------------------------------------------------
    feature:
        ... additional rear dropout: richardsachs_PiccoliGioielli_68.svg
        ... additional fork dropout: richardsachs_PiccoliGioielli.svg

        
3.3.06.10   - 2012.12.12    ... repository update
-------------------------------------------------------------------------------
    svn.code.sf.net
        http://svn.code.sf.net/p/rattlecad/code/3.3/06
        svn+ssh://username@svn.code.sf.net/p/rattlecad/code/3.3/06
        svn+ssh://username@svn.code.sf.net/p/rattlecad/code/trunk


3.3.06.10   - 2012.12.12 
-------------------------------------------------------------------------------
    debug:
        ... File Save on reloaded templates - > saves Files as ... ?
            ... e.g. 2710688435738 ... can not ever find a file like this ..


3.3.06.09   - 2012.12.12 
-------------------------------------------------------------------------------
    debug:
        ... older rattleCAD-Files just defines "Suspension" as Fork-Rendering
            ... if so set "Suspension_26" as default


3.3.06.07   - 2012.12.06 
-------------------------------------------------------------------------------
    feature:
        ... additional dropout, handling 16mm ChainStay-Tip


3.3.06.06   - 2012.12.02 
-------------------------------------------------------------------------------
    bugfix:
        ... correct brakeMount Position


3.3.06.05   - 2012.12.02 
-------------------------------------------------------------------------------
    feature:
        ... more precise curves for forkblade and chainstay


3.3.06.04   - 2012.12.02 
-------------------------------------------------------------------------------
    feature:
        ... new fork select options
            ... editable in FrameDetails: 
                  SteelLugged(straight,bent), SteelLuggedMAX, Composite, ...
            ... selectable in Summary & Mockup: 
                  SteelLugged, SteelLuggedMAX, Composite, ...


3.3.06.01   - 2012.11.28 
-------------------------------------------------------------------------------
    feature:
        ... new fork dropouts
    bugfix:
        ... update positioning of front brake to standard of 3.3.05
    attention: 
        ... llewelyn rear dropouts renamed
            ... llewelyn_64.svg  ...  llewellyn_LRD_64.svg
            ... llewelyn_68.svg  ...  llewellyn_LRD_68.svg
            ... llewelyn_72.svg  ...  llewellyn_LRD_72.svg


3.3.06.00   - 2012.11.27 
-------------------------------------------------------------------------------
    feature:
        ... bent Fork Blade


3.3.05.34   - 2012.11.11 
-------------------------------------------------------------------------------
    bugfix:
        ... scale of String "ChainStay Profile" in "ChainStay Details"

 
3.3.05.33   - 2012.11.04 
-------------------------------------------------------------------------------
    feature:
        ... add further point to ChainStay - Centerline


3.3.05.32   - 2012.11.01 
-------------------------------------------------------------------------------
    feature:
        ... improved configuration of ChainStay-Centerline


3.3.05.30   - 2012.11.01 
-------------------------------------------------------------------------------
    feature:
        ... improved configuration of ChainStay-Profile


3.3.05.29   - 2012.11.01 
-------------------------------------------------------------------------------
    bugfix & feature:
        ... improve usability in switch straight/bent/off ChainStays
        ... change naming of ChainStay-Profile parameters


3.3.05.28   - 2012.10.30 
-------------------------------------------------------------------------------
    bugfix & feature:
        ... editable DiscWith and offset to dropout


3.3.05.27   - 2012.10.29 
-------------------------------------------------------------------------------
    feature:
        ... add brake disc to ChainStay-Details


3.3.05.26   - 2012.10.28 
-------------------------------------------------------------------------------
    feature:
        ... add new type of ChainStay-Details


3.3.05.25   - 2012.10.07 
-------------------------------------------------------------------------------
    feature:
        ... allow <Control-c> to copy text in Help/Info - Panel
        ... bind  <Escape> to close Help/Info - Panel


3.3.05.23/24   - 2012.09.24 
-------------------------------------------------------------------------------
    feature:
        ... BaseConcept: refer virtual TopTube position to top of HeadTube
                instead of section of HeadTube/TopTube


3.3.05.22   - 2012.09.24 
-------------------------------------------------------------------------------
    feature:
        ... RearDerailleur: campagnolo_2011_UltraShift.svg


3.3.05.21   - 2012.09.22 
-------------------------------------------------------------------------------
    bugfix:
        ... check for modification before exit and request "File Save"
    architecture:
        ... move $::APPL_Env(...) to $::APPL_Config(...) 
                ... remove $::APPL_Env(...) completely


3.3.05.20   - 2012.09.21 
-------------------------------------------------------------------------------
    feature:
        ... LLEWELLYN dropouts 64, 68 & 72°


3.3.05.19   - 2012.09.21 
-------------------------------------------------------------------------------
    feature:
        ... additional dimensions for HeadSet Top and Stem
    debug:
        ... check for modification before exit and request "File Save"


3.3.05.16/17   - 2012.09.21 
-------------------------------------------------------------------------------
    feature:
        ... check for modification before exit and request "File Save"


3.3.05.15   - 2012.09.20 
-------------------------------------------------------------------------------
    bugfix:
        ... ChainStay Details -> BottomBracket ChainStay Offset_TopView
                ... parameter was not editable


3.3.05.14   - 2012.09.19 
-------------------------------------------------------------------------------
    components:
        ... add dropout: LLEWELLYN 70° from http://www.llewellynbikes.com
    feature:
        ... handling different types of reardropouts, position them
                in front or behind of chain- & seatstays


3.3.05.12   - 2012.09.15 
-------------------------------------------------------------------------------
    components:
        ... add dropout: DR1008 from http://www.paragonmachineworks.com


3.3.05.11   - 2012.09.14 
-------------------------------------------------------------------------------
    file format:
        ... when open an existing project-file, remove the existing
              <Result> tag, replace it with the <Result> tag of the template
              and fill during runtime


3.3.05.10   - 2012.09.14 
-------------------------------------------------------------------------------
    usability:
        ... new order to the tabs
                ... rename "Rear Mockup" to "ChainStay Details"
                ... repoition "Chainstay Details" after "Frame Details"


3.3.05.09   - 2012.09.09 
-------------------------------------------------------------------------------
    bugfix:
        ... lib_frame_geometry -> SeatTubeAngle on SeatTube/OffsetBB <> 0
                ... Virtual TopTube Length


3.3.05.08   - 2012.09.06 
-------------------------------------------------------------------------------
    bugfix:
        ... lib_frame_geometry -> SeatTubeAngle on SeatTube/OffsetBB <> 0
        ... lib_cv_custom      -> SeatTubeAngle on SeatTube/OffsetBB <> 0
                ... Virtual TopTube Length
 
           
3.3.05.06   - 2012.09.05 
-------------------------------------------------------------------------------
    bugfix:
        ... lib_frame_geometry -> base_geomatry -> SeatTubeAngle
 
 
3.3.05.05   - 2012.09.04 
-------------------------------------------------------------------------------
    bugfix:
        ... ETRTO - European Tire and Rim Technical Organisation
               ... in .../etc/rattleCAD_init.xml

               
3.3.05.04   - 2012.09.02 
-------------------------------------------------------------------------------
    bugfix:
        ... e.g.: can't read "HandleBar(Distance)": no such variable
                ... refer procedures directly in namespace

            
3.3.05.03   - 2012.08.28 
-------------------------------------------------------------------------------
    update:
        ... reorganize lib_frame_geometry.tcl


3.3.05.02   - 2012.08.25 
-------------------------------------------------------------------------------
    bugfix:
        ... fix incompatiblity to derailleur display 
                ... /root/Lugs/RearDropOut/Derailleur/x
                ... /root/Lugs/RearDropOut/Derailleur/y 
            ... are now positive values and has to be updated


3.3.05.01   - 2012.08.25 
-------------------------------------------------------------------------------
    feature:
        ... modified handling of rear dropout
        ... visualization is currently not compatible to 3.3.04.xx


3.3.04.14   - 2012.08.12 
-------------------------------------------------------------------------------
    feature:
        ... add ° to angular dimensions
        ... add angle conversion to FrameJig-Tab


3.3.04.12   - 2012.08.06 
-------------------------------------------------------------------------------
    feature:
        ... change log in Info Panel 


3.3.04.11   - 2012.07.29 
-------------------------------------------------------------------------------
    bugfix:
        ... file save ... after load template


3.3.04.10   - 2012.07.22 
-------------------------------------------------------------------------------
    feature:
        ... components:
          ... children saddle
          ... suspension fork 20"
    bugfix:
        ... file save


3.3.04.09   - 2012.07.22 
-------------------------------------------------------------------------------
    feature:
        ... resize stage on update if window size has changed   
    bugfix:
        ... open Config Panel
          ... config Panel crashes in 3.3.04.08


3.3.04.08   - 2012.07.22 
-------------------------------------------------------------------------------
    bugfix:
        ... File -> Save
          ... a file located in an other directory than USER_Dir was
                nevertheless  saved in USER_Dir


3.3.04.06   - 2012.07.18
-------------------------------------------------------------------------------
    bugfix:
        ... File -> Rendering
        ... File -> Import


3.3.04.05   - 2012.07.16
-------------------------------------------------------------------------------
    bugfix:
        ... resize stage on update if window size has changed


3.3.04.04   - 2012.07.15
-------------------------------------------------------------------------------
    feature:
        ... resize stage on update if window size has changed


3.3.04.03   - 2012.07.14
-------------------------------------------------------------------------------
    bugfix:
        ... etc/template_mtb_3.3.xml 
           ... add: /root/Component/Logo/File


3.3.04.02   - 2012.07.13
-------------------------------------------------------------------------------
    feature:
        ... dimension line on FrameDetails for SeatTube Angle
        ... additional dropout: ... etc/components/dropout/kinesis_1113.svg
    bugfix:
        ... cv_custom::update: centerlines for RearDeraileur 
           ... change: RearDerailleur_ctr to DerailleurRear_ctr


3.3.04.01   - 2012.07.12
-------------------------------------------------------------------------------
    feature:
        ... rattleCAD Logo on DownTube
        ... extend FileFormat: ... /root/Component/Logo/File


3.3.04.00   - 2012.07.12
-------------------------------------------------------------------------------
    feature:
        ... SeatTube offset
        ... extend FileFormat: ... /root/Custom/SeatTube/OffsetBB


3.3.03.08   - 2012.07.22 
-------------------------------------------------------------------------------
    bugfix:
        ... File -> Save
          ... a file located in an other directory than USER_Dir was
                nevertheless  saved in USER_Dir


3.3.03.07   - 2012.07.02
-------------------------------------------------------------------------------
    feature:
        ... Import File
          ... imports just a subset of the xml-Project-File
          ... allows defining templates of Tubesets
          ... allows importing personal paramaters for saddle & handlebar
          ... 


3.3.03.06   - 2012.07.01 
-------------------------------------------------------------------------------
    feature:
        ... Crankset Mockup: parameterized by length and Chainwheel
          ... requires any file named custom.svg in etc/components/crankset


3.3.03.05   - 2012.06.24  ... (3.3.03.04, 3.3.03.01)
-------------------------------------------------------------------------------
    feature:
        ... Base Concept: get dimensions from existing frames
           ... editable dimesion: stack & reach, virtual seattube length
                  horizontal chainstay length


3.3.03.01   - 2012.06.24
-------------------------------------------------------------------------------
    feature:
        ... Base Concept: add editable dimesion: virtual seattube length


3.3.02.04   - 2012.06.20
-------------------------------------------------------------------------------
    feature:
        ... Rear Mockup (cv_custom::update:  -> lib_gui::cv_Custom07)
           ... add editable page size & scale
           ... add drafting border


3.3.02.03   - 2012.06.20
-------------------------------------------------------------------------------
    bugfix:
        ... cv_custom::update:  render brake behind seatpost 


3.3.02.02   - 2012.05.20
-------------------------------------------------------------------------------
    bugfix:
        ... lib_config::leaveEntry: handle {,.} on decimal values
        ... cv_custom::createRearMockup::get_ChainStay_bent: 
                handle "0" values


3.3.02.01   - 2012.05.12
-------------------------------------------------------------------------------
    update/bugfix:
        ... add personal dimension: saddlenose / bottombracket as reference

        
3.3.00.32   - 2012.05.03
-------------------------------------------------------------------------------
    bugfix:
        ... update on campagnolo_ultra_torque.svg


3.3.00.30   - 2012.05.02
-------------------------------------------------------------------------------
    feature:
        ... add intersection dimensions on down- & seattube 
                in "Frame Drafting"


3.3.00.29   - 2012.05.02
-------------------------------------------------------------------------------
    bugfix:
        ... on result-seattube-angle


3.3.00.28   - 2012.05.02
-------------------------------------------------------------------------------
    bugfix:
        ... on headtube-angle displayed in "Frame Details"
            and "Frame Drafting"

        ... in "Configuration Panel". If stored Parameter in Project
            does not exist as selection anymore. This problem belongs to
            older versions 3.2.54 or older (not really sure about the version
            update in: lib_config::ListboxEvent


3.3.00.27   - 2012.05.01
-------------------------------------------------------------------------------
    feature:
        ... open files of version 3.2.xx
        ... add seattube positioning of saddle


3.3.00.20  - 2012.04.28
-------------------------------------------------------------------------------
    feature:
        ... show free space for ChainCtay


3.3.00.xx  - 2012.04.28
-------------------------------------------------------------------------------
    feature:
        ... new definition of Saddle Position
            - now uses orthogonal positioning
            - saddle also have a vertical dimension for positioning
            - modified seatpost represenation
        ... Rear Mockup
            give the designer a possibility to check ChainStay area based on
            - Crankset with different Chainwheels
            - last sprocket of cassette
            - tyre
        ... structure of project file changed belonging to changes of 3.3.xx   
        ... cleanup code

                            

                           