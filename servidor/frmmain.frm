version 5.00
begin vb.form frmmain 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   3  'fixed dialog
   caption         =   "argentum online"
   clientheight    =   6390
   clientleft      =   1950
   clienttop       =   1515
   clientwidth     =   5190
   controlbox      =   0   'false
   fillcolor       =   &h00c0c0c0&
   beginproperty font 
      name            =   "arial"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   forecolor       =   &h80000004&
   icon            =   "frmmain.frx":0000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   palettemode     =   1  'usezorder
   scaleheight     =   6390
   scalewidth      =   5190
   startupposition =   2  'centerscreen
   windowstate     =   1  'minimized
   begin vb.checkbox chkserverhabilitado 
      backcolor       =   &h00ffc0c0&
      caption         =   "server habilitado solo gms"
      height          =   255
      left            =   120
      tabindex        =   13
      top             =   4440
      width           =   2775
   end
   begin vb.textbox txtnumusers 
      alignment       =   2  'center
      backcolor       =   &h00c0ffff&
      height          =   315
      left            =   2640
      locked          =   -1  'true
      tabindex        =   12
      text            =   "0"
      top             =   240
      width           =   975
   end
   begin vb.commandbutton cmdsystray 
      backcolor       =   &h00ffc0c0&
      caption         =   "systray"
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   10
      top             =   5880
      width           =   1335
   end
   begin vb.commandbutton cmdcerrarserver 
      backcolor       =   &h00c0c0ff&
      caption         =   "cerrar servidor"
      height          =   375
      left            =   1560
      style           =   1  'graphical
      tabindex        =   9
      top             =   5880
      width           =   3495
   end
   begin vb.commandbutton cmdconfiguracion 
      backcolor       =   &h00ffc0c0&
      caption         =   "configuraci???n general"
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   8
      top             =   5400
      width           =   4935
   end
   begin vb.timer tpiquetec 
      enabled         =   0   'false
      interval        =   6000
      left            =   3000
      top             =   2580
   end
   begin vb.timer packetresend 
      interval        =   10
      left            =   3000
      top             =   2100
   end
   begin vb.timer securitytimer 
      enabled         =   0   'false
      interval        =   10000
      left            =   3480
      top             =   2100
   end
   begin vb.commandbutton cmddump 
      backcolor       =   &h00ffc0c0&
      caption         =   "crear log cr???tico de usuarios"
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   7
      top             =   4920
      width           =   4935
   end
   begin vb.timer fx 
      enabled         =   0   'false
      interval        =   4000
      left            =   3960
      top             =   2580
   end
   begin vb.timer auditoria 
      enabled         =   0   'false
      interval        =   1000
      left            =   3960
      top             =   3060
   end
   begin vb.timer gametimer 
      enabled         =   0   'false
      interval        =   40
      left            =   3960
      top             =   2100
   end
   begin vb.timer tlluviaevent 
      enabled         =   0   'false
      interval        =   60000
      left            =   3480
      top             =   3060
   end
   begin vb.timer tlluvia 
      enabled         =   0   'false
      interval        =   500
      left            =   3480
      top             =   2580
   end
   begin vb.timer autosave 
      enabled         =   0   'false
      interval        =   60000
      left            =   3000
      top             =   3060
   end
   begin vb.timer npcataca 
      enabled         =   0   'false
      interval        =   4000
      left            =   4440
      top             =   3060
   end
   begin vb.timer killlog 
      enabled         =   0   'false
      interval        =   60000
      left            =   4440
      top             =   2100
   end
   begin vb.timer timer_ai 
      enabled         =   0   'false
      interval        =   100
      left            =   4455
      top             =   2580
   end
   begin vb.frame frame1 
      backcolor       =   &h00ffc0c0&
      caption         =   "mensajea todos los clientes (solo testeo)"
      height          =   3615
      left            =   120
      tabindex        =   2
      top             =   720
      width           =   4935
      begin vb.textbox txtchat 
         backcolor       =   &h00c0ffff&
         height          =   2175
         left            =   120
         multiline       =   -1  'true
         tabindex        =   11
         top             =   1320
         width           =   4695
      end
      begin vb.commandbutton command2 
         backcolor       =   &h00ffc0c0&
         caption         =   "enviar por consola"
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   375
         left            =   2520
         style           =   1  'graphical
         tabindex        =   5
         top             =   720
         width           =   2295
      end
      begin vb.commandbutton command1 
         backcolor       =   &h00ffc0c0&
         caption         =   "enviar por pop-up"
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   375
         left            =   120
         style           =   1  'graphical
         tabindex        =   4
         top             =   720
         width           =   2295
      end
      begin vb.textbox broadmsg 
         backcolor       =   &h00c0ffff&
         height          =   315
         left            =   120
         tabindex        =   3
         top             =   240
         width           =   4695
      end
   end
   begin vb.label escuch 
      backstyle       =   0  'transparent
      caption         =   "label2"
      height          =   255
      left            =   3840
      tabindex        =   6
      top             =   0
      visible         =   0   'false
      width           =   1335
   end
   begin vb.label cantusuarios 
      appearance      =   0  'flat
      autosize        =   -1  'true
      backcolor       =   &h00c0c0c0&
      backstyle       =   0  'transparent
      caption         =   "n???mero de usuarios jugando:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   195
      left            =   120
      tabindex        =   1
      top             =   360
      width           =   2460
   end
   begin vb.label txstatus 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   210
      left            =   240
      tabindex        =   0
      top             =   0
      width           =   15
   end
   begin vb.menu mnupopup 
      caption         =   "popupmenu"
      visible         =   0   'false
      begin vb.menu mnumostrar 
         caption         =   "&mostrar"
      end
      begin vb.menu mnusalir 
         caption         =   "&salir"
      end
   end
