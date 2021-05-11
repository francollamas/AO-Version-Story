attribute vb_name = "tcp"
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
public const toadminsareabutconsejeros = 12

public const toconsejo = 14
public const toclanarea = 15
public const toconsejocaos = 16
public const torolesmasters = 17
public const todeadarea = 18


#if usarquesocket = 0 then
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

gencrc = 1


end function

sub darcuerpoycabeza(userbody as integer, userhead as integer, raza as string, gen as string)

select case gen
   case "hombre"
        select case raza
                case "humano"
                    userhead = cint(randomnumber(1, 30))
                    if userhead > 30 then userhead = 22
                    userbody = 1
                case "elfo"
                    userhead = cint(randomnumber(1, 12)) + 100
                    if userhead > 112 then userhead = 104
                    userbody = 2
                case "elfo oscuro"
                    userhead = cint(randomnumber(1, 9)) + 200
                    if userhead > 209 then userhead = 203
                    userbody = 3
                case "enano"
                    userhead = randomnumber(1, 5) + 300
                    if userhead > 305 then userhead = 304
                    userbody = 52
                case "gnomo"
                    userhead = randomnumber(1, 6) + 400
                    if userhead > 406 then userhead = 404
                    userbody = 52
                case else
                    userhead = 1
                    userbody = 1
        end select
   case "mujer"
        select case raza
                case "humano"
                    userhead = cint(randomnumber(1, 7)) + 69
                    if userhead > 76 then userhead = 74
                    userbody = 1
                case "elfo"
                    userhead = cint(randomnumber(1, 7)) + 166
                    if userhead > 177 then userhead = 172
                    userbody = 2
                case "elfo oscuro"
                    userhead = cint(randomnumber(1, 11)) + 269
                    if userhead > 280 then userhead = 275
                    userbody = 3
                case "gnomo"
                    userhead = randomnumber(1, 5) + 469
                    if userhead > 474 then userhead = 472
                    userbody = 52
                case "enano"
                    userhead = randomnumber(1, 3) + 369
                    if userhead > 372 then userhead = 372
                    userbody = 52
                case else
                    userhead = 70
                    userbody = 1
        end select

        
        'select case raza
                
        '        case "humano"
        '            userhead = cint(randomnumber(1, 5)) + 69
        '            if userhead > 74 then userhead = 74
        '            userbody = 1
        '        case "elfo"
        '            userhead = cint(randomnumber(1, 3)) + 169
        '            if userhead > 172 then userhead = 172
        '            userbody = 2
        '        case "elfo oscuro"
        '            userhead = cint(randomnumber(1, 6)) + 269
        '            if userhead > 275 then userhead = 275
        '            userbody = 3
        '        case "gnomo"
        '            userhead = randomnumber(1, 3) + 469
        '            if userhead > 472 then userhead = 472
        '            userbody = 52
        '        case "enano"
        '            userhead = 370
        '            userbody = 52
        '        case else
        '            userhead = 70
        '            userbody = 1
        'end select
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
    if userlist(userindex).stats.useratributos(loopc) > 18 or userlist(userindex).stats.useratributos(loopc) < 1 then
        validateatrib = false
        exit function
    end if
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

'barrin 3/3/03
'agregu� padrinoname y padrino password como opcionales, que se les da un valor siempre y cuando el servidor est� usando el sistema
sub connectnewuser(userindex as integer, name as string, password as string, body as integer, head as integer, userraza as string, usersexo as string, userclase as string, _
ua1 as string, ua2 as string, ua3 as string, ua4 as string, ua5 as string, _
us1 as string, us2 as string, us3 as string, us4 as string, us5 as string, _
us6 as string, us7 as string, us8 as string, us9 as string, us10 as string, _
us11 as string, us12 as string, us13 as string, us14 as string, us15 as string, _
us16 as string, us17 as string, us18 as string, us19 as string, us20 as string, _
us21 as string, useremail as string, hogar as string, optional padrinoname as string, optional padrinopassword as string)

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

'barrin 29/9/03
'ahora para poder crear un personaje se necesita un padrino, o sea una referencia de un personaje ya creado
'siempre que se haya definido eso
if usandosistemapadrinos = 1 then
                                        
    if fileexist(charpath & ucase$(padrinoname) & ".chr", vbnormal) = false then
        call senddata(toindex, userindex, 0, "errel personaje padrino no existe.")
        exit sub
    end if

    if ucase$(padrinopassword) <> ucase$(getvar(charpath & ucase$(padrinoname) & ".chr", "init", "password")) then
        call senddata(toindex, userindex, 0, "errpassword del padrino incorrecto.")
        exit sub
    end if

    if bancheck(padrinoname) then
        call senddata(toindex, userindex, 0, "errel personaje a padrinar se encuentra baneado.")
        exit sub
    end if

    if ucase$(getvar(charpath & ucase$(padrinoname) & ".chr", "stats", "elv")) < 20 then
        call senddata(toindex, userindex, 0, "errel personaje a padrinar debe ser nivel 20 o mayor.")
        exit sub
    end if
    
    dim padrinos as integer
    padrinos = val(getvar(charpath & ucase$(padrinoname) & ".chr", "contacto", "apadrinados"))
        
    if padrinos >= cantidadporpadrino then
        call senddata(toindex, userindex, 0, "errel personaje a padrinar ya ha llegado al l�mite de apadrinamiento.")
        exit sub
    end if
    
    call writevar(charpath & ucase$(padrinoname) & ".chr", "contacto", "apadrinados", str(padrinos + 1))
    
end if

'[barrin]

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

''''''''userlist(userindex).stats.useratributos(fuerza) = abs(cint(ua1))
''''''''userlist(userindex).stats.useratributos(inteligencia) = abs(cint(ua2))
''''''''userlist(userindex).stats.useratributos(agilidad) = abs(cint(ua3))
''''''''userlist(userindex).stats.useratributos(carisma) = abs(cint(ua4))
''''''''userlist(userindex).stats.useratributos(constitucion) = abs(cint(ua5))


'%%%%%%%%%%%%% prevenir hackeo de los atributos %%%%%%%%%%%%%
if not validateatrib(userindex) then
        call senddata(toindex, userindex, 0, "erratributos invalidos.")
        exit sub
end if
'%%%%%%%%%%%%% prevenir hackeo de los atributos %%%%%%%%%%%%%

select case ucase$(userraza)
    case "humano"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 1
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 1
        userlist(userindex).stats.useratributos(constitucion) = userlist(userindex).stats.useratributos(constitucion) + 2
    case "elfo"
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 4
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 2
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) + 2
    case "elfo oscuro"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 2
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 2
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 2
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) - 3
    case "enano"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) + 3
        userlist(userindex).stats.useratributos(constitucion) = userlist(userindex).stats.useratributos(constitucion) + 3
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) - 6
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) - 1
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) - 2
    case "gnomo"
        userlist(userindex).stats.useratributos(fuerza) = userlist(userindex).stats.useratributos(fuerza) - 4
        userlist(userindex).stats.useratributos(inteligencia) = userlist(userindex).stats.useratributos(inteligencia) + 3
        userlist(userindex).stats.useratributos(agilidad) = userlist(userindex).stats.useratributos(agilidad) + 3
        userlist(userindex).stats.useratributos(carisma) = userlist(userindex).stats.useratributos(carisma) + 1
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

#if usarquesocket = 1 or usarquesocket = 2 then

sub closesocket(byval userindex as integer, optional byval cerrarlo as boolean = true)
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

dim loopc as integer

'call logtarea("close socket")

'#if usarquesocket = 0 or usarquesocket = 2 then
on error goto errhandler
'#end if
    
    if userindex = lastuser then
        do until userlist(lastuser).flags.userlogged
            lastuser = lastuser - 1
            if lastuser < 1 then exit do
        loop
    end if
    
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    call ados.restarconexion(userlist(userindex).ip)
    

    if userlist(userindex).connid <> -1 then
        call closesocketsl(userindex)
    end if
    
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    if userlist(userindex).flags.userlogged then
            if numusers > 0 then numusers = numusers - 1
            call closeuser(userindex)
            
            call estadisticasweb.informar(cantidad_online, numusers)
    else
            call resetuserslot(userindex)
    end if
    
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

'    #if usarquesocket = 1 then
'
'    if userlist(userindex).connid <> -1 then
'        call closesocketsl(userindex)
'    end if
'
'    #elseif usarquesocket = 0 then
'
'    'frmmain.socket2(userindex).d i s c o n n e c t   no usar
'    frmmain.socket2(userindex).cleanup
'    unload frmmain.socket2(userindex)
'
'    #elseif usarquesocket = 2 then
'
'    if userlist(userindex).connid <> -1 then
'        call closesocketsl(userindex)
'    end if
'
'    #end if

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
    
    userlist(userindex).connid = -1
    userlist(userindex).connidvalida = false
    userlist(userindex).numeropaquetespormilisec = 0
            
exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).connidvalida = false
    userlist(userindex).numeropaquetespormilisec = 0
'    unload frmmain.socket2(userindex) ojooooooooooooooooo
'    if numusers > 0 then numusers = numusers - 1
    call resetuserslot(userindex)
    
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    #if usarquesocket = 1 then
    if userlist(userindex).connid <> -1 then
        call closesocketsl(userindex)
'        call apiclosesocket(userlist(userindex).connid)
    end if
    #end if
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
    
end sub

#elseif usarquesocket = 0 then

sub closesocket(byval userindex as integer)
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

'call logtarea("close socket")

on error goto errhandler

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>


    call ados.restarconexion(frmmain.socket2(userindex).peeraddress)

    userlist(userindex).connid = -1
'    gameinputmaparray(userindex) = -1
    userlist(userindex).numeropaquetespormilisec = 0

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    if userindex = lastuser and lastuser > 1 then
        do until userlist(lastuser).flags.userlogged
            lastuser = lastuser - 1
            if lastuser <= 1 then exit do
        loop
    end if

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    if userlist(userindex).flags.userlogged then
            if numusers <> 0 then numusers = numusers - 1
            call closeuser(userindex)
    end if

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

    frmmain.socket2(userindex).cleanup
'    frmmain.socket2(userindex).di    s  c o       n nect
    unload frmmain.socket2(userindex)
    call resetuserslot(userindex)


