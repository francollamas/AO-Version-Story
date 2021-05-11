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

'rutas de envio de datos
public enum sendtarget
    toindex = 0         'envia a un solo user
    toall = 1           'a todos los users
    tomap = 2           'todos los usuarios en el mapa
    topcarea = 3        'todos los users en el area de un user determinado
    tonone = 4          'ninguno
    toallbutindex = 5   'todos menos el index
    tomapbutindex = 6   'todos en el mapa menos el indice
    togm = 7
    tonpcarea = 8       'todos los users en el area de un user determinado
    toguildmembers = 9
    toadmins = 10
    topcareabutindex = 11
    toadminsareabutconsejeros = 12
    todiosesyclan = 13
    toconsejo = 14
    toclanarea = 15
    toconsejocaos = 16
    torolesmasters = 17
    todeadarea = 18
    tociudadanos = 19
    tocriminales = 20
    topartyarea = 21
    toreal = 22
    tocaos = 23
    tociudadanosyrms = 24
    tocriminalesyrms = 25
    torealyrms = 26
    tocaosyrms = 27
end enum


#if usarquesocket = 0 then
' general constants used with most of the controls
public const invalid_handle as integer = -1
public const control_errignore as integer = 0
public const control_errdisplay as integer = 1


' societwrench control actions
public const socket_open as integer = 1
public const socket_connect as integer = 2
public const socket_listen as integer = 3
public const socket_accept as integer = 4
public const socket_cancel as integer = 5
public const socket_flush as integer = 6
public const socket_close as integer = 7
public const socket_disconnect as integer = 7
public const socket_abort as integer = 8

' socketwrench control states
public const socket_none as integer = 0
public const socket_idle as integer = 1
public const socket_listening as integer = 2
public const socket_connecting as integer = 3
public const socket_accepting as integer = 4
public const socket_receiving as integer = 5
public const socket_sending as integer = 6
public const socket_closing as integer = 7

' societ address families
public const af_unspec as integer = 0
public const af_unix as integer = 1
public const af_inet as integer = 2

' societ types
public const sock_stream as integer = 1
public const sock_dgram as integer = 2
public const sock_raw as integer = 3
public const sock_rdm as integer = 4
public const sock_seqpacket as integer = 5

' protocol types
public const ipproto_ip as integer = 0
public const ipproto_icmp as integer = 1
public const ipproto_ggp as integer = 2
public const ipproto_tcp as integer = 6
public const ipproto_pup as integer = 12
public const ipproto_udp as integer = 17
public const ipproto_idp as integer = 22
public const ipproto_nd as integer = 77
public const ipproto_raw as integer = 255
public const ipproto_max as integer = 256


' network addpesses
public const inaddr_any as string = "0.0.0.0"
public const inaddr_loopback as string = "127.0.0.1"
public const inaddr_none as string = "255.055.255.255"

' shutdown values
public const socket_read as integer = 0
public const socket_write as integer = 1
public const socket_readwrite as integer = 2

' socketwrench error pesponse
public const socket_errignore as integer = 0
public const socket_errdisplay as integer = 1

' socketwrench error codes
public const wsabaseerr as integer = 24000
public const wsaeintr as integer = 24004
public const wsaebadf as integer = 24009
public const wsaeacces as integer = 24013
public const wsaefault as integer = 24014
public const wsaeinval as integer = 24022
public const wsaemfile as integer = 24024
public const wsaewouldblock as integer = 24035
public const wsaeinprogress as integer = 24036
public const wsaealready as integer = 24037
public const wsaenotsock as integer = 24038
public const wsaedestaddrreq as integer = 24039
public const wsaemsgsize as integer = 24040
public const wsaeprototype as integer = 24041
public const wsaenoprotoopt as integer = 24042
public const wsaeprotonosupport as integer = 24043
public const wsaesocktnosupport as integer = 24044
public const wsaeopnotsupp as integer = 24045
public const wsaepfnosupport as integer = 24046
public const wsaeafnosupport as integer = 24047
public const wsaeaddrinuse as integer = 24048
public const wsaeaddrnotavail as integer = 24049
public const wsaenetdown as integer = 24050
public const wsaenetunreach as integer = 24051
public const wsaenetreset as integer = 24052
public const wsaeconnaborted as integer = 24053
public const wsaeconnreset as integer = 24054
public const wsaenobufs as integer = 24055
public const wsaeisconn as integer = 24056
public const wsaenotconn as integer = 24057
public const wsaeshutdown as integer = 24058
public const wsaetoomanyrefs as integer = 24059
public const wsaetimedout as integer = 24060
public const wsaeconnrefused as integer = 24061
public const wsaeloop as integer = 24062
public const wsaenametoolong as integer = 24063
public const wsaehostdown as integer = 24064
public const wsaehostunreach as integer = 24065
public const wsaenotempty as integer = 24066
public const wsaeproclim as integer = 24067
public const wsaeusers as integer = 24068
public const wsaedquot as integer = 24069
public const wsaestale as integer = 24070
public const wsaeremote as integer = 24071
public const wsasysnotready as integer = 24091
public const wsavernotsupported as integer = 24092
public const wsanotinitialised as integer = 24093
public const wsahost_not_found as integer = 25001
public const wsatry_again as integer = 25002
public const wsano_recovery as integer = 25003
public const wsano_data as integer = 25004
public const wsano_address as integer = 2500
#end if

sub darcuerpoycabeza(byref userbody as integer, byref userhead as integer, byval raza as string, byval gen as string)
'todo: poner las heads en arrays, as� se acceden por �ndices
'y no hay problemas de discontinuidad de los �ndices.
'tambi�n se debe usar enums para raza y sexo
select case gen
   case "hombre"
        select case raza
            case "humano"
                userhead = randomnumber(1, 30)
                userbody = 1
            case "elfo"
                userhead = randomnumber(1, 13) + 100
                if userhead = 113 then userhead = 201       'un �ndice no es continuo.... :s muy feo
                userbody = 2
            case "elfo oscuro"
                userhead = randomnumber(1, 8) + 201
                userbody = 3
            case "enano"
                userhead = randomnumber(1, 5) + 300
                userbody = 52
            case "gnomo"
                userhead = randomnumber(1, 6) + 400
                userbody = 52
            case else
                userhead = 1
                userbody = 1
        end select
   case "mujer"
        select case raza
            case "humano"
                userhead = randomnumber(1, 7) + 69
                userbody = 1
            case "elfo"
                userhead = randomnumber(1, 7) + 169
                userbody = 2
            case "elfo oscuro"
                userhead = randomnumber(1, 11) + 269
                userbody = 3
            case "gnomo"
                userhead = randomnumber(1, 5) + 469
                userbody = 52
            case "enano"
                userhead = randomnumber(1, 3) + 369
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

'barrin 3/3/03
'agregu� padrinoname y padrino password como opcionales, que se les da un valor siempre y cuando el servidor est� usando el sistema
sub connectnewuser(userindex as integer, name as string, password as string, userraza as string, usersexo as string, userclase as string, _
                    us1 as string, us2 as string, us3 as string, us4 as string, us5 as string, _
                    us6 as string, us7 as string, us8 as string, us9 as string, us10 as string, _
                    us11 as string, us12 as string, us13 as string, us14 as string, us15 as string, _
                    us16 as string, us17 as string, us18 as string, us19 as string, us20 as string, _
                    us21 as string, useremail as string, hogar as string)

if not asciivalidos(name) then
    call senddata(sendtarget.toindex, userindex, 0, "errnombre invalido.")
    exit sub
end if

dim loopc as integer
dim totalskpts as long

'�existe el personaje?
if fileexist(charpath & ucase$(name) & ".chr", vbnormal) = true then
    call senddata(sendtarget.toindex, userindex, 0, "errya existe el personaje.")
    exit sub
end if

'tir� los dados antes de llegar ac�??
if userlist(userindex).stats.useratributos(eatributos.fuerza) = 0 then
    call senddata(sendtarget.toindex, userindex, 0, "errdebe tirar los dados antes de poder crear un personaje.")
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

select case ucase$(userraza)
    case "humano"
        userlist(userindex).stats.useratributos(eatributos.fuerza) = userlist(userindex).stats.useratributos(eatributos.fuerza) + 1
        userlist(userindex).stats.useratributos(eatributos.agilidad) = userlist(userindex).stats.useratributos(eatributos.agilidad) + 1
        userlist(userindex).stats.useratributos(eatributos.constitucion) = userlist(userindex).stats.useratributos(eatributos.constitucion) + 2
    case "elfo"
        userlist(userindex).stats.useratributos(eatributos.agilidad) = userlist(userindex).stats.useratributos(eatributos.agilidad) + 4
        userlist(userindex).stats.useratributos(eatributos.inteligencia) = userlist(userindex).stats.useratributos(eatributos.inteligencia) + 2
        userlist(userindex).stats.useratributos(eatributos.carisma) = userlist(userindex).stats.useratributos(eatributos.carisma) + 2
    case "elfo oscuro"
        userlist(userindex).stats.useratributos(eatributos.fuerza) = userlist(userindex).stats.useratributos(eatributos.fuerza) + 2
        userlist(userindex).stats.useratributos(eatributos.agilidad) = userlist(userindex).stats.useratributos(eatributos.agilidad) + 2
        userlist(userindex).stats.useratributos(eatributos.inteligencia) = userlist(userindex).stats.useratributos(eatributos.inteligencia) + 2
        userlist(userindex).stats.useratributos(eatributos.carisma) = userlist(userindex).stats.useratributos(eatributos.carisma) - 3
    case "enano"
        userlist(userindex).stats.useratributos(eatributos.fuerza) = userlist(userindex).stats.useratributos(eatributos.fuerza) + 3
        userlist(userindex).stats.useratributos(eatributos.constitucion) = userlist(userindex).stats.useratributos(eatributos.constitucion) + 3
        userlist(userindex).stats.useratributos(eatributos.inteligencia) = userlist(userindex).stats.useratributos(eatributos.inteligencia) - 6
        userlist(userindex).stats.useratributos(eatributos.agilidad) = userlist(userindex).stats.useratributos(eatributos.agilidad) - 1
        userlist(userindex).stats.useratributos(eatributos.carisma) = userlist(userindex).stats.useratributos(eatributos.carisma) - 2
    case "gnomo"
        userlist(userindex).stats.useratributos(eatributos.fuerza) = userlist(userindex).stats.useratributos(eatributos.fuerza) - 4
        userlist(userindex).stats.useratributos(eatributos.inteligencia) = userlist(userindex).stats.useratributos(eatributos.inteligencia) + 3
        userlist(userindex).stats.useratributos(eatributos.agilidad) = userlist(userindex).stats.useratributos(eatributos.agilidad) + 3
        userlist(userindex).stats.useratributos(eatributos.carisma) = userlist(userindex).stats.useratributos(eatributos.carisma) + 1
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
userlist(userindex).char.heading = eheading.south

call darcuerpoycabeza(userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).raza, userlist(userindex).genero)
userlist(userindex).origchar = userlist(userindex).char
   
 
userlist(userindex).char.weaponanim = ningunarma
userlist(userindex).char.shieldanim = ningunescudo
userlist(userindex).char.cascoanim = ninguncasco

userlist(userindex).stats.met = 1
dim miint as long
miint = randomnumber(1, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 3)

userlist(userindex).stats.maxhp = 15 + miint
userlist(userindex).stats.minhp = 15 + miint

userlist(userindex).stats.fit = 1


miint = randomnumber(1, userlist(userindex).stats.useratributos(eatributos.agilidad) \ 6)
if miint = 1 then miint = 2

userlist(userindex).stats.maxsta = 20 * miint
userlist(userindex).stats.minsta = 20 * miint


userlist(userindex).stats.maxagu = 100
userlist(userindex).stats.minagu = 100

userlist(userindex).stats.maxham = 100
userlist(userindex).stats.minham = 100


'<-----------------mana----------------------->
if ucase$(userclase) = "mago" then
    miint = randomnumber(1, userlist(userindex).stats.useratributos(eatributos.inteligencia)) / 3
    userlist(userindex).stats.maxman = 100 + miint
    userlist(userindex).stats.minman = 100 + miint
elseif ucase$(userclase) = "clerigo" or ucase$(userclase) = "druida" _
    or ucase$(userclase) = "bardo" or ucase$(userclase) = "asesino" then
        miint = randomnumber(1, userlist(userindex).stats.useratributos(eatributos.inteligencia)) / 4
        userlist(userindex).stats.maxman = 50
        userlist(userindex).stats.minman = 50
else
    userlist(userindex).stats.maxman = 0
    userlist(userindex).stats.minman = 0
end if

if ucase$(userclase) = "mago" or ucase$(userclase) = "clerigo" or _
   ucase$(userclase) = "druida" or ucase$(userclase) = "bardo" or _
   ucase$(userclase) = "asesino" then
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

userlist(userindex).invent.armoureqpslot = 4
userlist(userindex).invent.armoureqpobjindex = userlist(userindex).invent.object(4).objindex

userlist(userindex).invent.weaponeqpobjindex = userlist(userindex).invent.object(3).objindex
userlist(userindex).invent.weaponeqpslot = 3



call saveuser(userindex, charpath & ucase$(name) & ".chr")
  
'open user
call connectuser(userindex, name, password)
  
end sub

#if usarquesocket = 1 or usarquesocket = 2 then

sub closesocket(byval userindex as integer, optional byval cerrarlo as boolean = true)
dim loopc as integer

on error goto errhandler
    
    if userindex = lastuser then
        do until userlist(lastuser).flags.userlogged
            lastuser = lastuser - 1
            if lastuser < 1 then exit do
        loop
    end if
    
    'call securityip.iprestarconexion(getlongip(userlist(userindex).ip))
    
    if userlist(userindex).connid <> -1 then
        call closesocketsl(userindex)
    end if
    
    'es el mismo user al que est� revisando el centinela??
    'importante!!! hacerlo antes de resetear as� todav�a sabemos el nombre del user
    ' y lo podemos loguear
    if centinela.revisandouserindex = userindex then _
        call modcentinela.centinelauserlogout
    
    'mato los comercios seguros
    if userlist(userindex).comusu.destusu > 0 then
        if userlist(userlist(userindex).comusu.destusu).flags.userlogged then
            if userlist(userlist(userindex).comusu.destusu).comusu.destusu = userindex then
                call senddata(sendtarget.toindex, userlist(userindex).comusu.destusu, 0, "||comercio cancelado por el otro usuario" & fonttype_talk)
                call fincomerciarusu(userlist(userindex).comusu.destusu)
            end if
        end if
    end if
    
    if userlist(userindex).flags.userlogged then
        if numusers > 0 then numusers = numusers - 1
        call closeuser(userindex)
        
        call estadisticasweb.informar(cantidad_online, numusers)
    else
        call resetuserslot(userindex)
    end if
    
    userlist(userindex).connid = -1
    userlist(userindex).connidvalida = false
    userlist(userindex).numeropaquetespormilisec = 0
    
exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).connidvalida = false
    userlist(userindex).numeropaquetespormilisec = 0
    call resetuserslot(userindex)
    
#if usarquesocket = 1 then
    if userlist(userindex).connid <> -1 then
        call closesocketsl(userindex)
    end if
#end if

    call logerror("closesocket - error = " & err.number & " - descripci�n = " & err.description & " - userindex = " & userindex)
end sub

#elseif usarquesocket = 0 then

sub closesocket(byval userindex as integer)
on error goto errhandler
    
    
    
    userlist(userindex).connid = -1
    userlist(userindex).numeropaquetespormilisec = 0

    if userindex = lastuser and lastuser > 1 then
        do until userlist(lastuser).flags.userlogged
            lastuser = lastuser - 1
            if lastuser <= 1 then exit do
        loop
    end if

    if userlist(userindex).flags.userlogged then
            if numusers <> 0 then numusers = numusers - 1
            call closeuser(userindex)
    end if

    frmmain.socket2(userindex).cleanup
    unload frmmain.socket2(userindex)
    call resetuserslot(userindex)

exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).numeropaquetespormilisec = 0
    call resetuserslot(userindex)
end sub







#elseif usarquesocket = 3 then

sub closesocket(byval userindex as integer, optional byval cerrarlo as boolean = true)

on error goto errhandler

