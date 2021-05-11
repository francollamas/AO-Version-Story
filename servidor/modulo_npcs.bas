attribute vb_name = "npcs"
'argentum online 0.11.6
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

dim i as integer
userlist(userindex).nromacotas = userlist(userindex).nromacotas - 1
for i = 1 to maxmascotas
  if userlist(userindex).mascotasindex(i) = npcindex then
     userlist(userindex).mascotasindex(i) = 0
     userlist(userindex).mascotastype(i) = 0
     exit for
  end if
next i

end sub

sub quitarmascotanpc(byval maestro as integer, byval mascota as integer)
    npclist(maestro).mascotas = npclist(maestro).mascotas - 1
end sub

sub muerenpc(byval npcindex as integer, byval userindex as integer)
'********************************************************
'author: unknown
'llamado cuando la vida de un npc llega a cero.
'last modify date: 24/01/2007
'22/06/06: (nacho) chequeamos si es pretoriano
'24/01/2007: pablo (toxicwaste): agrego para actualizaci�n de tag si cambia de status.
'********************************************************
on error goto errhandler
    dim minpc as npc
    minpc = npclist(npcindex)
    dim eracriminal as boolean
   
    if (espretoriano(npcindex) = 4) then
        'seteamos todos estos 'flags' acorde para que cambien solos de alcoba
        dim i as integer
        dim j as integer
        dim npci as integer
        
        for i = 8 to 90
            for j = 8 to 90
                
                npci = mapdata(npclist(npcindex).pos.map, i, j).npcindex
                if npci > 0 then
                    if espretoriano(npci) > 0 then
                        npclist(npci).invent.armoureqpslot = iif(npclist(npcindex).pos.x > 50, 1, 5)
                    end if
                end if
            next j
        next i
        call crearclanpretoriano(mapa_pretoriano, npclist(npcindex).pos.x, npclist(npcindex).pos.y)
    elseif espretoriano(npcindex) > 0 then
            npclist(npcindex).invent.armoureqpslot = 0
            pretorianosvivos(switch(npclist(npcindex).pos.x < 50, 1, npclist(npcindex).pos.x > 50, 2)) = pretorianosvivos(switch(npclist(npcindex).pos.x < 50, 1, npclist(npcindex).pos.x > 50, 2)) - 1
    end if
   
    'quitamos el npc
    call quitarnpc(npcindex)
    
    if userindex > 0 then ' lo mato un usuario?
        if minpc.flags.snd3 > 0 then
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(minpc.flags.snd3))
        end if
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = enpctype.comun
        
        'el user que lo mato tiene mascotas?
        if userlist(userindex).nromacotas > 0 then
            dim t as integer
            for t = 1 to maxmascotas
                  if userlist(userindex).mascotasindex(t) > 0 then
                      if npclist(userlist(userindex).mascotasindex(t)).targetnpc = npcindex then
                              call followamo(userlist(userindex).mascotasindex(t))
                      end if
                  end if
            next t
        end if
        
        '[kevin]
        if minpc.flags.expcount > 0 then
            if userlist(userindex).partyindex > 0 then
                call mdparty.obtenerexito(userindex, minpc.flags.expcount, minpc.pos.map, minpc.pos.x, minpc.pos.y)
            else
                userlist(userindex).stats.exp = userlist(userindex).stats.exp + minpc.flags.expcount
                if userlist(userindex).stats.exp > maxexp then _
                    userlist(userindex).stats.exp = maxexp
                call writeconsolemsg(userindex, "has ganado " & minpc.flags.expcount & " puntos de experiencia.", fonttypenames.fonttype_fight)
            end if
            minpc.flags.expcount = 0
        end if
        
        '[/kevin]
        call writeconsolemsg(userindex, "has matado a la criatura!", fonttypenames.fonttype_fight)
        if userlist(userindex).stats.npcsmuertos < 32000 then _
            userlist(userindex).stats.npcsmuertos = userlist(userindex).stats.npcsmuertos + 1
        
        eracriminal = criminal(userindex)
        
        if minpc.stats.alineacion = 0 then
            if minpc.numero = guardias then
                userlist(userindex).reputacion.noblerep = 0
                userlist(userindex).reputacion.pleberep = 0
                userlist(userindex).reputacion.asesinorep = userlist(userindex).reputacion.asesinorep + 500
                if userlist(userindex).reputacion.asesinorep > maxrep then _
                    userlist(userindex).reputacion.asesinorep = maxrep
            end if
            if minpc.maestrouser = 0 then
                userlist(userindex).reputacion.asesinorep = userlist(userindex).reputacion.asesinorep + vlasesino
                if userlist(userindex).reputacion.asesinorep > maxrep then _
                    userlist(userindex).reputacion.asesinorep = maxrep
            end if
        elseif minpc.stats.alineacion = 1 then
            userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlcazador
            if userlist(userindex).reputacion.pleberep > maxrep then _
                userlist(userindex).reputacion.pleberep = maxrep
        elseif minpc.stats.alineacion = 2 then
            userlist(userindex).reputacion.noblerep = userlist(userindex).reputacion.noblerep + vlasesino / 2
            if userlist(userindex).reputacion.noblerep > maxrep then _
                userlist(userindex).reputacion.noblerep = maxrep
        elseif minpc.stats.alineacion = 4 then
            userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlcazador
            if userlist(userindex).reputacion.pleberep > maxrep then _
                userlist(userindex).reputacion.pleberep = maxrep
        end if
        if not criminal(userindex) and userlist(userindex).faccion.fuerzascaos = 1 then call expulsarfaccioncaos(userindex)
        
        if eracriminal and not criminal(userindex) then
            call refreshcharstatus(userindex)
        elseif not eracriminal and criminal(userindex) then
            call refreshcharstatus(userindex)
        end if
        
        call checkuserlevel(userindex)
    end if ' userindex > 0

   
    if minpc.maestrouser = 0 then
        'tiramos el oro
        call npctiraroro(minpc)
        'tiramos el inventario
        call npc_tirar_items(minpc)
    end if
   
    'respawn o no
    call respawnnpc(minpc)
   


