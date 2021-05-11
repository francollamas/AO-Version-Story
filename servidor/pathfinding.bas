attribute vb_name = "pathfinding"
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

'#######################################################
'pathfinding module
'coded by gulfas morgolock
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'
'ore is an excellent engine for introducing you not only
'to online game programming but also to general
'game programming. i am convinced that aaron perkings, creator
'of ore, did a great work. he made possible that a lot of
'people enjoy for no fee games made with his engine, and
'for me, this is something great.
'
'i'd really like to contribute to this work, and all the
'projects of free ore-based mmorpgs that are on the net.
'
'i did some basic improvements on the ai of the npcs, i
'added pathfinding, so now, the npcs are able to avoid
'obstacles. i believe that this improvement was essential
'for the engine.
'
'i'd like to see this as my contribution to ore project,
'i hope that someone finds this source code useful.
'so, please feel free to do whatever you want with my
'pathfinging module.
'
'i'd really appreciate that if you find this source code
'useful you mention my nickname on the credits of your
'program. but there is no obligation ;).
'
'.........................................................
'note:
'there is a little problem, ore refers to map arrays in a
'different manner that my pathfinding routines. when i wrote
'these routines, i did it without thinking in ore, so in my
'program i refer to maps in the usual way i do it.
'
'for example, suppose we have:
'map(1 to y,1 to x) as mapblock
'i usually use the first coordinate as y, and
'the second one as x.
'
'ore refers to maps in converse way, for example:
'map(1 to x,1 to y) as mapblock. as you can see the
'roles of first and second coordinates are different
'that my routines
'
'#######################################################


option explicit

private const rows as integer = 100
private const colums as integer = 100
private const maxint as integer = 1000

private type tintermidiatework
    known as boolean
    distv as integer
    prevv as tvertice
end type

dim tmparray(1 to rows, 1 to colums) as tintermidiatework

dim tileposy as integer