dim nurestados as boolean
dim connectionid as long


    nurestados = false
    connectionid = userlist(userindex).connid
    
    'call logindex(userindex, "******> sub closesocket. connid: " & connectionid & " cerrarlo: " & cerrarlo)
    
    
  
    userlist(userindex).connid = -1 'inabilitamos operaciones en socket
    userlist(userindex).numeropaquetespormilisec = 0

    if userindex = lastuser and lastuser > 1 then
        do
            lastuser = lastuser - 1
            if lastuser <= 1 then exit do
        loop while userlist(lastuser).connid = -1
    end if

    if userlist(userindex).flags.userlogged then
            if numusers <> 0 then numusers = numusers - 1
            nurestados = true
            call closeuser(userindex)
    end if
    
    call resetuserslot(userindex)
    
    'limpiada la userlist... reseteo el socket, si me lo piden
    'me lo piden desde: cerrada intecional del servidor (casi todas
    'las llamadas a closesocket del codigo)
    'no me lo piden desde: disconnect remoto (el on_close del control
    'de alejo realiza la desconexion automaticamente). esto puede pasar
    'por ejemplo, si el cliente cierra el ao.
    if cerrarlo then call frmmain.tcpserv.cerrarsocket(connectionid)

exit sub

errhandler:
    userlist(userindex).numeropaquetespormilisec = 0
    call logerror("closesocketerr: " & err.description & " ui:" & userindex)
    
    if not nurestados then
        if userlist(userindex).flags.userlogged then
            if numusers > 0 then
                numusers = numusers - 1
            end if
            call logerror("cerre sin grabar a: " & userlist(userindex).name)
        end if
    end if
    
    call logerror("el usuario no guardado tenia connid " & connectionid & ". socket no liberado.")
    call resetuserslot(userindex)

end sub


#end if

'[alejo-21-5]: cierra un socket sin limpiar el slot
sub closesocketsl(byval userindex as integer)

#if usarquesocket = 1 then

if userlist(userindex).connid <> -1 and userlist(userindex).connidvalida then
    call borraslotsock(userlist(userindex).connid)
    call wsapiclosesocket(userlist(userindex).connid)
    userlist(userindex).connidvalida = false
end if

#elseif usarquesocket = 0 then

if userlist(userindex).connid <> -1 and userlist(userindex).connidvalida then
    frmmain.socket2(userindex).cleanup
    unload frmmain.socket2(userindex)
    userlist(userindex).connidvalida = false
end if

#elseif usarquesocket = 2 then

if userlist(userindex).connid <> -1 and userlist(userindex).connidvalida then
    call frmmain.serv.cerrarsocket(userlist(userindex).connid)
    userlist(userindex).connidvalida = false
end if

#end if
end sub

public function enviardatosaslot(byval userindex as integer, datos as string) as long

#if usarquesocket = 1 then '**********************************************
    on error goto err
    
    dim ret as long
    
    
    
    ret = wsapienviar(userindex, datos)
    
    if ret <> 0 and ret <> wsaewouldblock then
        call closesocketsl(userindex)
        call cerrar_usuario(userindex)
    end if
    enviardatosaslot = ret
    exit function
    
err:
        'if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: err handler. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida & " err: " & err.description)

#elseif usarquesocket = 0 then '**********************************************

    dim encolar as boolean
    encolar = false
    
    enviardatosaslot = 0
    
    if userlist(userindex).colasalida.count <= 0 then
        if frmmain.socket2(userindex).write(datos, len(datos)) < 0 then
            if frmmain.socket2(userindex).lasterror = wsaewouldblock then
                userlist(userindex).sockpuedoenviar = false
                encolar = true
            else
                call cerrar_usuario(userindex)
            end if
        end if
    else
        encolar = true
    end if
    
    if encolar then
        debug.print "encolando..."
        userlist(userindex).colasalida.add datos
    end if

#elseif usarquesocket = 2 then '**********************************************

dim encolar as boolean
dim ret as long
    
    encolar = false
    
    '//
    '// valores de retorno:
    '//                     0: todo ok
    '//                     1: wsaewouldblock
    '//                     2: error critico
    '//
    if userlist(userindex).colasalida.count <= 0 then
        ret = frmmain.serv.enviar(userlist(userindex).connid, datos, len(datos))
        if ret = 1 then
            encolar = true
        elseif ret = 2 then
            call closesocketsl(userindex)
            call cerrar_usuario(userindex)
        end if
    else
        encolar = true
    end if
    
    if encolar then
        debug.print "encolando..."
        userlist(userindex).colasalida.add datos
    end if

#elseif usarquesocket = 3 then
    dim rv as long
    'al carajo, esto encola solo!!! che, me aprobar� los
    'parciales tambi�n?, este control hace todo solo!!!!
    on error goto errorhandler
        
        if userlist(userindex).connid = -1 then
            call logerror("tcp::enviardatosaslot, se intento enviar datos a un userindex con connid=-1")
            exit function
        end if
        
        if frmmain.tcpserv.enviar(userlist(userindex).connid, datos, len(datos)) = 2 then call closesocket(userindex, true)

exit function
errorhandler:
    call logerror("tcp::enviardatosaslot. ui/connid/datos: " & userindex & "/" & userlist(userindex).connid & "/" & datos)
#end if '**********************************************

end function

sub senddata(byval sndroute as sendtarget, byval sndindex as integer, byval sndmap as integer, byval snddata as string)

on error resume next

dim loopc as integer
dim x as integer
dim y as integer

snddata = snddata & endc

select case sndroute

    case sendtarget.topcarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub
    
    case sendtarget.toindex
        if userlist(sndindex).connid <> -1 then
            call enviardatosaslot(sndindex, snddata)
            exit sub
        end if


    case sendtarget.tonone
        exit sub
        
        
    case sendtarget.toadmins
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
                if userlist(loopc).flags.privilegios > 0 then
                    call enviardatosaslot(loopc, snddata)
               end if
            end if
        next loopc
        exit sub
        
    case sendtarget.toall
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.toallbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and (loopc <> sndindex) then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.tomap
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.userlogged then
                    if userlist(loopc).pos.map = sndmap then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            end if
        next loopc
        exit sub
      
    case sendtarget.tomapbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and loopc <> sndindex then
                if userlist(loopc).pos.map = sndmap then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
            
    case sendtarget.toguildmembers
        
        loopc = modguilds.m_iterador_proximouserindex(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, snddata)
            end if
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
        wend
        
        exit sub


    case sendtarget.todeadarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                        if userlist(mapdata(sndmap, x, y).userindex).flags.muerto = 1 or userlist(mapdata(sndmap, x, y).userindex).flags.privilegios >= 1 then
                           if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                           end if
                        end if
                    end if
               end if
            next x
        next y
        exit sub

    '[alejo-18-5]
    case sendtarget.topcareabutindex
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) and (mapdata(sndmap, x, y).userindex <> sndindex) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub
       
    case sendtarget.toclanarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) then
                        if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            if userlist(sndindex).guildindex > 0 and userlist(mapdata(sndmap, x, y).userindex).guildindex = userlist(sndindex).guildindex then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                            end if
                        end if
                    end if
               end if
            next x
        next y
        exit sub



    case sendtarget.topartyarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) then
                        if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            if userlist(sndindex).partyindex > 0 and userlist(mapdata(sndmap, x, y).userindex).partyindex = userlist(sndindex).partyindex then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                            end if
                        end if
                    end if
               end if
            next x
        next y
        exit sub
        
    '[cdt 17-02-2004]
    case sendtarget.toadminsareabutconsejeros
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) and (mapdata(sndmap, x, y).userindex <> sndindex) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            if userlist(mapdata(sndmap, x, y).userindex).flags.privilegios > 1 then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                            end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub
    '[/cdt]

    case sendtarget.tonpcarea
        for y = npclist(sndindex).pos.y - minyborder + 1 to npclist(sndindex).pos.y + minyborder - 1
            for x = npclist(sndindex).pos.x - minxborder + 1 to npclist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case sendtarget.todiosesyclan
        loopc = modguilds.m_iterador_proximouserindex(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, snddata)
            end if
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
        wend

        loopc = modguilds.iterador_proximogm(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, snddata)
            end if
            loopc = modguilds.iterador_proximogm(sndindex)
        wend

        exit sub

    case sendtarget.toconsejo
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.pertalcons > 0 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    case sendtarget.toconsejocaos
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.pertalconscaos > 0 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    case sendtarget.torolesmasters
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.tociudadanos
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if not criminal(loopc) then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.tocriminales
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if criminal(loopc) then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.toreal
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).faccion.armadareal = 1 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.tocaos
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).faccion.fuerzascaos = 1 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
        
    case tociudadanosyrms
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if not criminal(loopc) or userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case tocriminalesyrms
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if criminal(loopc) or userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case torealyrms
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).faccion.armadareal = 1 or userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case tocaosyrms
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).faccion.fuerzascaos = 1 or userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
end select

end sub

#if seguridadalkon then

sub sendcryptedmovechar(byval map as integer, byval userindex as integer, byval x as integer, byval y as integer)
dim loopc as integer

    for loopc = 1 to lastuser
        if userlist(loopc).pos.map = map then
            if loopc <> userindex then
                if (userlist(loopc).connid <> -1) then
                    call enviardatosaslot(loopc, "+" & encriptacion.movecharcrypt(loopc, userlist(userindex).char.charindex, x, y) & endc)
                end if
            end if
        end if
    next loopc
    exit sub
    

end sub

sub sendcrypteddata(byval sndroute as byte, byval sndindex as integer, byval sndmap as integer, byval snddata as string)
'no puse un optional parameter en senddata porque no estoy seguro
'como afecta la performance un parametro opcional
'prefiero 1k mas de exe que arriesgar performance
on error resume next

dim loopc as integer
dim x as integer
dim y as integer


select case sndroute


    case sendtarget.tonone
        exit sub
        
    case sendtarget.toadmins
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
'               if esdios(userlist(loopc).name) or essemidios(userlist(loopc).name) then
                if userlist(loopc).flags.privilegios > 0 then
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
               end if
            end if
        next loopc
        exit sub
        
    case sendtarget.toall
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.toallbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and (loopc <> sndindex) then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.tomap
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.userlogged then
                    if userlist(loopc).pos.map = sndmap then
                        call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                    end if
                end if
            end if
        next loopc
        exit sub
      
    case sendtarget.tomapbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and loopc <> sndindex then
                if userlist(loopc).pos.map = sndmap then
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case sendtarget.toguildmembers
    
        loopc = modguilds.m_iterador_proximouserindex(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
            end if
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
        wend
        
        exit sub
    
    case sendtarget.topcarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    '[alejo-18-5]
    case sendtarget.topcareabutindex
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) and (mapdata(sndmap, x, y).userindex <> sndindex) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    '[cdt 17-02-2004]
    case sendtarget.toadminsareabutconsejeros
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) and (mapdata(sndmap, x, y).userindex <> sndindex) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            if userlist(mapdata(sndmap, x, y).userindex).flags.privilegios > 1 then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                            end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub
    '[/cdt]

    case sendtarget.tonpcarea
        for y = npclist(sndindex).pos.y - minyborder + 1 to npclist(sndindex).pos.y + minyborder - 1
            for x = npclist(sndindex).pos.x - minxborder + 1 to npclist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case sendtarget.toindex
        if userlist(sndindex).connid <> -1 then
             call enviardatosaslot(sndindex, protocrypt(snddata, sndindex) & endc)
             exit sub
        end if
    case sendtarget.todiosesyclan
        
        loopc = modguilds.m_iterador_proximouserindex(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
            end if
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
        wend

        loopc = modguilds.iterador_proximogm(sndindex)
        while loopc > 0
            if (userlist(loopc).connid <> -1) then
                call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
            end if
            loopc = modguilds.iterador_proximogm(sndindex)
        wend

        exit sub
        

end select

end sub

#end if

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

function validatechr(byval userindex as integer) as boolean

validatechr = userlist(userindex).char.head <> 0 _
                and userlist(userindex).char.body <> 0 _
                and validateskills(userindex)

end function

sub connectuser(byval userindex as integer, name as string, password as string)
dim n as integer
dim tstr as string

'reseteamos los flags
userlist(userindex).flags.escondido = 0
userlist(userindex).flags.targetnpc = 0
userlist(userindex).flags.targetnpctipo = enpctype.comun
userlist(userindex).flags.targetobj = 0
userlist(userindex).flags.targetuser = 0
userlist(userindex).char.fx = 0

'controlamos no pasar el maximo de usuarios
if numusers >= maxusers then
    call senddata(sendtarget.toindex, userindex, 0, "errel servidor ha alcanzado el maximo de usuarios soportado, por favor vuelva a intertarlo mas tarde.")
    call closesocket(userindex)
    exit sub
end if

'�este ip ya esta conectado?
if allowmultilogins = 0 then
    if checkforsameip(userindex, userlist(userindex).ip) = true then
        call senddata(sendtarget.toindex, userindex, 0, "errno es posible usar mas de un personaje al mismo tiempo.")
        call closesocket(userindex)
        exit sub
    end if
end if

'�existe el personaje?
if not fileexist(charpath & ucase$(name) & ".chr", vbnormal) then
    call senddata(sendtarget.toindex, userindex, 0, "errel personaje no existe.")
    call closesocket(userindex)
    exit sub
end if

'�es el passwd valido?
if ucase$(password) <> ucase$(getvar(charpath & ucase$(name) & ".chr", "init", "password")) then
    call senddata(sendtarget.toindex, userindex, 0, "errpassword incorrecto.")
    
    call closesocket(userindex)
    exit sub
end if

'�ya esta conectado el personaje?
if checkforsamename(userindex, name) then
    if userlist(nameindex(name)).counters.saliendo then
        call senddata(sendtarget.toindex, userindex, 0, "errel usuario est� saliendo.")
    else
        call senddata(sendtarget.toindex, userindex, 0, "errperdon, un usuario con el mismo nombre se h� logoeado.")
    end if
    call closesocket(userindex)
    exit sub
end if

'cargamos el personaje
dim leer as new clsinireader

call leer.initialize(charpath & ucase$(name) & ".chr")

'cargamos los datos del personaje
call loaduserinit(userindex, leer)

call loaduserstats(userindex, leer)

if not validatechr(userindex) then
    call senddata(sendtarget.toindex, userindex, 0, "errerror en el personaje.")
    call closesocket(userindex)
    exit sub
end if

call loaduserreputacion(userindex, leer)

set leer = nothing

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

if userlist(userindex).flags.paralizado then
#if seguridadalkon then
    if encriptarprotocoloscriticos then
        call sendcrypteddata(sendtarget.toindex, userindex, 0, "paradok")
    else
#end if
        call senddata(sendtarget.toindex, userindex, 0, "paradok")
#if seguridadalkon then
    end if
#end if
end if

'feo, esto tiene que ser parche cliente
if userlist(userindex).flags.estupidez = 0 then call senddata(sendtarget.toindex, userindex, 0, "nestup")
'

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

   ''telefrag
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex <> 0 then
        ''si estaba en comercio seguro...
        if userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).comusu.destusu > 0 then
            if userlist(userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).comusu.destusu).flags.userlogged then
                call fincomerciarusu(userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).comusu.destusu)
                call senddata(sendtarget.toindex, userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).comusu.destusu, 0, "||comercio cancelado. el otro usuario se ha desconectado." & fonttype_talk)
            end if
            if userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).flags.userlogged then
                call fincomerciarusu(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex)
                call senddata(sendtarget.toindex, mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex, 0, "erralguien se ha conectado donde te encontrabas, por favor recon�ctate...")
            end if
        end if
        call closesocket(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex)
    end if
   
   
    if userlist(userindex).flags.muerto = 1 then
        call empollando(userindex)
    end if
end if

if not mapavalido(userlist(userindex).pos.map) then
    call senddata(sendtarget.toindex, userindex, 0, "errel pj se encuenta en un mapa invalido.")
    call closesocket(userindex)
    exit sub
end if

'nombre de sistema
userlist(userindex).name = name

userlist(userindex).password = password

userlist(userindex).showname = true 'por default los nombres son visibles

'info
call senddata(sendtarget.toindex, userindex, 0, "iu" & userindex) 'enviamos el user index
call senddata(sendtarget.toindex, userindex, 0, "cm" & userlist(userindex).pos.map & "," & mapinfo(userlist(userindex).pos.map).mapversion) 'carga el mapa
call senddata(sendtarget.toindex, userindex, 0, "tm" & mapinfo(userlist(userindex).pos.map).music)

