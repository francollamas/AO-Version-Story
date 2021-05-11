attribute vb_name = "ai"
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


option explicit

public const estatico = 1
public const mueve_al_azar = 2
public const npc_malo_ataca_usuarios_buenos = 3
public const npcdefensa = 4
public const guardias_atacan_criminales = 5
public const sigue_amo = 8
public const npc_ataca_npc = 9
public const npc_pathfinding = 10

public const elementalfuego = 93
public const elementaltierra = 94
public const elementalagua = 92

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

private sub guardiasai(byval npcindex as integer, optional byval delcaos as boolean = false)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer

for headingloop = north to west
    npos = npclist(npcindex).pos
    if npclist(npcindex).flags.inmovilizado = 0 or headingloop = npclist(npcindex).char.heading then
        call headtopos(headingloop, npos)
        if inmapbounds(npos.map, npos.x, npos.y) then
            ui = mapdata(npos.map, npos.x, npos.y).userindex
            if ui > 0 then
                  if userlist(ui).flags.muerto = 0 then
                         '�es criminal?
                         if not delcaos then
                            if criminal(ui) then
                                   call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                                   call npcatacauser(npcindex, ui)
                                   exit sub
                            elseif npclist(npcindex).flags.attackedby = userlist(ui).name _
                                      and not npclist(npcindex).flags.follow then
                                  call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                                  call npcatacauser(npcindex, ui)
                                  exit sub
                            end if
                        else
                            if not criminal(ui) then
                                   call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                                   call npcatacauser(npcindex, ui)
                                   exit sub
                            elseif npclist(npcindex).flags.attackedby = userlist(ui).name _
                                      and not npclist(npcindex).flags.follow then
                                  call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                                  call npcatacauser(npcindex, ui)
                                  exit sub
                            end if
                        end if
                  end if
            end if
        end if
    end if  'not inmovil
next headingloop

call restoreoldmovement(npcindex)

end sub

