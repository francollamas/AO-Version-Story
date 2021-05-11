version 5.00
begin vb.form frmdebugnpc 
   caption         =   "debugnpcs"
   clientheight    =   2460
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   4680
   linktopic       =   "form1"
   scaleheight     =   2460
   scalewidth      =   4680
   startupposition =   3  'windows default
   begin vb.commandbutton command2 
      caption         =   "salir"
      height          =   300
      left            =   90
      tabindex        =   5
      top             =   2085
      width           =   4455
   end
   begin vb.commandbutton command1 
      caption         =   "actualizarinfo"
      height          =   300
      left            =   90
      tabindex        =   2
      top             =   1755
      width           =   4455
   end
   begin vb.label label4 
      caption         =   "maxnpcs:"
      height          =   285
      left            =   90
      tabindex        =   4
      top             =   1380
      width           =   4455
   end
   begin vb.label label3 
      caption         =   "lastnpcindex:"
      height          =   285
      left            =   90
      tabindex        =   3
      top             =   1065
      width           =   4455
   end
   begin vb.label label2 
      caption         =   "npcs libres:"
      height          =   285
      left            =   105
      tabindex        =   1
      top             =   720
      width           =   4455
   end
   begin vb.label label1 
      caption         =   "npcs activos:"
      height          =   285
      left            =   90
      tabindex        =   0
      top             =   360
      width           =   4455
   end
end
attribute vb_name = "frmdebugnpc"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.2
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
dim i as integer, k as integer

for i = 1 to lastnpc
    if npclist(i).flags.npcactive then k = k + 1
next i

label1.caption = "npcs activos:" & k
label2.caption = "npcs libres:" & maxnpcs - k
label3.caption = "lastnpcindex:" & lastnpc
label4.caption = "maxnpcs:" & maxnpcs

end sub

private sub command2_click()
unload me
end sub