'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

exit sub

errhandler:
    userlist(userindex).connid = -1
'    gameinputmaparray(userindex) = -1
    userlist(userindex).numeropaquetespormilisec = 0
'    unload frmmain.socket2(userindex) ojooooooooooooooooo
'    if numusers > 0 then numusers = numusers - 1
    call resetuserslot(userindex)

'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>

end sub







#elseif usarquesocket = 3 then

sub closesocket(byval userindex as integer, optional byval cerrarlo as boolean = true)

on error goto errhandler

dim nurestados as boolean
dim connectionid as long


    nurestados = false
    connectionid = userlist(userindex).connid
    
    'call logindex(userindex, "******> sub closesocket. connid: " & connectionid & " cerrarlo: " & cerrarlo)
    
    call ados.restarconexion(userlist(userindex).ip)
    
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
debug.print "closesocketsl"

#if usarquesocket = 1 then

if userlist(userindex).connid <> -1 and userlist(userindex).connidvalida then
    call borraslotsock(userlist(userindex).connid)
'    call wsaasyncselect(userlist(userindex).connid, hwndmsg, byval 1025, byval (fd_close))
'    call apiclosesocket(userlist(userindex).connid)
    call wsapiclosesocket(userlist(userindex).connid)
    userlist(userindex).connidvalida = false
end if

#elseif usarquesocket = 0 then

if userlist(userindex).connid <> -1 and userlist(userindex).connidvalida then
    'frmmain.socket2(userindex).disconnect
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

'sub closesocket_nueva(byval userindex as integer)
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'
''call logtarea("close socket")
'
'on error goto errhandler
'
'
'
'    call ados.restarconexion(frmmain.socket2(userindex).peeraddress)
'
'    'userlist(userindex).connid = -1
'    'userlist(userindex).numeropaquetespormilisec = 0
'
'    if userlist(userindex).flags.userlogged then
'        if numusers <> 0 then numusers = numusers - 1
'        call closeuser(userindex)
'        userlist(userindex).connid = -1: userlist(userindex).numeropaquetespormilisec = 0
'        frmmain.socket2(userindex).disconnect
'        frmmain.socket2(userindex).cleanup
'        'unload frmmain.socket2(userindex)
'        call resetuserslot(userindex)
'        'call cerrar_usuario(userindex)
'    else
'        userlist(userindex).connid = -1
'        userlist(userindex).numeropaquetespormilisec = 0
'
'        frmmain.socket2(userindex).disconnect
'        frmmain.socket2(userindex).cleanup
'        call resetuserslot(userindex)
'        'unload frmmain.socket2(userindex)
'    end if
'
'exit sub
'
'errhandler:
'    userlist(userindex).connid = -1
'    userlist(userindex).numeropaquetespormilisec = 0
''    unload frmmain.socket2(userindex) ojooooooooooooooooo
''    if numusers > 0 then numusers = numusers - 1
'    call resetuserslot(userindex)
'
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
''<<<<<<<<<<<<<<<<<< no tocar >>>>>>>>>>>>>>>>>>>>>>
'
'end sub

public function enviardatosaslot(byval userindex as integer, datos as string) as long
'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)

'tcpesstats.bytesenviados = tcpesstats.bytesenviados + len(datos)

#if usarquesocket = 1 then '**********************************************
on error goto err

dim ret as long

if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: inicio. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida)

ret = wsapienviar(userindex, datos)

if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: inicio. acabo de enviar userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida & " ret=" & ret)

if ret <> 0 and ret <> wsaewouldblock then
    if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: entro a manejo de error. <> wsaewouldblock, <>0. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida)
    call closesocketsl(userindex)
    if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: luego de closesocket. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida)
    call cerrar_usuario(userindex)
    if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: luego de cerrar_usuario. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida)
end if
enviardatosaslot = ret
exit function

err:
    if frmmain.superlog.value = 1 then logcustom ("enviardatosaslot:: err handler. userindex=" & userindex & " datos=" & datos & " ul?/cid/cidv?=" & userlist(userindex).flags.userlogged & "/" & userlist(userindex).connid & "/" & userlist(userindex).connidvalida & " err: " & err.description)

#elseif usarquesocket = 0 then '**********************************************

dim encolar as boolean
encolar = false

enviardatosaslot = 0

'dim fr as integer
'fr = freefile
'open "c:\log.txt" for append as #fr
'print #fr, datos
'close #fr
'call frmmain.socket2(userindex).write(datos, len(datos))

'if frmmain.socket2(userindex).iswritable and userlist(userindex).sockpuedoenviar then
if userlist(userindex).colasalida.count <= 0 then
    if frmmain.socket2(userindex).write(datos, len(datos)) < 0 then
        if frmmain.socket2(userindex).lasterror = wsaewouldblock then
            userlist(userindex).sockpuedoenviar = false
            encolar = true
        else
            call cerrar_usuario(userindex)
        end if
'    else
'        debug.print userindex & ": " & datos
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
    rv = frmmain.tcpserv.enviar(userlist(userindex).connid, datos, len(datos))
    'if instr(1, datos, "val", vbtextcompare) > 0 or instr(1, datos, "log", vbtextcompare) > 0 or instr(1, datos, "fino", vbtextcompare) > 0 or instr(1, datos, "err", vbtextcompare) > 0 then
        'call logindex(userindex, "senddata. connid: " & userlist(userindex).connid & " datos: " & datos)
    'end if
    select case rv
        'case 1  'error critico, se viene el on_close
        case 2  'socket invalido.
            'intentemos cerrarlo?
            call closesocket(userindex, true)
        'case 3  'wsaewouldblock. solo si encolar=false en el control
            'aca hariamos manejo de encoladas, pero el server se encarga solo :d
    end select

exit function
errorhandler:
    call logerror("tcp::enviardatosaslot. ui/connid/datos: " & userindex & "/" & userlist(userindex).connid & "/" & datos)
#end if '**********************************************

end function

sub senddata(byval sndroute as byte, byval sndindex as integer, byval sndmap as integer, byval snddata as string)

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
            if userlist(loopc).connid <> -1 then
'               if esdios(userlist(loopc).name) or essemidios(userlist(loopc).name) then
                if userlist(loopc).flags.privilegios > 0 then
                    call enviardatosaslot(loopc, snddata)
               end if
            end if
        next loopc
        exit sub
        
    case toall
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                    #if usarapi then
'                    call wsapienviar(loopc, snddata)
'                    #else
'                    frmmain.socket2(loopc).write snddata, len(snddata)
'                    #end if
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case toallbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and (loopc <> sndindex) then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                    #if usarapi then
'                    call wsapienviar(loopc, snddata)
'                    #else
'                    frmmain.socket2(loopc).write snddata, len(snddata)
'                    #end if
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case tomap
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.userlogged then
                    if userlist(loopc).pos.map = sndmap then
                        'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                        'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            end if
        next loopc
        exit sub
      
    case tomapbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and loopc <> sndindex then
                if userlist(loopc).pos.map = sndmap then
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
            
    case toguildmembers
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(sndindex).guildinfo.guildname = userlist(loopc).guildinfo.guildname then
                        'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                        call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    
    case topcarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub


    case todeadarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                        if userlist(mapdata(sndmap, x, y).userindex).flags.muerto = 1 or userlist(mapdata(sndmap, x, y).userindex).flags.privilegios >= 1 then
                           if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                                'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                                'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
    '                            #if usarapi then
    '                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
    '                            #else
    '                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
    '                            #end if
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                           end if
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
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub
       
    case toclanarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if (mapdata(sndmap, x, y).userindex > 0) then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            if (userlist(mapdata(sndmap, x, y).userindex).guildinfo.guildname = userlist(sndindex).guildinfo.guildname) then
                                call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                            end if
                       end if
                    end if
               end if
            next x
        next y
        exit sub



    '[cdt 17-02-2004]
    case toadminsareabutconsejeros
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

    case tonpcarea
        for y = npclist(sndindex).pos.y - minyborder + 1 to npclist(sndindex).pos.y + minyborder - 1
            for x = npclist(sndindex).pos.x - minxborder + 1 to npclist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, snddata)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case toindex
        if userlist(sndindex).connid <> -1 then
             'call addtovar(userlist(sndindex).bytestransmitidossvr, lenb(snddata), 100000)
             'frmmain.socket2(sndindex).write snddata, len(snddata)
'             #if usarapi then
'             call wsapienviar(sndindex, snddata)
'             #else
'             frmmain.socket2(sndindex).write snddata, len(snddata)
'             #end if
            call enviardatosaslot(sndindex, snddata)
             exit sub
        end if
    case toconsejo
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.pertalcons > 0 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    case toconsejocaos
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.pertalconscaos > 0 then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    case torolesmasters
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.esrolesmaster then
                    call enviardatosaslot(loopc, snddata)
                end if
            end if
        next loopc
        exit sub
    end select

end sub

sub sendcrypteddata(byval sndroute as byte, byval sndindex as integer, byval sndmap as integer, byval snddata as string)
'no puse un optional parameter en senddata porque no estoy seguro
'como afecta la performance un parametro opcional
'prefiero 1k mas de exe que arriesgar performance
on error resume next

dim loopc as integer
dim x as integer
dim y as integer
dim aux$
dim dec$
dim nfile as integer
dim ret as long


select case sndroute


    case tonone
        exit sub
        
    case toadmins
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
'               if esdios(userlist(loopc).name) or essemidios(userlist(loopc).name) then
                if userlist(loopc).flags.privilegios > 0 then
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
               end if
            end if
        next loopc
        exit sub
        
    case toall
        for loopc = 1 to lastuser
            if userlist(loopc).connid <> -1 then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                    #if usarapi then
'                    call wsapienviar(loopc, snddata)
'                    #else
'                    frmmain.socket2(loopc).write snddata, len(snddata)
'                    #end if
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case toallbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and (loopc <> sndindex) then
                if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                    #if usarapi then