'vemos que clase de user es (se lo usa para setear los privilegios alcrear el pj)
userlist(userindex).flags.esrolesmaster = esrolesmaster(name)
if esadmin(name) then
    userlist(userindex).flags.privilegios = playertype.admin
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif esdios(name) then
    userlist(userindex).flags.privilegios = playertype.dios
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif essemidios(name) then
    userlist(userindex).flags.privilegios = playertype.semidios
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif esconsejero(name) then
    userlist(userindex).flags.privilegios = playertype.consejero
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, true)
else
    userlist(userindex).flags.privilegios = playertype.user
end if

''[el oso]: traigo esto aca arriba para darle el ip!
userlist(userindex).counters.idlecount = 0
'crea  el personaje del usuario
call makeuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)

call senddata(sendtarget.toindex, userindex, 0, "ip" & userlist(userindex).char.charindex)
''[/el oso]

call senduserstatsbox(userindex)

call enviarhambreysed(userindex)

call sendmotd(userindex)

if haciendobk then
    call senddata(sendtarget.toindex, userindex, 0, "bkw")
    call senddata(sendtarget.toindex, userindex, 0, "||servidor> por favor espera algunos segundos, worldsave esta ejecutandose." & fonttype_server)
end if

if enpausa then
    call senddata(sendtarget.toindex, userindex, 0, "bkw")
    call senddata(sendtarget.toindex, userindex, 0, "||servidor> lo sentimos mucho pero el servidor se encuentra actualmente detenido. intenta ingresar m�s tarde." & fonttype_server)
end if

if entesting and userlist(userindex).stats.elv >= 18 then
    call senddata(sendtarget.toindex, userindex, 0, "errservidor en testing por unos minutos, conectese con pjs de nivel menor a 18. no se conecte con pjs que puedan resultar importantes por ahora pues pueden arruinarse.")
    call closesocket(userindex)
    exit sub
end if

'actualiza el num de usuarios
'de aca en adelante graba el charfile, ojo!
numusers = numusers + 1
userlist(userindex).flags.userlogged = true

'usado para borrar pjs
call writevar(charpath & userlist(userindex).name & ".chr", "init", "logged", "1")

call estadisticasweb.informar(cantidad_online, numusers)

mapinfo(userlist(userindex).pos.map).numusers = mapinfo(userlist(userindex).pos.map).numusers + 1

if userlist(userindex).stats.skillpts > 0 then
    call enviarskills(userindex)
    call enviarsubirnivel(userindex, userlist(userindex).stats.skillpts)
end if

if numusers > daystats.maxusuarios then daystats.maxusuarios = numusers

if numusers > recordusuarios then
    call senddata(sendtarget.toall, 0, 0, "||record de usuarios conectados simultaniamente." & "hay " & numusers & " usuarios." & fonttype_info)
    recordusuarios = numusers
    call writevar(inipath & "server.ini", "init", "record", str(recordusuarios))
    
    call estadisticasweb.informar(record_usuarios, recordusuarios)
end if

if userlist(userindex).nromacotas > 0 then
    dim i as integer
    for i = 1 to maxmascotas
        if userlist(userindex).mascotastype(i) > 0 then
            userlist(userindex).mascotasindex(i) = spawnnpc(userlist(userindex).mascotastype(i), userlist(userindex).pos, true, true)
            
            if userlist(userindex).mascotasindex(i) > 0 then
                npclist(userlist(userindex).mascotasindex(i)).maestrouser = userindex
                call followamo(userlist(userindex).mascotasindex(i))
            else
                userlist(userindex).mascotasindex(i) = 0
            end if
        end if
    next i
end if

if userlist(userindex).flags.navegando = 1 then call senddata(sendtarget.toindex, userindex, 0, "naveg")

if criminal(userindex) then
    'call senddata(sendtarget.toindex, userindex, 0, "||miembro de las fuerzas del caos > seguro desactivado <" & fonttype_fight)
    call senddata(sendtarget.toindex, userindex, 0, "segoff")
    userlist(userindex).flags.seguro = false
else
    userlist(userindex).flags.seguro = true
    call senddata(sendtarget.toindex, userindex, 0, "segon")
end if

if serversologms > 0 then
    if userlist(userindex).flags.privilegios < serversologms then
        call senddata(sendtarget.toindex, userindex, 0, "errservidor restringido a administradores de jerarquia mayor o igual a: " & serversologms & ". por favor intente en unos momentos.")
        call closesocket(userindex)
        exit sub
    end if
end if

if userlist(userindex).guildindex > 0 then
    'welcome to the show baby...
    if not modguilds.m_conectarmiembroaclan(userindex, userlist(userindex).guildindex) then
        call senddata(sendtarget.toindex, userindex, 0, "||tu estado no te permite entrar al clan." & fonttype_guild)
    end if
end if

call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxwarp & "," & 0)

call senddata(sendtarget.toindex, userindex, 0, "logged")

call modguilds.sendguildnews(userindex)

if userlist(userindex).flags.noactualizado then
    call senddata(sendtarget.toindex, userindex, 0, "reau")
end if

if lloviendo then call senddata(sendtarget.toindex, userindex, 0, "llu")

tstr = modguilds.a_obtenerrechazodechar(userlist(userindex).name)

if tstr <> vbnullstring then
    call senddata(sendtarget.toindex, userindex, 0, "!!tu solicitud de ingreso al clan ha sido rechazada. el clan te explica que: " & tstr & endc)
end if

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
    dim j as long
    
    call senddata(sendtarget.toindex, userindex, 0, "|+mensajes de entrada:" & fonttype_info)
    
    for j = 1 to maxlines
        call senddata(sendtarget.toindex, userindex, 0, "|+" & chr$(3) & motd(j).texto)
    next j
end sub

