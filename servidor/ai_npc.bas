attribute vb_name = "ai"
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

public enum tipoai
    estatico = 1
    muevealazar = 2
    npcmaloatacausersbuenos = 3
    npcdefensa = 4
    guardiasatacancriminales = 5
    npcobjeto = 6
    sigueamo = 8
    npcatacanpc = 9
    npcpathfinding = 10
    
    'pretorianos
    sacerdotepretorianoai = 20
    guerreropretorianoai = 21
    magopretorianoai = 22
    cazadorpretorianoai = 23
    reypretoriano = 24
end enum

public const elementalfuego as integer = 93
public const elementaltierra as integer = 94
public const elementalagua as integer = 92

'damos a los npcs el mismo rango de visi�n que un pj
public const rango_vision_x as byte = 8
public const rango_vision_y as byte = 6

'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo ai_npc
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'ai de los npc
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

private sub guardiasai(byval npcindex as integer, byval delcaos as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 12/01/2010 (zama)
'14/09/2009: zama - now npcs don't atack protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs
'***************************************************
    dim npos as worldpos
    dim headingloop as byte
    dim ui as integer
    dim userprotected as boolean
    
    with npclist(npcindex)
        for headingloop = eheading.north to eheading.west
            npos = .pos
            if .flags.inmovilizado = 0 or headingloop = .char.heading then
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    if ui > 0 then
                        userprotected = not intervalopermiteseratacado(ui) and userlist(ui).flags.nopuedeseratacado
                        userprotected = userprotected or userlist(ui).flags.ignorado or userlist(ui).flags.enconsulta
                        
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible and not userprotected then
                            '�es criminal?
                            if not delcaos then
                                if criminal(ui) then
                                    if npcatacauser(npcindex, ui) then
                                        call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                    end if
                                    exit sub
                                elseif .flags.attackedby = userlist(ui).name and not .flags.follow then
                                    
                                    if npcatacauser(npcindex, ui) then
                                        call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                    end if
                                    exit sub
                                end if
                            else
                                if not criminal(ui) then
                                    if npcatacauser(npcindex, ui) then
                                        call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                    end if
                                    exit sub
                                elseif .flags.attackedby = userlist(ui).name and not .flags.follow then
                                      
                                    if npcatacauser(npcindex, ui) then
                                        call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                    end if
                                    exit sub
                                end if
                            end if
                        end if
                    end if
                end if
            end if  'not inmovil
        next headingloop
    end with
    
    call restoreoldmovement(npcindex)
end sub

''
' handles the evil npcs' artificial intelligency.
'
' @param npcindex specifies reference to the npc
private sub hostilmalvadoai(byval npcindex as integer)
'**************************************************************
'author: unknown
'last modify date: 12/01/2010 (zama)
'28/04/2009: zama - now those npcs who doble attack, have 50% of posibility of casting a spell on user.
'14/09/200*: zama - now npcs don't atack protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs
'**************************************************************
    dim npos as worldpos
    dim headingloop as byte
    dim ui as integer
    dim npci as integer
    dim atacopj as boolean
    dim userprotected as boolean
    
    atacopj = false
    
    with npclist(npcindex)
        for headingloop = eheading.north to eheading.west
            npos = .pos
            if .flags.inmovilizado = 0 or .char.heading = headingloop then
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    npci = mapdata(npos.map, npos.x, npos.y).npcindex
                    if ui > 0 and not atacopj then
                        userprotected = not intervalopermiteseratacado(ui) and userlist(ui).flags.nopuedeseratacado
                        userprotected = userprotected or userlist(ui).flags.ignorado or userlist(ui).flags.enconsulta
                        
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible and (not userprotected) then
                            
                            atacopj = true
                            if .movement = npcobjeto then
                                ' los npc objeto no atacan siempre al mismo usuario
                                if randomnumber(1, 3) = 3 then atacopj = false
                            end if
                            
                            if atacopj then
                                if .flags.lanzaspells then
                                    if .flags.atacadoble then
                                        if (randomnumber(0, 1)) then
                                            if npcatacauser(npcindex, ui) then
                                                call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                            end if
                                            exit sub
                                        end if
                                    end if
                                    
                                    call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                    call npclanzaunspell(npcindex, ui)
                                end if
                            end if
                            if npcatacauser(npcindex, ui) then
                                call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                            end if
                            exit sub

                        end if
                    elseif npci > 0 then
                        if npclist(npci).maestrouser > 0 and npclist(npci).flags.paralizado = 0 then
                            call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                            call sistemacombate.npcatacanpc(npcindex, npci, false)
                            exit sub
                        end if
                    end if
                end if
            end if  'inmo
        next headingloop
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub hostilbuenoai(byval npcindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 12/01/2010 (zama)
'14/09/2009: zama - now npcs don't atack protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs
'***************************************************
    dim npos as worldpos
    dim headingloop as eheading
    dim ui as integer
    dim userprotected as boolean
    
    with npclist(npcindex)
        for headingloop = eheading.north to eheading.west
            npos = .pos
            if .flags.inmovilizado = 0 or .char.heading = headingloop then
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    if ui > 0 then
                        if userlist(ui).name = .flags.attackedby then
                        
                            userprotected = not intervalopermiteseratacado(ui) and userlist(ui).flags.nopuedeseratacado
                            userprotected = userprotected or userlist(ui).flags.ignorado or userlist(ui).flags.enconsulta
                            
                            if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible and not userprotected then
                                if .flags.lanzaspells > 0 then
                                    call npclanzaunspell(npcindex, ui)
                                end if
                                
                                if npcatacauser(npcindex, ui) then
                                    call changenpcchar(npcindex, .char.body, .char.head, headingloop)
                                end if
                                exit sub
                            end if
                        end if
                    end if
                end if
            end if
        next headingloop
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub irusuariocercano(byval npcindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 25/07/2010 (zama)
'14/09/2009: zama - now npcs don't follow protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs
'25/07/2010: zama - agrego una validacion temporal para evitar que los npcs ataquen a usuarios de mapas difernetes.
'***************************************************
    dim theading as byte
    dim userindex as integer
    dim signons as integer
    dim signoeo as integer
    dim i as long
    dim userprotected as boolean
    
    with npclist(npcindex)
        if .flags.inmovilizado = 1 then
            select case .char.heading
                case eheading.north
                    signons = -1
                    signoeo = 0
                
                case eheading.east
                    signons = 0
                    signoeo = 1
                
                case eheading.south
                    signons = 1
                    signoeo = 0
                
                case eheading.west
                    signoeo = -1
                    signons = 0
            end select
            
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                userindex = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x and sgn(userlist(userindex).pos.x - .pos.x) = signoeo then
                    if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y and sgn(userlist(userindex).pos.y - .pos.y) = signons then
                        
                        userprotected = not intervalopermiteseratacado(userindex) and userlist(userindex).flags.nopuedeseratacado
                        userprotected = userprotected or userlist(userindex).flags.ignorado or userlist(userindex).flags.enconsulta
                        
                        if userlist(userindex).flags.muerto = 0 then
                            if not userprotected then
                                if .flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, userindex)
                                exit sub
                            end if
                        end if
                        
                    end if
                end if
            next i
            
        ' no esta inmobilizado
        else
            
            ' tiene prioridad de seguir al usuario al que le pertenece si esta en el rango de vision
            dim ownerindex as integer
            
            ownerindex = .owner
            if ownerindex > 0 then
                
                ' todo: es temporal hatsa reparar un bug que hace que ataquen a usuarios de otros mapas
                if userlist(ownerindex).pos.map = .pos.map then
                    
                    'is it in it's range of vision??
                    if abs(userlist(ownerindex).pos.x - .pos.x) <= rango_vision_x then
                        if abs(userlist(ownerindex).pos.y - .pos.y) <= rango_vision_y then
                            
                            ' va hacia el si o esta invi ni oculto
                            if userlist(ownerindex).flags.invisible = 0 and userlist(ownerindex).flags.oculto = 0 and not userlist(ownerindex).flags.enconsulta and not userlist(ownerindex).flags.ignorado then
                                if .flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, ownerindex)
                                    
                                theading = finddirection(.pos, userlist(ownerindex).pos)
                                call movenpcchar(npcindex, theading)
                                exit sub
                            end if
                        end if
                    end if
                
                ' esto significa que esta bugueado.. lo logueo, y "reparo" el error a mano (todo temporal)
                else
                    call logerror("el npc: " & .name & "(" & npcindex & "), intenta atacar a " & _
                                  userlist(ownerindex).name & "(index: " & ownerindex & ", mapa: " & _
                                  userlist(ownerindex).pos.map & ") desde el mapa " & .pos.map)
                    .owner = 0
                end if
                
            end if
            
            ' no le pertenece a nadie o el due�o no esta en el rango de vision, sigue a cualquiera
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                userindex = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x then
                    if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y then
                        
                        with userlist(userindex)
                            
                            userprotected = not intervalopermiteseratacado(userindex) and .flags.nopuedeseratacado
                            userprotected = userprotected or .flags.ignorado or .flags.enconsulta
                            
                            if .flags.muerto = 0 and .flags.invisible = 0 and .flags.oculto = 0 and _
                                .flags.adminperseguible and not userprotected then
                                
                                if npclist(npcindex).flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, userindex)
                                
                                theading = finddirection(npclist(npcindex).pos, .pos)
                                call movenpcchar(npcindex, theading)
                                exit sub
                            end if
                            
                        end with
                        
                    end if
                end if
            next i
            
            'si llega aca es que no hab�a ning�n usuario cercano vivo.
            'a bailar. pablo (toxicwaste)
            if randomnumber(0, 10) = 0 then
                call movenpcchar(npcindex, cbyte(randomnumber(eheading.north, eheading.west)))
            end if
            
        end if
    end with
    
    call restoreoldmovement(npcindex)
