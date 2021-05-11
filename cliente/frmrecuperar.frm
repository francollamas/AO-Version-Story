version 5.00
begin vb.form frmrecuperar 
   borderstyle     =   3  'fixed dialog
   clientheight    =   3000
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   4635
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   moveable        =   0   'false
   scaleheight     =   3000
   scalewidth      =   4635
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.textbox txtcorreo 
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   300
      left            =   345
      tabindex        =   3
      top             =   1830
      visible         =   0   'false
      width           =   3750
   end
   begin vb.commandbutton command2 
      caption         =   "cancelar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   465
      left            =   315
      mouseicon       =   "frmrecuperar.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   5
      top             =   2340
      width           =   1095
   end
   begin vb.commandbutton command1 
      caption         =   "recuperar"
      default         =   -1  'true
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   465
      left            =   3180
      mouseicon       =   "frmrecuperar.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   4
      top             =   2340
      visible         =   0   'false
      width           =   1095
   end
   begin vb.textbox txtnombre 
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   300
      left            =   405
      tabindex        =   2
      top             =   1080
      visible         =   0   'false
      width           =   3750
   end
   begin vb.label lblwhat 
      caption         =   $"frmrecuperar.frx":02a4
      beginproperty font 
         name            =   "verdana"
         size            =   11.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   1995
      left            =   165
      tabindex        =   7
      top             =   645
      width           =   4290
   end
   begin vb.label label3 
      alignment       =   2  'center
      caption         =   "direcci�n de correo:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   300
      left            =   375
      tabindex        =   6
      top             =   1560
      visible         =   0   'false
      width           =   3735
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   "nombre del personaje:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   300
      left            =   420
      tabindex        =   1
      top             =   810
      visible         =   0   'false
      width           =   3735
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   $"frmrecuperar.frx":033b
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   690
      left            =   60
      tabindex        =   0
      top             =   75
      visible         =   0   'false
      width           =   4500
   end
end
attribute vb_name = "frmrecuperar"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
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


private sub command1_click()
'ojo
estadologin = recuperarpass
me.mousepointer = 11

#if usarwrench = 1 then
frmmain.socket1.hostname = curserverip
'frmmain.socket1.hostname = "127.0.0.1"
frmmain.socket1.remoteport = curserverpasrecport
frmmain.socket1.connect
#else
if frmmain.winsock1.state <> sckclosed then _
    frmmain.winsock1.close
frmmain.winsock1.connect curserverip, curserverpasrecport
#end if
end sub

private sub command2_click()
unload me
end sub