end
attribute vb_name = "frmmain"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m???rquez pablo ignacio
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
'calle 3 n???mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c???digo postal 1900
'pablo ignacio m???rquez

option explicit

public escuchadas as long

private type notifyicondata
    cbsize as long
    hwnd as long
    uid as long
    uflags as long
    ucallbackmessage as long
    hicon as long
    sztip as string * 64
end type
   
const nim_add = 0
const nim_delete = 2
const nif_message = 1
const nif_icon = 2
const nif_tip = 4

const wm_mousemove = &h200
const wm_lbuttondblclk = &h203
const wm_rbuttonup = &h205

private declare function getwindowthreadprocessid lib "user32" (byval hwnd as long, lpdwprocessid as long) as long
private declare function shell_notifyicona lib "shell32" (byval dwmessage as long, lpdata as notifyicondata) as integer

private function setnotifyicondata(hwnd as long, id as long, flags as long, callbackmessage as long, icon as long, tip as string) as notifyicondata
    dim nidtemp as notifyicondata

    nidtemp.cbsize = len(nidtemp)
    nidtemp.hwnd = hwnd
    nidtemp.uid = id
    nidtemp.uflags = flags
    nidtemp.ucallbackmessage = callbackmessage
    nidtemp.hicon = icon
    nidtemp.sztip = tip & chr$(0)

    setnotifyicondata = nidtemp
end function

sub checkidleuser()
    dim iuserindex as long
    
    for iuserindex = 1 to maxusers
        with userlist(iuserindex)
            'conexion activa? y es un usuario loggeado?
            if .connid <> -1 and .flags.userlogged then
                'actualiza el contador de inactividad
                if .flags.traveling = 0 then
                    .counters.idlecount = .counters.idlecount + 1
                end if
                
                if .counters.idlecount >= idlelimit then
                    call writeshowmessagebox(iuserindex, "demasiado tiempo inactivo. has sido desconectado.")
                    'mato los comercios seguros
                    if .comusu.destusu > 0 then
                        if userlist(.comusu.destusu).flags.userlogged then
                            if userlist(.comusu.destusu).comusu.destusu = iuserindex then
                                call writeconsolemsg(.comusu.destusu, "comercio cancelado por el otro usuario.", fonttypenames.fonttype_talk)
                                call fincomerciarusu(.comusu.destusu)
                                call flushbuffer(.comusu.destusu) 'flush the buffer to send the message right away
                            end if
                        end if
                        call fincomerciarusu(iuserindex)
                    end if
                    call cerrar_usuario(iuserindex)
                end if
            end if
        end with
    next iuserindex