end sub

''
' makes a pet / summoned npc to follow an enemy
'
' @param npcindex specifies reference to the npc
private sub seguiragresor(byval npcindex as integer)
'**************************************************************
'author: unknown
'last modify by: marco vanotti (markoxx)
'last modify date: 08/16/2008
'08/16/2008: markoxx - now pets that do mel� attacks have to be near the enemy to attack.
'**************************************************************
    dim theading as byte
    dim ui as integer
    
    dim i as long
    
    dim signons as integer
    dim signoeo as integer

    with npclist(npcindex)
        if .flags.paralizado = 1 or .flags.inmovilizado = 1 then
            select case .char.heading
                case eheading.north
                    signons = -1
                    signoeo = 0
                
                case eheading.east
                    signons = 0
                    signoeo = 1
                
                case eheading.south
                    signons = 1
                    signoeo = 0
                
                case eheading.west
                    signoeo = -1
                    signons = 0
            end select

            for i = 1 to modareas.conngroups(.pos.map).countentrys
                ui = modareas.conngroups(.pos.map).userentrys(i)

                'is it in it's range of vision??
                if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x and sgn(userlist(ui).pos.x - .pos.x) = signoeo then
                    if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y and sgn(userlist(ui).pos.y - .pos.y) = signons then

                        if userlist(ui).name = .flags.attackedby then
                            if .maestrouser > 0 then
                                if not criminal(.maestrouser) and not criminal(ui) and (userlist(.maestrouser).flags.seguro or userlist(.maestrouser).faccion.armadareal = 1) then
                                    call writeconsolemsg(.maestrouser, "la mascota no atacar� a ciudadanos si eres miembro del ej�rcito real o tienes el seguro activado.", fonttypenames.fonttype_info)
                                    call flushbuffer(.maestrouser)
                                    .flags.attackedby = vbnullstring
                                    exit sub
                                end if
                            end if

                            if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 then
                                 if .flags.lanzaspells > 0 then
                                      call npclanzaunspell(npcindex, ui)
                                 else
                                    if distancia(userlist(ui).pos, npclist(npcindex).pos) <= 1 then
                                        ' todo : set this a separate ai for elementals and druid's pets
                                        if npclist(npcindex).numero <> 92 then
                                            call npcatacauser(npcindex, ui)
                                        end if
                                    end if
                                 end if
                                 exit sub
                            end if
                        end if
                        
                    end if
                end if
                
            next i
        else
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                ui = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x then
                    if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y then
                        
                        if userlist(ui).name = .flags.attackedby then
                            if .maestrouser > 0 then
                                if not criminal(.maestrouser) and not criminal(ui) and (userlist(.maestrouser).flags.seguro or userlist(.maestrouser).faccion.armadareal = 1) then
                                    call writeconsolemsg(.maestrouser, "la mascota no atacar� a ciudadanos si eres miembro del ej�rcito real o tienes el seguro activado.", fonttypenames.fonttype_info)
                                    call flushbuffer(.maestrouser)
                                    .flags.attackedby = vbnullstring
                                    call followamo(npcindex)
                                    exit sub
                                end if
                            end if
                            
                            if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 then
                                 if .flags.lanzaspells > 0 then
                                        call npclanzaunspell(npcindex, ui)
                                 else
                                    if distancia(userlist(ui).pos, npclist(npcindex).pos) <= 1 then
                                        ' todo : set this a separate ai for elementals and druid's pets
                                        if npclist(npcindex).numero <> 92 then
                                            call npcatacauser(npcindex, ui)
                                        end if
                                    end if
                                 end if
                                 
                                 theading = finddirection(.pos, userlist(ui).pos)
                                 call movenpcchar(npcindex, theading)
                                 
                                 exit sub
                            end if
                        end if
                        
                    end if
                end if
                
            next i
        end if
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub restoreoldmovement(byval npcindex as integer)
    with npclist(npcindex)
        if .maestrouser = 0 then
            .movement = .flags.oldmovement
            .hostile = .flags.oldhostil
            .flags.attackedby = vbnullstring
        end if
    end with
