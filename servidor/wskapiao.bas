attribute vb_name = "wskapiao"
'argentum online 0.11.20
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





'amen alejo por este modulo que has hecho :d

option explicit

#if usarquesocket = 1 then

'si la variable esta en true , al iniciar el wsapi se crea
'una ventana label para recibir los mensajes. al detenerlo,
'se destruye.
'si es false, los mensajes se envian al form frmmain (o el
'que sea).
#const wsapi_crear_label = true

private const sd_receive as long = &h0
private const sd_send as long = &h1
private const sd_both as long = &h2


private const max_tiempoidle_colallena = 1 'minutos
private const max_colasalida_count = 800

public declare sub sleep lib "kernel32" (byval dwmilliseconds as long)

public declare function getwindowlong lib "user32" alias "getwindowlonga" (byval hwnd as long, byval nindex as long) as long
public declare function setwindowlong lib "user32" alias "setwindowlonga" (byval hwnd as long, byval nindex as long, byval dwnewlong as long) as long
public declare function callwindowproc lib "user32" alias "callwindowproca" (byval lpprevwndfunc as long, byval hwnd as long, byval msg as long, byval wparam as long, byval lparam as long) as long

private declare function createwindowex lib "user32" alias "createwindowexa" (byval dwexstyle as long, byval lpclassname as string, byval lpwindowname as string, byval dwstyle as long, byval x as long, byval y as long, byval nwidth as long, byval nheight as long, byval hwndparent as long, byval hmenu as long, byval hinstance as long, lpparam as any) as long
private declare function destroywindow lib "user32" (byval hwnd as long) as long

private const ws_child = &h40000000
public const gwl_wndproc = (-4)

'====================================================================================
'====================================================================================
'esto es para agilizar la busqueda del slot a partir de un socket dado,
'sino, la funcion buscaslotsock se nos come todo el uso del cpu.

public type tsockcache
    sock as long
    slot as long
end type

'public wsapisockchache() as tsockcache 'lista de pares socket -> slot
'public wsapisockchachecant as long 'cantidad de elementos para hacer una busqueda eficiente :p
public wsapisock2usr as new collection

'====================================================================================
'====================================================================================

public oldwproc as long
public actualwproc as long
public hwndmsg as long

'====================================================================================
'====================================================================================

public socklisten as long

#end if

'====================================================================================
'====================================================================================


public sub iniciawsapi(byval hwndparent as long)
#if usarquesocket = 1 then

call logapisock("iniciawsapi")
debug.print "iniciawsapi"

#if wsapi_crear_label then
hwndmsg = createwindowex(0, "static", "aomsg", ws_child, 0, 0, 0, 0, hwndparent, 0, app.hinstance, byval 0&)
#else
hwndmsg = hwndparent
#end if 'wsapi_crear_label

oldwproc = setwindowlong(hwndmsg, gwl_wndproc, addressof wndproc)
actualwproc = getwindowlong(hwndmsg, gwl_wndproc)

dim desc as string
call startwinsock(desc)

#end if
end sub

public sub limpiawsapi(byval hwnd as long)
#if usarquesocket = 1 then

call logapisock("limpiawsapi")

if wsastartedup then
    call endwinsock
end if

if oldwproc <> 0 then
    setwindowlong hwndmsg, gwl_wndproc, oldwproc
    oldwproc = 0
end if

#if wsapi_crear_label then
if hwndmsg <> 0 then
    destroywindow hwndmsg
end if
#end if

#end if
end sub

public function buscaslotsock(byval s as long, optional byval cacheind as boolean = false) as long
debug.print "buscasockslot"
#if usarquesocket = 1 then

on error goto hayerror

buscaslotsock = wsapisock2usr.item(cstr(s))
exit function

hayerror:
buscaslotsock = -1

