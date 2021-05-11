version 5.00
begin vb.form frmservidor 
   backcolor       =   &h00c0c0c0&
   caption         =   "servidor"
   clientheight    =   5520
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   4575
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   5520
   scalewidth      =   4575
   startupposition =   3  'windows default
   begin vb.commandbutton command17 
      caption         =   "actualizar npcs.dat"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   16
      top             =   3600
      width           =   4095
   end
   begin vb.commandbutton command16 
      caption         =   "reload server.ini"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   15
      top             =   3360
      width           =   4095
   end
   begin vb.commandbutton command14 
      caption         =   "update motd"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   14
      top             =   3120
      width           =   4095
   end
   begin vb.commandbutton command19 
      caption         =   "unban all ips"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   18
      top             =   2880
      width           =   4095
   end
   begin vb.commandbutton command5 
      caption         =   "cargar backup del mundo"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   1
      top             =   4740
      width           =   4095
   end
   begin vb.commandbutton command18 
      caption         =   "guardar todos los personajes"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   17
      top             =   4500
      width           =   4095
   end
   begin vb.commandbutton command15 
      caption         =   "unban all"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   13
      top             =   2640
      width           =   4095
   end
   begin vb.commandbutton command13 
      caption         =   "debug listening socket"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   12
      top             =   2400
      width           =   4095
   end
   begin vb.commandbutton command12 
      caption         =   "debug npcs"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   11
      top             =   2160
      width           =   4095
   end
   begin vb.commandbutton command11 
      caption         =   "stats de los slots"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   8
      top             =   1920
      width           =   4095
   end
   begin vb.commandbutton command10 
      caption         =   "trafico"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   7
      top             =   1680
      width           =   4095
   end
   begin vb.commandbutton command9 
      caption         =   "reload lista nombres prohibidos"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   6
      top             =   1440
      width           =   4095
   end
   begin vb.commandbutton command8 
      caption         =   "actualizar hechizos"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   5
      top             =   1200
      width           =   4095
   end
   begin vb.commandbutton command7 
      caption         =   "configurar intervalos"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   4
      top             =   960
      width           =   4095
   end
   begin vb.commandbutton command3 
      caption         =   "reiniciar"
      enabled         =   0   'false
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   10
      top             =   720
      width           =   4095
   end
   begin vb.commandbutton command6 
      caption         =   "respawn guardias en posiciones originales"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   9
      top             =   480
      width           =   4095
   end
   begin vb.commandbutton command1 
      caption         =   "actualizar objetos.dat"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   3
      top             =   240
      width           =   4095
   end
   begin vb.commandbutton command4 
      caption         =   "hacer un backup del mundo"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   2
      top             =   4260
      width           =   4095
   end
   begin vb.commandbutton command2 
      caption         =   "ok"
      default         =   -1  'true
      height          =   255
      left            =   3480
      tabindex        =   0
      top             =   5220
      width           =   945
   end
   begin vb.commandbutton command20 
      caption         =   "reiniciar sockets"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   240
      tabindex        =   19
      top             =   5220
      width           =   3135
   end
   begin vb.shape shape3 
      height          =   3855
      left            =   120
      top             =   120
      width           =   4335
   end
   begin vb.shape shape2 
      height          =   975
      left            =   120
      top             =   4140
      width           =   4335
   end
end
attribute vb_name = "frmservidor"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.2
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

private sub command1_click()
call loadobjdata_nuevo

end sub

private sub command10_click()
frmtrafic.show
end sub

private sub command11_click()
frmconid.show
end sub

private sub command12_click()
frmdebugnpc.show
end sub

private sub command13_click()
frmdebugsocket.visible = true
end sub

private sub command14_click()
call loadmotd
end sub

private sub command15_click()
on error resume next

dim fn as string
dim cad$
dim n as integer, k as integer

fn = app.path & "\logs\gentebanned.log"

if fileexist(fn, vbnormal) then
    n = freefile
    open fn for input shared as #n
    do while not eof(n)
        k = k + 1
        input #n, cad$
        call unban(cad$)
        
    loop
    close #n
    msgbox "se han habilitado " & k & " personajes."
    kill fn
end if




end sub

private sub command16_click()
call loadsini
end sub

private sub command17_click()
call descarganpcsdat
call carganpcsdat

end sub

private sub command18_click()
me.mousepointer = 11
call guardarusuarios
me.mousepointer = 0
msgbox "grabado de personajes ok!"
end sub

private sub command19_click()
dim i as long, n as long

