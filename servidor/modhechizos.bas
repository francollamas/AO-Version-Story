attribute vb_name = "modhechizos"
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

public const helemental_fuego as integer = 26
public const helemental_tierra as integer = 28
public const superanillo as integer = 700

sub npclanzaspellsobreuser(byval npcindex as integer, byval userindex as integer, byval spell as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 13/02/2009
'13/02/2009: zama - los npcs que tiren magias, no podran hacerlo en mapas donde no se permita usarla.
'***************************************************
if npclist(npcindex).canattack = 0 then exit sub
if userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1 then exit sub

' si no se peude usar magia en el mapa, no le deja hacerlo.
if mapinfo(userlist(userindex).pos.map).magiasinefecto > 0 then exit sub

npclist(npcindex).canattack = 0
dim da�o as integer

with userlist(userindex)
    if hechizos(spell).subehp = 1 then
    
        da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, .pos.x, .pos.y))
        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
    
        .stats.minhp = .stats.minhp + da�o
        if .stats.minhp > .stats.maxhp then .stats.minhp = .stats.maxhp
        
        call writeconsolemsg(userindex, npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
        call writeupdateuserstats(userindex)
    
    elseif hechizos(spell).subehp = 2 then
        
        if .flags.privilegios and playertype.user then
        
            da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
            
            if .invent.cascoeqpobjindex > 0 then
                da�o = da�o - randomnumber(objdata(.invent.cascoeqpobjindex).defensamagicamin, objdata(.invent.cascoeqpobjindex).defensamagicamax)
            end if
            
            if .invent.anilloeqpobjindex > 0 then
                da�o = da�o - randomnumber(objdata(.invent.anilloeqpobjindex).defensamagicamin, objdata(.invent.anilloeqpobjindex).defensamagicamax)
            end if
            
            if da�o < 0 then da�o = 0
            
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, .pos.x, .pos.y))
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
        
            .stats.minhp = .stats.minhp - da�o
            
            call writeconsolemsg(userindex, npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
            call writeupdateuserstats(userindex)
            
            'muere
            if .stats.minhp < 1 then
                .stats.minhp = 0
                if npclist(npcindex).npctype = enpctype.guardiareal then
                    restarcriminalidad (userindex)
                end if
                call userdie(userindex)
                '[barrin 1-12-03]
                if npclist(npcindex).maestrouser > 0 then
                    'store it!
                    call statistics.storefrag(npclist(npcindex).maestrouser, userindex)
                    
                    call contarmuerte(userindex, npclist(npcindex).maestrouser)
                    call actstats(userindex, npclist(npcindex).maestrouser)
                end if
                '[/barrin]
            end if
        
        end if
        
    end if
    
    if hechizos(spell).paraliza = 1 or hechizos(spell).inmoviliza = 1 then
        if .flags.paralizado = 0 then
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, .pos.x, .pos.y))
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
              
            if .invent.anilloeqpobjindex = superanillo then
                call writeconsolemsg(userindex, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
                exit sub
            end if
            
            if hechizos(spell).inmoviliza = 1 then
                .flags.inmovilizado = 1
            end if
              
            .flags.paralizado = 1
            .counters.paralisis = intervaloparalizado
              
            call writeparalizeok(userindex)
        end if
    end if
    
    if hechizos(spell).estupidez = 1 then   ' turbacion
         if .flags.estupidez = 0 then
              call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, .pos.x, .pos.y))
              call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
              
                if .invent.anilloeqpobjindex = superanillo then
                    call writeconsolemsg(userindex, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
                    exit sub
                end if
              
              .flags.estupidez = 1
              .counters.ceguera = intervaloinvisible
                      
            call writedumb(userindex)
         end if
    end if
end with

end sub

sub npclanzaspellsobrenpc(byval npcindex as integer, byval targetnpc as integer, byval spell as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'solo hechizos ofensivos!

if npclist(npcindex).canattack = 0 then exit sub
npclist(npcindex).canattack = 0

dim da�o as integer

if hechizos(spell).subehp = 2 then
    
    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(sendtarget.tonpcarea, targetnpc, preparemessageplaywave(hechizos(spell).wav, npclist(targetnpc).pos.x, npclist(targetnpc).pos.y))
    call senddata(sendtarget.tonpcarea, targetnpc, preparemessagecreatefx(npclist(targetnpc).char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
    
    npclist(targetnpc).stats.minhp = npclist(targetnpc).stats.minhp - da�o
    
    'muere
    if npclist(targetnpc).stats.minhp < 1 then
        npclist(targetnpc).stats.minhp = 0
        if npclist(npcindex).maestrouser > 0 then
            call muerenpc(targetnpc, npclist(npcindex).maestrouser)
        else
            call muerenpc(targetnpc, 0)
        end if
    end if
    
end if
    
end sub

function tienehechizo(byval i as integer, byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    
    dim j as integer
    for j = 1 to maxuserhechizos
        if userlist(userindex).stats.userhechizos(j) = i then
            tienehechizo = true
            exit function
        end if
    next

exit function
errhandler:

end function

sub agregarhechizo(byval userindex as integer, byval slot as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim hindex as integer
dim j as integer

with userlist(userindex)
    hindex = objdata(.invent.object(slot).objindex).hechizoindex
    
    if not tienehechizo(hindex, userindex) then
        'buscamos un slot vacio
        for j = 1 to maxuserhechizos
            if .stats.userhechizos(j) = 0 then exit for
        next j
            
        if .stats.userhechizos(j) <> 0 then
            call writeconsolemsg(userindex, "no tienes espacio para m�s hechizos.", fonttypenames.fonttype_info)
        else
            .stats.userhechizos(j) = hindex
            call updateuserhechizos(false, userindex, cbyte(j))
            'quitamos del inv el item
            call quitaruserinvitem(userindex, cbyte(slot), 1)
        end if
    else
        call writeconsolemsg(userindex, "ya tienes ese hechizo.", fonttypenames.fonttype_info)
    end if
end with

end sub
            
sub decirpalabrasmagicas(byval spellwords as string, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 17/11/2009
'25/07/2009: zama - invisible admins don't say any word when casting a spell
'17/11/2009: zama - now the user become visible when casting a spell, if it is hidden
'***************************************************
on error resume next
with userlist(userindex)
    if .flags.admininvisible <> 1 then
        call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(spellwords, .char.charindex, vbcyan))
        
        ' si estaba oculto, se vuelve visible
        if .flags.oculto = 1 then
            .flags.oculto = 0
            .counters.tiempooculto = 0
            
            if .flags.invisible = 0 then
                call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
                call setinvisible(userindex, .char.charindex, false)
            end if
        end if
    end if
end with
    exit sub
end sub

''
' check if an user can cast a certain spell
'
' @param userindex specifies reference to user
' @param hechizoindex specifies reference to spell
' @return   true if the user can cast the spell, otherwise returns false
function puedelanzar(byval userindex as integer, byval hechizoindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 12/01/2010
'last modification by: zama
'06/11/09 - corregida la bonificaci�n de man� del mimetismo en el druida con flauta m�gica equipada.
'19/11/2009: zama - validacion de mana para el invocar mascotas
'12/01/2010: zama - validacion de mana para hechizos lanzados por druida.
'***************************************************
dim druidmanabonus as single

    with userlist(userindex)
        if .flags.muerto then
            call writeconsolemsg(userindex, "no puedes lanzar hechizos estando muerto.", fonttypenames.fonttype_info)
            exit function
        end if
            
        if hechizos(hechizoindex).needstaff > 0 then
            if .clase = eclass.mage then
                if .invent.weaponeqpobjindex > 0 then
                    if objdata(.invent.weaponeqpobjindex).staffpower < hechizos(hechizoindex).needstaff then
                        call writeconsolemsg(userindex, "no posees un b�culo lo suficientemente poderoso para poder lanzar el conjuro.", fonttypenames.fonttype_info)
                        exit function
                    end if
                else
                    call writeconsolemsg(userindex, "no puedes lanzar este conjuro sin la ayuda de un b�culo.", fonttypenames.fonttype_info)
                    exit function
                end if
            end if
        end if
            
        if .stats.userskills(eskill.magia) < hechizos(hechizoindex).minskill then
            call writeconsolemsg(userindex, "no tienes suficientes puntos de magia para lanzar este hechizo.", fonttypenames.fonttype_info)
            exit function
        end if
        
        if .stats.minsta < hechizos(hechizoindex).starequerido then
            if .genero = egenero.hombre then
                call writeconsolemsg(userindex, "est�s muy cansado para lanzar este hechizo.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "est�s muy cansada para lanzar este hechizo.", fonttypenames.fonttype_info)
            end if
            exit function
        end if
    
        druidmanabonus = 1
        if .clase = eclass.druid then
            if .invent.anilloeqpobjindex = flautaelfica then
                ' 50% menos de mana requerido para mimetismo
                if hechizos(hechizoindex).mimetiza = 1 then
                    druidmanabonus = 0.5
                    
                ' 30% menos de mana requerido para invocaciones
                elseif hechizos(hechizoindex).tipo = uinvocacion then
                    druidmanabonus = 0.7
                
                ' 10% menos de mana requerido para las demas magias, excepto apoca
                elseif hechizoindex <> apocalipsis_spell_index then
                    druidmanabonus = 0.9
                end if
            end if
            
            ' necesita tener la barra de mana completa para invocar una mascota
            if hechizos(hechizoindex).warp = 1 then
                if .stats.minman <> .stats.maxman then
                    call writeconsolemsg(userindex, "debes poseer toda tu man� para poder lanzar este hechizo.", fonttypenames.fonttype_info)
                    exit function
                ' si no tiene mascotas, no tiene sentido que lo use
                elseif .nromascotas = 0 then
                    call writeconsolemsg(userindex, "debes poseer alguna mascota para poder lanzar este hechizo.", fonttypenames.fonttype_info)
                    exit function
                end if
            end if
        end if
        
        if .stats.minman < hechizos(hechizoindex).manarequerido * druidmanabonus then
            call writeconsolemsg(userindex, "no tienes suficiente man�.", fonttypenames.fonttype_info)
            exit function
        end if
        
    end with
    
    puedelanzar = true
end function

sub hechizoterrenoestado(byval userindex as integer, byref b as boolean)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim poscasteadax as integer
dim poscasteaday as integer
dim poscasteadam as integer
dim h as integer
dim tempx as integer
dim tempy as integer

    with userlist(userindex)
        poscasteadax = .flags.targetx
        poscasteaday = .flags.targety
        poscasteadam = .flags.targetmap
        
        h = .flags.hechizo
        
        if hechizos(h).remueveinvisibilidadparcial = 1 then
            b = true
            for tempx = poscasteadax - 8 to poscasteadax + 8
                for tempy = poscasteaday - 8 to poscasteaday + 8
                    if inmapbounds(poscasteadam, tempx, tempy) then
                        if mapdata(poscasteadam, tempx, tempy).userindex > 0 then
                            'hay un user
                            if userlist(mapdata(poscasteadam, tempx, tempy).userindex).flags.invisible = 1 and userlist(mapdata(poscasteadam, tempx, tempy).userindex).flags.admininvisible = 0 then
                                call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(mapdata(poscasteadam, tempx, tempy).userindex).char.charindex, hechizos(h).fxgrh, hechizos(h).loops))
                            end if
                        end if
                    end if
                next tempy
            next tempx
        
            call infohechizo(userindex)
        end if
    end with
end sub

''
' le da propiedades al nuevo npc
'
' @param userindex  indice del usuario que invoca.
' @param b  indica si se termino la operaci�n.

sub hechizoinvocacion(byval userindex as integer, byref hechizocasteado as boolean)
'***************************************************
'author: uknown
'last modification: 18/11/2009
'sale del sub si no hay una posici�n valida.
'18/11/2009: optimizacion de codigo.
'***************************************************

on error goto error

with userlist(userindex)
    'no permitimos se invoquen criaturas en zonas seguras
    if mapinfo(.pos.map).pk = false or mapdata(.pos.map, .pos.x, .pos.y).trigger = etrigger.zonasegura then
        call writeconsolemsg(userindex, "no puedes invocar criaturas en zona segura.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    dim spellindex as integer, nronpcs as integer, npcindex as integer, petindex as integer
    dim targetpos as worldpos
    
    
    targetpos.map = .flags.targetmap
    targetpos.x = .flags.targetx
    targetpos.y = .flags.targety
    
    spellindex = .flags.hechizo
    
    ' warp de mascotas
    if hechizos(spellindex).warp = 1 then
        petindex = farthestpet(userindex)
        
        ' la invoco cerca mio
        if petindex > 0 then
            call warpmascota(userindex, petindex)
        end if
        
    ' invocacion normal
    else
        if .nromascotas >= maxmascotas then exit sub
        
        for nronpcs = 1 to hechizos(spellindex).cant
            
            if .nromascotas < maxmascotas then
                npcindex = spawnnpc(hechizos(spellindex).numnpc, targetpos, true, false)
                if npcindex > 0 then
                    .nromascotas = .nromascotas + 1
                    
                    petindex = freemascotaindex(userindex)
                    
                    .mascotasindex(petindex) = npcindex
                    .mascotastype(petindex) = npclist(npcindex).numero
                    
                    with npclist(npcindex)
                        .maestrouser = userindex
                        .contadores.tiempoexistencia = intervaloinvocacion
                        .givegld = 0
                    end with
                    
                    call followamo(npcindex)
                else
                    exit sub
                end if
            else
                exit for
            end if
        
        next nronpcs
    end if
end with

call infohechizo(userindex)
hechizocasteado = true

exit sub

error:
    with userlist(userindex)
        logerror ("[" & err.number & "] " & err.description & " por el usuario " & .name & "(" & userindex & _
                ") en (" & .pos.map & ", " & .pos.x & ", " & .pos.y & "). tratando de tirar el hechizo " & _
                hechizos(spellindex).nombre & "(" & spellindex & ") en la posicion ( " & .flags.targetx & ", " & .flags.targety & ")")
    end with

end sub

sub handlehechizoterreno(byval userindex as integer, byval spellindex as integer)
'***************************************************
'author: unknown
'last modification: 18/11/2009
'18/11/2009: zama - optimizacion de codigo.
'***************************************************
    
    dim hechizocasteado as boolean
    dim manarequerida as integer
    
    select case hechizos(spellindex).tipo
        case tipohechizo.uinvocacion
            call hechizoinvocacion(userindex, hechizocasteado)
            
        case tipohechizo.uestado
            call hechizoterrenoestado(userindex, hechizocasteado)
    end select

    if hechizocasteado then
        with userlist(userindex)
            call subirskill(userindex, eskill.magia, true)
            
            manarequerida = hechizos(spellindex).manarequerido
            
            if hechizos(spellindex).warp = 1 then ' invoc� una mascota
            ' consume toda la mana
                manarequerida = .stats.minman
            else
                ' bonificaciones en hechizos
                if .clase = eclass.druid then
                    ' solo con flauta equipada
                    if .invent.anilloeqpobjindex = flautaelfica then
                        ' 30% menos de mana para invocaciones
                        manarequerida = manarequerida * 0.7
                    end if
                end if
            end if
            
            ' quito la mana requerida
            .stats.minman = .stats.minman - manarequerida
            if .stats.minman < 0 then .stats.minman = 0
            
            ' quito la estamina requerida
            .stats.minsta = .stats.minsta - hechizos(spellindex).starequerido
            if .stats.minsta < 0 then .stats.minsta = 0
            
            ' update user stats
            call writeupdateuserstats(userindex)
        end with
    end if
    
end sub

sub handlehechizousuario(byval userindex as integer, byval spellindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/2010
'18/11/2009: zama - optimizacion de codigo.
'12/01/2010: zama - optimizacion y agrego bonificaciones al druida.
'***************************************************
    
    dim hechizocasteado as boolean
    dim manarequerida as integer
    
    select case hechizos(spellindex).tipo
        case tipohechizo.uestado
            ' afectan estados (por ejem : envenenamiento)
            call hechizoestadousuario(userindex, hechizocasteado)
        
        case tipohechizo.upropiedades
            ' afectan hp,mana,stamina,etc
            hechizocasteado = hechizopropusuario(userindex)
    end select

    if hechizocasteado then
        with userlist(userindex)
            call subirskill(userindex, eskill.magia, true)
            
            manarequerida = hechizos(spellindex).manarequerido
            
            ' bonificaciones para druida
            if .clase = eclass.druid then
                ' solo con flauta magica
                if .invent.anilloeqpobjindex = flautaelfica then
                    if hechizos(spellindex).mimetiza = 1 then
                        ' 50% menos de mana para mimetismo
                        manarequerida = manarequerida * 0.5
                        
                    elseif spellindex <> apocalipsis_spell_index then
                        ' 10% menos de mana para todo menos apoca y descarga
                        manarequerida = manarequerida * 0.9
                    end if
                end if
            end if
            
            ' quito la mana requerida
            .stats.minman = .stats.minman - manarequerida
            if .stats.minman < 0 then .stats.minman = 0
            
            ' quito la estamina requerida
            .stats.minsta = .stats.minsta - hechizos(spellindex).starequerido
            if .stats.minsta < 0 then .stats.minsta = 0
            
            ' update user stats
            call writeupdateuserstats(userindex)
            call writeupdateuserstats(.flags.targetuser)
            .flags.targetuser = 0
        end with
    end if

end sub

sub handlehechizonpc(byval userindex as integer, byval hechizoindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/2010
'13/02/2009: zama - agregada 50% bonificacion en coste de mana a mimetismo para druidas
'17/11/2009: zama - optimizacion de codigo.
'12/01/2010: zama - bonificacion para druidas de 10% para todos hechizos excepto apoca y descarga.
'12/01/2010: zama - los druidas mimetizados con npcs ahora son ignorados.
'***************************************************
    dim hechizocasteado as boolean
    dim manarequerida as long
    
    with userlist(userindex)
        select case hechizos(hechizoindex).tipo
            case tipohechizo.uestado
                ' afectan estados (por ejem : envenenamiento)
                call hechizoestadonpc(.flags.targetnpc, hechizoindex, hechizocasteado, userindex)
                
            case tipohechizo.upropiedades
                ' afectan hp,mana,stamina,etc
                call hechizopropnpc(hechizoindex, .flags.targetnpc, userindex, hechizocasteado)
        end select
        
        
        if hechizocasteado then
            call subirskill(userindex, eskill.magia, true)
            
            manarequerida = hechizos(hechizoindex).manarequerido
            
            ' bonificaci�n para druidas.
            if .clase = eclass.druid then
                ' se mostr� como usuario, puede ser atacado por npcs
                .flags.ignorado = false
                
                ' solo con flauta equipada
                if .invent.anilloeqpobjindex = flautaelfica then
                    if hechizos(hechizoindex).mimetiza = 1 then
                        ' 50% menos de mana para mimetismo
                        manarequerida = manarequerida * 0.5
                        ' ser� ignorado hasta que pierda el efecto del mimetismo o ataque un npc
                        .flags.ignorado = true
                    else
                        ' 10% menos de mana para hechizos
                        if hechizoindex <> apocalipsis_spell_index then
                             manarequerida = manarequerida * 0.9
                        end if
                    end if
                end if
            end if
            
            ' quito la mana requerida
            .stats.minman = .stats.minman - manarequerida
            if .stats.minman < 0 then .stats.minman = 0
            
            ' quito la estamina requerida
            .stats.minsta = .stats.minsta - hechizos(hechizoindex).starequerido
            if .stats.minsta < 0 then .stats.minsta = 0
            
            ' update user stats
            call writeupdateuserstats(userindex)
            .flags.targetnpc = 0
        end if
    end with
end sub


sub lanzarhechizo(byval spellindex as integer, byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 02/16/2010
'24/01/2007 zama - optimizacion de codigo.
'02/16/2010: marco - now .flags.hechizo makes reference to global spell index instead of user's spell index
'***************************************************
on error goto errhandler

with userlist(userindex)
    
    if .flags.enconsulta then
        call writeconsolemsg(userindex, "no puedes lanzar hechizos si est�s en consulta.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if puedelanzar(userindex, spellindex) then
        select case hechizos(spellindex).target
            case targettype.uusuarios
                if .flags.targetuser > 0 then
                    if abs(userlist(.flags.targetuser).pos.y - .pos.y) <= rango_vision_y then
                        call handlehechizousuario(userindex, spellindex)
                    else
                        call writeconsolemsg(userindex, "est�s demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                    end if
                else
                    call writeconsolemsg(userindex, "este hechizo act�a s�lo sobre usuarios.", fonttypenames.fonttype_info)
                end if
            
            case targettype.unpc
                if .flags.targetnpc > 0 then
                    if abs(npclist(.flags.targetnpc).pos.y - .pos.y) <= rango_vision_y then
                        call handlehechizonpc(userindex, spellindex)
                    else
                        call writeconsolemsg(userindex, "est�s demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                    end if
                else
                    call writeconsolemsg(userindex, "este hechizo s�lo afecta a los npcs.", fonttypenames.fonttype_info)
                end if
            
            case targettype.uusuariosynpc
                if .flags.targetuser > 0 then
                    if abs(userlist(.flags.targetuser).pos.y - .pos.y) <= rango_vision_y then
                        call handlehechizousuario(userindex, spellindex)
                    else
                        call writeconsolemsg(userindex, "est�s demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                    end if
                elseif .flags.targetnpc > 0 then
                    if abs(npclist(.flags.targetnpc).pos.y - .pos.y) <= rango_vision_y then
                        call handlehechizonpc(userindex, spellindex)
                    else
                        call writeconsolemsg(userindex, "est�s demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                    end if
                else
                    call writeconsolemsg(userindex, "target inv�lido.", fonttypenames.fonttype_info)
                end if
            
            case targettype.uterreno
                call handlehechizoterreno(userindex, spellindex)
        end select
        
    end if
    
    if .counters.trabajando then _
        .counters.trabajando = .counters.trabajando - 1
    
    if .counters.ocultando then _
        .counters.ocultando = .counters.ocultando - 1

end with

exit sub

errhandler:
    call logerror("error en lanzarhechizo. error " & err.number & " : " & err.description & _
        " hechizo: " & hechizos(spellindex).nombre & "(" & spellindex & _
        "). casteado por: " & userlist(userindex).name & "(" & userindex & ").")
    
end sub

sub hechizoestadousuario(byval userindex as integer, byref hechizocasteado as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 28/04/2010
'handles the spells that afect the stats of an user
'24/01/2007 pablo (toxicwaste) - invisibilidad no permitida en mapas con invisinefecto
'26/01/2007 pablo (toxicwaste) - cambios que permiten mejor manejo de ataques en los rings.
'26/01/2007 pablo (toxicwaste) - revivir no permitido en mapas con resusinefecto
'02/01/2008 marcos (byval) - curar veneno no permitido en usuarios muertos.
'06/28/2008 niconz - agregu� que se le de valor al flag inmovilizado.
'17/11/2008: niconz - agregado para quitar la penalizaci�n de vida en el ring y cambio de ecuacion.
'13/02/2009: zama - arreglada ecuacion para quitar vida tras resucitar en rings.
'23/11/2009: zama - optimizacion de codigo.
'28/04/2010: zama - agrego restricciones para ciudas respecto al estado atacable.
'***************************************************


dim hechizoindex as integer
dim targetindex as integer

with userlist(userindex)
    hechizoindex = .flags.hechizo
    targetindex = .flags.targetuser
    
    ' <-------- agrega invisibilidad ---------->
    if hechizos(hechizoindex).invisibilidad = 1 then
        if userlist(targetindex).flags.muerto = 1 then
            call writeconsolemsg(userindex, "�el usuario est� muerto!", fonttypenames.fonttype_info)
            hechizocasteado = false
            exit sub
        end if
        
        if userlist(targetindex).counters.saliendo then
            if userindex <> targetindex then
                call writeconsolemsg(userindex, "�el hechizo no tiene efecto!", fonttypenames.fonttype_info)
                hechizocasteado = false
                exit sub
            else
                call writeconsolemsg(userindex, "�no puedes hacerte invisible mientras te encuentras saliendo!", fonttypenames.fonttype_warning)
                hechizocasteado = false
                exit sub
            end if
        end if
        
        'no usar invi mapas invisinefecto
        if mapinfo(userlist(targetindex).pos.map).invisinefecto > 0 then
            call writeconsolemsg(userindex, "�la invisibilidad no funciona aqu�!", fonttypenames.fonttype_info)
            hechizocasteado = false
            exit sub
        end if
        
        ' chequea si el status permite ayudar al otro usuario
        hechizocasteado = cansupportuser(userindex, targetindex, true)
        if not hechizocasteado then exit sub
        
        'si sos user, no uses este hechizo con gms.
        if .flags.privilegios and playertype.user then
            if not userlist(targetindex).flags.privilegios and playertype.user then
                hechizocasteado = false
                exit sub
            end if
        end if
       
        userlist(targetindex).flags.invisible = 1
        call setinvisible(targetindex, userlist(targetindex).char.charindex, true)
    
        call infohechizo(userindex)
        hechizocasteado = true
    end if
    
    ' <-------- agrega mimetismo ---------->
    if hechizos(hechizoindex).mimetiza = 1 then
        if userlist(targetindex).flags.muerto = 1 then
            exit sub
        end if
        
        if userlist(targetindex).flags.navegando = 1 then
            exit sub
        end if
        if .flags.navegando = 1 then
            exit sub
        end if
        
        'si sos user, no uses este hechizo con gms.
        if .flags.privilegios and playertype.user then
            if not userlist(targetindex).flags.privilegios and playertype.user then
                exit sub
            end if
        end if
        
        if .flags.mimetizado = 1 then
            call writeconsolemsg(userindex, "ya te encuentras mimetizado. el hechizo no ha tenido efecto.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if .flags.admininvisible = 1 then exit sub
        
        'copio el char original al mimetizado
        
        .charmimetizado.body = .char.body
        .charmimetizado.head = .char.head
        .charmimetizado.cascoanim = .char.cascoanim
        .charmimetizado.shieldanim = .char.shieldanim
        .charmimetizado.weaponanim = .char.weaponanim
        
        .flags.mimetizado = 1
        
        'ahora pongo local el del enemigo
        .char.body = userlist(targetindex).char.body
        .char.head = userlist(targetindex).char.head
        .char.cascoanim = userlist(targetindex).char.cascoanim
        .char.shieldanim = userlist(targetindex).char.shieldanim
        .char.weaponanim = getweaponanim(userindex, userlist(targetindex).invent.weaponeqpobjindex)
        
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
       
       call infohechizo(userindex)
       hechizocasteado = true
    end if
    
    ' <-------- agrega envenenamiento ---------->
    if hechizos(hechizoindex).envenena = 1 then
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
        if not puedeatacar(userindex, targetindex) then exit sub
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        userlist(targetindex).flags.envenenado = 1
        call infohechizo(userindex)
        hechizocasteado = true
    end if
    
    ' <-------- cura envenenamiento ---------->
    if hechizos(hechizoindex).curaveneno = 1 then
    
        'verificamos que el usuario no este muerto
        if userlist(targetindex).flags.muerto = 1 then
            call writeconsolemsg(userindex, "�el usuario est� muerto!", fonttypenames.fonttype_info)
            hechizocasteado = false
            exit sub
        end if
        
        ' chequea si el status permite ayudar al otro usuario
        hechizocasteado = cansupportuser(userindex, targetindex)
        if not hechizocasteado then exit sub
            
        'si sos user, no uses este hechizo con gms.
        if .flags.privilegios and playertype.user then
            if not userlist(targetindex).flags.privilegios and playertype.user then
                exit sub
            end if
        end if
            
        userlist(targetindex).flags.envenenado = 0
        call infohechizo(userindex)
        hechizocasteado = true
    end if
    
    ' <-------- agrega maldicion ---------->
    if hechizos(hechizoindex).maldicion = 1 then
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
        if not puedeatacar(userindex, targetindex) then exit sub
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        userlist(targetindex).flags.maldicion = 1
        call infohechizo(userindex)
        hechizocasteado = true
    end if
    
    ' <-------- remueve maldicion ---------->
    if hechizos(hechizoindex).removermaldicion = 1 then
            userlist(targetindex).flags.maldicion = 0
            call infohechizo(userindex)
            hechizocasteado = true
    end if
    
    ' <-------- agrega bendicion ---------->
    if hechizos(hechizoindex).bendicion = 1 then
            userlist(targetindex).flags.bendicion = 1
            call infohechizo(userindex)
            hechizocasteado = true
    end if
    
    ' <-------- agrega paralisis/inmobilidad ---------->
    if hechizos(hechizoindex).paraliza = 1 or hechizos(hechizoindex).inmoviliza = 1 then
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
         if userlist(targetindex).flags.paralizado = 0 then
            if not puedeatacar(userindex, targetindex) then exit sub
            
            if userindex <> targetindex then
                call usuarioatacadoporusuario(userindex, targetindex)
            end if
            
            call infohechizo(userindex)
            hechizocasteado = true
            if userlist(targetindex).invent.anilloeqpobjindex = superanillo then
                call writeconsolemsg(targetindex, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
                call writeconsolemsg(userindex, " �el hechizo no tiene efecto!", fonttypenames.fonttype_fight)
                call flushbuffer(targetindex)
                exit sub
            end if
            
            if hechizos(hechizoindex).inmoviliza = 1 then userlist(targetindex).flags.inmovilizado = 1
            userlist(targetindex).flags.paralizado = 1
            userlist(targetindex).counters.paralisis = intervaloparalizado
            
            call writeparalizeok(targetindex)
            call flushbuffer(targetindex)
        end if
    end if
    
    ' <-------- remueve paralisis/inmobilidad ---------->
    if hechizos(hechizoindex).removerparalisis = 1 then
        
        ' remueve si esta en ese estado
        if userlist(targetindex).flags.paralizado = 1 then
        
            ' chequea si el status permite ayudar al otro usuario
            hechizocasteado = cansupportuser(userindex, targetindex, true)
            if not hechizocasteado then exit sub
            
            userlist(targetindex).flags.inmovilizado = 0
            userlist(targetindex).flags.paralizado = 0
            
            'no need to crypt this
            call writeparalizeok(targetindex)
            call infohechizo(userindex)
        
        end if
    end if
    
    ' <-------- remueve estupidez (aturdimiento) ---------->
    if hechizos(hechizoindex).removerestupidez = 1 then
    
        ' remueve si esta en ese estado
        if userlist(targetindex).flags.estupidez = 1 then
        
            ' chequea si el status permite ayudar al otro usuario
            hechizocasteado = cansupportuser(userindex, targetindex)
            if not hechizocasteado then exit sub
        
            userlist(targetindex).flags.estupidez = 0
            
            'no need to crypt this
            call writedumbnomore(targetindex)
            call flushbuffer(targetindex)
            call infohechizo(userindex)
        
        end if
    end if
    
    ' <-------- revive ---------->
    if hechizos(hechizoindex).revivir = 1 then
        if userlist(targetindex).flags.muerto = 1 then
            
            'seguro de resurreccion (solo afecta a los hechizos, no al sacerdote ni al comando de gm)
            if userlist(targetindex).flags.seguroresu then
                call writeconsolemsg(userindex, "�el esp�ritu no tiene intenciones de regresar al mundo de los vivos!", fonttypenames.fonttype_info)
                hechizocasteado = false
                exit sub
            end if
        
            'no usar resu en mapas con resusinefecto
            if mapinfo(userlist(targetindex).pos.map).resusinefecto > 0 then
                call writeconsolemsg(userindex, "�revivir no est� permitido aqu�! retirate de la zona si deseas utilizar el hechizo.", fonttypenames.fonttype_info)
                hechizocasteado = false
                exit sub
            end if
            
            'no podemos resucitar si nuestra barra de energ�a no est� llena. (gd: 29/04/07)
            if .stats.maxsta <> .stats.minsta then
                call writeconsolemsg(userindex, "no puedes resucitar si no tienes tu barra de energ�a llena.", fonttypenames.fonttype_info)
                hechizocasteado = false
                exit sub
            end if
            
            
            
            'revisamos si necesita vara
            if .clase = eclass.mage then
                if .invent.weaponeqpobjindex > 0 then
                    if objdata(.invent.weaponeqpobjindex).staffpower < hechizos(hechizoindex).needstaff then
                        call writeconsolemsg(userindex, "necesitas un b�culo mejor para lanzar este hechizo.", fonttypenames.fonttype_info)
                        hechizocasteado = false
                        exit sub
                    end if
                end if
            elseif .clase = eclass.bard then
                if .invent.anilloeqpobjindex <> laudelfico and .invent.anilloeqpobjindex <> laudmagico then
                    call writeconsolemsg(userindex, "necesitas un instrumento m�gico para devolver la vida.", fonttypenames.fonttype_info)
                    hechizocasteado = false
                    exit sub
                end if
            elseif .clase = eclass.druid then
                if .invent.anilloeqpobjindex <> flautaelfica and .invent.anilloeqpobjindex <> flautamagica then
                    call writeconsolemsg(userindex, "necesitas un instrumento m�gico para devolver la vida.", fonttypenames.fonttype_info)
                    hechizocasteado = false
                    exit sub
                end if
            end if
            
            ' chequea si el status permite ayudar al otro usuario
            hechizocasteado = cansupportuser(userindex, targetindex, true)
            if not hechizocasteado then exit sub
    
            dim eracriminal as boolean
            eracriminal = criminal(userindex)
            
            if not criminal(targetindex) then
                if targetindex <> userindex then
                    .reputacion.noblerep = .reputacion.noblerep + 500
                    if .reputacion.noblerep > maxrep then _
                        .reputacion.noblerep = maxrep
                    call writeconsolemsg(userindex, "�los dioses te sonr�en, has ganado 500 puntos de nobleza!", fonttypenames.fonttype_info)
                end if
            end if
            
            if eracriminal and not criminal(userindex) then
                call refreshcharstatus(userindex)
            end if
            
            with userlist(targetindex)
                'pablo toxic waste (gd: 29/04/07)
                .stats.minagu = 0
                .flags.sed = 1
                .stats.minham = 0
                .flags.hambre = 1
                call writeupdatehungerandthirst(targetindex)
                call infohechizo(userindex)
                .stats.minman = 0
                .stats.minsta = 0
            end with
            
            'agregado para quitar la penalizaci�n de vida en el ring y cambio de ecuacion. (niconz)
            if (triggerzonapelea(userindex, targetindex) <> trigger6_permite) then
                'solo saco vida si es user. no quiero que exploten gms por ahi.
                if .flags.privilegios and playertype.user then
                    .stats.minhp = .stats.minhp * (1 - userlist(targetindex).stats.elv * 0.015)
                end if
            end if
            
            if (.stats.minhp <= 0) then
                call userdie(userindex)
                call writeconsolemsg(userindex, "el esfuerzo de resucitar fue demasiado grande.", fonttypenames.fonttype_info)
                hechizocasteado = false
            else
                call writeconsolemsg(userindex, "el esfuerzo de resucitar te ha debilitado.", fonttypenames.fonttype_info)
                hechizocasteado = true
            end if
            
            if userlist(targetindex).flags.traveling = 1 then
                userlist(targetindex).counters.gohome = 0
                userlist(targetindex).flags.traveling = 0
                'call writeconsolemsg(targetindex, "tu viaje ha sido cancelado.", fonttypenames.fonttype_fight)
                call writemultimessage(targetindex, emessages.cancelhome)
            end if
            
            call revivirusuario(targetindex)
        else
            hechizocasteado = false
        end if
    
    end if
    
    ' <-------- agrega ceguera ---------->
    if hechizos(hechizoindex).ceguera = 1 then
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
            if not puedeatacar(userindex, targetindex) then exit sub
            if userindex <> targetindex then
                call usuarioatacadoporusuario(userindex, targetindex)
            end if
            userlist(targetindex).flags.ceguera = 1
            userlist(targetindex).counters.ceguera = intervaloparalizado / 3
    
            call writeblind(targetindex)
            call flushbuffer(targetindex)
            call infohechizo(userindex)
            hechizocasteado = true
    end if
    
    ' <-------- agrega estupidez (aturdimiento) ---------->
    if hechizos(hechizoindex).estupidez = 1 then
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit sub
        end if
            if not puedeatacar(userindex, targetindex) then exit sub
            if userindex <> targetindex then
                call usuarioatacadoporusuario(userindex, targetindex)
            end if
            if userlist(targetindex).flags.estupidez = 0 then
                userlist(targetindex).flags.estupidez = 1
                userlist(targetindex).counters.ceguera = intervaloparalizado
            end if
            call writedumb(targetindex)
            call flushbuffer(targetindex)
    
            call infohechizo(userindex)
            hechizocasteado = true
    end if
end with

end sub

sub hechizoestadonpc(byval npcindex as integer, byval spellindex as integer, byref hechizocasteado as boolean, byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 07/07/2008
'handles the spells that afect the stats of an npc
'04/13/2008 niconz - guardias faccionarios pueden ser
'removidos por users de su misma faccion.
'07/07/2008: niconz - solo se puede mimetizar con npcs si es druida
'***************************************************

with npclist(npcindex)
    if hechizos(spellindex).invisibilidad = 1 then
        call infohechizo(userindex)
        .flags.invisible = 1
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).envenena = 1 then
        if not puedeatacarnpc(userindex, npcindex) then
            hechizocasteado = false
            exit sub
        end if
        call npcatacado(npcindex, userindex)
        call infohechizo(userindex)
        .flags.envenenado = 1
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).curaveneno = 1 then
        call infohechizo(userindex)
        .flags.envenenado = 0
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).maldicion = 1 then
        if not puedeatacarnpc(userindex, npcindex) then
            hechizocasteado = false
            exit sub
        end if
        call npcatacado(npcindex, userindex)
        call infohechizo(userindex)
        .flags.maldicion = 1
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).removermaldicion = 1 then
        call infohechizo(userindex)
        .flags.maldicion = 0
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).bendicion = 1 then
        call infohechizo(userindex)
        .flags.bendicion = 1
        hechizocasteado = true
    end if
    
    if hechizos(spellindex).paraliza = 1 then
        if .flags.afectaparalisis = 0 then
            if not puedeatacarnpc(userindex, npcindex, true) then
                hechizocasteado = false
                exit sub
            end if
            call npcatacado(npcindex, userindex)
            call infohechizo(userindex)
            .flags.paralizado = 1
            .flags.inmovilizado = 0
            .contadores.paralisis = intervaloparalizado
            hechizocasteado = true
        else
            call writeconsolemsg(userindex, "el npc es inmune a este hechizo.", fonttypenames.fonttype_info)
            hechizocasteado = false
            exit sub
        end if
    end if
    
    if hechizos(spellindex).removerparalisis = 1 then
        if .flags.paralizado = 1 or .flags.inmovilizado = 1 then
            if .maestrouser = userindex then
                call infohechizo(userindex)
                .flags.paralizado = 0
                .contadores.paralisis = 0
                hechizocasteado = true
            else
                if .npctype = enpctype.guardiareal then
                    if esarmada(userindex) then
                        call infohechizo(userindex)
                        .flags.paralizado = 0
                        .contadores.paralisis = 0
                        hechizocasteado = true
                        exit sub
                    else
                        call writeconsolemsg(userindex, "s�lo puedes remover la par�lisis de los guardias si perteneces a su facci�n.", fonttypenames.fonttype_info)
                        hechizocasteado = false
                        exit sub
                    end if
                    
                    call writeconsolemsg(userindex, "solo puedes remover la par�lisis de los npcs que te consideren su amo.", fonttypenames.fonttype_info)
                    hechizocasteado = false
                    exit sub
                else
                    if .npctype = enpctype.guardiascaos then
                        if escaos(userindex) then
                            call infohechizo(userindex)
                            .flags.paralizado = 0
                            .contadores.paralisis = 0
                            hechizocasteado = true
                            exit sub
                        else
                            call writeconsolemsg(userindex, "solo puedes remover la par�lisis de los guardias si perteneces a su facci�n.", fonttypenames.fonttype_info)
                            hechizocasteado = false
                            exit sub
                        end if
                    end if
                end if
            end if
       else
          call writeconsolemsg(userindex, "este npc no est� paralizado", fonttypenames.fonttype_info)
          hechizocasteado = false
          exit sub
       end if
    end if
     
    if hechizos(spellindex).inmoviliza = 1 then
        if .flags.afectaparalisis = 0 then
            if not puedeatacarnpc(userindex, npcindex, true) then
                hechizocasteado = false
                exit sub
            end if
            call npcatacado(npcindex, userindex)
            .flags.inmovilizado = 1
            .flags.paralizado = 0
            .contadores.paralisis = intervaloparalizado
            call infohechizo(userindex)
            hechizocasteado = true
        else
            call writeconsolemsg(userindex, "el npc es inmune al hechizo.", fonttypenames.fonttype_info)
        end if
    end if
end with

if hechizos(spellindex).mimetiza = 1 then
    with userlist(userindex)
        if .flags.mimetizado = 1 then
            call writeconsolemsg(userindex, "ya te encuentras mimetizado. el hechizo no ha tenido efecto.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if .flags.admininvisible = 1 then exit sub
        
            
        if .clase = eclass.druid then
            'copio el char original al mimetizado
            
            .charmimetizado.body = .char.body
            .charmimetizado.head = .char.head
            .charmimetizado.cascoanim = .char.cascoanim
            .charmimetizado.shieldanim = .char.shieldanim
            .charmimetizado.weaponanim = .char.weaponanim
            
            .flags.mimetizado = 1
            
            'ahora pongo lo del npc.
            .char.body = npclist(npcindex).char.body
            .char.head = npclist(npcindex).char.head
            .char.cascoanim = ninguncasco
            .char.shieldanim = ningunescudo
            .char.weaponanim = ningunarma
        
            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
            
        else
            call writeconsolemsg(userindex, "s�lo los druidas pueden mimetizarse con criaturas.", fonttypenames.fonttype_info)
            exit sub
        end if
    
       call infohechizo(userindex)
       hechizocasteado = true
    end with
end if

end sub

sub hechizopropnpc(byval spellindex as integer, byval npcindex as integer, byval userindex as integer, byref hechizocasteado as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 14/08/2007
'handles the spells that afect the life npc
'14/08/2007 pablo (toxicwaste) - orden general.
'***************************************************

dim da�o as long

with npclist(npcindex)
    'salud
    if hechizos(spellindex).subehp = 1 then
        da�o = randomnumber(hechizos(spellindex).minhp, hechizos(spellindex).maxhp)
        da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
        
        call infohechizo(userindex)
        .stats.minhp = .stats.minhp + da�o
        if .stats.minhp > .stats.maxhp then _
            .stats.minhp = .stats.maxhp
        call writeconsolemsg(userindex, "has curado " & da�o & " puntos de vida a la criatura.", fonttypenames.fonttype_fight)
        hechizocasteado = true
        
    elseif hechizos(spellindex).subehp = 2 then
        if not puedeatacarnpc(userindex, npcindex) then
            hechizocasteado = false
            exit sub
        end if
        call npcatacado(npcindex, userindex)
        da�o = randomnumber(hechizos(spellindex).minhp, hechizos(spellindex).maxhp)
        da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
        if hechizos(spellindex).staffaffected then
            if userlist(userindex).clase = eclass.mage then
                if userlist(userindex).invent.weaponeqpobjindex > 0 then
                    da�o = (da�o * (objdata(userlist(userindex).invent.weaponeqpobjindex).staffdamagebonus + 70)) / 100
                    'aumenta da�o segun el staff-
                    'da�o = (da�o* (70 + bonifb�culo)) / 100
                else
                    da�o = da�o * 0.7 'baja da�o a 70% del original
                end if
            end if
        end if
        if userlist(userindex).invent.anilloeqpobjindex = laudelfico or userlist(userindex).invent.anilloeqpobjindex = flautaelfica then
            da�o = da�o * 1.04  'laud magico de los bardos
        end if
    
        call infohechizo(userindex)
        hechizocasteado = true
        
        if .flags.snd2 > 0 then
            call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(.flags.snd2, .pos.x, .pos.y))
        end if
        
        'quizas tenga defenza magica el npc. pablo (toxicwaste)
        da�o = da�o - .stats.defm
        if da�o < 0 then da�o = 0
        
        .stats.minhp = .stats.minhp - da�o
        call writeconsolemsg(userindex, "�le has quitado " & da�o & " puntos de vida a la criatura!", fonttypenames.fonttype_fight)
        call calculardarexp(userindex, npcindex, da�o)
    
        if .stats.minhp < 1 then
            .stats.minhp = 0
            call muerenpc(npcindex, userindex)
        end if
    end if
end with

end sub

sub infohechizo(byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 25/07/2009
'25/07/2009: zama - code improvements.
'25/07/2009: zama - now invisible admins magic sounds are not sent to anyone but themselves
'***************************************************
    dim spellindex as integer
    dim tuser as integer
    dim tnpc as integer
    
    with userlist(userindex)
        spellindex = .flags.hechizo
        tuser = .flags.targetuser
        tnpc = .flags.targetnpc
        
        call decirpalabrasmagicas(hechizos(spellindex).palabrasmagicas, userindex)
        
        if tuser > 0 then
            ' los admins invisibles no producen sonidos ni fx's
            if .flags.admininvisible = 1 and userindex = tuser then
                call enviardatosaslot(userindex, preparemessagecreatefx(userlist(tuser).char.charindex, hechizos(spellindex).fxgrh, hechizos(spellindex).loops))
                call enviardatosaslot(userindex, preparemessageplaywave(hechizos(spellindex).wav, userlist(tuser).pos.x, userlist(tuser).pos.y))
            else
                call senddata(sendtarget.topcarea, tuser, preparemessagecreatefx(userlist(tuser).char.charindex, hechizos(spellindex).fxgrh, hechizos(spellindex).loops))
                call senddata(sendtarget.topcarea, tuser, preparemessageplaywave(hechizos(spellindex).wav, userlist(tuser).pos.x, userlist(tuser).pos.y)) 'esta linea faltaba. pablo (toxicwaste)
            end if
        elseif tnpc > 0 then
            call senddata(sendtarget.tonpcarea, tnpc, preparemessagecreatefx(npclist(tnpc).char.charindex, hechizos(spellindex).fxgrh, hechizos(spellindex).loops))
            call senddata(sendtarget.tonpcarea, tnpc, preparemessageplaywave(hechizos(spellindex).wav, npclist(tnpc).pos.x, npclist(tnpc).pos.y))
        end if
        
        if tuser > 0 then
            if userindex <> tuser then
                if .showname then
                    call writeconsolemsg(userindex, hechizos(spellindex).hechizeromsg & " " & userlist(tuser).name, fonttypenames.fonttype_fight)
                else
                    call writeconsolemsg(userindex, hechizos(spellindex).hechizeromsg & " alguien.", fonttypenames.fonttype_fight)
                end if
                call writeconsolemsg(tuser, .name & " " & hechizos(spellindex).targetmsg, fonttypenames.fonttype_fight)
            else
                call writeconsolemsg(userindex, hechizos(spellindex).propiomsg, fonttypenames.fonttype_fight)
            end if
        elseif tnpc > 0 then
            call writeconsolemsg(userindex, hechizos(spellindex).hechizeromsg & " " & "la criatura.", fonttypenames.fonttype_fight)
        end if
    end with

end sub

public function hechizopropusuario(byval userindex as integer) as boolean
'***************************************************
'autor: unknown (orginal version)
'last modification: 28/04/2010
'02/01/2008 marcos (byval) - no permite tirar curar heridas a usuarios muertos.
'28/04/2010: zama - agrego restricciones para ciudas respecto al estado atacable.
'***************************************************

dim spellindex as integer
dim da�o as long
dim targetindex as integer

spellindex = userlist(userindex).flags.hechizo
targetindex = userlist(userindex).flags.targetuser
      
with userlist(targetindex)
    if .flags.muerto then
        call writeconsolemsg(userindex, "no puedes lanzar este hechizo a un muerto.", fonttypenames.fonttype_info)
        exit function
    end if
          
    ' <-------- aumenta hambre ---------->
    if hechizos(spellindex).subeham = 1 then
        
        call infohechizo(userindex)
        
        da�o = randomnumber(hechizos(spellindex).minham, hechizos(spellindex).maxham)
        
        .stats.minham = .stats.minham + da�o
        if .stats.minham > .stats.maxham then _
            .stats.minham = .stats.maxham
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de hambre a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
        end if
        
        call writeupdatehungerandthirst(targetindex)
    
    ' <-------- quita hambre ---------->
    elseif hechizos(spellindex).subeham = 2 then
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        else
            exit function
        end if
        
        call infohechizo(userindex)
        
        da�o = randomnumber(hechizos(spellindex).minham, hechizos(spellindex).maxham)
        
        .stats.minham = .stats.minham - da�o
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de hambre a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha quitado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
        end if
        
        if .stats.minham < 1 then
            .stats.minham = 0
            .flags.hambre = 1
        end if
        
        call writeupdatehungerandthirst(targetindex)
    end if
    
    ' <-------- aumenta sed ---------->
    if hechizos(spellindex).subesed = 1 then
        
        call infohechizo(userindex)
        
        da�o = randomnumber(hechizos(spellindex).minsed, hechizos(spellindex).maxsed)
        
        .stats.minagu = .stats.minagu + da�o
        if .stats.minagu > .stats.maxagu then _
            .stats.minagu = .stats.maxagu
        
        call writeupdatehungerandthirst(targetindex)
             
        if userindex <> targetindex then
          call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de sed a " & .name & ".", fonttypenames.fonttype_fight)
          call writeconsolemsg(targetindex, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
        else
          call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
        end if
        
    
    ' <-------- quita sed ---------->
    elseif hechizos(spellindex).subesed = 2 then
        
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        da�o = randomnumber(hechizos(spellindex).minsed, hechizos(spellindex).maxsed)
        
        .stats.minagu = .stats.minagu - da�o
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de sed a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha quitado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
        end if
        
        if .stats.minagu < 1 then
            .stats.minagu = 0
            .flags.sed = 1
        end if
        
        call writeupdatehungerandthirst(targetindex)
        
    end if
    
    ' <-------- aumenta agilidad ---------->
    if hechizos(spellindex).subeagilidad = 1 then
        
        ' chequea si el status permite ayudar al otro usuario
        if not cansupportuser(userindex, targetindex) then exit function
        
        call infohechizo(userindex)
        da�o = randomnumber(hechizos(spellindex).minagilidad, hechizos(spellindex).maxagilidad)
        
        .flags.duracionefecto = 1200
        .stats.useratributos(eatributos.agilidad) = .stats.useratributos(eatributos.agilidad) + da�o
        if .stats.useratributos(eatributos.agilidad) > minimoint(maxatributos, .stats.useratributosbackup(agilidad) * 2) then _
            .stats.useratributos(eatributos.agilidad) = minimoint(maxatributos, .stats.useratributosbackup(agilidad) * 2)
        
        .flags.tomopocion = true
        call writeupdatedexterity(targetindex)
    
    ' <-------- quita agilidad ---------->
    elseif hechizos(spellindex).subeagilidad = 2 then
        
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        .flags.tomopocion = true
        da�o = randomnumber(hechizos(spellindex).minagilidad, hechizos(spellindex).maxagilidad)
        .flags.duracionefecto = 700
        .stats.useratributos(eatributos.agilidad) = .stats.useratributos(eatributos.agilidad) - da�o
        if .stats.useratributos(eatributos.agilidad) < minatributos then .stats.useratributos(eatributos.agilidad) = minatributos
        
        call writeupdatedexterity(targetindex)
    end if
    
    ' <-------- aumenta fuerza ---------->
    if hechizos(spellindex).subefuerza = 1 then
    
        ' chequea si el status permite ayudar al otro usuario
        if not cansupportuser(userindex, targetindex) then exit function
        
        call infohechizo(userindex)
        da�o = randomnumber(hechizos(spellindex).minfuerza, hechizos(spellindex).maxfuerza)
        
        .flags.duracionefecto = 1200
    
        .stats.useratributos(eatributos.fuerza) = .stats.useratributos(eatributos.fuerza) + da�o
        if .stats.useratributos(eatributos.fuerza) > minimoint(maxatributos, .stats.useratributosbackup(fuerza) * 2) then _
            .stats.useratributos(eatributos.fuerza) = minimoint(maxatributos, .stats.useratributosbackup(fuerza) * 2)
        
        .flags.tomopocion = true
        call writeupdatestrenght(targetindex)
    
    ' <-------- quita fuerza ---------->
    elseif hechizos(spellindex).subefuerza = 2 then
    
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        .flags.tomopocion = true
        
        da�o = randomnumber(hechizos(spellindex).minfuerza, hechizos(spellindex).maxfuerza)
        .flags.duracionefecto = 700
        .stats.useratributos(eatributos.fuerza) = .stats.useratributos(eatributos.fuerza) - da�o
        if .stats.useratributos(eatributos.fuerza) < minatributos then .stats.useratributos(eatributos.fuerza) = minatributos
        
        call writeupdatestrenght(targetindex)
    end if
    
    ' <-------- cura salud ---------->
    if hechizos(spellindex).subehp = 1 then
        
        'verifica que el usuario no este muerto
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "�el usuario est� muerto!", fonttypenames.fonttype_info)
            exit function
        end if
        
        ' chequea si el status permite ayudar al otro usuario
        if not cansupportuser(userindex, targetindex) then exit function
           
        da�o = randomnumber(hechizos(spellindex).minhp, hechizos(spellindex).maxhp)
        da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
        
        call infohechizo(userindex)
    
        .stats.minhp = .stats.minhp + da�o
        if .stats.minhp > .stats.maxhp then _
            .stats.minhp = .stats.maxhp
        
        call writeupdatehp(targetindex)
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de vida a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
        end if
        
    ' <-------- quita salud (da�a) ---------->
    elseif hechizos(spellindex).subehp = 2 then
        
        if userindex = targetindex then
            call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
            exit function
        end if
        
        da�o = randomnumber(hechizos(spellindex).minhp, hechizos(spellindex).maxhp)
        
        da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
        
        if hechizos(spellindex).staffaffected then
            if userlist(userindex).clase = eclass.mage then
                if userlist(userindex).invent.weaponeqpobjindex > 0 then
                    da�o = (da�o * (objdata(userlist(userindex).invent.weaponeqpobjindex).staffdamagebonus + 70)) / 100
                else
                    da�o = da�o * 0.7 'baja da�o a 70% del original
                end if
            end if
        end if
        
        if userlist(userindex).invent.anilloeqpobjindex = laudelfico or userlist(userindex).invent.anilloeqpobjindex = flautaelfica then
            da�o = da�o * 1.04  'laud magico de los bardos
        end if
        
        'cascos antimagia
        if (.invent.cascoeqpobjindex > 0) then
            da�o = da�o - randomnumber(objdata(.invent.cascoeqpobjindex).defensamagicamin, objdata(.invent.cascoeqpobjindex).defensamagicamax)
        end if
        
        'anillos
        if (.invent.anilloeqpobjindex > 0) then
            da�o = da�o - randomnumber(objdata(.invent.anilloeqpobjindex).defensamagicamin, objdata(.invent.anilloeqpobjindex).defensamagicamax)
        end if
        
        if da�o < 0 then da�o = 0
        
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        .stats.minhp = .stats.minhp - da�o
        
        call writeupdatehp(targetindex)
        
        call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de vida a " & .name & ".", fonttypenames.fonttype_fight)
        call writeconsolemsg(targetindex, userlist(userindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
        
        'muere
        if .stats.minhp < 1 then
        
            if .flags.atacablepor <> userindex then
                'store it!
                call statistics.storefrag(userindex, targetindex)
                call contarmuerte(targetindex, userindex)
            end if
            
            .stats.minhp = 0
            call actstats(targetindex, userindex)
            call userdie(targetindex)
        end if
        
    end if
    
    ' <-------- aumenta mana ---------->
    if hechizos(spellindex).subemana = 1 then
        
        call infohechizo(userindex)
        .stats.minman = .stats.minman + da�o
        if .stats.minman > .stats.maxman then _
            .stats.minman = .stats.maxman
        
        call writeupdatemana(targetindex)
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de man� a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de man�.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de man�.", fonttypenames.fonttype_fight)
        end if
        
    
    ' <-------- quita mana ---------->
    elseif hechizos(spellindex).subemana = 2 then
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de man� a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha quitado " & da�o & " puntos de man�.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de man�.", fonttypenames.fonttype_fight)
        end if
        
        .stats.minman = .stats.minman - da�o
        if .stats.minman < 1 then .stats.minman = 0
        
        call writeupdatemana(targetindex)
        
    end if
    
    ' <-------- aumenta stamina ---------->
    if hechizos(spellindex).subesta = 1 then
        call infohechizo(userindex)
        .stats.minsta = .stats.minsta + da�o
        if .stats.minsta > .stats.maxsta then _
            .stats.minsta = .stats.maxsta
        
        call writeupdatesta(targetindex)
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de energ�a a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de energ�a.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de energ�a.", fonttypenames.fonttype_fight)
        end if
        
    ' <-------- quita stamina ---------->
    elseif hechizos(spellindex).subesta = 2 then
        if not puedeatacar(userindex, targetindex) then exit function
        
        if userindex <> targetindex then
            call usuarioatacadoporusuario(userindex, targetindex)
        end if
        
        call infohechizo(userindex)
        
        if userindex <> targetindex then
            call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de energ�a a " & .name & ".", fonttypenames.fonttype_fight)
            call writeconsolemsg(targetindex, userlist(userindex).name & " te ha quitado " & da�o & " puntos de energ�a.", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de energ�a.", fonttypenames.fonttype_fight)
        end if
        
        .stats.minsta = .stats.minsta - da�o
        
        if .stats.minsta < 1 then .stats.minsta = 0
        
        call writeupdatesta(targetindex)
        
    end if
end with

hechizopropusuario = true

call flushbuffer(targetindex)

end function

public function cansupportuser(byval casterindex as integer, byval targetindex as integer, _
                               optional byval docriminal as boolean = false) as boolean
'***************************************************
'author: zama
'last modification: 28/04/2010
'checks if caster can cast support magic on target user.
'***************************************************
     
 on error goto errhandler
 
    with userlist(casterindex)
        
        ' te podes curar a vos mismo
        if casterindex = targetindex then
            cansupportuser = true
            exit function
        end if
        
         ' no podes ayudar si estas en consulta
        if .flags.enconsulta then
            call writeconsolemsg(casterindex, "no puedes ayudar usuarios mientras estas en consulta.", fonttypenames.fonttype_info)
            exit function
        end if
        
        ' si estas en la arena, esta todo permitido
        if triggerzonapelea(casterindex, targetindex) = trigger6_permite then
            cansupportuser = true
            exit function
        end if
     
        ' victima criminal?
        if criminal(targetindex) then
        
            ' casteador ciuda?
            if not criminal(casterindex) then
            
                ' armadas no pueden ayudar
                if esarmada(casterindex) then
                    call writeconsolemsg(casterindex, "los miembros del ej�rcito real no pueden ayudar a los criminales.", fonttypenames.fonttype_info)
                    exit function
                end if
                
                ' si el ciuda tiene el seguro puesto no puede ayudar
                if .flags.seguro then
                    call writeconsolemsg(casterindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos.", fonttypenames.fonttype_info)
                    exit function
                else
                    ' penalizacion
                    if docriminal then
                        call volvercriminal(casterindex)
                    else
                        call disnobauban(casterindex, .reputacion.noblerep * 0.5, 10000)
                    end if
                end if
            end if
            
        ' victima ciuda o army
        else
            ' casteador es caos? => no pueden ayudar ciudas
            if escaos(casterindex) then
                call writeconsolemsg(casterindex, "los miembros de la legi�n oscura no pueden ayudar a los ciudadanos.", fonttypenames.fonttype_info)
                exit function
                
            ' casteador ciuda/army?
            elseif not criminal(casterindex) then
                
                ' esta en estado atacable?
                if userlist(targetindex).flags.atacablepor > 0 then
                    
                    ' no esta atacable por el casteador?
                    if userlist(targetindex).flags.atacablepor <> casterindex then
                    
                        ' si es armada no puede ayudar
                        if esarmada(casterindex) then
                            call writeconsolemsg(casterindex, "los miembros del ej�rcito real no pueden ayudar a ciudadanos en estado atacable.", fonttypenames.fonttype_info)
                            exit function
                        end if
    
                        ' seguro puesto?
                        if .flags.seguro then
                            call writeconsolemsg(casterindex, "para ayudar ciudadanos en estado atacable debes sacarte el seguro, pero te puedes volver criminal.", fonttypenames.fonttype_info)
                            exit function
                        else
                            call disnobauban(casterindex, .reputacion.noblerep * 0.5, 10000)
                        end if
                    end if
                end if
    
            end if
        end if
    end with
    
    cansupportuser = true

    exit function
    
errhandler:
    call logerror("error en cansupportuser, error: " & err.number & " - " & err.description & _
                  " casterindex: " & casterindex & ", targetindex: " & targetindex)

end function

sub updateuserhechizos(byval updateall as boolean, byval userindex as integer, byval slot as byte)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim loopc as byte

with userlist(userindex)
    'actualiza un solo slot
    if not updateall then
        'actualiza el inventario
        if .stats.userhechizos(slot) > 0 then
            call changeuserhechizo(userindex, slot, .stats.userhechizos(slot))
        else
            call changeuserhechizo(userindex, slot, 0)
        end if
    else
        'actualiza todos los slots
        for loopc = 1 to maxuserhechizos
            'actualiza el inventario
            if .stats.userhechizos(loopc) > 0 then
                call changeuserhechizo(userindex, loopc, .stats.userhechizos(loopc))
            else
                call changeuserhechizo(userindex, loopc, 0)
            end if
        next loopc
    end if
end with

end sub

sub changeuserhechizo(byval userindex as integer, byval slot as byte, byval hechizo as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    
    userlist(userindex).stats.userhechizos(slot) = hechizo
    
    if hechizo > 0 and hechizo < numerohechizos + 1 then
        call writechangespellslot(userindex, slot)
    else
        call writechangespellslot(userindex, slot)
    end if

end sub


public sub desplazarhechizo(byval userindex as integer, byval dire as integer, byval hechizodesplazado as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

if (dire <> 1 and dire <> -1) then exit sub
if not (hechizodesplazado >= 1 and hechizodesplazado <= maxuserhechizos) then exit sub

dim temphechizo as integer

with userlist(userindex)
    if dire = 1 then 'mover arriba
        if hechizodesplazado = 1 then
            call writeconsolemsg(userindex, "no puedes mover el hechizo en esa direcci�n.", fonttypenames.fonttype_info)
            exit sub
        else
            temphechizo = .stats.userhechizos(hechizodesplazado)
            .stats.userhechizos(hechizodesplazado) = .stats.userhechizos(hechizodesplazado - 1)
            .stats.userhechizos(hechizodesplazado - 1) = temphechizo
        end if
    else 'mover abajo
        if hechizodesplazado = maxuserhechizos then
            call writeconsolemsg(userindex, "no puedes mover el hechizo en esa direcci�n.", fonttypenames.fonttype_info)
            exit sub
        else
            temphechizo = .stats.userhechizos(hechizodesplazado)
            .stats.userhechizos(hechizodesplazado) = .stats.userhechizos(hechizodesplazado + 1)
            .stats.userhechizos(hechizodesplazado + 1) = temphechizo
        end if
    end if
end with

end sub

public sub disnobauban(byval userindex as integer, noblepts as long, bandidopts as long)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'disminuye la nobleza noblepts puntos y aumenta el bandido bandidopts puntos
    dim eracriminal as boolean
    eracriminal = criminal(userindex)
    
    with userlist(userindex)
        'si estamos en la arena no hacemos nada
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = 6 then exit sub
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then
            'pierdo nobleza...
            .reputacion.noblerep = .reputacion.noblerep - noblepts
            if .reputacion.noblerep < 0 then
                .reputacion.noblerep = 0
            end if
            
            'gano bandido...
            .reputacion.bandidorep = .reputacion.bandidorep + bandidopts
            if .reputacion.bandidorep > maxrep then _
                .reputacion.bandidorep = maxrep
            call writemultimessage(userindex, emessages.nobilitylost) 'call writenobilitylost(userindex)
            if criminal(userindex) then if .faccion.armadareal = 1 then call expulsarfaccionreal(userindex)
        end if
        
        if not eracriminal and criminal(userindex) then
            call refreshcharstatus(userindex)
        end if
    end with
end sub
