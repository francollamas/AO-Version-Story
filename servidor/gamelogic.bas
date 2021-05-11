attribute vb_name = "extra"
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

option explicit

public function esnewbie(byval userindex as integer) as boolean
    esnewbie = userlist(userindex).stats.elv <= limitenewbie
end function

public function esarmada(byval userindex as integer) as boolean
'***************************************************
'autor: pablo (toxicwaste)
'last modification: 23/01/2007
'***************************************************
    esarmada = (userlist(userindex).faccion.armadareal = 1)
end function

public function escaos(byval userindex as integer) as boolean
'***************************************************
'autor: pablo (toxicwaste)
'last modification: 23/01/2007
'***************************************************
    escaos = (userlist(userindex).faccion.fuerzascaos = 1)
end function

public function esgm(byval userindex as integer) as boolean
'***************************************************
'autor: pablo (toxicwaste)
'last modification: 23/01/2007
'***************************************************
    esgm = (userlist(userindex).flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero))
end function

public sub dotileevents(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'handles the map passage of users. allows the existance
'of exclusive maps for newbies, royal army and caos legion members
'and enables gms to enter every map without restriction.
'uses: mapinfo(map).restringir = "newbie" (newbies), "armada", "caos", "faccion" or "no".
'***************************************************
    dim npos as worldpos
    dim fxflag as boolean
    
on error goto errhandler
    'controla las salidas
    if inmapbounds(map, x, y) then
        with mapdata(map, x, y)
            if .objinfo.objindex > 0 then
                fxflag = objdata(.objinfo.objindex).objtype = eobjtype.otteleport
            end if
            
            if .tileexit.map > 0 and .tileexit.map <= nummaps then
                '�es mapa de newbies?
                if ucase$(mapinfo(.tileexit.map).restringir) = "newbie" then
                    '�el usuario es un newbie?
                    if esnewbie(userindex) or esgm(userindex) then
                        if legalpos(.tileexit.map, .tileexit.x, .tileexit.y, puedeatravesaragua(userindex)) then
                            call warpuserchar(userindex, .tileexit.map, .tileexit.x, .tileexit.y, fxflag)
                        else
                            call closestlegalpos(.tileexit, npos)
                            if npos.x <> 0 and npos.y <> 0 then
                                call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                            end if
                        end if
                    else 'no es newbie
                        call writeconsolemsg(userindex, "mapa exclusivo para newbies.", fonttypenames.fonttype_info)
                        call closeststablepos(userlist(userindex).pos, npos)
        
                        if npos.x <> 0 and npos.y <> 0 then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, false)
                        end if
                    end if
                elseif ucase$(mapinfo(.tileexit.map).restringir) = "armada" then '�es mapa de armadas?
                    '�el usuario es armada?
                    if esarmada(userindex) or esgm(userindex) then
                        if legalpos(.tileexit.map, .tileexit.x, .tileexit.y, puedeatravesaragua(userindex)) then
                            call warpuserchar(userindex, .tileexit.map, .tileexit.x, .tileexit.y, fxflag)
                        else
                            call closestlegalpos(.tileexit, npos)
                            if npos.x <> 0 and npos.y <> 0 then
                                call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                            end if
                        end if
                    else 'no es armada
                        call writeconsolemsg(userindex, "mapa exclusivo para miembros del ej�rcito real", fonttypenames.fonttype_info)
                        call closeststablepos(userlist(userindex).pos, npos)
                        
                        if npos.x <> 0 and npos.y <> 0 then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                        end if
                    end if
                elseif ucase$(mapinfo(.tileexit.map).restringir) = "caos" then '�es mapa de caos?
                    '�el usuario es caos?
                    if escaos(userindex) or esgm(userindex) then
                        if legalpos(.tileexit.map, .tileexit.x, .tileexit.y, puedeatravesaragua(userindex)) then
                            call warpuserchar(userindex, .tileexit.map, .tileexit.x, .tileexit.y, fxflag)
                        else
                            call closestlegalpos(.tileexit, npos)
                            if npos.x <> 0 and npos.y <> 0 then
                                call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                            end if
                        end if
                    else 'no es caos
                        call writeconsolemsg(userindex, "mapa exclusivo para miembros del ej�rcito oscuro.", fonttypenames.fonttype_info)
                        call closeststablepos(userlist(userindex).pos, npos)
                        
                        if npos.x <> 0 and npos.y <> 0 then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                        end if
                    end if
                elseif ucase$(mapinfo(.tileexit.map).restringir) = "faccion" then '�es mapa de faccionarios?
                    '�el usuario es armada o caos?
                    if esarmada(userindex) or escaos(userindex) or esgm(userindex) then
                        if legalpos(.tileexit.map, .tileexit.x, .tileexit.y, puedeatravesaragua(userindex)) then
                            call warpuserchar(userindex, .tileexit.map, .tileexit.x, .tileexit.y, fxflag)
                        else
                            call closestlegalpos(.tileexit, npos)
                            if npos.x <> 0 and npos.y <> 0 then
                                call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                            end if
                        end if
                    else 'no es faccionario
                        call writeconsolemsg(userindex, "solo se permite entrar al mapa si eres miembro de alguna facci�n", fonttypenames.fonttype_info)
                        call closeststablepos(userlist(userindex).pos, npos)
                        
                        if npos.x <> 0 and npos.y <> 0 then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                        end if
                    end if
                else 'no es un mapa de newbies, ni armadas, ni caos, ni faccionario.
                    if legalpos(.tileexit.map, .tileexit.x, .tileexit.y, puedeatravesaragua(userindex)) then
                        call warpuserchar(userindex, .tileexit.map, .tileexit.x, .tileexit.y, fxflag)
                    else
                        call closestlegalpos(.tileexit, npos)
                        if npos.x <> 0 and npos.y <> 0 then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, fxflag)
                        end if
                    end if
                end if
                
                'te fusite del mapa. la criatura ya no es m�s tuya ni te reconoce como que vos la atacaste.
                dim an as integer
                
                an = userlist(userindex).flags.atacadopornpc
                if an > 0 then
                   npclist(an).movement = npclist(an).flags.oldmovement
                   npclist(an).hostile = npclist(an).flags.oldhostil
                   npclist(an).flags.attackedby = vbnullstring
                end if
            
                an = userlist(userindex).flags.npcatacado
                if an > 0 then
                    if npclist(an).flags.attackedfirstby = userlist(userindex).name then
                        npclist(an).flags.attackedfirstby = vbnullstring
                    end if
                end if
                userlist(userindex).flags.atacadopornpc = 0
                userlist(userindex).flags.npcatacado = 0
            end if
        end with
    end if
