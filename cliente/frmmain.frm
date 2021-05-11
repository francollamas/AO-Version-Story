version 5.00
object = "{3b7c8863-d78f-101b-b9b5-04021c009402}#1.2#0"; "richtx32.ocx"
object = "{33101c00-75c3-11cf-a8a0-444553540000}#1.0#0"; "cswsk32.ocx"
object = "{248dd890-bb45-11cf-9abc-0080c7e7b78d}#1.0#0"; "mswinsck.ocx"
begin vb.form frmmain 
   borderstyle     =   0  'none
   clientheight    =   8700
   clientleft      =   360
   clienttop       =   300
   clientwidth     =   12000
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   forecolor       =   &h00000000&
   icon            =   "frmmain.frx":0000
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   palettemode     =   1  'usezorder
   scaleheight     =   580
   scalemode       =   3  'pixel
   scalewidth      =   800
   startupposition =   2  'centerscreen
   visible         =   0   'false
   begin socketwrenchctrl.socket socket1 
      left            =   6750
      top             =   1920
      _version        =   65536
      _extentx        =   741
      _extenty        =   741
      _stockprops     =   0
      autoresolve     =   0   'false
      backlog         =   1
      binary          =   -1  'true
      blocking        =   0   'false
      broadcast       =   0   'false
      buffersize      =   10240
      hostaddress     =   ""
      hostfile        =   ""
      hostname        =   ""
      inline          =   0   'false
      interval        =   0
      keepalive       =   0   'false
      library         =   ""
      linger          =   0
      localport       =   0
      localservice    =   ""
      protocol        =   0
      remoteport      =   0
      remoteservice   =   ""
      reuseaddress    =   0   'false
      route           =   -1  'true
      timeout         =   10000
      type            =   1
      urgent          =   0   'false
   end
   begin vb.picturebox picsm 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h80000005&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   450
      index           =   3
      left            =   11325
      mousepointer    =   99  'custom
      scaleheight     =   450
      scalewidth      =   420
      tabindex        =   30
      top             =   8445
      width           =   420
   end
   begin vb.picturebox picsm 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h80000005&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   450
      index           =   2
      left            =   10950
      mousepointer    =   99  'custom
      scaleheight     =   450
      scalewidth      =   420
      tabindex        =   29
      top             =   8445
      width           =   420
   end
   begin vb.picturebox picsm 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h80000005&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   450
      index           =   1
      left            =   10575
      mousepointer    =   99  'custom
      scaleheight     =   450
      scalewidth      =   420
      tabindex        =   28
      top             =   8445
      width           =   420
   end
   begin vb.picturebox picsm 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h80000005&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   450
      index           =   0
      left            =   10200
      mousepointer    =   99  'custom
      scaleheight     =   30
      scalemode       =   3  'pixel
      scalewidth      =   28
      tabindex        =   27
      top             =   8445
      width           =   420
   end
   begin vb.picturebox picinv 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      causesvalidation=   0   'false
      clipcontrols    =   0   'false
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h80000008&
      height          =   1920
      left            =   9000
      scaleheight     =   128
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   16
      top             =   2400
      width           =   2400
   end
   begin mswinsocklib.winsock winsock2 
      left            =   5760
      top             =   1920
      _extentx        =   741
      _extenty        =   741
      _version        =   393216
   end
   begin vb.textbox sendtxt 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   315
      left            =   150
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   2
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   1839
      visible         =   0   'false
      width           =   8190
   end
   begin vb.timer macrotrabajo 
      enabled         =   0   'false
      left            =   7080
      top             =   2520
   end
   begin vb.timer trainingmacro 
      enabled         =   0   'false
      interval        =   3121
      left            =   6600
      top             =   2520
   end
   begin vb.textbox sendcmstxt 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   315
      left            =   120
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   1
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   8520
      visible         =   0   'false
      width           =   8250
   end
   begin vb.timer macro 
      interval        =   750
      left            =   5760
      top             =   2520
   end
   begin mswinsocklib.winsock winsock1 
      left            =   6240
      top             =   1920
      _extentx        =   741
      _extenty        =   741
      _version        =   393216
   end
   begin vb.timer second 
      enabled         =   0   'false
      interval        =   1050
      left            =   4920
      top             =   2520
   end
   begin vb.timer spoofcheck 
      enabled         =   0   'false
      interval        =   60000
      left            =   4200
      top             =   2520
   end
   begin richtextlib.richtextbox rectxt 
      height          =   1478
      left            =   150
      tabindex        =   0
      tabstop         =   0   'false
      tooltiptext     =   "mensajes del servidor"
      top             =   360
      width           =   8205
      _extentx        =   14473
      _extenty        =   2619
      _version        =   393217
      backcolor       =   0
      enabled         =   -1  'true
      readonly        =   -1  'true
      scrollbars      =   2
      disablenoscroll =   -1  'true
      textrtf         =   $"frmmain.frx":030a
      beginproperty font {0be35203-8f91-11ce-9de3-00aa004bb851} 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
   end
   begin vb.listbox hlst 
      backcolor       =   &h00000000&
      forecolor       =   &h00ffffff&
      height          =   2790
      left            =   8880
      tabindex        =   17
      tabstop         =   0   'false
      top             =   2400
      visible         =   0   'false
      width           =   2565
   end
   begin vb.image imgmapa 
      height          =   300
      left            =   10230
      top             =   6675
      width           =   1395
   end
   begin vb.image imgclanes 
      height          =   390
      left            =   10245
      top             =   7980
      width           =   1380
   end
   begin vb.image imgestadisticas 
      height          =   360
      left            =   10215
      top             =   7605
      width           =   1425
   end
   begin vb.image imgopciones 
      height          =   330
      left            =   10215
      top             =   7275
      width           =   1425
   end
   begin vb.image imggrupo 
      height          =   315
      left            =   10215
      top             =   6990
      width           =   1410
   end
   begin vb.image imgasignarskill 
      height          =   450
      left            =   9975
      mousepointer    =   99  'custom
      top             =   690
      width           =   450
   end
   begin vb.label lbldropgold 
      backstyle       =   0  'transparent
      height          =   255
      left            =   10560
      mousepointer    =   99  'custom
      tabindex        =   33
      top             =   6240
      width           =   255
   end
   begin vb.label lblminimizar 
      backstyle       =   0  'transparent
      height          =   255
      left            =   11280
      mousepointer    =   99  'custom
      tabindex        =   32
      top             =   60
      width           =   255
   end
   begin vb.label lblcerrar 
      backstyle       =   0  'transparent
      height          =   255
      left            =   11550
      mousepointer    =   99  'custom
      tabindex        =   31
      top             =   60
      width           =   255
   end
   begin vb.label label7 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   450
      left            =   10320
      mouseicon       =   "frmmain.frx":0388
      mousepointer    =   99  'custom
      tabindex        =   19
      top             =   1920
      width           =   1125
   end
   begin vb.label lblfps 
      backstyle       =   0  'transparent
      caption         =   "101"
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   6705
      tabindex        =   26
      top             =   60
      width           =   555
   end
   begin vb.image imginvscrolldown 
      height          =   795
      left            =   10020
      top             =   5595
      visible         =   0   'false
      width           =   420
   end
   begin vb.image imginvscrollup 
      height          =   1065
      left            =   10005
      top             =   4545
      visible         =   0   'false
      width           =   420
   end
   begin vb.image cmdinfo 
      height          =   405
      left            =   10680
      mouseicon       =   "frmmain.frx":04da
      mousepointer    =   99  'custom
      top             =   5280
      visible         =   0   'false
      width           =   855
   end
   begin vb.label lblmapname 
      backstyle       =   0  'transparent
      enabled         =   0   'false
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ffff&
      height          =   255
      left            =   8700
      tabindex        =   25
      top             =   8445
      visible         =   0   'false
      width           =   1935
   end
   begin vb.image cmdmoverhechi 
      height          =   240
      index           =   0
      left            =   11430
      mouseicon       =   "frmmain.frx":062c
      mousepointer    =   99  'custom
      picture         =   "frmmain.frx":077e
      top             =   3480
      visible         =   0   'false
      width           =   225
   end
   begin vb.image cmdmoverhechi 
      height          =   240
      index           =   1
      left            =   11430
      mouseicon       =   "frmmain.frx":0ac2
      mousepointer    =   99  'custom
      picture         =   "frmmain.frx":0c14
      top             =   3225
      visible         =   0   'false
      width           =   225
   end
   begin vb.image xz 
      height          =   255
      index           =   0
      left            =   11400
      top             =   0
      width           =   255
   end
   begin vb.image xzz 
      height          =   195
      index           =   1
      left            =   11445
      top             =   0
      width           =   225
   end
   begin vb.label lblname 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   195
      left            =   8760
      tabindex        =   24
      top             =   360
      width           =   2625
   end
   begin vb.label lbllvl 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "255"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   9825
      tabindex        =   23
      top             =   1140
      width           =   270
   end
   begin vb.label label6 
      backstyle       =   0  'transparent
      caption         =   "nivel"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   9225
      tabindex        =   22
      top             =   1140
      width           =   465
   end
   begin vb.label lblporclvl 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "33.33%"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffff00&
      height          =   225
      left            =   9225
      tabindex        =   21
      top             =   1320
      width           =   555
   end
   begin vb.label lblexp 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "exp: 999999999/99999999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   9225
      tabindex        =   20
      top             =   1500
      width           =   2010
   end
   begin vb.image cmdlanzar 
      height          =   375
      left            =   8760
      mouseicon       =   "frmmain.frx":0f58
      mousepointer    =   99  'custom
      top             =   5280
      visible         =   0   'false
      width           =   1155
   end
   begin vb.label label4 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   435
      left            =   8880
      mouseicon       =   "frmmain.frx":10aa
      mousepointer    =   99  'custom
      tabindex        =   18
      top             =   1920
      width           =   1395
   end
   begin vb.label gldlbl 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "1"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   210
      left            =   10920
      tabindex        =   15
      top             =   6270
      width           =   90
   end
   begin vb.label lblstrg 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "00"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ffff&
      height          =   210
      left            =   9720
      tabindex        =   9
      top             =   6225
      width           =   210
   end
   begin vb.label lbldext 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "00"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ffff&
      height          =   210
      left            =   9120
      tabindex        =   8
      top             =   6225
      width           =   210
   end
   begin vb.label coord 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "000 x:00 y: 00"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ffff&
      height          =   255
      left            =   8700
      tabindex        =   7
      top             =   8670
      width           =   1335
   end
   begin vb.label lblweapon 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "000/000"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   255
      left            =   6960
      tabindex        =   6
      top             =   8640
      width           =   855
   end
   begin vb.label lblshielder 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "00/00"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   255
      left            =   5130
      tabindex        =   5
      top             =   8640
      width           =   855
   end
   begin vb.label lblhelm 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "00/00"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   255
      left            =   2940
      tabindex        =   4
      top             =   8640
      width           =   855
   end
   begin vb.label lblarmor 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "00/00"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   255
      left            =   1170
      tabindex        =   3
      top             =   8640
      width           =   855
   end
   begin vb.image imgscroll 
      height          =   240
      index           =   1000
      left            =   11400
      mousepointer    =   99  'custom
      top             =   3225
      width           =   225
   end
   begin vb.shape mainviewshp 
      bordercolor     =   &h00404040&
      height          =   6240
      left            =   180
      top             =   2235
      visible         =   0   'false
      width           =   8160
   end
   begin vb.image invequ 
      height          =   4230
      left            =   8715
      top             =   1875
      width           =   2970
   end
   begin vb.label lblmana 
      alignment       =   2  'center
      backcolor       =   &h00c0c000&
      backstyle       =   0  'transparent
      caption         =   "9999/9999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   8760
      tabindex        =   11
      top             =   7140
      width           =   1095
   end
   begin vb.label lblenergia 
      alignment       =   2  'center
      backcolor       =   &h0000c0c0&
      backstyle       =   0  'transparent
      caption         =   "999/999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   8760
      tabindex        =   10
      top             =   6780
      width           =   1095
   end
   begin vb.label lblvida 
      alignment       =   2  'center
      backcolor       =   &h000000ff&
      backstyle       =   0  'transparent
      caption         =   "999/999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   8760
      tabindex        =   12
      top             =   7455
      width           =   1095
   end
   begin vb.label lblhambre 
      alignment       =   2  'center
      backcolor       =   &h00004000&
      backstyle       =   0  'transparent
      caption         =   "999/999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   8760
      tabindex        =   13
      top             =   7800
      width           =   1095
   end
   begin vb.label lblsed 
      alignment       =   2  'center
      backcolor       =   &h00400000&
      backstyle       =   0  'transparent
      caption         =   "999/999"
      beginproperty font 
         name            =   "arial"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   180
      left            =   8760
      tabindex        =   14
      top             =   8130
      width           =   1095
   end
   begin vb.shape shpenergia 
      fillstyle       =   0  'solid
      height          =   180
      left            =   8760
      top             =   6795
      width           =   1125
   end
   begin vb.shape shpmana 
      fillstyle       =   0  'solid
      height          =   180
      left            =   8760
      top             =   7155
      width           =   1125
   end
   begin vb.shape shpvida 
      fillstyle       =   0  'solid
      height          =   180
      left            =   8760
      top             =   7470
      width           =   1125
   end
   begin vb.shape shphambre 
      fillstyle       =   0  'solid
      height          =   180
      left            =   8760
      top             =   7815
      width           =   1125
   end
   begin vb.shape shpsed 
      fillstyle       =   0  'solid
      height          =   180
      left            =   8760
      top             =   8160
      width           =   1125
   end
   begin vb.menu mnuobj 
      caption         =   "objeto"
      visible         =   0   'false
      begin vb.menu mnutirar 
         caption         =   "tirar"
      end
      begin vb.menu mnuusar 
         caption         =   "usar"
      end
      begin vb.menu mnuequipar 
         caption         =   "equipar"
      end
   end
   begin vb.menu mnunpc 
      caption         =   "npc"
      visible         =   0   'false
      begin vb.menu mnunpcdesc 
         caption         =   "descripcion"
      end
      begin vb.menu mnunpccomerciar 
         caption         =   "comerciar"
         visible         =   0   'false
      end
   end
