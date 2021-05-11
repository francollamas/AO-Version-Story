attribute vb_name = "modareas"
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

' modulo de envio por areas compatible con la versi�n 9.10.x ... by dunga

option explicit

'>>>>>>areas>>>>>areas>>>>>>>>areas>>>>>>>areas>>>>>>>>>>
public type areainfo
    areapertenecex as integer
    areapertenecey as integer
    
    arearecivex as integer
    arearecivey as integer
    
    minx as integer '-!!!
    miny as integer '-!!!
    
    areaid as long
end type

public type conngroup
    countentrys as long
    optvalue as long
    userentrys() as long
end type

public const user_nuevo as byte = 255

'cuidado:
' ���las areas est�n hardcodeadas!!!
private curday as byte
private curhour as byte

private areasinfo(1 to 100, 1 to 100) as byte
private postoarea(1 to 100) as byte

private areasrecive(12) as integer
'private areasenvia(12) as integer

public conngroups() as conngroup

public sub initareas()
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim loopx as long
    dim curarea as byte

' setup areas...
    for loopc = 0 to 11
        areasrecive(loopc) = (2 ^ loopc) or iif(loopc <> 0, 2 ^ (loopc - 1), 0) or iif(loopc <> 11, 2 ^ (loopc + 1), 0)
'        areasenvia(loopc) = 2 ^ (loopc + 1)
    next loopc
    
    for loopc = 1 to 100
        postoarea(loopc) = loopc \ 9
    next loopc
    
    for loopc = 1 to 100
        for loopx = 1 to 100
            'usamos 121 ids de area para saber si pasasamos de area "m�s r�pido"
            areasinfo(loopc, loopx) = (loopc \ 9 + 1) * (loopx \ 9 + 1)
        next loopx
    next loopc

'setup autooptimizacion de areas
    curday = iif(weekday(date) > 6, 1, 2) 'a ke tipo de dia pertenece?
    curhour = fix(hour(time) \ 3) 'a ke parte de la hora pertenece
    
    redim conngroups(1 to nummaps) as conngroup
    
    for loopc = 1 to nummaps
        conngroups(loopc).optvalue = val(getvar(datpath & "areasstats.dat", "mapa" & loopc, curday & "-" & curhour))
        
        if conngroups(loopc).optvalue = 0 then conngroups(loopc).optvalue = 1
        redim conngroups(loopc).userentrys(1 to conngroups(loopc).optvalue) as long
    next loopc
end sub

public sub areasoptimizacion()
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'es la funci�n de autooptimizacion.... la idea es no mandar redimensionando arrays grandes todo el tiempo
'**************************************************************
    dim loopc as long
    dim tcurday as byte
    dim tcurhour as byte
    dim entryvalue as long
    
    if (curday <> iif(weekday(date) > 6, 1, 2)) or (curhour <> fix(hour(time) \ 3)) then
        
        tcurday = iif(weekday(date) > 6, 1, 2) 'a ke tipo de dia pertenece?
        tcurhour = fix(hour(time) \ 3) 'a ke parte de la hora pertenece
        
        for loopc = 1 to nummaps
            entryvalue = val(getvar(datpath & "areasstats.dat", "mapa" & loopc, curday & "-" & curhour))
            call writevar(datpath & "areasstats.dat", "mapa" & loopc, curday & "-" & curhour, cint((entryvalue + conngroups(loopc).optvalue) \ 2))
            
            conngroups(loopc).optvalue = val(getvar(datpath & "areasstats.dat", "mapa" & loopc, tcurday & "-" & tcurhour))
            if conngroups(loopc).optvalue = 0 then conngroups(loopc).optvalue = 1
            if conngroups(loopc).optvalue >= mapinfo(loopc).numusers then redim preserve conngroups(loopc).userentrys(1 to conngroups(loopc).optvalue) as long
        next loopc
        
        curday = tcurday
        curhour = tcurhour
    end if
end sub

