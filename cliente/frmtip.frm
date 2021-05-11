version 5.00
begin vb.form frmtip 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   1965
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   4680
   controlbox      =   0   'false
   fillcolor       =   &h80000004&
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   1965
   scalewidth      =   4680
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.commandbutton command1 
      caption         =   "aceptar"
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
      mouseicon       =   "frmtip.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   1575
      width           =   1185
   end
   begin vb.checkbox check1 
      backcolor       =   &h00c0c0c0&
      caption         =   "mostrar proxima vez"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   270
      left            =   2040
      mouseicon       =   "frmtip.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   1620
      value           =   1  'checked
      width           =   2340
   end
   begin vb.label tip 
      backstyle       =   0  'transparent
      caption         =   "label2"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   1260
      left            =   120
      tabindex        =   1
      top             =   75
      width           =   4305
      wordwrap        =   -1  'true
   end
end
attribute vb_name = "frmtip"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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


private sub command1_click()
if frmtip.check1.value = vbchecked then
    tipf = "1"
else
    tipf = "0"
end if

unload me
end sub

private sub form_deactivate()
me.setfocus
end sub

private sub label2_click()
if frmtip.check1.value = vbchecked then
    tipf = "1"
else
    tipf = "0"
end if

unload me
end sub

