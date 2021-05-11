attribute vb_name = "tcp"
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

'buffer en bytes de cada socket
public const socket_buffer_size = 2048

'cuantos comandos de cada cliente guarda el server
public const command_buffer_size = 1000

public const ningunarma = 2

'rutas de envio de datos
public const toindex = 0 'envia a un solo user
public const toall = 1 'a todos los users
public const tomap = 2 'todos los usuarios en el mapa
public const topcarea = 3 'todos los users en el area de un user determinado
public const tonone = 4 'ninguno
public const toallbutindex = 5 'todos menos el index
public const tomapbutindex = 6 'todos en el mapa menos el indice
public const togm = 7
public const tonpcarea = 8 'todos los users en el area de un user determinado
public const toguildmembers = 9
public const toadmins = 10
public const topcareabutindex = 11

#if not (usarapi = 1) then
' general constants used with most of the controls
public const invalid_handle = -1
public const control_errignore = 0
public const control_errdisplay = 1


' societwrench control actions
public const socket_open = 1
public const socket_connect = 2
public const socket_listen = 3
public const socket_accept = 4
public const socket_cancel = 5
public const socket_flush = 6
public const socket_close = 7
public const socket_disconnect = 7
public const socket_abort = 8

' socketwrench control states
public const socket_none = 0
public const socket_idle = 1
public const socket_listening = 2
public const socket_connecting = 3
public const socket_accepting = 4
public const socket_receiving = 5
public const socket_sending = 6
public const socket_closing = 7

' societ address families
public const af_unspec = 0
public const af_unix = 1
public const af_inet = 2

' societ types
public const sock_stream = 1
public const sock_dgram = 2
public const sock_raw = 3
public const sock_rdm = 4
public const sock_seqpacket = 5

' protocol types
public const ipproto_ip = 0
public const ipproto_icmp = 1
public const ipproto_ggp = 2
public const ipproto_tcp = 6
public const ipproto_pup = 12
public const ipproto_udp = 17
public const ipproto_idp = 22
public const ipproto_nd = 77
public const ipproto_raw = 255
public const ipproto_max = 256


' network addpesses
public const inaddr_any = "0.0.0.0"
public const inaddr_loopback = "127.0.0.1"
public const inaddr_none = "255.055.255.255"

' shutdown values
public const socket_read = 0
public const socket_write = 1
public const socket_readwrite = 2

' socketwrench error pesponse
public const socket_errignore = 0
public const socket_errdisplay = 1

' socketwrench error aodes
public const wsabaseerr = 24000
public const wsaeintr = 24004
public const wsaebadf = 24009
public const wsaeacces = 24013
public const wsaefault = 24014
public const wsaeinval = 24022
public const wsaemfile = 24024
public const wsaewouldblock = 24035
public const wsaeinprogress = 24036
public const wsaealready = 24037
public const wsaenotsock = 24038
public const wsaedestaddrreq = 24039
public const wsaemsgsize = 24040
public const wsaeprototype = 24041
public const wsaenoprotoopt = 24042
public const wsaeprotonosupport = 24043
public const wsaesocktnosupport = 24044
public const wsaeopnotsupp = 24045
public const wsaepfnosupport = 24046
public const wsaeafnosupport = 24047
public const wsaeaddrinuse = 24048
public const wsaeaddrnotavail = 24049
public const wsaenetdown = 24050
public const wsaenetunreach = 24051
public const wsaenetreset = 24052
public const wsaeconnaborted = 24053
public const wsaeconnreset = 24054
public const wsaenobufs = 24055
public const wsaeisconn = 24056
public const wsaenotconn = 24057
public const wsaeshutdown = 24058
public const wsaetoomanyrefs = 24059
public const wsaetimedout = 24060
public const wsaeconnrefused = 24061
public const wsaeloop = 24062
public const wsaenametoolong = 24063
public const wsaehostdown = 24064
public const wsaehostunreach = 24065
public const wsaenotempty = 24066
public const wsaeproclim = 24067
public const wsaeusers = 24068
public const wsaedquot = 24069
public const wsaestale = 24070
public const wsaeremote = 24071
public const wsasysnotready = 24091
public const wsavernotsupported = 24092
public const wsanotinitialised = 24093
public const wsahost_not_found = 25001
public const wsatry_again = 25002
public const wsano_recovery = 25003
public const wsano_data = 25004
public const wsano_address = 2500
#end if

'esta funcion calcula el crc de cada paquete que se
'env�a al servidor.

public function gencrc(byval key as long, byval sddata as string) as long

end function



sub darcuerpoycabeza(userbody as integer, userhead as integer, raza as string, gen as string)

select case gen
   case "hombre"
        select case raza
        
                case "humano"
                    userhead = cint(randomnumber(1, 11))
                    if userhead > 11 then userhead = 11
                    userbody = 1
                case "elfo"
                    userhead = cint(randomnumber(1, 4)) + 100
                    if userhead > 104 then userhead = 104
                    userbody = 2
                case "elfo oscuro"
                    userhead = cint(randomnumber(1, 3)) + 200
                    if userhead > 203 then userhead = 203
                    userbody = 3
                case "enano"
                    userhead = randomnumber(1, 1) + 300
                    if userhead > 301 then userhead = 301
                    userbody = 52
                case "gnomo"
                    userhead = randomnumber(1, 1) + 400
                    if userhead > 401 then userhead = 401
                    userbody = 52
                case else
                    userhead = 1
                    userbody = 1
            
        end select
   case "mujer"
        select case raza
                case "humano"
                    userhead = cint(randomnumber(1, 3)) + 69
                    if userhead > 72 then userhead = 72
                    userbody = 1
                case "elfo"
                    userhead = cint(randomnumber(1, 3)) + 169
                    if userhead > 172 then userhead = 172
                    userbody = 2
                case "elfo oscuro"
                    userhead = cint(randomnumber(1, 3)) + 269
                    if userhead > 272 then userhead = 272
                    userbody = 3
                case "gnomo"
                    userhead = randomnumber(1, 2) + 469
                    if userhead > 471 then userhead = 471
                    userbody = 52
                case "enano"
                    userhead = 370
                    userbody = 52
                case else
                    userhead = 70
                    userbody = 1
        end select
end select

   
end sub

function asciivalidos(byval cad as string) as boolean
dim car as byte
dim i as integer

cad = lcase$(cad)

for i = 1 to len(cad)
    car = asc(mid$(cad, i, 1))
    
    if (car < 97 or car > 122) and (car <> 255) and (car <> 32) then
        asciivalidos = false
        exit function
    end if
    
next i

asciivalidos = true

end function

function numeric(byval cad as string) as boolean
dim car as byte
dim i as integer

cad = lcase$(cad)

for i = 1 to len(cad)
    car = asc(mid$(cad, i, 1))
    
    if (car < 48 or car > 57) then
        numeric = false
        exit function
    end if
    
next i

numeric = true

end function


function nombrepermitido(byval nombre as string) as boolean
dim i as integer

for i = 1 to ubound(forbidennames)
    if instr(nombre, forbidennames(i)) then
            nombrepermitido = false
            exit function
    end if
next i

nombrepermitido = true

end function

function validateatrib(byval userindex as integer) as boolean
dim loopc as integer

for loopc = 1 to numatributos
    if userlist(userindex).stats.useratributos(loopc) > 18 or userlist(userindex).stats.useratributos(loopc) < 1 then exit function
next loopc

validateatrib = true

end function

function validateskills(byval userindex as integer) as boolean

dim loopc as integer

for loopc = 1 to numskills
    if userlist(userindex).stats.userskills(loopc) < 0 then
        exit function
        if userlist(userindex).stats.userskills(loopc) > 100 then userlist(userindex).stats.userskills(loopc) = 100
    end if
next loopc

validateskills = true
    

end function

sub connectnewuser(userindex as integer, name as string, password as string, body as integer, head as integer, userraza as string, usersexo as string, userclase as string, _
ua1 as string, ua2 as string, ua3 as string, ua4 as string, ua5 as string, _
us1 as string, us2 as string, us3 as string, us4 as string, us5 as string, _
us6 as string, us7 as string, us8 as string, us9 as string, us10 as string, _
us11 as string, us12 as string, us13 as string, us14 as string, us15 as string, _
us16 as string, us17 as string, us18 as string, us19 as string, us20 as string, _
us21 as string, useremail as string, hogar as string)

if not nombrepermitido(name) then
    call senddata(toindex, userindex, 0, "errlos nombres de los personajes deben pertencer a la fantasia, el nombre indicado es invalido.")
    exit sub
end if

if not asciivalidos(name) then
    call senddata(toindex, userindex, 0, "errnombre invalido.")
    exit sub
end if

dim loopc as integer
dim totalskpts as long
  
'�existe el personaje?
if fileexist(charpath & ucase$(name) & ".chr", vbnormal) = true then
    call senddata(toindex, userindex, 0, "errya existe el personaje.")
    exit sub
end if

userlist(userindex).flags.muerto = 0
userlist(userindex).flags.escondido = 0



userlist(userindex).reputacion.asesinorep = 0
userlist(userindex).reputacion.bandidorep = 0
userlist(userindex).reputacion.burguesrep = 0
userlist(userindex).reputacion.ladronesrep = 0
userlist(userindex).reputacion.noblerep = 1000
userlist(userindex).reputacion.pleberep = 30

userlist(userindex).reputacion.promedio = 30 / 6


userlist(userindex).name = name
userlist(userindex).clase = userclase
userlist(userindex).raza = userraza
userlist(userindex).genero = usersexo
userlist(userindex).email = useremail
userlist(userindex).hogar = hogar

'userlist(userindex).stats.useratributos(fuerza) = abs(cint(ua1))
'userlist(userindex).stats.useratributos(inteligencia) = abs(cint(ua2))
'userlist(userindex).stats.useratributos(agilidad) = abs(cint(ua3))
'userlist(userindex).stats.useratributos(carisma) = abs(cint(ua4))
'userlist(userindex).stats.useratributos(constitucion) = abs(cint(ua5))


'%%%%%%%%%%%%% prevenir hackeo de los atributos %%%%%%%%%%%%%
if not validateatrib(userindex) then
        call senddata(toindex, userindex, 0, "erratributos invalidos.")
        exit sub
end if
'%%%%%%%%%%%%% prevenir hackeo de los atributos %%%%%%%%%%%%%

select case ucase$(userraza)
    case "humano"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 2
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 1
        userlist(userindex).stats.useratributos(constitucion) = userlist(userindex).stats.useratributos(constitucion) + 2
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 1
    case "elfo"
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 2
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 2
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) + 2
    case "elfo oscuro"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 1
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 2
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 2
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) + 2
    case "enano"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 3
        userlist(userindex).stats.useratributos(constitucion) = userlist(userindex).stats.useratributos(constitucion) + 3
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) - 6
    case "gnomo"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) - 5
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 3
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 3
end select



userlist(userindex).stats.userskills(1) = val(us1)
userlist(userindex).stats.userskills(2) = val(us2)
userlist(userindex).stats.userskills(3) = val(us3)
userlist(userindex).stats.userskills(4) = val(us4)
userlist(userindex).stats.userskills(5) = val(us5)
userlist(userindex).stats.userskills(6) = val(us6)
userlist(userindex).stats.userskills(7) = val(us7)
userlist(userindex).stats.userskills(8) = val(us8)
userlist(userindex).stats.userskills(9) = val(us9)
userlist(userindex).stats.userskills(10) = val(us10)
userlist(userindex).stats.userskills(11) = val(us11)
userlist(userindex).stats.userskills(12) = val(us12)
userlist(userindex).stats.userskills(13) = val(us13)
userlist(userindex).stats.userskills(14) = val(us14)
userlist(userindex).stats.userskills(15) = val(us15)
userlist(userindex).stats.userskills(16) = val(us16)
userlist(userindex).stats.userskills(17) = val(us17)
userlist(userindex).stats.userskills(18) = val(us18)
userlist(userindex).stats.userskills(19) = val(us19)
userlist(userindex).stats.userskills(20) = val(us20)
userlist(userindex).stats.userskills(21) = val(us21)

totalskpts = 0

'abs previnene el hackeo de los skills %%%%%%%%%%%%%
for loopc = 1 to numskills
    totalskpts = totalskpts + abs(userlist(userindex).stats.userskills(loopc))
next loopc


if totalskpts > 10 then
    call loghackattemp(userlist(userindex).name & " intento hackear los skills.")
    call borrarusuario(userlist(userindex).name)
    call closesocket(userindex)
    exit sub
end if
'%%%%%%%%%%%%% prevenir hackeo de los skills %%%%%%%%%%%%%

userlist(userindex).password = password
userlist(userindex).char.heading = south

call randomize(timer)
call darcuerpoycabeza(userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).raza, userlist(userindex).genero)
userlist(userindex).origchar = userlist(userindex).char
   
 
userlist(userindex).char.weaponanim = ningunarma
userlist(userindex).char.shieldanim = ningunescudo
userlist(userindex).char.cascoanim = ninguncasco

userlist(userindex).stats.met = 1
dim miint
miint = randomnumber(1, userlist(userindex).stats.useratributos(constitucion) \ 3)

userlist(userindex).stats.maxhp = 15 + miint
userlist(userindex).stats.minhp = 15 + miint

userlist(userindex).stats.fit = 1


miint = randomnumber(1, userlist(userindex).stats.useratributos(agilidad) \ 6)
if miint = 1 then miint = 2

userlist(userindex).stats.maxsta = 20 * miint
userlist(userindex).stats.minsta = 20 * miint


userlist(userindex).stats.maxagu = 100
userlist(userindex).stats.minagu = 100

userlist(userindex).stats.maxham = 100
userlist(userindex).stats.minham = 100


'<-----------------mana----------------------->
if userclase = "mago" then
    miint = randomnumber(1, userlist(userindex).stats.useratributos(inteligencia)) / 3
    userlist(userindex).stats.maxman = 100 + miint
    userlist(userindex).stats.minman = 100 + miint
elseif userclase = "clerigo" or userclase = "druida" _
    or userclase = "bardo" or userclase = "asesino" then
        miint = randomnumber(1, userlist(userindex).stats.useratributos(inteligencia)) / 4
        userlist(userindex).stats.maxman = 50
        userlist(userindex).stats.minman = 50
else
    userlist(userindex).stats.maxman = 0
    userlist(userindex).stats.minman = 0
end if

if userclase = "mago" or userclase = "clerigo" or _
   userclase = "druida" or userclase = "bardo" or _
   userclase = "asesino" then
        userlist(userindex).stats.userhechizos(1) = 2
end if

userlist(userindex).stats.maxhit = 2
userlist(userindex).stats.minhit = 1

userlist(userindex).stats.gld = 0




userlist(userindex).stats.exp = 0
userlist(userindex).stats.elu = 300
userlist(userindex).stats.elv = 1


'???????????????? inventario ��������������������
userlist(userindex).invent.nroitems = 4

userlist(userindex).invent.object(1).objindex = 467
userlist(userindex).invent.object(1).amount = 100

userlist(userindex).invent.object(2).objindex = 468
userlist(userindex).invent.object(2).amount = 100

userlist(userindex).invent.object(3).objindex = 460
userlist(userindex).invent.object(3).amount = 1
userlist(userindex).invent.object(3).equipped = 1

select case userraza
    case "humano"
        userlist(userindex).invent.object(4).objindex = 463
    case "elfo"
        userlist(userindex).invent.object(4).objindex = 464
    case "elfo oscuro"
        userlist(userindex).invent.object(4).objindex = 465
    case "enano"
        userlist(userindex).invent.object(4).objindex = 466
    case "gnomo"
        userlist(userindex).invent.object(4).objindex = 466
end select

userlist(userindex).invent.object(4).amount = 1
userlist(userindex).invent.object(4).equipped = 1

'userlist(userindex).invent.object(5).objindex = 461
'userlist(userindex).invent.object(5).amount = 50
'
'userlist(userindex).invent.object(6).objindex = 462
'userlist(userindex).invent.object(6).amount = 50

userlist(userindex).invent.armoureqpslot = 4
userlist(userindex).invent.armoureqpobjindex = userlist(userindex).invent.object(4).objindex

userlist(userindex).invent.weaponeqpobjindex = userlist(userindex).invent.object(3).objindex
userlist(userindex).invent.weaponeqpslot = 3



call saveuser(userindex, charpath & ucase$(name) & ".chr")
  
