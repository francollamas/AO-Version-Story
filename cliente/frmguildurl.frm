version 5.00
begin vb.form frmguildurl 
   borderstyle     =   1  'fixed single
   caption         =   "oficial web site"
   clientheight    =   1035
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   6135
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   1035
   scalewidth      =   6135
   startupposition =   1  'centerowner
   begin vb.commandbutton command1 
      caption         =   "aceptar"
      default         =   -1  'true
      height          =   255
      left            =   120
      mouseicon       =   "frmguildurl.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   720
      width           =   5895
   end
   begin vb.textbox text1 
      height          =   285
      left            =   120
      tabindex        =   1
      top             =   360
      width           =   5895
   end
   begin vb.label label1 
      caption         =   "ingrese la direccion del site:"
      height          =   255
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   4215
   end
end
attribute vb_name = "frmguildurl"
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
if text1 <> "" then _
    call senddata("newwebsi" & text1)
unload me
end sub

