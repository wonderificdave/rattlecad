#############################################################
#
#  switchpage package
#   (c) Manfred ROSENBERGER, 2006/12/29
#
#   Dimension is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 

package provide switchpage 0.1

# -----------------------------------------------------------------------------------
#
#: Functions : namespace      D I M E N S I O N
#

 namespace eval switch_page {
 
      variable switch_page
      array set switch_page \
                       [ list {x_max} {0} \
                              {y_max} {0} \
                       ]
   
      proc create {w name {pad 0}} {
         variable switch_page
	 set switch_page(pad) $pad

         set    switch_page(name) [frame $w.$name]
           # set    switch_page(name) [frame $w.$name  -bg yellow]
         pack   $switch_page(name)  -fill both -expand yes  
           # set    switch_page(name) [frame  $w.$name.fr_w ]
         pack   propagate  $switch_page(name)  off
         update  
           # tk_messageBox -message "  bindings :  [bindtags $switch_page(name)]"
           # tk_messageBox -message "  bindings :  [bindtags [winfo parent $switch_page(name)]]"
         return $switch_page(name)
      }
  

      proc add {w name {frame_label -nolabel}} {
         variable switch_page

         if { [ string compare $frame_label "-nolabel"] } {
             set switch_page_page [labelframe  $w.$name  -text $frame_label]
	 } else {
	     set switch_page_page [frame       $w.$name  ]
	 }
	 
         pack   $switch_page_page    -side left  -fill both  -expand yes 
         
         set    switch_page(current)  $w.$name
         lappend  switch_page(content) "$name"
          
         return $switch_page_page
      }


      proc showframe {page} { # name of content of switch_page
         variable switch_page
         # tk_messageBox -message "  page:  $page\n  parent  [winfo parent [winfo parent $page] ]"
         #set switch_page_frame   [winfo parent $page] 
         set switch_page_parent  [winfo parent $page]
    
         foreach child [winfo children $switch_page_parent] {
               pack forget $child 
         }
         pack  $page  -fill both  -expand yes
         set   switch_page(current)  $page
      }
 

      proc resize {name} {     # name of switch_page, not the content
         variable switch_page
         set current $switch_page(current)
         
         set space_x  [expr [winfo width  [winfo parent $name]]-2*$switch_page(pad)]
         set space_y  [expr [winfo height [winfo parent $name]]-2*$switch_page(pad)]

         foreach child [winfo children $name] {     # the child widget is a frame, take a look at procedure add
              pack forget $child
         }

           # tk_messageBox -message "pages:  [winfo children $name]"
         
         foreach child [winfo children $name] {     # the child widget is a frame, take a look at procedure add
              pack $child  -fill both  -expand yes
                # set lvl_0      $child
                # set lvl_1      [winfo parent $lvl_0]
                # set lvl_2      [winfo parent $lvl_1]
                # set lvl_3      [winfo parent $lvl_2]
                # set message           "$name  /  $lvl_0  /  $lvl_1  /  $lvl_2  "
                # set message           "$name  /  $lvl_0  /  $lvl_1  /  $lvl_2  /  $lvl_3"
                # set message "$message\n---------------------"
                # set message "$message\n$lvl_0    [winfo width $lvl_0]  /  [winfo height $lvl_0]   req: [winfo reqwidth $lvl_0] / [winfo reqheight $lvl_0]"
                # set message "$message\n$lvl_1    [winfo width $lvl_1]  /  [winfo height $lvl_1]   req: [winfo reqwidth $lvl_1] / [winfo reqheight $lvl_1]"
                # set message "$message\n$lvl_2    [winfo width $lvl_2]  /  [winfo height $lvl_2]   req: [winfo reqwidth $lvl_2] / [winfo reqheight $lvl_2]"
                # set message "$message\n$lvl_3    [winfo width $lvl_3]  /  [winfo height $lvl_3]   req: [winfo reqwidth $lvl_3] / [winfo reqheight $lvl_3]"
                # set message "$message\n.f1         [winfo width .f1]  /  [winfo height .f1]   req: [winfo reqwidth .f1] / [winfo reqheight .f1]"
                # set message "$message\n.f1.sf      [winfo width .f1.sf]  /  [winfo height .f1.sf]   req: [winfo reqwidth .f1.sf] / [winfo reqheight .f1.sf]"
                # set message "$message\n.f1.sf.fr_w [winfo width .f1.sf.fr_w]  /  [winfo height .f1.sf.fr_w]   req: [winfo reqwidth .f1.sf.fr_w] / [winfo reqheight .f1.sf.fr_w]"

                # tk_messageBox -message "$message"
              
              set child_reqwidth   [winfo reqwidth   $child]
	      set child_reqheight  [winfo reqheight  $child]
	      
                # tk_messageBox -message "$child_reqheight  $switch_page(y_max)   \nreq:   $child_reqwidth   $child_reqheight    "
              if { $child_reqwidth  > $switch_page(x_max)} { set switch_page(x_max) $child_reqwidth  }
              if { $child_reqheight > $switch_page(y_max)} { set switch_page(y_max) $child_reqheight }
              
              $name  configure  -width  $switch_page(x_max) \
                                -height $switch_page(y_max)

                # tk_messageBox -message "next"
              pack forget $child
              pack $switch_page(current)  -fill both  -expand yes
         }
         
      }
      
}