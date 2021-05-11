attribute vb_name = "praetorianscoopnpc"
''**************************************************************
'' praetorianscoopnpc.bas - handles the praeorians npcs.
''
'' implemented by mariano barrou (el oso)
''**************************************************************
'
''**************************************************************************
''this program is free software; you can redistribute it and/or modify
''it under the terms of the affero general public license;
''either version 1 of the license, or any later version.
''
''this program is distributed in the hope that it will be useful,
''but without any warranty; without even the implied warranty of
''merchantability or fitness for a particular purpose.  see the
''affero general public license for more details.
''
''you should have received a copy of the affero general public license
''along with this program; if not, you can find it at http://www.affero.org/oagpl.html
''**************************************************************************
'
'option explicit
''''''''''''''''''''''''''''''''''''''''''
''' declaraciones del modulo pretoriano ''
''''''''''''''''''''''''''''''''''''''''''
''' estas constantes definen que valores tienen
''' los npcs pretorianos en el npc-hostiles.dat
''' son fijas, pero se podria hacer una rutina que
''' las lea desde el npcshostiles.dat
'public const prcler_npc as integer = 900   ''"sacerdote pretoriano"
'public const prguer_npc as integer = 901   ''"guerrero  pretoriano"
'public const prmago_npc as integer = 902   ''"mago pretoriano"
'public const prcaza_npc as integer = 903   ''"cazador pretoriano"
'public const prking_npc as integer = 904   ''"rey pretoriano"
'
'
'' 1 rey.
'' 3 guerres.
'' 1 caza.
'' 1 mago.
'' 2 clerigos.
'public const nro_pretorianos as integer = 8
'
'' contiene los index de los miembros del clan.
'public pretorianos(1 to nro_pretorianos) as integer
'
'
''''''''''''''''''''''''''''''''''''''''''''''
''esta constante identifica en que mapa esta
''la fortaleza pretoriana (no es lo mismo de
''donde estan los npcs!).
''se extrae el dato del server.ini en sub loadsini
public mapa_pretoriano as integer
''''''''''''''''''''''''''''''''''''''''''''''
''estos numeros son necesarios por cuestiones de
''sonido. son los numeros de los wavs del cliente.
public const sonido_dragon_vivo as integer = 30
'''alcobas reales
'''ojo los bichos tan hardcodeados, no cambiar el mapa donde
'''est�n ubicados!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
'''mucho menos la coordenada y de las alcobas ya que debe ser la misma!!!
'''(hay funciones q cuentan con que es la misma!)
'public const alcoba1_x as integer = 35
'public const alcoba1_y as integer = 25
'public const alcoba2_x as integer = 67
'public const alcoba2_y as integer = 25

public enum epretorianai
    king = 1
    healer
    spellcaster
    swordmaster
    shooter
    thief
    last
end enum

' contains all the pretorian's combinations, and its the offsets
public pretorianaioffset(1 to 7) as integer
public pretoriandatnumbers() as integer
'
''added by nacho
''cuantos pretorianos vivos quedan. uno por cada alcoba
'public pretorianosvivos as integer
'

public sub loadpretoriandata()

    dim pretoriandat as string
    pretoriandat = datpath & "pretorianos.dat"

    dim nrocombinaciones as integer
    nrocombinaciones = val(getvar(pretoriandat, "main", "combinaciones"))

    redim pretoriandatnumbers(1 to nrocombinaciones)

    dim tempint as integer
    dim counter as long
    dim pretorianindex as integer

    pretorianindex = 1

    ' kings
    tempint = val(getvar(pretoriandat, "king", "cantidad"))
    pretorianaioffset(epretorianai.king) = 1
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "king", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "king", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' healers
    tempint = val(getvar(pretoriandat, "healer", "cantidad"))
    pretorianaioffset(epretorianai.healer) = pretorianindex
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "healer", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "healer", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' spellcaster
    tempint = val(getvar(pretoriandat, "spellcaster", "cantidad"))
    pretorianaioffset(epretorianai.spellcaster) = pretorianindex
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "spellcaster", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "spellcaster", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' swordswinger
    tempint = val(getvar(pretoriandat, "swordswinger", "cantidad"))
    pretorianaioffset(epretorianai.swordmaster) = pretorianindex
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "swordswinger", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "swordswinger", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' longrange
    tempint = val(getvar(pretoriandat, "longrange", "cantidad"))
    pretorianaioffset(epretorianai.shooter) = pretorianindex
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "longrange", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "longrange", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' thief
    tempint = val(getvar(pretoriandat, "thief", "cantidad"))
    pretorianaioffset(epretorianai.thief) = pretorianindex
    for counter = 1 to tempint

        ' alto
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "thief", "alto" & counter))
        pretorianindex = pretorianindex + 1
        ' bajo
        pretoriandatnumbers(pretorianindex) = val(getvar(pretoriandat, "thief", "bajo" & counter))
        pretorianindex = pretorianindex + 1

    next counter

    ' last
    pretorianaioffset(epretorianai.last) = pretorianindex

    ' inicializa los clanes pretorianos
    redim clanpretoriano(1 to 2) as clsclanpretoriano
    set clanpretoriano(1) = new clsclanpretoriano ' clan default
    set clanpretoriano(2) = new clsclanpretoriano ' invocable por gms

