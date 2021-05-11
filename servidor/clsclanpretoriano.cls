version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsclanpretoriano"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clsclanpretoriano - handles the praeorians npcs.
'
' designed (original version) by mariano barrou (el oso)
' redesigned by zama
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

'####################
' pretorians map vars (only used for the default map)
private leftspawnpos as worldpos
private rightspawnpos as worldpos

'####################
'actions and spells

' king
private enum ekingspells
    littleheal = 1
    removeparalisis = 2
    blindattack = 3
    stupidityattack = 4
    healpoison = 5
end enum

private enum ekingaction
    healallyparalisis = 1
    healallypoison
    healally
    chasetarget
    massiveattack
    retreatandheal
end enum

' healer
private enum ehealeraction
    healallyparalisis = 1
    paralizepet
    paralizeuser
    attackuser
    healally
    rescuefarally
end enum

private enum ehealerspells
    paralizeuser = 1
    removeparalisis = 2
    paralizenpc = 3
    heal = 4
    tormenta = 5
end enum

' spellcaster
private enum espellcasteraction
    removeinvi = 1
    attack
end enum

private enum espellcasterspells
    apocalipsis = 1
    remoinvi = 2
end enum

' thief
private enum ethiefaction
    attack = 1
    steal
    none
end enum

private enum ethiefspells
    arrow = 1
    paralisis = 2
end enum

' indicates wether the clan is active or not
private clanactive as boolean

' max distance for the thief to steal
private const thief_steal_distance as integer = 2

' countdown to break the spellcaster's wand
private wandbreakcounter as integer
' number from wich starts countdown
private const max_wand_break_value as integer = 6
' min hp needed for spellcaster to start countdown
private const start_countdown_min_hp as integer = 750

' time in which the king hasn't done anything
private kingidletime as long
' time needed for respawning an ally (aprox 5 min)
private const ally_respawn_time as long = 2000

' max distance to follow a user, or separate from team
private const max_distance as integer = 14
' number of total clan members
private const nro_pretorianos as integer = 9

' indicates clan map and king position
private centerpos  as worldpos
' indicates if the clan is spawned after being defeated
private respawnclan as boolean
' the number of clan members still alive
private clanmembersalive as integer

private type tpretoriandata
    npcindex as integer
    npcai as epretorianai
end type

' indice del clan pretoriano
private clanindex as integer

' contiene los index de los miembros del clan.
private pretorianos() as tpretoriandata

public function spawnclan(byval mapa as integer, byval x as integer, byval y as integer, _
                          byval pretoclanindex as integer, optional byval respawning as boolean = false) as boolean
'********************************************************
'author: el oso
'inicializa el clan pretoriano.
'last modify date: 21/09/2010
'22/06/2006: (nacho) - seteamos cuantos npcs creamos
'21/09/2010: zama - reescribi la funcion, ahora se le pasa las coordenadas de respawn
'********************************************************
on error goto errhandler

    dim npos as worldpos
    dim pretoindex as integer
    
    ' initial pos
    centerpos.map = mapa
    centerpos.x = x
    centerpos.y = y
    
    redim pretorianos(1 to nro_pretorianos) as tpretoriandata
    
    clanindex = pretoclanindex
    
    ' check valid spawn place only if it's the first time
    if not respawning then
        ' the clan only respawns on pretorian map
        if mapa = mapa_pretoriano then
            respawnclan = true
            call initializepretoriansvars
            
            ' default coordinates, override admin choise
            centerpos = leftspawnpos
            
        ' check if it's a valid area to respawn
        else
            if not isvalidspawnarea() then exit function
        end if
    end if

    npos = centerpos

    ' spawn clan members
    clanmembersalive = nro_pretorianos
    
    ' spawn king
    pretoindex = pretoindex + 1
    call spawnpretorian(npos, epretorianai.king, pretoindex, true)
    
    ' spawn 2 healers
    pretoindex = pretoindex + 1
    npos.x = npos.x + 3
    call spawnpretorian(npos, epretorianai.healer, pretoindex)
    
    pretoindex = pretoindex + 1
    npos.x = npos.x - 6
    call spawnpretorian(npos, epretorianai.healer, pretoindex)
    
    ' spawn 3 sword masters
    pretoindex = pretoindex + 1
    npos.y = npos.y + 3
    call spawnpretorian(npos, epretorianai.swordmaster, pretoindex)
    
    pretoindex = pretoindex + 1
    npos.x = npos.x + 3
    call spawnpretorian(npos, epretorianai.swordmaster, pretoindex)
    
    pretoindex = pretoindex + 1
    npos.x = npos.x + 3
    call spawnpretorian(npos, epretorianai.swordmaster, pretoindex)
    
    ' sapwn 1 shooter
    pretoindex = pretoindex + 1
    npos.y = npos.y - 6
    npos.x = npos.x - 1
    call spawnpretorian(npos, epretorianai.shooter, pretoindex)
    
    ' spawn 1 spellcaster
    pretoindex = pretoindex + 1
    npos.x = npos.x - 4
    call spawnpretorian(npos, epretorianai.spellcaster, pretoindex)
    
    ' spawn 1 thief
    pretoindex = pretoindex + 1
    call spawnpretorian(npos, epretorianai.thief, pretoindex)

    ' reset wand break counter
    wandbreakcounter = max_wand_break_value
    
    ' now is active
    clanactive = true
    
    ' clan creation success
    spawnclan = true

    exit function

errhandler:
    logerror ("error en crearclanpretoriano. error: " & err.number & " - " & err.description)
end function

private function isvalidspawnarea() as boolean
'********************************************************
'author: zama
'checks if it's a clean area to respawn the clan.
'required conditions:
'-> a 12x12 square free of blocks and in map bounds.
'-> must be a non-water terrain
'last modify date: 21/09/2010
'********************************************************
    
    dim loopx as long
    dim loopy as long
    
    for loopx = centerpos.x - 6 to centerpos.x + 6
        for loopy = centerpos.y - 6 to centerpos.y + 6
            
            if not inmapbounds(centerpos.map, loopx, loopy) then exit function
            
            if hayagua(centerpos.map, loopx, loopy) then exit function
            
        next loopy
    next loopx
    
    isvalidspawnarea = true
    
end function

private sub initializepretoriansvars()
'********************************************************
'author: zama
'initialize the variables/const used in pretorian map
'last modify date: 21/09/2010
'********************************************************

    leftspawnpos.map = mapa_pretoriano
    leftspawnpos.x = 35
    leftspawnpos.y = 25
    
    rightspawnpos.map = mapa_pretoriano
    rightspawnpos.x = 67
    rightspawnpos.y = 25
    
end sub

private sub spawnpretorian(byref spawnpos as worldpos, byval pretorianai as byte, byval pretoindex as integer, _
                           optional byval isking as boolean = false)
'********************************************************
'author: zama
'spawns the pretorian in the given position.
'last modify date: 21/09/2010
'********************************************************

    dim finalpos as worldpos
    dim npcindex as integer
    dim head as integer
    
    dim pretodatnumber as integer
    pretodatnumber = randomnumber(pretorianaioffset(pretorianai), _
                                  pretorianaioffset(pretorianai + 1) - 1)
                            
    ' odd numbers are tall races
    if (pretodatnumber and 1) = 1 then
        head = randomtallhead
    else
        head = randomshorthead
    end if
                      
    ' the king has to spawn always in the given position
    if isking then
        
        ' check if there's any npc in the king's position
        dim othernpcindex as integer
        othernpcindex = mapdata(spawnpos.map, spawnpos.x, spawnpos.y).npcindex
        
        ' found one
        if othernpcindex <> 0 then
            ' move it to the closest legal position
            call closestlegalpos(spawnpos, finalpos)
            if finalpos.x <> 0 and finalpos.y <> 0 then
                call senddata(sendtarget.tonpcarea, othernpcindex, _
                    preparemessagecharactermove(npclist(othernpcindex).char.charindex, finalpos.x, finalpos.y))
                ' update map and npc pos
                mapdata(spawnpos.map, spawnpos.x, spawnpos.y).npcindex = 0
                npclist(othernpcindex).pos = finalpos
                mapdata(finalpos.map, finalpos.x, finalpos.y).npcindex = othernpcindex
            
                ' king's position is now empty
                finalpos = spawnpos
            
            ' couldn't find a legal pos => remove it
            else
                call quitarnpc(othernpcindex)
            end if
        else
            finalpos = spawnpos
        end if
        
    ' other clan member doesn't have to spawn in the exact position
    else
        call closestlegalpos(spawnpos, finalpos, false, true)
    end if
                            
    ' create and spawn npc
    npcindex = crearnpc(pretoriandatnumbers(pretodatnumber), finalpos.map, finalpos, head)
    
    ' store index
    pretorianos(pretoindex).npcindex = npcindex
    pretorianos(pretoindex).npcai = pretorianai
    
    ' asign clanindex
    npclist(npcindex).clanindex = clanindex
    
