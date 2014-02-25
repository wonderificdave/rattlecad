#!/bin/sh
# test_bikeGeometry_IF.tcl \
exec tclsh "$0" ${1+"$@"}

    puts "\n\n ====== I N I T ============================ \n\n"
    
        # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    puts "   -> BASE_Dir: $BASE_Dir\n"
    
    set TEST_Dir  [file join $BASE_Dir _test]
    
    
        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
                
        # puts "  \$auto_path  $auto_path"
    
    package require   rattleCAD     3.4 
        # package require   canvasCAD     0.35
    package require   bikeGeometry  0.14
        # package require   extSummary    0.3
    package require   appUtil
    
    
    
    set projectFile      template_road_3.3.xml
    
    
    set ::APPL_Config(CONFIG_Dir)       [file join $BASE_Dir etc] 
         
    set ::APPL_Config(root_InitDOM)     [ lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml ] ]
    puts "     ... root_InitDOM         [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"
    
    set ::APPL_Config(root_ProjectDOM)  [lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) $projectFile] ]
    puts "     ... root_ProjectDOM      [file join $::APPL_Config(CONFIG_Dir) $projectFile]"
    
        # expired
        # set dictInit    [bikeGeometry::init_Prereq  $::APPL_Config(root_InitDOM)]
        # appUtil::pdict $dictInit
    
    bikeGeometry::set_forkConfig [$::APPL_Config(root_InitDOM) selectNode /root/Fork]
    
    set ::APPL_Config(root_ProjectDOM) [bikeGeometry::set_newProject $::APPL_Config(root_ProjectDOM)]
    
    # puts [$::APPL_Config(root_ProjectDOM) asXML]
    
    
    
    
    
    puts "\n"
    puts "    ... loop through files"
    puts ""
    puts "        ... \$TEST_Dir   $TEST_Dir"
    puts "\n"
    
      # parray ::APPL_Config
    
    foreach thisFile { 
           focus_cayo_expert_2010__L_56.xml focus_cayo_expert_2010__M_54.xml  focus_cayo_expert_2010__XL_58.xml \
           columbus_max.xml \
           _template_3.2.78.xml _template_3.2.78_offroad.xml _template_3.3.00.xml _template_3.3.02.xml \
           _template_3.3.03.xml _template_3.3.04.xml _template_3.3.05.35.xml _template_3.3.06.xml \
           Kid20_V7.xml  ghost_powerkid_20.xml \
           __test_Integration_02.xml   
    } {       
        set fileName     [file join  $TEST_Dir sample $thisFile]
        
        puts "\n"
        puts "  ========= o p e n   F I L E ====================="
        puts ""
        puts "         ... file:       $fileName"
        puts "n"
        
        set my_projDOM    [lib_file::get_XMLContent $fileName show]
            # set rattleCAD_Version [[$::APPL_Config(root_ProjectDOM) selectNodes /root/Project/rattleCADVersion/text()] asXML]

        bikeGeometry::set_newProject $my_projDOM
        #update          
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    exit
    
    set dictProject [bikeGeometry::init_Project]
    appUtil::pdict $dictProject   
    puts "\n -- 00 -- \n"     
    set value [dict get $dictProject Component Fork Height]
    puts "   00-1 -> $value"
        
        
        
        
        
    set dictProject [bikeGeometry::init_Project $::APPL_Config(root_ProjectDOM)]
    set value [dict get $dictProject Component Fork Height]
      #appUtil::pdict $dictProject   
    puts "   00-2 -> $value"
    
    
    
      # return
    
    
    
    
    
    puts "\n =========================================\n"
    
    puts "\n -- 01 -- \n"     
    set value [dict get $dictProject Component Fork Height]
    puts "   01 -> $value"

      
      
      
      
      
    puts "\n -- 02 -- \n" 
    if_bikeGeometry::set_projValue Component/Fork/Height 354.0

    
    puts "\n -- 03 -- \n"   
    set value [if_bikeGeometry::get_projValue Component/Fork/Height]
    puts "   03 -> $value"
    
    
    puts "$::project::Component(Fork/Height)"
    
    
    # return

    
    
    
    puts "\n -- 04 -- \n"   
    if_bikeGeometry::reference::update_cv_Parameter _cv_Name_ {0 0}
    
    puts "\n -- 05 -- \n"   
    # appUtil::pdict $dictProject
    
    
    puts "\n -- 06 -- \n"   
    # if_bikeGeometry::update_Project
    
 
    puts "\n -- 07 -- \n"   
    proc checkParameter {_name} {
                # puts "    -> checkParameter: $_name"
            eval [format "set compValue $%s::%s" if_bikeGeometry::reference $_name]
                # puts "     -> $compValue"
                #
            set cmdString [format "set newValue   \$%s::%s" if_bikeGeometry::project   $_name]
                # puts "     -> $cmdString"
                #
            if {[catch {eval $cmdString} fid]} {
                puts "         compValue <E>  $_name: \$newValue != $compValue"
                exit
            } else {
                #puts "   ....... $fid"
            }
            
            set i 0
            set valueLength [llength $compValue]
            
            while {$i < $valueLength} {
                set _compValue  [lindex $compValue $i]
                set _newValue   [lindex $newValue   $i]
                compareValue $_name $i $valueLength $_compValue $_newValue
                incr i
            }

            flush stdout
    }
    
    proc compareValue {_name _index _range compValue newValue {args}} {
         if {$compValue != $newValue} {  
              # ... ERROR
            set exceptComp [format "%.4f" $compValue]
            set exceptNew  [format "%.4f" $newValue]
            if {$exceptComp == $exceptNew} {
                compareValue $_name $_index $_range $exceptComp $exceptNew " -> format .4f"
                return
            } 
              
              
            puts "\n      ---- <ERROR> --------------------------\n"
            puts [format "         checkParameter <E>  %-30s" $_name:]
            puts "                should be this -> $compValue"
            puts "                            is -> $newValue"
            exit
        } else {
              # ... OK

            if {$_range == 1} {
                puts [format "         checkParameter <OK> %-30s %10s == %10s    %s" $_name: $newValue $compValue $args]
            } else {
                puts [format "         checkParameter <OK>   %-28s %10s == %10s    %s" $_name: $newValue $compValue $args]
            }
        }
        flush stdout
    }
    
    
    
    checkParameter Rendering(BrakeFront)
    checkParameter Rendering(BrakeRear)
    checkParameter Rendering(BottleCage_ST)   
    checkParameter Rendering(BottleCage_DT)
    checkParameter Rendering(BottleCage_DT_L)
    
    checkParameter RearWheel(RimDiameter)     
    checkParameter RearWheel(TyreHeight)      
    checkParameter FrontWheel(RimDiameter)    
    checkParameter FrontWheel(TyreHeight)     
    checkParameter Fork(Height)               
    checkParameter Fork(Rake)                 
    checkParameter Stem(Length)               
    checkParameter Stem(Angle)                
    checkParameter BottomBracket(depth)       
    checkParameter RearDrop(OffsetSSPerp)     
    checkParameter RearDrop(OffsetCSPerp)     
    checkParameter SeatTube(OffsetBB)         
    checkParameter DownTube(OffsetBB) 
       puts ""
    checkParameter BottomBracket(Position)
    checkParameter RearWheel(Position)    
    checkParameter FrontWheel(Position)   
    checkParameter SeatPost(Saddle)       
    checkParameter SeatPost(SeatTube)     
    checkParameter Saddle(Position)       
    checkParameter Saddle(Proposal)       
    checkParameter SeatStay(SeatTube)     
    checkParameter TopTube(SeatTube)      
    checkParameter TopTube(Steerer)       
    checkParameter HeadTube(Stem)         
    checkParameter HeadTube(Fork)         
    checkParameter Steerer(Stem)          
    checkParameter Steerer(Fork)          
    checkParameter DownTube(Steerer)      
    checkParameter DownTube(BBracket)     
    checkParameter HandleBar(Position)    
    checkParameter SeatTube(TopTube)      
    checkParameter SeatTube(Saddle)       
    checkParameter SeatTube(BBracket)     
    checkParameter SeatStay(End)          
    checkParameter SeatTube(Ground)       
    checkParameter Steerer(Ground)        
    checkParameter Position(BaseCenter)   
       puts ""
    checkParameter FrontBrake(Shoe)
    checkParameter FrontBrake(Mount)     
    checkParameter FrontBrake(Help)      
    checkParameter FrontBrake(Definition)
        puts ""
    checkParameter RearBrake(Shoe)
    checkParameter RearBrake(Mount)      
    checkParameter RearBrake(Help)       
    checkParameter RearBrake(Definition) 
        puts ""
    checkParameter LegClearance(Position)
    checkParameter SaddleNose(Position)
    checkParameter Position(IS_ChainSt_SeatSt)
        puts ""
    checkParameter Length(CrankSet) 

   
    
    
    
    
    
    
    

    
    

    
    
    