end
attribute vb_name = "frmmain"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

public tx as byte
public ty as byte
public mousex as long
public mousey as long
public mouseboton as long
public mouseshift as long
private clicx as long
private clicy as long

public isplaying as byte

private clsformulario as clsformmovementmanager

private cbotondiamarriba as clsgraphicalbutton
private cbotondiamabajo as clsgraphicalbutton
private cbotonmapa as clsgraphicalbutton
private cbotongrupo as clsgraphicalbutton
private cbotonopciones as clsgraphicalbutton
private cbotonestadisticas as clsgraphicalbutton
private cbotonclanes as clsgraphicalbutton
private cbotonasignarskill as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

public picskillstar as picture

dim puedemacrear as boolean

private sub form_load()
    
    if nores then
        ' handles form movement (drag and drop).
        set clsformulario = new clsformmovementmanager
        clsformulario.initialize me, 120
    end if

    me.picture = loadpicture(dirgraficos & "ventanaprincipal.jpg")
    
    invequ.picture = loadpicture(dirgraficos & "centroinventario.jpg")
    
    call loadbuttons
    
    me.left = 0
    me.top = 0
end sub

private sub loadbuttons()
    dim grhpath as string
    dim i as integer
    
    grhpath = dirgraficos

    set cbotondiamarriba = new clsgraphicalbutton
    set cbotondiamabajo = new clsgraphicalbutton
    set cbotongrupo = new clsgraphicalbutton
    set cbotonopciones = new clsgraphicalbutton
    set cbotonestadisticas = new clsgraphicalbutton
    set cbotonclanes = new clsgraphicalbutton
    set cbotonasignarskill = new clsgraphicalbutton
    set cbotonmapa = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotondiamarriba.initialize(imginvscrollup, "", _
                                    grhpath & "botondiamarribaf.bmp", _
                                    grhpath & "botondiamarribaf.bmp", me)

    call cbotondiamabajo.initialize(imginvscrolldown, "", _
                                    grhpath & "botondiamabajof.bmp", _
                                    grhpath & "botondiamabajof.bmp", me)
    
    call cbotonmapa.initialize(imgmapa, "", _
                                    grhpath & "botonmaparollover.jpg", _
                                    grhpath & "botonmapaclick.jpg", me)
                                    
    call cbotongrupo.initialize(imggrupo, "", _
                                    grhpath & "botongruporollover.jpg", _
                                    grhpath & "botongrupoclick.jpg", me)

    call cbotonopciones.initialize(imgopciones, "", _
                                    grhpath & "botonopcionesrollover.jpg", _
                                    grhpath & "botonopcionesclick.jpg", me)

    call cbotonestadisticas.initialize(imgestadisticas, "", _
                                    grhpath & "botonestadisticasrollover.jpg", _
                                    grhpath & "botonestadisticasclick.jpg", me)

    call cbotonclanes.initialize(imgclanes, "", _
                                    grhpath & "botonclanesrollover.jpg", _
                                    grhpath & "botonclanesclick.jpg", me)

    set picskillstar = loadpicture(grhpath & "botonasignarskills.bmp")

    if skillpoints > 0 then imgasignarskill.picture = picskillstar
    
    imgasignarskill.mouseicon = picmouseicon
    lbldropgold.mouseicon = picmouseicon
    lblcerrar.mouseicon = picmouseicon
    lblminimizar.mouseicon = picmouseicon
    
    for i = 0 to 3
        picsm(i).mouseicon = picmouseicon
    next i