end sub

private function randomtallhead()
'********************************************************
'author: zama
'gets a random tall race's head.
'last modify date: 21/09/2010
'********************************************************
    
    ' 3 tall races
    dim raza as integer
    raza = randomnumber(1, 3)
        
    ' male
    if (randomnumber(0, 1) = 1) then
        
        ' human
        if raza = 1 then
            randomtallhead = randomnumber(humano_h_primer_cabeza, humano_h_ultima_cabeza)
        ' elf
        elseif raza = 2 then
            randomtallhead = randomnumber(elfo_h_primer_cabeza, elfo_h_ultima_cabeza)
        ' drow
        else
            randomtallhead = randomnumber(drow_h_primer_cabeza, drow_h_ultima_cabeza)
        end if
        
    ' female
    else
        
        ' human
        if raza = 1 then
            randomtallhead = randomnumber(humano_m_primer_cabeza, humano_m_ultima_cabeza)
        ' elf
        elseif raza = 2 then
            randomtallhead = randomnumber(elfo_m_primer_cabeza, elfo_m_ultima_cabeza)
        ' drow
        else
            randomtallhead = randomnumber(drow_m_primer_cabeza, drow_m_ultima_cabeza)
        end if
        
    end if
    
end function

private function randomshorthead()
'********************************************************
'author: zama
'gets a random short race's head.
'last modify date: 21/09/2010
'********************************************************

    ' 2 short races
    dim raza as integer
    raza = randomnumber(1, 2)
        
    ' male
    if (randomnumber(0, 1) = 1) then
        
        ' dwarf
        if raza = 1 then
            randomshorthead = randomnumber(enano_h_primer_cabeza, enano_h_ultima_cabeza)
        ' gnome
        else
            randomshorthead = randomnumber(gnomo_h_primer_cabeza, gnomo_h_ultima_cabeza)
        end if
        
    ' female
    else
        
        ' dwarf
        if raza = 1 then
            randomshorthead = randomnumber(enano_m_primer_cabeza, enano_m_ultima_cabeza)
        ' gnome
        else
            randomshorthead = randomnumber(gnomo_m_primer_cabeza, gnomo_m_ultima_cabeza)
        end if
        
    end if

end function

public sub performpretorianai(byval npcindex as integer)
'********************************************************
'author: zama
'performs pretorian's ai.
'last modify date: 21/09/2010
'********************************************************
    
    dim pretorianai as byte
    pretorianai = getpretorianai(npcindex)
    
    select case pretorianai
        
        case epretorianai.king
            call ai_king(npcindex)
            
        case epretorianai.healer
            call ai_healer(npcindex)
            
        case epretorianai.spellcaster
            call ai_spellcaster(npcindex)
            
        case epretorianai.swordmaster
            call ai_swordmaster(npcindex)
            
        case epretorianai.shooter
            call ai_shooter(npcindex)
            
        case epretorianai.thief
            call ai_thief(npcindex)
            
    end select
    
end sub

private function getpretorianai(byval npcindex as integer) as byte
'********************************************************
'author: zama
'returns the pretorian's ai for the given npc.
'last modify date: 21/09/2010
'********************************************************
    
    dim counter as long
    
    for counter = 1 to nro_pretorianos
        if pretorianos(counter).npcindex = npcindex then
            getpretorianai = pretorianos(counter).npcai
            exit function
        end if
    next counter
    
end function

public sub ai_king(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 19/09/2010
'***************************************************
on error goto errhandler

    dim besttarget as integer
    dim action as byte
    
    besttarget = kingbesttarget(npcindex, action)
    
    call kingperformaction(npcindex, besttarget, action)
    
    exit sub

errhandler:
    logerror ("error en ai_king. error: " & err.number & " - " & err.description)
end sub

private function kingbesttarget(byval npcindex as integer, byref accion as byte) as integer
'***************************************************
'author: zama
'last modification: 05/07/2010
'pick the best target according to the following criteria:
'1) first try to heal status effects on allies (paralisis, poison, damaged) if any is alive
'2) if no ally is alive, then start a melee atack to near users
'3) if a user tries to run, then blind and make him stupid
'4) if no one is near, then heal himself.
'***************************************************
on error goto errhandler
    
    dim besttarget as integer

    ' there should be more than one in order to support
    if clanmembersalive <> 1 then

        ' chooses target only if can attack
        if npclist(npcindex).canattack = 1 then
            ' first checks if any ally is paralized in order to remove its paralizis
            besttarget = allyparalyzed(npcindex, false)
            if besttarget <> 0 then
                ' 20% of probability of doing it
                if randomnumber(1, 100) < 21 then
                    accion = ekingaction.healallyparalisis
                end if
            else
                ' now checks if any ally is poisoned in order to remove its poison
                besttarget = allypoisoned(npcindex)
                if besttarget <> 0 then
                    accion = ekingaction.healallypoison
                else
                    ' if no target found, then try to heal injured allies
                    besttarget = allyinjured(npcindex)
                    if besttarget <> 0 then
                        accion = ekingaction.healally
                    end if
                end if
            end if
        end if
    
    ' king's alone
    else
        
        dim mapa as integer
        dim npcposx as integer
        dim npcposy as integer
        
        dim userindex as integer
        dim counter as long
        
        dim besttargetdistance as integer
        dim distance as integer
        
        with npclist(npcindex).pos
            mapa = .map
            npcposx = .x
            npcposy = .y
        end with
        
        dim counterstart as long
        dim counterend as long
        dim counterstep as long
        
        ' to avoid that all attack the same target
        counterstep = randomnumber(0, 1)
        if counterstep = 1 then
            counterstart = 1
            counterend = modareas.conngroups(mapa).countentrys
        else
            counterstart = modareas.conngroups(mapa).countentrys
            counterend = 1
            counterstep = -1
        end if
        
        ' search for the best user target
        for counter = counterstart to counterend step counterstep
        
            userindex = modareas.conngroups(mapa).userentrys(counter)
            
            'is it in it's range of vision??
            if invisionrange(userindex, npcposx, npcposy) then
                ' can be atacked? if it's blinded, doesn't count.
                if useratacable(userindex) and userlist(userindex).flags.ceguera = 0 then
                    ' if previous user choosen, select the better
                    if besttarget <> 0 then
                        ' has priority to attack the nearest
                        distance = userdistance(userindex, npcposx, npcposy)
                        
                        if distance < besttargetdistance then
                            besttarget = userindex
                            besttargetdistance = distance
                        end if
                    else
                        besttarget = userindex
                        besttargetdistance = userdistance(userindex, npcposx, npcposy)
                    end if
                end if
            end if
                
        next counter
        
        ' any target found?
        if besttarget <> 0 then
            ' is reachable?
            if userreachable(npcindex, besttarget) then
                ' chase it
                accion = ekingaction.chasetarget
            
            ' the target is trying to escape => stop him with a massive status attack
            else
                accion = ekingaction.massiveattack
            end if
            
        ' no target found => retreat and heal
        else
            accion = ekingaction.retreatandheal
        end if
    end if

    kingbesttarget = besttarget

    exit function

errhandler:
    logerror ("error en kingbesttarget. error: " & err.number & " - " & err.description)
end function

private sub kingperformaction(byval npcindex as integer, byval besttarget as integer, byval accion as byte)
'***************************************************
'author: zama
'last modification: 05/07/2010
'performs the required action.
'***************************************************
on error goto errhandler

    dim idletime as long

    with npclist(npcindex)
        select case accion
            
            case ekingaction.healallyparalisis
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ekingspells.removeparalisis), true)
            
            case ekingaction.healallypoison
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ekingspells.healpoison), true)
            
            case ekingaction.healally
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ekingspells.littleheal), true)
                
                ' if time for respawning an ally has passed, then try to do it
                if kingidletime > ally_respawn_time then call kingreviveally(npcindex)
                idletime = kingidletime + 1
                
            case ekingaction.chasetarget, ekingaction.massiveattack
                
                if accion = ekingaction.chasetarget then
                    call greedywalkto(npcindex, userlist(besttarget).pos.map, _
                                      userlist(besttarget).pos.x, userlist(besttarget).pos.y)
                else
                    call npclanzaspellsobreuser(npcindex, besttarget, .spells(ekingspells.stupidityattack), true, true)
                    .canattack = 1 ' so it can make double attack
                    call npclanzaspellsobreuser(npcindex, besttarget, .spells(ekingspells.blindattack), true, true)
                    
                    ' king message
                    call writeconsolemsg(besttarget, "el rey pretoriano te ha vuelto est�pido.", fonttypenames.fonttype_fight)
                    call writeconsolemsg(besttarget, "el rey pretoriano te ha vuelto ciego ", fonttypenames.fonttype_fight)
                    call writeconsolemsg(besttarget, "a la distancia escuchas las siguientes palabras: �cobarde, no eres digno de luchar conmigo si escapas! ", fonttypenames.fonttype_veneno)
                end if
            
                call kingmeleeattack(npcindex)
            
            case ekingaction.retreatandheal
                call returntocenter(npcindex)
                if .stats.minhp <> .stats.maxhp then
                    call npclanzaspellsobrenpc(npcindex, npcindex, .spells(ekingspells.littleheal), true)
                end if
                
                ' if time for respawning an ally has passed, then try to do it
                if kingidletime > ally_respawn_time then call kingreviveally(npcindex)
                idletime = kingidletime + 1
                
        end select
    
    end with
    
    ' resets if anyone is around, else increases
    kingidletime = idletime
    debug.print kingidletime
    exit sub