private sub hostilmalvadoai(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer
dim npci as integer
dim atacopj as boolean

atacopj = false

for headingloop = north to west
    npos = npclist(npcindex).pos
    if npclist(npcindex).flags.inmovilizado = 0 or npclist(npcindex).char.heading = headingloop then
        call headtopos(headingloop, npos)
        if inmapbounds(npos.map, npos.x, npos.y) then
            ui = mapdata(npos.map, npos.x, npos.y).userindex
            npci = mapdata(npos.map, npos.x, npos.y).npcindex
            if ui > 0 and not atacopj then
                if userlist(ui).flags.muerto = 0 then
                    atacopj = true
                    if npclist(npcindex).flags.lanzaspells <> 0 then
                        dim k as integer
                        k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
                        call npclanzaunspell(npcindex, ui)
                    end if
                    call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                    call npcatacauser(npcindex, mapdata(npos.map, npos.x, npos.y).userindex)
                    exit sub
                end if
            elseif npci > 0 then
                    if npclist(npci).maestrouser > 0 and npclist(npci).flags.paralizado = 0 then
                        call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                        call npcatacanpc(npcindex, npci, false)
                        exit sub
                    end if
            end if
        end if
    end if  'inmo
next headingloop

call restoreoldmovement(npcindex)

end sub


private sub hostilbuenoai(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer
for headingloop = north to west
    npos = npclist(npcindex).pos
    if npclist(npcindex).flags.inmovilizado = 0 or npclist(npcindex).char.heading = headingloop then
        call headtopos(headingloop, npos)
        if inmapbounds(npos.map, npos.x, npos.y) then
            ui = mapdata(npos.map, npos.x, npos.y).userindex
            if ui > 0 then
                if userlist(ui).name = npclist(npcindex).flags.attackedby then
                    if userlist(ui).flags.muerto = 0 then
                            if npclist(npcindex).flags.lanzaspells > 0 then
                              dim k as integer
                              k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
                              call npclanzaunspell(npcindex, ui)
                            end if
                            call changenpcchar(tomap, 0, npos.map, npcindex, npclist(npcindex).char.body, npclist(npcindex).char.head, headingloop)
                            call npcatacauser(npcindex, ui)
                            exit sub
                    end if
                end if
            end if
        end if
    end if
next headingloop

call restoreoldmovement(npcindex)

end sub

private sub irusuariocercano(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer
dim signons as integer
dim signoeo as integer

if npclist(npcindex).flags.inmovilizado = 1 then
    select case npclist(npcindex).char.heading
        case north
            signons = -1
            signoeo = 0
        case east
            signons = 0
            signoeo = 1
        case south
            signons = 1
            signoeo = 0
        case west
            signoeo = -1
            signons = 0
    end select
    
    for y = npclist(npcindex).pos.y to npclist(npcindex).pos.y + signons * 10 step iif(signons = 0, 1, signons)
        for x = npclist(npcindex).pos.x to npclist(npcindex).pos.x + signoeo * 10 step iif(signoeo = 0, 1, signoeo)
            
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                   ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
                   if ui > 0 then
                      if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                            if npclist(npcindex).flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, ui)
                            exit sub
                      end if
                   end if
            end if
            
        next x
    next y
    
else
    for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
        for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                   ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
                   if ui > 0 then
                      if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                            if npclist(npcindex).flags.lanzaspells <> 0 then call npclanzaunspell(npcindex, ui)
                            theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                            call movenpcchar(npcindex, theading)
                            exit sub
                      end if
                   end if
            end if
        next x
    next y
end if

call restoreoldmovement(npcindex)

end sub

private sub seguiragresor(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer

dim signons as integer
dim signoeo as integer

if npclist(npcindex).flags.inmovilizado = 1 then
    select case npclist(npcindex).char.heading
        case north
            signons = -1
            signoeo = 0
        case east
            signons = 0
            signoeo = 1
        case south
            signons = 1
            signoeo = 0
        case west
            signoeo = -1
            signons = 0
    end select
    
    for y = npclist(npcindex).pos.y to npclist(npcindex).pos.y + signons * 10 step iif(signons = 0, 1, signons)
        for x = npclist(npcindex).pos.x to npclist(npcindex).pos.x + signoeo * 10 step iif(signoeo = 0, 1, signoeo)

            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
                if ui > 0 then
                    if userlist(ui).name = npclist(npcindex).flags.attackedby then
                        if npclist(npcindex).maestrouser > 0 then
                            if not criminal(npclist(npcindex).maestrouser) and not criminal(ui) and (userlist(npclist(npcindex).maestrouser).flags.seguro or userlist(npclist(npcindex).maestrouser).faccion.armadareal = 1) then
                                call senddata(toindex, npclist(npcindex).maestrouser, 0, "||la mascota no atacar� a ciudadanos si eres miembro de la armada real o tienes el seguro activado" & fonttype_info)
                                npclist(npcindex).flags.attackedby = ""
                                exit sub
                            end if
                        end if
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                             if npclist(npcindex).flags.lanzaspells > 0 then
                                  call npclanzaunspell(npcindex, ui)
                             end if
                             exit sub
                        end if
                    end if
                end if
            end if

        next x
    next y
else
    for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
        for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
                ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
                if ui > 0 then
                    if userlist(ui).name = npclist(npcindex).flags.attackedby then
                        if npclist(npcindex).maestrouser > 0 then
                            if not criminal(npclist(npcindex).maestrouser) and not criminal(ui) and (userlist(npclist(npcindex).maestrouser).flags.seguro or userlist(npclist(npcindex).maestrouser).faccion.armadareal = 1) then
                                call senddata(toindex, npclist(npcindex).maestrouser, 0, "||la mascota no atacar� a ciudadanos si eres miembro de la armada real o tienes el seguro activado" & fonttype_info)
                                npclist(npcindex).flags.attackedby = ""
                                call followamo(npcindex)
                                exit sub
                            end if
                        end if
                        if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                             if npclist(npcindex).flags.lanzaspells > 0 then
                                  call npclanzaunspell(npcindex, ui)
                             end if
                             theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                             call movenpcchar(npcindex, theading)
                             exit sub
                        end if
                    end if
                end if
            end if
        next x
    next y
end if
call restoreoldmovement(npcindex)

end sub

private sub restoreoldmovement(byval npcindex as integer)

if npclist(npcindex).maestrouser = 0 then
    npclist(npcindex).movement = npclist(npcindex).flags.oldmovement
    npclist(npcindex).hostile = npclist(npcindex).flags.oldhostil
    npclist(npcindex).flags.attackedby = ""
end if

end sub

private sub persigueciudadano(byval npcindex as integer)
dim ui as integer
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
    for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
        if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
           ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
           if ui > 0 then
                if not criminal(ui) then
                   if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                        if npclist(npcindex).flags.lanzaspells > 0 then
                              dim k as integer
                              k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
                              call npclanzaunspell(npcindex, ui)
                        end if
                        theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                        call movenpcchar(npcindex, theading)
                        exit sub
                   end if
                end if
           end if
        end if
    next x
next y

call restoreoldmovement(npcindex)

end sub


private sub persiguecriminal(byval npcindex as integer)
dim ui as integer
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim signons as integer
dim signoeo as integer

if npclist(npcindex).flags.inmovilizado = 1 then
    select case npclist(npcindex).char.heading
        case north
            signons = -1
            signoeo = 0
        case east
            signons = 0
            signoeo = 1
        case south
            signons = 1
            signoeo = 0
        case west
            signoeo = -1
            signons = 0
    end select
    
    for y = npclist(npcindex).pos.y to npclist(npcindex).pos.y + signons * 10 step iif(signons = 0, 1, signons)
        for x = npclist(npcindex).pos.x to npclist(npcindex).pos.x + signoeo * 10 step iif(signoeo = 0, 1, signoeo)


            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
               ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
               if ui > 0 then
                    if criminal(ui) then
                       if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                            if npclist(npcindex).flags.lanzaspells > 0 then
'                                  dim k as integer
'                                  k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
                                  call npclanzaunspell(npcindex, ui)
                            end if
                            exit sub
                       end if
                    end if
               end if
            end if


        next x
    next y
else
    for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
        for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
               ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
               if ui > 0 then
                    if criminal(ui) then
                       if userlist(ui).flags.muerto = 0 and userlist(ui).flags.invisible = 0 then
                            if npclist(npcindex).flags.lanzaspells > 0 then
                                  'dim k as integer
                                  'k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
                                  call npclanzaunspell(npcindex, ui)
                            end if
                            if npclist(npcindex).flags.inmovilizado = 1 then exit sub
                            theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                            call movenpcchar(npcindex, theading)
                            exit sub
                       end if
                    end if
               end if
            end if
        next x
    next y
end if
call restoreoldmovement(npcindex)

end sub

private sub seguiramo(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ui as integer
for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
    for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
        if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
            if npclist(npcindex).target = 0 and npclist(npcindex).targetnpc = 0 then
                ui = mapdata(npclist(npcindex).pos.map, x, y).userindex
                if ui > 0 then
                   if userlist(ui).flags.muerto = 0 _
                   and userlist(ui).flags.invisible = 0 _
                   and ui = npclist(npcindex).maestrouser _
                   and distancia(npclist(npcindex).pos, userlist(ui).pos) > 3 then
                        theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                        call movenpcchar(npcindex, theading)
                        exit sub
                   end if
                end if
            end if
        end if
    next x
next y

call restoreoldmovement(npcindex)

end sub

private sub ainpcatacanpc(byval npcindex as integer)
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer
dim ni as integer
dim bnoesta as boolean

dim signons as integer
dim signoeo as integer

if npclist(npcindex).flags.inmovilizado = 1 then
    select case npclist(npcindex).char.heading
        case north
            signons = -1
            signoeo = 0
        case east
            signons = 0
            signoeo = 1
        case south
            signons = 1
            signoeo = 0
        case west
            signoeo = -1
            signons = 0
    end select
    
    for y = npclist(npcindex).pos.y to npclist(npcindex).pos.y + signons * 10 step iif(signons = 0, 1, signons)
        for x = npclist(npcindex).pos.x to npclist(npcindex).pos.x + signoeo * 10 step iif(signoeo = 0, 1, signoeo)
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
               ni = mapdata(npclist(npcindex).pos.map, x, y).npcindex
               if ni > 0 then
                    if npclist(npcindex).targetnpc = ni then
                         bnoesta = true
                         if npclist(npcindex).numero = elementalfuego then
                             call npclanzaunspellsobrenpc(npcindex, ni)
                             if npclist(ni).npctype = dragon then
                                npclist(ni).canattack = 1
                                call npclanzaunspellsobrenpc(ni, npcindex)
                             end if
                         else
                            'aca verificamosss la distancia de ataque
                            if distancia(npclist(npcindex).pos, npclist(ni).pos) <= 1 then
                                call npcatacanpc(npcindex, ni)
                            end if
                         end if
                         exit sub
                    end if
               end if
            end if
        next x
    next y
else
    for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10
        for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10
            if x >= minxborder and x <= maxxborder and y >= minyborder and y <= maxyborder then
               ni = mapdata(npclist(npcindex).pos.map, x, y).npcindex
               if ni > 0 then
                    if npclist(npcindex).targetnpc = ni then
                         bnoesta = true
                         if npclist(npcindex).numero = elementalfuego then
                             call npclanzaunspellsobrenpc(npcindex, ni)
                             if npclist(ni).npctype = dragon then
                                npclist(ni).canattack = 1
                                call npclanzaunspellsobrenpc(ni, npcindex)
                             end if
                         else
                            'aca verificamosss la distancia de ataque
                            if distancia(npclist(npcindex).pos, npclist(ni).pos) <= 1 then
                                call npcatacanpc(npcindex, ni)
                            end if
                         end if
                         if npclist(npcindex).flags.inmovilizado = 1 then exit sub
                         theading = finddirection(npclist(npcindex).pos, npclist(mapdata(npclist(npcindex).pos.map, x, y).npcindex).pos)
                         call movenpcchar(npcindex, theading)
                         exit sub
                    end if
               end if
            end if
        next x
    next y
end if

if not bnoesta then
    if npclist(npcindex).maestrouser > 0 then
        call followamo(npcindex)
    else
        npclist(npcindex).movement = npclist(npcindex).flags.oldmovement
        npclist(npcindex).hostile = npclist(npcindex).flags.oldhostil
    end if
end if
    
end sub

function npcai(byval npcindex as integer)
on error goto errorhandler
        '<<<<<<<<<<< ataques >>>>>>>>>>>>>>>>
        if npclist(npcindex).maestrouser = 0 then
            'busca a alguien para atacar
            '�es un guardia?
            if npclist(npcindex).npctype = npctype_guardias then
                    call guardiasai(npcindex)
            elseif npclist(npcindex).npctype = npctype_guardiascaos then
                    call guardiasai(npcindex, true)
            elseif npclist(npcindex).hostile and npclist(npcindex).stats.alineacion <> 0 then
                    call hostilmalvadoai(npcindex)
            elseif npclist(npcindex).hostile and npclist(npcindex).stats.alineacion = 0 then
                    call hostilbuenoai(npcindex)
            end if
        else
            'evitamos que ataque a su amo, a menos
            'que el amo lo ataque.
            'call hostilbuenoai(npcindex)
        end if
        
        
        
        
        '<<<<<<<<<<<movimiento>>>>>>>>>>>>>>>>
        select case npclist(npcindex).movement
            case mueve_al_azar
                if npclist(npcindex).flags.inmovilizado = 1 then exit function
                if npclist(npcindex).npctype = npctype_guardias then
                    if int(randomnumber(1, 12)) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(1, 4)))
                    end if
                    call persiguecriminal(npcindex)
                elseif npclist(npcindex).npctype = npctype_guardiascaos then
                    if int(randomnumber(1, 12)) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(1, 4)))
                    end if
                    call persigueciudadano(npcindex)
                else
                        if int(randomnumber(1, 12)) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(1, 4)))
                    end if
                end if
            'va hacia el usuario cercano
            case npc_malo_ataca_usuarios_buenos
                call irusuariocercano(npcindex)
            'va hacia el usuario que lo ataco(follow)
            case npcdefensa
                call seguiragresor(npcindex)
            'persigue criminales
            case guardias_atacan_criminales
                call persiguecriminal(npcindex)
            case sigue_amo
                if npclist(npcindex).flags.inmovilizado = 1 then exit function
                call seguiramo(npcindex)
                if int(randomnumber(1, 12)) = 3 then
                        call movenpcchar(npcindex, cbyte(randomnumber(1, 4)))
                end if
            case npc_ataca_npc
                call ainpcatacanpc(npcindex)
            case npc_pathfinding
                if npclist(npcindex).flags.inmovilizado = 1 then exit function
                if recalculatepath(npcindex) then
                    call pathfindingai(npcindex)
                    'existe el camino?
                    if npclist(npcindex).pfinfo.nopath then 'si no existe nos movemos al azar
                        'move randomly
                        call movenpcchar(npcindex, int(randomnumber(1, 4)))
                    end if
                else
                    if not pathend(npcindex) then
                        call followpath(npcindex)
                    else
                        npclist(npcindex).pfinfo.pathlenght = 0
                    end if
                end if

        end select