end sub

public sub lightskillstar(byval bturnon as boolean)
    if bturnon then
        imgasignarskill.picture = picskillstar
    else
        set imgasignarskill.picture = nothing
    end if
end sub

private sub cmdmoverhechi_click(index as integer)
    if hlst.visible = true then
        if hlst.listindex = -1 then exit sub
        dim stemp as string
    
        select case index
            case 1 'subir
                if hlst.listindex = 0 then exit sub
            case 0 'bajar
                if hlst.listindex = hlst.listcount - 1 then exit sub
        end select
    
        call writemovespell(index = 1, hlst.listindex + 1)
        
        select case index
            case 1 'subir
                stemp = hlst.list(hlst.listindex - 1)
                hlst.list(hlst.listindex - 1) = hlst.list(hlst.listindex)
                hlst.list(hlst.listindex) = stemp
                hlst.listindex = hlst.listindex - 1
            case 0 'bajar
                stemp = hlst.list(hlst.listindex + 1)
                hlst.list(hlst.listindex + 1) = hlst.list(hlst.listindex)
                hlst.list(hlst.listindex) = stemp
                hlst.listindex = hlst.listindex + 1
        end select
    end if
end sub

public sub activarmacrohechizos()
    if not hlst.visible then
        call addtorichtextbox(frmmain.rectxt, "debes tener seleccionado el hechizo para activar el auto-lanzar", 0, 200, 200, false, true, true)
        exit sub
    end if
    
    trainingmacro.interval = int_macro_hechis
    trainingmacro.enabled = true
    call addtorichtextbox(frmmain.rectxt, "auto lanzar hechizos activado", 0, 200, 200, false, true, true)
    call controlsm(esmtype.mspells, true)
end sub

public sub desactivarmacrohechizos()
    trainingmacro.enabled = false
    call addtorichtextbox(frmmain.rectxt, "auto lanzar hechizos desactivado", 0, 150, 150, false, true, true)
    call controlsm(esmtype.mspells, false)
end sub

public sub controlsm(byval index as byte, byval mostrar as boolean)
dim grhindex as long
dim sr as rect
dim dr as rect

grhindex = grh_ini_sm + index + sm_cant * (cint(mostrar) + 1)