exit sub

errhandler:
    call logerror("error en dotileevents. error: " & err.number & " - desc: " & err.description)
end sub

function inrangovision(byval userindex as integer, byval x as integer, byval y as integer) as boolean

if x > userlist(userindex).pos.x - minxborder and x < userlist(userindex).pos.x + minxborder then
    if y > userlist(userindex).pos.y - minyborder and y < userlist(userindex).pos.y + minyborder then
        inrangovision = true
        exit function
    end if
end if
inrangovision = false

end function

function inrangovisionnpc(byval npcindex as integer, x as integer, y as integer) as boolean

if x > npclist(npcindex).pos.x - minxborder and x < npclist(npcindex).pos.x + minxborder then
    if y > npclist(npcindex).pos.y - minyborder and y < npclist(npcindex).pos.y + minyborder then
        inrangovisionnpc = true
        exit function
    end if
end if
inrangovisionnpc = false

end function


function inmapbounds(byval map as integer, byval x as integer, byval y as integer) as boolean
            
if (map <= 0 or map > nummaps) or x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
    inmapbounds = false
else
    inmapbounds = true
end if

end function

sub closestlegalpos(pos as worldpos, byref npos as worldpos, optional puedeagua as boolean = false, optional puedetierra as boolean = true)
'*****************************************************************
'author: unknown (original version)
'last modification: 24/01/2007 (toxicwaste)
'encuentra la posicion legal mas cercana y la guarda en npos
'*****************************************************************

dim notfound as boolean
dim loopc as integer
dim tx as long
dim ty as long

npos.map = pos.map

do while not legalpos(pos.map, npos.x, npos.y, puedeagua, puedetierra)
    if loopc > 12 then
        notfound = true
        exit do
    end if
    
    for ty = pos.y - loopc to pos.y + loopc
        for tx = pos.x - loopc to pos.x + loopc
            
            if legalpos(npos.map, tx, ty, puedeagua, puedetierra) then
                npos.x = tx
                npos.y = ty
                '�hay objeto?
                
                tx = pos.x + loopc
                ty = pos.y + loopc
  
            end if
        
        next tx
    next ty
    
    loopc = loopc + 1
    