errhandler:
    logerror ("error en kingperformaction. error: " & err.number & " - " & err.description)
end sub

private sub kingmeleeattack(npcindex)
'***************************************************
'author: zama
'last modification: 19/09/2010
'king performes a melee attack ignoring attack intervals
'***************************************************
on error goto errhandler

    dim headingloop as byte
    dim npos as worldpos
    
    dim userindex as integer
    
    with npclist(npcindex)
    
        ' check the four directions
        for headingloop = eheading.north to eheading.west
        
            npos = .pos
            
            call headtopos(headingloop, npos)
            
            ' in map limits?
            if inmapbounds(npos.map, npos.x, npos.y) then
            
                userindex = mapdata(npos.map, npos.x, npos.y).userindex
                if userindex > 0 then
                    if useratacable(userindex, false) then
                        if npcatacauser(npcindex, userindex) then
                            call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                        end if
                    
                        ''special speed ability for praetorian king (ignores intervals)
                        .canattack = 1
                    end if
                end if
            end if
        next headingloop
        
    end with
    
    exit sub

errhandler:
    logerror ("error en kingmeleeattack. error: " & err.number & " - " & err.description)
end sub

private sub kingreviveally(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 26/09/2010
'king tries to revive an ally.
'***************************************************
    
    dim allyindex as integer
    dim npos as worldpos
    
    with npclist(npcindex)

        ' has to be in the center to revive
        if .pos.x = centerpos.x then
            if .pos.y = centerpos.y then
                
                ' any ally dead?
                allyindex = allydead()
                if allyindex <> 0 then
                    npos = centerpos
                    npos.x = npos.x + 1
                    call spawnpretorian(npos, pretorianos(allyindex).npcai, allyindex)
                    clanmembersalive = clanmembersalive + 1
                end if
                
                ' reset iddle time
                kingidletime = 0
                
            end if
        end if

    end with

end sub

public sub ai_healer(byval npcindex as integer)
'***************************************************
'author: unkown
'last modification: -
'***************************************************
on error goto errhandler
    
    dim besttarget as integer
    dim accion as byte
    
    ' chooses target only if can attack
    if npclist(npcindex).canattack = 1 then
        ' first checks if any ally is paralized in order to remove its paralizis
        besttarget = allyparalyzed(npcindex, false)
        if besttarget <> 0 then
            accion = ehealeraction.healallyparalisis
        else
            ' now picks the best target to attack, either user or pet
            besttarget = healerbesttarget(npcindex, accion)
            
            ' if no target found, then try to heal injured allies
            if besttarget = 0 then
                besttarget = allyinjured(npcindex)
                
                ' found an injured ally
                if besttarget <> 0 then
                    accion = ehealeraction.healally
                end if
                
            end if
        end if
    end if
    
    ' search for far paralized allies, if not better choise selected
    if besttarget = 0 then
        
        'if it's paralized, it has no sense doing it
        if npclist(npcindex).flags.paralizado = 0 then
        
            besttarget = allyparalyzed(npcindex, true)
            if besttarget <> 0 then
                accion = ehealeraction.rescuefarally
            end if
            
        end if

    end if
    
    dim canmove as boolean
    
    ' performes the best action acording to the chosen target
    call healerperformaction(npcindex, besttarget, accion, canmove)
    
    ' moves only if in danger
    if canmove then call healermove(npcindex)
    
    exit sub
    
errhandler:
    logerror ("error en ai_healer. error: " & err.number & " - " & err.description)
end sub

private function healerbesttarget(byval npcindex as integer, byref accion as byte) as integer
'***************************************************
'author: zama
'last modification: 09/07/2010
'pick the best target according to the following criteria:
'1) "hoaxed" friends must be released
'2) enemy shall be annihilated no matter what
'3) party healing if no threats
'***************************************************

on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim petindex as integer
    
    dim besttarget as integer
    dim besttargetinvisible as boolean
    
    dim npcx as integer
    dim npcy as integer
    
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
    
    dim counterstart as long
    dim counterend as long
    dim counterstep as long
    
    ' to avoid that all attack the same target
    counterstep = randomnumber(0, 1)
    if counterstep = 1 then
        counterstart = 1
        counterend = modareas.conngroups(centerpos.map).countentrys
    else
        counterstart = modareas.conngroups(centerpos.map).countentrys
        counterend = 1
        counterstep = -1
    end if
    
    for counter = counterstart to counterend step counterstep
    
        userindex = modareas.conngroups(centerpos.map).userentrys(counter)
        
        ' can be atacked (doesn't matter if invisible or hidden)?
        if useratacable(userindex, false) then
                
            ' checks if ther's a non-paralized user pet in range. if so, then paralize it.
            petindex = checknearuserpets(npcindex, userindex)
            if petindex <> 0 then
                besttarget = petindex
                accion = ehealeraction.paralizepet
                exit for
            end if
                
            'is it in it's range of vision??
            if invisionrange(userindex, npcx, npcy) then
                
                with userlist(userindex)
                    
                    ' it's paralized?
                    if .flags.paralizado = 0 then
                        
                        ' it's visible?
                        if (.flags.invisible = 0) and (.flags.oculto = 0) then
                            
                            besttarget = userindex
                            accion = ehealeraction.paralizeuser
                            
                        end if
                        
                    ' user paralized, if not better target found then attack it
                    elseif besttarget = 0 then

                        besttarget = userindex
                        accion = ehealeraction.attackuser
                        
                    end if
                    
                end with
                
            end if
        
        end if
        
    next counter
    
    healerbesttarget = besttarget
        
    exit function

errhandler:
    logerror ("error en healerbesttarget. error: " & err.number & " - " & err.description)
end function

private sub healerperformaction(byval npcindex as integer, byval besttarget as integer, byval accion as byte, _
                                byref canmove as boolean)
'***************************************************
'author: zama
'last modification: 09/07/2010
'performs the required action. determines if the npc can move after perfoming the selected action.
'***************************************************
    
    with npclist(npcindex)
        select case accion
            
            case ehealeraction.healallyparalisis
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ehealerspells.removeparalisis), true)
                canmove = false
                
            case ehealeraction.paralizepet
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ehealerspells.paralizenpc), true)
                canmove = true
                
            case ehealeraction.paralizeuser
                call senddata(sendtarget.tonpcarea, npcindex, _
                    preparemessagechatoverhead(hechizos(.spells(ehealerspells.paralizeuser)).palabrasmagicas, .char.charindex, vbcyan))
                call npclanzaspellsobreuser(npcindex, besttarget, .spells(ehealerspells.paralizeuser), true)
                canmove = false
                
            case ehealeraction.attackuser
                call npclanzaspellsobreuser(npcindex, besttarget, .spells(ehealerspells.tormenta), true, true)
                canmove = false
                
            case ehealeraction.healally
                call npclanzaspellsobrenpc(npcindex, besttarget, .spells(ehealerspells.heal), true)
                canmove = true
                
            case ehealeraction.rescuefarally
                call greedywalkto(npcindex, .pos.map, npclist(besttarget).pos.x, npclist(besttarget).pos.y)
                canmove = false
                 
            case else
                canmove = true
                
        end select
    end with

end sub