sub resetfacciones(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/15/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'*************************************************
    with userlist(userindex).faccion
        .armadareal = 0
        .fuerzascaos = 0
        .ciudadanosmatados = 0
        .criminalesmatados = 0
        .recibioarmaduracaos = 0
        .recibioarmadurareal = 0
        .recibioexpinicialcaos = 0
        .recibioexpinicialreal = 0
        .recompensascaos = 0
        .recompensasreal = 0
        .reenlistadas = 0
    end with
end sub

sub resetcontadores(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/15/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'*************************************************
    with userlist(userindex).counters
        .aguacounter = 0
        .attackcounter = 0
        .ceguera = 0
        .comcounter = 0
        .estupidez = 0
        .frio = 0
        .hpcounter = 0
        .idlecount = 0
        .invisibilidad = 0
        .paralisis = 0
        .pasos = 0
        .pena = 0
        .piquetec = 0
        .stacounter = 0
        .veneno = 0
        .trabajando = 0
        .ocultando = 0

        .timerlanzarspell = 0
        .timerpuedeatacar = 0
        .timerpuedetrabajar = 0
        .timerusar = 0
    end with
end sub

sub resetcharinfo(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/15/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'*************************************************
    with userlist(userindex).char
        .body = 0
        .cascoanim = 0
        .charindex = 0
        .fx = 0
        .head = 0
        .loops = 0
        .heading = 0
        .loops = 0
        .shieldanim = 0
        .weaponanim = 0
    end with
end sub

sub resetbasicuserinfo(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/15/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'*************************************************
    with userlist(userindex)
        .name = ""
        .modname = ""
        .password = ""
        .desc = ""
        .descrm = ""
        .pos.map = 0
        .pos.x = 0
        .pos.y = 0
        .ip = ""
        .rdbuffer = ""
        .clase = ""
        .email = ""
        .genero = ""
        .hogar = ""
        .raza = ""

        .randkey = 0
        .prevchecksum = 0
        .packetnumber = 0

        .empocont = 0
        .partyindex = 0
        .partysolicitud = 0
        
        with .stats
            .banco = 0
            .elv = 0
            .elu = 0
            .exp = 0
            .def = 0
            .criminalesmatados = 0
            .npcsmuertos = 0
            .usuariosmatados = 0
            .fit = 0
            .skillpts = 0
        end with
    end with
end sub

sub resetreputacion(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/15/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'*************************************************
    with userlist(userindex).reputacion
        .asesinorep = 0
        .bandidorep = 0
        .burguesrep = 0
        .ladronesrep = 0
        .noblerep = 0
        .pleberep = 0
        .noblerep = 0
        .promedio = 0
    end with
end sub

sub resetguildinfo(byval userindex as integer)
    if userlist(userindex).escucheclan > 0 then
        call modguilds.gmdejadeescucharclan(userindex, userlist(userindex).escucheclan)
        userlist(userindex).escucheclan = 0
    end if
    if userlist(userindex).guildindex > 0 then
        call modguilds.m_desconectarmiembrodelclan(userindex, userlist(userindex).guildindex)
    end if
    userlist(userindex).guildindex = 0
end sub

sub resetuserflags(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 03/29/2006
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'03/29/2006 maraxus - reseteo el centinelaok tambi�n.
'*************************************************
    with userlist(userindex).flags
        .comerciando = false
        .ban = 0
        .escondido = 0
        .duracionefecto = 0
        .npcinv = 0
        .statschanged = 0
        .targetnpc = 0
        .targetnpctipo = enpctype.comun
        .targetobj = 0
        .targetobjmap = 0
        .targetobjx = 0
        .targetobjy = 0
        .targetuser = 0
        .tipopocion = 0
        .tomopocion = false
        .descuento = ""
        .hambre = 0
        .sed = 0
        .descansar = false
        .modocombate = false
        .vuela = 0
        .navegando = 0
        .oculto = 0
        .envenenado = 0
        .invisible = 0
        .paralizado = 0
        .maldicion = 0
        .bendicion = 0
        .meditando = 0
        .privilegios = playertype.user
        .puedemoverse = 0
        .oldbody = 0
        .oldhead = 0
        .admininvisible = 0
        .valcode = 0
        .hechizo = 0
        .timeswalk = 0
        .startwalk = 0
        .countsh = 0
        .estaempo = 0
        .pertalcons = 0
        .pertalconscaos = 0
        .silenciado = 0
        .centinelaok = false
    end with
end sub

sub resetuserspells(byval userindex as integer)
    dim loopc as long
    for loopc = 1 to maxuserhechizos
        userlist(userindex).stats.userhechizos(loopc) = 0
    next loopc
end sub

sub resetuserpets(byval userindex as integer)
    dim loopc as long
    
    userlist(userindex).nromacotas = 0
        
    for loopc = 1 to maxmascotas
        userlist(userindex).mascotasindex(loopc) = 0
        userlist(userindex).mascotastype(loopc) = 0
    next loopc
end sub

sub resetuserbanco(byval userindex as integer)
    dim loopc as long
    
    for loopc = 1 to max_bancoinventory_slots
          userlist(userindex).bancoinvent.object(loopc).amount = 0
          userlist(userindex).bancoinvent.object(loopc).equipped = 0
          userlist(userindex).bancoinvent.object(loopc).objindex = 0
    next loopc
    
    userlist(userindex).bancoinvent.nroitems = 0
end sub

public sub limpiarcomercioseguro(byval userindex as integer)
    with userlist(userindex).comusu
        if .destusu > 0 then
            call fincomerciarusu(.destusu)
            call fincomerciarusu(userindex)
        end if
    end with
end sub

sub resetuserslot(byval userindex as integer)

dim usrtmp as user

set userlist(userindex).commandsbuffer = nothing


set userlist(userindex).colasalida = nothing
userlist(userindex).sockpuedoenviar = false
userlist(userindex).connidvalida = false
userlist(userindex).connid = -1

call limpiarcomercioseguro(userindex)
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

with userlist(userindex).comusu
    .acepto = false
    .cant = 0
    .destnick = ""
    .destusu = 0
    .objeto = 0
end with

userlist(userindex) = usrtmp

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
userlist(userindex).flags.atacadopornpc = 0

map = userlist(userindex).pos.map
x = userlist(userindex).pos.x
y = userlist(userindex).pos.y
name = ucase$(userlist(userindex).name)
raza = userlist(userindex).raza
clase = userlist(userindex).clase

userlist(userindex).char.fx = 0
userlist(userindex).char.loops = 0
call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)

userlist(userindex).flags.userlogged = false
userlist(userindex).counters.saliendo = false

'le devolvemos el body y head originales
if userlist(userindex).flags.admininvisible = 1 then call doadmininvisible(userindex)

'si esta en party le devolvemos la experiencia
if userlist(userindex).partyindex > 0 then call mdparty.salirdeparty(userindex)

' grabamos el personaje del usuario
call saveuser(userindex, charpath & name & ".chr")

'usado para borrar pjs
call writevar(charpath & userlist(userindex).name & ".chr", "init", "logged", "0")


'quitar el dialogo
'if mapinfo(map).numusers > 0 then
'    call sendtouserarea(userindex, "qdl" & userlist(userindex).char.charindex)
'end if

if mapinfo(map).numusers > 0 then
    call senddata(sendtarget.tomapbutindex, userindex, map, "qdl" & userlist(userindex).char.charindex)
end if



'borrar el personaje
if userlist(userindex).char.charindex > 0 then
    call eraseuserchar(sendtarget.tomap, userindex, map, userindex)
end if

'borrar mascotas
for i = 1 to maxmascotas
    if userlist(userindex).mascotasindex(i) > 0 then
        if npclist(userlist(userindex).mascotasindex(i)).flags.npcactive then _
            call quitarnpc(userlist(userindex).mascotasindex(i))
    end if
next i

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
call logerror("error en closeuser. n�mero " & err.number & " descripci�n: " & err.description)


end sub


sub handledata(byval userindex as integer, byval rdata as string)

'
' atencion: cambios importantes en handledata.
' =========
'
'           la funcion se encuentra dividida en 2,
'           una parte controla los comandos que
'           empiezan con "/" y la otra los comanos
'           que no. (basado en la idea de barrin)
'


call logtarea("sub handledata :" & rdata & " " & userlist(userindex).name)

'nunca jamas remover o comentar esta linea !!!
'nunca jamas remover o comentar esta linea !!!
'nunca jamas remover o comentar esta linea !!!
on error goto errorhandler:
'nunca jamas remover o comentar esta linea !!!
'nunca jamas remover o comentar esta linea !!!
'nunca jamas remover o comentar esta linea !!!
'
'ah, no me queres hacer caso ? entonces
'atenete a las consecuencias!!
'

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
    dim dummyint as integer
    dim t() as string
    dim i as integer
    
    dim snddata as string
    dim climd5 as string
    dim clientchecksum as string
    dim serversidechecksum as long
    dim idlecountbackup as long
    
    cadenaoriginal = rdata
    
    '�tiene un indece valido?
    if userindex <= 0 then
        call closesocket(userindex)
        exit sub
    end if
    
    if left$(rdata, 13) = "givemevalcode" then
#if seguridadalkon then
        '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
        userlist(userindex).flags.valcode = randomnumber(20000, 32000)
        userlist(userindex).randkey = randomnumber(0, 99999)
        userlist(userindex).prevchecksum = userlist(userindex).randkey
        userlist(userindex).packetnumber = 100
        userlist(userindex).keycrypt = (userlist(userindex).randkey and 17320) xor (userlist(userindex).flags.valcode xor 4232)
        '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        call senddata(sendtarget.toindex, userindex, 0, "val" & userlist(userindex).randkey & "," & userlist(userindex).flags.valcode & "," & encriptacion.stringvalidacion)
        exit sub
    else
        '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
        clientchecksum = right$(rdata, len(rdata) - instrrev(rdata, chr$(126)))
        tstr = left$(rdata, len(rdata) - len(clientchecksum) - 1)
        serversidechecksum = checksum(userlist(userindex).prevchecksum, tstr)
        userlist(userindex).prevchecksum = serversidechecksum
        
        if clng(clientchecksum) <> serversidechecksum then
            call logerror("checksum error userindex: " & userindex & " rdata: " & rdata)
            call closesocket(userindex, true)
        end if
        
        'remove checksum from data
        rdata = tstr
        tstr = ""
#else
        call senddata(sendtarget.toindex, userindex, 0, "val" & userlist(userindex).randkey & "," & userlist(userindex).flags.valcode)
        exit sub
#end if
    end if
    '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    idlecountbackup = userlist(userindex).counters.idlecount
    userlist(userindex).counters.idlecount = 0
   
    if not userlist(userindex).flags.userlogged then

        select case left$(rdata, 6)
            case "ologin"
                rdata = right$(rdata, len(rdata) - 6)
                climd5 = right$(rdata, 16)
                if not md5ok(climd5) then
                    call senddata(sendtarget.toindex, userindex, 0, "errel cliente est� da�ado, por favor descarguelo nuevamente desde www.argentumonline.com.ar")
                    exit sub
                end if
                ver = readfield(3, rdata, 44)
                if versionok(ver) then
                    tname = readfield(1, rdata, 44)
                    
                    if not asciivalidos(tname) then
                        call senddata(sendtarget.toindex, userindex, 0, "errnombre invalido.")
                        call closesocket(userindex, true)
                        exit sub
                    end if
                    
                    if not personajeexiste(tname) then
                        call senddata(sendtarget.toindex, userindex, 0, "errel personaje no existe.")
                        call closesocket(userindex, true)
                        exit sub
                    end if
                    
                    if not bancheck(tname) then
                        if validarloginmsg(userlist(userindex).flags.valcode) <> cint(readfield(11, left$(rdata, len(rdata) - 16), 44)) then
                            call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                            call closesocket(userindex)
                            exit sub
                        end if
                        
                        userlist(userindex).flags.noactualizado = not versionesactuales(val(readfield(4, rdata, 44)), val(readfield(5, rdata, 44)), val(readfield(6, rdata, 44)), val(readfield(7, rdata, 44)), val(readfield(8, rdata, 44)), val(readfield(9, rdata, 44)), val(readfield(10, rdata, 44)))
                        
                        dim pass11 as string
                        pass11 = readfield(2, rdata, 44)
                        call connectuser(userindex, tname, pass11)
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "errse te ha prohibido la entrada a argentum debido a tu mal comportamiento. consulta en aocp.alkon.com.ar/est para ver el motivo de la prohibici�n.")
                    end if
                else
                     call senddata(sendtarget.toindex, userindex, 0, "erresta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
                     'call closesocket(userindex)
                     exit sub
                end if
                exit sub
            case "tirdad"
            
                userlist(userindex).stats.useratributos(eatributos.fuerza) = 9 + randomnumber(0, 4) + randomnumber(0, 5)
                userlist(userindex).stats.useratributos(eatributos.agilidad) = 9 + randomnumber(0, 4) + randomnumber(0, 5)
                userlist(userindex).stats.useratributos(eatributos.inteligencia) = 12 + randomnumber(0, 3) + randomnumber(0, 3)
                userlist(userindex).stats.useratributos(eatributos.carisma) = 12 + randomnumber(0, 3) + randomnumber(0, 3)
                userlist(userindex).stats.useratributos(eatributos.constitucion) = 12 + randomnumber(0, 3) + randomnumber(0, 3)
                
                call senddata(sendtarget.toindex, userindex, 0, "dados" & userlist(userindex).stats.useratributos(eatributos.fuerza) & "," & userlist(userindex).stats.useratributos(eatributos.agilidad) & "," & userlist(userindex).stats.useratributos(eatributos.inteligencia) & "," & userlist(userindex).stats.useratributos(eatributos.carisma) & "," & userlist(userindex).stats.useratributos(eatributos.constitucion))
                
                exit sub

            case "nlogin"
                if puedecrearpersonajes = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "errla creacion de personajes en este servidor se ha deshabilitado.")
                    call closesocket(userindex)
                    exit sub
                end if
                
                if serversologms <> 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "errservidor restringido a administradores. consulte la p�gina oficial o el foro oficial para mas informaci�n.")
                    call closesocket(userindex)
                    exit sub
                end if

                if aclon.maxpersonajes(userlist(userindex).ip) then
                    call senddata(sendtarget.toindex, userindex, 0, "errhas creado demasiados personajes.")
                    call closesocket(userindex)
                    exit sub
                end if
                
                rdata = right$(rdata, len(rdata) - 6)
                climd5 = right$(rdata, 16)
                rdata = left$(rdata, len(rdata) - 16)
                if not md5ok(climd5) then
                    call senddata(sendtarget.toindex, userindex, 0, "errel cliente est� da�ado o es antiguo, por favor desc�rguelo nuevamente desde el sitio http://ao.alkon.com.ar")
                    exit sub
                end if
                
                ver = readfield(3, rdata, 44)
                if versionok(ver) then
                    dim miinteger as integer
                    miinteger = cint(readfield(37, rdata, 44))
                    
                    if validarloginmsg(userlist(userindex).flags.valcode) <> miinteger then
                        call senddata(sendtarget.toindex, userindex, 0, "errpara poder continuar con la creaci�n del personaje, debe utilizar el cliente proporcionado en ao.alkon.com.ar")
                        'call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                        call closesocket(userindex)
                        exit sub
                    end if
                     
                    userlist(userindex).flags.noactualizado = not versionesactuales(val(readfield(37, rdata, 44)), val(readfield(38, rdata, 44)), val(readfield(39, rdata, 44)), val(readfield(40, rdata, 44)), val(readfield(41, rdata, 44)), val(readfield(42, rdata, 44)), val(readfield(43, rdata, 44)))
                    
                    call connectnewuser(userindex, readfield(1, rdata, 44), readfield(2, rdata, 44), readfield(4, rdata, 44), readfield(5, rdata, 44), readfield(6, rdata, 44), readfield(7, rdata, 44), _
                                        readfield(8, rdata, 44), readfield(9, rdata, 44), readfield(10, rdata, 44), readfield(11, rdata, 44), readfield(12, rdata, 44), readfield(13, rdata, 44), _
                                        readfield(14, rdata, 44), readfield(15, rdata, 44), readfield(16, rdata, 44), readfield(17, rdata, 44), readfield(18, rdata, 44), readfield(19, rdata, 44), _
                                        readfield(20, rdata, 44), readfield(21, rdata, 44), readfield(22, rdata, 44), readfield(23, rdata, 44), readfield(24, rdata, 44), readfield(25, rdata, 44), _
                                        readfield(26, rdata, 44), readfield(27, rdata, 44), readfield(28, rdata, 44), readfield(29, rdata, 44))
                
                else
                     call senddata(sendtarget.toindex, userindex, 0, "!!esta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
                     exit sub
                end if
                
                exit sub
        end select
    
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
                dim rt as string
                rt = app.path & "\chrbackup\" & ucase$(arg1) & ".bak"
                if fileexist(rt, vbnormal) then kill rt
                name charpath & ucase$(arg1) & ".chr" as rt
                call senddata(sendtarget.toindex, userindex, 0, "borrok")
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
    call loghackattemp("mesaje enviado sin logearse:" & rdata)
    call closesocket(userindex)
    exit sub
      
end if ' if not user logged


dim procesado as boolean

' bien ahora solo procesamos los comandos que no empiezan
' con "/".
if left$(rdata, 1) <> "/" then
    
    call handledata_1(userindex, rdata, procesado)
    if procesado then exit sub
    
' bien hasta aca fueron los comandos que no empezaban con
' "/". ahora adivin� que sigue :)
else
    
    call handledata_2(userindex, rdata, procesado)
    if procesado then exit sub

end if ' "/"

#if seguridadalkon then
    if handledataex(userindex, rdata) then exit sub
#end if


if userlist(userindex).flags.privilegios = playertype.user then
    userlist(userindex).counters.idlecount = idlecountbackup
end if

'>>>>>>>>>>>>>>>>>>>>>> solo administradores <<<<<<<<<<<<<<<<<<<
 if userlist(userindex).flags.privilegios = playertype.user then exit sub
'>>>>>>>>>>>>>>>>>>>>>> solo administradores <<<<<<<<<<<<<<<<<<<

'<<<<<<<<<<<<<<<<<<<< consejeros <<<<<<<<<<<<<<<<<<<<

if ucase$(rdata) = "/showname" then
    if userlist(userindex).flags.esrolesmaster or userlist(userindex).flags.privilegios >= playertype.dios then
        userlist(userindex).showname = not userlist(userindex).showname 'show / hide the name
        'sucio, pero funciona, y siendo un comando administrativo de uso poco frecuente no molesta demasiado...
        call usuarios.eraseuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, userindex)
        call usuarios.makeuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
    end if
    exit sub
end if

if ucase$(rdata) = "/onlinereal" then
    for tlong = 1 to lastuser
        if userlist(tlong).connid <> -1 then
            if userlist(tlong).faccion.armadareal = 1 and (userlist(tlong).flags.privilegios < playertype.dios or userlist(userindex).flags.privilegios >= playertype.dios) then
                tstr = tstr & userlist(tlong).name & ", "
            end if
        end if
    next tlong
    
    if len(tstr) > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||armadas conectados: " & left$(tstr, len(tstr) - 2) & fonttype_info)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||no hay armadas conectados" & fonttype_info)
    end if
    exit sub
end if

if ucase$(rdata) = "/onlinecaos" then
    for tlong = 1 to lastuser
        if userlist(tlong).connid <> -1 then
            if userlist(tlong).faccion.fuerzascaos = 1 and (userlist(tlong).flags.privilegios < playertype.dios or userlist(userindex).flags.privilegios >= playertype.dios) then
                tstr = tstr & userlist(tlong).name & ", "
            end if
        end if
    next tlong
    
    if len(tstr) > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||caos conectados: " & left$(tstr, len(tstr) - 2) & fonttype_info)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||no hay caos conectados" & fonttype_info)
    end if
    exit sub
end if

'/ircerca
'este comando sirve para teletrasportarse cerca del usuario
if ucase$(left$(rdata, 9)) = "/ircerca " then
    dim indiceuserdestino as integer
    rdata = right$(rdata, len(rdata) - 9) 'obtiene el nombre del usuario
    tindex = nameindex(rdata)
    
    'si es dios o admins no podemos salvo que nosotros tambi�n lo seamos
    if (esdios(rdata) or esadmin(rdata)) and userlist(userindex).flags.privilegios < playertype.dios then _
        exit sub
    
    if tindex <= 0 then 'existe el usuario destino?
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if

    for tint = 2 to 5 'esto for sirve ir cambiando la distancia destino
        for i = userlist(tindex).pos.x - tint to userlist(tindex).pos.x + tint
            for dummyint = userlist(tindex).pos.y - tint to userlist(tindex).pos.y + tint
                if (i >= userlist(tindex).pos.x - tint and i <= userlist(tindex).pos.x + tint) and (dummyint = userlist(tindex).pos.y - tint or dummyint = userlist(tindex).pos.y + tint) then
                    if mapdata(userlist(tindex).pos.map, i, dummyint).userindex = 0 and legalpos(userlist(tindex).pos.map, i, dummyint) then
                        call warpuserchar(userindex, userlist(tindex).pos.map, i, dummyint, true)
                        exit sub
                    end if
                elseif (dummyint >= userlist(tindex).pos.y - tint and dummyint <= userlist(tindex).pos.y + tint) and (i = userlist(tindex).pos.x - tint or i = userlist(tindex).pos.x + tint) then
                    if mapdata(userlist(tindex).pos.map, i, dummyint).userindex = 0 and legalpos(userlist(tindex).pos.map, i, dummyint) then
                        call warpuserchar(userindex, userlist(tindex).pos.map, i, dummyint, true)
                        exit sub
                    end if
                end if
            next dummyint
        next i
    next tint
    
    call senddata(sendtarget.toindex, userindex, 0, "||todos los lugares estan ocupados." & fonttype_info)
    exit sub
end if

'/rem comentario
if ucase$(left$(rdata, 4)) = "/rem" then
    rdata = right$(rdata, len(rdata) - 5)
    call loggm(userlist(userindex).name, "comentario: " & rdata, (userlist(userindex).flags.privilegios = playertype.consejero))
    call senddata(sendtarget.toindex, userindex, 0, "||comentario salvado..." & fonttype_info)
    exit sub
end if

'hora
if ucase$(left$(rdata, 5)) = "/hora" then
    call loggm(userlist(userindex).name, "hora.", (userlist(userindex).flags.privilegios = playertype.consejero))
    rdata = right$(rdata, len(rdata) - 5)
    call senddata(sendtarget.toall, 0, 0, "||hora: " & time & " " & date & fonttype_info)
    exit sub
end if

'�donde esta?
if ucase$(left$(rdata, 7)) = "/donde " then
    rdata = right$(rdata, len(rdata) - 7)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    if userlist(tindex).flags.privilegios >= playertype.dios then exit sub
    call senddata(sendtarget.toindex, userindex, 0, "||ubicacion  " & userlist(tindex).name & ": " & userlist(tindex).pos.map & ", " & userlist(tindex).pos.x & ", " & userlist(tindex).pos.y & "." & fonttype_info)
    call loggm(userlist(userindex).name, "/donde " & userlist(tindex).name, (userlist(userindex).flags.privilegios = playertype.consejero))
    exit sub
end if

if ucase$(left$(rdata, 6)) = "/nene " then
    rdata = right$(rdata, len(rdata) - 6)

    if mapavalido(val(rdata)) then
        dim npcindex as integer
            dim conts as string


            conts = ""
        for npcindex = 1 to lastnpc

        '�esta vivo?
        if npclist(npcindex).flags.npcactive _
                and npclist(npcindex).pos.map = val(rdata) _
                    and npclist(npcindex).hostile = 1 and _
                        npclist(npcindex).stats.alineacion = 2 then
                       conts = conts & npclist(npcindex).name & ", "

        end if

        next npcindex
                if conts <> "" then
                    conts = left(conts, len(conts) - 2)
                else
                    conts = "no hay npcs"
                end if
                call senddata(sendtarget.toindex, userindex, 0, "||npcs en mapa: " & conts & fonttype_info)
                call loggm(userlist(userindex).name, "numero enemigos en mapa " & rdata, (userlist(userindex).flags.privilegios = playertype.consejero))
    end if
    exit sub
end if



if ucase$(rdata) = "/teleploc" then
    call warpuserchar(userindex, userlist(userindex).flags.targetmap, userlist(userindex).flags.targetx, userlist(userindex).flags.targety, true)
    call loggm(userlist(userindex).name, "/teleploc a x:" & userlist(userindex).flags.targetx & " y:" & userlist(userindex).flags.targety & " map:" & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = playertype.consejero))
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
        if userlist(userindex).flags.privilegios = playertype.consejero then
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
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    call warpuserchar(tindex, mapa, x, y, true)
    call senddata(sendtarget.toindex, tindex, 0, "||" & userlist(userindex).name & " transportado." & fonttype_info)
    call loggm(userlist(userindex).name, "transporto a " & userlist(tindex).name & " hacia " & "mapa" & mapa & " x:" & x & " y:" & y, (userlist(userindex).flags.privilegios = playertype.consejero))
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/silenciar " then
    rdata = right$(rdata, len(rdata) - 11)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    if userlist(tindex).flags.silenciado = 0 then
        userlist(tindex).flags.silenciado = 1
        call senddata(sendtarget.toindex, userindex, 0, "||usuario silenciado." & fonttype_info)
        call senddata(sendtarget.toindex, tindex, 0, "!!estimado usuario, ud ha sido silenciado por los administradores. sus denuncias ser�n ignoradas por el servidor de aqu� en mas. utilice /gm ayuda para contactar un administrador.")
        call loggm(userlist(userindex).name, "/silenciar " & userlist(tindex).name, (userlist(userindex).flags.privilegios = playertype.consejero))
    else
        userlist(tindex).flags.silenciado = 0
        call senddata(sendtarget.toindex, userindex, 0, "||usuario des silenciado." & fonttype_info)
        call loggm(userlist(userindex).name, "/dessilenciar " & userlist(tindex).name, (userlist(userindex).flags.privilegios = playertype.consejero))
    end if
    exit sub
end if



if ucase$(left$(rdata, 9)) = "/show sos" then
    dim m as string
    for n = 1 to ayuda.longitud
        m = ayuda.verelemento(n)
        call senddata(sendtarget.toindex, userindex, 0, "rsos" & m)
    next n
    call senddata(sendtarget.toindex, userindex, 0, "msos")
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
    
    'si es dios o admins no podemos salvo que nosotros tambi�n lo seamos
    if (esdios(rdata) or esadmin(rdata)) and userlist(userindex).flags.privilegios < playertype.dios then _
        exit sub
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    

    call warpuserchar(userindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y + 1, true)
    
    if userlist(userindex).flags.admininvisible = 0 then call senddata(sendtarget.toindex, tindex, 0, "||" & userlist(userindex).name & " se ha trasportado hacia donde te encontras." & fonttype_info)
    call loggm(userlist(userindex).name, "/ira " & userlist(tindex).name & " mapa:" & userlist(tindex).pos.map & " x:" & userlist(tindex).pos.x & " y:" & userlist(tindex).pos.y, (userlist(userindex).flags.privilegios = playertype.consejero))
    exit sub