with grhdata(grhindex)
    sr.left = .sx
    sr.right = sr.left + .pixelwidth
    sr.top = .sy
    sr.bottom = sr.top + .pixelheight
    
    dr.left = 0
    dr.right = .pixelwidth
    dr.top = 0
    dr.bottom = .pixelheight
end with

call drawgrhtohdc(picsm(index).hdc, grhindex, sr, dr)
picsm(index).refresh

select case index
    case esmtype.sresucitation
        if mostrar then
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_resu_on, 0, 255, 0, true, false, true)
            picsm(index).tooltiptext = "seguro de resucitaci�n activado."
        else
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_resu_off, 255, 0, 0, true, false, true)
            picsm(index).tooltiptext = "seguro de resucitaci�n desactivado."
        end if
        
    case esmtype.ssafemode
        if mostrar then
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_activado, 0, 255, 0, true, false, true)
            picsm(index).tooltiptext = "seguro activado."
        else
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_desactivado, 255, 0, 0, true, false, true)
            picsm(index).tooltiptext = "seguro desactivado."
        end if
        
    case esmtype.mspells
        if mostrar then
            picsm(index).tooltiptext = "macro de hechizos activado."
        else
            picsm(index).tooltiptext = "macro de hechizos desactivado."
        end if
        
    case esmtype.mwork
        if mostrar then
            picsm(index).tooltiptext = "macro de trabajo activado."
        else
            picsm(index).tooltiptext = "macro de trabajo desactivado."
        end if
end select

smstatus(index) = mostrar
end sub

private sub form_keyup(keycode as integer, shift as integer)
'***************************************************
'autor: unknown
'last modification: 18/11/2009
'18/11/2009: zama - ahora se pueden poner comandos en los mensajes personalizados (execpto guildchat y privados)
'***************************************************
#if seguridadalkon then
    if logging then call cheatingdeath.storekey(keycode, false)
#end if
    
    if (not sendtxt.visible) and (not sendcmstxt.visible) then
        
        'checks if the key is valid
        if lenb(customkeys.readablename(keycode)) > 0 then
            select case keycode
                case customkeys.bindedkey(ekeytype.mkeytogglemusic)
                    audio.musicactivated = not audio.musicactivated
                    
                case customkeys.bindedkey(ekeytype.mkeytogglesound)
                    audio.soundactivated = not audio.soundactivated
                    
                case customkeys.bindedkey(ekeytype.mkeytogglefxs)
                    audio.soundeffectsactivated = not audio.soundeffectsactivated
                
                case customkeys.bindedkey(ekeytype.mkeygetobject)
                    call agarraritem
                
                case customkeys.bindedkey(ekeytype.mkeyequipobject)
                    call equiparitem
                
                case customkeys.bindedkey(ekeytype.mkeytogglenames)
                    nombres = not nombres
                
                case customkeys.bindedkey(ekeytype.mkeytamanimal)
                    if userestado = 1 then
                        with fonttypes(fonttypenames.fonttype_info)
                            call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                        end with
                    else
                        call writework(eskill.domar)
                    end if
                    
                case customkeys.bindedkey(ekeytype.mkeysteal)
                    if userestado = 1 then
                        with fonttypes(fonttypenames.fonttype_info)
                            call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                        end with
                    else
                        call writework(eskill.robar)
                    end if
                    
                case customkeys.bindedkey(ekeytype.mkeyhide)
                    if userestado = 1 then
                        with fonttypes(fonttypenames.fonttype_info)
                            call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                        end with
                    else
                        call writework(eskill.ocultarse)
                    end if
                                    
                case customkeys.bindedkey(ekeytype.mkeydropobject)
                    call tiraritem
                
                case customkeys.bindedkey(ekeytype.mkeyuseobject)
                    if macrotrabajo.enabled then call desactivarmacrotrabajo
                        
                    if maintimer.check(timersindex.useitemwithu) then
                        call usaritem
                    end if
                
                case customkeys.bindedkey(ekeytype.mkeyrequestrefresh)
                    if maintimer.check(timersindex.sendrpu) then
                        call writerequestpositionupdate
                        beep
                    end if
                case customkeys.bindedkey(ekeytype.mkeytogglesafemode)
                    call writesafetoggle

                case customkeys.bindedkey(ekeytype.mkeytoggleresuscitationsafe)
                    call writeresuscitationtoggle
            end select
        else
            select case keycode
                'custom messages!
                case vbkey0 to vbkey9
                    dim custommessage as string
                    
                    custommessage = custommessages.message((keycode - 39) mod 10)
                    if lenb(custommessage) <> 0 then
                        ' no se pueden mandar mensajes personalizados de clan o privado!
                        if ucase(left(custommessage, 5)) <> "/cmsg" and _
                            left(custommessage, 1) <> "\" then
                            
                            call parseusercommand(custommessage)
                        end if
                    end if
            end select
        end if
    end if
    
    select case keycode
        case customkeys.bindedkey(ekeytype.mkeytalkwithguild)
            if sendtxt.visible then exit sub
            
            if (not comerciando) and (not mirandoasignarskills) and _
              (not frmmsg.visible) and (not mirandoforo) and _
              (not frmestadisticas.visible) and (not frmcantidad.visible) then
                sendcmstxt.visible = true
                sendcmstxt.setfocus
            end if
        
        case customkeys.bindedkey(ekeytype.mkeytakescreenshot)
            call screencapture
                
        case customkeys.bindedkey(ekeytype.mkeyshowoptions)
            call frmopciones.show(vbmodeless, frmmain)
        
        case customkeys.bindedkey(ekeytype.mkeymeditate)
            if userminman = usermaxman then exit sub
            
            if userestado = 1 then
                with fonttypes(fonttypenames.fonttype_info)
                    call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                end with
                exit sub
            end if
                
            if not puedemacrear then
                addtorichtextbox frmmain.rectxt, "no tan r�pido..!", 255, 255, 255, false, false, true
            else
                call writemeditate
                puedemacrear = false
            end if
        
        case customkeys.bindedkey(ekeytype.mkeycastspellmacro)
            if userestado = 1 then
                with fonttypes(fonttypenames.fonttype_info)
                    call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                end with
                exit sub
            end if
            
            if trainingmacro.enabled then
                desactivarmacrohechizos
            else
                activarmacrohechizos
            end if
        
        case customkeys.bindedkey(ekeytype.mkeyworkmacro)
            if userestado = 1 then
                with fonttypes(fonttypenames.fonttype_info)
                    call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                end with
                exit sub
            end if
            
            if macrotrabajo.enabled then
                call desactivarmacrotrabajo
            else
                call activarmacrotrabajo
            end if
        
        case customkeys.bindedkey(ekeytype.mkeyexitgame)
            if frmmain.macrotrabajo.enabled then call desactivarmacrotrabajo
            call writequit
            
        case customkeys.bindedkey(ekeytype.mkeyattack)
            if shift <> 0 then exit sub
            
            if not maintimer.check(timersindex.arrows, false) then exit sub 'check if arrows interval has finished.
            if not maintimer.check(timersindex.castspell, false) then 'check if spells interval has finished.
                if not maintimer.check(timersindex.castattack) then exit sub 'corto intervalo golpe-hechizo
            else
                if not maintimer.check(timersindex.attack) or userdescansar or usermeditar then exit sub
            end if
            
            if trainingmacro.enabled then call desactivarmacrohechizos
            if macrotrabajo.enabled then call desactivarmacrotrabajo
            call writeattack
        
        case customkeys.bindedkey(ekeytype.mkeytalk)
            if sendcmstxt.visible then exit sub
            
            if (not comerciando) and (not mirandoasignarskills) and _
              (not frmmsg.visible) and (not mirandoforo) and _
              (not frmestadisticas.visible) and (not frmcantidad.visible) then
                sendtxt.visible = true
                sendtxt.setfocus
            end if
            
    end select