end sub

private sub persigueciudadano(byval npcindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 12/01/2010 (zama)
'14/09/2009: zama - now npcs don't follow protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs.
'***************************************************
    dim userindex as integer
    dim theading as byte
    dim i as long
    dim userprotected as boolean
    
    with npclist(npcindex)
        for i = 1 to modareas.conngroups(.pos.map).countentrys
            userindex = modareas.conngroups(.pos.map).userentrys(i)
                
            'is it in it's range of vision??
            if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x then
                if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y then
                    
                    if not criminal(userindex) then
                    
                        userprotected = not intervalopermiteseratacado(userindex) and userlist(userindex).flags.nopuedeseratacado
                        userprotected = userprotected or userlist(userindex).flags.ignorado or userlist(userindex).flags.enconsulta
                        
                        if userlist(userindex).flags.muerto = 0 and userlist(userindex).flags.invisible = 0 and _
                            userlist(userindex).flags.oculto = 0 and userlist(userindex).flags.adminperseguible and not userprotected then
                            
                            if .flags.lanzaspells > 0 then
                                call npclanzaunspell(npcindex, userindex)
                            end if
                            theading = finddirection(.pos, userlist(userindex).pos)
                            call movenpcchar(npcindex, theading)
                            exit sub
                        end if
                    end if
                    
               end if
            end if
            
        next i
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub persiguecriminal(byval npcindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 12/01/2010 (zama)
'14/09/2009: zama - now npcs don't follow protected users.
'12/01/2010: zama - los npcs no atacan druidas mimetizados con npcs.
'***************************************************
    dim userindex as integer
    dim theading as byte
    dim i as long
    dim signons as integer
    dim signoeo as integer
    dim userprotected as boolean
    
    with npclist(npcindex)
        if .flags.inmovilizado = 1 then
            select case .char.heading
                case eheading.north
                    signons = -1
                    signoeo = 0
                
                case eheading.east
                    signons = 0
                    signoeo = 1
                
                case eheading.south
                    signons = 1
                    signoeo = 0
                
                case eheading.west
                    signoeo = -1
                    signons = 0
            end select
            
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                userindex = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x and sgn(userlist(userindex).pos.x - .pos.x) = signoeo then
                    if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y and sgn(userlist(userindex).pos.y - .pos.y) = signons then
                        
                        if criminal(userindex) then
                            with userlist(userindex)
                                 
                                 userprotected = not intervalopermiteseratacado(userindex) and .flags.nopuedeseratacado
                                 userprotected = userprotected or userlist(userindex).flags.ignorado or userlist(userindex).flags.enconsulta
                                 
                                 if .flags.muerto = 0 and .flags.invisible = 0 and _
                                    .flags.oculto = 0 and .flags.adminperseguible and not userprotected then
                                     
                                     if npclist(npcindex).flags.lanzaspells > 0 then
                                           call npclanzaunspell(npcindex, userindex)
                                     end if
                                     exit sub
                                end if
                            end with
                        end if
                        
                   end if
                end if
            next i
        else
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                userindex = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x then
                    if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y then
                        
                        if criminal(userindex) then
                            
                            userprotected = not intervalopermiteseratacado(userindex) and userlist(userindex).flags.nopuedeseratacado
                            userprotected = userprotected or userlist(userindex).flags.ignorado
                            
                            if userlist(userindex).flags.muerto = 0 and userlist(userindex).flags.invisible = 0 and _
                               userlist(userindex).flags.oculto = 0 and userlist(userindex).flags.adminperseguible and not userprotected then
                                if .flags.lanzaspells > 0 then
                                    call npclanzaunspell(npcindex, userindex)
                                end if
                                if .flags.inmovilizado = 1 then exit sub
                                theading = finddirection(.pos, userlist(userindex).pos)
                                call movenpcchar(npcindex, theading)
                                exit sub
                           end if
                        end if
                        
                   end if
                end if
                
            next i
        end if
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub seguiramo(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim theading as byte
    dim ui as integer
    
    with npclist(npcindex)
        if .target = 0 and .targetnpc = 0 then
            ui = .maestrouser
            
            if ui > 0 then
                'is it in it's range of vision??
                if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x then
                    if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y then
                        if userlist(ui).flags.muerto = 0 _
                                and userlist(ui).flags.invisible = 0 _
                                and userlist(ui).flags.oculto = 0 _
                                and distancia(.pos, userlist(ui).pos) > 3 then
                            theading = finddirection(.pos, userlist(ui).pos)
                            call movenpcchar(npcindex, theading)
                            exit sub
                        end if
                    end if
                end if
            end if
        end if
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub ainpcatacanpc(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim theading as byte
    dim x as long
    dim y as long
    dim ni as integer
    dim bnoesta as boolean
    
    dim signons as integer
    dim signoeo as integer
    
    with npclist(npcindex)
        if .flags.inmovilizado = 1 then
            select case .char.heading
                case eheading.north
                    signons = -1
                    signoeo = 0
                
                case eheading.east
                    signons = 0
                    signoeo = 1
                
                case eheading.south
                    signons = 1
                    signoeo = 0
                
                case eheading.west
                    signoeo = -1
                    signons = 0
            end select
            
            for y = .pos.y to .pos.y + signons * rango_vision_y step iif(signons = 0, 1, signons)
                for x = .pos.x to .pos.x + signoeo * rango_vision_x step iif(signoeo = 0, 1, signoeo)
                    if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                        ni = mapdata(.pos.map, x, y).npcindex
                        if ni > 0 then
                            if .targetnpc = ni then
                                bnoesta = true
                                if .numero = elementalfuego then
                                    call npclanzaunspellsobrenpc(npcindex, ni)
                                    if npclist(ni).npctype = dragon then
                                        npclist(ni).canattack = 1
                                        call npclanzaunspellsobrenpc(ni, npcindex)
                                     end if
                                 else
                                    'aca verificamosss la distancia de ataque
                                    if distancia(.pos, npclist(ni).pos) <= 1 then
                                        call sistemacombate.npcatacanpc(npcindex, ni)
                                    end if
                                 end if
                                 exit sub
                            end if
                       end if
                    end if
                next x
            next y
        else
            for y = .pos.y - rango_vision_y to .pos.y + rango_vision_y
                for x = .pos.x - rango_vision_y to .pos.x + rango_vision_y
                    if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                       ni = mapdata(.pos.map, x, y).npcindex
                       if ni > 0 then
                            if .targetnpc = ni then
                                 bnoesta = true
                                 if .numero = elementalfuego then
                                     call npclanzaunspellsobrenpc(npcindex, ni)
                                     if npclist(ni).npctype = dragon then
                                        npclist(ni).canattack = 1
                                        call npclanzaunspellsobrenpc(ni, npcindex)
                                     end if
                                 else
                                    'aca verificamosss la distancia de ataque
                                    if distancia(.pos, npclist(ni).pos) <= 1 then
                                        call sistemacombate.npcatacanpc(npcindex, ni)
                                    end if
                                 end if
                                 if .flags.inmovilizado = 1 then exit sub
                                 if .targetnpc = 0 then exit sub
                                 theading = finddirection(.pos, npclist(mapdata(.pos.map, x, y).npcindex).pos)
                                 call movenpcchar(npcindex, theading)
                                 exit sub
                            end if
                       end if
                    end if
                next x
            next y
        end if
        
        if not bnoesta then
            if .maestrouser > 0 then
                call followamo(npcindex)
            else
                .movement = .flags.oldmovement
                .hostile = .flags.oldhostil
            end if
        end if
    end with
end sub

public sub ainpcobjeto(byval npcindex as integer)
'***************************************************
'autor: zama
'last modification: 14/09/2009 (zama)
'14/09/2009: zama - now npcs don't follow protected users.
'***************************************************
    dim userindex as integer
    dim i as long
    dim userprotected as boolean
    
    with npclist(npcindex)
        for i = 1 to modareas.conngroups(.pos.map).countentrys
            userindex = modareas.conngroups(.pos.map).userentrys(i)
            
            'is it in it's range of vision??
            if abs(userlist(userindex).pos.x - .pos.x) <= rango_vision_x then
                if abs(userlist(userindex).pos.y - .pos.y) <= rango_vision_y then
                    
                    with userlist(userindex)
                        userprotected = not intervalopermiteseratacado(userindex) and .flags.nopuedeseratacado
                        
                        if .flags.muerto = 0 and .flags.invisible = 0 and _
                            .flags.oculto = 0 and .flags.adminperseguible and not userprotected then
                            
                            ' no quiero que ataque siempre al primero
                            if randomnumber(1, 3) < 3 then
                                if npclist(npcindex).flags.lanzaspells > 0 then
                                     call npclanzaunspell(npcindex, userindex)
                                end if
                            
                                exit sub
                            end if
                        end if
                    end with
               end if
            end if
            
        next i
    end with

end sub

sub npcai(byval npcindex as integer)
'**************************************************************
'author: unknown
'last modify by: zama
'last modify date: 15/11/2009
'08/16/2008: markoxx - now pets that do mel� attacks have to be near the enemy to attack.
'15/11/2009: zama - implementacion de npc objetos ai.
'**************************************************************
on error goto errorhandler
    with npclist(npcindex)
        '<<<<<<<<<<< ataques >>>>>>>>>>>>>>>>
        if .maestrouser = 0 then
            'busca a alguien para atacar
            '�es un guardia?
            if .npctype = enpctype.guardiareal then
                call guardiasai(npcindex, false)
            elseif .npctype = enpctype.guardiascaos then
                call guardiasai(npcindex, true)
            elseif .hostile and .stats.alineacion <> 0 then
                call hostilmalvadoai(npcindex)
            elseif .hostile and .stats.alineacion = 0 then
                call hostilbuenoai(npcindex)
            end if
        else
            'evitamos que ataque a su amo, a menos
            'que el amo lo ataque.
            'call hostilbuenoai(npcindex)
        end if
        
        
        '<<<<<<<<<<<movimiento>>>>>>>>>>>>>>>>
        select case .movement
            case tipoai.muevealazar
                if .flags.inmovilizado = 1 then exit sub
                if .npctype = enpctype.guardiareal then
                    if randomnumber(1, 12) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(eheading.north, eheading.west)))
                    end if
                    
                    call persiguecriminal(npcindex)
                    
                elseif .npctype = enpctype.guardiascaos then
                    if randomnumber(1, 12) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(eheading.north, eheading.west)))
                    end if
                    
                    call persigueciudadano(npcindex)
                    
                else
                    if randomnumber(1, 12) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(eheading.north, eheading.west)))
                    end if
                end if
            
            'va hacia el usuario cercano
            case tipoai.npcmaloatacausersbuenos
                call irusuariocercano(npcindex)
            
            'va hacia el usuario que lo ataco(follow)
            case tipoai.npcdefensa
                call seguiragresor(npcindex)
            
            'persigue criminales
            case tipoai.guardiasatacancriminales
                call persiguecriminal(npcindex)
            
            case tipoai.sigueamo
                if .flags.inmovilizado = 1 then exit sub
                call seguiramo(npcindex)
                if randomnumber(1, 12) = 3 then
                    call movenpcchar(npcindex, cbyte(randomnumber(eheading.north, eheading.west)))
                end if
            
            case tipoai.npcatacanpc
                call ainpcatacanpc(npcindex)
                
            case tipoai.npcobjeto
                call ainpcobjeto(npcindex)
                
            case tipoai.npcpathfinding
                if .flags.inmovilizado = 1 then exit sub
                if recalculatepath(npcindex) then
                    call pathfindingai(npcindex)
                    'existe el camino?
                    if .pfinfo.nopath then 'si no existe nos movemos al azar
                        'move randomly
                        call movenpcchar(npcindex, randomnumber(eheading.north, eheading.west))
                    end if
                else
                    if not pathend(npcindex) then
                        call followpath(npcindex)
                    else
                        .pfinfo.pathlenght = 0
                    end if
                end if
        end select
    end with