end sub

private sub auditoria_timer()
on error goto errhand
static centinelsecs as byte

centinelsecs = centinelsecs + 1

if centinelsecs = 5 then
    'every 5 seconds, we try to call the player's attention so it will report the code.
    call modcentinela.calluserattention
    
    centinelsecs = 0
end if

call pasarsegundo 'sistema de desconexion de 10 segs

call actualizaestadisticasweb

exit sub

errhand:

call logerror("error en timer auditoria. err: " & err.description & " - " & err.number)
resume next

end sub

private sub autosave_timer()

on error goto errhandler
'fired every minute
static minutos as long
static minutoslatsclean as long
static minspjessave as long


minutos = minutos + 1
minspjessave = minspjessave + 1

'???????????????????????????????????????????
call modareas.areasoptimizacion
'???????????????????????????????????????????

'actualizamos el centinela
call modcentinela.pasarminutocentinela

if minutos = minutosws - 1 then
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("worldsave en 1 minuto ...", fonttypenames.fonttype_veneno))
end if

if minutos >= minutosws then
    call es.dobackup
    call aclon.vaciarcoleccion
    minutos = 0
end if

if minspjessave = minutosguardarusuarios - 1 then
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("charsave en 1 minuto ...", fonttypenames.fonttype_veneno))
elseif minspjessave >= minutosguardarusuarios then
    call mdparty.actualizaexperiencias
    call guardarusuarios
    minspjessave = 0
end if

if minutoslatsclean >= 15 then
    minutoslatsclean = 0
    call respawnorigposnpcs 'respawn de los guardias en las pos originales
    call limpiarmundo
else
    minutoslatsclean = minutoslatsclean + 1
end if

call purgarpenas
call checkidleuser

'<<<<<-------- log the number of users online ------>>>
dim n as integer
n = freefile()
open app.path & "\logs\numusers.log" for output shared as n
print #n, numusers
close #n
'<<<<<-------- log the number of users online ------>>>

exit sub
errhandler:
    call logerror("error en timerautosave " & err.number & ": " & err.description)
    resume next
end sub

private sub chkserverhabilitado_click()
    serversologms = chkserverhabilitado.value
end sub

private sub cmdcerrarserver_click()
    if msgbox("??????atencion!! si cierra el servidor puede provocar la perdida de datos. " & _
        "???desea hacerlo de todas maneras?", vbyesno) = vbyes then
        
        dim f
        for each f in forms
            unload f
        next
    end if
end sub

private sub cmdconfiguracion_click()
    frmservidor.visible = true
end sub

private sub cmddump_click()
on error resume next

    dim i as integer
    for i = 1 to maxusers
        call logcriticevent(i & ") connid: " & userlist(i).connid & _
            ". connidvalida: " & userlist(i).connidvalida & " name: " & userlist(i).name & _
            " userlogged: " & userlist(i).flags.userlogged)
    next i
    
    call logcriticevent("lastuser: " & lastuser & " nextopenuser: " & nextopenuser)

end sub

private sub cmdsystray_click()
    setsystray
end sub

private sub command1_click()
call senddata(sendtarget.toall, 0, preparemessageshowmessagebox(broadmsg.text))
''''''''''''''''solo para el testeo'''''''
''''''''''se usa para comunicarse con el server'''''''''''
txtchat.text = txtchat.text & vbnewline & "servidor> " & broadmsg.text
end sub

public sub initmain(byval f as byte)

if f = 1 then
    call setsystray
else
    frmmain.show
end if

end sub

private sub command2_click()
call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> " & broadmsg.text, fonttypenames.fonttype_server))
''''''''''''''''solo para el testeo'''''''
''''''''''se usa para comunicarse con el server'''''''''''
txtchat.text = txtchat.text & vbnewline & "servidor> " & broadmsg.text
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
on error resume next
   
   if not visible then
        select case x \ screen.twipsperpixelx
                
            case wm_lbuttondblclk
                windowstate = vbnormal
                visible = true
                dim hprocess as long
                getwindowthreadprocessid hwnd, hprocess
                appactivate hprocess
            case wm_rbuttonup
                hhook = setwindowshookex(wh_callwndproc, addressof apphook, app.hinstance, app.threadid)
                popupmenu mnupopup
                if hhook then unhookwindowshookex hhook: hhook = 0
        end select
   end if
   
