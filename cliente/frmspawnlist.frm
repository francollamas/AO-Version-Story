version 5.00
begin vb.form frmspawnlist 
   borderstyle     =   3  'fixed dialog
   caption         =   "invocar"
   clientheight    =   3465
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   3300
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3465
   scalewidth      =   3300
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.commandbutton command1 
      caption         =   "spawn"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   345
      mouseicon       =   "frmspawnlist.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2985
      width           =   1650
   end
   begin vb.commandbutton command2 
      caption         =   "salir"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   2025
      mouseicon       =   "frmspawnlist.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   2985
      width           =   810
   end
   begin vb.listbox lstcriaturas 
      height          =   2400
      left            =   345
      tabindex        =   0
      top             =   480
      width           =   2490
   end
   begin vb.label label1 
      autosize        =   -1  'true
      caption         =   "selecciona la criatura:"
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
      left            =   645
      tabindex        =   3
      top             =   75
      width           =   1935
   end
end
attribute vb_name = "frmspawnlist"
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

private sub command1_click()
    call writespawncreature(lstcriaturas.listindex + 1)
end sub

private sub command2_click()
    unload me
end sub

private sub form_deactivate()
    'me.setfocus
end sub

