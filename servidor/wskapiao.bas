attribute vb_name = "wskapiao"
'**************************************************************
' wskapiao.bas
'
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

''
' modulo para manejar winsock
'

#if usarquesocket = 1 then


'si la variable esta en true , al iniciar el wsapi se crea
'una ventana label para recibir los mensajes. al detenerlo,
'se destruye.
'si es false, los mensajes se envian al form frmmain (o el
'que sea).
#const wsapi_crear_label = true

private const sd_both as long = &h2

public declare sub sleep lib "kernel32" (byval dwmilliseconds as long)

public declare function getwindowlong lib "user32" alias "getwindowlonga" (byval hwnd as long, byval nindex as long) as long
public declare function setwindowlong lib "user32" alias "setwindowlonga" (byval hwnd as long, byval nindex as long, byval dwnewlong as long) as long
public declare function callwindowproc lib "user32" alias "callwindowproca" (byval lpprevwndfunc as long, byval hwnd as long, byval msg as long, byval wparam as long, byval lparam as long) as long

private declare function createwindowex lib "user32" alias "createwindowexa" (byval dwexstyle as long, byval lpclassname as string, byval lpwindowname as string, byval dwstyle as long, byval x as long, byval y as long, byval nwidth as long, byval nheight as long, byval hwndparent as long, byval hmenu as long, byval hinstance as long, lpparam as any) as long
private declare function destroywindow lib "user32" (byval hwnd as long) as long

private const ws_child = &h40000000
public const gwl_wndproc = (-4)

private const size_rcvbuf as long = 8192
private const size_sndbuf as long = 8192

''
'esto es para agilizar la busqueda del slot a partir de un socket dado,
'sino, la funcion buscaslotsock se nos come todo el uso del cpu.
'
' @param sock sock
' @param slot slot
'
public type tsockcache
    sock as long
    slot as long
end type

public wsapisock2usr as collection

' ====================================================================================
' ====================================================================================

public oldwproc as long
public actualwproc as long
public hwndmsg as long

' ====================================================================================
' ====================================================================================

public socklisten as long

#end if

' ====================================================================================
' ====================================================================================


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

public sub limpiawsapi()
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

public function buscaslotsock(byval s as long) as long
#if usarquesocket = 1 then

on error goto hayerror
    
    buscaslotsock = wsapisock2usr.item(cstr(s))
exit function
    
hayerror:
    buscaslotsock = -1
#end if

end function

public sub agregaslotsock(byval sock as long, byval slot as long)
debug.print "agregasockslot"
#if (usarquesocket = 1) then

if wsapisock2usr.count > maxusers then
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

public sub borraslotsock(byval sock as long)
#if (usarquesocket = 1) then
dim cant as long

cant = wsapisock2usr.count
on error resume next
wsapisock2usr.remove cstr(sock)

debug.print "borrasockslot " & cant & " -> " & wsapisock2usr.count

#end if
end sub



public function wndproc(byval hwnd as long, byval msg as long, byval wparam as long, byval lparam as long) as long
#if usarquesocket = 1 then

on error resume next

    dim ret as long
    dim tmp() as byte
    dim s as long
    dim e as long
    dim n as integer
    dim ulterror as long
    
    select case msg
        case 1025
            s = wparam
            e = wsagetselectevent(lparam)
            
            select case e
                case fd_accept
                    if s = socklisten then
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
            
            '        call intentarenviardatosencolados(n)
            '
            '        dale = userlist(n).colasalida.count > 0
            '        do while dale
            '            ret = wsapienviar(n, userlist(n).colasalida.item(1), false)
            '            if ret <> 0 then
            '                if ret = wsaewouldblock then
            '                    dale = false
            '                else
            '                    'y aca que hacemo' ?? help! i need somebody, help!
            '                    dale = false
            '                    debug.print "error al enviar el dato desde la cola " & ret & ": " & getwsaerrorstring(ret)
            '                end if
            '            else
            '            '    debug.print "dato de la cola enviado"
            '                userlist(n).colasalida.remove 1
            '                dale = (userlist(n).colasalida.count > 0)
            '            end if
            '        loop
        
                case fd_read
                    n = buscaslotsock(s)
                    if n < 0 and s <> socklisten then
                        'call apiclosesocket(s)
                        call wsapiclosesocket(s)
                        exit function
                    end if
                    
                    'create appropiate sized buffer
                    redim preserve tmp(size_rcvbuf - 1) as byte
                    
                    ret = recv(s, tmp(0), size_rcvbuf, 0)
                    ' comparo por = 0 ya que esto es cuando se cierra
                    ' "gracefully". (mas abajo)
                    if ret < 0 then
                        ulterror = err.lastdllerror
                        if ulterror = wsaemsgsize then
                            debug.print "wsaemsgsize"
                            ret = size_rcvbuf
                        else
                            debug.print "error en recv: " & getwsaerrorstring(ulterror)
                            call logapisock("error en recv: n=" & n & " s=" & s & " str=" & getwsaerrorstring(ulterror))
                            
                            'no hay q llamar a closesocket() directamente,
                            'ya q pueden abusar de algun error para
                            'desconectarse sin los 10segs. creeme.
                            call closesocketsl(n)
                            call cerrar_usuario(n)
                            exit function
                        end if
                    elseif ret = 0 then
                        call closesocketsl(n)
                        call cerrar_usuario(n)
                    end if
                    
                    redim preserve tmp(ret - 1) as byte
                    
                    call eventosockread(n, tmp)
                
                case fd_close
                    n = buscaslotsock(s)
                    if s <> socklisten then call apiclosesocket(s)
                    
                    if n > 0 then
                        call borraslotsock(s)
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
public function wsapienviar(byval slot as integer, byref str as string) as long
#if usarquesocket = 1 then
    dim ret as string
    dim retorno as long
    dim data() as byte
    
    redim preserve data(len(str) - 1) as byte

    data = strconv(str, vbfromunicode)
    
