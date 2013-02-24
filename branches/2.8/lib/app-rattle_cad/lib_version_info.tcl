# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval version_info {
 

   
   #-------------------------------------------------------------------------
       #  create_config_design
       #
   proc create { w } {
         
        ::Debug  p  
        
        global APPL_Env APPL_Config


        if {[winfo exists $w]} {
          wm deiconify  $w
             Debug t "$w allready exists"  1
          return
        }
        
        set widget_font {-*-Courier-Medium-R-Normal--*-120-*-*-*-*-*-*}

        toplevel       $w
        wm  title      $w  "Info Panel:    rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)"
          ;# wm  transient  $w  .
 
        set   INFO_Notebook     [ NoteBook    $w.nb]
        pack $INFO_Notebook     -expand true -fill both 
        

        ;# =======================================================================
          ;# -- version_intro -----------
          ;#
        set version_intro      [ $INFO_Notebook insert end intro \
                                           -text      "Intro" ]
                                           
             ;# -- intro image ----------
        set version_intro_content [::create_intro  $version_intro  content ]
          ;# wm  resizable  $w  0 0
        
             
             
        ;# =======================================================================
          ;# -- version_env -------------
          ;#
        set version_env        [ $INFO_Notebook insert end environment \
                                           -text      "Environment" ]
             ;# -- text -----------------
        pack [set sw_env       [ ScrolledWindow $version_env.sw] ] -fill both  -expand 1 

        set env_text           [ text $sw_env.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $widget_font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_env setwidget $sw_env.text
                                           
             
             
        ;# =======================================================================
          ;# -- project_cfg -------------
          ;#
        set project_cfg        [ $INFO_Notebook insert end project \
                                           -text      "Project" ]
             ;# -- text -----------------
        pack [set sw_prj       [ ScrolledWindow $project_cfg.sw] ] -fill both  -expand 1 

        set prj_text           [ text $sw_prj.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $widget_font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_prj setwidget $sw_prj.text
                                           
             
             
        ;# =======================================================================
          ;# -- version_license ---------
          ;#
        set version_license    [ $INFO_Notebook insert end license \
                                           -text      "License" ]
             ;# -- text -----------------
        pack [set sw_lic       [ ScrolledWindow $version_license.sw] ] -fill both  -expand 1 

        set lic_text           [ text $sw_lic.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $widget_font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_lic setwidget $sw_lic.text



        ;# =======================================================================
          ;# -- insert into version_env -------------
          ;#
        $env_text  insert end "\n\n"
        $env_text  insert end "  ====================================================\n"
        $env_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $env_text  insert end "  ====================================================\n"
        $env_text  insert end "\n\n"
        $env_text  insert end "   Version:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "     Version:        $APPL_Env(RELEASE_Version)\n"
        $env_text  insert end "     Revision:       $APPL_Env(RELEASE_Revision)\n"
        $env_text  insert end "     Release Date:   $APPL_Env(RELEASE_Date)\n"
        $env_text  insert end "\n\n"
        $env_text  insert end "   Environment:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
        $env_text  insert end "     APPL_Env(ROOT_Dir):      $APPL_Env(ROOT_Dir)\n"
        $env_text  insert end "     APPL_Env(BASE_Dir):      $APPL_Env(BASE_Dir)\n"
        $env_text  insert end "     APPL_Env(CONFIG_Dir):    $APPL_Env(CONFIG_Dir)\n"
        $env_text  insert end "     APPL_Env(IMAGE_Dir):     $APPL_Env(IMAGE_Dir)\n"
        $env_text  insert end "     APPL_Env(USER_Dir):      $APPL_Env(USER_Dir)\n"
        $env_text  insert end "\n"
        $env_text  insert end "     APPL_Env(USER_Init):     $APPL_Env(USER_Init)\n"
        $env_text  insert end "\n"
        $env_text  insert end "\n\n"
        $env_text  insert end "     APPL_Env(CONFIG_Window):    $APPL_Env(CONFIG_Window)\n"
        $env_text  insert end "     APPL_Env(CONFIG_Notebook):  $APPL_Env(CONFIG_Notebook)\n"
        $env_text  insert end "     APPL_Env(TUBEMITER_Window): $APPL_Env(TUBEMITER_Window)\n"
        $env_text  insert end "\n\n"
        $env_text  insert end "   Packages:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
        $env_text  insert end "     \$::vectorfont::font_dir  $::vectorfont::font_dir  "
        $env_text  insert end "\n\n\n\n"
        $env_text  insert end "   others:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n\n\n"
        
        

        $env_text  insert end "     config::Language\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
        foreach value [lsort $config::Language_Command] \
          {
        $env_text  insert end "          $value\n"
          }
        $env_text  insert end "\n\n\n"
		  
        $env_text  insert end "     APPL_Config(Window_Position)\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
		$env_text  insert end "          current:      [get_w_geometry .]\n"
		$env_text  insert end "          user-setting: $APPL_Config(Window_Position)\n"
        $env_text  insert end "\n\n\n"
		  
        $env_text  insert end "     $control::FILE_List\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
        foreach value $control::FILE_List \
          {
        $env_text  insert end "          $value\n"
          }
		  
        $env_text  insert end "\n\n"



        ;# =======================================================================
          ;# -- insert into current Project ---------
          ;#
        $prj_text  insert end "\n\n"
        $prj_text  insert end "  ====================================================\n"
        $prj_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $prj_text  insert end "  ====================================================\n"
        $prj_text  insert end "\n\n"
        $prj_text  insert end "    current Project\n"
        $prj_text  insert end "  ----------------------------------------------------\n"
        $prj_text  insert end "\n"
        $prj_text  insert end "       $APPL_Config(PROJECT_Name)\n"
        $prj_text  insert end "\n"
        
        
        $prj_text  insert end "  ------- control::CURRENT_Config\n"
        $prj_text  insert end "\n"
        foreach id [lsort [array names control::CURRENT_Config]] \
          {
        $prj_text  insert end [format "          %-30s   %10s\n"  $id $control::CURRENT_Config($id)]
          }
        
        
        $prj_text  insert end "\n\n"        
        $prj_text  insert end "  ------- geometry::CURRENT_Project\n"
        $prj_text  insert end "\n"
        foreach id [lsort [array names geometry::CURRENT_Project]] \
          {
        $prj_text  insert end [format "          %-30s   %s\n"    $id $geometry::CURRENT_Project($id)]
          }

        
        $prj_text  insert end "\n\n"
        $prj_text  insert end "  ------- geometry::CURRENT_Replace\n"
        $prj_text  insert end "\n"
        foreach id [lsort [array names geometry::CURRENT_Replace]] \
          {
        $prj_text  insert end [format "          %-30s   %10s\n"  $id $geometry::CURRENT_Replace($id)]
          }
        
        
        $prj_text  insert end "\n\n"

       


        ;# =======================================================================
          ;# -- insert into version_license ---------
          ;#
        $lic_text  insert end "\n\n"
        $lic_text  insert end "  ====================================================\n"
        $lic_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $lic_text  insert end "  ====================================================\n"
        $lic_text  insert end ""
        
        set fd [open [file join [file dirname $::APPL_Env(CONFIG_Dir)] license.txt] r]
        while {![eof $fd]} {
	         set line [gets $fd]
	         $lic_text  insert end "    $line\n"
        }
        close $fd

        $lic_text  insert end "\n\n"
        

                               
        $version_intro         configure  -borderwidth 2 
        $version_env           configure  -borderwidth 2 
        $project_cfg           configure  -borderwidth 2
        $version_license       configure  -borderwidth 2 

        $INFO_Notebook         raise [ $INFO_Notebook page 0 ]
        
        return $INFO_Notebook
   }
   
   

     #-------------------------------------------------------------------------
     #
     #  end  namespace eval version_info 
     #

 }
  
