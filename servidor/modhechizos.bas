attribute vb_name = "modhechizos"
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

sub npclanzaspellsobreuser(byval npcindex as integer, byval userindex as integer, byval spell as integer)

if npclist(npcindex).canattack = 0 then exit sub
if userlist(userindex).flags.invisible = 1 then exit sub

npclist(npcindex).canattack = 0
dim da�o as integer

if hechizos(spell).subehp = 1 then

    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)

    userlist(userindex).stats.minhp = userlist(userindex).stats.minhp + da�o
    if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
    
    call senddata(toindex, userindex, 0, "||" & npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida." & fonttype_fight)

elseif hechizos(spell).subehp = 2 then
    
    da�o = randomnumber(hechizos(spell).minhp, hechizos(spell).maxhp)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)

    if userlist(userindex).flags.privilegios = 0 then userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - da�o
    
    call senddata(toindex, userindex, 0, "||" & npclist(npcindex).name & " te ha quitado " & da�o & " puntos de vida." & fonttype_fight)
    
    'muere
    if userlist(userindex).stats.minhp < 1 then
        userlist(userindex).stats.minhp = 0
        call userdie(userindex)
    end if
    
end if

if hechizos(spell).paraliza = 1 then
     if userlist(userindex).flags.paralizado = 0 then
          userlist(userindex).flags.paralizado = 1
          userlist(userindex).counters.paralisis = intervaloparalizado
          call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(spell).wav)
          call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & hechizos(spell).fxgrh & "," & hechizos(spell).loops)
          call senddata(toindex, userindex, 0, "paradok")
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
        call senddata(toindex, userindex, 0, "||no tenes espacio para mas hechizos." & fonttype_info)
    else
        userlist(userindex).stats.userhechizos(j) = hindex
        call updateuserhechizos(false, userindex, cbyte(j))
        'quitamos del inv el item
        call quitaruserinvitem(userindex, cbyte(slot), 1)
    end if
else
    call senddata(toindex, userindex, 0, "||ya tenes ese hechizo." & fonttype_info)
end if

end sub
            
sub decirpalabrasmagicas(byval s as string, byval userindex as integer)
on error resume next

    dim ind as string
    ind = userlist(userindex).char.charindex
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbcyan & "�" & s & "�" & ind)
    exit sub
end sub
function puedelanzar(byval userindex as integer, byval hechizoindex as integer) as boolean


if userlist(userindex).flags.muerto = 0 then
    dim wp2 as worldpos
    wp2.map = userlist(userindex).flags.targetmap
    wp2.x = userlist(userindex).flags.targetx
    wp2.y = userlist(userindex).flags.targety
    
    if distancia(userlist(userindex).pos, wp2) > 18 then
            'userlist(userindex).flags.administrativeban = 1
            'call senddata(toall, 0, 0, "||los dioses han desterrado a " & userlist(userindex).name & fonttype_info)
            'call loghackattemp(userlist(userindex).name & " ip:" & userlist(userindex).ip & " trato de lanzar un spell desde otro mapa.")
            'call cerrar_usuario(userindex)
            exit function
    end if
    
    if userlist(userindex).stats.minman >= hechizos(hechizoindex).manarequerido then
        if userlist(userindex).stats.userskills(magia) >= hechizos(hechizoindex).minskill then
            puedelanzar = (userlist(userindex).stats.minsta > 0)
        else
            call senddata(toindex, userindex, 0, "||no tenes suficientes puntos de magia para lanzar este hechizo." & fonttype_info)
            puedelanzar = false
        end if
    else
            call senddata(toindex, userindex, 0, "||no tenes suficiente mana." & fonttype_info)
            puedelanzar = false
    end if
else
   call senddata(toindex, userindex, 0, "||no podes lanzar hechizos porque estas muerto." & fonttype_info)
   puedelanzar = false
end if

end function

sub hechizoinvocacion(byval userindex as integer, byref b as boolean)

'call logtarea("hechizoinvocacion")
if userlist(userindex).nromacotas >= maxmascotas then exit sub

dim h as integer, j as integer, ind as integer, index as integer
dim targetpos as worldpos


targetpos.map = userlist(userindex).flags.targetmap
targetpos.x = userlist(userindex).flags.targetx
targetpos.y = userlist(userindex).flags.targety