exit sub

errhandler:
    call logerror("error en muerenpc - error: " & err.number & " - desc: " & err.description)
end sub

sub resetnpcflags(byval npcindex as integer)
    'clear the npc's flags
    
    with npclist(npcindex).flags
        .afectaparalisis = 0
        .aguavalida = 0
        .attackedby = vbnullstring
        .attackedfirstby = vbnullstring
        .attacking = 0
        .backup = 0
        .bendicion = 0
        .domable = 0
        .envenenado = 0
        .faccion = 0
        .follow = false
        .lanzaspells = 0
        .golpeexacto = 0
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
        .useainow = false
        .atacaapj = 0
        .atacaanpc = 0
        .aialineacion = e_alineacion.ninguna
        .aipersonalidad = e_personalidad.ninguna
    end with
end sub

sub resetnpccounters(byval npcindex as integer)

npclist(npcindex).contadores.paralisis = 0
npclist(npcindex).contadores.tiempoexistencia = 0

end sub

sub resetnpccharinfo(byval npcindex as integer)

npclist(npcindex).char.body = 0
npclist(npcindex).char.cascoanim = 0
npclist(npcindex).char.charindex = 0
npclist(npcindex).char.fx = 0
npclist(npcindex).char.head = 0
npclist(npcindex).char.heading = 0
npclist(npcindex).char.loops = 0
npclist(npcindex).char.shieldanim = 0
npclist(npcindex).char.weaponanim = 0


end sub


sub resetnpccriatures(byval npcindex as integer)


dim j as integer
for j = 1 to npclist(npcindex).nrocriaturas
    npclist(npcindex).criaturas(j).npcindex = 0
    npclist(npcindex).criaturas(j).npcname = vbnullstring
next j

npclist(npcindex).nrocriaturas = 0

end sub

sub resetexpresiones(byval npcindex as integer)

dim j as integer
for j = 1 to npclist(npcindex).nroexpresiones
    npclist(npcindex).expresiones(j) = vbnullstring
next j

npclist(npcindex).nroexpresiones = 0

end sub