end sub

private sub form_mousedown(button as integer, shift as integer, x as single, y as single)
    mouseboton = button
    mouseshift = shift
end sub

private sub form_mouseup(button as integer, shift as integer, x as single, y as single)
    clicx = x
    clicy = y
end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
    if prgrun = true then
        prgrun = false
        cancel = 1
    end if
end sub

private sub imgasignarskill_click()
    dim i as integer
    
    llegaronskills = false
    call writerequestskills
    call flushbuffer
    
    do while not llegaronskills
        doevents 'esperamos a que lleguen y mantenemos la interfaz viva
    loop
    llegaronskills = false
    
    for i = 1 to numskills
        frmskills3.text1(i).caption = userskills(i)
    next i
    
    alocados = skillpoints
    frmskills3.puntos.caption = skillpoints
    frmskills3.show , frmmain

end sub

private sub imgclanes_click()
    if frmguildleader.visible then unload frmguildleader
    call writerequestguildleaderinfo
end sub

private sub imgestadisticas_click()
    llegaronatrib = false
    llegaronskills = false
    llegofama = false
    call writerequestatributes
    call writerequestskills
    call writerequestministats
    call writerequestfame
    call flushbuffer
    do while not llegaronskills or not llegaronatrib or not llegofama
        doevents 'esperamos a que lleguen y mantenemos la interfaz viva
    loop
    frmestadisticas.iniciar_labels
    frmestadisticas.show , frmmain
    llegaronatrib = false
    llegaronskills = false
    llegofama = false
end sub

private sub imggrupo_click()
    call writerequestpartyform
end sub

private sub imginvscrolldown_click()
    call inventario.scrollinventory(true)
end sub

private sub imginvscrollup_click()
    call inventario.scrollinventory(false)
end sub

private sub imgmapa_click()
    call frmmapa.show(vbmodeless, frmmain)
end sub

private sub imgopciones_click()
    call frmopciones.show(vbmodeless, frmmain)
end sub

private sub invequ_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub lblscroll_click(index as integer)
    inventario.scrollinventory (index = 0)
end sub

private sub lblcerrar_click()
    prgrun = false
end sub

private sub lblminimizar_click()
    me.windowstate = 1
end sub

private sub macro_timer()
    puedemacrear = true
end sub

private sub macrotrabajo_timer()
    if inventario.selecteditem = 0 then
        call desactivarmacrotrabajo
        exit sub
    end if
    
    'macros are disabled if not using argentum!
    if not application.isappactive() then
        call desactivarmacrotrabajo
        exit sub
    end if
    
    if usingskill = eskill.pesca or usingskill = eskill.talar or usingskill = eskill.mineria or _
                usingskill = fundirmetal or (usingskill = eskill.herreria and not frmherrero.visible) then
        call writeworkleftclick(tx, ty, usingskill)
        usingskill = 0
    end if
    
    'if inventario.objtype(inventario.selecteditem) = eobjtype.otweapon then
     if not (frmcarp.visible = true) then call usaritem
end sub

public sub activarmacrotrabajo()
    macrotrabajo.interval = int_macro_trabajo
    macrotrabajo.enabled = true
    call addtorichtextbox(frmmain.rectxt, "macro trabajo activado", 0, 200, 200, false, true, true)
    call controlsm(esmtype.mwork, true)
end sub

public sub desactivarmacrotrabajo()
    macrotrabajo.enabled = false
    macrobltindex = 0
    usingskill = 0
    mousepointer = vbdefault
    call addtorichtextbox(frmmain.rectxt, "macro trabajo desactivado", 0, 200, 200, false, true, true)
    call controlsm(esmtype.mwork, false)
end sub


private sub mnuequipar_click()
    call equiparitem
end sub

private sub mnunpccomerciar_click()
    call writeleftclick(tx, ty)
    call writecommercestart
end sub

private sub mnunpcdesc_click()
    call writeleftclick(tx, ty)
end sub

private sub mnutirar_click()
    call tiraritem
end sub

private sub mnuusar_click()
    call usaritem
end sub

private sub picmh_click()
    call addtorichtextbox(frmmain.rectxt, "auto lanzar hechizos. utiliza esta habilidad para entrenar �nicamente. para activarlo/desactivarlo utiliza f7.", 255, 255, 255, false, false, true)
end sub

private sub coord_click()
    call addtorichtextbox(frmmain.rectxt, "estas coordenadas son tu ubicaci�n en el mapa. utiliza la letra l para corregirla si esta no se corresponde con la del servidor por efecto del lag.", 255, 255, 255, false, false, true)
end sub

private sub picsm_dblclick(index as integer)
select case index
    case esmtype.sresucitation
        call writeresuscitationtoggle
        
    case esmtype.ssafemode
        call writesafetoggle
        
    case esmtype.mspells
        if userestado = 1 then
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
            exit sub
        end if
        
        if trainingmacro.enabled then
            call desactivarmacrohechizos
        else
            call activarmacrohechizos
        end if
        
    case esmtype.mwork
        if userestado = 1 then
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
            exit sub
        end if
        
        if macrotrabajo.enabled then
            call desactivarmacrotrabajo
        else
            call activarmacrotrabajo
        end if
end select
end sub

private sub sendtxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        if lenb(stxtbuffer) <> 0 then call parseusercommand(stxtbuffer)
        
        stxtbuffer = ""
        sendtxt.text = ""
        keycode = 0
        sendtxt.visible = false
        
        if picinv.visible then
            picinv.setfocus
        else
            hlst.setfocus
        end if
    end if
end sub

private sub spoofcheck_timer()

dim ipmmsb as byte
dim ipmsb as byte
dim iplsb as byte
dim ipllsb as byte