end sub

private sub quitariconosystray()
on error resume next

'borramos el icono del systray
dim i as integer
dim nid as notifyicondata

nid = setnotifyicondata(frmmain.hwnd, vbnull, nif_message or nif_icon or nif_tip, vbnull, frmmain.icon, "")

i = shell_notifyicona(nim_delete, nid)
    

end sub

private sub form_unload(cancel as integer)
on error resume next

'save stats!!!
call statistics.dumpstatistics

call quitariconosystray

#if usarquesocket = 1 then
call limpiawsapi
#elseif usarquesocket = 0 then
socket1.cleanup
#elseif usarquesocket = 2 then
serv.detener
#end if

dim loopc as integer

for loopc = 1 to maxusers
    if userlist(loopc).connid <> -1 then call closesocket(loopc)
next

'log
dim n as integer
n = freefile
open app.path & "\logs\main.log" for append shared as #n
print #n, date & " " & time & " server cerrado."
close #n

end

set sonidosmapas = nothing

end sub

private sub fx_timer()
on error goto hayerror

call sonidosmapas.reproducirsonidosdemapas

exit sub
hayerror:

end sub

private sub gametimer_timer()
'********************************************************
'author: unknown
'last modify date: -
'********************************************************
    dim iuserindex as long
    dim benviarstats as boolean
    dim benviarays as boolean
    
on error goto hayerror
    
    '<<<<<< procesa eventos de los usuarios >>>>>>
    for iuserindex = 1 to maxusers 'lastuser
        with userlist(iuserindex)
           'conexion activa?
           if .connid <> -1 then
                '???user valido?
                
                if .connidvalida and .flags.userlogged then
                    
                    '[alejo-18-5]
                    benviarstats = false
                    benviarays = false
                    
                    if .flags.paralizado = 1 then call efectoparalisisuser(iuserindex)
                    if .flags.ceguera = 1 or .flags.estupidez then call efectocegueestu(iuserindex)
                    
                    if .flags.muerto = 0 then
                        
                        '[consejeros]
                        if (.flags.privilegios and playertype.user) then call efectolava(iuserindex)
                        
                        if .flags.desnudo <> 0 and (.flags.privilegios and playertype.user) <> 0 then call efectofrio(iuserindex)
                        
                        if .flags.meditando then call domeditar(iuserindex)
                        
                        if .flags.envenenado <> 0 and (.flags.privilegios and playertype.user) <> 0 then call efectoveneno(iuserindex)
                        
                        if .flags.admininvisible <> 1 then
                            if .flags.invisible = 1 then call efectoinvisibilidad(iuserindex)
                            if .flags.oculto = 1 then call dopermaneceroculto(iuserindex)
                        end if
                        
                        if .flags.mimetizado = 1 then call efectomimetismo(iuserindex)
                        
                        if .flags.atacablepor <> 0 then call efectoestadoatacable(iuserindex)
                        
                        call duracionpociones(iuserindex)
                        
                        call hambreysed(iuserindex, benviarays)
                        
                        if .flags.hambre = 0 and .flags.sed = 0 then
                            if lloviendo then
                                if not intemperie(iuserindex) then
                                    if not .flags.descansar then
                                    'no esta descansando
                                        call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                                        if benviarstats then
                                            call writeupdatehp(iuserindex)
                                            benviarstats = false
                                        end if
                                        call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                                        if benviarstats then
                                            call writeupdatesta(iuserindex)
                                            benviarstats = false
                                        end if
                                    else
                                    'esta descansando
                                        call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                                        if benviarstats then
                                            call writeupdatehp(iuserindex)
                                            benviarstats = false
                                        end if
                                        call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                                        if benviarstats then
                                            call writeupdatesta(iuserindex)
                                            benviarstats = false
                                        end if
                                        'termina de descansar automaticamente
                                        if .stats.maxhp = .stats.minhp and .stats.maxsta = .stats.minsta then
                                            call writerestok(iuserindex)
                                            call writeconsolemsg(iuserindex, "has terminado de descansar.", fonttypenames.fonttype_info)
                                            .flags.descansar = false
                                        end if
                                        
                                    end if
                                end if
                            else
                                if not .flags.descansar then
                                'no esta descansando
                                    
                                    call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                                    if benviarstats then
                                        call writeupdatehp(iuserindex)
                                        benviarstats = false
                                    end if
                                    call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                                    if benviarstats then
                                        call writeupdatesta(iuserindex)
                                        benviarstats = false
                                    end if
                                    
                                else
                                'esta descansando
                                    
                                    call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                                    if benviarstats then
                                        call writeupdatehp(iuserindex)
                                        benviarstats = false
                                    end if
                                    call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                                    if benviarstats then
                                        call writeupdatesta(iuserindex)
                                        benviarstats = false
                                    end if
                                    'termina de descansar automaticamente
                                    if .stats.maxhp = .stats.minhp and .stats.maxsta = .stats.minsta then
                                        call writerestok(iuserindex)
                                        call writeconsolemsg(iuserindex, "has terminado de descansar.", fonttypenames.fonttype_info)
                                        .flags.descansar = false
                                    end if
                                    
                                end if
                            end if
                        end if
                        
                        if benviarays then call writeupdatehungerandthirst(iuserindex)
                        
                        if .nromascotas > 0 then call tiempoinvocacion(iuserindex)
                    else
                        if .flags.traveling <> 0 then call travelingeffect(iuserindex)
                    end if 'muerto
                else 'no esta logeado?
                    'inactive players will be removed!
                    .counters.idlecount = .counters.idlecount + 1
                    if .counters.idlecount > intervaloparaconexion then
                        .counters.idlecount = 0
                        call closesocket(iuserindex)
                    end if
                end if 'userlogged
                
                'if there is anything to be sent, we send it
                call flushbuffer(iuserindex)
            end if
        end with
    next iuserindex