loop

if notfound = true then
    npos.x = 0
    npos.y = 0
end if

end sub

private sub closeststablepos(pos as worldpos, byref npos as worldpos)
'*****************************************************************
'encuentra la posicion legal mas cercana que no sea un portal y la guarda en npos
'*****************************************************************

dim notfound as boolean
dim loopc as integer
dim tx as long
dim ty as long

npos.map = pos.map

do while not legalpos(pos.map, npos.x, npos.y)
    if loopc > 12 then
        notfound = true
        exit do
    end if
    
    for ty = pos.y - loopc to pos.y + loopc
        for tx = pos.x - loopc to pos.x + loopc
            
            if legalpos(npos.map, tx, ty) and mapdata(npos.map, tx, ty).tileexit.map = 0 then
                npos.x = tx
                npos.y = ty
                '�hay objeto?
                
                tx = pos.x + loopc
                ty = pos.y + loopc
  
            end if
        
        next tx
    next ty
    
    loopc = loopc + 1
    
loop

if notfound = true then
    npos.x = 0
    npos.y = 0
end if

end sub

function nameindex(byval name as string) as integer
    dim userindex as long
    
    '�nombre valido?
    if lenb(name) = 0 then
        nameindex = 0
        exit function
    end if
    
    if instrb(name, "+") <> 0 then
        name = ucase$(replace(name, "+", " "))
    end if
    
    userindex = 1
    do until ucase$(userlist(userindex).name) = ucase$(name)
        
        userindex = userindex + 1
        
        if userindex > maxusers then
            nameindex = 0
            exit function
        end if
    loop
     
    nameindex = userindex
end function

function checkforsameip(byval userindex as integer, byval userip as string) as boolean
    dim loopc as long
    
    for loopc = 1 to maxusers
        if userlist(loopc).flags.userlogged = true then
            if userlist(loopc).ip = userip and userindex <> loopc then
                checkforsameip = true
                exit function
            end if
        end if
    next loopc
    
    checkforsameip = false
end function

function checkforsamename(byval name as string) as boolean
'controlo que no existan usuarios con el mismo nombre
    dim loopc as long
    
    for loopc = 1 to lastuser
        if userlist(loopc).flags.userlogged then
            
            'if ucase$(userlist(loopc).name) = ucase$(name) and userlist(loopc).connid <> -1 then
            'ojo preguntar por el connid <> -1 produce que un pj en determinado
            'momento pueda estar logueado 2 veces (ie: cierra el socket desde alla)
            'ese evento no dispara un save user, lo que puede ser utilizado para duplicar items
            'este bug en alkon produjo que el servidor este caido durante 3 dias. atentos.
            
            if ucase$(userlist(loopc).name) = ucase$(name) then
                checkforsamename = true
                exit function
            end if
        end if
    next loopc
    
    checkforsamename = false
end function

sub headtopos(byval head as eheading, byref pos as worldpos)
'*****************************************************************
'toma una posicion y se mueve hacia donde esta perfilado
'*****************************************************************
    select case head
        case eheading.north
            pos.y = pos.y - 1
        
        case eheading.south
            pos.y = pos.y + 1
        
        case eheading.east
            pos.x = pos.x + 1
        
        case eheading.west
            pos.x = pos.x - 1
    end select
end sub

function legalpos(byval map as integer, byval x as integer, byval y as integer, optional byval puedeagua as boolean = false, optional byval puedetierra as boolean = true) as boolean
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'checks if the position is legal.
'***************************************************
'�es un mapa valido?
if (map <= 0 or map > nummaps) or _
   (x < minxborder or x > maxxborder or y < minyborder or y > maxyborder) then
            legalpos = false
else
    if puedeagua and puedetierra then
        legalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (mapdata(map, x, y).userindex = 0) and _
                   (mapdata(map, x, y).npcindex = 0)
    elseif puedetierra and not puedeagua then
        legalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (mapdata(map, x, y).userindex = 0) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (not hayagua(map, x, y))
    elseif puedeagua and not puedetierra then
        legalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (mapdata(map, x, y).userindex = 0) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (hayagua(map, x, y))
    else
        legalpos = false
    end if
   
