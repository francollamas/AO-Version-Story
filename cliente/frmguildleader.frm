version 5.00
begin vb.form frmguildleader 
   borderstyle     =   1  'fixed single
   caption         =   "administraci�n del clan"
   clientheight    =   6555
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   5880
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
   scaleheight     =   6555
   scalewidth      =   5880
   startupposition =   2  'centerscreen
   begin vb.commandbutton command8 
      cancel          =   -1  'true
      caption         =   "cerrar"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   15
      top             =   5880
      width           =   2775
   end
   begin vb.commandbutton command7 
      caption         =   "propuestas de paz"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   14
      top             =   5280
      width           =   2775
   end
   begin vb.commandbutton command6 
      caption         =   "editar url de la web del clan"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   13
      top             =   4680
      width           =   2775
   end
   begin vb.commandbutton command5 
      caption         =   "editar codex o descripcion"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   12
      top             =   4080
      width           =   2775
   end
   begin vb.frame frame3 
      caption         =   "clanes"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2295
      left            =   0
      tabindex        =   9
      top             =   0
      width           =   2895
      begin vb.listbox guildslist 
         height          =   1425
         itemdata        =   "frmguildleader.frx":0548
         left            =   120
         list            =   "frmguildleader.frx":054a
         tabindex        =   11
         top             =   240
         width           =   2655
      end
      begin vb.commandbutton command4 
         caption         =   "detalles"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":054c
         mousepointer    =   99  'custom
         tabindex        =   10
         top             =   1800
         width           =   2655
      end
   end
   begin vb.frame txtnews 
      caption         =   "guildnews"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1575
      left            =   0
      tabindex        =   6
      top             =   2280
      width           =   5775
      begin vb.commandbutton command3 
         caption         =   "actualizar"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":069e
         mousepointer    =   99  'custom
         tabindex        =   8
         top             =   1080
         width           =   5535
      end
      begin vb.textbox txtguildnews 
         height          =   735
         left            =   120
         multiline       =   -1  'true
         tabindex        =   7
         top             =   240
         width           =   5535
      end
   end
   begin vb.frame frame2 
      caption         =   "miembros"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2295
      left            =   2880
      tabindex        =   3
      top             =   0
      width           =   2895
      begin vb.commandbutton command2 
         caption         =   "detalles"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":07f0
         mousepointer    =   99  'custom
         tabindex        =   5
         top             =   1800
         width           =   2655
      end
      begin vb.listbox members 
         height          =   1425
         itemdata        =   "frmguildleader.frx":0942
         left            =   120
         list            =   "frmguildleader.frx":0944
         tabindex        =   4
         top             =   240
         width           =   2655
      end
   end
   begin vb.frame frame1 
      caption         =   "solicitudes de ingreso"
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
      left            =   0
      tabindex        =   0
      top             =   3960
      width           =   2895
      begin vb.commandbutton command1 
         caption         =   "detalles"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":0946
         mousepointer    =   99  'custom
         tabindex        =   2
         top             =   1560
         width           =   2655
      end
      begin vb.listbox solicitudes 
         height          =   1230
         itemdata        =   "frmguildleader.frx":0a98
         left            =   120
         list            =   "frmguildleader.frx":0a9a
         tabindex        =   1
         top             =   240
         width           =   2655
      end
      begin vb.label miembros 
         caption         =   "el clan cuenta con x miembros"
         height          =   255
         left            =   120
         tabindex        =   16
         top             =   2040
         width           =   2535
      end
   end
end
attribute vb_name = "frmguildleader"
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

private sub command1_click()

frmcharinfo.frmsolicitudes = true
call senddata("1hrinfo<" & solicitudes.list(solicitudes.listindex))

'unload me

end sub

private sub command2_click()

frmcharinfo.frmmiembros = true
call senddata("1hrinfo<" & members.list(members.listindex))

'unload me

end sub

private sub command3_click()

dim k$

k$ = replace(txtguildnews, vbcrlf, "�")

call senddata("actgnews" & k$)

end sub

private sub command4_click()

frmguildbrief.esleader = true
call senddata("clandetails" & guildslist.list(guildslist.listindex))

'unload me

end sub

private sub command5_click()

call frmguilddetails.show(vbmodal, frmguildleader)

'unload me

end sub

private sub command6_click()
call frmguildurl.show(vbmodeless, frmguildleader)
'unload me
end sub

private sub command7_click()
call senddata("envpropp")
end sub

private sub command8_click()
unload me
frmmain.setfocus
end sub


public sub parseleaderinfo(byval data as string)

if me.visible then exit sub

dim r%, t%

r% = val(readfield(1, data, asc("�")))

for t% = 1 to r%
    guildslist.additem readfield(1 + t%, data, asc("�"))
next t%

r% = val(readfield(t% + 1, data, asc("�")))
miembros.caption = "el clan cuenta con " & r% & " miembros."

dim k%

for k% = 1 to r%
    members.additem readfield(t% + 1 + k%, data, asc("�"))
next k%

txtguildnews = replace(readfield(t% + k% + 1, data, asc("�")), "�", vbcrlf)

t% = t% + k% + 2

r% = val(readfield(t%, data, asc("�")))

for k% = 1 to r%
    solicitudes.additem readfield(t% + k%, data, asc("�"))
next k%

me.show vbmodeless, frmmain

end sub

private sub form_deactivate()
'me.setfocus
end sub

