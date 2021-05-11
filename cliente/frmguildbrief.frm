version 5.00
begin vb.form frmguildbrief 
   borderstyle     =   1  'fixed single
   caption         =   "detalles del clan"
   clientheight    =   7260
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   7530
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
   scaleheight     =   7260
   scalewidth      =   7530
   startupposition =   1  'centerowner
   begin vb.commandbutton command3 
      caption         =   "ofrecer paz"
      height          =   375
      left            =   1680
      mouseicon       =   "frmguildbrief.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   26
      top             =   6840
      width           =   1335
   end
   begin vb.commandbutton aliado 
      caption         =   "ofrecer alianza"
      height          =   375
      left            =   3120
      mouseicon       =   "frmguildbrief.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   25
      top             =   6840
      width           =   1335
   end
   begin vb.commandbutton guerra 
      caption         =   "declarar guerra"
      height          =   375
      left            =   4560
      mouseicon       =   "frmguildbrief.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   24
      top             =   6840
      width           =   1335
   end
   begin vb.commandbutton command2 
      caption         =   "solicitar ingreso"
      height          =   375
      left            =   6000
      mouseicon       =   "frmguildbrief.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   20
      top             =   6840
      width           =   1335
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "cerrar"
      height          =   375
      left            =   120
      mouseicon       =   "frmguildbrief.frx":0548
      mousepointer    =   99  'custom
      tabindex        =   19
      top             =   6840
      width           =   1455
   end
   begin vb.frame frame3 
      caption         =   "descripci�n"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1335
      left            =   120
      tabindex        =   18
      top             =   5400
      width           =   7215
      begin vb.textbox desc 
         height          =   975
         left            =   120
         locked          =   -1  'true
         multiline       =   -1  'true
         tabindex        =   23
         top             =   240
         width           =   6975
      end
   end
   begin vb.frame frame2 
      caption         =   "codex"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2415
      left            =   120
      tabindex        =   9
      top             =   2970
      width           =   7215
      begin vb.label codex 
         height          =   255
         index           =   7
         left            =   240
         tabindex        =   17
         top             =   2040
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   6
         left            =   240
         tabindex        =   16
         top             =   1800
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   5
         left            =   240
         tabindex        =   15
         top             =   1560
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   4
         left            =   240
         tabindex        =   14
         top             =   1320
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   3
         left            =   240
         tabindex        =   13
         top             =   1080
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   2
         left            =   240
         tabindex        =   12
         top             =   840
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   1
         left            =   210
         tabindex        =   11
         top             =   600
         width           =   6735
      end
      begin vb.label codex 
         height          =   255
         index           =   0
         left            =   240
         tabindex        =   10
         top             =   360
         width           =   6735
      end
   end
   begin vb.frame frame1 
      caption         =   "info del clan"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2940
      left            =   120
      tabindex        =   0
      top             =   -15
      width           =   7215
      begin vb.label antifaccion 
         caption         =   "puntos antifaccion:"
         height          =   255
         left            =   120
         tabindex        =   27
         top             =   2640
         width           =   6975
      end
      begin vb.label aliados 
         caption         =   "clanes aliados:"
         height          =   255
         left            =   120
         tabindex        =   22
         top             =   2400
         width           =   6975
      end
      begin vb.label enemigos 
         caption         =   "clanes enemigos:"
         height          =   255
         left            =   120
         tabindex        =   21
         top             =   2160
         width           =   6975
      end
      begin vb.label lblalineacion 
         caption         =   "alineacion:"
         height          =   255
         left            =   120
         tabindex        =   8
         top             =   1920
         width           =   6975
      end
      begin vb.label eleccion 
         caption         =   "elecciones:"
         height          =   255
         left            =   120
         tabindex        =   7
         top             =   1680
         width           =   6975
      end
      begin vb.label miembros 
         caption         =   "miembros:"
         height          =   255
         left            =   120
         tabindex        =   6
         top             =   1440
         width           =   6975
      end
      begin vb.label web 
         caption         =   "web site:"
         height          =   255
         left            =   120
         tabindex        =   5
         top             =   1200
         width           =   6975
      end
      begin vb.label lider 
         caption         =   "lider:"
         height          =   255
         left            =   120
         tabindex        =   4
         top             =   960
         width           =   6975
      end
      begin vb.label creacion 
         caption         =   "fecha de creacion:"
         height          =   255
         left            =   120
         tabindex        =   3
         top             =   720
         width           =   6975
      end
      begin vb.label fundador 
         caption         =   "fundador:"
         height          =   255
         left            =   120
         tabindex        =   2
         top             =   480
         width           =   6975
      end
      begin vb.label nombre 
         caption         =   "nombre:"
         height          =   255
         left            =   120
         tabindex        =   1
         top             =   240
         width           =   6975
      end
   end
end
attribute vb_name = "frmguildbrief"
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

public esleader as boolean


public sub parseguildinfo(byval buffer as string)

if not esleader then
    guerra.visible = false
    aliado.visible = false
    command3.visible = false
else
    guerra.visible = true
    aliado.visible = true
    command3.visible = true
end if

nombre.caption = "nombre:" & readfield(1, buffer, asc("�"))
fundador.caption = "fundador:" & readfield(2, buffer, asc("�"))
creacion.caption = "fecha de creacion:" & readfield(3, buffer, asc("�"))
lider.caption = "lider:" & readfield(4, buffer, asc("�"))
web.caption = "web site:" & readfield(5, buffer, asc("�"))
miembros.caption = "miembros:" & readfield(6, buffer, asc("�"))
eleccion.caption = "dias para proxima eleccion de lider:" & readfield(7, buffer, asc("�"))
'oro.caption = "oro:" & readfield(8, buffer, asc("�"))
lblalineacion.caption = "alineaci�n: " & readfield(8, buffer, asc("�"))
enemigos.caption = "clanes enemigos:" & readfield(9, buffer, asc("�"))
aliados.caption = "clanes aliados:" & readfield(10, buffer, asc("�"))
antifaccion.caption = "puntos antifaccion: " & readfield(11, buffer, asc("�"))

dim t as long

for t = 1 to 8
    codex(t - 1).caption = readfield(11 + t, buffer, asc("�"))
next t

dim des as string

des = readfield(20, buffer, asc("�"))
desc.text = replace(des, "�", vbcrlf)

me.show vbmodal, frmmain

end sub

private sub aliado_click()
frmcommet.nombre = right(nombre.caption, len(nombre.caption) - 7)
frmcommet.t = alianza
frmcommet.caption = "ingrese propuesta de alianza"
call frmcommet.show(vbmodal, frmguildbrief)

'call senddata("ofrecali" & right(nombre, len(nombre) - 7))
'unload me
end sub

private sub command1_click()
unload me
end sub

private sub command2_click()

call frmguildsol.recievesolicitud(right$(nombre, len(nombre) - 7))
call frmguildsol.show(vbmodal, frmguildbrief)
'unload me

end sub

private sub command3_click()
frmcommet.nombre = right(nombre.caption, len(nombre.caption) - 7)
frmcommet.t = paz
frmcommet.caption = "ingrese propuesta de paz"
call frmcommet.show(vbmodal, frmguildbrief)
'unload me
end sub


private sub guerra_click()
call senddata("decguerr" & right(nombre.caption, len(nombre.caption) - 7))
unload me
end sub
