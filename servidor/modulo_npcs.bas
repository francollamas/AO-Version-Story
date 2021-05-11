attribute vb_name = "npcs"
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

dim i as integer

npclist(maestro).mascotas = npclist(maestro).mascotas - 1

'for i = 1 to ubound(npclist(maestro).criaturas)
'  if npclist(maestro).criaturas(i).npcindex = mascota then
'     npclist(maestro).criaturas(i).npcindex = 0
'     npclist(maestro).criaturas(i).npcname = ""
'     exit for
'  end if
'next i

end sub

sub muerenpc(byval npcindex as integer, byval userindex as integer)
on error goto errhandler

'   call logtarea("sub muerenpc")
   
   dim minpc as npc
   minpc = npclist(npcindex)
   
   'quitamos el npc
   call quitarnpc(npcindex)
   
   
    
   if userindex > 0 then ' lo mato un usuario?
        if minpc.flags.snd3 > 0 then call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & minpc.flags.snd3)
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = 0
        
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
        
        call addtovar(userlist(userindex).stats.exp, minpc.giveexp, maxexp)
        call senddata(toindex, userindex, 0, "||has ganado " & minpc.giveexp & " puntos de experiencia." & fonttype_fight)
        call senddata(toindex, userindex, 0, "||has matado la criatura!" & fonttype_fight)
        call addtovar(userlist(userindex).stats.npcsmuertos, 1, 32000)
        
        if minpc.stats.alineacion = 0 then
              if minpc.numero = guardias then
                    call volvercriminal(userindex)
              end if
              if not esdios(userlist(userindex).name) then call addtovar(userlist(userindex).reputacion.asesinorep, vlasesino, maxrep)
        elseif minpc.stats.alineacion = 1 then
          call addtovar(userlist(userindex).reputacion.pleberep, vlcazador, maxrep)
        elseif minpc.stats.alineacion = 2 then
          call addtovar(userlist(userindex).reputacion.noblerep, vlasesino / 2, maxrep)
        elseif minpc.stats.alineacion = 4 then
          call addtovar(userlist(userindex).reputacion.pleberep, vlcazador, maxrep)
        end if
        if not criminal(userindex) and userlist(userindex).faccion.fuerzascaos = 1 then call expulsarfaccioncaos(userindex)
        
        'controla el nivel del usuario
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
    call logerror("error en muerenpc")
    
end sub

sub resetnpcflags(byval npcindex as integer)
'clear the npc's flags

npclist(npcindex).flags.afectaparalisis = 0
npclist(npcindex).flags.aguavalida = 0
npclist(npcindex).flags.attackedby = ""
npclist(npcindex).flags.attacking = 0
npclist(npcindex).flags.backup = 0
npclist(npcindex).flags.bendicion = 0
npclist(npcindex).flags.domable = 0
npclist(npcindex).flags.envenenado = 0
npclist(npcindex).flags.faccion = 0
npclist(npcindex).flags.follow = false
npclist(npcindex).flags.lanzaspells = 0
npclist(npcindex).flags.golpeexacto = 0
npclist(npcindex).flags.invisible = 0
npclist(npcindex).flags.maldicion = 0
npclist(npcindex).flags.oldhostil = 0
npclist(npcindex).flags.oldmovement = 0
npclist(npcindex).flags.paralizado = 0
npclist(npcindex).flags.respawn = 0
npclist(npcindex).flags.respawnorigpos = 0
npclist(npcindex).flags.snd1 = 0
npclist(npcindex).flags.snd2 = 0
npclist(npcindex).flags.snd3 = 0
npclist(npcindex).flags.snd4 = 0
npclist(npcindex).flags.tierrainvalida = 0
npclist(npcindex).flags.useainow = false

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
    npclist(npcindex).criaturas(j).npcname = ""
next j

npclist(npcindex).nrocriaturas = 0

end sub

sub resetexpresiones(byval npcindex as integer)

dim j as integer
for j = 1 to npclist(npcindex).nroexpresiones: npclist(npcindex).expresiones(j) = "": next j

npclist(npcindex).nroexpresiones = 0

end sub


sub resetnpcmaininfo(byval npcindex as integer)

npclist(npcindex).attackable = 0
npclist(npcindex).canattack = 0
npclist(npcindex).comercia = 0
npclist(npcindex).giveexp = 0
npclist(npcindex).givegld = 0
npclist(npcindex).hostile = 0
npclist(npcindex).inflacion = 0
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
npclist(npcindex).desc = ""

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
    call erasenpcchar(tomap, 0, npclist(npcindex).pos.map, npcindex)
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

