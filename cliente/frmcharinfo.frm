version 5.00
begin vb.form frmcharinfo 
   borderstyle     =   1  'fixed single
   caption         =   "info"
   clientheight    =   6195
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   5325
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
   scalewidth      =   5325
   startupposition =   1  'centerowner
   begin vb.commandbutton desc 
      caption         =   "peticion"
      height          =   495
      left            =   2100
      mouseicon       =   "frmcharinfo.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   24
      top             =   5640
      width           =   855
   end
   begin vb.commandbutton echar 
      caption         =   "echar"
      height          =   495
      left            =   1080
      mouseicon       =   "frmcharinfo.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   23
      top             =   5640
      width           =   855
   end
   begin vb.commandbutton aceptar 
      caption         =   "aceptar"
      height          =   495
      left            =   4200
      mouseicon       =   "frmcharinfo.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   22
      top             =   5640
      width           =   975
   end
   begin vb.commandbutton rechazar 
      caption         =   "rechazar"
      height          =   495
      left            =   3120
      mouseicon       =   "frmcharinfo.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   21
      top             =   5640
      width           =   855
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "cerrar"
      height          =   495
      left            =   120
      mouseicon       =   "frmcharinfo.frx":0548
      mousepointer    =   99  'custom
      tabindex        =   20
      top             =   5640
      width           =   855
   end
   begin vb.frame rep 
      caption         =   "reputacion"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1095
      left            =   120
      tabindex        =   16
      top             =   4440
      width           =   5055
      begin vb.label reputacion 
         caption         =   "reputacion:"
         height          =   255
         left            =   120
         tabindex        =   19
         top             =   720
         width           =   4695
      end
      begin vb.label criminales 
         caption         =   "criminales asesinados:"
         height          =   255
         left            =   120
         tabindex        =   18
         top             =   480
         width           =   4695
      end
      begin vb.label ciudadanos 
         caption         =   "ciudadanos asesinados:"
         height          =   255
         left            =   120
         tabindex        =   17
         top             =   240
         width           =   4695
      end
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
      height          =   1815
      left            =   120
      tabindex        =   9
      top             =   2640
      width           =   5055
      begin vb.label faccion 
         caption         =   "faccion:"
         height          =   255
         left            =   120
         tabindex        =   15
         top             =   1440
         width           =   4695
      end
      begin vb.label integro 
         caption         =   "clanes que integro:"
         height          =   255
         left            =   120
         tabindex        =   14
         top             =   1200
         width           =   4695
      end
      begin vb.label lider 
         caption         =   "veces fue lider de clan:"
         height          =   255
         left            =   120
         tabindex        =   13
         top             =   960
         width           =   4695
      end
      begin vb.label fundo 
         caption         =   "fundo el clan:"
         height          =   255
         left            =   120
         tabindex        =   12
         top             =   720
         width           =   4695
      end
      begin vb.label solicitudesrechazadas 
         caption         =   "solicitudes rechazadas:"
         height          =   255
         left            =   120
         tabindex        =   11
         top             =   480
         width           =   4695
      end
      begin vb.label solicitudes 
         caption         =   "solicitudes para ingresar a clanes:"
         height          =   255
         left            =   120
         tabindex        =   10
         top             =   240
         width           =   4695
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
      height          =   2415
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   5055
      begin vb.label status 
         caption         =   "status:"
         height          =   255
         left            =   120
         tabindex        =   8
         top             =   2040
         width           =   4695
      end
      begin vb.label banco 
         caption         =   "banco:"
         height          =   255
         left            =   120
         tabindex        =   7
         top             =   1800
         width           =   4695
      end
      begin vb.label oro 
         caption         =   "oro:"
         height          =   255
         left            =   120
         tabindex        =   6
         top             =   1560
         width           =   4695
      end
      begin vb.label genero 
         caption         =   "genero:"
         height          =   255
         left            =   120
         tabindex        =   5
         top             =   1080
         width           =   4695
      end
      begin vb.label raza 
         caption         =   "raza:"
         height          =   255
         left            =   120
         tabindex        =   4
         top             =   600
         width           =   4695
      end
      begin vb.label clase 
         caption         =   "clase:"
         height          =   255
         left            =   120
         tabindex        =   3
         top             =   840
         width           =   4695
      end
      begin vb.label nivel 
         caption         =   "nivel:"
         height          =   255
         left            =   120
         tabindex        =   2
         top             =   1320
         width           =   4695
      end
      begin vb.label nombre 
         caption         =   "nombre:"
         height          =   255
         left            =   120
         tabindex        =   1
         top             =   360
         width           =   4695
      end
   end