end if

'haceme invisible vieja!
if ucase$(rdata) = "/invisible" then
    call doadmininvisible(userindex)
    call loggm(userlist(userindex).name, "/invisible", (userlist(userindex).flags.privilegios = playertype.consejero))
    exit sub
end if

if ucase$(rdata) = "/panelgm" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call senddata(sendtarget.toindex, userindex, 0, "abpanel")
    exit sub
end if

if ucase$(rdata) = "listusu" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    tstr = "listusu"
    for loopc = 1 to lastuser
        if (userlist(loopc).name <> "") and userlist(loopc).flags.privilegios = playertype.user then
            tstr = tstr & userlist(loopc).name & ","
        end if
    next loopc
    if len(tstr) > 7 then
        tstr = left$(tstr, len(tstr) - 1)
    end if
    call senddata(sendtarget.toindex, userindex, 0, tstr)
    exit sub
end if

'[barrin 30-11-03]
if ucase$(rdata) = "/trabajando" then
        if userlist(userindex).flags.esrolesmaster then exit sub
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") and userlist(loopc).counters.trabajando > 0 then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        if tstr <> "" then
            tstr = left$(tstr, len(tstr) - 2)
            call senddata(sendtarget.toindex, userindex, 0, "||usuarios trabajando: " & tstr & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no hay usuarios trabajando" & fonttype_info)
        end if
        exit sub
end if
'[/barrin 30-11-03]

if ucase$(rdata) = "/ocultando" then
        if userlist(userindex).flags.esrolesmaster then exit sub
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") and userlist(loopc).counters.ocultando > 0 then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        if tstr <> "" then
            tstr = left$(tstr, len(tstr) - 2)
            call senddata(sendtarget.toindex, userindex, 0, "||usuarios ocultandose: " & tstr & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no hay usuarios ocultandose" & fonttype_info)
        end if
        exit sub
end if

if ucase$(left$(rdata, 8)) = "/carcel " then
    '/carcel nick@motivo@<tiempo>
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right$(rdata, len(rdata) - 8)
    
    name = readfield(1, rdata, asc("@"))
    tstr = readfield(2, rdata, asc("@"))
    if (not isnumeric(readfield(3, rdata, asc("@")))) or name = "" or tstr = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||utilice /carcel nick@motivo@tiempo" & fonttype_info)
        exit sub
    end if
    i = val(readfield(3, rdata, asc("@")))
    
    tindex = nameindex(name)
    
    'if ucase$(name) = "reeves" then exit sub
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > playertype.user then
        call senddata(sendtarget.toindex, userindex, 0, "||no podes encarcelar a administradores." & fonttype_info)
        exit sub
    end if
    
    if i > 60 then
        call senddata(sendtarget.toindex, userindex, 0, "||no podes encarcelar por mas de 60 minutos." & fonttype_info)
        exit sub
    end if
    
    name = replace(name, "\", "")
    name = replace(name, "/", "")
    
    if fileexist(charpath & name & ".chr", vbnormal) then
        tint = val(getvar(charpath & name & ".chr", "penas", "cant"))
        call writevar(charpath & name & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & name & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": carcel " & i & "m, motivo: " & lcase$(tstr) & " " & date & " " & time)
    end if
    
    call encarcelar(tindex, i, userlist(userindex).name)
    call loggm(userlist(userindex).name, " encarcelo a " & name, userlist(userindex).flags.privilegios = playertype.consejero)
    exit sub
end if


if ucase$(left$(rdata, 6)) = "/rmata" then

    rdata = right$(rdata, len(rdata) - 6)
    
    'los consejeros no pueden rmatar a nada en el mapa pretoriano
    if userlist(userindex).flags.privilegios = playertype.consejero and userlist(userindex).pos.map = mapa_pretoriano then
        call senddata(sendtarget.toindex, userindex, 0, "||los consejeros no pueden usar este comando en el mapa pretoriano." & fonttype_info)
        exit sub
    end if
    
    tindex = userlist(userindex).flags.targetnpc
    if tindex > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||rmatas (con posible respawn) a: " & npclist(tindex).name & fonttype_info)
        dim minpc as npc
        minpc = npclist(tindex)
        call quitarnpc(tindex)
        call respawnnpc(minpc)
        
    'seres
    else
        call senddata(sendtarget.toindex, userindex, 0, "||debes hacer click sobre el npc antes" & fonttype_info)
    end if
    
    exit sub
end if



if ucase$(left$(rdata, 13)) = "/advertencia " then
    '/carcel nick@motivo
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right$(rdata, len(rdata) - 13)
    
    name = readfield(1, rdata, asc("@"))
    tstr = readfield(2, rdata, asc("@"))
    if name = "" or tstr = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||utilice /advertencia nick@motivo" & fonttype_info)
        exit sub
    end if
    
    tindex = nameindex(name)
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > playertype.user then
        call senddata(sendtarget.toindex, userindex, 0, "||no podes advertir a administradores." & fonttype_info)
        exit sub
    end if
    
    name = replace(name, "\", "")
    name = replace(name, "/", "")
    
    if fileexist(charpath & name & ".chr", vbnormal) then
        tint = val(getvar(charpath & name & ".chr", "penas", "cant"))
        call writevar(charpath & name & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & name & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": advertencia por: " & lcase$(tstr) & " " & date & " " & time)
    end if
    
    call loggm(userlist(userindex).name, " advirtio a " & name, userlist(userindex).flags.privilegios = playertype.consejero)
    exit sub
end if



'modifica caracter
if ucase$(left$(rdata, 5)) = "/mod " then
    rdata = ucase$(right$(rdata, len(rdata) - 5))
    tstr = replace$(readfield(1, rdata, 32), "+", " ")
    tindex = nameindex(tstr)
    arg1 = readfield(2, rdata, 32)
    arg2 = readfield(3, rdata, 32)
    arg3 = readfield(4, rdata, 32)
    arg4 = readfield(5, rdata, 32)
    
    if userlist(userindex).flags.esrolesmaster then
        select case userlist(userindex).flags.privilegios
            case playertype.consejero
                ' los rms consejeros s�lo se pueden editar su head, body y exp
                if nameindex(readfield(1, rdata, 32)) <> userindex then exit sub
                if arg1 <> "body" and arg1 <> "head" and arg1 <> "level" then exit sub
            
            case playertype.semidios
                ' los rms s�lo se pueden editar su level y el head y body de cualquiera
                if arg1 = "level" and nameindex(readfield(1, rdata, 32)) <> userindex then exit sub
                if arg1 <> "body" and arg1 <> "head" then exit sub
            
            case playertype.dios
                ' si quiere modificar el level s�lo lo puede hacer sobre s� mismo
                if arg1 = "level" and nameindex(readfield(1, rdata, 32)) <> userindex then exit sub
                ' los drms pueden aplicar los siguientes comandos sobre cualquiera
                if arg1 <> "body" and arg1 <> "head" and arg1 <> "ciu" and arg1 <> "cri" and arg1 <> "clase" and arg1 <> "skills" then exit sub
        end select
    elseif userlist(userindex).flags.privilegios < playertype.dios then   'si no es rm debe ser dios para poder usar este comando
        exit sub
    end if
    
    call loggm(userlist(userindex).name, rdata, false)
    
    select case arg1
        case "oro" '/mod yo oro 95000
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if val(arg2) < 5000000 then
                userlist(tindex).stats.gld = val(arg2)
                call senduserstatsbox(tindex)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||no esta permitido utilizar valores mayores. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
        case "exp" '/mod yo exp 9995000
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if val(arg2) < 15995001 then
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
                call senddata(sendtarget.toindex, userindex, 0, "||no esta permitido utilizar valores mayores a mucho. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
        case "body"
            if tindex <= 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "init", "body", arg2)
                call senddata(sendtarget.toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
                exit sub
            end if
            
            call changeuserchar(sendtarget.tomap, 0, userlist(tindex).pos.map, tindex, val(arg2), userlist(tindex).char.head, userlist(tindex).char.heading, userlist(tindex).char.weaponanim, userlist(tindex).char.shieldanim, userlist(tindex).char.cascoanim)
            exit sub
        case "head"
            if tindex <= 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "init", "head", arg2)
                call senddata(sendtarget.toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
                exit sub
            end if
            
            call changeuserchar(sendtarget.tomap, 0, userlist(tindex).pos.map, tindex, userlist(tindex).char.body, val(arg2), userlist(tindex).char.heading, userlist(tindex).char.weaponanim, userlist(tindex).char.shieldanim, userlist(tindex).char.cascoanim)
            exit sub
        case "cri"
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            userlist(tindex).faccion.criminalesmatados = val(arg2)
            exit sub
        case "ciu"
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            userlist(tindex).faccion.ciudadanosmatados = val(arg2)
            exit sub
        case "level"
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            userlist(tindex).stats.elv = val(arg2)
            exit sub
        case "clase"
            if tindex <= 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if len(arg2) > 1 then
                userlist(tindex).clase = ucase$(left$(arg2, 1)) & lcase$(mid$(arg2, 2))
            else
                userlist(tindex).clase = ucase$(arg2)
            end if
    '[dng]
        case "skills"
            for loopc = 1 to numskills
                if ucase$(replace$(skillsnames(loopc), " ", "+")) = ucase$(arg2) then n = loopc
            next loopc


            if n = 0 then
                call senddata(sendtarget.toindex, 0, 0, "|| skill inexistente!" & fonttype_info)
                exit sub
            end if

            if tindex = 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "skills", "sk" & n, arg3)
                call senddata(sendtarget.toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
            else
                userlist(tindex).stats.userskills(n) = val(arg3)
            end if
        exit sub
        
        case "skillslibres"
            
            if tindex = 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "stats", "skillptslibres", arg2)
                call senddata(sendtarget.toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
            
            else
                userlist(tindex).stats.skillpts = val(arg2)
            end if
        exit sub
    '[/dng]
        case else
            call senddata(sendtarget.toindex, userindex, 0, "||comando no permitido." & fonttype_info)
            exit sub
        end select

    exit sub
end if


'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
if userlist(userindex).flags.privilegios < playertype.semidios then
    exit sub
end if

if ucase$(left$(rdata, 6)) = "/info " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 6)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        'no permitimos mirar dioses
        if esdios(rdata) or esadmin(rdata) then exit sub
        
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline, buscando en charfile." & fonttype_info)
        senduserstatstxtoff userindex, rdata
    else
        if userlist(tindex).flags.privilegios >= playertype.dios then exit sub
        senduserstatstxt userindex, tindex
    end if

    exit sub
end if

'ministats del user
    if ucase$(left$(rdata, 6)) = "/stat " then
        if userlist(userindex).flags.esrolesmaster then exit sub
        call loggm(userlist(userindex).name, rdata, false)
        
        rdata = right$(rdata, len(rdata) - 6)
        
        tindex = nameindex(rdata)
        
        if tindex <= 0 then
            call senddata(sendtarget.toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_info)
            senduserministatstxtfromchar userindex, rdata
        else
            senduserministatstxt userindex, tindex
        end if
    
        exit sub
    end if


if ucase$(left$(rdata, 5)) = "/bal " then
rdata = right$(rdata, len(rdata) - 5)
tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_talk)
        senduserorotxtfromchar userindex, rdata
    else
        call senddata(sendtarget.toindex, userindex, 0, "|| el usuario " & rdata & " tiene " & userlist(tindex).stats.banco & " en el banco" & fonttype_talk)
    end if
    exit sub
end if

'inv del user
if ucase$(left$(rdata, 5)) = "/inv " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline. leyendo del charfile..." & fonttype_talk)
        senduserinvtxtfromchar userindex, rdata
    else
        senduserinvtxt userindex, tindex
    end if

    exit sub
end if

'inv del user
if ucase$(left$(rdata, 5)) = "/bov " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_talk)
        senduserbovedatxtfromchar userindex, rdata
    else
        senduserbovedatxt userindex, tindex
    end if

    exit sub
end if

'skills del user
if ucase$(left$(rdata, 8)) = "/skills " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 8)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call replace(rdata, "\", " ")
        call replace(rdata, "/", " ")
        
        for tint = 1 to numskills
            call senddata(sendtarget.toindex, userindex, 0, "|| char>" & skillsnames(tint) & " = " & getvar(charpath & rdata & ".chr", "skills", "sk" & tint) & fonttype_info)
        next tint
            call senddata(sendtarget.toindex, userindex, 0, "|| char> libres:" & getvar(charpath & rdata & ".chr", "stats", "skillptslibres") & fonttype_info)
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
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    userlist(tindex).flags.muerto = 0
    userlist(tindex).stats.minhp = userlist(tindex).stats.maxhp
    call darcuerpodesnudo(tindex)
    call changeuserchar(sendtarget.tomap, 0, userlist(tindex).pos.map, val(tindex), userlist(tindex).char.body, userlist(tindex).origchar.head, userlist(tindex).char.heading, userlist(tindex).char.weaponanim, userlist(tindex).char.shieldanim, userlist(tindex).char.cascoanim)
    call senduserstatsbox(val(tindex))
    call senddata(sendtarget.toindex, tindex, 0, "||" & userlist(userindex).name & " te ha resucitado." & fonttype_info)
    call loggm(userlist(userindex).name, "resucito a " & userlist(tindex).name, false)
    exit sub
end if

if ucase$(rdata) = "/onlinegm" then
        for loopc = 1 to lastuser
            'tiene nombre? es gm? si es dios o admin, nosotros lo somos tambi�n??
            if (userlist(loopc).name <> "") and userlist(loopc).flags.privilegios > playertype.user and (userlist(loopc).flags.privilegios < playertype.dios or userlist(userindex).flags.privilegios >= playertype.dios) then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        if len(tstr) > 0 then
            tstr = left$(tstr, len(tstr) - 2)
            call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no hay gms online" & fonttype_info)
        end if
        exit sub
end if

'barrin 30/9/03
if ucase$(rdata) = "/onlinemap" then
    for loopc = 1 to lastuser
        if userlist(loopc).name <> "" and userlist(loopc).pos.map = userlist(userindex).pos.map and (userlist(loopc).flags.privilegios < playertype.dios or userlist(userindex).flags.privilegios >= playertype.dios) then
            tstr = tstr & userlist(loopc).name & ", "
        end if
    next loopc
    if len(tstr) > 2 then _
        tstr = left$(tstr, len(tstr) - 2)
    call senddata(sendtarget.toindex, userindex, 0, "||usuarios en el mapa: " & tstr & fonttype_info)
    exit sub
end if


'perdon
if ucase$(left$(rdata, 7)) = "/perdon" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 8)
    tindex = nameindex(rdata)
    if tindex > 0 then
        
        if esnewbie(tindex) then
                call volverciudadano(tindex)
        else
                call loggm(userlist(userindex).name, "intento perdonar un personaje de nivel avanzado.", false)
                call senddata(sendtarget.toindex, userindex, 0, "||solo se permite perdonar newbies." & fonttype_info)
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
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
        call senddata(sendtarget.toindex, userindex, 0, "||no podes echar a alguien con jerarquia mayor a la tuya." & fonttype_info)
        exit sub
    end if
        
    call senddata(sendtarget.toall, 0, 0, "||" & userlist(userindex).name & " echo a " & userlist(tindex).name & "." & fonttype_info)
    call closesocket(tindex)
    call loggm(userlist(userindex).name, "echo a " & userlist(tindex).name, false)
    exit sub
end if

if ucase$(left$(rdata, 10)) = "/ejecutar " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 10)
    tindex = nameindex(rdata)
    if userlist(tindex).flags.privilegios > playertype.user then
        call senddata(sendtarget.toindex, userindex, 0, "||est�s loco?? como vas a pi�atear un gm!!!! :@" & fonttype_info)
        exit sub
    end if
    if tindex > 0 then
        call userdie(tindex)
        call senddata(sendtarget.toall, 0, 0, "||" & userlist(userindex).name & " ha ejecutado a " & userlist(tindex).name & fonttype_ejecucion)
        call loggm(userlist(userindex).name, " ejecuto a " & userlist(tindex).name, false)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||no est� online" & fonttype_info)
    end if
exit sub
end if

