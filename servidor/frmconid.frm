version 5.00
begin vb.form frmconid 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "conid"
   clientheight    =   4440
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   4440
   scalewidth      =   4680
   startupposition =   2  'centerscreen
   begin vb.commandbutton command3 
      backcolor       =   &h00ffc0c0&
      caption         =   "liberar todos los slots"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   135
      style           =   1  'graphical
      tabindex        =   3
      top             =   3495
      width           =   4290
   end
   begin vb.commandbutton command2 
      backcolor       =   &h00ffc0c0&
      caption         =   "ver estado"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   135
      style           =   1  'graphical
      tabindex        =   2
      top             =   3030
      width           =   4290
   end
   begin vb.listbox list1 
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
      height          =   2205
      left            =   180
      tabindex        =   1
      top             =   150
      width           =   4215
   end
   begin vb.commandbutton command1 
      backcolor       =   &h00ffc0c0&
      caption         =   "cerrar"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   120
      style           =   1  'graphical
      tabindex        =   0
      top             =   3975
      width           =   4290
   end
   begin vb.label label1 
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
      height          =   510
      left            =   180
      tabindex        =   4
      top             =   2430
      width           =   4230
   end
end
attribute vb_name = "frmconid"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m???rquez pablo ignacio
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
'calle 3 n???mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c???digo postal 1900
'pablo ignacio m???rquez

option explicit

private sub command1_click()
    unload me
end sub

private sub command2_click()

list1.clear

dim c as integer
dim i as integer

for i = 1 to maxusers
    list1.additem "userindex " & i & " -- " & userlist(i).connid
    if userlist(i).connid <> -1 then c = c + 1
next i

if c = maxusers then
    label1.caption = "???no hay slots vacios!"
else
    label1.caption = "???hay " & maxusers - c & " slots vacios!"
end if

end sub

private sub command3_click()
dim i as integer

for i = 1 to maxusers
    if userlist(i).connid <> -1 and userlist(i).connidvalida and not userlist(i).flags.userlogged then call closesocket(i)
next i

end sub

