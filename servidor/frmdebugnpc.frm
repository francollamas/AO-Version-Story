version 5.00
begin vb.form frmdebugnpc 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "debug npcs"
   clientheight    =   2460
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   2460
   scalewidth      =   4680
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
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
      height          =   300
      left            =   90
      style           =   1  'graphical
      tabindex        =   5
      top             =   2085
      width           =   4455
   end
   begin vb.commandbutton command1 
      backcolor       =   &h00ffc0c0&
      caption         =   "actualizarinfo"
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
      left            =   90
      style           =   1  'graphical
      tabindex        =   2
      top             =   1755
      width           =   4455
   end
   begin vb.label label4 
      backstyle       =   0  'transparent
      caption         =   "maxnpcs:"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   90
      tabindex        =   4
      top             =   1380
      width           =   4455
   end
   begin vb.label label3 
      backstyle       =   0  'transparent
      caption         =   "lastnpcindex:"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   90
      tabindex        =   3
      top             =   1065
      width           =   4455
   end
   begin vb.label label2 
      backstyle       =   0  'transparent
      caption         =   "npcs libres:"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   105
      tabindex        =   1
      top             =   720
      width           =   4455
   end
   begin vb.label label1 
      backstyle       =   0  'transparent
      caption         =   "npcs activos:"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
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