'dim i as long
'
'for i = 1 to maxusers
'    if userlist(i).connid = s and userlist(i).connidvalida then
'        buscaslotsock = i
'        exit function
'    end if
'next i
'
'buscaslotsock = -1

'
'dim pri as long, ult as long, med as long
'
'if wsapisockchachecant > 0 then
'    'busqueda dicotomica :d
'    pri = 1
'    ult = wsapisockchachecant
'    med = int((pri + ult) / 2)
'
'    do while (pri <= ult) and (wsapisockchache(med).sock <> s)
'        if s < wsapisockchache(med).sock then
'            ult = med - 1
'        else
'            pri = med + 1
'        end if
'        med = int((pri + ult) / 2)
'    loop
'
'    if pri <= ult then
'        if cacheind then
'            buscaslotsock = med
'        else
'            buscaslotsock = wsapisockchache(med).slot
'        end if
'    else
'        buscaslotsock = -1
'    end if
'else
'    buscaslotsock = -1
'end if

#end if
end function

public sub agregaslotsock(byval sock as long, byval slot as long)
debug.print "agregasockslot"
#if (usarquesocket = 1) then

if frmmain.superlog.value = 1 then logcustom ("agregaslotsock:: sock=" & sock & " slot=" & slot)

if wsapisock2usr.count > maxusers then
    if frmmain.superlog.value = 1 then logcustom ("imposible agregarslotsock (wsapi2usr.count>maxusers)")
    call closesocket(slot)
    exit sub
end if

wsapisock2usr.add cstr(slot), cstr(sock)

'dim pri as long, ult as long, med as long
'dim loopc as long
'
'if wsapisockchachecant > 0 then
'    pri = 1
'    ult = wsapisockchachecant
'    med = int((pri + ult) / 2)
'
'    do while (pri <= ult) and (ult > 1)
'        if sock < wsapisockchache(med).sock then
'            ult = med - 1
'        else
'            pri = med + 1
'        end if
'        med = int((pri + ult) / 2)
'    loop
'
'    pri = iif(sock < wsapisockchache(med).sock, med, med + 1)
'    ult = wsapisockchachecant
'    for loopc = ult to pri step -1
'        wsapisockchache(loopc + 1) = wsapisockchache(loopc)
'    next loopc
'    med = pri
'else
'    med = 1
'end if
'wsapisockchache(med).slot = slot
'wsapisockchache(med).sock = sock
'wsapisockchachecant = wsapisockchachecant + 1

#end if
end sub

public sub borraslotsock(byval sock as long, optional byval cacheindice as long)
#if (usarquesocket = 1) then
dim cant as long

cant = wsapisock2usr.count
on error resume next
wsapisock2usr.remove cstr(sock)

debug.print "borrasockslot " & cant & " -> " & wsapisock2usr.count

'dim n as long, indice as long
'
''if ismissing(cacheindice) then
'    indice = buscaslotsock(sock, true)
'    if indice < 1 then exit sub
''else
''    indice = cacheindice
''end if
'
'wsapisockchachecant = wsapisockchachecant - 1
'
'for n = indice to wsapisockchachecant
'    wsapisockchache(n) = wsapisockchache(n + 1)
'next n

#end if
end sub



public function wndproc(byval hwnd as long, byval msg as long, byval wparam as long, byval lparam as long) as long
#if usarquesocket = 1 then

on error resume next

dim ret as long
dim tmp as string

dim s as long, e as long
dim n as integer
    
dim dale as boolean
dim ulterror as long


wndproc = 0


if camaralenta = 1 then
    sleep 1
end if


select case msg
case 1025

    s = wparam
    e = wsagetselectevent(lparam)
    'debug.print "msg: " & msg & " w: " & wparam & " l: " & lparam
    call logapisock("msg: " & msg & " w: " & wparam & " l: " & lparam)
    
    select case e
    case fd_accept
            if frmmain.superlog.value = 1 then logcustom ("fd_accept")
        if s = socklisten then
            if frmmain.superlog.value = 1 then logcustom ("socklisten = " & s & ". llamo a eventosocketaccept")
            call eventosockaccept(s)
        end if
        
