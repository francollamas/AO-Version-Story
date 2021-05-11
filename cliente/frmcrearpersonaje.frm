version 5.00
begin vb.form frmcrearpersonaje 
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   9000
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   12000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   600
   scalemode       =   3  'pixel
   scalewidth      =   800
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
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
      itemdata        =   "frmcrearpersonaje.frx":0000
      left            =   5925
      list            =   "frmcrearpersonaje.frx":0002
      style           =   2  'dropdown list
      tabindex        =   31
      top             =   2700
      width           =   2820
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
      itemdata        =   "frmcrearpersonaje.frx":0004
      left            =   5925
      list            =   "frmcrearpersonaje.frx":000e
      style           =   2  'dropdown list
      tabindex        =   30
      top             =   2250
      width           =   2820
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
      itemdata        =   "frmcrearpersonaje.frx":0021
      left            =   5925
      list            =   "frmcrearpersonaje.frx":0023
      style           =   2  'dropdown list
      tabindex        =   29
      top             =   1800
      width           =   2820
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
      itemdata        =   "frmcrearpersonaje.frx":0025
      left            =   9015
      list            =   "frmcrearpersonaje.frx":0027
      style           =   2  'dropdown list
      tabindex        =   7
      top             =   3510
      width           =   2565
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
      left            =   3570
      tabindex        =   0
      top             =   1275
      width           =   4815
   end
   begin vb.label label3 
      backstyle       =   0  'transparent
      caption         =   "+3"
      forecolor       =   &h00ffff80&
      height          =   195
      left            =   4020
      tabindex        =   33
      top             =   4260
      visible         =   0   'false
      width           =   195
   end
   begin vb.image image1 
      height          =   3120
      left            =   3270
      stretch         =   -1  'true
      top             =   4710
      width           =   2475
   end
   begin vb.label puntos 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      left            =   7200
      tabindex        =   32
      top             =   8535
      width           =   270
   end
   begin vb.image command1 
      height          =   165
      index           =   3
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0029
      mousepointer    =   99  'custom
      top             =   3465
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   5
      left            =   7785
      mouseicon       =   "frmcrearpersonaje.frx":017b
      mousepointer    =   99  'custom
      top             =   3675
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   7
      left            =   7785
      mouseicon       =   "frmcrearpersonaje.frx":02cd
      mousepointer    =   99  'custom
      top             =   3885
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   9
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":041f
      mousepointer    =   99  'custom
      top             =   4110
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   11
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0571
      mousepointer    =   99  'custom
      top             =   4335
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   13
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":06c3
      mousepointer    =   99  'custom
      top             =   4545
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   15
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0815
      mousepointer    =   99  'custom
      top             =   4785
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   17
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0967
      mousepointer    =   99  'custom
      top             =   4965
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   19
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0ab9
      mousepointer    =   99  'custom
      top             =   5175
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   21
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":0c0b
      mousepointer    =   99  'custom
      top             =   5385
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   23
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":0d5d
      mousepointer    =   99  'custom
      top             =   5610
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   25
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":0eaf
      mousepointer    =   99  'custom
      top             =   5820
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   27
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":1001
      mousepointer    =   99  'custom
      top             =   6015
      width           =   150
   end
   begin vb.image command1 
      height          =   165
      index           =   1
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":1153
      mousepointer    =   99  'custom
      top             =   3240
      width           =   150
   end
   begin vb.image command1 
      height          =   135
      index           =   0
      left            =   8355
      mouseicon       =   "frmcrearpersonaje.frx":12a5
      mousepointer    =   99  'custom
      top             =   3270
      width           =   180
   end
   begin vb.image command1 
      height          =   150
      index           =   2
      left            =   8355
      mouseicon       =   "frmcrearpersonaje.frx":13f7
      mousepointer    =   99  'custom
      top             =   3495
      width           =   195
   end
   begin vb.image command1 
      height          =   135
      index           =   4
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":1549
      mousepointer    =   99  'custom
      top             =   3720
      width           =   195
   end
   begin vb.image command1 
      height          =   150
      index           =   6
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":169b
      mousepointer    =   99  'custom
      top             =   3945
      width           =   180
   end
   begin vb.image command1 
      height          =   150
      index           =   8
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":17ed
      mousepointer    =   99  'custom
      top             =   4155
      width           =   195
   end
   begin vb.image command1 
      height          =   135
      index           =   10
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":193f
      mousepointer    =   99  'custom
      top             =   4380
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   12
      left            =   8355
      mouseicon       =   "frmcrearpersonaje.frx":1a91
      mousepointer    =   99  'custom
      top             =   4605
      width           =   165
   end
   begin vb.image command1 
      height          =   120
      index           =   14
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":1be3
      mousepointer    =   99  'custom
      top             =   4800
      width           =   135
   end
   begin vb.image command1 
      height          =   120
      index           =   16
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":1d35
      mousepointer    =   99  'custom
      top             =   4995
      width           =   135
   end
   begin vb.image command1 
      height          =   120
      index           =   18
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":1e87
      mousepointer    =   99  'custom
      top             =   5220
      width           =   150
   end
   begin vb.image command1 
      height          =   135
      index           =   20
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":1fd9
      mousepointer    =   99  'custom
      top             =   5400
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   22
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":212b
      mousepointer    =   99  'custom
      top             =   5640
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   24
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":227d
      mousepointer    =   99  'custom
      top             =   5850
      width           =   150
   end
   begin vb.image command1 
      height          =   120
      index           =   26
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":23cf
      mousepointer    =   99  'custom
      top             =   6075
      width           =   150
   end
   begin vb.image command1 
      height          =   150
      index           =   28
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":2521
      mousepointer    =   99  'custom
      top             =   6285
      width           =   165
   end
   begin vb.image command1 
      height          =   150
      index           =   29
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":2673
      mousepointer    =   99  'custom
      top             =   6270
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   30
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":27c5
      mousepointer    =   99  'custom
      top             =   6495
      width           =   150
   end
   begin vb.image command1 
      height          =   150
      index           =   31
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":2917
      mousepointer    =   99  'custom
      top             =   6465
      width           =   150
   end
   begin vb.image command1 
      height          =   135
      index           =   32
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":2a69
      mousepointer    =   99  'custom
      top             =   6720
      width           =   180
   end
   begin vb.image command1 
      height          =   135
      index           =   33
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":2bbb
      mousepointer    =   99  'custom
      top             =   6690
      width           =   180
   end
   begin vb.image command1 
      height          =   135
      index           =   34
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":2d0d
      mousepointer    =   99  'custom
      top             =   6945
      width           =   135
   end
   begin vb.image command1 
      height          =   150
      index           =   35
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":2e5f
      mousepointer    =   99  'custom
      top             =   6915
      width           =   165
   end
   begin vb.image command1 
      height          =   105
      index           =   36
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":2fb1
      mousepointer    =   99  'custom
      top             =   7170
      width           =   150
   end
   begin vb.image command1 
      height          =   180
      index           =   37
      left            =   7755
      mouseicon       =   "frmcrearpersonaje.frx":3103
      mousepointer    =   99  'custom
      top             =   7125
      width           =   195
   end
   begin vb.image command1 
      height          =   120
      index           =   38
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":3255
      mousepointer    =   99  'custom
      top             =   7395
      width           =   135
   end
   begin vb.image command1 
      height          =   165
      index           =   39
      left            =   7770
      mouseicon       =   "frmcrearpersonaje.frx":33a7
      mousepointer    =   99  'custom
      top             =   7335
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   40
      left            =   8370
      mouseicon       =   "frmcrearpersonaje.frx":34f9
      mousepointer    =   99  'custom
      top             =   7590
      width           =   165
   end
   begin vb.image command1 
      height          =   135
      index           =   41
      left            =   7815
      mouseicon       =   "frmcrearpersonaje.frx":364b
      mousepointer    =   99  'custom
      top             =   7560
      width           =   135
   end
   begin vb.image boton 
      height          =   645
      index           =   2
      left            =   315
      mouseicon       =   "frmcrearpersonaje.frx":379d
      mousepointer    =   99  'custom
      top             =   3015
      width           =   660
   end
   begin vb.image boton 
      height          =   255
      index           =   1
      left            =   1905
      mouseicon       =   "frmcrearpersonaje.frx":38ef
      mousepointer    =   99  'custom
      top             =   8565
      width           =   765
   end
   begin vb.image boton 
      height          =   210
      index           =   0
      left            =   9075
      mouseicon       =   "frmcrearpersonaje.frx":3a41
      mousepointer    =   99  'custom
      top             =   8565
      width           =   1200
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   20
      left            =   7995
      tabindex        =   28
      top             =   7515
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   19
      left            =   7995
      tabindex        =   27
      top             =   7306
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   18
      left            =   7995
      tabindex        =   26
      top             =   7092
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   17
      left            =   7995
      tabindex        =   25
      top             =   6878
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   16
      left            =   7995
      tabindex        =   24
      top             =   6664
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   15
      left            =   7995
      tabindex        =   23
      top             =   6450
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   14
      left            =   7995
      tabindex        =   22
      top             =   6236
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   13
      left            =   7995
      tabindex        =   21
      top             =   6022
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   12
      left            =   7995
      tabindex        =   20
      top             =   5808
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   11
      left            =   7995
      tabindex        =   19
      top             =   5594
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   10
      left            =   7995
      tabindex        =   18
      top             =   5380
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   9
      left            =   7995
      tabindex        =   17
      top             =   5166
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   8
      left            =   7995
      tabindex        =   16
      top             =   4952
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   7
      left            =   7995
      tabindex        =   15
      top             =   4738
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   6
      left            =   7995
      tabindex        =   14
      top             =   4524
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   5
      left            =   7995
      tabindex        =   13
      top             =   4310
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   4
      left            =   7995
      tabindex        =   12
      top             =   4096
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   3
      left            =   7995
      tabindex        =   11
      top             =   3882
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   2
      left            =   7995
      tabindex        =   10
      top             =   3668
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   0
      left            =   7995
      tabindex        =   9
      top             =   3240
      width           =   270
   end
   begin vb.label skill 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   1
      left            =   7995
      tabindex        =   8
      top             =   3450
      width           =   270
   end
   begin vb.image imghogar 
      height          =   2850
      left            =   8775
      picture         =   "frmcrearpersonaje.frx":3b93
      top             =   3900
      width           =   2985
   end
   begin vb.label lbcarisma 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   5310
      tabindex        =   6
      top             =   3570
      width           =   225
   end
   begin vb.label lbsabiduria 
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffff00&
      height          =   255
      left            =   3840
      tabindex        =   5
      top             =   4260
      visible         =   0   'false
      width           =   270
   end
   begin vb.label lbinteligencia 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   5325
      tabindex        =   4
      top             =   3240
      width           =   210
   end
   begin vb.label lbconstitucion 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   5310
      tabindex        =   3
      top             =   3900
      width           =   225
   end
   begin vb.label lbagilidad 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   5310
      tabindex        =   2
      top             =   2910
      width           =   225
   end
   begin vb.label lbfuerza 
      alignment       =   1  'right justify
      backstyle       =   0  'transparent
      caption         =   "0"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   5310
      tabindex        =   1
      top             =   2580
      width           =   210
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

