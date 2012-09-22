            
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
        ... resize stage on update if window size has changed   bugfix:
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

                            

                           