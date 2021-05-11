version 5.00
begin vb.form frmservidor 
   backcolor       =   &h00c0c0c0&
   caption         =   "servidor"
   clientheight    =   6540
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   4845
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   436
   scalemode       =   3  'pixel
   scalewidth      =   323
   startupposition =   3  'windows default
   begin vb.commandbutton command26 
      caption         =   "reset listen"
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
      left            =   1920
      tabindex        =   26
      top             =   6180
      width           =   1455
   end
   begin vb.picturebox picfuera 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      forecolor       =   &h80000008&
      height          =   4350
      left            =   120
      scaleheight     =   288
      scalemode       =   3  'pixel
      scalewidth      =   304
      tabindex        =   6
      top             =   120
      width           =   4590
      begin vb.vscrollbar vs1 
         height          =   4335
         largechange     =   50
         left            =   4320
         smallchange     =   17
         tabindex        =   24
         top             =   0
         width           =   255
      end
      begin vb.picturebox piccont 
         backcolor       =   &h00c0c0c0&
         borderstyle     =   0  'none
         height          =   4815
         left            =   0
         scaleheight     =   321
         scalemode       =   3  'pixel
         scalewidth      =   289
         tabindex        =   7
         top             =   0
         width           =   4334
         begin vb.commandbutton command27 
            caption         =   "debug userlist"
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
            left            =   120
            tabindex        =   27
            top             =   4440
            width           =   4095
         end
         begin vb.commandbutton command22 
            caption         =   "administraci�n"
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
            left            =   120
            tabindex        =   8
            top             =   4200
            width           =   4095
         end
         begin vb.commandbutton command21 
            caption         =   "pausar el servidor"
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
            left            =   120
            tabindex        =   9
            top             =   3960
            width           =   4095
         end
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
            left            =   120
            tabindex        =   10
            top             =   3720
            width           =   4095
         end
         begin vb.commandbutton command25 
            caption         =   "reload md5s"
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
            left            =   120
            tabindex        =   25
            top             =   3480
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
            left            =   120
            tabindex        =   11
            top             =   3240
            width           =   4095
         end
         begin vb.commandbutton command28 
            caption         =   "reload balance.dat"
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
            left            =   120
            tabindex        =   28
            top             =   3000
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
            left            =   120
            tabindex        =   12
            top             =   2760
            width           =   4095
         end
         begin vb.commandbutton command19 
            caption         =   "unban all ips (peligro!)"
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
            left            =   120
            tabindex        =   13
            top             =   2520
            width           =   4095
         end
         begin vb.commandbutton command15 
            caption         =   "unban all (peligro!)"
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
            left            =   120
            tabindex        =   14
            top             =   2280
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
            left            =   120
            tabindex        =   15
            top             =   2040
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
            left            =   120
            tabindex        =   16
            top             =   1800
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
            left            =   120
            tabindex        =   17
            top             =   1560
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
            left            =   120
            tabindex        =   18
            top             =   1320
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
            left            =   120
            tabindex        =   19
            top             =   1080
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
            left            =   120
            tabindex        =   20
            top             =   840
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
            left            =   120
            tabindex        =   21
            top             =   600
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
            left            =   120
            tabindex        =   22
            top             =   360
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
            left            =   120
            tabindex        =   23
            top             =   120
            width           =   4095
         end
      end
   end
   begin vb.commandbutton command23 
      caption         =   "boton magico para apagar server"
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
      top             =   5520
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
      top             =   5160
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
      tabindex        =   3
      top             =   4920
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
      top             =   4680
      width           =   4095
   end
   begin vb.commandbutton command2 
      caption         =   "ok"
      default         =   -1  'true
      height          =   255
      left            =   3480
      tabindex        =   0
      top             =   6180
      width           =   945
   end
   begin vb.commandbutton command20 
      caption         =   "reset sockets"
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
      top             =   6180
      width           =   1575
   end
   begin vb.shape shape2 
      height          =   1335
      left            =   120
      top             =   4560
      width           =   4335
   end
end
attribute vb_name = "frmservidor"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
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

private sub command1_click()
call loadobjdata

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

private sub command14_click()
call loadmotd
end sub

private sub command15_click()
on error resume next

dim fn as string
dim cad$
dim n as integer, k as integer

dim sentrada as string