sub resetnpcmaininfo(byval npcindex as integer)

    npclist(npcindex).attackable = 0
    npclist(npcindex).canattack = 0
    npclist(npcindex).comercia = 0
    npclist(npcindex).giveexp = 0
    npclist(npcindex).givegld = 0
    npclist(npcindex).hostile = 0
    npclist(npcindex).invrespawn = 0
    npclist(npcindex).level = 0
    
    if npclist(npcindex).maestrouser > 0 then call quitarmascota(npclist(npcindex).maestrouser, npcindex)
    if npclist(npcindex).maestronpc > 0 then call quitarmascotanpc(npclist(npcindex).maestronpc, npcindex)
    
    npclist(npcindex).maestrouser = 0
    npclist(npcindex).maestronpc = 0
    
    npclist(npcindex).mascotas = 0
    npclist(npcindex).movement = 0
    npclist(npcindex).name = "npc sin iniciar"
    npclist(npcindex).npctype = 0
    npclist(npcindex).numero = 0
    npclist(npcindex).orig.map = 0
    npclist(npcindex).orig.x = 0
    npclist(npcindex).orig.y = 0
    npclist(npcindex).poderataque = 0
    npclist(npcindex).poderevasion = 0
    npclist(npcindex).pos.map = 0
    npclist(npcindex).pos.x = 0
    npclist(npcindex).pos.y = 0
    npclist(npcindex).skilldomar = 0
    npclist(npcindex).target = 0
    npclist(npcindex).targetnpc = 0
    npclist(npcindex).tipoitems = 0
    npclist(npcindex).veneno = 0
    npclist(npcindex).desc = vbnullstring
    
    
    dim j as integer
    for j = 1 to npclist(npcindex).nrospells
        npclist(npcindex).spells(j) = 0
    next j
    
    call resetnpccharinfo(npcindex)
    call resetnpccriatures(npcindex)
    call resetexpresiones(npcindex)

end sub

sub quitarnpc(byval npcindex as integer)

on error goto errhandler

    npclist(npcindex).flags.npcactive = false
    
    if inmapbounds(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y) then
        call erasenpcchar(npclist(npcindex).pos.map, npcindex)
    end if
    
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
    npclist(npcindex).flags.npcactive = false
    call logerror("error en quitarnpc")

end sub

function testspawntrigger(pos as worldpos, optional puedeagua as boolean = false) as boolean
    
    if legalpos(pos.map, pos.x, pos.y, puedeagua) then
        testspawntrigger = _
        mapdata(pos.map, pos.x, pos.y).trigger <> 3 and _
        mapdata(pos.map, pos.x, pos.y).trigger <> 2 and _
        mapdata(pos.map, pos.x, pos.y).trigger <> 1
    end if

end function

sub crearnpc(nronpc as integer, mapa as integer, origpos as worldpos)
'call logtarea("sub crearnpc")
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
    
    if nindex = 0 then exit sub
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
                    exit sub
                else
                    altpos.x = 50
                    altpos.y = 50
                    call closestlegalpos(altpos, newpos)
                    if newpos.x <> 0 and newpos.y <> 0 then
                        npclist(nindex).pos.map = newpos.map
                        npclist(nindex).pos.x = newpos.x
                        npclist(nindex).pos.y = newpos.y
                        call makenpcchar(true, newpos.map, nindex, newpos.map, newpos.x, newpos.y)
                        exit sub
                    else
                        call quitarnpc(nindex)
                        call logerror(maxspawnattemps & " iteraciones en crearnpc mapa:" & mapa & " nronpc:" & nronpc)
                        exit sub
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

end sub

sub makenpcchar(byval tomap as boolean, sndindex as integer, npcindex as integer, byval map as integer, byval x as integer, byval y as integer)
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

sub changenpcchar(byval npcindex as integer, byval body as integer, byval head as integer, byval heading as eheading)
    if npcindex > 0 then
        npclist(npcindex).char.body = body
        npclist(npcindex).char.head = head
        npclist(npcindex).char.heading = heading
        
        call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharacterchange(body, head, heading, npclist(npcindex).char.charindex, 0, 0, 0, 0, 0))
    end if
end sub

sub erasenpcchar(byval sndindex as integer, byval npcindex as integer)

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

sub movenpcchar(byval npcindex as integer, byval nheading as byte)

on error goto errh
    dim npos as worldpos
    npos = npclist(npcindex).pos
    call headtopos(nheading, npos)
    
    'es mascota ????
    if npclist(npcindex).maestrouser > 0 then
        ' es una posicion legal
        if legalpos(npclist(npcindex).pos.map, npos.x, npos.y, npclist(npcindex).flags.aguavalida = 1) then
        
            if npclist(npcindex).flags.aguavalida = 0 and hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
            if npclist(npcindex).flags.tierrainvalida = 1 and not hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
            

            call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharactermove(npclist(npcindex).char.charindex, npos.x, npos.y))
            
            'update map and user pos
            mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0
            npclist(npcindex).pos = npos
            npclist(npcindex).char.heading = nheading
            mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = npcindex
            call checkupdateneedednpc(npcindex, nheading)
        end if
