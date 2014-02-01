

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
    refactoring:
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
    refactoring:
        ... lib_config.tcl: Config Window
        

3.4.00.25  - 2013.02.28
-------------------------------------------------------------------------------
    refactoring:
        ... call bikeGeometry::setValue instead of 
              bikeGeometry::set_projectValue 
        ... rattleCAD_Test::controlDemo: return used time
        

3.4.00.24  - 2013.02.27
-------------------------------------------------------------------------------
    refactoring:
        ... some code cleanup
    debug:
        mouse binding in "... info" tab
        

3.4.00.23  - 2013.02.27
-------------------------------------------------------------------------------
    refactoring:
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
    refactoring:
        ... bikeGeometry


3.4.00.18  - 2013.02.24
-------------------------------------------------------------------------------
    refactoring:
        ... unify procedures project::setValues and project::getValues
            ... updating: rattleCAD::projectUpdate


3.4.00.17   - 2013.02.24
-------------------------------------------------------------------------------
    feature:
        ... create user-init file: _rattleCAD.init   .. in project-directory
            ... containing:  <GUI_Font>Arial 8</GUI_Font> for font and size


3.4.00.16   - 2013.02.23
-------------------------------------------------------------------------------
    refactoring:
        ... extract procedures from projectUpdate::createEdit


3.4.00.15   - 2013.02.22
-------------------------------------------------------------------------------
    debug/feature:
        ... demo mode: File -> Demo


3.4.00.14   - 2013.02.22
-------------------------------------------------------------------------------
    refactoring:
        ... move frame_geometry::createEdit to projectUpdate::createEdit


3.4.00.13   - 2013.02.21 
-------------------------------------------------------------------------------
    refactoring:
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
        ... check creation of %USERDIR% directory in APP-Directory on Windows7


3.4.00.06   - 2013.02.17 
-------------------------------------------------------------------------------
    feature:
        ... add samples to rattleCAD and loop through them
            ... File -> Samples
        ... update Title, when update canvas is finished


3.4.00.05   - 2013.02.17 
-------------------------------------------------------------------------------
    refactoring:
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
        ... cv_custom::createRearMockup::get_ChainStay_bent: handle "0" values


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
        ... add intersection dimensions on down- & seattube in "Frame Drafting"


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

                            

                           