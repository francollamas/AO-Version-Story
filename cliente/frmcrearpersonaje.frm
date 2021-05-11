version 5.00
begin vb.form frmcrearpersonaje 
   backcolor       =   &h8000000a&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   9000
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   11985
   clipcontrols    =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   600
   scalemode       =   3  'pixel
   scalewidth      =   799
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.combobox lstalienacion 
      backcolor       =   &h00000000&
      enabled         =   0   'false
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   315
      itemdata        =   "frmcrearpersonaje.frx":0000
      left            =   6120
      list            =   "frmcrearpersonaje.frx":000a
      style           =   2  'dropdown list
      tabindex        =   8
      top             =   5040
      visible         =   0   'false
      width           =   2625
   end
   begin vb.textbox txtmail 
      backcolor       =   &h80000012&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   3480
      tabindex        =   3
      top             =   2280
      width           =   5055
   end
   begin vb.textbox txtconfirmpasswd 
      backcolor       =   &h80000012&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "courier"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      imemode         =   3  'disable
      left            =   6120
      passwordchar    =   "*"
      tabindex        =   2
      top             =   1800
      width           =   2415
   end
   begin vb.textbox txtpasswd 
      backcolor       =   &h80000012&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "courier"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      imemode         =   3  'disable
      left            =   3480
      passwordchar    =   "*"
      tabindex        =   1
      top             =   1800
      width           =   2415
   end
   begin vb.timer tanimacion 
      left            =   840
      top             =   1080
   end
   begin vb.combobox lstprofesion 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   315
      itemdata        =   "frmcrearpersonaje.frx":001d
      left            =   6060
      list            =   "frmcrearpersonaje.frx":001f
      style           =   2  'dropdown list
      tabindex        =   6
      top             =   4035
      width           =   2625
   end
   begin vb.combobox lstgenero 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   315
      itemdata        =   "frmcrearpersonaje.frx":0021
      left            =   6060
      list            =   "frmcrearpersonaje.frx":002b
      style           =   2  'dropdown list
      tabindex        =   7
      top             =   4560
      width           =   2625
   end
   begin vb.combobox lstraza 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   315
      itemdata        =   "frmcrearpersonaje.frx":003e
      left            =   6060
      list            =   "frmcrearpersonaje.frx":0040
      style           =   2  'dropdown list
      tabindex        =   5
      top             =   3495
      width           =   2625
   end
   begin vb.combobox lsthogar 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   315
      itemdata        =   "frmcrearpersonaje.frx":0042
      left            =   6060
      list            =   "frmcrearpersonaje.frx":0044
      style           =   2  'dropdown list
      tabindex        =   4
      top             =   2985
      width           =   2625
   end
   begin vb.textbox txtnombre 
      backcolor       =   &h80000012&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   3480
      maxlength       =   30
      tabindex        =   0
      top             =   1320
      width           =   5055
   end
   begin vb.picturebox picpj 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   975
      left            =   7080
      scaleheight     =   65
      scalemode       =   3  'pixel
      scalewidth      =   41
      tabindex        =   14
      top             =   6360
      width           =   615
   end
   begin vb.picturebox pichead 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   360
      index           =   1
      left            =   6795
      scaleheight     =   24
      scalemode       =   3  'pixel
      scalewidth      =   24
      tabindex        =   27
      top             =   5880
      visible         =   0   'false
      width           =   360
   end
   begin vb.picturebox pichead 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   360
      index           =   2
      left            =   7200
      scaleheight     =   24
      scalemode       =   3  'pixel
      scalewidth      =   24
      tabindex        =   28
      top             =   5880
      visible         =   0   'false
      width           =   360
   end
   begin vb.picturebox pichead 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   360
      index           =   3
      left            =   7605
      scaleheight     =   24
      scalemode       =   3  'pixel
      scalewidth      =   24
      tabindex        =   29
      top             =   5880
      visible         =   0   'false
      width           =   360
   end
   begin vb.picturebox pichead 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   360
      index           =   4
      left            =   8010
      scaleheight     =   24
      scalemode       =   3  'pixel
      scalewidth      =   24
      tabindex        =   30
      top             =   5880
      visible         =   0   'false
      width           =   360
   end
   begin vb.picturebox pichead 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h80000008&
      height          =   360
      index           =   0
      left            =   6390
      scaleheight     =   24
      scalemode       =   3  'pixel
      scalewidth      =   24
      tabindex        =   26
      top             =   5880
      visible         =   0   'false
      width           =   360
   end
   begin vb.image imgarcostar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   7110
      width           =   225
   end
   begin vb.image imgarcostar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   7110
      width           =   225
   end
   begin vb.image imgarcostar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   7110
      width           =   225
   end
   begin vb.image imgarcostar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   7110
      width           =   225
   end
   begin vb.image imgarcostar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   7110
      width           =   225
   end
   begin vb.image imgarmasstar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   6825
      width           =   225
   end
   begin vb.image imgarmasstar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   6825
      width           =   225
   end
   begin vb.image imgarmasstar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   6825
      width           =   225
   end
   begin vb.image imgarmasstar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   6825
      width           =   225
   end
   begin vb.image imgescudosstar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   6540
      width           =   225
   end
   begin vb.image imgescudosstar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   6540
      width           =   225
   end
   begin vb.image imgescudosstar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   6540
      width           =   225
   end
   begin vb.image imgescudosstar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   6540
      width           =   225
   end
   begin vb.image imgvidastar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   6255
      width           =   225
   end
   begin vb.image imgvidastar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   6255
      width           =   225
   end
   begin vb.image imgvidastar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   6255
      width           =   225
   end
   begin vb.image imgvidastar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   6255
      width           =   225
   end
   begin vb.image imgmagiastar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   5970
      width           =   225
   end
   begin vb.image imgmagiastar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   5970
      width           =   225
   end
   begin vb.image imgmagiastar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   5970
      width           =   225
   end
   begin vb.image imgmagiastar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   5970
      width           =   225
   end
   begin vb.image imgarmasstar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   6825
      width           =   225
   end
   begin vb.image imgescudosstar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   6540
      width           =   225
   end
   begin vb.image imgvidastar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   6255
      width           =   225
   end
   begin vb.image imgmagiastar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   5970
      width           =   225
   end
   begin vb.image imgevasionstar 
      height          =   195
      index           =   5
      left            =   5400
      top             =   5685
      width           =   225
   end
   begin vb.image imgevasionstar 
      height          =   195
      index           =   4
      left            =   5175
      top             =   5685
      width           =   225
   end
   begin vb.image imgevasionstar 
      height          =   195
      index           =   3
      left            =   4950
      top             =   5685
      width           =   225
   end
   begin vb.image imgevasionstar 
      height          =   195
      index           =   2
      left            =   4725
      top             =   5685
      width           =   225
   end
   begin vb.image imgevasionstar 
      height          =   195
      index           =   1
      left            =   4500
      top             =   5685
      width           =   225
   end
   begin vb.label lblespecialidad 
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
      forecolor       =   &h00ffffff&
      height          =   375
      left            =   4440
      tabindex        =   31
      top             =   7395
      width           =   1455
   end
   begin vb.line line1 
      bordercolor     =   &h000000ff&
      borderstyle     =   3  'dot
      index           =   3
      visible         =   0   'false
      x1              =   479
      x2              =   505
      y1              =   416
      y2              =   416
   end
   begin vb.line line1 
      bordercolor     =   &h000000ff&
      borderstyle     =   3  'dot
      index           =   2
      visible         =   0   'false
      x1              =   479
      x2              =   505
      y1              =   391
      y2              =   391
   end
   begin vb.line line1 
      bordercolor     =   &h000000ff&
      borderstyle     =   3  'dot
      index           =   1
      visible         =   0   'false
      x1              =   504
      x2              =   504
      y1              =   392
      y2              =   416
   end
   begin vb.line line1 
      bordercolor     =   &h000000ff&
      borderstyle     =   3  'dot
      index           =   0
      visible         =   0   'false
      x1              =   479
      x2              =   479
      y1              =   392
      y2              =   416
   end
   begin vb.label lblatributofinal 
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   5
      left            =   5445
      tabindex        =   25
      top             =   4830
      width           =   225
   end
   begin vb.label lblatributofinal 
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   4
      left            =   5445
      tabindex        =   24
      top             =   4470
      width           =   225
   end
   begin vb.label lblatributofinal 
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   3
      left            =   5445
      tabindex        =   23
      top             =   4125
      width           =   225
   end
   begin vb.label lblatributofinal 
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   2
      left            =   5445
      tabindex        =   22
      top             =   3780
      width           =   225
   end
   begin vb.label lblatributofinal 
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   1
      left            =   5445
      tabindex        =   21
      top             =   3450
      width           =   225
   end
   begin vb.label lblmodraza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "+0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   5
      left            =   4950
      tabindex        =   20
      top             =   4830
      width           =   225
   end
   begin vb.label lblmodraza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "+0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   4
      left            =   4950
      tabindex        =   19
      top             =   4470
      width           =   225
   end
   begin vb.label lblmodraza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "+0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   3
      left            =   4950
      tabindex        =   18
      top             =   4125
      width           =   225
   end
   begin vb.label lblmodraza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "+0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   2
      left            =   4950
      tabindex        =   17
      top             =   3780
      width           =   225
   end
   begin vb.label lblmodraza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "+0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   1
      left            =   4950
      tabindex        =   16
      top             =   3450
      width           =   225
   end
   begin vb.image imgatributos 
      height          =   270
      left            =   3960
      top             =   2745
      width           =   975
   end
   begin vb.label lblhelp 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "arial"
         size            =   11.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   -1  'true
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   4935
      left            =   9480
      tabindex        =   15
      top             =   1800
      width           =   1935
   end
   begin vb.image imgvolver 
      height          =   450
      left            =   1335
      top             =   8190
      width           =   1290
   end
   begin vb.image imgcrear 
      height          =   435
      left            =   9090
      top             =   8190
      width           =   2610
   end
   begin vb.image imgalineacion 
      height          =   240
      left            =   6855
      top             =   4830
      visible         =   0   'false
      width           =   945
   end
   begin vb.image imggenero 
      height          =   240
      left            =   6960
      top             =   4335
      width           =   705
   end
   begin vb.image imgclase 
      height          =   240
      left            =   7020
      top             =   3795
      width           =   555
   end
   begin vb.image imgraza 
      height          =   255
      left            =   7035
      top             =   3270
      width           =   570
   end
   begin vb.image imgpuebloorigen 
      height          =   225
      left            =   6600
      top             =   2760
      width           =   1425
   end
   begin vb.image imgespecialidad 
      height          =   240
      left            =   3330
      top             =   7410
      width           =   1065
   end
   begin vb.image imgarcos 
      height          =   225
      left            =   3345
      top             =   7140
      width           =   555
   end
   begin vb.image imgarmas 
      height          =   240
      left            =   3330
      top             =   6840
      width           =   615
   end
   begin vb.image imgescudos 
      height          =   255
      left            =   3315
      top             =   6540
      width           =   735
   end
   begin vb.image imgvida 
      height          =   225
      left            =   3330
      top             =   6270
      width           =   465
   end
   begin vb.image imgmagia 
      height          =   255
      left            =   3285
      top             =   5955
      width           =   660
   end
   begin vb.image imgevasion 
      height          =   255
      left            =   3285
      top             =   5670
      width           =   735
   end
   begin vb.image imgconstitucion 
      height          =   255
      left            =   3285
      top             =   4785
      width           =   1080
   end
   begin vb.image imgcarisma 
      height          =   240
      left            =   3435
      top             =   4440
      width           =   765
   end
   begin vb.image imginteligencia 
      height          =   240
      left            =   3330
      top             =   4110
      width           =   1005
   end
   begin vb.image imgagilidad 
      height          =   240
      left            =   3420
      top             =   3765
      width           =   735
   end
   begin vb.image imgfuerza 
      height          =   240
      left            =   3450
      top             =   3420
      width           =   675
   end
   begin vb.image imgf 
      height          =   270
      left            =   5415
      top             =   3075
      width           =   270
   end
   begin vb.image imgm 
      height          =   270
      left            =   4950
      top             =   3075
      width           =   270
   end
   begin vb.image imgd 
      height          =   270
      left            =   4485
      top             =   3090
      width           =   270
   end
   begin vb.image imgconfirmpasswd 
      height          =   255
      left            =   6585
      top             =   1545
      width           =   1440
   end
   begin vb.image imgpasswd 
      height          =   255
      left            =   4350
      top             =   1545
      width           =   930
   end
   begin vb.image imgnombre 
      height          =   240
      left            =   5205
      top             =   1065
      width           =   1635
   end
   begin vb.image imgmail 
      height          =   240
      left            =   5310
      top             =   2055
      width           =   1395
   end
   begin vb.image imgtirardados 
      height          =   765
      left            =   1380
      top             =   3105
      width           =   1200
   end
   begin vb.image dirpj 
      height          =   225
      index           =   1
      left            =   7455
      picture         =   "frmcrearpersonaje.frx":0046
      top             =   7320
      visible         =   0   'false
      width           =   240
   end
   begin vb.image dirpj 
      height          =   225
      index           =   0
      left            =   7080
      picture         =   "frmcrearpersonaje.frx":0358
      top             =   7320
      visible         =   0   'false
      width           =   240
   end
   begin vb.image headpj 
      height          =   225
      index           =   1
      left            =   8460
      picture         =   "frmcrearpersonaje.frx":066a
      top             =   5925
      visible         =   0   'false
      width           =   240
   end
   begin vb.image headpj 
      height          =   225
      index           =   0
      left            =   6075
      picture         =   "frmcrearpersonaje.frx":097c
      top             =   5925
      visible         =   0   'false
      width           =   240
   end
   begin vb.image image1 
      height          =   3120
      left            =   8880
      stretch         =   -1  'true
      top             =   9120
      visible         =   0   'false
      width           =   2475
   end
   begin vb.image imgdados 
      height          =   885
      left            =   195
      mouseicon       =   "frmcrearpersonaje.frx":0c8e
      mousepointer    =   99  'custom
      top             =   2775
      width           =   900
   end
   begin vb.image imghogar 
      height          =   2850
      left            =   5640
      picture         =   "frmcrearpersonaje.frx":0de0
      top             =   9120
      visible         =   0   'false
      width           =   2985
   end
   begin vb.label lblatributos 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   4
      left            =   4500
      tabindex        =   13
      top             =   4470
      width           =   225
   end
   begin vb.label lblatributos 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   3
      left            =   4500
      tabindex        =   12
      top             =   4125
      width           =   225
   end
   begin vb.label lblatributos 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   5
      left            =   4500
      tabindex        =   11
      top             =   4830
      width           =   225
   end
   begin vb.label lblatributos 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   2
      left            =   4500
      tabindex        =   10
      top             =   3780
      width           =   225
   end
   begin vb.label lblatributos 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "18"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   1
      left            =   4500
      tabindex        =   9
      top             =   3450
      width           =   225
   end