end if

end function

function movetolegalpos(byval map as integer, byval x as integer, byval y as integer, optional byval puedeagua as boolean = false, optional byval puedetierra as boolean = true) as boolean
'***************************************************
'autor: zama
'last modification: 13/07/2009
'checks if the position is legal, but considers that if there's a casper, it's a legal movement.
'13/07/2009: zama - now it's also legal move where an invisible admin is.
'***************************************************

dim userindex as integer
dim isdeadchar as boolean
dim isadmininvisible as boolean


'�es un mapa valido?
if (map <= 0 or map > nummaps) or _
   (x < minxborder or x > maxxborder or y < minyborder or y > maxyborder) then
            movetolegalpos = false
    else
        userindex = mapdata(map, x, y).userindex
        if userindex > 0 then
            isdeadchar = userlist(userindex).flags.muerto = 1
            isadmininvisible = userlist(userindex).flags.admininvisible = 1
        else
            isdeadchar = false
            isadmininvisible = false
        end if
    
    if puedeagua and puedetierra then
        movetolegalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (userindex = 0 or isdeadchar or isadmininvisible) and _
                   (mapdata(map, x, y).npcindex = 0)
    elseif puedetierra and not puedeagua then
        movetolegalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (userindex = 0 or isdeadchar or isadmininvisible) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (not hayagua(map, x, y))
    elseif puedeagua and not puedetierra then
        movetolegalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (userindex = 0 or isdeadchar or isadmininvisible) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (hayagua(map, x, y))
    else
        movetolegalpos = false
    end if
  
end if

end function

public sub findlegalpos(byval userindex as integer, byval map as integer, byref x as integer, byref y as integer)
'***************************************************
'autor: zama
'last modification: 26/03/2009
'search for a legal pos for the user who is being teleported.
'***************************************************

    if mapdata(map, x, y).userindex <> 0 or _
        mapdata(map, x, y).npcindex <> 0 then
                    
        ' se teletransporta a la misma pos a la que estaba
        if mapdata(map, x, y).userindex = userindex then exit sub
                            
        dim foundplace as boolean
        dim tx as long
        dim ty as long
        dim rango as long
        dim otheruserindex as integer
    
        for rango = 1 to 5
            for ty = y - rango to y + rango
                for tx = x - rango to x + rango
                    'reviso que no haya user ni npc
                    if mapdata(map, tx, ty).userindex = 0 and _
                        mapdata(map, tx, ty).npcindex = 0 then
                        
                        if inmapbounds(map, tx, ty) then foundplace = true
                        
                        exit for
                    end if

                next tx
        
                if foundplace then _
                    exit for
            next ty
            
            if foundplace then _
                    exit for
        next rango

    
        if foundplace then 'si encontramos un lugar, listo, nos quedamos ahi
            x = tx
            y = ty
        else
            'muy poco probable, pero..
            'si no encontramos un lugar, sacamos al usuario que tenemos abajo, y si es un npc, lo pisamos.
            otheruserindex = mapdata(map, x, y).userindex
            if otheruserindex <> 0 then
                'si no encontramos lugar, y abajo teniamos a un usuario, lo pisamos y cerramos su comercio seguro
                if userlist(otheruserindex).comusu.destusu > 0 then
                    'le avisamos al que estaba comerciando que se tuvo que ir.
                    if userlist(userlist(otheruserindex).comusu.destusu).flags.userlogged then
                        call fincomerciarusu(userlist(otheruserindex).comusu.destusu)
                        call writeconsolemsg(userlist(otheruserindex).comusu.destusu, "comercio cancelado. el otro usuario se ha desconectado.", fonttypenames.fonttype_talk)
                        call flushbuffer(userlist(otheruserindex).comusu.destusu)
                    end if
                    'lo sacamos.
                    if userlist(otheruserindex).flags.userlogged then
                        call fincomerciarusu(otheruserindex)
                        call writeerrormsg(otheruserindex, "alguien se ha conectado donde te encontrabas, por favor recon�ctate...")
                        call flushbuffer(otheruserindex)
                    end if
                end if
            
                call closesocket(otheruserindex)
            end if
        end if
    end if

end sub