else ' no es mascota
        ' controlamos que la posicion sea legal, los npc que
        ' no son mascotas tienen mas restricciones de movimiento.
        if legalposnpc(npclist(npcindex).pos.map, npos.x, npos.y, npclist(npcindex).flags.aguavalida) then
            
            if npclist(npcindex).flags.aguavalida = 0 and hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
            if npclist(npcindex).flags.tierrainvalida = 1 and not hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
            
            '[alejo-18-5]
            'server

            call senddata(sendtarget.tonpcarea, npcindex, preparemessagecharactermove(npclist(npcindex).char.charindex, npos.x, npos.y))

            
            'update map and user pos
            mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0
            npclist(npcindex).pos = npos
            npclist(npcindex).char.heading = nheading
            mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = npcindex
            
            call checkupdateneedednpc(npcindex, nheading)
        
        else
            if npclist(npcindex).movement = tipoai.npcpathfinding then
                'someone has blocked the npc's way, we must to seek a new path!
                npclist(npcindex).pfinfo.pathlenght = 0
            end if
        
        end if
    end if

exit sub

errh:
    logerror ("error en move npc " & npcindex)


end sub

function nextopennpc() as integer
'call logtarea("sub nextopennpc")

on error goto errhandler

dim loopc as integer
  
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

dim n as integer
n = randomnumber(1, 100)
if n < 30 then
    userlist(userindex).flags.envenenado = 1
    call writeconsolemsg(userindex, "��la criatura te ha envenenado!!", fonttypenames.fonttype_fight)
end if

end sub

function spawnnpc(byval npcindex as integer, pos as worldpos, byval fx as boolean, byval respawn as boolean) as integer
'***************************************************
'autor: unknown (orginal version)
'last modification: 23/01/2007
'23/01/2007 -> pablo (toxicwaste): creates an npc of the type npcindex
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
dim it as integer

nindex = opennpc(npcindex, respawn)   'conseguimos un indice
puedeagua = npclist(nindex).flags.aguavalida
puedetierra = iif(npclist(nindex).flags.tierrainvalida = 1, false, true)

it = 0

if nindex > maxnpcs then
    spawnnpc = 0
    exit function
end if

do while not posicionvalida
        
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
        
        it = it + 1
        
        if it > maxspawnattemps then
            call quitarnpc(nindex)
            spawnnpc = 0
            call logerror("mas de " & maxspawnattemps & " iteraciones en spawnnpc mapa:" & pos.map & " index:" & npcindex)
            exit function
        end if
loop

'asignamos las nuevas coordenas
map = newpos.map
x = npclist(nindex).pos.x
y = npclist(nindex).pos.y

'crea el npc
call makenpcchar(true, map, nindex, map, x, y)

if fx then
    call senddata(sendtarget.tonpcarea, nindex, preparemessageplaywave(snd_warp))
    call senddata(sendtarget.tonpcarea, nindex, preparemessagecreatefx(npclist(nindex).char.charindex, fxids.fxwarp, 0))
end if

spawnnpc = nindex

end function

sub respawnnpc(minpc as npc)

if (minpc.flags.respawn = 0) then call crearnpc(minpc.numero, minpc.pos.map, minpc.orig)

end sub

'devuelve el nro de enemigos que hay en el mapa map
function npchostiles(byval map as integer) as integer

dim npcindex as integer
dim cont as integer

'contador
cont = 0
for npcindex = 1 to lastnpc

    '�esta vivo?
    if npclist(npcindex).flags.npcactive _
       and npclist(npcindex).pos.map = map _
       and npclist(npcindex).hostile = 1 and _
       npclist(npcindex).stats.alineacion = 2 then
            cont = cont + 1
           
    end if
    
next npcindex

npchostiles = cont

end function

sub npctiraroro(minpc as npc)