function testspawntrigger(pos as worldpos) as boolean


if legalpos(pos.map, pos.x, pos.y) then
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
dim nindex as integer
dim posicionvalida as boolean
dim iteraciones as long


dim map as integer
dim x as integer
dim y as integer

nindex = opennpc(nronpc) 'conseguimos un indice

if nindex > maxnpcs then exit sub

'necesita ser respawned en un lugar especifico
if inmapbounds(origpos.map, origpos.x, origpos.y) then
    
    map = origpos.map
    x = origpos.x
    y = origpos.y
    npclist(nindex).orig = origpos
    npclist(nindex).pos = origpos
   
else
    
    pos.map = mapa 'mapa
    
    do while not posicionvalida
    
        randomize (timer)
        pos.x = cint(rnd * 100 + 1) 'obtenemos posicion al azar en x
        pos.y = cint(rnd * 100 + 1) 'obtenemos posicion al azar en y
        
        call closestlegalpos(pos, newpos)  'nos devuelve la posicion valida mas cercana
        
        'si x e y son iguales a 0 significa que no se encontro posicion valida
        if legalposnpc(newpos.map, newpos.x, newpos.y, npclist(nindex).flags.aguavalida) and _
           not haypcarea(newpos) and testspawntrigger(newpos) then
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
                call quitarnpc(nindex)
                call logerror(maxspawnattemps & " iteraciones en crearnpc mapa:" & mapa & " nronpc:" & nronpc)
                exit sub
        end if
    loop
    
    'asignamos las nuevas coordenas
    map = newpos.map
    x = npclist(nindex).pos.x
    y = npclist(nindex).pos.y
end if

'crea el npc
call makenpcchar(tomap, 0, map, nindex, map, x, y)

end sub

sub makenpcchar(sndroute as byte, sndindex as integer, sndmap as integer, npcindex as integer, byval map as integer, byval x as integer, byval y as integer)


dim charindex as integer

if npclist(npcindex).char.charindex = 0 then
    charindex = nextopencharindex
    npclist(npcindex).char.charindex = charindex
    charlist(charindex) = npcindex
end if


mapdata(map, x, y).npcindex = npcindex

call senddata(sndroute, sndindex, sndmap, "cc" & npclist(npcindex).char.body & "," & npclist(npcindex).char.head & "," & npclist(npcindex).char.heading & "," & npclist(npcindex).char.charindex & "," & x & "," & y)

end sub

sub changenpcchar(sndroute as byte, sndindex as integer, sndmap as integer, npcindex as integer, body as integer, head as integer, heading as byte)

if npcindex > 0 then
    npclist(npcindex).char.body = body
    npclist(npcindex).char.head = head
    npclist(npcindex).char.heading = heading
    call senddata(sndroute, sndindex, sndmap, "cp" & npclist(npcindex).char.charindex & "," & body & "," & head & "," & heading)
end if

end sub

sub erasenpcchar(sndroute as byte, sndindex as integer, sndmap as integer, byval npcindex as integer)

if npclist(npcindex).char.charindex <> 0 then charlist(npclist(npcindex).char.charindex) = 0

if npclist(npcindex).char.charindex = lastchar then
    do until charlist(lastchar) > 0
        lastchar = lastchar - 1
        if lastchar < 1 then exit do
    loop
end if

'quitamos del mapa
mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0

