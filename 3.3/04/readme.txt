3.3.04.02   - 2012.07.13
-------------------------------------------------------------------------------
    feature:
        ... dimension line on FrameDetails for SeatTube Angle
        ... additional dropout: ... etc/components/dropout/kinesis_1113.svg
    bugfix:
        ... cv_custom::update: centerlines for RearDeraileur 
           ... cahnge: RearDerailleur_ctr to DerailleurRear_ctr
       

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

                            

                           