end
attribute vb_name = "frmcharinfo"
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



public frmmiembros as boolean
public frmsolicitudes as boolean

private sub aceptar_click()
frmmiembros = false
frmsolicitudes = false
call senddata("aceptari" & right(nombre, len(nombre) - 7))
unload frmguildleader
call senddata("glinfo")
unload me
end sub

private sub command1_click()
unload me
end sub


public sub parsecharinfo(byval rdata as string)

if frmmiembros then
    rechazar.visible = false
    aceptar.visible = false
    echar.visible = true
    desc.visible = false
else
    rechazar.visible = true
    aceptar.visible = true
    echar.visible = false
    desc.visible = true
end if


'h$ = "chrinfo" & username & ","
'h$ = h$ & miuser.raza & ","
'h$ = h$ & miuser.clase & ","
'h$ = h$ & miuser.genero & ","
'h$ = h$ & miuser.stats.elv & ","
'h$ = h$ & miuser.stats.gld & ","
'h$ = h$ & miuser.stats.banco & ","
'h$ = h$ & miuser.reputacion.promedio & ","


nombre.caption = "nombre:" & readfield(1, rdata, 44)
raza.caption = "raza:" & readfield(2, rdata, 44)
clase.caption = "clase:" & readfield(3, rdata, 44)
genero.caption = "genero:" & readfield(4, rdata, 44)
nivel.caption = "nivel:" & readfield(5, rdata, 44)
oro.caption = "oro:" & readfield(6, rdata, 44)
banco.caption = "banco:" & readfield(7, rdata, 44)

dim y as long, k as long

y = val(readfield(8, rdata, 44))

if y > 0 then
    status.caption = "status: ciudadano"
else
    status.caption = "status: criminal"
end if


'h$ = h$ & miuser.guildinfo.fundoclan & ","9
'h$ = h$ & miuser.guildinfo.esguildleader & ","10
'h$ = h$ & miuser.guildinfo.echadas & ","11
'h$ = h$ & miuser.guildinfo.solicitudes & ","12
'h$ = h$ & miuser.guildinfo.solicitudesrechazadas & ","13
'h$ = h$ & miuser.guildinfo.vecesfueguildleader & ","14
'h$ = h$ & miuser.guildinfo.clanesparticipo & ","15

'h$ = h$ & miuser.guildinfo.clanfundado & ","16
'h$ = h$ & miuser.guildinfo.guildname & ","17



y = val(readfield(9, rdata, 44))

solicitudes.caption = "solicitudes para ingresar a clanes:" & readfield(12, rdata, 44)
solicitudesrechazadas.caption = "solicitudes rechazadas:" & readfield(13, rdata, 44)


if y = 1 then
    fundo.caption = "fundo el clan: " & readfield(16, rdata, 44)
else
    fundo.caption = "fundo el clan: ninguno"
end if


lider.caption = "veces fue lider de clan:" & readfield(14, rdata, 44)
integro.caption = "clanes que integro:" & readfield(15, rdata, 44)

'h$ = h$ & miuser.faccion.armadareal & "," 18
'h$ = h$ & miuser.faccion.fuerzascaos & "," 19
'h$ = h$ & miuser.faccion.ciudadanosmatados & "," 20
'h$ = h$ & miuser.faccion.criminalesmatados 21

y = val(readfield(18, rdata, 44))

if y = 1 then
    faccion.caption = "faccion: ejercito real"
else
    k = val(readfield(19, rdata, 44))
    if k = 1 then
        faccion.caption = "faccion: fuerzas del caos"
    else
        faccion.caption = "faccion: ninguna"
    end if
end if

ciudadanos.caption = "ciudadanos asesinados:" & readfield(20, rdata, 44)
criminales.caption = "criminales asesinados:" & readfield(21, rdata, 44)
reputacion.caption = "reputacion:" & val(readfield(8, rdata, 44))
me.show vbmodeless, frmmain


end sub

private sub desc_click()
call senddata("envcomen" & right(nombre, len(nombre) - 7))
end sub

private sub echar_click()
call senddata("echarcla" & right(nombre, len(nombre) - 7))
frmmiembros = false
frmsolicitudes = false
unload frmguildleader
call senddata("glinfo")
unload me
end sub

private sub rechazar_click()
call senddata("rechazar" & right(nombre, len(nombre) - 7))
frmmiembros = false
frmsolicitudes = false
unload frmguildleader
call senddata("glinfo")
unload me
end sub
