attribute vb_name = "acciones"
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

option explicit

''
' modulo para manejar las acciones (doble click) de los carteles, foro, puerta, ramitas
'

''
' ejecuta la accion del doble click
'
' @param userindex userindex
' @param map numero de mapa
' @param x x
' @param y y

sub accion(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
on error resume next

'�rango visi�n? (toxicwaste)
if (abs(userlist(userindex).pos.y - y) > rango_vision_y) or (abs(userlist(userindex).pos.x - x) > rango_vision_x) then
    exit sub
end if

'�posicion valida?
if inmapbounds(map, x, y) then
   
    dim foundchar as byte
    dim foundsomething as byte
    dim tempcharindex as integer
       
    if mapdata(map, x, y).npcindex > 0 then     'acciones npcs
        'set the target npc
        userlist(userindex).flags.targetnpc = mapdata(map, x, y).npcindex
        
        if npclist(mapdata(map, x, y).npcindex).comercia = 1 then
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call writeconsolemsg(userindex, "��estas muerto!!", fonttypenames.fonttype_info)
                exit sub
            end if
            
            if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                call writeconsolemsg(userindex, "estas demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'iniciamos la rutina pa' comerciar.
            call iniciarcomercionpc(userindex)
        
        elseif npclist(mapdata(map, x, y).npcindex).npctype = enpctype.banquero then
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call writeconsolemsg(userindex, "��estas muerto!!", fonttypenames.fonttype_info)
                exit sub
            end if
            
            if distancia(npclist(mapdata(map, x, y).npcindex).pos, userlist(userindex).pos) > 3 then
                call writeconsolemsg(userindex, "estas demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'a depositar de una
            call iniciardeposito(userindex)
        
        elseif npclist(mapdata(map, x, y).npcindex).npctype = enpctype.revividor or npclist(mapdata(map, x, y).npcindex).npctype = enpctype.resucitadornewbie then
            if distancia(userlist(userindex).pos, npclist(mapdata(map, x, y).npcindex).pos) > 10 then
                call writeconsolemsg(userindex, "el sacerdote no puede curarte debido a que estas demasiado lejos.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'revivimos si es necesario
            if userlist(userindex).flags.muerto = 1 and (npclist(mapdata(map, x, y).npcindex).npctype = enpctype.revividor or esnewbie(userindex)) then
                call revivirusuario(userindex)
            end if
            
            if npclist(mapdata(map, x, y).npcindex).npctype = enpctype.revividor or esnewbie(userindex) then
                'curamos totalmente
                userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
                call writeupdateuserstats(userindex)
            end if
        end if
        
    '�es un obj?
    elseif mapdata(map, x, y).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x, y).objinfo.objindex
        
        select case objdata(mapdata(map, x, y).objinfo.objindex).objtype
            
            case eobjtype.otpuertas 'es una puerta
                call accionparapuerta(map, x, y, userindex)
            case eobjtype.otcarteles 'es un cartel
                call accionparacartel(map, x, y, userindex)
            case eobjtype.otforos 'foro
                call accionparaforo(map, x, y, userindex)
            case eobjtype.otle�a    'le�a
                if mapdata(map, x, y).objinfo.objindex = fogata_apag and userlist(userindex).flags.muerto = 0 then
                    call accionpararamita(map, x, y, userindex)
                end if
        end select
    '>>>>>>>>>>>objetos que ocupam mas de un tile<<<<<<<<<<<<<
    elseif mapdata(map, x + 1, y).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x + 1, y).objinfo.objindex
        
        select case objdata(mapdata(map, x + 1, y).objinfo.objindex).objtype
            
            case eobjtype.otpuertas 'es una puerta
                call accionparapuerta(map, x + 1, y, userindex)
            
        end select
    elseif mapdata(map, x + 1, y + 1).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x + 1, y + 1).objinfo.objindex

        select case objdata(mapdata(map, x + 1, y + 1).objinfo.objindex).objtype
            
            case eobjtype.otpuertas 'es una puerta
                call accionparapuerta(map, x + 1, y + 1, userindex)
            
        end select
    elseif mapdata(map, x, y + 1).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x, y + 1).objinfo.objindex

        select case objdata(mapdata(map, x, y + 1).objinfo.objindex).objtype
            
            case eobjtype.otpuertas 'es una puerta
                call accionparapuerta(map, x, y + 1, userindex)
            
        end select
    end if
end if

end sub

