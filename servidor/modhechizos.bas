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

if hechizos(spell).subehp = 1 then

    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, userlist(userindex).pos.x, userlist(userindex).pos.y))
    call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))

    userlist(userindex).stats.minhp = userlist(userindex).stats.minhp + da�o
    if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
    
    call writeconsolemsg(userindex, npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
    call writeupdateuserstats(userindex)

elseif hechizos(spell).subehp = 2 then
    
    if userlist(userindex).flags.privilegios and playertype.user then
    
        da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
        
        if userlist(userindex).invent.cascoeqpobjindex > 0 then
            da�o = da�o - randomnumber(objdata(userlist(userindex).invent.cascoeqpobjindex).defensamagicamin, objdata(userlist(userindex).invent.cascoeqpobjindex).defensamagicamax)
        end if
        
        if userlist(userindex).invent.anilloeqpobjindex > 0 then
            da�o = da�o - randomnumber(objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamin, objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamax)
        end if
        
        if da�o < 0 then da�o = 0
        
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, userlist(userindex).pos.x, userlist(userindex).pos.y))
        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
    
        userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - da�o
        
        call writeconsolemsg(userindex, npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
        call writeupdateuserstats(userindex)
        
        'muere
        if userlist(userindex).stats.minhp < 1 then
            userlist(userindex).stats.minhp = 0
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
    if userlist(userindex).flags.paralizado = 0 then
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, userlist(userindex).pos.x, userlist(userindex).pos.y))
        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
          
        if userlist(userindex).invent.anilloeqpobjindex = superanillo then
            call writeconsolemsg(userindex, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
        if hechizos(spell).inmoviliza = 1 then
            userlist(userindex).flags.inmovilizado = 1
        end if
          
        userlist(userindex).flags.paralizado = 1
        userlist(userindex).counters.paralisis = intervaloparalizado
          
        call writeparalizeok(userindex)
    end if
end if

if hechizos(spell).estupidez = 1 then   ' turbacion
     if userlist(userindex).flags.estupidez = 0 then
          call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(hechizos(spell).wav, userlist(userindex).pos.x, userlist(userindex).pos.y))
          call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, hechizos(spell).fxgrh, hechizos(spell).loops))
          
            if userlist(userindex).invent.anilloeqpobjindex = superanillo then
                call writeconsolemsg(userindex, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
                exit sub
            end if
          
          userlist(userindex).flags.estupidez = 1
          userlist(userindex).counters.ceguera = intervaloinvisible
                  
        call writedumb(userindex)
     end if
end if

end sub


sub npclanzaspellsobrenpc(byval npcindex as integer, byval targetnpc as integer, byval spell as integer)
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
dim hindex as integer
dim j as integer
hindex = objdata(userlist(userindex).invent.object(slot).objindex).hechizoindex

if not tienehechizo(hindex, userindex) then
    'buscamos un slot vacio
    for j = 1 to maxuserhechizos
        if userlist(userindex).stats.userhechizos(j) = 0 then exit for
    next j
        
    if userlist(userindex).stats.userhechizos(j) <> 0 then
        call writeconsolemsg(userindex, "no tenes espacio para mas hechizos.", fonttypenames.fonttype_info)
    else
        userlist(userindex).stats.userhechizos(j) = hindex
        call updateuserhechizos(false, userindex, cbyte(j))
        'quitamos del inv el item
        call quitaruserinvitem(userindex, cbyte(slot), 1)
    end if
else
    call writeconsolemsg(userindex, "ya tenes ese hechizo.", fonttypenames.fonttype_info)
end if

end sub
            
sub decirpalabrasmagicas(byval s as string, byval userindex as integer)
on error resume next
    call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(s, userlist(userindex).char.charindex, vbcyan))
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
'last modification: 11/09/08
'last modification by: marco vanotti (marco)
' - 11/09/08 now druid have mana bonus while casting summoning spells having a magic flute equipped (marco)
'***************************************************
dim druidmanabonus as single

    if userlist(userindex).flags.muerto then
        call writeconsolemsg(userindex, "no podes lanzar hechizos porque estas muerto.", fonttypenames.fonttype_info)
        puedelanzar = false
        exit function
    end if
        
    if hechizos(hechizoindex).needstaff > 0 then
        if userlist(userindex).clase = eclass.mage then
            if userlist(userindex).invent.weaponeqpobjindex > 0 then
                if objdata(userlist(userindex).invent.weaponeqpobjindex).staffpower < hechizos(hechizoindex).needstaff then
                    call writeconsolemsg(userindex, "no posees un b�culo lo suficientemente poderoso para que puedas lanzar el conjuro.", fonttypenames.fonttype_info)
                    puedelanzar = false
                    exit function
                end if
            else
                call writeconsolemsg(userindex, "no puedes lanzar este conjuro sin la ayuda de un b�culo.", fonttypenames.fonttype_info)
                puedelanzar = false
                exit function
            end if
        end if
    end if
        
    if userlist(userindex).stats.userskills(eskill.magia) < hechizos(hechizoindex).minskill then
        call writeconsolemsg(userindex, "no tenes suficientes puntos de magia para lanzar este hechizo.", fonttypenames.fonttype_info)
        puedelanzar = false
        exit function
    end if
    
    if userlist(userindex).stats.minsta < hechizos(hechizoindex).starequerido then
        if userlist(userindex).genero = egenero.hombre then
            call writeconsolemsg(userindex, "est�s muy cansado para lanzar este hechizo.", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, "est�s muy cansada para lanzar este hechizo.", fonttypenames.fonttype_info)
        end if
        puedelanzar = false
        exit function
    end if

    if hechizos(hechizoindex).tipo = uinvocacion then
    'if it is a summoning spell and we are druids, having a magic flute equipped then we will need less mana
        if userlist(userindex).clase = eclass.druid and userlist(userindex).invent.anilloeqpobjindex = flautamagica then
            druidmanabonus = 0.7
        else
            druidmanabonus = 1
        end if
    else
        druidmanabonus = 1
    end if
    
    if userlist(userindex).stats.minman < hechizos(hechizoindex).manarequerido * druidmanabonus then
        call writeconsolemsg(userindex, "no tenes suficiente mana.", fonttypenames.fonttype_info)
        puedelanzar = false
        exit function
    end if
        
    puedelanzar = true
end function

sub hechizoterrenoestado(byval userindex as integer, byref b as boolean)
dim poscasteadax as integer
dim poscasteaday as integer
dim poscasteadam as integer
dim h as integer
dim tempx as integer
dim tempy as integer


    poscasteadax = userlist(userindex).flags.targetx
    poscasteaday = userlist(userindex).flags.targety
    poscasteadam = userlist(userindex).flags.targetmap
    
    h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
    
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

end sub

''
' le da propiedades al nuevo npc
'
' @param userindex  indice del usuario que invoca.
' @param b  indica si se termino la operaci�n.