h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
    
    
for j = 1 to hechizos(h).cant
    
    if userlist(userindex).nromacotas < maxmascotas then
        ind = spawnnpc(hechizos(h).numnpc, targetpos, true, false)
        if ind <= maxnpcs then
            userlist(userindex).nromacotas = userlist(userindex).nromacotas + 1
            
            index = freemascotaindex(userindex)
            
            userlist(userindex).mascotasindex(index) = ind
            userlist(userindex).mascotastype(index) = npclist(ind).numero
            
            npclist(ind).maestrouser = userindex
            npclist(ind).contadores.tiempoexistencia = intervaloinvocacion
            npclist(ind).givegld = 0
            
            call followamo(ind)
        end if
            
    else
        exit for
    end if
    
next j


call infohechizo(userindex)
b = true


end sub

sub handlehechizoterreno(byval userindex as integer, byval uh as integer)

dim b as boolean

select case hechizos(uh).tipo
    case uinvocacion '
       call hechizoinvocacion(userindex, b)
end select

if b then
    call subirskill(userindex, magia)
    'if hechizos(uh).resis = 1 then call subirskill(userlist(userindex).flags.targetuser, resis)
    userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    call senduserstatsbox(userindex)
end if


end sub

sub handlehechizousuario(byval userindex as integer, byval uh as integer)

dim b as boolean
select case hechizos(uh).tipo
    case uestado ' afectan estados (por ejem : envenenamiento)
       call hechizoestadousuario(userindex, b)
    case upropiedades ' afectan hp,mana,stamina,etc
       call hechizopropusuario(userindex, b)
end select

if b then
    call subirskill(userindex, magia)
    'if hechizos(uh).resis = 1 then call subirskill(userlist(userindex).flags.targetuser, resis)
    userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    call senduserstatsbox(userindex)
    call senduserstatsbox(userlist(userindex).flags.targetuser)
    userlist(userindex).flags.targetuser = 0
end if

end sub

sub handlehechizonpc(byval userindex as integer, byval uh as integer)



dim b as boolean

select case hechizos(uh).tipo
    case uestado ' afectan estados (por ejem : envenenamiento)
       call hechizoestadonpc(userlist(userindex).flags.targetnpc, uh, b, userindex)
    case upropiedades ' afectan hp,mana,stamina,etc
       call hechizopropnpc(uh, userlist(userindex).flags.targetnpc, userindex, b)
end select

if b then
    call subirskill(userindex, magia)
    userlist(userindex).flags.targetnpc = 0
    userlist(userindex).stats.minman = userlist(userindex).stats.minman - hechizos(uh).manarequerido
    if userlist(userindex).stats.minman < 0 then userlist(userindex).stats.minman = 0
    call senduserstatsbox(userindex)
end if

end sub
sub lanzarhechizo(index as integer, userindex as integer)



dim uh as integer
dim exito as boolean

uh = userlist(userindex).stats.userhechizos(index)

if puedelanzar(userindex, uh) then
    select case hechizos(uh).target
        
        case uusuarios
            if userlist(userindex).flags.targetuser > 0 then
                call handlehechizousuario(userindex, uh)
            else
                call senddata(toindex, userindex, 0, "||este hechizo actua solo sobre usuarios." & fonttype_info)
            end if
        case unpc
            if userlist(userindex).flags.targetnpc > 0 then
                call handlehechizonpc(userindex, uh)
            else
                call senddata(toindex, userindex, 0, "||este hechizo solo afecta a los npcs." & fonttype_info)
            end if
        case uusuariosynpc
            if userlist(userindex).flags.targetuser > 0 then
                call handlehechizousuario(userindex, uh)
            elseif userlist(userindex).flags.targetnpc > 0 then
                call handlehechizonpc(userindex, uh)
            else
                call senddata(toindex, userindex, 0, "||target invalido." & fonttype_info)
            end if
        case uterreno
            call handlehechizoterreno(userindex, uh)
    end select
    
end if
                

end sub
sub hechizoestadousuario(byval userindex as integer, byref b as boolean)



dim h as integer, tu as integer
h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
tu = userlist(userindex).flags.targetuser

if hechizos(h).invisibilidad = 1 then
   userlist(tu).flags.invisible = 1
   call senddata(tomap, 0, userlist(tu).pos.map, "nover" & userlist(tu).char.charindex & ",1")
   call infohechizo(userindex)
   b = true
end if

if hechizos(h).envenena = 1 then
        if not puedeatacar(userindex, tu) then exit sub
        if userindex <> tu then
            call usuarioatacadoporusuario(userindex, tu)
        end if
        userlist(tu).flags.envenenado = 1
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).curaveneno = 1 then
        userlist(tu).flags.envenenado = 0
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).maldicion = 1 then
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

