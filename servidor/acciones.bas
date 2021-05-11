attribute vb_name = "acciones"
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim tempindex as integer
    
on error resume next
    '�rango visi�n? (toxicwaste)
    if (abs(userlist(userindex).pos.y - y) > rango_vision_y) or (abs(userlist(userindex).pos.x - x) > rango_vision_x) then
        exit sub
    end if
    
    '�posicion valida?
    if inmapbounds(map, x, y) then
        with userlist(userindex)
            if mapdata(map, x, y).npcindex > 0 then     'acciones npcs
                tempindex = mapdata(map, x, y).npcindex
                
                'set the target npc
                .flags.targetnpc = tempindex
                
                if npclist(tempindex).comercia = 1 then
                    '�esta el user muerto? si es asi no puede comerciar
                    if .flags.muerto = 1 then
                        call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'is it already in commerce mode??
                    if .flags.comerciando then
                        exit sub
                    end if
                    
                    if distancia(npclist(tempindex).pos, .pos) > 3 then
                        call writeconsolemsg(userindex, "est�s demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'iniciamos la rutina pa' comerciar.
                    call iniciarcomercionpc(userindex)
                
                elseif npclist(tempindex).npctype = enpctype.banquero then
                    '�esta el user muerto? si es asi no puede comerciar
                    if .flags.muerto = 1 then
                        call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'is it already in commerce mode??
                    if .flags.comerciando then
                        exit sub
                    end if
                    
                    if distancia(npclist(tempindex).pos, .pos) > 3 then
                        call writeconsolemsg(userindex, "est�s demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'a depositar de una
                    call iniciardeposito(userindex)
                
                elseif npclist(tempindex).npctype = enpctype.revividor or npclist(tempindex).npctype = enpctype.resucitadornewbie then
                    if distancia(.pos, npclist(tempindex).pos) > 10 then
                        call writeconsolemsg(userindex, "el sacerdote no puede curarte debido a que est�s demasiado lejos.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'revivimos si es necesario
                    if .flags.muerto = 1 and (npclist(tempindex).npctype = enpctype.revividor or esnewbie(userindex)) then
                        call revivirusuario(userindex)
                    end if
                    
                    if npclist(tempindex).npctype = enpctype.revividor or esnewbie(userindex) then
                        'curamos totalmente
                        .stats.minhp = .stats.maxhp
                        call writeupdateuserstats(userindex)
                    end if
                end if
                
            '�es un obj?
            elseif mapdata(map, x, y).objinfo.objindex > 0 then
                tempindex = mapdata(map, x, y).objinfo.objindex
                
                .flags.targetobj = tempindex
                
                select case objdata(tempindex).objtype
                    case eobjtype.otpuertas 'es una puerta
                        call accionparapuerta(map, x, y, userindex)
                    case eobjtype.otcarteles 'es un cartel
                        call accionparacartel(map, x, y, userindex)
                    case eobjtype.otforos 'foro
                        call accionparaforo(map, x, y, userindex)
                    case eobjtype.otle�a    'le�a
                        if tempindex = fogata_apag and .flags.muerto = 0 then
                            call accionpararamita(map, x, y, userindex)
                        end if
                end select
            '>>>>>>>>>>>objetos que ocupam mas de un tile<<<<<<<<<<<<<
            elseif mapdata(map, x + 1, y).objinfo.objindex > 0 then
                tempindex = mapdata(map, x + 1, y).objinfo.objindex
                .flags.targetobj = tempindex
                
                select case objdata(tempindex).objtype
                    
                    case eobjtype.otpuertas 'es una puerta
                        call accionparapuerta(map, x + 1, y, userindex)
                    
                end select
            
            elseif mapdata(map, x + 1, y + 1).objinfo.objindex > 0 then
                tempindex = mapdata(map, x + 1, y + 1).objinfo.objindex
                .flags.targetobj = tempindex
        
                select case objdata(tempindex).objtype
                    case eobjtype.otpuertas 'es una puerta
                        call accionparapuerta(map, x + 1, y + 1, userindex)
                end select
            
            elseif mapdata(map, x, y + 1).objinfo.objindex > 0 then
                tempindex = mapdata(map, x, y + 1).objinfo.objindex
                .flags.targetobj = tempindex
                
                select case objdata(tempindex).objtype
                    case eobjtype.otpuertas 'es una puerta
                        call accionparapuerta(map, x, y + 1, userindex)
                end select
            end if
        end with
    end if
end sub

public sub accionparaforo(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 02/01/2010
'02/01/2010: zama - agrego foros faccionarios
'***************************************************

on error resume next

    dim pos as worldpos
    
    pos.map = map
    pos.x = x
    pos.y = y
    
    if distancia(pos, userlist(userindex).pos) > 2 then
        call writeconsolemsg(userindex, "estas demasiado lejos.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if sendposts(userindex, objdata(mapdata(map, x, y).objinfo.objindex).foroid) then
        call writeshowforumform(userindex)
    end if
    
end sub

sub accionparapuerta(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

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
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_puerta, x, y))
                    
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
                
                call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_puerta, x, y))
        end if
        
        userlist(userindex).flags.targetobj = mapdata(map, x, y).objinfo.objindex
    else
        call writeconsolemsg(userindex, "la puerta est� cerrada con llave.", fonttypenames.fonttype_info)
    end if
else
    call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
end if

end sub

sub accionparacartel(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

if objdata(mapdata(map, x, y).objinfo.objindex).objtype = 8 then
  
  if len(objdata(mapdata(map, x, y).objinfo.objindex).texto) > 0 then
    call writeshowsignal(userindex, mapdata(map, x, y).objinfo.objindex)
  end if
  
end if

end sub

sub accionpararamita(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

dim suerte as byte
dim exito as byte
dim obj as obj

dim pos as worldpos
pos.map = map
pos.x = x
pos.y = y

with userlist(userindex)
    if distancia(pos, .pos) > 2 then
        call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if mapdata(map, x, y).trigger = etrigger.zonasegura or mapinfo(map).pk = false then
        call writeconsolemsg(userindex, "no puedes hacer fogatas en zona segura.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if .stats.userskills(supervivencia) > 1 and .stats.userskills(supervivencia) < 6 then
        suerte = 3
    elseif .stats.userskills(supervivencia) >= 6 and .stats.userskills(supervivencia) <= 10 then
        suerte = 2
    elseif .stats.userskills(supervivencia) >= 10 and .stats.userskills(supervivencia) then
        suerte = 1
    end if
    
    exito = randomnumber(1, suerte)
    
    if exito = 1 then
        if mapinfo(.pos.map).zona <> ciudad then
            obj.objindex = fogata
            obj.amount = 1
            
            call writeconsolemsg(userindex, "has prendido la fogata.", fonttypenames.fonttype_info)
            
            call makeobj(obj, map, x, y)
            
            'las fogatas prendidas se deben eliminar
            dim fogatita as new cgarbage
            fogatita.map = map
            fogatita.x = x
            fogatita.y = y
            call trashcollector.add(fogatita)
            
            call subirskill(userindex, eskill.supervivencia, true)
        else
            call writeconsolemsg(userindex, "la ley impide realizar fogatas en las ciudades.", fonttypenames.fonttype_info)
            exit sub
        end if
    else
        call writeconsolemsg(userindex, "no has podido hacer fuego.", fonttypenames.fonttype_info)
        call subirskill(userindex, eskill.supervivencia, false)
    end if

end with

end sub