'    case fd_write
'        n = buscaslotsock(s)
'        if n < 0 and s <> socklisten then
'            'call apiclosesocket(s)
'            call wsapiclosesocket(s)
'            exit function
'        end if
'
'        userlist(n).sockpuedoenviar = true

'        call intentarenviardatosencolados(n)
'
''        dale = userlist(n).colasalida.count > 0
''        do while dale
''            ret = wsapienviar(n, userlist(n).colasalida.item(1), false)
''            if ret <> 0 then
''                if ret = wsaewouldblock then
''                    dale = false
''                else
''                    'y aca que hacemo' ?? help! i need somebody, help!
''                    dale = false
''                    debug.print "error al enviar el dato desde la cola " & ret & ": " & getwsaerrorstring(ret)
''                end if
''            else
''            '    debug.print "dato de la cola enviado"
''                userlist(n).colasalida.remove 1
''                dale = (userlist(n).colasalida.count > 0)
''            end if
''        loop

    case fd_read
        
        n = buscaslotsock(s)
        if n < 0 and s <> socklisten then
            'call apiclosesocket(s)
            call wsapiclosesocket(s)
            exit function
        end if
        
        'call wsaasyncselect(s, hwndmsg, byval 1025, byval (0))
        
        '4k de buffer
        tmp = space(8192)   'si cambias este valor, tambien hacelo mas abajo
                            'donde dice ret = 8192 :)
        
        ret = recv(s, tmp, len(tmp), 0)
        ' comparo por = 0 ya que esto es cuando se cierra
        ' "gracefully". (mas abajo)
        if ret < 0 then
            ulterror = err.lastdllerror
            if ulterror = wsaemsgsize then
                debug.print "wsaemsgsize"
                ret = 8192
            else
                debug.print "error en recv: " & getwsaerrorstring(ulterror)
                call logapisock("error en recv: n=" & n & " s=" & s & " str=" & getwsaerrorstring(ulterror))
                
                'no hay q llamar a closesocket() directamente,
                'ya q pueden abusar de algun error para
                'desconectarse sin los 10segs. creeme.
            '    call c l o s e socket(n)
            
                call closesocketsl(n)
                call cerrar_usuario(n)
                exit function
            end if
        elseif ret = 0 then
            call closesocketsl(n)
            call cerrar_usuario(n)
        end if
        
        'call wsaasyncselect(s, hwndmsg, byval 1025, byval (fd_read or fd_write or fd_close or fd_accept))
        
        tmp = left(tmp, ret)
        
        'call logapisock("wndproc:fd_read:n=" & n & ":tmp=" & tmp)
        
        call eventosockread(n, tmp)
        
    case fd_close
        n = buscaslotsock(s)
        if s <> socklisten then call apiclosesocket(s)
        
        call logapisock("wndproc:fd_close:n=" & n & ":err=" & wsagetasyncerror(lparam))
        
        if n > 0 then
            call borraslotsock(userlist(n).connid)
            userlist(n).connid = -1
            userlist(n).connidvalida = false
            call eventosockclose(n)
        end if
        
    end select
case else
    wndproc = callwindowproc(oldwproc, hwnd, msg, wparam, lparam)
end select

#end if
end function

'retorna 0 cuando se envi� o se metio en la cola,
'retorna <> 0 cuando no se pudo enviar o no se pudo meter en la cola
public function wsapienviar(byval slot as integer, byval str as string, optional encolar as boolean = true) as long
#if usarquesocket = 1 then

if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: slot=" & slot & " str=" & str & " len(str)=" & len(str) & " encolar=" & encolar)

dim ret as string
dim ulterror as long
dim retorno as long

retorno = 0

'debug.print ">>>> " & str