private sub healermove(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 09/07/2010
'doesn't move after casting some spells. try to avoid swordmasters.
'***************************************************
    
    with npclist(npcindex)
        
        ' can't move if paralized
        if .flags.paralizado = 1 then exit sub
    
        ' only applies to clan map
        if .pos.map <> centerpos.map then exit sub
        
        ' if nobody's near or it's idle then returns near the king
        call returntocenter(npcindex)
        
        ' runs away from close users
        if targetclose(.pos) then
            call returntocenter(npcindex)
        end if
        
    end with

end sub

public sub ai_spellcaster(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: -
'***************************************************
on error goto errhandler
    
    dim besttarget as integer
    dim accion as byte
    
    ' it sacrifices itself giving a fatal blow if close to death
    if spellcastersacrifice(npcindex) then exit sub
    
    ' if healthy then choose best target
    besttarget = spellcasterbesttarget(npcindex, accion)
    
    ' performes the best action acoording to the chosen target
    if besttarget <> 0 then
        call spellcasterperformaction(npcindex, besttarget, accion)
    end if
    
    ' moves only if in danger
    call spellcastermove(npcindex, besttarget)
    
exit sub
    
errhandler:
    logerror ("error en ai_spellcaster. error: " & err.number & " - " & err.description)
end sub

private function spellcastersacrifice(byval npcindex as integer) as boolean
'***************************************************
'author: zama
'last modification: 05/07/2010
'checks if the required conditions to sacrify are fullfiled, if so then does it.
'the wand break counter is stored in the boat slot, asuming it'd never be used for any other purpose.
'***************************************************
    
    with npclist(npcindex)
    
        if .stats.minhp <= start_countdown_min_hp then
            call senddata(sendtarget.tonpcarea, npcindex, preparemessagecreatefx(.char.charindex, fxids.fxmeditargrande, infinite_loops))
        
            if .canattack = 1 then
            
                .canattack = 0
                
                wandbreakcounter = wandbreakcounter - 1
                call spellcasterdestroywand(npcindex, espellcasterspells.apocalipsis)
                
                '  wand broken => dies
                if wandbreakcounter = 0 then call muerenpc(npcindex, 0)
                
            end if
            
            spellcastersacrifice = true
            
        else
            'restore wand break counter
            if wandbreakcounter <> max_wand_break_value then
                wandbreakcounter = max_wand_break_value
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagecreatefx(.char.charindex, 0, 0))
            end if
        end if
    end with
    
end function

private function spellcasterbesttarget(byval npcindex as integer, byref accion as byte) as integer
'***************************************************
'author: zama
'last modification: 05/07/2010
'pick the best target according to the following criteria:
'1) invisible enemies can be detected sometimes
'2) a wizard's mission is background spellcasting attack
'***************************************************

on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim besttarget as integer
    dim npcx as integer
    dim npcy as integer
    dim besttargetinvisible as boolean
    
        
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
    
    dim counterstart as long
    dim counterend as long
    dim counterstep as long
    
    ' to avoid that all attack the same target
    counterstep = randomnumber(0, 1)
    if counterstep = 1 then
        counterstart = 1
        counterend = modareas.conngroups(centerpos.map).countentrys
    else
        counterstart = modareas.conngroups(centerpos.map).countentrys
        counterend = 1
        counterstep = -1
    end if
    
    for counter = counterstart to counterend step counterstep
    
        userindex = modareas.conngroups(centerpos.map).userentrys(counter)
        
        'is it in it's range of vision??
        if invisionrange(userindex, npcx, npcy) then
            
            ' can be atacked?
            if useratacable(userindex, false) then
                
                with userlist(userindex)
                    ' it's invisible?
                    if (.flags.invisible = 1) or (.flags.oculto = 1) then
                        
                        ' try to remove invisibility
                        if (randomnumber(1, 100) <= 35) then
                            besttarget = userindex
                            accion = espellcasteraction.removeinvi
                            exit for
                        end if
                        
                        ' paralized invisible users are good target!
                        if .flags.paralizado = 1 then
                            besttarget = userindex
                            besttargetinvisible = true
                            accion = espellcasteraction.attack
                        end if
                    
                    ' visible but paralized?
                    elseif (.flags.paralizado = 1) then
                        
                        ' if not found an invisible and paralized target, then it's a good one
                        if not besttargetinvisible or besttarget = 0 then
                            besttarget = userindex
                            accion = espellcasteraction.attack
                        end if
                    
                    ' visible and can move, if not better found then choose it
                    elseif besttarget = 0 then

                        besttarget = userindex
                        accion = espellcasteraction.attack
                        
                    end if
                    
                end with
                
            end if
        
        end if
        
    next counter
    
    spellcasterbesttarget = besttarget
        
    
    exit function

errhandler:
    logerror ("error en spellcasterbesttarget. error: " & err.number & " - " & err.description)
end function

private sub spellcasterperformaction(byval npcindex as integer, byval besttarget as integer, byval accion as byte)
'***************************************************
'author: zama
'last modification: 05/07/2010
'performs the required action.
'***************************************************
    
    with npclist(npcindex)
        select case accion
            
            case espellcasteraction.attack
                call npclanzaspellsobreuser(npcindex, besttarget, .spells(espellcasterspells.apocalipsis), true, true)
            
            case espellcasteraction.removeinvi
                call npclanzaspellsobreuser(npcindex, besttarget, .spells(espellcasterspells.remoinvi), true, true)
                
        end select
    end with
    
end sub

private sub spellcastermove(byval npcindex as integer, byval besttarget as integer)
'***************************************************
'author: zama
'last modification: 05/07/2010
'doesn't move unless nobody is near or there is no best target.
'***************************************************
    
    with npclist(npcindex)
        
        ' can't move if paralized
        if .flags.paralizado = 1 then exit sub
        
        ' only applies to clan map
        if .pos.map <> centerpos.map then exit sub
        
        ' if nobody's near or it's idle then returns near the king
        if (besttarget = 0) and (.canattack = 1) then call returntocenter(npcindex)
        
        ' runs away from close users
        if targetclose(.pos) then
            call returntocenter(npcindex)
        end if
        
    end with

end sub

private sub spellcasterdestroywand(byval npcindex as integer, byval spellindex as integer)
'***************************************************
'author: unkown
'last modification: -
'***************************************************
on error goto errhandler
    ''sonidos: 30 y 32, y no los cambien sino termina siendo muy chistoso...
    ''para el fx utiliza el del hechizos(spellindex)
    
    with npclist(npcindex)
        select case wandbreakcounter
            case 5
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead("rahma", .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
            case 4
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead("v�rtax", .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
            case 3
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead("zill", .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
            case 2
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead("y�k� e'nta", .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
            case 1
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead("��kor�t�!!", .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
            case 0
                call senddata(sendtarget.tonpcarea, npcindex, preparemessagechatoverhead(vbnullstring, .char.charindex, vbgreen))
                call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(sonido_dragon_vivo, .pos.x, .pos.y))
                
                call dealwanddamage(npcindex, .spells(spellindex))
        end select
        
    end with
    
exit sub

errhandler:
    logerror ("error en spellcasterdestroywand. error: " & err.number & " - " & err.description)
end sub

private sub dealwanddamage(byval npcindex as integer, byval spellindex as integer)
'***************************************************
'author: zama
'last modification: 17/06/2011
'description: deals massive wand damage.
'17/06/2011: amraphen - user's hp is updated once he gets hit by wand damage.
'***************************************************
on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim distancia as integer
    dim danio as integer
    
    dim x as integer
    dim y as integer
    
    with npclist(npcindex)
        
        x = .pos.x
        y = .pos.y
        
        for counter = 1 to modareas.conngroups(centerpos.map).countentrys
            
            userindex = modareas.conngroups(centerpos.map).userentrys(counter)
            
            if userindex <> 0 then
            
                with userlist(userindex)
                    
                    if useratacable(userindex, false, false) then
                        
                        distancia = userdistance(userindex, x, y)
                        danio = abs(int(880 / (distancia ^ (3 / 7))))
                        
                        .stats.minhp = .stats.minhp - danio
                        
                        call writeconsolemsg(userindex, npclist(npcindex).name & " te ha quitado " & danio & " puntos de vida al romper su vara.", fonttypenames.fonttype_fight)
                        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spellindex).wav, .pos.x, .pos.y))
                        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, hechizos(spellindex).fxgrh, hechizos(spellindex).loops))
                        
                        if .stats.minhp < 1 then
                            .stats.minhp = 0
                            call userdie(userindex)
                        else
                            'updates user's hp:
                            call writeupdatehp(userindex)
                            ' also hit pets
                            if .nromascotas > 0 then _
                                call dealwanddamagetopets(npcindex, userindex, spellindex)
                            
                        end if
                        
                    end if
                    
                end with
            
            end if
            
        next counter
        
    end with
    
    exit sub
    
errhandler:
    logerror ("error en dealwanddamage. error: " & err.number & " - " & err.description)
end sub