exit sub

errorhandler:
    with npclist(npcindex)
        call logerror("error en npcai. error: " & err.number & " - " & err.description & ". " & _
        "npc: " & .name & ", index: " & npcindex & ", maestrouser: " & .maestrouser & _
        ", maestronpc: " & .maestronpc & ", mapa: " & .pos.map & " x:" & .pos.x & " y:" & _
        .pos.y & " mov:" & .movement & " targu:" & _
        .target & " targn:" & .targetnpc)
    end with
    
    dim minpc as npc
    minpc = npclist(npcindex)
    call quitarnpc(npcindex)
    call respawnnpc(minpc)
end sub

function usernear(byval npcindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'returns true if there is an user adjacent to the npc position.
'***************************************************

    with npclist(npcindex)
        usernear = not int(distance(.pos.x, .pos.y, userlist(.pfinfo.targetuser).pos.x, _
                    userlist(.pfinfo.targetuser).pos.y)) > 1
    end with
end function

function recalculatepath(byval npcindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'returns true if we have to seek a new path
'***************************************************

    if npclist(npcindex).pfinfo.pathlenght = 0 then
        recalculatepath = true
    elseif not usernear(npcindex) and npclist(npcindex).pfinfo.pathlenght = npclist(npcindex).pfinfo.curpos - 1 then
        recalculatepath = true
    end if
end function

function pathend(byval npcindex as integer) as boolean
'***************************************************
'author: gulfas morgolock
'last modification: -
'returns if the npc has arrived to the end of its path
'***************************************************
    pathend = npclist(npcindex).pfinfo.curpos = npclist(npcindex).pfinfo.pathlenght
end function

function followpath(byval npcindex as integer) as boolean
'***************************************************
'author: gulfas morgolock
'last modification: -
'moves the npc.
'***************************************************
    dim tmppos as worldpos
    dim theading as byte
    
    with npclist(npcindex)
        tmppos.map = .pos.map
        tmppos.x = .pfinfo.path(.pfinfo.curpos).y ' invert� las coordenadas
        tmppos.y = .pfinfo.path(.pfinfo.curpos).x
        
        'debug.print "(" & tmppos.x & "," & tmppos.y & ")"
        
        theading = finddirection(.pos, tmppos)
        
        movenpcchar npcindex, theading
        
        .pfinfo.curpos = .pfinfo.curpos + 1
    end with
end function

function pathfindingai(byval npcindex as integer) as boolean
'***************************************************
'author: gulfas morgolock
'last modification: -
'this function seeks the shortest path from the npc
'to the user's location.
'***************************************************
    dim y as long
    dim x as long
    
    with npclist(npcindex)
        for y = .pos.y - 10 to .pos.y + 10    'makes a loop that looks at
             for x = .pos.x - 10 to .pos.x + 10   '5 tiles in every direction
                
                 'make sure tile is legal
                 if x > minxborder and x < maxxborder and y > minyborder and y < maxyborder then
                    
                     'look for a user
                     if mapdata(.pos.map, x, y).userindex > 0 then
                         'move towards user
                          dim tmpuserindex as integer
                          tmpuserindex = mapdata(.pos.map, x, y).userindex
                          with userlist(tmpuserindex)
                            if .flags.muerto = 0 and .flags.invisible = 0 and .flags.oculto = 0 and .flags.adminperseguible then
                                'we have to invert the coordinates, this is because
                                'ore refers to maps in converse way of my pathfinding
                                'routines.
                                npclist(npcindex).pfinfo.target.x = .pos.y
                                npclist(npcindex).pfinfo.target.y = .pos.x 'ops!
                                npclist(npcindex).pfinfo.targetuser = tmpuserindex
                                call seekpath(npcindex)
                                exit function
                            end if
                        end with
                    end if
                end if
            next x
        next y
    end with
end function

sub npclanzaunspell(byval npcindex as integer, byval userindex as integer)
'**************************************************************
'author: unknown
'last modify by: -
'last modify date: -
'**************************************************************
    with userlist(userindex)
        if .flags.invisible = 1 or .flags.oculto = 1 then exit sub
    end with
    
    dim k as integer
    k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
    call npclanzaspellsobreuser(npcindex, userindex, npclist(npcindex).spells(k))
end sub

sub npclanzaunspellsobrenpc(byval npcindex as integer, byval targetnpc as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim k as integer
    k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
    call npclanzaspellsobrenpc(npcindex, targetnpc, npclist(npcindex).spells(k))
end sub
