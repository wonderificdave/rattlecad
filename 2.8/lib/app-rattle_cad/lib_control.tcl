# -----------------------------------------------------------------------------------
#
#: Functions : namespace      C O N T R O L
#

 namespace eval control {
                            
   variable   FILE_Attr
   array set  FILE_Attr { Version {prev. 2.2}
                        }
   
   variable   templ_filename     project.rcad
   variable   current_filename   ""
   variable   default_type       {.rcad}
   variable   filetypes        { {"RattleCAD"  {.rcad} }
                                 {"csv"        {.csv}  }
                                 {"All Files"  *       }
                               }
   
   variable   install_dir        $::APPL_Env(BASE_Dir)
   variable   USER_Dir           [file join $install_dir user]

   variable   USER_Template
   array set  USER_Template {      type  Road
                                  Road  {}      
                               OffRoad  {}
                                   gui  {}
                            }
                        
   variable   GUI_Config 
   array set  GUI_Config {  GUI_METH_BBracket      {height}
                            GUI_METH_HTube         {bar}
                            GUI_LOCK_config_Rim    {lock}
                            GUI_LOCK_config_Tyre   {lock}
                            GUI_LOCK_replace_Rim   {lock}
                            GUI_LOCK_replace_Tyre  {lock}
                            GUI_FRAME_Display      {outline}
                            _GUI_Font               {Arial 8}
                            _Language               {english}
                         }
						 
   variable   FILE_List	 {}
   variable   FILE_List_Widget {}  
						 
                         
     # variable   FRAME_Config_Mode        wait
   variable   FRAME_Display_Values     {centerline outline preview}
   variable   FRAME_Display_Direction  {plus}
   
   variable   FRAME_Config_Mode        frame_design
   variable   FRAME_Geometry_Id        wait   

   variable   Last_Mode    {}
   variable   Current_Mode {}
   
   variable   TEMPLATE_Road
   array set  TEMPLATE_Road    {}
   variable   TEMPLATE_OffRoad 
   array set  TEMPLATE_OffRoad {}
   variable   CURRENT_Config
   array set  CURRENT_Config   {}
   
   
   variable   UPDATE_Parameter {false}
   

   #-------------------------------------------------------------------------
       #  init
       #
   proc init {} {
          variable TEMPLATE_Road 
          variable TEMPLATE_OffRoad
          variable CURRENT_Config
          variable USER_Template
          variable USER_Dir
		  
		set    ::APPL_Env(USER_Dir)    $USER_Dir
          

        set    USER_Template(Road)     [file join  $USER_Dir  _user_road.tmpl]
        set    USER_Template(OffRoad)  [file join  $USER_Dir  _user_offroad.tmpl]

          
        set    TEMPLATE_Road(HandleBar_Type)            drop_bar
        set    TEMPLATE_Road(Fork_Type)                 rigid
        set    TEMPLATE_Road(InnerLeg_Length)           850.0
        set    TEMPLATE_Road(CrankArm_Length)           172.5
        set    TEMPLATE_Road(Wheel_Front_Rim_Diameter)  622.0
        set    TEMPLATE_Road(Wheel_Front_Tyre_Height)    23.0
        set    TEMPLATE_Road(Wheel_Rear_Rim_Diameter)   622.0
        set    TEMPLATE_Road(Wheel_Rear_Tyre_Height)     23.0
        set    TEMPLATE_Road(BottomBracket_Height)      272.5
        set    TEMPLATE_Road(ChainStay_Length)          410.0
        set    TEMPLATE_Road(Front_Length)              595.0
        set    TEMPLATE_Road(SeatTube_Angle)             73.0
        set    TEMPLATE_Road(HandleBar_Distance)        474.0
        set    TEMPLATE_Road(HandleBar_Height)          646.0
        set    TEMPLATE_Road(HeadTube_Length)           166.0
        # set    TEMPLATE_Road(HeadTube_Angle)             72.0
        # set    TEMPLATE_Road(TopTube_Heigth)            800.0
        set    TEMPLATE_Road(TopTube_Angle)               2.0
        set    TEMPLATE_Road(TopTube_Pivot)              80.0
        set    TEMPLATE_Road(TopTube_Diameter)           28.6  
        set    TEMPLATE_Road(TopTube_Diameter_SL)        28.6
        set    TEMPLATE_Road(HeadTube_Diameter)          36.0 
        set    TEMPLATE_Road(DownTube_Diameter)          31.8  
        set    TEMPLATE_Road(SeatTube_Diameter)          28.6  
        set    TEMPLATE_Road(HeadTube_Bottom)            15.0
        set    TEMPLATE_Road(HeadTube_Top)               12.0
        set    TEMPLATE_Road(SeatTube_Lug)               30.0
        set    TEMPLATE_Road(SeatStay_Distance)          30.0
        set    TEMPLATE_Road(Fork_Heigth)               365.0
        set    TEMPLATE_Road(Fork_Rake)                  45.0
        set    TEMPLATE_Road(ForkBlade_Width)         	 29.0
        set    TEMPLATE_Road(ForkCrown_Diameter)         45.0
        set    TEMPLATE_Road(HeadsetBottom_Heigth)       15.0
        set    TEMPLATE_Road(Stem_Heigth)                45.0
        set    TEMPLATE_Road(Stem_Angle)                -10.0
        set    TEMPLATE_Road(Stem_Length)               110.0
        set    TEMPLATE_Road(Comp_Wheel_Front_Rim_Diameter)  622.0
        set    TEMPLATE_Road(Comp_Wheel_Front_Tyre_Height)    25.0
        set    TEMPLATE_Road(Comp_Wheel_Rear_Rim_Diameter)   622.0 
        set    TEMPLATE_Road(Comp_Wheel_Rear_Tyre_Height)     25.0
        set    TEMPLATE_Road(Comp_Fork_Heigth)          375.0
        set    TEMPLATE_Road(Comp_Fork_Rake)             40.0
        set    TEMPLATE_Road(Comp_Stem_Heigth)           25.0
        set    TEMPLATE_Road(Comp_Stem_Angle)             0.0
        set    TEMPLATE_Road(Comp_Stem_Length)          130.0
        set    TEMPLATE_Road(DownTube_BB_Diameter)       34.9
        set    TEMPLATE_Road(SeatTube_BB_Diameter)       31.8
        set    TEMPLATE_Road(SeatStay_Diameter)          16
        set    TEMPLATE_Road(SeatStay_Diameter_2)        13
        set    TEMPLATE_Road(SeatStay_TaperLength)      300.0
        set    TEMPLATE_Road(ChainStay_Diameter)         29
        set    TEMPLATE_Road(ChainStay_Diameter_2)       14
        set    TEMPLATE_Road(ChainStay_TaperLength)     300.0
        # set    TEMPLATE_Road(BottomBrckt_Diameter)       38.0
          

          # 
          #  default   OffRoad - values
          #

        set    TEMPLATE_OffRoad(HandleBar_Type)            flat_bar
        set    TEMPLATE_OffRoad(Fork_Type)                 suspension
        set    TEMPLATE_OffRoad(InnerLeg_Length)           850.0
        set    TEMPLATE_OffRoad(CrankArm_Length)           175.0
        set    TEMPLATE_OffRoad(Wheel_Front_Rim_Diameter)  559.0
        set    TEMPLATE_OffRoad(Wheel_Front_Tyre_Height)    47.0
        set    TEMPLATE_OffRoad(Wheel_Rear_Rim_Diameter)   559.0
        set    TEMPLATE_OffRoad(Wheel_Rear_Tyre_Height)     47.0
        set    TEMPLATE_OffRoad(BottomBracket_Height)      295.5
        set    TEMPLATE_OffRoad(ChainStay_Length)          420.0
        set    TEMPLATE_OffRoad(Front_Length)              615.0
        set    TEMPLATE_OffRoad(SeatTube_Angle)             72.0
        set    TEMPLATE_OffRoad(HeadTube_Length)           166.0
        set    TEMPLATE_OffRoad(HandleBar_Distance)        474.0
        set    TEMPLATE_OffRoad(HandleBar_Height)          630.0
        set    TEMPLATE_OffRoad(HeadTube_Length)           140.0
        # set    TEMPLATE_OffRoad(HeadTube_Angle)             71.0
        # set    TEMPLATE_OffRoad(TopTube_Heigth)            800.0
        set    TEMPLATE_OffRoad(TopTube_Angle)               5.0
        set    TEMPLATE_OffRoad(TopTube_Pivot)              80.0          	       		      
        set    TEMPLATE_OffRoad(TopTube_Diameter)           28.6  
        set    TEMPLATE_OffRoad(HeadTube_Diameter)          36.0 
        set    TEMPLATE_OffRoad(DownTube_Diameter)          31.8  
        set    TEMPLATE_OffRoad(SeatTube_Diameter)          31.8  
        set    TEMPLATE_OffRoad(TopTube_Diameter_SL)        31.8
        set    TEMPLATE_OffRoad(HeadTube_Bottom)            14.0
        set    TEMPLATE_OffRoad(HeadTube_Top)               13.0
        set    TEMPLATE_OffRoad(SeatTube_Lug)               30.0
        set    TEMPLATE_OffRoad(SeatStay_Distance)          30.0
        set    TEMPLATE_OffRoad(Fork_Heigth)               410.0
        set    TEMPLATE_OffRoad(Fork_Rake)                  40.0
        set    TEMPLATE_OffRoad(ForkBlade_Width)         	32.0
        set    TEMPLATE_OffRoad(ForkCrown_Diameter)         45.0
        set    TEMPLATE_OffRoad(HeadsetBottom_Heigth)       15.0
        set    TEMPLATE_OffRoad(Stem_Heigth)                45.0
        set    TEMPLATE_OffRoad(Stem_Angle)                -10.0
        set    TEMPLATE_OffRoad(Stem_Length)               110.0
        set    TEMPLATE_OffRoad(Comp_Wheel_Front_Rim_Diameter)  559.0
        set    TEMPLATE_OffRoad(Comp_Wheel_Front_Tyre_Height)    58.0
        set    TEMPLATE_OffRoad(Comp_Wheel_Rear_Rim_Diameter)   559.0 
        set    TEMPLATE_OffRoad(Comp_Wheel_Rear_Tyre_Height)     58.0
        set    TEMPLATE_OffRoad(Comp_Fork_Heigth)          430.0
        set    TEMPLATE_OffRoad(Comp_Fork_Rake)             40.0
        set    TEMPLATE_OffRoad(Comp_Stem_Heigth)           25.0
        set    TEMPLATE_OffRoad(Comp_Stem_Angle)             0.0
        set    TEMPLATE_OffRoad(Comp_Stem_Length)          130.0
        set    TEMPLATE_OffRoad(DownTube_BB_Diameter)       34.9
        set    TEMPLATE_OffRoad(SeatTube_BB_Diameter)       31.8
        set    TEMPLATE_OffRoad(SeatStay_Diameter)          16
        set    TEMPLATE_OffRoad(SeatStay_Diameter_2)        13
        set    TEMPLATE_OffRoad(SeatStay_TaperLength)      300.0
        set    TEMPLATE_OffRoad(ChainStay_Diameter)         29
        set    TEMPLATE_OffRoad(ChainStay_Diameter_2)       14
        set    TEMPLATE_OffRoad(ChainStay_TaperLength)     300.0        	       		      
         # set    TEMPLATE_OffRoad(BottomBrckt_Diameter)       38.0
        
        
          # -- road -------
          #
        if {[file isfile $USER_Template(Road)] && [file readable $USER_Template(Road)]} {
                ::Debug  t  "USER_Template(Road)   $USER_Template(Road)"
                read_configfile  $USER_Template(Road)
                check_init_values
                array set         TEMPLATE_Road  [array get CURRENT_Config]
            } else {
                ::Debug  t  "<E> USER_Template(Road)   $USER_Template(Road)  does not exist"
            }
  
          # -- offroad ----
          #
        if {[file isfile $USER_Template(OffRoad)] && [file readable $USER_Template(OffRoad)]} {
                ::Debug  t  "USER_Template(OffRoad)   $USER_Template(OffRoad)"
                read_configfile  $USER_Template(OffRoad)
                check_init_values
                array set         TEMPLATE_OffRoad  [array get CURRENT_Config]
            }   else {
                ::Debug  t  "<E> USER_Template(OffRoad)   $USER_Template(OffRoad)  does not exist"
            }
        
          # -- first initialization ----
          #
        set templName [format "TEMPLATE_%s"  $USER_Template(type)]
          # unset      CURRENT_Config
          # tk_messageBox -message "init 01:   [array names CURRENT_Config]"
          # array unset CURRENT_Config  * 
          # tk_messageBox -message "init 02:   [array names CURRENT_Config]"        
        
        array set   CURRENT_Config  [array get $templName]
          # tk_messageBox -message "init 02:   [array names CURRENT_Config]"    

        return 
          
   }
   
   
   #-------------------------------------------------------------------------
       #  check initial values 
       #          
   proc check_init_values {} {
   
          variable CURRENT_Config
          variable GUI_Config
 
        ::Debug  p 
        
          # -- _rattleCAD_Version ---------------
        if {[string equal [array names CURRENT_Config "ForkBlade_Width"] {} ]} {  # -- ForkBlade_Width defined first in 2.8.00
			set CURRENT_Config(_rattleCAD_Version)   2.70
			
			if {[string equal [array names CURRENT_Config "ForkCrown_Diameter"] {} ]} {  # -- ForkCrown_Diameter defined first in 2.5.00
				set CURRENT_Config(_rattleCAD_Version)   2.40
				
				if {[string equal [array names CURRENT_Config "Fork_Type"] {} ]} {  # -- Fork_Type defined first in 2.4.02
					set CURRENT_Config(_rattleCAD_Version)   2.30
					
					if {[string equal [array names CURRENT_Config "HeadTube_Length"] {} ]} {  # -- HeadTube_Length not defined yet in prev. versions
						 set CURRENT_Config(_rattleCAD_Version)   2.00
						 
						 if {[string equal [array names CURRENT_Config "Wheel_Rear_Rim_Diameter"] {} ]} { # -- Wheel_Rear_Rim_Diameter not defined yet in prev. versions
							 set CURRENT_Config(_rattleCAD_Version)   1.90
							 
							 if {[string equal [array names CURRENT_Config "Wheel_Diameter"] {Wheel_Diameter} ]} { # -- Wheel_Rear_Rim_Diameter not defined yet in prev. versions
								 set CURRENT_Config(_rattleCAD_Version)   1.00
							 }
						 }
					 }
				}
			}
		} else {
			 set CURRENT_Config(_rattleCAD_Version)   $::APPL_Env(RELEASE_Version)
		}
         
          # tk_messageBox -message "rattleCAD - Version:  $CURRENT_Config(_rattleCAD_Version)\n [array names CURRENT_Config]"
        ::Debug  t   "\n\n\n\n\n"
        ::Debug  t   "====================================================================="
        ::Debug  t   "\n"
        ::Debug  t   "      rattleCAD - Version   :    $CURRENT_Config(_rattleCAD_Version)    "
        ::Debug  t   "\n"
        
          
          # -- convert to _rattleCAD_Version ----        
             # set  CURRENT_Config()  $CURRENT_Config()

        if { $CURRENT_Config(_rattleCAD_Version) == 1.00 } {
 
             set  CURRENT_Config(TopTube_Diameter)              25.4  
             set  CURRENT_Config(HeadTube_Diameter)             31.8 
             set  CURRENT_Config(DownTube_Diameter)             28.6  
             set  CURRENT_Config(SeatTube_Diameter)             28.6  
             set  CURRENT_Config(TopTube_Diameter_SL)           25.4
             set  CURRENT_Config(SeatTube_Lug)                   5.0
             set  CURRENT_Config(SeatStay_Distance)             30.0
             set  CURRENT_Config(CrankArm_Length)              170.0
             set  CURRENT_Config(Comp_Fork_Heigth)             375.0
             set  CURRENT_Config(Comp_Fork_Rake)                40.0
             set  CURRENT_Config(Comp_Stem_Heigth)              25.0
             set  CURRENT_Config(Comp_Stem_Angle)                0.0
             set  CURRENT_Config(Comp_Stem_Length)             130.0
             set  CURRENT_Config(DownTube_BB_Diameter)          28.6
             set  CURRENT_Config(SeatTube_BB_Diameter)          28.6      
             set  CURRENT_Config(SeatStay_Diameter)             16.0
             set  CURRENT_Config(SeatStay_Diameter_2)           13.0
             set  CURRENT_Config(SeatStay_TaperLength)         300.0
             set  CURRENT_Config(ChainStay_Diameter)            29.0
             set  CURRENT_Config(ChainStay_Diameter_2)          14.0
             set  CURRENT_Config(ChainStay_TaperLength)        300.0       

             set  CURRENT_Config(Wheel_Rim_Diameter)           622.0
             set  CURRENT_Config(Comp_Wheel_Rim_Diameter)      622.0
             
             #set  CURRENT_Config(Wheel_Tyre_Height)             25.0
             #set  CURRENT_Config(Comp_Wheel_Tyre_Height)        25.0 
            
             set  CURRENT_Config(HandleBar_Type)            drop_bar
                          
             set  CURRENT_Config(Wheel_Tyre_Height)              [expr 0.5 * ($CURRENT_Config(Wheel_Diameter) - $CURRENT_Config(Wheel_Rim_Diameter) ) ]
             set  CURRENT_Config(Wheel_Rear_Rim_Diameter)        $CURRENT_Config(Wheel_Rim_Diameter)
             set  CURRENT_Config(Wheel_Front_Rim_Diameter)       $CURRENT_Config(Wheel_Rim_Diameter) 
             set  CURRENT_Config(Wheel_Rear_Tyre_Height)         $CURRENT_Config(Wheel_Tyre_Height) 
             set  CURRENT_Config(Wheel_Front_Tyre_Height)        $CURRENT_Config(Wheel_Tyre_Height) 
             

             set  CURRENT_Config(Comp_Wheel_Tyre_Height)         [expr 0.5 * ($CURRENT_Config(Comp_Wheel_Diameter) - $CURRENT_Config(Comp_Wheel_Rim_Diameter) ) ]             
             set  CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter)   $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
             set  CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)  $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
             set  CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)    $CURRENT_Config(Comp_Wheel_Tyre_Height) 
             set  CURRENT_Config(Comp_Wheel_Front_Tyre_Height)   $CURRENT_Config(Comp_Wheel_Tyre_Height) 
             
             set  CURRENT_Config(ChainStay_Length)               $CURRENT_Config(Chainstay_Length)  
             set  CURRENT_Config(TopTube_Pivot)                  $CURRENT_Config(InnerLeg_Length_x)             
             set  CURRENT_Config(BottomBracket_Height)           $CURRENT_Config(BottomBracket_Heigth)
                  array unset  CURRENT_Config  "Chainstay_Length"
                  array unset  CURRENT_Config  "InnerLeg_Length_x"
                  array unset  CURRENT_Config  "BottomBracket_Heigth"
        }
        
        if { $CURRENT_Config(_rattleCAD_Version) == 1.90 } {
             set  CURRENT_Config(Wheel_Rear_Rim_Diameter)        $CURRENT_Config(Wheel_Rim_Diameter)
             set  CURRENT_Config(Wheel_Front_Rim_Diameter)       $CURRENT_Config(Wheel_Rim_Diameter) 
             set  CURRENT_Config(Wheel_Rear_Tyre_Height)         $CURRENT_Config(Wheel_Tyre_Height) 
             set  CURRENT_Config(Wheel_Front_Tyre_Height)        $CURRENT_Config(Wheel_Tyre_Height) 
             set  CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter)   $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
             set  CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)  $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
             set  CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)    $CURRENT_Config(Comp_Wheel_Tyre_Height) 
             set  CURRENT_Config(Comp_Wheel_Front_Tyre_Height)   $CURRENT_Config(Comp_Wheel_Tyre_Height) 
             
             set  CURRENT_Config(BottomBracket_Height)           $CURRENT_Config(BottomBracket_Heigth)
                  array unset  CURRENT_Config  "BottomBracket_Heigth"
        }
        
        if { $CURRENT_Config(_rattleCAD_Version) == 2.00 } {
             set  CURRENT_Config(Wheel_Rim_Diameter)             $CURRENT_Config(Wheel_Rear_Rim_Diameter) 
             set  CURRENT_Config(Wheel_Tyre_Height)              $CURRENT_Config(Wheel_Rear_Tyre_Height) 
             set  CURRENT_Config(Comp_Wheel_Rim_Diameter)        $CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter) 
             set  CURRENT_Config(Comp_Wheel_Tyre_Height)         $CURRENT_Config(Comp_Wheel_Rear_Tyre_Height) 
            
             #set  CURRENT_Config(BottomBracket_Height)            $CURRENT_Config(BottomBracket_Heigth)
             #     array unset  CURRENT_Config  "BottomBracket_Heigth"
        }

        if { $CURRENT_Config(_rattleCAD_Version) <= 2.30 } {
			 set  CURRENT_Config(Fork_Type)                      {rigid} 
        }

        if { $CURRENT_Config(_rattleCAD_Version) <= 2.40 } {
			 set  CURRENT_Config(ForkCrown_Diameter)             $CURRENT_Config(HeadTube_Diameter) 
        }

        if { $CURRENT_Config(_rattleCAD_Version) <= 2.70 } {
			 # tk_messageBox -message " -> $CURRENT_Config(_rattleCAD_Version)"	
			 set  CURRENT_Config(ForkBlade_Width)             	 $CURRENT_Config(HeadTube_Diameter)  
        }


          # -- Wheel_Rear_Diameter --------------
        set geometry::CURRENT_Project(Wheel_Rear_Diameter)   [expr $CURRENT_Config(Wheel_Rear_Rim_Diameter) + 2*$CURRENT_Config(Wheel_Rear_Tyre_Height)]
  
    
           # -- BottomBracket_Depth -------------
        set CURRENT_Config(BottomBracket_Depth)    [expr 0.5*$geometry::CURRENT_Project(Wheel_Rear_Diameter) - $CURRENT_Config(BottomBracket_Height)] 
          # tk_messageBox -message " check_init_values:\nCURRENT_Config(BottomBracket_Depth)  $CURRENT_Config(BottomBracket_Depth)\nCURRENT_Config(BottomBracket_Height)  $CURRENT_Config(BottomBracket_Height)"
        
              
        
          # -- compute geometry -----------------
        if { $CURRENT_Config(_rattleCAD_Version) <= 2.00 } {
                geometry_2x::compute_bb_wheel_fork 
                geometry_2x::compute_frame_geometry
                geometry_2x::extend_value_to_22
                  
                array set geometry::CURRENT_Project  {}
                array set geometry::CURRENT_Project  [array get geometry_2x::CURRENT_Project]
                
                  # tk_messageBox -message "control::check_init_values  FileVersion: $CURRENT_Config(_rattleCAD_Version)  [array names  CURRENT_Config  {HeadTube_Length}]"

            } else {                
                control::update_parameter  force 
            }
   }
   
   
   #-------------------------------------------------------------------------
       #  open File Selection
       #
   proc openFile_Selection {{mode default}} {
        
          variable CURRENT_Config 
          variable USER_Dir     
          variable current_filename
          variable filetypes
       
        ::Debug  p  1
        
        get_user_dir

        while {true} {
       	    set fileName [tk_getOpenFile  -initialdir $USER_Dir  -filetypes  $filetypes ] 
       	    if {[string length $fileName] == 0} {
       	        break
       	    } elseif {[file exists $fileName] && [file readable $fileName]} {
       	        
                control::openFile $fileName
				control::update_filelist $fileName
				
				set current_filename      $fileName
              
                    ::Debug  t  "File: $current_filename"  1
       	        return
       	    } else {
       	        tk_messageBox -icon error -title "Read ERROR" \
       		      -message "File «$fileName» is not readable"
                    ::Debug  t  "File «$fileName» is not readable"  1
       	    }
        }
   
   }


   #-------------------------------------------------------------------------
       #  open File by name
       #
   proc openFile_FileList {} {  
		  variable  FILE_List_Widget
		  variable  USER_Dir
		  variable  current_filename
		  
		  set fileName [ $FILE_List_Widget get ]
		  set fileName [ file join $USER_Dir $fileName]
		  
		  control::openFile         $fileName
		  control::update_filelist  $fileName
		  
   	      set current_filename      $fileName

		  
		    # tk_messageBox -message " -> $fileName"	    
   }
   
   
   #-------------------------------------------------------------------------
       #  open File
       #
   proc openFile {fileName} {
        
          variable CURRENT_Config 
       
        ::Debug  p  1
        
		array unset CURRENT_Config

		control::read_configfile $fileName
		
		control::check_init_values
		control::update_parameter  {force}
		control::switch_canvas     {config}
		
		set current_filename $fileName
		::set_window_title "File: $current_filename ($CURRENT_Config(_rattleCAD_Version))"
		control::toggle_lock_attribute  {new_file}
		config::update_cfg_values
   }


   #-------------------------------------------------------------------------
       #  check values 
       #          
   proc check_values {par_name} {
   
          variable CURRENT_Config

        ::Debug  p 

        if {[string equal $par_name force]} return
          # tk_messageBox -message "check_values:   $par_name $CURRENT_Config($par_name)"
        
        switch -glob $par_name {
             *Tyre_Height \
                             {  if { $CURRENT_Config($par_name) < 0} { 
                                    set CURRENT_Config($par_name) 0.00
                                }
                                if {[string equal $par_name {Wheel_Tyre_Height}]} {
                                    set CURRENT_Config(Wheel_Front_Tyre_Height)        $CURRENT_Config(Wheel_Tyre_Height)
                                    set CURRENT_Config(Wheel_Rear_Tyre_Height)         $CURRENT_Config(Wheel_Tyre_Height)
                                    ::Debug  t    [format "   -> %-30s  %s"  Wheel_Front_Tyre_Height  $CURRENT_Config(Wheel_Front_Tyre_Height)]
                                    ::Debug  t    [format "   -> %-30s  %s"  Wheel_Rear_Tyre_Height   $CURRENT_Config(Wheel_Rear_Tyre_Height)]
                                } 
                                
                                if {[string equal $par_name {Comp_Wheel_Tyre_Height}]} { 
                                    set CURRENT_Config(Comp_Wheel_Front_Tyre_Height)   $CURRENT_Config(Comp_Wheel_Tyre_Height) 
                                    set CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)    $CURRENT_Config(Comp_Wheel_Tyre_Height) 
                                    ::Debug  t    [format "   -> %-30s  %s"  Comp_Wheel_Front_Tyre_Height  $CURRENT_Config(Comp_Wheel_Front_Tyre_Height)]
                                    ::Debug  t    [format "   -> %-30s  %s"  Comp_Wheel_Rear_Tyre_Height   $CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)]
                                } 
                             }
                          
             *Rim_Diameter \
                             {  if { $CURRENT_Config($par_name) < 0} { 
                                    set CURRENT_Config($par_name) 0.00
                                }
                                if {[string equal $par_name {Wheel_Rim_Diameter}]} {
                                    set CURRENT_Config(Wheel_Front_Rim_Diameter)       $CURRENT_Config(Wheel_Rim_Diameter) 
                                    set CURRENT_Config(Wheel_Rear_Rim_Diameter)        $CURRENT_Config(Wheel_Rim_Diameter) 
                                    ::Debug  t    [format "   -> %-30s  %s"  Wheel_Front_Rim_Diameter  $CURRENT_Config(Wheel_Front_Rim_Diameter)]
                                    ::Debug  t    [format "   -> %-30s  %s"  Wheel_Rear_Rim_Diameter   $CURRENT_Config(Wheel_Rear_Rim_Diameter)]
                                } 
                                
                                if {[string equal $par_name {Comp_Wheel_Rim_Diameter}]} { 
                                    set CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)  $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
                                    set CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter)   $CURRENT_Config(Comp_Wheel_Rim_Diameter) 
                                    ::Debug  t    [format "   -> %-30s  %s"  Comp_Wheel_Front_Rim_Diameter  $CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)]
                                    ::Debug  t    [format "   -> %-30s  %s"  Comp_Wheel_Rear_Rim_Diameter   $CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter)]
                                } 
                             }

             HeadsetBottom_Heigth \
                             {  if { $CURRENT_Config($par_name) < 0} { 
                                    set CURRENT_Config($par_name) 0.00
                                }
                             } 
							 
             ForkCrown_Diameter \
                             {  if { $CURRENT_Config($par_name) < 28} { 
                                    set CURRENT_Config($par_name) 28
                                }
                             } 
		}
 
   }
    
    
   #-------------------------------------------------------------------------
       #  update parameter
       #
   proc update_parameter {par_name} {

         variable CURRENT_Config 
         variable GUI_Config
         variable UPDATE_Parameter
         variable UPDATE_Changes
        
         ::Debug  p  1
         
         # -- compare variables of last update with the curren
       set do_update false
       
            # tk_messageBox -message "update_parameter: [array size CURRENT_Config] == [array size config::CURRENT_Config]"
       set UPDATE_Changes {}
          
       if { ! [string equal $par_name "force"] } {  
           foreach id [array names config::CURRENT_Config] {
               if {![string equal $config::CURRENT_Config($id) $CURRENT_Config($id)]} {
                    set UPDATE_Parameter  {true}
                    set UPDATE_Changes    [concat $UPDATE_Changes $id  $CURRENT_Config($id) ]
                    Debug t "\n\n           ->             $id:     $CURRENT_Config($id)  /  $config::CURRENT_Config($id) \n"
                          # tk_messageBox -message " change:   $id  $CURRENT_Config($id) vs. $config::CURRENT_Config($id)"
                    set CURRENT_Config($id)  $config::CURRENT_Config($id)
               }
           }
       }
       set GUI_METH_HTube  $GUI_Config(GUI_METH_HTube)
                      
       switch -glob $par_name {
            Comp_*  { set UPDATE_Parameter            "force"
                      set GUI_Config(GUI_METH_HTube)  "angle"
                        # tk_messageBox -message "$par_name $UPDATE_Parameter"
                    }
            force   { set UPDATE_Parameter            "force" 
                        # tk_messageBox -message "$par_name $UPDATE_Parameter"
                    }
            default {}
       }
       
       ::Debug t  "\n\n"

       switch $UPDATE_Parameter {
           false   { ::Debug t  "          ->type:   update not necessary"
                     # tk_messageBox -message "update_parameter: there was no change"
                     return
                   }
           force   { ::Debug t  "          ->type:   update is forced"
                     # tk_messageBox -message "update_parameter: force" 
                   }
           default { ::Debug t  "          ->type:   update required"
                     ::Debug t  "          ->reason:   $UPDATE_Changes"
                   }
       }

       ::Debug t  "\n\n"      
       
         # -- recompute wheel parameter ----------------------- geometry::CURRENT_Project
       check_values    $par_name       
         # -- compute   rearwheel frontwheel headtubeangle  --- geometry::CURRENT_Project
       geometry::compute_bb_wheel_headtube  $par_name
         # -- compute frame geometry  ------------------------- geometry::CURRENT_Project
       geometry::compute_frame_geometry
         # -- compute replace geometry ------------------------ geometry::CURRENT_Replace
       geometry::compute_replace_geometry

         # -- format values of project parameters
       format_project_values 
       
         # -- update config::CURRENT_Config
       config::update_cfg_values 

         # -- reset GUI_Config(GUI_METH_HTube)
       set GUI_Config(GUI_METH_HTube)  $GUI_METH_HTube

         # -- report current project
       foreach id [lsort [array names CURRENT_Config]] {
             ::Debug  t    [format "  %-45s  %s"  CURRENT_Config($id)  $CURRENT_Config($id)]
       }
       
       
         # -- update graph
         ::Debug t "\n  --------------------------\n  update_graph  $control::FRAME_Config_Mode\n\n"
       update_graph

   }


       #-------------------------------------------------------------------------
       #  update graph
       #
   proc update_graph {{mode mode}} {
       
       variable FRAME_Config_Mode
       global   _CURRENT_Project

       ::Debug  p 
        
       if {[string equal $FRAME_Config_Mode {wait}]} return
       
         #  set FRAME_Config_Mode $mode
         #  tk_messageBox -message "   control::update_graph  $FRAME_Config_Mode" 

       switch $FRAME_Config_Mode {
                 frame_design -
                 replace_component { design::create  $::design_widget }
                 frame_detail      { detail::create  $::detail_widget }
                 _no_action        { after 50 }
                 default           { tk_messageBox -message "control::update_graph  -default  $FRAME_Config_Mode " }
       } 
   }


       #-------------------------------------------------------------------------
       #  format project-values
       #
   proc format_project_values {} {
       
         variable CURRENT_Config
       
       ::Debug  p 
       
         # tk_messageBox -message "format_project_values  $CURRENT_Project(Parameter_InitList)"
       foreach id [array names CURRENT_Config] {
          switch $id {
              HandleBar_Type {}
              Fork_Type      {}
              default { set CURRENT_Config($id) [format "%.2f" $CURRENT_Config($id)]}
          }
       }
   }
 

   #-------------------------------------------------------------------------
       #  switch_frame_display
       #
   proc switch_frame_display {} {
        
        variable GUI_Config
        variable FRAME_Display_Values
        variable FRAME_Display_Direction
        
        set current_index [lsearch $FRAME_Display_Values $GUI_Config(GUI_FRAME_Display)]
          # tk_messageBox -message " switch_frame_display:  $GUI_Config(GUI_FRAME_Display)  /  $FRAME_Display_Values / $current_index" 
        
        if {[string equal $FRAME_Display_Direction "plus"]} {
            set new_index [ expr $current_index + 1 ]
            if {$new_index == [llength $FRAME_Display_Values]} {
                set FRAME_Display_Direction "minus"
                set new_index [ expr $new_index - 2]
            }        
        } else {
            set new_index [ expr $current_index - 1 ]
            if {$new_index < 0} {                
                set FRAME_Display_Direction "plus"
                set new_index [ expr $new_index + 2]
            }
        }
        
          # tk_messageBox -message " switch_frame_display:  $new_index / $current_index" 
        
        set GUI_Config(GUI_FRAME_Display) [lindex $FRAME_Display_Values $new_index]
        
          # tk_messageBox -message " switch_frame_display:  $new_index / $current_index / $GUI_Config(GUI_FRAME_Display)" 
 
        design::create           $::design_widget

   }
   
   
   #-------------------------------------------------------------------------
       #  switch_canvas
       #
   proc switch_canvas { cfg_mode } {
         
          variable  Last_Mode  
          variable  Current_Mode
          variable  FRAME_Config_Mode

        ::Debug  p  
        
        global _CURRENT_Project
        # set    CURRENT_Project(Parameter_InitList) {}

        switch $cfg_mode {
             replace  -
             config   { set mode frame_design
                        switch_page::showframe   $::DESIGN_Frame
                        switch $cfg_mode {
                            config  { set FRAME_Config_Mode  frame_design      }
                            replace { set FRAME_Config_Mode  replace_component }
                        }
                        design::create           $::design_widget 
                        update
                        ::gui_button  resize_canvas
                        design::create           $::design_widget  
                        # config::create           $config::CONFIG_Window
                        Debug  t  "switch_design:   design::create       $::design_widget "
                        set Last_Mode $cfg_mode
                      }
             detail   { set mode frame_detail
			            set FRAME_Config_Mode    $mode              ;# 2008.07.04 to update_graph on press enter
                        switch_page::showframe   $::DETAIL_Frame
                        detail::create           $::detail_widget 
                        update
                        detail::resize           $::detail_widget
                        Debug  t  "switch_detail:   detail::create       $::detail_widget "
                        set Last_Mode $cfg_mode
                      }
             drafting { switch_page::showframe   $::DRAFTING_Frame
                        drafting::create         $::draft_widget 
                        config::create           $config::CONFIG_Window
                          Debug  t  "switch_drafting:  drafting::create      $::draft_widget " 
                        set Last_Mode $cfg_mode                          
                      }    
             preview  { if {[string equal  $Current_Mode {preview} ]} {
                              # tk_messageBox -message "switch back  $Current_Mode  $Last_Mode "
                            set Current_Mode {}
                            switch_canvas  $Last_Mode 
                            return
                        } 
                        switch_page::showframe   $::COMPLETE_Frame
                        preview::create          $::preview_widget 
                        Debug  t  "switch_drafting:  drafting::create      $::preview_widget "
                        set Current_Mode $cfg_mode                          
                      }             
       
             default {}
        }                

   }
   

   #-------------------------------------------------------------------------
       #  reset replace to global values 
       #
   proc toggle_config_replace {} {
          
          #variable   FRAME_Config_Mode
          
        ::Debug  p
        ::Debug  t  "    \$control::FRAME_Config_Mode   $control::FRAME_Config_Mode"

        switch $control::FRAME_Config_Mode {
                 replace_component {set control::FRAME_Config_Mode frame_design}
                 frame_design      {set control::FRAME_Config_Mode replace_component}
                 default           {set control::FRAME_Config_Mode replace_component}
        }

        ::Debug  t  "    \$control::FRAME_Config_Mode   $control::FRAME_Config_Mode"
        design::create  $::design_widget  
   }


   #-------------------------------------------------------------------------
       #  toggle lock-attribute
       #
   proc toggle_lock_attribute {{refer config}} {
        
          variable GUI_Config
          
        ::Debug  p  1
        
        global  _APPL_Config 
		global  _CURRENT_Project  
        
        if {![winfo exists $config::CONFIG_Window]} {return}
        
		  # -------------
		  
        if {! [string equal $refer {config}] } {
        
             if {$control::CURRENT_Config(Wheel_Rear_Rim_Diameter) == $control::CURRENT_Config(Wheel_Front_Rim_Diameter)} \
                       { set GUI_Config(GUI_LOCK_config_Rim)      lock 
                } else { set GUI_Config(GUI_LOCK_config_Rim)    unlock }
             
             if {$control::CURRENT_Config(Wheel_Rear_Tyre_Height)  == $control::CURRENT_Config(Wheel_Front_Tyre_Height) } \
                       { set GUI_Config(GUI_LOCK_config_Tyre)     lock 
                } else { set GUI_Config(GUI_LOCK_config_Tyre)   unlock }
        
             if {$control::CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter) == $control::CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)} \
                       { set GUI_Config(GUI_LOCK_replace_Rim)     lock 
                } else { set GUI_Config(GUI_LOCK_replace_Rim)   unlock }
                
             if {$control::CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)  == $control::CURRENT_Config(Comp_Wheel_Front_Tyre_Height) } \
                       { set GUI_Config(GUI_LOCK_replace_Tyre)    lock 
                } else { set GUI_Config(GUI_LOCK_replace_Tyre)  unlock }
           }
           
        
        set widget_path(config)     $config::Config_Widget.param 
        set widget_path(replace)    $config::Replace_Widget.param 

        destroy $config::CONFIG_Notebook
        config::create_content
        control::format_project_values        
        
          # tk_messageBox -message " action_rim  $action_rim || action_tyre $action_tyre"
          # tk_messageBox -message " $widget_path(config)  ||  $widget_path(replace)     "

        foreach  nb_tab {config replace} \
           {
             eval   [ format "set rim_status  \$GUI_Config(GUI_LOCK_%s_Rim)"  $nb_tab]
             eval   [ format "set tyre_status \$GUI_Config(GUI_LOCK_%s_Tyre)" $nb_tab]
             
             if {[string equal $rim_status  "lock"]} {
                   destroy $widget_path($nb_tab).f_Wheel_Rear_Rim_Diameter
                   destroy $widget_path($nb_tab).f_Wheel_Front_Rim_Diameter 
                   switch $nb_tab {
                       config  { set control::CURRENT_Config(Wheel_Front_Rim_Diameter)       $control::CURRENT_Config(Wheel_Rear_Rim_Diameter) 
                                 set control::CURRENT_Config(Wheel_Rim_Diameter)             $control::CURRENT_Config(Wheel_Rear_Rim_Diameter) 
                               }
                       replace { set control::CURRENT_Config(Comp_Wheel_Front_Rim_Diameter)  $control::CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter) 
                                 set control::CURRENT_Config(Comp_Wheel_Rim_Diameter)        $control::CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter) 
                               }
                   }
                   
                } else {
                   destroy $widget_path($nb_tab).f_Wheel_Rim_Diameter
                }      

             if {[string equal $tyre_status  "lock"]} {
                   destroy $widget_path($nb_tab).f_Wheel_Rear_Tyre_Height
                   destroy $widget_path($nb_tab).f_Wheel_Front_Tyre_Height 
                   switch $nb_tab {
                       config  { set control::CURRENT_Config(Wheel_Front_Tyre_Height)       $control::CURRENT_Config(Wheel_Rear_Tyre_Height) 
                                 set control::CURRENT_Config(Wheel_Tyre_Height)             $control::CURRENT_Config(Wheel_Rear_Tyre_Height) 
                               }
                       replace { set control::CURRENT_Config(Comp_Wheel_Front_Tyre_Height)  $control::CURRENT_Config(Comp_Wheel_Rear_Tyre_Height) 
                                 set control::CURRENT_Config(Comp_Wheel_Tyre_Height)        $control::CURRENT_Config(Comp_Wheel_Rear_Tyre_Height) 
                               }
                   }
                   
                } else {
                   destroy $widget_path($nb_tab).f_Wheel_Tyre_Height
                }      

             if {![string equal $rim_status  "lock"]} {
                if {[string equal $tyre_status  "lock"]} {
                      pack $widget_path($nb_tab).f_Wheel_Tyre_Height  -after $widget_path($nb_tab).f_Wheel_Front_Rim_Diameter
                   }
                }
           }
           
           
        foreach  nb_tab {config replace} \
           {
             eval   [ format "set rim_status  \$GUI_Config(GUI_LOCK_%s_Rim)"  $nb_tab]
             eval   [ format "set tyre_status \$GUI_Config(GUI_LOCK_%s_Tyre)" $nb_tab]
             
             switch $nb_tab {
                  config  { 
                          }
                  replace {
                          }
             }
           }      
             

        if {[string equal $GUI_Config(GUI_METH_BBracket)  "height"]} {
                   destroy $widget_path(config).f_BottomBracket_Depth
           } else {
                   destroy $widget_path(config).f_BottomBracket_Height
           }

        if {[string equal $GUI_Config(GUI_METH_HTube)  "angle"]} {
                   destroy $widget_path(config).f_HandleBar_Distance
                   destroy $widget_path(config).f_HandleBar_Height
           } else {
                   destroy $widget_path(config).f_HeadTube_Angle
                   destroy $widget_path(config).f_Stem_Heigth
           }
      
        config::resize
        
          # control::update_graph 

   } 


   #-------------------------------------------------------------------------
       #  reset replace to config values 
       #
   proc reset_replace_to_config {} {
          
          variable CURRENT_Config
          variable FRAME_Config_Mode
          
        ::Debug  p

        foreach id { Wheel_Front_Rim_Diameter    
                     Wheel_Front_Tyre_Height
                     Wheel_Rear_Rim_Diameter    
                     Wheel_Rear_Tyre_Height   
                     Fork_Heigth         Fork_Rake
                     Stem_Heigth         Stem_Angle          Stem_Length
                   } {
		     eval set CURRENT_Config(Comp_$id)  \$CURRENT_Config($id) 
		     ::Debug  t "CURRENT_Config(Comp_$id)  $CURRENT_Config($id)"
        }
        
        set CURRENT_Config(Comp_Wheel_Rim_Diameter)       $CURRENT_Config(Wheel_Rim_Diameter)
        set CURRENT_Config(Comp_Wheel_Tyre_Height)        $CURRENT_Config(Wheel_Tyre_Height)
        
          # array unset geometry::CURRENT_Replace 
        array set   geometry::CURRENT_Replace  [array get geometry::CURRENT_Project]
        
          # tk_messageBox -message "reset_replace_to_config"
        config::update_cfg_values
        
        set FRAME_Config_Mode   replace_component
        
        update_parameter        {force}
          # update_parameter        Comp_Stem_Heigth
          # update_graph
          # tk_messageBox -message " $CURRENT_Config(Stem_Heigth)  $CURRENT_Config(Stem_Heigth)"
   }   
   

   #-------------------------------------------------------------------------
       #  get user directory
       #
   proc get_user_dir {} {
        variable install_dir
        variable USER_Dir
       
        ::Debug  p  1

        ::Debug  t  "install_dir  $install_dir"  1
        ::Debug  t  "USER_Dir     $USER_Dir"     1
   
        set search_dir [file join [file dirname $install_dir] user]
        ::Debug  t  "dirname      [file dirname $install_dir]"  1
        ::Debug  t  "search_dir   $search_dir"  1
       
        if {[file exists $search_dir]} {
            if {[file isdirectory $search_dir]} {
                set USER_Dir $search_dir
                ::Debug  t  "search_dir   $search_dir" 
            } else {
                tk_messageBox -title   "Config ERROR" \
                              -icon    error \
                              -message "There is af file \n   ... $search_dir\n     should be ad directory\n\n  ... please remove file"
                return
            }
        } else {
            file mkdir $search_dir
        }
       
        ::set_window_title "File: $USER_Dir"
        
        return $USER_Dir
   }
   
      	 
   #-------------------------------------------------------------------------
       #  save File
       #
   proc saveFile {} {
      
        variable USER_Dir     
   	    variable current_filename
   	     
	    ::Debug  p  1

	   	get_user_dir
	   	set current_filename [control::write_configfile]

		if {$current_filename != ""} {
			control::update_filelist $current_filename
		}
	    ::set_window_title "File: $current_filename"
	   	::Debug  t  "current_filename  $current_filename" 1
   }


   #-------------------------------------------------------------------------
       #  reset to template 
       #
   proc template_to_design {type} {
          
          variable USER_Template
          variable FRAME_Config_Mode
          variable TEMPLATE_Road  
          variable TEMPLATE_OffRoad           
          variable CURRENT_Config 
          
      ::Debug  p

      set USER_Template(type) $type
      set templName [format "TEMPLATE_%s"  $USER_Template(type)]
        # tk_messageBox -message "template_to_design :  $templName"     
      
      array set   CURRENT_Config  [array get $templName]
      
      control::format_project_values
      config::update_cfg_values
      control::update_parameter  {force}
      control::switch_canvas     {config}

      ::set_window_title  $templName
      ::Debug  t  "$::design_widget  $FRAME_Config_Mode " 1
      
      return

   }


   #-------------------------------------------------------------------------
       #  read from user defined templates 
       #
   proc read_user_templates {} {

          variable USER_Template
          
        ::Debug  p

        set    USER_Template_dir       [control::get_user_dir]
        set    USER_Template(road)     [file join  $USER_Template_dir  _user_road.tmpl]
        set    USER_Template(offroad)  [file join  $USER_Template_dir  _user_offroad.tmpl]

        # -- road -------
        if {[file isfile $USER_Template(road)] && [file readable $USER_Template(road)]} {
            ::Debug  t  "USER_Template(road)   $USER_Template(road)"
            source $USER_Template(road)
        } else {
            ::Debug  t  "<E> USER_Template(road)   $USER_Template(road)  does not exist"
        }
  
        # -- offroad ----
        if {[file isfile $USER_Template(offroad)] && [file readable $USER_Template(offroad)]} {
            ::Debug  t  "USER_Template(offroad)   $USER_Template(offroad)"
            source $USER_Template(offroad)
        } else {
            ::Debug  t  "<E> USER_Template(offroad)   $USER_Template(offroad)  does not exist"
        }

        # -- error - handling from old versions ----
        set check_value [::GetConfig FRAME_Config  road  ChainStay_Length]
        if {$check_value != {} } {
               # tk_messageBox -message "  -> leer \$check_value   $check_value"
            ::SetConfig FRAME_Config  road  ChainStay_Length $check_value
            ::DelConfig FRAME_Config  road  ChainStay_Length 
        } 
   }
   
   
   #-------------------------------------------------------------------------
       #  write user defined templates 
       #
   proc write_user_template {} {

          global   _CURRENT_Project
          variable USER_Template
          variable TEMPLATE_Road  
          variable TEMPLATE_OffRoad           
          variable CURRENT_Config
          
        ::Debug  p
        
        ::Debug  t  "USER_Template(type)   $USER_Template(type)"
        ::Debug  t  "USER_Template($USER_Template(type))   $USER_Template($USER_Template(type))"
        
        ::Debug  a  CURRENT_Config
        
       	set fileName  $USER_Template($USER_Template(type)) 
       	
       	  # -- create template-file content
          #
        set fileContent  {}
        set fileContent  "!$USER_Template(type)"  
        set output       [format "%s;%s;"  HandleBar_Type  $control::CURRENT_Config(HandleBar_Type)] 
	    set fileContent  [concat $fileContent\n$output]
        set output       [format "%s;%s;"  Fork_Type       $control::CURRENT_Config(Fork_Type)] 
	    set fileContent  [concat $fileContent\n$output]
        
        foreach id [lsort [array names control::CURRENT_Config]] {
            switch $id {
                HandleBar_Type {}
				Fork_Type      {}
                default {
                    set output    [format "%s;%s;"  $id  $control::CURRENT_Config($id)]               
                    ::Debug  t "output  $output "
                    set fileContent  [concat $fileContent\n$output]
                    }
            }
        }

          # -- write to Config
          #
        set templName [format "TEMPLATE_%s"  $USER_Template(type)]
        array set $templName {}
        array set $templName [array get CURRENT_Config]         
                   
       	  # -- file - handling
          #
        if {[file exists $fileName] } {
       	    file delete -force $fileName
       	}
   	
        if {[catch { set fd [open $fileName w] } err]} {
            set antwort [tk_messageBox -type    retrycancel \
		                       -icon    error \
		                       -title   "ERROR" \
		                       -message "An ERROR occured during save operation:\n$err"]
            if {[string match "cancel" $antwort]} {
                return
	        }
        } 

       	  # -- write to file
          #
        puts   $fd $fileContent
        close  $fd       
        return $fileName
   }
   

   #-------------------------------------------------------------------------
       #  read current config from id 
       #
   proc read_configfile {fileName} {

        variable CURRENT_Config
        variable FILE_Attr
        
        ::Debug  p  1
        
        set fd [open $fileName r]
        
        array unset CURRENT_Config
        
        while {![eof $fd]} {
	         set line [gets $fd]
	         if {![string equal [string index $line 0] {!}]} {
	              set value [ split $line ";" ]
	              set v_name  [lindex $value 0]
	              regsub -all {,} [lindex $value 1] {\.} v_value
	              catch { eval [format "set CURRENT_Config(%s) %s"  $v_name $v_value]}
	              ::Debug t "    -> CURRENT_Config($v_name) $v_value"
	         } else {
	                # tk_messageBox -message " $line"
	              set line    [string trim [string range $line 1 end] ]
	              set value   [split  $line ";"]
	              set v_name  [lindex $value 0]
	              set v_value [lindex $value 1]
	              switch $v_name {
	                   rattleCAD { ::Debug t "\n\n  -> rattleCAD <- \n\n "}
	                          {} {}
	                     default {   # tk_messageBox -message " $line   /  $v_name  $v_value"
	                               catch { eval [format "set FILE_Attr(%s) %s"  $v_name $v_value]}
	                                 # tk_messageBox -message " $FILE_Attr($v_name)"
	                             }
	              }
	         }
        }
        close $fd
        
          # tk_messageBox -message "read_configfile: \n [array names control::CURRENT_Config]"   
   }		


   #-------------------------------------------------------------------------
       #  write current config to file
       #
   proc write_configfile {} {

         global   APPL_Env

        ::Debug  p  1

        while {true} {
            set fileName [tk_getSaveFile  -initialdir        $control::USER_Dir  \
                                          -initialfile       $control::current_filename  \
                                          -filetypes         $control::filetypes \
                                          -defaultextension  $control::default_type ]
                                              
              # tk_messageBox -message " ->$fileName<"
			if {$fileName == "" } {
                  return ""
            } elseif {
                  [catch { set fd [open $fileName w] } err]} {
                  set antwort [tk_messageBox -type retrycancel \
                                -icon     error \
                                -title   "ERROR" \
                                -message "An ERROR occured during file open operation:\n$err"]
                  if {[string match "cancel" $antwort]} {
					  break
                  }
                  return ""
            } 
    		  
            set fileContent  {}
            set fileContent                        "! rattleCAD; " 
            set fileContent  [concat $fileContent\n[format "! Version; %s.%s;" $APPL_Env(RELEASE_Version) $APPL_Env(RELEASE_Revision)] ]
    	    set fileContent  [concat $fileContent\n[format "! Date;    2008.02.21/01:21;" ] ]
    	    set fileContent  [concat $fileContent\n"!" ]
    	    set fileContent  [concat $fileContent\n[format "%s;%s;"  HandleBar_Type  $control::CURRENT_Config(HandleBar_Type)]]
    	    set fileContent  [concat $fileContent\n[format "%s;%s;"  Fork_Type       $control::CURRENT_Config(Fork_Type)     ]]

            foreach id [lsort [array names control::CURRENT_Config]] {
                switch $id {
                    HandleBar_Type {}
                    Fork_Type      {}
                    default {
                         # tk_messageBox -message "$id"
                        set output    [format "%s;%s;"  $id  $control::CURRENT_Config($id)]               
                        ::Debug  t "output  $output "
                        set fileContent  [concat $fileContent\n$output]
                           # puts $fd $output
                        }
                }
            }
            
            ::Debug  t "$fileContent"
            
            puts   $fd  $fileContent 
            close $fd
            return $fileName               
        }
   } 


   #-------------------------------------------------------------------------
       #  manage user-settings:  language, font, ...
       #
   proc user_settings {{mode read} } {
  
        variable  USER_Dir
      
      Debug  p
      
      global APPL_Env APPL_Config
      
        # tk_messageBox -message " $APPL_Env(USER_Dir)" 
      
      set APPL_Env(USER_Init) [file join $USER_Dir _user.init]
      
        # tk_messageBox -message " user_init:  File:  $APPL_Env(USER_Init)" 
      
      switch $mode {
          
          read    { if {[file readable $APPL_Env(USER_Init)]} {
                           catch {source $APPL_Env(USER_Init)} err
                             # tk_messageBox -message " source $APPL_Env(USER_Init)\n $::APPL_Config(Language)\n $APPL_Config(GUI_Font)" 
                             set control::FILE_List $APPL_Config(FILE_List)
					   } else {
                             # tk_messageBox -message " no $APPL_Env(USER_Init)" 
                       }
                    return
                  }
          
          write   { if { [catch { set fd [open $APPL_Env(USER_Init) w ] } err ]} {
	                   set antwort [tk_messageBox -type retrycancel \
		                              -icon     error \
		                              -title   "ERROR: USER Settings" \
		                              -message "An ERROR occured during create operation:\n$err"]
	                   if {[string match "cancel" $antwort]} {
		               return
	                   }
	                } else {
                         # tk_messageBox -message  " passt eh:  $APPL_Env(USER_Init)!"
                    }
		  
                    puts  $fd "set APPL_Config(Language)        \{[string trim $::Language(____current) {_}]\}"
                    puts  $fd "set APPL_Config(GUI_Font)        \{$::APPL_Config(GUI_Font)\}"
					puts  $fd "set APPL_Config(Window_Position) \{[get_w_geometry .]\}"
					puts  $fd "set APPL_Config(FILE_List)       \{$control::FILE_List\}"
        	    
                    close $fd
                    return 
                  }
          
          reset   { catch {file delete $APPL_Env(USER_Init)}
                  }
          
          default {}
      
      }
      
   }
  
  
   #-------------------------------------------------------------------------
       #  manage content of FILE_List
       #
   proc update_filelist {fileName} {  
		  variable  FILE_List
		  variable  FILE_List_Widget
		  variable  USER_Dir
		  
		  set list_length  5
		  
		    # -- get only the string after USER_Dir
		  if {[string match $USER_Dir* $fileName]} {
				set file_name [string range $fileName [expr 1 + [string length $USER_Dir]]  end]
		  }
		  
		    # -- remove entry in list, if allready existing ...
		  set recent_ind [lsearch  -exact   $FILE_List  $file_name ]
		  if { $recent_ind >= 0 } { 
		      set FILE_List [lreplace $FILE_List $recent_ind $recent_ind]
		  }
		  
		    # -- add filename in front of list ...
		  set FILE_List [linsert  $FILE_List  0  $file_name]
		  
		    # -- if list longer then  $list_length ...
		  if { [llength $FILE_List] > $list_length } {
		      set FILE_List [lreplace $FILE_List  $list_length  end]
	      }
		    
			# -- update the Combobox ...
		  $FILE_List_Widget  configure  -values $FILE_List		  
		  $FILE_List_Widget  setvalue   first
   }
  
  


}