'si el npc tiene oro lo tiramos
'pablo (toxicwaste): ahora se puede poner m�s de 10k de drop de oro en los npc.
if minpc.givegld > 0 then
    dim miobj as obj
    dim miaux as double
    miaux = minpc.givegld
    do while miaux > 10000
        miobj.amount = 10000
        miobj.objindex = ioro
        call tiraritemalpiso(minpc.pos, miobj)
        miaux = miaux - 10000
    loop
    if miaux > 0 then
        miobj.amount = miaux
        miobj.objindex = ioro
        call tiraritemalpiso(minpc.pos, miobj)
    end if
    
end if

end sub

function opennpc(byval npcnumber as integer, optional byval respawn = true) as integer

'###################################################
'#               atencion peligro                  #
'###################################################
'
'    ���� no usar getvar para leer los npcs !!!!
'
'el que ose desafiar esta ley, se las tendr� que ver
'con migo. para leer los npcs se deber� usar la
'nueva clase clsleerinis.
'
'alejo
'
'###################################################

dim npcindex as integer
dim npcfile as string
dim leer as clsinireader

'if npcnumber > 499 then
        'npcfile = datpath & "npcs-hostiles.dat"
'        set leer = leernpcshostiles
'else
        npcfile = datpath & "npcs.dat"
        set leer = leernpcs
'end if

npcindex = nextopennpc

if npcindex > maxnpcs then 'limite de npcs
    opennpc = npcindex
    exit function
end if

npclist(npcindex).numero = npcnumber
npclist(npcindex).name = leer.getvalue("npc" & npcnumber, "name")
npclist(npcindex).desc = leer.getvalue("npc" & npcnumber, "desc")

npclist(npcindex).movement = val(leer.getvalue("npc" & npcnumber, "movement"))
npclist(npcindex).flags.oldmovement = npclist(npcindex).movement

npclist(npcindex).flags.aguavalida = val(leer.getvalue("npc" & npcnumber, "aguavalida"))
npclist(npcindex).flags.tierrainvalida = val(leer.getvalue("npc" & npcnumber, "tierrainvalida"))
npclist(npcindex).flags.faccion = val(leer.getvalue("npc" & npcnumber, "faccion"))

npclist(npcindex).npctype = val(leer.getvalue("npc" & npcnumber, "npctype"))

npclist(npcindex).char.body = val(leer.getvalue("npc" & npcnumber, "body"))
npclist(npcindex).char.head = val(leer.getvalue("npc" & npcnumber, "head"))
npclist(npcindex).char.heading = val(leer.getvalue("npc" & npcnumber, "heading"))

npclist(npcindex).attackable = val(leer.getvalue("npc" & npcnumber, "attackable"))
npclist(npcindex).comercia = val(leer.getvalue("npc" & npcnumber, "comercia"))
npclist(npcindex).hostile = val(leer.getvalue("npc" & npcnumber, "hostile"))
npclist(npcindex).flags.oldhostil = npclist(npcindex).hostile

npclist(npcindex).giveexp = val(leer.getvalue("npc" & npcnumber, "giveexp"))

'npclist(npcindex).flags.expdada = npclist(npcindex).giveexp
npclist(npcindex).flags.expcount = npclist(npcindex).giveexp

npclist(npcindex).veneno = val(leer.getvalue("npc" & npcnumber, "veneno"))

npclist(npcindex).flags.domable = val(leer.getvalue("npc" & npcnumber, "domable"))


npclist(npcindex).givegld = val(leer.getvalue("npc" & npcnumber, "givegld"))

npclist(npcindex).poderataque = val(leer.getvalue("npc" & npcnumber, "poderataque"))
npclist(npcindex).poderevasion = val(leer.getvalue("npc" & npcnumber, "poderevasion"))

npclist(npcindex).invrespawn = val(leer.getvalue("npc" & npcnumber, "invrespawn"))


npclist(npcindex).stats.maxhp = val(leer.getvalue("npc" & npcnumber, "maxhp"))
npclist(npcindex).stats.minhp = val(leer.getvalue("npc" & npcnumber, "minhp"))
npclist(npcindex).stats.maxhit = val(leer.getvalue("npc" & npcnumber, "maxhit"))
npclist(npcindex).stats.minhit = val(leer.getvalue("npc" & npcnumber, "minhit"))
npclist(npcindex).stats.def = val(leer.getvalue("npc" & npcnumber, "def"))
npclist(npcindex).stats.alineacion = val(leer.getvalue("npc" & npcnumber, "alineacion"))