end
attribute vb_name = "frmcrearpersonaje"
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

private cbotonpasswd as clsgraphicalbutton
private cbotontirardados as clsgraphicalbutton
private cbotonmail as clsgraphicalbutton
private cbotonnombre as clsgraphicalbutton
private cbotonconfirmpasswd as clsgraphicalbutton
private cbotonatributos as clsgraphicalbutton
private cbotond as clsgraphicalbutton
private cbotonm as clsgraphicalbutton
private cbotonf as clsgraphicalbutton
private cbotonfuerza as clsgraphicalbutton
private cbotonagilidad as clsgraphicalbutton
private cbotoninteligencia as clsgraphicalbutton
private cbotoncarisma as clsgraphicalbutton
private cbotonconstitucion as clsgraphicalbutton
private cbotonevasion as clsgraphicalbutton
private cbotonmagia as clsgraphicalbutton
private cbotonvida as clsgraphicalbutton
private cbotonescudos as clsgraphicalbutton
private cbotonarmas as clsgraphicalbutton
private cbotonarcos as clsgraphicalbutton
private cbotonespecialidad as clsgraphicalbutton
private cbotonpuebloorigen as clsgraphicalbutton
private cbotonraza as clsgraphicalbutton
private cbotonclase as clsgraphicalbutton
private cbotongenero as clsgraphicalbutton
private cbotonalineacion as clsgraphicalbutton
private cbotonvolver as clsgraphicalbutton
private cbotoncrear as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private picfullstar as picture
private pichalfstar as picture
private picglowstar as picture