private function limites(byval vfila as integer, byval vcolu as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

limites = vcolu >= 1 and vcolu <= colums and vfila >= 1 and vfila <= rows
end function

private function iswalkable(byval map as integer, byval row as integer, byval col as integer, byval npcindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

iswalkable = mapdata(map, row, col).blocked = 0 and mapdata(map, row, col).npcindex = 0

if mapdata(map, row, col).userindex <> 0 then
     if mapdata(map, row, col).userindex <> npclist(npcindex).pfinfo.targetuser then iswalkable = false
end if

end function

private sub processadjacents(byval mapindex as integer, byref t() as tintermidiatework, byref vfila as integer, byref vcolu as integer, byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim v as tvertice
    dim j as integer
    'look to north
    j = vfila - 1
    if limites(j, vcolu) then
            if iswalkable(mapindex, j, vcolu, npcindex) then
                    'nos aseguramos que no hay un camino m�s corto
                    if t(j, vcolu).distv = maxint then
                        'actualizamos la tabla de calculos intermedios
                        t(j, vcolu).distv = t(vfila, vcolu).distv + 1
                        t(j, vcolu).prevv.x = vcolu
                        t(j, vcolu).prevv.y = vfila
                        'mete el vertice en la cola
                        v.x = vcolu
                        v.y = j
                        call push(v)
                    end if
            end if
    end if
    j = vfila + 1
    'look to south
    if limites(j, vcolu) then
            if iswalkable(mapindex, j, vcolu, npcindex) then
                'nos aseguramos que no hay un camino m�s corto
                if t(j, vcolu).distv = maxint then
                    'actualizamos la tabla de calculos intermedios
                    t(j, vcolu).distv = t(vfila, vcolu).distv + 1
                    t(j, vcolu).prevv.x = vcolu
                    t(j, vcolu).prevv.y = vfila
                    'mete el vertice en la cola
                    v.x = vcolu
                    v.y = j
                    call push(v)
                end if
            end if
    end if
    'look to west
    if limites(vfila, vcolu - 1) then
            if iswalkable(mapindex, vfila, vcolu - 1, npcindex) then
                'nos aseguramos que no hay un camino m�s corto
                if t(vfila, vcolu - 1).distv = maxint then
                    'actualizamos la tabla de calculos intermedios
                    t(vfila, vcolu - 1).distv = t(vfila, vcolu).distv + 1
                    t(vfila, vcolu - 1).prevv.x = vcolu
                    t(vfila, vcolu - 1).prevv.y = vfila
                    'mete el vertice en la cola
                    v.x = vcolu - 1
                    v.y = vfila
                    call push(v)
                end if
            end if
    end if
    'look to east
    if limites(vfila, vcolu + 1) then
            if iswalkable(mapindex, vfila, vcolu + 1, npcindex) then
                'nos aseguramos que no hay un camino m�s corto
                if t(vfila, vcolu + 1).distv = maxint then
                    'actualizamos la tabla de calculos intermedios
                    t(vfila, vcolu + 1).distv = t(vfila, vcolu).distv + 1
                    t(vfila, vcolu + 1).prevv.x = vcolu
                    t(vfila, vcolu + 1).prevv.y = vfila
                    'mete el vertice en la cola
                    v.x = vcolu + 1
                    v.y = vfila
                    call push(v)
                end if
            end if
    end if
   
   
end sub


public sub seekpath(byval npcindex as integer, optional byval maxsteps as integer = 30)
'***************************************************
'author: unknown
'last modification: -
'this sub seeks a path from the npclist(npcindex).pos
'to the location npclist(npcindex).pfinfo.target.
'the optional parameter maxsteps is the maximum of steps
'allowed for the path.
'***************************************************

    dim cur_npc_pos as tvertice
    dim tar_npc_pos as tvertice
    dim v as tvertice
    dim npcmap as integer
    dim steps as integer
    
    npcmap = npclist(npcindex).pos.map
    
    steps = 0
    
    cur_npc_pos.x = npclist(npcindex).pos.y
    cur_npc_pos.y = npclist(npcindex).pos.x
    
    tar_npc_pos.x = npclist(npcindex).pfinfo.target.x '  userlist(npclist(npcindex).pfinfo.targetuser).pos.x
    tar_npc_pos.y = npclist(npcindex).pfinfo.target.y '  userlist(npclist(npcindex).pfinfo.targetuser).pos.y
    
    call initializetable(tmparray, cur_npc_pos)
    call initqueue
    
    'we add the first vertex to the queue
    call push(cur_npc_pos)
    
    do while (not isempty)
        if steps > maxsteps then exit do
        v = pop
        if v.x = tar_npc_pos.x and v.y = tar_npc_pos.y then exit do
        call processadjacents(npcmap, tmparray, v.y, v.x, npcindex)
    loop
    
    call makepath(npcindex)

end sub

private sub makepath(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'builds the path previously calculated
'***************************************************

    dim pasos as integer
    dim miv as tvertice
    dim i as integer
    
    pasos = tmparray(npclist(npcindex).pfinfo.target.y, npclist(npcindex).pfinfo.target.x).distv
    npclist(npcindex).pfinfo.pathlenght = pasos
    
    
    if pasos = maxint then
        'msgbox "there is no path."
        npclist(npcindex).pfinfo.nopath = true
        npclist(npcindex).pfinfo.pathlenght = 0
        exit sub
    end if
    
    redim npclist(npcindex).pfinfo.path(0 to pasos) as tvertice
    
    miv.x = npclist(npcindex).pfinfo.target.x
    miv.y = npclist(npcindex).pfinfo.target.y
    
    for i = pasos to 1 step -1
        npclist(npcindex).pfinfo.path(i) = miv
        miv = tmparray(miv.y, miv.x).prevv
    next i
    
    npclist(npcindex).pfinfo.curpos = 1
    npclist(npcindex).pfinfo.nopath = false
   
end sub

private sub initializetable(byref t() as tintermidiatework, byref s as tvertice, optional byval maxsteps as integer = 30)
'***************************************************
'author: unknown
'last modification: -
'initialize the array where we calculate the path
'***************************************************


dim j as integer, k as integer
const anymap = 1
for j = s.y - maxsteps to s.y + maxsteps
    for k = s.x - maxsteps to s.x + maxsteps
        if inmapbounds(anymap, j, k) then
            t(j, k).known = false
            t(j, k).distv = maxint
            t(j, k).prevv.x = 0
            t(j, k).prevv.y = 0
        end if
    next
next

t(s.y, s.x).known = false
t(s.y, s.x).distv = 0

end sub