#if seguridadalkon then
    call security.datasent(slot, data)
#end if
    
    retorno = 0
    
    if userlist(slot).connid <> -1 and userlist(slot).connidvalida then
        ret = send(byval userlist(slot).connid, data(0), byval ubound(data()) + 1, byval 0)
        if ret < 0 then
            ret = err.lastdllerror
            if ret = wsaewouldblock then
                
#if seguridadalkon then
                call security.datastored(slot)
#end if
                
                ' wsaewouldblock, put the data again in the outgoingdata buffer
                call userlist(slot).outgoingdata.writeasciistringfixed(str)
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

public sub eventosockaccept(byval sockid as long)
#if usarquesocket = 1 then
'==========================================================
'uso de la api de winsock
'========================
    
    dim newindex as integer
    dim ret as long
    dim tam as long, sa as sockaddr
    dim nuevosock as long
    dim i as long
    dim str as string
    dim data() as byte
    
    tam = sockaddr_size
    
    '=============================================
    'sockid es en este caso es el socket de escucha,
    'a diferencia de socketwrench que es el nuevo
    'socket de la nueva conn
    
'modificado por maraxus
    'ret = wsaaccept(sockid, sa, tam, addressof condicionsocket, 0)
    ret = accept(sockid, sa, tam)

    if ret = invalid_socket then
        i = err.lastdllerror
        call logcriticevent("error en accept() api " & i & ": " & getwsaerrorstring(i))
        exit sub
    end if

    'if ret = invalid_socket then
    '    if err.lastdllerror = 11002 then
    '        ' we couldn't decide if to accept or reject the connection
    '        'force reject so we can get it out of the queue
    '        ret = wsaaccept(sockid, sa, tam, addressof condicionsocket, 1)
    '        call logcriticevent("error en wsaaccept() api 11002: no se pudo decidir si aceptar o rechazar la conexi�n.")
    '    else
    '        i = err.lastdllerror
    '        call logcriticevent("error en wsaaccept() api " & i & ": " & getwsaerrorstring(i))
    '        exit sub
    '    end if
    'end if

    nuevosock = ret
    
    if setsockopt(nuevosock, sol_socket, so_linger, 0, 4) <> 0 then
        i = err.lastdllerror
        call logcriticevent("error al setear lingers." & i & ": " & getwsaerrorstring(i))
    end if
    
    if not securityip.ipsecurityaceptarnuevaconexion(sa.sin_addr) then
        call wsapiclosesocket(nuevosock)
        exit sub
    end if
    
    if securityip.ipsecuritysuperalimiteconexiones(sa.sin_addr) then
        str = protocol.preparemessageerrormsg("limite de conexiones para su ip alcanzado.")
        
        redim preserve data(len(str) - 1) as byte
        
        data = strconv(str, vbfromunicode)
        
#if seguridadalkon then
        call security.datasent(security.no_slot, data)
#end if
        
        call send(byval nuevosock, data(0), byval ubound(data()) + 1, byval 0)
        call wsapiclosesocket(nuevosock)
        exit sub
    end if
    
    'seteamos el tama�o del buffer de entrada
    if setsockopt(nuevosock, sol_socket, so_rcvbuffer, size_rcvbuf, 4) <> 0 then
        i = err.lastdllerror
        call logcriticevent("error al setear el tama�o del buffer de entrada " & i & ": " & getwsaerrorstring(i))
    end if
    'seteamos el tama�o del buffer de salida
    if setsockopt(nuevosock, sol_socket, so_sndbuffer, size_sndbuf, 4) <> 0 then
        i = err.lastdllerror
        call logcriticevent("error al setear el tama�o del buffer de salida " & i & ": " & getwsaerrorstring(i))
    end if
    
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '   bienvenido al servidor!!!!!!!!
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    
    'mariano: baje la busqueda de slot abajo de condicionsocket y limite x ip
    newindex = nextopenuser ' nuevo indice
    
    if newindex <= maxusers then
        
        'make sure both outgoing and incoming data buffers are clean
        call userlist(newindex).incomingdata.readasciistringfixed(userlist(newindex).incomingdata.length)
        call userlist(newindex).outgoingdata.readasciistringfixed(userlist(newindex).outgoingdata.length)