sub hechizoinvocacion(byval userindex as integer, byref b as boolean)
'***************************************************
'author: uknown
'last modification: 06/15/2008 (niconz)
'sale del sub si no hay una posici�n valida.
'***************************************************
if userlist(userindex).nromascotas >= maxmascotas then exit sub

'no permitimos se invoquen criaturas en zonas seguras
if mapinfo(userlist(userindex).pos.map).pk = false or mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = etrigger.zonasegura then
    call writeconsolemsg(userindex, "en zona segura no puedes invocar criaturas.", fonttypenames.fonttype_info)
    exit sub
end if

dim h as integer, j as integer, ind as integer, index as integer
dim targetpos as worldpos


targetpos.map = userlist(userindex).flags.targetmap
targetpos.x = userlist(userindex).flags.targetx
targetpos.y = userlist(userindex).flags.targety

h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
    
    
for j = 1 to hechizos(h).cant
    
    if userlist(userindex).nromascotas < maxmascotas then
        ind = spawnnpc(hechizos(h).numnpc, targetpos, true, false)
        if ind > 0 then
            userlist(userindex).nromascotas = userlist(userindex).nromascotas + 1
            
            index = freemascotaindex(userindex)
            
            userlist(userindex).mascotasindex(index) = ind
            userlist(userindex).mascotastype(index) = npclist(ind).numero
            
            npclist(ind).maestrouser = userindex
            npclist(ind).contadores.tiempoexistencia = intervaloinvocacion
            npclist(ind).givegld = 0
            
            call followamo(ind)
        else
            exit sub
        end if
            
    else
        exit for
    end if
    
next j


call infohechizo(userindex)
b = true


end sub

sub handlehechizoterreno(byval userindex as integer, byval uh as integer)
'***************************************************
'author: unknown
'last modification: 05/01/08
'
'***************************************************
if userlist(userindex).flags.modocombate = false then
    call writeconsolemsg(userindex, "debes estar en modo de combate para lanzar este hechizo.", fonttypenames.fonttype_info)
    exit sub
end if

dim b as boolean

select case hechizos(uh).tipo
    case tipohechizo.uinvocacion '
        call hechizoinvocacion(userindex, b)
    case tipohechizo.uestado
        call hechizoterrenoestado(userindex, b)
    
end select

if b then
    call subirskill(userindex, magia)
    'if hechizos(uh).resis = 1 then call subirskill(userlist(userindex).flags.targetuser, resis)
    if userlist(userindex).clase = eclass.druid and userlist(userindex).invent.anilloeqpobjindex = flautamagica then
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido * 0.7
    else
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    end if

    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - hechizos(uh).starequerido
    if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
    call writeupdateuserstats(userindex)
end if


end sub

sub handlehechizousuario(byval userindex as integer, byval uh as integer)
'***************************************************
'author: unknown
'last modification: 05/01/08
'
'***************************************************
if userlist(userindex).flags.modocombate = false then
    call writeconsolemsg(userindex, "debes estar en modo de combate para lanzar este hechizo.", fonttypenames.fonttype_info)
    exit sub
end if

dim b as boolean
select case hechizos(uh).tipo
    case tipohechizo.uestado ' afectan estados (por ejem : envenenamiento)
       call hechizoestadousuario(userindex, b)
    
    case tipohechizo.upropiedades ' afectan hp,mana,stamina,etc
       call hechizopropusuario(userindex, b)
end select

if b then
    call subirskill(userindex, magia)
    'if hechizos(uh).resis = 1 then call subirskill(userlist(userindex).flags.targetuser, resis)
    'agregado para que los druidas, al tener equipada la flauta magica, el coste de mana de mimetismo es de 50% menos.
    if userlist(userindex).clase = eclass.druid and userlist(userindex).invent.anilloeqpobjindex = flautamagica and hechizos(uh).mimetiza = 1 then
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido * 0.5
    else
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    end if
    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - hechizos(uh).starequerido
    if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
    call writeupdateuserstats(userindex)
    call writeupdateuserstats(userlist(userindex).flags.targetuser)
    userlist(userindex).flags.targetuser = 0
end if

end sub

sub handlehechizonpc(byval userindex as integer, byval uh as integer)
'***************************************************
'author: unknown
'last modification: 13/02/2009
'13/02/2009: zama - agregada 50% bonificacion en coste de mana a mimetismo para druidas
'***************************************************
dim b as boolean

select case hechizos(uh).tipo
    case tipohechizo.uestado ' afectan estados (por ejem : envenenamiento)
        call hechizoestadonpc(userlist(userindex).flags.targetnpc, uh, b, userindex)
    case tipohechizo.upropiedades ' afectan hp,mana,stamina,etc
        call hechizopropnpc(uh, userlist(userindex).flags.targetnpc, userindex, b)
end select


if b then
    call subirskill(userindex, magia)
    userlist(userindex).flags.targetnpc = 0
    
    ' bonificaci�n para druidas.
    if userlist(userindex).clase = eclass.druid and userlist(userindex).invent.anilloeqpobjindex = flautamagica and hechizos(uh).mimetiza = 1 then
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido * 0.5
    else
        userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    end if

    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - hechizos(uh).starequerido
    if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
    call writeupdateuserstats(userindex)
end if

end sub


sub lanzarhechizo(index as integer, userindex as integer)

dim uh as integer

uh = userlist(userindex).stats.userhechizos(index)