function legalposnpc(byval map as integer, byval x as integer, byval y as integer, byval aguavalida as byte, optional byval ispet as boolean = false) as boolean
'***************************************************
'autor: unkwnown
'last modification: 09/23/2009
'checks if it's a legal pos for the npc to move to.
'09/23/2009: pato - if userindex is a admininvisible, then is a legal pos.
'***************************************************
dim isdeadchar as boolean
dim userindex as integer
dim isadmininvisible as boolean
    
    
    if (map <= 0 or map > nummaps) or _
        (x < minxborder or x > maxxborder or y < minyborder or y > maxyborder) then
        legalposnpc = false
        exit function
    end if

    with mapdata(map, x, y)
        userindex = .userindex
        if userindex > 0 then
            isdeadchar = userlist(userindex).flags.muerto = 1
            isadmininvisible = (userlist(userindex).flags.admininvisible = 1)
        else
            isdeadchar = false
            isadmininvisible = false
        end if
    
        if aguavalida = 0 then
            legalposnpc = (.blocked <> 1) and _
            (.userindex = 0 or isdeadchar or isadmininvisible) and _
            (.npcindex = 0) and _
            (.trigger <> etrigger.posinvalida or ispet) _
            and not hayagua(map, x, y)
        else
            legalposnpc = (.blocked <> 1) and _
            (.userindex = 0 or isdeadchar or isadmininvisible) and _
            (.npcindex = 0) and _
            (.trigger <> etrigger.posinvalida or ispet)
        end if
    end with
end function

sub sendhelp(byval index as integer)
dim numhelplines as integer
dim loopc as integer

numhelplines = val(getvar(datpath & "help.dat", "init", "numlines"))

for loopc = 1 to numhelplines
    call writeconsolemsg(index, getvar(datpath & "help.dat", "help", "line" & loopc), fonttypenames.fonttype_info)
next loopc

end sub

public sub expresar(byval npcindex as integer, byval userindex as integer)
    if npclist(npcindex).nroexpresiones > 0 then
        dim randomi
        randomi = randomnumber(1, npclist(npcindex).nroexpresiones)
        call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(npclist(npcindex).expresiones(randomi), npclist(npcindex).char.charindex, vbwhite))
    end if
end sub

