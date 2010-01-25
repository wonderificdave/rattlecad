  #: Parameter :

  set CANVAS_MIN_X 520
  set CANVAS_MIN_Y 430
  
  set FRAME(Config_Id)        0
  set FRAME(CANVAS_Scale)     1.0
  set FRAME(BBOX_Move)        [ list 0 0 ]
 

  # Images    
  #
  set      img_open     [ image create photo -file $APPL_Env(IMAGE_Dir)/open.gif ]
  set      img_recent   [ image create photo -file $APPL_Env(IMAGE_Dir)/open_recent.gif ]
  set      img_save     [ image create photo -file $APPL_Env(IMAGE_Dir)/save.gif ]
  set      img_print    [ image create photo -file $APPL_Env(IMAGE_Dir)/print.gif   ]
  set      img_clear    [ image create photo -file $APPL_Env(IMAGE_Dir)/clean.gif   ]
  set      img_design   [ image create photo -file $APPL_Env(IMAGE_Dir)/design.gif ]
  set      img_drawing  [ image create photo -file $APPL_Env(IMAGE_Dir)/drawing.gif ]
  set      img_reset_r  [ image create photo -file $APPL_Env(IMAGE_Dir)/reset_road.gif    ]
  set      img_reset_o  [ image create photo -file $APPL_Env(IMAGE_Dir)/reset_offroad.gif ]
  set      img_scale_p  [ image create photo -file $APPL_Env(IMAGE_Dir)/scale_plus.gif  ]
  set      img_scale_m  [ image create photo -file $APPL_Env(IMAGE_Dir)/scale_minus.gif ]
  set      img_resize   [ image create photo -file $APPL_Env(IMAGE_Dir)/resize.gif ]
  set      img_exit     [ image create photo -file $APPL_Env(IMAGE_Dir)/exit.gif ]

  

  # Language    
  #
  array set Language {}

  set Language(____current) ____english 
  
  set Language(____english) \
	       [list \
	             [list BottomBracket_Depth     {BottomBracket Depth}      ] \
	             [list BottomBracket_Height    {BottomBracket Height}     ] \
	             [list BottomBrckt_Diameter    {BottomBracket Diameter}   ] \
	             [list ChainStay_Diameter      {ChainStay Diameter}       ] \
	             [list ChainStay_Diameter_2    {ChainStay Diameter 2}     ] \
	             [list ChainStay_Length        {ChainStay Length}         ] \
	             [list ChainStay_TaperLength   {ChainStay Taper Length}   ] \
	             [list Comp_Fork_Heigth        {Fork Heigth}              ] \
	             [list Comp_Fork_Rake          {Fork Rake}                ] \
	             [list Comp_Stem_Angle         {Stem Angle}               ] \
	             [list Comp_Stem_Heigth        {Stem Heigth}              ] \
	             [list Comp_Stem_Length        {Stem Length}              ] \
	             [list Comp_Wheel_Front_Rim_Diameter  {Rim Diameter Front}] \
	             [list Comp_Wheel_Front_Tyre_Height   { Tyre Height}      ] \
	             [list Comp_Wheel_Rear_Rim_Diameter   {Rim Diameter Rear} ] \
	             [list Comp_Wheel_Rear_Tyre_Height    { Tyre Height}      ] \
	             [list Comp_Wheel_Rim_Diameter        {WheelRim Diameter} ] \
	             [list Comp_Wheel_Tyre_Height  { Tyre Height}             ] \
	             [list CrankArm_Length         {CrankArm Length}          ] \
	             [list DownTube_BB_Diameter    {DownTube Diameter BB}     ] \
	             [list DownTube_Diameter       {DownTube Diameter}        ] \
	             [list Fork                    {Fork}                     ] \
	             [list Fork_Type               {Fork Type}                ] \
	             [list Fork_Heigth             {Fork Heigth}              ] \
	             [list Fork_Rake               {Fork Rake}                ] \
				 [list ForkBlade_Width         {ForkBlade With}           ] \
				 [list ForkCrown_Diameter      {ForkCrown Diameter}       ] \
	             [list Front_Length            {Front Length}             ] \
	             [list HandleBar_Distance      {HandleBar Distance}       ] \
	             [list HandleBar_Height        {HandleBar Height}         ] \
	             [list HeadTube_Angle          {HeadTube Angle}           ] \
	             [list HeadTube_Bottom         {HeadTube Bottom}          ] \
	             [list HeadTube_Diameter       {HeadTube Diameter}        ] \
	             [list HeadTube_Length         {HeadTube Length}          ] \
	             [list HeadTube_Top            {HeadTube Top}             ] \
	             [list HeadsetBottom_Heigth    {Headset Bottom Heigth}    ] \
	             [list InnerLeg_Length         {InnerLeg Length}          ] \
	             [list SeatStay_Diameter_2     {SeatStay Diameter 2}      ] \
	             [list SeatStay_Distance       {SeatStay Distance}        ] \
	             [list SeatStay_TaperLength    {SeatStay TaperLength}     ] \
	             [list SeatTube_Angle          {SeatTube Angle}           ] \
	             [list SeatTube_BB_Diameter    {SeatTube Diameter BB}     ] \
	             [list SeatTube_Diameter       {SeatTube Diameter}        ] \
	             [list SeatTube_Lug            {SeatTube Lug}             ] \
	             [list Stem_Angle              {Stem Angle}               ] \
	             [list Stem_Heigth             {Stem Heigth}              ] \
	             [list Stem_Length             {Stem Length}              ] \
	             [list TopTube_Angle           {TopTube Angle}            ] \
	             [list TopTube_Diameter        {TopTube Diameter}         ] \
	             [list TopTube_Diameter_SL     {TopTube Diameter Seat}    ] \
	             [list TopTube_Heigth          {TopTube Heigth}           ] \
	             [list TopTube_Pivot           {TopTube Pivot}            ] \
	             [list Wheel_Front_Rim_Diameter       {Rim Diameter Front}] \
	             [list Wheel_Front_Tyre_Height        { Tyre Height}      ] \
	             [list Wheel_Rear_Rim_Diameter        {Rim Diameter Rear} ] \
	             [list Wheel_Rear_Tyre_Height         { Tyre Height}      ] \
	             [list Wheel_Rim_Diameter             {Rim Diameter}      ] \
	             [list Wheel_Tyre_Height              { Tyre Height}      ] \
                     \
	             [list Control_Panel           {Control Panel}            ] \
	             [list Config                  {Config}                   ] \
	             [list Detail                  {Detail}                   ] \
	             [list Drafting                {Drafting}                 ] \
	             [list Replace                 {Replace}                  ] \
                     \
	             [list BBMeth                  {BBracket Control}         ] \
	             [list HTMeth                  {HeadTube Control}         ] \
	             [list Centerline              {Centerline}               ] \
	             [list Commit                  {Commit}                   ] \
	             [list Dimension               {Dimension}                ] \
	             [list Display                 {Display}                  ] \
	             [list Format                  {Format}          ´        ] \
	             [list Frame_Jig               {Frame Jig}                ] \
	             [list Front                   {Front}                    ] \
	             [list Geometry                {Geometry}                 ] \
	             [list HandleBar               {Handlebar}                ] \
	             [list HandleBar_Type          {Handlebar Type}           ] \
	             [list Parameter               {Parameter}                ] \
	             [list Personal                {Personal}                 ] \
	             [list Rear                    {Rear}                     ] \
	             [list Reset                   {Reset}                    ] \
	             [list RimLock                 {Rim Diameter}             ] \
	             [list Scale                   {Scale}                    ] \
	             [list SeatStay_Diameter       {SeatStay Diameter}        ] \
	             [list Tube_Dimension          {Cut Dimension}            ] \
	             [list Type                    {Type}                     ] \
	             [list TyreLock                {Tyre Height}              ] \
	             [list Update                  {Update}                   ] \
	             [list angle                   {angle}                    ] \
	             [list bar                     {bar}                      ] \
	             [list depth                   {depth}                    ] \
	             [list drop_bar                {drop bar}                 ] \
	             [list flat_bar                {flat bar}                 ] \
	             [list height                  {height}                   ] \
	             [list lock                    {lock}                     ] \
	             [list off                     {off}                      ] \
	             [list on                      {on}                       ] \
	             [list reset_2_frame_cfg       {... reset to Frame}       ] \
	             [list toggle_config_replace   {... config/replace}       ] \
	             [list unlock                  {unlock}                   ] \
	             [list update_cfg_gui          {... update Control Panel} ] \
	             [list update_drafting         {... update Drafting}      ] \
	       ]  							      

  set Language(____deutsch) \
	       [list \
	             [list BottomBracket_Depth     {Tretlager Tiefgang}       ] \
	             [list BottomBracket_Height    {Tretlager Höhe}           ] \
	             [list BottomBrckt_Diameter    {Tretlager Durchmesser}    ] \
	             [list ChainStay_Diameter      {Kettenstreben Höhe}       ] \
	             [list ChainStay_Diameter_2    {Kettenstr Durchm. 2}      ] \
	             [list ChainStay_Length        {Kettenstreben Länge}      ] \
	             [list ChainStay_TaperLength   {Kettenstr Red. Länge}     ] \
	             [list Comp_Fork_Heigth        {Gabel Höhe}               ] \
	             [list Comp_Fork_Rake          {Gabel Vorbiegung}         ] \
	             [list Comp_Stem_Angle         {LenkerVorbau Winkel}      ] \
	             [list Comp_Stem_Heigth        {LenkerVorbau Höhe}        ] \
	             [list Comp_Stem_Length        {LenkerVorbau Länge}       ] \
	             [list Comp_Wheel_Rim_Diameter {Felgen Durchm.}           ] \
	             [list Comp_Wheel_Tyre_Height  {Reifen Höhe}              ] \
	             [list Comp_Wheel_Front_Rim_Diameter  {Felgen Durchm. v.} ] \
	             [list Comp_Wheel_Front_Tyre_Height   { Tyre Height}      ] \
	             [list Comp_Wheel_Rear_Rim_Diameter   {Felgen Durchm. h.} ] \
	             [list Comp_Wheel_Rear_Tyre_Height    { Reifen Höhe}       ] \
	             [list CrankArm_Length         {Tretkurbel Länge}         ] \
	             [list DownTube_BB_Diameter    {UnterRohr Durchm. Tretl.} ] \
	             [list DownTube_Diameter       {UnterRohr Durchmesser}    ] \
	             [list Fork                    {Gabel}                    ] \
	             [list Fork_Type               {Gabel Typ}                ] \
	             [list Fork_Heigth             {Gabel Höhe}               ] \
	             [list Fork_Rake               {Gabel Vorbiegung}         ] \
				 [list ForkBlade_Width         {Gabelscheiden Breite}     ] \
				 [list ForkCrown_Diameter      {Gabelkopf Durchmesser}    ] \
	             [list Front_Length            {Vorderbau Länge}          ] \
	             [list HandleBar_Distance      {Lenker Abstand}           ] \
	             [list HandleBar_Height        {Lenker Höhe}              ] \
	             [list HeadTube_Angle          {SteuerRohr Winkel}        ] \
	             [list HeadTube_Bottom         {SteuerRohr unten}         ] \
	             [list HeadTube_Diameter       {SteuerRohr Durchmesser}   ] \
	             [list HeadTube_Length         {SteuerRohr Länge}         ] \
	             [list HeadTube_Top            {SteuerRohr oben}          ] \
	             [list HeadsetBottom_Heigth    {Steuerstatz Höhe unt.}    ] \
	             [list InnerLeg_Length         {Innere Beinlänge}         ] \
	             [list SeatStay_Diameter       {Sattelstreben Durchm.}    ] \
	             [list SeatStay_Diameter_2     {Sattelstr. Durchm. 2}     ] \
	             [list SeatStay_Distance       {Sattelstreben Abstand}    ] \
	             [list SeatStay_TaperLength    {Sattelstr. Red. Länge}    ] \
	             [list SeatTube_Angle          {SattelRohr Winkel}        ] \
	             [list SeatTube_BB_Diameter    {SattelRohr Durchm. Tretl.}] \
	             [list SeatTube_Diameter       {SattelRohr Durchmesser}   ] \
	             [list SeatTube_Lug            {SattelRohr Überstand}     ] \
	             [list Stem_Angle              {LenkerVorbau Winkel}      ] \
	             [list Stem_Heigth             {LenkerVorbau Höhe}        ] \
	             [list Stem_Length             {LenkerVorbau Länge}       ] \
	             [list TopTube_Angle           {OberRohr Winkel}          ] \
	             [list TopTube_Diameter        {OberRohr Durchmesser}     ] \
	             [list TopTube_Diameter_SL     {OberRohr Durchm. Sattel}  ] \
	             [list TopTube_Heigth          {OberRohr Höhe}            ] \
	             [list TopTube_Pivot           {OberRohr Schrittpunkt}    ] \
	             [list Wheel_Rim_Diameter             {Felgen Durchmesser}] \
	             [list Wheel_Tyre_Height              { Reifen Höhe}      ] \
	             [list Wheel_Front_Rim_Diameter       {Felgen Durchm. v.} ] \
	             [list Wheel_Front_Tyre_Height        { Reifen Höhe}      ] \
	             [list Wheel_Rear_Rim_Diameter        {Felgen Durchm. h.} ] \
	             [list Wheel_Rear_Tyre_Height         { Reifen Höhe}      ] \
	             [list SeatStay_Diameter       {SeatStay Diameter}        ] \
	             \
	             [list Control_Panel           {Steuer Pult}              ] \
	             [list Config                  {Konfig.}                  ] \
	             [list Detail                  {Detail}                   ] \
	             [list Drafting                {Zeichnung}                ] \
	             [list Replace                 {Ersatz}                   ] \
                     \
	             [list BBMeth                  {Tretlager Steuerung}      ] \
	             [list HTMeth                  {Steuerrohr Steuerung}     ] \
	             [list Centerline              {Mittellinien}             ] \
	             [list Commit                  {Annehmen}                 ] \
	             [list Dimension               {Bemaßung}                 ] \
	             [list Display                 {Darstellung}              ] \
	             [list Format                  {Format}          ´        ] \
	             [list Frame_Jig               {Vorrichtung}              ] \
	             [list Front                   {Vorne}                    ] \
	             [list Geometry                {Geometrie}                ] \
	             [list HandleBar               {Lenker}                   ] \
	             [list HandleBar_Type          {Lenker Typ}               ] \
	             [list Parameter               {Parameter}                ] \
	             [list Personal                {Person}                   ] \
	             [list Rear                    {Hinten}                   ] \
	             [list Reset                   {Zurücksetzen}             ] \
	             [list RimLock                 {Felgen Durchm.}           ] \
	             [list Scale                   {Maßstab}                  ] \
	             [list Tube_Dimension          {Zuschnitt}                ] \
	             [list Type                    {Typ}                      ] \
	             [list TyreLock                {Reifen Höhe}              ] \
	             [list Update                  {Aktualisieren}            ] \
	             [list angle                   {Winkel}                   ] \
	             [list bar                     {Lenker}                   ] \
	             [list depth                   {Tiefe}                    ] \
	             [list drop_bar                {Straße}                   ] \
	             [list flat_bar                {Gelände}                  ] \
	             [list height                  {Höhe}                     ] \
	             [list lock                    {lock}                     ] \
	             [list off                     {aus}                      ] \
	             [list on                      {ein}                      ] \
	             [list reset_2_frame_cfg       {... auf Konfig. zurücksetzen} ] \
	             [list toggle_config_replace   {... Konfig./Ersatz}       ] \
	             [list unlock                  {unlock}                   ] \
	             [list update_cfg_gui          {... update Steuer Pult}   ] \
	             [list update_drafting         {... Zeichnung aktualisieren}  ] \
	       ]


  set Language(____steirisch) \
	       [list \
	             [list BottomBracket_Depth     {Trejtloga Tiafgaung}      ] \
	             [list BottomBracket_Height    {Trejtloga Hechn}          ] \
	             [list BottomBrckt_Diameter    {Trejtloga Durchmessa}     ] \
	             [list ChainStay_Diameter      {Kejdnstrehm Hechn}        ] \
	             [list ChainStay_Diameter_2    {Kejdnstrehm Duachm. 2}    ] \
	             [list ChainStay_Length        {Kejdnstrehm Laingan}      ] \
	             [list ChainStay_TaperLength   {Kejdnstrehm Spiez Laingan}] \
	             [list Comp_Fork_Heigth        {Gobl Hechn}               ] \
	             [list Comp_Fork_Rake          {Gobl Voabiegung}          ] \
	             [list Comp_Stem_Angle         {LejnkaVoabau Winkl}       ] \
	             [list Comp_Stem_Heigth        {LejnkaVoabau Hechn}       ] \
	             [list Comp_Stem_Length        {LejnkaVoabau Laingan}     ] \
	             [list Comp_Wheel_Rim_Diameter {Fölgn Durchmessa}         ] \
	             [list Comp_Wheel_Tyre_Height  {Raifn Hechn}              ] \
	             [list Comp_Wheel_Front_Rim_Diameter  {Fölgn Durchmessa voan}  ] \
	             [list Comp_Wheel_Front_Tyre_Height   { Raifn Hechn}      ] \
	             [list Comp_Wheel_Rear_Rim_Diameter   {Fölgn Durchmessa hintn} ] \
	             [list Comp_Wheel_Rear_Tyre_Height    { Raifn Hechn}       ] \
	             [list CrankArm_Length         {Tridling Laingan}         ] \
	             [list DownTube_BB_Diameter    {UntaRoar Duachm. Trejtl.} ] \
	             [list DownTube_Diameter       {UntaRoar Duachmessa}      ] \
	             [list Fork                    {Gobl}                     ] \
	             [list Fork_Type               {Gobl Dübbn}               ] \
	             [list Fork_Heigth             {Gobl Hechn}               ] \
	             [list Fork_Rake               {Gobl Voabiegung}          ] \
				 [list ForkBlade_Width         {Foblscheidn Breadn}       ] \
				 [list ForkCrown_Diameter      {Goblkoupf Durchmessa}     ] \
	             [list Front_Length            {Voadabau Laingan}         ] \
	             [list HandleBar_Distance      {Lejnka Obstaund}          ] \
	             [list HandleBar_Height        {Lejnka Hechn}             ] \
	             [list HeadTube_Angle          {StaiaRoar Winkl}          ] \
	             [list HeadTube_Bottom         {StaiaRoar intn}           ] \
	             [list HeadTube_Diameter       {StaiaRoar Duachmessa}     ] \
	             [list HeadTube_Length         {StaiaRoar Laingan}        ] \
	             [list HeadTube_Top            {StaiaRoar oum}            ] \
	             [list HeadsetBottom_Heigth    {Staiastatz Hechn intn}    ] \
	             [list InnerLeg_Length         {Innari Haxn Laingan}      ] \
	             [list SeatStay_Diameter       {Soddlstrehm Duachmessa}   ] \
	             [list SeatStay_Diameter_2     {Soddlstrehm Duachm. 2}    ] \
	             [list SeatStay_Distance       {Soddlstrejm Ostaund}      ] \
	             [list SeatStay_TaperLength    {Soddlstrehm Spiez Läjngan}] \
	             [list SeatTube_Angle          {SoddlRoar Winkl}          ] \
	             [list SeatTube_BB_Diameter    {SoddlRoar Duachm. Trejtl.}] \
	             [list SeatTube_Diameter       {SoddlRoar Duachmessa}     ] \
	             [list SeatTube_Lug            {SoddlRoar Iwastaund}      ] \
	             [list Stem_Angle              {LejnkaVoabau Winkl}       ] \
	             [list Stem_Heigth             {LejnkaVoabau Hechn}       ] \
	             [list Stem_Length             {LejnkaVoabau Laingan}     ] \
	             [list TopTube_Angle           {OuwaRoar Winkl}           ] \
	             [list TopTube_Diameter        {OuwaRoar Duachmessa}      ] \
	             [list TopTube_Diameter_SL     {OuwaRoar Duachm. Soddl}   ] \
	             [list TopTube_Heigth          {OuwaRoar Hechn}           ] \
	             [list TopTube_Pivot           {OuwaRoar Schrittpunkt}    ] \
	             [list Wheel_Rim_Diameter             {Fölgn Duachmessa}  ] \
	             [list Wheel_Tyre_Height              {Raifn Hechn}       ] \
	             [list Wheel_Front_Rim_Diameter       {Fölgn Durchmessa voan}  ] \
	             [list Wheel_Front_Tyre_Height        { Raifn Hechn}      ] \
	             [list Wheel_Rear_Rim_Diameter        {Fölgn Durchmessa hintn} ] \
	             [list Wheel_Rear_Tyre_Height         { Raifn Hechn}      ] \
	             \
	             [list Control_Panel           {Steiabrejdl}              ] \
	             [list Config                  {Eistöüln}                 ] \
	             [list Detail                  {Detajl}                   ] \
	             [list Drafting                {Zeichnung}                ] \
	             [list Replace                 {Easotz}                   ] \
                     \
	             [list BBMeth                  {Trejtloga Staierung}      ] \
	             [list HTMeth                  {StaiaRoar Staierung}      ] \
	             [list Centerline              {Middllinien}              ] \
	             [list Commit                  {Annehmen}                 ] \
	             [list Dimension               {Bemoßung}                 ] \
	             [list Display                 {Doarstöüllung}            ] \
	             [list Drafting                {Zeichnung}                ] \
	             [list Format                  {Foamat}          ´        ] \
	             [list Frame_Jig               {Voarichtung}              ] \
	             [list Front                   {Voan}                     ] \
	             [list Geometry                {Geometrie}                ] \
	             [list HandleBar               {Lejnka}                   ] \
	             [list HandleBar_Type          {Lejnka Typ}               ] \
	             [list Parameter               {Parameta}                 ] \
	             [list Personal                {Peasaun}                  ] \
	             [list Rear                    {Hintn}                    ] \
	             [list Reset                   {Zrucksejtzn}              ] \
	             [list RimLock                 {Fölgn Durchm.}            ] \
	             [list Scale                   {Moßstob}                  ] \
	             [list Tube_Dimension          {Zuaschnidd}               ] \
	             [list Type                    {Dübbn}                    ] \
	             [list TyreLock                {Reifn Hechn}              ] \
	             [list Update                  {Aktualisian}              ] \
	             [list angle                   {Winkl}                    ] \
	             [list bar                     {Lejnka}                   ] \
	             [list depth                   {Tiafn}                    ] \
	             [list drop_bar                {Strosn}                   ] \
	             [list flat_bar                {Geläjnde}                 ] \
	             [list height                  {Hechn}                    ] \
	             [list lock                    {lock}                     ] \
	             [list off                     {aus}                      ] \
	             [list on                      {ein}                      ] \
	             [list reset_2_frame_cfg       {... auf Konfig. zrucksejtzn} ] \
	             [list toggle_config_replace   {... Einst./Ersatz}        ] \
	             [list unlock                  {unlock}                   ] \
	             [list update_cfg_gui          {... update Steiabrejdl}   ] \
	             [list update_drafting         {... Zeichnung aktualisian}] \
	       ]  
	       