dim loopc as integer
dim ln as string
npclist(npcindex).invent.nroitems = val(leer.getvalue("npc" & npcnumber, "nroitems"))
for loopc = 1 to npclist(npcindex).invent.nroitems
    ln = leer.getvalue("npc" & npcnumber, "obj" & loopc)
    npclist(npcindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
    npclist(npcindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
next loopc

npclist(npcindex).flags.lanzaspells = val(leer.getvalue("npc" & npcnumber, "lanzaspells"))
if npclist(npcindex).flags.lanzaspells > 0 then redim npclist(npcindex).spells(1 to npclist(npcindex).flags.lanzaspells)
for loopc = 1 to npclist(npcindex).flags.lanzaspells
    npclist(npcindex).spells(loopc) = val(leer.getvalue("npc" & npcnumber, "sp" & loopc))
next loopc


if npclist(npcindex).npctype = enpctype.entrenador then
    npclist(npcindex).nrocriaturas = val(leer.getvalue("npc" & npcnumber, "nrocriaturas"))
    redim npclist(npcindex).criaturas(1 to npclist(npcindex).nrocriaturas) as tcriaturasentrenador
    for loopc = 1 to npclist(npcindex).nrocriaturas
        npclist(npcindex).criaturas(loopc).npcindex = leer.getvalue("npc" & npcnumber, "ci" & loopc)
        npclist(npcindex).criaturas(loopc).npcname = leer.getvalue("npc" & npcnumber, "cn" & loopc)
    next loopc
end if



npclist(npcindex).flags.npcactive = true
npclist(npcindex).flags.useainow = false

if respawn then
    npclist(npcindex).flags.respawn = val(leer.getvalue("npc" & npcnumber, "respawn"))
else
    npclist(npcindex).flags.respawn = 1
end if

npclist(npcindex).flags.backup = val(leer.getvalue("npc" & npcnumber, "backup"))
npclist(npcindex).flags.respawnorigpos = val(leer.getvalue("npc" & npcnumber, "origpos"))
npclist(npcindex).flags.afectaparalisis = val(leer.getvalue("npc" & npcnumber, "afectaparalisis"))
npclist(npcindex).flags.golpeexacto = val(leer.getvalue("npc" & npcnumber, "golpeexacto"))


npclist(npcindex).flags.snd1 = val(leer.getvalue("npc" & npcnumber, "snd1"))
npclist(npcindex).flags.snd2 = val(leer.getvalue("npc" & npcnumber, "snd2"))
npclist(npcindex).flags.snd3 = val(leer.getvalue("npc" & npcnumber, "snd3"))

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

dim aux as string
aux = leer.getvalue("npc" & npcnumber, "nroexp")
if lenb(aux) = 0 then
    npclist(npcindex).nroexpresiones = 0
else
    npclist(npcindex).nroexpresiones = val(aux)
    redim npclist(npcindex).expresiones(1 to npclist(npcindex).nroexpresiones) as string
    for loopc = 1 to npclist(npcindex).nroexpresiones
        npclist(npcindex).expresiones(loopc) = leer.getvalue("npc" & npcnumber, "exp" & loopc)
    next loopc
end if

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

'tipo de items con los que comercia
npclist(npcindex).tipoitems = val(leer.getvalue("npc" & npcnumber, "tipoitems"))

'update contadores de npcs
if npcindex > lastnpc then lastnpc = npcindex
numnpcs = numnpcs + 1


'devuelve el nuevo indice
opennpc = npcindex

end function

sub dofollow(byval npcindex as integer, byval username as string)

if npclist(npcindex).flags.follow then
  npclist(npcindex).flags.attackedby = vbnullstring
  npclist(npcindex).flags.follow = false
  npclist(npcindex).movement = npclist(npcindex).flags.oldmovement
  npclist(npcindex).hostile = npclist(npcindex).flags.oldhostil
else
  npclist(npcindex).flags.attackedby = username
  npclist(npcindex).flags.follow = true
  npclist(npcindex).movement = 4 'follow
  npclist(npcindex).hostile = 0
end if

end sub

sub followamo(byval npcindex as integer)

  npclist(npcindex).flags.follow = true
  npclist(npcindex).movement = tipoai.sigueamo 'follow
  npclist(npcindex).hostile = 0
  npclist(npcindex).target = 0
  npclist(npcindex).targetnpc = 0

end sub

