attribute vb_name = "praetorianscoopnpc"
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
'''''''''''''''''''''''''''''''''''''''''
'' declaraciones del modulo pretoriano ''
'''''''''''''''''''''''''''''''''''''''''
'' estas constantes definen que valores tienen
'' los npcs pretorianos en el npc-hostiles.dat
'' son fijas, pero se podria hacer una rutina que
'' las lea desde el npcshostiles.dat
public const prcler_npc = 900   ''"sacerdote pretoriano"
public const prguer_npc = 901   ''"guerrero  pretoriano"
public const prmago_npc = 902   ''"mago pretoriano"
public const prcaza_npc = 903   ''"cazador pretoriano"
public const prking_npc = 904   ''"rey pretoriano"
''''''''''''''''''''''''''''''''''''''''''''''
''esta constante identifica en que mapa esta
''la fortaleza pretoriana (no es lo mismo de
''donde estan los npcs!).
''se extrae el dato del server.ini en sub loadsini
public mapa_pretoriano as integer
''''''''''''''''''''''''''''''''''''''''''''''
''estos numeros son necesarios por cuestiones de
''sonido. son los numeros de los wavs del cliente.
private const sonido_dragon_vivo = 30
private const sonido_dragon_muerto = 32
''alcobas reales
''ojo los bichos tan hardcodeados, no cambiar el mapa donde
''est�n ubicados!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
''mucho menos la coordenada y de las alcobas ya que debe ser la misma!!!
''(hay funciones q cuentan con que es la misma!)
public const alcoba1_x = 35
public const alcoba1_y = 25
public const alcoba2_x = 67
public const alcoba2_y = 25



'/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
'/\/\/\/\/\/\/\/\ (npcs cooperativos tipo clan)/\/\/\/\/\/\/\/\/\
'/\/\/\/\/\/\/\/\         por el oso           /\/\/\/\/\/\/\/\/\
'/\/\/\/\/\/\/\/\       ositear@yahoo.com.ar   /\/\/\/\/\/\/\/\/\
'/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
'un comentario a la izquierda:
'cuando codifique este modulo contaba con el codigo fuente de 2 versiones
'atras del servidor actual, por lo tanto el codigo es "autosuficiente"
'esto significa que casi no usa nignuna funcion del resto del proyecto
'para facilitar su insersion en cada servidor
'si alguien es feliz acoplandolo al servidor, bienvenido sea :d


public function espretoriano(byval npcindex as integer) as integer
on error goto errorh

    dim n as integer
    dim i as integer
    n = npclist(npcindex).numero
    i = npclist(npcindex).char.charindex
'    call senddata(tonpcarea, npcindex, npclist(npcindex).pos.map, "||" & vbgreen & "� soy pretoriano �" & str(ind))
    select case npclist(npcindex).numero
    case prcler_npc
        espretoriano = 1
    case prmago_npc
        espretoriano = 2
    case prcaza_npc
        espretoriano = 3
    case prking_npc
        espretoriano = 4
    case prguer_npc
        espretoriano = 5
    end select

exit function

errorh:
    logerror ("error en npcai.espretoriano? " & npclist(npcindex).name)
    'do nothing

end function


sub crearclanpretoriano(byval mapa as integer, byval x as integer, byval y as integer)
on error goto errorh

    ''------------------------------------------------------
    ''recibe el x,y donde el rey anterior estaba posicionado.
    ''------------------------------------------------------
    ''35,25 y 67,25 son las posiciones del rey
    
    ''sub crearnpc(nronpc as integer, mapa as integer, origpos as worldpos)
    ''public const prcler_npc = 900
    ''public const prguer_npc = 901
    ''public const prmago_npc = 902
    ''public const prcaza_npc = 903
    ''public const prking_npc = 904
    dim wp as worldpos
    dim wp2 as worldpos
    dim telefrag as integer
    
    wp.map = mapa_pretoriano
    select case x   ''forma burda de ver que alcoba es
        case is < 50
            wp.x = alcoba2_x
            wp.y = alcoba2_y
        case is >= 50
            wp.x = alcoba1_x
            wp.y = alcoba1_y
    end select
    
    telefrag = mapdata(wp.map, wp.x, wp.y).npcindex
    
    if telefrag > 0 then
        ''el rey va a pisar a un npc de antiguo rey
        ''obtengo en wp2 la mejor posicion cercana
        call closestlegalpos(wp, wp2)
        if (legalpos(wp2.map, wp2.x, wp2.y)) then
            ''mover al actual
            call senddata(tomap, 0, wp2.map, "mp" & npclist(telefrag).char.charindex & "," & wp2.x & "," & wp2.y)
            'update map and user pos
            mapdata(wp.map, wp.x, wp.y).npcindex = 0
            npclist(telefrag).pos = wp2
            mapdata(wp2.map, wp2.x, wp2.y).npcindex = telefrag
        else
            ''telefrag!!!
            call quitarnpc(telefrag)
        end if
    end if
    ''ya limpi� el lugar para el rey (wp)
    ''los otros no necesitan este caso ya que respawnan lejos
    call crearnpc(prking_npc, mapa_pretoriano, wp)
    wp.x = wp.x + 3
    call crearnpc(prcler_npc, mapa_pretoriano, wp)
    wp.x = wp.x - 6
    call crearnpc(prcler_npc, mapa_pretoriano, wp)
    wp.y = wp.y + 3
    call crearnpc(prguer_npc, mapa_pretoriano, wp)
    wp.x = wp.x + 3
    call crearnpc(prguer_npc, mapa_pretoriano, wp)
    wp.x = wp.x + 3
    call crearnpc(prguer_npc, mapa_pretoriano, wp)
    wp.y = wp.y - 6
    wp.x = wp.x - 1
    call crearnpc(prcaza_npc, mapa_pretoriano, wp)
    wp.x = wp.x - 4
    call crearnpc(prmago_npc, mapa_pretoriano, wp)
exit sub

errorh:
    logerror ("error en npcai.crearclanpretoriano ")
    'do nothing

end sub

sub prcaza_ai(byval npcind as integer)
on error goto errorh
    '' no cambiar:
    '' hechizos: 1- flecha
    

    dim x as integer
    dim y as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim besttarget as integer
    dim npcalind as integer
    dim pjenind  as integer
    
    dim pjbesttarget as boolean
    dim btx as integer
    dim bty as integer
    dim xc as integer
    dim yc as integer
    dim azar as integer
    dim azar2 as integer
    
    dim quehacer as byte
        ''1- ataca usuarios
    
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    npcposm = npclist(npcind).pos.map
    
    pjbesttarget = false
    x = 0
    y = 0
    quehacer = 0
    
    
    azar = int(sgn(randomnumber(-10, 10)))
    'azar = sgn(azar)
    if azar = 0 then azar = 1
    azar2 = int(sgn(randomnumber(-10, 10)))
    'azar2 = sgn(azar2)
    if azar2 = 0 then azar2 = 1
    
    
    'pick the best target according to the following criteria:
    '1) magues are dangerous, but they are weak too, they're
    '   our primary target
    '2) in any other case, our nearest enemy will be attacked
    
    for x = npcposx + (azar * 8) to npcposx + (azar * -8) step -azar
        for y = npcposy + (azar2 * 7) to npcposy + (azar2 * -7) step -azar2
            npcalind = mapdata(npcposm, x, y).npcindex  ''por si implementamos algo contra npcs
            pjenind = mapdata(npcposm, x, y).userindex
            if (pjenind > 0) and (npclist(npcind).canattack = 1) then
                if (userlist(pjenind).flags.invisible = 0) and not (userlist(pjenind).flags.muerto = 1) then
                'todo: borrar los gms
                    if (esmagooclerigo(pjenind)) then
                        ''say no more, atacar a este
                        pjbesttarget = true
                        besttarget = pjenind
                        quehacer = 1
                        'call npclanzaspellsobreuser(npcind, pjenind, npclist(npcind).spells(1)) ''flecha pasa como spell
                        x = npcposx + (azar * -8)
                        y = npcposy + (azar2 * -7)
                        ''forma espantosa de zafar del for
                     else
                        if (besttarget > 0) then
                            ''ver el mas cercano a mi
                            if sqr((x - npcposx) ^ 2 + (y - npcposy) ^ 2) < sqr((npcposx - userlist(besttarget).pos.x) ^ 2 + (npcposy - userlist(besttarget).pos.y) ^ 2) then
                                ''el nuevo esta mas cerca
                                pjbesttarget = true
                                besttarget = pjenind
                                quehacer = 1
                            end if
                        else
                            pjbesttarget = true
                            besttarget = pjenind
                            quehacer = 1
                        end if
                    end if
                end if
            end if  ''fin analisis del tile
        next y
    next x
    
select case quehacer
    case 1  ''nearest target
        if (npclist(npcind).canattack = 1) then
            call npclanzaspellsobreuser(npcind, besttarget, npclist(npcind).spells(1))
        end if
    ''case 2: not yet implemented