'open user
call connectuser(userindex, name, password)
  
end sub

sub closesocket(byval userindex as integer)
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

'call logtarea("close socket")

#if not (usarapi = 1) then
on error goto errhandler
#end if

    
    call ados.restarconexion(userlist(userindex).ip)
    
    if userlist(userindex).flags.userlogged then
            if numusers <> 0 then numusers = numusers - 1
            call closeuser(userindex)
            
            call estadisticasweb.informar(cantidad_online, numusers)
    end if
    
    #if usarapi then
    
    if userlist(userindex).connid <> -1 then
        call apiclosesocket(userlist(userindex).connid)
    end if
    
    #else
    
    'frmmain.socket2(userindex).disconnect
    frmmain.socket2(userindex).cleanup
    unload frmmain.socket2(userindex)
    
    #end if
    
    userlist(userindex).connid = -1
    userlist(userindex).numeropaquetespormilisec = 0
            
    call resetuserslot(userindex)

exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).numeropaquetespormilisec = 0
'    unload frmmain.socket2(userindex) ojooooooooooooooooo
'    if numusers > 0 then numusers = numusers - 1
    call resetuserslot(userindex)
    
    #if usarapi then
    if userlist(userindex).connid <> -1 then
        call apiclosesocket(userlist(userindex).connid)
    end if
    #end if
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
    
end sub


sub closesocket_nueva(byval userindex as integer)
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

'call logtarea("close socket")

on error goto errhandler
    

    
    call ados.restarconexion(frmmain.socket2(userindex).peeraddress)
    
    'userlist(userindex).connid = -1
    'userlist(userindex).numeropaquetespormilisec = 0
            
    if userlist(userindex).flags.userlogged then
        if numusers <> 0 then numusers = numusers - 1
        call closeuser(userindex)
        userlist(userindex).connid = -1: userlist(userindex).numeropaquetespormilisec = 0
        frmmain.socket2(userindex).disconnect
        frmmain.socket2(userindex).cleanup
        'unload frmmain.socket2(userindex)
        call resetuserslot(userindex)
        'call cerrar_usuario(userindex)
    else
        userlist(userindex).connid = -1
        userlist(userindex).numeropaquetespormilisec = 0
        
        frmmain.socket2(userindex).disconnect
        frmmain.socket2(userindex).cleanup
        call resetuserslot(userindex)
        'unload frmmain.socket2(userindex)
    end if

exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).numeropaquetespormilisec = 0
'    unload frmmain.socket2(userindex) ojooooooooooooooooo
'    if numusers > 0 then numusers = numusers - 1
    call resetuserslot(userindex)
    
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
    
end sub


sub senddata(sndroute as byte, sndindex as integer, sndmap as integer, snddata as string)


on error resume next

dim loopc as integer
dim x as integer
dim y as integer
dim aux$
dim dec$
dim nfile as integer
dim ret as long

snddata = snddata & endc



select case sndroute


    case tonone
        exit sub
        
    case toadmins
        for loopc = 1 to lastuser
            if userlist(loopc).connid > -1 then
               if esdios(userlist(loopc).name) or essemidios(userlist(loopc).name) then
                        'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                        #if usarapi then
                        call wsapienviar(loopc, snddata)
                        #else
                        frmmain.socket2(loopc).write snddata, len(snddata)
                        #end if
               end if
            end if
        next loopc
        exit sub
        
    case toall
        for loopc = 1 to lastuser
            if userlist(loopc).connid > -1 then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
                    #if usarapi then
                    call wsapienviar(loopc, snddata)
                    #else
                    frmmain.socket2(loopc).write snddata, len(snddata)
                    #end if
                end if
            end if
        next loopc
        exit sub
    
    case toallbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid > -1) and (loopc <> sndindex) then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
                    #if usarapi then
                    call wsapienviar(loopc, snddata)
                    #else
                    frmmain.socket2(loopc).write snddata, len(snddata)
                    #end if
                end if
            end if
        next loopc
        exit sub
    
    case tomap
        for loopc = 1 to lastuser
            if (userlist(loopc).connid > -1) then
                if userlist(loopc).flags.userlogged then
                    if userlist(loopc).pos.map = sndmap then
                        'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                        'frmmain.socket2(loopc).write snddata, len(snddata)
                        #if usarapi then
                        call wsapienviar(loopc, snddata)
                        #else
                        frmmain.socket2(loopc).write snddata, len(snddata)
                        #end if
                    end if
                end if
            end if
        next loopc
        exit sub
      
    case tomapbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid > -1) and loopc <> sndindex then
                if userlist(loopc).pos.map = sndmap then
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
                        #if usarapi then
                        call wsapienviar(loopc, snddata)
                        #else
                        frmmain.socket2(loopc).write snddata, len(snddata)
                        #end if
                end if
            end if
        next loopc
        exit sub
            
    case toguildmembers
        for loopc = 1 to lastuser
            if (userlist(loopc).connid > -1) then
                if userlist(sndindex).guildinfo.guildname = userlist(loopc).guildinfo.guildname then
                        'frmmain.socket2(loopc).write snddata, len(snddata)
                        #if usarapi then
                        call wsapienviar(loopc, snddata)
                        #else
                        frmmain.socket2(loopc).write snddata, len(snddata)
                        #end if
                end if
            end if
        next loopc
        exit sub
    
    case topcarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid > -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #if usarapi then
                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
                            #else
                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    '[alejo-18-5]
    case topcareabutindex
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) and (mapdata(sndmap, x, y).userindex <> sndindex) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid > -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #if usarapi then
                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
                            #else
                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case tonpcarea
        for y = npclist(sndindex).pos.y - minyborder + 1 to npclist(sndindex).pos.y + minyborder - 1
            for x = npclist(sndindex).pos.x - minxborder + 1 to npclist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid > -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #if usarapi then
                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
                            #else
                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
                            #end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case toindex
        if userlist(sndindex).connid > -1 then
             'call addtovar(userlist(sndindex).bytestransmitidossvr, lenb(snddata), 100000)
             'frmmain.socket2(sndindex).write snddata, len(snddata)
             #if usarapi then
             call wsapienviar(sndindex, snddata)
             #else
             frmmain.socket2(sndindex).write snddata, len(snddata)
             #end if
             exit sub
        end if

end select

end sub
function estapcarea(index as integer, index2 as integer) as boolean


dim x as integer, y as integer
for y = userlist(index).pos.y - minyborder + 1 to userlist(index).pos.y + minyborder - 1
        for x = userlist(index).pos.x - minxborder + 1 to userlist(index).pos.x + minxborder - 1

            if mapdata(userlist(index).pos.map, x, y).userindex = index2 then
                estapcarea = true
                exit function
            end if
        
        next x
next y
estapcarea = false
end function

function haypcarea(pos as worldpos) as boolean


dim x as integer, y as integer
for y = pos.y - minyborder + 1 to pos.y + minyborder - 1
        for x = pos.x - minxborder + 1 to pos.x + minxborder - 1
            if x > 0 and y > 0 and x < 101 and y < 101 then
                if mapdata(pos.map, x, y).userindex > 0 then
                    haypcarea = true
                    exit function
                end if
            end if
        next x
next y
haypcarea = false
end function

function hayobjarea(pos as worldpos, objindex as integer) as boolean


dim x as integer, y as integer
for y = pos.y - minyborder + 1 to pos.y + minyborder - 1
        for x = pos.x - minxborder + 1 to pos.x + minxborder - 1
            if mapdata(pos.map, x, y).objinfo.objindex = objindex then
                hayobjarea = true
                exit function
            end if
        
        next x
next y
hayobjarea = false
end function

sub corregirskills(byval userindex as integer)
dim k as integer

for k = 1 to numskills
  if userlist(userindex).stats.userskills(k) > maxskillpoints then userlist(userindex).stats.userskills(k) = maxskillpoints
next

for k = 1 to numatributos
 if userlist(userindex).stats.useratributos(k) > maxatributos then
    call senddata(toindex, userindex, 0, "errel personaje tiene atributos invalidos.")
    exit sub
 end if
next k
 
end sub


function validatechr(byval userindex as integer) as boolean

validatechr = userlist(userindex).char.head <> 0 and _
userlist(userindex).char.body <> 0 and validateskills(userindex)

end function

sub connectuser(byval userindex as integer, name as string, password as string)
dim n as integer

'reseteamos los flags
userlist(userindex).flags.escondido = 0
userlist(userindex).flags.targetnpc = 0
userlist(userindex).flags.targetnpctipo = 0
userlist(userindex).flags.targetobj = 0
userlist(userindex).flags.targetuser = 0
userlist(userindex).char.fx = 0



'controlamos no pasar el maximo de usuarios
if numusers >= maxusers then
    call senddata(toindex, userindex, 0, "errel servidor ha alcanzado el maximo de usuarios soportado, por favor vuelva a intertarlo mas tarde.")
    call closesocket(userindex)
    exit sub
end if
  
'�este ip ya esta conectado?
if allowmultilogins = 0 then
    if checkforsameip(userindex, userlist(userindex).ip) = true then
        call senddata(toindex, userindex, 0, "errno es posible usar mas de un personaje al mismo tiempo.")
        call closesocket(userindex)
        exit sub
    end if
end if

'�ya esta conectado el personaje?
if checkforsamename(userindex, name) = true then
    call senddata(toindex, userindex, 0, "errperdon, un usuario con el mismo nombre se h� logoeado.")
    call closesocket(userindex)
    exit sub
end if

'�existe el personaje?
if fileexist(charpath & ucase$(name) & ".chr", vbnormal) = false then
    call senddata(toindex, userindex, 0, "errel personaje no existe.")
    call closesocket(userindex)
    exit sub
end if

'�es el passwd valido?
if ucase$(password) <> ucase$(getvar(charpath & ucase$(name) & ".chr", "init", "password")) then
    call senddata(toindex, userindex, 0, "errpassword incorrecto.")
    'call frmmain.socket2(userindex).disconnect
    call closesocket(userindex)
    exit sub
end if

'cargamos los datos del personaje
call loaduserinit(userindex, charpath & ucase$(name) & ".chr")
call loaduserstats(userindex, charpath & ucase$(name) & ".chr")
'call corregirskills(userindex)

if not validatechr(userindex) then
    call senddata(toindex, userindex, 0, "errerror en el personaje.")
    call closesocket(userindex)
    exit sub
end if

call loaduserreputacion(userindex, charpath & ucase$(name) & ".chr")


if userlist(userindex).invent.escudoeqpslot = 0 then userlist(userindex).char.shieldanim = ningunescudo
if userlist(userindex).invent.cascoeqpslot = 0 then userlist(userindex).char.cascoanim = ninguncasco
if userlist(userindex).invent.weaponeqpslot = 0 then userlist(userindex).char.weaponanim = ningunarma


call updateuserinv(true, userindex, 0)
call updateuserhechizos(true, userindex, 0)

if userlist(userindex).flags.navegando = 1 then
     userlist(userindex).char.body = objdata(userlist(userindex).invent.barcoobjindex).ropaje
     userlist(userindex).char.head = 0
     userlist(userindex).char.weaponanim = ningunarma
     userlist(userindex).char.shieldanim = ningunescudo
     userlist(userindex).char.cascoanim = ninguncasco
end if


if userlist(userindex).flags.paralizado then call senddata(toindex, userindex, 0, "paradok")

'posicion de comienzo
if userlist(userindex).pos.map = 0 then
    if ucase$(userlist(userindex).hogar) = "nix" then
             userlist(userindex).pos = nix
    elseif ucase$(userlist(userindex).hogar) = "ullathorpe" then
             userlist(userindex).pos = ullathorpe
    elseif ucase$(userlist(userindex).hogar) = "banderbill" then
             userlist(userindex).pos = banderbill
    elseif ucase$(userlist(userindex).hogar) = "lindos" then
             userlist(userindex).pos = lindos
    else
        userlist(userindex).hogar = "ullathorpe"
        userlist(userindex).pos = ullathorpe
    end if
else
   
   if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex <> 0 then call closesocket(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex)
   
end if

'nombre de sistema
userlist(userindex).name = name

userlist(userindex).password = password
'userlist(userindex).ip = frmmain.socket2(userindex).peeraddress
  
'info
call senddata(toindex, userindex, 0, "iu" & userindex) 'enviamos el user index
call senddata(toindex, userindex, 0, "cm" & userlist(userindex).pos.map & "," & mapinfo(userlist(userindex).pos.map).mapversion) 'carga el mapa
call senddata(toindex, userindex, 0, "tm" & mapinfo(userlist(userindex).pos.map).music)

if lloviendo then call senddata(toindex, userindex, 0, "llu")

call updateusermap(userindex)
call senduserstatsbox(userindex)
call enviarhambreysed(userindex)

call sendmotd(userindex)

if haciendobk then
    call senddata(toindex, userindex, 0, "bkw")
    call senddata(toindex, userindex, 0, "||por favor espera algunos segundo, worldsave esta ejecutandose." & fonttype_info)
end if

'actualiza el num de usuarios
if userindex > lastuser then lastuser = userindex

numusers = numusers + 1
call estadisticasweb.informar(cantidad_online, numusers)

userlist(userindex).flags.userlogged = true

mapinfo(userlist(userindex).pos.map).numusers = mapinfo(userlist(userindex).pos.map).numusers + 1

if userlist(userindex).stats.skillpts > 0 then
    call enviarskills(userindex)
    call enviarsubirnivel(userindex, userlist(userindex).stats.skillpts)
end if

if numusers > daystats.maxusuarios then daystats.maxusuarios = numusers

if numusers > recordusuarios then
    call senddata(toall, 0, 0, "||record de usuarios conectados simultaniamente." & "hay " & numusers & " usuarios." & fonttype_info)
    recordusuarios = numusers
    call writevar(inipath & "server.ini", "init", "record", str(recordusuarios))
    
    call estadisticasweb.informar(record_usuarios, recordusuarios)
end if

if esdios(name) then
    userlist(userindex).flags.privilegios = 3
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif essemidios(name) then
    userlist(userindex).flags.privilegios = 2
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif esconsejero(name) then
    userlist(userindex).flags.privilegios = 1
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, true)
else
    userlist(userindex).flags.privilegios = 0
end if

set userlist(userindex).guildref = fetchguild(userlist(userindex).guildinfo.guildname)

userlist(userindex).counters.idlecount = 0

if userlist(userindex).nromacotas > 0 then
    dim i as integer
    for i = 1 to maxmascotas
        if userlist(userindex).mascotastype(i) > 0 then
            userlist(userindex).mascotasindex(i) = spawnnpc(userlist(userindex).mascotastype(i), userlist(userindex).pos, true, true)
            
            if userlist(userindex).mascotasindex(i) <= maxnpcs then
                  npclist(userlist(userindex).mascotasindex(i)).maestrouser = userindex
                  call followamo(userlist(userindex).mascotasindex(i))
            else
                  userlist(userindex).mascotasindex(i) = 0
            end if
        end if
    next i
end if


if userlist(userindex).flags.navegando = 1 then call senddata(toindex, userindex, 0, "naveg")

userlist(userindex).flags.seguro = true

'crea  el personaje del usuario
call makeuserchar(tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
call senddata(toindex, userindex, 0, "ip" & userlist(userindex).char.charindex)
call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxwarp & "," & 0)
call senddata(toindex, userindex, 0, "logged")

call sendguildnews(userindex)


call mostrarnumusers

n = freefile
open app.path & "\logs\numusers.log" for output as n
print #n, numusers
close #n

n = freefile
'log
open app.path & "\logs\connect.log" for append shared as #n
print #n, userlist(userindex).name & " ha entrado al juego. userindex:" & userindex & " " & time & " " & date
close #n

end sub

sub sendmotd(byval userindex as integer)
dim j as integer
call senddata(toindex, userindex, 0, "||message of the day:" & fonttype_info)
for j = 1 to maxlines
    call senddata(toindex, userindex, 0, "||" & motd(j).texto)
next j
end sub

sub resetfacciones(byval userindex as integer)

userlist(userindex).faccion.armadareal = 0
userlist(userindex).faccion.fuerzascaos = 0
userlist(userindex).faccion.ciudadanosmatados = 0
userlist(userindex).faccion.criminalesmatados = 0
userlist(userindex).faccion.recibioarmaduracaos = 0
userlist(userindex).faccion.recibioarmadurareal = 0
userlist(userindex).faccion.recibioexpinicialcaos = 0
userlist(userindex).faccion.recibioexpinicialreal = 0
userlist(userindex).faccion.recompensascaos = 0
userlist(userindex).faccion.recompensasreal = 0

