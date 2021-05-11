version 5.00
begin vb.form frmcharinfo 
   borderstyle     =   1  'fixed single
   caption         =   "informaci�n del personaje"
   clientheight    =   6195
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   6390
   clipcontrols    =   0   'false
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
   scaleheight     =   6195
   scalewidth      =   6390
   startupposition =   1  'centerowner
   begin vb.commandbutton desc 
      caption         =   "peticion"
      height          =   495
      left            =   2655
      mouseicon       =   "frmcharinfo.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   14
      top             =   5625
      width           =   1000
   end
   begin vb.commandbutton echar 
      caption         =   "echar"
      height          =   495
      left            =   1395
      mouseicon       =   "frmcharinfo.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   13
      top             =   5625
      width           =   1000
   end
   begin vb.commandbutton aceptar 
      caption         =   "aceptar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   495
      left            =   5085
      mouseicon       =   "frmcharinfo.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   12
      top             =   5625
      width           =   1000
   end
   begin vb.commandbutton rechazar 
      caption         =   "rechazar"
      height          =   495
      left            =   3870
      mouseicon       =   "frmcharinfo.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   11
      top             =   5625
      width           =   1000
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "cerrar"
      height          =   495
      left            =   120
      mouseicon       =   "frmcharinfo.frx":0548
      mousepointer    =   99  'custom
      tabindex        =   10
      top             =   5625
      width           =   1000
   end
   begin vb.frame frame1 
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
      height          =   3120
      left            =   135
      tabindex        =   9
      top             =   2355
      width           =   6075
      begin vb.textbox txtmiembro 
         height          =   1110
         left            =   135
         multiline       =   -1  'true
         scrollbars      =   2  'vertical
         tabindex        =   22
         top             =   1800
         width           =   5790
      end
      begin vb.textbox txtpeticiones 
         height          =   1110
         left            =   135
         multiline       =   -1  'true
         scrollbars      =   2  'vertical
         tabindex        =   15
         top             =   450
         width           =   5790
      end
      begin vb.label lblmiembro 
         caption         =   "ultimos clanes en los que particip�:"
         height          =   255
         left            =   135
         tabindex        =   23
         top             =   1620
         width           =   2985
      end
      begin vb.label lblsolicitado 
         caption         =   "ultimas membres�as solicitadas:"
         height          =   255
         left            =   135
         tabindex        =   21
         top             =   270
         width           =   2985
      end
   end
   begin vb.frame charinfo 
      caption         =   "general"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2100
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   6075
      begin vb.label reputacion 
         caption         =   "reputacion:"
         height          =   255
         left            =   3060
         tabindex        =   20
         top             =   1560
         width           =   2445
      end
      begin vb.label criminales 
         caption         =   "criminales asesinados:"
         height          =   255
         left            =   3060
         tabindex        =   19
         top             =   1325
         width           =   2900
      end
      begin vb.label ciudadanos 
         caption         =   "ciudadanos asesinados:"
         height          =   255
         left            =   3060
         tabindex        =   18
         top             =   1080
         width           =   2850
      end
      begin vb.label ejercito 
         caption         =   "faccion:"
         height          =   255
         left            =   3060
         tabindex        =   17
         top             =   844
         width           =   2880
      end
      begin vb.label guildactual 
         caption         =   "clan actual:"
         height          =   255
         left            =   3030
         tabindex        =   16
         top             =   600
         width           =   2880
      end
      begin vb.label status 
         caption         =   "status:"
         height          =   255
         left            =   3060
         tabindex        =   8
         top             =   1800
         width           =   2760
      end
      begin vb.label banco 
         caption         =   "banco:"
         height          =   255
         left            =   120
         tabindex        =   7
         top             =   1800
         width           =   2985
      end
      begin vb.label oro 
         caption         =   "oro:"
         height          =   255
         left            =   120
         tabindex        =   6
         top             =   1560
         width           =   2805
      end
      begin vb.label genero 
         caption         =   "genero:"
         height          =   255
         left            =   120
         tabindex        =   5
         top             =   1080
         width           =   2895
      end
      begin vb.label raza 
         caption         =   "raza:"
         height          =   255
         left            =   120
         tabindex        =   4
         top             =   600
         width           =   2880
      end
      begin vb.label clase 
         caption         =   "clase:"
         height          =   255
         left            =   120
         tabindex        =   3
         top             =   840
         width           =   3270
      end
      begin vb.label nivel 
         caption         =   "nivel:"
         height          =   255
         left            =   120
         tabindex        =   2
         top             =   1320
         width           =   3105
      end
      begin vb.label nombre 
         caption         =   "nombre:"
         height          =   255
         left            =   135
         tabindex        =   1
         top             =   360
         width           =   5640
      end
   end
end
attribute vb_name = "frmcharinfo"
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

public enum charinfofrmtype
    frmmembers
    frmmembershiprequests
end enum

public frmtype as charinfofrmtype

private sub aceptar_click()
    call writeguildacceptnewmember(trim$(right$(nombre, len(nombre) - 8)))
    unload frmguildleader
    call writerequestguildleaderinfo
    unload me
end sub

private sub command1_click()
    unload me
end sub

private sub desc_click()
    call writeguildrequestjoinerinfo(right$(nombre, len(nombre) - 8))
end sub

private sub echar_click()
    call writeguildkickmember(right$(nombre, len(nombre) - 8))
    unload frmguildleader
    call writerequestguildleaderinfo
    unload me
end sub

private sub rechazar_click()
    load frmcommet
    frmcommet.t = rechazopj
    frmcommet.nombre = right$(nombre, len(nombre) - 8)
    frmcommet.caption = "ingrese motivo para rechazo"
    frmcommet.show vbmodeless, frmcharinfo
end sub