if userlist(slot).connid <> -1 and userlist(slot).connidvalida then
'    if  then
'        ' si hay elementos sin enviar, lo mete en la cola
'        ' ya q hay q mantener un orden de paquetes
'        userlist(slot).colasalida.add str 'metelo en la cola vite'
'    if (userlist(slot).sockpuedoenviar and (userlist(slot).colasalida.count = 0)) or (not encolar) then
    if ((userlist(slot).colasalida.count = 0)) or (not encolar) then
        if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: previo a ret = send(" & userlist(slot).connid & "," & str & "," & len(str) & ",0)")
        ret = send(byval userlist(slot).connid, byval str, byval len(str), byval 0)
        if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: post a ret = send(" & userlist(slot).connid & "," & str & "," & len(str) & ",0) devolvio: " & ret)
        if ret < 0 then
            ulterror = err.lastdllerror
            if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: if ret<0 then.. ulterror=" & ulterror)
        '    debug.print "error en send " & ret & " " & ulterror & " " & getwsaerrorstring(err.lastdllerror)
            if ulterror = wsaewouldblock then
                userlist(slot).sockpuedoenviar = false
                if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: seteo ul(" & slot & ").sockpuedoenviar=false")
                if encolar then
                    userlist(slot).colasalida.add str 'metelo en la cola vite'
                    if frmmain.superlog.value = 1 then logcustom ("wsapienviar:: encolo en ul(" & slot & ")")
        '            debug.print "dato encolado."
'                else
'                    retorno = ulterror
                end if
'            else
'                retorno = ret
            end if
            retorno = ulterror
            'logapisock ("error en send, slot: " & slot)
            'call closesocket(slot)
        end if
    else
        if userlist(slot).colasalida.count < max_colasalida_count or userlist(slot).counters.idlecount < max_tiempoidle_colallena then
            userlist(slot).colasalida.add str 'metelo en la cola vite'
        else
            retorno = -1
        end if
    end if
elseif userlist(slot).connid <> -1 and not userlist(slot).connidvalida then
    if not userlist(slot).counters.saliendo then
        retorno = -1
    end if
end if

wsapienviar = retorno

#end if
end function


public sub logcustom(byval str as string)
#if (usarquesocket = 1) then

on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\custom.log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

exit sub

errhandler:

#end if
end sub


public sub logapisock(byval str as string)
#if (usarquesocket = 1) then

on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\wsapi.log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

exit sub

errhandler:

#end if
end sub


public sub intentarenviardatosencolados(byval n as integer)
#if usarquesocket = 1 then

dim dale as boolean
dim ret as long

dale = userlist(n).colasalida.count > 0
do while dale
    ret = wsapienviar(n, userlist(n).colasalida.item(1), false)
    if ret <> 0 then
        if ret = wsaewouldblock then
            dale = false
        else
            'y aca que hacemo' ?? help! i need somebody, help!
            dale = false
            debug.print "error al enviar el dato desde la cola " & ret & ": " & getwsaerrorstring(ret)
            call logapisock("intentarenviardatosencolados: n=" & n & " " & getwsaerrorstring(ret))
            call closesocketsl(n)
            call cerrar_usuario(n)
        end if
    else
    '    debug.print "dato de la cola enviado"
        userlist(n).colasalida.remove 1
        dale = (userlist(n).colasalida.count > 0)
    end if
loop

#end if
end sub


public sub eventosockaccept(byval sockid as long)
#if usarquesocket = 1 then
'==========================================================
'uso de la api de winsock
'========================

'call logapisock("eventosockaccept")

if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "pedido de conexion socketid:" & sockid & vbcrlf

'on error resume next
    
    dim newindex as integer
    dim ret as long
    dim tam as long, sa as sockaddr
    dim nuevosock as long
    dim i as long
    dim tstr as string
    
    tam = sockaddr_size
    
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "nextopenuser" & vbcrlf
    
    newindex = nextopenuser ' nuevo indice
    if frmmain.superlog.value = 1 then logcustom ("eventsockaccept:: newindex=" & newindex)
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "userindex asignado " & newindex & vbcrlf
    
