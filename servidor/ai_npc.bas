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
    sigueamo = 8
    npcatacanpc = 9
    npcpathfinding = 10
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
    dim npos as worldpos
    dim headingloop as byte
    dim ui as integer
    
    with npclist(npcindex)
        for headingloop = eheading.north to eheading.west
            npos = .pos
            if .flags.inmovilizado = 0 or headingloop = .char.heading then
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    if ui > 0 then
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible then
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
'last modify date: 28/04/2009
'28/04/2009: zama - now those npcs who doble attack, have 50% of posibility of casting a spell on user.
'**************************************************************
    dim npos as worldpos
    dim headingloop as byte
    dim ui as integer
    dim npci as integer
    dim atacopj as boolean
    
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
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible then
                            atacopj = true
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
    dim npos as worldpos
    dim headingloop as eheading
    dim ui as integer
    
    with npclist(npcindex)
        for headingloop = eheading.north to eheading.west
            npos = .pos
            if .flags.inmovilizado = 0 or .char.heading = headingloop then
                call headtopos(headingloop, npos)
                if inmapbounds(npos.map, npos.x, npos.y) then
                    ui = mapdata(npos.map, npos.x, npos.y).userindex
                    if ui > 0 then
                        if userlist(ui).name = .flags.attackedby then
                            if userlist(ui).flags.muerto = 0 and userlist(ui).flags.adminperseguible then
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
    dim theading as byte
    dim ui as integer
    dim signons as integer
    dim signoeo as integer
    dim i as long
    
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
                ui = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x and sgn(userlist(ui).pos.x - .pos.x) = signoeo then
                    if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y and sgn(userlist(ui).pos.y - .pos.y) = signons then
                        
                        if userlist(ui).flags.muerto = 0 then
                            if .flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, ui)
                            exit sub
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
                        
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 and userlist(ui).flags.adminperseguible then
                            if .flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, ui)
                            theading = finddirection(.pos, userlist(ui).pos)
                            call movenpcchar(npcindex, theading)
                            exit sub
                        end if
                        
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
                                    call writeconsolemsg(.maestrouser, "la mascota no atacar� a ciudadanos si eres miembro de la armada real o tienes el seguro activado", fonttypenames.fonttype_info)
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
                                    call writeconsolemsg(.maestrouser, "la mascota no atacar� a ciudadanos si eres miembro de la armada real o tienes el seguro activado", fonttypenames.fonttype_info)
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
    dim ui as integer
    dim theading as byte
    dim i as long
    
    with npclist(npcindex)
        for i = 1 to modareas.conngroups(.pos.map).countentrys
            ui = modareas.conngroups(.pos.map).userentrys(i)
                
            'is it in it's range of vision??
            if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x then
                if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y then
                    
                    if not criminal(ui) then
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 then
                            if .flags.lanzaspells > 0 then
                                call npclanzaunspell(npcindex, ui)
                            end if
                            theading = finddirection(.pos, userlist(ui).pos)
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
    dim ui as integer
    dim theading as byte
    dim i as long
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
            
            for i = 1 to modareas.conngroups(.pos.map).countentrys
                ui = modareas.conngroups(.pos.map).userentrys(i)
                
                'is it in it's range of vision??
                if abs(userlist(ui).pos.x - .pos.x) <= rango_vision_x and sgn(userlist(ui).pos.x - .pos.x) = signoeo then
                    if abs(userlist(ui).pos.y - .pos.y) <= rango_vision_y and sgn(userlist(ui).pos.y - .pos.y) = signons then
                        
                        if criminal(ui) then
                           if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 and userlist(ui).flags.adminperseguible then
                                if .flags.lanzaspells > 0 then
                                      call npclanzaunspell(npcindex, ui)
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
                        
                        if criminal(ui) then
                           if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 and userlist(ui).flags.oculto = 0 and userlist(ui).flags.adminperseguible then
                                if .flags.lanzaspells > 0 then
                                    call npclanzaunspell(npcindex, ui)
                                end if
                                if .flags.inmovilizado = 1 then exit sub
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

private sub seguiramo(byval npcindex as integer)
    dim theading as byte
    dim ui as integer
    
    with npclist(npcindex)
        if .target = 0 and .targetnpc = 0 then
            ui = .maestrouser
            
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
    end with
    
    call restoreoldmovement(npcindex)
end sub

private sub ainpcatacanpc(byval npcindex as integer)
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