exit function


errorhandler:
    call logerror("npcai " & npclist(npcindex).name & " " & npclist(npcindex).maestrouser & " " & npclist(npcindex).maestronpc & " mapa:" & npclist(npcindex).pos.map & " x:" & npclist(npcindex).pos.x & " y:" & npclist(npcindex).pos.y & " mov:" & npclist(npcindex).movement & " targu:" & npclist(npcindex).target & " targn:" & npclist(npcindex).targetnpc)
    dim minpc as npc
    minpc = npclist(npcindex)
    call quitarnpc(npcindex)
    call respawnnpc(minpc)
    
end function


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

function simpleai(byval npcindex as integer) as boolean
'#################################################################
'old ore4 ai function
'#################################################################
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer

for y = npclist(npcindex).pos.y - 5 to npclist(npcindex).pos.y + 5    'makes a loop that looks at
    for x = npclist(npcindex).pos.x - 5 to npclist(npcindex).pos.x + 5   '5 tiles in every direction
           'make sure tile is legal
            if x > minxborder and x < maxxborder and y > minyborder and y < maxyborder then
                'look for a user
                if mapdata(npclist(npcindex).pos.map, x, y).userindex > 0 then
                    'move towards user
                    theading = finddirection(npclist(npcindex).pos, userlist(mapdata(npclist(npcindex).pos.map, x, y).userindex).pos)
                    movenpcchar npcindex, theading
                    'leave
                    exit function
                end if
            end if
    next x
