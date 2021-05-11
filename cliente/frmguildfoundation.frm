version 5.00
begin vb.form frmguildfoundation 
   borderstyle     =   1  'fixed single
   caption         =   "creaci�n de un clan"
   clientheight    =   3840
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4050
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3840
   scalewidth      =   4050
   startupposition =   1  'centerowner
   begin vb.commandbutton command2 
      cancel          =   -1  'true
      caption         =   "cancelar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   120
      mouseicon       =   "frmguildfoundation.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   7
      top             =   3360
      width           =   975
   end
   begin vb.commandbutton command1 
      caption         =   "siguiente"
      height          =   375
      left            =   3000
      mouseicon       =   "frmguildfoundation.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   6
      top             =   3360
      width           =   975
   end
   begin vb.frame frame2 
      caption         =   "web site del clan"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   855
      left            =   120
      tabindex        =   4
      top             =   2400
      width           =   3855
      begin vb.textbox text2 
         height          =   285
         left            =   120
         tabindex        =   5
         top             =   360
         width           =   3495
      end
   end
   begin vb.frame frame1 
      caption         =   "informaci�n b�sica"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2175
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   3855
      begin vb.textbox txtclanname 
         height          =   285
         left            =   240
         tabindex        =   2
         top             =   1680
         width           =   3375
      end
      begin vb.label label2 
         caption         =   $"frmguildfoundation.frx":02a4
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   -1  'true
            strikethrough   =   0   'false
         endproperty
         height          =   975
         left            =   240
         tabindex        =   3
         top             =   600
         width           =   3495
      end
      begin vb.label label1 
         caption         =   "nombre del clan:"
         height          =   255
         left            =   240
         tabindex        =   1
         top             =   360
         width           =   1455
      end
   end
end
attribute vb_name = "frmguildfoundation"
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

private sub command1_click()
clanname = txtclanname
site = text2
unload me
frmguilddetails.show , me
end sub

private sub command2_click()
unload me
end sub

private sub form_deactivate()
me.setfocus
end sub

private sub form_load()

if len(txtclanname.text) <= 30 then
    if not asciivalidos(txtclanname) then
        msgbox "nombre invalido."
        exit sub
    end if
else
        msgbox "nombre demasiado extenso."
        exit sub
end if



end sub
