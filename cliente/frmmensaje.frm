version 5.00
begin vb.form frmmensaje 
   backcolor       =   &h00c0c0c0&
   caption         =   "mensaje"
   clientheight    =   3195
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   3990
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   3195
   scalewidth      =   3990
   startupposition =   1  'centerowner
   begin vb.commandbutton command1 
      caption         =   "cerrar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   120
      mouseicon       =   "frmmensaje.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   2760
      width           =   3735
   end
   begin vb.label msg 
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
      forecolor       =   &h00000000&
      height          =   2535
      left            =   60
      tabindex        =   0
      top             =   120
      width           =   3855
      wordwrap        =   -1  'true
   end
end
attribute vb_name = "frmmensaje"
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
unload me
end sub

private sub form_deactivate()
me.setfocus
end sub

