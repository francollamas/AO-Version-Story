attribute vb_name = "mdparty"
'**************************************************************
' mdparty.bas - library of functions to manipulate parties.
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
' soportes para las parties
' (ver este modulo como una clase abstracta "partymanager")
'


''
'cantidad maxima de parties en el servidor
public const max_parties as integer = 300

''
'nivel minimo para crear party
public const minpartylevel as byte = 15

''
'cantidad maxima de gente en la party
public const party_maxmembers as byte = 5

''
'si esto esta en true, la exp sale por cada golpe que le da
'si no, la exp la recibe al salirse de la party (pq las partys, floodean)
public const party_experienciaporgolpe as boolean = false

''
'maxima diferencia de niveles permitida en una party
public const maxpartydeltalevel as byte = 7

''
'distancia al leader para que este acepte el ingreso
public const maxdistanciaingresoparty as byte = 2

''
'maxima distancia a un exito para obtener su experiencia
public const party_maxdistancia as byte = 18

''
'restan las muertes de los miembros?
public const castigos as boolean = false

''
'numero al que elevamos el nivel de cada miembro de la party
'esto es usado para calcular la distribuci�n de la experiencia entre los miembros
'se lee del archivo de balance
public exponentenivelparty as single

''
'tpartymember
'
' @param userindex userindex
' @param experiencia experiencia
'
public type tpartymember
    userindex as integer
    experiencia as double
end type


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
    
    if cint(userlist(userindex).stats.useratributos(eatributos.carisma)) * userlist(userindex).stats.userskills(eskill.liderazgo) < 100 then
        call writeconsolemsg(userindex, "tu carisma y liderazgo no son suficientes para liderar una party.", fonttypenames.fonttype_party)
        puedecrearparty = false
    elseif userlist(userindex).flags.muerto = 1 then
        call writeconsolemsg(userindex, "est�s muerto!", fonttypenames.fonttype_party)
        puedecrearparty = false
    end if
end function

public sub crearparty(byval userindex as integer)
dim tint as integer
if userlist(userindex).partyindex = 0 then
    if userlist(userindex).flags.muerto = 0 then
        if userlist(userindex).stats.userskills(eskill.liderazgo) >= 5 then
            tint = mdparty.nextparty
            if tint = -1 then
                call writeconsolemsg(userindex, "por el momento no se pueden crear mas parties", fonttypenames.fonttype_party)
                exit sub
            else
                set parties(tint) = new clsparty
                if not parties(tint).nuevomiembro(userindex) then
                    call writeconsolemsg(userindex, "la party est� llena, no puedes entrar", fonttypenames.fonttype_party)
                    set parties(tint) = nothing
                    exit sub
                else
                    call writeconsolemsg(userindex, "�has formado una party!", fonttypenames.fonttype_party)
                    userlist(userindex).partyindex = tint
                    userlist(userindex).partysolicitud = 0
                    if not parties(tint).hacerleader(userindex) then
                        call writeconsolemsg(userindex, "no puedes hacerte l�der.", fonttypenames.fonttype_party)
                    else
                        call writeconsolemsg(userindex, "� te has convertido en l�der de la party !", fonttypenames.fonttype_party)
                    end if
                end if
            end if
        else
            call writeconsolemsg(userindex, " no tienes suficientes puntos de liderazgo para liderar una party.", fonttypenames.fonttype_party)
        end if
    else
        call writeconsolemsg(userindex, "est�s muerto!", fonttypenames.fonttype_party)
    end if
else
    call writeconsolemsg(userindex, " ya perteneces a una party.", fonttypenames.fonttype_party)
end if
end sub

public sub solicitaringresoaparty(byval userindex as integer)
'esto es enviado por el pj para solicitar el ingreso a la party
dim tint as integer

    if userlist(userindex).partyindex > 0 then
        'si ya esta en una party
        call writeconsolemsg(userindex, " ya perteneces a una party, escribe /salirparty para abandonarla", fonttypenames.fonttype_party)
        userlist(userindex).partysolicitud = 0
        exit sub
    end if
    if userlist(userindex).flags.muerto = 1 then
        call writeconsolemsg(userindex, " �est�s muerto!", fonttypenames.fonttype_info)
        userlist(userindex).partysolicitud = 0
        exit sub
    end if
    tint = userlist(userindex).flags.targetuser
    if tint > 0 then
        if userlist(tint).partyindex > 0 then
            userlist(userindex).partysolicitud = userlist(tint).partyindex
            call writeconsolemsg(userindex, " el fundador decidir� si te acepta en la party", fonttypenames.fonttype_party)
        else
            call writeconsolemsg(userindex, userlist(tint).name & " no es fundador de ninguna party.", fonttypenames.fonttype_info)
            userlist(userindex).partysolicitud = 0
            exit sub
        end if
    else
        call writeconsolemsg(userindex, " para ingresar a una party debes hacer click sobre el fundador y luego escribir /party", fonttypenames.fonttype_party)
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
    call writeconsolemsg(userindex, " no eres miembro de ninguna party.", fonttypenames.fonttype_info)
end if

end sub

public sub expulsardeparty(byval leader as integer, byval oldmember as integer)
dim pi as integer
pi = userlist(leader).partyindex

if pi = userlist(oldmember).partyindex then
    if parties(pi).salemiembro(oldmember) then
        'si la funcion me da true, entonces la party se disolvio
        'y los partyindex fueron reseteados a 0
        set parties(pi) = nothing
    else
        userlist(oldmember).partyindex = 0
    end if
