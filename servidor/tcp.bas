attribute vb_name = "tcp"
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

sub darcuerpo(byval userindex as integer)
'*************************************************
'author: nacho (integer)
'last modified: 14/03/2007
'elije una cabeza para el usuario y le da un body
'*************************************************
dim newbody as integer
dim userraza as byte
dim usergenero as byte

usergenero = userlist(userindex).genero
userraza = userlist(userindex).raza

select case usergenero
   case egenero.hombre
        select case userraza
            case eraza.humano
                newbody = 1
            case eraza.elfo
                newbody = 2
            case eraza.drow
                newbody = 3
            case eraza.enano
                newbody = 300
            case eraza.gnomo
                newbody = 300
        end select
   case egenero.mujer
        select case userraza
            case eraza.humano
                newbody = 1
            case eraza.elfo
                newbody = 2
            case eraza.drow
                newbody = 3
            case eraza.gnomo
                newbody = 300
            case eraza.enano
                newbody = 300
        end select
end select

userlist(userindex).char.body = newbody
end sub

private function validarcabeza(byval userraza as byte, byval usergenero as byte, byval head as integer) as boolean

select case usergenero
    case egenero.hombre
        select case userraza
            case eraza.humano
                validarcabeza = (head >= humano_h_primer_cabeza and _
                                head <= humano_h_ultima_cabeza)
            case eraza.elfo
                validarcabeza = (head >= elfo_h_primer_cabeza and _
                                head <= elfo_h_ultima_cabeza)
            case eraza.drow
                validarcabeza = (head >= drow_h_primer_cabeza and _
                                head <= drow_h_ultima_cabeza)
            case eraza.enano
                validarcabeza = (head >= enano_h_primer_cabeza and _
                                head <= enano_h_ultima_cabeza)
            case eraza.gnomo
                validarcabeza = (head >= gnomo_h_primer_cabeza and _
                                head <= gnomo_h_ultima_cabeza)
        end select
    
    case egenero.mujer
        select case userraza
            case eraza.humano
                validarcabeza = (head >= humano_m_primer_cabeza and _
                                head <= humano_m_ultima_cabeza)
            case eraza.elfo
                validarcabeza = (head >= elfo_m_primer_cabeza and _
                                head <= elfo_m_ultima_cabeza)
            case eraza.drow
                validarcabeza = (head >= drow_m_primer_cabeza and _
                                head <= drow_m_ultima_cabeza)
            case eraza.enano
                validarcabeza = (head >= enano_m_primer_cabeza and _
                                head <= enano_m_ultima_cabeza)
            case eraza.gnomo
                validarcabeza = (head >= gnomo_m_primer_cabeza and _
                                head <= gnomo_m_ultima_cabeza)
        end select
end select
        
end function

function asciivalidos(byval cad as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim loopc as integer

for loopc = 1 to numskills
    if userlist(userindex).stats.userskills(loopc) < 0 then
        exit function
        if userlist(userindex).stats.userskills(loopc) > 100 then userlist(userindex).stats.userskills(loopc) = 100
    end if
next loopc

validateskills = true
    
end function

sub connectnewuser(byval userindex as integer, byref name as string, byref password as string, byval userraza as eraza, byval usersexo as egenero, byval userclase as eclass, _
                    byref useremail as string, byval hogar as eciudad, byval head as integer)
'*************************************************
'author: unknown
'last modified: 3/12/2009
'conecta un nuevo usuario
'23/01/2007 pablo (toxicwaste) - agregu� resetfaccion al crear usuario
'24/01/2007 pablo (toxicwaste) - agregu� el nuevo mana inicial de los magos.
'12/02/2007 pablo (toxicwaste) - puse + 1 de const al elfo normal.
'20/04/2007 pablo (toxicwaste) - puse -1 de fuerza al elfo.
'09/01/2008 pablo (toxicwaste) - ahora los modificadores de raza se controlan desde balance.dat
'11/19/2009: pato - modifico la man� inicial del bandido.
'11/19/2009: pato - asigno los valores iniciales de expskills y eluskills.
'03/12/2009: budi - optimizaci�n del c�digo.
'*************************************************
dim i as long

with userlist(userindex)

    if not asciivalidos(name) or lenb(name) = 0 then
        call writeerrormsg(userindex, "nombre inv�lido.")
        exit sub
    end if
    
    if userlist(userindex).flags.userlogged then
        call logcheating("el usuario " & userlist(userindex).name & " ha intentado crear a " & name & " desde la ip " & userlist(userindex).ip)
        
        'kick player ( and leave character inside :d )!
        call closesocketsl(userindex)
        call cerrar_usuario(userindex)
        
        exit sub
    end if
    
    '�existe el personaje?
    if fileexist(charpath & ucase$(name) & ".chr", vbnormal) = true then
        call writeerrormsg(userindex, "ya existe el personaje.")
        exit sub
    end if
    
    'tir� los dados antes de llegar ac�??
    if .stats.useratributos(eatributos.fuerza) = 0 then
        call writeerrormsg(userindex, "debe tirar los dados antes de poder crear un personaje.")
        exit sub
    end if
    
    if not validarcabeza(userraza, usersexo, head) then
        call logcheating("el usuario " & name & " ha seleccionado la cabeza " & head & " desde la ip " & .ip)
        
        call writeerrormsg(userindex, "cabeza inv�lida, elija una cabeza seleccionable.")
        exit sub
    end if
    
    .flags.muerto = 0
    .flags.escondido = 0
    
    .reputacion.asesinorep = 0
    .reputacion.bandidorep = 0
    .reputacion.burguesrep = 0
    .reputacion.ladronesrep = 0
    .reputacion.noblerep = 1000
    .reputacion.pleberep = 30
    
    .reputacion.promedio = 30 / 6
    
    
    .name = name
    .clase = userclase
    .raza = userraza
    .genero = usersexo
    .email = useremail
    .hogar = hogar
    
    '[pablo (toxic waste) 9/01/08]
    .stats.useratributos(eatributos.fuerza) = .stats.useratributos(eatributos.fuerza) + modraza(userraza).fuerza
    .stats.useratributos(eatributos.agilidad) = .stats.useratributos(eatributos.agilidad) + modraza(userraza).agilidad
    .stats.useratributos(eatributos.inteligencia) = .stats.useratributos(eatributos.inteligencia) + modraza(userraza).inteligencia
    .stats.useratributos(eatributos.carisma) = .stats.useratributos(eatributos.carisma) + modraza(userraza).carisma
    .stats.useratributos(eatributos.constitucion) = .stats.useratributos(eatributos.constitucion) + modraza(userraza).constitucion
    '[/pablo (toxic waste)]
    
    for i = 1 to numskills
        .stats.userskills(i) = 0
        call checkeluskill(userindex, i, true)
    next i
    
    .stats.skillpts = 10
    
    .char.heading = eheading.south
    
    call darcuerpo(userindex)
    .char.head = head
    
    .origchar = .char
    
    dim miint as long
    miint = randomnumber(1, .stats.useratributos(eatributos.constitucion) \ 3)
    
    .stats.maxhp = 15 + miint
    .stats.minhp = 15 + miint
    
    miint = randomnumber(1, .stats.useratributos(eatributos.agilidad) \ 6)
    if miint = 1 then miint = 2
    
    .stats.maxsta = 20 * miint
    .stats.minsta = 20 * miint
    
    
    .stats.maxagu = 100
    .stats.minagu = 100
    
    .stats.maxham = 100
    .stats.minham = 100
    
    
    '<-----------------mana----------------------->
    if userclase = eclass.mage then 'cambio en mana inicial (toxicwaste)
        miint = .stats.useratributos(eatributos.inteligencia) * 3
        .stats.maxman = miint
        .stats.minman = miint
    elseif userclase = eclass.cleric or userclase = eclass.druid _
        or userclase = eclass.bard or userclase = eclass.assasin then
            .stats.maxman = 50
            .stats.minman = 50
    elseif userclase = eclass.bandit then 'mana inicial del bandido (toxicwaste)
            .stats.maxman = 50
            .stats.minman = 50
    else
        .stats.maxman = 0
        .stats.minman = 0
    end if
    
    if userclase = eclass.mage or userclase = eclass.cleric or _
       userclase = eclass.druid or userclase = eclass.bard or _
       userclase = eclass.assasin then
            .stats.userhechizos(1) = 2
        
            if userclase = eclass.druid then .stats.userhechizos(2) = 46
    end if
    
    .stats.maxhit = 2
    .stats.minhit = 1
    
    .stats.gld = 0
    
    .stats.exp = 0
    .stats.elu = 300
    .stats.elv = 1
    
    '???????????????? inventario ��������������������
    dim slot as byte
    dim ispaladin as boolean
    
    ispaladin = userclase = eclass.paladin
    
    'pociones rojas (newbie)
    slot = 1
    .invent.object(slot).objindex = 857
    .invent.object(slot).amount = 200
    
    'pociones azules (newbie)
    if .stats.maxman > 0 or ispaladin then
        slot = slot + 1
        .invent.object(slot).objindex = 856
        .invent.object(slot).amount = 200
    
    else
        'pociones amarillas (newbie)
        slot = slot + 1
        .invent.object(slot).objindex = 855
        .invent.object(slot).amount = 100
    
        'pociones verdes (newbie)
        slot = slot + 1
        .invent.object(slot).objindex = 858
        .invent.object(slot).amount = 50
    
    end if
    
    ' ropa (newbie)
    slot = slot + 1
    select case userraza
        case eraza.humano
            .invent.object(slot).objindex = 463
        case eraza.elfo
            .invent.object(slot).objindex = 464
        case eraza.drow
            .invent.object(slot).objindex = 465
        case eraza.enano
            .invent.object(slot).objindex = 466
        case eraza.gnomo
            .invent.object(slot).objindex = 466
    end select
    
    ' equipo ropa
    .invent.object(slot).amount = 1
    .invent.object(slot).equipped = 1
    
    .invent.armoureqpslot = slot
    .invent.armoureqpobjindex = .invent.object(slot).objindex

    'arma (newbie)
    slot = slot + 1
    select case userclase
        case eclass.hunter
            ' arco (newbie)
            .invent.object(slot).objindex = 859
        case eclass.worker
            ' herramienta (newbie)
            .invent.object(slot).objindex = randomnumber(561, 565)
        case else
            ' daga (newbie)
            .invent.object(slot).objindex = 460
    end select
    
    ' equipo arma
    .invent.object(slot).amount = 1
    .invent.object(slot).equipped = 1
    
    .invent.weaponeqpobjindex = .invent.object(slot).objindex
    .invent.weaponeqpslot = slot
    
    .char.weaponanim = getweaponanim(userindex, .invent.weaponeqpobjindex)

    ' municiones (newbie)
    if userclase = eclass.hunter then
        slot = slot + 1
        .invent.object(slot).objindex = 860
        .invent.object(slot).amount = 150
        
        ' equipo flechas
        .invent.object(slot).equipped = 1
        .invent.municioneqpslot = slot
        .invent.municioneqpobjindex = 860
    end if

    ' manzanas (newbie)
    slot = slot + 1
    .invent.object(slot).objindex = 467
    .invent.object(slot).amount = 100
    
    ' jugos (nwbie)
    slot = slot + 1
    .invent.object(slot).objindex = 468
    .invent.object(slot).amount = 100
    
    ' sin casco y escudo
    .char.shieldanim = ningunescudo
    .char.cascoanim = ninguncasco
    
    ' total items
    .invent.nroitems = slot
    
    #if conuptime then
        .logontime = now
        .uptime = 0
    #end if

end with

'valores default de facciones al activar nuevo usuario
call resetfacciones(userindex)

call writevar(charpath & ucase$(name) & ".chr", "init", "password", password) 'grabamos el password aqui afuera, para no mantenerlo cargado en memoria

call saveuser(userindex, charpath & ucase$(name) & ".chr")
  
'open user
call connectuser(userindex, name, password)
  
end sub

#if usarquesocket = 1 or usarquesocket = 2 then

sub closesocket(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    with userlist(userindex)
        if userindex = lastuser then
            do until userlist(lastuser).flags.userlogged
                lastuser = lastuser - 1
                if lastuser < 1 then exit do
            loop
        end if
        
        call securityip.iprestarconexion(getlongip(.ip))
        
        if .connid <> -1 then
            call closesocketsl(userindex)
        end if
        
        'es el mismo user al que est� revisando el centinela??
        'importante!!! hacerlo antes de resetear as� todav�a sabemos el nombre del user
        ' y lo podemos loguear
        dim centinelaindex as byte
        centinelaindex = .flags.centinelaindex
        
        if centinelaindex <> 0 then
            call modcentinela.centinelauserlogout(centinelaindex)
        end if
        
        'mato los comercios seguros
        if .comusu.destusu > 0 then
            if userlist(.comusu.destusu).flags.userlogged then
                if userlist(.comusu.destusu).comusu.destusu = userindex then
                    call writeconsolemsg(.comusu.destusu, "comercio cancelado por el otro usuario", fonttypenames.fonttype_talk)
                    call fincomerciarusu(.comusu.destusu)
                    call flushbuffer(.comusu.destusu)
                end if
            end if
        end if
        
        'empty buffer for reuse
        call .incomingdata.readasciistringfixed(.incomingdata.length)
        
        if .flags.userlogged then
            if numusers > 0 then numusers = numusers - 1
            call closeuser(userindex)
            
            call estadisticasweb.informar(cantidad_online, numusers)
        else
            call resetuserslot(userindex)
        end if
        
        .connid = -1
        .connidvalida = false
    end with
exit sub

errhandler:
    userlist(userindex).connid = -1
    userlist(userindex).connidvalida = false
    call resetuserslot(userindex)

    call logerror("closesocket - error = " & err.number & " - descripci�n = " & err.description & " - userindex = " & userindex)
end sub

#elseif usarquesocket = 0 then

sub closesocket(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    
    
    
    userlist(userindex).connid = -1

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
    call resetuserslot(userindex)
end sub


#elseif usarquesocket = 3 then

sub closesocket(byval userindex as integer, optional byval cerrarlo as boolean = true)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
on error goto errhandler

dim nurestados as boolean
dim connectionid as long


    nurestados = false
    connectionid = userlist(userindex).connid
    
    'call logindex(userindex, "******> sub closesocket. connid: " & connectionid & " cerrarlo: " & cerrarlo)
    
    
  
    userlist(userindex).connid = -1 'inabilitamos operaciones en socket

    if userindex = lastuser and lastuser > 1 then
        do
            lastuser = lastuser - 1
            if lastuser <= 1 then exit do
        loop while userlist(lastuser).flags.userlogged = true
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
    call logerror("closesocketerr: " & err.description & " ui:" & userindex)
    
    if not nurestados then
        if userlist(userindex).flags.userlogged then
            if numusers > 0 then
                numusers = numusers - 1
            end if
            call logerror("cerre sin grabar a: " & userlist(userindex).name)
        end if
    end if
    
    call logerror("el usuario no guardado ten�a connid " & connectionid & ". socket no liberado.")
    call resetuserslot(userindex)

end sub


#end if

'[alejo-21-5]: cierra un socket sin limpiar el slot
sub closesocketsl(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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

''
' send an string to a slot
'
' @param userindex the index of the user
' @param datos the string that will be send
' @remarks if usarquesocket is 3 it won`t use the clsbytequeue

public function enviardatosaslot(byval userindex as integer, byref datos as string) as long
'***************************************************
'author: unknown
'last modification: 01/10/07
'last modified by: lucas tavolaro ortiz (tavo)
'now it uses the clsbytequeue class and don`t make a fifo queue of string
'***************************************************

#if usarquesocket = 1 then '**********************************************
    on error goto err
    
    dim ret as long
    
    ret = wsapienviar(userindex, datos)
    
    if ret <> 0 and ret <> wsaewouldblock then
        ' close the socket avoiding any critical error
        call closesocketsl(userindex)
        call cerrar_usuario(userindex)
    end if
exit function
    
err:

#elseif usarquesocket = 0 then '**********************************************
    
    if frmmain.socket2(userindex).write(datos, len(datos)) < 0 then
        if frmmain.socket2(userindex).lasterror = wsaewouldblock then
            ' wsaewouldblock, put the data again in the outgoingdata buffer
            call userlist(userindex).outgoingdata.writeasciistringfixed(datos)
        else
            'close the socket avoiding any critical error
            call cerrar_usuario(userindex)
        end if
    end if
#elseif usarquesocket = 2 then '**********************************************

    'return value for this socket:
    '--0) ok
    '--1) wsaewouldblock
    '--2) error
    
    dim ret as long

    ret = frmmain.serv.enviar(.connid, datos, len(datos))
            
    if ret = 1 then
        ' wsaewouldblock, put the data again in the outgoingdata buffer
        call .outgoingdata.writeasciistringfixed(datos)
    elseif ret = 2 then
        'close socket avoiding any critical error
        call closesocketsl(userindex)
        call cerrar_usuario(userindex)
    end if
    

#elseif usarquesocket = 3 then
    'this socket doesn`t use the byte queue class
    'al carajo, esto encola solo!!! che, me aprobar� los
    'parciales tambi�n?, este control hace todo solo!!!!
    on error goto errorhandler
        
        if userlist(userindex).connid = -1 then
            call logerror("tcp::enviardatosaslot, se intento enviar datos a un userindex con connid=-1")
            exit function
        end if
        
        if frmmain.tcpserv.enviar(userlist(userindex).connid, datos, len(datos)) = 2 then call closesocket(userindex)

exit function
errorhandler:
    call logerror("tcp::enviardatosaslot. ui/connid/datos: " & userindex & "/" & userlist(userindex).connid & "/" & datos)
#end if '**********************************************

end function
function estapcarea(index as integer, index2 as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

validatechr = userlist(userindex).char.head <> 0 _
                and userlist(userindex).char.body <> 0 _
                and validateskills(userindex)

end function

sub connectuser(byval userindex as integer, byref name as string, byref password as string)
'***************************************************
'autor: unknown (orginal version)
'last modification: 24/07/2010 (zama)
'26/03/2009: zama - agrego por default que el color de dialogo de los dioses, sea como el de su nick.
'12/06/2009: zama - agrego chequeo de nivel al loguear
'14/09/2009: zama - ahora el usuario esta protegido del ataque de npcs al loguear
'11/27/2009: budi - se envian los invstats del personaje y su fuerza y agilidad
'03/12/2009: budi - optimizaci�n del c�digo
'24/07/2010: zama - la posicion de comienzo es namehuak, como se habia definido inicialmente.
'***************************************************
dim n as integer
dim tstr as string

with userlist(userindex)

    if .flags.userlogged then
        call logcheating("el usuario " & .name & " ha intentado loguear a " & name & " desde la ip " & .ip)
        'kick player ( and leave character inside :d )!
        call closesocketsl(userindex)
        call cerrar_usuario(userindex)
        exit sub
    end if
    
    'reseteamos los flags
    .flags.escondido = 0
    .flags.targetnpc = 0
    .flags.targetnpctipo = enpctype.comun
    .flags.targetobj = 0
    .flags.targetuser = 0
    .char.fx = 0
    
    'controlamos no pasar el maximo de usuarios
    if numusers >= maxusers then
        call writeerrormsg(userindex, "el servidor ha alcanzado el m�ximo de usuarios soportado, por favor vuelva a intertarlo m�s tarde.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    '�este ip ya esta conectado?
    if allowmultilogins = 0 then
        if checkforsameip(userindex, .ip) = true then
            call writeerrormsg(userindex, "no es posible usar m�s de un personaje al mismo tiempo.")
            call flushbuffer(userindex)
            call closesocket(userindex)
            exit sub
        end if
    end if
    
    '�existe el personaje?
    if not fileexist(charpath & ucase$(name) & ".chr", vbnormal) then
        call writeerrormsg(userindex, "el personaje no existe.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    '�es el passwd valido?
    if ucase$(password) <> ucase$(getvar(charpath & ucase$(name) & ".chr", "init", "password")) then
        call writeerrormsg(userindex, "password incorrecto.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    '�ya esta conectado el personaje?
    if checkforsamename(name) then
        if userlist(nameindex(name)).counters.saliendo then
            call writeerrormsg(userindex, "el usuario est� saliendo.")
        else
            call writeerrormsg(userindex, "perd�n, un usuario con el mismo nombre se ha logueado.")
        end if
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    'reseteamos los privilegios
    .flags.privilegios = 0
    
    'vemos que clase de user es (se lo usa para setear los privilegios al loguear el pj)
    if esadmin(name) then
        .flags.privilegios = .flags.privilegios or playertype.admin
        call loggm(name, "se conecto con ip:" & .ip)
    elseif esdios(name) then
        .flags.privilegios = .flags.privilegios or playertype.dios
        call loggm(name, "se conecto con ip:" & .ip)
    elseif essemidios(name) then
        .flags.privilegios = .flags.privilegios or playertype.semidios
        
        .flags.privespecial = esgmespecial(name)
        
        call loggm(name, "se conecto con ip:" & .ip)
    elseif esconsejero(name) then
        .flags.privilegios = .flags.privilegios or playertype.consejero
        call loggm(name, "se conecto con ip:" & .ip)
    else
        .flags.privilegios = .flags.privilegios or playertype.user
        .flags.adminperseguible = true
    end if
    
    'add rm flag if needed
    if esrolesmaster(name) then
        .flags.privilegios = .flags.privilegios or playertype.rolemaster
    end if
    
    if serversologms > 0 then
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero)) = 0 then
            call writeerrormsg(userindex, "servidor restringido a administradores. por favor reintente en unos momentos.")
            call flushbuffer(userindex)
            call closesocket(userindex)
            exit sub
        end if
    end if
    
    'cargamos el personaje
    dim leer as clsinimanager
    set leer = new clsinimanager
    
    call leer.initialize(charpath & ucase$(name) & ".chr")
    
    'cargamos los datos del personaje
    call loaduserinit(userindex, leer)
    
    call loaduserstats(userindex, leer)
    
    if not validatechr(userindex) then
        call writeerrormsg(userindex, "error en el personaje.")
        call closesocket(userindex)
        exit sub
    end if
    
    call loaduserreputacion(userindex, leer)
    
    set leer = nothing
    
    if .invent.escudoeqpslot = 0 then .char.shieldanim = ningunescudo
    if .invent.cascoeqpslot = 0 then .char.cascoanim = ninguncasco
    if .invent.weaponeqpslot = 0 then .char.weaponanim = ningunarma
    
    if .invent.mochilaeqpslot > 0 then
        .currentinventoryslots = max_normal_inventory_slots + objdata(.invent.object(.invent.mochilaeqpslot).objindex).mochilatype * 5
    else
        .currentinventoryslots = max_normal_inventory_slots
    end if
    if (.flags.muerto = 0) then
        .flags.seguroresu = false
        call writemultimessage(userindex, emessages.resuscitationsafeoff)
    else
        .flags.seguroresu = true
        call writemultimessage(userindex, emessages.resuscitationsafeon)
    end if
    
    call updateuserinv(true, userindex, 0)
    call updateuserhechizos(true, userindex, 0)
    
    if .flags.paralizado then
        call writeparalizeok(userindex)
    end if
    
    dim mapa as integer
    mapa = .pos.map
    
    'posicion de comienzo
    if mapa = 0 then
        .pos = nemahuak
        mapa = nemahuak.map
    else
    
        if not mapavalido(mapa) then
            call writeerrormsg(userindex, "el pj se encuenta en un mapa inv�lido.")
            call closesocket(userindex)
            exit sub
        end if
        
        ' if map has different initial coords, update it
        dim startmap as integer
        startmap = mapinfo(mapa).startpos.map
        if startmap <> 0 then
            if mapavalido(startmap) then
                .pos = mapinfo(mapa).startpos
                mapa = startmap
            end if
        end if
        
    end if
    
    'tratamos de evitar en lo posible el "telefrag". solo 1 intento de loguear en pos adjacentes.
    'codigo por pablo (toxicwaste) y revisado por nacho (integer), corregido para que realmetne ande y no tire el server por juan mart�n sotuyo dodero (maraxus)
    if mapdata(mapa, .pos.x, .pos.y).userindex <> 0 or mapdata(mapa, .pos.x, .pos.y).npcindex <> 0 then
        dim foundplace as boolean
        dim esagua as boolean
        dim tx as long
        dim ty as long
        
        foundplace = false
        esagua = hayagua(mapa, .pos.x, .pos.y)
        
        for ty = .pos.y - 1 to .pos.y + 1
            for tx = .pos.x - 1 to .pos.x + 1
                if esagua then
                    'reviso que sea pos legal en agua, que no haya user ni npc para poder loguear.
                    if legalpos(mapa, tx, ty, true, false) then
                        foundplace = true
                        exit for
                    end if
                else
                    'reviso que sea pos legal en tierra, que no haya user ni npc para poder loguear.
                    if legalpos(mapa, tx, ty, false, true) then
                        foundplace = true
                        exit for
                    end if
                end if
            next tx
            
            if foundplace then _
                exit for
        next ty
        
        if foundplace then 'si encontramos un lugar, listo, nos quedamos ahi
            .pos.x = tx
            .pos.y = ty
        else
            'si no encontramos un lugar, sacamos al usuario que tenemos abajo, y si es un npc, lo pisamos.
            if mapdata(mapa, .pos.x, .pos.y).userindex <> 0 then
               'si no encontramos lugar, y abajo teniamos a un usuario, lo pisamos y cerramos su comercio seguro
                if userlist(mapdata(mapa, .pos.x, .pos.y).userindex).comusu.destusu > 0 then
                    'le avisamos al que estaba comerciando que se tuvo que ir.
                    if userlist(userlist(mapdata(mapa, .pos.x, .pos.y).userindex).comusu.destusu).flags.userlogged then
                        call fincomerciarusu(userlist(mapdata(mapa, .pos.x, .pos.y).userindex).comusu.destusu)
                        call writeconsolemsg(userlist(mapdata(mapa, .pos.x, .pos.y).userindex).comusu.destusu, "comercio cancelado. el otro usuario se ha desconectado.", fonttypenames.fonttype_talk)
                        call flushbuffer(userlist(mapdata(mapa, .pos.x, .pos.y).userindex).comusu.destusu)
                    end if
                    'lo sacamos.
                    if userlist(mapdata(mapa, .pos.x, .pos.y).userindex).flags.userlogged then
                        call fincomerciarusu(mapdata(mapa, .pos.x, .pos.y).userindex)
                        call writeerrormsg(mapdata(mapa, .pos.x, .pos.y).userindex, "alguien se ha conectado donde te encontrabas, por favor recon�ctate...")
                        call flushbuffer(mapdata(mapa, .pos.x, .pos.y).userindex)
                    end if
                end if
                
                call closesocket(mapdata(mapa, .pos.x, .pos.y).userindex)
            end if
        end if
    end if
    
    'nombre de sistema
    .name = name
    
    .showname = true 'por default los nombres son visibles
    
    'if in the water, and has a boat, equip it!
    if .invent.barcoobjindex > 0 and _
            (hayagua(mapa, .pos.x, .pos.y) or bodyisboat(.char.body)) then

        .char.head = 0
        if .flags.muerto = 0 then
            call toggleboatbody(userindex)
        else
            .char.body = ifragatafantasmal
            .char.shieldanim = ningunescudo
            .char.weaponanim = ningunarma
            .char.cascoanim = ninguncasco
        end if
        
        .flags.navegando = 1
    end if
    
    
    'info
    call writeuserindexinserver(userindex) 'enviamos el user index
    call writechangemap(userindex, .pos.map, mapinfo(.pos.map).mapversion) 'carga el mapa
    call writeplaymidi(userindex, val(readfield(1, mapinfo(.pos.map).music, 45)))
    
    if .flags.privilegios = playertype.dios then
        .flags.chatcolor = rgb(250, 250, 150)
    elseif .flags.privilegios <> playertype.user and .flags.privilegios <> (playertype.user or playertype.chaoscouncil) and .flags.privilegios <> (playertype.user or playertype.royalcouncil) then
        .flags.chatcolor = rgb(0, 255, 0)
    elseif .flags.privilegios = (playertype.user or playertype.royalcouncil) then
        .flags.chatcolor = rgb(0, 255, 255)
    elseif .flags.privilegios = (playertype.user or playertype.chaoscouncil) then
        .flags.chatcolor = rgb(255, 128, 64)
    else
        .flags.chatcolor = vbwhite
    end if
    
    
    ''[el oso]: traigo esto aca arriba para darle el ip!
    #if conuptime then
        .logontime = now
    #end if
    
    'crea  el personaje del usuario
    call makeuserchar(true, .pos.map, userindex, .pos.map, .pos.x, .pos.y)
    
    if (.flags.privilegios and (playertype.user or playertype.rolemaster)) = 0 then
        call doadmininvisible(userindex)
        .flags.senddenounces = true
    end if
    
    call writeusercharindexinserver(userindex)
    ''[/el oso]
    
    call dotileevents(userindex, .pos.map, .pos.x, .pos.y)
    
    call checkuserlevel(userindex)
    call writeupdateuserstats(userindex)
    
    call writeupdatehungerandthirst(userindex)
    call writeupdatestrenghtanddexterity(userindex)
        
    call sendmotd(userindex)
    
    if haciendobk then
        call writepausetoggle(userindex)
        call writeconsolemsg(userindex, "servidor> por favor espera algunos segundos, el worldsave est� ejecut�ndose.", fonttypenames.fonttype_server)
    end if
    
    if enpausa then
        call writepausetoggle(userindex)
        call writeconsolemsg(userindex, "servidor> lo sentimos mucho pero el servidor se encuentra actualmente detenido. intenta ingresar m�s tarde.", fonttypenames.fonttype_server)
    end if
    
    if entesting and .stats.elv >= 18 then
        call writeerrormsg(userindex, "servidor en testing por unos minutos, conectese con pjs de nivel menor a 18. no se conecte con pjs que puedan resultar importantes por ahora pues pueden arruinarse.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    'actualiza el num de usuarios
    'de aca en adelante graba el charfile, ojo!
    numusers = numusers + 1
    .flags.userlogged = true
    
    'usado para borrar pjs
    call writevar(charpath & .name & ".chr", "init", "logged", "1")
    
    call estadisticasweb.informar(cantidad_online, numusers)
    
    mapinfo(.pos.map).numusers = mapinfo(.pos.map).numusers + 1
    
    if .stats.skillpts > 0 then
        call writesendskills(userindex)
        call writelevelup(userindex, .stats.skillpts)
    end if
    
    if numusers > recordusuarios then
        call senddata(sendtarget.toall, 0, preparemessageconsolemsg("record de usuarios conectados simultaneamente." & "hay " & numusers & " usuarios.", fonttypenames.fonttype_info))
        recordusuarios = numusers
        call writevar(inipath & "server.ini", "init", "record", str(recordusuarios))
        
        call estadisticasweb.informar(record_usuarios, recordusuarios)
    end if
    
    if .nromascotas > 0 and mapinfo(.pos.map).pk then
        dim i as integer
        for i = 1 to maxmascotas
            if .mascotastype(i) > 0 then
                .mascotasindex(i) = spawnnpc(.mascotastype(i), .pos, true, true)
                
                if .mascotasindex(i) > 0 then
                    npclist(.mascotasindex(i)).maestrouser = userindex
                    call followamo(.mascotasindex(i))
                else
                    .mascotasindex(i) = 0
                end if
            end if
        next i
    end if
    
    if .flags.navegando = 1 then
        call writenavigatetoggle(userindex)
    end if
    
    if criminal(userindex) then
        call writemultimessage(userindex, emessages.safemodeoff) 'call writesafemodeoff(userindex)
        .flags.seguro = false
    else
        .flags.seguro = true
        call writemultimessage(userindex, emessages.safemodeon) 'call writesafemodeon(userindex)
    end if
    
    if .guildindex > 0 then
        'welcome to the show baby...
        if not modguilds.m_conectarmiembroaclan(userindex, .guildindex) then
            call writeconsolemsg(userindex, "tu estado no te permite entrar al clan.", fonttypenames.fonttype_guild)
        end if
    end if
    
    call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, fxids.fxwarp, 0))
    
    call writeloggedmessage(userindex)
    
    call modguilds.sendguildnews(userindex)
    
    ' esta protegido del ataque de npcs por 5 segundos, si no realiza ninguna accion
    call intervalopermiteseratacado(userindex, true)
    
    if lloviendo then
        call writeraintoggle(userindex)
    end if
    
    tstr = modguilds.a_obtenerrechazodechar(.name)
    
    if lenb(tstr) <> 0 then
        call writeshowmessagebox(userindex, "tu solicitud de ingreso al clan ha sido rechazada. el clan te explica que: " & tstr)
    end if
    
    'load the user statistics
    call statistics.userconnected(userindex)
    
    call mostrarnumusers
    
    #if seguridadalkon then
        call security.userconnected(userindex)
    #end if

    n = freefile
    open app.path & "\logs\numusers.log" for output as n
    print #n, numusers
    close #n
    
    n = freefile
    'log
    open app.path & "\logs\connect.log" for append shared as #n
    print #n, .name & " ha entrado al juego. userindex:" & userindex & " " & time & " " & date
    close #n

end with
end sub

sub sendmotd(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim j as long
    
    call writeguildchat(userindex, "mensajes de entrada:")
    for j = 1 to maxlines
        call writeguildchat(userindex, motd(j).texto)
    next j
end sub

sub resetfacciones(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 23/01/2007
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'23/01/2007 pablo (toxicwaste) - agrego nivelingreso, fechaingreso, matadosingreso y nextrecompensa.
'*************************************************
    with userlist(userindex).faccion
        .armadareal = 0
        .ciudadanosmatados = 0
        .criminalesmatados = 0
        .fuerzascaos = 0
        .fechaingreso = "no ingres� a ninguna facci�n"
        .recibioarmaduracaos = 0
        .recibioarmadurareal = 0
        .recibioexpinicialcaos = 0
        .recibioexpinicialreal = 0
        .recompensascaos = 0
        .recompensasreal = 0
        .reenlistadas = 0
        .nivelingreso = 0
        .matadosingreso = 0
        .nextrecompensa = 0
    end with
end sub

sub resetcontadores(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 10/07/2010
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'05/20/2007 integer - agregue todas las variables que faltaban.
'10/07/2010: zama - agrego los counters que faltaban.
'*************************************************
    with userlist(userindex).counters
        .aguacounter = 0
        .asignedskills = 0
        .attackcounter = 0
        .bpuedemeditar = true
        .ceguera = 0
        .comcounter = 0
        .estupidez = 0
        .failedusageattempts = 0
        .frio = 0
        .gohome = 0
        .hpcounter = 0
        .idlecount = 0
        .invisibilidad = 0
        .lava = 0
        .mimetismo = 0
        .ocultando = 0
        .paralisis = 0
        .pena = 0
        .piquetec = 0
        .saliendo = false
        .salir = 0
        .stacounter = 0
        .tiempooculto = 0
        .timerestadoatacable = 0
        .timergolpemagia = 0
        .timergolpeusar = 0
        .timerlanzarspell = 0
        .timermagiagolpe = 0
        .timerpertenecenpc = 0
        .timerpuedeatacar = 0
        .timerpuedeseratacado = 0
        .timerpuedetrabajar = 0
        .timerpuedeusararco = 0
        .timerusar = 0
        .trabajando = 0
        .veneno = 0
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
        .name = vbnullstring
        .desc = vbnullstring
        .descrm = vbnullstring
        .pos.map = 0
        .pos.x = 0
        .pos.y = 0
        .ip = vbnullstring
        .clase = 0
        .email = vbnullstring
        .genero = 0
        .hogar = 0
        .raza = 0
        
        .partyindex = 0
        .partysolicitud = 0
        
        with .stats
            .banco = 0
            .elv = 0
            .elu = 0
            .exp = 0
            .def = 0
            '.criminalesmatados = 0
            .npcsmuertos = 0
            .usuariosmatados = 0
            .skillpts = 0
            .gld = 0
            .useratributos(1) = 0
            .useratributos(2) = 0
            .useratributos(3) = 0
            .useratributos(4) = 0
            .useratributos(5) = 0
            .useratributosbackup(1) = 0
            .useratributosbackup(2) = 0
            .useratributosbackup(3) = 0
            .useratributosbackup(4) = 0
            .useratributosbackup(5) = 0
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'last modified: 06/28/2008
'resetea todos los valores generales y las stats
'03/15/2006 maraxus - uso de with para mayor performance y claridad.
'03/29/2006 maraxus - reseteo el centinelaok tambi�n.
'06/28/2008 niconz - agrego el flag inmovilizado
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
        .descuento = vbnullstring
        .hambre = 0
        .sed = 0
        .descansar = false
        .vuela = 0
        .navegando = 0
        .oculto = 0
        .envenenado = 0
        .invisible = 0
        .paralizado = 0
        .inmovilizado = 0
        .maldicion = 0
        .bendicion = 0
        .meditando = 0
        .privilegios = 0
        .privespecial = false
        .puedemoverse = 0
        .oldbody = 0
        .oldhead = 0
        .admininvisible = 0
        .valcode = 0
        .hechizo = 0
        .timeswalk = 0
        .startwalk = 0
        .countsh = 0
        .silenciado = 0
        .centinelaok = false
        .centinelaindex = 0
        .adminperseguible = false
        .lastmap = 0
        .traveling = 0
        .atacablepor = 0
        .atacadopornpc = 0
        .atacadoporuser = 0
        .nopuedeseratacado = false
        .sharenpcwith = 0
        .enconsulta = false
        .ignorado = false
        .senddenounces = false
        .paralizedby = vbnullstring
        .paralizedbyindex = 0
        .paralizedbynpcindex = 0
        
        if .ownednpc <> 0 then
            call perdionpc(userindex)
        end if
        
    end with
    
    
    
end sub

sub resetuserspells(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim loopc as long
    for loopc = 1 to maxuserhechizos
        userlist(userindex).stats.userhechizos(loopc) = 0
    next loopc
end sub

sub resetuserpets(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim loopc as long
    
    userlist(userindex).nromascotas = 0
        
    for loopc = 1 to maxmascotas
        userlist(userindex).mascotasindex(loopc) = 0
        userlist(userindex).mascotastype(loopc) = 0
    next loopc
end sub

sub resetuserbanco(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim loopc as long
    
    for loopc = 1 to max_bancoinventory_slots
          userlist(userindex).bancoinvent.object(loopc).amount = 0
          userlist(userindex).bancoinvent.object(loopc).equipped = 0
          userlist(userindex).bancoinvent.object(loopc).objindex = 0
    next loopc
    
    userlist(userindex).bancoinvent.nroitems = 0
end sub

public sub limpiarcomercioseguro(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with userlist(userindex).comusu
        if .destusu > 0 then
            call fincomerciarusu(.destusu)
            call fincomerciarusu(userindex)
        end if
    end with
end sub

sub resetuserslot(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i as long

userlist(userindex).connidvalida = false
userlist(userindex).connid = -1

call limpiarcomercioseguro(userindex)
call resetfacciones(userindex)
call resetcontadores(userindex)
call resetguildinfo(userindex)
call resetcharinfo(userindex)
call resetbasicuserinfo(userindex)
call resetreputacion(userindex)
call resetuserflags(userindex)
call limpiarinventario(userindex)
call resetuserspells(userindex)
call resetuserpets(userindex)
call resetuserbanco(userindex)

with userlist(userindex).comusu
    .acepto = false
    
    for i = 1 to max_offer_slots
        .cant(i) = 0
        .objeto(i) = 0
    next i
    
    .goldamount = 0
    .destnick = vbnullstring
    .destusu = 0
end with
 
end sub

sub closeuser(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

dim n as integer
dim map as integer
dim name as string
dim i as integer

dim an as integer

with userlist(userindex)
    an = .flags.atacadopornpc
    if an > 0 then
          npclist(an).movement = npclist(an).flags.oldmovement
          npclist(an).hostile = npclist(an).flags.oldhostil
          npclist(an).flags.attackedby = vbnullstring
    end if
    
    an = .flags.npcatacado
    if an > 0 then
        if npclist(an).flags.attackedfirstby = .name then
            npclist(an).flags.attackedfirstby = vbnullstring
        end if
    end if
    .flags.atacadopornpc = 0
    .flags.npcatacado = 0
    
    map = .pos.map
    name = ucase$(.name)
    
    .char.fx = 0
    .char.loops = 0
    call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, 0, 0))
    
    .flags.userlogged = false
    .counters.saliendo = false
    
    'le devolvemos el body y head originales
    if .flags.admininvisible = 1 then
        .char.body = .flags.oldbody
        .char.head = .flags.oldhead
        .flags.admininvisible = 0
    end if
    
    'si esta en party le devolvemos la experiencia
    if .partyindex > 0 then call mdparty.salirdeparty(userindex)
    
    'save statistics
    call statistics.userdisconnected(userindex)
    
    ' grabamos el personaje del usuario
    call saveuser(userindex, charpath & name & ".chr")
    
    'usado para borrar pjs
    call writevar(charpath & .name & ".chr", "init", "logged", "0")
    
    'quitar el dialogo
    'if mapinfo(map).numusers > 0 then
    '    call sendtouserarea(userindex, "qdl" & .char.charindex)
    'end if
    
    if mapinfo(map).numusers > 0 then
        call senddata(sendtarget.topcareabutindex, userindex, preparemessageremovechardialog(.char.charindex))
    end if
    
    'borrar el personaje
    if .char.charindex > 0 then
        call eraseuserchar(userindex, .flags.admininvisible = 1)
    end if
    
    'borrar mascotas
    for i = 1 to maxmascotas
        if .mascotasindex(i) > 0 then
            if npclist(.mascotasindex(i)).flags.npcactive then _
                call quitarnpc(.mascotasindex(i))
        end if
    next i
    
    'update map users
    mapinfo(map).numusers = mapinfo(map).numusers - 1
    
    if mapinfo(map).numusers < 0 then
        mapinfo(map).numusers = 0
    end if
    
    ' si el usuario habia dejado un msg en la gm's queue lo borramos
    if ayuda.existe(.name) then call ayuda.quitar(.name)
    
    call resetuserslot(userindex)
    
    call mostrarnumusers
    
    n = freefile(1)
    open app.path & "\logs\connect.log" for append shared as #n
        print #n, name & " ha dejado el juego. " & "user index:" & userindex & " " & time & " " & date
    close #n
end with

exit sub

errhandler:
call logerror("error en closeuser. n�mero " & err.number & " descripci�n: " & err.description)

end sub

sub reloadsokcet()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    call writesendnight(userindex, iif(denoche and (mapinfo(userlist(userindex).pos.map).zona = campo or mapinfo(userlist(userindex).pos.map).zona = ciudad), true, false))
    call writesendnight(userindex, iif(denoche, true, false))
end sub

public sub echarpjsnoprivilegiados()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim loopc as long
    
    for loopc = 1 to lastuser
        if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
            if userlist(loopc).flags.privilegios and playertype.user then
                call closesocket(loopc)
            end if
        end if
    next loopc

end sub