if hechizos(h).paraliza = 1 then
     if userlist(tu).flags.paralizado = 0 then
            if not puedeatacar(userindex, tu) then exit sub
            
            if userindex <> tu then
                call usuarioatacadoporusuario(userindex, tu)
            end if
            
            userlist(tu).flags.paralizado = 1
            userlist(tu).counters.paralisis = intervaloparalizado
            call senddata(toindex, tu, 0, "paradok")
            call infohechizo(userindex)
            b = true
    end if
end if

if hechizos(h).removerparalisis = 1 then
    if userlist(tu).flags.paralizado = 1 then
                userlist(tu).flags.paralizado = 0
                call senddata(toindex, tu, 0, "paradok")
                call infohechizo(userindex)
                b = true
    end if
end if

if hechizos(h).revivir = 1 then
    if userlist(tu).flags.muerto = 1 then
        if not criminal(tu) then
                if tu <> userindex then
                    call addtovar(userlist(userindex).reputacion.noblerep, 500, maxrep)
                    call senddata(toindex, userindex, 0, "||�los dioses te sonrien, has ganado 500 puntos de nobleza!." & fonttype_info)
                end if
        end if
        
        call revivirusuario(tu)
    end if
    call infohechizo(userindex)
    b = true
end if

if hechizos(h).ceguera = 1 then
        if not puedeatacar(userindex, tu) then exit sub
        if userindex <> tu then
            call usuarioatacadoporusuario(userindex, tu)
        end if
        userlist(tu).flags.ceguera = 1
        userlist(tu).counters.ceguera = intervaloparalizado
        call senddata(toindex, tu, 0, "cegu")
        call infohechizo(userindex)
        b = true
end if

if hechizos(h).estupidez = 1 then
        if not puedeatacar(userindex, tu) then exit sub
        if userindex <> tu then
            call usuarioatacadoporusuario(userindex, tu)
        end if
        userlist(tu).flags.estupidez = 1
        userlist(tu).counters.ceguera = intervaloparalizado
        call senddata(toindex, tu, 0, "dumb")
        call infohechizo(userindex)
        b = true
end if

end sub
sub hechizoestadonpc(byval npcindex as integer, byval hindex as integer, byref b as boolean, byval userindex as integer)



if hechizos(hindex).invisibilidad = 1 then
   call infohechizo(userindex)
   npclist(npcindex).flags.invisible = 1
   b = true
end if

if hechizos(hindex).envenena = 1 then
   if npclist(npcindex).attackable = 0 then
        call senddata(toindex, userindex, 0, "||no podes atacar a ese npc." & fonttype_info)
        exit sub
   end if
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
   if npclist(npcindex).attackable = 0 then
        call senddata(toindex, userindex, 0, "||no podes atacar a ese npc." & fonttype_info)
        exit sub
   end if
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
            call infohechizo(userindex)
            npclist(npcindex).flags.paralizado = 1
            npclist(npcindex).contadores.paralisis = intervaloparalizado
            b = true
   else
      call senddata(toindex, userindex, 0, "||el npc es inmune a este hechizo." & fonttype_fight)
   end if
end if

if hechizos(hindex).removerparalisis = 1 then
   if npclist(npcindex).flags.paralizado = 1 then
            call infohechizo(userindex)
            npclist(npcindex).flags.paralizado = 0
            npclist(npcindex).contadores.paralisis = 0
            b = true
   else
      call senddata(toindex, userindex, 0, "||el npc no esta paralizado." & fonttype_fight)
   end if
end if

 


end sub

sub hechizopropnpc(byval hindex as integer, byval npcindex as integer, byval userindex as integer, byref b as boolean)

dim da�o as integer