iplsb = 3 + 15
ipmsb = 32 + 15
ipmmsb = 200 + 15
ipllsb = 74 + 15

if ipdelservidor <> ((ipmmsb - 15) & "." & (ipmsb - 15) & "." & (iplsb - 15) _
& "." & (ipllsb - 15)) then end

end sub

private sub second_timer()
    if not dialogosclanes is nothing then dialogosclanes.passtimer
end sub

'[end]'

''''''''''''''''''''''''''''''''''''''
'     item control                   '
''''''''''''''''''''''''''''''''''''''

private sub tiraritem()
    if userestado = 1 then
        with fonttypes(fonttypenames.fonttype_info)
            call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
        end with
    else
        if (inventario.selecteditem > 0 and inventario.selecteditem < max_inventory_slots + 1) or (inventario.selecteditem = flagoro) then
            if inventario.amount(inventario.selecteditem) = 1 then
                call writedrop(inventario.selecteditem, 1)
            else
                if inventario.amount(inventario.selecteditem) > 1 then
                    if not comerciando then frmcantidad.show , frmmain
                end if
            end if
        end if
    end if
end sub

private sub agarraritem()
    if userestado = 1 then
        with fonttypes(fonttypenames.fonttype_info)
            call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
        end with
    else
        call writepickup
    end if
end sub

private sub usaritem()
    if pausa then exit sub
    
    if comerciando then exit sub
    
    if trainingmacro.enabled then desactivarmacrohechizos
    
    if (inventario.selecteditem > 0) and (inventario.selecteditem < max_inventory_slots + 1) then _
        call writeuseitem(inventario.selecteditem)
end sub

private sub equiparitem()
    if userestado = 1 then
        with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
        end with
    else
        if comerciando then exit sub
        
        if (inventario.selecteditem > 0) and (inventario.selecteditem < max_inventory_slots + 1) then _
        call writeequipitem(inventario.selecteditem)
    end if
end sub



''''''''''''''''''''''''''''''''''''''
'     hechizos control               '
''''''''''''''''''''''''''''''''''''''

private sub trainingmacro_timer()
    if not hlst.visible then
        desactivarmacrohechizos
        exit sub
    end if
    
    'macros are disabled if focus is not on argentum!
    if not application.isappactive() then
        desactivarmacrohechizos
        exit sub
    end if
    
    if comerciando then exit sub
    
    if hlst.list(hlst.listindex) <> "(none)" and maintimer.check(timersindex.castspell, false) then
        call writecastspell(hlst.listindex + 1)
        call writework(eskill.magia)
    end if
    
    call convertcptotp(mousex, mousey, tx, ty)
    
    if usingskill = magia and not maintimer.check(timersindex.castspell) then exit sub
    
    if usingskill = proyectiles and not maintimer.check(timersindex.attack) then exit sub
    
    call writeworkleftclick(tx, ty, usingskill)
    usingskill = 0
end sub

private sub cmdlanzar_click()
    if hlst.list(hlst.listindex) <> "(none)" and maintimer.check(timersindex.work, false) then
        if userestado = 1 then
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
        else
            call writecastspell(hlst.listindex + 1)
            call writework(eskill.magia)
            usamacro = true
        end if
    end if
end sub

private sub cmdlanzar_mousemove(button as integer, shift as integer, x as single, y as single)
    usamacro = false
    cntd = 0
end sub

private sub cmdinfo_click()
    if hlst.listindex <> -1 then
        call writespellinfo(hlst.listindex + 1)
    end if
end sub

private sub despinv_click(index as integer)
    inventario.scrollinventory (index = 0)
end sub

private sub form_click()
    if cartel then cartel = false

#if seguridadalkon then
    if logging then call cheatingdeath.storekey(mouseboton, true)
#end if

    if not comerciando then
        call convertcptotp(mousex, mousey, tx, ty)
        
        if not ingamearea() then exit sub
        
        if mouseshift = 0 then
            if mouseboton <> vbrightbutton then
                '[ybarra]
                if usamacro then
                    cntd = cntd + 1
                    if cntd = 3 then
                        call writeusespellmacro
                        cntd = 0
                    end if
                    usamacro = false
                end if
                '[/ybarra]
                if usingskill = 0 then
                    call writeleftclick(tx, ty)
                else
                
                    if trainingmacro.enabled then call desactivarmacrohechizos
                    if macrotrabajo.enabled then call desactivarmacrotrabajo
                    
                    if not maintimer.check(timersindex.arrows, false) then 'check if arrows interval has finished.
                        frmmain.mousepointer = vbdefault
                        usingskill = 0
                        with fonttypes(fonttypenames.fonttype_talk)
                            call addtorichtextbox(frmmain.rectxt, "no puedes lanzar proyectiles tan r�pido.", .red, .green, .blue, .bold, .italic)
                        end with
                        exit sub
                    end if
                    
                    'splitted because vb isn't lazy!
                    if usingskill = proyectiles then
                        if not maintimer.check(timersindex.arrows) then
                            frmmain.mousepointer = vbdefault
                            usingskill = 0
                            with fonttypes(fonttypenames.fonttype_talk)
                                call addtorichtextbox(frmmain.rectxt, "no puedes lanzar proyectiles tan r�pido.", .red, .green, .blue, .bold, .italic)
                            end with
                            exit sub
                        end if
                    end if
                    
                    'splitted because vb isn't lazy!
                    if usingskill = magia then
                        if not maintimer.check(timersindex.attack, false) then 'check if attack interval has finished.
                            if not maintimer.check(timersindex.castattack) then 'corto intervalo de golpe-magia
                                frmmain.mousepointer = vbdefault
                                usingskill = 0
                                with fonttypes(fonttypenames.fonttype_talk)
                                    call addtorichtextbox(frmmain.rectxt, "no puedes lanzar hechizos tan r�pido.", .red, .green, .blue, .bold, .italic)
                                end with
                                exit sub
                            end if
                        else
                            if not maintimer.check(timersindex.castspell) then 'check if spells interval has finished.
                                frmmain.mousepointer = vbdefault
                                usingskill = 0
                                with fonttypes(fonttypenames.fonttype_talk)
                                    call addtorichtextbox(frmmain.rectxt, "no puedes lanzar hechizos tan rapido.", .red, .green, .blue, .bold, .italic)
                                end with
                                exit sub
                            end if
                        end if
                    end if
                    
                    'splitted because vb isn't lazy!
                    if (usingskill = pesca or usingskill = robar or usingskill = talar or usingskill = mineria or usingskill = fundirmetal) then
                        if not maintimer.check(timersindex.work) then
                            frmmain.mousepointer = vbdefault
                            usingskill = 0
                            exit sub
                        end if
                    end if
                    
                    if frmmain.mousepointer <> 2 then exit sub 'parcheo porque a veces tira el hechizo sin tener el cursor (niconz)
                    
                    frmmain.mousepointer = vbdefault
                    call writeworkleftclick(tx, ty, usingskill)
                    usingskill = 0
                end if
            else
                call abrirmenuviewport
            end if
        elseif (mouseshift and 1) = 1 then
            if not customkeys.keyassigned(keycodeconstants.vbkeyshift) then
                if mouseboton = vbleftbutton then
                    call writewarpchar("yo", usermap, tx, ty)
                end if
            end if
        end if
    end if
