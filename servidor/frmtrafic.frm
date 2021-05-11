version 5.00
begin vb.form frmtrafic 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "trafico"
   clientheight    =   2850
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   2850
   scalewidth      =   4680
   startupposition =   2  'centerscreen
   begin vb.commandbutton command1 
      backcolor       =   &h00ffc0c0&
      cancel          =   -1  'true
      caption         =   "salir (esc)"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   465
      left            =   90
      style           =   1  'graphical
      tabindex        =   1
      top             =   2280
      width           =   1440
   end
   begin vb.listbox lsttrafico 
      backcolor       =   &h00c0ffff&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1815
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
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
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
    me.visible = false
end sub