'                    call wsapienviar(loopc, snddata)
'                    #else
'                    frmmain.socket2(loopc).write snddata, len(snddata)
'                    #end if
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case tomap
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(loopc).flags.userlogged then
                    if userlist(loopc).pos.map = sndmap then
                        'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                        'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                        call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                    end if
                end if
            end if
        next loopc
        exit sub
      
    case tomapbutindex
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) and loopc <> sndindex then
                if userlist(loopc).pos.map = sndmap then
                    'call addtovar(userlist(loopc).bytestransmitidossvr, lenb(snddata), 100000)
                    'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                    call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
            
    case toguildmembers
        for loopc = 1 to lastuser
            if (userlist(loopc).connid <> -1) then
                if userlist(sndindex).guildinfo.guildname = userlist(loopc).guildinfo.guildname then
                        'frmmain.socket2(loopc).write snddata, len(snddata)
'                        #if usarapi then
'                        call wsapienviar(loopc, snddata)
'                        #else
'                        frmmain.socket2(loopc).write snddata, len(snddata)
'                        #end if
                        call enviardatosaslot(loopc, protocrypt(snddata, loopc) & endc)
                end if
            end if
        next loopc
        exit sub
    
    case topcarea
        for y = userlist(sndindex).pos.y - minyborder + 1 to userlist(sndindex).pos.y + minyborder - 1
            for x = userlist(sndindex).pos.x - minxborder + 1 to userlist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
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
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    '[cdt 17-02-2004]
    case toadminsareabutconsejeros
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

    case tonpcarea
        for y = npclist(sndindex).pos.y - minyborder + 1 to npclist(sndindex).pos.y + minyborder - 1
            for x = npclist(sndindex).pos.x - minxborder + 1 to npclist(sndindex).pos.x + minxborder - 1
               if inmapbounds(sndmap, x, y) then
                    if mapdata(sndmap, x, y).userindex > 0 then
                       if userlist(mapdata(sndmap, x, y).userindex).connid <> -1 then
                            'call addtovar(userlist(mapdata(sndmap, x, y).userindex).bytestransmitidossvr, lenb(snddata), 100000)
                            'frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #if usarapi then
'                            call wsapienviar(mapdata(sndmap, x, y).userindex, snddata)
'                            #else
'                            frmmain.socket2(mapdata(sndmap, x, y).userindex).write snddata, len(snddata)
'                            #end if
                            call enviardatosaslot(mapdata(sndmap, x, y).userindex, protocrypt(snddata, mapdata(sndmap, x, y).userindex) & endc)
                       end if
                    end if
               end if
            next x
        next y
        exit sub

    case toindex
        if userlist(sndindex).connid <> -1 then
             'call addtovar(userlist(sndindex).bytestransmitidossvr, lenb(snddata), 100000)
             'frmmain.socket2(sndindex).write snddata, len(snddata)
'             #if usarapi then
'             call wsapienviar(sndindex, snddata)
'             #else
'             frmmain.socket2(sndindex).write snddata, len(snddata)
'             #end if
             call enviardatosaslot(sndindex, protocrypt(snddata, sndindex) & endc)
             exit sub
        end if
    exit sub
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

'�ya esta conectado el personaje?
if checkforsamename(userindex, name) = true then
    if userlist(nameindex(name)).counters.saliendo then
        call senddata(toindex, userindex, 0, "errel usuario est� saliendo.")
    else
        call senddata(toindex, userindex, 0, "errperdon, un usuario con el mismo nombre se h� logoeado.")
    end if
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


if userlist(userindex).flags.paralizado then
    if encriptarprotocoloscriticos then
        call sendcrypteddata(toindex, userindex, 0, "paradok")
    else
        call senddata(toindex, userindex, 0, "paradok")
    end if
end if

'feo, esto tiene que ser parche cliente
if userlist(userindex).flags.estupidez = 0 then call senddata(toindex, userindex, 0, "nestup")
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
                call senddata(toindex, userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).comusu.destusu, 0, "||comercio cancelado. el otro usuario se ha desconectado." & fonttype_talk)
            end if
            if userlist(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex).flags.userlogged then
                call fincomerciarusu(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex)
                call senddata(toindex, mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex, 0, "erralguien se ha conectado donde te encontrabas, por favor recon�ctate...")
            end if
        end if
        call closesocket(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex)
    end if
   
   
    if userlist(userindex).flags.muerto = 1 then
        call empollando(userindex)
    end if
end if

if not mapavalido(userlist(userindex).pos.map) then
    call senddata(toindex, userindex, 0, "errel pj se encuenta en un mapa invalido.")
    call closesocket(userindex)
    exit sub
end if

'nombre de sistema
userlist(userindex).name = name

userlist(userindex).password = password
'userlist(userindex).ip = frmmain.socket2(userindex).peeraddress
  
'info
call senddata(toindex, userindex, 0, "iu" & userindex) 'enviamos el user index
call senddata(toindex, userindex, 0, "cm" & userlist(userindex).pos.map & "," & mapinfo(userlist(userindex).pos.map).mapversion) 'carga el mapa
call senddata(toindex, userindex, 0, "tm" & mapinfo(userlist(userindex).pos.map).music)


''[el oso]: traigo esto aca arriba para darle el ip!
set userlist(userindex).guildref = fetchguild(userlist(userindex).guildinfo.guildname)
userlist(userindex).counters.idlecount = 0
'crea  el personaje del usuario
call makeuserchar(tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
call senddata(toindex, userindex, 0, "ip" & userlist(userindex).char.charindex)
''[/el oso]

call updateusermap(userindex)
call senduserstatsbox(userindex)
call enviarhambreysed(userindex)

call sendmotd(userindex)

if haciendobk then
    call senddata(toindex, userindex, 0, "bkw")
    call senddata(toindex, userindex, 0, "||servidor> por favor espera algunos segundos, worldsave esta ejecutandose." & fonttype_server)
end if

if enpausa then
    call senddata(toindex, userindex, 0, "bkw")
    call senddata(toindex, userindex, 0, "||servidor> lo sentimos mucho pero el servidor se encuentra actualmente detenido. intenta ingresar m�s tarde." & fonttype_server)
end if

if entesting and userlist(userindex).stats.elv >= 18 then
    call senddata(toindex, userindex, 0, "errservidor en testing por unos minutos, conectese con pjs de nivel menor a 18. no se conecte con pjs que puedan resultar importantes por ahora pues pueden arruinarse.")
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
    call senddata(toall, 0, 0, "||record de usuarios conectados simultaniamente." & "hay " & numusers & " usuarios." & fonttype_info)
    recordusuarios = numusers
    call writevar(inipath & "server.ini", "init", "record", str(recordusuarios))
    
    call estadisticasweb.informar(record_usuarios, recordusuarios)
end if

userlist(userindex).flags.esrolesmaster = esrolesmaster(name)
if esadmin(name) then
    userlist(userindex).flags.privilegios = 4
    call loggm(userlist(userindex).name, "se conecto con ip:" & userlist(userindex).ip, false)
elseif esdios(name) then
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

if criminal(userindex) then
    'call senddata(toindex, userindex, 0, "||miembro de las fuerzas del caos > seguro desactivado <" & fonttype_fight)
    call senddata(toindex, userindex, 0, "segoff")
    userlist(userindex).flags.seguro = false
else
    userlist(userindex).flags.seguro = true
    call senddata(toindex, userindex, 0, "segon")
end if

if serversologms > 0 then
    if userlist(userindex).flags.privilegios < serversologms then
        call senddata(toindex, userindex, 0, "errservidor restringido a administradores de jerarquia mayor o igual a: " & serversologms & ". por favor intente en unos momentos.")
        call closesocket(userindex)
        exit sub
    end if
end if

call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxwarp & "," & 0)

call senddata(toindex, userindex, 0, "logged")


call sendguildnews(userindex)

if userlist(userindex).flags.noactualizado then
    call senddata(toindex, userindex, 0, "reau")
end if


if lloviendo then call senddata(toindex, userindex, 0, "llu")

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
userlist(userindex).faccion.reenlistadas = 0
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

userlist(userindex).counters.timerlanzarspell = 0
userlist(userindex).counters.timerpuedeatacar = 0
userlist(userindex).counters.timerpuedetrabajar = 0
userlist(userindex).counters.timerusar = 0

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
userlist(userindex).descrm = ""
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

'barrin 3/03/03
userlist(userindex).apadrinados = 0

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
userlist(userindex).stats.fit = 0

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
userlist(userindex).stats.skillpts = 0
userlist(userindex).flags.oldbody = 0
userlist(userindex).flags.oldhead = 0
userlist(userindex).flags.admininvisible = 0
userlist(userindex).flags.valcode = 0
userlist(userindex).flags.hechizo = 0

userlist(userindex).flags.timeswalk = 0
userlist(userindex).flags.startwalk = 0
userlist(userindex).flags.countsh = 0
userlist(userindex).flags.trabajando = false


userlist(userindex).empocont = 0
userlist(userindex).flags.estaempo = 0
userlist(userindex).flags.pertalcons = 0
userlist(userindex).flags.pertalconscaos = 0


userlist(userindex).flags.silenciado = 0



userlist(userindex).partyindex = 0
userlist(userindex).partysolicitud = 0



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
userlist(userindex) = usrtmp

set userlist(userindex).commandsbuffer = nothing
set userlist(userindex).guildref = nothing

set userlist(userindex).colasalida = nothing
userlist(userindex).sockpuedoenviar = false
userlist(userindex).connidvalida = false
userlist(userindex).connid = -1

userlist(userindex).anticuelgue = 0

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
userlist(userindex).flags.atacadopornpc = 0

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

'si esta en party le devolvemos la experiencia
if userlist(userindex).partyindex > 0 then call mdparty.salirdeparty(userindex)

' grabamos el personaje del usuario
call saveuser(userindex, charpath & name & ".chr")

'usado para borrar pjs
call writevar(charpath & userlist(userindex).name & ".chr", "init", "logged", "0")


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

'if userindex = lastuser then
'    do until userlist(lastuser).flags.userlogged
'        lastuser = lastuser - 1
'        if lastuser < 1 then exit do
'    loop
'end if
  
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
dim clientcrc as string
dim serversidecrc as long
dim idlecountbackup as long

cadenaoriginal = rdata

'�tiene un indece valido?
if userindex <= 0 then
    call closesocket(userindex)
    exit sub
end if

if left$(rdata, 13) = "givemevalcode" then
   '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
   '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   call senddata(toindex, userindex, 0, "val" & userlist(userindex).randkey & "," & userlist(userindex).flags.valcode)
   call enviarconfigserver(userindex) 'padrinos, creacion pjs,
   exit sub
