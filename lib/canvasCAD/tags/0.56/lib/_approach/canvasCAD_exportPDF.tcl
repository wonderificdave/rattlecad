
 ##+##########################################################################
 #
 # package: canvasCAD	->	canvasCAD_print.tcl
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
 #	namespace:  canvasCAD
 # ---------------------------------------------------------------------------
 #
 #

    proc canvasCAD::ObjectMethods_add {} {
    
                package require snit
                package require pdf4tcl
 
                    # ------------------------            
                exportPDF {         switch [llength $argList] {
                                        1 { return [ exportPDF $name [lindex $argList 0] ] }
                                        2 { return [ exportPDF $name [lindex $argList 0] [lindex $argList 1] ] }
                                        3 { return [ exportPDF $name [lindex $argList 0] [lindex $argList 1] [lindex $argList 2] ] }
                                        4 { return [ exportPDF $name [lindex $argList 0] [lindex $argList 1] [lindex $argList 2] [lindex $argList 3] ] }
                                    }
                                }
    } 

    proc canvasCAD::exportPDF {cv_name printFile} {
            #
            #
        # variable canvas_Name
            #
        # puts "\n\n   ... export PDF "    
        #     #
        # set exportFile [file join $::APPL_Config(EXPORT_PDF) tubeMiter_01.pdf]
        #     #
        # puts "      ... $exportFile"    
        
        pdf4tcl::new mypdf -paper a3 -margin 15mm    
        mypdf startPage    
        mypdf canvas $cv_name
        mypdf write -file $printFile
        mypdf destroy
        
        #
        # http://wiki.tcl.tk/949
        #
        #  # Example printing a canvas with pdf4info
        #  package require pdf4tcl                       ; # Get the package
        #  pdf4tcl::new mypdf -paper a4 -margin 15mm     ; # make a new pdf-object
        #  mypdf startPage                               ; # make a new page
        #  # make and fill a canvas .canv
        #  # ...
        #  mypdf canvas .canv                            ; # then put the canvas on your pdf-page
        #  mypdf write -file canvas.pdf                  ; # write to file
        #  mypdf destroy                                 ; # clean up
        #  # printing:
        #  eval exec [auto_execok start] AcroRd32.exe /p /h [list [file normalize canvas.pdf ]]        
        
        
        
        
            
    }