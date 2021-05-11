version 5.00
begin vb.form frminterv 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "intervalos"
   clientheight    =   4920
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   7650
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   4920
   scalewidth      =   7650
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
      backcolor       =   &h00ffc0c0&
      caption         =   "guardar intervalos"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   4680
      style           =   1  'graphical
      tabindex        =   36
      top             =   4320
      width           =   2895
   end
   begin vb.commandbutton command1 
      backcolor       =   &h00ffc0c0&
      caption         =   "aplicar"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   2880
      style           =   1  'graphical
      tabindex        =   0
      top             =   4320
      width           =   1695
   end
   begin vb.frame frame11 
      backcolor       =   &h00ffc0c0&
      caption         =   "npcs"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   2880
      tabindex        =   49
      top             =   2160
      width           =   1695
      begin vb.frame frame4 
         backcolor       =   &h00ffc0c0&
         caption         =   "a.i"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1575
         left            =   150
         tabindex        =   50
         top             =   240
         width           =   1365
         begin vb.textbox txtai 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   52
            text            =   "0"
            top             =   1080
            width           =   1050
         end
         begin vb.textbox txtnpcpuedeatacar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   135
            tabindex        =   51
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.label label7 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "ai"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   165
            tabindex        =   54
            top             =   840
            width           =   195
         end
         begin vb.label label9 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "puede atacar"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   150
            tabindex        =   53
            top             =   255
            width           =   1155
         end
      end
   end
   begin vb.frame frame12 
      backcolor       =   &h00ffc0c0&
      caption         =   "clima && ambiente"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   4680
      tabindex        =   39
      top             =   2160
      width           =   2865
      begin vb.frame frame7 
         backcolor       =   &h00ffc0c0&
         caption         =   "frio y fx ambientales"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1650
         left            =   120
         tabindex        =   40
         top             =   240
         width           =   2625
         begin vb.textbox txtcmdexec 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   1320
            tabindex        =   44
            text            =   "0"
            top             =   1110
            width           =   915
         end
         begin vb.textbox txtintervaloperdidastaminalluvia 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   1320
            tabindex        =   43
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.textbox txtintervalowavfx 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   150
            tabindex        =   42
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.textbox txtintervalofrio 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   41
            text            =   "0"
            top             =   1080
            width           =   915
         end
         begin vb.label label20 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "timerexec"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   1320
            tabindex        =   48
            top             =   840
            width           =   900
         end
         begin vb.label label19 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "stamina lluvia"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   1320
            tabindex        =   47
            top             =   270
            width           =   1260
         end
         begin vb.label label13 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "fxs"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   180
            tabindex        =   46
            top             =   270
            width           =   330
         end
         begin vb.label label12 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "fr�o"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   195
            tabindex        =   45
            top             =   840
            width           =   345
         end
      end
   end
   begin vb.frame frame6 
      backcolor       =   &h00ffc0c0&
      caption         =   "usuarios"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   120
      tabindex        =   3
      top             =   0
      width           =   7455
      begin vb.frame frame9 
         backcolor       =   &h00ffc0c0&
         caption         =   "otros"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   90
         tabindex        =   24
         top             =   210
         width           =   1410
         begin vb.textbox txtintervaloparaconexion 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   240
            tabindex        =   26
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.textbox txttrabajo 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   240
            tabindex        =   25
            text            =   "0"
            top             =   1200
            width           =   930
         end
         begin vb.label label14 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "intervalocon"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   240
            tabindex        =   28
            top             =   270
            width           =   1095
         end
         begin vb.label label16 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "trabajo"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   240
            tabindex        =   27
            top             =   960
            width           =   660
         end
      end
      begin vb.frame frame8 
         backcolor       =   &h00ffc0c0&
         caption         =   "combate"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   1545
         tabindex        =   19
         top             =   210
         width           =   1410
         begin vb.textbox txtpuedeatacar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   135
            tabindex        =   22
            text            =   "0"
            top             =   1200
            width           =   930
         end
         begin vb.textbox txtintervalolanzahechizo 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   120
            tabindex        =   20
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.label label17 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "puede atacar"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   135
            tabindex        =   23
            top             =   930
            width           =   1170
         end
         begin vb.label label15 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "lanza spell"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   150
            tabindex        =   21
            top             =   285
            width           =   1005
         end
      end
      begin vb.frame frame3 
         backcolor       =   &h00ffc0c0&
         caption         =   "hambre y sed"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   5925
         tabindex        =   14
         top             =   210
         width           =   1410
         begin vb.textbox txtintervalohambre 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   16
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.textbox txtintervalosed 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   15
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.label label5 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "hambre"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   180
            tabindex        =   18
            top             =   255
            width           =   660
         end
         begin vb.label label6 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "sed"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   165
            tabindex        =   17
            top             =   930
            width           =   345
         end
      end
      begin vb.frame frame1 
         backcolor       =   &h00ffc0c0&
         caption         =   "sanar"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   4470
         tabindex        =   9
         top             =   210
         width           =   1410
         begin vb.textbox txtsanaintervalodescansar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   11
            text            =   "0"
            top             =   480
            width           =   1050
         end
         begin vb.textbox txtsanaintervalosindescansar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   10
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.label label3 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "descansando"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   180
            tabindex        =   13
            top             =   255
            width           =   1170
         end
         begin vb.label label1 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "sin descansar"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   165
            tabindex        =   12
            top             =   930
            width           =   1215
         end
      end
      begin vb.frame frame2 
         backcolor       =   &h00ffc0c0&
         caption         =   "stamina"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   3015
         tabindex        =   4
         top             =   210
         width           =   1410
         begin vb.textbox txtstaminaintervalosindescansar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   150
            tabindex        =   6
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.textbox txtstaminaintervalodescansar 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   285
            left            =   165
            tabindex        =   5
            text            =   "0"
            top             =   480
            width           =   1050
         end
         begin vb.label label2 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "sin descansar"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   165
            tabindex        =   8
            top             =   930
            width           =   1215
         end
         begin vb.label label4 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "descansando"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   180
            tabindex        =   7
            top             =   255
            width           =   1170
         end
      end
   end
   begin vb.frame frame5 
      backcolor       =   &h00ffc0c0&
      caption         =   "magia"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   120
      tabindex        =   2
      top             =   2160
      width           =   2655
      begin vb.frame frame10 
         backcolor       =   &h00ffc0c0&
         caption         =   "duracion spells"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1650
         left            =   135
         tabindex        =   29
         top             =   270
         width           =   2400
         begin vb.textbox txtinvocacion 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   1170
            tabindex        =   37
            text            =   "0"
            top             =   1170
            width           =   900
         end
         begin vb.textbox txtintervaloinvisible 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   1170
            tabindex        =   34
            text            =   "0"
            top             =   495
            width           =   900
         end
         begin vb.textbox txtintervaloparalizado 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   195
            tabindex        =   31
            text            =   "0"
            top             =   1170
            width           =   795
         end
         begin vb.textbox txtintervaloveneno 
            backcolor       =   &h00c0ffff&
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   300
            left            =   195
            tabindex        =   30
            text            =   "0"
            top             =   510
            width           =   795
         end
         begin vb.label label18 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "invocaci�n"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   1170
            tabindex        =   38
            top             =   960
            width           =   945
         end
         begin vb.label label11 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "invisible"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   1170
            tabindex        =   35
            top             =   285
            width           =   720
         end
         begin vb.label label10 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "paralizado"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   225
            tabindex        =   33
            top             =   960
            width           =   900
         end
         begin vb.label label8 
            autosize        =   -1  'true
            backstyle       =   0  'transparent
            caption         =   "veneno"
            beginproperty font 
               name            =   "ms sans serif"
               size            =   8.25
               charset         =   0
               weight          =   700
               underline       =   0   'false
               italic          =   0   'false
               strikethrough   =   0   'false
            endproperty
            height          =   195
            left            =   225
            tabindex        =   32
            top             =   300
            width           =   660
         end
      end
   end
   begin vb.commandbutton ok 
      backcolor       =   &h00ffc0c0&
      cancel          =   -1  'true
      caption         =   "salir (esc)"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   1
      top             =   4320
      width           =   1695
   end