private enum ehelp
    iepasswd
    ietirardados
    iemail
    ienombre
    ieconfirmpasswd
    ieatributos
    ied
    iem
    ief
    iefuerza
    ieagilidad
    ieinteligencia
    iecarisma
    ieconstitucion
    ieevasion
    iemagia
    ievida
    ieescudos
    iearmas
    iearcos
    ieespecialidad
    iepuebloorigen
    ieraza
    ieclase
    iegenero
    iealineacion
end enum

private vhelp(25) as string
private vespecialidades() as string

private type tmodraza
    fuerza as single
    agilidad as single
    inteligencia as single
    carisma as single
    constitucion as single
end type

private type tmodclase
    evasion as double
    ataquearmas as double
    ataqueproyectiles as double
    da�oarmas as double
    da�oproyectiles as double
    escudo as double
    magia as double
    vida as double
    hit as double
end type

private modraza() as tmodraza
private modclase() as tmodclase

private nrorazas as integer
private nroclases as integer

private cargando as boolean

private currentgrh as long
private dir as e_heading

private sub form_load()
    me.picture = loadpicture(dirgraficos & "ventanacrearpersonaje.jpg")
    
    cargando = true
    call loadcharinfo
    call cargarespecialidades
    
    call iniciargraficos
    call cargarcombos
    
    call loadhelp
    
    call drawimageinpicture(picpj, me.picture, 0, 0, , , picpj.left, picpj.top)
    dir = south
    
    call tirardados
    
    cargando = false
    
    'userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    userhead = 0
    
#if seguridadalkon then
    call protectform(me)
#end if

end sub

private sub cargarespecialidades()

    redim vespecialidades(1 to nroclases)
    
    vespecialidades(eclass.hunter) = "ocultarse"
    vespecialidades(eclass.thief) = "robar y ocultarse"
    vespecialidades(eclass.assasin) = "apu�alar"
    vespecialidades(eclass.bandit) = "combate sin armas"
    vespecialidades(eclass.druid) = "domar"
    vespecialidades(eclass.pirat) = "navegar"
    vespecialidades(eclass.worker) = "extracci�n y construcci�n"
end sub