sub lookattile(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 26/03/2009
'13/02/2009: zama - el nombre del gm que aparece por consola al clickearlo, tiene el color correspondiente a su rango
'***************************************************

on error goto errhandler

'responde al click del usuario sobre el mapa
dim foundchar as byte
dim foundsomething as byte
dim tempcharindex as integer
dim stat as string
dim ft as fonttypenames

'�rango visi�n? (toxicwaste)
if (abs(userlist(userindex).pos.y - y) > rango_vision_y) or (abs(userlist(userindex).pos.x - x) > rango_vision_x) then
    exit sub
end if

'�posicion valida?
if inmapbounds(map, x, y) then
    userlist(userindex).flags.targetmap = map
    userlist(userindex).flags.targetx = x
    userlist(userindex).flags.targety = y
    '�es un obj?
    if mapdata(map, x, y).objinfo.objindex > 0 then
        'informa el nombre
        userlist(userindex).flags.targetobjmap = map
        userlist(userindex).flags.targetobjx = x
        userlist(userindex).flags.targetobjy = y
        foundsomething = 1
    elseif mapdata(map, x + 1, y).objinfo.objindex > 0 then
        'informa el nombre
        if objdata(mapdata(map, x + 1, y).objinfo.objindex).objtype = eobjtype.otpuertas then
            userlist(userindex).flags.targetobjmap = map
            userlist(userindex).flags.targetobjx = x + 1
            userlist(userindex).flags.targetobjy = y
            foundsomething = 1
        end if
    elseif mapdata(map, x + 1, y + 1).objinfo.objindex > 0 then
        if objdata(mapdata(map, x + 1, y + 1).objinfo.objindex).objtype = eobjtype.otpuertas then
            'informa el nombre
            userlist(userindex).flags.targetobjmap = map
            userlist(userindex).flags.targetobjx = x + 1
            userlist(userindex).flags.targetobjy = y + 1
            foundsomething = 1
        end if
    elseif mapdata(map, x, y + 1).objinfo.objindex > 0 then
        if objdata(mapdata(map, x, y + 1).objinfo.objindex).objtype = eobjtype.otpuertas then
            'informa el nombre
            userlist(userindex).flags.targetobjmap = map
            userlist(userindex).flags.targetobjx = x
            userlist(userindex).flags.targetobjy = y + 1
            foundsomething = 1
        end if
    end if
    
    if foundsomething = 1 then
        userlist(userindex).flags.targetobj = mapdata(map, userlist(userindex).flags.targetobjx, userlist(userindex).flags.targetobjy).objinfo.objindex
        if mostrarcantidad(userlist(userindex).flags.targetobj) then
            call writeconsolemsg(userindex, objdata(userlist(userindex).flags.targetobj).name & " - " & mapdata(userlist(userindex).flags.targetobjmap, userlist(userindex).flags.targetobjx, userlist(userindex).flags.targetobjy).objinfo.amount & "", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, objdata(userlist(userindex).flags.targetobj).name, fonttypenames.fonttype_info)
        end if
    
    end if
    '�es un personaje?
    if y + 1 <= ymaxmapsize then
        if mapdata(map, x, y + 1).userindex > 0 then
            tempcharindex = mapdata(map, x, y + 1).userindex
            foundchar = 1
        end if
        if mapdata(map, x, y + 1).npcindex > 0 then
            tempcharindex = mapdata(map, x, y + 1).npcindex
            foundchar = 2
        end if
    end if
    '�es un personaje?
    if foundchar = 0 then
        if mapdata(map, x, y).userindex > 0 then
            tempcharindex = mapdata(map, x, y).userindex
            foundchar = 1
        end if
        if mapdata(map, x, y).npcindex > 0 then
            tempcharindex = mapdata(map, x, y).npcindex
            foundchar = 2
        end if
    end if
    
    
    'reaccion al personaje
    if foundchar = 1 then '  �encontro un usuario?
            
       if userlist(tempcharindex).flags.admininvisible = 0 or userlist(userindex).flags.privilegios and playertype.dios then
            
            if lenb(userlist(tempcharindex).descrm) = 0 and userlist(tempcharindex).showname then 'no tiene descrm y quiere que se vea su nombre.
                if esnewbie(tempcharindex) then
                    stat = " <newbie>"
                end if
                
                if userlist(tempcharindex).faccion.armadareal = 1 then
                    stat = stat & " <ej�rcito real> " & "<" & tituloreal(tempcharindex) & ">"
                elseif userlist(tempcharindex).faccion.fuerzascaos = 1 then
                    stat = stat & " <legi�n oscura> " & "<" & titulocaos(tempcharindex) & ">"
                end if
                
                if userlist(tempcharindex).guildindex > 0 then
                    stat = stat & " <" & modguilds.guildname(userlist(tempcharindex).guildindex) & ">"
                end if
                
                if len(userlist(tempcharindex).desc) > 0 then
                    stat = "ves a " & userlist(tempcharindex).name & stat & " - " & userlist(tempcharindex).desc
                else
                    stat = "ves a " & userlist(tempcharindex).name & stat
                end if
                
                                
                if userlist(tempcharindex).flags.privilegios and playertype.royalcouncil then
                    stat = stat & " [consejo de banderbill]"
                    ft = fonttypenames.fonttype_consejovesa
                elseif userlist(tempcharindex).flags.privilegios and playertype.chaoscouncil then
                    stat = stat & " [concilio de las sombras]"
                    ft = fonttypenames.fonttype_consejocaosvesa
                else
                    if not userlist(tempcharindex).flags.privilegios and playertype.user then
                        stat = stat & " <game master>"
                        
                        ' elijo el color segun el rango del gm:
                        ' dios
                        if userlist(tempcharindex).flags.privilegios = playertype.dios then
                            ft = fonttypenames.fonttype_dios
                        ' gm
                        elseif userlist(tempcharindex).flags.privilegios = playertype.semidios then
                            ft = fonttypenames.fonttype_gm
                        ' conse
                        elseif userlist(tempcharindex).flags.privilegios = playertype.consejero then
                            ft = fonttypenames.fonttype_conse
                        ' rm o dsrm
                        elseif userlist(tempcharindex).flags.privilegios = (playertype.rolemaster or playertype.consejero) or userlist(tempcharindex).flags.privilegios = (playertype.rolemaster or playertype.dios) then
                            ft = fonttypenames.fonttype_ejecucion
                        end if
                        
                    elseif criminal(tempcharindex) then
                        stat = stat & " <criminal>"
                        ft = fonttypenames.fonttype_fight
                    else
                        stat = stat & " <ciudadano>"
                        ft = fonttypenames.fonttype_citizen
                    end if
                end if
            else  'si tiene descrm la muestro siempre.
                stat = userlist(tempcharindex).descrm
                ft = fonttypenames.fonttype_infobold
            end if
            
            if lenb(stat) > 0 then
                call writeconsolemsg(userindex, stat, ft)
            end if
            
            foundsomething = 1
            userlist(userindex).flags.targetuser = tempcharindex
            userlist(userindex).flags.targetnpc = 0
            userlist(userindex).flags.targetnpctipo = enpctype.comun
       end if

    end if
    if foundchar = 2 then '�encontro un npc?
            dim estatus as string
            
            if userlist(userindex).flags.privilegios and (playertype.semidios or playertype.dios or playertype.admin) then
                estatus = "(" & npclist(tempcharindex).stats.minhp & "/" & npclist(tempcharindex).stats.maxhp & ") "
            else
                if userlist(userindex).flags.muerto = 0 then
                    if userlist(userindex).stats.userskills(eskill.supervivencia) >= 0 and userlist(userindex).stats.userskills(eskill.supervivencia) <= 10 then
                        estatus = "(dudoso) "
                    elseif userlist(userindex).stats.userskills(eskill.supervivencia) > 10 and userlist(userindex).stats.userskills(eskill.supervivencia) <= 20 then
                        if npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp / 2) then
                            estatus = "(herido) "
                        else
                            estatus = "(sano) "
                        end if
                    elseif userlist(userindex).stats.userskills(eskill.supervivencia) > 20 and userlist(userindex).stats.userskills(eskill.supervivencia) <= 30 then
                        if npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.5) then
                            estatus = "(malherido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.75) then
                            estatus = "(herido) "
                        else
                            estatus = "(sano) "
                        end if
                    elseif userlist(userindex).stats.userskills(eskill.supervivencia) > 30 and userlist(userindex).stats.userskills(eskill.supervivencia) <= 40 then
                        if npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.25) then
                            estatus = "(muy malherido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.5) then
                            estatus = "(herido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.75) then
                            estatus = "(levemente herido) "
                        else
                            estatus = "(sano) "
                        end if
                    elseif userlist(userindex).stats.userskills(eskill.supervivencia) > 40 and userlist(userindex).stats.userskills(eskill.supervivencia) < 60 then
                        if npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.05) then
                            estatus = "(agonizando) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.1) then
                            estatus = "(casi muerto) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.25) then
                            estatus = "(muy malherido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.5) then
                            estatus = "(herido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp * 0.75) then
                            estatus = "(levemente herido) "
                        elseif npclist(tempcharindex).stats.minhp < (npclist(tempcharindex).stats.maxhp) then
                            estatus = "(sano) "
                        else
                            estatus = "(intacto) "
                        end if
                    elseif userlist(userindex).stats.userskills(eskill.supervivencia) >= 60 then
                        estatus = "(" & npclist(tempcharindex).stats.minhp & "/" & npclist(tempcharindex).stats.maxhp & ") "
                    else
                        estatus = "!error!"
                    end if
                end if
            end if
            
            if len(npclist(tempcharindex).desc) > 1 then
                call writechatoverhead(userindex, npclist(tempcharindex).desc, npclist(tempcharindex).char.charindex, vbwhite)
            elseif tempcharindex = centinelanpcindex then
                'enviamos nuevamente el texto del centinela seg�n quien pregunta
                call modcentinela.centinelasendclave(userindex)
            else
                if npclist(tempcharindex).maestrouser > 0 then
                    call writeconsolemsg(userindex, estatus & npclist(tempcharindex).name & " es mascota de " & userlist(npclist(tempcharindex).maestrouser).name, fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, estatus & npclist(tempcharindex).name & ".", fonttypenames.fonttype_info)
                    if userlist(userindex).flags.privilegios and (playertype.dios or playertype.admin) then
                        call writeconsolemsg(userindex, "le peg� primero: " & npclist(tempcharindex).flags.attackedfirstby & ".", fonttypenames.fonttype_info)
                    end if
                end if
                
            end if
            foundsomething = 1
            userlist(userindex).flags.targetnpctipo = npclist(tempcharindex).npctype
            userlist(userindex).flags.targetnpc = tempcharindex
            userlist(userindex).flags.targetuser = 0
            userlist(userindex).flags.targetobj = 0
        
    end if
    
    if foundchar = 0 then
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = enpctype.comun
        userlist(userindex).flags.targetuser = 0
    end if
    
    '*** no encotro nada ***
    if foundsomething = 0 then
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = enpctype.comun
        userlist(userindex).flags.targetuser = 0
        userlist(userindex).flags.targetobj = 0
        userlist(userindex).flags.targetobjmap = 0
        userlist(userindex).flags.targetobjx = 0
        userlist(userindex).flags.targetobjy = 0
        call writeconsolemsg(userindex, "no ves nada interesante.", fonttypenames.fonttype_info)
    end if