'actualizamos los cliente
call senddata(tomap, 0, npclist(npcindex).pos.map, "bp" & npclist(npcindex).char.charindex)

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
            if legalpos(npclist(npcindex).pos.map, npos.x, npos.y) then
            
                if npclist(npcindex).flags.aguavalida = 0 and hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
                if npclist(npcindex).flags.tierrainvalida = 1 and not hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
                
                '[alejo-18-5]
                call senddata(tomap, 0, npclist(npcindex).pos.map, "mp" & npclist(npcindex).char.charindex & "," & npos.x & "," & npos.y)
                'call senddata(tonpcarea, npcindex, npclist(npcindex).pos.map, "mp" & npclist(npcindex).char.charindex & "," & npos.x & "," & npos.y)
            
                'update map and user pos
                mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0
                npclist(npcindex).pos = npos
                npclist(npcindex).char.heading = nheading
                mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = npcindex
            end if
    else ' no es mascota
            ' controlamos que la posicion sea legal, los npc que
            ' no son mascotas tienen mas restricciones de movimiento.
            if legalposnpc(npclist(npcindex).pos.map, npos.x, npos.y, npclist(npcindex).flags.aguavalida) then
                
                if npclist(npcindex).flags.aguavalida = 0 and hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
                if npclist(npcindex).flags.tierrainvalida = 1 and not hayagua(npclist(npcindex).pos.map, npos.x, npos.y) then exit sub
                
                '[alejo-18-5]
                call senddata(tomap, 0, npclist(npcindex).pos.map, "mp" & npclist(npcindex).char.charindex & "," & npos.x & "," & npos.y)
                'call senddata(tonpcarea, npcindex, npclist(npcindex).pos.map, "mp" & npclist(npcindex).char.charindex & "," & npos.x & "," & npos.y)
                
                'update map and user pos
                mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = 0
                npclist(npcindex).pos = npos
                npclist(npcindex).char.heading = nheading
                mapdata(npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y).npcindex = npcindex
            else
                if npclist(npcindex).movement = npc_pathfinding then
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
    call senddata(toindex, userindex, 0, "||��la criatura te ha envenenado!!" & fonttype_fight)
end if

end sub

function spawnnpc(byval npcindex as integer, pos as worldpos, byval fx as boolean, byval respawn as boolean) as integer
'crea un npc del tipo npcindex
'call logtarea("sub spawnnpc")

dim newpos as worldpos
dim nindex as integer
dim posicionvalida as boolean


dim map as integer
dim x as integer
dim y as integer
dim it as integer

nindex = opennpc(npcindex, respawn)   'conseguimos un indice

it = 0

if nindex > maxnpcs then
    spawnnpc = nindex
    exit function
end if

do while not posicionvalida
        
        call closestlegalpos(pos, newpos)  'nos devuelve la posicion valida mas cercana
        'si x e y son iguales a 0 significa que no se encontro posicion valida
        if legalpos(newpos.map, newpos.x, newpos.y) then
            'asignamos las nuevas coordenas solo si son validas
            npclist(nindex).pos.map = newpos.map
            npclist(nindex).pos.x = newpos.x
            npclist(nindex).pos.y = newpos.y
            posicionvalida = true
        else
            newpos.x = 0
            newpos.y = 0
        end if
        
        it = it + 1
        
        if it > maxspawnattemps then
            call quitarnpc(nindex)
            spawnnpc = maxnpcs
            call logerror("mas de " & maxspawnattemps & " iteraciones en spawnnpc mapa:" & pos.map & " index:" & npcindex)
            exit function
        end if
loop
    
'asignamos las nuevas coordenas
map = newpos.map
x = npclist(nindex).pos.x
y = npclist(nindex).pos.y

'crea el npc
call makenpcchar(tomap, 0, map, nindex, map, x, y)

if fx then
    call senddata(tomap, 0, map, "tw" & snd_warp)
    call senddata(tomap, 0, map, "cfx" & npclist(nindex).char.charindex & "," & fxwarp & "," & 0)
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
if minpc.givegld > 0 then
    dim miobj as obj
    miobj.amount = minpc.givegld
    miobj.objindex = ioro
    call tiraritemalpiso(minpc.pos, miobj)
end if

end sub



function opennpc(byval npcnumber as integer, optional byval respawn = true) as integer

dim npcindex as integer
'dim npcfile as string
dim a as long, s as long

if npcnumber > 499 then
'        npcfile = datpath & "npcs-hostiles.dat"
    a = anpc_host
else
'        npcfile = datpath & "npcs.dat"
    a = anpc
end if

s = inibuscarseccion(a, "npc" & npcnumber)

npcindex = nextopennpc

if npcindex > maxnpcs then 'limite de npcs
    opennpc = npcindex
    exit function
end if

npclist(npcindex).numero = npcnumber
'npclist(npcindex).name = getvar(npcfile, "npc" & npcnumber, "name")
'npclist(npcindex).desc = getvar(npcfile, "npc" & npcnumber, "desc")
'
'npclist(npcindex).movement = val(getvar(npcfile, "npc" & npcnumber, "movement"))
'npclist(npcindex).flags.oldmovement = npclist(npcindex).movement

npclist(npcindex).name = inidarclavestr(a, s, "name")
npclist(npcindex).desc = inidarclavestr(a, s, "desc")

npclist(npcindex).movement = inidarclaveint(a, s, "movement")
npclist(npcindex).flags.oldmovement = npclist(npcindex).movement