private sub iniciargraficos()

    dim grhpath as string
    grhpath = dirgraficos
    
    set cbotonpasswd = new clsgraphicalbutton
    set cbotontirardados = new clsgraphicalbutton
    set cbotonmail = new clsgraphicalbutton
    set cbotonnombre = new clsgraphicalbutton
    set cbotonconfirmpasswd = new clsgraphicalbutton
    set cbotonatributos = new clsgraphicalbutton
    set cbotond = new clsgraphicalbutton
    set cbotonm = new clsgraphicalbutton
    set cbotonf = new clsgraphicalbutton
    set cbotonfuerza = new clsgraphicalbutton
    set cbotonagilidad = new clsgraphicalbutton
    set cbotoninteligencia = new clsgraphicalbutton
    set cbotoncarisma = new clsgraphicalbutton
    set cbotonconstitucion = new clsgraphicalbutton
    set cbotonevasion = new clsgraphicalbutton
    set cbotonmagia = new clsgraphicalbutton
    set cbotonvida = new clsgraphicalbutton
    set cbotonescudos = new clsgraphicalbutton
    set cbotonarmas = new clsgraphicalbutton
    set cbotonarcos = new clsgraphicalbutton
    set cbotonespecialidad = new clsgraphicalbutton
    set cbotonpuebloorigen = new clsgraphicalbutton
    set cbotonraza = new clsgraphicalbutton
    set cbotonclase = new clsgraphicalbutton
    set cbotongenero = new clsgraphicalbutton
    set cbotonalineacion = new clsgraphicalbutton
    set cbotonvolver = new clsgraphicalbutton
    set cbotoncrear = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonpasswd.initialize(imgpasswd, "", grhpath & "botoncontrase�a.jpg", _
                                    grhpath & "botoncontrase�a.jpg", me, , , false, false)
                                    
    call cbotontirardados.initialize(imgtirardados, "", grhpath & "botontirardados.jpg", _
                                    grhpath & "botontirardados.jpg", me, , , false, false)
                                    
    call cbotonmail.initialize(imgmail, "", grhpath & "botonmailpj.jpg", _
                                    grhpath & "botonmailpj.jpg", me, , , false, false)
                                    
    call cbotonnombre.initialize(imgnombre, "", grhpath & "botonnombrepj.jpg", _
                                    grhpath & "botonnombrepj.jpg", me, , , false, false)
                                    
    call cbotonconfirmpasswd.initialize(imgconfirmpasswd, "", grhpath & "botonrepetircontrase�a.jpg", _
                                    grhpath & "botonrepetircontrase�a.jpg", me, , , false, false)
                                    
    call cbotonatributos.initialize(imgatributos, "", grhpath & "botonatributos.jpg", _
                                    grhpath & "botonatributos.jpg", me, , , false, false)
                                    
    call cbotond.initialize(imgd, "", grhpath & "botond.jpg", _
                                    grhpath & "botond.jpg", me, , , false, false)
                                    
    call cbotonm.initialize(imgm, "", grhpath & "botonm.jpg", _
                                    grhpath & "botonm.jpg", me, , , false, false)
                                    
    call cbotonf.initialize(imgf, "", grhpath & "botonf.jpg", _
                                    grhpath & "botonf.jpg", me, , , false, false)
                                    
    call cbotonfuerza.initialize(imgfuerza, "", grhpath & "botonfuerza.jpg", _
                                    grhpath & "botonfuerza.jpg", me, , , false, false)
                                    
    call cbotonagilidad.initialize(imgagilidad, "", grhpath & "botonagilidad.jpg", _
                                    grhpath & "botonagilidad.jpg", me, , , false, false)
                                    
    call cbotoninteligencia.initialize(imginteligencia, "", grhpath & "botoninteligencia.jpg", _
                                    grhpath & "botoninteligencia.jpg", me, , , false, false)
                                    
    call cbotoncarisma.initialize(imgcarisma, "", grhpath & "botoncarisma.jpg", _
                                    grhpath & "botoncarisma.jpg", me, , , false, false)
                                    
    call cbotonconstitucion.initialize(imgconstitucion, "", grhpath & "botonconstitucion.jpg", _
                                    grhpath & "botonconstitucion.jpg", me, , , false, false)
                                    
    call cbotonevasion.initialize(imgevasion, "", grhpath & "botonevasion.jpg", _
                                    grhpath & "botonevasion.jpg", me, , , false, false)
                                    
    call cbotonmagia.initialize(imgmagia, "", grhpath & "botonmagia.jpg", _
                                    grhpath & "botonmagia.jpg", me, , , false, false)
                                    
    call cbotonvida.initialize(imgvida, "", grhpath & "botonvida.jpg", _
                                    grhpath & "botonvida.jpg", me, , , false, false)
                                    
    call cbotonescudos.initialize(imgescudos, "", grhpath & "botonescudos.jpg", _
                                    grhpath & "botonescudos.jpg", me, , , false, false)
                                    
    call cbotonarmas.initialize(imgarmas, "", grhpath & "botonarmas.jpg", _
                                    grhpath & "botonarmas.jpg", me, , , false, false)
                                    
    call cbotonarcos.initialize(imgarcos, "", grhpath & "botonarcos.jpg", _
                                    grhpath & "botonarcos.jpg", me, , , false, false)
                                    
    call cbotonespecialidad.initialize(imgespecialidad, "", grhpath & "botonespecialidad.jpg", _
                                    grhpath & "botonespecialidad.jpg", me, , , false, false)
                                    
    call cbotonpuebloorigen.initialize(imgpuebloorigen, "", grhpath & "botonpuebloorigen.jpg", _
                                    grhpath & "botonpuebloorigen.jpg", me, , , false, false)
                                    
    call cbotonraza.initialize(imgraza, "", grhpath & "botonraza.jpg", _
                                    grhpath & "botonraza.jpg", me, , , false, false)
                                    
    call cbotonclase.initialize(imgclase, "", grhpath & "botonclase.jpg", _
                                    grhpath & "botonclase.jpg", me, , , false, false)
                                    
    call cbotongenero.initialize(imggenero, "", grhpath & "botongenero.jpg", _
                                    grhpath & "botongenero.jpg", me, , , false, false)
                                    
    call cbotonalineacion.initialize(imgalineacion, "", grhpath & "botonalineacion.jpg", _
                                    grhpath & "botonalineacion.jpg", me, , , false, false)
                                    
    call cbotonvolver.initialize(imgvolver, "", grhpath & "botonvolverrollover.jpg", _
                                    grhpath & "botonvolverclick.jpg", me)
                                    
    call cbotoncrear.initialize(imgcrear, "", grhpath & "botoncrearpersonajerollover.jpg", _
                                    grhpath & "botoncrearpersonajeclick.jpg", me)

    set picfullstar = loadpicture(grhpath & "estrellasimple.jpg")
    set pichalfstar = loadpicture(grhpath & "estrellamitad.jpg")
    set picglowstar = loadpicture(grhpath & "estrellabrillante.jpg")

end sub

