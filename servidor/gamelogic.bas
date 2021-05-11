attribute vb_name = "extra"
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

option explicit

public function esnewbie(byval userindex as integer) as boolean
esnewbie = userlist(userindex).stats.elv <= limitenewbie
end function



public sub dotileevents(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)

on error goto errhandler

dim npos as worldpos
dim fxflag as boolean
'controla las salidas
if inmapbounds(map, x, y) then
    
    if mapdata(map, x, y).objinfo.objindex > 0 then
        fxflag = objdata(mapdata(map, x, y).objinfo.objindex).objtype = eobjtype.otteleport
    end if
    
    if mapdata(map, x, y).tileexit.map > 0 then
        '�es mapa de newbies?
        if ucase$(mapinfo(mapdata(map, x, y).tileexit.map).restringir) = "si" then
            '�el usuario es un newbie?
            if esnewbie(userindex) then
                if legalpos(mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y, puedeatravesaragua(userindex)) then
                    if fxflag then '�fx?
                        call warpuserchar(userindex, mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y, true)
                    else
                        call warpuserchar(userindex, mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y)
                    end if
                else
                    call closestlegalpos(mapdata(map, x, y).tileexit, npos)
                    if npos.x <> 0 and npos.y <> 0 then
                        if fxflag then
                            call warpuserchar(userindex, npos.map, npos.x, npos.y, true)
                        else
                            call warpuserchar(userindex, npos.map, npos.x, npos.y)
                        end if
                    end if
                end if
            else 'no es newbie
                call senddata(sendtarget.toindex, userindex, 0, "||mapa exclusivo para newbies." & fonttype_info)
                dim veces as byte
                veces = 0
                call closeststablepos(userlist(userindex).pos, npos)

                if npos.x <> 0 and npos.y <> 0 then
                        call warpuserchar(userindex, npos.map, npos.x, npos.y)
                end if
            end if
        else 'no es un mapa de newbies
            if legalpos(mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y, puedeatravesaragua(userindex)) then
                if fxflag then
                    call warpuserchar(userindex, mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y, true)
                else
                    call warpuserchar(userindex, mapdata(map, x, y).tileexit.map, mapdata(map, x, y).tileexit.x, mapdata(map, x, y).tileexit.y)
                end if
            else
                call closestlegalpos(mapdata(map, x, y).tileexit, npos)
                if npos.x <> 0 and npos.y <> 0 then
                    if fxflag then
                        call warpuserchar(userindex, npos.map, npos.x, npos.y, true)
                    else
                        call warpuserchar(userindex, npos.map, npos.x, npos.y)
                    end if
                end if
            end if
        end if
    end if
    
end if

exit sub

errhandler:
    call logerror("error en dotileevents")

end sub

function inrangovision(byval userindex as integer, x as integer, y as integer) as boolean

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

if x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
    inmapbounds = false
else
    inmapbounds = true
end if

end function

sub closestlegalpos(pos as worldpos, byref npos as worldpos)
'*****************************************************************
'encuentra la posicion legal mas cercana y la guarda en npos
'*****************************************************************

dim notfound as boolean
dim loopc as integer
dim tx as integer
dim ty as integer

npos.map = pos.map

do while not legalpos(pos.map, npos.x, npos.y)
    if loopc > 12 then
        notfound = true
        exit do
    end if
    
    for ty = pos.y - loopc to pos.y + loopc
        for tx = pos.x - loopc to pos.x + loopc
            
            if legalpos(npos.map, tx, ty) then
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

sub closeststablepos(pos as worldpos, byref npos as worldpos)
'*****************************************************************
'encuentra la posicion legal mas cercana que no sea un portal y la guarda en npos
'*****************************************************************

dim notfound as boolean
dim loopc as integer
dim tx as integer
dim ty as integer

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

function nameindex(byref name as string) as integer

dim userindex as integer
'�nombre valido?
if name = "" then
    nameindex = 0
    exit function
end if

name = ucase$(replace(name, "+", " "))

userindex = 1
do until ucase$(userlist(userindex).name) = name
    
    userindex = userindex + 1
    
    if userindex > maxusers then
        nameindex = 0
        exit function
    end if
    
loop
 
nameindex = userindex
 
end function



function ip_index(byval inip as string) as integer
 
dim userindex as integer
'�nombre valido?
if inip = "" then
    ip_index = 0
    exit function
