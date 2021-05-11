attribute vb_name = "usuarios"
'argentum online 0.9.0.2
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

'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'rutinas de los usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

sub actstats(byval victimindex as integer, byval attackerindex as integer)

dim daexp as integer

daexp = cint(userlist(victimindex).stats.elv * 2)

userlist(attackerindex).stats.exp = userlist(attackerindex).stats.exp + daexp
if userlist(attackerindex).stats.exp > maxexp then _
    userlist(attackerindex).stats.exp = maxexp

'lo mata
call senddata(sendtarget.toindex, attackerindex, 0, "||has matado a " & userlist(victimindex).name & "!" & fonttype_fight)
call senddata(sendtarget.toindex, attackerindex, 0, "||has ganado " & daexp & " puntos de experiencia." & fonttype_fight)
      
call senddata(sendtarget.toindex, victimindex, 0, "||" & userlist(attackerindex).name & " te ha matado!" & fonttype_fight)

if triggerzonapelea(victimindex, attackerindex) <> trigger6_permite then
    if (not criminal(victimindex)) then
         userlist(attackerindex).reputacion.asesinorep = userlist(attackerindex).reputacion.asesinorep + vlasesino * 2
         if userlist(attackerindex).reputacion.asesinorep > maxrep then _
            userlist(attackerindex).reputacion.asesinorep = maxrep
         userlist(attackerindex).reputacion.burguesrep = 0
         userlist(attackerindex).reputacion.noblerep = 0
         userlist(attackerindex).reputacion.pleberep = 0
    else
         userlist(attackerindex).reputacion.noblerep = userlist(attackerindex).reputacion.noblerep + vlnoble
         if userlist(attackerindex).reputacion.noblerep > maxrep then _
            userlist(attackerindex).reputacion.noblerep = maxrep
    end if
end if

call userdie(victimindex)

if userlist(attackerindex).stats.usuariosmatados < 32000 then _
    userlist(attackerindex).stats.usuariosmatados = userlist(attackerindex).stats.usuariosmatados + 1

'log
call logasesinato(userlist(attackerindex).name & " asesino a " & userlist(victimindex).name)

end sub


sub revivirusuario(byval userindex as integer)

userlist(userindex).flags.muerto = 0
userlist(userindex).stats.minhp = 35

'no puede estar empollando
userlist(userindex).flags.estaempo = 0
userlist(userindex).empocont = 0

if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then
    userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
end if

call darcuerpodesnudo(userindex)
call changeuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).origchar.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
call senduserstatsbox(userindex)

end sub


sub changeuserchar(byval sndroute as byte, byval sndindex as integer, byval sndmap as integer, byval userindex as integer, _
                    byval body as integer, byval head as integer, byval heading as byte, _
                    byval arma as integer, byval escudo as integer, byval casco as integer)

    userlist(userindex).char.body = body
    userlist(userindex).char.head = head
    userlist(userindex).char.heading = heading
    userlist(userindex).char.weaponanim = arma
    userlist(userindex).char.shieldanim = escudo
    userlist(userindex).char.cascoanim = casco
    
    if sndroute = sendtarget.tomap then
        call sendtouserarea(userindex, "cp" & userlist(userindex).char.charindex & "," & body & "," & head & "," & heading & "," & arma & "," & escudo & "," & userlist(userindex).char.fx & "," & userlist(userindex).char.loops & "," & casco)
    else
        call senddata(sndroute, sndindex, sndmap, "cp" & userlist(userindex).char.charindex & "," & body & "," & head & "," & heading & "," & arma & "," & escudo & "," & userlist(userindex).char.fx & "," & userlist(userindex).char.loops & "," & casco)
    end if
end sub

sub enviarsubirnivel(byval userindex as integer, byval puntos as integer)
    call senddata(sendtarget.toindex, userindex, 0, "suni" & puntos)
end sub

sub enviarskills(byval userindex as integer)
    dim i as integer
    dim cad as string
    
    for i = 1 to numskills
       cad = cad & userlist(userindex).stats.userskills(i) & ","
    next i
    
    senddata sendtarget.toindex, userindex, 0, "skills" & cad$
end sub

sub enviarfama(byval userindex as integer)
    dim cad as string
    
    cad = cad & userlist(userindex).reputacion.asesinorep & ","
    cad = cad & userlist(userindex).reputacion.bandidorep & ","
    cad = cad & userlist(userindex).reputacion.burguesrep & ","
    cad = cad & userlist(userindex).reputacion.ladronesrep & ","
    cad = cad & userlist(userindex).reputacion.noblerep & ","
    cad = cad & userlist(userindex).reputacion.pleberep & ","
    
    dim l as long
    
    l = (-userlist(userindex).reputacion.asesinorep) + _
        (-userlist(userindex).reputacion.bandidorep) + _
        userlist(userindex).reputacion.burguesrep + _
        (-userlist(userindex).reputacion.ladronesrep) + _
        userlist(userindex).reputacion.noblerep + _
        userlist(userindex).reputacion.pleberep
    l = l / 6
    
    userlist(userindex).reputacion.promedio = l
    
    cad = cad & userlist(userindex).reputacion.promedio
    
    senddata sendtarget.toindex, userindex, 0, "fama" & cad
end sub

sub enviaratrib(byval userindex as integer)
dim i as integer
dim cad as string
for i = 1 to numatributos
  cad = cad & userlist(userindex).stats.useratributos(i) & ","
next
call senddata(sendtarget.toindex, userindex, 0, "atr" & cad)
end sub

public sub enviarminiestadisticas(byval userindex as integer)
with userlist(userindex)
    call senddata(sendtarget.toindex, userindex, 0, "mest" & .faccion.ciudadanosmatados & "," & _
                .faccion.criminalesmatados & "," & .stats.usuariosmatados & "," & _
                .stats.npcsmuertos & "," & .clase & "," & .counters.pena)
end with

end sub

sub eraseuserchar(sndroute as byte, sndindex as integer, sndmap as integer, userindex as integer)

on error goto errorhandler
   
    charlist(userlist(userindex).char.charindex) = 0
    
    if userlist(userindex).char.charindex = lastchar then
        do until charlist(lastchar) > 0
            lastchar = lastchar - 1
            if lastchar <= 1 then exit do
        loop
    end if
    
    'le mandamos el mensaje para que borre el personaje a los clientes que est�n en el mismo mapa
    if sndroute = sendtarget.tomap then
        call sendtouserarea(userindex, "bp" & userlist(userindex).char.charindex)
        call quitaruser(userindex, userlist(userindex).pos.map)
    else
        call senddata(sndroute, sndindex, sndmap, "bp" & userlist(userindex).char.charindex)
    end if
    
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = 0
    userlist(userindex).char.charindex = 0
    
    numchars = numchars - 1
    
    exit sub
    
errorhandler:
        call logerror("error en eraseuserchar " & err.number & ": " & err.description)

end sub