private sub cargarcombos()
    dim i as integer
    
    lstprofesion.clear
    
    for i = lbound(listaclases) to nroclases
        lstprofesion.additem listaclases(i)
    next i
    
    lsthogar.clear
    
    for i = lbound(ciudades()) to ubound(ciudades())
        lsthogar.additem ciudades(i)
    next i
    
    lstraza.clear
    
    for i = lbound(listarazas()) to nrorazas
        lstraza.additem listarazas(i)
    next i
    
    lstprofesion.listindex = 1
end sub

function checkdata() as boolean
    if txtpasswd.text <> txtconfirmpasswd.text then
        msgbox "los passwords que tipeo no coinciden, por favor vuelva a ingresarlos."
        exit function
    end if
    
    if not checkmailstring(txtmail.text) then
        msgbox "direccion de mail invalida."
        exit function
    end if

    if userraza = 0 then
        msgbox "seleccione la raza del personaje."
        exit function
    end if
    
    if usersexo = 0 then
        msgbox "seleccione el sexo del personaje."
        exit function
    end if
    
    if userclase = 0 then
        msgbox "seleccione la clase del personaje."
        exit function
    end if
    
    if userhogar = 0 then
        msgbox "seleccione el hogar del personaje."
        exit function
    end if
    'toqueteado x salvito
    dim i as integer
    for i = 1 to numatributos
        if val(lblatributos(i).caption) = 0 then
            msgbox "los atributos del personaje son invalidos."
            exit function
        end if
    next i
    
    if len(username) > 30 then
        msgbox ("el nombre debe tener menos de 30 letras.")
        exit function
    end if
    
    checkdata = true

end function

private sub tirardados()
    call writethrowdices
    call flushbuffer
end sub

private sub dirpj_click(index as integer)
    select case index
        case 0
            dir = checkdir(dir + 1)
        case 1
            dir = checkdir(dir - 1)
    end select
    
    call updateheadselection
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    clearlabel
end sub

private sub headpj_click(index as integer)
    select case index
        case 0
            userhead = checkcabeza(userhead + 1)
        case 1
            userhead = checkcabeza(userhead - 1)
    end select
    
    call updateheadselection
    
end sub

private sub updateheadselection()
    dim head as integer
    
    head = userhead
    call drawhead(head, 2)
    
    head = head + 1
    call drawhead(checkcabeza(head), 3)
    
    head = head + 1
    call drawhead(checkcabeza(head), 4)
    
    head = userhead
    
    head = head - 1
    call drawhead(checkcabeza(head), 1)
    
    head = head - 1
    call drawhead(checkcabeza(head), 0)
end sub

private sub imgcrear_click()

    dim i as integer
    dim charascii as byte
    
    username = txtnombre.text
            
    if right$(username, 1) = " " then
        username = rtrim$(username)
        msgbox "nombre invalido, se han removido los espacios al final del nombre"
    end if
    
    userraza = lstraza.listindex + 1
    usersexo = lstgenero.listindex + 1
    userclase = lstprofesion.listindex + 1
    
    for i = 1 to numatributes
        useratributos(i) = val(lblatributos(i).caption)
    next i
         
    userhogar = lsthogar.listindex + 1
    
    if not checkdata then exit sub
    
#if seguridadalkon then
    userpassword = md5.getmd5string(txtpasswd.text)
    call md5.md5reset
#else
    userpassword = txtpasswd.text
#end if
    
    for i = 1 to len(userpassword)
        charascii = asc(mid$(userpassword, i, 1))
        if not legalcharacter(charascii) then
            msgbox ("password inv�lido. el caract�r " & chr$(charascii) & " no est� permitido.")
            exit sub
        end if
    next i
    
    useremail = txtmail.text
    
#if usarwrench = 1 then
    frmmain.socket1.hostname = curserverip
    frmmain.socket1.remoteport = curserverport
#end if
    
    estadologin = e_modo.crearnuevopj
    
#if usarwrench = 1 then
    if not frmmain.socket1.connected then
#else
    if frmmain.winsock1.state <> sckconnected then
#end if
        msgbox "error: se ha perdido la conexion con el server."
        unload me
        
    else
        call login
    end if
    
    bshowtutorial = true
end sub

private sub imgdados_click()
    call audio.playwave(snd_dice)
            call tirardados
end sub

private sub imgespecialidad_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieespecialidad)
end sub

private sub imgnombre_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ienombre)
end sub

private sub imgpasswd_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iepasswd)
end sub

private sub imgconfirmpasswd_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieconfirmpasswd)
end sub

private sub imgatributos_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieatributos)
end sub

private sub imgd_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ied)
end sub

private sub imgm_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iem)
end sub

private sub imgf_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ief)
end sub

private sub imgfuerza_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iefuerza)
end sub

private sub imgagilidad_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieagilidad)
end sub

private sub imginteligencia_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieinteligencia)
end sub

private sub imgcarisma_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iecarisma)
end sub

private sub imgconstitucion_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieconstitucion)
end sub

private sub imgarcos_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iearcos)
end sub

private sub imgarmas_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iearmas)
end sub

private sub imgescudos_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieescudos)
end sub

private sub imgevasion_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieevasion)
end sub

private sub imgmagia_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iemagia)
end sub

private sub imgmail_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iemail)
end sub

private sub imgvida_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ievida)
end sub

private sub imgtirardados_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ietirardados)
end sub

private sub imgpuebloorigen_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iepuebloorigen)
end sub

private sub imgraza_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieraza)
end sub

private sub imgclase_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieclase)
end sub

private sub imggenero_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iegenero)
end sub

private sub imgalineacion_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iealineacion)
end sub

private sub imgvolver_click()
    call audio.playmidi("2.mid")
    
    bshowtutorial = false
    
    unload me
end sub

private sub lstgenero_click()
    usersexo = lstgenero.listindex + 1
    call darcuerpoycabeza
end sub

private sub lstprofesion_click()
on error resume next
'    image1.picture = loadpicture(app.path & "\graficos\" & lstprofesion.text & ".jpg")
'
    userclase = lstprofesion.listindex + 1
    
    call updatestats
    call updateespecialidad(userclase)
end sub

private sub updateespecialidad(byval eclase as eclass)
    lblespecialidad.caption = vespecialidades(eclase)
end sub

private sub lstraza_click()
    userraza = lstraza.listindex + 1
    call darcuerpoycabeza
    
    call updatestats
end sub

private sub pichead_click(index as integer)
    ' no se mueve si clickea al medio
    if index = 2 then exit sub
    
    dim counter as integer
    dim head as integer
    
    head = userhead
    
    if index > 2 then
        for counter = index - 2 to 1 step -1
            head = checkcabeza(head + 1)
        next counter
    else
        for counter = 2 - index to 1 step -1
            head = checkcabeza(head - 1)
        next counter
    end if
    
    userhead = head
    
    call updateheadselection
    