'salud
if hechizos(hindex).subehp = 1 then
    da�o = randomnumber(hechizos(hindex).minhp, hechizos(hindex).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    call infohechizo(userindex)
    call addtovar(npclist(npcindex).stats.minhp, da�o, npclist(npcindex).stats.maxhp)
    call senddata(toindex, userindex, 0, "||has curado " & da�o & " puntos de salud a la criatura." & fonttype_fight)
    b = true
elseif hechizos(hindex).subehp = 2 then
    
    if npclist(npcindex).attackable = 0 then
        call senddata(toindex, userindex, 0, "||no podes atacar a ese npc." & fonttype_info)
        exit sub
    end if
    
    da�o = randomnumber(hechizos(hindex).minhp, hechizos(hindex).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    call infohechizo(userindex)
    b = true
    call npcatacado(npcindex, userindex)
    if npclist(npcindex).flags.snd2 > 0 then call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & npclist(npcindex).flags.snd2)
    
    npclist(npcindex).stats.minhp = npclist(npcindex).stats.minhp - _
    da�o
    senddata toindex, userindex, 0, "||le has causado " & da�o & " puntos de da�o a la criatura!" & fonttype_fight
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
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & hechizos(h).wav)
    
    if userlist(userindex).flags.targetuser > 0 then
        call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userlist(userindex).flags.targetuser).char.charindex & "," & hechizos(h).fxgrh & "," & hechizos(h).loops)
    elseif userlist(userindex).flags.targetnpc > 0 then
        call senddata(topcarea, userindex, npclist(userlist(userindex).flags.targetnpc).pos.map, "cfx" & npclist(userlist(userindex).flags.targetnpc).char.charindex & "," & hechizos(h).fxgrh & "," & hechizos(h).loops)
    end if
    
    if userlist(userindex).flags.targetuser > 0 then
        if userindex <> userlist(userindex).flags.targetuser then
            call senddata(toindex, userindex, 0, "||" & hechizos(h).hechizeromsg & " " & userlist(userlist(userindex).flags.targetuser).name & fonttype_fight)
            call senddata(toindex, userlist(userindex).flags.targetuser, 0, "||" & userlist(userindex).name & " " & hechizos(h).targetmsg & fonttype_fight)
        else
            call senddata(toindex, userindex, 0, "||" & hechizos(h).propiomsg & fonttype_fight)
        end if
    elseif userlist(userindex).flags.targetnpc > 0 then
        call senddata(toindex, userindex, 0, "||" & hechizos(h).hechizeromsg & " " & "la criatura." & fonttype_fight)
    end if
    
end sub

sub hechizopropusuario(byval userindex as integer, byref b as boolean)

dim h as integer
dim da�o as integer
dim tempchr as integer
    
h = userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)
tempchr = userlist(userindex).flags.targetuser
      
'hambre
if hechizos(h).subeham = 1 then
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minham, hechizos(h).maxham)
    
    call addtovar(userlist(tempchr).stats.minham, _
         da�o, userlist(tempchr).stats.maxham)
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has restaurado " & da�o & " puntos de hambre a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha restaurado " & da�o & " puntos de hambre." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has restaurado " & da�o & " puntos de hambre." & fonttype_fight)
    end if
    
    call enviarhambreysed(tempchr)
    b = true
    
elseif hechizos(h).subeham = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    da�o = randomnumber(hechizos(h).minham, hechizos(h).maxham)
    
    userlist(tempchr).stats.minham = userlist(tempchr).stats.minham - da�o
    
    if userlist(tempchr).stats.minham < 0 then userlist(tempchr).stats.minham = 0
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has quitado " & da�o & " puntos de hambre a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha quitado " & da�o & " puntos de hambre." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has quitado " & da�o & " puntos de hambre." & fonttype_fight)
    end if
    
    call enviarhambreysed(tempchr)
    
    b = true
    
    if userlist(tempchr).stats.minham < 1 then
        userlist(tempchr).stats.minham = 0
        userlist(tempchr).flags.hambre = 1
    end if
    
end if

'sed
if hechizos(h).subesed = 1 then
    
    call infohechizo(userindex)
    
    call addtovar(userlist(tempchr).stats.minagu, da�o, _
         userlist(tempchr).stats.maxagu)
         
    if userindex <> tempchr then
      call senddata(toindex, userindex, 0, "||le has restaurado " & da�o & " puntos de sed a " & userlist(tempchr).name & fonttype_fight)
      call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha restaurado " & da�o & " puntos de sed." & fonttype_fight)
    else
      call senddata(toindex, userindex, 0, "||te has restaurado " & da�o & " puntos de sed." & fonttype_fight)
    end if
    
    b = true
    
elseif hechizos(h).subesed = 2 then
    
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    userlist(tempchr).stats.minagu = userlist(tempchr).stats.minagu - da�o
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has quitado " & da�o & " puntos de sed a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha quitado " & da�o & " puntos de sed." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has quitado " & da�o & " puntos de sed." & fonttype_fight)
    end if
    
    if userlist(tempchr).stats.minagu < 1 then
            userlist(tempchr).stats.minagu = 0
            userlist(tempchr).flags.sed = 1
    end if
    
    b = true
end if

' <-------- agilidad ---------->
if hechizos(h).subeagilidad = 1 then
    
    call infohechizo(userindex)
    da�o = randomnumber(hechizos(h).minagilidad, hechizos(h).maxagilidad)
    
    userlist(tempchr).flags.duracionefecto = 1200
    call addtovar(userlist(tempchr).stats.useratributos(agilidad), da�o, maxatributos)
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
    userlist(tempchr).stats.useratributos(agilidad) = userlist(tempchr).stats.useratributos(agilidad) - da�o
    if userlist(tempchr).stats.useratributos(agilidad) < minatributos then userlist(tempchr).stats.useratributos(agilidad) = minatributos
    b = true
    