if puedelanzar(userindex, uh) then
    select case hechizos(uh).target
        case targettype.uusuarios
            if userlist(userindex).flags.targetuser > 0 then
                if abs(userlist(userlist(userindex).flags.targetuser).pos.y - userlist(userindex).pos.y) <= rango_vision_y then
                    call handlehechizousuario(userindex, uh)
                else
                    call writeconsolemsg(userindex, "estas demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                end if
            else
                call writeconsolemsg(userindex, "este hechizo act�a solo sobre usuarios.", fonttypenames.fonttype_info)
            end if
        
        case targettype.unpc
            if userlist(userindex).flags.targetnpc > 0 then
                if abs(npclist(userlist(userindex).flags.targetnpc).pos.y - userlist(userindex).pos.y) <= rango_vision_y then
                    call handlehechizonpc(userindex, uh)
                else
                    call writeconsolemsg(userindex, "estas demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                end if
            else
                call writeconsolemsg(userindex, "este hechizo solo afecta a los npcs.", fonttypenames.fonttype_info)
            end if
        
        case targettype.uusuariosynpc
            if userlist(userindex).flags.targetuser > 0 then
                if abs(userlist(userlist(userindex).flags.targetuser).pos.y - userlist(userindex).pos.y) <= rango_vision_y then
                    call handlehechizousuario(userindex, uh)
                else
                    call writeconsolemsg(userindex, "estas demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                end if
            elseif userlist(userindex).flags.targetnpc > 0 then
                if abs(npclist(userlist(userindex).flags.targetnpc).pos.y - userlist(userindex).pos.y) <= rango_vision_y then
                    call handlehechizonpc(userindex, uh)
                else
                    call writeconsolemsg(userindex, "estas demasiado lejos para lanzar este hechizo.", fonttypenames.fonttype_warning)
                end if
            else
                call writeconsolemsg(userindex, "target invalido.", fonttypenames.fonttype_info)
            end if
        
        case targettype.uterreno
            call handlehechizoterreno(userindex, uh)
    end select
    
end if

if userlist(userindex).counters.trabajando then _
    userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando - 1

if userlist(userindex).counters.ocultando then _
    userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando - 1
    
end sub

sub hechizoestadousuario(byval userindex as integer, byref b as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 13/02/2009
'handles the spells that afect the stats of an user
'24/01/2007 pablo (toxicwaste) - invisibilidad no permitida en mapas con invisinefecto
'26/01/2007 pablo (toxicwaste) - cambios que permiten mejor manejo de ataques en los rings.
'26/01/2007 pablo (toxicwaste) - revivir no permitido en mapas con resusinefecto
'02/01/2008 marcos (byval) - curar veneno no permitido en usuarios muertos.
'06/28/2008 niconz - agregu� que se le de valor al flag inmovilizado.
'17/11/2008: niconz - agregado para quitar la penalizaci�n de vida en el ring y cambio de ecuacion.
'13/02/2009: zama - arreglada ecuacion para quitar vida tras resucitar en rings.
'***************************************************


dim h as integer, tu as integer
h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
tu = userlist(userindex).flags.targetuser


if hechizos(h).invisibilidad = 1 then
   
    if userlist(tu).flags.muerto = 1 then
        call writeconsolemsg(userindex, "�est� muerto!", fonttypenames.fonttype_info)
        b = false
        exit sub
    end if
    
    if userlist(tu).counters.saliendo then
        if userindex <> tu then
            call writeconsolemsg(userindex, "�el hechizo no tiene efecto!", fonttypenames.fonttype_info)
            b = false
            exit sub
        else
            call writeconsolemsg(userindex, "�no puedes ponerte invisible mientras te encuentres saliendo!", fonttypenames.fonttype_warning)
            b = false
            exit sub
        end if
    end if
    
    'no usar invi mapas invisinefecto
    if mapinfo(userlist(tu).pos.map).invisinefecto > 0 then
        call writeconsolemsg(userindex, "�la invisibilidad no funciona aqu�!", fonttypenames.fonttype_info)
        b = false
        exit sub
    end if
    
    'para poder tirar invi a un pk en el ring
    if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
        if criminal(tu) and not criminal(userindex) then
            if esarmada(userindex) then
                call writeconsolemsg(userindex, "los miembros de la armada real no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
            if userlist(userindex).flags.seguro then
                call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                call volvercriminal(userindex)
            end if
        end if
    end if
    
    'si sos user, no uses este hechizo con gms.
    if userlist(userindex).flags.privilegios and playertype.user then
        if not userlist(tu).flags.privilegios and playertype.user then
            exit sub
        end if
    end if
   
    userlist(tu).flags.invisible = 1
    call senddata(sendtarget.topcarea, tu, preparemessagesetinvisible(userlist(tu).char.charindex, true))

    call infohechizo(userindex)
    b = true
end if

if hechizos(h).mimetiza = 1 then
    if userlist(tu).flags.muerto = 1 then
        exit sub
    end if
    
    if userlist(tu).flags.navegando = 1 then
        exit sub
    end if
    if userlist(userindex).flags.navegando = 1 then
        exit sub
    end if
    
    'si sos user, no uses este hechizo con gms.
    if userlist(userindex).flags.privilegios and playertype.user then
        if not userlist(tu).flags.privilegios and playertype.user then
            exit sub
        end if
    end if
    
    if userlist(userindex).flags.mimetizado = 1 then
        call writeconsolemsg(userindex, "ya te encuentras transformado. el hechizo no ha tenido efecto", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if userlist(userindex).flags.admininvisible = 1 then exit sub
    
    'copio el char original al mimetizado
    
    with userlist(userindex)
        .charmimetizado.body = .char.body
        .charmimetizado.head = .char.head
        .charmimetizado.cascoanim = .char.cascoanim
        .charmimetizado.shieldanim = .char.shieldanim
        .charmimetizado.weaponanim = .char.weaponanim
        
        .flags.mimetizado = 1
        
        'ahora pongo local el del enemigo
        .char.body = userlist(tu).char.body
        .char.head = userlist(tu).char.head
        .char.cascoanim = userlist(tu).char.cascoanim
        .char.shieldanim = userlist(tu).char.shieldanim
        .char.weaponanim = userlist(tu).char.weaponanim
    
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
    end with
   
   call infohechizo(userindex)
   b = true
end if

if hechizos(h).envenena = 1 then
    if userindex = tu then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
    
    if not puedeatacar(userindex, tu) then exit sub
    if userindex <> tu then
        call usuarioatacadoporusuario(userindex, tu)
    end if
    userlist(tu).flags.envenenado = 1
    call infohechizo(userindex)
    b = true
end if

if hechizos(h).curaveneno = 1 then

    'verificamos que el usuario no este muerto
    if userlist(tu).flags.muerto = 1 then
        call writeconsolemsg(userindex, "�est� muerto!", fonttypenames.fonttype_info)
        b = false
        exit sub
    end if
    
    'para poder tirar curar veneno a un pk en el ring
    if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
        if criminal(tu) and not criminal(userindex) then
            if esarmada(userindex) then
                call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
            if userlist(userindex).flags.seguro then
                call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                call disnobauban(userindex, userlist(userindex).reputacion.noblerep * 0.5, 10000)
            end if
        end if
    end if
        
    'si sos user, no uses este hechizo con gms.
    if userlist(userindex).flags.privilegios and playertype.user then
        if not userlist(tu).flags.privilegios and playertype.user then
            exit sub
        end if
    end if
        
    userlist(tu).flags.envenenado = 0
    call infohechizo(userindex)
    b = true
end if

if hechizos(h).maldicion = 1 then
    if userindex = tu then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
    
    if not puedeatacar(userindex, tu) then exit sub
    if userindex <> tu then
        call usuarioatacadoporusuario(userindex, tu)
    end if
    userlist(tu).flags.maldicion = 1
    call infohechizo(userindex)
    b = true
end if

if hechizos(h).removermaldicion = 1 then
        userlist(tu).flags.maldicion = 0
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).bendicion = 1 then
        userlist(tu).flags.bendicion = 1
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).paraliza = 1 or hechizos(h).inmoviliza = 1 then
    if userindex = tu then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
    
     if userlist(tu).flags.paralizado = 0 then
            if not puedeatacar(userindex, tu) then exit sub
            
            if userindex <> tu then
                call usuarioatacadoporusuario(userindex, tu)
            end if
            
            call infohechizo(userindex)
            b = true
            if userlist(tu).invent.anilloeqpobjindex = superanillo then
                call writeconsolemsg(tu, " tu anillo rechaza los efectos del hechizo.", fonttypenames.fonttype_fight)
                call writeconsolemsg(userindex, " �el hechizo no tiene efecto!", fonttypenames.fonttype_fight)
                call flushbuffer(tu)
                exit sub
            end if
            
            if hechizos(h).inmoviliza = 1 then userlist(tu).flags.inmovilizado = 1
            userlist(tu).flags.paralizado = 1
            userlist(tu).counters.paralisis = intervaloparalizado
            
            call writeparalizeok(tu)
            call flushbuffer(tu)
      
    end if
end if


if hechizos(h).removerparalisis = 1 then
    if userlist(tu).flags.paralizado = 1 then
        'para poder tirar remo a un pk en el ring
        if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
            if criminal(tu) and not criminal(userindex) then
                if esarmada(userindex) then
                    call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                end if
                if userlist(userindex).flags.seguro then
                    call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                else
                    call volvercriminal(userindex)
                end if
            end if
        end if
        
        userlist(tu).flags.inmovilizado = 0
        userlist(tu).flags.paralizado = 0
        'no need to crypt this
        call writeparalizeok(tu)
        call infohechizo(userindex)
        b = true
    end if
end if

if hechizos(h).removerestupidez = 1 then
    if userlist(tu).flags.estupidez = 1 then
        'para poder tirar remo estu a un pk en el ring
        if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
            if criminal(tu) and not criminal(userindex) then
                if esarmada(userindex) then
                    call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                end if
                if userlist(userindex).flags.seguro then
                    call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                else
                    call disnobauban(userindex, userlist(userindex).reputacion.noblerep * 0.5, 10000)
                end if
            end if
        end if
    
        userlist(tu).flags.estupidez = 0
        'no need to crypt this
        call writedumbnomore(tu)
        call flushbuffer(tu)
        call infohechizo(userindex)
        b = true
    end if
end if


if hechizos(h).revivir = 1 then
    if userlist(tu).flags.muerto = 1 then
        
        'seguro de resurreccion (solo afecta a los hechizos, no al sacerdote ni al comando de gm)
        if userlist(tu).flags.seguroresu then
            call writeconsolemsg(userindex, "�el esp�ritu no tiene intenciones de regresar al mundo de los vivos!", fonttypenames.fonttype_info)
            b = false
            exit sub
        end if
    
        'no usar resu en mapas con resusinefecto
        if mapinfo(userlist(tu).pos.map).resusinefecto > 0 then
            call writeconsolemsg(userindex, "�revivir no est� permitido aqui! retirate de la zona si deseas utilizar el hechizo.", fonttypenames.fonttype_info)
            b = false
            exit sub
        end if
        
        'no podemos resucitar si nuestra barra de energ�a no est� llena. (gd: 29/04/07)
        if userlist(userindex).stats.maxsta <> userlist(userindex).stats.minsta then
            call writeconsolemsg(userindex, "no puedes resucitar si no tienes tu barra de energ�a llena.", fonttypenames.fonttype_info)
            b = false
            exit sub
        end if
        
        'revisamos si necesita vara
        if userlist(userindex).clase = eclass.mage then
            if userlist(userindex).invent.weaponeqpobjindex > 0 then
                if objdata(userlist(userindex).invent.weaponeqpobjindex).staffpower < hechizos(h).needstaff then
                    call writeconsolemsg(userindex, "necesitas un mejor b�culo para este hechizo", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                end if
            end if
        elseif userlist(userindex).clase = eclass.bard then
            if userlist(userindex).invent.anilloeqpobjindex <> laudmagico then
                call writeconsolemsg(userindex, "necesitas un instrumento m�gico para devolver la vida", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
        elseif userlist(userindex).clase = eclass.druid then
            if userlist(userindex).invent.anilloeqpobjindex <> flautamagica then
                call writeconsolemsg(userindex, "necesitas un instrumento m�gico para devolver la vida", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
        end if
        
        'para poder tirar revivir a un pk en el ring
        if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
            if criminal(tu) and not criminal(userindex) then
                if esarmada(userindex) then
                    call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                end if
                if userlist(userindex).flags.seguro then
                    call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                else
                    call volvercriminal(userindex)
                end if
            end if
        end if

        dim eracriminal as boolean
        eracriminal = criminal(userindex)
        if not criminal(tu) then
            if tu <> userindex then
                userlist(userindex).reputacion.noblerep = userlist(userindex).reputacion.noblerep + 500
                if userlist(userindex).reputacion.noblerep > maxrep then _
                    userlist(userindex).reputacion.noblerep = maxrep
                call writeconsolemsg(userindex, "�los dioses te sonrien, has ganado 500 puntos de nobleza!.", fonttypenames.fonttype_info)
            end if
        end if
        
        if eracriminal and not criminal(userindex) then
            call refreshcharstatus(userindex)
        end if
        
        
        'pablo toxic waste (gd: 29/04/07)
        userlist(tu).stats.minagu = 0
        userlist(tu).flags.sed = 1
        userlist(tu).stats.minham = 0
        userlist(tu).flags.hambre = 1
        call writeupdatehungerandthirst(tu)
        call infohechizo(userindex)
        userlist(tu).stats.minman = 0
        userlist(tu).stats.minsta = 0
        
        'agregado para quitar la penalizaci�n de vida en el ring y cambio de ecuacion. (niconz)
        if (triggerzonapelea(userindex, tu) <> trigger6_permite) then
            'solo saco vida si es user. no quiero que exploten gms por ahi.
            if userlist(userindex).flags.privilegios and playertype.user then
                userlist(userindex).stats.minhp = userlist(userindex).stats.minhp * (1 - userlist(tu).stats.elv * 0.015)
            end if
        end if
        
        if (userlist(userindex).stats.minhp <= 0) then
            call userdie(userindex)
            call writeconsolemsg(userindex, "el esfuerzo de resucitar fue demasiado grande", fonttypenames.fonttype_info)
            b = false
        else
            call writeconsolemsg(userindex, "el esfuerzo de resucitar te ha debilitado", fonttypenames.fonttype_info)
            b = true
        end if
        
        call revivirusuario(tu)
    else
        b = false
    end if

end if

if hechizos(h).ceguera = 1 then
    if userindex = tu then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
    
        if not puedeatacar(userindex, tu) then exit sub
        if userindex <> tu then
            call usuarioatacadoporusuario(userindex, tu)
        end if
        userlist(tu).flags.ceguera = 1
        userlist(tu).counters.ceguera = intervaloparalizado / 3

        call writeblind(tu)
        call flushbuffer(tu)
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).estupidez = 1 then
    if userindex = tu then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
        if not puedeatacar(userindex, tu) then exit sub
        if userindex <> tu then
            call usuarioatacadoporusuario(userindex, tu)
        end if
        if userlist(tu).flags.estupidez = 0 then
            userlist(tu).flags.estupidez = 1
            userlist(tu).counters.ceguera = intervaloparalizado
        end if
        call writedumb(tu)
        call flushbuffer(tu)

        call infohechizo(userindex)
        b = true
end if

end sub

sub hechizoestadonpc(byval npcindex as integer, byval hindex as integer, byref b as boolean, byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 07/07/2008
'handles the spells that afect the stats of an npc
'04/13/2008 niconz - guardias faccionarios pueden ser
'removidos por users de su misma faccion.
'07/07/2008: niconz - solo se puede mimetizar con npcs si es druida
'***************************************************
if hechizos(hindex).invisibilidad = 1 then
    call infohechizo(userindex)
    npclist(npcindex).flags.invisible = 1
    b = true
end if

if hechizos(hindex).envenena = 1 then
    if not puedeatacarnpc(userindex, npcindex) then
        b = false
        exit sub
    end if
    call npcatacado(npcindex, userindex)
    call infohechizo(userindex)
    npclist(npcindex).flags.envenenado = 1
    b = true
end if

if hechizos(hindex).curaveneno = 1 then
    call infohechizo(userindex)
    npclist(npcindex).flags.envenenado = 0
    b = true
end if

if hechizos(hindex).maldicion = 1 then
    if not puedeatacarnpc(userindex, npcindex) then
        b = false
        exit sub
    end if
    call npcatacado(npcindex, userindex)
    call infohechizo(userindex)
    npclist(npcindex).flags.maldicion = 1
    b = true
end if

if hechizos(hindex).removermaldicion = 1 then
    call infohechizo(userindex)
    npclist(npcindex).flags.maldicion = 0
    b = true
end if

if hechizos(hindex).bendicion = 1 then
    call infohechizo(userindex)
    npclist(npcindex).flags.bendicion = 1
    b = true
end if

if hechizos(hindex).paraliza = 1 then
    if npclist(npcindex).flags.afectaparalisis = 0 then
        if not puedeatacarnpc(userindex, npcindex) then
            b = false
            exit sub
        end if
        call npcatacado(npcindex, userindex)
        call infohechizo(userindex)
        npclist(npcindex).flags.paralizado = 1
        npclist(npcindex).flags.inmovilizado = 0
        npclist(npcindex).contadores.paralisis = intervaloparalizado
        b = true
    else
        call writeconsolemsg(userindex, "el npc es inmune a este hechizo.", fonttypenames.fonttype_info)
        b = false
        exit sub
    end if
end if

if hechizos(hindex).removerparalisis = 1 then
    if npclist(npcindex).flags.paralizado = 1 or npclist(npcindex).flags.inmovilizado = 1 then
        if npclist(npcindex).maestrouser = userindex then
            call infohechizo(userindex)
            npclist(npcindex).flags.paralizado = 0
            npclist(npcindex).contadores.paralisis = 0
            b = true
        else
            if npclist(npcindex).npctype = enpctype.guardiareal then
                if esarmada(userindex) then
                    call infohechizo(userindex)
                    npclist(npcindex).flags.paralizado = 0
                    npclist(npcindex).contadores.paralisis = 0
                    b = true
                    exit sub
                else
                    call writeconsolemsg(userindex, "solo puedes remover la par�lisis de los guardias si perteneces a su facci�n.", fonttypenames.fonttype_info)
                    b = false
                    exit sub
                end if
                
                call writeconsolemsg(userindex, "solo puedes remover la par�lisis de los npcs que te consideren su amo", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                if npclist(npcindex).npctype = enpctype.guardiascaos then
                    if escaos(userindex) then
                        call infohechizo(userindex)
                        npclist(npcindex).flags.paralizado = 0
                        npclist(npcindex).contadores.paralisis = 0
                        b = true
                        exit sub
                    else
                        call writeconsolemsg(userindex, "solo puedes remover la par�lisis de los guardias si perteneces a su facci�n.", fonttypenames.fonttype_info)
                        b = false
                        exit sub
                    end if
                end if
            end if
        end if
   else
      call writeconsolemsg(userindex, "este npc no esta paralizado", fonttypenames.fonttype_info)
      b = false
      exit sub
   end if
end if
 
if hechizos(hindex).inmoviliza = 1 then
    if npclist(npcindex).flags.afectaparalisis = 0 then
        if not puedeatacarnpc(userindex, npcindex) then
            b = false
            exit sub
        end if
        call npcatacado(npcindex, userindex)
        npclist(npcindex).flags.inmovilizado = 1
        npclist(npcindex).flags.paralizado = 0
        npclist(npcindex).contadores.paralisis = intervaloparalizado
        call infohechizo(userindex)
        b = true
    else
        call writeconsolemsg(userindex, "el npc es inmune al hechizo.", fonttypenames.fonttype_info)
    end if
end if

if hechizos(hindex).mimetiza = 1 then
    
    if userlist(userindex).flags.mimetizado = 1 then
        call writeconsolemsg(userindex, "ya te encuentras transformado. el hechizo no ha tenido efecto", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if userlist(userindex).flags.admininvisible = 1 then exit sub
    
        
    if userlist(userindex).clase = eclass.druid then
        'copio el char original al mimetizado
        with userlist(userindex)
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
        end with
    else
        call writeconsolemsg(userindex, "solo los druidas pueden mimetizarse con criaturas.", fonttypenames.fonttype_info)
        exit sub
    end if

   call infohechizo(userindex)
   b = true
end if
end sub

sub hechizopropnpc(byval hindex as integer, byval npcindex as integer, byval userindex as integer, byref b as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 14/08/2007
'handles the spells that afect the life npc
'14/08/2007 pablo (toxicwaste) - orden general.
'***************************************************

dim da�o as long

'salud
if hechizos(hindex).subehp = 1 then
    da�o = randomnumber(hechizos(hindex).minhp, hechizos(hindex).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    call infohechizo(userindex)
    npclist(npcindex).stats.minhp = npclist(npcindex).stats.minhp + da�o
    if npclist(npcindex).stats.minhp > npclist(npcindex).stats.maxhp then _
        npclist(npcindex).stats.minhp = npclist(npcindex).stats.maxhp
    call writeconsolemsg(userindex, "has curado " & da�o & " puntos de salud a la criatura.", fonttypenames.fonttype_fight)
    b = true
    
elseif hechizos(hindex).subehp = 2 then
    if not puedeatacarnpc(userindex, npcindex) then
        b = false
        exit sub
    end if
    call npcatacado(npcindex, userindex)
    da�o = randomnumber(hechizos(hindex).minhp, hechizos(hindex).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)

    if hechizos(hindex).staffaffected then
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
    if userlist(userindex).invent.anilloeqpobjindex = laudmagico or userlist(userindex).invent.anilloeqpobjindex = flautamagica then
        da�o = da�o * 1.04  'laud magico de los bardos
    end if

    call infohechizo(userindex)
    b = true
    
    if npclist(npcindex).flags.snd2 > 0 then
        call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(npclist(npcindex).flags.snd2, npclist(npcindex).pos.x, npclist(npcindex).pos.y))
    end if
    
    'quizas tenga defenza magica el npc. pablo (toxicwaste)
    da�o = da�o - npclist(npcindex).stats.defm
    if da�o < 0 then da�o = 0
    
    npclist(npcindex).stats.minhp = npclist(npcindex).stats.minhp - da�o
    call writeconsolemsg(userindex, "�le has causado " & da�o & " puntos de da�o a la criatura!", fonttypenames.fonttype_fight)
    call calculardarexp(userindex, npcindex, da�o)

    if npclist(npcindex).stats.minhp < 1 then
        npclist(npcindex).stats.minhp = 0
        call muerenpc(npcindex, userindex)
    end if
end if

end sub

sub infohechizo(byval userindex as integer)


    dim h as integer
    h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
    
    
    call decirpalabrasmagicas(hechizos(h).palabrasmagicas, userindex)
    
    if userlist(userindex).flags.targetuser > 0 then
        call senddata(sendtarget.topcarea, userlist(userindex).flags.targetuser, preparemessagecreatefx(userlist(userlist(userindex).flags.targetuser).char.charindex, hechizos(h).fxgrh, hechizos(h).loops))
        call senddata(sendtarget.topcarea, userlist(userindex).flags.targetuser, preparemessageplaywave(hechizos(h).wav, userlist(userlist(userindex).flags.targetuser).pos.x, userlist(userlist(userindex).flags.targetuser).pos.y)) 'esta linea faltaba. pablo (toxicwaste)
    elseif userlist(userindex).flags.targetnpc > 0 then
        call senddata(sendtarget.tonpcarea, userlist(userindex).flags.targetnpc, preparemessagecreatefx(npclist(userlist(userindex).flags.targetnpc).char.charindex, hechizos(h).fxgrh, hechizos(h).loops))
        call senddata(sendtarget.tonpcarea, userlist(userindex).flags.targetnpc, preparemessageplaywave(hechizos(h).wav, npclist(userlist(userindex).flags.targetnpc).pos.x, npclist(userlist(userindex).flags.targetnpc).pos.y))
    end if
    
    if userlist(userindex).flags.targetuser > 0 then
        if userindex <> userlist(userindex).flags.targetuser then
            if userlist(userindex).showname then
                call writeconsolemsg(userindex, hechizos(h).hechizeromsg & " " & userlist(userlist(userindex).flags.targetuser).name, fonttypenames.fonttype_fight)
            else
                call writeconsolemsg(userindex, hechizos(h).hechizeromsg & " alguien.", fonttypenames.fonttype_fight)
            end if
            call writeconsolemsg(userlist(userindex).flags.targetuser, userlist(userindex).name & " " & hechizos(h).targetmsg, fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, hechizos(h).propiomsg, fonttypenames.fonttype_fight)
        end if
    elseif userlist(userindex).flags.targetnpc > 0 then
        call writeconsolemsg(userindex, hechizos(h).hechizeromsg & " " & "la criatura.", fonttypenames.fonttype_fight)
    end if

end sub

sub hechizopropusuario(byval userindex as integer, byref b as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 02/01/2008
'02/01/2008 marcos (byval) - no permite tirar curar heridas a usuarios muertos.
'***************************************************

dim h as integer
dim da�o as long
dim tempchr as integer

h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
tempchr = userlist(userindex).flags.targetuser
      
if userlist(tempchr).flags.muerto then
    call writeconsolemsg(userindex, "no pod�s lanzar ese hechizo a un muerto.", fonttypenames.fonttype_info)
    exit sub
end if
      
'hambre
if hechizos(h).subeham = 1 then
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minham, hechizos(h).maxham)
    
    userlist(tempchr).stats.minham = userlist(tempchr).stats.minham + da�o
    if userlist(tempchr).stats.minham > userlist(tempchr).stats.maxham then _
        userlist(tempchr).stats.minham = userlist(tempchr).stats.maxham
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de hambre a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
    end if
    
    call writeupdatehungerandthirst(tempchr)
    b = true
    
elseif hechizos(h).subeham = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    else
        exit sub
    end if
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minham, hechizos(h).maxham)
    
    userlist(tempchr).stats.minham = userlist(tempchr).stats.minham - da�o
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de hambre a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha quitado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de hambre.", fonttypenames.fonttype_fight)
    end if
    
    b = true
    
    if userlist(tempchr).stats.minham < 1 then
        userlist(tempchr).stats.minham = 0
        userlist(tempchr).flags.hambre = 1
    end if
    
    call writeupdatehungerandthirst(tempchr)
end if

'sed
if hechizos(h).subesed = 1 then
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minsed, hechizos(h).maxsed)
    
    userlist(tempchr).stats.minagu = userlist(tempchr).stats.minagu + da�o
    if userlist(tempchr).stats.minagu > userlist(tempchr).stats.maxagu then _
        userlist(tempchr).stats.minagu = userlist(tempchr).stats.maxagu
    
    call writeupdatehungerandthirst(tempchr)
         
    if userindex <> tempchr then
      call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de sed a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
      call writeconsolemsg(tempchr, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
    else
      call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
    end if
    
    b = true
    
elseif hechizos(h).subesed = 2 then
    
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minsed, hechizos(h).maxsed)
    
    userlist(tempchr).stats.minagu = userlist(tempchr).stats.minagu - da�o
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de sed a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha quitado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de sed.", fonttypenames.fonttype_fight)
    end if
    
    if userlist(tempchr).stats.minagu < 1 then
        userlist(tempchr).stats.minagu = 0
        userlist(tempchr).flags.sed = 1
    end if
    
    call writeupdatehungerandthirst(tempchr)
    
    b = true
end if

' <-------- agilidad ---------->
if hechizos(h).subeagilidad = 1 then
    
    'para poder tirar cl a un pk en el ring
    if (triggerzonapelea(userindex, tempchr) <> trigger6_permite) then
        if criminal(tempchr) and not criminal(userindex) then
            if esarmada(userindex) then
                call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
            if userlist(userindex).flags.seguro then
                call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                call disnobauban(userindex, userlist(userindex).reputacion.noblerep * 0.5, 10000)
            end if
        end if
    end if
    
    call infohechizo(userindex)
    da�o = randomnumber(hechizos(h).minagilidad, hechizos(h).maxagilidad)
    
    userlist(tempchr).flags.duracionefecto = 1200
    userlist(tempchr).stats.useratributos(eatributos.agilidad) = userlist(tempchr).stats.useratributos(eatributos.agilidad) + da�o
    if userlist(tempchr).stats.useratributos(eatributos.agilidad) > minimoint(maxatributos, userlist(tempchr).stats.useratributosbackup(agilidad) * 2) then _
        userlist(tempchr).stats.useratributos(eatributos.agilidad) = minimoint(maxatributos, userlist(tempchr).stats.useratributosbackup(agilidad) * 2)
    userlist(tempchr).flags.tomopocion = true
    b = true
    
elseif hechizos(h).subeagilidad = 2 then
    
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    userlist(tempchr).flags.tomopocion = true
    da�o = randomnumber(hechizos(h).minagilidad, hechizos(h).maxagilidad)
    userlist(tempchr).flags.duracionefecto = 700
    userlist(tempchr).stats.useratributos(eatributos.agilidad) = userlist(tempchr).stats.useratributos(eatributos.agilidad) - da�o
    if userlist(tempchr).stats.useratributos(eatributos.agilidad) < minatributos then userlist(tempchr).stats.useratributos(eatributos.agilidad) = minatributos
    b = true
    
end if

' <-------- fuerza ---------->
if hechizos(h).subefuerza = 1 then
    'para poder tirar fuerza a un pk en el ring
    if (triggerzonapelea(userindex, tempchr) <> trigger6_permite) then
        if criminal(tempchr) and not criminal(userindex) then
            if esarmada(userindex) then
                call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
            if userlist(userindex).flags.seguro then
                call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                call disnobauban(userindex, userlist(userindex).reputacion.noblerep * 0.5, 10000)
            end if
        end if
    end if
    
    call infohechizo(userindex)
    da�o = randomnumber(hechizos(h).minfuerza, hechizos(h).maxfuerza)
    
    userlist(tempchr).flags.duracionefecto = 1200

    userlist(tempchr).stats.useratributos(eatributos.fuerza) = userlist(tempchr).stats.useratributos(eatributos.fuerza) + da�o
    if userlist(tempchr).stats.useratributos(eatributos.fuerza) > minimoint(maxatributos, userlist(tempchr).stats.useratributosbackup(fuerza) * 2) then _
        userlist(tempchr).stats.useratributos(eatributos.fuerza) = minimoint(maxatributos, userlist(tempchr).stats.useratributosbackup(fuerza) * 2)
    
    userlist(tempchr).flags.tomopocion = true
    b = true
    
elseif hechizos(h).subefuerza = 2 then

    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    userlist(tempchr).flags.tomopocion = true
    
    da�o = randomnumber(hechizos(h).minfuerza, hechizos(h).maxfuerza)
    userlist(tempchr).flags.duracionefecto = 700
    userlist(tempchr).stats.useratributos(eatributos.fuerza) = userlist(tempchr).stats.useratributos(eatributos.fuerza) - da�o
    if userlist(tempchr).stats.useratributos(eatributos.fuerza) < minatributos then userlist(tempchr).stats.useratributos(eatributos.fuerza) = minatributos
    b = true
    
end if

'salud
if hechizos(h).subehp = 1 then
    
    'verifica que el usuario no este muerto
    if userlist(tempchr).flags.muerto = 1 then
        call writeconsolemsg(userindex, "�est� muerto!", fonttypenames.fonttype_info)
        b = false
        exit sub
    end if
    
    'para poder tirar curar a un pk en el ring
    if (triggerzonapelea(userindex, tempchr) <> trigger6_permite) then
        if criminal(tempchr) and not criminal(userindex) then
            if esarmada(userindex) then
                call writeconsolemsg(userindex, "los armadas no pueden ayudar a los criminales", fonttypenames.fonttype_info)
                b = false
                exit sub
            end if
            if userlist(userindex).flags.seguro then
                call writeconsolemsg(userindex, "para ayudar criminales debes sacarte el seguro ya que te volver�s criminal como ellos", fonttypenames.fonttype_info)
                b = false
                exit sub
            else
                call disnobauban(userindex, userlist(userindex).reputacion.noblerep * 0.5, 10000)
            end if
        end if
    end if
       
    da�o = randomnumber(hechizos(h).minhp, hechizos(h).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    call infohechizo(userindex)

    userlist(tempchr).stats.minhp = userlist(tempchr).stats.minhp + da�o
    if userlist(tempchr).stats.minhp > userlist(tempchr).stats.maxhp then _
        userlist(tempchr).stats.minhp = userlist(tempchr).stats.maxhp
    
    call writeupdatehp(tempchr)
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de vida a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
    end if
    
    b = true
elseif hechizos(h).subehp = 2 then
    
    if userindex = tempchr then
        call writeconsolemsg(userindex, "no puedes atacarte a vos mismo.", fonttypenames.fonttype_fight)
        exit sub
    end if
    
    da�o = randomnumber(hechizos(h).minhp, hechizos(h).maxhp)
    
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    if hechizos(h).staffaffected then
        if userlist(userindex).clase = eclass.mage then
            if userlist(userindex).invent.weaponeqpobjindex > 0 then
                da�o = (da�o * (objdata(userlist(userindex).invent.weaponeqpobjindex).staffdamagebonus + 70)) / 100
            else
                da�o = da�o * 0.7 'baja da�o a 70% del original
            end if
        end if
    end if
    
    if userlist(userindex).invent.anilloeqpobjindex = laudmagico or userlist(userindex).invent.anilloeqpobjindex = flautamagica then
        da�o = da�o * 1.04  'laud magico de los bardos
    end if
    
    'cascos antimagia
    if (userlist(tempchr).invent.cascoeqpobjindex > 0) then
        da�o = da�o - randomnumber(objdata(userlist(tempchr).invent.cascoeqpobjindex).defensamagicamin, objdata(userlist(tempchr).invent.cascoeqpobjindex).defensamagicamax)
    end if
    
    'anillos
    if (userlist(tempchr).invent.anilloeqpobjindex > 0) then
        da�o = da�o - randomnumber(objdata(userlist(tempchr).invent.anilloeqpobjindex).defensamagicamin, objdata(userlist(tempchr).invent.anilloeqpobjindex).defensamagicamax)
    end if
    
    if da�o < 0 then da�o = 0
    
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    userlist(tempchr).stats.minhp = userlist(tempchr).stats.minhp - da�o
    
    call writeupdatehp(tempchr)
    
    call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de vida a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
    call writeconsolemsg(tempchr, userlist(userindex).name & " te ha quitado " & da�o & " puntos de vida.", fonttypenames.fonttype_fight)
    
    'muere
    if userlist(tempchr).stats.minhp < 1 then
        'store it!
        call statistics.storefrag(userindex, tempchr)
        
        call contarmuerte(tempchr, userindex)
        userlist(tempchr).stats.minhp = 0
        call actstats(tempchr, userindex)
        call userdie(tempchr)
    end if
    
    b = true
end if

'mana
if hechizos(h).subemana = 1 then
    
    call infohechizo(userindex)
    userlist(tempchr).stats.minman = userlist(tempchr).stats.minman + da�o
    if userlist(tempchr).stats.minman > userlist(tempchr).stats.maxman then _
        userlist(tempchr).stats.minman = userlist(tempchr).stats.maxman
    
    call writeupdatemana(tempchr)
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de mana a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de mana.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de mana.", fonttypenames.fonttype_fight)
    end if
    
    b = true
    
elseif hechizos(h).subemana = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de mana a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha quitado " & da�o & " puntos de mana.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de mana.", fonttypenames.fonttype_fight)
    end if
    
    userlist(tempchr).stats.minman = userlist(tempchr).stats.minman - da�o
    if userlist(tempchr).stats.minman < 1 then userlist(tempchr).stats.minman = 0
    
    call writeupdatemana(tempchr)
    
    b = true
end if

'stamina
if hechizos(h).subesta = 1 then
    call infohechizo(userindex)
    userlist(tempchr).stats.minsta = userlist(tempchr).stats.minsta + da�o
    if userlist(tempchr).stats.minsta > userlist(tempchr).stats.maxsta then _
        userlist(tempchr).stats.minsta = userlist(tempchr).stats.maxsta
    
    call writeupdatesta(tempchr)
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has restaurado " & da�o & " puntos de vitalidad a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha restaurado " & da�o & " puntos de vitalidad.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has restaurado " & da�o & " puntos de vitalidad.", fonttypenames.fonttype_fight)
    end if
    b = true
elseif hechizos(h).subesta = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    if userindex <> tempchr then
        call writeconsolemsg(userindex, "le has quitado " & da�o & " puntos de vitalidad a " & userlist(tempchr).name, fonttypenames.fonttype_fight)
        call writeconsolemsg(tempchr, userlist(userindex).name & " te ha quitado " & da�o & " puntos de vitalidad.", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "te has quitado " & da�o & " puntos de vitalidad.", fonttypenames.fonttype_fight)
    end if
    
    userlist(tempchr).stats.minsta = userlist(tempchr).stats.minsta - da�o
    
    if userlist(tempchr).stats.minsta < 1 then userlist(tempchr).stats.minsta = 0
    
    call writeupdatesta(tempchr)
    
    b = true
end if

call flushbuffer(tempchr)

end sub

sub updateuserhechizos(byval updateall as boolean, byval userindex as integer, byval slot as byte)

'call logtarea("sub updateuserhechizos")

dim loopc as byte

'actualiza un solo slot
if not updateall then

    'actualiza el inventario
    if userlist(userindex).stats.userhechizos(slot) > 0 then
        call changeuserhechizo(userindex, slot, userlist(userindex).stats.userhechizos(slot))
    else
        call changeuserhechizo(userindex, slot, 0)
    end if

else

'actualiza todos los slots
for loopc = 1 to maxuserhechizos

        'actualiza el inventario
        if userlist(userindex).stats.userhechizos(loopc) > 0 then
            call changeuserhechizo(userindex, loopc, userlist(userindex).stats.userhechizos(loopc))
        else
            call changeuserhechizo(userindex, loopc, 0)
        end if

next loopc

end if

end sub

sub changeuserhechizo(byval userindex as integer, byval slot as byte, byval hechizo as integer)

'call logtarea("changeuserhechizo")

userlist(userindex).stats.userhechizos(slot) = hechizo


if hechizo > 0 and hechizo < numerohechizos + 1 then
    
    call writechangespellslot(userindex, slot)

else

    call writechangespellslot(userindex, slot)

end if


end sub


public sub desplazarhechizo(byval userindex as integer, byval dire as integer, byval cualhechizo as integer)

if (dire <> 1 and dire <> -1) then exit sub
if not (cualhechizo >= 1 and cualhechizo <= maxuserhechizos) then exit sub

dim temphechizo as integer

if dire = 1 then 'mover arriba
    if cualhechizo = 1 then
        call writeconsolemsg(userindex, "no puedes mover el hechizo en esa direccion.", fonttypenames.fonttype_info)
        exit sub
    else
        temphechizo = userlist(userindex).stats.userhechizos(cualhechizo)
        userlist(userindex).stats.userhechizos(cualhechizo) = userlist(userindex).stats.userhechizos(cualhechizo - 1)
        userlist(userindex).stats.userhechizos(cualhechizo - 1) = temphechizo

        'prevent the user from casting other spells than the one he had selected when he hitted "cast".
        if userlist(userindex).flags.hechizo > 0 then
            userlist(userindex).flags.hechizo = userlist(userindex).flags.hechizo - 1
        end if
    end if
else 'mover abajo
    if cualhechizo = maxuserhechizos then
        call writeconsolemsg(userindex, "no puedes mover el hechizo en esa direccion.", fonttypenames.fonttype_info)
        exit sub
    else
        temphechizo = userlist(userindex).stats.userhechizos(cualhechizo)
        userlist(userindex).stats.userhechizos(cualhechizo) = userlist(userindex).stats.userhechizos(cualhechizo + 1)
        userlist(userindex).stats.userhechizos(cualhechizo + 1) = temphechizo

        'prevent the user from casting other spells than the one he had selected when he hitted "cast".
        if userlist(userindex).flags.hechizo > 0 then
            userlist(userindex).flags.hechizo = userlist(userindex).flags.hechizo + 1
        end if
    end if
end if
end sub


public sub disnobauban(byval userindex as integer, noblepts as long, bandidopts as long)
'disminuye la nobleza noblepts puntos y aumenta el bandido bandidopts puntos
    dim eracriminal as boolean
    eracriminal = criminal(userindex)
    
    'si estamos en la arena no hacemos nada
    if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub
    
if userlist(userindex).flags.privilegios and (playertype.user or playertype.consejero) then
    'pierdo nobleza...
    userlist(userindex).reputacion.noblerep = userlist(userindex).reputacion.noblerep - noblepts
    if userlist(userindex).reputacion.noblerep < 0 then
        userlist(userindex).reputacion.noblerep = 0
    end if
    
    'gano bandido...
    userlist(userindex).reputacion.bandidorep = userlist(userindex).reputacion.bandidorep + bandidopts
    if userlist(userindex).reputacion.bandidorep > maxrep then _
        userlist(userindex).reputacion.bandidorep = maxrep
    call writenobilitylost(userindex)
    if criminal(userindex) then if userlist(userindex).faccion.armadareal = 1 then call expulsarfaccionreal(userindex)
end if
    
    if not eracriminal and criminal(userindex) then
        call refreshcharstatus(userindex)
    end if
end sub