end sub

private sub tanimacion_timer()
    dim sr as rect
    dim grh as long
    dim x as long
    dim y as long
    static frame as byte
    
    if currentgrh = 0 then exit sub
    userhead = checkcabeza(userhead)
    
    frame = frame + 1
    if frame >= grhdata(currentgrh).numframes then frame = 1
    call drawimageinpicture(picpj, me.picture, 0, 0, , , picpj.left, picpj.top)
    
    grh = grhdata(currentgrh).frames(frame)
    
    with grhdata(grh)
        sr.left = .sx
        sr.top = .sy
        sr.right = sr.left + .pixelwidth
        sr.bottom = sr.top + .pixelheight
        
        x = picpj.width / 2 - .pixelwidth / 2
        y = (picpj.height - .pixelheight) - 5
        
        call drawtransparentgrhtohdc(picpj.hdc, x, y, grh, sr, vbblack)
        y = y + .pixelheight
    end with
    
    grh = headdata(userhead).head(dir).grhindex
    
    with grhdata(grh)
        sr.left = .sx
        sr.top = .sy
        sr.right = sr.left + .pixelwidth
        sr.bottom = sr.top + .pixelheight
        
        x = picpj.width / 2 - .pixelwidth / 2
        y = y + bodydata(userbody).headoffset.y - .pixelheight
        
        call drawtransparentgrhtohdc(picpj.hdc, x, y, grh, sr, vbblack)
    end with
end sub

private sub drawhead(byval head as integer, byval picindex as integer)

    dim sr as rect
    dim grh as long
    dim x as long
    dim y as long
    
    call drawimageinpicture(pichead(picindex), me.picture, 0, 0, , , pichead(picindex).left, pichead(picindex).top)
    
    grh = headdata(head).head(dir).grhindex

    with grhdata(grh)
        sr.left = .sx
        sr.top = .sy
        sr.right = sr.left + .pixelwidth
        sr.bottom = sr.top + .pixelheight
        
        x = pichead(picindex).width / 2 - .pixelwidth / 2
        y = 1
        
        call drawtransparentgrhtohdc(pichead(picindex).hdc, x, y, grh, sr, vbblack)
    end with
    
end sub

private sub txtconfirmpasswd_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ieconfirmpasswd)
end sub

private sub txtmail_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iemail)
end sub

private sub txtnombre_change()
    txtnombre.text = ltrim(txtnombre.text)
end sub

private sub txtnombre_keypress(keyascii as integer)
    keyascii = asc(ucase(chr(keyascii)))
end sub

private sub darcuerpoycabeza()

    dim bvisible as boolean
    dim picindex as integer
    dim lineindex as integer
    
    select case usersexo
        case egenero.hombre
            select case userraza
                case eraza.humano
                    userhead = humano_h_primer_cabeza
                    userbody = humano_h_cuerpo_desnudo
                    
                case eraza.elfo
                    userhead = elfo_h_primer_cabeza
                    userbody = elfo_h_cuerpo_desnudo
                    
                case eraza.elfooscuro
                    userhead = drow_h_primer_cabeza
                    userbody = drow_h_cuerpo_desnudo
                    
                case eraza.enano
                    userhead = enano_h_primer_cabeza
                    userbody = enano_h_cuerpo_desnudo
                    
                case eraza.gnomo
                    userhead = gnomo_h_primer_cabeza
                    userbody = gnomo_h_cuerpo_desnudo
                    
                case else
                    userhead = 0
                    userbody = 0
            end select
            
        case egenero.mujer
            select case userraza
                case eraza.humano
                    userhead = humano_m_primer_cabeza
                    userbody = humano_m_cuerpo_desnudo
                    
                case eraza.elfo
                    userhead = elfo_m_primer_cabeza
                    userbody = elfo_m_cuerpo_desnudo
                    
                case eraza.elfooscuro
                    userhead = drow_m_primer_cabeza
                    userbody = drow_m_cuerpo_desnudo
                    
                case eraza.enano
                    userhead = enano_m_primer_cabeza
                    userbody = enano_m_cuerpo_desnudo
                    
                case eraza.gnomo
                    userhead = gnomo_m_primer_cabeza
                    userbody = gnomo_m_cuerpo_desnudo
                    
                case else
                    userhead = 0
                    userbody = 0
            end select
        case else
            userhead = 0
            userbody = 0
    end select
    
    bvisible = userhead <> 0 and userbody <> 0
    
    headpj(0).visible = bvisible
    headpj(1).visible = bvisible
    dirpj(0).visible = bvisible
    dirpj(1).visible = bvisible
    
    for picindex = 0 to 4
        pichead(picindex).visible = bvisible
    next picindex
    
    for lineindex = 0 to 3
        line1(lineindex).visible = bvisible
    next lineindex
    
    if bvisible then call updateheadselection
    
    currentgrh = bodydata(userbody).walk(dir).grhindex
    if currentgrh > 0 then _
        tanimacion.interval = round(grhdata(currentgrh).speed / grhdata(currentgrh).numframes)
end sub

private function checkcabeza(byval head as integer) as integer