public skillpoints as byte

function checkdata() as boolean
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

if skillpoints > 0 then
    msgbox "asigne los skillpoints del personaje."
    exit function
end if

dim i as integer
for i = 1 to numatributos
    if useratributos(i) = 0 then
        msgbox "los atributos del personaje son invalidos."
        exit function
    end if
next i

checkdata = true


end function

private sub boton_click(index as integer)
    call audio.playwave(snd_click)
    
    select case index
        case 0
            
            dim i as integer
            dim k as object
            i = 1
            for each k in skill
                userskills(i) = k.caption
                i = i + 1
            next
            
            username = txtnombre.text
            
            if right$(username, 1) = " " then
                username = rtrim$(username)
                msgbox "nombre invalido, se han removido los espacios al final del nombre"
            end if
            
            userraza = lstraza.listindex + 1
            usersexo = lstgenero.listindex + 1
            userclase = lstprofesion.listindex + 1
            
            useratributos(1) = val(lbfuerza.caption)
            useratributos(2) = val(lbinteligencia.caption)
            useratributos(3) = val(lbagilidad.caption)
            useratributos(4) = val(lbcarisma.caption)
            useratributos(5) = val(lbconstitucion.caption)
            
            userhogar = lsthogar.listindex + 1
            
            'barrin 3/10/03
            if checkdata() then
                frmpasswd.show vbmodal, me
            end if
            
        case 1
            call audio.playmidi("2.mid")
            
            frmconnect.fondo.picture = loadpicture(app.path & "\graficos\conectar.jpg")
            unload me
            
            
        case 2
            call audio.playwave(snd_dice)
            call tirardados
    end select