end if
  
userindex = 1
do until userlist(userindex).ip = inip
    
    userindex = userindex + 1
    
    if userindex > maxusers then
        ip_index = 0
        exit function
    end if
    
loop
 
ip_index = userindex

exit function

end function


function checkforsameip(byval userindex as integer, byval userip as string) as boolean
dim loopc as integer
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

function checkforsamename(byval userindex as integer, byval name as string) as boolean
'controlo que no existan usuarios con el mismo nombre
dim loopc as long
for loopc = 1 to maxusers
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
dim x as integer
dim y as integer
dim tempvar as single
dim nx as integer
dim ny as integer

x = pos.x
y = pos.y

if head = eheading.north then
    nx = x
    ny = y - 1
end if

if head = eheading.south then
    nx = x
    ny = y + 1
end if

if head = eheading.east then
    nx = x + 1
    ny = y
end if

if head = eheading.west then
    nx = x - 1
    ny = y
end if

'devuelve valores
pos.x = nx
pos.y = ny

end sub

function legalpos(byval map as integer, byval x as integer, byval y as integer, optional byval puedeagua as boolean = false) as boolean

'�es un mapa valido?
if (map <= 0 or map > nummaps) or _
   (x < minxborder or x > maxxborder or y < minyborder or y > maxyborder) then
            legalpos = false
else
  
  if not puedeagua then
        legalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (mapdata(map, x, y).userindex = 0) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (not hayagua(map, x, y))
  else
        legalpos = (mapdata(map, x, y).blocked <> 1) and _
                   (mapdata(map, x, y).userindex = 0) and _
                   (mapdata(map, x, y).npcindex = 0) and _
                   (hayagua(map, x, y))
  end if
   
end if

end function

function legalposnpc(byval map as integer, byval x as integer, byval y as integer, byval aguavalida as byte) as boolean

if (map <= 0 or map > nummaps) or _
   (x < minxborder or x > maxxborder or y < minyborder or y > maxyborder) then
    legalposnpc = false
else

 if aguavalida = 0 then
   legalposnpc = (mapdata(map, x, y).blocked <> 1) and _
     (mapdata(map, x, y).userindex = 0) and _
     (mapdata(map, x, y).npcindex = 0) and _
     (mapdata(map, x, y).trigger <> etrigger.posinvalida) _
     and not hayagua(map, x, y)
 else
   legalposnpc = (mapdata(map, x, y).blocked <> 1) and _
     (mapdata(map, x, y).userindex = 0) and _
     (mapdata(map, x, y).npcindex = 0) and _
     (mapdata(map, x, y).trigger <> etrigger.posinvalida)
 end if
 
end if


end function

sub sendhelp(byval index as integer)
dim numhelplines as integer
dim loopc as integer

numhelplines = val(getvar(datpath & "help.dat", "init", "numlines"))

for loopc = 1 to numhelplines
    call senddata(sendtarget.toindex, index, 0, "||" & getvar(datpath & "help.dat", "help", "line" & loopc) & fonttype_info)
next loopc

end sub

public sub expresar(byval npcindex as integer, byval userindex as integer)
    if npclist(npcindex).nroexpresiones > 0 then
        dim randomi
        randomi = randomnumber(1, npclist(npcindex).nroexpresiones)
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & npclist(npcindex).expresiones(randomi) & "�" & npclist(npcindex).char.charindex & fonttype_info)
    end if
end sub

sub lookattile(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)

