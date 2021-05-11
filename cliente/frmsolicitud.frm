version 5.00
begin vb.form frmguildsol 
   borderstyle     =   1  'fixed single
   caption         =   "ingreso"
   clientheight    =   3495
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
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
   scaleheight     =   3495
   scalewidth      =   4680
   startupposition =   1  'centerowner
   begin vb.commandbutton command2 
      cancel          =   -1  'true
      caption         =   "cancelar"
      height          =   495
      left            =   240
      mouseicon       =   "frmsolicitud.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   2880
      width           =   855
   end
   begin vb.commandbutton command1 
      caption         =   "enviar"
      height          =   495
      left            =   3360
      mouseicon       =   "frmsolicitud.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2880
      width           =   975
   end
   begin vb.textbox text1 
      height          =   1215
      left            =   240
      maxlength       =   400
      multiline       =   -1  'true
      tabindex        =   1
      top             =   1440
      width           =   4095
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   $"frmsolicitud.frx":02a4
      height          =   1215
      left            =   240
      tabindex        =   0
      top             =   120
      width           =   3975
   end
end
attribute vb_name = "frmguildsol"
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

dim cname as string

private sub command1_click()
dim f$

f$ = "solicitud" & cname
f$ = f$ & "," & replace(replace(text1.text, ",", ";"), vbcrlf, "�")

call senddata(f$)

unload me

end sub

private sub command2_click()
unload me
end sub

public sub recievesolicitud(byval guildname as string)

cname = guildname

end sub