else
   '<<<<<<<<<<< modulo privado de cada implementacion >>>>>>
   if false then
        call logerror("crc error userindex: " & userindex & " rdata: " & rdata)
        call closesocket(userindex, true)
        debug.print "err crc " & tstr
   end if
   'saco el firulete del crc (cada uno debe utilizar su tecnica)
   rdata = mid$(rdata, 1, instrrev(rdata, "~") - 1)
   
   '<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end if

idlecountbackup = userlist(userindex).counters.idlecount
userlist(userindex).counters.idlecount = 0
   
   if not userlist(userindex).flags.userlogged then

        select case left$(rdata, 6)
            case "ologin"
                rdata = right$(rdata, len(rdata) - 6)
                climd5 = right$(readfield(4, rdata, asc(",")), 16)
                'rdata = left$(rdata, len(rdata) - 16)
                if not md5ok(climd5) then
                    call senddata(toindex, userindex, 0, "errel cliente est� da�ado, por favor descarguelo nuevamente desde www.argentumonline.com.ar")
                    exit sub
                end if
                ver = readfield(3, rdata, 44)
                if versionok(ver) then
                    tname = readfield(1, rdata, 44)
                    
                    if not asciivalidos(tname) then
                        call senddata(toindex, userindex, 0, "errnombre invalido.")
                        call closesocket(userindex, true)
                        exit sub
                    end if
                    
                    if not personajeexiste(tname) then
                        call senddata(toindex, userindex, 0, "errel personaje no existe.")
                        call closesocket(userindex, true)
                        exit sub
                    end if

                    if not bancheck(tname) then

                        if (false) then
                              call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                              call closesocket(userindex)
                              exit sub
                        end if

                        userlist(userindex).flags.noactualizado = false
                        'userlist(userindex).flags.noactualizado = not versionesactuales(val(readfield(5, rdata, 44)), val(readfield(6, rdata, 44)), val(readfield(7, rdata, 44)), val(readfield(8, rdata, 44)), val(readfield(9, rdata, 44)), val(readfield(10, rdata, 44)), val(readfield(11, rdata, 44)))
                        'if userlist(userindex).flags.noactualizado then
                        'atencion aca se manejan las auto actualizacoines
                        if false then
                            call senddata(toindex, userindex, 0, "errexisten actualizaciones pendientes. ejecute el programa autoupdateclient.exe ubicado en la carpeta del ao para actualizar el juego")
                            call closesocket(userindex)
                        end if
                        
                        dim pass11 as string
                        pass11 = readfield(2, rdata, 44)
                        call connectuser(userindex, tname, pass11)
                    else
                        call senddata(toindex, userindex, 0, "errse te ha prohibido la entrada a argentum debido a tu mal comportamiento. consulta en aocp.alkon.com.ar/est para ver el motivo de la prohibici�n.")
                    end if
                else
                     call senddata(toindex, userindex, 0, "erresta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
                     'call closesocket(userindex)
                     exit sub
                end if
                exit sub
            case "tirdad"
            
                userlist(userindex).stats.useratributos(1) = int(randomnumber(3, 6) + randomnumber(3, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(2) = int(randomnumber(3, 6) + randomnumber(3, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(3) = int(randomnumber(6, 6) + randomnumber(3, 6) + randomnumber(3, 6))
                userlist(userindex).stats.useratributos(4) = int(randomnumber(3, 6) + randomnumber(3, 6) + randomnumber(1, 6))
                userlist(userindex).stats.useratributos(5) = int(randomnumber(6, 6) + randomnumber(3, 6) + randomnumber(3, 6))
                
                'barrin 3/10/03
                'cuando se tiran los dados, el servidor manda un 0 o un 1 dependiendo de si usamos o no el sistema de padrinos
                'as�, el cliente sabr� si abrir el frmpasswd con textboxes extra para poner el nombre y pass del padrino o no
                call senddata(toindex, userindex, 0, "dados" & userlist(userindex).stats.useratributos(1) & "," & userlist(userindex).stats.useratributos(2) & "," & userlist(userindex).stats.useratributos(3) & "," & userlist(userindex).stats.useratributos(4) & "," & userlist(userindex).stats.useratributos(5) & "," & usandosistemapadrinos)
                
                exit sub

            case "nlogin"
                
                if puedecrearpersonajes = 0 then
                    call senddata(toindex, userindex, 0, "errla creacion de personajes en este servidor se ha deshabilitado.")
                    call closesocket(userindex)
                    exit sub
                end if
                
                if serversologms > 0 then
                    call senddata(toindex, userindex, 0, "errservidor restringido a administradores. consulte la p�gina oficial o el foro oficial para mas informaci�n.")
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
                    call senddata(toindex, userindex, 0, "errel cliente est� da�ado o es antiguo, por favor desc�rguelo nuevamente desde el sitio http://ao.alkon.com.ar")
                    exit sub
                end if

'                if not validinputnp(rdata) then exit sub
                
                ver = readfield(5, rdata, 44)
                if versionok(ver) then
                     dim miinteger as integer
                     if usandosistemapadrinos = 1 then
                        miinteger = cint(val(readfield(46, rdata, 44)))
                     else
                        miinteger = cint(val(readfield(44, rdata, 44)))
                     end if
                        
                     'validacion sobre loginmessage y valcode (privada!)
                     if false then
                         call senddata(toindex, userindex, 0, "errpara poder continuar con la creaci�n del personaje, debe utilizar el cliente proporcionado en ao.alkon.com.ar")
                         'call loghackattemp("ip:" & userlist(userindex).ip & " intento crear un bot.")
                         call closesocket(userindex)
                         exit sub
                     end if
                     
                     'barrin 3/10/03
                     'a partir de si usamos el sistema o no, tratamos de conectar al nuevo pjta
                     if usandosistemapadrinos = 1 then
                        call connectnewuser(userindex, readfield(1, rdata, 44), readfield(2, rdata, 44), val(readfield(3, rdata, 44)), readfield(4, rdata, 44), readfield(6, rdata, 44), readfield(7, rdata, 44), _
                        readfield(8, rdata, 44), readfield(9, rdata, 44), readfield(10, rdata, 44), readfield(11, rdata, 44), readfield(12, rdata, 44), readfield(13, rdata, 44), _
                        readfield(14, rdata, 44), readfield(15, rdata, 44), readfield(16, rdata, 44), readfield(17, rdata, 44), readfield(18, rdata, 44), readfield(19, rdata, 44), _
                        readfield(20, rdata, 44), readfield(21, rdata, 44), readfield(22, rdata, 44), readfield(23, rdata, 44), readfield(24, rdata, 44), readfield(25, rdata, 44), _
                        readfield(26, rdata, 44), readfield(27, rdata, 44), readfield(28, rdata, 44), readfield(29, rdata, 44), readfield(30, rdata, 44), readfield(31, rdata, 44), _
                        readfield(32, rdata, 44), readfield(33, rdata, 44), readfield(34, rdata, 44), readfield(35, rdata, 44), readfield(36, rdata, 44), readfield(37, rdata, 44), readfield(38, rdata, 44))
                     else
                        userlist(userindex).flags.noactualizado = not versionesactuales(val(readfield(37, rdata, 44)), val(readfield(38, rdata, 44)), val(readfield(39, rdata, 44)), val(readfield(40, rdata, 44)), val(readfield(41, rdata, 44)), val(readfield(42, rdata, 44)), val(readfield(43, rdata, 44)))
                        
                        call connectnewuser(userindex, readfield(1, rdata, 44), readfield(2, rdata, 44), val(readfield(3, rdata, 44)), readfield(4, rdata, 44), readfield(6, rdata, 44), readfield(7, rdata, 44), _
                        readfield(8, rdata, 44), readfield(9, rdata, 44), readfield(10, rdata, 44), readfield(11, rdata, 44), readfield(12, rdata, 44), readfield(13, rdata, 44), _
                        readfield(14, rdata, 44), readfield(15, rdata, 44), readfield(16, rdata, 44), readfield(17, rdata, 44), readfield(18, rdata, 44), readfield(19, rdata, 44), _
                        readfield(20, rdata, 44), readfield(21, rdata, 44), readfield(22, rdata, 44), readfield(23, rdata, 44), readfield(24, rdata, 44), readfield(25, rdata, 44), _
                        readfield(26, rdata, 44), readfield(27, rdata, 44), readfield(28, rdata, 44), readfield(29, rdata, 44), readfield(30, rdata, 44), readfield(31, rdata, 44), _
                        readfield(32, rdata, 44), readfield(33, rdata, 44), readfield(34, rdata, 44), readfield(35, rdata, 44), readfield(36, rdata, 44))
                     end if
                
                else
                     call senddata(toindex, userindex, 0, "!!esta version del juego es obsoleta, la version correcta es " & ultimaversion & ". la misma se encuentra disponible en nuestra pagina.")
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
'if not userlist(userindex).flags.userlogged then
    call loghackattemp("mesaje enviado sin logearse:" & rdata)
'    call frmmain.socket2(userindex).disconnect
    call closesocket(userindex)
    exit sub
'end if
  
end if ' if not user logged


dim procesado as boolean

' bien ahora solo procesamos los comandos que no empiezan
' con "/".
if left(rdata, 1) <> "/" then
    
    call handledata_1(userindex, rdata, procesado)
    if procesado then exit sub
    
' bien hasta aca fueron los comandos que no empezaban con
' "/". ahora adivin� que sigue :)
else
    
    call handledata_2(userindex, rdata, procesado)
    if procesado then exit sub

end if ' "/"


if userlist(userindex).flags.privilegios = 0 then
    userlist(userindex).counters.idlecount = idlecountbackup
end if

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
    if userlist(tindex).flags.privilegios = 3 then exit sub
    call senddata(toindex, userindex, 0, "||ubicacion  " & userlist(tindex).name & ": " & userlist(tindex).pos.map & ", " & userlist(tindex).pos.x & ", " & userlist(tindex).pos.y & "." & fonttype_info)
    call loggm(userlist(userindex).name, "/donde " & userlist(tindex).name, (userlist(userindex).flags.privilegios = 1))
    exit sub
end if

'nro de enemigos
'if ucase$(left$(rdata, 6)) = "/nene " then
'    rdata = right$(rdata, len(rdata) - 6)
'    if mapavalido(val(rdata)) then
'        call senddata(toindex, userindex, 0, "nene" & npchostiles(val(rdata)))
'        call loggm(userlist(userindex).name, "numero enemigos en mapa " & rdata, (userlist(userindex).flags.privilegios = 1))
'    end if
'    exit sub
'end if

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
                call senddata(toindex, userindex, 0, "||npcs en mapa: " & conts & fonttype_info)
                call loggm(userlist(userindex).name, "numero enemigos en mapa " & rdata, (userlist(userindex).flags.privilegios = 1))
    end if
    exit sub
end if



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

if ucase$(left$(rdata, 11)) = "/silenciar " then
    rdata = right$(rdata, len(rdata) - 11)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline." & fonttype_info)
        exit sub
    end if
    if userlist(tindex).flags.silenciado = 0 then
        userlist(tindex).flags.silenciado = 1
        call senddata(toindex, userindex, 0, "||usuario silenciado." & fonttype_info)
        call senddata(toindex, tindex, 0, "!!estimado usuario, ud ha sido silenciado por los administradores. sus denuncias ser�n ignoradas por el servidor de aqu� en mas. utilice /gm ayuda para contactar un administrador.")
        call loggm(userlist(userindex).name, "/silenciar " & userlist(tindex).name, (userlist(userindex).flags.privilegios = 1))
    else
        userlist(tindex).flags.silenciado = 0
        call senddata(toindex, userindex, 0, "||usuario des silenciado." & fonttype_info)
        call loggm(userlist(userindex).name, "/dessilenciar " & userlist(tindex).name, (userlist(userindex).flags.privilegios = 1))
    end if
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

if ucase$(rdata) = "/panelgm" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call senddata(toindex, userindex, 0, "abpanel")
    exit sub
end if

if ucase$(rdata) = "listusu" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    tstr = "listusu"
    for loopc = 1 to lastuser
        if (userlist(loopc).name <> "") and userlist(loopc).flags.privilegios = 0 then
            tstr = tstr & userlist(loopc).name & ","
        end if
    next loopc
    if len(tstr) > 7 then
        tstr = left$(tstr, len(tstr) - 2)
    end if
    call senddata(toindex, userindex, 0, tstr)
    exit sub
end if

'[barrin 30-11-03]
if ucase$(rdata) = "/trabajando" then
        if userlist(userindex).flags.esrolesmaster then exit sub
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") and userlist(loopc).flags.trabajando = true then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        tstr = left$(tstr, len(tstr) - 2)
        call senddata(toindex, userindex, 0, "||usuarios trabajando: " & tstr & fonttype_info)
        exit sub
end if
'[/barrin 30-11-03]


if ucase$(left$(rdata, 8)) = "/carcel " then
    '/carcel nick@motivo@<tiempo>
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right$(rdata, len(rdata) - 8)
    
    name = readfield(1, rdata, asc("@"))
    tstr = readfield(2, rdata, asc("@"))
    if (not isnumeric(readfield(3, rdata, asc("@")))) or name = "" or tstr = "" then
        call senddata(toindex, userindex, 0, "||utilice /carcel nick@motivo@tiempo" & fonttype_info)
        exit sub
    end if
    i = val(readfield(3, rdata, asc("@")))
    
    tindex = nameindex(name)
    
    'if ucase$(name) = "reeves" then exit sub
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > 0 then
        call senddata(toindex, userindex, 0, "||no podes encarcelar a administradores." & fonttype_info)
        exit sub
    end if
    
    if i > 60 then
        call senddata(toindex, userindex, 0, "||no podes encarcelar por mas de 60 minutos." & fonttype_info)
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
    call loggm(userlist(userindex).name, " encarcelo a " & name, userlist(userindex).flags.privilegios = 1)
    exit sub
end if

if ucase$(left$(rdata, 13)) = "/advertencia " then
    '/carcel nick@motivo
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right$(rdata, len(rdata) - 13)
    
    name = readfield(1, rdata, asc("@"))
    tstr = readfield(2, rdata, asc("@"))
    if name = "" or tstr = "" then
        call senddata(toindex, userindex, 0, "||utilice /advertencia nick@motivo" & fonttype_info)
        exit sub
    end if
    
    tindex = nameindex(name)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_info)
        exit sub
    end if
    
    if userlist(tindex).flags.privilegios > 0 then
        call senddata(toindex, userindex, 0, "||no podes advertir a administradores." & fonttype_info)
        exit sub
    end if
    
    name = replace(name, "\", "")
    name = replace(name, "/", "")
    
    if fileexist(charpath & name & ".chr", vbnormal) then
        tint = val(getvar(charpath & name & ".chr", "penas", "cant"))
        call writevar(charpath & name & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & name & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": advertencia por: " & lcase$(tstr) & " " & date & " " & time)
    end if
    
    call loggm(userlist(userindex).name, " advirtio a " & name, userlist(userindex).flags.privilegios = 1)
    exit sub
end if



'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<< semidioses <<<<<<<<<<<<<<<<<<<<<<<<
if userlist(userindex).flags.privilegios < 2 then
    exit sub
end if

if ucase$(left$(rdata, 6)) = "/info " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 6)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline, buscando en charfile." & fonttype_info)
        senduserstatstxtoff userindex, rdata
        'muy dificil :p
        'senduserstatstxtfromchar userindex, tindex
    else
        if userlist(tindex).flags.privilegios = 3 then exit sub
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
            call senddata(toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_info)
            senduserministatstxtfromchar userindex, tindex
        else
            senduserministatstxt userindex, tindex
        end if
    
        exit sub
    end if


if ucase$(left$(rdata, 5)) = "/bal " then
rdata = right$(rdata, len(rdata) - 5)
tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_talk)
        senduserorotxtfromchar userindex, rdata
    else
        call senddata(toindex, userindex, 0, "|| el usuario " & rdata & " tiene " & userlist(tindex).stats.banco & " en el banco" & fonttype_talk)
    end if
    exit sub
end if

'inv del user
if ucase$(left$(rdata, 5)) = "/inv " then
    call loggm(userlist(userindex).name, rdata, false)
    
    rdata = right$(rdata, len(rdata) - 5)
    
    tindex = nameindex(rdata)
    
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline. leyendo del charfile..." & fonttype_talk)
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
        call senddata(toindex, userindex, 0, "||usuario offline. leyendo charfile... " & fonttype_talk)
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
            call senddata(toindex, userindex, 0, "|| char>" & skillsnames(tint) & " = " & getvar(charpath & rdata & ".chr", "skills", "sk" & tint) & fonttype_info)
        next tint
            call senddata(toindex, userindex, 0, "|| char> libres:" & getvar(charpath & rdata & ".chr", "stats", "skillptslibres") & fonttype_info)
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

'barrin 30/9/03
if ucase$(rdata) = "/onlinemap" then
        for loopc = 1 to lastuser
            if (userlist(loopc).name <> "") and userlist(loopc).pos.map = userlist(userindex).pos.map then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        next loopc
        tstr = left$(tstr, len(tstr) - 2)
        call senddata(toindex, userindex, 0, "||usuarios en el mapa: " & tstr & fonttype_info)
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

if ucase$(left$(rdata, 10)) = "/ejecutar " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 10)
    tindex = nameindex(rdata)
    if userlist(tindex).flags.privilegios > 0 then
        call senddata(toindex, userindex, 0, "||est�s loco?? como vas a pi�atear un gm!!!! :@" & fonttype_info)
        exit sub
    end if
    if tindex > 0 then
        call userdie(tindex)
        call senddata(toall, 0, 0, "||" & userlist(userindex).name & " ha ejecutado a " & userlist(tindex).name & fonttype_ejecucion)
        call loggm(userlist(userindex).name, " ejecuto a " & userlist(tindex).name, false)
    else
        call senddata(toindex, userindex, 0, "||no est� online" & fonttype_info)
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
        call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_talk)
        
        if fileexist(charpath & tstr & ".chr", vbnormal) then
            tlong = userdarprivilegiolevel(tstr)
            
            if tlong > userlist(userindex).flags.privilegios then
                call senddata(toindex, userindex, 0, "||no podes banear a al alguien de mayor jerarquia." & fonttype_info)
                exit sub
            end if
            
            if getvar(charpath & tstr & ".chr", "flags", "ban") <> "0" then
                call senddata(toindex, userindex, 0, "||el personaje ya se encuentra baneado." & fonttype_info)
                exit sub
            end if
            
            call logbanfromname(tstr, userindex, name)
            call senddata(toadmins, 0, 0, "||servidor> " & userlist(userindex).name & " ha baneado a " & tstr & "." & fonttype_server)
            
            'ponemos el flag de ban a 1
            call writevar(charpath & tstr & ".chr", "flags", "ban", "1")
            'ponemos la pena
            tint = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
            call writevar(charpath & tstr & ".chr", "penas", "cant", tint + 1)
            call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban por " & lcase$(name) & " " & date & " " & time)
            
            if tlong > 0 then
                    userlist(userindex).flags.ban = 1
                    call closesocket(userindex)
                    call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " banned by the server por bannear un administrador." & fonttype_fight)
            end if

            call loggm(userlist(userindex).name, "ban a " & tstr, false)
        else
            call senddata(toindex, userindex, 0, "||el pj " & tstr & " no existe." & fonttype_info)
        end if
    else
        if userlist(tindex).flags.privilegios > userlist(userindex).flags.privilegios then
            call senddata(toindex, userindex, 0, "||no podes banear a al alguien de mayor jerarquia." & fonttype_info)
            exit sub
        end if
        
        call logban(tindex, userindex, name)
        call senddata(toadmins, 0, 0, "||servidor> " & userlist(userindex).name & " ha baneado a " & userlist(tindex).name & "." & fonttype_server)
        
        'ponemos el flag de ban a 1
        userlist(tindex).flags.ban = 1
        
        if userlist(tindex).flags.privilegios > 0 then
                userlist(userindex).flags.ban = 1
                call closesocket(userindex)
                call senddata(toadmins, 0, 0, "||" & userlist(userindex).name & " banned by the server por bannear un administrador." & fonttype_fight)
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
        call senddata(toindex, userindex, 0, "||charfile inexistente (no use +)" & fonttype_info)
        exit sub
    end if
    
    call unban(rdata)
    
    'penas
    i = val(getvar(charpath & rdata & ".chr", "penas", "cant"))
    call writevar(charpath & rdata & ".chr", "penas", "cant", i + 1)
    call writevar(charpath & rdata & ".chr", "penas", "p" & i + 1, lcase$(userlist(userindex).name) & ": unban. " & date & " " & time)
    
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
        call senddata(toall, 0, 0, "||" & rdata & fonttype_talk & endc)
    end if
    exit sub