if ucase$(left$(rdata, 5)) = "/ban " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 5)
    tstr = readfield(2, rdata, asc("@")) ' nick
    tindex = nameindex(tstr)
    name = readfield(1, rdata, asc("@")) ' motivo
    
    if ucase$(rdata) = "reeves" then exit sub
    
    
    ' crawling chaos, underground
    ' cult has summed, twisted sound
    
    ' drain you out of your sanity
    ' face the thing that sould not be!
    
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario no esta online." & fonttype_talk)
        
        if fileexist(charpath & tstr & ".chr", vbnormal) then
            tlong = userdarprivilegiolevel(tstr)
            
            if tlong > userlist(userindex).flags.privilegios then
                call senddata(sendtarget.toindex, userindex, 0, "||no podes banear a al alguien de mayor jerarquia." & fonttype_info)
                exit sub
            end if
            
            if getvar(charpath & tstr & ".chr", "flags", "ban") <> "0" then
                call senddata(sendtarget.toindex, userindex, 0, "||el personaje ya se encuentra baneado." & fonttype_info)
                exit sub
            end if
            
            call logbanfromname(tstr, userindex, name)
            call senddata(sendtarget.toadmins, 0, 0, "||servidor> " & userlist(userindex).name & " ha baneado a " & tstr & "." & fonttype_server)
            
            'ponemos el flag de ban a 1
            call writevar(charpath & tstr & ".chr", "flags", "ban", "1")
            'ponemos la pena
            tint = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
            call writevar(charpath & tstr & ".chr", "penas", "cant", tint + 1)
            call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban por " & lcase$(name) & " " & date & " " & time)
            
            if tlong > 0 then
                    userlist(userindex).flags.ban = 1
                    call closesocket(userindex)
                    call senddata(sendtarget.toadmins, 0, 0, "||" & userlist(userindex).name & " banned by the server por bannear un administrador." & fonttype_fight)
            end if

            call loggm(userlist(userindex).name, "ban a " & tstr, false)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||el pj " & tstr & " no existe." & fonttype_info)
        end if
    else
        if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
            call senddata(sendtarget.toindex, userindex, 0, "||no podes banear a al alguien de mayor jerarquia." & fonttype_info)
            exit sub
        end if
        
        call logban(tindex, userindex, name)
        call senddata(sendtarget.toadmins, 0, 0, "||servidor> " & userlist(userindex).name & " ha baneado a " & userlist(tindex).name & "." & fonttype_server)
        
        'ponemos el flag de ban a 1
        userlist(tindex).flags.ban = 1
        
        if userlist(tindex).flags.privilegios > playertype.user then
            userlist(userindex).flags.ban = 1
            call closesocket(userindex)
            call senddata(sendtarget.toadmins, 0, 0, "||" & userlist(userindex).name & " banned by the server por bannear un administrador." & fonttype_fight)
        end if
        
        call loggm(userlist(userindex).name, "ban a " & userlist(tindex).name, false)
        
        'ponemos el flag de ban a 1
        call writevar(charpath & tstr & ".chr", "flags", "ban", "1")
        'ponemos la pena
        tint = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
        call writevar(charpath & tstr & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban por " & lcase$(name) & " " & date & " " & time)
        
        call closesocket(tindex)
    end if

    exit sub
end if

if ucase$(left$(rdata, 7)) = "/unban " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 7)
    
    rdata = replace(rdata, "\", "")
    rdata = replace(rdata, "/", "")
    
    if not fileexist(charpath & rdata & ".chr", vbnormal) then
        call senddata(sendtarget.toindex, userindex, 0, "||charfile inexistente (no use +)" & fonttype_info)
        exit sub
    end if
    
    call unban(rdata)
    
    'penas
    i = val(getvar(charpath & rdata & ".chr", "penas", "cant"))
    call writevar(charpath & rdata & ".chr", "penas", "cant", i + 1)
    call writevar(charpath & rdata & ".chr", "penas", "p" & i + 1, lcase$(userlist(userindex).name) & ": unban. " & date & " " & time)
    
    call loggm(userlist(userindex).name, "/unban a " & rdata, false)
    call senddata(sendtarget.toindex, userindex, 0, "||" & rdata & " unbanned." & fonttype_info)
    

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
        call senddata(sendtarget.toindex, userindex, 0, "||el jugador no esta online." & fonttype_info)
        exit sub
    end if
    
    call senddata(sendtarget.toindex, tindex, 0, "||" & userlist(userindex).name & " h� sido trasportado." & fonttype_info)
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
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 9)
    if userlist(userindex).flags.targetnpc = 0 then exit sub
    call resetnpcinv(userlist(userindex).flags.targetnpc)
    call loggm(userlist(userindex).name, "/resetinv " & npclist(userlist(userindex).flags.targetnpc).name, false)
    exit sub
end if

'/clean
if ucase$(rdata) = "/limpiar" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call limpiarmundo
    exit sub
end if

'mensaje del servidor
if ucase$(left$(rdata, 6)) = "/rmsg " then
    rdata = right$(rdata, len(rdata) - 6)
    call loggm(userlist(userindex).name, "mensaje broadcast:" & rdata, false)
    if rdata <> "" then
        call senddata(sendtarget.toall, 0, 0, "||" & rdata & fonttype_talk & endc)
    end if
    exit sub
end if

'ip del nick
if ucase$(left$(rdata, 9)) = "/nick2ip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 9)
    tindex = nameindex(ucase$(rdata))
    call loggm(userlist(userindex).name, "nick2ip solicito la ip de " & rdata, userlist(userindex).flags.privilegios = playertype.consejero)
    if tindex > 0 then
        if (userlist(userindex).flags.privilegios > playertype.user and userlist(tindex).flags.privilegios = playertype.user) or (userlist(userindex).flags.privilegios >= playertype.dios) then
            call senddata(sendtarget.toindex, userindex, 0, "||el ip de " & rdata & " es " & userlist(tindex).ip & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no tienes los privilegios necesarios" & fonttype_info)
        end if
    else
       call senddata(sendtarget.toindex, userindex, 0, "||no hay ningun personaje con ese nick" & fonttype_info)
    end if
    exit sub
end if
 
'ip del nick
if ucase$(left$(rdata, 9)) = "/ip2nick " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 9)

    if instr(rdata, ".") < 1 then
        tint = nameindex(rdata)
        if tint < 1 then
            call senddata(sendtarget.toindex, userindex, 0, "||pj offline" & fonttype_info)
            exit sub
        end if
        rdata = userlist(tint).ip
    end if
    tstr = vbnullstring
    call loggm(userlist(userindex).name, "ip2nick solicito los nicks de ip " & rdata, userlist(userindex).flags.privilegios = playertype.consejero)
    for loopc = 1 to lastuser
        if userlist(loopc).ip = rdata and userlist(loopc).name <> "" and userlist(loopc).flags.userlogged then
            if (userlist(userindex).flags.privilegios > playertype.user and userlist(loopc).flags.privilegios = playertype.user) or (userlist(userindex).flags.privilegios >= playertype.dios) then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        end if
    next loopc
    
    call senddata(sendtarget.toindex, userindex, 0, "||los personajes con ip " & rdata & " son: " & tstr & fonttype_info)
    exit sub
end if


if ucase$(left$(rdata, 8)) = "/onclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 8)
    tint = guildindex(rdata)
    
    if tint > 0 then
        tstr = modguilds.m_listademiembrosonline(userindex, tint)
        call senddata(sendtarget.toindex, userindex, 0, "||clan " & ucase(rdata) & ": " & tstr & fonttype_guildmsg)
    end if
end if


'crear teleport
if ucase(left(rdata, 4)) = "/ct " then
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < playertype.dios then exit sub
    '/ct mapa_dest x_dest y_dest
    rdata = right(rdata, len(rdata) - 4)
    call loggm(userlist(userindex).name, "/ct: " & rdata, false)
    mapa = readfield(1, rdata, 32)
    x = readfield(2, rdata, 32)
    y = readfield(3, rdata, 32)
    
    if mapavalido(mapa) = false or inmapbounds(mapa, x, y) = false then
        exit sub
    end if
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).objinfo.objindex > 0 then
        exit sub
    end if
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map > 0 then
        exit sub
    end if
    
    if mapdata(mapa, x, y).objinfo.objindex > 0 then
        call senddata(sendtarget.toindex, userindex, mapa, "||hay un objeto en el piso en ese lugar" & fonttype_info)
        exit sub
    end if
    
    dim et as obj
    et.amount = 1
    et.objindex = 378
    
    call makeobj(sendtarget.tomap, 0, userlist(userindex).pos.map, et, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1)
    
    et.amount = 1
    et.objindex = 651
    
    call makeobj(sendtarget.tomap, 0, mapa, et, mapa, x, y)
    
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map = mapa
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.x = x
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.y = y
    
    exit sub
end if

'destruir teleport
'toma el ultimo click
if ucase(left(rdata, 3)) = "/dt" then
    '/dt
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < playertype.dios then exit sub
    call loggm(userlist(userindex).name, "/dt", false)
    
    mapa = userlist(userindex).flags.targetmap
    x = userlist(userindex).flags.targetx
    y = userlist(userindex).flags.targety
    
    if objdata(mapdata(mapa, x, y).objinfo.objindex).objtype = eobjtype.otteleport and _
        mapdata(mapa, x, y).tileexit.map > 0 then
        call eraseobj(sendtarget.tomap, 0, mapa, mapdata(mapa, x, y).objinfo.amount, mapa, x, y)
        call eraseobj(sendtarget.tomap, 0, mapdata(mapa, x, y).tileexit.map, 1, mapdata(mapa, x, y).tileexit.map, mapdata(mapa, x, y).tileexit.x, mapdata(mapa, x, y).tileexit.y)
        mapdata(mapa, x, y).tileexit.map = 0
        mapdata(mapa, x, y).tileexit.x = 0
        mapdata(mapa, x, y).tileexit.y = 0
    end if
    
    exit sub
end if


if ucase$(rdata) = "/lluvia" then
    call loggm(userlist(userindex).name, rdata, false)
    lloviendo = not lloviendo
    call senddata(sendtarget.toall, 0, 0, "llu")
    exit sub
end if


if ucase$(left$(rdata, 9)) = "/setdesc " then
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < playertype.dios then exit sub
    rdata = right$(rdata, len(rdata) - 9)
    dummyint = userlist(userindex).flags.targetuser
    if dummyint > 0 then
        userlist(dummyint).descrm = rdata
    else
        call senddata(sendtarget.toindex, userindex, 0, "||haz click sobre un personaje antes!" & fonttype_info)
    end if
    exit sub
    
end if




select case ucase$(left$(rdata, 13))
    case "/forcemidimap"
        if len(rdata) > 13 then
            rdata = right$(rdata, len(rdata) - 14)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||el formato correcto de este comando es /forcemidmap midi mapa, siendo el mapa opcional" & fonttype_info)
            exit sub
        end if
        
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios < playertype.dios and not userlist(userindex).flags.esrolesmaster then exit sub
        
        'obtenemos el n�mero de midi
        arg1 = readfield(1, rdata, vbkeyspace)
        ' y el de mapa
        arg2 = readfield(2, rdata, vbkeyspace)
        
        'si el mapa no fue enviado tomo el actual
        if isnumeric(arg2) then
            tint = cint(arg2)
        else
            tint = userlist(userindex).pos.map
        end if
        
        if isnumeric(arg1) then
            if arg1 = "0" then
                'ponemos el default del mapa
                call senddata(sendtarget.tomap, 0, tint, "tm" & cstr(mapinfo(userlist(userindex).pos.map).music))
            else
                'ponemos el pedido por el gm
                call senddata(sendtarget.tomap, 0, tint, "tm" & arg1)
            end if
        else
            call senddata(sendtarget.toindex, userindex, 0, "||el formato correcto de este comando es /forcemidmap midi mapa, siendo el mapa opcional" & fonttype_info)
        end if
        exit sub
    
    case "/forcewavmap "
        rdata = right$(rdata, len(rdata) - 13)
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios < playertype.dios and not userlist(userindex).flags.esrolesmaster then exit sub
        
        'obtenemos el n�mero de wav
        arg1 = readfield(1, rdata, vbkeyspace)
        ' el de mapa
        arg2 = readfield(2, rdata, vbkeyspace)
        ' el de x
        arg3 = readfield(3, rdata, vbkeyspace)
        ' y el de y (las coords x-y s�lo tendr�n sentido al implementarse el panning en la 11.6)
        arg4 = readfield(4, rdata, vbkeyspace)
        
        'si el mapa no fue enviado tomo el actual
        if isnumeric(arg2) and isnumeric(arg3) and isnumeric(arg4) then
            tint = cint(arg2)
        else
            tint = userlist(userindex).pos.map
            arg3 = cstr(userlist(userindex).pos.x)
            arg4 = cstr(userlist(userindex).pos.y)
        end if
        
        if isnumeric(arg1) then
            'ponemos el pedido por el gm
            call senddata(sendtarget.tomap, 0, tint, "tw" & arg1)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||el formato correcto de este comando es /forcewavmap wav mapa x y, siendo la posici�n opcional" & fonttype_info)
        end if
        exit sub
end select

select case ucase$(left$(rdata, 8))
    case "/realmsg"
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios > playertype.semidios or userlist(userindex).flags.esrolesmaster then
            tstr = right$(rdata, len(rdata) - 9)
            
            if instr(1, tstr, "~") = 0 then
                call senddata(sendtarget.torealyrms, 0, 0, "||armada real> " & tstr & fonttype_talk)
            else
                call senddata(sendtarget.torealyrms, 0, 0, "||armada real> " & tstr)
            end if
        end if
        exit sub
    
    case "/caosmsg"
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios > playertype.semidios or userlist(userindex).flags.esrolesmaster then
            tstr = right$(rdata, len(rdata) - 9)
            
            if instr(1, tstr, "~") = 0 then
                call senddata(sendtarget.tocaosyrms, 0, 0, "||fuerzas del caos> " & tstr & fonttype_talk)
            else
                call senddata(sendtarget.tocaosyrms, 0, 0, "||fuerzas del caos> " & tstr)
            end if
        end if
        exit sub
    
    case "/ciumsg "
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios > playertype.semidios or userlist(userindex).flags.esrolesmaster then
            tstr = right$(rdata, len(rdata) - 8)
            
            if instr(1, tstr, "~") = 0 then
                call senddata(sendtarget.tociudadanosyrms, 0, 0, "||ciudadanos> " & tstr & fonttype_talk)
            else
                call senddata(sendtarget.tociudadanosyrms, 0, 0, "||ciudadanos> " & tstr)
            end if
        end if
        exit sub
    
    case "/crimsg "
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios > playertype.semidios or userlist(userindex).flags.esrolesmaster then
            tstr = right$(rdata, len(rdata) - 8)
            
            if instr(1, tstr, "~") = 0 then
                call senddata(sendtarget.tocriminalesyrms, 0, 0, "||criminales> " & tstr & fonttype_talk)
            else
                call senddata(sendtarget.tocriminalesyrms, 0, 0, "||criminales> " & tstr)
            end if
        end if
        exit sub
    
    case "/talkas "
        'solo dioses, admins y rms
        if userlist(userindex).flags.privilegios > playertype.semidios or userlist(userindex).flags.esrolesmaster then
            'asegurarse haya un npc seleccionado
            if userlist(userindex).flags.targetnpc > 0 then
                tstr = right$(rdata, len(rdata) - 8)
                
                call senddata(sendtarget.tonpcarea, userlist(userindex).flags.targetnpc, npclist(userlist(userindex).flags.targetnpc).pos.map, "||" & vbwhite & "�" & tstr & "�" & cstr(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            else
                call senddata(sendtarget.toindex, userindex, 0, "||debes seleccionar el npc por el que quieres hablar antes de usar este comando" & fonttype_info)
            end if
        end if
        exit sub
end select




'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
if userlist(userindex).flags.privilegios < playertype.dios then
    exit sub
end if


'[barrin 30-11-03]
'quita todos los objetos del area
if ucase$(rdata) = "/massdest" then
    for y = userlist(userindex).pos.y - minyborder + 1 to userlist(userindex).pos.y + minyborder - 1
            for x = userlist(userindex).pos.x - minxborder + 1 to userlist(userindex).pos.x + minxborder - 1
                if x > 0 and y > 0 and x < 101 and y < 101 then _
                    if mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex > 0 then _
                    if itemnoesdemapa(mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex) then call eraseobj(sendtarget.tomap, userindex, userlist(userindex).pos.map, 10000, userlist(userindex).pos.map, x, y)
            next x
    next y
    call loggm(userlist(userindex).name, "/massdest", (userlist(userindex).flags.privilegios = playertype.consejero))
    exit sub
end if
'[/barrin 30-11-03]


'[yb]
if ucase$(left$(rdata, 12)) = "/aceptconse " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 12)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline" & fonttype_info)
    else
        call senddata(sendtarget.toall, 0, 0, "||" & rdata & " fue aceptado en el honorable consejo real de banderbill." & fonttype_consejo)
        userlist(tindex).flags.pertalcons = 1
        call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y, false)
    end if
    exit sub