sub makeuserchar(byval sndroute as sendtarget, byval sndindex as integer, byval sndmap as integer, byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
on local error goto hayerror
    dim charindex as integer

    if inmapbounds(map, x, y) then
        'if needed make a new character in list
        if userlist(userindex).char.charindex = 0 then
            charindex = nextopencharindex
            userlist(userindex).char.charindex = charindex
            charlist(charindex) = userindex
        end if
        
        'place character on map
        mapdata(map, x, y).userindex = userindex
        
        'send make character command to clients
        dim klan as string
        if userlist(userindex).guildindex > 0 then
            klan = guilds(userlist(userindex).guildindex).guildname
        end if
        
        dim bcr as byte
        dim sendprivilegios as byte
       
        bcr = criminal(userindex)

        if klan <> "" then
            if sndroute = sendtarget.toindex then
#if seguridadalkon then
                if encriptarprotocoloscriticos then
                    if userlist(userindex).flags.privilegios > playertype.user then
                        if userlist(userindex).showname then
                            call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & " <" & klan & ">" & "," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        else
                            'hide the name and clan
                            call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & ",," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        end if
                    else
                        call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & " <" & klan & ">" & "," & bcr & "," & iif(userlist(userindex).flags.pertalcons = 1, 4, iif(userlist(userindex).flags.pertalconscaos = 1, 6, 0)))
                    end if
                else
#end if
                    if userlist(userindex).flags.privilegios > playertype.user then
                        if userlist(userindex).showname then
                            call senddata(sndroute, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & " <" & klan & ">" & "," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        else
                            'hide the name and clan
                            call senddata(sndroute, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & ",," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        end if
                    else
                        call senddata(sndroute, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & " <" & klan & ">" & "," & bcr & "," & iif(userlist(userindex).flags.pertalcons = 1, 4, iif(userlist(userindex).flags.pertalconscaos = 1, 6, 0)))
                    end if
#if seguridadalkon then
                end if
#end if
            elseif sndroute = sendtarget.tomap then
                call agregaruser(userindex, userlist(userindex).pos.map)
                call checkupdateneededuser(userindex, user_nuevo)
            end if
        else 'if tiene clan
            if sndroute = sendtarget.toindex then
#if seguridadalkon then
                if encriptarprotocoloscriticos then
                    if userlist(userindex).flags.privilegios > playertype.user then
                        if userlist(userindex).showname then
                            call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & "," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        else
                            'hide the name
                            call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & ",," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        end if
                    else
                        call sendcrypteddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & "," & bcr & "," & iif(userlist(userindex).flags.pertalcons = 1, 4, iif(userlist(userindex).flags.pertalconscaos = 1, 6, 0)))
                    end if
                else
#end if
                    if userlist(userindex).flags.privilegios > playertype.user then
                        if userlist(userindex).showname then
                            call senddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & "," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        else
                            call senddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & ",," & bcr & "," & iif(userlist(userindex).flags.esrolesmaster, 5, userlist(userindex).flags.privilegios))
                        end if
                    else
                        call senddata(sendtarget.toindex, sndindex, sndmap, "cc" & userlist(userindex).char.body & "," & userlist(userindex).char.head & "," & userlist(userindex).char.heading & "," & userlist(userindex).char.charindex & "," & x & "," & y & "," & userlist(userindex).char.weaponanim & "," & userlist(userindex).char.shieldanim & "," & userlist(userindex).char.fx & "," & 999 & "," & userlist(userindex).char.cascoanim & "," & userlist(userindex).name & "," & bcr & "," & iif(userlist(userindex).flags.pertalcons = 1, 4, iif(userlist(userindex).flags.pertalconscaos = 1, 6, 0)))
                    end if
#if seguridadalkon then
                end if
#end if
            elseif sndroute = sendtarget.tomap then
                call agregaruser(userindex, userlist(userindex).pos.map)
                call checkupdateneededuser(userindex, user_nuevo)
            end if
       end if   'if clan
    end if
exit sub

hayerror:
    logerror ("makeuserchar: num: " & err.number & " desc: " & err.description)
    'resume next
    call closesocket(userindex)
end sub

sub checkuserlevel(byval userindex as integer)

on error goto errhandler

dim pts as integer
dim aumentohit as integer
dim aumentomana as integer
dim aumentosta as integer
dim wasnewbie as boolean

'�alcanzo el maximo nivel?
if userlist(userindex).stats.elv = stat_maxelv then
    userlist(userindex).stats.exp = 0
    userlist(userindex).stats.elu = 0
    exit sub
end if

wasnewbie = esnewbie(userindex)

