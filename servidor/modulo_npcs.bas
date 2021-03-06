attribute vb_name = "npcs"
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


'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo npc
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'contiene todas las rutinas necesarias para cotrolar los
'npcs meno la rutina de ai que se encuentra en el modulo
'ai_npcs para su mejor comprension.
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

option explicit

sub quitarmascota(byval userindex as integer, byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim i as integer
    
    for i = 1 to maxmascotas
      if userlist(userindex).mascotasindex(i) = npcindex then
         userlist(userindex).mascotasindex(i) = 0
         userlist(userindex).mascotastype(i) = 0
         
         userlist(userindex).nromascotas = userlist(userindex).nromascotas - 1
         exit for
      end if
    next i
end sub

sub quitarmascotanpc(byval maestro as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    npclist(maestro).mascotas = npclist(maestro).mascotas - 1
end sub

public sub muerenpc(byval npcindex as integer, byval userindex as integer)
'********************************************************
'author: unknown
'llamado cuando la vida de un npc llega a cero.
'last modify date: 13/07/2010
'22/06/06: (nacho) chequeamos si es pretoriano
'24/01/2007: pablo (toxicwaste): agrego para actualizaci�n de tag si cambia de status.
'22/05/2010: zama - los caos ya no suben nobleza ni plebe al atacar npcs.
'23/05/2010: zama - el usuario pierde la pertenencia del npc.
'13/07/2010: zama - optimizaciones de logica en la seleccion de pretoriano, y el posible cambio de alencion del usuario.
'********************************************************
on error goto errhandler

    dim minpc as npc
    minpc = npclist(npcindex)
    dim eracriminal as boolean
    dim pretorianoindex as integer
   
   ' es pretoriano?
    if minpc.npctype = enpctype.pretoriano then
        call clanpretoriano(minpc.clanindex).muerepretoriano(npcindex)
    end if
      
    'quitamos el npc
    call quitarnpc(npcindex)
    
    if userindex > 0 then ' lo mato un usuario?
        with userlist(userindex)
        
            if minpc.flags.snd3 > 0 then
                call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(minpc.flags.snd3, minpc.pos.x, minpc.pos.y))
            end if
            .flags.targetnpc = 0
            .flags.targetnpctipo = enpctype.comun
            
            'el user que lo mato tiene mascotas?
            if .nromascotas > 0 then
                dim t as integer
                for t = 1 to maxmascotas
                      if .mascotasindex(t) > 0 then
                          if npclist(.mascotasindex(t)).targetnpc = npcindex then
                                  call followamo(.mascotasindex(t))
                          end if
                      end if
                next t
            end if
            
            '[kevin]
            if minpc.flags.expcount > 0 then
                if .partyindex > 0 then
                    call mdparty.obtenerexito(userindex, minpc.flags.expcount, minpc.pos.map, minpc.pos.x, minpc.pos.y)
                else
                    .stats.exp = .stats.exp + minpc.flags.expcount
                    if .stats.exp > maxexp then _
                        .stats.exp = maxexp
                    call writeconsolemsg(userindex, "has ganado " & minpc.flags.expcount & " puntos de experiencia.", fonttypenames.fonttype_fight)
                end if
                minpc.flags.expcount = 0
            end if
            
            '[/kevin]
            call writeconsolemsg(userindex, "�has matado a la criatura!", fonttypenames.fonttype_fight)
            if .stats.npcsmuertos < 32000 then _
                .stats.npcsmuertos = .stats.npcsmuertos + 1
            
            eracriminal = criminal(userindex)
            
            if minpc.stats.alineacion = 0 then
            
                if minpc.numero = guardias then
                    .reputacion.noblerep = 0
                    .reputacion.pleberep = 0
                    .reputacion.asesinorep = .reputacion.asesinorep + 500
                    if .reputacion.asesinorep > maxrep then _
                        .reputacion.asesinorep = maxrep
                end if
                
                if minpc.maestrouser = 0 then
                    .reputacion.asesinorep = .reputacion.asesinorep + vlasesino
                    if .reputacion.asesinorep > maxrep then _
                        .reputacion.asesinorep = maxrep
                end if
                
            elseif not escaos(userindex) then
                if minpc.stats.alineacion = 1 then
                    .reputacion.pleberep = .reputacion.pleberep + vlcazador
                    if .reputacion.pleberep > maxrep then _
                        .reputacion.pleberep = maxrep
                        
                elseif minpc.stats.alineacion = 2 then
                    .reputacion.noblerep = .reputacion.noblerep + vlasesino / 2
                    if .reputacion.noblerep > maxrep then _
                        .reputacion.noblerep = maxrep
                        
                elseif minpc.stats.alineacion = 4 then
                    .reputacion.pleberep = .reputacion.pleberep + vlcazador
                    if .reputacion.pleberep > maxrep then _
                        .reputacion.pleberep = maxrep
                        
                end if
            end if
            
            dim escriminal as boolean
            escriminal = criminal(userindex)
            
            ' cambio de alienacion?
            if eracriminal <> escriminal then
                
                ' se volvio pk?
                if escriminal then
                    if esarmada(userindex) then call expulsarfaccionreal(userindex)
                
                ' se volvio ciuda
                else
                    if escaos(userindex) then call expulsarfaccioncaos(userindex)
                end if
                
                call refreshcharstatus(userindex)
            end if
                        
            call checkuserlevel(userindex)
            
            if npcindex = .flags.paralizedbynpcindex then
                call removeparalisis(userindex)
            end if
            
        end with
    end if ' userindex > 0
   
    if minpc.maestrouser = 0 then
        'tiramos el inventario
        call npc_tirar_items(minpc, minpc.npctype = enpctype.pretoriano)
        'respawn o no
        call respawnnpc(minpc)
    end if
    
exit sub

errhandler:
    call logerror("error en muerenpc - error: " & err.number & " - desc: " & err.description)
end sub

private sub resetnpcflags(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'clear the npc's flags
    
    with npclist(npcindex).flags
        .afectaparalisis = 0
        .aguavalida = 0
        .attackedby = vbnullstring
        .attackedfirstby = vbnullstring
        .backup = 0
        .bendicion = 0
        .domable = 0
        .envenenado = 0
        .faccion = 0
        .follow = false
        .atacadoble = 0
        .lanzaspells = 0
        .invisible = 0
        .maldicion = 0
        .oldhostil = 0
        .oldmovement = 0
        .paralizado = 0
        .inmovilizado = 0
        .respawn = 0
        .respawnorigpos = 0
        .snd1 = 0
        .snd2 = 0
        .snd3 = 0
        .tierrainvalida = 0
    end with
end sub

private sub resetnpccounters(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with npclist(npcindex).contadores
        .paralisis = 0
        .tiempoexistencia = 0
    end with
end sub

private sub resetnpccharinfo(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with npclist(npcindex).char
        .body = 0
        .cascoanim = 0
        .charindex = 0
        .fx = 0
        .head = 0
        .heading = 0
        .loops = 0
        .shieldanim = 0
        .weaponanim = 0
    end with
end sub

private sub resetnpccriatures(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim j as long
    
    with npclist(npcindex)
        for j = 1 to .nrocriaturas
            .criaturas(j).npcindex = 0
            .criaturas(j).npcname = vbnullstring
        next j
        
        .nrocriaturas = 0
    end with
end sub

sub resetexpresiones(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim j as long
    
    with npclist(npcindex)
        for j = 1 to .nroexpresiones
            .expresiones(j) = vbnullstring
        next j
        
        .nroexpresiones = 0
    end with
end sub

private sub resetnpcmaininfo(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'22/05/2010: zama - ahora se resetea el due�o del npc tambi�n.
'***************************************************

    with npclist(npcindex)
        .attackable = 0
        .canattack = 0
        .comercia = 0
        .giveexp = 0
        .givegld = 0
        .hostile = 0
        .invrespawn = 0
        
        if .maestrouser > 0 then call quitarmascota(.maestrouser, npcindex)
        if .maestronpc > 0 then call quitarmascotanpc(.maestronpc)
        if .owner > 0 then call perdionpc(.owner)
        
        .maestrouser = 0
        .maestronpc = 0
        .owner = 0
        
        .mascotas = 0
        .movement = 0
        .name = vbnullstring
        .npctype = 0
        .numero = 0
        .orig.map = 0
        .orig.x = 0
        .orig.y = 0
        .poderataque = 0
        .poderevasion = 0
        .pos.map = 0
        .pos.x = 0
        .pos.y = 0
        .skilldomar = 0
        .target = 0
        .targetnpc = 0
        .tipoitems = 0
        .veneno = 0
        .desc = vbnullstring
        
        .clanindex = 0
        
        dim j as long
        for j = 1 to .nrospells
            .spells(j) = 0
        next j
    end with
    
    call resetnpccharinfo(npcindex)
    call resetnpccriatures(npcindex)
    call resetexpresiones(npcindex)
end sub

public sub quitarnpc(byval npcindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 16/11/2009
'16/11/2009: zama - now npcs lose their owner
'***************************************************
on error goto errhandler

    with npclist(npcindex)
        .flags.npcactive = false
        
        if inmapbounds(.pos.map, .pos.x, .pos.y) then
            call erasenpcchar(npcindex)
        end if
    end with
        
    'nos aseguramos de que el inventario sea removido...
    'asi los lobos no volveran a tirar armaduras ;))
    call resetnpcinv(npcindex)
    call resetnpcflags(npcindex)
    call resetnpccounters(npcindex)
    
    call resetnpcmaininfo(npcindex)
    
    if npcindex = lastnpc then
        do until npclist(lastnpc).flags.npcactive
            lastnpc = lastnpc - 1
            if lastnpc < 1 then exit do
        loop
    end if
        
      
    if numnpcs <> 0 then
        numnpcs = numnpcs - 1
    end if
exit sub

errhandler:
    call logerror("error en quitarnpc")
end sub

public sub quitarpet(byval userindex as integer, byval npcindex as integer)
'***************************************************
'autor: zama
'last modification: 18/11/2009
'kills a pet
'***************************************************
on error goto errhandler

    dim i as integer
    dim petindex as integer

    with userlist(userindex)
        
        ' busco el indice de la mascota
        for i = 1 to maxmascotas
            if .mascotasindex(i) = npcindex then petindex = i
        next i
        
        ' poco probable que pase, pero por las dudas..
        if petindex = 0 then exit sub
        
        ' limpio el slot de la mascota
        .nromascotas = .nromascotas - 1
        .mascotasindex(petindex) = 0
        .mascotastype(petindex) = 0
        
        ' elimino la mascota
        call quitarnpc(npcindex)
    end with
    
    exit sub

errhandler:
    call logerror("error en quitarpet. error: " & err.number & " desc: " & err.description & " npcindex: " & npcindex & " userindex: " & userindex & " petindex: " & petindex)
end sub

private function testspawntrigger(pos as worldpos, optional puedeagua as boolean = false) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    
    if legalpos(pos.map, pos.x, pos.y, puedeagua) then
        testspawntrigger = _
        mapdata(pos.map, pos.x, pos.y).trigger <> 3 and _
        mapdata(pos.map, pos.x, pos.y).trigger <> 2 and _
        mapdata(pos.map, pos.x, pos.y).trigger <> 1
    end if
    
end function

public function crearnpc(nronpc as integer, mapa as integer, origpos as worldpos, _
                         optional byval customhead as integer) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'crea un npc del tipo nronpc

dim pos as worldpos
dim newpos as worldpos
dim altpos as worldpos
dim nindex as integer
dim posicionvalida as boolean
dim iteraciones as long
dim puedeagua as boolean
dim puedetierra as boolean


dim map as integer
dim x as integer
dim y as integer

    nindex = opennpc(nronpc) 'conseguimos un indice
    
    if nindex > maxnpcs then exit function
    
    ' cabeza customizada
    if customhead <> 0 then npclist(nindex).char.head = customhead
    
    puedeagua = npclist(nindex).flags.aguavalida
    puedetierra = iif(npclist(nindex).flags.tierrainvalida = 1, false, true)
    
    'necesita ser respawned en un lugar especifico
    if inmapbounds(origpos.map, origpos.x, origpos.y) then
        
        map = origpos.map
        x = origpos.x
        y = origpos.y
        npclist(nindex).orig = origpos
        npclist(nindex).pos = origpos
       
    else
        
        pos.map = mapa 'mapa
        altpos.map = mapa
        
        do while not posicionvalida
            pos.x = randomnumber(minxborder, maxxborder)    'obtenemos posicion al azar en x
            pos.y = randomnumber(minyborder, maxyborder)    'obtenemos posicion al azar en y
            
            call closestlegalpos(pos, newpos, puedeagua, puedetierra)  'nos devuelve la posicion valida mas cercana
            if newpos.x <> 0 and newpos.y <> 0 then
                altpos.x = newpos.x
                altpos.y = newpos.y     'posicion alternativa (para evitar el anti respawn, pero intentando qeu si ten�a que ser en el agua, sea en el agua.)
            else
                call closestlegalpos(pos, newpos, puedeagua)
                if newpos.x <> 0 and newpos.y <> 0 then
                    altpos.x = newpos.x
                    altpos.y = newpos.y     'posicion alternativa (para evitar el anti respawn)
                end if
            end if
            'si x e y son iguales a 0 significa que no se encontro posicion valida
            if legalposnpc(newpos.map, newpos.x, newpos.y, puedeagua) and _
               not haypcarea(newpos) and testspawntrigger(newpos, puedeagua) then
                'asignamos las nuevas coordenas solo si son validas
                npclist(nindex).pos.map = newpos.map
                npclist(nindex).pos.x = newpos.x
                npclist(nindex).pos.y = newpos.y
                posicionvalida = true
            else
                newpos.x = 0
                newpos.y = 0
            
            end if
                
                
                
            'for debug
            iteraciones = iteraciones + 1
            if iteraciones > maxspawnattemps then
                if altpos.x <> 0 and altpos.y <> 0 then
                    map = altpos.map
                    x = altpos.x
                    y = altpos.y
                    npclist(nindex).pos.map = map
                    npclist(nindex).pos.x = x
                    npclist(nindex).pos.y = y
                    call makenpcchar(true, map, nindex, map, x, y)
                    exit function
                else
                    altpos.x = 50
                    altpos.y = 50
                    call closestlegalpos(altpos, newpos)
                    if newpos.x <> 0 and newpos.y <> 0 then
                        npclist(nindex).pos.map = newpos.map
                        npclist(nindex).pos.x = newpos.x
                        npclist(nindex).pos.y = newpos.y
                        call makenpcchar(true, newpos.map, nindex, newpos.map, newpos.x, newpos.y)
                        exit function
                    else
                        call quitarnpc(nindex)
                        call logerror(maxspawnattemps & " iteraciones en crearnpc mapa:" & mapa & " nronpc:" & nronpc)
                        exit function
                    end if
                end if
            end if
        loop
            
        'asignamos las nuevas coordenas
        map = newpos.map
        x = npclist(nindex).pos.x
        y = npclist(nindex).pos.y
    end if
            
    'crea el npc
    call makenpcchar(true, map, nindex, map, x, y)
    
    crearnpc = nindex
    
end function

public sub makenpcchar(byval tomap as boolean, sndindex as integer, npcindex as integer, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    
    dim charindex as integer

    if npclist(npcindex).char.charindex = 0 then
        charindex = nextopencharindex
        npclist(npcindex).char.charindex = charindex
        charlist(charindex) = npcindex
    end if
    
    mapdata(map, x, y).npcindex = npcindex
    
    if not tomap then
        call writecharactercreate(sndindex, npclist(npcindex).char.body, npclist(npcindex).char.head, npclist(npcindex).char.heading, npclist(npcindex).char.charindex, x, y, 0, 0, 0, 0, 0, vbnullstring, 0, 0)
        call flushbuffer(sndindex)
    else
        call agregarnpc(npcindex)
    end if
end sub

public sub changenpcchar(byval npcindex as integer, byval body as integer, byval head as integer, byval heading as eheading)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if npcindex > 0 then
        with npclist(npcindex).char
            .body = body
            .head = head
            .heading = heading
            
            call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharacterchange(body, head, heading, .charindex, 0, 0, 0, 0, 0))
        end with
    end if
end sub

private sub erasenpcchar(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

if npclist(npcindex).char.charindex <> 0 then charlist(npclist(npcindex).char.charindex) = 0

if npclist(npcindex).char.charindex = lastchar then
    do until charlist(lastchar) > 0
        lastchar = lastchar - 1
        if lastchar <= 1 then exit do
    loop
end if

'quitamos del mapa
mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0

'actualizamos los clientes
call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharacterremove(npclist(npcindex).char.charindex))

'update la lista npc
npclist(npcindex).char.charindex = 0


'update numchars
numchars = numchars - 1


end sub

public function movenpcchar(byval npcindex as integer, byval nheading as byte) as boolean
'***************************************************
'autor: unknown (orginal version)
'last modification: 06/04/2009
'06/04/2009: zama - now npcs can force to change position with dead character
'01/08/2009: zama - now npcs can't force to chance position with a dead character if that means to change the terrain the character is in
'26/09/2010: zama - turn sub into function to know if npc has moved or not.
'***************************************************

on error goto errh

    dim npos as worldpos
    dim userindex as integer
    
    with npclist(npcindex)
        npos = .pos
        call headtopos(nheading, npos)
        
        ' es una posicion legal
        if legalposnpc(npos.map, npos.x, npos.y, .flags.aguavalida = 1, .maestrouser <> 0) then
            
            if .flags.aguavalida = 0 and hayagua(.pos.map, npos.x, npos.y) then exit function
            if .flags.tierrainvalida = 1 and not hayagua(.pos.map, npos.x, npos.y) then exit function
            
            userindex = mapdata(.pos.map, npos.x, npos.y).userindex
            ' si hay un usuario a donde se mueve el npc, entonces esta muerto
            if userindex > 0 then
                
                ' no se traslada caspers de agua a tierra
                if hayagua(.pos.map, npos.x, npos.y) and not hayagua(.pos.map, .pos.x, .pos.y) then exit function
                ' no se traslada caspers de tierra a agua
                if not hayagua(.pos.map, npos.x, npos.y) and hayagua(.pos.map, .pos.x, .pos.y) then exit function
                
                with userlist(userindex)
                    ' actualizamos posicion y mapa
                    mapdata(.pos.map, .pos.x, .pos.y).userindex = 0
                    .pos.x = npclist(npcindex).pos.x
                    .pos.y = npclist(npcindex).pos.y
                    mapdata(.pos.map, .pos.x, .pos.y).userindex = userindex
                        
                    ' avisamos a los usuarios del area, y al propio usuario lo forzamos a moverse
                    call senddata(sendtarget.topcareabutindex, userindex, preparemessagecharactermove(userlist(userindex).char.charindex, .pos.x, .pos.y))
                    call writeforcecharmove(userindex, invertheading(nheading))
                end with
            end if
            
            call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharactermove(.char.charindex, npos.x, npos.y))

            'update map and user pos
            mapdata(.pos.map, .pos.x, .pos.y).npcindex = 0
            .pos = npos
            .char.heading = nheading
            mapdata(.pos.map, npos.x, npos.y).npcindex = npcindex
            call checkupdateneedednpc(npcindex, nheading)
        
            ' npc has moved
            movenpcchar = true
        
        elseif .maestrouser = 0 then
            if .movement = tipoai.npcpathfinding then
                'someone has blocked the npc's way, we must to seek a new path!
                .pfinfo.pathlenght = 0
            end if
        end if
    end with
    
    exit function

errh:
    logerror ("error en move npc " & npcindex & ". error: " & err.number & " - " & err.description)
end function

function nextopennpc() as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    dim loopc as long
      
    for loopc = 1 to maxnpcs + 1
        if loopc > maxnpcs then exit for
        if not npclist(loopc).flags.npcactive then exit for
    next loopc
      
    nextopennpc = loopc
exit function

errhandler:
    call logerror("error en nextopennpc")
end function

sub npcenvenenaruser(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 10/07/2010
'10/07/2010: zama - now npcs can't poison dead users.
'***************************************************

    dim n as integer
    
    with userlist(userindex)
        if .flags.muerto = 1 then exit sub
        
        n = randomnumber(1, 100)
        if n < 30 then
            .flags.envenenado = 1
            call writeconsolemsg(userindex, "��la criatura te ha envenenado!!", fonttypenames.fonttype_fight)
        end if
    end with
    
end sub

function spawnnpc(byval npcindex as integer, pos as worldpos, byval fx as boolean, byval respawn as boolean) as integer
'***************************************************
'autor: unknown (orginal version)
'last modification: 06/15/2008
'23/01/2007 -> pablo (toxicwaste): creates an npc of the type npcindex
'06/15/2008 -> optimiz� el codigo. (niconz)
'***************************************************
dim newpos as worldpos
dim altpos as worldpos
dim nindex as integer
dim posicionvalida as boolean
dim puedeagua as boolean
dim puedetierra as boolean


dim map as integer
dim x as integer
dim y as integer

nindex = opennpc(npcindex, respawn)    'conseguimos un indice

if nindex > maxnpcs then
    spawnnpc = 0
    exit function
end if

puedeagua = npclist(nindex).flags.aguavalida
puedetierra = not npclist(nindex).flags.tierrainvalida = 1
        
call closestlegalpos(pos, newpos, puedeagua, puedetierra)  'nos devuelve la posicion valida mas cercana
call closestlegalpos(pos, altpos, puedeagua)
'si x e y son iguales a 0 significa que no se encontro posicion valida

if newpos.x <> 0 and newpos.y <> 0 then
    'asignamos las nuevas coordenas solo si son validas
    npclist(nindex).pos.map = newpos.map
    npclist(nindex).pos.x = newpos.x
    npclist(nindex).pos.y = newpos.y
    posicionvalida = true
else
    if altpos.x <> 0 and altpos.y <> 0 then
        npclist(nindex).pos.map = altpos.map
        npclist(nindex).pos.x = altpos.x
        npclist(nindex).pos.y = altpos.y
        posicionvalida = true
    else
        posicionvalida = false
    end if
end if

if not posicionvalida then
    call quitarnpc(nindex)
    spawnnpc = 0
    exit function
end if

'asignamos las nuevas coordenas
map = newpos.map
x = npclist(nindex).pos.x
y = npclist(nindex).pos.y

'crea el npc
call makenpcchar(true, map, nindex, map, x, y)

if fx then
    call senddata(sendtarget.tonpcarea, nindex, preparemessageplaywave(snd_warp, x, y))
    call senddata(sendtarget.tonpcarea, nindex, preparemessagecreatefx(npclist(nindex).char.charindex, fxids.fxwarp, 0))
end if

spawnnpc = nindex

end function

sub respawnnpc(minpc as npc)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if (minpc.flags.respawn = 0) then call crearnpc(minpc.numero, minpc.pos.map, minpc.orig)

end sub

private sub npctiraroro(byref minpc as npc)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'si el npc tiene oro lo tiramos
    if minpc.givegld > 0 then
        dim miobj as obj
        dim miaux as long
        miaux = minpc.givegld
        do while miaux > max_inventory_objs
            miobj.amount = max_inventory_objs
            miobj.objindex = ioro
            call tiraritemalpiso(minpc.pos, miobj)
            miaux = miaux - max_inventory_objs
        loop
        if miaux > 0 then
            miobj.amount = miaux
            miobj.objindex = ioro
            call tiraritemalpiso(minpc.pos, miobj)
        end if
    end if
end sub

public function opennpc(byval npcnumber as integer, optional byval respawn = true) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'###################################################
'#               atencion peligro                  #
'###################################################
'
'    ���� no usar getvar para leer los npcs !!!!
'
'el que ose desafiar esta ley, se las tendr� que ver
'conmigo. para leer los npcs se deber� usar la
'nueva clase clsinimanager.
'
'alejo
'
'###################################################
    dim npcindex as integer
    dim leer as clsinimanager
    dim loopc as long
    dim ln as string
    
    set leer = leernpcs
    
    'if requested index is invalid, abort
    if not leer.keyexists("npc" & npcnumber) then
        opennpc = maxnpcs + 1
        exit function
    end if
    
    npcindex = nextopennpc
    
    if npcindex > maxnpcs then 'limite de npcs
        opennpc = npcindex
        exit function
    end if
    
    with npclist(npcindex)
        .numero = npcnumber
        .name = leer.getvalue("npc" & npcnumber, "name")
        .desc = leer.getvalue("npc" & npcnumber, "desc")
        
        .movement = val(leer.getvalue("npc" & npcnumber, "movement"))
        .flags.oldmovement = .movement
        
        .flags.aguavalida = val(leer.getvalue("npc" & npcnumber, "aguavalida"))
        .flags.tierrainvalida = val(leer.getvalue("npc" & npcnumber, "tierrainvalida"))
        .flags.faccion = val(leer.getvalue("npc" & npcnumber, "faccion"))
        .flags.atacadoble = val(leer.getvalue("npc" & npcnumber, "atacadoble"))
        
        .npctype = val(leer.getvalue("npc" & npcnumber, "npctype"))
        
        .char.body = val(leer.getvalue("npc" & npcnumber, "body"))
        .char.head = val(leer.getvalue("npc" & npcnumber, "head"))
        .char.heading = val(leer.getvalue("npc" & npcnumber, "heading"))
        
        .attackable = val(leer.getvalue("npc" & npcnumber, "attackable"))
        .comercia = val(leer.getvalue("npc" & npcnumber, "comercia"))
        .hostile = val(leer.getvalue("npc" & npcnumber, "hostile"))
        .flags.oldhostil = .hostile
        
        .giveexp = val(leer.getvalue("npc" & npcnumber, "giveexp"))
        
        .flags.expcount = .giveexp
        
        .veneno = val(leer.getvalue("npc" & npcnumber, "veneno"))
        
        .flags.domable = val(leer.getvalue("npc" & npcnumber, "domable"))
        
        .givegld = val(leer.getvalue("npc" & npcnumber, "givegld"))
        
        .poderataque = val(leer.getvalue("npc" & npcnumber, "poderataque"))
        .poderevasion = val(leer.getvalue("npc" & npcnumber, "poderevasion"))
        
        .invrespawn = val(leer.getvalue("npc" & npcnumber, "invrespawn"))
        
        with .stats
            .maxhp = val(leer.getvalue("npc" & npcnumber, "maxhp"))
            .minhp = val(leer.getvalue("npc" & npcnumber, "minhp"))
            .maxhit = val(leer.getvalue("npc" & npcnumber, "maxhit"))
            .minhit = val(leer.getvalue("npc" & npcnumber, "minhit"))
            .def = val(leer.getvalue("npc" & npcnumber, "def"))
            .defm = val(leer.getvalue("npc" & npcnumber, "defm"))
            .alineacion = val(leer.getvalue("npc" & npcnumber, "alineacion"))
        end with
        
        .invent.nroitems = val(leer.getvalue("npc" & npcnumber, "nroitems"))
        for loopc = 1 to .invent.nroitems
            ln = leer.getvalue("npc" & npcnumber, "obj" & loopc)
            .invent.object(loopc).objindex = val(readfield(1, ln, 45))
            .invent.object(loopc).amount = val(readfield(2, ln, 45))
        next loopc
        
        for loopc = 1 to max_npc_drops
            ln = leer.getvalue("npc" & npcnumber, "drop" & loopc)
            .drop(loopc).objindex = val(readfield(1, ln, 45))
            .drop(loopc).amount = val(readfield(2, ln, 45))
        next loopc

        
        .flags.lanzaspells = val(leer.getvalue("npc" & npcnumber, "lanzaspells"))
        if .flags.lanzaspells > 0 then redim .spells(1 to .flags.lanzaspells)
        for loopc = 1 to .flags.lanzaspells
            .spells(loopc) = val(leer.getvalue("npc" & npcnumber, "sp" & loopc))
        next loopc
        
        if .npctype = enpctype.entrenador then
            .nrocriaturas = val(leer.getvalue("npc" & npcnumber, "nrocriaturas"))
            redim .criaturas(1 to .nrocriaturas) as tcriaturasentrenador
            for loopc = 1 to .nrocriaturas
                .criaturas(loopc).npcindex = leer.getvalue("npc" & npcnumber, "ci" & loopc)
                .criaturas(loopc).npcname = leer.getvalue("npc" & npcnumber, "cn" & loopc)
            next loopc
        end if
        
        with .flags
            .npcactive = true
            
            if respawn then
                .respawn = val(leer.getvalue("npc" & npcnumber, "respawn"))
            else
                .respawn = 1
            end if
            
            .backup = val(leer.getvalue("npc" & npcnumber, "backup"))
            .respawnorigpos = val(leer.getvalue("npc" & npcnumber, "origpos"))
            .afectaparalisis = val(leer.getvalue("npc" & npcnumber, "afectaparalisis"))
            
            .snd1 = val(leer.getvalue("npc" & npcnumber, "snd1"))
            .snd2 = val(leer.getvalue("npc" & npcnumber, "snd2"))
            .snd3 = val(leer.getvalue("npc" & npcnumber, "snd3"))
        end with
        
        '<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>
        .nroexpresiones = val(leer.getvalue("npc" & npcnumber, "nroexp"))
        if .nroexpresiones > 0 then redim .expresiones(1 to .nroexpresiones) as string
        for loopc = 1 to .nroexpresiones
            .expresiones(loopc) = leer.getvalue("npc" & npcnumber, "exp" & loopc)
        next loopc
        '<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>
        
        'tipo de items con los que comercia
        .tipoitems = val(leer.getvalue("npc" & npcnumber, "tipoitems"))
        
        .ciudad = val(leer.getvalue("npc" & npcnumber, "ciudad"))
    end with
    
    'update contadores de npcs
    if npcindex > lastnpc then lastnpc = npcindex
    numnpcs = numnpcs + 1
    
    'devuelve el nuevo indice
    opennpc = npcindex
end function

public sub dofollow(byval npcindex as integer, byval username as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with npclist(npcindex)
        if .flags.follow then
            .flags.attackedby = vbnullstring
            .flags.follow = false
            .movement = .flags.oldmovement
            .hostile = .flags.oldhostil
        else
            .flags.attackedby = username
            .flags.follow = true
            .movement = tipoai.npcdefensa
            .hostile = 0
        end if
    end with
end sub

public sub followamo(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with npclist(npcindex)
        .flags.follow = true
        .movement = tipoai.sigueamo
        .hostile = 0
        .target = 0
        .targetnpc = 0
    end with
end sub

public sub validarpermanencianpc(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'chequea si el npc continua perteneciendo a alg�n usuario
'***************************************************

    with npclist(npcindex)
        if intervaloperdionpc(.owner) then call perdionpc(.owner)
    end with
end sub