end select
    
''  vamos a setear el hold on del cazador en el medio entre el rey
''  y el atacante. de esta manera se lo podra atacar aun asi est� lejos
''  pero sin alejarse del rango de los an hoax vorps de los
''  clerigos o rey. a menos q este paralizado, claro

if npclist(npcind).flags.paralizado = 1 then exit sub

if not npcposm = mapa_pretoriano then exit sub


'mejora: si quedan solos, se van con el resto del ejercito
if npclist(npcind).invent.armoureqpslot <> 0 then
    'si me estoy yendo a alguna alcoba
    call cambiaralcoba(npcind)
    exit sub
end if




if estoymuylejos(npcind) then
    volveralcentro (npcind)
    exit sub
end if

if (besttarget > 0) then

    btx = userlist(besttarget).pos.x
    bty = userlist(besttarget).pos.y
    
    if npcposx < 50 then
        
        call greedywalkto(npcind, mapa_pretoriano, alcoba1_x + ((btx - alcoba1_x) \ 2), alcoba1_y + ((bty - alcoba1_y) \ 2))
        'greedywalkto npcind, mapa_pretoriano, alcoba1_x + ((btx - alcoba1_x) \ 2), alcoba1_y + ((bty - alcoba1_y) \ 2)
    else
        call greedywalkto(npcind, mapa_pretoriano, alcoba2_x + ((btx - alcoba2_x) \ 2), alcoba2_y + ((bty - alcoba2_y) \ 2))
        'greedywalkto npcind, mapa_pretoriano, alcoba2_x + ((btx - alcoba2_x) \ 2), alcoba2_y + ((bty - alcoba2_y) \ 2)
    end if
else
    ''2do loop. busca gente acercandose por otros frentes para frenarla
    if npcposx < 50 then xc = alcoba1_x else xc = alcoba2_x
    yc = alcoba1_y
    
    for x = xc - 16 to xc + 16
        for y = yc - 14 to yc + 14
            if not (x <= npcposx + 8 and x >= npcposx - 8 and y >= npcposy - 7 and y <= npcposy + 7) then
                ''si es un tile no analizado
                pjenind = mapdata(npcposm, x, y).userindex    ''por si implementamos algo contra npcs
                if (pjenind > 0) then
                    if not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.muerto = 1) then
                        ''si no esta muerto.., ya encontro algo para ir a buscar
                        call greedywalkto(npcind, mapa_pretoriano, userlist(pjenind).pos.x, userlist(pjenind).pos.y)
                        exit sub
                    end if
                end if
            end if
        next y
    next x
    
    ''vuelve si no esta en proceso de ataque a usuarios
    if (npclist(npcind).canattack = 1) then call volveralcentro(npcind)

end if
    
exit sub
errorh:
    logerror ("error en npcai.prcaza_ai ")
    'do nothing

end sub

sub prmago_ai(byval npcind as integer)
on error goto errorh
    
    'hechizos: no cambiar aca
    'representan la ubicacion de los spells en npc_hostiles.dat y si se los puede cambiar en ese archivo
    '1- apocalipsis 'modificable
    '2- remover invisibilidad 'no modificable
    dim dat_apocalipsis as integer
    dim dat_remueve_invi as integer
    dat_apocalipsis = 1
    dat_remueve_invi = 2
    
    ''el mago pretoriano guarda  el index al npc rey en el
    ''inventario.barcoobjind parameter. ese no es usado nunca.
    ''el objetivo es no modificar al tad npc utilizando una propiedad
    ''que nunca va a ser utilizada por un npc (espero)
    dim x as integer
    dim y as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim besttarget as integer
    dim npcalind as integer
    dim pjenind as integer
    dim pjbesttarget as boolean
    dim bs as byte
    dim azar as integer
    dim azar2 as integer

    dim quehacer as byte
        ''1- atacar a enemigos
        ''2- remover invisibilidades
        ''3- rotura de vara

    npcposx = npclist(npcind).pos.x   ''store current position
    npcposy = npclist(npcind).pos.y   ''for direct access
    npcposm = npclist(npcind).pos.map
    
    pjbesttarget = false
    besttarget = 0
    quehacer = 0
    x = 0
    y = 0
    
    
    if (npclist(npcind).stats.minhp < 750) then   ''dying
        quehacer = 3        ''va a romper su vara en 5 segundos
    else
        if not (npclist(npcind).invent.barcoslot = 6) then
            npclist(npcind).invent.barcoslot = 6    ''restore wand break counter
            call senddata(tomap, npcind, npclist(npcind).pos.map, "cfx" & npclist(npcind).char.charindex & "," & 0 & "," & 0)
        end if
    
        'pick the best target according to the following criteria:
        '1) invisible enemies can be detected sometimes
        '2) a wizard's mission is background spellcasting attack
        
        azar = int(sgn(randomnumber(-10, 10)))
        'azar = sgn(azar)
        if azar = 0 then azar = 1
        azar2 = int(sgn(randomnumber(-10, 10)))
        'azar2 = sgn(azar2)
        if azar2 = 0 then azar2 = 1
        
        ''esto fue para rastrear el combat field al azar
        ''si no se hace asi, los npcs pretorianos "combinan" ataques, y cada
        ''ataque puede sumar hasta 700 hit points, lo cual los vuelve
        ''invulnerables
        
'        azar = 1
        
        for x = npcposx + (azar * 8) to npcposx + (azar * -8) step -azar
            for y = npcposy + (azar2 * 7) to npcposy + (azar2 * -7) step -azar2
                npcalind = mapdata(npcposm, x, y).npcindex  ''por si implementamos algo contra npcs
                pjenind = mapdata(npcposm, x, y).userindex
                
                if (pjenind > 0) and (npclist(npcind).canattack = 1) then
                    if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.admininvisible = 1) then
                        if (userlist(pjenind).flags.invisible = 1) then
                            ''usuario invisible, vamos a ver si se la podemos sacar
                            
                            if (randomnumber(1, 100) <= 35) then
                                ''mago detecta invisiblidad
                                npclist(npcind).canattack = 0
                                call npcremueveinvisibilidad(npcind, pjenind, dat_remueve_invi)
                                exit sub ''basta, suficiente!, jeje
                            end if
                            if userlist(pjenind).flags.paralizado = 1 then
                                ''los usuarios invisibles y paralizados son un buen target!
                                besttarget = pjenind
                                pjbesttarget = true
                                quehacer = 2
                            end if
                        elseif (userlist(pjenind).flags.paralizado = 1) then
                            if (besttarget > 0) then
                                if not (userlist(besttarget).flags.invisible = 1) then
                                ''encontre un paralizado visible, y no hay un besttarget invisible (paralizado invisible)
                                besttarget = pjenind
                                pjbesttarget = true
                                quehacer = 2
                                end if
                            else
                                besttarget = pjenind
                                pjbesttarget = true
                                quehacer = 2
                            end if
                        elseif besttarget = 0 then
                            ''movil visible
                            besttarget = pjenind
                            pjbesttarget = true
                            quehacer = 2
                        end if  ''
                    end if  ''endif:    not muerto
                end if  ''endif: es un tile con pj y puede atacar
            next y
        next x
    end if  ''endif esta muriendo
    
    
    select case quehacer
    ''case 1 esta "harcodeado" en el doble for
    ''es remover invisibilidades
    case 2          ''apocalipsis rahma na�arak o'al
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�" & hechizos(npclist(npcind).spells(dat_apocalipsis)).palabrasmagicas & "�" & str(npclist(npcind).char.charindex))
        call npclanzaspellsobreuser2(npcind, besttarget, npclist(npcind).spells(dat_apocalipsis)) ''spell 1 de mago: apocalipsis
    case 3
    
        call senddata(tomap, npcind, npclist(npcind).pos.map, "cfx" & npclist(npcind).char.charindex & "," & fxmeditargrande & "," & loopadeternum)
        ''userlist(userindex).char.fx = fxmeditargrande
    
        if npclist(npcind).canattack = 1 then
            npclist(npcind).canattack = 0
            bs = npclist(npcind).invent.barcoslot
            bs = bs - 1
            call magodestruyewand(npcind, bs, dat_apocalipsis)
            if bs = 0 then
                call muerenpc(npcind, 0)
            else
                npclist(npcind).invent.barcoslot = bs
            end if
        end if
    end select
    
    
    ''movimiento (si puede)
    ''el mago no se mueve a menos q tenga alguien al lado
    
    if npclist(npcind).flags.paralizado = 1 then exit sub
    
    if not (quehacer = 3) then      ''si no ta matandose
            ''alejarse si tiene un pj cerca
            ''pero alejarse sin alejarse del rey
        if not (npcposm = mapa_pretoriano) then exit sub
        
        ''si no hay nadie cerca, o no tengo nada que hacer...
        if (besttarget = 0) and (npclist(npcind).canattack = 1) then call volveralcentro(npcind)
        
        pjenind = mapdata(npcposm, npcposx - 1, npcposy).userindex
        if (pjenind > 0) then
            if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
                ''esta es una forma muy facil de matar 2 pajaros
                ''de un tiro. se aleja del usuario pq el centro va a
                ''estar ocupado, y a la vez se aproxima al rey, manteniendo
                ''una linea de defensa compacta
                call volveralcentro(npcind)
                exit sub
            end if
        end if
        
        pjenind = mapdata(npcposm, npcposx + 1, npcposy).userindex
        if pjenind > 0 then
            if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
                call volveralcentro(npcind)
                exit sub
            end if
        end if
        
        pjenind = mapdata(npcposm, npcposx, npcposy - 1).userindex
        if pjenind > 0 then
            if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
                call volveralcentro(npcind)
                exit sub
            end if
        end if
        
        pjenind = mapdata(npcposm, npcposx, npcposy + 1).userindex
        if pjenind > 0 then
            if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
                call volveralcentro(npcind)
                exit sub
            end if
        end if
            
    
    end if  ''end if not matandose
    