exit sub

hayerror:
    logerror ("error en gametimer: " & err.description & " userindex = " & iuserindex)
end sub

private sub mnusalir_click()
    call cmdcerrarserver_click
end sub

public sub mnumostrar_click()
on error resume next
    windowstate = vbnormal
    form_mousemove 0, 0, 7725, 0
end sub

private sub killlog_timer()
on error resume next
if fileexist(app.path & "\logs\connect.log", vbnormal) then kill app.path & "\logs\connect.log"
if fileexist(app.path & "\logs\haciendo.log", vbnormal) then kill app.path & "\logs\haciendo.log"
if fileexist(app.path & "\logs\stats.log", vbnormal) then kill app.path & "\logs\stats.log"
if fileexist(app.path & "\logs\asesinatos.log", vbnormal) then kill app.path & "\logs\asesinatos.log"
if fileexist(app.path & "\logs\hackattemps.log", vbnormal) then kill app.path & "\logs\hackattemps.log"
if not fileexist(app.path & "\logs\nokillwsapi.txt") then
    if fileexist(app.path & "\logs\wsapi.log", vbnormal) then kill app.path & "\logs\wsapi.log"
end if

end sub

private sub setsystray()

    dim i as integer
    dim s as string
    dim nid as notifyicondata
    
    s = "argentum-online"
    nid = setnotifyicondata(frmmain.hwnd, vbnull, nif_message or nif_icon or nif_tip, wm_mousemove, frmmain.icon, s)
    i = shell_notifyicona(nim_add, nid)
        
    if windowstate <> vbminimized then windowstate = vbminimized
    visible = false

end sub

private sub npcataca_timer()

on error resume next
    dim npc as long
    
    for npc = 1 to lastnpc
        npclist(npc).canattack = 1
    next npc

end sub

private sub packetresend_timer()
'***************************************************
'autor: juan mart???n sotuyo dodero (maraxus)
'last modification: 04/01/07
'attempts to resend to the user all data that may be enqueued.
'***************************************************
on error goto errhandler:
    dim i as long
    
    for i = 1 to maxusers
        if userlist(i).connidvalida then
            if userlist(i).outgoingdata.length > 0 then
                call enviardatosaslot(i, userlist(i).outgoingdata.readasciistringfixed(userlist(i).outgoingdata.length))
            end if
        end if
    next i