end
attribute vb_name = "frminterv"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
'
'this program is free software; you can redistribute it and/or modify
'it under the terms of the affero general public license;
'either version 1 of the license, or any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the affero general public license
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'
'argentum online is based on baronsoft's vb6 online rpg
'you can contact the original creator of ore at aaron@baronsoft.com
'for more information about ore please visit http://www.baronsoft.com/
'
'
'you can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'calle 3 n�mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c�digo postal 1900
'pablo ignacio m�rquez

option explicit

public sub aplicarintervalos()

'�?�?�?�?�?�?�?�?�?�?� intervalos del main loop �?�?�?�?�?�?�?�?�
sanaintervalosindescansar = val(txtsanaintervalosindescansar.text)
staminaintervalosindescansar = val(txtstaminaintervalosindescansar.text)
sanaintervalodescansar = val(txtsanaintervalodescansar.text)
staminaintervalodescansar = val(txtstaminaintervalodescansar.text)
intervalosed = val(txtintervalosed.text)
intervalohambre = val(txtintervalohambre.text)
intervaloveneno = val(txtintervaloveneno.text)
intervaloparalizado = val(txtintervaloparalizado.text)
intervaloinvisible = val(txtintervaloinvisible.text)
intervalofrio = val(txtintervalofrio.text)
intervalowavfx = val(txtintervalowavfx.text)
intervaloinvocacion = val(txtinvocacion.text)
intervaloparaconexion = val(txtintervaloparaconexion.text)