'si exp >= then exp para subir de nivel entonce subimos el nivel
'if userlist(userindex).stats.exp >= userlist(userindex).stats.elu then
do while userlist(userindex).stats.exp >= userlist(userindex).stats.elu
    
    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_nivel)
    call senddata(sendtarget.toindex, userindex, 0, "||�has subido de nivel!" & fonttype_info)
    
    if userlist(userindex).stats.elv = 1 then
        pts = 10
    else
        pts = 5
    end if
    
    userlist(userindex).stats.skillpts = userlist(userindex).stats.skillpts + pts
    
    call senddata(sendtarget.toindex, userindex, 0, "||has ganado " & pts & " skillpoints." & fonttype_info)
       
    userlist(userindex).stats.elv = userlist(userindex).stats.elv + 1
    
    userlist(userindex).stats.exp = userlist(userindex).stats.exp - userlist(userindex).stats.elu
    
    if not esnewbie(userindex) and wasnewbie then
        call quitarnewbieobj(userindex)
        if ucase$(mapinfo(userlist(userindex).pos.map).restringir) = "si" then
            call warpuserchar(userindex, 1, 50, 50, true)
            call senddata(sendtarget.toindex, userindex, 0, "||debes abandonar el dungeon newbie." & fonttype_warning)
        end if
    end if

    if userlist(userindex).stats.elv < 11 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.5
    elseif userlist(userindex).stats.elv < 25 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.3
    else
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.2
    end if

    dim aumentohp as integer
    select case ucase$(userlist(userindex).clase)
        case "guerrero"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(9, 12)
                case 20
                    aumentohp = randomnumber(8, 12)
                case 19, 18
                    aumentohp = randomnumber(8, 11)
                case else
                    aumentohp = randomnumber(6, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) + adicionalhpguerrero
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 2, 3)
            aumentosta = aumentostdef
        
        case "cazador"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(9, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19, 18
                    aumentohp = randomnumber(6, 11)
                case else
                    aumentohp = randomnumber(6, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select

            aumentohit = iif(userlist(userindex).stats.elv > 35, 2, 3)
            aumentosta = aumentostdef
        
        case "pirata"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(9, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 18, 19
                    aumentohp = randomnumber(6, 11)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) + adicionalhpguerrero
            end select
            
            aumentohit = 3
            aumentosta = aumentostdef
        
        case "paladin"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(9, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19, 18
                    aumentohp = randomnumber(6, 11)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) + adicionalhpcazador
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 1, 3)
            aumentomana = userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case "ladron"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19, 18
                    aumentohp = randomnumber(5, 9)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select
            
            aumentohit = 1
            aumentosta = aumentostladron
            
        case "mago"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) - adicionalhpcazador
            end select
            if aumentohp < 1 then aumentohp = 4
            
            aumentohit = 1
            aumentomana = 3 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostmago
        
        case "le�ador"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) - adicionalhpcazador
            end select
            
            aumentohit = 2
            aumentosta = aumentostle�ador
        
        case "minero"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) - adicionalhpcazador
            end select
            
            aumentohit = 2
            aumentosta = aumentostminero
        
        case "pescador"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) - adicionalhpcazador
            end select
            
            aumentohit = 1
            aumentosta = aumentostpescador
        
        case "clerigo"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(7, 11)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19, 18
                    aumentohp = randomnumber(5, 9)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select
            
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case "druida"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19, 18
                    aumentohp = randomnumber(5, 9)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select
            
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case "asesino"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19, 18
                    aumentohp = randomnumber(5, 9)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 1, 3)
            aumentomana = userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case "bardo"
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19, 18
                    aumentohp = randomnumber(5, 9)
                case else
                    aumentohp = randomnumber(4, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2)
            end select
            
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case else
            select case userlist(userindex).stats.useratributos(eatributos.constitucion)
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, userlist(userindex).stats.useratributos(eatributos.constitucion) \ 2) - adicionalhpcazador
            end select

            aumentohit = 2
            aumentosta = aumentostdef
    end select
    
    'actualizamos hitpoints
    userlist(userindex).stats.maxhp = userlist(userindex).stats.maxhp + aumentohp
    if userlist(userindex).stats.maxhp > stat_maxhp then _
        userlist(userindex).stats.maxhp = stat_maxhp
    'actualizamos stamina
    userlist(userindex).stats.maxsta = userlist(userindex).stats.maxsta + aumentosta
    if userlist(userindex).stats.maxsta > stat_maxsta then _
        userlist(userindex).stats.maxsta = stat_maxsta
    'actualizamos mana
    userlist(userindex).stats.maxman = userlist(userindex).stats.maxman + aumentomana
    if userlist(userindex).stats.elv < 36 then
        if userlist(userindex).stats.maxman > stat_maxman then _
            userlist(userindex).stats.maxman = stat_maxman
    else
        if userlist(userindex).stats.maxman > 9999 then _
            userlist(userindex).stats.maxman = 9999
    end if
    
    'actualizamos golpe m�ximo
    userlist(userindex).stats.maxhit = userlist(userindex).stats.maxhit + aumentohit
    if userlist(userindex).stats.elv < 36 then
        if userlist(userindex).stats.maxhit > stat_maxhit_under36 then _
            userlist(userindex).stats.maxhit = stat_maxhit_under36
    else
        if userlist(userindex).stats.maxhit > stat_maxhit_over36 then _
            userlist(userindex).stats.maxhit = stat_maxhit_over36
    end if
    
    'actualizamos golpe m�nimo
    userlist(userindex).stats.minhit = userlist(userindex).stats.minhit + aumentohit
    if userlist(userindex).stats.elv < 36 then
        if userlist(userindex).stats.minhit > stat_maxhit_under36 then _
            userlist(userindex).stats.minhit = stat_maxhit_under36
    else
        if userlist(userindex).stats.minhit > stat_maxhit_over36 then _
            userlist(userindex).stats.minhit = stat_maxhit_over36
    end if
    
    'notificamos al user
    if aumentohp > 0 then senddata sendtarget.toindex, userindex, 0, "||has ganado " & aumentohp & " puntos de vida." & fonttype_info
    if aumentosta > 0 then senddata sendtarget.toindex, userindex, 0, "||has ganado " & aumentosta & " puntos de vitalidad." & fonttype_info
    if aumentomana > 0 then senddata sendtarget.toindex, userindex, 0, "||has ganado " & aumentomana & " puntos de magia." & fonttype_info
    if aumentohit > 0 then
        senddata sendtarget.toindex, userindex, 0, "||tu golpe maximo aumento en " & aumentohit & " puntos." & fonttype_info
        senddata sendtarget.toindex, userindex, 0, "||tu golpe minimo aumento en " & aumentohit & " puntos." & fonttype_info
    end if
    
    call logdesarrollo(date & " " & userlist(userindex).name & " paso a nivel " & userlist(userindex).stats.elv & " gano hp: " & aumentohp)
    
    userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
    
    call enviarskills(userindex)
    call enviarsubirnivel(userindex, pts)
   
    senduserstatsbox userindex
    
loop
'end if


exit sub

errhandler:
    logerror ("error en la subrutina checkuserlevel")
end sub

function puedeatravesaragua(byval userindex as integer) as boolean

puedeatravesaragua = _
  userlist(userindex).flags.navegando = 1 or _
  userlist(userindex).flags.vuela = 1

end function

sub moveuserchar(byval userindex as integer, byval nheading as byte)

dim npos as worldpos
    
    npos = userlist(userindex).pos
    call headtopos(nheading, npos)
    
    if legalpos(userlist(userindex).pos.map, npos.x, npos.y, puedeatravesaragua(userindex)) then
        if mapinfo(userlist(userindex).pos.map).numusers > 1 then
            'si no estoy solo en el mapa...
#if seguridadalkon then
            call sendcryptedmovechar(npos.map, userindex, npos.x, npos.y)
#else
            call sendtouserareabutindex(userindex, "+" & userlist(userindex).char.charindex & "," & npos.x & "," & npos.y)
#end if
        end if
        
        'update map and user pos
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = 0
        userlist(userindex).pos = npos
        userlist(userindex).char.heading = nheading
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = userindex
        
        'actualizamos las �reas de ser necesario
        call modareas.checkupdateneededuser(userindex, nheading)
    else
        call senddata(sendtarget.toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
    end if
    
    if userlist(userindex).counters.trabajando then _
        userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando - 1

    if userlist(userindex).counters.ocultando then _
        userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando - 1
end sub

sub changeuserinv(userindex as integer, slot as byte, object as userobj)

    userlist(userindex).invent.object(slot) = object
    
    if object.objindex > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "csi" & slot & "," & object.objindex & "," & objdata(object.objindex).name & "," & object.amount & "," & object.equipped & "," & objdata(object.objindex).grhindex & "," _
        & objdata(object.objindex).objtype & "," _
        & objdata(object.objindex).maxhit & "," _
        & objdata(object.objindex).minhit & "," _
        & objdata(object.objindex).maxdef & "," _
        & objdata(object.objindex).valor \ 3)
    else
        call senddata(sendtarget.toindex, userindex, 0, "csi" & slot & "," & "0" & "," & "(none)" & "," & "0" & "," & "0")
    end if

end sub


function nextopencharindex() as integer
'modificada por el oso para codificar los mp1234,2,1 en 2 bytes
'para lograrlo, el charindex no puede tener su bit numero 6 (desde 0) en 1
'y tampoco puede ser un charindex que tenga el bit 0 en 1.

on local error goto hayerror

dim loopc as integer
    
    loopc = 1
    
    while loopc < maxchars
        if charlist(loopc) = 0 and not ((loopc and &hffc0&) = 64) then
            nextopencharindex = loopc
            numchars = numchars + 1
            if loopc > lastchar then lastchar = loopc
            exit function
        else
            loopc = loopc + 1
        end if
    wend

