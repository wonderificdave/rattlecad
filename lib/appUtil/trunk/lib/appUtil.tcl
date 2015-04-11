###
### (C) Copyright 2004-2007 by Tech-EDV Reithofer
###
###   Tech-EDV PROVIDES THIS PROGRAM "AS IS" AND WITH ALL FAULTS.
###   Tech-EDV SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF MERCHANTABILITY
###   OR FITNESS FOR A PARTICULAR USE.
###   Tech-EDV DOES NOT WARRANT THAT THE OPERATION OF THE PROGRAM  WILL  BE
###   UNINTERRUPTED OR ERROR FREE.
###
### It is NOT implemented to define any user specific function that
### can be used without any other product from Tech-EDV.
###
###       Technische EDV Reithofer
###       A-8042 Graz,
###       Peierlhang 31b
###
###       Tel. +43-316-405707 Fax +43-316-405707-15
###       Mob. +43-650-405707-7
###       EMail: gerhard.reithofer@tech-edv.co.at
###       Web http://www.tech.edv.co.at
###                                                Graz 2007-02.14
###
### Description:
###    General tool package
###
### created: pkg_mkIndex -verbose . 
###
### History:
###  20071214: DelConfig added
###            delete a content of list
###  20070804: graphic debug-output added
###            option -list on GetConfig
###            returns the separator first if there is no specific value requested
###  20070612: Config_Value_Notset, Config_Value_Separator changed
###            Bug with liststructure in data if 'Out' and Level=1
###  20150411: 0.17
###            namespaceReport namespace  [{}/namespace] format [domNode/asXML/asText]
###            appUtil::_add_namespaceReport -> catch {_add_namespaceReport $_node $_element}
###

package provide appUtil  0.17

namespace eval appUtil { 

    package require tdom
    
    variable Config_Value_Notset ""
    variable Config_Value_Separator "."
    variable config_var
    
    # array set config_var {}
}


        # -- SetConfig -------------
        #
    proc appUtil::SetConfig { key val args } {
      
        variable Config_Value_Separator 
        variable config_var

        ::Debug  p

        set idx $key
            ## idx=$key
        set la [llength $args]
        if {!$la} { 
            set config_var($idx) $val
            return 
        }
            ## idx=$key/$val
        append idx $Config_Value_Separator $val
        set val [lindex $args end]
            ## val=$a(end)
        if {$la>1} {
                ## idx=$key/$val/
            append idx $Config_Value_Separator
                ## idx=$key/$val/$a1/$a2...$a(end-1)
            append idx [join [lrange $args 0 end-1] $Config_Value_Separator]
        } 
        set config_var($idx) $val
    }


        # -- GetConfig -------------
        #
    proc appUtil::GetConfig { args } {

        variable Config_Value_Separator 
        variable Config_Value_Notset
        variable config_var

        ::Debug  p

          # -- no arguments to procedure
          #      returns the Separator at first
        if {![llength $args]} {
            return "$Config_Value_Separator [lsort [array names config_var]]"
        }
        
          # -- first argument: -list 
          #      returns the Separator at first
        if {[lindex $args 0] == "-list"} {
            puts " $args"
            set path          [join   [lrange $args 1 end] $Config_Value_Separator]
            return "$Config_Value_Separator [lsearch -inline -all  [array names config_var] $path.* ]"
        }

          # -- default
        set idx [join $args $Config_Value_Separator]
        if [info exists config_var($idx)] {
            return $config_var($idx)
        } else {
            return $Config_Value_Notset
        }
      }


        # -- DelConfig -------------
        #
    proc appUtil::DelConfig { args } {
          
        variable Config_Value_Separator 
        variable config_var

        ::Debug  p

        if {![llength $args]} {
            return 0
        } else {
            set idx [join [lrange $args 0 end] $Config_Value_Separator]
            array unset config_var $idx
            return 
        }  
    }


        # -- ReadConfig ------------
        #
    proc appUtil::ReadConfigFile { fname } {
        Debug Fun [info level] 8
        if {![file exists $fname]} {
            return "Configuration file '$fname' does not exist."
        }
        set res [catch {set fd [open $fname RDONLY]} err]
        if {$res} { return $err }
        
        set cnt 0
        while {![eof $fd]} {
            incr cnt
            set line [string trim [gets $fd]]
            if {![regexp {^[A-Za-z]} $line]} continue
                # Debug Var line 8
            set exe SetConfig
            append exe " " $line
            set res [catch {eval $exe} err] 
            if {$res} { 
                catch {puts stderr "Error in configuration line $cnt - line ignored:\n$err"}
            }
        }
        return ""
    }


        #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/440
        #
  proc appUtil::flatten_nestedList { args } {
        if {[llength $args] == 0 } { return ""}
        set flatList {}
        foreach e [eval concat $args] {
            foreach ee $e { lappend flatList $ee }
        }
            # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
        return $flatList
  }    


    namespace export SetConfig DelConfig GetConfig ReadConfigFile SetDebugLevel Debug


# -- appUtil  ---------------
  # namespace import \
        appUtil::SetConfig \
        appUtil::GetConfig \
        appUtil::DelConfig \
        appUtil::SetDebugLevel \
        appUtil::appDebug 