end if

'ip del nick
if ucase$(left$(rdata, 9)) = "/nick2ip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 9)
    tindex = nameindex(ucase$(rdata))
    call loggm(userlist(userindex).name, "nick2ip solicito la ip de " & rdata, userlist(userindex).flags.privilegios = 1)
    if tindex > 0 then
        if (userlist(userindex).flags.privilegios > 0 and userlist(tindex).flags.privilegios = 0) or (userlist(userindex).flags.privilegios = 3) then
            call senddata(toindex, userindex, 0, "||el ip de " & rdata & " es " & userlist(tindex).ip & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "||no tienes los privilegios necesarios" & fonttype_info)
        end if
    else
       call senddata(toindex, userindex, 0, "||no hay ningun personaje con ese nick" & fonttype_info)
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
            call senddata(toindex, userindex, 0, "||pj offline" & fonttype_info)
            exit sub
        end if
        rdata = userlist(tint).ip
    end if
    tstr = vbnullstring
    call loggm(userlist(userindex).name, "ip2nick solicito los nicks de ip " & rdata, userlist(userindex).flags.privilegios = 1)
    for loopc = 1 to lastuser
        if userlist(loopc).ip = rdata and userlist(loopc).name <> "" and userlist(loopc).flags.userlogged then
            if (userlist(userindex).flags.privilegios > 0 and userlist(loopc).flags.privilegios = 0) or (userlist(userindex).flags.privilegios = 3) then
                tstr = tstr & userlist(loopc).name & ", "
            end if
        end if
    next loopc
    
    call senddata(toindex, userindex, 0, "||los personajes con ip " & rdata & " son: " & tstr & fonttype_info)
    exit sub