exit function
hayerror:
logerror ("nextopencharindex: num: " & err.number & " desc: " & err.description)

end function

function nextopenuser() as integer
    
    dim loopc as integer
      
    for loopc = 1 to maxusers + 1
      if loopc > maxusers then exit for
      if (userlist(loopc).connid = -1) then exit for
    next loopc
      
    nextopenuser = loopc

end function

sub senduserstatsbox(byval userindex as integer)
    call senddata(sendtarget.toindex, userindex, 0, "est" & userlist(userindex).stats.maxhp & "," & userlist(userindex).stats.minhp & "," & userlist(userindex).stats.maxman & "," & userlist(userindex).stats.minman & "," & userlist(userindex).stats.maxsta & "," & userlist(userindex).stats.minsta & "," & userlist(userindex).stats.gld & "," & userlist(userindex).stats.elv & "," & userlist(userindex).stats.elu & "," & userlist(userindex).stats.exp)
end sub

sub enviarhambreysed(byval userindex as integer)
    call senddata(sendtarget.toindex, userindex, 0, "ehys" & userlist(userindex).stats.maxagu & "," & userlist(userindex).stats.minagu & "," & userlist(userindex).stats.maxham & "," & userlist(userindex).stats.minham)
end sub

sub senduserstatstxt(byval sendindex as integer, byval userindex as integer)
dim guildi as integer


    call senddata(sendtarget.toindex, sendindex, 0, "||estadisticas de: " & userlist(userindex).name & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||nivel: " & userlist(userindex).stats.elv & "  exp: " & userlist(userindex).stats.exp & "/" & userlist(userindex).stats.elu & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||vitalidad: " & userlist(userindex).stats.fit & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||salud: " & userlist(userindex).stats.minhp & "/" & userlist(userindex).stats.maxhp & "  mana: " & userlist(userindex).stats.minman & "/" & userlist(userindex).stats.maxman & "  vitalidad: " & userlist(userindex).stats.minsta & "/" & userlist(userindex).stats.maxsta & fonttype_info)
    
    if userlist(userindex).invent.weaponeqpobjindex > 0 then
        call senddata(sendtarget.toindex, sendindex, 0, "||menor golpe/mayor golpe: " & userlist(userindex).stats.minhit & "/" & userlist(userindex).stats.maxhit & " (" & objdata(userlist(userindex).invent.weaponeqpobjindex).minhit & "/" & objdata(userlist(userindex).invent.weaponeqpobjindex).maxhit & ")" & fonttype_info)
    else
        call senddata(sendtarget.toindex, sendindex, 0, "||menor golpe/mayor golpe: " & userlist(userindex).stats.minhit & "/" & userlist(userindex).stats.maxhit & fonttype_info)
    end if
    
    if userlist(userindex).invent.armoureqpobjindex > 0 then
        call senddata(sendtarget.toindex, sendindex, 0, "||(cuerpo) min def/max def: " & objdata(userlist(userindex).invent.armoureqpobjindex).mindef & "/" & objdata(userlist(userindex).invent.armoureqpobjindex).maxdef & fonttype_info)
    else
        call senddata(sendtarget.toindex, sendindex, 0, "||(cuerpo) min def/max def: 0" & fonttype_info)
    end if
    
    if userlist(userindex).invent.cascoeqpobjindex > 0 then
        call senddata(sendtarget.toindex, sendindex, 0, "||(cabeza) min def/max def: " & objdata(userlist(userindex).invent.cascoeqpobjindex).mindef & "/" & objdata(userlist(userindex).invent.cascoeqpobjindex).maxdef & fonttype_info)
    else
        call senddata(sendtarget.toindex, sendindex, 0, "||(cabeza) min def/max def: 0" & fonttype_info)
    end if
    
    guildi = userlist(userindex).guildindex
    if guildi > 0 then
        call senddata(sendtarget.toindex, sendindex, 0, "||clan: " & guilds(guildi).guildname & fonttype_info)
        if ucase$(guilds(guildi).getleader) = ucase$(userlist(sendindex).name) then
            call senddata(sendtarget.toindex, sendindex, 0, "||status: lider" & fonttype_info)
        end if
        'guildpts no tienen objeto
        'call senddata(sendtarget.toindex, sendindex, 0, "||user guildpoints: " & userlist(userindex).guildinfo.guildpoints & fonttype_info)
    end if
    
    call senddata(sendtarget.toindex, sendindex, 0, "||oro: " & userlist(userindex).stats.gld & "  posicion: " & userlist(userindex).pos.x & "," & userlist(userindex).pos.y & " en mapa " & userlist(userindex).pos.map & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||dados: " & userlist(userindex).stats.useratributos(eatributos.fuerza) & ", " & userlist(userindex).stats.useratributos(eatributos.agilidad) & ", " & userlist(userindex).stats.useratributos(eatributos.inteligencia) & ", " & userlist(userindex).stats.useratributos(eatributos.carisma) & ", " & userlist(userindex).stats.useratributos(eatributos.constitucion) & fonttype_info)

end sub

sub senduserministatstxt(byval sendindex as integer, byval userindex as integer)
with userlist(userindex)
    call senddata(sendtarget.toindex, sendindex, 0, "||pj: " & .name & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||ciudadanosmatados: " & .faccion.ciudadanosmatados & " criminalesmatados: " & .faccion.criminalesmatados & " usuariosmatados: " & .stats.usuariosmatados & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||npcsmuertos: " & .stats.npcsmuertos & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||clase: " & .clase & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||pena: " & .counters.pena & fonttype_info)
end with

end sub

sub senduserministatstxtfromchar(byval sendindex as integer, byval charname as string)
dim charfile as string
dim ban as string
dim bandetailpath as string

    bandetailpath = app.path & "\logs\" & "bandetail.dat"
    charfile = charpath & charname & ".chr"
    
    if fileexist(charfile) then
        call senddata(sendtarget.toindex, sendindex, 0, "||pj: " & charname & fonttype_info)
        ' 3 en uno :p
        call senddata(sendtarget.toindex, sendindex, 0, "||ciudadanosmatados: " & getvar(charfile, "facciones", "ciudmatados") & " criminalesmatados: " & getvar(charfile, "facciones", "crimmatados") & " usuariosmatados: " & getvar(charfile, "muertes", "usermuertes") & fonttype_info)
        call senddata(sendtarget.toindex, sendindex, 0, "||npcsmuertos: " & getvar(charfile, "muertes", "npcsmuertes") & fonttype_info)
        call senddata(sendtarget.toindex, sendindex, 0, "||clase: " & getvar(charfile, "init", "clase") & fonttype_info)
        call senddata(sendtarget.toindex, sendindex, 0, "||pena: " & getvar(charfile, "counters", "pena") & fonttype_info)
        ban = getvar(charfile, "flags", "ban")
        call senddata(sendtarget.toindex, sendindex, 0, "||ban: " & ban & fonttype_info)
        if ban = "1" then
            call senddata(sendtarget.toindex, sendindex, 0, "||ban por: " & getvar(charfile, charname, "bannedby") & " motivo: " & getvar(bandetailpath, charname, "reason") & fonttype_info)
        end if
    else
        call senddata(sendtarget.toindex, sendindex, 0, "||el pj no existe: " & charname & fonttype_info)
    end if
    
end sub

sub senduserinvtxt(byval sendindex as integer, byval userindex as integer)
on error resume next

    dim j as long
    
    call senddata(sendtarget.toindex, sendindex, 0, "||" & userlist(userindex).name & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "|| tiene " & userlist(userindex).invent.nroitems & " objetos." & fonttype_info)
    
    for j = 1 to max_inventory_slots
        if userlist(userindex).invent.object(j).objindex > 0 then
            call senddata(sendtarget.toindex, sendindex, 0, "|| objeto " & j & " " & objdata(userlist(userindex).invent.object(j).objindex).name & " cantidad:" & userlist(userindex).invent.object(j).amount & fonttype_info)
        end if
    next j
end sub

sub senduserinvtxtfromchar(byval sendindex as integer, byval charname as string)
on error resume next

    dim j as long
    dim charfile as string, tmp as string
    dim objind as long, objcant as long
    
    charfile = charpath & charname & ".chr"
    
    if fileexist(charfile, vbnormal) then
        call senddata(sendtarget.toindex, sendindex, 0, "||" & charname & fonttype_info)
        call senddata(sendtarget.toindex, sendindex, 0, "|| tiene " & getvar(charfile, "inventory", "cantidaditems") & " objetos." & fonttype_info)
        
        for j = 1 to max_inventory_slots
            tmp = getvar(charfile, "inventory", "obj" & j)
            objind = readfield(1, tmp, asc("-"))
            objcant = readfield(2, tmp, asc("-"))
            if objind > 0 then
                call senddata(sendtarget.toindex, sendindex, 0, "|| objeto " & j & " " & objdata(objind).name & " cantidad:" & objcant & fonttype_info)
            end if
        next j
    else
        call senddata(sendtarget.toindex, sendindex, 0, "||usuario inexistente: " & charname & fonttype_info)
    end if
    
end sub

sub senduserskillstxt(byval sendindex as integer, byval userindex as integer)
on error resume next
dim j as integer
call senddata(sendtarget.toindex, sendindex, 0, "||" & userlist(userindex).name & fonttype_info)
for j = 1 to numskills
    call senddata(sendtarget.toindex, sendindex, 0, "|| " & skillsnames(j) & " = " & userlist(userindex).stats.userskills(j) & fonttype_info)
next
call senddata(sendtarget.toindex, sendindex, 0, "|| skilllibres:" & userlist(userindex).stats.skillpts & fonttype_info)
end sub

function dameuserindex(socketid as integer) as integer

dim loopc as integer
  
loopc = 1
  
do until userlist(loopc).connid = socketid

    loopc = loopc + 1
    
    if loopc > maxusers then
        dameuserindex = 0
        exit function
    end if
    
loop
  
dameuserindex = loopc

end function

function dameuserindexconnombre(byval nombre as string) as integer

dim loopc as integer
  
loopc = 1
  
nombre = ucase$(nombre)

do until ucase$(userlist(loopc).name) = nombre

    loopc = loopc + 1
    
    if loopc > maxusers then
        dameuserindexconnombre = 0
        exit function
    end if
    
loop
  
dameuserindexconnombre = loopc

end function


function esmascotaciudadano(byval npcindex as integer, byval userindex as integer) as boolean

if npclist(npcindex).maestrouser > 0 then
        esmascotaciudadano = not criminal(npclist(npcindex).maestrouser)
        if esmascotaciudadano then call senddata(sendtarget.toindex, npclist(npcindex).maestrouser, 0, "||��" & userlist(userindex).name & " esta atacando tu mascota!!" & fonttype_fight)
end if

end function

sub npcatacado(byval npcindex as integer, byval userindex as integer)


'guardamos el usuario que ataco el npc
npclist(npcindex).flags.attackedby = userlist(userindex).name

if npclist(npcindex).maestrouser > 0 then call allmascotasatacanuser(userindex, npclist(npcindex).maestrouser)

if esmascotaciudadano(npcindex, userindex) then
            call volvercriminal(userindex)
            npclist(npcindex).movement = tipoai.npcdefensa
            npclist(npcindex).hostile = 1
else
    'reputacion
    if npclist(npcindex).stats.alineacion = 0 then
       if npclist(npcindex).npctype = enpctype.guardiareal then
            userlist(userindex).reputacion.noblerep = 0
            userlist(userindex).reputacion.pleberep = 0
            userlist(userindex).reputacion.asesinorep = userlist(userindex).reputacion.asesinorep + 200
            if userlist(userindex).reputacion.asesinorep > maxrep then _
                userlist(userindex).reputacion.asesinorep = maxrep
       else
            if not npclist(npcindex).maestrouser > 0 then   'mascotas nooo!
                userlist(userindex).reputacion.bandidorep = userlist(userindex).reputacion.bandidorep + vlasalto
                if userlist(userindex).reputacion.bandidorep > maxrep then _
                    userlist(userindex).reputacion.bandidorep = maxrep
            end if
       end if
    elseif npclist(npcindex).stats.alineacion = 1 then
       userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlcazador / 2
       if userlist(userindex).reputacion.pleberep > maxrep then _
        userlist(userindex).reputacion.pleberep = maxrep
    end if
    
    'hacemos que el npc se defienda
    npclist(npcindex).movement = tipoai.npcdefensa
    npclist(npcindex).hostile = 1
    
end if

end sub

function puedeapu�alar(byval userindex as integer) as boolean

if userlist(userindex).invent.weaponeqpobjindex > 0 then
 puedeapu�alar = _
 ((userlist(userindex).stats.userskills(eskill.apu�alar) >= min_apu�alar) _
 and (objdata(userlist(userindex).invent.weaponeqpobjindex).apu�ala = 1)) _
 or _
  ((ucase$(userlist(userindex).clase) = "asesino") and _
  (objdata(userlist(userindex).invent.weaponeqpobjindex).apu�ala = 1))
else
 puedeapu�alar = false
end if
end function
sub subirskill(byval userindex as integer, byval skill as integer)

if userlist(userindex).flags.hambre = 0 and _
   userlist(userindex).flags.sed = 0 then
    dim aumenta as integer
    dim prob as integer
    
    if userlist(userindex).stats.elv <= 3 then
        prob = 25
    elseif userlist(userindex).stats.elv > 3 _
        and userlist(userindex).stats.elv < 6 then
        prob = 35
    elseif userlist(userindex).stats.elv >= 6 _
        and userlist(userindex).stats.elv < 10 then
        prob = 40
    elseif userlist(userindex).stats.elv >= 10 _
        and userlist(userindex).stats.elv < 20 then
        prob = 45
    else
        prob = 50
    end if
    
    aumenta = randomnumber(1, prob)
    
    dim lvl as integer
    lvl = userlist(userindex).stats.elv
    
    if lvl >= ubound(levelskill) then exit sub
    if userlist(userindex).stats.userskills(skill) = maxskillpoints then exit sub
    
    if aumenta = 7 and userlist(userindex).stats.userskills(skill) < levelskill(lvl).levelvalue then
        userlist(userindex).stats.userskills(skill) = userlist(userindex).stats.userskills(skill) + 1
        call senddata(sendtarget.toindex, userindex, 0, "||�has mejorado tu skill " & skillsnames(skill) & " en un punto!. ahora tienes " & userlist(userindex).stats.userskills(skill) & " pts." & fonttype_info)
        
        userlist(userindex).stats.exp = userlist(userindex).stats.exp + 50
        if userlist(userindex).stats.exp > maxexp then _
            userlist(userindex).stats.exp = maxexp
        
        call senddata(sendtarget.toindex, userindex, 0, "||�has ganado 50 puntos de experiencia!" & fonttype_fight)
        call checkuserlevel(userindex)
    end if
end if

end sub

sub userdie(byval userindex as integer)
on error goto errorhandler

    'sonido
    if ucase$(userlist(userindex).genero) = "mujer" then
        call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, userlist(userindex).pos.map, e_soundindex.muerte_mujer)
    else
        call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, userlist(userindex).pos.map, e_soundindex.muerte_hombre)
    end if
    
    'quitar el dialogo del user muerto
    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "qdl" & userlist(userindex).char.charindex)
    
    userlist(userindex).stats.minhp = 0
    userlist(userindex).stats.minsta = 0
    userlist(userindex).flags.atacadopornpc = 0
    userlist(userindex).flags.atacadoporuser = 0
    userlist(userindex).flags.envenenado = 0
    userlist(userindex).flags.muerto = 1
    
    
    dim an as integer
    
    an = userlist(userindex).flags.atacadopornpc
    
    if an > 0 then
        npclist(an).movement = npclist(an).flags.oldmovement
        npclist(an).hostile = npclist(an).flags.oldhostil
        npclist(an).flags.attackedby = ""
    end if
    
    '<<<< paralisis >>>>
    if userlist(userindex).flags.paralizado = 1 then
        userlist(userindex).flags.paralizado = 0
        call senddata(sendtarget.toindex, userindex, 0, "paradok")
    end if
    
    '<<< estupidez >>>
    if userlist(userindex).flags.estupidez = 1 then
        userlist(userindex).flags.estupidez = 0
        call senddata(sendtarget.toindex, userindex, 0, "nestup")
    end if
    
    '<<<< descansando >>>>
    if userlist(userindex).flags.descansar then
        userlist(userindex).flags.descansar = false
        call senddata(sendtarget.toindex, userindex, 0, "dok")
    end if
    
    '<<<< meditando >>>>
    if userlist(userindex).flags.meditando then
        userlist(userindex).flags.meditando = false
        call senddata(sendtarget.toindex, userindex, 0, "medok")
    end if
    
    '<<<< invisible >>>>
    if userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1 then
        userlist(userindex).flags.oculto = 0
        userlist(userindex).flags.invisible = 0
        'no hace falta encriptar este nover
        call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
    end if
    
    if triggerzonapelea(userindex, userindex) <> trigger6_permite then
        ' << si es newbie no pierde el inventario >>
        if not esnewbie(userindex) or criminal(userindex) then
            call tirartodo(userindex)
        else
            if esnewbie(userindex) then call tirartodoslositemsnonewbies(userindex)
        end if
    end if
    
    ' desequipa todos los objetos
    'desequipar armadura
    if userlist(userindex).invent.armoureqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.armoureqpslot)
    end if
    'desequipar arma
    if userlist(userindex).invent.weaponeqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.weaponeqpslot)
    end if
    'desequipar casco
    if userlist(userindex).invent.cascoeqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.cascoeqpslot)
    end if
    'desequipar herramienta
    if userlist(userindex).invent.herramientaeqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.herramientaeqpslot)
    end if
    'desequipar municiones
    if userlist(userindex).invent.municioneqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.municioneqpslot)
    end if
    'desequipar escudo
    if userlist(userindex).invent.escudoeqpobjindex > 0 then
        call desequipar(userindex, userlist(userindex).invent.escudoeqpslot)
    end if
    
    ' << reseteamos los posibles fx sobre el personaje >>
    if userlist(userindex).char.loops = loopadeternum then
        userlist(userindex).char.fx = 0
        userlist(userindex).char.loops = 0
    end if
    
    ' << restauramos el mimetismo
    if userlist(userindex).flags.mimetizado = 1 then
        userlist(userindex).char.body = userlist(userindex).charmimetizado.body
        userlist(userindex).char.head = userlist(userindex).charmimetizado.head
        userlist(userindex).char.cascoanim = userlist(userindex).charmimetizado.cascoanim
        userlist(userindex).char.shieldanim = userlist(userindex).charmimetizado.shieldanim
        userlist(userindex).char.weaponanim = userlist(userindex).charmimetizado.weaponanim
        userlist(userindex).counters.mimetismo = 0
        userlist(userindex).flags.mimetizado = 0
    end if
    
    '<< cambiamos la apariencia del char >>
    if userlist(userindex).flags.navegando = 0 then
        userlist(userindex).char.body = icuerpomuerto
        userlist(userindex).char.head = icabezamuerto
        userlist(userindex).char.shieldanim = ningunescudo
        userlist(userindex).char.weaponanim = ningunarma
        userlist(userindex).char.cascoanim = ninguncasco
    else
        userlist(userindex).char.body = ifragatafantasmal ';)
    end if
    
    dim i as integer
    for i = 1 to maxmascotas
        
        if userlist(userindex).mascotasindex(i) > 0 then
               if npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia > 0 then
                    call muerenpc(userlist(userindex).mascotasindex(i), 0)
               else
                    npclist(userlist(userindex).mascotasindex(i)).maestrouser = 0
                    npclist(userlist(userindex).mascotasindex(i)).movement = npclist(userlist(userindex).mascotasindex(i)).flags.oldmovement
                    npclist(userlist(userindex).mascotasindex(i)).hostile = npclist(userlist(userindex).mascotasindex(i)).flags.oldhostil
                    userlist(userindex).mascotasindex(i) = 0
                    userlist(userindex).mascotastype(i) = 0
               end if
        end if
        
    next i
    
    userlist(userindex).nromacotas = 0
    
    
    'if mapinfo(userlist(userindex).pos.map).pk then
    '        dim miobj as obj
    '        dim npos as worldpos
    '        miobj.objindex = randomnumber(554, 555)
    '        miobj.amount = 1
    '        npos = tiraritemalpiso(userlist(userindex).pos, miobj)
    '        dim manchasangre as new cgarbage
    '        manchasangre.map = npos.map
    '        manchasangre.x = npos.x
    '        manchasangre.y = npos.y
    '        call trashcollector.add(manchasangre)
    'end if
    
    '<< actualizamos clientes >>
    call changeuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, val(userindex), userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, ningunarma, ningunescudo, ninguncasco)
    call senduserstatsbox(userindex)
    
    
    '<<castigos por party>>
    if userlist(userindex).partyindex > 0 then
        call mdparty.obtenerexito(userindex, userlist(userindex).stats.elv * -10 * mdparty.cantmiembros(userindex), userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
    end if

exit sub

errorhandler:
    call logerror("error en sub userdie. error: " & err.number & " descripci�n: " & err.description)
end sub


sub contarmuerte(byval muerto as integer, byval atacante as integer)

    if esnewbie(muerto) then exit sub
    
    if triggerzonapelea(muerto, atacante) = trigger6_permite then exit sub
    
    if criminal(muerto) then
        if userlist(atacante).flags.lastcrimmatado <> userlist(muerto).name then
            userlist(atacante).flags.lastcrimmatado = userlist(muerto).name
            if userlist(atacante).faccion.criminalesmatados < 65000 then _
                userlist(atacante).faccion.criminalesmatados = userlist(atacante).faccion.criminalesmatados + 1
        end if
        
        if userlist(atacante).faccion.criminalesmatados > maxusermatados then
            userlist(atacante).faccion.criminalesmatados = 0
            userlist(atacante).faccion.recompensasreal = 0
        end if
        
        if userlist(atacante).faccion.recibioexpinicialcaos = 1 and userlist(muerto).faccion.fuerzascaos = 1 then
            userlist(atacante).faccion.reenlistadas = 200  'jaja que trucho
            
            'con esto evitamos que se vuelva a reenlistar
        end if
    else
        if userlist(atacante).flags.lastciudmatado <> userlist(muerto).name then
            userlist(atacante).flags.lastciudmatado = userlist(muerto).name
            if userlist(atacante).faccion.ciudadanosmatados < 65000 then _
                userlist(atacante).faccion.ciudadanosmatados = userlist(atacante).faccion.ciudadanosmatados + 1
        end if
        
        if userlist(atacante).faccion.ciudadanosmatados > maxusermatados then
            userlist(atacante).faccion.ciudadanosmatados = 0
            userlist(atacante).faccion.recompensascaos = 0
        end if
    end if


end sub

sub tilelibre(byref pos as worldpos, byref npos as worldpos, byref obj as obj)
'call logtarea("sub tilelibre")

dim notfound as boolean
dim loopc as integer
dim tx as integer
dim ty as integer
dim hayobj as boolean
    hayobj = false
    npos.map = pos.map
    
    do while not legalpos(pos.map, npos.x, npos.y) or hayobj
        
        if loopc > 15 then
            notfound = true
            exit do
        end if
        
        for ty = pos.y - loopc to pos.y + loopc
            for tx = pos.x - loopc to pos.x + loopc
            
                if legalpos(npos.map, tx, ty) then
                    'we continue if: a - the item is different from 0 and the dropped item or b - the amount dropped + amount in map exceeds max_inventory_objs
                    hayobj = (mapdata(npos.map, tx, ty).objinfo.objindex > 0 and mapdata(npos.map, tx, ty).objinfo.objindex <> obj.objindex)
                    if not hayobj then _
                        hayobj = (mapdata(npos.map, tx, ty).objinfo.amount + obj.amount > max_inventory_objs)
                    if not hayobj and mapdata(npos.map, tx, ty).tileexit.map = 0 then
                        npos.x = tx
                        npos.y = ty
                        tx = pos.x + loopc
                        ty = pos.y + loopc
                    end if
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

sub warpuserchar(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer, optional byval fx as boolean = false)

dim oldmap as integer
dim oldx as integer
dim oldy as integer

    'quitar el dialogo
    call sendtouserarea(userindex, "qdl" & userlist(userindex).char.charindex)
    call senddata(sendtarget.toindex, userindex, userlist(userindex).pos.map, "qtdl")
    
    oldmap = userlist(userindex).pos.map
    oldx = userlist(userindex).pos.x
    oldy = userlist(userindex).pos.y
    
    call eraseuserchar(sendtarget.tomap, 0, oldmap, userindex)
        
    if oldmap <> map then
        call senddata(sendtarget.toindex, userindex, 0, "cm" & map & "," & mapinfo(userlist(userindex).pos.map).mapversion)
        call senddata(sendtarget.toindex, userindex, 0, "tm" & mapinfo(map).music)
        
        'update new map users
        mapinfo(map).numusers = mapinfo(map).numusers + 1
    
        'update old map users
        mapinfo(oldmap).numusers = mapinfo(oldmap).numusers - 1
        if mapinfo(oldmap).numusers < 0 then
            mapinfo(oldmap).numusers = 0
        end if
    end if
    
    userlist(userindex).pos.x = x
    userlist(userindex).pos.y = y
    userlist(userindex).pos.map = map
    
    call makeuserchar(sendtarget.tomap, 0, map, userindex, map, x, y)
    call senddata(sendtarget.toindex, userindex, 0, "ip" & userlist(userindex).char.charindex)
    
    'seguis invisible al pasar de mapa
    if (userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1) and (not userlist(userindex).flags.admininvisible = 1) then
        call sendtouserarea(userindex, "nover" & userlist(userindex).char.charindex & ",1", encriptarprotocoloscriticos)
    end if
    
    if fx and userlist(userindex).flags.admininvisible = 0 then 'fx
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_warp)
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxwarp & ",0")
    end if
    
    call warpmascotas(userindex)