sentrada = inputbox("escribe ""estoy de acuerdo"" entre comillas y con distici�n de mayusculas minusculas para desbanear a todos los personajes", "unban", "hola")
if sentrada = "estoy de acuerdo" then

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
end if

end sub

private sub command16_click()
call loadsini
end sub

private sub command17_click()
    call carganpcsdat
end sub

private sub command18_click()
me.mousepointer = 11
call mdparty.actualizaexperiencias
call guardarusuarios
me.mousepointer = 0
msgbox "grabado de personajes ok!"
end sub

private sub command19_click()
dim i as long, n as long

dim sentrada as string

sentrada = inputbox("escribe ""estoy de acuerdo"" sin comillas y con distici�n de mayusculas minusculas para desbanear a todos los personajes", "unban", "hola")
if sentrada = "estoy de acuerdo" then
    
    n = banips.count
    for i = 1 to banips.count
        banips.remove 1
    next i
    
    msgbox "se han habilitado " & n & " ipes"
end if

end sub

private sub command2_click()
frmservidor.visible = false
end sub

private sub command20_click()
#if usarquesocket = 1 then

if msgbox("esta seguro que desea reiniciar los sockets ? se cerrar�n todas las conexiones activas.", vbyesno, "reiniciar sockets") = vbyes then
    call wsapireiniciarsockets
end if

#elseif usarquesocket = 2 then

dim loopc as integer

if msgbox("esta seguro que desea reiniciar los sockets ? se cerrar�n todas las conexiones activas.", vbyesno, "reiniciar sockets") = vbyes then
    for loopc = 1 to maxusers
        if userlist(loopc).connid <> -1 and userlist(loopc).connidvalida then
            call closesocket(loopc)
        end if
    next loopc
    
    call frmmain.serv.detener
    call frmmain.serv.iniciar(puerto)
end if

#end if
end sub

'barrin 29/9/03
private sub command21_click()

if enpausa = false then
    enpausa = true
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    command21.caption = "reanudar el servidor"
else
    enpausa = false
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    command21.caption = "pausar el servidor"
end if

end sub

private sub command22_click()
    me.visible = false
    frmadmin.show
end sub

private sub command23_click()
if msgbox("esta seguro que desea hacer worldsave, guardar pjs y cerrar ?", vbyesno, "apagar magicamente") = vbyes then
    me.mousepointer = 11
    
    frmstat.show
   
    'worldsave
    call dobackup

    'commit experiencia
    call mdparty.actualizaexperiencias

    'guardar pjs
    call guardarusuarios
    
    'chauuu
    unload frmmain
end if
end sub

private sub command25_click()
call md5scarga

end sub

private sub command26_click()
#if usarquesocket = 1 then
    'cierra el socket de escucha
    if socklisten >= 0 then call apiclosesocket(socklisten)
    
    'inicia el socket de escucha
    socklisten = listenforconnect(puerto, hwndmsg, "")
#end if
end sub

private sub command27_click()
frmuserlist.show

end sub

private sub command28_click()
    call loadbalance
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


#if usarquesocket = 1 then
call apiclosesocket(socklisten)
#elseif usarquesocket = 0 then
frmmain.socket1.cleanup
frmmain.socket2(0).cleanup
#elseif usarquesocket = 2 then
frmmain.serv.detener
#end if

dim loopc as integer

for loopc = 1 to maxusers
    call closesocket(loopc)
next
  

lastuser = 0
numusers = 0

call freenpcs
call freecharindexes

call loadsini
call cargarbackup
call loadobjdata

#if usarquesocket = 1 then
socklisten = listenforconnect(puerto, hwndmsg, "")

#elseif usarquesocket = 0 then
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

private sub form_load()
#if usarquesocket = 1 then
command20.visible = true
command26.visible = true
#elseif usarquesocket = 0 then
command20.visible = false
command26.visible = false
#elseif usarquesocket = 2 then
command20.visible = true
command26.visible = false
#end if

vs1.min = 0
if piccont.height > picfuera.scaleheight then
    vs1.max = piccont.height - picfuera.scaleheight
else
    vs1.max = 0
end if
piccont.top = -vs1.value

end sub

private sub vs1_change()
piccont.top = -vs1.value
end sub

private sub vs1_scroll()
piccont.top = -vs1.value
end sub