end sub


function randomnumber(byval lowerbound as variant, byval upperbound as variant) as single

randomize timer

randomnumber = (upperbound - lowerbound + 1) * rnd + lowerbound
if randomnumber > upperbound then randomnumber = upperbound

end function

private sub tirardados()
    call writethrowdices
    call flushbuffer
end sub

private sub command1_click(index as integer)
call audio.playwave(snd_click)

dim indice
if (index and &h1) = 0 then
    if skillpoints > 0 then
        indice = index \ 2
        skill(indice).caption = val(skill(indice).caption) + 1
        skillpoints = skillpoints - 1
    end if
else
    if skillpoints < 10 then
        
        indice = index \ 2
        if val(skill(indice).caption) > 0 then
            skill(indice).caption = val(skill(indice).caption) - 1
            skillpoints = skillpoints + 1
        end if
    end if
end if

puntos.caption = skillpoints
end sub

private sub form_load()
skillpoints = 10
puntos.caption = skillpoints
me.picture = loadpicture(app.path & "\graficos\cp-interface.jpg")
imghogar.picture = loadpicture(app.path & "\graficos\cp-ullathorpe.jpg")

dim i as integer
lstprofesion.clear
for i = lbound(listaclases) to ubound(listaclases)
    lstprofesion.additem listaclases(i)