select case usersexo
    case egenero.hombre
        select case userraza
            case eraza.humano
                if head > humano_h_ultima_cabeza then
                    checkcabeza = humano_h_primer_cabeza + (head - humano_h_ultima_cabeza) - 1
                elseif head < humano_h_primer_cabeza then
                    checkcabeza = humano_h_ultima_cabeza - (humano_h_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.elfo
                if head > elfo_h_ultima_cabeza then
                    checkcabeza = elfo_h_primer_cabeza + (head - elfo_h_ultima_cabeza) - 1
                elseif head < elfo_h_primer_cabeza then
                    checkcabeza = elfo_h_ultima_cabeza - (elfo_h_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.elfooscuro
                if head > drow_h_ultima_cabeza then
                    checkcabeza = drow_h_primer_cabeza + (head - drow_h_ultima_cabeza) - 1
                elseif head < drow_h_primer_cabeza then
                    checkcabeza = drow_h_ultima_cabeza - (drow_h_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.enano
                if head > enano_h_ultima_cabeza then
                    checkcabeza = enano_h_primer_cabeza + (head - enano_h_ultima_cabeza) - 1
                elseif head < enano_h_primer_cabeza then
                    checkcabeza = enano_h_ultima_cabeza - (enano_h_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.gnomo
                if head > gnomo_h_ultima_cabeza then
                    checkcabeza = gnomo_h_primer_cabeza + (head - gnomo_h_ultima_cabeza) - 1
                elseif head < gnomo_h_primer_cabeza then
                    checkcabeza = gnomo_h_ultima_cabeza - (gnomo_h_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case else
                userraza = lstraza.listindex + 1
                checkcabeza = checkcabeza(head)
        end select
        
    case egenero.mujer
        select case userraza
            case eraza.humano
                if head > humano_m_ultima_cabeza then
                    checkcabeza = humano_m_primer_cabeza + (head - humano_m_ultima_cabeza) - 1
                elseif head < humano_m_primer_cabeza then
                    checkcabeza = humano_m_ultima_cabeza - (humano_m_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.elfo
                if head > elfo_m_ultima_cabeza then
                    checkcabeza = elfo_m_primer_cabeza + (head - elfo_m_ultima_cabeza) - 1
                elseif head < elfo_m_primer_cabeza then
                    checkcabeza = elfo_m_ultima_cabeza - (elfo_m_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.elfooscuro
                if head > drow_m_ultima_cabeza then
                    checkcabeza = drow_m_primer_cabeza + (head - drow_m_ultima_cabeza) - 1
                elseif head < drow_m_primer_cabeza then
                    checkcabeza = drow_m_ultima_cabeza - (drow_m_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.enano
                if head > enano_m_ultima_cabeza then
                    checkcabeza = enano_m_primer_cabeza + (head - enano_m_ultima_cabeza) - 1
                elseif head < enano_m_primer_cabeza then
                    checkcabeza = enano_m_ultima_cabeza - (enano_m_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case eraza.gnomo
                if head > gnomo_m_ultima_cabeza then
                    checkcabeza = gnomo_m_primer_cabeza + (head - gnomo_m_ultima_cabeza) - 1
                elseif head < gnomo_m_primer_cabeza then
                    checkcabeza = gnomo_m_ultima_cabeza - (gnomo_m_primer_cabeza - head) + 1
                else
                    checkcabeza = head
                end if
                
            case else
                userraza = lstraza.listindex + 1
                checkcabeza = checkcabeza(head)
        end select
    case else
        usersexo = lstgenero.listindex + 1
        checkcabeza = checkcabeza(head)
end select
end function

private function checkdir(byref dir as e_heading) as e_heading

    if dir > e_heading.west then dir = e_heading.north
    if dir < e_heading.north then dir = e_heading.west
    
    checkdir = dir
    
    currentgrh = bodydata(userbody).walk(dir).grhindex
    if currentgrh > 0 then _
        tanimacion.interval = round(grhdata(currentgrh).speed / grhdata(currentgrh).numframes)

end function

private sub loadhelp()
    vhelp(ehelp.iepasswd) = "la contrase�a que utilizar�s para conectar tu personaje al juego."
    vhelp(ehelp.ietirardados) = "presionando sobre la esfera roja, se modificar�n al azar los atributos de tu personaje, de esta manera puedes elegir los que m�s te parezcan para definir a tu personaje."
    vhelp(ehelp.iemail) = "es sumamente importante que ingreses una direcci�n de correo electr�nico v�lida, ya que en el caso de perder la contrase�a de tu personaje, se te enviar� cuando lo requieras, a esa direcci�n."
    vhelp(ehelp.ienombre) = "s� cuidadoso al seleccionar el nombre de tu personaje. argentum es un juego de rol, un mundo m�gico y fant�stico, y si seleccion�s un nombre obsceno o con connotaci�n pol�tica, los administradores borrar�n tu personaje y no habr� ninguna posibilidad de recuperarlo."
    vhelp(ehelp.ieconfirmpasswd) = "la contrase�a que utilizar�s para conectar tu personaje al juego."
    vhelp(ehelp.ieatributos) = "son las cualidades que definen tu personaje. generalmente se los llama ""dados"". (ver tirar dados)"
    vhelp(ehelp.ied) = "son los atributos que obtuviste al azar. presion� la esfera roja para volver a tirarlos."
    vhelp(ehelp.iem) = "son los modificadores por raza que influyen en los atributos de tu personaje."
    vhelp(ehelp.ief) = "los atributos finales de tu personaje, de acuerdo a la raza que elegiste."
    vhelp(ehelp.iefuerza) = "de ella depender� qu� tan potentes ser�n tus golpes, tanto con armas de cuerpo a cuerpo, a distancia o sin armas."
    vhelp(ehelp.ieagilidad) = "este atributo intervendr� en qu� tan bueno seas, tanto evadiendo como acertando golpes, respecto de otros personajes como de las criaturas a las q te enfrentes."
    vhelp(ehelp.ieinteligencia) = "influir� de manera directa en cu�nto man� ganar�s por nivel."
    vhelp(ehelp.iecarisma) = "ser� necesario tanto para la relaci�n con otros personajes (entrenamiento en parties) como con las criaturas (domar animales)."
    vhelp(ehelp.ieconstitucion) = "afectar� a la cantidad de vida que podr�s ganar por nivel."
    vhelp(ehelp.ieevasion) = "eval�a la habilidad esquivando ataques f�sicos."
    vhelp(ehelp.iemagia) = "punt�a la cantidad de man� que se tendr�."
    vhelp(ehelp.ievida) = "valora la cantidad de salud que se podr� llegar a tener."
    vhelp(ehelp.ieescudos) = "estima la habilidad para rechazar golpes con escudos."
    vhelp(ehelp.iearmas) = "eval�a la habilidad en el combate cuerpo a cuerpo con armas."
    vhelp(ehelp.iearcos) = "eval�a la habilidad en el combate a distancia con arcos. "
    vhelp(ehelp.ieespecialidad) = ""
    vhelp(ehelp.iepuebloorigen) = "define el hogar de tu personaje. sin embargo, el personaje nacer� en nemahuak, la ciudad de los novatos."
    vhelp(ehelp.ieraza) = "de la raza que elijas depender� c�mo se modifiquen los dados que saques. pod�s cambiar de raza para poder visualizar c�mo se modifican los distintos atributos."
    vhelp(ehelp.ieclase) = "la clase influir� en las caracter�sticas principales que tenga tu personaje, asi como en las magias e items que podr� utilizar. las estrellas que ves abajo te mostrar�n en qu� habilidades se destaca la misma."
    vhelp(ehelp.iegenero) = "indica si el personaje ser� masculino o femenino. esto influye en los items que podr� equipar."
    vhelp(ehelp.iealineacion) = "indica si el personaje seguir� la senda del mal o del bien. (actualmente deshabilitado)"
end sub

private sub clearlabel()
    lastbuttonpressed.toggletonormal
    lblhelp = ""
end sub

private sub txtnombre_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.ienombre)
end sub

private sub txtpasswd_mousemove(button as integer, shift as integer, x as single, y as single)
    lblhelp.caption = vhelp(ehelp.iepasswd)
end sub

public sub updatestats()
    call updaterazamod
    call updatestars
end sub

private sub updaterazamod()
    dim selraza as integer
    dim i as integer
    
    
    if lstraza.listindex > -1 then
    
        selraza = lstraza.listindex + 1
        
        with modraza(selraza)
            lblmodraza(eatributos.fuerza).caption = iif(.fuerza >= 0, "+", "") & .fuerza
            lblmodraza(eatributos.agilidad).caption = iif(.agilidad >= 0, "+", "") & .agilidad
            lblmodraza(eatributos.inteligencia).caption = iif(.inteligencia >= 0, "+", "") & .inteligencia
            lblmodraza(eatributos.carisma).caption = iif(.carisma >= 0, "+", "") & .carisma
            lblmodraza(eatributos.constitucion).caption = iif(.constitucion >= 0, "+", "") & .constitucion
        end with
    end if
    
    ' atributo total
    for i = 1 to numatributes
        lblatributofinal(i).caption = val(lblatributos(i).caption) + val(lblmodraza(i))
    next i
    
end sub

private sub updatestars()
    dim numstars as double
    
    if userclase = 0 then exit sub
    
    ' estrellas de evasion
    numstars = (2.454 + 0.073 * val(lblatributofinal(eatributos.agilidad).caption)) * modclase(userclase).evasion
    call setstars(imgevasionstar, numstars * 2)
    
    ' estrellas de magia
    numstars = modclase(userclase).magia * val(lblatributofinal(eatributos.inteligencia).caption) * 0.085
    call setstars(imgmagiastar, numstars * 2)
    
    ' estrellas de vida
    numstars = 0.24 + (val(lblatributofinal(eatributos.constitucion).caption) * 0.5 - modclase(userclase).vida) * 0.475
    call setstars(imgvidastar, numstars * 2)
    
    ' estrellas de escudo
    numstars = 4 * modclase(userclase).escudo
    call setstars(imgescudosstar, numstars * 2)
    
    ' estrellas de armas
    numstars = (0.509 + 0.01185 * val(lblatributofinal(eatributos.fuerza).caption)) * modclase(userclase).hit * _
                modclase(userclase).da�oarmas + 0.119 * modclase(userclase).ataquearmas * _
                val(lblatributofinal(eatributos.agilidad).caption)
    call setstars(imgarmasstar, numstars * 2)
    
    ' estrellas de arcos
    numstars = (0.4915 + 0.01265 * val(lblatributofinal(eatributos.fuerza).caption)) * _
                modclase(userclase).da�oproyectiles * modclase(userclase).hit + 0.119 * modclase(userclase).ataqueproyectiles * _
                val(lblatributofinal(eatributos.agilidad).caption)
    call setstars(imgarcostar, numstars * 2)
end sub

private sub setstars(byref imgcontainer as object, byval numstars as integer)
    dim fullstars as integer
    dim hashalfstar as boolean
    dim index as integer
    dim counter as integer

    if numstars > 0 then
        
        if numstars > 10 then numstars = 10
        
        fullstars = int(numstars / 2)
        
        ' tienen brillo extra si estan todas
        if fullstars = 5 then
            for index = 1 to fullstars
                imgcontainer(index).picture = picglowstar
            next index
        else
            ' numero impar? entonces hay que poner "media estrella"
            if (numstars mod 2) > 0 then hashalfstar = true
            
            ' muestro las estrellas enteras
            if fullstars > 0 then
                for index = 1 to fullstars
                    imgcontainer(index).picture = picfullstar
                next index
                
                counter = fullstars
            end if
            
            ' muestro la mitad de la estrella (si tiene)
            if hashalfstar then
                counter = counter + 1
                
                imgcontainer(counter).picture = pichalfstar
            end if
            
            ' si estan completos los espacios, no borro nada
            if counter <> 5 then
                ' limpio las que queden vacias
                for index = counter + 1 to 5
                    set imgcontainer(index).picture = nothing
                next index
            end if
            
        end if
    else
        ' limpio todo
        for index = 1 to 5
            set imgcontainer(index).picture = nothing
        next index
    end if

end sub

private sub loadcharinfo()
    dim searchvar as string
    dim i as integer
    
    nrorazas = ubound(listarazas())
    nroclases = ubound(listaclases())

    redim modraza(1 to nrorazas)
    redim modclase(1 to nroclases)
    
    'modificadores de clase
    for i = 1 to nroclases
        with modclase(i)
            searchvar = listaclases(i)
            
            .evasion = val(getvar(inipath & "charinfo.dat", "modevasion", searchvar))
            .ataquearmas = val(getvar(inipath & "charinfo.dat", "modataquearmas", searchvar))
            .ataqueproyectiles = val(getvar(inipath & "charinfo.dat", "modataqueproyectiles", searchvar))
            .da�oarmas = val(getvar(inipath & "charinfo.dat", "modda�oarmas", searchvar))
            .da�oproyectiles = val(getvar(inipath & "charinfo.dat", "modda�oproyectiles", searchvar))
            .escudo = val(getvar(inipath & "charinfo.dat", "modescudo", searchvar))
            .hit = val(getvar(inipath & "charinfo.dat", "hit", searchvar))
            .magia = val(getvar(inipath & "charinfo.dat", "modmagia", searchvar))
            .vida = val(getvar(inipath & "charinfo.dat", "modvida", searchvar))
        end with
    next i
    
    'modificadores de raza
    for i = 1 to nrorazas
        with modraza(i)
            searchvar = replace(listarazas(i), " ", "")
        
            .fuerza = val(getvar(inipath & "charinfo.dat", "modraza", searchvar + "fuerza"))
            .agilidad = val(getvar(inipath & "charinfo.dat", "modraza", searchvar + "agilidad"))
            .inteligencia = val(getvar(inipath & "charinfo.dat", "modraza", searchvar + "inteligencia"))
            .carisma = val(getvar(inipath & "charinfo.dat", "modraza", searchvar + "carisma"))
            .constitucion = val(getvar(inipath & "charinfo.dat", "modraza", searchvar + "constitucion"))
        end with
    next i

end sub