#if seguridadalkon then
        call security.newconnection(newindex)
#end if
        
        userlist(newindex).ip = getascip(sa.sin_addr)
        'busca si esta banneada la ip
        for i = 1 to banips.count
            if banips.item(i) = userlist(newindex).ip then
                'call apiclosesocket(nuevosock)
                call writeerrormsg(newindex, "su ip se encuentra bloqueada en este servidor.")
                call flushbuffer(newindex)
                call securityip.iprestarconexion(sa.sin_addr)
                call wsapiclosesocket(nuevosock)
                exit sub
            end if
        next i
        
        if newindex > lastuser then lastuser = newindex
        
        userlist(newindex).connid = nuevosock
        userlist(newindex).connidvalida = true
        
        call agregaslotsock(nuevosock, newindex)
    else
        str = protocol.preparemessageerrormsg("el servidor se encuentra lleno en este momento. disculpe las molestias ocasionadas.")
        
        redim preserve data(len(str) - 1) as byte
        
        data = strconv(str, vbfromunicode)
        
#if seguridadalkon then
        call security.datasent(security.no_slot, data)
#end if
        
        call send(byval nuevosock, data(0), byval ubound(data()) + 1, byval 0)
        call wsapiclosesocket(nuevosock)
    end if
    
#end if
end sub

public sub eventosockread(byval slot as integer, byref datos() as byte)
#if usarquesocket = 1 then

with userlist(slot)
    
#if seguridadalkon then
    call security.datareceived(slot, datos)
#end if
    
    call .incomingdata.writeblock(datos)
    
    if .connid <> -1 then
        call handleincomingdata(slot)
    else
        exit sub
    end if
end with

#end if
end sub

public sub eventosockclose(byval slot as integer)
#if usarquesocket = 1 then

    'es el mismo user al que est� revisando el centinela??
    'si estamos ac� es porque se cerr� la conexi�n, no es un /salir, y no queremos banearlo....
    dim centinelaindex as byte
    centinelaindex = userlist(slot).flags.centinelaindex
        
    if centinelaindex <> 0 then
        call modcentinela.centinelauserlogout(centinelaindex)
    end if
    
#if seguridadalkon then
    call security.userdisconnected(slot)
#end if
    
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
    
    for i = 1 to maxusers
        set userlist(i).incomingdata = nothing
        set userlist(i).outgoingdata = nothing
    next i
    
    ' no 'ta el preserve :p
    redim userlist(1 to maxusers)
    for i = 1 to maxusers
        userlist(i).connid = -1
        userlist(i).connidvalida = false
        
        set userlist(i).incomingdata = new clsbytequeue
        set userlist(i).outgoingdata = new clsbytequeue
    next i
    
    lastuser = 1
    numusers = 0
    
    call limpiawsapi
    call sleep(100)
    call iniciawsapi(frmmain.hwnd)
    socklisten = listenforconnect(puerto, hwndmsg, "")


#end if
end sub

public sub wsapiclosesocket(byval socket as long)
#if usarquesocket = 1 then
call wsaasyncselect(socket, hwndmsg, byval 1025, byval (fd_close))
call shutdown(socket, sd_both)
#end if
end sub

public function condicionsocket(byref lpcallerid as wsabuf, byref lpcallerdata as wsabuf, byref lpsqos as flowspec, byval reserved as long, byref lpcalleeid as wsabuf, byref lpcalleedata as wsabuf, byref group as long, byval dwcallbackdata as long) as long
#if usarquesocket = 1 then
    dim sa as sockaddr
    
    'check if we were requested to force reject

    if dwcallbackdata = 1 then
        condicionsocket = cf_reject
        exit function
    end if
    
     'get the address

    copymemory sa, byval lpcallerid.lpbuffer, lpcallerid.dwbufferlen

    
    if not securityip.ipsecurityaceptarnuevaconexion(sa.sin_addr) then
        condicionsocket = cf_reject
        exit function
    end if

    condicionsocket = cf_accept 'en realdiad es al pedo, porque condicionsocket se inicializa a 0, pero as� es m�s claro....
#end if
end function
