version 5.00
begin vb.form frmherrero 
   borderstyle     =   1  'fixed single
   caption         =   "herrero"
   clientheight    =   3585
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4470
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3585
   scalewidth      =   4470
   startupposition =   1  'centerowner
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
      left            =   120
      mouseicon       =   "frmherrero.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   4
      top             =   3015
      width           =   1710
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
      left            =   2520
      mouseicon       =   "frmherrero.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   3015
      width           =   1710
   end
   begin vb.listbox lstarmas 
      height          =   2010
      left            =   150
      tabindex        =   2
      top             =   810
      width           =   4080
   end
   begin vb.commandbutton command2 
      caption         =   "armaduras"
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
      left            =   2370
      mouseicon       =   "frmherrero.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   210
      width           =   1710
   end
   begin vb.commandbutton command1 
      caption         =   "armas"
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
      left            =   210
      mouseicon       =   "frmherrero.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   210
      width           =   1710
   end
   begin vb.listbox lstarmaduras 
      height          =   2010
      left            =   135
      tabindex        =   5
      top             =   825
      width           =   4080
   end
end
attribute vb_name = "frmherrero"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.9
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
lstarmaduras.visible = false
lstarmas.visible = true
end sub

private sub command2_click()
lstarmaduras.visible = true
lstarmas.visible = false
end sub

private sub command3_click()

on error resume next

if lstarmas.visible then
 call senddata("cns" & armasherrero(lstarmas.listindex))
else
 call senddata("cns" & armadurasherrero(lstarmaduras.listindex))
end if

unload me

end sub

private sub command4_click()
unload me
end sub

private sub form_deactivate()
'me.setfocus
end sub

