#!/usr/bin/wish

 #

    set APPL_START_Dir [file normalize [file dirname [lindex $argv0]]]
    set APPL_ROOT_Dir  [file dirname [file dirname [file dirname $APPL_START_Dir]]]
    puts "  -> \$APPL_START_Dir $APPL_START_Dir"
    puts "  -> \$APPL_ROOT_Dir  $APPL_ROOT_Dir"
    lappend auto_path "$APPL_ROOT_Dir"
    lappend auto_path "$APPL_ROOT_Dir/lib"
    
    package require bikeGeometry
    
    
        #

        #
    proc bikeGeometry::geometry3D::openProject {{sampleFile {}}} {

            variable fileName
            variable sourceText
            variable targetText
            
            variable exportFileName
            variable exportFileExtension 
            variable exportDir
            
            variable rattleCAD_DOM
            
            variable RearHubWidth
            variable FrontHubWidth    100
            variable ChainStayOffset
            variable height_BottomBracket                        
        
            puts "\n"
            puts "  =============================================="
            puts "   -- openProject:   $sampleFile"
            puts "  =============================================="
            puts "\n"
    

                # --- open File ------------
            if {$sampleFile == {}} {
                set fileName [tk_getOpenFile]
            } else {
                set fileName $sampleFile
                puts "   ... $fileName"
            }
                #
            puts "\n   -> getContent: $sampleFile:"
            set fp [open $sampleFile]
            fconfigure    $fp -encoding utf-8
            set xml [read $fp]
            close         $fp
            set sampleDOC   [dom parse  $xml]
            set sampleDOM   [$sampleDOC documentElement]
                #
            bikeGeometry::set_newProject $sampleDOM
                #
            bikeGeometry::set_to_project
                #
            #set projectDict [bikeGeometry::get_projectDICT]                
                
                
                
                
                
            #set fp [open ${fileName}]
			      # fconfigure    $fp -encoding utf-8
            #set rattleCAD_Project [read $fp]
            #close         $fp
                #
            #dom parse  $rattleCAD_Project rattleCAD_DOC
            #set  rattleCAD_DOM [$rattleCAD_DOC documentElement root]
            set  rattleCAD_DOM $sampleDOM 
                #
            if {$fileName == {}} {return}
			set exportFileName [file rootname [file tail $fileName]]
            set exportDir      [file dirname $fileName]
                # --- check export-Dir -----
            set exportDir [file join [file dirname argv0] _export]
            if {![file exists $exportDir]} {
                file mkdir $exportDir
            }              
                #
                # --- openSCAD 
                #
            set exportFile [file join $exportDir [format "export_%s.%s" _complete $exportFileExtension]]
            set exportFile [file normalize $exportFile]
                #
            saveFile    $exportFile [getComplete]
                #
            exit
            
                # --- compute results ------            

                # --- cleanup outputs ------            
            $sourceText delete 1.0 end
            $targetText delete 1.0 end

                # --- fill outputs ---------
            $sourceText insert end $rattleCAD_Project
                
                
                 # --- common Values -------
            set RearHubWidth          [[$rattleCAD_DOM selectNodes /root/Component/Wheel/Rear/HubWidth/text()            ] asXML]
            set ChainStayOffset       [[$rattleCAD_DOM selectNodes /root/Lugs/RearDropOut/ChainStay/Offset_TopView/text()] asXML]
            set height_BottomBracket  [split [[$rattleCAD_DOM selectNodes /root/Result/Length/BottomBracket/Height/text() ] asXML] ,]
        
               
            set typeList {frame fork seatpost saddle stem handlebar frontrim rearrim fronttyre reartyre all_other _complete}
                #
            foreach type $typeList {
                    #
                puts "\n    -> $type \n"   
                    #
                set exportFile [file join $exportDir [format "export_%s.%s" $type $exportFileExtension]]
                set exportFile [file normalize $exportFile]
                
                    # --- convert to OBJ-3D
                create_obj $type  

                    # --- save Content
                saveContent   $exportFile
            }   
                #
                
                #
                # --- MeshLab
                #                
            set exportFile [file join $exportDir assembly.mlp]
            set exportFile [file normalize $exportFile]
                
                # --- convert to OBJ-3D
            #create_MeshlabProject  

                # --- save Content
            #saveContent   $exportFile
                # 
            # exit                
    }

    proc bikeGeometry::geometry3D::reloadProject {} {
            variable fileName
            openProject "$fileName"        
    }

    proc bikeGeometry::geometry3D::start_GUI {{fileName {}}} {
    
                # tk_messageBox -message "encoding system  [encoding system]"
            puts "encoding system  [encoding system]"
            
            variable sourceText
            variable targetText
                #
                
                # --- store fileName --
                #
            # set fileName {}

                # --- window ----------
                #
            pack [ frame .f -bg lightblue] 
                
                # -- buttonBar
                #
            set buttonBar    [ frame .f.bb ]
                pack $buttonBar      -expand yes -fill both 
            button $buttonBar.openProject    -text "  open rattleCAD-Project  "    -command openProject
            button $buttonBar.reloadProject  -text " reload rattleCAD-Project "    -command reloadProject
            label  $buttonBar.sp_00          -text "           "
            button $buttonBar.saveContent    -text " export to OBJ - 3D "          -command saveContent   
            label  $buttonBar.sp_01          -text "                                      "
            button $buttonBar.exit  -text " EXIT "                        -command exit   

                pack $buttonBar.openProject $buttonBar.reloadProject $buttonBar.sp_00 \
                     $buttonBar.saveContent $buttonBar.sp_01 \
                     $buttonBar.exit \
                     -side left


                # -- textFrame
                #
            set textFrame    [ frame .f.tf ]
                pack $textFrame      -expand yes -fill both 
                
            set sourceFrame  [ frame    $textFrame.f_source       -relief sunken ]
            set targetFrame  [ frame    $textFrame.f_target       -relief sunken ]
                pack $sourceFrame $targetFrame \
                     -side left

                # -- source
            set sourceText [ text $sourceFrame.txt -wrap none -xscroll "$sourceFrame.h set" \
                                                              -yscroll "$sourceFrame.v set" -height 46 -width 80 ]
            scrollbar $sourceFrame.v -orient vertical   -command "$sourceFrame.txt yview"
            scrollbar $sourceFrame.h -orient horizontal -command "$sourceFrame.txt xview"
                # Lay them out
                grid $sourceFrame.txt $sourceFrame.v  -sticky nsew
                grid $sourceFrame.h                     -sticky nsew
                # Tell the text widget to take all the extra room
                grid rowconfigure    $sourceFrame.txt 0 -weight 1
                grid columnconfigure $sourceFrame.txt 0 -weight 1 
                
                # -- target
            set targetText [ text $targetFrame.txt -wrap none -xscroll "$targetFrame.h set" \
                                                              -yscroll "$targetFrame.v set" -height 46 -width 80 ]
            scrollbar $targetFrame.v -orient vertical   -command "$targetFrame.txt yview"
            scrollbar $targetFrame.h -orient horizontal -command "$targetFrame.txt xview"
                # Lay them out
                grid $targetFrame.txt $targetFrame.v  -sticky nsew
                grid $targetFrame.h                     -sticky nsew
                # Tell the text widget to take all the extra room
                grid rowconfigure    $targetFrame.txt 0 -weight 1
                grid columnconfigure $targetFrame.txt 0 -weight 1 
             

            # -- open File
            if {$fileName != {}} {
                puts "\n   ... $fileName"
                openProject "$fileName"
            } else {
                puts "\n   ... $fileName"
                # openProject
            }
        
    }
    
     
        # -- open File
    if {[llength $argv] > 0} {
        set fileName [lindex $argv 0]
        puts "\n   ... $fileName"
        bikeGeometry::geometry3D::start_GUI "$fileName"
    } else {
        bikeGeometry::geometry3D::start_GUI
    }   