end if

if ucase$(left$(rdata, 16)) = "/aceptconsecaos " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 16)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||usuario offline" & fonttype_info)
    else
        call senddata(sendtarget.toall, 0, 0, "||" & rdata & " fue aceptado en el consejo de la legi�n oscura." & fonttype_consejocaos)
        userlist(tindex).flags.pertalconscaos = 1
        call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y, false)
    end if
    exit sub
end if

if left$(ucase$(rdata), 5) = "/piso" then
    for x = 5 to 95
        for y = 5 to 95
            tindex = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
            if tindex > 0 then
                if objdata(tindex).objtype <> 4 then
                    call senddata(sendtarget.toindex, userindex, 0, "||(" & x & "," & y & ") " & objdata(tindex).name & fonttype_info)
                end if
            end if
        next y
    next x
    exit sub
end if

if ucase$(left$(rdata, 10)) = "/estupido " then
    if userlist(userindex).flags.esrolesmaster = 1 then exit sub
    'para deteccion de aoice
    rdata = ucase$(right$(rdata, len(rdata) - 10))
    i = nameindex(rdata)
    if i <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||offline" & fonttype_info)
    else
        call senddata(sendtarget.toindex, i, 0, "dumb")
    end if
    exit sub
end if

if ucase$(left$(rdata, 12)) = "/noestupido " then
    if userlist(userindex).flags.esrolesmaster = 1 then exit sub
    'para deteccion de aoice
    rdata = ucase$(right$(rdata, len(rdata) - 12))
    i = nameindex(rdata)
    if i <= 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||offline" & fonttype_info)
    else
        call senddata(sendtarget.toindex, i, 0, "nestup")
    end if
    exit sub
end if

if left$(ucase$(rdata), 13) = "/dumpsecurity" then
    call securityip.dumptables
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/kickconse " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 11)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        if fileexist(charpath & rdata & ".chr") then
            call senddata(sendtarget.toindex, userindex, 0, "||usuario offline, echando de los consejos" & fonttype_info)
            call writevar(charpath & ucase(rdata) & ".chr", "consejo", "pertenece", 0)
            call writevar(charpath & ucase(rdata) & ".chr", "consejo", "pertenececaos", 0)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no se encuentra el charfile " & charpath & rdata & ".chr" & fonttype_info)
            exit sub
        end if
    else
        if userlist(tindex).flags.pertalcons > 0 then
            call senddata(sendtarget.toindex, tindex, 0, "||has sido echado en el consejo de banderbill" & fonttype_talk & endc)
            userlist(tindex).flags.pertalcons = 0
            call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y)
            call senddata(sendtarget.toall, 0, 0, "||" & rdata & " fue expulsado del consejo de banderbill" & fonttype_consejo)
        end if
        if userlist(tindex).flags.pertalconscaos > 0 then
            call senddata(sendtarget.toindex, tindex, 0, "||has sido echado en el consejo de la legi�n oscura" & fonttype_talk & endc)
            userlist(tindex).flags.pertalconscaos = 0
            call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y)
            call senddata(sendtarget.toall, 0, 0, "||" & rdata & " fue expulsado del consejo de la legi�n oscura" & fonttype_consejocaos)
        end if
    end if
    exit sub
end if
'[/yb]



if ucase$(left$(rdata, 8)) = "/trigger" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = trim(right(rdata, len(rdata) - 8))
    mapa = userlist(userindex).pos.map
    x = userlist(userindex).pos.x
    y = userlist(userindex).pos.y
    if rdata <> "" then
        tint = mapdata(mapa, x, y).trigger
        mapdata(mapa, x, y).trigger = val(rdata)
    end if
    call senddata(sendtarget.toindex, userindex, 0, "||trigger " & mapdata(mapa, x, y).trigger & " en mapa " & mapa & " " & x & ", " & y & fonttype_info)
    exit sub
end if



if ucase(rdata) = "/baniplist" then
   
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    tstr = "||"
    for loopc = 1 to banips.count
        tstr = tstr & banips.item(loopc) & ", "
    next loopc
    tstr = tstr & fonttype_info
    call senddata(sendtarget.toindex, userindex, 0, tstr)
    exit sub
end if

if ucase(rdata) = "/banipreload" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call banipguardar
    call banipcargar
    exit sub
end if

if ucase(left(rdata, 14)) = "/miembrosclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = trim(right(rdata, len(rdata) - 9))
    if not fileexist(app.path & "\guilds\" & rdata & "-members.mem") then
        call senddata(sendtarget.toindex, userindex, 0, "|| no existe el clan: " & rdata & fonttype_info)
        exit sub
    end if
    
    call loggm(userlist(userindex).name, "miembrosclan a " & rdata, false)

    tint = val(getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "init", "nromembers"))
    
    for i = 1 to tint
        tstr = getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "members", "member" & i)
        'tstr es la victima
        call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & "<" & rdata & ">." & fonttype_info)
    next i

    exit sub
end if



if ucase(left(rdata, 9)) = "/banclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = trim(right(rdata, len(rdata) - 9))
    if not fileexist(app.path & "\guilds\" & rdata & "-members.mem") then
        call senddata(sendtarget.toindex, userindex, 0, "|| no existe el clan: " & rdata & fonttype_info)
        exit sub
    end if
    
    call senddata(sendtarget.toall, 0, 0, "|| " & userlist(userindex).name & " banned al clan " & ucase$(rdata) & fonttype_fight)
    
    'baneamos a los miembros
    call loggm(userlist(userindex).name, "banclan a " & rdata, false)

    tint = val(getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "init", "nromembers"))
    
    for i = 1 to tint
        tstr = getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "members", "member" & i)
        'tstr es la victima
        call ban(tstr, "administracion del servidor", "clan banned")
        tindex = nameindex(tstr)
        if tindex > 0 then
            'esta online
            userlist(tindex).flags.ban = 1
            call closesocket(tindex)
        end if
        
        call senddata(sendtarget.toall, 0, 0, "||   " & tstr & "<" & rdata & "> ha sido expulsado del servidor." & fonttype_fight)

        'ponemos el flag de ban a 1
        call writevar(charpath & tstr & ".chr", "flags", "ban", "1")

        'ponemos la pena
        n = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
        call writevar(charpath & tstr & ".chr", "penas", "cant", n + 1)
        call writevar(charpath & tstr & ".chr", "penas", "p" & n + 1, lcase$(userlist(userindex).name) & ": ban al clan: " & rdata & " " & date & " " & time)

    next i

    exit sub
end if


'ban x ip
if ucase(left(rdata, 7)) = "/banip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    dim banip as string, xnick as boolean
    
    rdata = right$(rdata, len(rdata) - 7)
    tstr = replace(readfield(1, rdata, asc(" ")), "+", " ")
    'busca primero la ip del nick
    tindex = nameindex(tstr)
    if tindex <= 0 then
        xnick = false
        call loggm(userlist(userindex).name, "/banip " & rdata, false)
        banip = tstr
    else
        xnick = true
        call loggm(userlist(userindex).name, "/banip " & userlist(tindex).name & " - " & userlist(tindex).ip, false)
        banip = userlist(tindex).ip
    end if
    
    rdata = right$(rdata, len(rdata) - len(tstr))
    
    if banipbuscar(banip) > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||la ip " & banip & " ya se encuentra en la lista de bans." & fonttype_info)
        exit sub
    end if
    
    call banipagrega(banip)
    call senddata(sendtarget.toadmins, userindex, 0, "||" & userlist(userindex).name & " baneo la ip " & banip & fonttype_fight)
    
    if xnick = true then
        call logban(tindex, userindex, "ban por ip desde nick por " & rdata)
        
        call senddata(sendtarget.toadmins, 0, 0, "||" & userlist(userindex).name & " echo a " & userlist(tindex).name & "." & fonttype_fight)
        call senddata(sendtarget.toadmins, 0, 0, "||" & userlist(userindex).name & " banned a " & userlist(tindex).name & "." & fonttype_fight)
        
        'ponemos el flag de ban a 1
        userlist(tindex).flags.ban = 1
        
        call loggm(userlist(userindex).name, "echo a " & userlist(tindex).name, false)
        call loggm(userlist(userindex).name, "ban a " & userlist(tindex).name, false)
        call closesocket(tindex)
    end if
    
    exit sub
end if

'desbanea una ip
if ucase(left(rdata, 9)) = "/unbanip " then
    
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right(rdata, len(rdata) - 9)
    call loggm(userlist(userindex).name, "/unbanip " & rdata, false)
    