'    debug.print newindex

    '=============================================
    'sockid es en este caso es el socket de escucha,
    'a diferencia de socketwrench que es el nuevo
    'socket de la nueva conn
    
    if frmmain.superlog.value = 1 then logcustom ("eventsockaccept:: llamo a accept(" & sockid & ",sa," & tam & ")")
    
    ret = accept(sockid, sa, tam)
    
    if frmmain.superlog.value = 1 then logcustom ("eventsockaccept:: accept devuelve ret=" & ret)
    
    if ret = invalid_socket then
        i = err.lastdllerror
        call logcriticevent("error en accept() api " & i & ": " & getwsaerrorstring(i))
        if frmmain.superlog.value = 1 then call logcustom("error en accept() api " & i & ": " & getwsaerrorstring(i))
        exit sub
    end if
    nuevosock = ret

    if newindex <= maxusers then
        if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "cargando socket " & newindex & vbcrlf
        
               
        userlist(newindex).ip = getascip(sa.sin_addr)
        
        if frmmain.superlog.value = 1 then logcustom ("eventsockaccept:: getascip=" & userlist(newindex).ip)
        
        'busca si esta banneada la ip
        for i = 1 to banips.count
            if banips.item(i) = userlist(newindex).ip then
                'call apiclosesocket(nuevosock)
                call wsapiclosesocket(nuevosock)
                exit sub
            end if
        next i
        
        
        call logapisock("eventosockaccept newindex: " & newindex & " nuevosock: " & nuevosock & " ip: " & userlist(newindex).ip)
        '=============================================
        if ados.maxconexiones(userlist(newindex).ip) then
            userlist(newindex).connid = -1
            if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "user slot reseteado " & newindex & vbcrlf
            if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "socket unloaded" & newindex & vbcrlf
            'call logcriticevent(userlist(newindex).ip & " intento crear mas de 3 conexiones.")
            call ados.restarconexion(userlist(newindex).ip)
            'call apiclosesocket(nuevosock)
            call wsapiclosesocket(nuevosock)
            'exit sub
        end if
        
        if newindex > lastuser then lastuser = newindex
        
        userlist(newindex).sockpuedoenviar = true
        userlist(newindex).connid = nuevosock
        userlist(newindex).connidvalida = true
        set userlist(newindex).commandsbuffer = new ccolaarray
        set userlist(newindex).colasalida = new collection
        
        if frmmain.superlog.value = 1 then logcustom ("eventosockaccept:: voy a llamar a agregaslotsock(" & nuevosock & "," & newindex & ")")
        call agregaslotsock(nuevosock, newindex)
        
'        debug.print "conexion desde " & userlist(newindex).ip
        
        if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & userlist(newindex).ip & " logged." & vbcrlf & vbcrlf
    else
        call logcriticevent("no acepte conexion porque no tenia slots")
        if frmmain.superlog.value = 1 then logcustom ("eventosockaccept:: no tenia mas slots! sockid=" & sockid & " nuevosock=" & nuevosock & " newindex=" & newindex)
        tstr = "errserver lleno." & endc
        dim aaa as long
        aaa = send(byval nuevosock, byval tstr, byval len(tstr), byval 0)
        if frmmain.superlog.value = 1 then logcustom ("eventosockaccept:: no tenia mas slots! send devuelve=" & aaa)
'        ret = accept(sockid, sa, tam)
'        if ret = invalid_socket then
'            call logcriticevent("error en accept() api")
'            exit sub
'        end if

        'call apiclosesocket(nuevosock)
        call wsapiclosesocket(nuevosock)
    end if
    
#end if
end sub

public sub eventosockread(byval slot as integer, byref datos as string)
#if usarquesocket = 1 then