end sub

sub resetcontadores(byval userindex as integer)

userlist(userindex).counters.aguacounter = 0
userlist(userindex).counters.attackcounter = 0
userlist(userindex).counters.ceguera = 0
userlist(userindex).counters.comcounter = 0
userlist(userindex).counters.estupidez = 0
userlist(userindex).counters.frio = 0
userlist(userindex).counters.hpcounter = 0
userlist(userindex).counters.idlecount = 0
userlist(userindex).counters.invisibilidad = 0
userlist(userindex).counters.paralisis = 0
userlist(userindex).counters.pasos = 0
userlist(userindex).counters.pena = 0
userlist(userindex).counters.piquetec = 0
userlist(userindex).counters.stacounter = 0
userlist(userindex).counters.veneno = 0

end sub

sub resetcharinfo(byval userindex as integer)

userlist(userindex).char.body = 0
userlist(userindex).char.cascoanim = 0
userlist(userindex).char.charindex = 0
userlist(userindex).char.fx = 0
userlist(userindex).char.head = 0
userlist(userindex).char.loops = 0
userlist(userindex).char.heading = 0
userlist(userindex).char.loops = 0
userlist(userindex).char.shieldanim = 0
userlist(userindex).char.weaponanim = 0

end sub

sub resetbasicuserinfo(byval userindex as integer)

userlist(userindex).name = ""
userlist(userindex).modname = ""
userlist(userindex).password = ""
userlist(userindex).desc = ""
userlist(userindex).pos.map = 0
userlist(userindex).pos.x = 0
userlist(userindex).pos.y = 0
userlist(userindex).ip = ""
userlist(userindex).rdbuffer = ""
userlist(userindex).clase = ""
userlist(userindex).email = ""
userlist(userindex).genero = ""
userlist(userindex).hogar = ""
userlist(userindex).raza = ""

userlist(userindex).randkey = 0
userlist(userindex).prevcrc = 0
userlist(userindex).packetnumber = 0

userlist(userindex).stats.banco = 0
userlist(userindex).stats.elv = 0
userlist(userindex).stats.elu = 0
userlist(userindex).stats.exp = 0
userlist(userindex).stats.def = 0
userlist(userindex).stats.criminalesmatados = 0
userlist(userindex).stats.npcsmuertos = 0
userlist(userindex).stats.usuariosmatados = 0

end sub

sub resetreputacion(byval userindex as integer)

userlist(userindex).reputacion.asesinorep = 0
userlist(userindex).reputacion.bandidorep = 0
userlist(userindex).reputacion.burguesrep = 0
userlist(userindex).reputacion.ladronesrep = 0
userlist(userindex).reputacion.noblerep = 0
userlist(userindex).reputacion.pleberep = 0
userlist(userindex).reputacion.noblerep = 0
userlist(userindex).reputacion.promedio = 0

end sub

sub resetguildinfo(byval userindex as integer)

userlist(userindex).guildinfo.clanfundado = ""
userlist(userindex).guildinfo.echadas = 0
userlist(userindex).guildinfo.esguildleader = 0
userlist(userindex).guildinfo.fundoclan = 0
userlist(userindex).guildinfo.guildname = ""
userlist(userindex).guildinfo.solicitudes = 0
userlist(userindex).guildinfo.solicitudesrechazadas = 0
userlist(userindex).guildinfo.vecesfueguildleader = 0
userlist(userindex).guildinfo.yavoto = 0
userlist(userindex).guildinfo.clanesparticipo = 0
userlist(userindex).guildinfo.guildpoints = 0

end sub

sub resetuserflags(byval userindex as integer)

userlist(userindex).flags.comerciando = false
userlist(userindex).flags.ban = 0
userlist(userindex).flags.escondido = 0
userlist(userindex).flags.duracionefecto = 0
userlist(userindex).flags.npcinv = 0
userlist(userindex).flags.statschanged = 0
userlist(userindex).flags.targetnpc = 0
userlist(userindex).flags.targetnpctipo = 0
userlist(userindex).flags.targetobj = 0
userlist(userindex).flags.targetobjmap = 0
userlist(userindex).flags.targetobjx = 0
userlist(userindex).flags.targetobjy = 0
userlist(userindex).flags.targetuser = 0
userlist(userindex).flags.tipopocion = 0
userlist(userindex).flags.tomopocion = false
userlist(userindex).flags.descuento = ""
userlist(userindex).flags.hambre = 0
userlist(userindex).flags.sed = 0
userlist(userindex).flags.descansar = false
userlist(userindex).flags.modocombate = false
userlist(userindex).flags.vuela = 0
userlist(userindex).flags.navegando = 0
userlist(userindex).flags.oculto = 0
userlist(userindex).flags.envenenado = 0
userlist(userindex).flags.invisible = 0
userlist(userindex).flags.paralizado = 0
userlist(userindex).flags.maldicion = 0
userlist(userindex).flags.bendicion = 0
userlist(userindex).flags.meditando = 0
userlist(userindex).flags.privilegios = 0
userlist(userindex).flags.puedemoverse = 0
userlist(userindex).flags.puedelanzarspell = 0
userlist(userindex).stats.skillpts = 0
userlist(userindex).flags.oldbody = 0
userlist(userindex).flags.oldhead = 0
userlist(userindex).flags.admininvisible = 0
userlist(userindex).flags.valcode = 0
userlist(userindex).flags.hechizo = 0

end sub

sub resetuserspells(byval userindex as integer)

dim loopc as integer
for loopc = 1 to maxuserhechizos
    userlist(userindex).stats.userhechizos(loopc) = 0
next

end sub

sub resetuserpets(byval userindex as integer)

dim loopc as integer

userlist(userindex).nromacotas = 0
    
for loopc = 1 to maxmascotas
    userlist(userindex).mascotasindex(loopc) = 0
    userlist(userindex).mascotastype(loopc) = 0
next loopc

end sub

sub resetuserbanco(byval userindex as integer)
dim loopc as integer
for loopc = 1 to max_bancoinventory_slots
      userlist(userindex).bancoinvent.object(loopc).amount = 0
      userlist(userindex).bancoinvent.object(loopc).equipped = 0
      userlist(userindex).bancoinvent.object(loopc).objindex = 0
next
userlist(userindex).bancoinvent.nroitems = 0
end sub

sub resetuserslot(byval userindex as integer)

set userlist(userindex).commandsbuffer = nothing
set userlist(userindex).guildref = nothing

userlist(userindex).anticuelgue = 0

call resetfacciones(userindex)
call resetcontadores(userindex)
call resetcharinfo(userindex)
call resetbasicuserinfo(userindex)
call resetreputacion(userindex)
call resetguildinfo(userindex)
call resetuserflags(userindex)
call limpiarinventario(userindex)
call resetuserspells(userindex)
call resetuserpets(userindex)
call resetuserbanco(userindex)

'userlist(userindex).numeropaquetespormilisec = 0
'userlist(userindex).bytestransmitidosuser = 0
'userlist(userindex).bytestransmitidossvr = 0





end sub


sub closeuser(byval userindex as integer)
'call logtarea("closeuser " & userindex)

on error goto errhandler

dim n as integer
dim x as integer
dim y as integer
dim loopc as integer
dim map as integer
dim name as string
dim raza as string
dim clase as string
dim i as integer

dim an as integer

an = userlist(userindex).flags.atacadopornpc
if an > 0 then
      npclist(an).movement = npclist(an).flags.oldmovement
      npclist(an).hostile = npclist(an).flags.oldhostil
      npclist(an).flags.attackedby = ""
end if

map = userlist(userindex).pos.map
x = userlist(userindex).pos.x
y = userlist(userindex).pos.y
name = ucase$(userlist(userindex).name)
raza = userlist(userindex).raza
clase = userlist(userindex).clase

userlist(userindex).char.fx = 0
userlist(userindex).char.loops = 0
call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
   

userlist(userindex).flags.userlogged = false
userlist(userindex).counters.saliendo = false

'le devolvemos el body y head originales
if userlist(userindex).flags.admininvisible = 1 then call doadmininvisible(userindex)

' grabamos el personaje del usuario
call saveuser(userindex, charpath & name & ".chr")

'quitar el dialogo
if mapinfo(map).numusers > 0 then
    call senddata(tomapbutindex, userindex, map, "qdl" & userlist(userindex).char.charindex)
end if

'borrar el personaje
if userlist(userindex).char.charindex > 0 then
    call eraseuserchar(tomapbutindex, userindex, map, userindex)
end if

'borrar mascotas
for i = 1 to maxmascotas
    if userlist(userindex).mascotasindex(i) > 0 then
        if npclist(userlist(userindex).mascotasindex(i)).flags.npcactive then _
                call quitarnpc(userlist(userindex).mascotasindex(i))
    end if
next i

if userindex = lastuser then
    do until userlist(lastuser).flags.userlogged
        lastuser = lastuser - 1
        if lastuser < 1 then exit do
    loop
end if
  
'if numusers <> 0 then
'    numusers = numusers - 1
'end if

'update map users
mapinfo(map).numusers = mapinfo(map).numusers - 1

if mapinfo(map).numusers < 0 then
    mapinfo(map).numusers = 0
end if

' si el usuario habia dejado un msg en la gm's queue lo borramos
if ayuda.existe(userlist(userindex).name) then call ayuda.quitar(userlist(userindex).name)

call resetuserslot(userindex)

call mostrarnumusers

n = freefile(1)
open app.path & "\logs\connect.log" for append shared as #n
print #n, name & " h� dejado el juego. " & "user index:" & userindex & " " & time & " " & date
close #n

exit sub

errhandler:
call logerror("error en closeuser")


end sub


sub handledata(byval userindex as integer, byval rdata as string)

call logtarea("sub handledata :" & rdata & " " & userlist(userindex).name)

on error goto errorhandler:




dim snddata as string
dim cadenaoriginal as string

dim loopc as integer
dim npos as worldpos
dim tstr as string
dim tint as integer
dim tlong as long
dim tindex as integer
dim tname as string
dim tmessage as string
dim auxind as integer
dim arg1 as string
dim arg2 as string
dim arg3 as string
dim arg4 as string
dim ver as string
dim encpass as string
dim pass as string
dim mapa as integer
dim name as string
dim ind
dim n as integer
dim wpaux as worldpos
dim mifile as integer
dim x as integer
dim y as integer
dim climd5 as string

dim clientcrc as string
dim serversidecrc as long

cadenaoriginal = rdata

'�tiene un indece valido?
if userindex <= 0 then
    call closesocket(userindex)
    exit sub
end if

if left$(rdata, 13) = "givemevalcode" then
   '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
   userlist(userindex).flags.valcode = cint(randomnumber(20000, 32000))
   userlist(userindex).randkey = clng(randomnumber(0, 99999))
   userlist(userindex).prevcrc = userlist(userindex).randkey
   userlist(userindex).packetnumber = 100
   '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   call senddata(toindex, userindex, 0, "val" & userlist(userindex).randkey & "," & userlist(userindex).flags.valcode)
   exit sub
elseif userlist(userindex).flags.userlogged = false and left(rdata, 12) = "clienteviejo" then
    dim elmsg as string, lalong as string
    elmsg = "errla version del cliente que usas es obsoleta. si deseas conectarte a este servidor, entra a www.argentum-online.com.ar y alli podr�s enterarte como hacer."
    if len(elmsg) > 255 then elmsg = left(elmsg, 255)
    lalong = chr(0) & chr(len(elmsg))
    call senddata(toindex, userindex, 0, lalong & elmsg)
    call closesocket(userindex)
    exit sub
else
   '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
   'clientcrc = readfield(2, rdata, 126)
   clientcrc = right(rdata, len(rdata) - instrrev(rdata, chr(126)))
   tstr = left$(rdata, len(rdata) - len(clientcrc) - 1)
   'serversidecrc = gencrc(userlist(userindex).prevcrc, tstr)
   'if clng(clientcrc) <> serversidecrc then call closesocket(userindex): debug.print "err crc"
   userlist(userindex).prevcrc = serversidecrc
   rdata = tstr
   tstr = ""
   '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end if