sub npcai(byval npcindex as integer)
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
    call logerror("npcai " & npclist(npcindex).name & " " & npclist(npcindex).maestrouser & " " & npclist(npcindex).maestronpc & " mapa:" & npclist(npcindex).pos.map & " x:" & npclist(npcindex).pos.x & " y:" & npclist(npcindex).pos.y & " mov:" & npclist(npcindex).movement & " targu:" & npclist(npcindex).target & " targn:" & npclist(npcindex).targetnpc)
    dim minpc as npc
    minpc = npclist(npcindex)
    call quitarnpc(npcindex)
    call respawnnpc(minpc)
end sub

function usernear(byval npcindex as integer) as boolean
'#################################################################
'returns true if there is an user adjacent to the npc position.
'#################################################################
    usernear = not int(distance(npclist(npcindex).pos.x, npclist(npcindex).pos.y, userlist(npclist(npcindex).pfinfo.targetuser).pos.x, userlist(npclist(npcindex).pfinfo.targetuser).pos.y)) > 1
end function

function recalculatepath(byval npcindex as integer) as boolean
'#################################################################
'returns true if we have to seek a new path
'#################################################################
    if npclist(npcindex).pfinfo.pathlenght = 0 then
        recalculatepath = true
    elseif not usernear(npcindex) and npclist(npcindex).pfinfo.pathlenght = npclist(npcindex).pfinfo.curpos - 1 then
        recalculatepath = true
    end if
end function

function pathend(byval npcindex as integer) as boolean
'#################################################################
'coded by gulfas morgolock
'returns if the npc has arrived to the end of its path
'#################################################################
    pathend = npclist(npcindex).pfinfo.curpos = npclist(npcindex).pfinfo.pathlenght
end function

function followpath(byval npcindex as integer) as boolean
'#################################################################
'coded by gulfas morgolock
'moves the npc.
'#################################################################
    dim tmppos as worldpos
    dim theading as byte
    
    tmppos.map = npclist(npcindex).pos.map
    tmppos.x = npclist(npcindex).pfinfo.path(npclist(npcindex).pfinfo.curpos).y ' invert� las coordenadas
    tmppos.y = npclist(npcindex).pfinfo.path(npclist(npcindex).pfinfo.curpos).x
    
    'debug.print "(" & tmppos.x & "," & tmppos.y & ")"
    
    theading = finddirection(npclist(npcindex).pos, tmppos)
    
    movenpcchar npcindex, theading
    
    npclist(npcindex).pfinfo.curpos = npclist(npcindex).pfinfo.curpos + 1
end function

function pathfindingai(byval npcindex as integer) as boolean
'#################################################################
'coded by gulfas morgolock / 11-07-02
'www.geocities.com/gmorgolock
'morgolock@speedy.com.ar
'this function seeks the shortest path from the npc
'to the user's location.
'#################################################################
    dim y as long
    dim x as long
    
    for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10    'makes a loop that looks at
         for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10   '5 tiles in every direction
            
             'make sure tile is legal
             if x > minxborder and x < maxxborder and y > minyborder and y < maxyborder then
                
                 'look for a user
                 if mapdata(npclist(npcindex).pos.map, x, y).userindex > 0 then
                     'move towards user
                      dim tmpuserindex as integer
                      tmpuserindex = mapdata(npclist(npcindex).pos.map, x, y).userindex
                      with userlist(tmpuserindex)
                        if .flags.muerto = 0 and .flags.invisible = 0 and .flags.oculto = 0 and .flags.adminperseguible then
                            'we have to invert the coordinates, this is because
                            'ore refers to maps in converse way of my pathfinding
                            'routines.
                            npclist(npcindex).pfinfo.target.x = userlist(tmpuserindex).pos.y
                            npclist(npcindex).pfinfo.target.y = userlist(tmpuserindex).pos.x 'ops!
                            npclist(npcindex).pfinfo.targetuser = tmpuserindex
                            call seekpath(npcindex)
                            exit function
                        end if
                    end with
                end if
            end if
        next x
    next y
end function

sub npclanzaunspell(byval npcindex as integer, byval userindex as integer)
    if userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1 then exit sub
    
    dim k as integer
    k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
    call npclanzaspellsobreuser(npcindex, userindex, npclist(npcindex).spells(k))
end sub

sub npclanzaunspellsobrenpc(byval npcindex as integer, byval targetnpc as integer)
    dim k as integer
    k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
    call npclanzaspellsobrenpc(npcindex, targetnpc, npclist(npcindex).spells(k))
end sub