next i

lsthogar.clear

for i = lbound(ciudades()) to ubound(ciudades())
    lsthogar.additem ciudades(i)
next i


lstraza.clear

for i = lbound(listarazas()) to ubound(listarazas())
    lstraza.additem listarazas(i)
next i


lstprofesion.clear

for i = lbound(listaclases()) to ubound(listaclases())
    lstprofesion.additem listaclases(i)
next i

lstprofesion.listindex = 1

image1.picture = loadpicture(app.path & "\graficos\" & lstprofesion.text & ".jpg")
call tirardados
end sub

private sub lstprofesion_click()
on error resume next
    image1.picture = loadpicture(app.path & "\graficos\" & lstprofesion.text & ".jpg")
    
'todo : esto vuela en la 0.12.1!!!
    if lstprofesion.listindex + 1 = eclass.druid then
        call msgbox("esta clase se encuentra deshabilitada hasta el pr�ximo parche, en el que se le realizar�n varios cambios importantes." & vbcrlf _
            & "sepan disculpar las molestias.")
        
        lstprofesion.listindex = 0
    end if
end sub

private sub txtnombre_change()
txtnombre.text = ltrim(txtnombre.text)
end sub

private sub txtnombre_gotfocus()
msgbox "sea cuidadoso al seleccionar el nombre de su personaje, argentum es un juego de rol, un mundo magico y fantastico, si selecciona un nombre obsceno o con connotaci�n politica los administradores borrar�n su personaje y no habr� ninguna posibilidad de recuperarlo."
end sub

private sub txtnombre_keypress(keyascii as integer)
    keyascii = asc(ucase(chr(keyascii)))
end sub
