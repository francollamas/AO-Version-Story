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
   begin vb.commandbutton command9 
      caption         =   "propuestas de alianzas"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   17
      top             =   5460
      width           =   2775
   end
   begin vb.commandbutton command8 
      cancel          =   -1  'true
      caption         =   "cerrar"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   15
      top             =   5970
      width           =   2775
   end
   begin vb.commandbutton command7 
      caption         =   "propuestas de paz"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   14
      top             =   4950
      width           =   2775
   end
   begin vb.commandbutton command6 
      caption         =   "editar url de la web del clan"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   13
      top             =   4440
      width           =   2775
   end
   begin vb.commandbutton command5 
      caption         =   "editar codex o descripcion"
      height          =   495
      left            =   3000
      mouseicon       =   "frmguildleader.frx":0548
      mousepointer    =   99  'custom
      tabindex        =   12
      top             =   3930
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
         itemdata        =   "frmguildleader.frx":069a
         left            =   120
         list            =   "frmguildleader.frx":069c
         tabindex        =   11
         top             =   240
         width           =   2655
      end
      begin vb.commandbutton command4 
         caption         =   "detalles"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":069e
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
         mouseicon       =   "frmguildleader.frx":07f0
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
         mouseicon       =   "frmguildleader.frx":0942
         mousepointer    =   99  'custom
         tabindex        =   5
         top             =   1800
         width           =   2655
      end
      begin vb.listbox members 
         height          =   1425
         itemdata        =   "frmguildleader.frx":0a94
         left            =   120
         list            =   "frmguildleader.frx":0a96
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
      begin vb.commandbutton cmdelecciones 
         caption         =   "abrir elecciones"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":0a98
         mousepointer    =   99  'custom
         tabindex        =   18
         top             =   1935
         width           =   2655
      end
      begin vb.commandbutton command1 
         caption         =   "detalles"
         height          =   375
         left            =   120
         mouseicon       =   "frmguildleader.frx":0bea
         mousepointer    =   99  'custom
         tabindex        =   2
         top             =   1170
         width           =   2655
      end
      begin vb.listbox solicitudes 
         height          =   840
         itemdata        =   "frmguildleader.frx":0d3c
         left            =   120
         list            =   "frmguildleader.frx":0d3e
         tabindex        =   1
         top             =   240
         width           =   2655
      end
      begin vb.label miembros 
         caption         =   "el clan cuenta con x miembros"
         height          =   255
         left            =   120
         tabindex        =   16
         top             =   1620
         width           =   2535
      end
   end
end
attribute vb_name = "frmguildleader"
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

private sub cmdelecciones_click()
    call writeguildopenelections
    unload me
end sub

private sub command1_click()
    if solicitudes.listindex = -1 then exit sub
    
    frmcharinfo.frmsolicitudes = true
    call writeguildmemberinfo(solicitudes.list(solicitudes.listindex))

    'unload me
end sub

private sub command2_click()
    if members.listindex = -1 then exit sub
    
    frmcharinfo.frmmiembros = true
    call writeguildmemberinfo(members.list(members.listindex))

    'unload me
end sub

private sub command3_click()
    dim k as string

    k = replace(txtguildnews, vbcrlf, "�")
    
    call writeguildupdatenews(k)
end sub

private sub command4_click()
    frmguildbrief.esleader = true
    call writeguildrequestdetails(guildslist.list(guildslist.listindex))

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
    call writeguildpeaceproplist
end sub
private sub command9_click()
    call writeguildallianceproplist
end sub

private sub command8_click()
    unload me
    frmmain.setfocus
end sub