end if


if ucase$(left$(rdata, 8)) = "/onclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 8)
        for loopc = 1 to lastuser
            if userlist(loopc).flags.userlogged then
                if ucase(userlist(loopc).guildinfo.guildname) = ucase(rdata) then
                    tstr = tstr & userlist(loopc).name & ", "
                end if
            end if
        next loopc
        call senddata(toindex, userindex, 0, "||clan " & ucase(rdata) & ": " & tstr & fonttype_guildmsg)
     exit sub
end if


'crear teleport
if ucase(left(rdata, 4)) = "/ct " then
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < 3 then exit sub
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
        call senddata(toindex, userindex, mapa, "||hay un objeto en el piso en ese lugar" & fonttype_info)
        exit sub
    end if
    
    dim et as obj
    et.amount = 1
    et.objindex = 378
    
    call makeobj(tomap, 0, userlist(userindex).pos.map, et, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1)
    
    et.amount = 1
    et.objindex = 651
    
    call makeobj(tomap, 0, mapa, et, mapa, x, y)
    
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.map = mapa
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.x = x
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1).tileexit.y = y
    
    exit sub
end if

'destruir teleport
'toma el ultimo click
if ucase(left(rdata, 3)) = "/dt" then
    '/dt
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < 3 then exit sub
    call loggm(userlist(userindex).name, "/dt", false)
    
    mapa = userlist(userindex).flags.targetmap
    x = userlist(userindex).flags.targetx
    y = userlist(userindex).flags.targety
    
    if objdata(mapdata(mapa, x, y).objinfo.objindex).objtype = objtype_teleport and _
        mapdata(mapa, x, y).tileexit.map > 0 then
        call eraseobj(tomap, 0, mapa, mapdata(mapa, x, y).objinfo.amount, mapa, x, y)
        call eraseobj(tomap, 0, mapdata(mapa, x, y).tileexit.map, 1, mapdata(mapa, x, y).tileexit.map, mapdata(mapa, x, y).tileexit.x, mapdata(mapa, x, y).tileexit.y)
        mapdata(mapa, x, y).tileexit.map = 0
        mapdata(mapa, x, y).tileexit.x = 0
        mapdata(mapa, x, y).tileexit.y = 0
    end if
    
    exit sub
end if


if ucase$(rdata) = "/lluvia" then
    call loggm(userlist(userindex).name, rdata, false)
    lloviendo = not lloviendo
    call senddata(toall, 0, 0, "llu")
    exit sub
end if


if ucase(left(rdata, 9)) = "/setdesc " then
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < 3 then exit sub
    rdata = right$(rdata, len(rdata) - 9)
    dummyint = userlist(userindex).flags.targetuser
    if dummyint > 0 then
        userlist(dummyint).descrm = rdata
    else
        call senddata(toindex, userindex, 0, "||haz click sobre un personaje antes!" & fonttype_info)
    end if
    exit sub
    
end if



'modifica caracter
if ucase$(left$(rdata, 5)) = "/mod " then
    if not userlist(userindex).flags.esrolesmaster and userlist(userindex).flags.privilegios < 3 then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right$(rdata, len(rdata) - 5)
    tstr = readfield(1, rdata, 32)
    tindex = nameindex(tstr)
    arg1 = readfield(2, rdata, 32)
    arg2 = readfield(3, rdata, 32)
    arg3 = readfield(4, rdata, 32)
    arg4 = readfield(5, rdata, 32)
    
    select case ucase$(arg1)
