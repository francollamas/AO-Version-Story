version 5.00
begin vb.form frmpres 
   autoredraw      =   -1  'true
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   3195
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   4680
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3195
   scalewidth      =   4680
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.timer timer1 
      interval        =   3400
      left            =   1125
      top             =   1230
   end
end
attribute vb_name = "frmpres"
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

dim puedo as boolean

private sub form_keypress(keyascii as integer)
    if keyascii = 27 then if puedo then unload me
end sub

private sub form_load()
    me.width = 800 * screen.twipsperpixelx
    me.height = 600 * screen.twipsperpixely
    puedo = false
end sub

private sub timer1_timer()
static ticks as long

ticks = ticks + 1

if ticks = 1 then
    me.picture = loadpicture(app.path & "\graficos\alkonao2.jpg")
    puedo = true
elseif ticks = 2 then
    me.picture = loadpicture(app.path & "\graficos\newfinal.jpg")
else
    unload me
end if

end sub
