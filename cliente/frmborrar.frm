version 5.00
begin vb.form frmborrar 
   borderstyle     =   1  'fixed single
   caption         =   "eliminar personaje"
   clientheight    =   2835
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4635
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   moveable        =   0   'false
   scaleheight     =   2835
   scalewidth      =   4635
   startupposition =   2  'centerscreen
   begin vb.commandbutton command1 
      caption         =   "cancelar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   420
      left            =   150
      mouseicon       =   "frmborrar.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   7
      top             =   2325
      width           =   1005
   end
   begin vb.commandbutton cmdborrar 
      caption         =   "borrar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   420
      left            =   3480
      mouseicon       =   "frmborrar.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   6
      top             =   2340
      visible         =   0   'false
      width           =   1005
   end
   begin vb.textbox txtpasswd 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      left            =   135
      tabindex        =   5
      top             =   1860
      visible         =   0   'false
      width           =   4350
   end
   begin vb.textbox txtnombre 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      left            =   120
      tabindex        =   4
      top             =   1140
      visible         =   0   'false
      width           =   4350
   end
   begin vb.label lblwhat 
      caption         =   $"frmborrar.frx":02a4
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
      left            =   195
      tabindex        =   8
      top             =   585
      width           =   4290
   end
   begin vb.label label4 
      caption         =   "password:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   150
      tabindex        =   3
      top             =   1635
      visible         =   0   'false
      width           =   2145
   end
   begin vb.label label3 
      caption         =   "nombre del personaje:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   150
      tabindex        =   2
      top             =   900
      visible         =   0   'false
      width           =   2145
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   "atenci�n"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   270
      left            =   1740
      tabindex        =   1
      top             =   60
      visible         =   0   'false
      width           =   1020
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   "mediante esta acci�n borrar�s el personaje almacenado en el servidor y no habr� manera de recuperarlo!"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   435
      left            =   120
      tabindex        =   0
      top             =   345
      visible         =   0   'false
      width           =   4440
   end
end
attribute vb_name = "frmborrar"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
'
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


private sub cmdborrar_click()
#if usarrwench = 1 then

frmmain.socket1.hostname = curserverip
frmmain.socket1.remoteport = curserverport
me.mousepointer = 11
frmmain.socket1.connect

#else

me.mousepointer = 11
if frmmain.winsock1.state <> sckclosed then _
    frmmain.winsock1.close
frmmain.winsock1.connect curserverip, curserverport

#end if
end sub

private sub command1_click()
me.visible = false
end sub

