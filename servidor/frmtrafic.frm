version 5.00
begin vb.form frmtrafic 
   borderstyle     =   1  'fixed single
   caption         =   "trafico"
   clientheight    =   3195
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3195
   scalewidth      =   4680
   startupposition =   3  'windows default
   begin vb.commandbutton command1 
      caption         =   "cerrar"
      height          =   585
      left            =   90
      tabindex        =   1
      top             =   2250
      width           =   960
   end
   begin vb.listbox lsttrafico 
      height          =   2010
      left            =   60
      tabindex        =   0
      top             =   135
      width           =   4455
   end
end
attribute vb_name = "frmtrafic"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.20
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



private sub command1_click()
me.visible = false
end sub