public sub checkupdateneededuser(byval userindex as integer, byval head as byte)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'es la funci�n clave del sistema de areas... es llamada al mover un user
'**************************************************************
    if userlist(userindex).areasinfo.areaid = areasinfo(userlist(userindex).pos.x, userlist(userindex).pos.y) then exit sub
    
    dim minx as long, maxx as long, miny as long, maxy as long, x as long, y as long
    dim tempint as long, map as long
    
    with userlist(userindex)
        
        minx = .areasinfo.minx
        miny = .areasinfo.miny
        
        if head = eheading.north then
            maxy = miny - 1
            miny = miny - 9
            maxx = minx + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        
        elseif head = eheading.south then
            maxy = miny + 35
            miny = miny + 27
            maxx = minx + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny - 18)
        
        elseif head = eheading.west then
            maxx = minx - 1
            minx = minx - 9
            maxy = miny + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        
        
        elseif head = eheading.east then
            maxx = minx + 35
            minx = minx + 27
            maxy = miny + 26
            .areasinfo.minx = cint(minx - 18)
            .areasinfo.miny = cint(miny)
        
           
        elseif head = user_nuevo then
            'esto pasa por cuando cambiamos de mapa o logeamos...
            miny = ((.pos.y \ 9) - 1) * 9
            maxy = miny + 26
            
            minx = ((.pos.x \ 9) - 1) * 9
            maxx = minx + 26
            
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        end if
        
        if miny < 1 then miny = 1
        if minx < 1 then minx = 1
        if maxy > 100 then maxy = 100
        if maxx > 100 then maxx = 100
        
        map = userlist(userindex).pos.map
        
        'esto es para ke el cliente elimine lo "fuera de area..."
        call senddata(sendtarget.toindex, userindex, 0, "ca" & chr$(.pos.x) & chr$(.pos.y))
        
        'actualizamos!!!
        for x = minx to maxx
            for y = miny to maxy
                
                '<<< user >>>
                if mapdata(map, x, y).userindex then
                    
                    tempint = mapdata(map, x, y).userindex
                    
                    if userindex <> tempint then
                        call makeuserchar(sendtarget.toindex, userindex, 0, cint(tempint), map, x, y)
                        call makeuserchar(sendtarget.toindex, cint(tempint), 0, userindex, .pos.map, .pos.x, .pos.y)
                        
                        'si el user estaba invisible le avisamos al nuevo cliente de eso
#if seguridadalkon then
                        if encriptarprotocoloscriticos then
                            if userlist(tempint).flags.invisible or userlist(tempint).flags.oculto then
                                 call enviardatosaslot(userindex, protocrypt("nover" & userlist(tempint).char.charindex & ",1", userindex) & endc)
                            end if
                            
                            if userlist(userindex).flags.invisible or userlist(userindex).flags.oculto then
                                 call enviardatosaslot(tempint, protocrypt("nover" & userlist(userindex).char.charindex & ",1", tempint) & endc)
                            end if
                        else
#end if
                            if userlist(tempint).flags.invisible or userlist(tempint).flags.oculto then
                                 call enviardatosaslot(userindex, "nover" & userlist(tempint).char.charindex & ",1" & endc)
                            end if
                            
                            if userlist(userindex).flags.invisible or userlist(userindex).flags.oculto then
                                 call enviardatosaslot(tempint, "nover" & userlist(userindex).char.charindex & ",1" & endc)
                            end if
#if seguridadalkon then
                        end if
#end if
                    elseif head = user_nuevo then
                        call makeuserchar(sendtarget.toindex, userindex, 0, userindex, map, x, y)
                    end if
                
                end if
                
                '<<< npc >>>
                if mapdata(map, x, y).npcindex then
                    call makenpcchar(sendtarget.toindex, userindex, 0, mapdata(map, x, y).npcindex, map, x, y)
                 end if
                 
                '<<< item >>>
                if mapdata(map, x, y).objinfo.objindex then
                    tempint = mapdata(map, x, y).objinfo.objindex
                    if not esobjetofijo(objdata(tempint).objtype) then
                        call senddata(sendtarget.toindex, userindex, 0, "ho" & objdata(tempint).grhindex & "," & x & "," & y)
                        
                        if objdata(tempint).objtype = eobjtype.otpuertas then
                            call bloquear(sendtarget.toindex, userindex, 0, cint(map), x, y, mapdata(map, x, y).blocked)
                            call bloquear(sendtarget.toindex, userindex, 0, cint(map), x - 1, y, mapdata(map, x - 1, y).blocked)
                        end if
                    end if
                end if
            
            next y
        next x
            
        'precalculados :p
        tempint = .pos.x \ 9
        .areasinfo.arearecivex = areasrecive(tempint)
        .areasinfo.areapertenecex = 2 ^ tempint
        
        tempint = .pos.y \ 9
        .areasinfo.arearecivey = areasrecive(tempint)
        .areasinfo.areapertenecey = 2 ^ tempint
        
        .areasinfo.areaid = areasinfo(.pos.x, .pos.y)
    end with
end sub