npclist(npcindex).flags.aguavalida = inidarclaveint(a, s, "aguavalida")
npclist(npcindex).flags.tierrainvalida = inidarclaveint(a, s, "tierrainvalida")
npclist(npcindex).flags.faccion = inidarclaveint(a, s, "faccion")

npclist(npcindex).npctype = inidarclaveint(a, s, "npctype")

npclist(npcindex).char.body = inidarclaveint(a, s, "body")
npclist(npcindex).char.head = inidarclaveint(a, s, "head")
npclist(npcindex).char.heading = inidarclaveint(a, s, "heading")

npclist(npcindex).attackable = inidarclaveint(a, s, "attackable")
npclist(npcindex).comercia = inidarclaveint(a, s, "comercia")
npclist(npcindex).hostile = inidarclaveint(a, s, "hostile")
npclist(npcindex).flags.oldhostil = npclist(npcindex).hostile

npclist(npcindex).giveexp = inidarclaveint(a, s, "giveexp")

npclist(npcindex).veneno = inidarclaveint(a, s, "veneno")

npclist(npcindex).flags.domable = inidarclaveint(a, s, "domable")


npclist(npcindex).givegld = inidarclaveint(a, s, "givegld")

npclist(npcindex).poderataque = inidarclaveint(a, s, "poderataque")
npclist(npcindex).poderevasion = inidarclaveint(a, s, "poderevasion")

npclist(npcindex).invrespawn = inidarclaveint(a, s, "invrespawn")


npclist(npcindex).stats.maxhp = inidarclaveint(a, s, "maxhp")
npclist(npcindex).stats.minhp = inidarclaveint(a, s, "minhp")
npclist(npcindex).stats.maxhit = inidarclaveint(a, s, "maxhit")
npclist(npcindex).stats.minhit = inidarclaveint(a, s, "minhit")
npclist(npcindex).stats.def = inidarclaveint(a, s, "def")
npclist(npcindex).stats.alineacion = inidarclaveint(a, s, "alineacion")
npclist(npcindex).stats.impactrate = inidarclaveint(a, s, "impactrate")