end sub

sub updateusermap(byval userindex as integer)

dim map as integer
dim x as integer
dim y as integer

'enviarnoche userindex

on error goto 0

map = userlist(userindex).pos.map

for y = yminmapsize to ymaxmapsize
    for x = xminmapsize to xmaxmapsize
        if mapdata(map, x, y).userindex > 0 and userindex <> mapdata(map, x, y).userindex then
            call makeuserchar(sendtarget.toindex, userindex, 0, mapdata(map, x, y).userindex, map, x, y)
#if seguridadalkon then
            if encriptarprotocoloscriticos then
                if userlist(mapdata(map, x, y).userindex).flags.invisible = 1 or userlist(mapdata(map, x, y).userindex).flags.oculto = 1 then call sendcrypteddata(sendtarget.toindex, userindex, 0, "nover" & userlist(mapdata(map, x, y).userindex).char.charindex & ",1")
            else
#end if
                if userlist(mapdata(map, x, y).userindex).flags.invisible = 1 or userlist(mapdata(map, x, y).userindex).flags.oculto = 1 then call senddata(sendtarget.toindex, userindex, 0, "nover" & userlist(mapdata(map, x, y).userindex).char.charindex & ",1")
#if seguridadalkon then
            end if
#end if
        end if

        if mapdata(map, x, y).npcindex > 0 then
            call makenpcchar(sendtarget.toindex, userindex, 0, mapdata(map, x, y).npcindex, map, x, y)
        end if

        if mapdata(map, x, y).objinfo.objindex > 0 then
            if objdata(mapdata(map, x, y).objinfo.objindex).objtype <> eobjtype.otarboles then
                call makeobj(sendtarget.toindex, userindex, 0, mapdata(map, x, y).objinfo, map, x, y)
                if objdata(mapdata(map, x, y).objinfo.objindex).objtype = eobjtype.otpuertas then
                          call bloquear(sendtarget.toindex, userindex, 0, map, x, y, mapdata(map, x, y).blocked)
                          call bloquear(sendtarget.toindex, userindex, 0, map, x - 1, y, mapdata(map, x - 1, y).blocked)
                end if
            end if
        end if
        
    next x