end sub

















'
''/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
''/\/\/\/\/\/\/\/\ modulo de combate pretoriano /\/\/\/\/\/\/\/\/\
''/\/\/\/\/\/\/\/\ (npcs cooperativos tipo clan)/\/\/\/\/\/\/\/\/\
''/\/\/\/\/\/\/\/\         por el oso           /\/\/\/\/\/\/\/\/\
''/\/\/\/\/\/\/\/\       mbarrou@dc.uba.ar      /\/\/\/\/\/\/\/\/\
''/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
'
'
'public function espretoriano(byval npcindex as integer) as boolean
'on error goto errhandler
'
'    espretoriano = (npclist(npcindex).numero <= 925 and npclist(npcindex).numero >= 900)
'    exit function
'
'    select case npclist(npcindex).numero
'        case prcler_npc
'            espretoriano = 1
'        case prmago_npc
'            espretoriano = 2
'        case prcaza_npc
'            espretoriano = 3
'        case prking_npc
'            espretoriano = 4
'        case prguer_npc
'            espretoriano = 5
'    end select
'exit function
'
'errhandler:
'    logerror ("error en npcai.espretoriano? " & npclist(npcindex).name)
'end function
'
'public sub crearclanpretoriano(byval x as integer)
''********************************************************
''author: el oso
''inicializa el clan pretoriano.
''last modify date: 22/6/06: (nacho) seteamos cuantos npcs creamos
''********************************************************
'on error goto errhandler
'
'    ''------------------------------------------------------
'    ''recibe el x,y donde el rey anterior estaba posicionado.
'    ''------------------------------------------------------
'    ''35,25 y 67,25 son las posiciones del rey
'
'    ''sub crearnpc(nronpc as integer, mapa as integer, origpos as worldpos)
'    ''public const prcler_npc = 900
'    ''public const prguer_npc = 901
'    ''public const prmago_npc = 902
'    ''public const prcaza_npc = 903
'    ''public const prking_npc = 904
'    dim wp as worldpos
'    dim wp2 as worldpos
'    dim telefrag as integer
'    dim pretoindex as integer
'    dim npcindex as integer
'
'    wp.map = mapa_pretoriano
'    if x < 50 then ''forma burda de ver que alcoba es
'        wp.x = alcoba2_x
'        wp.y = alcoba2_y
'    else
'        wp.x = alcoba1_x
'        wp.y = alcoba1_y
'    end if
'
'    pretorianosvivos = 7 'hay 7 + el rey.
'    telefrag = mapdata(wp.map, wp.x, wp.y).npcindex
'
'    if telefrag > 0 then
'        ''el rey va a pisar a un npc de antiguo rey
'        ''obtengo en wp2 la mejor posicion cercana
'        call closestlegalpos(wp, wp2)
'        if wp2.x <> 0 and wp2.y <> 0 then
'            ''mover al actual
'
'            call senddata(sendtarget.tonpcarea, telefrag, preparemessagecharactermove(npclist(telefrag).char.charindex, wp2.x, wp2.y))
'            'update map and user pos
'            mapdata(wp.map, wp.x, wp.y).npcindex = 0
'            npclist(telefrag).pos = wp2
'            mapdata(wp2.map, wp2.x, wp2.y).npcindex = telefrag
'        else
'            ''telefrag!!!
'            call quitarnpc(telefrag)
'        end if
'    end if
'
'    ''ya limpi� el lugar para el rey (wp)
'    ''los otros no necesitan este caso ya que respawnan lejos
'
'    'busco la posicion legal mas cercana aca, aun que creo que tendr�a que ir en el crearnpc. (niconz)
'
'    ' rey
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prking_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' clerigo
'    wp.x = wp.x + 3
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prcler_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' clerigo
'    wp.x = wp.x - 6
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prcler_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' guerre
'    wp.y = wp.y + 3
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prguer_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' guerre
'    wp.x = wp.x + 3
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prguer_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' guerre
'    wp.x = wp.x + 3
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prguer_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'    ' kaza
'    wp.y = wp.y - 6
'    wp.x = wp.x - 1
'    call closestlegalpos(wp, wp2, false, true)
'    npcindex = crearnpc(prcaza_npc, mapa_pretoriano, wp2)
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'errhandler:
'end sub
'
'sub prrey_ai(byval npcind as integer)
'on error goto errorh
'    'hechizos: no cambiar aca
'    'representan la ubicacion de los spells en npc_hostiles.dat y si se los puede cambiar en ese archivo
'    '1- curar_leves 'no modificable
'    '2- remover paralisis 'no modificable
'    '3- ceugera - 'no modificable
'    '4- estupidez - 'no modificable
'    '5- curarveneno - 'no modificable
'    dim dat_curarleves as integer
'    dim dat_remueveparalisis as integer
'    dim dat_ceguera as integer
'    dim dat_estupidez as integer
'    dim dat_curarveneno as integer
'    dat_curarleves = 1
'    dat_remueveparalisis = 2
'    dat_ceguera = 3
'    dat_estupidez = 4
'    dat_curarveneno = 5
'
'
'    dim ui as integer
'    dim x as integer
'    dim y as integer
'    dim npcposx as integer
'    dim npcposy as integer
'    dim npcposm as integer
'    dim npcalind as integer
'    dim pjenind as integer
'    dim besttarget as integer
'    dim distbesttarget as integer
'    dim dist as integer
'    dim e_p as integer
'    dim haypretorianos as boolean
'    dim headingloop as byte
'    dim npos as worldpos
'    ''dim quehacer as integer
'        ''1- remueve paralisis con un minimo % de efecto
'        ''2- remueve veneno
'        ''3- cura
'
'    npcposm = npclist(npcind).pos.map
'    npcposx = npclist(npcind).pos.x
'    npcposy = npclist(npcind).pos.y
'    besttarget = 0
'    distbesttarget = 0
'    haypretorianos = false
'
'    'pick the best target according to the following criteria:
'    'king won't fight. since praetorians' mission is to keep him alive
'    'he will stay as far as possible from combat environment, but close enought
'    'as to aid his loyal army.
'    'if his army has been annihilated, the king will pick the
'    'closest enemy an chase it using his special 'weapon speedhack' ability
'    for x = npcposx - 8 to npcposx + 8
'        for y = npcposy - 7 to npcposy + 7
'            'scan combat field
'            npcalind = mapdata(npcposm, x, y).npcindex
'            pjenind = mapdata(npcposm, x, y).userindex
'            if (npclist(npcind).canattack = 1) then   ''saltea el analisis si no puede atacar para evitar cuentas
'                if (npcalind > 0) then
'                    e_p = espretoriano(npcalind)
'                    if e_p > 0 and e_p < 6 and (not (npcalind = npcind)) then
'                        haypretorianos = true
'
'                        'me curo mientras haya pretorianos (no es lo ideal, deber�a no dar experiencia tampoco, pero por ahora es lo que hay)
'                        npclist(npcind).stats.minhp = npclist(npcind).stats.maxhp
'                    end if
'
'                    if (npclist(npcalind).flags.paralizado = 1 and e_p > 0 and e_p < 6) then
'                        ''el rey puede desparalizar con una efectividad del 20%
'                        if (randomnumber(1, 100) < 21) then
'                            call npcremueveparalisisnpc(npcind, npcalind, dat_remueveparalisis)
'                            npclist(npcind).canattack = 0
'                            exit sub
'                        end if
'
'                    ''failed to remove
'                    elseif (npclist(npcalind).flags.envenenado = 1) then    ''un chiche :d
'                        if espretoriano(npcalind) then
'                            call npcremuevevenenonpc(npcind, npcalind, dat_curarveneno)
'                            npclist(npcind).canattack = 0
'                            exit sub
'                        end if
'                    elseif (npclist(npcalind).stats.maxhp > npclist(npcalind).stats.minhp) then
'                        if espretoriano(npcalind) and not (npcalind = npcind) then
'                            ''cura, salvo q sea yo mismo. eso lo hace 'despues'
'                            call npccuralevesnpc(npcind, npcalind, dat_curarleves)
'                            npclist(npcind).canattack = 0
'                            ''exit sub
'                        end if
'                    end if
'                end if
'
'                if pjenind > 0 and not haypretorianos then
'                    if not (userlist(pjenind).flags.muerto = 1 or userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1 or userlist(pjenind).flags.ceguera = 1) and userlist(pjenind).flags.adminperseguible then
'                        ''si no esta muerto o invisible o ciego... o tiene el /ignorando
'                        dist = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
'                        if (dist < distbesttarget or besttarget = 0) then
'                            besttarget = pjenind
'                            distbesttarget = dist
'                        end if
'                    end if
'                end if
'            end if  ''canattack = 1
'        next y
'    next x
'
'    if not haypretorianos then
'        ''si estoy aca es porque no hay pretorianos cerca!!!
'        ''todo mi ejercito fue asesinado
'        ''salgo a atacar a todos a lo loco a espadazos
'        if besttarget > 0 then
'            if esalcanzable(npcind, besttarget) then
'                call greedywalkto(npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y)
'                'greedywalkto npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y
'            else
'                ''el chabon es piola y ataca desde lejos entonces lo castigamos!
'                call npclanzaestupidezpj(npcind, besttarget, dat_estupidez)
'                call npclanzaceguerapj(npcind, besttarget, dat_ceguera)
'            end if
'
'            ''heading loop de ataque
'            ''teclavolaespada
'            for headingloop = eheading.north to eheading.west
'                npos = npclist(npcind).pos
'                call headtopos(headingloop, npos)
'                if inmapbounds(npos.map, npos.x, npos.y) then
'                    ui = mapdata(npos.map, npos.x, npos.y).userindex
'                    if ui > 0 then
'                        if npcatacauser(npcind, ui) then
'                            call changenpcchar(npcind, npclist(npcind).char.body, npclist(npcind).char.head, headingloop)
'                        end if
'
'                        ''special speed ability for praetorian king ---------
'                        npclist(npcind).canattack = 1   ''this is not a bug!!
'                        '----------------------------------------------------
'
'                    end if
'                end if
'            next headingloop
'
'        else    ''no hay targets cerca
'            call volveralcentro(npcind)
'            if (npclist(npcind).stats.minhp < npclist(npcind).stats.maxhp) and (npclist(npcind).canattack = 1) then
'                ''si no hay ndie y estoy daniado me curo
'                call npccuralevesnpc(npcind, npcind, dat_curarleves)
'                npclist(npcind).canattack = 0
'            end if
'
'        end if
'    end if
'exit sub
'
'errorh:
'    logerror ("error en npcai.prrey_ai? ")
'
'end sub
'
'sub prguer_ai(byval npcind as integer)
'on error goto errorh
'
'    dim headingloop as byte
'    dim npos as worldpos
'    dim x as integer
'    dim y as integer
'    dim dist as integer
'    dim distbesttarget as integer
'    dim npcposx as integer
'    dim npcposy as integer
'    dim npcposm as integer
'    dim ui as integer
'    dim pjenind as integer
'    dim besttarget as integer
'    npcposm = npclist(npcind).pos.map
'    npcposx = npclist(npcind).pos.x
'    npcposy = npclist(npcind).pos.y
'    besttarget = 0
'    dist = 0
'    distbesttarget = 0
'
'    for x = npcposx - 8 to npcposx + 8
'        for y = npcposy - 7 to npcposy + 7
'            pjenind = mapdata(npcposm, x, y).userindex
'            if (pjenind > 0) then
'                if (not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1 or userlist(pjenind).flags.muerto = 1)) and esalcanzable(npcind, pjenind) and userlist(pjenind).flags.adminperseguible then
'                    ''caluclo la distancia al pj, si esta mas cerca q el actual
'                    ''mejor besttarget entonces ataco a ese.
'                    if (besttarget > 0) then
'                        dist = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
'                        if (dist < distbesttarget) then
'                            besttarget = pjenind
'                            distbesttarget = dist
'                        end if
'                    else
'                        distbesttarget = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
'                        besttarget = pjenind
'                    end if
'                end if
'            end if
'        next y
'    next x
'
'    ''llamo a esta funcion si lo llevaron muy lejos.
'    ''la idea es que no lo "alejen" del rey y despues queden
'    ''lejos de la batalla cuando matan a un enemigo o este
'    ''sale del area de combate (tipica forma de separar un clan)
'    if npclist(npcind).flags.paralizado = 0 then
'
'        'mejora: si quedan solos, se van con el resto del ejercito
'        if npclist(npcind).invent.armoureqpslot <> 0 then
'            call cambiaralcoba(npcind)
'            'si me estoy yendo a alguna alcoba
'        elseif besttarget = 0 or estoymuylejos(npcind) then
'            call volveralcentro(npcind)
'        elseif besttarget > 0 then
'            call greedywalkto(npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y)
'        end if
'    end if
'
'''teclavolaespada
'for headingloop = eheading.north to eheading.west
'    npos = npclist(npcind).pos
'    call headtopos(headingloop, npos)
'    if inmapbounds(npos.map, npos.x, npos.y) then
'        ui = mapdata(npos.map, npos.x, npos.y).userindex
'        if ui > 0 then
'            if not (userlist(ui).flags.muerto = 1) then
'                if npcatacauser(npcind, ui) then
'                    call changenpcchar(npcind, npclist(npcind).char.body, npclist(npcind).char.head, headingloop)
'                end if
'                npclist(npcind).canattack = 0
'            end if
'        end if
'    end if
'next headingloop
'
'
'exit sub
'
'errorh:
'    logerror ("error en npcai.prguer_ai? ")
'
'
'end sub
'
'sub prcler_ai(byval npcind as integer)
'on error goto errorh
'
'    'hechizos: no cambiar aca
'    'representan la ubicacion de los spells en npc_hostiles.dat y si se los puede cambiar en ese archivo
'    '1- paralizar pjs 'modificable
'    '2- remover paralisis 'no modificable
'    '3- curargraves - 'no modificable
'    '4- paralizar mascotas - 'no modificable
'    '5- curarveneno - 'no modificable
'    dim dat_paralizarpj as integer
'    dim dat_remueveparalisis as integer
'    dim dat_curargraves as integer
'    dim dat_paralizar_npc as integer
'    dim dat_tormentaavanzada as integer
'    dat_paralizarpj = 1
'    dat_remueveparalisis = 2
'    dat_paralizar_npc = 3
'    dat_curargraves = 4
'    dat_tormentaavanzada = 5
'
'    dim x as integer
'    dim y as integer
'    dim npcposx as integer
'    dim npcposy as integer
'    dim npcposm as integer
'    dim npcalind as integer
'    dim pjenind as integer
'    dim centrox as integer
'    dim centroy as integer
'    dim besttarget as integer
'    dim pjbesttarget as boolean
'    dim azar, azar2 as integer
'    dim quehacer as byte
'        ''1- paralizar enemigo,
'        ''2- bombardear enemigo
'        ''3- ataque a mascotas
'        ''4- curar aliado
'    quehacer = 0
'    npcposm = npclist(npcind).pos.map
'    npcposx = npclist(npcind).pos.x
'    npcposy = npclist(npcind).pos.y
'    pjbesttarget = false
'    besttarget = 0
'
'    azar = sgn(randomnumber(-1, 1))
'    if azar = 0 then azar = 1
'    azar2 = sgn(randomnumber(-1, 1))
'    if azar2 = 0 then azar2 = 1
'
'    'pick the best target according to the following criteria:
'    '1) "hoaxed" friends must be released
'    '2) enemy shall be annihilated no matter what
'    '3) party healing if no threats
'    for x = npcposx + (azar * 8) to npcposx + (azar * -8) step -azar
'        for y = npcposy + (azar2 * 7) to npcposy + (azar2 * -7) step -azar2
'            'scan combat field
'            npcalind = mapdata(npcposm, x, y).npcindex
'            pjenind = mapdata(npcposm, x, y).userindex
'            if (npclist(npcind).canattack = 1) then   ''saltea el analisis si no puede atacar para evitar cuentas
'                if (npcalind > 0) then  ''allie?
'                    if (espretoriano(npcalind) = 0) then
'                        if (npclist(npcalind).maestrouser > 0) and (not (npclist(npcalind).flags.paralizado > 0)) then
'                            call npcparalizanpc(npcind, npcalind, dat_paralizar_npc)
'                            npclist(npcind).canattack = 0
'                            exit sub
'                        end if
'                    else    'es un pj aliado en combate
'                        if (npclist(npcalind).flags.paralizado = 1) then
'                            ' amigo paralizado, an hoax vorp ya
'                            call npcremueveparalisisnpc(npcind, npcalind, dat_remueveparalisis)
'                            npclist(npcind).canattack = 0
'                            exit sub
'                        elseif (besttarget = 0) then ''si no tiene nada q hacer..
'                            if (npclist(npcalind).stats.maxhp > npclist(npcalind).stats.minhp) then
'                                besttarget = npcalind   ''cura heridas
'                                pjbesttarget = false
'                                quehacer = 4
'                            end if
'                        end if
'                    end if
'                elseif (pjenind > 0) then ''aggressor
'                    if not (userlist(pjenind).flags.muerto = 1) and userlist(pjenind).flags.adminperseguible then
'                        if (userlist(pjenind).flags.paralizado = 0) then
'                            if (not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1)) then
'                                ''pj movil y visible, jeje, si o si es target
'                                besttarget = pjenind
'                                pjbesttarget = true
'                                quehacer = 1
'                            end if
'                        else    ''pj paralizado, ataca este invisible o no
'                            if not (besttarget > 0) or not (pjbesttarget) then ''a menos q tenga algo mejor
'                                besttarget = pjenind
'                                pjbesttarget = true
'                                quehacer = 2
'                            end if
'                        end if  ''endif paralizado
'                    end if  ''end if not muerto
'                end if  ''listo el analisis del tile
'            end if  ''saltea el analisis si no puede atacar, en realidad no es lo "mejor" pero evita cuentas in�tiles
'        next y
'    next x
'
'    ''aqui (si llego) tiene el mejor target
'    select case quehacer
'    case 0
'        ''nada que hacer. buscar mas alla del campo de visi�n algun aliado, a menos
'        ''que este paralizado pq no puedo ir
'        if npclist(npcind).flags.paralizado = 1 then exit sub
'
'        if not npcposm = mapa_pretoriano then exit sub
'
'        if npcposx < 50 then centrox = alcoba1_x else centrox = alcoba2_x
'        centroy = alcoba1_y
'        ''aca establec� el lugar de las alcobas
'
'        ''este doble for busca amigos paralizados lejos para ir a rescatarlos
'        ''entra aca solo si en el area cercana al rey no hay algo mejor que
'        ''hacer.
'        for x = centrox - 16 to centrox + 16
'            for y = centroy - 15 to centroy + 15
'                if not (x < npcposx + 8 and x > npcposx + 8 and y < npcposy + 7 and y > npcposy - 7) then
'                ''si no es un tile ya analizado... (evito cuentas)
'                    npcalind = mapdata(npcposm, x, y).npcindex
'                    if npcalind > 0 then
'                        if (espretoriano(npcalind) > 0 and npclist(npcalind).flags.paralizado = 1) then
'                            ''si esta paralizado lo va a rescatar, sino
'                            ''ya va a volver por su cuenta
'                            call greedywalkto(npcind, npcposm, npclist(npcalind).pos.x, npclist(npcalind).pos.y)
''                            greedywalkto npcind, npcposm, npclist(npcalind).pos.x, npclist(npcalind).pos.y
'                            exit sub
'                        end if
'                    end if  ''endif npc
'                end if  ''endif tile analizado
'            next y
'        next x
'
'        ''si estoy aca esta totalmente al cuete el clerigo o mal posicionado por rescate anterior
'        if npclist(npcind).invent.armoureqpslot = 0 then
'            call volveralcentro(npcind)
'            exit sub
'        end if
'        ''fin quehacer = 0 (npc al cuete)
'
'    case 1  '' paralizar enemigo pj
'        call senddata(sendtarget.tonpcarea, npcind, preparemessagechatoverhead(hechizos(npclist(npcind).spells(dat_paralizarpj)).palabrasmagicas, npclist(npcind).char.charindex, vbcyan))
'        call npclanzaspellsobreuser(npcind, besttarget, npclist(npcind).spells(dat_paralizarpj)) ''spell 1 de clerigo es paralizar
'        exit sub
'    case 2  '' ataque a usuarios (invisibles tambien)
'        call senddata(sendtarget.tonpcarea, npcind, preparemessagechatoverhead(hechizos(npclist(npcind).spells(dat_tormentaavanzada)).palabrasmagicas, npclist(npcind).char.charindex, vbcyan))
'        call npclanzaspellsobreuser2(npcind, besttarget, npclist(npcind).spells(dat_tormentaavanzada)) ''spell 2 de clerigo es vax on tar avanzado
'        exit sub
'    case 3  '' ataque a mascotas
'        if not (npclist(besttarget).flags.paralizado = 1) then
'            call npcparalizanpc(npcind, besttarget, dat_paralizar_npc)
'            npclist(npcind).canattack = 0
'        end if  ''todo: vax on tar sobre mascotas
'    case 4  '' party healing
'        call npccuranpc(npcind, besttarget, dat_curargraves)
'        npclist(npcind).canattack = 0
'    end select
'
'
'
'    ''movimientos
'    ''el clerigo no tiene un movimiento fijo, pero es esperable
'    ''que no se aleje mucho del rey... y si se aleje de espaderos
'
'    if npclist(npcind).flags.paralizado = 1 then exit sub
'
'    if not (npcposm = mapa_pretoriano) then exit sub
'
'    'mejora: si quedan solos, se van con el resto del ejercito
'    if npclist(npcind).invent.armoureqpslot <> 0 then
'        call cambiaralcoba(npcind)
'        exit sub
'    end if
'
'
'    pjenind = mapdata(npcposm, npcposx - 1, npcposy).userindex
'    if pjenind > 0 then
'        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1) then
'            ''esta es una forma muy facil de matar 2 pajaros
'            ''de un tiro. se aleja del usuario pq el centro va a
'            ''estar ocupado, y a la vez se aproxima al rey, manteniendo
'            ''una linea de defensa compacta
'            call volveralcentro(npcind)
'            exit sub
'        end if
'    end if
'
'    pjenind = mapdata(npcposm, npcposx + 1, npcposy).userindex
'    if pjenind > 0 then
'        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1) then
'            call volveralcentro(npcind)
'            exit sub
'        end if
'    end if
'
'    pjenind = mapdata(npcposm, npcposx, npcposy - 1).userindex
'    if pjenind > 0 then
'        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1) then
'            call volveralcentro(npcind)
'            exit sub
'        end if
'    end if
'
'    pjenind = mapdata(npcposm, npcposx, npcposy + 1).userindex
'    if pjenind > 0 then
'        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.oculto = 1) then
'            call volveralcentro(npcind)
'            exit sub
'        end if
'    end if
'
'exit sub
'
'errorh:
'    logerror ("error en npcai.prcler_ai? ")
'
'end sub
'
'function esmagooclerigo(byval pjenind as integer) as boolean
'on error goto errorh
'
'    esmagooclerigo = userlist(pjenind).clase = eclass.mage or _
'                        userlist(pjenind).clase = eclass.cleric or _
'                        userlist(pjenind).clase = eclass.druid or _
'                        userlist(pjenind).clase = eclass.bard
'exit function
'
'errorh:
'    logerror ("error en npcai.esmagooclerigo? ")
'end function
'
'sub npcremuevevenenonpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
'on error goto errorh
'    dim indireccion as integer
'
'    indireccion = npclist(npcind).spells(indice)
'    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
'    call senddata(sendtarget.tonpcarea, npcind, preparemessagechatoverhead(hechizos(indireccion).palabrasmagicas, npclist(npcind).char.charindex, vbcyan))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessagecreatefx(npclist(npcalind).char.charindex, hechizos(indireccion).fxgrh, hechizos(indireccion).loops))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessageplaywave(hechizos(indireccion).wav, npclist(npcalind).pos.x, npclist(npcalind).pos.y))
'    npclist(npcalind).veneno = 0
'    npclist(npcalind).flags.envenenado = 0
'
'exit sub
'
'errorh:
'    logerror ("error en npcai.npcremuevevenenonpc? ")
'
'end sub
'
'sub npccuralevesnpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
'on error goto errorh
'    dim indireccion as integer
'
'    indireccion = npclist(npcind).spells(indice)
'    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
'    call senddata(sendtarget.tonpcarea, npcind, preparemessagechatoverhead(hechizos(indireccion).palabrasmagicas, npclist(npcind).char.charindex, vbcyan))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessageplaywave(hechizos(indireccion).wav, npclist(npcalind).pos.x, npclist(npcalind).pos.y))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessagecreatefx(npclist(npcalind).char.charindex, hechizos(indireccion).fxgrh, hechizos(indireccion).loops))
'
'    if (npclist(npcalind).stats.minhp + 5 < npclist(npcalind).stats.maxhp) then
'        npclist(npcalind).stats.minhp = npclist(npcalind).stats.minhp + 5
'    else
'        npclist(npcalind).stats.minhp = npclist(npcalind).stats.maxhp
'    end if
'
'exit sub
'
'errorh:
'    logerror ("error en npcai.npccuralevesnpc? ")
'
'end sub
'
'
'sub npcremueveparalisisnpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
'on error goto errorh
'    dim indireccion as integer
'
'    indireccion = npclist(npcind).spells(indice)
'    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
'    call senddata(sendtarget.tonpcarea, npcind, preparemessagechatoverhead(hechizos(indireccion).palabrasmagicas, npclist(npcind).char.charindex, vbcyan))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessageplaywave(hechizos(indireccion).wav, npclist(npcalind).pos.x, npclist(npcalind).pos.y))
'    call senddata(sendtarget.tonpcarea, npcalind, preparemessagecreatefx(npclist(npcalind).char.charindex, hechizos(indireccion).fxgrh, hechizos(indireccion).loops))
'    npclist(npcalind).contadores.paralisis = 0
'    npclist(npcalind).flags.paralizado = 0
'exit sub
'
'errorh:
'    logerror ("error en npcai.npcremueveparalisisnpc? ")
'
'end sub
'
'sub npcparalizanpc(byval paralizador as integer, byval paralizado as integer, byval indice)
'on error goto errorh
'    dim indireccion as integer
'
'    indireccion = npclist(paralizador).spells(indice)
'    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
'    call senddata(sendtarget.tonpcarea, paralizador, preparemessagechatoverhead(hechizos(indireccion).palabrasmagicas, npclist(paralizador).char.charindex, vbcyan))
'    call senddata(sendtarget.tonpcarea, paralizado, preparemessageplaywave(hechizos(indireccion).wav, npclist(paralizado).pos.x, npclist(paralizado).pos.y))
'    call senddata(sendtarget.tonpcarea, paralizado, preparemessagecreatefx(npclist(paralizado).char.charindex, hechizos(indireccion).fxgrh, hechizos(indireccion).loops))
'
'    npclist(paralizado).flags.paralizado = 1
'    npclist(paralizado).contadores.paralisis = intervaloparalizado * 2
'
'exit sub
'
'errorh:
'    logerror ("error en npcai.npcparalizanpc? ")
'
'end sub
'
'sub npccuranpc(byval curador as integer, byval curado as integer, byval indice as integer)
'on error goto errorh
'    dim indireccion as integer
'
'
'    indireccion = npclist(curador).spells(indice)
'    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
'    call senddata(sendtarget.tonpcarea, curador, preparemessagechatoverhead(hechizos(indireccion).palabrasmagicas, npclist(curador).char.charindex, vbcyan))
'    call senddata(sendtarget.tonpcarea, curado, preparemessageplaywave(hechizos(indireccion).wav, npclist(curado).pos.x, npclist(curado).pos.y))
'    call senddata(sendtarget.tonpcarea, curado, preparemessagecreatefx(npclist(curado).char.charindex, hechizos(indireccion).fxgrh, hechizos(indireccion).loops))
'    if npclist(curado).stats.minhp + 30 > npclist(curado).stats.maxhp then
'        npclist(curado).stats.minhp = npclist(curado).stats.maxhp
'    else
'        npclist(curado).stats.minhp = npclist(curado).stats.minhp + 30
'    end if
'exit sub
'
'errorh:
'    logerror ("error en npcai.npccuranpc? ")
'
'end sub
'
'    pretoindex = pretoindex + 1
'    pretorianos(pretoindex) = npcindex
'
'exit sub
'
'errhandler:
'    logerror ("error en npcai.crearclanpretoriano. error: " & err.number & " - " & err.description)
'end sub
'
'public sub muerepretoriano(byval npcindex as integer)
''***************************************************
''author: zama
''last modification: 27/06/2010
''eliminates the pretorian from the current alive ones.
''***************************************************
'
'    dim pretoindex as integer
'
'    for pretoindex = 1 to nro_pretorianos
'        if pretorianos(pretoindex) = npcindex then
'            pretorianos(pretoindex) = 0
'            exit sub
'        end if
'    next pretoindex
'
'end sub
'