userlist(userindex).counters.idlecount = 0
   
   if not userlist(userindex).flags.userlogged then

        select case left$(rdata, 6)
            case "ologin"
                rdata = right$(rdata, len(rdata) - 6)
                climd5 = right$(rdata, 16)
                rdata = left$(rdata, len(rdata) - 16)
                if not md5ok(climd5) then
                    call senddata(toindex, userindex, 0, "errel cliente est� da�ado, por favor descarguelo nuevamente desde el sitio.")
                    exit sub
                end if
                ver = readfield(3, rdata, 44)
                if versionok(ver) then
                    tname = readfield(1, rdata, 44)
                    
                    if not asciivalidos(tname) then
                        call senddata(toindex, userindex, 0, "errnombre invalido.")
                        exit sub
                    end if
                    
                    if not personajeexiste(tname) then
                        call senddata(toindex, userindex, 0, "errel personaje no existe.")
                        exit sub
                    end if
                    
                    if not bancheck(tname) then
                        
                        if (userlist(userindex).flags.valcode = 0) or (validarloginmsg(userlist(userindex).flags.valcode) <> cint(val(readfield(4, rdata, 44)))) then
                              call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                              call closesocket(userindex)
                              exit sub
                        end if
                        dim pass11 as string
                        pass11 = readfield(2, rdata, 44)
                        call connectuser(userindex, tname, pass11)
                    else
                        call senddata(toindex, userindex, 0, "errse te ha prohibido la entrada a argentum debido a tu mal comportamiento.")
                    end if
                    
                else
                     call senddata(toindex, userindex, 0, "erresta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
                     'call closesocket(userindex)
                     exit sub
                end if
                exit sub
            case "tirdad"
                userlist(userindex).stats.useratributos(1) = cint(randomnumber(1, 6) + randomnumber(1, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(2) = cint(randomnumber(1, 6) + randomnumber(1, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(3) = cint(randomnumber(1, 6) + randomnumber(1, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(4) = cint(randomnumber(1, 6) + randomnumber(1, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(5) = cint(randomnumber(1, 6) + randomnumber(1, 6) + randomnumber(1, 6))

                call senddata(toindex, userindex, 0, "dados" & userlist(userindex).stats.useratributos(1) & "," & userlist(userindex).stats.useratributos(2) & "," & userlist(userindex).stats.useratributos(3) & "," & userlist(userindex).stats.useratributos(4) & "," & userlist(userindex).stats.useratributos(5))
                
                exit sub

            case "nlogin"
            
                if puedecrearpersonajes = 0 then
                        call senddata(toindex, userindex, 0, "errno se pueden crear mas personajes en este servidor.")
                        call closesocket(userindex)
                        exit sub
                end if
                
                if aclon.maxpersonajes(userlist(userindex).ip) then
                        call senddata(toindex, userindex, 0, "errhas creado demasiados personajes.")
                        call closesocket(userindex)
                        exit sub
                end if
                
                rdata = right$(rdata, len(rdata) - 6)
                climd5 = right$(rdata, 16)
                rdata = left$(rdata, len(rdata) - 16)
                if not md5ok(climd5) then
                    call senddata(toindex, userindex, 0, "errel cliente est� da�ado, por favor descarguelo nuevamente desde el sitio.")
                    exit sub
                end if
'                if not validinputnp(rdata) then exit sub
                
                ver = readfield(5, rdata, 44)
                if versionok(ver) then
                     dim miinteger as integer
                     miinteger = cint(val(readfield(37, rdata, 44)))
                     
                     if (userlist(userindex).flags.valcode = 0) or (validarloginmsg(userlist(userindex).flags.valcode) <> cint(val(readfield(37, rdata, 44)))) then
                         call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                         call closesocket(userindex)
                         exit sub
                     end if
                     
                     call connectnewuser(userindex, readfield(1, rdata, 44), readfield(2, rdata, 44), val(readfield(3, rdata, 44)), readfield(4, rdata, 44), readfield(6, rdata, 44), readfield(7, rdata, 44), _
                     readfield(8, rdata, 44), readfield(9, rdata, 44), readfield(10, rdata, 44), readfield(11, rdata, 44), readfield(12, rdata, 44), readfield(13, rdata, 44), _
                     readfield(14, rdata, 44), readfield(15, rdata, 44), readfield(16, rdata, 44), readfield(17, rdata, 44), readfield(18, rdata, 44), readfield(19, rdata, 44), _
                     readfield(20, rdata, 44), readfield(21, rdata, 44), readfield(22, rdata, 44), readfield(23, rdata, 44), readfield(24, rdata, 44), readfield(25, rdata, 44), _
                     readfield(26, rdata, 44), readfield(27, rdata, 44), readfield(28, rdata, 44), readfield(29, rdata, 44), readfield(30, rdata, 44), readfield(31, rdata, 44), _
                     readfield(32, rdata, 44), readfield(33, rdata, 44), readfield(34, rdata, 44), readfield(35, rdata, 44), readfield(36, rdata, 44))
                else
                     call senddata(toindex, userindex, 0, "!!esta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
                     exit sub
                end if
                
                exit sub
        end select
    end if
    
select case left$(rdata, 4)
    case "borr" ' <<< borra personajes
       on error goto exiterr1
        rdata = right$(rdata, len(rdata) - 4)
        if (userlist(userindex).flags.valcode = 0) or (validarloginmsg(userlist(userindex).flags.valcode) <> cint(val(readfield(3, rdata, 44)))) then
                      call loghackattemp("ip:" & userlist(userindex).ip & " intento borrar un personaje.")
                      call closesocket(userindex)
                      exit sub
        end if
        arg1 = readfield(1, rdata, 44)
        
        if not asciivalidos(arg1) then exit sub
        
        '�existe el personaje?
        if not fileexist(charpath & ucase$(arg1) & ".chr", vbnormal) then
            call closesocket(userindex)
            exit sub
        end if

        '�es el passwd valido?
        if ucase$(readfield(2, rdata, 44)) <> ucase$(getvar(charpath & ucase$(arg1) & ".chr", "init", "password")) then
            call closesocket(userindex)
            exit sub
        end if

        'if fileexist(charpath & ucase$(arg1) & ".chr", vbnormal) then
            dim rt$
            rt$ = app.path & "\chrbackup\" & ucase$(arg1) & ".bak"
            if fileexist(rt$, vbnormal) then kill rt$
            name charpath & ucase$(arg1) & ".chr" as rt$
            call senddata(toindex, userindex, 0, "borrok")
            exit sub
exiterr1:
    call logerror(err.description & " " & rdata)
    exit sub
        'end if
end select

'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'si no esta logeado y envia un comando diferente a los
'de arriba cerramos la conexion.
'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if not userlist(userindex).flags.userlogged then
    call loghackattemp("mesaje enviado sin logearse:" & rdata)
'    call frmmain.socket2(userindex).disconnect
    call closesocket(userindex)
    exit sub
end if
  


select case ucase$(left$(rdata, 1))
    case ";" 'hablar
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!! los muertos no pueden comunicarse con el mundo de los vivos. " & fonttype_info)
            exit sub
        end if
        rdata = right$(rdata, len(rdata) - 1)
        if instr(rdata, "�") then
            exit sub
        end if
    
        '[consejeros]
        if userlist(userindex).flags.privilegios = 1 then
            call loggm(userlist(userindex).name, "dijo: " & rdata, true)
        end if
        
        ind = userlist(userindex).char.charindex
        call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & rdata & "�" & str(ind))
        exit sub
    case "-" 'gritar
        if userlist(userindex).flags.muerto = 1 then
                call senddata(toindex, userindex, 0, "||��estas muerto!! los muertos no pueden comunicarse con el mundo de los vivos. " & fonttype_info)
                exit sub
        end if
        rdata = right$(rdata, len(rdata) - 1)
        if instr(rdata, "�") then
            exit sub
        end if
        '[consejeros]
        if userlist(userindex).flags.privilegios = 1 then
            call loggm(userlist(userindex).name, "grito: " & rdata, true)
        end if

        ind = userlist(userindex).char.charindex
        call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbred & "�" & rdata & "�" & str(ind))
        exit sub
    case "\" 'susurrar al oido
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!! los muertos no pueden comunicarse con el mundo de los vivos. " & fonttype_info)
            exit sub
        end if
        rdata = right$(rdata, len(rdata) - 1)
        tname = readfield(1, rdata, 32)
        tindex = nameindex(tname)
        if tindex <> 0 then
            if len(rdata) <> len(tname) then
                tmessage = right$(rdata, len(rdata) - (1 + len(tname)))
            else
                tmessage = " "
            end if
            if not estapcarea(userindex, tindex) then
                call senddata(toindex, userindex, 0, "||estas muy lejos del usuario." & fonttype_info)
                exit sub
            end if
            ind = userlist(userindex).char.charindex
            if instr(tmessage, "�") then
                exit sub
            end if
            
            '[consejeros]
            if userlist(userindex).flags.privilegios = 1 then
                call loggm(userlist(userindex).name, "le dijo a '" & userlist(tindex).name & "' " & tmessage, true)
            end if

            call senddata(toindex, userindex, userlist(userindex).pos.map, "||" & vbblue & "�" & tmessage & "�" & str(ind))
            call senddata(toindex, tindex, userlist(userindex).pos.map, "||" & vbblue & "�" & tmessage & "�" & str(ind))
            exit sub
        end if
        call senddata(toindex, userindex, 0, "||usuario inexistente. " & fonttype_info)
        exit sub
    case "m" 'moverse
        
        rdata = right$(rdata, len(rdata) - 1)
        
        if not userlist(userindex).flags.descansar and not userlist(userindex).flags.meditando _
           and userlist(userindex).flags.paralizado = 0 then
              call moveuserchar(userindex, val(rdata))
        elseif userlist(userindex).flags.descansar then
          userlist(userindex).flags.descansar = false
          call senddata(toindex, userindex, 0, "dok")
          call senddata(toindex, userindex, 0, "||has dejado de descansar." & fonttype_info)
          call moveuserchar(userindex, val(rdata))
        elseif userlist(userindex).flags.meditando then
          userlist(userindex).flags.meditando = false
          call senddata(toindex, userindex, 0, "medok")
          call senddata(toindex, userindex, 0, "||dejas de meditar." & fonttype_info)
          userlist(userindex).char.fx = 0
          userlist(userindex).char.loops = 0
          call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
          call moveuserchar(userindex, val(rdata))
        else
          call senddata(toindex, userindex, 0, "||no podes moverte porque estas paralizado." & fonttype_info)
        end if
        
        if userlist(userindex).flags.oculto = 1 then
            
            if ucase$(userlist(userindex).clase) <> "ladron" then
                call senddata(toindex, userindex, 0, "||has vuelto a ser visible." & fonttype_info)
                userlist(userindex).flags.oculto = 0
                userlist(userindex).flags.invisible = 0
                call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
            end if
            
        end if

        exit sub
end select

select case ucase$(rdata)
    case "rpu" 'pedido de actualizacion de la posicion
        call senddata(toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
        exit sub
    case "at"
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��no podes atacar a nadie porque estas muerto!!. " & fonttype_info)
            exit sub
        end if
        '[consejeros]
        if userlist(userindex).flags.privilegios = 1 then
            call senddata(toindex, userindex, 0, "||no puedes atacar a nadie. " & fonttype_info)
            exit sub
        end if
        if not userlist(userindex).flags.modocombate then
            call senddata(toindex, userindex, 0, "||no estas en modo de combate, presiona la tecla ""c"" para pasar al modo combate. " & fonttype_info)
        else
            if userlist(userindex).invent.weaponeqpobjindex > 0 then
                if objdata(userlist(userindex).invent.weaponeqpobjindex).proyectil = 1 then
                            call senddata(toindex, userindex, 0, "||no pod�s usar asi esta arma." & fonttype_info)
                            exit sub
                end if
            end if
            call usuarioataca(userindex)
        end if
        exit sub
    case "ag"
        if userlist(userindex).flags.muerto = 1 then
                call senddata(toindex, userindex, 0, "||��estas muerto!! los muertos no pueden tomar objetos. " & fonttype_info)
                exit sub
        end if
        '[consejeros]
        if userlist(userindex).flags.privilegios = 1 then
                call senddata(toindex, userindex, 0, "||no puedes tomar ningun objeto. " & fonttype_info)
                exit sub
        end if
        call getobj(userindex)
        exit sub
    case "tab" 'entrar o salir modo combate
        if userlist(userindex).flags.modocombate then
            call senddata(toindex, userindex, 0, "||has salido del modo de combate. " & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "||has pasado al modo de combate. " & fonttype_info)
        end if
        userlist(userindex).flags.modocombate = not userlist(userindex).flags.modocombate
        exit sub
    case "seg" 'activa / desactiva el seguro
        if userlist(userindex).flags.seguro then
              call senddata(toindex, userindex, 0, "||has desactivado el seguro. " & fonttype_info)
        else
              call senddata(toindex, userindex, 0, "||has activado el seguro. " & fonttype_info)
        end if
        userlist(userindex).flags.seguro = not userlist(userindex).flags.seguro
        exit sub
    case "actualizar"
        call senddata(toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
        exit sub
    case "/online"
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        tstr = left$(tstr, len(tstr) - 2)
        call senddata(toindex, userindex, 0, "||" & tstr & fonttype_info)
        call senddata(toindex, userindex, 0, "||n�mero de usuarios: " & numusers & fonttype_info)
        exit sub
    case "/salir"
        'call senddata(toindex, userindex, 0, "finok")
        cerrar_usuario (userindex)
        exit sub
    case "/fundarclan"
        if userlist(userindex).guildinfo.fundoclan = 1 then
            call senddata(toindex, userindex, 0, "||ya has fundado un clan, solo se puede fundar uno por personaje." & fonttype_info)
            exit sub
        end if
        if cancreateguild(userindex) then
            call senddata(toindex, userindex, 0, "showfun" & fonttype_info)
        end if
        exit sub
    case "glinfo"
        if userlist(userindex).guildinfo.esguildleader = 1 then
                    call sendguildleaderinfo(userindex)
        else
                    call sendguildslist(userindex)
        end if
        exit sub
    case "/balance"
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        'se asegura que el target es un npc
        if userlist(userindex).flags.targetnpc = 0 then
              call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
              exit sub
        end if
        if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                  exit sub
        end if
        if npclist(userlist(userindex).flags.targetnpc).npctype <> npctype_banquero _
        or userlist(userindex).flags.muerto = 1 then exit sub
        if fileexist(charpath & ucase$(userlist(userindex).name) & ".chr", vbnormal) = false then
              call senddata(toindex, userindex, 0, "!!el personaje no existe, cree uno nuevo.")
              closesocket (userindex)
              exit sub
        end if
        call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
        exit sub
    case "/quieto" ' << comando a mascotas
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                      call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
         end if
         'se asegura que el target es un npc
         if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
         end if
         if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                      call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                      exit sub
         end if
         if npclist(userlist(userindex).flags.targetnpc).maestrouser <> _
            userindex then exit sub
         npclist(userlist(userindex).flags.targetnpc).movement = estatico
         call expresar(userlist(userindex).flags.targetnpc, userindex)
         exit sub
    case "/acompa�ar"
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        'se asegura que el target es un npc
        if userlist(userindex).flags.targetnpc = 0 then
              call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
              exit sub
        end if
        if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                  exit sub
        end if
        if npclist(userlist(userindex).flags.targetnpc).maestrouser <> _
          userindex then exit sub
        call followamo(userlist(userindex).flags.targetnpc)
        call expresar(userlist(userindex).flags.targetnpc, userindex)
        exit sub
    case "/entrenar"
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        'se asegura que el target es un npc
        if userlist(userindex).flags.targetnpc = 0 then
              call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
              exit sub
        end if
        if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                  exit sub
        end if
        if npclist(userlist(userindex).flags.targetnpc).npctype <> npctype_entrenador then exit sub
        call enviarlistacriaturas(userindex, userlist(userindex).flags.targetnpc)
        exit sub
    case "/descansar"
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
            exit sub
        end if
        if hayobjarea(userlist(userindex).pos, fogata) then
                call senddata(toindex, userindex, 0, "dok")
                if not userlist(userindex).flags.descansar then
                    call senddata(toindex, userindex, 0, "||te acomodas junto a la fogata y comenzas a descansar." & fonttype_info)
                else
                    call senddata(toindex, userindex, 0, "||te levantas." & fonttype_info)
                end if
                userlist(userindex).flags.descansar = not userlist(userindex).flags.descansar
        else
                if userlist(userindex).flags.descansar then
                    call senddata(toindex, userindex, 0, "||te levantas." & fonttype_info)
                    
                    userlist(userindex).flags.descansar = false
                    call senddata(toindex, userindex, 0, "dok")
                    exit sub
                end if
                call senddata(toindex, userindex, 0, "||no hay ninguna fogata junto a la cual descansar." & fonttype_info)
        end if
        exit sub
    case "/meditar"
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
            exit sub
        end if
        call senddata(toindex, userindex, 0, "medok")
        if not userlist(userindex).flags.meditando then
           call senddata(toindex, userindex, 0, "||comenzas a meditar." & fonttype_info)
        else
           call senddata(toindex, userindex, 0, "||dejas de meditar." & fonttype_info)
        end if
        userlist(userindex).flags.meditando = not userlist(userindex).flags.meditando
        if userlist(userindex).flags.meditando then
            userlist(userindex).char.loops = loopadeternum
            if userlist(userindex).stats.elv < 15 then
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxmeditarchico & "," & loopadeternum)
                userlist(userindex).char.fx = fxmeditarchico
            elseif userlist(userindex).stats.elv < 30 then
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxmeditarmediano & "," & loopadeternum)
                userlist(userindex).char.fx = fxmeditarmediano
            else
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxmeditargrande & "," & loopadeternum)
                userlist(userindex).char.fx = fxmeditargrande
            end if
        else
            userlist(userindex).char.fx = 0
            userlist(userindex).char.loops = 0
            call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
        end if
        exit sub
    case "/resucitar"
       'se asegura que el target es un npc
       if userlist(userindex).flags.targetnpc = 0 then
           call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
           exit sub
       end if
       if npclist(userlist(userindex).flags.targetnpc).npctype <> 1 _
       or userlist(userindex).flags.muerto <> 1 then exit sub
       if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
           call senddata(toindex, userindex, 0, "||el sacerdote no puede resucitarte debido a que estas demasiado lejos." & fonttype_info)
           exit sub
       end if
       if fileexist(charpath & ucase$(userlist(userindex).name) & ".chr", vbnormal) = false then
           call senddata(toindex, userindex, 0, "!!el personaje no existe, cree uno nuevo.")
           closesocket (userindex)
           exit sub
       end if
       call revivirusuario(userindex)
       call senddata(toindex, userindex, 0, "||��h�s sido resucitado!!" & fonttype_info)
       exit sub
    case "/curar"
       'se asegura que el target es un npc
       if userlist(userindex).flags.targetnpc = 0 then
           call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
           exit sub
       end if
       if npclist(userlist(userindex).flags.targetnpc).npctype <> 1 _
       or userlist(userindex).flags.muerto <> 0 then exit sub
       if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
           call senddata(toindex, userindex, 0, "||el sacerdote no puede curarte debido a que estas demasiado lejos." & fonttype_info)
           exit sub
       end if
       userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
       call senduserstatsbox(val(userindex))
       call senddata(toindex, userindex, 0, "||��h�s sido curado!!" & fonttype_info)
       exit sub
    case "/ayuda"
       call sendhelp(userindex)
       exit sub
     case "/est"
        call senduserstatstxt(userindex, userindex)
        exit sub
    case "atri"
        call enviaratrib(userindex)
        exit sub
    case "fama"
        call enviarfama(userindex)
        exit sub
    case "eski"
        call enviarskills(userindex)
        exit sub
    case "/comerciar"
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        if userlist(userindex).flags.privilegios = 1 then
            exit sub
        end if
        '�el target es un npc valido?
        if userlist(userindex).flags.targetnpc > 0 then
              '�el npc puede comerciar?
              if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                 if len(npclist(userlist(userindex).flags.targetnpc).desc) > 0 then call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "no tengo ningun interes en comerciar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                 exit sub
              end if
              if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                  exit sub
              end if
              'iniciamos la rutina pa' comerciar.
              call iniciarcomercionpc(userindex)
         '[alejo]
#if false = true then
        elseif userlist(userindex).flags.targetuser > 0 then
            'comercio con otro usuario
            'puede comerciar ?
            if userlist(userlist(userindex).flags.targetuser).flags.muerto = 1 then
                call senddata(toindex, userindex, 0, "||��no puedes comerciar con los muertos!!" & fonttype_info)
                exit sub
            end if
            'soy yo ?
            if userlist(userindex).flags.targetuser = userindex then
                call senddata(toindex, userindex, 0, "||no puedes comerciar con vos mismo..." & fonttype_info)
                exit sub
            end if
            'ta muy lejos ?
            if distancia(userlist(userlist(userindex).flags.targetuser).pos, userlist(userindex).pos) > 3 then
                call senddata(toindex, userindex, 0, "||estas demasiado lejos del usuario." & fonttype_info)
                exit sub
            end if
            'ya ta comerciando ? es con migo o con otro ?
            if userlist(userlist(userindex).flags.targetuser).flags.comerciando = true and _
                userlist(userlist(userindex).flags.targetuser).comusu.destusu <> userindex then
                call senddata(toindex, userindex, 0, "||no puedes comerciar con el usuario en este momento." & fonttype_info)
                exit sub
            end if
            'inicializa unas variables...
            userlist(userindex).comusu.destusu = userlist(userindex).flags.targetuser
            userlist(userindex).comusu.cant = 0
            userlist(userindex).comusu.objeto = 0
            userlist(userindex).comusu.acepto = false
            
            'rutina para comerciar con otro usuario
            call iniciarcomercioconusuario(userindex, userlist(userindex).flags.targetuser)
#end if
        else
            call senddata(toindex, userindex, 0, "||primero hace click izquierdo sobre el personaje." & fonttype_info)
        end if
        exit sub
    '[/alejo]
    '[kevin]------------------------------------------
    case "/boveda"
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        '�el target es un npc valido?
        if userlist(userindex).flags.targetnpc > 0 then
              if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                  exit sub
              end if
              if npclist(userlist(userindex).flags.targetnpc).npctype = 4 then
                call iniciardeposito(userindex)
              else
                exit sub
              end if
        else
          call senddata(toindex, userindex, 0, "||primero hace click izquierdo sobre el personaje." & fonttype_info)
        end if
        exit sub
    '[/kevin]------------------------------------
    '[alejo]
    case "fincom"
        'user sale del modo comercio
        userlist(userindex).flags.comerciando = false
        call senddata(toindex, userindex, 0, "fincomok")
        exit sub
        case "fincomusu"
        'sale modo comercio usuario
        if userlist(userindex).comusu.destusu > 0 and _
            userlist(userlist(userindex).comusu.destusu).comusu.destusu = userindex then
            call senddata(toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha dejado de comerciar con vos." & fonttype_talk)
            call fincomerciarusu(userlist(userindex).comusu.destusu)
        end if
        
        call fincomerciarusu(userindex)
        exit sub
    '[kevin]---------------------------------------
    '******************************************************
    case "finban"
        'user sale del modo banco
        userlist(userindex).flags.comerciando = false
        call senddata(toindex, userindex, 0, "finbanok")
        exit sub
    '-------------------------------------------------------
    '[/kevin]**************************************
    case "comusuok"
        'aceptar el cambio
        call aceptarcomerciousu(userindex)
        exit sub
    case "comusuno"
        'rechazar el cambio
        if userlist(userindex).comusu.destusu > 0 then
            call senddata(toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha rechazado tu oferta." & fonttype_talk)
            call fincomerciarusu(userlist(userindex).comusu.destusu)
        end if
        call senddata(toindex, userindex, 0, "||has rechazado la oferta del otro usuario." & fonttype_talk)
        call fincomerciarusu(userindex)
        exit sub
    '[/alejo]

    case "/enlistar"
        'se asegura que el target es un npc
       if userlist(userindex).flags.targetnpc = 0 then
           call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
           exit sub
       end if
       
       if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
       or userlist(userindex).flags.muerto <> 0 then exit sub
       
       if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
           call senddata(toindex, userindex, 0, "||el sacerdote no puede curarte debido a que estas demasiado lejos." & fonttype_info)
           exit sub
       end if
       
       if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
              call enlistararmadareal(userindex)
       else
              call enlistarcaos(userindex)
       end if
       
       exit sub
    case "/informacion"
       'se asegura que el target es un npc
       if userlist(userindex).flags.targetnpc = 0 then
           call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
           exit sub
       end if
       
       if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
       or userlist(userindex).flags.muerto <> 0 then exit sub
       
       if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
           call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
           exit sub
       end if
       
       if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
            if userlist(userindex).faccion.armadareal = 0 then
                call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las tropas reales!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
            call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "tu deber es combatir criminales, cada 100 criminales que derrotes te dare una recompensa." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
       else
            if userlist(userindex).faccion.fuerzascaos = 0 then
                call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las fuerzas del caos!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
            call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "tu deber es sembrar el caos y la desesperanza, cada 100 ciudadanos que derrotes te dare una recompensa." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
       end if
       exit sub
    case "/recompensa"
       'se asegura que el target es un npc
       if userlist(userindex).flags.targetnpc = 0 then
           call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
           exit sub
       end if
       if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
       or userlist(userindex).flags.muerto <> 0 then exit sub
       if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
           call senddata(toindex, userindex, 0, "||el sacerdote no puede curarte debido a que estas demasiado lejos." & fonttype_info)
           exit sub
       end if
       if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
            if userlist(userindex).faccion.armadareal = 0 then
                call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las tropas reales!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
            call recompensaarmadareal(userindex)
       else
            if userlist(userindex).faccion.fuerzascaos = 0 then
                call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las fuerzas del caos!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
            call recompensacaos(userindex)
       end if
       exit sub
end select


select case ucase$(left$(rdata, 2))
'    case "/z"
'        dim pos as worldpos, pos2 as worldpos
'        dim o as obj
'
'        for loopc = 1 to 100
'            pos = userlist(userindex).pos
'            o.amount = 1
'            o.objindex = ioro
'            'exit for
'            call tiraroro(100000, userindex)
'            'call tilelibre(pos, pos2)
'            'if pos2.x = 0 or pos2.y = 0 then exit for
'
'            'call makeobj(tomap, 0, userlist(userindex).pos.map, o, pos2.map, pos2.x, pos2.y)
'        next loopc
'
'        exit sub
    case "ti" 'tirar item
            if userlist(userindex).flags.navegando = 1 or _
               userlist(userindex).flags.muerto = 1 or _
               userlist(userindex).flags.privilegios = 1 then exit sub
               '[consejeros]
            
            rdata = right$(rdata, len(rdata) - 2)
            arg1 = readfield(1, rdata, 44)
            arg2 = readfield(2, rdata, 44)
            if val(arg1) = flagoro then
                call tiraroro(val(arg2), userindex)
                call senduserstatsbox(userindex)
                exit sub
            else
                if val(arg1) <= max_inventory_slots and val(arg1) > 0 then
                    if userlist(userindex).invent.object(val(arg1)).objindex = 0 then
                            exit sub
                    end if
                    call dropobj(userindex, val(arg1), val(arg2), userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
                else
                    exit sub
                end if
            end if
            exit sub
    case "lh" ' lanzar hechizo
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!!." & fonttype_info)
            exit sub
        end if
        rdata = right$(rdata, len(rdata) - 2)
        userlist(userindex).flags.hechizo = val(rdata)
        exit sub
    case "lc" 'click izquierdo
        rdata = right$(rdata, len(rdata) - 2)
        arg1 = readfield(1, rdata, 44)
        arg2 = readfield(2, rdata, 44)
        if not numeric(arg1) or not numeric(arg2) then exit sub
        x = cint(arg1)
        y = cint(arg2)
        call lookattile(userindex, userlist(userindex).pos.map, x, y)
        exit sub
    case "rc" 'click derecho
        rdata = right$(rdata, len(rdata) - 2)
        arg1 = readfield(1, rdata, 44)
        arg2 = readfield(2, rdata, 44)
        if not numeric(arg1) or not numeric(arg2) then exit sub
        x = cint(arg1)
        y = cint(arg2)
        call accion(userindex, userlist(userindex).pos.map, x, y)
        exit sub
    case "uk"
        if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!!." & fonttype_info)
            exit sub
        end if

        rdata = right$(rdata, len(rdata) - 2)
        select case val(rdata)
            case robar
                call senddata(toindex, userindex, 0, "t01" & robar)
            case magia
                call senddata(toindex, userindex, 0, "t01" & magia)
            case domar
                call senddata(toindex, userindex, 0, "t01" & domar)
            case ocultarse
                
                if userlist(userindex).flags.navegando = 1 then
                      call senddata(toindex, userindex, 0, "||no podes ocultarte si estas navegando." & fonttype_info)
                      exit sub
                end if
                
                if userlist(userindex).flags.oculto = 1 then
                      call senddata(toindex, userindex, 0, "||ya estas oculto." & fonttype_info)
                      exit sub
                end if
                
                call doocultarse(userindex)
        end select
        exit sub
end select

'mensaje del servidor a gms - lo ubico aqui para que no se confunda con /gm [gonzalo]
if ucase$(left$(rdata, 6)) = "/gmsg " and userlist(userindex).flags.privilegios > 0 then
    rdata = right$(rdata, len(rdata) - 6)
    call loggm(userlist(userindex).name, "mensaje a gms:" & rdata, (userlist(userindex).flags.privilegios = 1))
    if rdata <> "" then
        call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & "> " & rdata & "~255~255~255~0~1")
    end if
    exit sub
end if

select case ucase$(left$(rdata, 3))
    case "/gm"
        if not ayuda.existe(userlist(userindex).name) then
            call senddata(toindex, userindex, 0, "||el mensaje ha sido entregado, ahora solo debes esperar que se desocupe algun gm." & fonttype_info)
            call ayuda.push(rdata, userlist(userindex).name)
        else
            call ayuda.quitar(userlist(userindex).name)
            call ayuda.push(rdata, userlist(userindex).name)
            call senddata(toindex, userindex, 0, "||ya habias mandado un mensaje, tu mensaje ha sido movido al final de la cola de mensajes." & fonttype_info)
        end if
        exit sub
    case "usa"
        rdata = right$(rdata, len(rdata) - 3)
        if val(rdata) <= max_inventory_slots and val(rdata) > 0 then
            if userlist(userindex).invent.object(val(rdata)).objindex = 0 then exit sub
        else
            exit sub
        end if
        call useinvitem(userindex, val(rdata))
        exit sub
    case "cns" ' construye herreria
        rdata = right$(rdata, len(rdata) - 3)
        x = cint(rdata)
        if x < 1 then exit sub
        if objdata(x).skherreria = 0 then exit sub
        call herreroconstruiritem(userindex, x)
        exit sub
    case "cnc" ' construye carpinteria
        rdata = right$(rdata, len(rdata) - 3)
        x = cint(rdata)
        if x < 1 or objdata(x).skcarpinteria = 0 then exit sub
        call carpinteroconstruiritem(userindex, x)
        exit sub
    case "wlc" 'click izquierdo en modo trabajo
        rdata = right$(rdata, len(rdata) - 3)
        arg1 = readfield(1, rdata, 44)
        arg2 = readfield(2, rdata, 44)
        arg3 = readfield(3, rdata, 44)
        if arg3 = "" or arg2 = "" or arg1 = "" then exit sub
        if not numeric(arg1) or not numeric(arg2) or not numeric(arg3) then exit sub
        
        x = cint(arg1)
        y = cint(arg2)
        tlong = cint(arg3)
        
        if userlist(userindex).flags.muerto = 1 or _
           userlist(userindex).flags.descansar or _
           userlist(userindex).flags.meditando or _
           not inmapbounds(userlist(userindex).pos.map, x, y) then exit sub
                          
        if not inrangovision(userindex, x, y) then
            call senddata(toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
            exit sub
        end if
        
        select case tlong
        
        case proyectiles
            dim tu as integer, tn as integer
            'nos aseguramos que este usando un arma de proyectiles
            if userlist(userindex).invent.weaponeqpobjindex = 0 then exit sub
            
            if objdata(userlist(userindex).invent.weaponeqpobjindex).proyectil <> 1 then exit sub
             
            if userlist(userindex).invent.municioneqpobjindex = 0 then
                    call senddata(toindex, userindex, 0, "||no tenes municiones." & fonttype_info)
                    exit sub
            end if
             
            'quitamos stamina
            if userlist(userindex).stats.minsta >= 10 then
                 call quitarsta(userindex, randomnumber(1, 10))
            else
                 call senddata(toindex, userindex, 0, "||estas muy cansado para luchar." & fonttype_info)
                 exit sub
            end if
             
            call lookattile(userindex, userlist(userindex).pos.map, arg1, arg2)
            
            tu = userlist(userindex).flags.targetuser
            tn = userlist(userindex).flags.targetnpc
            
            
            if tn > 0 then
                if npclist(tn).attackable = 0 then exit sub
            else
                if tu = 0 then exit sub
            end if
            
            if tn > 0 then call usuarioatacanpc(userindex, tn)
                
            if tu > 0 then
                if userlist(userindex).flags.seguro then
                        if not criminal(tu) then
                                call senddata(toindex, userindex, 0, "||no podes atacar ciudadanos, para hacerlo debes desactivar el seguro apretando la tecla s" & fonttype_fight)
                                exit sub
                        end if
                end if

                call usuarioatacausuario(userindex, tu)
            end if
            
            dim dummyint as integer
            dummyint = userlist(userindex).invent.municioneqpslot
            call quitaruserinvitem(userindex, userlist(userindex).invent.municioneqpslot, 1)
            if dummyint < 1 or dummyint > max_inventory_slots then exit sub
            if userlist(userindex).invent.object(dummyint).amount > 0 then
                userlist(userindex).invent.object(dummyint).equipped = 1
                userlist(userindex).invent.municioneqpslot = dummyint
                userlist(userindex).invent.municioneqpobjindex = userlist(userindex).invent.object(dummyint).objindex
                call updateuserinv(false, userindex, userlist(userindex).invent.municioneqpslot)
            else
                call updateuserinv(false, userindex, dummyint)
                userlist(userindex).invent.municioneqpslot = 0
                userlist(userindex).invent.municioneqpobjindex = 0
            end if
            
        case magia
            if userlist(userindex).flags.puedelanzarspell = 0 then exit sub
            '[consejeros]
            if userlist(userindex).flags.privilegios = 1 then exit sub
            
            call lookattile(userindex, userlist(userindex).pos.map, x, y)
            
            if userlist(userindex).flags.hechizo > 0 then
                call lanzarhechizo(userlist(userindex).flags.hechizo, userindex)
                userlist(userindex).flags.puedelanzarspell = 0
                userlist(userindex).flags.hechizo = 0
            else
                call senddata(toindex, userindex, 0, "||�primero selecciona el hechizo que quieres lanzar!" & fonttype_info)
            end if
        case pesca
                  
            if userlist(userindex).invent.herramientaeqpobjindex = 0 then exit sub
            
            if userlist(userindex).invent.herramientaeqpobjindex <> objtype_ca�a then
                    call closesocket(userindex)
                    exit sub
            end if
            
            if userlist(userindex).flags.puedetrabajar = 0 then exit sub
            
            if hayagua(userlist(userindex).pos.map, x, y) then
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & sound_pescar)
                call dopescar(userindex)
            else
                call senddata(toindex, userindex, 0, "||no hay agua donde pescar busca un lago, rio o mar." & fonttype_info)
            end if
            
        case robar
           if mapinfo(userlist(userindex).pos.map).pk then
                if userlist(userindex).flags.puedetrabajar = 0 then exit sub
                
                call lookattile(userindex, userlist(userindex).pos.map, x, y)
                
                if userlist(userindex).flags.targetuser > 0 and userlist(userindex).flags.targetuser <> userindex then
                   if userlist(userlist(userindex).flags.targetuser).flags.muerto = 0 then
                        wpaux.map = userlist(userindex).pos.map
                        wpaux.x = val(readfield(1, rdata, 44))
                        wpaux.y = val(readfield(2, rdata, 44))
                        if distancia(wpaux, userlist(userindex).pos) > 2 then
                            call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                            exit sub
                        end if
                        '17/09/02
                        'no aseguramos que el trigger le permite robar
                        if mapdata(userlist(userlist(userindex).flags.targetuser).pos.map, userlist(userlist(userindex).flags.targetuser).pos.x, userlist(userlist(userindex).flags.targetuser).pos.y).trigger = 4 then
                            call senddata(toindex, userindex, 0, "||no podes robar aqu�." & fonttype_warning)
                            exit sub
                        end if

                        call dorobar(userindex, userlist(userindex).flags.targetuser)
                   end if
                else
                    call senddata(toindex, userindex, 0, "||no a quien robarle!." & fonttype_info)
                end if
            else
                call senddata(toindex, userindex, 0, "||�no podes robarle en zonas seguras!." & fonttype_info)
            end if
        case talar
            
            if userlist(userindex).flags.puedetrabajar = 0 then exit sub
            
            if userlist(userindex).invent.herramientaeqpobjindex = 0 then
                call senddata(toindex, userindex, 0, "||deber�as equiparte el hacha." & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).invent.herramientaeqpobjindex <> hacha_le�ador then
                    call closesocket(userindex)
                    exit sub
            end if
            
            auxind = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
            if auxind > 0 then
                wpaux.map = userlist(userindex).pos.map
                wpaux.x = x
                wpaux.y = y
                if distancia(wpaux, userlist(userindex).pos) > 2 then
                    call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                    exit sub
                end if
                '�hay un arbol donde clickeo?
                if objdata(auxind).objtype = objtype_arboles then
                    call senddata(topcarea, cint(userindex), userlist(userindex).pos.map, "tw" & sound_talar)
                    call dotalar(userindex)
                end if
            else
                call senddata(toindex, userindex, 0, "||no hay ningun arbol ahi." & fonttype_info)
            end if
        case mineria
            
            if userlist(userindex).flags.puedetrabajar = 0 then exit sub
            
            if userlist(userindex).invent.herramientaeqpobjindex = 0 then exit sub
            
            if userlist(userindex).invent.herramientaeqpobjindex <> piquete_minero then
                    call closesocket(userindex)
                    exit sub
            end if
            
            call lookattile(userindex, userlist(userindex).pos.map, x, y)
            
            auxind = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
            if auxind > 0 then
                wpaux.map = userlist(userindex).pos.map
                wpaux.x = x
                wpaux.y = y
                if distancia(wpaux, userlist(userindex).pos) > 2 then
                    call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                    exit sub
                end if
                '�hay un yacimiento donde clickeo?
                if objdata(auxind).objtype = objtype_yacimiento then
                    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & sound_minero)
                    call domineria(userindex)
                else
                    call senddata(toindex, userindex, 0, "||ahi no hay ningun yacimiento." & fonttype_info)
                end if
            else
                call senddata(toindex, userindex, 0, "||ahi no hay ningun yacimiento." & fonttype_info)
            end if
        case domar
          'modificado 25/11/02
          'optimizado y solucionado el bug de la doma de
          'criaturas hostiles.
          dim ci as integer
          
          call lookattile(userindex, userlist(userindex).pos.map, x, y)
          ci = userlist(userindex).flags.targetnpc
          
          if ci > 0 then
                   if npclist(ci).flags.domable > 0 then
                        wpaux.map = userlist(userindex).pos.map
                        wpaux.x = x
                        wpaux.y = y
                        if distancia(wpaux, npclist(userlist(userindex).flags.targetnpc).pos) > 2 then
                              call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                              exit sub
                        end if
                        if npclist(ci).flags.attackedby <> "" then
                              call senddata(toindex, userindex, 0, "||no pod�s domar una criatura que est� luchando con un jugador." & fonttype_info)
                              exit sub
                        end if
                        call dodomar(userindex, ci)
                    else
                        call senddata(toindex, userindex, 0, "||no podes domar a esa criatura." & fonttype_info)
                    end if
          else
                 call senddata(toindex, userindex, 0, "||no hay ninguna criatura alli!." & fonttype_info)
          end if
          
        case fundirmetal
            call lookattile(userindex, userlist(userindex).pos.map, x, y)
            
            if userlist(userindex).flags.targetobj > 0 then
                if objdata(userlist(userindex).flags.targetobj).objtype = objtype_fragua then
                    call fundirmineral(userindex)
                else
                    call senddata(toindex, userindex, 0, "||ahi no hay ninguna fragua." & fonttype_info)
                end if
            else
                call senddata(toindex, userindex, 0, "||ahi no hay ninguna fragua." & fonttype_info)
            end if
            
        case herreria
            call lookattile(userindex, userlist(userindex).pos.map, x, y)
            
            if userlist(userindex).flags.targetobj > 0 then
                if objdata(userlist(userindex).flags.targetobj).objtype = objtype_yunque then
                    call enivararmasconstruibles(userindex)
                    call enivararmadurasconstruibles(userindex)
                    call senddata(toindex, userindex, 0, "sfh")
                else
                    call senddata(toindex, userindex, 0, "||ahi no hay ningun yunque." & fonttype_info)
                end if
            else
                call senddata(toindex, userindex, 0, "||ahi no hay ningun yunque." & fonttype_info)
            end if
            
        end select
        
        userlist(userindex).flags.puedetrabajar = 0
        exit sub
    case "cig"
        rdata = right$(rdata, len(rdata) - 3)
        x = guilds.count
        
        if createguild(userlist(userindex).name, userlist(userindex).reputacion.promedio, userindex, rdata) then
            if x = 0 then
                call senddata(toindex, userindex, 0, "||felicidades has creado el primer clan de argentum!!!." & fonttype_info)
            else
                call senddata(toindex, userindex, 0, "||felicidades has creado el clan numero " & x + 1 & " de argentum!!!." & fonttype_info)
            end if
            call saveguildsdb
        end if
        
        exit sub
end select

select case ucase$(left$(rdata, 4))
    case "infs" 'informacion del hechizo
            rdata = right$(rdata, len(rdata) - 4)
            if val(rdata) > 0 and val(rdata) < maxuserhechizos + 1 then
                dim h as integer
                h = userlist(userindex).stats.userhechizos(val(rdata))
                if h > 0 and h < numerohechizos + 1 then
                    call senddata(toindex, userindex, 0, "||%%%%%%%%%%%% info del hechizo %%%%%%%%%%%%" & fonttype_info)
                    call senddata(toindex, userindex, 0, "||nombre:" & hechizos(h).nombre & fonttype_info)
                    call senddata(toindex, userindex, 0, "||descripcion:" & hechizos(h).desc & fonttype_info)
                    call senddata(toindex, userindex, 0, "||skill requerido: " & hechizos(h).minskill & " de magia." & fonttype_info)
                    call senddata(toindex, userindex, 0, "||mana necesario: " & hechizos(h).manarequerido & fonttype_info)
                    call senddata(toindex, userindex, 0, "||%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" & fonttype_info)
                end if
            else
                call senddata(toindex, userindex, 0, "||�primero selecciona el hechizo.!" & fonttype_info)
            end if
            exit sub
   case "equi"
            if userlist(userindex).flags.muerto = 1 then
            call senddata(toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
            exit sub
            end if
            rdata = right$(rdata, len(rdata) - 4)
            if val(rdata) <= max_inventory_slots and val(rdata) > 0 then
                 if userlist(userindex).invent.object(val(rdata)).objindex = 0 then exit sub
            else
                exit sub
            end if
            call equiparinvitem(userindex, val(rdata))
            exit sub
    case "chea" 'cambiar heading ;-)
        rdata = right$(rdata, len(rdata) - 4)
        if val(rdata) > 0 and val(rdata) < 5 then
            userlist(userindex).char.heading = rdata
            call changeuserchar(tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
        end if
        exit sub
    case "skse" 'modificar skills
        dim i as integer
        dim sumatoria as integer
        dim incremento as integer
        rdata = right$(rdata, len(rdata) - 4)
        
        'codigo para prevenir el hackeo de los skills
        '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        for i = 1 to numskills
            incremento = val(readfield(i, rdata, 44))
            
            if incremento < 0 then
                'call senddata(toall, 0, 0, "||los dioses han desterrado a " & userlist(userindex).name & fonttype_info)
                call loghackattemp(userlist(userindex).name & " ip:" & userlist(userindex).ip & " trato de hackear los skills.")
                userlist(userindex).stats.skillpts = 0
                call closesocket(userindex)
                exit sub
            end if
            
            sumatoria = sumatoria + incremento
        next i
        
        if sumatoria > userlist(userindex).stats.skillpts then
            'userlist(userindex).flags.administrativeban = 1
            'call senddata(toall, 0, 0, "||los dioses han desterrado a " & userlist(userindex).name & fonttype_info)
            call loghackattemp(userlist(userindex).name & " ip:" & userlist(userindex).ip & " trato de hackear los skills.")
            call closesocket(userindex)
            exit sub
        end if
        '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        for i = 1 to numskills
            incremento = val(readfield(i, rdata, 44))
            userlist(userindex).stats.skillpts = userlist(userindex).stats.skillpts - incremento
            userlist(userindex).stats.userskills(i) = userlist(userindex).stats.userskills(i) + incremento
            if userlist(userindex).stats.userskills(i) > 100 then userlist(userindex).stats.userskills(i) = 100
        next i
        exit sub
    case "entr" 'entrena hombre!
        
        if userlist(userindex).flags.targetnpc = 0 then exit sub
        
        if npclist(userlist(userindex).flags.targetnpc).npctype <> 3 then exit sub
        
        rdata = right$(rdata, len(rdata) - 4)
        
        if npclist(userlist(userindex).flags.targetnpc).mascotas < maxmascotasentrenador then
            if val(rdata) > 0 and val(rdata) < npclist(userlist(userindex).flags.targetnpc).nrocriaturas + 1 then
                    dim spawnednpc as integer
                    spawnednpc = spawnnpc(npclist(userlist(userindex).flags.targetnpc).criaturas(val(rdata)).npcindex, npclist(userlist(userindex).flags.targetnpc).pos, true, false)
                    if spawnednpc <= maxnpcs then
                        npclist(spawnednpc).maestronpc = userlist(userindex).flags.targetnpc
                        npclist(userlist(userindex).flags.targetnpc).mascotas = npclist(userlist(userindex).flags.targetnpc).mascotas + 1
                    end if
            end if
        else
            call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "no puedo traer mas criaturas, mata las existentes!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
        end if
        
        exit sub
    case "comp"
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                   call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                   exit sub
         end if
         '�el target es un npc valido?
         if userlist(userindex).flags.targetnpc > 0 then
               '�el npc puede comerciar?
               if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                   call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & fonttype_talk & "�" & "no tengo ningun interes en comerciar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                   exit sub
               end if
         else
           exit sub
         end if
         rdata = right$(rdata, len(rdata) - 5)
         'user compra el item del slot rdata
         call npcventaitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)), userlist(userindex).flags.targetnpc)
         exit sub
    '[kevin]*********************************************************************
    '------------------------------------------------------------------------------------
    case "reti"
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                   call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                   exit sub
         end if
         '�el target es un npc valido?
         if userlist(userindex).flags.targetnpc > 0 then
               '�es el banquero?
               if npclist(userlist(userindex).flags.targetnpc).npctype <> 4 then
                   exit sub
               end if
         else
           exit sub
         end if
         rdata = right(rdata, len(rdata) - 5)
         'user retira el item del slot rdata
         call userretiraitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
         exit sub
    '-----------------------------------------------------------------------------------
    '[/kevin]****************************************************************************
    case "vend"
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                   call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                   exit sub
         end if
         '�el target es un npc valido?
         if userlist(userindex).flags.targetnpc > 0 then
               '�el npc puede comerciar?
               if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                   call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & fonttype_talk & "�" & "no tengo ningun interes en comerciar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                   exit sub
               end if
         else
           exit sub
         end if
         rdata = right$(rdata, len(rdata) - 5)
         'user compra el item del slot rdata
         call npccompraitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
         exit sub
    '[kevin]-------------------------------------------------------------------------
    '****************************************************************************************
    case "depo"
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                   call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                   exit sub
         end if
         '�el target es un npc valido?
         if userlist(userindex).flags.targetnpc > 0 then
               '�el npc puede comerciar?
               if npclist(userlist(userindex).flags.targetnpc).npctype <> 4 then
                   exit sub
               end if
         else
           exit sub
         end if
         rdata = right(rdata, len(rdata) - 5)
         'user deposita el item del slot rdata
         call userdepositaitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
         exit sub
    '****************************************************************************************
    '[/kevin]---------------------------------------------------------------------------------
         
end select

select case ucase$(left$(rdata, 5))
    case "demsg"
        if userlist(userindex).flags.targetobj > 0 then
        rdata = right$(rdata, len(rdata) - 5)
        dim f as string, titu as string, msg as string, f2 as string
        f = app.path & "\foros\"
        f = f & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & ".for"
        titu = readfield(1, rdata, 176)
        msg = readfield(2, rdata, 176)
        dim n2 as integer, loopme as integer
        if fileexist(f, vbnormal) then
            dim num as integer
            num = val(getvar(f, "info", "cantmsg"))
            if num > max_mensajes_foro then
                for loopme = 1 to num
                    kill app.path & "\foros\" & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & loopme & ".for"
                next
                kill app.path & "\foros\" & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & ".for"
                num = 0
            end if
            n2 = freefile
            f2 = left$(f, len(f) - 4)
            f2 = f2 & num + 1 & ".for"
            open f2 for output as n2
            print #n2, titu
            print #n2, msg
            call writevar(f, "info", "cantmsg", num + 1)
        else
            n2 = freefile
            f2 = left$(f, len(f) - 4)
            f2 = f2 & "1" & ".for"
            open f2 for output as n2
            print #n2, titu
            print #n2, msg
            call writevar(f, "info", "cantmsg", 1)
        end if
        close #n2
        end if
        exit sub
    case "/bug "
        n = freefile
        open app.path & "\bugs\bugs.log" for append shared as n
        print #n,
        print #n,
        print #n, "########################################################################"
        print #n, "########################################################################"
        print #n, "usuario:" & userlist(userindex).name & "  fecha:" & date & "    hora:" & time
        print #n, "########################################################################"
        print #n, "bug:"
        print #n, right$(rdata, len(rdata) - 5)
        print #n, "########################################################################"
        print #n, "########################################################################"
        print #n,
        print #n,
        close #n
        exit sub
end select


select case ucase$(left$(rdata, 6))
    case "/desc "
        rdata = right$(rdata, len(rdata) - 6)
        if not asciivalidos(rdata) then
            call senddata(toindex, userindex, 0, "||la descripcion tiene caracteres invalidos." & fonttype_info)
            exit sub
        end if
        userlist(userindex).desc = rdata
        call senddata(toindex, userindex, 0, "||la descripcion a cambiado." & fonttype_info)
        exit sub
    case "descod" 'informacion del hechizo
            rdata = right$(rdata, len(rdata) - 6)
            call updatecodexanddesc(rdata, userindex)
            exit sub
    case "/voto "
            rdata = right$(rdata, len(rdata) - 6)
            call computevote(userindex, rdata)
            exit sub
            
 end select

'[alejo]
select case ucase$(left$(rdata, 7))
case "ofrecer"
        rdata = right$(rdata, len(rdata) - 7)
        arg1 = readfield(1, rdata, asc(","))
        arg2 = readfield(2, rdata, asc(","))

        if val(arg1) <= 0 or val(arg2) <= 0 then
            exit sub
        end if
        if userlist(userlist(userindex).comusu.destusu).flags.userlogged = false then
            'sigue vivo el usuario ?
            call fincomerciarusu(userindex)
            exit sub
        else
            'esta vivo ?
            if userlist(userlist(userindex).comusu.destusu).flags.muerto = 1 then
                call fincomerciarusu(userindex)
                exit sub
            end if
            '//tiene la cantidad que ofrece ??//'
            if val(arg1) = flagoro then
                'oro
                if val(arg2) > userlist(userindex).stats.gld then
                    call senddata(toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
                    exit sub
                end if
            else
                'inventario
                if val(arg2) > userlist(userindex).invent.object(val(arg1)).amount then
                    call senddata(toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
                    exit sub
                end if
            end if
            '[consejeros]
            if userlist(userindex).comusu.objeto > 0 then
                call senddata(toindex, userindex, 0, "||no puedes cambiar tu oferta." & fonttype_talk)
                exit sub
            end if
            userlist(userindex).comusu.objeto = val(arg1)
            userlist(userindex).comusu.cant = val(arg2)
            if userlist(userlist(userindex).comusu.destusu).comusu.destusu <> userindex then
                call fincomerciarusu(userindex)
                exit sub
            else
                '[corregido]
                if userlist(userlist(userindex).comusu.destusu).comusu.acepto = true then
                    'no no no vos te estas pasando de listo...
                    userlist(userlist(userindex).comusu.destusu).comusu.acepto = false
                    call senddata(toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha cambiado su oferta." & fonttype_talk)
                end if
                '[/corregido]
                'es la ofrenda de respuesta :)
                call enviarobjetotransaccion(userlist(userindex).comusu.destusu)
            end if
        end if
        exit sub
end select
'[/alejo]

select case ucase$(left$(rdata, 8))
    case "aceppeat"
        rdata = right$(rdata, len(rdata) - 8)
        call acceptpeaceoffer(userindex, rdata)
        exit sub
    case "peaceoff"
        rdata = right$(rdata, len(rdata) - 8)
        call recievepeaceoffer(userindex, rdata)
        exit sub
    case "peacedet"
        rdata = right$(rdata, len(rdata) - 8)
        call sendpeacerequest(userindex, rdata)
        exit sub
    case "envcomen"
        rdata = right$(rdata, len(rdata) - 8)
        call sendpeticion(userindex, rdata)
        exit sub
    case "envpropp"
        call sendpeacepropositions(userindex)
        exit sub
    case "decguerr"
        rdata = right$(rdata, len(rdata) - 8)
        call declarewar(userindex, rdata)
        exit sub
    case "decaliad"
        rdata = right$(rdata, len(rdata) - 8)
        call declareallie(userindex, rdata)
        exit sub
    case "newwebsi"
        rdata = right$(rdata, len(rdata) - 8)
        call setnewurl(userindex, rdata)
        exit sub
    case "aceptari"
        rdata = right$(rdata, len(rdata) - 8)
        call acceptclanmember(userindex, rdata)
        exit sub
    case "rechazar"
        rdata = right$(rdata, len(rdata) - 8)
        call denyrequest(userindex, rdata)
        exit sub
    case "echarcla"
        rdata = right$(rdata, len(rdata) - 8)
        call eacharmember(userindex, rdata)
        exit sub
    case "/passwd "
        rdata = right$(rdata, len(rdata) - 8)
        if len(rdata) < 6 then
             call senddata(toindex, userindex, 0, "||el password debe tener al menos 6 caracteres." & fonttype_info)
        else
             call senddata(toindex, userindex, 0, "||el password ha sido cambiado." & fonttype_info)
             userlist(userindex).password = rdata
        end if
        exit sub
    case "actgnews"
        rdata = right$(rdata, len(rdata) - 8)
        call updateguildnews(rdata, userindex)
        exit sub
    case "1hrinfo<"
        rdata = right$(rdata, len(rdata) - 8)
        call sendcharinfo(rdata, userindex)
        exit sub
end select


select case ucase$(left$(rdata, 9))
    case "solicitud"
         rdata = right$(rdata, len(rdata) - 9)
         call solicitudingresoclan(userindex, rdata)
         exit sub
    case "/retirar " 'retira oro en el banco
         '�esta el user muerto? si es asi no puede comerciar
         if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
         end if
         'se asegura que el target es un npc
         if userlist(userindex).flags.targetnpc = 0 then
              call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
              exit sub
         end if
         rdata = right$(rdata, len(rdata) - 9)
         if npclist(userlist(userindex).flags.targetnpc).npctype <> npctype_banquero _
         or userlist(userindex).flags.muerto = 1 then exit sub
         if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
              call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
              exit sub
         end if
         if fileexist(charpath & ucase$(userlist(userindex).name) & ".chr", vbnormal) = false then
              call senddata(toindex, userindex, 0, "!!el personaje no existe, cree uno nuevo.")
              closesocket (userindex)
              exit sub
         end if
         if val(rdata) > 0 and val(rdata) <= userlist(userindex).stats.banco then
              userlist(userindex).stats.banco = userlist(userindex).stats.banco - val(rdata)
              userlist(userindex).stats.gld = userlist(userindex).stats.gld + val(rdata)
              call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
         else
              call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & " no tenes esa cantidad." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
         end if
         call senduserstatsbox(val(userindex))
         exit sub
end select


select case ucase$(left$(rdata, 11))
    case "/depositar " 'depositar oro en el banco
        '�esta el user muerto? si es asi no puede comerciar
        if userlist(userindex).flags.muerto = 1 then
                  call senddata(toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                  exit sub
        end if
        'se asegura que el target es un npc
        if userlist(userindex).flags.targetnpc = 0 then
              call senddata(toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
              exit sub
        end if
        if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                  exit sub
        end if
        rdata = right$(rdata, len(rdata) - 11)
        if npclist(userlist(userindex).flags.targetnpc).npctype <> npctype_banquero _
        or userlist(userindex).flags.muerto = 1 then exit sub
        if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
              call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
              exit sub
        end if
        if clng(val(rdata)) > 0 and clng(val(rdata)) <= userlist(userindex).stats.gld then
              userlist(userindex).stats.banco = userlist(userindex).stats.banco + val(rdata)
              userlist(userindex).stats.gld = userlist(userindex).stats.gld - val(rdata)
              call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
        else
              call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & " no tenes esa cantidad." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
        end if
        call senduserstatsbox(val(userindex))
        exit sub
  case "clandetails"
        rdata = right$(rdata, len(rdata) - 11)
        call sendguilddetails(userindex, rdata)
        exit sub
end select



'>>>>>>>>>>>>>>>>>>>>>> solo administradores <<<<<<<<<<<<<<<<<<<
 if userlist(userindex).flags.privilegios = 0 then exit sub
'>>>>>>>>>>>>>>>>>>>>>> solo administradores <<<<<<<<<<<<<<<<<<<


'<<<<<<<<<<<<<<<<<<<< consejeros <<<<<<<<<<<<<<<<<<<<

'/rem comentario
if ucase$(left$(rdata, 4)) = "/rem" then
    rdata = right$(rdata, len(rdata) - 5)
    call loggm(userlist(userindex).name, "comentario: " & rdata, (userlist(userindex).flags.privilegios = 1))
    call senddata(toindex, userindex, 0, "||comentario salvado..." & fonttype_info)
    exit sub
end if

'hora
if ucase$(left$(rdata, 5)) = "/hora" then
    call loggm(userlist(userindex).name, "hora.", (userlist(userindex).flags.privilegios = 1))
    rdata = right$(rdata, len(rdata) - 5)
    call senddata(toall, 0, 0, "||hora: " & time & " " & date & fonttype_info)
    exit sub
end if

'�donde esta?
if ucase$(left$(rdata, 7)) = "/donde " then
    rdata = right$(rdata, len(rdata) - 7)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    call senddata(toindex, userindex, 0, "||ubicacion  " & userlist(tindex).name & ": " & userlist(tindex).pos.map & ", " & userlist(tindex).pos.x & ", " & userlist(tindex).pos.y & "." & fonttype_info)
    call loggm(userlist(userindex).name, "/donde", (userlist(userindex).flags.privilegios = 1))
    exit sub
end if

'nro de enemigos
if ucase$(left$(rdata, 6)) = "/nene " then
    rdata = right$(rdata, len(rdata) - 6)
    if mapavalido(val(rdata)) then
        call senddata(toindex, userindex, 0, "nene" & npchostiles(val(rdata)))
        call loggm(userlist(userindex).name, "numero enemigos en mapa " & rdata, (userlist(userindex).flags.privilegios = 1))
    end if
    exit sub
end if

'[consejeros] '[consejeros] '[consejeros] '[consejeros]

if ucase$(rdata) = "/teleploc" then
    call warpuserchar(userindex, userlist(userindex).flags.targetmap, userlist(userindex).flags.targetx, userlist(userindex).flags.targety, true)
    call loggm(userlist(userindex).name, "/teleploc a x:" & userlist(userindex).flags.targetx & " y:" & userlist(userindex).flags.targety & " map:" & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = 1))
    exit sub
end if

'teleportar
if ucase$(left$(rdata, 7)) = "/telep " then
    rdata = right$(rdata, len(rdata) - 7)
    mapa = val(readfield(2, rdata, 32))
    if not mapavalido(mapa) then exit sub
    name = readfield(1, rdata, 32)
    if name = "" then exit sub
    if ucase$(name) <> "yo" then
        if userlist(userindex).flags.privilegios = 1 then
            exit sub
        end if
        tindex = nameindex(name)
    else
        tindex = userindex
    end if
    x = val(readfield(3, rdata, 32))
    y = val(readfield(4, rdata, 32))
    if not inmapbounds(mapa, x, y) then exit sub
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    call warpuserchar(tindex, mapa, x, y, true)
    call senddata(toindex, tindex, 0, "||" & userlist(userindex).name & " transportado." & fonttype_info)
    call loggm(userlist(userindex).name, "transporto a " & userlist(tindex).name & " hacia " & "mapa" & mapa & " x:" & x & " y:" & y, (userlist(userindex).flags.privilegios = 1))
    exit sub
end if

if ucase$(left$(rdata, 9)) = "/show sos" then
    dim m as string
    for n = 1 to ayuda.longitud
        m = ayuda.verelemento(n)
        call senddata(toindex, userindex, 0, "rsos" & m)
    next n
    call senddata(toindex, userindex, 0, "msos")
    exit sub
end if

if ucase$(left$(rdata, 7)) = "sosdone" then
    rdata = right$(rdata, len(rdata) - 7)
    call ayuda.quitar(rdata)
    exit sub
end if

'ir a
if ucase$(left$(rdata, 5)) = "/ira " then
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    

    call warpuserchar(userindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y + 1, true)
    
    if userlist(userindex).flags.admininvisible = 0 then call senddata(toindex, tindex, 0, "||" & userlist(userindex).name & " se ha trasportado hacia donde te encontras." & fonttype_info)
    call loggm(userlist(userindex).name, "/ira " & userlist(tindex).name & " mapa:" & userlist(tindex).pos.map & " x:" & userlist(tindex).pos.x & " y:" & userlist(tindex).pos.y, (userlist(userindex).flags.privilegios = 1))
    exit sub
end if

'haceme invisible vieja!
if ucase$(rdata) = "/invisible" then
    call doadmininvisible(userindex)
    call loggm(userlist(userindex).name, "/invisible", (userlist(userindex).flags.privilegios = 1))
    exit sub
end if


'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
if userlist(userindex).flags.privilegios < 2 then
    exit sub
end if

'info de user
if ucase$(left$(rdata, 6)) = "/info " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 6)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if

    senduserstatstxt userindex, tindex
    exit sub
end if

'inv del user
if ucase$(left$(rdata, 5)) = "/inv " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if

    senduserinvtxt userindex, tindex
    exit sub
end if

'skills del user
if ucase$(left$(rdata, 8)) = "/skills " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 8)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if

    senduserskillstxt userindex, tindex
    exit sub
end if

if ucase$(left$(rdata, 9)) = "/revivir " then
    rdata = right$(rdata, len(rdata) - 9)
    name = rdata
    if ucase$(name) <> "yo" then
        tindex = nameindex(name)
    else
        tindex = userindex
    end if
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    userlist(tindex).flags.muerto = 0
    userlist(tindex).stats.minhp = userlist(tindex).stats.maxhp
    call darcuerpodesnudo(tindex)
    call changeuserchar(tomap, 0, userlist(tindex).pos.map, val(tindex), userlist(tindex).char.body, userlist(tindex).origchar.head, userlist(tindex).char.heading, userlist(tindex).char.weaponanim, userlist(tindex).char.shieldanim, userlist(userindex).char.cascoanim)
    call senduserstatsbox(val(tindex))
    call senddata(toindex, tindex, 0, "||" & userlist(userindex).name & " te h� resucitado." & fonttype_info)
    call loggm(userlist(userindex).name, "resucito a " & userlist(tindex).name, false)
    exit sub
end if

if ucase$(rdata) = "/onlinegm" then
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") and userlist(loopc).flags.privilegios <> 0 then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        if len(tstr) > 0 then
            tstr = left$(tstr, len(tstr) - 2)
            call senddata(toindex, userindex, 0, "||" & tstr & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "||no hay gms online" & fonttype_info)
        end if
        exit sub
end if

if ucase$(left$(rdata, 8)) = "/carcel " then
    
    rdata = right$(rdata, len(rdata) - 8)
    
    name = readfield(1, rdata, 32)
    i = val(readfield(1, rdata, 32))
    name = right$(rdata, len(rdata) - (len(name) + 1))
    
    tindex = nameindex(name)
    
'    if ucase$(name) = "morgolock" then exit sub
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
        call senddata(toindex, userindex, 0, "||no podes encarcelar a alguien con jerarquia mayor a la tuya." & fonttype_info)
        exit sub
    end if
    
    if i > 30 then
        call senddata(toindex, userindex, 0, "||no podes encarcelar por mas de 30 minutos." & fonttype_info)
        exit sub
    end if
    
    call encarcelar(tindex, i, userlist(userindex).name)
    
    exit sub
end if

'perdon
if ucase$(left$(rdata, 7)) = "/perdon" then
    rdata = right$(rdata, len(rdata) - 8)
    tindex = nameindex(rdata)
    if tindex > 0 then
        
        if esnewbie(tindex) then
                call volverciudadano(tindex)
        else
                call loggm(userlist(userindex).name, "intento perdonar un personaje de nivel avanzado.", false)
                call senddata(toindex, userindex, 0, "||solo se permite perdonar newbies." & fonttype_info)
        end if
        
    end if
    exit sub
end if

'echar usuario
if ucase$(left$(rdata, 7)) = "/echar " then
    rdata = right$(rdata, len(rdata) - 7)
    tindex = nameindex(rdata)
    if ucase$(rdata) = "morgolock" then exit sub
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
        call senddata(toindex, userindex, 0, "||no podes echar a alguien con jerarquia mayor a la tuya." & fonttype_info)
        exit sub
    end if
        
    call senddata(toall, 0, 0, "||" & userlist(userindex).name & " echo a " & userlist(tindex).name & "." & fonttype_info)
    call closesocket(tindex)
    call loggm(userlist(userindex).name, "echo a " & userlist(tindex).name, false)
    exit sub
end if


if ucase$(left$(rdata, 5)) = "/ban " then
    rdata = right$(rdata, len(rdata) - 5)
    tindex = nameindex(readfield(2, rdata, asc("@")))
    name = readfield(1, rdata, asc("@"))
    
    if ucase$(rdata) = "morgolock" then exit sub
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
        call senddata(toindex, userindex, 0, "||no podes banear a al alguien de mayor jerarquia." & fonttype_info)
        exit sub
    end if
    
    call logban(tindex, userindex, name)
    
    call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " echo a " & userlist(tindex).name & "." & fonttype_fight)
    call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " banned a " & userlist(tindex).name & "." & fonttype_fight)
    
    'ponemos el flag de ban a 1
    userlist(tindex).flags.ban = 1
    
    if userlist(tindex).flags.privilegios > 0 then
            userlist(userindex).flags.ban = 1
            call closesocket(userindex)
            call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " banned by the server por bannear un administrador." & fonttype_fight)
    end if
    
    call loggm(userlist(userindex).name, "echo a " & userlist(tindex).name, false)
    call loggm(userlist(userindex).name, "ban a " & userlist(tindex).name, false)
    call closesocket(tindex)
    exit sub
end if

if ucase$(left$(rdata, 7)) = "/unban " then
    rdata = right$(rdata, len(rdata) - 7)
    call unban(rdata)
    call loggm(userlist(userindex).name, "/unban a " & rdata, false)
    call senddata(toindex, userindex, 0, "||" & rdata & " unbanned." & fonttype_info)
    exit sub
end if


'seguir
if ucase$(rdata) = "/seguir" then
    if userlist(userindex).flags.targetnpc > 0 then
        call dofollow(userlist(userindex).flags.targetnpc, userlist(userindex).name)
    end if
    exit sub
end if

'summon
if ucase$(left$(rdata, 5)) = "/sum " then
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el jugador no esta online." & fonttype_info)
        exit sub
    end if
    
    call senddata(toindex, tindex, 0, "||" & userlist(userindex).name & " h� sido trasportado." & fonttype_info)
    call warpuserchar(tindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y + 1, true)
    
    call loggm(userlist(userindex).name, "/sum " & userlist(tindex).name & " map:" & userlist(userindex).pos.map & " x:" & userlist(userindex).pos.x & " y:" & userlist(userindex).pos.y, false)
    exit sub
end if

'crear criatura
if ucase$(left$(rdata, 3)) = "/cc" then
   call enviarspawnlist(userindex)
   exit sub
end if

'spawn!!!!!
if ucase$(left$(rdata, 3)) = "spa" then
    rdata = right$(rdata, len(rdata) - 3)
    
    if val(rdata) > 0 and val(rdata) < ubound(spawnlist) + 1 then _
          call spawnnpc(spawnlist(val(rdata)).npcindex, userlist(userindex).pos, true, false)
          
          call loggm(userlist(userindex).name, "sumoneo " & spawnlist(val(rdata)).npcname, false)
          
    exit sub
end if

'resetea el inventario
if ucase$(rdata) = "/resetinv" then
    rdata = right$(rdata, len(rdata) - 9)
    if userlist(userindex).flags.targetnpc = 0 then exit sub
    call resetnpcinv(userlist(userindex).flags.targetnpc)
    call loggm(userlist(userindex).name, "/resetinv " & npclist(userlist(userindex).flags.targetnpc).name, false)
    exit sub
end if

'/clean
if ucase$(rdata) = "/limpiar" then
    call limpiarmundo
    exit sub
end if

'mensaje del servidor
if ucase$(left$(rdata, 6)) = "/rmsg " then
    rdata = right$(rdata, len(rdata) - 6)
    call loggm(userlist(userindex).name, "mensaje broadcast:" & rdata, false)
    if rdata <> "" then
        call senddata(toall, 0, 0, "||" & rdata & fonttype_talk & endc)
    end if
    exit sub
end if

'ip del nick
if ucase$(left$(rdata, 8)) = "/ipnick " then
    rdata = right$(rdata, len(rdata) - 8)
    tindex = nameindex(ucase$(rdata))
    if tindex > 0 then
       call senddata(toindex, userindex, 0, "||el ip de " & rdata & " es " & userlist(tindex).ip & fonttype_info)
    end if
    exit sub
end if

'ip del nick
if ucase$(left$(rdata, 8)) = "/nickip " then
    rdata = right$(rdata, len(rdata) - 8)
    tindex = ip_index(rdata)
    if tindex > 0 then
       call senddata(toindex, userindex, 0, "||el nick del ip " & rdata & " es " & userlist(tindex).name & fonttype_info)
    end if
    exit sub
end if



'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
if userlist(userindex).flags.privilegios < 3 then
    exit sub
end if

'ban x ip
if ucase(left(rdata, 6)) = "/banip" then
    dim banip as string, xnick as boolean
    
    rdata = right(rdata, len(rdata) - 7)
    'busca primero la ip del nick
    tindex = nameindex(rdata)
    if tindex <= 0 then
        xnick = false
        call loggm(userlist(userindex).name, "/banip " & rdata, false)
        banip = rdata
    else
        xnick = true
        call loggm(userlist(userindex).name, "/banip " & userlist(tindex).name & " - " & userlist(tindex).ip, false)
        banip = userlist(tindex).ip
    end if
    
    'se fija si esta baneada
    for loopc = 1 to banips.count
        if banips.item(loopc) = banip then
            call senddata(toindex, userindex, 0, "||la ip " & banip & " ya se encuentra en la lista de bans." & fonttype_info)
            exit sub
        end if
    next loopc
    
    banips.add banip
    call senddata(toadmins, userindex, 0, "||" & userlist(userindex).name & " baneo la ip " & banip & fonttype_fight)
    
    if xnick = true then
        call logban(tindex, userindex, "ban por ip desde nick")
        
        call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " echo a " & userlist(tindex).name & "." & fonttype_fight)
        call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " banned a " & userlist(tindex).name & "." & fonttype_fight)
        
        'ponemos el flag de ban a 1
        userlist(tindex).flags.ban = 1
        
        call loggm(userlist(userindex).name, "echo a " & userlist(tindex).name, false)
        call loggm(userlist(userindex).name, "ban a " & userlist(tindex).name, false)
        call closesocket(tindex)
    end if
    
    exit sub
end if

'desbanea una ip
if ucase(left(rdata, 8)) = "/unbanip" then
    
    
    rdata = right(rdata, len(rdata) - 9)
    call loggm(userlist(userindex).name, "/unbanip " & rdata, false)
    
    for loopc = 1 to banips.count
        if banips.item(loopc) = rdata then
            banips.remove loopc
            call senddata(toindex, userindex, 0, "||la ip " & banip & " se ha quitado de la lista de bans." & fonttype_info)
            exit sub
        end if
    next loopc
    
    call senddata(toindex, userindex, 0, "||la ip " & rdata & " no se encuentra en la lista de bans." & fonttype_info)
    
    exit sub
end if

'crear teleport
if ucase(left(rdata, 3)) = "/ct" then
    '/ct mapa_dest x_dest y_dest
    rdata = right(rdata, len(rdata) - 4)
    call loggm(userlist(userindex).name, "/ct: " & rdata, false)
    mapa = readfield(1, rdata, 32)
    x = readfield(2, rdata, 32)
    y = readfield(3, rdata, 32)
    
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).objinfo.objindex > 0 then
        exit sub
    end if
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map > 0 then
        exit sub
    end if
    if mapavalido(mapa) = false or inmapbounds(mapa, x, y) = false then
        exit sub
    end if
    
    dim et as obj
    et.amount = 1
    et.objindex = 378
    
    call makeobj(tomap, 0, userlist(userindex).pos.map, et, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1)
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map = mapa
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.x = x
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.y = y
    
    exit sub
end if

'destruir teleport
'toma el ultimo click
if ucase(left(rdata, 3)) = "/dt" then
    '/dt
    call loggm(userlist(userindex).name, "/dt", false)
    
    mapa = userlist(userindex).flags.targetmap
    x = userlist(userindex).flags.targetx
    y = userlist(userindex).flags.targety
    
    if objdata(mapdata(mapa, x, y).objinfo.objindex).objtype = objtype_teleport and _
        mapdata(mapa, x, y).tileexit.map > 0 then
        call eraseobj(tomap, 0, mapa, mapdata(mapa, x, y).objinfo.amount, mapa, x, y)
        mapdata(mapa, x, y).tileexit.map = 0
        mapdata(mapa, x, y).tileexit.x = 0
        mapdata(mapa, x, y).tileexit.y = 0
    end if
    
    exit sub
end if

'destruir
if ucase$(left$(rdata, 5)) = "/dest" then
    call loggm(userlist(userindex).name, "/dest", false)
    rdata = right$(rdata, len(rdata) - 5)
    call eraseobj(tomap, userindex, userlist(userindex).pos.map, 10000, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
    exit sub
end if

'bloquear
if ucase$(left$(rdata, 5)) = "/bloq" then
    call loggm(userlist(userindex).name, "/bloq", false)
    rdata = right$(rdata, len(rdata) - 5)
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 0 then
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 1
        call bloquear(tomap, userindex, userlist(userindex).pos.map, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y, 1)
    else
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 0
        call bloquear(tomap, userindex, userlist(userindex).pos.map, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y, 0)
    end if
    exit sub
end if

'quitar npc
if ucase$(rdata) = "/mata" then
    rdata = right$(rdata, len(rdata) - 5)
    if userlist(userindex).flags.targetnpc = 0 then exit sub
    call quitarnpc(userlist(userindex).flags.targetnpc)
    call loggm(userlist(userindex).name, "/mata " & npclist(userlist(userindex).flags.targetnpc).name, false)
    exit sub
end if

'quita todos los npcs del area
if ucase$(rdata) = "/masskill" then
    for y = userlist(userindex).pos.y - minyborder + 1 to userlist(userindex).pos.y + minyborder - 1
            for x = userlist(userindex).pos.x - minxborder + 1 to userlist(userindex).pos.x + minxborder - 1
                if x > 0 and y > 0 and x < 101 and y < 101 then _
                    if mapdata(userlist(userindex).pos.map, x, y).npcindex > 0 then call quitarnpc(mapdata(userlist(userindex).pos.map, x, y).npcindex)
            next x
    next y
    call loggm(userlist(userindex).name, "/masskill", false)
    exit sub
end if

'quita todos los npcs del area
if ucase$(rdata) = "/limpiar" then
        call limpiarmundo
        exit sub
end if

'mensaje del sistema
if ucase$(left$(rdata, 6)) = "/smsg " then
    rdata = right$(rdata, len(rdata) - 6)
    call loggm(userlist(userindex).name, "mensaje de sistema:" & rdata, false)
    call senddata(toall, 0, 0, "!!" & rdata & endc)
    
    exit sub
end if

'crear criatura, toma directamente el indice
if ucase$(left$(rdata, 5)) = "/acc " then
   rdata = right$(rdata, len(rdata) - 5)
   call spawnnpc(val(rdata), userlist(userindex).pos, true, false)
   exit sub
end if

'crear criatura con respawn, toma directamente el indice
if ucase$(left$(rdata, 6)) = "/racc " then
   rdata = right$(rdata, len(rdata) - 6)
   call spawnnpc(val(rdata), userlist(userindex).pos, true, true)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai1 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial1 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai2 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial1 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai3 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial3 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai4 " then
   rdata = right$(rdata, len(rdata) - 5)
   tunicamagoimperial = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac1 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos1 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac2 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos2 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac3 " then
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos3 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac4 " then
   rdata = right$(rdata, len(rdata) - 5)
   tunicamagocaos = val(rdata)
   exit sub
end if



'comando para depurar la navegacion
if ucase$(rdata) = "/nave" then
    if userlist(userindex).flags.navegando = 1 then
        userlist(userindex).flags.navegando = 0
    else
        userlist(userindex).flags.navegando = 1
    end if
    exit sub
end if

'apagamos
if ucase$(rdata) = "/apagar" then
    if ucase$(userlist(userindex).name) <> "morgolock" then
        call loggm(userlist(userindex).name, "���intento apagar el server!!!", false)
        exit sub
    end if
    'log
    mifile = freefile
    open app.path & "\logs\main.log" for append shared as #mifile
    print #mifile, date & " " & time & " server apagado por " & userlist(userindex).name & ". "
    close #mifile
    unload frmmain
    exit sub
end if

'condena
if ucase$(left$(rdata, 7)) = "/conden" then
    rdata = right$(rdata, len(rdata) - 8)
    tindex = nameindex(rdata)
    if tindex > 0 then call volvercriminal(tindex)
    exit sub
end if

if ucase$(left$(rdata, 7)) = "/rajar " then
    rdata = right$(rdata, len(rdata) - 7)
    tindex = nameindex(ucase$(rdata))
    if tindex > 0 then
        call resetfacciones(tindex)
    end if
    exit sub
end if

'modifica caracter
if ucase$(left$(rdata, 5)) = "/mod " then
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 5)
    tindex = nameindex(readfield(1, rdata, 32))
    arg1 = readfield(2, rdata, 32)
    arg2 = readfield(3, rdata, 32)
    arg3 = readfield(4, rdata, 32)
    arg4 = readfield(5, rdata, 32)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    
    select case ucase$(arg1)
    
        case "oro"
            if val(arg2) < 95001 then
                userlist(tindex).stats.gld = val(arg2)
                call senduserstatsbox(tindex)
            else
                call senddata(toindex, userindex, 0, "||no esta permitido utilizar valores mayores a 95000. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
        case "exp"
            if val(arg2) < 9995001 then
                if userlist(tindex).stats.exp + val(arg2) > _
                   userlist(tindex).stats.elu then
                   dim resto
                   resto = val(arg2) - userlist(tindex).stats.elu
                   userlist(tindex).stats.exp = userlist(tindex).stats.exp + userlist(tindex).stats.elu
                   call checkuserlevel(tindex)
                   userlist(tindex).stats.exp = userlist(tindex).stats.exp + resto
                else
                   userlist(tindex).stats.exp = val(arg2)
                end if
                call senduserstatsbox(tindex)
            else
                call senddata(toindex, userindex, 0, "||no esta permitido utilizar valores mayores a 5000. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
   
       
        case "body"
            call changeuserchar(tomap, 0, userlist(tindex).pos.map, tindex, val(arg2), userlist(tindex).char.head, userlist(tindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            exit sub
        case "head"
            call changeuserchar(tomap, 0, userlist(tindex).pos.map, tindex, userlist(tindex).char.body, val(arg2), userlist(tindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            exit sub
        case "cri"
            userlist(tindex).faccion.criminalesmatados = val(arg2)
            exit sub
        case "ciu"
            userlist(tindex).faccion.ciudadanosmatados = val(arg2)
            exit sub
        case "level"
            userlist(tindex).stats.elv = val(arg2)
            exit sub
        case else
            call senddata(toindex, userindex, 0, "||comando no permitido." & fonttype_info)
            exit sub
    end select

    exit sub
end if


if ucase$(left$(rdata, 9)) = "/dobackup" then
    call dobackup
    exit sub
end if

if ucase$(left$(rdata, 7)) = "/grabar" then
    call guardarusuarios
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/borrar sos" then
    call ayuda.reset
    exit sub
end if

if ucase$(left$(rdata, 9)) = "/show int" then
    call frmmain.mnumostrar_click
    exit sub
end if

if ucase$(rdata) = "/lluvia" then
    lloviendo = not lloviendo
    call senddata(toall, 0, 0, "llu")
    exit sub
end if

if ucase$(rdata) = "/passday" then
    call dayelapsed
    exit sub
end if


exit sub


errorhandler:
 call logerror("handledata. cadori:" & cadenaoriginal & " nom:" & userlist(userindex).name & "ui:" & userindex & " n: " & err.number & " d: " & err.description)
 'call closesocket(userindex)
 call cerrar_usuario(userindex)
 
 

end sub

sub reloadsokcet()

on error goto errhandler

    frmmain.socket1.cleanup
    call configlisteningsocket(frmmain.socket1, puerto)


exit sub
errhandler:
    call logerror("error en checksocketstate," & err.description)

end sub



public sub eventosockaccept(sockid as long)
#if usarapi then
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
    
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "nextopenuser" & vbcrlf
    
    newindex = nextopenuser ' nuevo indice
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "userindex asignado " & newindex & vbcrlf
    
    if newindex <= maxusers then
        if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "cargando socket " & newindex & vbcrlf
        '=============================================
        'sockid es en este caso es el socket de escucha,
        'a diferencia de socketwrench que es el nuevo
        'socket de la nueva conn
        
        tam = sockaddr_size
        
        ret = accept(sockid, sa, tam)
        if ret = invalid_socket then
            call logcriticevent("error en accept() api")
            exit sub
        end if
        nuevosock = ret
        
        userlist(newindex).ip = getascip(sa.sin_addr)
        
        'busca si esta banneada la ip
        for i = 1 to banips.count
            if banips.item(i) = userlist(newindex).ip then
                call apiclosesocket(nuevosock)
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
            call apiclosesocket(nuevosock)
            'exit sub
        end if
        
        userlist(newindex).connid = nuevosock
        set userlist(newindex).commandsbuffer = new ccolaarray

        if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & userlist(newindex).ip & " logged." & vbcrlf
    else
        call logcriticevent("no acepte conexion porque no tenia slots")
    end if
    
#end if
end sub

public sub eventosockread(slot as integer, byref datos as string)
#if usarapi then

dim t() as string
dim loopc as long

userlist(slot).rdbuffer = userlist(slot).rdbuffer & datos

if instr(1, userlist(slot).rdbuffer, chr(2)) > 0 then
    userlist(slot).rdbuffer = "clienteviejo" & endc
    debug.print "clienteviejo"
end if

t = split(userlist(slot).rdbuffer, endc)
if ubound(t) > 0 then
    userlist(slot).rdbuffer = t(ubound(t))
    
    for loopc = 0 to ubound(t) - 1
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        '%%% si esta opcion se activa soluciona %%%
        '%%% el problema del speedhack          %%%
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if clientscommandsqueue = 1 then
            if t(loopc) <> "" then if not userlist(slot).commandsbuffer.push(t(loopc)) then call cerrar_usuario(slot)
        
        else ' sh tiebe efecto
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

public sub eventosockclose(slot as integer)
#if usarapi then
    if userlist(slot).flags.userlogged then
        call cerrar_usuario(slot)
    else
        call closesocket(slot)
    end if
#end if
end sub