else
    if foundsomething = 0 then
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = enpctype.comun
        userlist(userindex).flags.targetuser = 0
        userlist(userindex).flags.targetobj = 0
        userlist(userindex).flags.targetobjmap = 0
        userlist(userindex).flags.targetobjx = 0
        userlist(userindex).flags.targetobjy = 0
        call writeconsolemsg(userindex, "no ves nada interesante.", fonttypenames.fonttype_info)
    end if
end if

exit sub

errhandler:
    call logerror("error en lookattile. error " & err.number & " : " & err.description)

end sub

function finddirection(pos as worldpos, target as worldpos) as eheading
'*****************************************************************
'devuelve la direccion en la cual el target se encuentra
'desde pos, 0 si la direc es igual
'*****************************************************************
dim x as integer
dim y as integer

x = pos.x - target.x
y = pos.y - target.y

'ne
if sgn(x) = -1 and sgn(y) = 1 then
    finddirection = iif(randomnumber(0, 1), eheading.north, eheading.east)
    exit function
end if

'nw
if sgn(x) = 1 and sgn(y) = 1 then
    finddirection = iif(randomnumber(0, 1), eheading.west, eheading.north)
    exit function
end if

'sw
if sgn(x) = 1 and sgn(y) = -1 then
    finddirection = iif(randomnumber(0, 1), eheading.west, eheading.south)
    exit function