next y

end sub


sub warpmascotas(byval userindex as integer)
dim i as integer

dim umascrespawn  as boolean
dim miflag as byte, mascotasreales as integer
dim prevmacotatype as integer

dim pettypes(1 to maxmascotas) as integer
dim petrespawn(1 to maxmascotas) as boolean
dim pettiempodevida(1 to maxmascotas) as integer

dim nropets as integer, invocadosmatados as integer

nropets = userlist(userindex).nromacotas
invocadosmatados = 0

    'matamos los invocados
    '[alejo 18-03-2004]
    for i = 1 to maxmascotas
        if userlist(userindex).mascotasindex(i) > 0 then
            ' si la mascota tiene tiempo de vida > 0 significa q fue invocada.
            if npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia > 0 then
                call quitarnpc(userlist(userindex).mascotasindex(i))
                userlist(userindex).mascotasindex(i) = 0
                invocadosmatados = invocadosmatados + 1
                nropets = nropets - 1
            end if
        end if
    next i
    
    if invocadosmatados > 0 then
        call senddata(sendtarget.toindex, userindex, 0, "||pierdes el control de tus mascotas." & fonttype_info)
    end if
    
    for i = 1 to maxmascotas
        if userlist(userindex).mascotasindex(i) > 0 then
            petrespawn(i) = npclist(userlist(userindex).mascotasindex(i)).flags.respawn = 0
            pettypes(i) = userlist(userindex).mascotastype(i)
            pettiempodevida(i) = npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia
            call quitarnpc(userlist(userindex).mascotasindex(i))
        end if
    next i
    
    for i = 1 to maxmascotas
        if pettypes(i) > 0 then
            userlist(userindex).mascotasindex(i) = spawnnpc(pettypes(i), userlist(userindex).pos, false, petrespawn(i))
            userlist(userindex).mascotastype(i) = pettypes(i)
            'controlamos que se sumoneo ok
            if userlist(userindex).mascotasindex(i) = 0 then
                userlist(userindex).mascotasindex(i) = 0
                userlist(userindex).mascotastype(i) = 0
                if userlist(userindex).nromacotas > 0 then userlist(userindex).nromacotas = userlist(userindex).nromacotas - 1
                exit sub
            end if
            npclist(userlist(userindex).mascotasindex(i)).maestrouser = userindex
            npclist(userlist(userindex).mascotasindex(i)).movement = tipoai.sigueamo
            npclist(userlist(userindex).mascotasindex(i)).target = 0
            npclist(userlist(userindex).mascotasindex(i)).targetnpc = 0
            npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia = pettiempodevida(i)
            call followamo(userlist(userindex).mascotasindex(i))
        end if
    next i
    
    userlist(userindex).nromacotas = nropets