private sub dealwanddamagetopets(byval npcindex as integer, byval userindex as integer, byval spellindex as integer)
'***************************************************
'author: zama
'last modification: 26/09/2010
'deals massive wand damage to user pets.
'***************************************************
on error goto errhandler

    dim petindex as integer
    dim petcounter as long

    dim distancia as integer
    dim danio as integer
    
    dim npcx as integer
    dim npcy as integer
    
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
    
    for petcounter = 1 to maxmascotas
                                    
        petindex = userlist(userindex).mascotasindex(petcounter)
        if petindex > 0 then
           with npclist(petindex)
           
                distancia = npcdistance(petindex, npcx, npcy)
                danio = abs(int(880 / (distancia ^ (3 / 7))))

                .stats.minhp = .stats.minhp - danio
                
                call senddata(sendtarget.tonpcarea, petindex, preparemessageplaywave(hechizos(spellindex).wav, .pos.x, .pos.y))
                call senddata(sendtarget.tonpcarea, petindex, preparemessagecreatefx(.char.charindex, hechizos(spellindex).fxgrh, hechizos(spellindex).loops))
                
                if .stats.minhp < 1 then
                    .stats.minhp = 0
                    call muerenpc(petindex, 0)
                end if
                
           end with
        end if
        
    next petcounter
    
    exit sub
    
errhandler:
    logerror ("error en dealwanddamagetopets. error: " & err.number & " - " & err.description)
end sub