n = banips.count
for i = 1 to banips.count
    banips.remove 1
next i

msgbox "se han habilitado " & n & " ipes"

end sub

private sub command2_click()
frmservidor.visible = false
end sub

private sub command20_click()
#if usarapi then
dim i as long

if msgbox("esta seguro que desea reiniciar los sockets ? se cerrar�n todas las conexiones activas.", vbyesno, "reiniciar sockets") = vbyes then
    'cierra el socket de escucha
    if socklisten >= 0 then call apiclosesocket(socklisten)
    
    'cierra todas las conexiones
    for i = 1 to maxusers
        if userlist(i).connid <> -1 then
            call closesocket(i)
        end if
    next i
    
    'inicia el socket de escucha
    socklisten = listenforconnect(puerto, hwndmsg, "")
    
    'comprueba si el proc de la ventana es el correcto
    dim tmpwproc as long
    tmpwproc = getwindowlong(hwndmsg, gwl_wndproc)
    if tmpwproc <> actualwproc then
        msgbox "incorrecto proc de ventana (" & tmpwproc & " <> " & actualwproc & ")"
        call logapisock("incorrecto proc de ventana")
        oldwproc = tmpwproc
        if oldwproc <> 0 then
            setwindowlong frmmain.hwnd, gwl_wndproc, addressof wndproc
            actualwproc = getwindowlong(frmmain.hwnd, gwl_wndproc)
        end if
    end if
end if
#end if
end sub

private sub command3_click()
if msgbox("��atencion!! si reinicia el servidor puede provocar la perdida de datos de los usarios. �desea reiniciar el servidor de todas maneras?", vbyesno) = vbyes then
    me.visible = false
    call restart
end if
end sub

private sub command4_click()
on error goto eh
    me.mousepointer = 11
    frmstat.show
    call dobackup
    me.mousepointer = 0
    msgbox "worldsave ok!!"
exit sub
eh:
call logerror("error en worldsave")
end sub

private sub command5_click()

'se asegura de que los sockets estan cerrados e ignora cualquier err
on error resume next

if frmmain.visible then frmmain.txstatus.caption = "reiniciando."

frmstat.show

if fileexist(app.path & "\logs\errores.log", vbnormal) then kill app.path & "\logs\errores.log"
if fileexist(app.path & "\logs\connect.log", vbnormal) then kill app.path & "\logs\connect.log"
if fileexist(app.path & "\logs\hackattemps.log", vbnormal) then kill app.path & "\logs\hackattemps.log"
if fileexist(app.path & "\logs\asesinatos.log", vbnormal) then kill app.path & "\logs\asesinatos.log"
if fileexist(app.path & "\logs\resurrecciones.log", vbnormal) then kill app.path & "\logs\resurrecciones.log"
if fileexist(app.path & "\logs\teleports.log", vbnormal) then kill app.path & "\logs\teleports.log"


#if usarapi then
call apiclosesocket(socklisten)
#else
frmmain.socket1.cleanup
frmmain.socket2(0).cleanup
#end if

dim loopc as integer

for loopc = 1 to maxusers
    call closesocket(loopc)
next
  

lastuser = 0
numusers = 0

redim npclist(1 to maxnpcs) as npc 'npcs
redim charlist(1 to maxchars) as integer

call loadsini
call cargarbackup
call loadobjdata

#if usarapi then
socklisten = listenforconnect(puerto, frmmain.hwnd, "")

#else
frmmain.socket1.addressfamily = af_inet
frmmain.socket1.protocol = ipproto_ip
frmmain.socket1.sockettype = sock_stream
frmmain.socket1.binary = false
frmmain.socket1.blocking = false
frmmain.socket1.buffersize = 1024

frmmain.socket2(0).addressfamily = af_inet
frmmain.socket2(0).protocol = ipproto_ip
frmmain.socket2(0).sockettype = sock_stream
frmmain.socket2(0).blocking = false
frmmain.socket2(0).buffersize = 2048

'escucha
frmmain.socket1.localport = puerto
frmmain.socket1.listen
#end if

if frmmain.visible then frmmain.txstatus.caption = "escuchando conexiones entrantes ..."

end sub

private sub command6_click()
call respawnorigposnpcs
end sub

private sub command7_click()
frminterv.show
end sub

private sub command8_click()
call cargarhechizos
end sub

private sub command9_click()
call cargarforbidenwords
end sub

private sub form_deactivate()
frmservidor.visible = false
end sub

