version 5.00
begin vb.form frmcambiamotd 
   borderstyle     =   1  'fixed single
   caption         =   "cambiar motd"
   clientheight    =   3780
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3780
   scalewidth      =   4680
   startupposition =   3  'windows default
   begin vb.commandbutton command1 
      caption         =   "cancelar"
      height          =   375
      left            =   2580
      tabindex        =   3
      top             =   3300
      width           =   1455
   end
   begin vb.commandbutton cmdok 
      caption         =   "aceptar"
      height          =   375
      left            =   660
      tabindex        =   2
      top             =   3300
      width           =   1455
   end
   begin vb.textbox txtmotd 
      height          =   2415
      left            =   120
      multiline       =   -1  'true
      scrollbars      =   3  'both
      tabindex        =   0
      top             =   660
      width           =   4455
   end
   begin vb.label label1 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "no te olvides de poner los codigos de colores al final de cada linea!"
      beginproperty font 
         name            =   "arial"
         size            =   9.75
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   495
      left            =   120
      tabindex        =   1
      top             =   60
      width           =   4455
   end
end
attribute vb_name = "frmcambiamotd"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
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

option explicit

private sub cmdok_click()
dim t() as string
dim i as long, n as long, pos as long

if len(txtmotd.text) >= 2 then
    if right(txtmotd.text, 2) = vbcrlf then txtmotd.text = left(txtmotd.text, len(txtmotd.text) - 2)
end if

t = split(txtmotd.text, vbcrlf)

'hola~1~1~1~1~1

for i = lbound(t) to ubound(t)
    n = 0
    pos = instr(1, t(i), "~")
    do while pos > 0 and pos < len(t(i))
        n = n + 1
        pos = instr(pos + 1, t(i), "~")
    loop
    if n <> 5 then
        msgbox "error en el formato de la linea " & i + 1 & "."
        exit sub
    end if
next i

call senddata("zmotd" & txtmotd.text)
unload me
end sub

private sub command1_click()
unload me

end sub