exit sub

errhandler:
    logerror ("error en packetresend - error: " & err.number & " - desc: " & err.description)
    resume next
end sub

private sub securitytimer_timer()

#if seguridadalkon then
    call security.securitycheck
#end if

end sub

private sub timer_ai_timer()

on error goto errorhandler
    dim npcindex as long
    dim mapa as integer
    dim e_p as integer
    
    'barrin 29/9/03
    if not haciendobk and not enpausa then
        'update npcs
        for npcindex = 1 to lastnpc
            
            with npclist(npcindex)
                if .flags.npcactive then 'nos aseguramos que sea inteligente!
                
                    ' chequea si contiua teniendo due???o
                    if .owner > 0 then call validarpermanencianpc(npcindex)
                
                    if .flags.paralizado = 1 then
                        call efectoparalisisnpc(npcindex)
                    else
                        ' preto? tienen ai especial
                        if .npctype = enpctype.pretoriano then
                            call clanpretoriano(.clanindex).performpretorianai(npcindex)
                        else
                            'usamos ai si hay algun user en el mapa
                            if .flags.inmovilizado = 1 then
                               call efectoparalisisnpc(npcindex)
                            end if
                            
                            mapa = .pos.map
                            
                            if mapa > 0 then
                                if mapinfo(mapa).numusers > 0 then
                                    if .movement <> tipoai.estatico then
                                        call npcai(npcindex)
                                    end if
                                end if
                            end if
                        end if
                    end if
                end if
            end with
        next npcindex
    end if
    
    exit sub

errorhandler:
    call logerror("error en timer_ai_timer " & npclist(npcindex).name & " mapa:" & _
    npclist(npcindex).pos.map)
    call muerenpc(npcindex, 0)
end sub

private sub tlluvia_timer()
on error goto errhandler

dim icount as long
if lloviendo then
   for icount = 1 to lastuser
        call efectolluvia(icount)
   next icount
end if

exit sub
errhandler:
call logerror("tlluvia " & err.number & ": " & err.description)
end sub

private sub tlluviaevent_timer()

on error goto errorhandler
static minutoslloviendo as long
static minutossinlluvia as long

if not lloviendo then
    minutossinlluvia = minutossinlluvia + 1
    if minutossinlluvia >= 15 and minutossinlluvia < 1440 then
        if randomnumber(1, 100) <= 2 then
            lloviendo = true
            minutossinlluvia = 0
            call senddata(sendtarget.toall, 0, preparemessageraintoggle())
        end if
    elseif minutossinlluvia >= 1440 then
        lloviendo = true
        minutossinlluvia = 0
        call senddata(sendtarget.toall, 0, preparemessageraintoggle())
    end if
else
    minutoslloviendo = minutoslloviendo + 1
    if minutoslloviendo >= 5 then
        lloviendo = false
        call senddata(sendtarget.toall, 0, preparemessageraintoggle())
        minutoslloviendo = 0
    else
        if randomnumber(1, 100) <= 2 then
            lloviendo = false
            minutoslloviendo = 0
            call senddata(sendtarget.toall, 0, preparemessageraintoggle())
        end if
    end if
end if

exit sub
errorhandler:
call logerror("error tlluviatimer")

end sub

private sub tpiquetec_timer()
    dim nuevaa as boolean
   ' dim nuevol as boolean
    dim gi as integer
    dim i as long
    