exit sub
    
errorh:
    logerror ("error en npcai.prmago_ai? ")

end sub

sub prrey_ai(byval npcind as integer)
on error goto errorh
    'hechizos: no cambiar aca
    'representan la ubicacion de los spells en npc_hostiles.dat y si se los puede cambiar en ese archivo
    '1- curar_leves 'no modificable
    '2- remover paralisis 'no modificable
    '3- ceugera - 'no modificable
    '4- estupidez - 'no modificable
    '5- curarveneno - 'no modificable
    dim dat_curarleves as integer
    dim dat_remueveparalisis as integer
    dim dat_ceguera as integer
    dim dat_estupidez as integer
    dim dat_curarveneno as integer
    dat_curarleves = 1
    dat_remueveparalisis = 2
    dat_ceguera = 3
    dat_estupidez = 4
    dat_curarveneno = 5
    
    
    dim ui as integer
    dim x as integer
    dim y as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim npcalind as integer
    dim pjenind as integer
    dim besttarget as integer
    dim distbesttarget as integer
    dim dist as integer
    dim e_p as integer
    dim haypretorianos as boolean
    dim headingloop as byte
    dim npos as worldpos
    ''dim quehacer as integer
        ''1- remueve paralisis con un minimo % de efecto
        ''2- remueve veneno
        ''3- cura
    
    npcposm = npclist(npcind).pos.map
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    besttarget = 0
    distbesttarget = 0
    haypretorianos = false
    
    'pick the best target according to the following criteria:
    'king won't fight. since praetorians' mission is to keep him alive
    'he will stay as far as possible from combat environment, but close enought
    'as to aid his loyal army.
    'if his army has been annihilated, the king will pick the
    'closest enemy an chase it using his special 'weapon speedhack' ability
    for x = npcposx - 8 to npcposx + 8
        for y = npcposy - 7 to npcposy + 7
            'scan combat field
            npcalind = mapdata(npcposm, x, y).npcindex
            pjenind = mapdata(npcposm, x, y).userindex
            if (npclist(npcind).canattack = 1) then   ''saltea el analisis si no puede atacar para evitar cuentas
                if (npcalind > 0) then
                    e_p = espretoriano(npcalind)
                    if e_p > 0 and e_p < 6 and (not (npcalind = npcind)) then haypretorianos = true
                    if (npclist(npcalind).flags.paralizado = 1 and e_p > 0 and e_p < 6) then
                        ''el rey puede desparalizar con una efectividad del 20%
                        if (randomnumber(1, 100) < 21) then
                            call npcremueveparalisisnpc(npcind, npcalind, dat_remueveparalisis)
                            npclist(npcind).canattack = 0
                            exit sub
                        end if
                    
                    ''failed to remove
                    elseif (npclist(npcalind).flags.envenenado = 1) then    ''un chiche :d
                        if espretoriano(npcalind) then
                            call npcremuevevenenonpc(npcind, npcalind, dat_curarveneno)
                            npclist(npcind).canattack = 0
                            exit sub
                        end if
                    elseif (npclist(npcalind).stats.maxhp > npclist(npcalind).stats.minhp) then
                        if espretoriano(npcalind) and not (npcalind = npcind) then
                            ''cura, salvo q sea yo mismo. eso lo hace 'despues'
                            call npccuralevesnpc(npcind, npcalind, dat_curarleves)
                            npclist(npcind).canattack = 0
                            ''exit sub
                        end if
                    end if
                end if

                if pjenind > 0 and not haypretorianos then
                    if not (userlist(pjenind).flags.muerto = 1 or userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.ceguera = 1) then
                        ''si no esta muerto o invisible o ciego...
                        dist = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
                        if (dist < distbesttarget or besttarget = 0) then
                            besttarget = pjenind
                            distbesttarget = dist
                        end if
                    end if
                end if
            end if  ''canattack = 1
        next y
    next x
    
    if not haypretorianos then
        ''si estoy aca es porque no hay pretorianos cerca!!!
        ''todo mi ejercito fue asesinado
        ''salgo a atacar a todos a lo loco a espadazos
        if besttarget > 0 then
            if esalcanzable(npcind, besttarget) then
                call greedywalkto(npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y)
                'greedywalkto npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y
            else
                ''el chabon es piola y ataca desde lejos entonces lo castigamos!
                call npclanzaestupidezpj(npcind, besttarget, dat_estupidez)
                call npclanzaceguerapj(npcind, besttarget, dat_ceguera)
            end if
            
            ''heading loop de ataque
            ''teclavolaespada
            for headingloop = north to west
                npos = npclist(npcind).pos
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    if ui > 0 then
                        call changenpcchar(tomap, 0, npos.map, npcind, npclist(npcind).char.body, npclist(npcind).char.head, headingloop)
                        call npcatacauser(npcind, ui)
                        
                        ''special speed ability for praetorian king ---------
                        npclist(npcind).canattack = 1   ''this is not a bug!!
                        '----------------------------------------------------
                    
                    end if
                end if
            next headingloop
        
        else    ''no hay targets cerca
            call volveralcentro(npcind)
            if (npclist(npcind).stats.minhp < npclist(npcind).stats.maxhp) and (npclist(npcind).canattack = 1) then
                ''si no hay ndie y estoy daniado me curo
                call npccuralevesnpc(npcind, npcind, dat_curarleves)
                npclist(npcind).canattack = 0
            end if
        
        end if
    end if
exit sub

errorh:
    logerror ("error en npcai.prrey_ai? ")
    
end sub

sub prguer_ai(byval npcind as integer)
on error goto errorh

    dim headingloop as byte
    dim npos as worldpos
    dim x as integer
    dim y as integer
    dim dist as integer
    dim distbesttarget as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim npcalind as integer
    dim ui as integer
    dim pjenind as integer
    dim besttarget as integer
    npcposm = npclist(npcind).pos.map
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    besttarget = 0
    dist = 0
    distbesttarget = 0
    
    for x = npcposx - 8 to npcposx + 8
        for y = npcposy - 7 to npcposy + 7
            pjenind = mapdata(npcposm, x, y).userindex
            if (pjenind > 0) then
                if (not (userlist(pjenind).flags.invisible = 1 or userlist(pjenind).flags.muerto = 1)) and esalcanzable(npcind, pjenind) then
                    ''caluclo la distancia al pj, si esta mas cerca q el actual
                    ''mejor besttarget entonces ataco a ese.
                    if (besttarget > 0) then
                        dist = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
                        if (dist < distbesttarget) then
                            besttarget = pjenind
                            distbesttarget = dist
                        end if
                    else
                        distbesttarget = sqr((userlist(pjenind).pos.x - npcposx) ^ 2 + (userlist(pjenind).pos.y - npcposy) ^ 2)
                        besttarget = pjenind
                    end if
                end if
            end if
        next y
    next x
    
    ''llamo a esta funcion si lo llevaron muy lejos.
    ''la idea es que no lo "alejen" del rey y despues queden
    ''lejos de la batalla cuando matan a un enemigo o este
    ''sale del area de combate (tipica forma de separar un clan)
    if npclist(npcind).flags.paralizado = 0 then

        'mejora: si quedan solos, se van con el resto del ejercito
        if npclist(npcind).invent.armoureqpslot <> 0 then
            call cambiaralcoba(npcind)
            'si me estoy yendo a alguna alcoba
        elseif besttarget = 0 or estoymuylejos(npcind) then
            call volveralcentro(npcind)
        elseif besttarget > 0 then
            call greedywalkto(npcind, userlist(besttarget).pos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y)
        end if
    end if