end sub


sub repararmascotas(byval userindex as integer)
dim i as integer
dim mascotasreales as integer

    for i = 1 to maxmascotas
      if userlist(userindex).mascotastype(i) > 0 then mascotasreales = mascotasreales + 1
    next i
    
    if mascotasreales <> userlist(userindex).nromacotas then userlist(userindex).nromacotas = 0

end sub

sub cerrar_usuario(byval userindex as integer, optional byval tiempo as integer = -1)
    if tiempo = -1 then tiempo = intervalocerrarconexion
    
    if userlist(userindex).flags.userlogged and not userlist(userindex).counters.saliendo then
        userlist(userindex).counters.saliendo = true
        userlist(userindex).counters.salir = iif(userlist(userindex).flags.privilegios > playertype.user or not mapinfo(userlist(userindex).pos.map).pk, 0, tiempo)
        
        
        call senddata(sendtarget.toindex, userindex, 0, "||cerrando...se cerrar� el juego en " & userlist(userindex).counters.salir & " segundos..." & fonttype_info)
    end if
end sub

'cambiarnick: cambia el nick de un slot.
'
'userindex: quien ejecut� la orden
'userindexdestino: slot del usuario destino, a quien cambiarle el nick
'nuevonick: nuevo nick de userindexdestino
public sub cambiarnick(byval userindex as integer, byval userindexdestino as integer, byval nuevonick as string)
dim viejonick as string
dim viejocharbackup as string