'    for loopc = 1 to banips.count
'        if banips.item(loopc) = rdata then
'            banips.remove loopc
'            call senddata(sendtarget.toindex, userindex, 0, "||la ip " & banip & " se ha quitado de la lista de bans." & fonttype_info)
'            exit sub
'        end if
'    next loopc
'
'    call senddata(sendtarget.toindex, userindex, 0, "||la ip " & rdata & " no se encuentra en la lista de bans." & fonttype_info)
    
    if banipquita(rdata) then
        call senddata(sendtarget.toindex, userindex, 0, "||la ip """ & rdata & """ se ha quitado de la lista de bans." & fonttype_info)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||la ip """ & rdata & """ no se encuentra en la lista de bans." & fonttype_info)
    end if
    
    exit sub
end if



'crear item
if ucase(left(rdata, 4)) = "/ci " then
    rdata = right$(rdata, len(rdata) - 4)
    call loggm(userlist(userindex).name, "/ci: " & rdata, false)
    
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).objinfo.objindex > 0 then
        exit sub
    end if
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map > 0 then
        exit sub
    end if
    if val(rdata) < 1 or val(rdata) > numobjdatas then
        exit sub
    end if
    
    'is the object not null?
    if objdata(val(rdata)).name = "" then exit sub
    
    dim objeto as obj
    
    call senddata(sendtarget.toindex, userindex, 0, "||atencion: fueron creados ***100*** items!, tire y /dest los que no necesite!!" & fonttype_guild)
    
    objeto.amount = 100
    objeto.objindex = val(rdata)
    
    call makeobj(sendtarget.tomap, 0, userlist(userindex).pos.map, objeto, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1)
    
    exit sub
end if


'destruir
if ucase$(left$(rdata, 5)) = "/dest" then
    call loggm(userlist(userindex).name, "/dest", false)
    rdata = right$(rdata, len(rdata) - 5)
    call eraseobj(sendtarget.tomap, userindex, userlist(userindex).pos.map, 10000, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
    exit sub
end if

if ucase$(left$(rdata, 8)) = "/nocaos " then
    rdata = right$(rdata, len(rdata) - 8)
    call loggm(userlist(userindex).name, "echo del caos a: " & rdata, false)

    tindex = nameindex(rdata)
    
    if tindex > 0 then
        userlist(tindex).faccion.fuerzascaos = 0
        userlist(tindex).faccion.reenlistadas = 200
        call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas del caos y prohibida la reenlistada" & fonttype_info)
        call senddata(sendtarget.toindex, tindex, 0, "|| " & userlist(userindex).name & " te ha expulsado en forma definitiva de las fuerzas del caos." & fonttype_fight)
    else
        if fileexist(charpath & rdata & ".chr") then
            call writevar(charpath & rdata & ".chr", "facciones", "ejercitocaos", 0)
            call writevar(charpath & rdata & ".chr", "facciones", "reenlistadas", 200)
            call writevar(charpath & rdata & ".chr", "facciones", "extra", "expulsado por " & userlist(userindex).name)
            call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas del caos y prohibida la reenlistada" & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & ".chr inexistente." & fonttype_info)
        end if
    end if
    exit sub
end if

if ucase$(left$(rdata, 8)) = "/noreal " then
    rdata = right$(rdata, len(rdata) - 8)
    call loggm(userlist(userindex).name, "echo de la real a: " & rdata, false)

    rdata = replace(rdata, "\", "")
    rdata = replace(rdata, "/", "")

    tindex = nameindex(rdata)

    if tindex > 0 then
        userlist(tindex).faccion.armadareal = 0
        userlist(tindex).faccion.reenlistadas = 200
        call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas reales y prohibida la reenlistada" & fonttype_info)
        call senddata(sendtarget.toindex, tindex, 0, "|| " & userlist(userindex).name & " te ha expulsado en forma definitiva de las fuerzas reales." & fonttype_fight)
    else
        if fileexist(charpath & rdata & ".chr") then
            call writevar(charpath & rdata & ".chr", "facciones", "ejercitoreal", 0)
            call writevar(charpath & rdata & ".chr", "facciones", "reenlistadas", 200)
            call writevar(charpath & rdata & ".chr", "facciones", "extra", "expulsado por " & userlist(userindex).name)
            call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas reales y prohibida la reenlistada" & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "|| " & rdata & ".chr inexistente." & fonttype_info)
        end if
    end if
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/forcemidi " then
    rdata = right$(rdata, len(rdata) - 11)
    if not isnumeric(rdata) then
        exit sub
    else
        call senddata(sendtarget.toall, 0, 0, "|| " & userlist(userindex).name & " broadcast musica: " & rdata & fonttype_server)
        call senddata(sendtarget.toall, 0, 0, "tm" & rdata)
    end if
end if

if ucase$(left$(rdata, 10)) = "/forcewav " then
    rdata = right$(rdata, len(rdata) - 10)
    if not isnumeric(rdata) then
        exit sub
    else
        call senddata(sendtarget.toall, 0, 0, "tw" & rdata)
    end if
end if


if ucase$(left$(rdata, 12)) = "/borrarpena " then
    '/borrarpena pj pena
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right$(rdata, len(rdata) - 12)
    
    name = readfield(1, rdata, asc("@"))
    tstr = readfield(2, rdata, asc("@"))
    
    if name = "" or tstr = "" or not isnumeric(tstr) then
        call senddata(sendtarget.toindex, userindex, 0, "||utilice /borrarpj nick@numerodepena" & fonttype_info)
        exit sub
    end if
    
    name = replace(name, "\", "")
    name = replace(name, "/", "")
    
    if fileexist(charpath & name & ".chr", vbnormal) then
        rdata = getvar(charpath & name & ".chr", "penas", "p" & val(tstr))
        call writevar(charpath & name & ".chr", "penas", "p" & val(tstr), lcase$(userlist(userindex).name) & ": <pena borrada> " & date & " " & time)
    end if
    
    call loggm(userlist(userindex).name, " borro la pena: " & tstr & "-" & rdata & " de " & name, userlist(userindex).flags.privilegios = playertype.consejero)
    exit sub
end if





'bloquear
if ucase$(left$(rdata, 5)) = "/bloq" then
    call loggm(userlist(userindex).name, "/bloq", false)
    rdata = right$(rdata, len(rdata) - 5)
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 0 then
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 1
        call bloquear(sendtarget.tomap, userindex, userlist(userindex).pos.map, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y, 1)
    else
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).blocked = 0
        call bloquear(sendtarget.tomap, userindex, userlist(userindex).pos.map, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y, 0)
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

'ultima ip de un char
if ucase(left(rdata, 8)) = "/lastip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right(rdata, len(rdata) - 8)
    
    'no se si sea muy necesario, pero por si las dudas... ;)
    rdata = replace(rdata, "\", "")
    rdata = replace(rdata, "/", "")
    
    if fileexist(charpath & rdata & ".chr", vbnormal) then
        call senddata(sendtarget.toindex, userindex, 0, "||la ultima ip de """ & rdata & """ fue : " & getvar(charpath & rdata & ".chr", "init", "lastip") & fonttype_info)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||charfile """ & rdata & """ inexistente." & fonttype_info)
    end if
    exit sub
end if





'cambia el motd
if ucase(rdata) = "/motdcambia" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    tstr = "zmotd"
    for loopc = 1 to maxlines
        tstr = tstr & motd(loopc).texto & vbcrlf
    next loopc
    if right(tstr, 2) = vbcrlf then tstr = left(tstr, len(tstr) - 2)
    call senddata(sendtarget.toindex, userindex, 0, tstr)
    exit sub
end if

if ucase(left(rdata, 5)) = "zmotd" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right(rdata, len(rdata) - 5)
    t = split(rdata, vbcrlf)
    
    maxlines = ubound(t) - lbound(t) + 1
    redim motd(1 to maxlines)
    call writevar(app.path & "\dat\motd.ini", "init", "numlines", cstr(maxlines))
    
    n = lbound(t)
    for loopc = 1 to maxlines
        call writevar(app.path & "\dat\motd.ini", "motd", "line" & loopc, t(n))
        motd(loopc).texto = t(n)
        n = n + 1
    next loopc
    
    exit sub
end if


'quita todos los npcs del area
if ucase$(rdata) = "/limpiar" then
        if userlist(userindex).flags.esrolesmaster then exit sub
        call limpiarmundo
        exit sub
end if

'mensaje del sistema
if ucase$(left$(rdata, 6)) = "/smsg " then
    rdata = right$(rdata, len(rdata) - 6)
    call loggm(userlist(userindex).name, "mensaje de sistema:" & rdata, false)
    call senddata(sendtarget.toall, 0, 0, "!!" & rdata & endc)
    exit sub
end if

'crear criatura, toma directamente el indice
if ucase$(left$(rdata, 5)) = "/acc " then
   rdata = right$(rdata, len(rdata) - 5)
   call loggm(userlist(userindex).name, "sumoneo a " & npclist(val(rdata)).name & " en mapa " & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = playertype.consejero))
   call spawnnpc(val(rdata), userlist(userindex).pos, true, false)
   exit sub
end if

'crear criatura con respawn, toma directamente el indice
if ucase$(left$(rdata, 6)) = "/racc " then
 
   rdata = right$(rdata, len(rdata) - 6)
   call loggm(userlist(userindex).name, "sumoneo con respawn " & npclist(val(rdata)).name & " en mapa " & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = playertype.consejero))
   call spawnnpc(val(rdata), userlist(userindex).pos, true, true)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai1 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial1 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai2 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial2 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai3 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduraimperial3 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ai4 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   tunicamagoimperial = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac1 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos1 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac2 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos2 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac3 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   armaduracaos3 = val(rdata)
   exit sub
end if

if ucase$(left$(rdata, 5)) = "/ac4 " then
    if userlist(userindex).flags.esrolesmaster then exit sub
   rdata = right$(rdata, len(rdata) - 5)
   tunicamagocaos = val(rdata)
   exit sub
end if



'comando para depurar la navegacion
if ucase$(rdata) = "/nave" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    if userlist(userindex).flags.navegando = 1 then
        userlist(userindex).flags.navegando = 0
    else
        userlist(userindex).flags.navegando = 1
    end if
    exit sub
end if

if ucase$(rdata) = "/habilitar" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    if serversologms > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||servidor habilitado para todos" & fonttype_info)
        serversologms = 0
    else
        call senddata(sendtarget.toindex, userindex, 0, "||servidor restringido a administradores." & fonttype_info)
        serversologms = 1
    end if
    exit sub
end if

'apagamos
if ucase$(rdata) = "/apagar" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(sendtarget.toall, userindex, 0, "||" & userlist(userindex).name & " intenta apagar el servidor!!!" & fonttype_fight)
'    if ucase$(userlist(userindex).name) <> "alejolp" then
'        call loggm(userlist(userindex).name, "���intento apagar el server!!!", false)
'        exit sub
'    end if
    'log
    mifile = freefile
    open app.path & "\logs\main.log" for append shared as #mifile
    print #mifile, date & " " & time & " server apagado por " & userlist(userindex).name & ". "
    close #mifile
    unload frmmain
    exit sub
end if

'reiniciamos
'if ucase$(rdata) = "/reiniciar" then
'    call loggm(userlist(userindex).name, rdata, false)
'    if ucase$(userlist(userindex).name) <> "alejolp" then
'        call loggm(userlist(userindex).name, "���intento apagar el server!!!", false)
'        exit sub
'    end if
'    'log
'    mifile = freefile
'    open app.path & "\logs\main.log" for append shared as #mifile
'    print #mifile, date & " " & time & " server reiniciado por " & userlist(userindex).name & ". "
'    close #mifile
'    reiniciarserver = 666
'    exit sub
'end if

'condena
if ucase$(left$(rdata, 7)) = "/conden" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 8)
    tindex = nameindex(rdata)
    if tindex > 0 then call volvercriminal(tindex)
    exit sub
end if

if ucase$(left$(rdata, 7)) = "/rajar " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 7)
    tindex = nameindex(ucase$(rdata))
    if tindex > 0 then
        call resetfacciones(tindex)
    end if
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/rajarclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 11)
    tint = modguilds.m_echarmiembrodeclan(userindex, rdata)  'me da el guildindex
    if tint = 0 then
        call senddata(sendtarget.toindex, userindex, 0, "|| no pertenece a ningun clan o es fundador." & fonttype_info)
    else
        call senddata(sendtarget.toindex, userindex, 0, "|| expulsado." & fonttype_info)
        call senddata(sendtarget.toguildmembers, tint, 0, "|| " & rdata & " ha sido expulsado del clan por los administradores del servidor" & fonttype_guild)
    end if
    exit sub
end if

'lst email
if ucase$(left$(rdata, 11)) = "/lastemail " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 11)
    if fileexist(charpath & rdata & ".chr") then
        tstr = getvar(charpath & rdata & ".chr", "contacto", "email")
        call senddata(sendtarget.toindex, userindex, 0, "||last email de " & rdata & ":" & tstr & fonttype_info)
    end if
exit sub
end if


'altera password
if ucase$(left$(rdata, 7)) = "/apass " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 7)
    tstr = readfield(1, rdata, asc("@"))
    if tstr = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||usar /apass <pjsinpass>@<pjconpass>" & fonttype_info)
        exit sub
    end if
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario a cambiarle el pass (" & tstr & ") esta online, no se puede si esta online" & fonttype_info)
        exit sub
    end if
    arg1 = readfield(2, rdata, asc("@"))
    if arg1 = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||usar /apass <pjsinpass> <pjconpass>" & fonttype_info)
        exit sub
    end if
    if not fileexist(charpath & tstr & ".chr") or not fileexist(charpath & arg1 & ".chr") then
        call senddata(sendtarget.toindex, userindex, 0, "||alguno de los pjs no existe " & tstr & "@" & arg1 & fonttype_info)
    else
        arg2 = getvar(charpath & arg1 & ".chr", "init", "password")
        call writevar(charpath & tstr & ".chr", "init", "password", arg2)
        call senddata(sendtarget.toindex, userindex, 0, "||password de " & tstr & " cambiado a: " & arg2 & fonttype_info)
    end if
exit sub
end if

'altera email
if ucase$(left$(rdata, 8)) = "/aemail " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 8)
    tstr = readfield(1, rdata, asc("-"))
    if tstr = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||usar /aemail <pj>-<nuevomail>" & fonttype_info)
        exit sub
    end if
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el usuario esta online, no se puede si esta online" & fonttype_info)
        exit sub
    end if
    arg1 = readfield(2, rdata, asc("-"))
    if arg1 = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||usar /aemail <pj>-<nuevomail>" & fonttype_info)
        exit sub
    end if
    if not fileexist(charpath & tstr & ".chr") then
        call senddata(sendtarget.toindex, userindex, 0, "||no existe el charfile " & charpath & tstr & ".chr" & fonttype_info)
    else
        call writevar(charpath & tstr & ".chr", "contacto", "email", arg1)
        call senddata(sendtarget.toindex, userindex, 0, "||email de " & tstr & " cambiado a: " & arg1 & fonttype_info)
    end if
exit sub
end if


if ucase$(left$(rdata, 7)) = "/aname " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 7)
    tstr = readfield(1, rdata, asc("@"))
    arg1 = readfield(2, rdata, asc("@"))
    
    
    if tstr = "" or arg1 = "" then
        call senddata(sendtarget.toindex, userindex, 0, "||usar: /aname origen@destino" & fonttype_info)
        exit sub
    end if
    
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||el pj esta online, debe salir para el cambio" & fonttype_warning)
        exit sub
    end if
    
    if fileexist(charpath & ucase(tstr) & ".chr") = false then
        call senddata(sendtarget.toindex, userindex, 0, "||el pj " & tstr & " es inexistente " & fonttype_info)
        exit sub
    end if
    
    arg2 = getvar(charpath & ucase(tstr) & ".chr", "guild", "guildindex")
    if isnumeric(arg2) then
        if cint(arg2) > 0 then
            call senddata(sendtarget.toindex, userindex, 0, "||el pj " & tstr & " pertenece a un clan, debe salir del mismo con /salirclan para ser transferido. " & fonttype_info)
            exit sub
        end if
    end if
    
    if fileexist(charpath & ucase(arg1) & ".chr") = false then
        filecopy charpath & ucase(tstr) & ".chr", charpath & ucase(arg1) & ".chr"
        call senddata(sendtarget.toindex, userindex, 0, "||transferencia exitosa" & fonttype_info)
        call writevar(charpath & tstr & ".chr", "flags", "ban", "1")
        'ponemos la pena
        tint = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
        call writevar(charpath & tstr & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban por cambio de nick a " & ucase$(arg1) & " " & date & " " & time)
    else
        call senddata(sendtarget.toindex, userindex, 0, "||el nick solicitado ya existe" & fonttype_info)
        exit sub
    end if
    exit sub
end if

if ucase$(rdata) = "/centinelaactivado" then
    centinelaactivado = not centinelaactivado
    
    centinela.revisandouserindex = 0
    centinela.clave = 0
    centinela.tiemporestante = 0
    
    if centinelanpcindex then
        call quitarnpc(centinelanpcindex)
        centinelanpcindex = 0
    end if
    
    if centinelaactivado then
        call senddata(sendtarget.toadmins, 0, 0, "el centinela ha sido activado.")
    else
        call senddata(sendtarget.toadmins, 0, 0, "el centinela ha sido desactivado.")
    end if
end if

if ucase$(left$(rdata, 9)) = "/dobackup" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call dobackup
    exit sub
end if
if ucase$(left$(rdata, 10)) = "/showcmsg " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 10)
    call modguilds.gmescuchaclan(userindex, rdata)
    exit sub
end if
if ucase$(left$(rdata, 11)) = "/guardamapa" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call grabarmapa(userlist(userindex).pos.map, app.path & "\worldbackup\mapa" & userlist(userindex).pos.map)
    exit sub
end if

if ucase$(left$(rdata, 12)) = "/modmapinfo " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right(rdata, len(rdata) - 12)
    select case ucase(readfield(1, rdata, 32))
    case "pk"
        tstr = readfield(2, rdata, 32)
        if tstr <> "" then
            mapinfo(userlist(userindex).pos.map).pk = iif(tstr = "0", true, false)
            call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "pk", tstr)
        end if
        call senddata(sendtarget.toindex, userindex, 0, "||mapa " & userlist(userindex).pos.map & " pk: " & mapinfo(userlist(userindex).pos.map).pk & fonttype_info)
    case "backup"
        tstr = readfield(2, rdata, 32)
        if tstr <> "" then
            mapinfo(userlist(userindex).pos.map).backup = cbyte(tstr)
            call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "backup", tstr)
        end if
        
        call senddata(sendtarget.toindex, userindex, 0, "||mapa " & userlist(userindex).pos.map & " backup: " & mapinfo(userlist(userindex).pos.map).backup & fonttype_info)
    end select
    exit sub
end if

if ucase$(left$(rdata, 7)) = "/grabar" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call mdparty.actualizaexperiencias
    call guardarusuarios
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/borrar sos" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call ayuda.reset
    exit sub
end if

if ucase$(left$(rdata, 9)) = "/show int" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call frmmain.mnumostrar_click
    exit sub
end if


if ucase$(rdata) = "/noche" then
    if (userlist(userindex).name <> "el oso" or ucase$(userlist(userindex).name) <> "maraxus") then exit sub
    denoche = not denoche
    for loopc = 1 to numusers
        if userlist(userindex).flags.userlogged and userlist(userindex).connid > -1 then
            call enviarnoche(loopc)
        end if
    next loopc
    exit sub
end if

'if ucase$(rdata) = "/passday" then
'    if userlist(userindex).flags.esrolesmaster then exit sub
'    call loggm(userlist(userindex).name, rdata, false)
'    'clanesviejo clanesnuevo
'    'call dayelapsed
'    exit sub
'end if

if ucase$(rdata) = "/echartodospjs" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call echarpjsnoprivilegiados
    exit sub
end if



if ucase$(rdata) = "/tcpesstats" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(sendtarget.toindex, userindex, 0, "||los datos estan en bytes." & fonttype_info)
    with tcpesstats
        call senddata(sendtarget.toindex, userindex, 0, "||in/s: " & .bytesrecibidosxseg & " out/s: " & .bytesenviadosxseg & fonttype_info)
        call senddata(sendtarget.toindex, userindex, 0, "||in/s max: " & .bytesrecibidosxsegmax & " -> " & .bytesrecibidosxsegcuando & fonttype_info)
        call senddata(sendtarget.toindex, userindex, 0, "||out/s max: " & .bytesenviadosxsegmax & " -> " & .bytesenviadosxsegcuando & fonttype_info)
    end with
    tstr = ""
    tlong = 0
    for loopc = 1 to lastuser
        if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
            if userlist(loopc).colasalida.count > 0 then
                tstr = tstr & userlist(loopc).name & " (" & userlist(loopc).colasalida.count & "), "
                tlong = tlong + 1
            end if
        end if
    next loopc
    call senddata(sendtarget.toindex, userindex, 0, "||posibles pjs trabados: " & tlong & fonttype_info)
    call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_info)
    exit sub
end if

if ucase$(rdata) = "/reloadnpcs" then

    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)

    call descarganpcsdat
    call carganpcsdat

    call senddata(sendtarget.toindex, userindex, 0, "|| npcs.dat y npcshostiles.dat recargados." & fonttype_info)
    exit sub
end if

if ucase$(rdata) = "/reloadsini" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call loadsini
    exit sub
end if

if ucase$(rdata) = "/reloadhechizos" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call cargarhechizos
    exit sub
end if

if ucase$(rdata) = "/reloadobj" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call loadobjdata
    exit sub
end if

if ucase$(rdata) = "/reiniciar" then
    if userlist(userindex).name <> "el oso" or ucase$(userlist(userindex).name) <> "maraxus" then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call reiniciarservidor(true)
    exit sub
end if

if ucase$(rdata) = "/autoupdate" then
    if userlist(userindex).name <> "el oso" or ucase$(userlist(userindex).name) <> "maraxus" then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(sendtarget.toindex, userindex, 0, "|| tid: " & cstr(reiniciarautoupdate()) & fonttype_info)
    exit sub
end if

#if seguridadalkon then
    handledatadiosex userindex, rdata
#end if

exit sub

errorhandler:
 call logerror("handledata. cadori:" & cadenaoriginal & " nom:" & userlist(userindex).name & "ui:" & userindex & " n: " & err.number & " d: " & err.description)
 'resume
 'call closesocket(userindex)
 call cerrar_usuario(userindex)
 
 

end sub

sub reloadsokcet()
on error goto errhandler
#if usarquesocket = 1 then

    call logapisock("reloadsokcet() " & numusers & " " & lastuser & " " & maxusers)
    
    if numusers <= 0 then
        call wsapireiniciarsockets
    else
'       call apiclosesocket(socklisten)
'       socklisten = listenforconnect(puerto, hwndmsg, "")
    end if

#elseif usarquesocket = 0 then

    frmmain.socket1.cleanup
    call configlisteningsocket(frmmain.socket1, puerto)
    
#elseif usarquesocket = 2 then

    

#end if

exit sub
errhandler:
    call logerror("error en checksocketstate " & err.number & ": " & err.description)

end sub

public sub enviarnoche(byval userindex as integer)

call senddata(sendtarget.toindex, userindex, 0, "noc" & iif(denoche and (mapinfo(userlist(userindex).pos.map).zona = campo or mapinfo(userlist(userindex).pos.map).zona = ciudad), "1", "0"))
call senddata(sendtarget.toindex, userindex, 0, "noc" & iif(denoche, "1", "0"))

end sub

public sub echarpjsnoprivilegiados()
dim loopc as long

for loopc = 1 to lastuser
    if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
        if userlist(loopc).flags.privilegios < playertype.consejero then
            call closesocket(loopc)
        end if
    end if
next loopc

end sub