''teclavolaespada
for headingloop = north to west
    npos = npclist(npcind).pos
    call headtopos(headingloop, npos)
    if inmapbounds(npos.map, npos.x, npos.y) then
        ui = mapdata(npos.map, npos.x, npos.y).userindex
        if ui > 0 then
            if not (userlist(ui).flags.muerto = 1) then
                call changenpcchar(tomap, 0, npos.map, npcind, npclist(npcind).char.body, npclist(npcind).char.head, headingloop)
                call npcatacauser(npcind, ui)
                npclist(npcind).canattack = 0
            end if
        end if
    end if
next headingloop


exit sub

errorh:
    logerror ("error en npcai.prguer_ai? ")
    

end sub

sub prcler_ai(byval npcind as integer)
on error goto errorh
    
    'hechizos: no cambiar aca
    'representan la ubicacion de los spells en npc_hostiles.dat y si se los puede cambiar en ese archivo
    '1- paralizar pjs 'modificable
    '2- remover paralisis 'no modificable
    '3- curargraves - 'no modificable
    '4- paralizar mascotas - 'no modificable
    '5- curarveneno - 'no modificable
    dim dat_paralizarpj as integer
    dim dat_remueveparalisis as integer
    dim dat_curargraves as integer
    dim dat_paralizar_npc as integer
    dim dat_tormentaavanzada as integer
    dat_paralizarpj = 1
    dat_remueveparalisis = 2
    dat_paralizar_npc = 3
    dat_curargraves = 4
    dat_tormentaavanzada = 5

    dim x as integer
    dim y as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim npcalind as integer
    dim pjenind as integer
    dim centrox as integer
    dim centroy as integer
    dim besttarget as integer
    dim pjbesttarget as boolean
    dim azar, azar2 as integer
    dim quehacer as byte
        ''1- paralizar enemigo,
        ''2- bombardear enemigo
        ''3- ataque a mascotas
        ''4- curar aliado
    quehacer = 0
    npcposm = npclist(npcind).pos.map
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    pjbesttarget = false
    besttarget = 0
    
    azar = randomnumber(-10, 10)
    azar = int(sgn(azar))
    if azar = 0 then azar = 1
    azar2 = randomnumber(-10, 10)
    azar2 = int(sgn(azar2))
    if azar2 = 0 then azar2 = 1
    
    'pick the best target according to the following criteria:
    '1) "hoaxed" friends must be released
    '2) enemy shall be annihilated no matter what
    '3) party healing if no threats
    for x = npcposx + (azar * 8) to npcposx + (azar * -8) step -azar
        for y = npcposy + (azar2 * 7) to npcposy + (azar2 * -7) step -azar2
            'scan combat field
            npcalind = mapdata(npcposm, x, y).npcindex
            pjenind = mapdata(npcposm, x, y).userindex
            if (npclist(npcind).canattack = 1) then   ''saltea el analisis si no puede atacar para evitar cuentas
                if (npcalind > 0) then  ''allie?
                    if (espretoriano(npcalind) = 0) then
                        if (npclist(npcalind).maestrouser > 0) and (not (npclist(npcalind).flags.paralizado > 0)) then
                            call npcparalizanpc(npcind, npcalind, dat_paralizar_npc)
                            npclist(npcind).canattack = 0
                            exit sub
                        end if
                    else    'es un pj aliado en combate
                        if (npclist(npcalind).flags.paralizado = 1) then
                            ' amigo paralizado, an hoax vorp ya
                            call npcremueveparalisisnpc(npcind, npcalind, dat_remueveparalisis)
                            npclist(npcind).canattack = 0
                            exit sub
                        elseif (besttarget = 0) then ''si no tiene nada q hacer..
                            if (npclist(npcalind).stats.maxhp > npclist(npcalind).stats.minhp) then
                                besttarget = npcalind   ''cura heridas
                                pjbesttarget = false
                                quehacer = 4
                            end if
                        end if
                    end if
                elseif (pjenind > 0) then ''aggressor
                    if not (userlist(pjenind).flags.muerto = 1) then
                        if (userlist(pjenind).flags.paralizado = 0) then
                            if (not (userlist(pjenind).flags.invisible = 1)) then
                                ''pj movil y visible, jeje, si o si es target
                                besttarget = pjenind
                                pjbesttarget = true
                                quehacer = 1
                            end if
                        else    ''pj paralizado, ataca este invisible o no
                            if not (besttarget > 0) or not (pjbesttarget) then ''a menos q tenga algo mejor
                                besttarget = pjenind
                                pjbesttarget = true
                                quehacer = 2
                            end if
                        end if  ''endif paralizado
                    end if  ''end if not muerto
                end if  ''listo el analisis del tile
            end if  ''saltea el analisis si no puede atacar, en realidad no es lo "mejor" pero evita cuentas in�tiles
        next y
    next x
            
    ''aqui (si llego) tiene el mejor target
    select case quehacer
    case 0
        ''nada que hacer. buscar mas alla del campo de visi�n algun aliado, a menos
        ''que este paralizado pq no puedo ir
        if npclist(npcind).flags.paralizado = 1 then exit sub
        
        if not npcposm = mapa_pretoriano then exit sub
        
        if npcposx < 50 then centrox = alcoba1_x else centrox = alcoba2_x
        centroy = alcoba1_y
        ''aca establec� el lugar de las alcobas
        
        ''este doble for busca amigos paralizados lejos para ir a rescatarlos
        ''entra aca solo si en el area cercana al rey no hay algo mejor que
        ''hacer.
        for x = centrox - 16 to centrox + 16
            for y = centroy - 15 to centroy + 15
                if not (x < npcposx + 8 and x > npcposx + 8 and y < npcposy + 7 and y > npcposy - 7) then
                ''si no es un tile ya analizado... (evito cuentas)
                    npcalind = mapdata(npcposm, x, y).npcindex
                    if npcalind > 0 then
                        if (espretoriano(npcalind) > 0 and npclist(npcalind).flags.paralizado = 1) then
                            ''si esta paralizado lo va a rescatar, sino
                            ''ya va a volver por su cuenta
                            call greedywalkto(npcind, npcposm, npclist(npcalind).pos.x, npclist(npcalind).pos.y)
'                            greedywalkto npcind, npcposm, npclist(npcalind).pos.x, npclist(npcalind).pos.y
                            exit sub
                        end if
                    end if  ''endif npc
                end if  ''endif tile analizado
            next y
        next x
        
        ''si estoy aca esta totalmente al cuete el clerigo o mal posicionado por rescate anterior
        if npclist(npcind).invent.armoureqpslot = 0 then
            call volveralcentro(npcind)
            exit sub
        end if
        ''fin quehacer = 0 (npc al cuete)
        
    case 1  '' paralizar enemigo pj
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�" & hechizos(npclist(npcind).spells(dat_paralizarpj)).palabrasmagicas & "�" & str(npclist(npcind).char.charindex))
        call npclanzaspellsobreuser(npcind, besttarget, npclist(npcind).spells(dat_paralizarpj)) ''spell 1 de clerigo es paralizar
        exit sub
    case 2  '' ataque a usuarios (invisibles tambien)
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�" & hechizos(npclist(npcind).spells(dat_tormentaavanzada)).palabrasmagicas & "�" & str(npclist(npcind).char.charindex))
        call npclanzaspellsobreuser2(npcind, besttarget, npclist(npcind).spells(dat_tormentaavanzada)) ''spell 2 de clerigo es vax on tar avanzado
        exit sub
    case 3  '' ataque a mascotas
        if not (npclist(besttarget).flags.paralizado = 1) then
            call npcparalizanpc(npcind, besttarget, dat_paralizar_npc)
            npclist(npcind).canattack = 0
        end if  ''todo: vax on tar sobre mascotas
    case 4  '' party healing
        call npccuranpc(npcind, besttarget, dat_curargraves)
        npclist(npcind).canattack = 0
    end select
    
    
    
    ''movimientos
    ''el clerigo no tiene un movimiento fijo, pero es esperable
    ''que no se aleje mucho del rey... y si se aleje de espaderos
    
    if npclist(npcind).flags.paralizado = 1 then exit sub
    
    if not (npcposm = mapa_pretoriano) then exit sub
    
    'mejora: si quedan solos, se van con el resto del ejercito
    if npclist(npcind).invent.armoureqpslot <> 0 then
        call cambiaralcoba(npcind)
        exit sub
    end if
    
    
    pjenind = mapdata(npcposm, npcposx - 1, npcposy).userindex
    if pjenind > 0 then
        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
            ''esta es una forma muy facil de matar 2 pajaros
            ''de un tiro. se aleja del usuario pq el centro va a
            ''estar ocupado, y a la vez se aproxima al rey, manteniendo
            ''una linea de defensa compacta
            call volveralcentro(npcind)
            exit sub
        end if
    end if
    
    pjenind = mapdata(npcposm, npcposx + 1, npcposy).userindex
    if pjenind > 0 then
        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
            call volveralcentro(npcind)
            exit sub
        end if
    end if
    
    pjenind = mapdata(npcposm, npcposx, npcposy - 1).userindex
    if pjenind > 0 then
        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
            call volveralcentro(npcind)
            exit sub
        end if
    end if
    
    pjenind = mapdata(npcposm, npcposx, npcposy + 1).userindex
    if pjenind > 0 then
        if not (userlist(pjenind).flags.muerto = 1) and not (userlist(pjenind).flags.invisible = 1) then
            call volveralcentro(npcind)
            exit sub
        end if
    end if
    