public sub checkupdateneedednpc(byval npcindex as integer, byval head as byte)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
' se llama cuando se mueve un npc
'**************************************************************
    
    if npclist(npcindex).areasinfo.areaid = areasinfo(npclist(npcindex).pos.x, npclist(npcindex).pos.y) then exit sub
    
    dim minx as long, maxx as long, miny as long, maxy as long, x as long, y as long
    dim tempint as long
    
    with npclist(npcindex)
        minx = .areasinfo.minx
        miny = .areasinfo.miny
        
        if head = eheading.north then
            maxy = miny - 1
            miny = miny - 9
            maxx = minx + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        
        elseif head = eheading.south then
            maxy = miny + 35
            miny = miny + 27
            maxx = minx + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny - 18)
        
        elseif head = eheading.west then
            maxx = minx - 1
            minx = minx - 9
            maxy = miny + 26
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        
        
        elseif head = eheading.east then
            maxx = minx + 35
            minx = minx + 27
            maxy = miny + 26
            .areasinfo.minx = cint(minx - 18)
            .areasinfo.miny = cint(miny)
        
           
        elseif head = user_nuevo then
            'esto pasa por cuando cambiamos de mapa o logeamos...
            miny = ((.pos.y \ 9) - 1) * 9
            maxy = miny + 26
            
            minx = ((.pos.x \ 9) - 1) * 9
            maxx = minx + 26
            
            .areasinfo.minx = cint(minx)
            .areasinfo.miny = cint(miny)
        end if
        
        if miny < 1 then miny = 1
        if minx < 1 then minx = 1
        if maxy > 100 then maxy = 100
        if maxx > 100 then maxx = 100

        
        'actualizamos!!!
        if mapinfo(.pos.map).numusers <> 0 then
            for x = minx to maxx
                for y = miny to maxy
                    if mapdata(.pos.map, x, y).userindex then _
                        call makenpcchar(sendtarget.toindex, mapdata(.pos.map, x, y).userindex, 0, npcindex, .pos.map, .pos.x, .pos.y)
                next y
            next x
        end if
            
        'precalculados :p
        tempint = .pos.x \ 9
        .areasinfo.arearecivex = areasrecive(tempint)
        .areasinfo.areapertenecex = 2 ^ tempint
            
        tempint = .pos.y \ 9
        .areasinfo.arearecivey = areasrecive(tempint)
        .areasinfo.areapertenecey = 2 ^ tempint
        
        .areasinfo.areaid = areasinfo(.pos.x, .pos.y)
    end with
end sub

public sub quitaruser(byval userindex as integer, byval map as integer)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim tempval as long
    dim loopc as long
    
    'saco del viejo mapa
    conngroups(map).countentrys = conngroups(map).countentrys - 1
    tempval = conngroups(map).countentrys
    
    for loopc = 1 to tempval + 1
        if conngroups(map).userentrys(loopc) = userindex then exit for
    next loopc
    
    for loopc = loopc to tempval
        conngroups(map).userentrys(loopc) = conngroups(map).userentrys(loopc + 1)
    next loopc
    
    if tempval > conngroups(map).optvalue then 'nescesito redim?
        redim preserve conngroups(map).userentrys(1 to tempval) as long
    end if
end sub

public sub agregaruser(byval userindex as integer, byval map as integer, optional byval esnuevo as boolean = true)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim tempval as long
    
    if esnuevo then
        if not mapavalido(map) then exit sub
        'update map and connection groups data
        conngroups(map).countentrys = conngroups(map).countentrys + 1
        tempval = conngroups(map).countentrys
        
        if tempval > conngroups(map).optvalue then 'nescesito redim
            redim preserve conngroups(map).userentrys(1 to tempval) as long
        end if
        
        conngroups(map).userentrys(tempval) = userindex
    end if

    'update user
    userlist(userindex).areasinfo.areaid = 0
    
    userlist(userindex).areasinfo.areapertenecex = 0
    userlist(userindex).areasinfo.areapertenecey = 0
    userlist(userindex).areasinfo.arearecivex = 0
    userlist(userindex).areasinfo.arearecivey = 0
end sub

public sub argegarnpc(byval npcindex as integer)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    npclist(npcindex).areasinfo.areaid = 0
    
    npclist(npcindex).areasinfo.areapertenecex = 0
    npclist(npcindex).areasinfo.areapertenecey = 0
    npclist(npcindex).areasinfo.arearecivex = 0
    npclist(npcindex).areasinfo.arearecivey = 0
end sub

public sub sendtouserarea(byval userindex as integer, byval sddata as string, optional encriptar as boolean = false)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey

    if not mapavalido(map) then exit sub
    if not encriptar then sddata = sddata & endc
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                if userlist(tempindex).connidvalida then
#if seguridadalkon then
                    if encriptar then
                        call enviardatosaslot(tempindex, protocrypt(sddata, tempindex) & endc)
                    else
#end if
                        call enviardatosaslot(tempindex, sddata)
#if seguridadalkon then
                    end if
#end if
                end if
            end if
        end if
    next loopc
end sub

public sub sendtouserareabutindex(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
' esta solo se usa para enviar mps asi que se puede encriptar desde aca :)
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey

    if not mapavalido(map) then exit sub

    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
            
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if tempindex <> userindex then
                    if userlist(tempindex).connidvalida then
                        call enviardatosaslot(tempindex, sddata)
                    end if
                end if
            end if
        end if
    next loopc
end sub

public sub sendtonpcarea(byval npcindex as long, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = npclist(npcindex).pos.map
    areax = npclist(npcindex).areasinfo.areapertenecex
    areay = npclist(npcindex).areasinfo.areapertenecey
    
    sddata = sddata & endc
    
    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if userlist(tempindex).connidvalida then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

public sub sendtoareabypos(byval map as integer, byval areax as integer, byval areay as integer, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    areax = 2 ^ (areax \ 9)
    areay = 2 ^ (areay \ 9)
    
    sddata = sddata & endc
    
    if not mapavalido(map) then exit sub

    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
            
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if userlist(tempindex).connidvalida then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub
