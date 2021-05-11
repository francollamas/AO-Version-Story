attribute vb_name = "mdparty"
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




'modulo de parties
'por el oso (ositear@yahoo.com.ar)



option explicit

public const max_parties = 300
'cantidad maxima de parties en el servidor

public const minpartylevel = 15
'nivel minimo para crear party

public const party_maxmembers = 5
'cantidad maxima de gente en la party

public const party_experienciaporgolpe = false
'si esto esta en true, la exp sale por cada golpe que le da
'si no, la exp la recibe al salirse de la party (pq las partys, floodean)

public const maxpartydeltalevel = 7
'maxima diferencia de niveles permitida en una party

public const maxdistanciaingresoparty = 2
'distancia al leader para que este acepte el ingreso

public const party_maxdistancia = 18
'maxima distancia a un exito para obtener su experiencia

'restan las muertes de los miembros?
public const castigos = false

public type tpartymember
    userindex as integer
    experiencia as long
end type

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'soportes para las parties
'(ver este modulo como una clase abstracta "partymanager")
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

public function nextparty() as integer
dim i as integer
nextparty = -1
for i = 1 to max_parties
    if parties(i) is nothing then
        nextparty = i
        exit function
    end if
next i
end function

public function puedecrearparty(byval userindex as integer) as boolean
    puedecrearparty = true
'    if userlist(userindex).stats.elv < minpartylevel then
    if userlist(userindex).stats.useratributos(carisma) * userlist(userindex).stats.userskills(liderazgo) < 100 then
        call senddata(toindex, userindex, 0, "|| tu carisma y liderazgo no son suficientes para liderar una party." & fonttype_party)
        puedecrearparty = false
    elseif userlist(userindex).flags.muerto = 1 then
        call senddata(toindex, userindex, 0, "|| est�s muerto!" & fonttype_party)
        puedecrearparty = false
    end if
end function

public sub crearparty(byval userindex as integer)
dim tint as integer
if userlist(userindex).partyindex = 0 then
    if userlist(userindex).flags.muerto = 0 then
        if userlist(userindex).stats.userskills(liderazgo) >= 5 then
            tint = mdparty.nextparty
            if tint = -1 then
                call senddata(toindex, userindex, 0, "|| por el momento no se pueden crear mas parties" & fonttype_party)
                exit sub
            else
                set parties(tint) = new clsparty
                if not parties(tint).nuevomiembro(userindex) then
                    call senddata(toindex, userindex, 0, "|| la party est� llena, no puedes entrar" & fonttype_party)
                    set parties(tint) = nothing
                    exit sub
                else
                    call senddata(toindex, userindex, 0, "|| � has formado una party !" & fonttype_party)
                    userlist(userindex).partyindex = tint
                    userlist(userindex).partysolicitud = 0
                    if not parties(tint).hacerleader(userindex) then
                        call senddata(toindex, userindex, 0, "|| no puedes hacerte l�der." & fonttype_party)
                    else
                        call senddata(toindex, userindex, 0, "|| � te has convertido en l�der de la party !" & fonttype_party)
                    end if
                end if
            end if
        else
            call senddata(toindex, userindex, 0, "|| no tienes suficientes puntos de liderazgo para liderar una party." & fonttype_party)
        end if
    else
        call senddata(toindex, userindex, 0, "|| est�s muerto!" & fonttype_party)
    end if
else
    call senddata(toindex, userindex, 0, "|| ya perteneces a una party." & fonttype_party)
end if
end sub

public sub solicitaringresoaparty(byval userindex as integer)
'esto es enviado por el pj para solicitar el ingreso a la party
dim tint as integer

    if userlist(userindex).partyindex > 0 then
        'si ya esta en una party
        call senddata(toindex, userindex, 0, "|| ya perteneces a una party, escribe /salirparty para abandonarla" & fonttype_party)
        userlist(userindex).partysolicitud = 0
        exit sub
    end if
    if userlist(userindex).flags.muerto = 1 then
        call senddata(toindex, userindex, 0, "|| �est�s muerto!" & fonttype_info)
        userlist(userindex).partysolicitud = 0
        exit sub
    end if
    tint = userlist(userindex).flags.targetuser
    if tint > 0 then
        if userlist(tint).partyindex > 0 then
            userlist(userindex).partysolicitud = userlist(tint).partyindex
            call senddata(toindex, userindex, 0, "|| el fundador decidir� si te acepta en la party" & fonttype_party)
        else
            call senddata(toindex, userindex, 0, "|| " & userlist(tint).name & " no es fundador de ninguna party." & fonttype_info)
            userlist(userindex).partysolicitud = 0
            exit sub
        end if
    else
        call senddata(toindex, userindex, 0, "|| para ingresar a una party debes hacer click sobre el fundador y luego escribir /party" & fonttype_party)
        userlist(userindex).partysolicitud = 0
    end if

end sub
public sub salirdeparty(byval userindex as integer)
dim pi as integer
pi = userlist(userindex).partyindex
if pi > 0 then
    if parties(pi).salemiembro(userindex) then
        'sale el leader
        set parties(pi) = nothing
    else
        userlist(userindex).partyindex = 0
    end if
else
    call senddata(toindex, userindex, 0, "|| no eres miembro de ninguna party." & fonttype_info)
end if

end sub


