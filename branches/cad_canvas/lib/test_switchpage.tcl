  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
  
  lappend auto_path "$APPL_ROOT_Dir/_switchpage"
  package require switchpage

  # source lib_switchpage.tcl
  
  
  frame .f1
  frame .bt
  pack  .f1 -fill both -expand yes
  pack  .bt

  set sw_frame [switch_page::create  .f1  sf  0 ]

  set sw_fr_1  [switch_page::add     $sw_frame   sw_1  001]
  set sw_fr_2  [switch_page::add     $sw_frame   sw_2  002]
  set sw_fr_3  [switch_page::add     $sw_frame   sw_3  003]

  pack [text  $sw_fr_1.txt   -background red    -width 50 -height 10]  -padx 20  -fill x     -expand yes
  pack [text  $sw_fr_2.txt   -background white  -width 30 -height 20]  -pady 20  -fill y     -expand yes
  
  
  
  pack [frame $sw_fr_3.frm       -background white ]  -fill both  -expand yes
  
  pack [text  $sw_fr_3.frm.txta  -background gray  -width 50 -height 10]  -side left  -pady 5  -fill both    -expand yes  
  
  
  pack [frame $sw_fr_3.frm.f     -background white ]   -fill y  -expand no  -side right

        text  $sw_fr_3.frm.f.txta  -background red    -width 10 -height  2 
        text  $sw_fr_3.frm.f.txtb  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txtc  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txtd  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txte  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txtf  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txtg  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txth  -background red    -width 10 -height  2   
        text  $sw_fr_3.frm.f.txti  -background red    -width 10 -height  2   
  
  pack $sw_fr_3.frm.f.txta  \
       $sw_fr_3.frm.f.txtb  \
       $sw_fr_3.frm.f.txtc  \
       $sw_fr_3.frm.f.txtd  \
       $sw_fr_3.frm.f.txte  \
       $sw_fr_3.frm.f.txtf  \
       $sw_fr_3.frm.f.txtg  \
       $sw_fr_3.frm.f.txth  \
       $sw_fr_3.frm.f.txti  \
       -pady 2  -padx 4    
 

  button  .bt.exit  -text "  exit  "  -bd 1  -width 12  -padx 0  -command exit 
  button  .bt.sw1   -text "  fr1  "   -bd 1  -width 12  -padx 0  -command {switch_page::showframe $sw_fr_1}
  button  .bt.sw2   -text "  fr2  "   -bd 1  -width 12  -padx 0  -command {switch_page::showframe $sw_fr_2}
  button  .bt.sw3   -text "  fr3  "   -bd 1  -width 12  -padx 0  -command {switch_page::showframe $sw_fr_3}
  button  .bt.res   -text " resize "  -bd 1  -width 12  -padx 0  -command {switch_page::resize    $sw_frame}
  button  .bt.upd   -text " resize "  -bd 1  -width 12  -padx 0  -command {update_text}

  pack    \
        .bt.sw1   \
        .bt.sw2   \
        .bt.sw3   \
        .bt.res   \
        .bt.upd   \
        .bt.exit  \
        \
        -fill both  -expand yes  -side left

  update
  # switch_page::resize     $sw_frame
  update
  switch_page::showframe  $sw_fr_1

  wm minsize . [winfo width  .]   [winfo height  .]


  proc update_text {} {
         global   sw_frame  sw_fr_1  sw_fr_2  sw_fr_3

         #switch_page::resize $sw_frame
         
         $sw_fr_1.txt         delete  @0,0 end
         $sw_fr_2.txt         delete  @0,0 end
         $sw_fr_3.frm.f.txta  delete  @0,0 end
         $sw_fr_3.frm.f.txtb  delete  @0,0 end
  
         $sw_fr_1.txt   insert  end  " [winfo reqwidth $sw_fr_1.txt]  /  [winfo reqheight $sw_fr_1.txt]\n"
         $sw_fr_1.txt   insert  end  " [winfo width $sw_fr_1.txt]  /  [winfo height $sw_fr_1.txt]"
         
         $sw_fr_2.txt   insert  end  " [winfo reqwidth $sw_fr_2.txt]  /  [winfo reqheight $sw_fr_2.txt]\n"
         $sw_fr_2.txt   insert  end  " [winfo width $sw_fr_2.txt]  /  [winfo height $sw_fr_2.txt]"
         
         $sw_fr_3.frm.f.txta  insert  end  " [winfo reqwidth $sw_fr_3.frm.f]  /  [winfo reqheight $sw_fr_3.frm.f]\n"
         $sw_fr_3.frm.f.txta  insert  end  " [winfo width    $sw_fr_3.frm.f]  /  [winfo height    $sw_fr_3.frm.f]"
         
         $sw_fr_3.frm.f.txtb  insert  end  " [winfo reqwidth $sw_fr_3.frm.f.txtb]  /  [winfo reqheight $sw_fr_3.frm.f.txtb]\n"
         $sw_fr_3.frm.f.txtb  insert  end  " [winfo width    $sw_fr_3.frm.f.txtb]  /  [winfo height    $sw_fr_3.frm.f.txtb]"
  
  
  
  
  
           #$sw_fr_1.txt   
           #$sw_fr_2.txt   
           #$sw_fr_3.txta  
           #$sw_fr_3.txtb  
  }

    # bind . <Configure> {switch_page::resize $sw_frame} 
  #bind . <Configure> {update_text} 