dim loopc as integer
dim ln as string
npclist(npcindex).invent.nroitems = inidarclaveint(a, s, "nroitems")
for loopc = 1 to npclist(npcindex).invent.nroitems
    ln = inidarclavestr(a, s, "obj" & loopc)
    npclist(npcindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
    npclist(npcindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
next loopc

npclist(npcindex).flags.lanzaspells = inidarclaveint(a, s, "lanzaspells")
if npclist(npcindex).flags.lanzaspells > 0 then redim npclist(npcindex).spells(1 to npclist(npcindex).flags.lanzaspells)
for loopc = 1 to npclist(npcindex).flags.lanzaspells
    npclist(npcindex).spells(loopc) = inidarclaveint(a, s, "sp" & loopc)
next loopc


if npclist(npcindex).npctype = npctype_entrenador then
    npclist(npcindex).nrocriaturas = inidarclaveint(a, s, "nrocriaturas")
    redim npclist(npcindex).criaturas(1 to npclist(npcindex).nrocriaturas) as tcriaturasentrenador
    for loopc = 1 to npclist(npcindex).nrocriaturas
        npclist(npcindex).criaturas(loopc).npcindex = inidarclaveint(a, s, "ci" & loopc)
        npclist(npcindex).criaturas(loopc).npcname = inidarclavestr(a, s, "cn" & loopc)
    next loopc
end if


npclist(npcindex).inflacion = inidarclaveint(a, s, "inflacion")

npclist(npcindex).flags.npcactive = true
npclist(npcindex).flags.useainow = false

if respawn then
    npclist(npcindex).flags.respawn = inidarclaveint(a, s, "respawn")
else
    npclist(npcindex).flags.respawn = 1
end if

npclist(npcindex).flags.backup = inidarclaveint(a, s, "backup")
npclist(npcindex).flags.respawnorigpos = inidarclaveint(a, s, "origpos")
npclist(npcindex).flags.afectaparalisis = inidarclaveint(a, s, "afectaparalisis")
npclist(npcindex).flags.golpeexacto = inidarclaveint(a, s, "golpeexacto")


npclist(npcindex).flags.snd1 = inidarclaveint(a, s, "snd1")
npclist(npcindex).flags.snd2 = inidarclaveint(a, s, "snd2")
npclist(npcindex).flags.snd3 = inidarclaveint(a, s, "snd3")
npclist(npcindex).flags.snd4 = inidarclaveint(a, s, "snd4")

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

dim aux as long
aux = inidarclaveint(a, s, "nroexp")
npclist(npcindex).nroexpresiones = (aux)
    
if aux > 0 then
    redim npclist(npcindex).expresiones(1 to npclist(npcindex).nroexpresiones) as string
    for loopc = 1 to npclist(npcindex).nroexpresiones
        npclist(npcindex).expresiones(loopc) = inidarclavestr(a, s, "exp" & loopc)
    next loopc
end if

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

'tipo de items con los que comercia
npclist(npcindex).tipoitems = inidarclaveint(a, s, "tipoitems")

'update contadores de npcs
if npcindex > lastnpc then lastnpc = npcindex
numnpcs = numnpcs + 1


'devuelve el nuevo indice
opennpc = npcindex

end function


function opennpc_viejo(byval npcnumber as integer, optional byval respawn = true) as integer

dim npcindex as integer
dim npcfile as string

if npcnumber > 499 then
        npcfile = datpath & "npcs-hostiles.dat"
else
        npcfile = datpath & "npcs.dat"
end if


npcindex = nextopennpc

if npcindex > maxnpcs then 'limite de npcs
    opennpc_viejo = npcindex
    exit function
end if

npclist(npcindex).numero = npcnumber
npclist(npcindex).name = getvar(npcfile, "npc" & npcnumber, "name")
npclist(npcindex).desc = getvar(npcfile, "npc" & npcnumber, "desc")

npclist(npcindex).movement = val(getvar(npcfile, "npc" & npcnumber, "movement"))
npclist(npcindex).flags.oldmovement = npclist(npcindex).movement

npclist(npcindex).flags.aguavalida = val(getvar(npcfile, "npc" & npcnumber, "aguavalida"))
npclist(npcindex).flags.tierrainvalida = val(getvar(npcfile, "npc" & npcnumber, "tierrainvalida"))
npclist(npcindex).flags.faccion = val(getvar(npcfile, "npc" & npcnumber, "faccion"))

npclist(npcindex).npctype = val(getvar(npcfile, "npc" & npcnumber, "npctype"))

npclist(npcindex).char.body = val(getvar(npcfile, "npc" & npcnumber, "body"))
npclist(npcindex).char.head = val(getvar(npcfile, "npc" & npcnumber, "head"))
npclist(npcindex).char.heading = val(getvar(npcfile, "npc" & npcnumber, "heading"))

npclist(npcindex).attackable = val(getvar(npcfile, "npc" & npcnumber, "attackable"))
npclist(npcindex).comercia = val(getvar(npcfile, "npc" & npcnumber, "comercia"))
npclist(npcindex).hostile = val(getvar(npcfile, "npc" & npcnumber, "hostile"))
npclist(npcindex).flags.oldhostil = npclist(npcindex).hostile

npclist(npcindex).giveexp = val(getvar(npcfile, "npc" & npcnumber, "giveexp"))

npclist(npcindex).veneno = val(getvar(npcfile, "npc" & npcnumber, "veneno"))

npclist(npcindex).flags.domable = val(getvar(npcfile, "npc" & npcnumber, "domable"))


npclist(npcindex).givegld = val(getvar(npcfile, "npc" & npcnumber, "givegld"))

npclist(npcindex).poderataque = val(getvar(npcfile, "npc" & npcnumber, "poderataque"))
npclist(npcindex).poderevasion = val(getvar(npcfile, "npc" & npcnumber, "poderevasion"))

npclist(npcindex).invrespawn = val(getvar(npcfile, "npc" & npcnumber, "invrespawn"))


npclist(npcindex).stats.maxhp = val(getvar(npcfile, "npc" & npcnumber, "maxhp"))
npclist(npcindex).stats.minhp = val(getvar(npcfile, "npc" & npcnumber, "minhp"))
npclist(npcindex).stats.maxhit = val(getvar(npcfile, "npc" & npcnumber, "maxhit"))
npclist(npcindex).stats.minhit = val(getvar(npcfile, "npc" & npcnumber, "minhit"))
npclist(npcindex).stats.def = val(getvar(npcfile, "npc" & npcnumber, "def"))
npclist(npcindex).stats.alineacion = val(getvar(npcfile, "npc" & npcnumber, "alineacion"))
npclist(npcindex).stats.impactrate = val(getvar(npcfile, "npc" & npcnumber, "impactrate"))


dim loopc as integer
dim ln as string
npclist(npcindex).invent.nroitems = val(getvar(npcfile, "npc" & npcnumber, "nroitems"))
for loopc = 1 to npclist(npcindex).invent.nroitems
    ln = getvar(npcfile, "npc" & npcnumber, "obj" & loopc)
    npclist(npcindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
    npclist(npcindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
next loopc

npclist(npcindex).flags.lanzaspells = val(getvar(npcfile, "npc" & npcnumber, "lanzaspells"))
if npclist(npcindex).flags.lanzaspells > 0 then redim npclist(npcindex).spells(1 to npclist(npcindex).flags.lanzaspells)
for loopc = 1 to npclist(npcindex).flags.lanzaspells
    npclist(npcindex).spells(loopc) = val(getvar(npcfile, "npc" & npcnumber, "sp" & loopc))
next loopc


if npclist(npcindex).npctype = npctype_entrenador then
    npclist(npcindex).nrocriaturas = val(getvar(npcfile, "npc" & npcnumber, "nrocriaturas"))
    redim npclist(npcindex).criaturas(1 to npclist(npcindex).nrocriaturas) as tcriaturasentrenador
    for loopc = 1 to npclist(npcindex).nrocriaturas
        npclist(npcindex).criaturas(loopc).npcindex = getvar(npcfile, "npc" & npcnumber, "ci" & loopc)
        npclist(npcindex).criaturas(loopc).npcname = getvar(npcfile, "npc" & npcnumber, "cn" & loopc)
    next loopc
end if


npclist(npcindex).inflacion = val(getvar(npcfile, "npc" & npcnumber, "inflacion"))

npclist(npcindex).flags.npcactive = true
npclist(npcindex).flags.useainow = false

if respawn then
    npclist(npcindex).flags.respawn = val(getvar(npcfile, "npc" & npcnumber, "respawn"))
else
    npclist(npcindex).flags.respawn = 1
end if

npclist(npcindex).flags.backup = val(getvar(npcfile, "npc" & npcnumber, "backup"))
npclist(npcindex).flags.respawnorigpos = val(getvar(npcfile, "npc" & npcnumber, "origpos"))
npclist(npcindex).flags.afectaparalisis = val(getvar(npcfile, "npc" & npcnumber, "afectaparalisis"))
npclist(npcindex).flags.golpeexacto = val(getvar(npcfile, "npc" & npcnumber, "golpeexacto"))


npclist(npcindex).flags.snd1 = val(getvar(npcfile, "npc" & npcnumber, "snd1"))
npclist(npcindex).flags.snd2 = val(getvar(npcfile, "npc" & npcnumber, "snd2"))
npclist(npcindex).flags.snd3 = val(getvar(npcfile, "npc" & npcnumber, "snd3"))
npclist(npcindex).flags.snd4 = val(getvar(npcfile, "npc" & npcnumber, "snd4"))

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

dim aux as string
aux = getvar(npcfile, "npc" & npcnumber, "nroexp")
if aux = "" then
    npclist(npcindex).nroexpresiones = 0
else
    npclist(npcindex).nroexpresiones = val(aux)
    redim npclist(npcindex).expresiones(1 to npclist(npcindex).nroexpresiones) as string
    for loopc = 1 to npclist(npcindex).nroexpresiones
        npclist(npcindex).expresiones(loopc) = getvar(npcfile, "npc" & npcnumber, "exp" & loopc)
    next loopc
end if

'<<<<<<<<<<<<<< expresiones >>>>>>>>>>>>>>>>

'tipo de items con los que comercia
npclist(npcindex).tipoitems = val(getvar(npcfile, "npc" & npcnumber, "tipoitems"))

'update contadores de npcs
if npcindex > lastnpc then lastnpc = npcindex
numnpcs = numnpcs + 1


'devuelve el nuevo indice
opennpc_viejo = npcindex

end function

sub enviarlistacriaturas(byval userindex as integer, byval npcindex)
  dim sd as string
  dim k as integer
  sd = sd & npclist(npcindex).nrocriaturas & ","
  for k = 1 to npclist(npcindex).nrocriaturas
        sd = sd & npclist(npcindex).criaturas(k).npcname & ","
  next k
  sd = "lstcri" & sd
  call senddata(toindex, userindex, 0, sd)
end sub


sub dofollow(byval npcindex as integer, byval username as string)

if npclist(npcindex).flags.follow then
  npclist(npcindex).flags.attackedby = ""
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
  npclist(npcindex).movement = sigue_amo 'follow
  npclist(npcindex).hostile = 0
  npclist(npcindex).target = 0
  npclist(npcindex).targetnpc = 0

end sub