public sub expulsardeparty(byval leader as integer, byval oldmember as integer)
dim pi as integer
dim razon as string
pi = userlist(leader).partyindex
if pi > 0 then
    if pi = userlist(oldmember).partyindex then
        if parties(pi).espartyleader(leader) then
            if parties(pi).salemiembro(oldmember) then
                'si la funcion me da true, entonces la party se disolvio
                'y los partyindex fueron reseteados a 0
                set parties(pi) = nothing
            else
                userlist(oldmember).partyindex = 0
            end if
        else
            call senddata(toindex, leader, 0, "|| solo el fundador puede expulsar miembros de una party." & fonttype_info)
        end if
    else
        call senddata(toindex, leader, 0, "|| " & userlist(oldmember).name & " no pertenece a tu party." & fonttype_info)
    end if
else
    call senddata(toindex, leader, 0, "|| no eres miembro de ninguna party." & fonttype_info)
end if



end sub


public sub aprobaringresoaparty(byval leader as integer, byval newmember as integer)
'el ui es el leader
dim pi as integer
dim razon as string

pi = userlist(leader).partyindex

if pi > 0 then
    if parties(pi).espartyleader(leader) then
        if userlist(newmember).partyindex = 0 then
            if not userlist(leader).flags.muerto = 1 then
                if not userlist(newmember).flags.muerto = 1 then
                    if userlist(newmember).partysolicitud = pi then
                        if parties(pi).puedeentrar(newmember, razon) then
                            if parties(pi).nuevomiembro(newmember) then
                                call parties(pi).mandarmensajeaconsola(userlist(leader).name & " ha aceptado a " & userlist(newmember).name & " en la party.", "servidor")
                                userlist(newmember).partyindex = pi
                                userlist(newmember).partysolicitud = 0
                            else
                                'no pudo entrar
                                'aca uno puede codificar otro tipo de errores...
                                call senddata(toadmins, leader, 0, "|| servidor> catastrofe en parties, nuevomiembro dio false! :s " & fonttype_party)
                            end if
                        else
                            'no debe entrar
                            call senddata(toindex, leader, 0, "|| " & razon & fonttype_party)
                        end if
                    else
                        call senddata(toindex, leader, 0, "|| " & userlist(newmember).name & " no ha solicitado ingresar a tu party." & fonttype_party)
                        exit sub
                    end if
                else
                    call senddata(toindex, leader, 0, "|| �est� muerto, no puedes aceptar miembros en ese estado!" & fonttype_party)
                    exit sub
                end if
            else
                call senddata(toindex, leader, 0, "|| �est�s muerto, no puedes aceptar miembros en ese estado!" & fonttype_party)
                exit sub
            end if
        else
            call senddata(toindex, leader, 0, "||" & userlist(newmember).name & " ya es miembro de otra party." & fonttype_party)
            ' ya tiene party el otro tipo
        end if
    else
        call senddata(toindex, leader, 0, "|| no eres l�der, no puedes aceptar miembros." & fonttype_party)
        exit sub
    end if
else
    call senddata(toindex, leader, 0, "|| no eres miembro de ninguna party." & fonttype_info)
    exit sub
end if

end sub

public sub broadcastparty(byval userindex as integer, byref texto as string)
dim pi as integer
    
    pi = userlist(userindex).partyindex
    
    if pi > 0 then
        call parties(pi).mandarmensajeaconsola(texto, userlist(userindex).name)
    end if

end sub

public sub onlineparty(byval userindex as integer)
dim pi as integer
dim texto as string

    pi = userlist(userindex).partyindex
    
    if pi > 0 then
        call parties(pi).obtenermiembrosonline(texto)
        call senddata(toindex, userindex, 0, "||" & texto & fonttype_party)
    end if
    

end sub


public sub transformarenlider(byval oldleader as integer, byval newleader as integer)
dim pi as integer

if oldleader = newleader then exit sub

pi = userlist(oldleader).partyindex

if pi > 0 then
    if pi = userlist(newleader).partyindex then
        if userlist(newleader).flags.muerto = 0 then
            if parties(pi).espartyleader(oldleader) then
                if parties(pi).hacerleader(newleader) then
                    call parties(pi).mandarmensajeaconsola("el nuevo l�der de la party es " & userlist(newleader).name, userlist(oldleader).name)
                else
                    call senddata(toindex, oldleader, 0, "||�no se ha hecho el cambio de mando!" & fonttype_party)
                end if
            else
                call senddata(toindex, oldleader, 0, "||�no eres el l�der!" & fonttype_party)
            end if
        else
            call senddata(toindex, oldleader, 0, "||�est� muerto!" & fonttype_info)
        end if
    else
        call senddata(toindex, oldleader, 0, "||" & userlist(newleader).name & " no pertenece a tu party." & fonttype_info)
    end if
end if

end sub


public sub actualizaexperiencias()
'esta funcion se invoca antes de worlsaves, y apagar servidores
'en caso que la experiencia sea acumulada y no por golpe
'para que grabe los datos en los charfiles
dim i as integer

if not party_experienciaporgolpe then
    
    haciendobk = true
    call senddata(toall, 0, 0, "bkw")
    
    call senddata(toall, 0, 0, "||servidor> distribuyendo experiencia en parties." & fonttype_server)
    for i = 1 to max_parties
        if not parties(i) is nothing then
            call parties(i).flushexperiencia
        end if
    next i
    call senddata(toall, 0, 0, "||servidor> experiencia distribuida." & fonttype_server)
    call senddata(toall, 0, 0, "bkw")
    haciendobk = false

end if

end sub

public sub obtenerexito(byval userindex as integer, byval exp as long, mapa as integer, x as integer, y as integer)
    if exp <= 0 then
        if not castigos then exit sub
    end if
    
    call parties(userlist(userindex).partyindex).obtenerexito(exp, mapa, x, y)


end sub

public function cantmiembros(byval userindex as integer) as integer
cantmiembros = 0
if userlist(userindex).partyindex > 0 then
    cantmiembros = parties(userlist(userindex).partyindex).cantmiembros
end if

end function