'        case "nick"
'            t = split(rdata, " ", 3)
'            if ubound(t) = 2 then
'                call cambiarnick(userindex, tindex, t(2))
'            end if
        case "oro" '/mod yo oro 95000
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
            if val(arg2) < 5000000 then
                userlist(tindex).stats.gld = val(arg2)
                call senduserstatsbox(tindex)
            else
                call senddata(toindex, userindex, 0, "||no esta permitido utilizar valores mayores. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
        case "exp" '/mod yo exp 9995000
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
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
                call senddata(toindex, userindex, 0, "||no esta permitido utilizar valores mayores a mucho. su comando ha quedado en los logs del juego." & fonttype_info)
                exit sub
            end if
        case "body"
            if tindex <= 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "init", "head", arg2)
                call senddata(toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
                exit sub
            end if
            
            call changeuserchar(tomap, 0, userlist(tindex).pos.map, tindex, val(arg2), userlist(tindex).char.head, userlist(tindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            exit sub
        case "head"
            if tindex <= 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "init", "body", arg2)
                call senddata(toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
                exit sub
            end if
            
            call changeuserchar(tomap, 0, userlist(tindex).pos.map, tindex, userlist(tindex).char.body, val(arg2), userlist(tindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            exit sub
        case "cri"
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
            userlist(tindex).faccion.criminalesmatados = val(arg2)
            exit sub
        case "ciu"
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
            userlist(tindex).faccion.ciudadanosmatados = val(arg2)
            exit sub
        case "level"
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
            userlist(tindex).stats.elv = val(arg2)
            exit sub
        case "clase"
            if tindex <= 0 then
                call senddata(toindex, userindex, 0, "||usuario offline:" & tstr & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.esrolesmaster then exit sub
            userlist(tindex).clase = ucase$(arg2)
    '[dng]
        case "skills"
            for loopc = 1 to numskills
                if ucase$(replace$(skillsnames(loopc), " ", "+")) = ucase$(arg2) then n = loopc
            next loopc


            if n = 0 then
                call senddata(toindex, 0, 0, "|| skill inexistente!" & fonttype_info)
                exit sub
            end if

            if tindex = 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "skills", "sk" & n, arg3)
                call senddata(toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
            else
                userlist(tindex).stats.userskills(n) = val(arg3)
            end if
        exit sub
        
        case "skillslibres"
            
            if tindex = 0 then
                call writevar(charpath & replace$(readfield(1, rdata, 32), "+", " ") & ".chr", "stats", "skillptslibres", arg2)
                call senddata(toindex, userindex, 0, "||charfile alterado:" & tstr & fonttype_info)
            
            else
                userlist(tindex).stats.skillpts = val(arg2)
            end if
        exit sub
    '[/dng]
        case else
            call senddata(toindex, userindex, 0, "||comando no permitido." & fonttype_info)
            exit sub
        end select

    exit sub
end if





'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
'<<<<<<<<<<<<<<<<<<<<< dioses >>>>>>>>>>>>>>>>>>>>>>>>
if userlist(userindex).flags.privilegios < 3 then
    exit sub
end if

'[el oso extended]




'[/el oso]


'[barrin 30-11-03]
'quita todos los objetos del area
if ucase$(rdata) = "/massdest" then
    for y = userlist(userindex).pos.y - minyborder + 1 to userlist(userindex).pos.y + minyborder - 1
            for x = userlist(userindex).pos.x - minxborder + 1 to userlist(userindex).pos.x + minxborder - 1
                if x > 0 and y > 0 and x < 101 and y < 101 then _
                    if mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex > 0 then _
                    if itemnoesdemapa(mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex) then call eraseobj(tomap, userindex, userlist(userindex).pos.map, 10000, userlist(userindex).pos.map, x, y)
            next x
    next y
    call loggm(userlist(userindex).name, "/massdest", (userlist(userindex).flags.privilegios = 1))
    exit sub
end if
'[/barrin 30-11-03]


'[yb]
if ucase$(left$(rdata, 12)) = "/aceptconse " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 12)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        call senddata(toindex, userindex, 0, "||usuario offline" & fonttype_info)
    else
        call senddata(toall, 0, 0, "||" & rdata & " fue aceptado en el honorable consejo real de banderbill." & fonttype_consejo)
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
        call senddata(toindex, userindex, 0, "||usuario offline" & fonttype_info)
    else
        call senddata(toall, 0, 0, "||" & rdata & " fue aceptado en el consejo de la legi�n oscura." & fonttype_consejocaos)
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
                    call senddata(toindex, userindex, 0, "||(" & x & "," & y & ") " & objdata(tindex).name & fonttype_info)
                end if
            end if
        next y
    next x
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/kickconse " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 11)
    tindex = nameindex(rdata)
    if tindex <= 0 then
        if fileexist(charpath & rdata & ".chr") then
            call senddata(toindex, userindex, 0, "||usuario offline, echando de los consejos" & fonttype_info)
            call writevar(charpath & ucase(rdata) & ".chr", "consejo", "pertenece", 0)
            call writevar(charpath & ucase(rdata) & ".chr", "consejo", "pertenececaos", 0)
        else
            call senddata(toindex, userindex, 0, "||no se encuentra el charfile " & charpath & rdata & ".chr" & fonttype_info)
            exit sub
        end if
    else
        if userlist(tindex).flags.pertalcons > 0 then
            call senddata(toindex, tindex, 0, "||has sido echado en el consejo de banderbill" & fonttype_talk & endc)
            userlist(tindex).flags.pertalcons = 0
            call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y)
            call senddata(toall, 0, 0, "||" & rdata & " fue expulsado del consejo de banderbill" & fonttype_consejo)
        end if
        if userlist(tindex).flags.pertalconscaos > 0 then
            call senddata(toindex, tindex, 0, "||has sido echado en el consejo de la legi�n oscura" & fonttype_talk & endc)
            userlist(tindex).flags.pertalconscaos = 0
            call warpuserchar(tindex, userlist(tindex).pos.map, userlist(tindex).pos.x, userlist(tindex).pos.y)
            call senddata(toall, 0, 0, "||" & rdata & " fue expulsado del consejo de la legi�n oscura" & fonttype_consejocaos)
        end if
    end if
    exit sub
end if
'[/yb]



if ucase(left(rdata, 8)) = "/trigger" then
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
    call senddata(toindex, userindex, 0, "||trigger " & mapdata(mapa, x, y).trigger & " en mapa " & mapa & " " & x & ", " & y & fonttype_info)
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
    call senddata(toindex, userindex, 0, tstr)
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
        call senddata(toindex, userindex, 0, "|| no existe el clan: " & rdata & fonttype_info)
        exit sub
    end if
    
    call loggm(userlist(userindex).name, "miembrosclan a " & rdata, false)

    tint = val(getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "init", "nromembers"))
    
    for i = 1 to tint
        tstr = getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "members", "member" & i)
        'tstr es la victima
        call senddata(toindex, userindex, 0, "||" & tstr & "<" & rdata & ">." & fonttype_info)
    next i

    exit sub
end if



if ucase(left(rdata, 9)) = "/banclan " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = trim(right(rdata, len(rdata) - 9))
    if not fileexist(app.path & "\guilds\" & rdata & "-members.mem") then
        call senddata(toindex, userindex, 0, "|| no existe el clan: " & rdata & fonttype_info)
        exit sub
    end if
    
    call senddata(toall, 0, 0, "|| " & userlist(userindex).name & " banned al clan " & ucase$(rdata) & fonttype_fight)
    
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
        
        call senddata(toall, 0, 0, "||   " & tstr & "<" & rdata & "> ha sido expulsado del servidor." & fonttype_fight)

        'ponemos el flag de ban a 1
        call writevar(charpath & tstr & ".chr", "flags", "ban", "1")

        'ponemos la pena
        n = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
        call writevar(charpath & tstr & ".chr", "penas", "cant", n + 1)
        call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban al clan: " & rdata & " " & date & " " & time)

    next i

    exit sub
end if


'ban x ip
if ucase(left(rdata, 7)) = "/banip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
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
    
    if banipbuscar(banip) > 0 then
        call senddata(toindex, userindex, 0, "||la ip " & banip & " ya se encuentra en la lista de bans." & fonttype_info)
        exit sub
    end if
    
    call banipagrega(banip)
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
if ucase(left(rdata, 9)) = "/unbanip " then
    
    if userlist(userindex).flags.esrolesmaster then exit sub
    
    rdata = right(rdata, len(rdata) - 9)
    call loggm(userlist(userindex).name, "/unbanip " & rdata, false)
    
'    for loopc = 1 to banips.count
'        if banips.item(loopc) = rdata then
'            banips.remove loopc
'            call senddata(toindex, userindex, 0, "||la ip " & banip & " se ha quitado de la lista de bans." & fonttype_info)
'            exit sub
'        end if
'    next loopc
'
'    call senddata(toindex, userindex, 0, "||la ip " & rdata & " no se encuentra en la lista de bans." & fonttype_info)
    
    if banipquita(rdata) then
        call senddata(toindex, userindex, 0, "||la ip """ & rdata & """ se ha quitado de la lista de bans." & fonttype_info)
    else
        call senddata(toindex, userindex, 0, "||la ip """ & rdata & """ no se encuentra en la lista de bans." & fonttype_info)
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
    
    dim objeto as obj
    
    call senddata(toindex, userindex, 0, "||atencion: fueron creados ***100*** items!, tire y /dest los que no necesite!!" & fonttype_guild)
    
    objeto.amount = 100
    objeto.objindex = val(rdata)
    
    call makeobj(tomap, 0, userlist(userindex).pos.map, objeto, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y - 1)
    
    exit sub
end if


'destruir
if ucase$(left$(rdata, 5)) = "/dest" then
    call loggm(userlist(userindex).name, "/dest", false)
    rdata = right$(rdata, len(rdata) - 5)
    call eraseobj(tomap, userindex, userlist(userindex).pos.map, 10000, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
    exit sub
end if

if ucase$(left$(rdata, 8)) = "/nocaos " then
    rdata = right$(rdata, len(rdata) - 8)
    call loggm(userlist(userindex).name, "echo del caos a: " & rdata, false)

    tindex = nameindex(rdata)
    
    if tindex > 0 then
        userlist(tindex).faccion.fuerzascaos = 0
        userlist(tindex).faccion.reenlistadas = 200
        call senddata(toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas del caos y prohibida la reenlistada" & fonttype_info)
        call senddata(toindex, tindex, 0, "|| " & userlist(userindex).name & " te ha expulsado en forma definitiva de las fuerzas del caos." & fonttype_fight)
    else
        if fileexist(charpath & rdata & ".chr") then
            call writevar(charpath & rdata & ".chr", "facciones", "ejercitocaos", 0)
            call writevar(charpath & rdata & ".chr", "facciones", "reenlistadas", 200)
            call writevar(charpath & rdata & ".chr", "facciones", "extra", "expulsado por " & userlist(userindex).name)
            call senddata(toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas del caos y prohibida la reenlistada" & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "|| " & rdata & ".chr inexistente." & fonttype_info)
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
        call senddata(toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas reales y prohibida la reenlistada" & fonttype_info)
        call senddata(toindex, tindex, 0, "|| " & userlist(userindex).name & " te ha expulsado en forma definitiva de las fuerzas reales." & fonttype_fight)
    else
        if fileexist(charpath & rdata & ".chr") then
            call writevar(charpath & rdata & ".chr", "facciones", "ejercitoreal", 0)
            call writevar(charpath & rdata & ".chr", "facciones", "reenlistadas", 200)
            call writevar(charpath & rdata & ".chr", "facciones", "extra", "expulsado por " & userlist(userindex).name)
            call senddata(toindex, userindex, 0, "|| " & rdata & " expulsado de las fuerzas reales y prohibida la reenlistada" & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "|| " & rdata & ".chr inexistente." & fonttype_info)
        end if
    end if
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/forcemidi " then
    rdata = right$(rdata, len(rdata) - 11)
    if not isnumeric(rdata) then
        exit sub
    else
        call senddata(toall, 0, 0, "|| " & userlist(userindex).name & " broadcast musica: " & rdata & fonttype_server)
        call senddata(toall, 0, 0, "tm" & rdata)
    end if
end if

if ucase$(left$(rdata, 10)) = "/forcewav " then
    rdata = right$(rdata, len(rdata) - 10)
    if not isnumeric(rdata) then
        exit sub
    else
        call senddata(toall, 0, 0, "tw" & rdata)
    end if
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

'ultima ip de un char
if ucase(left(rdata, 8)) = "/lastip " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    rdata = right(rdata, len(rdata) - 8)
    
    'no se si sea muy necesario, pero por si las dudas... ;)
    rdata = replace(rdata, "\", "")
    rdata = replace(rdata, "/", "")
    
    if fileexist(charpath & rdata & ".chr", vbnormal) then
        call senddata(toindex, userindex, 0, "||la ultima ip de """ & rdata & """ fue : " & getvar(charpath & rdata & ".chr", "init", "lastip") & fonttype_info)
    else
        call senddata(toindex, userindex, 0, "||charfile """ & rdata & """ inexistente." & fonttype_info)
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
    call senddata(toindex, userindex, 0, tstr)
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
    call senddata(toall, 0, 0, "!!" & rdata & endc)
    exit sub
end if

'crear criatura, toma directamente el indice
if ucase$(left$(rdata, 5)) = "/acc " then
   rdata = right$(rdata, len(rdata) - 5)
   call loggm(userlist(userindex).name, "sumoneo a " & npclist(val(rdata)).name & " en mapa " & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = 1))
   call spawnnpc(val(rdata), userlist(userindex).pos, true, false)
   exit sub
end if

'crear criatura con respawn, toma directamente el indice
if ucase$(left$(rdata, 6)) = "/racc " then
 
   rdata = right$(rdata, len(rdata) - 6)
   call loggm(userlist(userindex).name, "sumoneo con respawn " & npclist(val(rdata)).name & " en mapa " & userlist(userindex).pos.map, (userlist(userindex).flags.privilegios = 1))
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
        call senddata(toindex, userindex, 0, "||servidor habilitado para todos" & fonttype_info)
        serversologms = 0
    else
        call senddata(toindex, userindex, 0, "||servidor restringido a administradores." & fonttype_info)
        serversologms = 1
    end if
    exit sub
end if

'apagamos
if ucase$(rdata) = "/apagar" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(toall, userindex, 0, "||" & userlist(userindex).name & " intenta apagar el servidor!!!" & fonttype_fight)
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
    tindex = nameindex(ucase$(rdata))
    if tindex > 0 then
        call eacharmember(tindex, userlist(userindex).name)
        userlist(tindex).guildinfo.guildname = ""
        userlist(tindex).guildinfo.esguildleader = 0
    end if
    exit sub
end if

'lst email
if ucase$(left$(rdata, 11)) = "/lastemail " then
    if userlist(userindex).flags.esrolesmaster then exit sub
    rdata = right$(rdata, len(rdata) - 11)
    if fileexist(charpath & rdata & ".chr") then
        tstr = getvar(charpath & rdata & ".chr", "contacto", "email")
        call senddata(toindex, userindex, 0, "||last email de " & rdata & ":" & tstr & fonttype_info)
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
        call senddata(toindex, userindex, 0, "||usar /apass <pjsinpass>@<pjconpass>" & fonttype_info)
        exit sub
    end if
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(toindex, userindex, 0, "||el usuario a cambiarle el pass (" & tstr & ") esta online, no se puede si esta online" & fonttype_info)
        exit sub
    end if
    arg1 = readfield(2, rdata, asc("@"))
    if arg1 = "" then
        call senddata(toindex, userindex, 0, "||usar /apass <pjsinpass> <pjconpass>" & fonttype_info)
        exit sub
    end if
    if not fileexist(charpath & tstr & ".chr") or not fileexist(charpath & arg1 & ".chr") then
        call senddata(toindex, userindex, 0, "||alguno de los pjs no existe " & tstr & "@" & arg1 & fonttype_info)
    else
        arg2 = getvar(charpath & arg1 & ".chr", "init", "password")
        call writevar(charpath & tstr & ".chr", "init", "password", arg2)
        call senddata(toindex, userindex, 0, "||password de " & tstr & " cambiado a: " & arg2 & fonttype_info)
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
        call senddata(toindex, userindex, 0, "||usar /aemail <pj>-<nuevomail>" & fonttype_info)
        exit sub
    end if
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(toindex, userindex, 0, "||el usuario esta online, no se puede si esta online" & fonttype_info)
        exit sub
    end if
    arg1 = readfield(2, rdata, asc("-"))
    if arg1 = "" then
        call senddata(toindex, userindex, 0, "||usar /aemail <pj>-<nuevomail>" & fonttype_info)
        exit sub
    end if
    if not fileexist(charpath & tstr & ".chr") then
        call senddata(toindex, userindex, 0, "||no existe el charfile " & charpath & tstr & ".chr" & fonttype_info)
    else
        call writevar(charpath & tstr & ".chr", "contacto", "email", arg1)
        call senddata(toindex, userindex, 0, "||email de " & tstr & " cambiado a: " & arg1 & fonttype_info)
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
        call senddata(toindex, userindex, 0, "||usar: /aname origen@destino" & fonttype_info)
        exit sub
    end if
    
    tindex = nameindex(tstr)
    if tindex > 0 then
        call senddata(toindex, userindex, 0, "||el pj esta online, debe salir para el cambio" & fonttype_warning)
        exit sub
    end if
    
    if fileexist(charpath & ucase(tstr) & ".chr") = false then
        call senddata(toindex, userindex, 0, "||el pj " & tstr & " es inexistente " & fonttype_info)
        exit sub
    end if
    if fileexist(charpath & ucase(arg1) & ".chr") = false then
        filecopy charpath & ucase(tstr) & ".chr", charpath & ucase(arg1) & ".chr"
        call senddata(toindex, userindex, 0, "||transferencia exitosa" & fonttype_info)
        call writevar(charpath & tstr & ".chr", "flags", "ban", "1")
        'ponemos la pena
        tint = val(getvar(charpath & tstr & ".chr", "penas", "cant"))
        call writevar(charpath & tstr & ".chr", "penas", "cant", tint + 1)
        call writevar(charpath & tstr & ".chr", "penas", "p" & tint + 1, lcase$(userlist(userindex).name) & ": ban por cambio de nick a " & ucase$(arg1) & " " & date & " " & time)
    else
        call senddata(toindex, userindex, 0, "||el nick solicitado ya existe" & fonttype_info)
        exit sub
    end if
    exit sub
end if




if ucase$(left$(rdata, 9)) = "/dobackup" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call dobackup
    exit sub
end if

if ucase$(left$(rdata, 11)) = "/guardamapa" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call savemapdata(userlist(userindex).pos.map)
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
        end if
        call senddata(toindex, userindex, 0, "||mapa " & userlist(userindex).pos.map & " pk: " & mapinfo(userlist(userindex).pos.map).pk & fonttype_info)
    case "backup"
        tstr = readfield(2, rdata, 32)
        if tstr <> "" then
            mapinfo(userlist(userindex).pos.map).backup = cbyte(tstr)
        end if
        call senddata(toindex, userindex, 0, "||mapa " & userlist(userindex).pos.map & " backup: " & mapinfo(userlist(userindex).pos.map).backup & fonttype_info)
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


if ucase(rdata) = "/noche" then
    if (userlist(userindex).name <> "el oso") then exit sub
    denoche = not denoche
    for loopc = 1 to numusers
        if userlist(userindex).flags.userlogged and userlist(userindex).connid > -1 then
            call enviarnoche(loopc)
        end if
    next loopc
    exit sub
end if

if ucase$(rdata) = "/passday" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call dayelapsed
    exit sub
end if

if ucase(rdata) = "/echartodospjs" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call echarpjsnoprivilegiados
    exit sub
end if



if ucase(rdata) = "/tcpesstats" then
    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(toindex, userindex, 0, "||los datos estan en bytes." & fonttype_info)
    with tcpesstats
        call senddata(toindex, userindex, 0, "||in/s: " & .bytesrecibidosxseg & " out/s: " & .bytesenviadosxseg & fonttype_info)
        call senddata(toindex, userindex, 0, "||in/s max: " & .bytesrecibidosxsegmax & " -> " & .bytesrecibidosxsegcuando & fonttype_info)
        call senddata(toindex, userindex, 0, "||out/s max: " & .bytesenviadosxsegmax & " -> " & .bytesenviadosxsegcuando & fonttype_info)
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
    call senddata(toindex, userindex, 0, "||posibles pjs trabados: " & tlong & fonttype_info)
    call senddata(toindex, userindex, 0, "||" & tstr & fonttype_info)
    exit sub
end if

if ucase$(rdata) = "/reloadnpcs" then

    if userlist(userindex).flags.esrolesmaster then exit sub
    call loggm(userlist(userindex).name, rdata, false)

    call descarganpcsdat
    call carganpcsdat

    call senddata(toindex, userindex, 0, "|| npcs.dat y npcshostiles.dat recargados." & fonttype_info)
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
    if userlist(userindex).name <> "el oso" then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call reiniciarservidor(true)
    exit sub
end if

if ucase$(rdata) = "/autoupdate" then
    if userlist(userindex).name <> "el oso" then exit sub
    call loggm(userlist(userindex).name, rdata, false)
    call senddata(toindex, userindex, 0, "|| tid: " & cstr(reiniciarautoupdate()) & fonttype_info)
    exit sub
end if
exit sub

errorhandler:
 call logerror("handledata. cadori:" & cadenaoriginal & " nom:" & userlist(userindex).name & "ui:" & userindex & " n: " & err.number & " d: " & err.description)
 'resume
 'call closesocket(userindex)
 call cerrar_usuario(userindex)
 
 

end sub

sub reloadsokcet()
debug.print "reloadsocket"

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

'sistema de padrinos, creacion de personajes,
public sub enviarconfigserver(byval userindex as integer)
call senddata(toindex, userindex, 0, "cose" & usandosistemapadrinos & "," & puedecrearpersonajes)

end sub

public sub enviarnoche(byval userindex as integer)

call senddata(toindex, userindex, 0, "noc" & iif(denoche and (mapinfo(userlist(userindex).pos.map).zona = campo or mapinfo(userlist(userindex).pos.map).zona = ciudad), "1", "0"))
call senddata(toindex, userindex, 0, "noc" & iif(denoche, "1", "0"))

end sub

public sub echarpjsnoprivilegiados()
dim loopc as long

for loopc = 1 to lastuser
    if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
        if userlist(loopc).flags.privilegios < 1 then
            call closesocket(loopc)
        end if
    end if
next loopc

end sub

'public sub wrchintentarenviardatosencolados(byval index as integer)
'#if usarquesocket = 0 then
'dim ret as integer, dale as boolean
'
'on local error goto hayerr
'
'do while (userlist(index).colasalida.count > 0)
'    userlist(index).colasalida.remove 1
'loop
'exit sub
'
''if isobject(userlist(index).colasalida) then
'    dale = (userlist(index).colasalida.count > 0)
'    do while dale 'and frmmain.socket2(index).iswritable
'        ret = frmmain.socket2(index).write(userlist(index).colasalida.item(1), len(userlist(index).colasalida.item(1)))
'        if ret < 0 then
'            dale = false
'            if frmmain.socket2(index).lasterror <> wsaewouldblock then
'                call closesocketsl(index)
'                call cerrar_usuario(index)
'            end if
'        else
'            userlist(index).colasalida.remove 1
'            dale = (userlist(index).colasalida.count > 0)
'            debug.print index & ": " & userlist(index).colasalida.item(1)
'            debug.print "desencolado."
'        end if
''        dale = (ret >= 0)
''        if dale then
''            debug.print index & ": " & userlist(index).colasalida.item(1)
''            debug.print "desencolado."
''            userlist(index).colasalida.remove 1
''        end if
'    loop
''end if
'
'exit sub
'hayerr:
'#end if
'end sub
'
'public sub servintentarenviardatosencolados(byval userindex as integer)
'#if usarquesocket = 2 then
'
'dim ret as integer, dale as boolean
'
'on local error goto hayerr
'
'dale = (userlist(userindex).colasalida.count > 0)
'do while dale 'and frmmain.socket2(index).iswritable
'    ret = frmmain.serv.enviar(userlist(userindex).connid, userlist(userindex).colasalida.item(1), len(userlist(userindex).colasalida.item(1)))
'    if ret = 0 then 'todo ok
'        userlist(userindex).colasalida.remove 1
'        dale = (userlist(userindex).colasalida.count > 0)
'    elseif ret = 1 then 'wsaewouldblock
'        dale = false
'    elseif ret = 2 then 'error critico
'        call closesocketsl(userindex)
'        call cerrar_usuario(userindex)
'        dale = false
'    end if
'loop
'
'exit sub
'hayerr:
'
'#end if
'end sub