exit sub

errorh:
    logerror ("error en npcai.prcler_ai? ")
    
end sub

function esmagooclerigo(byval pjenind as integer) as boolean
on error goto errorh

    esmagooclerigo = userlist(pjenind).clase = "mago" or _
                        userlist(pjenind).clase = "clerigo" or _
                        userlist(pjenind).clase = "druida" or _
                        userlist(pjenind).clase = "bardo"
exit function

errorh:
    logerror ("error en npcai.esmagooclerigo? ")
end function

sub npcremuevevenenonpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcalind, npclist(npcalind).pos.map, "cfx" & npclist(npcalind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    npclist(npcalind).veneno = 0
    npclist(npcalind).flags.envenenado = 0

exit sub

errorh:
    logerror ("error en npcai.npcremuevevenenonpc? ")

end sub

sub npccuralevesnpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(tonpcarea, npcalind, npclist(npcalind).pos.map, "cfx" & npclist(npcalind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    
    if (npclist(npcalind).stats.minhp + 5 < npclist(npcalind).stats.maxhp) then
        npclist(npcalind).stats.minhp = npclist(npcalind).stats.minhp + 5
    else
        npclist(npcalind).stats.minhp = npclist(npcalind).stats.maxhp
    end if
    
exit sub

errorh:
    logerror ("error en npcai.npccuralevesnpc? ")
    
end sub


sub npcremueveparalisisnpc(byval npcind as integer, byval npcalind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(tonpcarea, npcalind, npclist(npcalind).pos.map, "cfx" & npclist(npcalind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    
    npclist(npcalind).contadores.paralisis = 0
    npclist(npcalind).flags.paralizado = 0
exit sub

errorh:
    logerror ("error en npcai.npcremueveparalisisnpc? ")

end sub

sub npcparalizanpc(byval paralizador as integer, byval paralizado as integer, byval indice)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(paralizador).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, paralizador, npclist(paralizador).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(paralizador).char.charindex))
    call senddata(tonpcarea, paralizador, npclist(paralizador).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(tonpcarea, paralizado, npclist(paralizado).pos.map, "cfx" & npclist(paralizado).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    'call senddata(tonpcarea, paralizador, npclist(paralizador).pos.map, "||" & vbcyan & "� hoax mantra �" & str(npclist(paralizador).char.charindex))
    'call senddata(tonpcarea, paralizador, npclist(paralizador).pos.map, "tw" & hechizos(npclist(paralizador).spells(1)).wav)
    'call senddata(tonpcarea, paralizado, npclist(paralizado).pos.map, "cfx" & npclist(paralizado).char.charindex & "," & hechizos(npclist(paralizador).spells(1)).fxgrh & "," & hechizos(npclist(paralizador).spells(1)).loops)
    npclist(paralizado).flags.paralizado = 1
    npclist(paralizado).contadores.paralisis = intervaloparalizado * 2

exit sub

errorh:
    logerror ("error en npcai.npcparalizanpc? ")

end sub

sub npccuranpc(byval curador as integer, byval curado as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    

    indireccion = npclist(curador).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, curador, npclist(curador).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(curador).char.charindex))
    call senddata(tonpcarea, curador, npclist(curador).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(tonpcarea, curado, npclist(curado).pos.map, "cfx" & npclist(curado).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    'call senddata(tonpcarea, curador, npclist(curador).pos.map, "||" & vbcyan & "�en corp sanctis�" & str(npclist(curador).char.charindex))
    'call senddata(tonpcarea, curador, npclist(curador).pos.map, "tw" & hechizos(npclist(curador).spells(3)).wav)
    'call senddata(tonpcarea, curado, npclist(curado).pos.map, "cfx" & npclist(curado).char.charindex & "," & hechizos(npclist(curador).spells(3)).fxgrh & "," & hechizos(npclist(curador).spells(3)).loops)
    if npclist(curado).stats.minhp + 30 > npclist(curado).stats.maxhp then
        npclist(curado).stats.minhp = npclist(curado).stats.maxhp
    else
        npclist(curado).stats.minhp = npclist(curado).stats.minhp + 30
    end if
exit sub

errorh:
    logerror ("error en npcai.npccuranpc? ")

end sub

sub npclanzaceguerapj(byval npcind as integer, byval pjenind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(topcarea, pjenind, userlist(pjenind).pos.map, "cfx" & userlist(pjenind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�cae xiti̇" & str(npclist(npcind).char.charindex))
    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(3).wav)
    'call senddata(tonpcarea, curado, npclist(curado).pos.map, "cfx" & npclist(curado).char.charindex & "," & hechizos(npclist(curador).spells(3)).fxgrh & "," & hechizos(npclist(curador).spells(3)).loops)
    
    userlist(pjenind).flags.ceguera = 1
    userlist(pjenind).counters.ceguera = intervaloinvisible
    ''envia ceguera
    call senddata(toindex, pjenind, 0, "cegu")
    ''bardea si es el rey
    if npclist(npcind).name = "rey pretoriano" then
        call senddata(toindex, pjenind, 0, "||el rey pretoriano te ha vuelto ciego " & fonttype_fight)
        call senddata(toindex, pjenind, 0, "||a la distancia escuchas las siguientes palabras: �cobarde, no eres digno de luchar conmigo si escapas! " & fonttype_veneno)
    end if

exit sub

errorh:
    logerror ("error en npcai.npclanzaceguerapj? ")
end sub

sub npclanzaestupidezpj(byval npcind as integer, byval pjenind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    

    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(topcarea, pjenind, userlist(pjenind).pos.map, "cfx" & userlist(pjenind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�async gam alڰ" & str(npclist(npcind).char.charindex))
    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(3).wav)
    'call senddata(tonpcarea, curado, npclist(curado).pos.map, "cfx" & npclist(curado).char.charindex & "," & hechizos(npclist(curador).spells(3)).fxgrh & "," & hechizos(npclist(curador).spells(3)).loops)
    userlist(pjenind).flags.estupidez = 1
    userlist(pjenind).counters.estupidez = intervaloinvisible
    'manda estupidez
    if encriptarprotocoloscriticos then
        call sendcrypteddata(toindex, pjenind, 0, "dumb")
    else
        call senddata(toindex, pjenind, 0, "dumb")
    end if
    'bardea si es el rey
    if npclist(npcind).name = "rey pretoriano" then
        call senddata(toindex, pjenind, 0, "||el rey pretoriano te ha vuelto est�pido " & fonttype_fight)
    end if
exit sub

errorh:
    logerror ("error en npcai.npclanzaestupidezpj? ")
end sub

sub npcremueveinvisibilidad(byval npcind as integer, byval pjenind as integer, byval indice as integer)
on error goto errorh
    dim indireccion as integer
    
    indireccion = npclist(npcind).spells(indice)
    '' envia las palabras magicas, fx y wav del indice-esimo hechizo del npc-hostiles.dat
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "� " & hechizos(indireccion).palabrasmagicas & " �" & str(npclist(npcind).char.charindex))
    call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(indireccion).wav)
    call senddata(topcarea, pjenind, userlist(pjenind).pos.map, "cfx" & userlist(pjenind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops + 4)

    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbcyan & "�an rohl �x ma�o�" & str(npclist(npcind).char.charindex))
    'call senddata(topcarea, pjenind, userlist(pjenind).pos.map, "cfx" & userlist(pjenind).char.charindex & "," & hechizos(4).fxgrh & "," & hechizos(4).loops + 4)
    'call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & hechizos(4).wav)
    
    call senddata(toindex, pjenind, 0, "||comienzas a hacerte visible." & fonttype_veneno)
    userlist(pjenind).counters.invisibilidad = intervaloinvisible - 1
    ''guarda, la invisiblidad corre para adelante y no para atras a diferencia de paralisis!!
    ''la invisiblidad se resetea cuando llega a intervaloinvisible
    'alta manera de zafar las distintas maneras de manejar la invisiblidad por los distintos servidors
    'gracias barrin por la idea ;-)
    
    'userlist(pjenind).flags.invisible = 0
    'call senddata(tomap, 0, userlist(pjenind).pos.map, "nover" & userlist(pjenind).char.charindex & ",0")
exit sub

errorh:
    logerror ("error en npcai.npcremueveinvisibilidad ")

end sub

sub npclanzaspellsobreuser2(byval npcindex as integer, byval userindex as integer, byval spell as integer)
on error goto errorh
''  igual a la otra pero ataca invisibles!!!
'' (malditos controles de casos imposibles...)

if npclist(npcindex).canattack = 0 then exit sub
'if userlist(userindex).flags.invisible = 1 then exit sub

npclist(npcindex).canattack = 0
dim da�o as integer

if hechizos(spell).subehp = 1 then

    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)

    userlist(userindex).stats.minhp = userlist(userindex).stats.minhp + da�o
    if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
    
    call senddata(toindex, userindex, 0, "||" & npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida." & fonttype_fight)

elseif hechizos(spell).subehp = 2 then
    
    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)

    if userlist(userindex).flags.privilegios = 0 then userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - da�o
    
    call senddata(toindex, userindex, 0, "||" & npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida." & fonttype_fight)
    
    'muere
    if userlist(userindex).stats.minhp < 1 then
        userlist(userindex).stats.minhp = 0
        call userdie(userindex)
    end if
    
end if

if hechizos(spell).paraliza = 1 then
     if userlist(userindex).flags.paralizado = 0 then
          userlist(userindex).flags.paralizado = 1
          userlist(userindex).counters.paralisis = intervaloparalizado
          call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
          call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)
          if encriptarprotocoloscriticos then
            call sendcrypteddata(toindex, userindex, 0, "paradok")
          else
            call senddata(toindex, userindex, 0, "paradok")
          end if
     end if
end if

exit sub

errorh:
    logerror ("error en npcai.npclanzaspellsobreuser2 ")


end sub



sub magodestruyewand(byval npcind as integer, byval bs as byte, byval indice as integer)
on error goto errorh
    ''sonidos: 30 y 32, y no los cambien sino termina siendo muy chistoso...
    ''para el fx utiliza el del hechizos(indice)
    dim x as integer
    dim y as integer
    dim pjind as integer
    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    dim danio as double
    dim dist as double
    dim danioi as integer
    dim mascotaind as integer
    dim indireccion as integer
    
    select case bs
        case 5
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "�rahma�" & str(npclist(npcind).char.charindex))
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_vivo)
        case 4
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "�v�rtax �" & str(npclist(npcind).char.charindex))
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_vivo)
        case 3
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "�zill�" & str(npclist(npcind).char.charindex))
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_vivo)
        case 2
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "�y�k� e'nta�" & str(npclist(npcind).char.charindex))
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_vivo)
        case 1
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "���kor�t�!!�" & str(npclist(npcind).char.charindex))
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_vivo)
        case 0
            call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbgreen & "� �" & str(npclist(npcind).char.charindex))
            call senddata(tomap, npcind, npclist(npcind).pos.map, "tw" & sonido_dragon_muerto)
            npcposx = npclist(npcind).pos.x
            npcposy = npclist(npcind).pos.y
            npcposm = npclist(npcind).pos.map
            pjind = 0
            indireccion = npclist(npcind).spells(indice)
            ''da�o masivo por destruccion de wand
            for x = 8 to 95
                for y = 8 to 95
                    pjind = mapdata(npcposm, x, y).userindex
                    mascotaind = mapdata(npcposm, x, y).npcindex
                    if pjind > 0 then
                        dist = sqr((userlist(pjind).pos.x - npcposx) ^ 2 + (userlist(pjind).pos.y - npcposy) ^ 2)
                        danio = 880 / (dist ^ (3 / 7))
                        danioi = abs(int(danio))
                        ''efectiviza el danio
                        if userlist(pjind).flags.privilegios = 0 then userlist(pjind).stats.minhp = userlist(pjind).stats.minhp - danioi
                        
                        call senddata(toindex, pjind, 0, "||" & npclist(npcind).name & " te ha quitado " & danioi & " puntos de vida al romper su vara." & fonttype_fight)
                        call senddata(topcarea, pjind, userlist(pjind).pos.map, "tw" & hechizos(indireccion).wav)
                        call senddata(topcarea, pjind, userlist(pjind).pos.map, "cfx" & userlist(pjind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
                        
                        if userlist(pjind).stats.minhp < 1 then
                            userlist(pjind).stats.minhp = 0
                            call userdie(pjind)
                        end if
                    
                    elseif (mascotaind > 0) then
                        if (npclist(mascotaind).maestrouser > 0) then
                        
                            dist = sqr((npclist(mascotaind).pos.x - npcposx) ^ 2 + (npclist(mascotaind).pos.y - npcposy) ^ 2)
                            danio = 880 / (dist ^ (3 / 7))
                            danioi = abs(int(danio))
                            ''efectiviza el danio
                            'if userlist(pjind).flags.privilegios = 0 then userlist(pjind).stats.minhp = userlist(pjind).stats.minhp - danioi
                            npclist(mascotaind).stats.minhp = npclist(mascotaind).stats.minhp - danioi
                            
                            'call senddata(toindex, pjind, 0, "||" & npclist(npcind).name & " te ha quitado " & danioi & " puntos de vida al romper su vara." & fonttype_fight)
                            call senddata(tonpcarea, mascotaind, npclist(mascotaind).pos.map, "tw" & hechizos(indireccion).wav)
                            call senddata(tonpcarea, mascotaind, npclist(mascotaind).pos.map, "cfx" & npclist(mascotaind).char.charindex & "," & hechizos(indireccion).fxgrh & "," & hechizos(indireccion).loops)
                            
                            if npclist(mascotaind).stats.minhp < 1 then
                                npclist(mascotaind).stats.minhp = 0
                                call muerenpc(mascotaind, 0)
                            end if
                        end if  ''es mascota
                    end if  ''hay npc
                    
                next y
            next x
    end select

exit sub

errorh:
    logerror ("error en npcai.magodestruyewand ")

end sub


sub greedywalkto(byval npcorig as integer, byval map as integer, byval x as integer, byval y as integer)
on error goto errorh
''  este procedimiento es llamado cada vez que un npc deba ir
''  a otro lugar en el mismo mapa. utiliza una t�cnica
''  de programaci�n greedy no determin�stica.
''  cada paso azaroso que me acerque al destino, es un buen paso.
''  si no hay mejor paso v�lido, entonces hay que volver atr�s y reintentar.
''  si no puedo moverme, me considero piketeado
''  la funcion es larga, pero es o(1) - orden algor�tmico temporal constante

dim npcx as integer
dim npcy as integer
dim usrx as integer
dim usry as integer
dim dual as integer
dim mapa as integer

if not (npclist(npcorig).pos.map = map) then exit sub   ''si son distintos mapas abort

npcx = npclist(npcorig).pos.x
npcy = npclist(npcorig).pos.y

if (npcx = x and npcy = y) then exit sub    ''ya llegu�!!


''  levanto las coordenadas del destino
usrx = x
usry = y
mapa = map

''  moverse
    if (npcx > usrx) then
        if (npcy < usry) then
            ''npc esta arriba a la derecha
            dual = randomnumber(0, 10)
            if ((dual mod 2) = 0) then ''move down
                if legalpos(mapa, npcx, npcy + 1) then
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy - 1) then
                    call moverarr(npcorig)
                    exit sub
                else
                    ''aqui no puedo ir a ningun lado. hay q ver si me bloquean caspers
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
                
            else        ''random first move
                if legalpos(mapa, npcx - 1, npcy) then
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy - 1) then
                    call moverarr(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            end if  ''checked random first move
        elseif (npcy > usry) then   ''npc esta abajo a la derecha
            dual = randomnumber(0, 10)
            if ((dual mod 2) = 0) then ''move up
                if legalpos(mapa, npcx, npcy - 1) then  ''u
                    call moverarr(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then  ''l
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                    call moverder(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            else    ''random first move
                if legalpos(mapa, npcx - 1, npcy) then  ''l
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                    call moverder(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            end if  ''endif random first move
        else    ''x completitud, esta en la misma y
            if legalpos(mapa, npcx - 1, npcy) then  ''l
                call moverizq(npcorig)
                exit sub
            elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                call moveraba(npcorig)
                exit sub
            elseif legalpos(mapa, npcx, npcy - 1) then  ''u
                call moverarr(npcorig)
                exit sub
            else
                ''si me muevo abajo entro en loop. aca el algoritmo falla
                if npclist(npcorig).canattack = 1 and (randomnumber(1, 100) > 95) then
                    call senddata(tonpcarea, npcorig, npclist(npcorig).pos.map, "||" & vbyellow & "�maldito bastardo, � ven aqu� !�" & str(npclist(npcorig).char.charindex))
                    npclist(npcorig).canattack = 0
                end if
            end if
        end if
    
    elseif (npcx < usrx) then
        
        if (npcy < usry) then
            ''npc esta arriba a la izquierda
            dual = randomnumber(0, 10)
            if ((dual mod 2) = 0) then ''move down
                if legalpos(mapa, npcx, npcy + 1) then  ''aba
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy - 1) then
                    call moverarr(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            else    ''random first move
                if legalpos(mapa, npcx + 1, npcy) then  ''der
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then  ''aba
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy - 1) then
                    call moverarr(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            end if
        
        elseif (npcy > usry) then   ''npc esta abajo a la izquierda
            dual = randomnumber(0, 10)
            if ((dual mod 2) = 0) then ''move up
                if legalpos(mapa, npcx, npcy - 1) then  ''u
                    call moverarr(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then  ''l
                    call moverizq(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                    call moveraba(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            else
                if legalpos(mapa, npcx + 1, npcy) then  ''r
                    call moverder(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy - 1) then  ''u
                    call moverarr(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                    call moveraba(npcorig)
                    exit sub
                elseif legalpos(mapa, npcx - 1, npcy) then  ''l
                    call moverizq(npcorig)
                    exit sub
                else
                    if casperblock(npcorig) then call liberarcasperblock(npcorig)
                end if
            end if
        else    ''x completitud, esta en la misma y
            if legalpos(mapa, npcx + 1, npcy) then  ''r
                call moverder(npcorig)
                exit sub
            elseif legalpos(mapa, npcx, npcy + 1) then  ''d
                call moveraba(npcorig)
                exit sub
            elseif legalpos(mapa, npcx, npcy - 1) then  ''u
                call moverarr(npcorig)
                exit sub
            else
                ''si me muevo loopeo. aca falla el algoritmo
                if npclist(npcorig).canattack = 1 and (randomnumber(1, 100) > 95) then
                    call senddata(tonpcarea, npcorig, npclist(npcorig).pos.map, "||" & vbyellow & "�maldito bastardo, � ven aqu� !�" & str(npclist(npcorig).char.charindex))
                    npclist(npcorig).canattack = 0
                end if
            end if
        end if
    
    
    else ''igual x
        if (npcy > usry) then    ''npc esta abajo
            if legalpos(mapa, npcx, npcy - 1) then  ''u
                call moverarr(npcorig)
                exit sub
            elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                call moverder(npcorig)
                exit sub
            elseif legalpos(mapa, npcx - 1, npcy) then  ''l
                call moverizq(npcorig)
                exit sub
            else
                ''aca tambien falla el algoritmo
                if npclist(npcorig).canattack = 1 and (randomnumber(1, 100) > 95) then
                    call senddata(tonpcarea, npcorig, npclist(npcorig).pos.map, "||" & vbyellow & "�maldito bastardo, � ven aqu� !�" & str(npclist(npcorig).char.charindex))
                    npclist(npcorig).canattack = 0
                end if
            end if
        else    ''npc esta arriba
            if legalpos(mapa, npcx, npcy + 1) then  ''aba
                call moveraba(npcorig)
                exit sub
            elseif legalpos(mapa, npcx + 1, npcy) then  ''r
                call moverder(npcorig)
                exit sub
            elseif legalpos(mapa, npcx - 1, npcy) then  ''l
                call moverizq(npcorig)
                exit sub
            else
                ''posible loop
                if npclist(npcorig).canattack = 1 and (randomnumber(1, 100) > 95) then
                    call senddata(tonpcarea, npcorig, npclist(npcorig).pos.map, "||" & vbyellow & "�maldito bastardo, � ven aqu� !�" & str(npclist(npcorig).char.charindex))
                    npclist(npcorig).canattack = 0
                end if
            end if
        end if
    end if

exit sub

errorh:
    logerror ("error en npcai.greedywalkto")

end sub


sub moveraba(byval npcorig as integer)
on error goto errorh

    dim mapa as integer
    dim npcx as integer
    dim npcy as integer
    mapa = npclist(npcorig).pos.map
    npcx = npclist(npcorig).pos.x
    npcy = npclist(npcorig).pos.y

    call senddata(tomap, 0, npclist(npcorig).pos.map, "mp" & npclist(npcorig).char.charindex & "," & npcx & "," & npcy + 1)
    'update map and npc pos
    mapdata(mapa, npcx, npcy).npcindex = 0
    npclist(npcorig).pos.y = npcy + 1
    npclist(npcorig).char.heading = south
    mapdata(mapa, npcx, npcy + 1).npcindex = npcorig
exit sub

errorh:
    logerror ("error en npcai.moveraba ")

end sub

sub moverarr(byval npcorig as integer)
on error goto errorh

    dim mapa as integer
    dim npcx as integer
    dim npcy as integer
    mapa = npclist(npcorig).pos.map
    npcx = npclist(npcorig).pos.x
    npcy = npclist(npcorig).pos.y
    
    call senddata(tomap, 0, npclist(npcorig).pos.map, "mp" & npclist(npcorig).char.charindex & "," & npcx & "," & npcy - 1)
    'update map and npc pos
    mapdata(mapa, npcx, npcy).npcindex = 0
    npclist(npcorig).pos.y = npcy - 1
    npclist(npcorig).char.heading = north
    mapdata(mapa, npcx, npcy - 1).npcindex = npcorig
exit sub

errorh:
    logerror ("error en npcai.moverarr")
end sub

sub moverizq(byval npcorig as integer)
on error goto errorh

    dim mapa as integer
    dim npcx as integer
    dim npcy as integer
    mapa = npclist(npcorig).pos.map
    npcx = npclist(npcorig).pos.x
    npcy = npclist(npcorig).pos.y

    call senddata(tomap, 0, npclist(npcorig).pos.map, "mp" & npclist(npcorig).char.charindex & "," & npcx - 1 & "," & npcy)
    'update map and npc pos
    mapdata(mapa, npcx, npcy).npcindex = 0
    npclist(npcorig).pos.x = npcx - 1
    npclist(npcorig).char.heading = west
    mapdata(mapa, npcx - 1, npcy).npcindex = npcorig

exit sub

errorh:
    logerror ("error en npcai.moverizq")

end sub

sub moverder(byval npcorig as integer)
on error goto errorh

    dim mapa as integer
    dim npcx as integer
    dim npcy as integer
    mapa = npclist(npcorig).pos.map
    npcx = npclist(npcorig).pos.x
    npcy = npclist(npcorig).pos.y
    
    call senddata(tomap, 0, npclist(npcorig).pos.map, "mp" & npclist(npcorig).char.charindex & "," & npcx + 1 & "," & npcy)
    'update map and npc pos
    mapdata(mapa, npcx, npcy).npcindex = 0
    npclist(npcorig).pos.x = npcx + 1
    npclist(npcorig).char.heading = east
    mapdata(mapa, npcx + 1, npcy).npcindex = npcorig
exit sub

errorh:
    logerror ("error en npcai.moverder")

end sub


sub volveralcentro(byval npcind as integer)
on error goto errorh
    
    dim npcposx as integer
    dim npcposy as integer
    dim npcmap as integer
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    npcmap = npclist(npcind).pos.map
    
    if npcmap = mapa_pretoriano then
        ''35,25 y 67,25 son las posiciones del rey
        if npcposx < 50 then    ''esta a la izquierda
            call greedywalkto(npcind, npcmap, alcoba1_x, alcoba1_y)
            'greedywalkto npcind, npcmap, 35, 25
        else
            call greedywalkto(npcind, npcmap, alcoba2_x, alcoba2_y)
            'greedywalkto npcind, npcmap, 67, 25
        end if
    end if

exit sub

errorh:
    logerror ("error en npcai.volveralcentro")

end sub

function estoymuylejos(byval npcind) as boolean
''me dice si estoy fuera del anillo exterior de proteccion
''de los clerigos
    
    dim retvalue as boolean
    
    'if npclist(npcind).pos.x < 50 then
    '    retvalue = npclist(npcind).pos.x < 43 and npclist(npcind).pos.x > 27
    'else
    '    retvalue = npclist(npcind).pos.x < 80 and npclist(npcind).pos.x > 59
    'end if
    
    retvalue = npclist(npcind).pos.y > 39
    
    if not npclist(npcind).pos.map = mapa_pretoriano then
        estoymuylejos = false
    else
        estoymuylejos = retvalue
    end if

exit function

errorh:
    logerror ("error en npcai.estoymuylejos")

end function

function estoylejos(byval npcind) as boolean
on error goto errorh

    ''35,25 y 67,25 son las posiciones del rey
    ''esta fction me indica si estoy lejos del rango de vision
    
    
    dim retvalue as boolean
    
    if npclist(npcind).pos.x < 50 then
        retvalue = npclist(npcind).pos.x < 43 and npclist(npcind).pos.x > 27
    else
        retvalue = npclist(npcind).pos.x < 75 and npclist(npcind).pos.x > 59
    end if
    
    retvalue = retvalue and npclist(npcind).pos.y > 19 and npclist(npcind).pos.y < 31
    
    if not npclist(npcind).pos.map = mapa_pretoriano then
        estoylejos = false
    else
        estoylejos = not retvalue
    end if

exit function

errorh:
    logerror ("error en npcai.estoylejos")

end function

function esalcanzable(byval npcind as integer, byval pjenind as integer) as boolean
on error goto errorh
    
    ''esta funcion es especialmente hecha para el mapa pretoriano
    ''est� dise�ada para que se ignore a los pjs que estan demasiado lejos
    ''evitando asi que los "lockeen" en la pelea sacandolos de combate
    ''sin matarlos. la fcion es totalmente inutil si los npcs estan en otro mapa.
    ''chequea la posibilidad que les hagan /racc desde otro mapa para evitar
    ''malos comportamientos
    ''35,25 y 67,25 son las posiciones del rey
''on error resume next


    dim retvalue as boolean
    dim retvalue2 as boolean
    
    dim pjposx as integer
    dim pjposy as integer
    dim npcposx as integer
    dim npcposy as integer
    
    pjposx = userlist(pjenind).pos.x
    pjposy = userlist(pjenind).pos.y
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    
    if (npclist(npcind).pos.map = mapa_pretoriano) and (userlist(pjenind).pos.map = mapa_pretoriano) then
        ''los bounds del mapa pretoriano son fijos.
        ''esta en una posicion alcanzable si esta dentro del
        ''espacio de las alcobas reales del mapa dise�ado por mi.
        ''y dentro de la alcoba en el rango del perimetro de defensa
        '' 8+8+8+8 x 7+7+7+7
        retvalue = pjposx > 18 and pjposx < 49 and npcposx <= 51 'and npcposx < 49
        retvalue = retvalue and (pjposy > 14 and pjposy < 40) 'and npcposy > 14 and npcposy < 50)
        retvalue2 = pjposx > 52 and pjposx < 81 and npcposx > 51 'and npcposx < 81
        retvalue2 = retvalue2 and (pjposy > 14 and pjposy < 40) 'and npcposy > 14 and npcposy < 50)
        ''rv dice si estan en la alcoba izquierda los 2 y en zona valida de combate
        ''rv2 dice si estan en la derecha
        retvalue = retvalue or retvalue2
        'if retvalue = false then
        '    if npclist(npcind).canattack = 1 then
        '        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "�� cobarde !�" & str(npclist(npcind).char.charindex))
        '        npclist(npcind).canattack = 0
        '    end if
        'end if
    else
        retvalue = false
    end if
    
    esalcanzable = retvalue
     
exit function

errorh:
    logerror ("error en npcai.esalcanzable")
 
 
end function



function casperblock(byval npc as integer) as boolean
on error goto errorh
    
    dim npcposm as integer
    dim npcposx as integer
    dim npcposy as integer
    dim pj as integer
    
    dim retvalue as boolean
    
    npcposx = npclist(npc).pos.x
    npcposy = npclist(npc).pos.y
    npcposm = npclist(npc).pos.map
    
    retvalue = not (legalpos(npcposm, npcposx + 1, npcposy) or _
                legalpos(npcposm, npcposx - 1, npcposy) or _
                legalpos(npcposm, npcposx, npcposy + 1) or _
                legalpos(npcposm, npcposx, npcposy - 1))
                
    if retvalue then
        ''si son todas invalidas
        ''busco que algun casper sea causante de piketeo
        retvalue = false

        pj = mapdata(npcposm, npcposx + 1, npcposy).userindex
        if pj > 0 then
            retvalue = userlist(pj).flags.muerto = 1
        end if
        
        pj = mapdata(npcposm, npcposx - 1, npcposy).userindex
        if pj > 0 then
            retvalue = retvalue or userlist(pj).flags.muerto = 1
        end if
        
        pj = mapdata(npcposm, npcposx, npcposy + 1).userindex
        if pj > 0 then
            retvalue = retvalue or userlist(pj).flags.muerto = 1
        end if
        
        pj = mapdata(npcposm, npcposx, npcposy - 1).userindex
        if pj > 0 then
            retvalue = retvalue or userlist(pj).flags.muerto = 1
        end if
        
    else
        retvalue = false
    
    end if
    
    casperblock = retvalue
    exit function

errorh:
'    msgbox ("error!!")
    casperblock = false
    logerror ("error en npcai.casperblock")

end function


sub liberarcasperblock(byval npcind as integer)
on error goto errorh

    dim npcposx as integer
    dim npcposy as integer
    dim npcposm as integer
    
    npcposx = npclist(npcind).pos.x
    npcposy = npclist(npcind).pos.y
    npcposm = npclist(npcind).pos.map
    
    if legalpos(npcposm, npcposx + 1, npcposy + 1) then
        call senddata(tomap, 0, npcposm, "mp" & npclist(npcind).char.charindex & "," & npcposx + 1 & "," & npcposy + 1)
        'update map and npc pos
        mapdata(npcposm, npcposx, npcposy).npcindex = 0
        npclist(npcind).pos.y = npcposy + 1
        npclist(npcind).pos.x = npcposx + 1
        npclist(npcind).char.heading = south
        mapdata(npcposm, npcposx + 1, npcposy + 1).npcindex = npcind
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "���ja ja ja ja!!�" & str(npclist(npcind).char.charindex))
        exit sub
    end if

    if legalpos(npcposm, npcposx - 1, npcposy - 1) then
        call senddata(tomap, 0, npcposm, "mp" & npclist(npcind).char.charindex & "," & npcposx - 1 & "," & npcposy - 1)
        'update map and npc pos
        mapdata(npcposm, npcposx, npcposy).npcindex = 0
        npclist(npcind).pos.y = npcposy - 1
        npclist(npcind).pos.x = npcposx - 1
        npclist(npcind).char.heading = north
        mapdata(npcposm, npcposx - 1, npcposy - 1).npcindex = npcind
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "���ja ja ja ja!!�" & str(npclist(npcind).char.charindex))
        exit sub
    end if

    if legalpos(npcposm, npcposx + 1, npcposy - 1) then
        call senddata(tomap, 0, npcposm, "mp" & npclist(npcind).char.charindex & "," & npcposx + 1 & "," & npcposy - 1)
        'update map and npc pos
        mapdata(npcposm, npcposx, npcposy).npcindex = 0
        npclist(npcind).pos.y = npcposy - 1
        npclist(npcind).pos.x = npcposx + 1
        npclist(npcind).char.heading = east
        mapdata(npcposm, npcposx + 1, npcposy - 1).npcindex = npcind
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "���ja ja ja ja!!�" & str(npclist(npcind).char.charindex))
        exit sub
    end if
    
    if legalpos(npcposm, npcposx - 1, npcposy + 1) then
        call senddata(tomap, 0, npcposm, "mp" & npclist(npcind).char.charindex & "," & npcposx - 1 & "," & npcposy + 1)
        'update map and npc pos
        mapdata(npcposm, npcposx, npcposy).npcindex = 0
        npclist(npcind).pos.y = npcposy + 1
        npclist(npcind).pos.x = npcposx - 1
        npclist(npcind).char.heading = west
        mapdata(npcposm, npcposx - 1, npcposy + 1).npcindex = npcind
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "���ja ja ja ja!!�" & str(npclist(npcind).char.charindex))
        exit sub
    end if
    
    ''si esta aca, estamos fritos!
    if npclist(npcind).canattack = 1 then
        call senddata(tonpcarea, npcind, npclist(npcind).pos.map, "||" & vbyellow & "��por las barbas de los antiguos reyes! �alej�os endemoniados espectros o sufrir�is la furia de los dioses!�" & str(npclist(npcind).char.charindex))
        npclist(npcind).canattack = 0
    end if
    
exit sub

errorh:
    logerror ("error en npcai.liberarcasperblock")

end sub

public sub cambiaralcoba(byval npcind as integer)
on error goto errorh

    select case npclist(npcind).invent.armoureqpslot
        case 2
            call greedywalkto(npcind, mapa_pretoriano, 48, 70)
            if npclist(npcind).pos.x = 48 and npclist(npcind).pos.y = 70 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 6
            call greedywalkto(npcind, mapa_pretoriano, 52, 71)
            if npclist(npcind).pos.x = 52 and npclist(npcind).pos.y = 71 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 1
            call greedywalkto(npcind, mapa_pretoriano, 73, 56)
            if npclist(npcind).pos.x = 73 and npclist(npcind).pos.y = 56 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 7
            call greedywalkto(npcind, mapa_pretoriano, 73, 48)
            if npclist(npcind).pos.x = 73 and npclist(npcind).pos.y = 48 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 5
            call greedywalkto(npcind, mapa_pretoriano, 31, 56)
            if npclist(npcind).pos.x = 31 and npclist(npcind).pos.y = 56 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 3
            call greedywalkto(npcind, mapa_pretoriano, 31, 48)
            if npclist(npcind).pos.x = 31 and npclist(npcind).pos.y = 48 then npclist(npcind).invent.armoureqpslot = npclist(npcind).invent.armoureqpslot + 1
        case 4, 8
            npclist(npcind).invent.armoureqpslot = 0
            exit sub
    end select

exit sub
errorh:
call logerror("error en cambiaralcoba " & err.description)
end sub