dim t() as string
dim loopc as long

debug.print "<<<< " & datos

if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "eventosockread ui: " & slot & " datos: " & datos & vbcrlf

'tcpesstats.bytesrecibidos = tcpesstats.bytesrecibidos + len(datos)

if frmmain.superlog.value = 1 then logcustom ("eventosockread:: slot=" & slot & " datos=" & datos)

userlist(slot).rdbuffer = userlist(slot).rdbuffer & datos

'if instr(1, userlist(slot).rdbuffer, chr(2)) > 0 then
'    userlist(slot).rdbuffer = "clienteviejo" & endc
'    debug.print "clienteviejo"
'end if

t = split(userlist(slot).rdbuffer, endc)
if ubound(t) > 0 then
    userlist(slot).rdbuffer = t(ubound(t))
    
    for loopc = 0 to ubound(t) - 1
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        '%%% si esta opcion se activa soluciona %%%
        '%%% el problema del speedhack          %%%
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if clientscommandsqueue = 1 then
            'if t(loopc) <> "" then if not userlist(slot).commandsbuffer.push(t(loopc)) then call cerrar_usuario(slot, 0)
            if t(loopc) <> "" then if not userlist(slot).commandsbuffer.push(t(loopc)) then call closesocket(slot)
            if frmmain.superlog.value = 1 then logcustom ("eventosockaccept:: pude pushear los datos del slot " & slot)
        else ' no encolamos los comandos (muy viejo)
              if userlist(slot).connid <> -1 then
                call handledata(slot, t(loopc))
              else
                exit sub
              end if
        end if
    next loopc
end if

#end if
end sub

public sub eventosockclose(byval slot as integer)
#if usarquesocket = 1 then

    if frmmain.superlog.value = 1 then logcustom ("eventosockclose:: slot=" & slot)
    if userlist(slot).flags.userlogged then
        call closesocketsl(slot)
        call cerrar_usuario(slot)
    else
        call closesocket(slot)
    end if
#end if
end sub


public sub wsapireiniciarsockets()
#if usarquesocket = 1 then
dim i as long
    'cierra el socket de escucha
    if socklisten >= 0 then call apiclosesocket(socklisten)
    
    'cierra todas las conexiones
    for i = 1 to maxusers
        if userlist(i).connid <> -1 and userlist(i).connidvalida then
            call closesocket(i)
        end if
        
        'call resetuserslot(i)
    next i
    
    ' no 'ta el preserve :p
    redim userlist(1 to maxusers)
    for i = 1 to maxusers
        userlist(i).connid = -1
        userlist(i).connidvalida = false
    next i
    
    lastuser = 1
    numusers = 0
    
    call limpiawsapi(frmmain.hwnd)
    call sleep(100)
    call iniciawsapi(frmmain.hwnd)
    socklisten = listenforconnect(puerto, hwndmsg, "")

'    'inicia el socket de escucha
'    socklisten = listenforconnect(puerto, hwndmsg, "")
'
'    'comprueba si el proc de la ventana es el correcto
'    dim tmpwproc as long
'    tmpwproc = getwindowlong(hwndmsg, gwl_wndproc)
'    if tmpwproc <> actualwproc then
'        msgbox "incorrecto proc de ventana (" & tmpwproc & " <> " & actualwproc & ")"
'        call logapisock("incorrecto proc de ventana")
'        oldwproc = tmpwproc
'        if oldwproc <> 0 then
'            setwindowlong frmmain.hwnd, gwl_wndproc, addressof wndproc
'            actualwproc = getwindowlong(frmmain.hwnd, gwl_wndproc)
'        end if
'    end if
#end if
end sub


public sub wsapiclosesocket(byval socket as long)
#if usarquesocket = 1 then
call wsaasyncselect(socket, hwndmsg, byval 1025, byval (fd_close))
call shutdown(socket, sd_both)
#end if
end sub