if userlist(userindexdestino).flags.userlogged = false then exit sub
viejonick = userlist(userindexdestino).name

if fileexist(charpath & viejonick & ".chr", vbnormal) then
    'hace un backup del char
    viejocharbackup = charpath & viejonick & ".chr.old-"
    name charpath & viejonick & ".chr" as viejocharbackup
end if

end sub

public sub empollando(byval userindex as integer)
if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).objinfo.objindex > 0 then
    userlist(userindex).flags.estaempo = 1
else
    userlist(userindex).flags.estaempo = 0
    userlist(userindex).empocont = 0
end if

end sub

sub senduserstatstxtoff(byval sendindex as integer, byval nombre as string)

if fileexist(charpath & nombre & ".chr", vbarchive) = false then
    call senddata(sendtarget.toindex, sendindex, 0, "||pj inexistente" & fonttype_info)
else
    call senddata(sendtarget.toindex, sendindex, 0, "||estadisticas de: " & nombre & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||nivel: " & getvar(charpath & nombre & ".chr", "stats", "elv") & "  exp: " & getvar(charpath & nombre & ".chr", "stats", "exp") & "/" & getvar(charpath & nombre & ".chr", "stats", "elu") & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||vitalidad: " & getvar(charpath & nombre & ".chr", "stats", "minsta") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxsta") & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "||salud: " & getvar(charpath & nombre & ".chr", "stats", "minhp") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxhp") & "  mana: " & getvar(charpath & nombre & ".chr", "stats", "minman") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxman") & fonttype_info)
    
    call senddata(sendtarget.toindex, sendindex, 0, "||menor golpe/mayor golpe: " & getvar(charpath & nombre & ".chr", "stats", "maxhit") & fonttype_info)
    
    call senddata(sendtarget.toindex, sendindex, 0, "||oro: " & getvar(charpath & nombre & ".chr", "stats", "gld") & fonttype_info)
end if
exit sub

end sub
sub senduserorotxtfromchar(byval sendindex as integer, byval charname as string)
on error resume next
dim j as integer
dim charfile as string, tmp as string
dim objind as long, objcant as long

charfile = charpath & charname & ".chr"

if fileexist(charfile, vbnormal) then
    call senddata(sendtarget.toindex, sendindex, 0, "||" & charname & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "|| tiene " & getvar(charfile, "stats", "banco") & " en el banco." & fonttype_info)
    else
    call senddata(sendtarget.toindex, sendindex, 0, "||usuario inexistente: " & charname & fonttype_info)
end if

end sub