end sub

private sub form_dblclick()
'**************************************************************
'author: unknown
'last modify date: 12/27/2007
'12/28/2007: byval - chequea que la ventana de comercio y boveda no este abierta al hacer doble clic a un comerciante, sobrecarga la lista de items.
'**************************************************************
    if not mirandoforo and not comerciando then 'frmcomerciar.visible and not frmbancoobj.visible then
        call writedoubleclick(tx, ty)
    end if
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    mousex = x - mainviewshp.left
    mousey = y - mainviewshp.top
    
    'trim to fit screen
    if mousex < 0 then
        mousex = 0
    elseif mousex > mainviewshp.width then
        mousex = mainviewshp.width
    end if
    
    'trim to fit screen
    if mousey < 0 then
        mousey = 0
    elseif mousey > mainviewshp.height then
        mousey = mainviewshp.height
    end if
    
    lastpressed.toggletonormal
    
end sub

private sub hlst_keydown(keycode as integer, shift as integer)
       keycode = 0
end sub

private sub hlst_keypress(keyascii as integer)
       keyascii = 0
end sub

private sub hlst_keyup(keycode as integer, shift as integer)
        keycode = 0
end sub

private sub lbldropgold_click()

    inventario.selectgold
    if usergld > 0 then
        if not comerciando then frmcantidad.show , frmmain
    end if
    
end sub