sub accionparaforo(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim pos as worldpos
pos.map = map
pos.x = x
pos.y = y

if distancia(pos, userlist(userindex).pos) > 2 then
    call writeconsolemsg(userindex, "estas demasiado lejos.", fonttypenames.fonttype_info)
    exit sub
end if

'�hay mensajes?
dim f as string, tit as string, men as string, base as string, auxcad as string
f = app.path & "\foros\" & ucase$(objdata(mapdata(map, x, y).objinfo.objindex).foroid) & ".for"
if fileexist(f, vbnormal) then
    dim num as integer
    num = val(getvar(f, "info", "cantmsg"))
    base = left$(f, len(f) - 4)
    dim i as integer
    dim n as integer
    for i = 1 to num
        n = freefile
        f = base & i & ".for"
        open f for input shared as #n
        input #n, tit
        men = vbnullstring
        auxcad = vbnullstring
        do while not eof(n)
            input #n, auxcad
            men = men & vbcrlf & auxcad
        loop
        close #n
        call writeaddforummsg(userindex, tit, men)
        
    next
end if
call writeshowforumform(userindex)
end sub


sub accionparapuerta(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim miobj as obj
dim wp as worldpos

if not (distance(userlist(userindex).pos.x, userlist(userindex).pos.y, x, y) > 2) then
    if objdata(mapdata(map, x, y).objinfo.objindex).llave = 0 then
        if objdata(mapdata(map, x, y).objinfo.objindex).cerrada = 1 then
                'abre la puerta
                if objdata(mapdata(map, x, y).objinfo.objindex).llave = 0 then
                    
                    mapdata(map, x, y).objinfo.objindex = objdata(mapdata(map, x, y).objinfo.objindex).indexabierta
                    
                    call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectcreate(objdata(mapdata(map, x, y).objinfo.objindex).grhindex, x, y))
                    
                    'desbloquea
                    mapdata(map, x, y).blocked = 0
                    mapdata(map, x - 1, y).blocked = 0
                    
                    'bloquea todos los mapas
                    call bloquear(true, map, x, y, 0)
                    call bloquear(true, map, x - 1, y, 0)
                    
                      
                    'sonido
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_puerta))
                    
                else
                     call writeconsolemsg(userindex, "la puerta esta cerrada con llave.", fonttypenames.fonttype_info)
                end if
        else
                'cierra puerta
                mapdata(map, x, y).objinfo.objindex = objdata(mapdata(map, x, y).objinfo.objindex).indexcerrada
                
                call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectcreate(objdata(mapdata(map, x, y).objinfo.objindex).grhindex, x, y))
                                
                mapdata(map, x, y).blocked = 1
                mapdata(map, x - 1, y).blocked = 1
                
                
                call bloquear(true, map, x - 1, y, 1)
                call bloquear(true, map, x, y, 1)
                
                call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_puerta))
        end if
        
        userlist(userindex).flags.targetobj = mapdata(map, x, y).objinfo.objindex
    else
        call writeconsolemsg(userindex, "la puerta esta cerrada con llave.", fonttypenames.fonttype_info)
    end if
else
    call writeconsolemsg(userindex, "estas demasiado lejos.", fonttypenames.fonttype_info)
end if

end sub

sub accionparacartel(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next


dim miobj as obj

if objdata(mapdata(map, x, y).objinfo.objindex).objtype = 8 then
  
  if len(objdata(mapdata(map, x, y).objinfo.objindex).texto) > 0 then
    call writeshowsignal(userindex, mapdata(map, x, y).objinfo.objindex)
  end if
  
end if

end sub

sub accionpararamita(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim suerte as byte
dim exito as byte
dim obj as obj
dim raise as integer

dim pos as worldpos
pos.map = map
pos.x = x
pos.y = y

if distancia(pos, userlist(userindex).pos) > 2 then
    call writeconsolemsg(userindex, "estas demasiado lejos.", fonttypenames.fonttype_info)
    exit sub
end if

if mapdata(map, x, y).trigger = etrigger.zonasegura or mapinfo(map).pk = false then
    call writeconsolemsg(userindex, "en zona segura no puedes hacer fogatas.", fonttypenames.fonttype_info)
    exit sub
end if

if userlist(userindex).stats.userskills(supervivencia) > 1 and userlist(userindex).stats.userskills(supervivencia) < 6 then
            suerte = 3
elseif userlist(userindex).stats.userskills(supervivencia) >= 6 and userlist(userindex).stats.userskills(supervivencia) <= 10 then
            suerte = 2
elseif userlist(userindex).stats.userskills(supervivencia) >= 10 and userlist(userindex).stats.userskills(supervivencia) then
            suerte = 1
end if

exito = randomnumber(1, suerte)

if exito = 1 then
    if mapinfo(userlist(userindex).pos.map).zona <> ciudad then
        obj.objindex = fogata
        obj.amount = 1
        
        call writeconsolemsg(userindex, "has prendido la fogata.", fonttypenames.fonttype_info)
        call senddata(topcarea, userindex, preparemessageplayfiresound())
        
        call makeobj(map, obj, map, x, y)
        
        'las fogatas prendidas se deben eliminar
        dim fogatita as new cgarbage
        fogatita.map = map
        fogatita.x = x
        fogatita.y = y
        call trashcollector.add(fogatita)
    else
        call writeconsolemsg(userindex, "la ley impide realizar fogatas en las ciudades.", fonttypenames.fonttype_info)
        exit sub
    end if
else
    call writeconsolemsg(userindex, "no has podido hacer fuego.", fonttypenames.fonttype_info)
end if

call subirskill(userindex, supervivencia)

end sub