end if

'se
if sgn(x) = -1 and sgn(y) = -1 then
    finddirection = iif(randomnumber(0, 1), eheading.south, eheading.east)
    exit function
end if

'sur
if sgn(x) = 0 and sgn(y) = -1 then
    finddirection = eheading.south
    exit function
end if

'norte
if sgn(x) = 0 and sgn(y) = 1 then
    finddirection = eheading.north
    exit function
end if

'oeste
if sgn(x) = 1 and sgn(y) = 0 then
    finddirection = eheading.west
    exit function
end if

'este
if sgn(x) = -1 and sgn(y) = 0 then
    finddirection = eheading.east
    exit function
end if

'misma
if sgn(x) = 0 and sgn(y) = 0 then
    finddirection = 0
    exit function
end if

end function

'[barrin 30-11-03]
public function itemnoesdemapa(byval index as integer) as boolean

itemnoesdemapa = objdata(index).objtype <> eobjtype.otpuertas and _
            objdata(index).objtype <> eobjtype.otforos and _
            objdata(index).objtype <> eobjtype.otcarteles and _
            objdata(index).objtype <> eobjtype.otarboles and _
            objdata(index).objtype <> eobjtype.otyacimiento and _
            objdata(index).objtype <> eobjtype.otteleport
end function
'[/barrin 30-11-03]

public function mostrarcantidad(byval index as integer) as boolean
mostrarcantidad = objdata(index).objtype <> eobjtype.otpuertas and _
            objdata(index).objtype <> eobjtype.otforos and _
            objdata(index).objtype <> eobjtype.otcarteles and _
            objdata(index).objtype <> eobjtype.otarboles and _
            objdata(index).objtype <> eobjtype.otyacimiento and _
            objdata(index).objtype <> eobjtype.otteleport
end function

public function esobjetofijo(byval objtype as eobjtype) as boolean

esobjetofijo = objtype = eobjtype.otforos or _
               objtype = eobjtype.otcarteles or _
               objtype = eobjtype.otarboles or _
               objtype = eobjtype.otyacimiento

end function