end if

' <-------- fuerza ---------->
if hechizos(h).subefuerza = 1 then
    
    call infohechizo(userindex)
    da�o = randomnumber(hechizos(h).minfuerza, hechizos(h).maxfuerza)
    
    userlist(tempchr).flags.duracionefecto = 1200
    
    call addtovar(userlist(tempchr).stats.useratributos(fuerza), da�o, maxatributos)
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
    userlist(tempchr).stats.useratributos(fuerza) = userlist(tempchr).stats.useratributos(fuerza) - da�o
    if userlist(tempchr).stats.useratributos(fuerza) < minatributos then userlist(tempchr).stats.useratributos(fuerza) = minatributos
    b = true
    
end if

'salud
if hechizos(h).subehp = 1 then
    da�o = randomnumber(hechizos(h).minhp, hechizos(h).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    call infohechizo(userindex)
    
    call addtovar(userlist(tempchr).stats.minhp, da�o, _
         userlist(tempchr).stats.maxhp)
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has restaurado " & da�o & " puntos de vida a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha restaurado " & da�o & " puntos de vida." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has restaurado " & da�o & " puntos de vida." & fonttype_fight)
    end if
    
    b = true
elseif hechizos(h).subehp = 2 then
    
    if userindex = tempchr then
        call senddata(toindex, userindex, 0, "||no podes atacarte a vos mismo." & fonttype_fight)
        exit sub
    end if
    
    da�o = randomnumber(hechizos(h).minhp, hechizos(h).maxhp)
    da�o = da�o + porcentaje(da�o, 3 * userlist(userindex).stats.elv)
    
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    userlist(tempchr).stats.minhp = userlist(tempchr).stats.minhp - da�o
    
    call senddata(toindex, userindex, 0, "||le has quitado " & da�o & " puntos de vida a " & userlist(tempchr).name & fonttype_fight)
    call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha quitado " & da�o & " puntos de vida." & fonttype_fight)
    
    'muere
    if userlist(tempchr).stats.minhp < 1 then
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
    call addtovar(userlist(tempchr).stats.minman, da�o, userlist(tempchr).stats.maxman)
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has restaurado " & da�o & " puntos de mana a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha restaurado " & da�o & " puntos de mana." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has restaurado " & da�o & " puntos de mana." & fonttype_fight)
    end if
    
    b = true
    
elseif hechizos(h).subemana = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has quitado " & da�o & " puntos de mana a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha quitado " & da�o & " puntos de mana." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has quitado " & da�o & " puntos de mana." & fonttype_fight)
    end if
    
    userlist(tempchr).stats.minman = userlist(tempchr).stats.minman - da�o
    if userlist(tempchr).stats.minman < 1 then userlist(tempchr).stats.minman = 0
    b = true
    
end if

'stamina
if hechizos(h).subesta = 1 then
    call infohechizo(userindex)
    call addtovar(userlist(tempchr).stats.minsta, da�o, _
         userlist(tempchr).stats.maxsta)
    if userindex <> tempchr then
         call senddata(toindex, userindex, 0, "||le has restaurado " & da�o & " puntos de vitalidad a " & userlist(tempchr).name & fonttype_fight)
         call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha restaurado " & da�o & " puntos de vitalidad." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has restaurado " & da�o & " puntos de vitalidad." & fonttype_fight)
    end if
    b = true
elseif hechizos(h).subemana = 2 then
    if not puedeatacar(userindex, tempchr) then exit sub
    
    if userindex <> tempchr then
        call usuarioatacadoporusuario(userindex, tempchr)
    end if
    
    call infohechizo(userindex)
    
    if userindex <> tempchr then
        call senddata(toindex, userindex, 0, "||le has quitado " & da�o & " puntos de vitalidad a " & userlist(tempchr).name & fonttype_fight)
        call senddata(toindex, tempchr, 0, "||" & userlist(userindex).name & " te ha quitado " & da�o & " puntos de vitalidad." & fonttype_fight)
    else
        call senddata(toindex, userindex, 0, "||te has quitado " & da�o & " puntos de vitalidad." & fonttype_fight)
    end if
    
    userlist(tempchr).stats.minsta = userlist(tempchr).stats.minsta - da�o
    
    if userlist(tempchr).stats.minsta < 1 then userlist(tempchr).stats.minsta = 0
    b = true
end if


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

    call senddata(toindex, userindex, 0, "shs" & slot & "," & hechizo & "," & hechizos(hechizo).nombre)

else

    call senddata(toindex, userindex, 0, "shs" & slot & "," & "0" & "," & "(none)")

end if


end sub