public sub ai_swordmaster(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: -
'***************************************************
on error goto errhandler

    dim besttarget as integer
    
    ' first choose best target
    besttarget = swordmasterbesttarget(npcindex)
    
    ' then moves, close to target user if in range
    call swordmastermove(npcindex, besttarget)
    
    ' finally, attacks sorrounding targets
    call swordmasterattack(npcindex)
    
    exit sub

errhandler:
    logerror ("error en ai_swordmaster. error: " & err.number & " - " & err.description)
end sub

private function swordmasterbesttarget(byval npcindex as integer) as integer
'***************************************************
'author: zama
'last modification: 26/06/2010
'picks the best target according to the following criteria:
'1) the nearest enemy will be attacked.
'***************************************************

on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim besttarget as integer
    dim besttargetdistance as integer
    
    dim npcx as integer
    dim npcy as integer
    dim distance as integer
    
    
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
    
    dim counterstart as long
    dim counterend as long
    dim counterstep as long
    
    ' to avoid that all attack the same target
    counterstep = randomnumber(0, 1)
    if counterstep = 1 then
        counterstart = 1
        counterend = modareas.conngroups(centerpos.map).countentrys
    else
        counterstart = modareas.conngroups(centerpos.map).countentrys
        counterend = 1
        counterstep = -1
    end if
    
    for counter = counterstart to counterend step counterstep
    
        userindex = modareas.conngroups(centerpos.map).userentrys(counter)
        
        'is it in it's range of vision??
        if invisionrange(userindex, npcx, npcy) then
            
            ' can be atacked?
            if useratacable(userindex) then
                ' checks limits in order to avoid to separate it from the rest of the clan
                if userreachable(npcindex, userindex) then
                
                    if besttarget <> 0 then
                        
                        ' has priority to attack the nearest
                        distance = userdistance(userindex, npcx, npcy)
                        
                        if distance < besttargetdistance then
                            besttarget = userindex
                            besttargetdistance = distance
                        end if
                        
                    else
                        besttarget = userindex
                        besttargetdistance = userdistance(userindex, npcx, npcy)
                    end if
                
                end if
            
            end if
        
        end if
        
    next counter
    
    swordmasterbesttarget = besttarget
    
    exit function

errhandler:
    logerror ("error en swordmasterbesttarget. error: " & err.number & " - " & err.description)
end function

private sub swordmastermove(byval npcindex as integer, byval besttarget as integer)
'***************************************************
'author: zama
'last modification: 24/06/2010
'la idea es que no lo "alejen" del rey y despues queden
'lejos de la batalla cuando matan a un enemigo o este
'sale del area de combate (tipica forma de separar un clan)
'***************************************************

on error goto errhandler

    with npclist(npcindex)
    
        ' if paralized can't move
        if .flags.paralizado = 1 then exit sub
        
        ' only applies to clan map
        if .pos.map <> centerpos.map then exit sub
        
        ' if it's far from protection then returns to center
        if farfromteam(npcindex) then
            call returntocenter(npcindex)
            exit sub
        end if
        
        ' if someone's in range, then go close to him
        if besttarget > 0 then
            
            with userlist(besttarget)
                call greedywalkto(npcindex, centerpos.map, .pos.x, .pos.y)
            end with
            
        'returns to center if no target found
        else
            call returntocenter(npcindex)
        end if
        
    end with
    
    exit sub
    
errhandler:
    logerror ("error en swordmastermove. error: " & err.number & " - " & err.description)
end sub

private sub swordmasterattack(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 26/06/2010
'searchs and attacks the sorrounding target
'***************************************************

on error goto errhandler

    dim headingloop as byte
    dim npcpos as worldpos
    dim userindex as integer
    
    with npclist(npcindex)
    
        ' check the four directions
        for headingloop = eheading.north to eheading.west
        
            npcpos = .pos
            call headtopos(headingloop, npcpos)
            
            userindex = mapdata(npcpos.map, npcpos.x, npcpos.y).userindex
            
            if userindex > 0 then
                if useratacable(userindex, false) then
                    if npcatacauser(npcindex, userindex) then
                        call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                        exit for
                    end if
                end if
            end if
            
        next headingloop
        
    end with

    exit sub
    
errhandler:
    logerror ("error en swordmasterattack. error: " & err.number & " - " & err.description)
end sub

public sub ai_shooter(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: -
'***************************************************
    dim besttarget as integer
    
    ' first choose best target
    besttarget = shooterbesttarget(npcindex)
    
    ' found a target => attack!
    if besttarget > 0 then
        ' attack with arrow
        call npclanzaspellsobreuser(npcindex, besttarget, npclist(npcindex).spells(1))
    end if
    
    ' then moves, close to target user if attacking one
    call shootermove(npcindex, besttarget)
    
    exit sub
    
errhandler:
    logerror ("error en ai_shooter. error: " & err.number & " - " & err.description)
end sub

private function shooterbesttarget(byval npcindex as integer) as integer
'***************************************************
'author: zama
'last modification: 24/06/2010
'picks the best target according to the following criteria:
'1) magic clases are dangerous, but they are weak too, they're
'   our primary target
'2) in any other case, our nearest enemy will be attacked
'***************************************************

on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim besttarget as integer
    dim besttargetdistance as integer
    
    dim npcx as integer
    dim npcy as integer
    dim distance as integer
    
        
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
        
    dim counterstart as long
    dim counterend as long
    dim counterstep as long
    
    ' to avoid that all attack the same target
    counterstep = randomnumber(0, 1)
    if counterstep = 1 then
        counterstart = 1
        counterend = modareas.conngroups(centerpos.map).countentrys
    else
        counterstart = modareas.conngroups(centerpos.map).countentrys
        counterend = 1
        counterstep = -1
    end if
    
    for counter = counterstart to counterend step counterstep
    
        userindex = modareas.conngroups(centerpos.map).userentrys(counter)
        
        'is it in it's range of vision??
        if invisionrange(userindex, npcx, npcy) then
            
            ' can be atacked?
            if useratacable(userindex) then
                
                ' has priority to attack magic clases
                if esclasemagica(userindex) then
                    besttarget = userindex
                    exit for
                else
                    if besttarget <> 0 then
                        
                        ' has priority to attack the nearest
                        distance = userdistance(userindex, npcx, npcy)
                        
                        if distance < besttargetdistance then
                            besttarget = userindex
                            besttargetdistance = distance
                        end if
                        
                    else
                        besttarget = userindex
                        besttargetdistance = userdistance(userindex, npcx, npcy)
                    end if
                    
                end if
            
            end if
        
        end if
        
    next counter
    
    shooterbesttarget = besttarget
        
    exit function

errhandler:
    logerror ("error en shooterbesttarget. error: " & err.number & " - " & err.description)
end function

private sub shootermove(byval npcindex as integer, byval besttarget as integer)
'***************************************************
'author: zama
'last modification: 24/06/2010
'vamos a setear el hold on del cazador en el medio entre el rey
'y el atacante. de esta manera se lo podra atacar aun asi est� lejos
'pero sin alejarse del rango de los an hoax vorps de los
'clerigos o rey. a menos q este paralizado, claro
'***************************************************

on error goto errhandler

    with npclist(npcindex)
    
        ' if paralized can't move
        if .flags.paralizado = 1 then exit sub
        
        ' only applies to clan map
        if .pos.map <> centerpos.map then exit sub

        ' if it's far from protection then returns to center
        if farfromteam(npcindex) then
            call returntocenter(npcindex)
            exit sub
        end if
        
        ' don't go too far from center
        if abs(centerpos.x - .pos.x) > 4 or abs(centerpos.y - .pos.y) > 4 then
            call returntocenter(npcindex)
            exit sub
        end if
        
        ' if has attacked someone, then go close to him
        if besttarget > 0 then
            
            call greedywalkto(npcindex, centerpos.map, _
                              centerpos.x + ((userlist(besttarget).pos.x - centerpos.x) / 2), _
                              centerpos.y + ((userlist(besttarget).pos.y - centerpos.y) / 2))
            exit sub
        else
        
            ' search for aproaching enemies
            dim counter as long
            dim userindex as integer
            
            for counter = 1 to modareas.conngroups(centerpos.map).countentrys
            
                userindex = modareas.conngroups(centerpos.map).userentrys(counter)
                
                'is it in extended range of vision from center position??
                if invisionrange(userindex, centerpos.x, centerpos.y, true) then
                    
                    ' can be atacked?
                    if useratacable(userindex) then
                        
                        with userlist(userindex)
                            call greedywalkto(npcindex, centerpos.map, .pos.x, .pos.y)
                        end with
                        
                        exit sub
                    end if
                    
                end if
            next counter
        end if
        
        'returns to center if no target found
        if .canattack = 1 then call returntocenter(npcindex)
         
    end with
    
    exit sub
    
errhandler:
    logerror ("error en shootermove. error: " & err.number & " - " & err.description)
end sub

private sub ai_thief(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: -
'***************************************************
on error goto errhandler

    dim besttarget as integer
    dim action as byte
    
    ' first choose best target
    besttarget = thiefbesttarget(npcindex, action)
    
    ' perform's thief action acording to its priorities
    call thiefperfomaction(npcindex, besttarget, action)
    
    exit sub

errhandler:
    logerror ("error en ai_thief. error: " & err.number & " - " & err.description)
end sub

private function thiefbesttarget(byval npcindex as integer, byref action as byte) as integer
'***************************************************
'author: zama
'last modification: 26/06/2010
'picks the best target according to the following criteria:
'1) has priority to attack hunters.
'2) targets the nearer user.
'***************************************************

on error goto errhandler

    dim userindex as integer
    dim counter as long
    
    dim besttarget as integer
    dim besttargetdistance as integer
    
    dim npcx as integer
    dim npcy as integer
    dim distance as integer
    
    
    npcx = npclist(npcindex).pos.x
    npcy = npclist(npcindex).pos.y
    
    dim counterstart as long
    dim counterend as long
    dim counterstep as long
    
    ' to avoid that all attack the same target
    counterstep = randomnumber(0, 1)
    if counterstep = 1 then
        counterstart = 1
        counterend = modareas.conngroups(centerpos.map).countentrys
    else
        counterstart = modareas.conngroups(centerpos.map).countentrys
        counterend = 1
        counterstep = -1
    end if
    
    for counter = counterstart to counterend step counterstep
    
        userindex = modareas.conngroups(centerpos.map).userentrys(counter)
        
        'is it in it's range of vision??
        if invisionrange(userindex, npcx, npcy) then
            
            ' can be atacked?
            if useratacable(userindex, false) then
                ' checks limits in order to avoid to separate it from the rest of the clan
                if userreachable(npcindex, userindex) then
                
                    ' is it a hunter? => has priority
                    if userlist(userindex).clase = eclass.hunter then
                        besttarget = userindex
                        besttargetdistance = userdistance(userindex, npcx, npcy)
                        exit for
                    end if
                    
                    if besttarget <> 0 then
                        
                        ' has priority to attack the nearest
                        distance = userdistance(userindex, npcx, npcy)
                        
                        if distance < besttargetdistance then
                            besttarget = userindex
                            besttargetdistance = distance
                        end if
                        
                    else
                        besttarget = userindex
                        besttargetdistance = userdistance(userindex, npcx, npcy)
                    end if
                
                end if
            
            end if
        
        end if
        
    next counter
    
    ' couldn't find anyone
    if besttarget = 0 then
        action = ethiefaction.none
    else
        ' if close to target => snatch/steal
        if besttargetdistance <= thief_steal_distance then
            action = ethiefaction.steal
        
        ' too far => attack while aproaching
        else
            action = ethiefaction.attack
        end if
    end if
    
    thiefbesttarget = besttarget
    
    exit function

errhandler:
    logerror ("error en thiefbesttarget. error: " & err.number & " - " & err.description)
end function

private sub thiefperfomaction(byval npcindex as integer, byval besttarget as integer, byval action as byte)
'***************************************************
'author: zama
'last modification: 28/10/2010
'28/10/2010: zama - now thief doesn't steal/snatch admins.
'***************************************************
on error goto errhandler
    
    dim weaponeqpslot as byte
    dim municioneqpslot as byte
    
    with npclist(npcindex)
        
        select case action
            
            case ethiefaction.attack, ethiefaction.steal
                
                ' can't do anything
                if .canattack = 1 then
                
                    ' attack with arrow
                    if action = ethiefaction.attack then
                        call npclanzaspellsobreuser(npcindex, besttarget, .spells(ethiefspells.arrow), false, true)
                        
                        ' can paralize
                        if randomnumber(1, 100) < 10 then
                            call npclanzaspellsobreuser(npcindex, besttarget, .spells(ethiefspells.paralisis), false, true)
                            call writeconsolemsg(besttarget, "��" & .name & " te ha paralizado con su golpe!!", fonttypenames.fonttype_veneno)
                        
                        ' can unequip weapon
                        elseif randomnumber(1, 100) < 22 then
                            
                            weaponeqpslot = userlist(besttarget).invent.weaponeqpslot
                            if weaponeqpslot <> 0 then call desequipar(besttarget, weaponeqpslot)
                            
                        end if
                        
                    ' try to snatch/steal (except for admins)
                    elseif not esgm(besttarget) then
                        
                        ' can snatch weapon or arrows
                        if randomnumber(1, 100) < 16 then
                            
                            weaponeqpslot = userlist(besttarget).invent.weaponeqpslot
                            if weaponeqpslot <> 0 then
                                
                                if snatchitem(npcindex, besttarget, weaponeqpslot) then
                                    call writeconsolemsg(besttarget, "��" & .name & " te ha arrebatado tu arma!!", fonttypenames.fonttype_veneno)
                                end if
                                
                            else
                                municioneqpslot = userlist(besttarget).invent.municioneqpslot
                                if municioneqpslot <> 0 then
                                
                                    if snatchitem(npcindex, besttarget, municioneqpslot) then
                                        call writeconsolemsg(besttarget, "��" & .name & " te ha arrebatado tus municiones!!", fonttypenames.fonttype_veneno)
                                    end if
                                    
                                end if
                            end if
                        
                        ' can steal the items of a slot
                        elseif randomnumber(1, 100) < 16 then
                        
                            dim slot as byte
                            slot = randomnumber(1, userlist(besttarget).currentinventoryslots)
                            
                            if thiefstealitem(npcindex, besttarget, slot) then
                                call writeconsolemsg(besttarget, "��" & .name & " te est� robando!!", fonttypenames.fonttype_veneno)
                            end if
                            
                        end if
                    end if
                    
                end if
                
                ' has chances of becoming invisible (if visible)
                if .flags.invisible = 0 then
                    
                    if randomnumber(1, 100) < 25 then call thiefturninvisible(npcindex, true)
                
                ' is invisible, can turn visible.
                else
                    if randomnumber(1, 100) < 13 then call thiefturninvisible(npcindex, false)
                end if
                
                ' get closer to target
                call greedywalkto(npcindex, centerpos.map, userlist(besttarget).pos.x, userlist(besttarget).pos.y)
                
            case ethiefaction.none
                
                ' turns visible if no threat
                if .flags.invisible = 1 then call thiefturninvisible(npcindex, false)
                
                call returntocenter(npcindex)
                
        end select
        
    end with

    exit sub

errhandler:
    logerror ("error en thiefperfomaction. error: " & err.number & " - " & err.description)
end sub

private function snatchitem(byval npcindex as integer, byval targetindex as integer, byval slot as byte) as boolean
'***************************************************
'author: zama
'last modification: 25/09/2010
'snatchs slot items from user. no validations are made bacause it's either weapon or munition.
'***************************************************
on error goto errhandler

    dim dropobj as obj
    dim npos as worldpos
    
    with userlist(targetindex)
        dropobj.amount = .invent.object(slot).amount
        dropobj.objindex = .invent.object(slot).objindex
    
        ' search for suitable place to drop item
        call tilelibre(.pos, npos, dropobj, false, true)
        
        ' found any?
        if npos.x <> 0 and npos.y <> 0 then
            ' drop it
            call makeobj(dropobj, npos.map, npos.x, npos.y)
            call quitaruserinvitem(targetindex, slot, dropobj.amount)
            call updateuserinv(false, targetindex, slot)
            
            ' suceed
            snatchitem = true
        end if
    end with
    
    exit function
    
errhandler:
    logerror ("error en snatchitem. error: " & err.number & " - " & err.description)
end function

private function thiefstealitem(byval npcindex as integer, byval targetindex as integer, byval slot as byte) as boolean
'***************************************************
'author: zama
'last modification: 25/09/2010
'steal slot items from user. if no space in thief's inventory, drop it on floor.
'22/10/2010: zama - now thief doesn't try to stel slots with no items in it.
'***************************************************
    dim stolenobj as obj
    dim nroitems as integer
    
    ' if doesn't have any item, the doesn't do anything
    if userlist(targetindex).invent.object(slot).objindex = 0 then exit function
    
    ' if not stealable, then don't do anything
    if not objesrobable(targetindex, slot) then exit function

    ' if thief's inventory is full, then snatch it
    nroitems = npclist(npcindex).invent.nroitems
    if nroitems = 20 then
        
        thiefstealitem = snatchitem(npcindex, targetindex, slot)
             
    ' steal it
    else
        
        stolenobj.amount = userlist(targetindex).invent.object(slot).amount
        stolenobj.objindex = userlist(targetindex).invent.object(slot).objindex
        
        ' add it to thief inventory
        with npclist(npcindex)
            nroitems = nroitems + 1
            .invent.object(nroitems).amount = stolenobj.amount
            .invent.object(nroitems).objindex = stolenobj.objindex
            .invent.nroitems = nroitems
        end with
        
        ' take it from user inventory
        call quitaruserinvitem(targetindex, slot, stolenobj.amount)
        call updateuserinv(false, targetindex, slot)
        
        thiefstealitem = true
        
    end if
    
end function

private sub thiefturninvisible(byval npcindex as integer, byval turnvisible as boolean)
'***************************************************
'author: zama
'last modification: 26/09/2010
'turn thief visible/invisible.
'***************************************************
    
    with npclist(npcindex)
    
        if turnvisible then
            .flags.invisible = 1
        else
            .flags.invisible = 0
        end if
        
        call senddata(sendtarget.tonpcarea, npcindex, preparemessagesetinvisible(.char.charindex, turnvisible))
    
    end with
    
end sub

private function targetclose(byref pos as worldpos) as boolean
'***************************************************
'author: zama
'last modification: 05/07/2010
'checks if there is any attackable user sorrounding the given position.
'***************************************************
    dim userindex as integer
    
    dim npos as worldpos
    dim headingloop as byte
    
    for headingloop = eheading.north to eheading.west
        
        npos = pos
        call headtopos(headingloop, npos)
        
        userindex = mapdata(npos.map, npos.x, npos.y).userindex
        
        if userindex <> 0 then
            if useratacable(userindex) then
                targetclose = true
                exit function
            end if
        end if
    next headingloop
    
end function

private function checknearuserpets(byval npcindex as integer, byval userindex as integer) as integer
'***************************************************
'author: zama
'last modification: 09/07/2010
'checks if there is a non-paralized user pet in cleric vision range.
'***************************************************
    dim petcounter as long
    dim petindex as integer
    
    with userlist(userindex)
        
        if .nromascotas = 0 then exit function
        
        for petcounter = 1 to maxmascotas
        
            petindex = .mascotasindex(petcounter)
            if petindex > 0 then
            
               with npclist(petindex)
                    
                    ' if it is visible for the pretorian
                    if invisionrangenpc(npcindex, .pos.x, .pos.y) then
                        
                        ' if not paralized then it's a suitable target
                        if .flags.paralizado = 0 then
                            checknearuserpets = petindex
                            exit function
                        end if
                    
                    end if
                    
               end with
               
            end if
            
        next petcounter
        
    end with

end function

private function esclasemagica(byval userindex as integer) as boolean
'***************************************************
'author: unkown
'last modification: -
'***************************************************
on error goto errhandler

    with userlist(userindex)
        esclasemagica = .clase = eclass.mage or _
                        .clase = eclass.cleric or _
                        .clase = eclass.druid or _
                        .clase = eclass.bard
    end with
    
    exit function

errhandler:
    logerror ("error en esclasemagica. error: " & err.number & " - " & err.description)
end function

private sub greedywalkto(byval npcindex as integer, byval targetmap as integer, _
                         byval targetx as integer, byval targety as integer)
'***************************************************
'author: unknown
'  este procedimiento es llamado cada vez que un npc deba ir
'  a otro lugar en el mismo targetmap. utiliza una t�cnica
'  de programaci�n greedy no determin�stica.
'  cada paso azaroso que me acerque al destino, es un buen paso.
'  si no hay mejor paso v�lido, entonces hay que volver atr�s y reintentar.
'  si no puedo moverme, me considero piketeado
'  la funcion es larga, pero es o(1) - orden algor�tmico temporal constante
'last modification: 26/09/2010
'rapsodius - changed mod by and for speed
'26/09/2010: zama - now make movements as normal npcs, which allows to kick caspers and invisible admins.
'***************************************************
on error goto errhandler

    dim npcx as integer
    dim npcy as integer
    dim randomdir as integer
    
    with npclist(npcindex).pos
        if .map <> targetmap then exit sub
        
        npcx = .x
        npcy = .y
    end with
    
    ' arrived to destination
    if (npcx = targetx and npcy = targety) then exit sub
    
    ' try to reach target
    if (npcx > targetx) then
    
        ' target is down-left
        if (npcy < targety) then
            
            randomdir = randomnumber(0, 9)
            if ((randomdir and 1) = 0) then ''move down
            
                if movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                end if
                
            else
                ''random first move
                if movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                end if
                
            end if
            
        ' target is up-left
        elseif (npcy > targety) then
        
            randomdir = randomnumber(0, 9)
            if ((randomdir and 1) = 0) then ''move up
            
                if movenpcchar(npcindex, eheading.north) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                end if
                
            else
                ''random first move
                if movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                end if
                
            end if
            
        ' target is straight left
        else
        
            if movenpcchar(npcindex, eheading.west) then
                exit sub
            elseif movenpcchar(npcindex, eheading.south) then
                exit sub
            elseif movenpcchar(npcindex, eheading.north) then
                exit sub
            else
                ' if moves to east, algorithm fails because starts a loop
                call movefailed(npcindex)
            end if
            
        end if
    
    elseif (npcx < targetx) then
        
        ' target is down-right
        if (npcy < targety) then
            
            randomdir = randomnumber(0, 9)
            if ((randomdir and 1) = 0) then ''move down
            
                if movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                end if
                
            else    ''random first move
                
                if movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                end if
                
            end if
        
        ' target is up-right
        elseif (npcy > targety) then
        
            randomdir = randomnumber(0, 9)
            if ((randomdir and 1) = 0) then ''move up
            
                if movenpcchar(npcindex, eheading.north) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                end if
                
            else
            
                if movenpcchar(npcindex, eheading.east) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.north) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.south) then
                    exit sub
                elseif movenpcchar(npcindex, eheading.west) then
                    exit sub
                end if
                
            end if
        
        ' target is straight right
        else
        
            if movenpcchar(npcindex, eheading.east) then
                exit sub
            elseif movenpcchar(npcindex, eheading.south) then
                exit sub
            elseif movenpcchar(npcindex, eheading.north) then
                exit sub
            else
                ' if moves to west, algorithm fails because starts a loop
                call movefailed(npcindex)
            end if
            
        end if
    
    ' target is straight up/down
    else
    
        ' target is straight up
        if (npcy > targety) then
        
            if movenpcchar(npcindex, eheading.north) then
                exit sub
            elseif movenpcchar(npcindex, eheading.east) then
                exit sub
            elseif movenpcchar(npcindex, eheading.west) then
                exit sub
            else
                ' if moves to south, algorithm fails because starts a loop
                call movefailed(npcindex)
            end if
            
        ' target is straight down
        else
        
            if movenpcchar(npcindex, eheading.south) then
                exit sub
            elseif movenpcchar(npcindex, eheading.east) then
                exit sub
            elseif movenpcchar(npcindex, eheading.west) then
                exit sub
            else
                ' if moves to north, algorithm fails because starts a loop
                call movefailed(npcindex)
            end if
            
        end if
        
    end if
    
    exit sub

errhandler:
    logerror ("error en greedywalkto. error: " & err.number & " - " & err.description)
end sub

private sub movefailed(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 26/06/2010
'npc shouts a message overhead because cannot move (to avoid a loop)
'***************************************************

    with npclist(npcindex)
        if .canattack = 1 then
            if (randomnumber(1, 100) > 95) then
                call senddata(sendtarget.tonpcarea, npcindex, _
                    preparemessagechatoverhead("maldito bastardo, �ven aqu�!", .char.charindex, vbyellow))
                .canattack = 0
            end if
        end if
    end with

end sub

private sub returntocenter(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 19/09/2010
'returns to the center, where the king is.
'***************************************************
    
    call greedywalkto(npcindex, centerpos.map, centerpos.x, centerpos.y)
    
end sub

private function farfromteam(byval npcindex) as boolean
'***************************************************
'author: unknown & zama
'last modification: 19/09/2010
'checks if npc is far from cleric protection ring
'***************************************************
    
    if npclist(npcindex).pos.map <> centerpos.map then exit function
    
    farfromteam = (abs(npclist(npcindex).pos.y - centerpos.y) > max_distance) or _
                  (abs(npclist(npcindex).pos.x - centerpos.x) > max_distance)
    
    exit function

errhandler:
    logerror ("error en farfromteam. error: " & err.number & " - " & err.description)
end function

private function userreachable(byval npcindex as integer, byval userindex as integer) as boolean
'***************************************************
'author: zama
'last modification: 19/09/2010
'ignores users who are too far in order to avoid being separated from the rest of the team.
'***************************************************
on error goto errhandler
        
    if npclist(npcindex).pos.map <> centerpos.map then exit function

    userreachable = (abs(userlist(userindex).pos.x - centerpos.x) < max_distance) and _
                    (abs(userlist(userindex).pos.y - centerpos.y) < max_distance)
    
    
    exit function
    
errhandler:
    logerror ("error en userreachable. error: " & err.number & " - " & err.description)
end function

private function invisionrange(byval userindex as integer, byval x as integer, byval y as integer, _
                               optional byval extendedrange as boolean = false) as boolean
'***************************************************
'author: zama
'last modification: 24/06/2010
'checks whether user is in vision range or not
'***************************************************

    dim rango as integer
    rango = val(iif(extendedrange, 2, 1))
    
    with userlist(userindex)
        invisionrange = abs(.pos.x - x) <= rango_vision_x * rango and _
                        abs(.pos.y - y) <= rango_vision_y * rango
    end with
    
end function

private function invisionrangenpc(byval npcindex as integer, byval x as integer, byval y as integer, _
                                  optional byval extendedrange as boolean = false) as boolean
'***************************************************
'author: zama
'last modification: 24/06/2010
'checks whether npc is in vision range or not
'***************************************************
    
    dim rango as integer
    rango = val(iif(extendedrange, 2, 1))

    with npclist(npcindex)
        invisionrangenpc = abs(.pos.x - x) <= rango_vision_x * rango and _
                           abs(.pos.y - y) <= rango_vision_y * rango
    end with
    
end function

private function useratacable(byval userindex as integer, optional byval checkvisibility as boolean = true, _
                              optional byval attackadmin as boolean = true) as boolean
'***************************************************
'author: zama
'last modification: 05/10/2010
'determines whether the user can be atacked or not
'05/10/2010: zama - now doesn't allow to attack admins sometimes.
'***************************************************

    with userlist(userindex).flags
        useratacable = not .enconsulta and _
                       .admininvisible = 0 and _
                       .adminperseguible and _
                       .muerto = 0
                       
        if checkvisibility then
            useratacable = useratacable and _
                           .oculto = 0 and _
                           .invisible = 0
        end if
        
        if not attackadmin then
            useratacable = useratacable and (not esgm(userindex))
        end if
        
    end with
                        
end function

private function userdistance(byval userindex as integer, byval x as integer, byval y as integer) as integer
'***************************************************
'author: zama
'last modification: 24/06/2010
'calculates the user distance according to the given coords.
'***************************************************

    with userlist(userindex)
        userdistance = abs(x - .pos.x) + abs(y - .pos.y)
    end with
    
end function

private function npcdistance(byval npcindex as integer, byval x as integer, byval y as integer) as integer
'***************************************************
'author: zama
'last modification: 24/06/2010
'calculates the npc distance according to the given coords.
'***************************************************

    with npclist(npcindex)
        npcdistance = abs(x - .pos.x) + abs(y - .pos.y)
    end with
    
end function

public sub muerepretoriano(byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 27/06/2010
'eliminates the pretorian from the current alive ones, and respawn the clan if in pretorian's default map.
'***************************************************

    dim pretoindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        ' remove npc index
        if pretorianos(pretoindex).npcindex = npcindex then
            pretorianos(pretoindex).npcindex = 0
            clanmembersalive = clanmembersalive - 1
            
            ' entire clan has been defeated
            if clanmembersalive = 0 then
                ' respawn it? (only allowed in pretorian default map)
                if respawnclan then
                    
                    dim newspawnpos as worldpos
                
                    ' switch respawn place (alternate between two places)
                    if centerpos.x = leftspawnpos.x then
                        newspawnpos = rightspawnpos
                    else
                        newspawnpos = leftspawnpos
                    end if
                    
                    ' spawn it
                    call spawnclan(newspawnpos.map, newspawnpos.x, newspawnpos.y, clanindex, true)
                else
                    clanactive = false
                end if
            end if
            
            exit sub
        end if
    next pretoindex
    
end sub

private function allyparalyzed(byval npcindex as integer, byval extendedrange as boolean) as integer
'***************************************************
'author: zama
'last modification: 27/06/2010
'returns the index of the paralized ally if exists one.
'***************************************************
   
    dim pretoindex as integer
    dim allyindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        
        allyindex = pretorianos(pretoindex).npcindex
        if allyindex <> 0 then
            if npclist(allyindex).flags.paralizado = 1 then
                if invisionrangenpc(allyindex, npclist(npcindex).pos.x, npclist(npcindex).pos.y, extendedrange) then
                    allyparalyzed = allyindex
                    exit function
                end if
            end if
        end if
        
    next pretoindex
 
end function

private function allyinjured(byval npcindex as integer) as integer
'***************************************************
'author: zama
'last modification: 09/07/2010
'returns the index of the first found injured ally if exists one.
'***************************************************
   
    dim pretoindex as integer
    dim allyindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        
        allyindex = pretorianos(pretoindex).npcindex
        if allyindex <> 0 then
            with npclist(allyindex)
                if .stats.minhp < .stats.maxhp then
                    if invisionrangenpc(npcindex, .pos.x, .pos.y, false) then
                        allyinjured = allyindex
                        exit function
                    end if
                end if
            end with
        end if
        
    next pretoindex
 
end function

private function allypoisoned(byval npcindex as integer) as integer
'***************************************************
'author: zama
'last modification: 19/09/2010
'returns the index of the poisoned ally if exists one.
'***************************************************
   
    dim pretoindex as integer
    dim allyindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        
        allyindex = pretorianos(pretoindex).npcindex
        if allyindex <> 0 then
            if npclist(allyindex).flags.envenenado = 1 then
                if invisionrangenpc(allyindex, npclist(npcindex).pos.x, npclist(npcindex).pos.y) then
                    allypoisoned = allyindex
                    exit function
                end if
            end if
        end if
        
    next pretoindex
 
end function

private function allydead() as integer
'***************************************************
'author: zama
'last modification: 19/09/2010
'returns the index of the first dead member found, if exists.
'***************************************************

    dim pretoindex as integer
    dim allyindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        
        if pretorianos(pretoindex).npcindex = 0 then
            allydead = pretoindex
            exit function
        end if
        
    next pretoindex

end function

public function canatackmember(byval npcindex as integer) as boolean
'***************************************************
'author: zama
'last modification: 26/09/2010
'returns true if given npcindex belongs to a normal clan member, o if king's alone.
'***************************************************
    
    ' king?
    if pretorianos(1).npcindex = npcindex then
        ' any member left? => can't attack
        if clanmembersalive <> 1 then exit function
    end if
    
    canatackmember = true
    
end function

public property get clanmap() as integer
'***************************************************
'author: zama
'last modification: 29/10/2010
'returns the clan map
'***************************************************
    clanmap = centerpos.map
end property

public property get active() as boolean
'***************************************************
'author: zama
'last modification: 29/10/2010
'returns true if clan is active.
'***************************************************
    active = clanactive
end property

public sub deleteclan()
'***************************************************
'author: zama
'last modification: 29/10/2010
'kill all alive members.
'***************************************************

    dim pretoindex as long
    dim npcindex as integer
    
    for pretoindex = 1 to nro_pretorianos
        
        npcindex = pretorianos(pretoindex).npcindex
        if npcindex <> 0 then call quitarnpc(npcindex)
    
        pretorianos(pretoindex).npcindex = 0
        
    next pretoindex
    
    clanactive = false
    
end sub