else
    call writeconsolemsg(leader, lcase(userlist(oldmember).name) & " no pertenece a tu party.", fonttypenames.fonttype_info)
end if

end sub

''
' determines if a user can use party commands like /acceptparty or not.
'
' @param user specifies reference to user
' @return  true if the user can use party commands, false if not.
public function userpuedeejecutarcomandos(byval user as integer) as boolean
'*************************************************
'author: marco vanotti(marco)
'last modified: 05/05/09
'
'*************************************************
    dim pi as integer
    
    pi = userlist(user).partyindex
    
    if pi > 0 then
        if parties(pi).espartyleader(user) then
            userpuedeejecutarcomandos = true
        else
            call writeconsolemsg(user, "�no eres el l�der de tu party!", fonttypenames.fonttype_party)
            exit function
        end if
    else
        call writeconsolemsg(user, "no eres miembro de ninguna party.", fonttypenames.fonttype_info)
        exit function
    end if
end function

public sub aprobaringresoaparty(byval leader as integer, byval newmember as integer)
'el ui es el leader
dim pi as integer
dim razon as string

pi = userlist(leader).partyindex

if userlist(newmember).partysolicitud = pi then
    if not userlist(newmember).flags.muerto = 1 then
        if userlist(newmember).partyindex = 0 then
            if parties(pi).puedeentrar(newmember, razon) then
                if parties(pi).nuevomiembro(newmember) then
                    call parties(pi).mandarmensajeaconsola(userlist(leader).name & " ha aceptado a " & userlist(newmember).name & " en la party.", "servidor")
                    userlist(newmember).partyindex = pi
                    userlist(newmember).partysolicitud = 0
                else
                    'no pudo entrar
                    'aca uno puede codificar otro tipo de errores...
                    call senddata(sendtarget.toadmins, leader, preparemessageconsolemsg(" servidor> catastrofe en parties, nuevomiembro dio false! :s ", fonttypenames.fonttype_party))
                    end if
                else
                'no debe entrar
                call writeconsolemsg(leader, razon, fonttypenames.fonttype_party)
            end if
        else
            call writeconsolemsg(leader, userlist(newmember).name & " ya es miembro de otra party.", fonttypenames.fonttype_party)
            exit sub
        end if
    else
        call writeconsolemsg(leader, "�est� muerto, no puedes aceptar miembros en ese estado!", fonttypenames.fonttype_party)
        exit sub
    end if
else
    call writeconsolemsg(leader, lcase(userlist(newmember).name) & " no ha solicitado ingresar a tu party.", fonttypenames.fonttype_party)
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
'*************************************************
'author: unknown
'last modified: 11/27/09 (budi)
'adapte la funci�n a los nuevos m�todos de clsparty
'*************************************************
dim i as integer
dim pi as integer
dim text as string
dim membersonline(1 to party_maxmembers) as integer
    pi = userlist(userindex).partyindex
    
    if pi > 0 then
        call parties(pi).obtenermiembrosonline(membersonline)
        text = "nombre(exp): "
        for i = 1 to party_maxmembers
            if membersonline(i) > 0 then
                text = text & " - " & userlist(membersonline(i)).name & " (" & fix(parties(pi).miexperiencia(membersonline(i))) & ")"
            end if
        next i
        text = text & ". experiencia total: " & parties(pi).obtenerexperienciatotal
        call writeconsolemsg(userindex, text, fonttypenames.fonttype_party)
    end if
    
end sub


public sub transformarenlider(byval oldleader as integer, byval newleader as integer)
dim pi as integer

if oldleader = newleader then exit sub

pi = userlist(oldleader).partyindex

if pi = userlist(newleader).partyindex then
    if userlist(newleader).flags.muerto = 0 then
        if parties(pi).hacerleader(newleader) then
            call parties(pi).mandarmensajeaconsola("el nuevo l�der de la party es " & userlist(newleader).name, userlist(oldleader).name)
        else
            call writeconsolemsg(oldleader, "�no se ha hecho el cambio de mando!", fonttypenames.fonttype_party)
        end if
    else
        call writeconsolemsg(oldleader, "�est� muerto!", fonttypenames.fonttype_info)
    end if
else
    call writeconsolemsg(oldleader, lcase(userlist(newleader).name) & " no pertenece a tu party.", fonttypenames.fonttype_info)
end if

end sub


public sub actualizaexperiencias()
'esta funcion se invoca antes de worlsaves, y apagar servidores
'en caso que la experiencia sea acumulada y no por golpe
'para que grabe los datos en los charfiles
dim i as integer

if not party_experienciaporgolpe then
    
    haciendobk = true
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> distribuyendo experiencia en parties.", fonttypenames.fonttype_server))
    for i = 1 to max_parties
        if not parties(i) is nothing then
            call parties(i).flushexperiencia
        end if
    next i
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> experiencia distribuida.", fonttypenames.fonttype_server))
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
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

''
' sets the new p_sumaniveleselevados to the party.
'
' @param userinidex specifies reference to user
' @remarks when a user level up and he is in a party, we call this sub to don't desestabilice the party exp formula
public sub actualizarsumaniveleselevados(byval userindex as integer)
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 28/10/08
'
'*************************************************
    if userlist(userindex).partyindex > 0 then
        call parties(userlist(userindex).partyindex).updatesumaniveleselevados(userlist(userindex).stats.elv)
    end if
end sub