'///////////////// timers \\\\\\\\\\\\\\\\\\\

intervalouserpuedecastear = val(txtintervalolanzahechizo.text)
frmmain.npcataca.interval = val(txtnpcpuedeatacar.text)
frmmain.timer_ai.interval = val(txtai.text)
intervalouserpuedetrabajar = val(txttrabajo.text)
intervalouserpuedeatacar = val(txtpuedeatacar.text)
frmmain.tlluvia.interval = val(txtintervaloperdidastaminalluvia.text)



end sub

private sub command1_click()
on error resume next
call aplicarintervalos

end sub

private sub command2_click()

on error goto err

'intervalos
call writevar(inipath & "server.ini", "intervalos", "sanaintervalosindescansar", str(sanaintervalosindescansar))
call writevar(inipath & "server.ini", "intervalos", "staminaintervalosindescansar", str(staminaintervalosindescansar))
call writevar(inipath & "server.ini", "intervalos", "sanaintervalodescansar", str(sanaintervalodescansar))
call writevar(inipath & "server.ini", "intervalos", "staminaintervalodescansar", str(staminaintervalodescansar))
call writevar(inipath & "server.ini", "intervalos", "intervalosed", str(intervalosed))
call writevar(inipath & "server.ini", "intervalos", "intervalohambre", str(intervalohambre))
call writevar(inipath & "server.ini", "intervalos", "intervaloveneno", str(intervaloveneno))
call writevar(inipath & "server.ini", "intervalos", "intervaloparalizado", str(intervaloparalizado))
call writevar(inipath & "server.ini", "intervalos", "intervaloinvisible", str(intervaloinvisible))
call writevar(inipath & "server.ini", "intervalos", "intervalofrio", str(intervalofrio))
call writevar(inipath & "server.ini", "intervalos", "intervalowavfx", str(intervalowavfx))
call writevar(inipath & "server.ini", "intervalos", "intervaloinvocacion", str(intervaloinvocacion))
call writevar(inipath & "server.ini", "intervalos", "intervaloparaconexion", str(intervaloparaconexion))

'&&&&&&&&&&&&&&&&&&&&& timers &&&&&&&&&&&&&&&&&&&&&&&

call writevar(inipath & "server.ini", "intervalos", "intervalolanzahechizo", str(intervalouserpuedecastear))
call writevar(inipath & "server.ini", "intervalos", "intervalonpcai", frmmain.timer_ai.interval)
call writevar(inipath & "server.ini", "intervalos", "intervalonpcpuedeatacar", frmmain.npcataca.interval)
call writevar(inipath & "server.ini", "intervalos", "intervalotrabajo", str(intervalouserpuedetrabajar))
call writevar(inipath & "server.ini", "intervalos", "intervalouserpuedeatacar", str(intervalouserpuedeatacar))
call writevar(inipath & "server.ini", "intervalos", "intervaloperdidastaminalluvia", frmmain.tlluvia.interval)


msgbox "los intervalos se han guardado sin problemas."

exit sub
err:
    msgbox "error al intentar grabar los intervalos"
end sub

private sub ok_click()
    me.visible = false
end sub