on error goto errhandler
    for i = 1 to lastuser
        with userlist(i)
            if .flags.userlogged then
                if mapdata(.pos.map, .pos.x, .pos.y).trigger = etrigger.antipiquete then
                    if .flags.muerto = 0 then
                        .counters.piquetec = .counters.piquetec + 1
                        call writeconsolemsg(i, "?????????est???s obstruyendo la v???a p???blica, mu???vete o ser???s encarcelado!!!", fonttypenames.fonttype_info)
                        
                        if .counters.piquetec > 23 then
                            .counters.piquetec = 0
                            call encarcelar(i, tiempo_carcel_piquete)
                        end if
                    else
                        .counters.piquetec = 0
                    end if
                else
                    .counters.piquetec = 0
                end if
                
                'ustedes se preguntaran que hace esto aca?
                'bueno la respuesta es simple: el codigo de ao es una mierda y encontrar
                'todos los puntos en los cuales la alineacion puede cambiar es un dolor de
                'huevos, asi que lo controlo aca, cada 6 segundos, lo cual es razonable
        
                gi = .guildindex
                if gi > 0 then
                    nuevaa = false
                   ' nuevol = false
                    if not modguilds.m_validarpermanencia(i, true, nuevaa) then
                        call writeconsolemsg(i, "has sido expulsado del clan. ???el clan ha sumado un punto de antifacci???n!", fonttypenames.fonttype_guild)
                    end if
                    if nuevaa then
                        call senddata(sendtarget.toguildmembers, gi, preparemessageconsolemsg("???el clan ha pasado a tener alineaci???n " & guildalignment(gi) & "!", fonttypenames.fonttype_guild))
                        call logclanes("???el clan cambio de alineaci???n!")
                    end if
'                    if nuevol then
'                        call senddata(sendtarget.toguildmembers, gi, preparemessageconsolemsg("???el clan tiene un nuevo l???der!", fonttypenames.fonttype_guild))
'                        call logclanes("???el clan tiene nuevo lider!")
'                    end if
                end if
                
                call flushbuffer(i)
            end if
        end with
    next i
exit sub

errhandler:
    call logerror("error en tpiquetec_timer " & err.number & ": " & err.description)
end sub





'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''uso del control tcpserv'''''''''''''''''''''''''''
'''''''''''''compilar con usarquesocket = 3''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


#if usarquesocket = 3 then

private sub tcpserv_eror(byval numero as long, byval descripcion as string)
    call logerror("tcpserver socket error: " & numero & "/" & descripcion)
end sub

private sub tcpserv_nuevaconn(byval id as long)
on error goto errorhandlernc

    escuchadas = escuchadas + 1
    escuch.caption = escuchadas
    
    dim i as integer
    
    dim newindex as integer
    newindex = nextopenuser
    
    if newindex <= maxusers then
        'call logindex(newindex, "******> accept. connid: " & id)
        
        tcpserv.setdato id, newindex
        
        if ados.maxconexiones(tcpserv.getip(id)) then
            call ados.restarconexion(tcpserv.getip(id))
            call resetuserslot(newindex)
            exit sub
        end if

        if newindex > lastuser then lastuser = newindex

        userlist(newindex).connid = id
        userlist(newindex).ip = tcpserv.getip(id)
        userlist(newindex).connidvalida = true
        set userlist(newindex).commandsbuffer = new ccolaarray
        
        for i = 1 to banips.count
            if banips.item(i) = tcpserv.getip(id) then
                call resetuserslot(newindex)
                exit sub
            end if
        next i

    else
        call closesocket(newindex, true)
        logcriticevent ("newindex > maxusers. imposible alocatear sockets")
    end if

exit sub

errorhandlernc:
call logerror("tcpserver::nuevaconexion " & err.description)
end sub

private sub tcpserv_close(byval id as long, byval midato as long)
    on error goto eh
    '' no cierro yo el socket. el on_close lo cierra por mi.
    'call logindex(midato, "******> remote close. connid: " & id & " midato: " & midato)
    call closesocket(midato, false)
exit sub
eh:
    call logerror("ocurrio un error en el evento tcpserv_close. id/midato:" & id & "/" & midato)
end sub

private sub tcpserv_read(byval id as long, datos as variant, byval cantidad as long, byval midato as long)
on error goto errorh

with userlist(midato)
    datos = strconv(strconv(datos, vbunicode), vbfromunicode)
    
    call .incomingdata.writeasciistringfixed(datos)
    
    if .connid <> -1 then
        call handleincomingdata(midato)
    else
        exit sub
    end if
end with

exit sub

errorh:
call logerror("error socket read: " & midato & " dato:" & rd & " userlogged: " & userlist(midato).flags.userlogged & " connid:" & userlist(midato).connid & " id parametro" & id & " error:" & err.description)

end sub

#end if
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''fin  uso del control tcpserv'''''''''''''''''''''''''
'''''''''''''compilar con usarquesocket = 3''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