next y

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
dim npos as worldpos
dim headingloop as byte
dim theading as byte
dim y as integer
dim x as integer

for y = npclist(npcindex).pos.y - 10 to npclist(npcindex).pos.y + 10    'makes a loop that looks at
     for x = npclist(npcindex).pos.x - 10 to npclist(npcindex).pos.x + 10   '5 tiles in every direction

         'make sure tile is legal
         if x > minxborder and x < maxxborder and y > minyborder and y < maxyborder then
         
             'look for a user
             if mapdata(npclist(npcindex).pos.map, x, y).userindex > 0 then
                 'move towards user
                  dim tmpuserindex as integer
                  tmpuserindex = mapdata(npclist(npcindex).pos.map, x, y).userindex
                  if userlist(tmpuserindex).flags.muerto = 0 and userlist(tmpuserindex).flags.invisible = 0 then
                    'we have to invert the coordinates, this is because
                    'ore refers to maps in converse way of my pathfinding
                    'routines.
                    npclist(npcindex).pfinfo.target.x = userlist(tmpuserindex).pos.y
                    npclist(npcindex).pfinfo.target.y = userlist(tmpuserindex).pos.x 'ops!
                    npclist(npcindex).pfinfo.targetuser = tmpuserindex
                    call seekpath(npcindex)
                    exit function
                  end if
             end if
             
         end if
              
     next x
 next y
end function


sub npclanzaunspell(byval npcindex as integer, byval userindex as integer)

if userlist(userindex).flags.invisible = 1 then exit sub

dim k as integer
k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
call npclanzaspellsobreuser(npcindex, userindex, npclist(npcindex).spells(k))

end sub


sub npclanzaunspellsobrenpc(byval npcindex as integer, byval targetnpc as integer)

dim k as integer
    k = randomnumber(1, npclist(npcindex).flags.lanzaspells)
    call npclanzaspellsobrenpc(npcindex, targetnpc, npclist(npcindex).spells(k))

end sub


