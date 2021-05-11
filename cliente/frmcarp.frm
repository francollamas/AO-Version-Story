version 5.00
begin vb.form frmcarp 
   caption         =   "carpintero"
   clientheight    =   3165
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   4650
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   3165
   scalewidth      =   4650
   startupposition =   1  'centerowner
   begin vb.listbox lstarmas 
      height          =   2205
      left            =   270
      tabindex        =   2
      top             =   240
      width           =   4080
   end
   begin vb.commandbutton command3 
      caption         =   "construir"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   435
      left            =   2640
      mouseicon       =   "frmcarp.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   2670
      width           =   1710
   end
   begin vb.commandbutton command4 
      caption         =   "salir"
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
      left            =   255
      mouseicon       =   "frmcarp.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   2670
      width           =   1710
   end
end
attribute vb_name = "frmcarp"
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

option explicit

private sub command3_click()
on error resume next

call senddata("cnc" & objcarpintero(lstarmas.listindex))

unload me
end sub

private sub command4_click()
unload me
end sub

private sub form_deactivate()
'me.setfocus
end sub

