##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


    set WINDOW_Title      "geometry: fruit"
    
      
    set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
    lappend auto_path "$APPL_ROOT_Dir"
      
    package require		Tk
    package require		geometry 0.1


    set a [geometry::apple new]
    $a eat               ;# prints "skin now off" and "yummy!"
    
    set b [geometry::banana new]
    $b eat               ;# prints "skin now off" and "yummy!"
    
    set c [geometry::citrus new]
    $c eat               ;# prints "citrus skin now off" and "yummy!"
    
    geometry::fruit destroy
    $b eat               ;# error "unknown command"   
    
    
    
    
    exit
 
 
