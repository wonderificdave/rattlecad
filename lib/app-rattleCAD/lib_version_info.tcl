 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_version_info.tcl
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
 #	namespace:  rattleCAD::version_info
 # ---------------------------------------------------------------------------
 #
 # 
 namespace eval version_info {
 

   
   #-------------------------------------------------------------------------
       #  create_config_design
       #
   proc create { w {tab 0}} {
        
		 global APPL_Env APPL_Config


        if {[winfo exists $w]} {
			wm deiconify  $w
			$w.nb	raise [ $w.nb page $tab ]
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
        set version_intro_content [::create_intro  $version_intro  content  30]
          ;# wm  resizable  $w  0 0
        
             
             
        ;# =======================================================================
          ;# -- version_help-------------
          ;#
        set version_help        [ $INFO_Notebook insert end help \
                                           -text      "Help" ]
             ;# -- text -----------------
        pack [set sw_help       [ ScrolledWindow $version_help.sw] ] -fill both  -expand 1 

        set help_text           [ text $sw_help.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $widget_font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_help setwidget $sw_help.text
                                           
             
             
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
          ;# -- version_exclusion ---------
          ;#
        set version_exclusion    [ $INFO_Notebook insert end exclusion \
                                           -text      "Exclusion" ]
             ;# -- text -----------------
        pack [set sw_excl      [ ScrolledWindow $version_exclusion.sw] ] -fill both  -expand 1 

        set excl_text          [ text $sw_excl.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $widget_font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_excl setwidget $sw_excl.text



        ;# =======================================================================
          ;# -- insert into version_env -------------
          ;#
        $env_text  insert end "\n\n"
        $env_text  insert end "  ====================================================\n"
        $env_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $env_text  insert end "  ====================================================\n"
		$env_text  insert end "\n\n"
        $env_text  insert end "   Runtime:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "     Tcl/Tk:         [info patchlevel]\n"
        $env_text  insert end "     Exec:             [info nameofexecutable]\n"
 		$env_text  insert end "\n"
		$env_text  insert end "       Tk:             [package require Tk]\n"
		$env_text  insert end "       BWidget:        [package require BWidget]\n"
		$env_text  insert end "       rattleCAD:      [package require rattleCAD]\n"
		$env_text  insert end "       canvasCAD:      [package require canvasCAD]\n"
		$env_text  insert end "       extSummary:     [package require extSummary]\n"  
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
        # $env_text  insert end "     APPL_Env(USER_Init):     $APPL_Env(USER_Init)\n"
        $env_text  insert end "\n\n"
        $env_text  insert end "   Packages:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n"
        $env_text  insert end "     \$::vectorfont::font_dir  $::vectorfont::font_dir  "
		$env_text  insert end "\n\n\n\n"
        $env_text  insert end "   others:\n"
        $env_text  insert end "  ----------------------------------------------------\n"
        $env_text  insert end "\n\n\n"
        
        

        ;# =======================================================================
          ;# -- insert into version_help ---------
          ;#
        $help_text  insert end "\n\n"
        $help_text  insert end "  ====================================================\n"
        $help_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $help_text  insert end "  ====================================================\n"
        $help_text  insert end ""
        
        set fd [open [file join [file dirname $::APPL_Env(CONFIG_Dir)] help.txt] r]
        while {![eof $fd]} {
	         set line [gets $fd]
	         $help_text  insert end "    $line\n"
        }
        close $fd

        $help_text  insert end "\n\n"
        

		
        ;# =======================================================================
          ;# -- insert into version_license ---------
          ;#
        $lic_text   insert end "\n\n"
        $lic_text   insert end "  ====================================================\n"
        $lic_text   insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $lic_text   insert end "  ====================================================\n"
        $lic_text   insert end ""
        
        set fd [open [file join [file dirname $::APPL_Env(CONFIG_Dir)] license.txt] r]
        while {![eof $fd]} {
	         set line [gets $fd]
	         $lic_text  insert end "    $line\n"
        }
        close $fd

        $lic_text   insert end "\n\n"

        

        ;# =======================================================================
          ;# -- insert into exclusion ---------
          ;#
        $excl_text  insert end "\n\n"
        $excl_text  insert end "  ====================================================\n"
        $excl_text  insert end "   rattleCAD       $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)\n"
        $excl_text  insert end "  ====================================================\n"
        $excl_text  insert end ""
        
        set fd [open [file join [file dirname $::APPL_Env(CONFIG_Dir)] exclusion.txt] r]
        while {![eof $fd]} {
	         set line [gets $fd]
	         $excl_text  insert end "    $line\n"
        }
        close $fd

        $excl_text  insert end "\n\n"
        

                               
        $version_intro			configure  -borderwidth 2 
        $version_help			configure  -borderwidth 2 
        $version_env			configure  -borderwidth 2 
        $version_license		configure  -borderwidth 2 
        $version_exclusion		configure  -borderwidth 2 

        $INFO_Notebook 			compute_size
        $INFO_Notebook			raise [ $INFO_Notebook page $tab ]
        
        return $INFO_Notebook
   }
   
   

     #-------------------------------------------------------------------------
     #
     #  end  namespace eval version_info 
     #

 }
  