private sub label4_click()
    call audio.playwave(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centroinventario.jpg")

    ' activo controles de inventario
    picinv.visible = true
    imginvscrollup.visible = true
    imginvscrolldown.visible = true

    ' desactivo controles de hechizo
    hlst.visible = false
    cmdinfo.visible = false
    cmdlanzar.visible = false
    
    cmdmoverhechi(0).visible = false
    cmdmoverhechi(1).visible = false
    
end sub

private sub label7_click()
    call audio.playwave(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centrohechizos.jpg")
    
    ' activo controles de hechizos
    hlst.visible = true
    cmdinfo.visible = true
    cmdlanzar.visible = true
    
    cmdmoverhechi(0).visible = true
    cmdmoverhechi(1).visible = true
    
    ' desactivo controles de inventario
    picinv.visible = false
    imginvscrollup.visible = false
    imginvscrolldown.visible = false

end sub

private sub picinv_dblclick()
    if frmcarp.visible or frmherrero.visible then exit sub
    
    if not maintimer.check(timersindex.useitemwithdblclick) then exit sub
    
    if macrotrabajo.enabled then call desactivarmacrotrabajo
    
    call usaritem
end sub

private sub picinv_mouseup(button as integer, shift as integer, x as single, y as single)
    call audio.playwave(snd_click)
end sub

private sub rectxt_change()
on error resume next  'el .setfocus causaba errores al salir y volver a entrar
    if not application.isappactive() then exit sub
    
    if sendtxt.visible then
        sendtxt.setfocus
    elseif me.sendcmstxt.visible then
        sendcmstxt.setfocus
    elseif (not comerciando) and (not mirandoasignarskills) and _
        (not frmmsg.visible) and (not mirandoforo) and _
        (not frmestadisticas.visible) and (not frmcantidad.visible) then
         
        if picinv.visible then
            picinv.setfocus
        elseif hlst.visible then
            hlst.setfocus
        end if
    end if
end sub

private sub rectxt_keydown(keycode as integer, shift as integer)
    if picinv.visible then
        picinv.setfocus
    else
        hlst.setfocus
    end if
end sub

private sub sendtxt_change()
'**************************************************************
'author: unknown
'last modify date: 3/06/2006
'3/06/2006: maraxus - imped� se inserten caract�res no imprimibles
'**************************************************************
    if len(sendtxt.text) > 160 then
        stxtbuffer = "soy un cheater, avisenle a un gm"
    else
        'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
        dim i as long
        dim tempstr as string
        dim charascii as integer
        
        for i = 1 to len(sendtxt.text)
            charascii = asc(mid$(sendtxt.text, i, 1))
            if charascii >= vbkeyspace and charascii <= 250 then
                tempstr = tempstr & chr$(charascii)
            end if
        next i
        
        if tempstr <> sendtxt.text then
            'we only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            sendtxt.text = tempstr
        end if
        
        stxtbuffer = sendtxt.text
    end if
end sub

private sub sendtxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendcmstxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        'say
        if stxtbuffercmsg <> "" then
            call parseusercommand("/cmsg " & stxtbuffercmsg)
        end if

        stxtbuffercmsg = ""
        sendcmstxt.text = ""
        keycode = 0
        me.sendcmstxt.visible = false
        
        if picinv.visible then
            picinv.setfocus
        else
            hlst.setfocus
        end if
    end if
end sub

private sub sendcmstxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendcmstxt_change()
    if len(sendcmstxt.text) > 160 then
        stxtbuffercmsg = "soy un cheater, avisenle a un gm"
    else
        'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
        dim i as long
        dim tempstr as string
        dim charascii as integer
        
        for i = 1 to len(sendcmstxt.text)
            charascii = asc(mid$(sendcmstxt.text, i, 1))
            if charascii >= vbkeyspace and charascii <= 250 then
                tempstr = tempstr & chr$(charascii)
            end if
        next i
        
        if tempstr <> sendcmstxt.text then
            'we only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            sendcmstxt.text = tempstr
        end if
        
        stxtbuffercmsg = sendcmstxt.text
    end if
end sub


''''''''''''''''''''''''''''''''''''''
'     socket1                        '
''''''''''''''''''''''''''''''''''''''
#if usarwrench = 1 then

private sub socket1_connect()
    
    'clean input and output buffers
    call incomingdata.readasciistringfixed(incomingdata.length)
    call outgoingdata.readasciistringfixed(outgoingdata.length)
    
#if seguridadalkon then
    call connectionstablished(socket1.peeraddress)
#end if
    
    second.enabled = true

    select case estadologin
        case e_modo.crearnuevopj
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login
        
        case e_modo.normal
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login
        
        case e_modo.dados
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call audio.playmidi("7.mid")
            frmcrearpersonaje.show vbmodal
    end select
end sub

private sub socket1_disconnect()
    dim i as long
    
    second.enabled = false
    connected = false
    
    socket1.cleanup
    
    frmconnect.mousepointer = vbnormal
    
    do while i < forms.count - 1
        i = i + 1
        
        if forms(i).name <> me.name and forms(i).name <> frmconnect.name and forms(i).name <> frmcrearpersonaje.name then
            unload forms(i)
        end if
    loop
    
    on local error goto 0
    
    if not frmcrearpersonaje.visible then
        frmconnect.visible = true
    end if
    
    frmmain.visible = false
    
    pausa = false
    usermeditar = false
    
#if seguridadalkon then
    logging = false
    logstring = false
    lastpressed = 0
    lastmouse = false
    lastamount = 0
#end if

    userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    
    for i = 1 to numskills
        userskills(i) = 0
    next i

    for i = 1 to numatributos
        useratributos(i) = 0
    next i
    
    for i = 1 to max_inventory_slots
        
    next i
    
    macrotrabajo.enabled = false

    skillpoints = 0
    alocados = 0
end sub

private sub socket1_lasterror(errorcode as integer, errorstring as string, response as integer)
    '*********************************************
    'handle socket errors
    '*********************************************
    if errorcode = 24036 then
        call msgbox("por favor espere, intentando completar conexion.", vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
        exit sub
    end if
    
    call msgbox(errorstring, vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
    frmconnect.mousepointer = 1
    response = 0
    second.enabled = false

    frmmain.socket1.disconnect
    
    if not frmcrearpersonaje.visible then
        frmconnect.show
    else
        frmcrearpersonaje.mousepointer = 0
    end if
end sub

private sub socket1_read(datalength as integer, isurgent as integer)
    dim rd as string
    dim data() as byte
    
    call socket1.read(rd, datalength)
    data = strconv(rd, vbfromunicode)
    
    if rd = vbnullstring then exit sub
    
#if seguridadalkon then
    call datareceived(data)
#end if
    
    'put data in the buffer
    call incomingdata.writeblock(data)
    
    'send buffer to handle data
    call handleincomingdata
end sub


#end if

private sub abrirmenuviewport()
#if (conmenuseconextuales = 1) then

if tx >= minxborder and ty >= minyborder and _
    ty <= maxyborder and tx <= maxxborder then
    if mapdata(tx, ty).charindex > 0 then
        if charlist(mapdata(tx, ty).charindex).invisible = false then
        
            dim i as long
            dim m as new frmmenusefashion
            
            load m
            m.setcallback me
            m.setmenuid 1
            m.listainit 2, false
            
            if charlist(mapdata(tx, ty).charindex).nombre <> "" then
                m.listasetitem 0, charlist(mapdata(tx, ty).charindex).nombre, true
            else
                m.listasetitem 0, "<npc>", true
            end if
            m.listasetitem 1, "comerciar"
            
            m.listafin
            m.show , me

        end if
    end if
end if

#end if
end sub

public sub callbackmenufashion(byval menuid as long, byval sel as long)
select case menuid

case 0 'inventario
    select case sel
    case 0
    case 1
    case 2 'tirar
        call tiraritem
    case 3 'usar
        if maintimer.check(timersindex.useitemwithdblclick) then
            call usaritem
        end if
    case 3 'equipar
        call equiparitem
    end select
    
case 1 'menu del viewport del engine
    select case sel
    case 0 'nombre
        call writeleftclick(tx, ty)
        
    case 1 'comerciar
        call writeleftclick(tx, ty)
        call writecommercestart
    end select
end select
end sub


'
' -------------------
'    w i n s o c k
' -------------------
'

#if usarwrench <> 1 then

private sub winsock1_close()
    dim i as long
    
    debug.print "winsock close"
    
    second.enabled = false
    connected = false
    
    if winsock1.state <> sckclosed then _
        winsock1.close
    
    frmconnect.mousepointer = vbnormal
    
    do while i < forms.count - 1
        i = i + 1
        
        if forms(i).name <> me.name and forms(i).name <> frmconnect.name and forms(i).name <> frmcrearpersonaje.name then
            unload forms(i)
        end if
    loop
    on local error goto 0
    
    if not frmcrearpersonaje.visible then
        frmconnect.visible = true
    end if
    
    frmmain.visible = false

    pausa = false
    usermeditar = false

    userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    
    for i = 1 to numskills
        userskills(i) = 0
    next i

    for i = 1 to numatributos
        useratributos(i) = 0
    next i

    skillpoints = 0
    alocados = 0

    dialogos.cantidaddialogos = 0
end sub

private sub winsock1_connect()
    debug.print "winsock connect"
    
    'clean input and output buffers
    call incomingdata.readasciistringfixed(incomingdata.length)
    call outgoingdata.readasciistringfixed(outgoingdata.length)
    
#if seguridadalkon then
    call connectionstablished(winsock1.remotehostip)
#end if
    
    second.enabled = true
    
    select case estadologin
        case e_modo.crearnuevopj
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login


        case e_modo.normal
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login

        case e_modo.dados
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call audio.playmidi("7.mid")
            frmcrearpersonaje.show vbmodal
            
#if seguridadalkon then
            call protectform(frmcrearpersonaje)
#end if
    end select
end sub

private sub winsock1_dataarrival(byval bytestotal as long)
    dim rd as string
    dim data() as byte
    
    'socket1.read rd, datalength
    winsock1.getdata rd
    
    data = strconv(rd, vbfromunicode)
    
#if seguridadalkon then
    call datareceived(data)
#end if
    
    'set data in the buffer
    call incomingdata.writeblock(data)
    
    'send buffer to handle data
    call handleincomingdata
end sub

private sub winsock1_error(byval number as integer, description as string, byval scode as long, byval source as string, byval helpfile as string, byval helpcontext as long, canceldisplay as boolean)
    '*********************************************
    'handle socket errors
    '*********************************************
    
    call msgbox(description, vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
    frmconnect.mousepointer = 1
    second.enabled = false

    if winsock1.state <> sckclosed then _
        winsock1.close

    if not frmcrearpersonaje.visible then
        frmconnect.show
    else
        frmcrearpersonaje.mousepointer = 0
    end if
end sub
#end if

private function ingamearea() as boolean
'***************************************************
'author: niconz
'last modification: 04/07/08
'checks if last click was performed within or outside the game area.
'***************************************************
    if clicx < mainviewshp.left or clicx > mainviewshp.left + mainviewshp.width then exit function
    if clicy < mainviewshp.top or clicy > mainviewshp.top + mainviewshp.height then exit function
    
    ingamearea = true
end function

private sub winsock2_connect()
#if seguridadalkon = 1 then
    call modurl.processrequest
#end if
end sub