'responde al click del usuario sobre el mapa
dim foundchar as byte
dim foundsomething as byte
dim tempcharindex as integer
dim stat as string
dim objtype as integer

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
            call senddata(sendtarget.toindex, userindex, 0, "||" & objdata(userlist(userindex).flags.targetobj).name & " - " & mapdata(userlist(userindex).flags.targetobjmap, userlist(userindex).flags.targetobjx, userlist(userindex).flags.targetobjy).objinfo.amount & "" & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||" & objdata(userlist(userindex).flags.targetobj).name & fonttype_info)
        end if
    
    end if
    '�es un personaje?
    if y + 1 <= ymaxmapsize then
        if mapdata(map, x, y + 1).userindex > 0 then
            tempcharindex = mapdata(map, x, y + 1).userindex
            if userlist(tempcharindex).showname then    ' es gm y pidi� que se oculte su nombre??
                foundchar = 1
            end if
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
            if userlist(tempcharindex).showname then    ' es gm y pidi� que se oculte su nombre??
                foundchar = 1
            end if
        end if
        if mapdata(map, x, y).npcindex > 0 then
            tempcharindex = mapdata(map, x, y).npcindex
            foundchar = 2
        end if
    end if
    
    
    'reaccion al personaje
    if foundchar = 1 then '  �encontro un usuario?
            
       if userlist(tempcharindex).flags.admininvisible = 0 or userlist(userindex).flags.privilegios = playertype.dios then
            
            if userlist(tempcharindex).descrm = "" then
                if esnewbie(tempcharindex) then
                    stat = " <newbie>"
                end if
                
                if userlist(tempcharindex).faccion.armadareal = 1 then
                    stat = stat & " <ejercito real> " & "<" & tituloreal(tempcharindex) & ">"
                elseif userlist(tempcharindex).faccion.fuerzascaos = 1 then
                    stat = stat & " <legi�n oscura> " & "<" & titulocaos(tempcharindex) & ">"
                end if
                
                if userlist(tempcharindex).guildindex > 0 then
                    stat = stat & " <" & guilds(userlist(tempcharindex).guildindex).guildname & ">"
                end if
                
                if len(userlist(tempcharindex).desc) > 1 then
                    stat = "ves a " & userlist(tempcharindex).name & stat & " - " & userlist(tempcharindex).desc
                else
                    stat = "ves a " & userlist(tempcharindex).name & stat
                end if
                
                if userlist(tempcharindex).flags.pertalcons > 0 then
                    stat = stat & " [consejo de banderbill]" & fonttype_consejovesa
                elseif userlist(tempcharindex).flags.pertalconscaos > 0 then
                    stat = stat & " [consejo de las sombras]" & fonttype_consejocaosvesa
                else
                    if userlist(tempcharindex).flags.privilegios > 0 then
                        stat = stat & " <game master> ~0~185~0~1~0"
                    elseif criminal(tempcharindex) then
                        stat = stat & " <criminal> ~255~0~0~1~0"
                    else
                        stat = stat & " <ciudadano> ~0~0~200~1~0"
                    end if
                end if
            else
                stat = userlist(tempcharindex).descrm & " " & fonttype_infobold
            end if
            
            if len(stat) > 0 then _
                call senddata(sendtarget.toindex, userindex, 0, "||" & stat)

            foundsomething = 1
            userlist(userindex).flags.targetuser = tempcharindex
            userlist(userindex).flags.targetnpc = 0
            userlist(userindex).flags.targetnpctipo = enpctype.comun
       end if

    end if
    if foundchar = 2 then '�encontro un npc?
            dim estatus as string
            
            if userlist(userindex).flags.privilegios >= playertype.semidios then
                estatus = "(" & npclist(tempcharindex).stats.minhp & "/" & npclist(tempcharindex).stats.maxhp & ")"
            else
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
            
            if len(npclist(tempcharindex).desc) > 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & npclist(tempcharindex).desc & "�" & npclist(tempcharindex).char.charindex & fonttype_info)
            elseif tempcharindex = centinelanpcindex then
                'enviamos nuevamente el texto del centinela seg�n quien pregunta
                call modcentinela.centinelasendclave(userindex)
            else
                if npclist(tempcharindex).maestrouser > 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "|| " & estatus & npclist(tempcharindex).name & " es mascota de " & userlist(npclist(tempcharindex).maestrouser).name & fonttype_info)
                else
                    call senddata(sendtarget.toindex, userindex, 0, "|| " & estatus & npclist(tempcharindex).name & "." & fonttype_info)
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
        call senddata(sendtarget.toindex, userindex, 0, "||no ves nada interesante." & fonttype_info)
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
        call senddata(sendtarget.toindex, userindex, 0, "||no ves nada interesante." & fonttype_info)
    end if
end if


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
    finddirection = eheading.north
    exit function
end if

'nw
if sgn(x) = 1 and sgn(y) = 1 then
    finddirection = eheading.west
    exit function
end if

'sw
if sgn(x) = 1 and sgn(y) = -1 then
    finddirection = eheading.west
    exit function
end if

'se
if sgn(x) = -1 and sgn(y) = -1 then
    finddirection = eheading.south
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
