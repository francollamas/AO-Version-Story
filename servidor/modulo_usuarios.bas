attribute vb_name = "usuarios"
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

'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'rutinas de los usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

sub actstats(byval victimindex as integer, byval attackerindex as integer)

dim daexp as integer
dim eracriminal as boolean

daexp = cint(userlist(victimindex).stats.elv * 2)

userlist(attackerindex).stats.exp = userlist(attackerindex).stats.exp + daexp
if userlist(attackerindex).stats.exp > maxexp then _
    userlist(attackerindex).stats.exp = maxexp

'lo mata
call writeconsolemsg(attackerindex, "has matado a " & userlist(victimindex).name & "!", fonttypenames.fonttype_fight)
call writeconsolemsg(attackerindex, "has ganado " & daexp & " puntos de experiencia.", fonttypenames.fonttype_fight)
      
call writeconsolemsg(victimindex, userlist(attackerindex).name & " te ha matado!", fonttypenames.fonttype_fight)

if triggerzonapelea(victimindex, attackerindex) <> trigger6_permite then
    eracriminal = criminal(attackerindex)
    
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
    
    if eracriminal and not criminal(attackerindex) then
        call refreshcharstatus(attackerindex)
    elseif not eracriminal and criminal(attackerindex) then
        call refreshcharstatus(attackerindex)
    end if
end if

call userdie(victimindex)

if userlist(attackerindex).stats.usuariosmatados < maxusermatados then _
    userlist(attackerindex).stats.usuariosmatados = userlist(attackerindex).stats.usuariosmatados + 1

call flushbuffer(victimindex)

'log
call logasesinato(userlist(attackerindex).name & " asesino a " & userlist(victimindex).name)

end sub


sub revivirusuario(byval userindex as integer)

userlist(userindex).flags.muerto = 0
userlist(userindex).stats.minhp = userlist(userindex).stats.useratributos(eatributos.constitucion)

'if he died, venom should fade away
userlist(userindex).flags.envenenado = 0

'no puede estar empollando
userlist(userindex).flags.estaempo = 0
userlist(userindex).empocont = 0

if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then
    userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
end if

call darcuerpodesnudo(userindex)
call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).origchar.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
call writeupdateuserstats(userindex)

end sub

sub changeuserchar(byval userindex as integer, byval body as integer, byval head as integer, byval heading as byte, _
                    byval arma as integer, byval escudo as integer, byval casco as integer)

    with userlist(userindex).char
        .body = body
        .head = head
        .heading = heading
        .weaponanim = arma
        .shieldanim = escudo
        .cascoanim = casco
    end with
    
    call senddata(sendtarget.topcarea, userindex, preparemessagecharacterchange(body, head, heading, userlist(userindex).char.charindex, arma, escudo, userlist(userindex).char.fx, userlist(userindex).char.loops, casco))
end sub

sub enviarfama(byval userindex as integer)
    dim l as long
    
    l = (-userlist(userindex).reputacion.asesinorep) + _
        (-userlist(userindex).reputacion.bandidorep) + _
        userlist(userindex).reputacion.burguesrep + _
        (-userlist(userindex).reputacion.ladronesrep) + _
        userlist(userindex).reputacion.noblerep + _
        userlist(userindex).reputacion.pleberep
    l = round(l / 6)
    
    userlist(userindex).reputacion.promedio = l
    
    call writefame(userindex)
end sub

sub eraseuserchar(byval userindex as integer)

on error goto errorhandler
   
    charlist(userlist(userindex).char.charindex) = 0
    
    if userlist(userindex).char.charindex = lastchar then
        do until charlist(lastchar) > 0
            lastchar = lastchar - 1
            if lastchar <= 1 then exit do
        loop
    end if
    
    'le mandamos el mensaje para que borre el personaje a los clientes que est�n cerca
    call senddata(sendtarget.topcarea, userindex, preparemessagecharacterremove(userlist(userindex).char.charindex))
    call quitaruser(userindex, userlist(userindex).pos.map)
    
    mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = 0
    userlist(userindex).char.charindex = 0
    
    numchars = numchars - 1
exit sub
    
errorhandler:
        call logerror("error en eraseuserchar " & err.number & ": " & err.description)
end sub

sub refreshcharstatus(byval userindex as integer)
'*************************************************
'author: tararira
'last modified: 6/04/2007
'refreshes the status and tag of userindex.
'*************************************************
    dim klan as string
    if userlist(userindex).guildindex > 0 then
        klan = modguilds.guildname(userlist(userindex).guildindex)
        klan = " <" & klan & ">"
    end if
    
    if userlist(userindex).showname then
        call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, criminal(userindex), userlist(userindex).name & klan))
    else
        call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, criminal(userindex), vbnullstring))
    end if
end sub

sub makeuserchar(byval tomap as boolean, byval sndindex as integer, byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)

on error goto hayerror
    dim charindex as integer

    if inmapbounds(map, x, y) then
        'if needed make a new character in list
        if userlist(userindex).char.charindex = 0 then
            charindex = nextopencharindex
            userlist(userindex).char.charindex = charindex
            charlist(charindex) = userindex
        end if
        
        'place character on map if needed
        if tomap then _
            mapdata(map, x, y).userindex = userindex
        
        'send make character command to clients
        dim klan as string
        if userlist(userindex).guildindex > 0 then
            klan = modguilds.guildname(userlist(userindex).guildindex)
        end if
        
        dim bcr as byte
        
        bcr = criminal(userindex)
        
        if lenb(klan) <> 0 then
            if not tomap then
                if userlist(userindex).showname then
                    call writecharactercreate(sndindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.charindex, x, y, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.fx, 999, userlist(userindex).char.cascoanim, userlist(userindex).name & " <" & klan & ">", bcr, userlist(userindex).flags.privilegios)
                else
                    'hide the name and clan - set privs as normal user
                    call writecharactercreate(sndindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.charindex, x, y, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.fx, 999, userlist(userindex).char.cascoanim, vbnullstring, bcr, playertype.user)
                end if
            else
                call agregaruser(userindex, userlist(userindex).pos.map)
            end if
        else 'if tiene clan
            if not tomap then
                if userlist(userindex).showname then
                    call writecharactercreate(sndindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.charindex, x, y, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.fx, 999, userlist(userindex).char.cascoanim, userlist(userindex).name, bcr, userlist(userindex).flags.privilegios)
                else
                    call writecharactercreate(sndindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.charindex, x, y, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.fx, 999, userlist(userindex).char.cascoanim, vbnullstring, bcr, playertype.user)
                end if
            else
                call agregaruser(userindex, userlist(userindex).pos.map)
            end if
        end if 'if clan
    end if
exit sub

hayerror:
    logerror ("makeuserchar: num: " & err.number & " desc: " & err.description)
    'resume next
    call closesocket(userindex)
end sub

sub checkuserlevel(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 01/10/2007
'chequea que el usuario no halla alcanzado el siguiente nivel,
'de lo contrario le da la vida, mana, etc, correspodiente.
'07/08/2006 integer - modificacion de los valores
'01/10/2007 tavo - corregido el bug de stat_maxelv
'24/01/2007 pablo (toxicwaste) - agrego modificaciones en elu al subir de nivel.
'24/01/2007 pablo (toxicwaste) - agrego modificaciones de la subida de mana de los magos por lvl.
'13/03/2007 pablo (toxicwaste) - agrego diferencias entre el 18 y el 19 en constituci�n.
'*************************************************

on error goto errhandler

dim pts as integer
dim constitucion as integer
dim aumentohit as integer
dim aumentomana as integer
dim aumentosta as integer
dim aumentohp as integer
dim wasnewbie as boolean

'�alcanzo el maximo nivel?
if userlist(userindex).stats.elv >= stat_maxelv then
    userlist(userindex).stats.exp = 0
    userlist(userindex).stats.elu = 0
    exit sub
end if
    
wasnewbie = esnewbie(userindex)

do while userlist(userindex).stats.exp >= userlist(userindex).stats.elu
    
    'checkea otra vez, esto sucede si tiene mas exp y puede saltarse el maximo
    'nivel
    if userlist(userindex).stats.elv >= stat_maxelv then
        userlist(userindex).stats.exp = 0
        userlist(userindex).stats.elu = 0
        exit sub
    end if
    
    'store it!
    call statistics.userlevelup(userindex)
    
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_nivel))
    call writeconsolemsg(userindex, "�has subido de nivel!", fonttypenames.fonttype_info)
    
    if userlist(userindex).stats.elv = 1 then
        pts = 10
    else
        'for multiple levels being rised at once
        pts = pts + 5
    end if
    
    userlist(userindex).stats.elv = userlist(userindex).stats.elv + 1
    
    userlist(userindex).stats.exp = userlist(userindex).stats.exp - userlist(userindex).stats.elu
    
    'nueva subida de exp x lvl. pablo (toxicwaste)
    if userlist(userindex).stats.elv < 15 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.4
    elseif userlist(userindex).stats.elv < 21 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.35
    elseif userlist(userindex).stats.elv < 33 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.3
    elseif userlist(userindex).stats.elv < 41 then
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.225
    else
        userlist(userindex).stats.elu = userlist(userindex).stats.elu * 1.25
    end if
    
    constitucion = userlist(userindex).stats.useratributos(eatributos.constitucion)
    
    select case userlist(userindex).clase
        case eclass.warrior
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 12)
                case 20
                    aumentohp = randomnumber(8, 11)
                case 19
                    aumentohp = randomnumber(7, 11)
                case 18
                    aumentohp = randomnumber(7, 10)
                case 17
                    aumentohp = randomnumber(6, 10)
                case 16
                    aumentohp = randomnumber(6, 9)
                case 15
                    aumentohp = randomnumber(5, 9)
                case 14
                    aumentohp = randomnumber(5, 8)
                case 13
                    aumentohp = randomnumber(4, 8)
                case 12
                    aumentohp = randomnumber(4, 7)
            end select
            aumentohit = iif(userlist(userindex).stats.elv > 35, 2, 3)
            aumentosta = aumentostdef
        
        case eclass.hunter
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19
                    aumentohp = randomnumber(7, 10)
                case 18
                    aumentohp = randomnumber(6, 10)
                case 17
                    aumentohp = randomnumber(6, 9)
                case 16
                    aumentohp = randomnumber(5, 9)
                case 15
                    aumentohp = randomnumber(5, 8)
                case 14
                    aumentohp = randomnumber(4, 8)
                case 13
                    aumentohp = randomnumber(4, 7)
                case 12
                    aumentohp = randomnumber(3, 7)
            end select
            aumentohit = iif(userlist(userindex).stats.elv > 35, 2, 3)
            aumentosta = aumentostdef
        
        case eclass.pirat
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 12)
                case 20
                    aumentohp = randomnumber(8, 11)
                case 19
                    aumentohp = randomnumber(7, 11)
                case 18
                    aumentohp = randomnumber(7, 10)
                case 17
                    aumentohp = randomnumber(6, 10)
                case 16
                    aumentohp = randomnumber(6, 9)
                case 15
                    aumentohp = randomnumber(5, 9)
                case 14
                    aumentohp = randomnumber(5, 8)
                case 13
                    aumentohp = randomnumber(4, 8)
                case 12
                    aumentohp = randomnumber(4, 7)
            end select
            aumentohit = 3
            aumentosta = aumentostdef
        
        case eclass.paladin
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19
                    aumentohp = randomnumber(7, 10)
                case 18
                    aumentohp = randomnumber(6, 10)
                case 17
                    aumentohp = randomnumber(6, 9)
                case 16
                    aumentohp = randomnumber(5, 9)
                case 15
                    aumentohp = randomnumber(5, 8)
                case 14
                    aumentohp = randomnumber(4, 8)
                case 13
                    aumentohp = randomnumber(4, 7)
                case 12
                    aumentohp = randomnumber(3, 7)
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 1, 3)
            aumentomana = userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case eclass.thief
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 12)
                case 20
                    aumentohp = randomnumber(8, 11)
                case 19
                    aumentohp = randomnumber(7, 11)
                case 18
                    aumentohp = randomnumber(7, 10)
                case 17
                    aumentohp = randomnumber(6, 10)
                case 16
                    aumentohp = randomnumber(6, 9)
                case 15
                    aumentohp = randomnumber(5, 9)
                case 14
                    aumentohp = randomnumber(5, 8)
                case 13
                    aumentohp = randomnumber(4, 8)
                case 12
                    aumentohp = randomnumber(4, 7)
            end select
            aumentohit = 1
            aumentosta = aumentostladron
            
        case eclass.mage
            select case constitucion
                case 21
                    aumentohp = randomnumber(6, 8)
                case 20
                    aumentohp = randomnumber(5, 8)
                case 19
                    aumentohp = randomnumber(5, 7)
                case 18
                    aumentohp = randomnumber(4, 7)
                case 17
                    aumentohp = randomnumber(4, 6)
                case 16
                    aumentohp = randomnumber(3, 6)
                case 15
                    aumentohp = randomnumber(3, 5)
                case 14
                    aumentohp = randomnumber(2, 5)
                case 13
                    aumentohp = randomnumber(2, 4)
                case 12
                    aumentohp = randomnumber(1, 4)
            end select
            if aumentohp < 1 then aumentohp = 4
            
            aumentohit = 1 'nueva dist de mana para mago (toxicwaste)
            aumentomana = 2.8 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostmago
        
        case eclass.lumberjack
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19
                    aumentohp = randomnumber(7, 10)
                case 18
                    aumentohp = randomnumber(6, 10)
                case 17
                    aumentohp = randomnumber(6, 9)
                case 16
                    aumentohp = randomnumber(5, 9)
                case 15
                    aumentohp = randomnumber(5, 8)
                case 14
                    aumentohp = randomnumber(4, 8)
                case 13
                    aumentohp = randomnumber(4, 7)
                case 12
                    aumentohp = randomnumber(3, 7)
            end select
            
            aumentohit = 2
            aumentosta = aumentostle�ador
        
        case eclass.miner
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19
                    aumentohp = randomnumber(7, 10)
                case 18
                    aumentohp = randomnumber(6, 10)
                case 17
                    aumentohp = randomnumber(6, 9)
                case 16
                    aumentohp = randomnumber(5, 9)
                case 15
                    aumentohp = randomnumber(5, 8)
                case 14
                    aumentohp = randomnumber(4, 8)
                case 13
                    aumentohp = randomnumber(4, 7)
                case 12
                    aumentohp = randomnumber(3, 7)
            end select
            
            aumentohit = 2
            aumentosta = aumentostminero
        
        case eclass.fisher
            select case constitucion
                case 21
                    aumentohp = randomnumber(8, 11)
                case 20
                    aumentohp = randomnumber(7, 11)
                case 19
                    aumentohp = randomnumber(7, 10)
                case 18
                    aumentohp = randomnumber(6, 10)
                case 17
                    aumentohp = randomnumber(6, 9)
                case 16
                    aumentohp = randomnumber(5, 9)
                case 15
                    aumentohp = randomnumber(5, 8)
                case 14
                    aumentohp = randomnumber(4, 8)
                case 13
                    aumentohp = randomnumber(4, 7)
                case 12
                    aumentohp = randomnumber(3, 7)
            end select
            
            aumentohit = 1
            aumentosta = aumentostpescador
        
        case eclass.cleric
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case eclass.druid
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case eclass.assasin
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 1, 3)
            aumentomana = userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case eclass.bard
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            
            aumentohit = 2
            aumentomana = 2 * userlist(userindex).stats.useratributos(eatributos.inteligencia)
            aumentosta = aumentostdef
        
        case eclass.blacksmith, eclass.carpenter
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            aumentohit = 2
            aumentosta = aumentostdef
            
        case eclass.bandit
            select case constitucion
                case 21
                    aumentohp = randomnumber(7, 10)
                case 20
                    aumentohp = randomnumber(6, 10)
                case 19
                    aumentohp = randomnumber(6, 9)
                case 18
                    aumentohp = randomnumber(5, 9)
                case 17
                    aumentohp = randomnumber(5, 8)
                case 16
                    aumentohp = randomnumber(4, 8)
                case 15
                    aumentohp = randomnumber(4, 7)
                case 14
                    aumentohp = randomnumber(3, 7)
                case 13
                    aumentohp = randomnumber(3, 6)
                case 12
                    aumentohp = randomnumber(2, 6)
            end select
            
            aumentohit = iif(userlist(userindex).stats.elv > 35, 1, 3)
            aumentomana = iif(userlist(userindex).stats.maxman = 300, 0, userlist(userindex).stats.useratributos(eatributos.inteligencia) - 10)
            if aumentomana < 4 then aumentomana = 4
            aumentosta = aumentostle�ador
        case else
            select case constitucion
                case 21
                    aumentohp = randomnumber(6, 9)
                case 20
                    aumentohp = randomnumber(5, 9)
                case 19, 18
                    aumentohp = randomnumber(4, 8)
                case else
                    aumentohp = randomnumber(5, constitucion \ 2) - adicionalhpcazador
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
    if userlist(userindex).clase = eclass.bandit then 'mana del bandido restringido hasta 300
        if userlist(userindex).stats.maxman > 300 then
            userlist(userindex).stats.maxman = 300
        end if
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
    if aumentohp > 0 then
        call writeconsolemsg(userindex, "has ganado " & aumentohp & " puntos de vida.", fonttypenames.fonttype_info)
    end if
    if aumentosta > 0 then
        call writeconsolemsg(userindex, "has ganado " & aumentosta & " puntos de vitalidad.", fonttypenames.fonttype_info)
    end if
    if aumentomana > 0 then
        call writeconsolemsg(userindex, "has ganado " & aumentomana & " puntos de magia.", fonttypenames.fonttype_info)
    end if
    if aumentohit > 0 then
        call writeconsolemsg(userindex, "tu golpe maximo aumento en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
        call writeconsolemsg(userindex, "tu golpe minimo aumento en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
    end if
    
    call logdesarrollo(userlist(userindex).name & " paso a nivel " & userlist(userindex).stats.elv & " gano hp: " & aumentohp)
    
    userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
loop

'if it ceased to be a newbie, remove newbie items and get char away from newbie dungeon
if not esnewbie(userindex) and wasnewbie then
    call quitarnewbieobj(userindex)
    if ucase$(mapinfo(userlist(userindex).pos.map).restringir) = "newbie" then
        call warpuserchar(userindex, 1, 50, 50, true)
        call writeconsolemsg(userindex, "debes abandonar el dungeon newbie.", fonttypenames.fonttype_info)
    end if
end if

'send all gained skill points at once (if any)
if pts > 0 then
    call writelevelup(userindex, pts)
    
    userlist(userindex).stats.skillpts = userlist(userindex).stats.skillpts + pts
    
    call writeconsolemsg(userindex, "has ganado un total de " & pts & " skillpoints.", fonttypenames.fonttype_info)
end if

call writeupdateuserstats(userindex)

exit sub

errhandler:
    call logerror("error en la subrutina checkuserlevel - error : " & err.number & " - description : " & err.description)
end sub

function puedeatravesaragua(byval userindex as integer) as boolean

puedeatravesaragua = _
  userlist(userindex).flags.navegando = 1 or _
  userlist(userindex).flags.vuela = 1

end function

sub moveuserchar(byval userindex as integer, byval nheading as eheading)

dim npos as worldpos
    
    npos = userlist(userindex).pos
    call headtopos(nheading, npos)
    
    if legalpos(userlist(userindex).pos.map, npos.x, npos.y, puedeatravesaragua(userindex)) then
        if mapinfo(userlist(userindex).pos.map).numusers > 1 then
            'si no estoy solo en el mapa...

            call senddata(sendtarget.topcareabutindex, userindex, preparemessagecharactermove(userlist(userindex).char.charindex, npos.x, npos.y))

        end if
        
        'update map and user pos
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = 0
        userlist(userindex).pos = npos
        userlist(userindex).char.heading = nheading
        mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = userindex
        
        'actualizamos las �reas de ser necesario
        call modareas.checkupdateneededuser(userindex, nheading)
    else
        call writeposupdate(userindex)
    end if
    
    if userlist(userindex).counters.trabajando then _
        userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando - 1

    if userlist(userindex).counters.ocultando then _
        userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando - 1
end sub

sub changeuserinv(byval userindex as integer, byval slot as byte, byref object as userobj)
    userlist(userindex).invent.object(slot) = object
    call writechangeinventoryslot(userindex, slot)
end sub

function nextopencharindex() as integer
    dim loopc as long
    
    for loopc = 1 to maxchars
        if charlist(loopc) = 0 then
            nextopencharindex = loopc
            numchars = numchars + 1
            
            if loopc > lastchar then _
                lastchar = loopc
            
            exit function
        end if
    next loopc
end function

function nextopenuser() as integer
    dim loopc as long
    
    for loopc = 1 to maxusers + 1
        if loopc > maxusers then exit for
        if (userlist(loopc).connid = -1 and userlist(loopc).flags.userlogged = false) then exit for
    next loopc
    
    nextopenuser = loopc
end function

sub senduserstatstxt(byval sendindex as integer, byval userindex as integer)
dim guildi as integer


    call writeconsolemsg(sendindex, "estadisticas de: " & userlist(userindex).name, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "nivel: " & userlist(userindex).stats.elv & "  exp: " & userlist(userindex).stats.exp & "/" & userlist(userindex).stats.elu, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "salud: " & userlist(userindex).stats.minhp & "/" & userlist(userindex).stats.maxhp & "  mana: " & userlist(userindex).stats.minman & "/" & userlist(userindex).stats.maxman & "  vitalidad: " & userlist(userindex).stats.minsta & "/" & userlist(userindex).stats.maxsta, fonttypenames.fonttype_info)
    
    if userlist(userindex).invent.weaponeqpobjindex > 0 then
        call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & userlist(userindex).stats.minhit & "/" & userlist(userindex).stats.maxhit & " (" & objdata(userlist(userindex).invent.weaponeqpobjindex).minhit & "/" & objdata(userlist(userindex).invent.weaponeqpobjindex).maxhit & ")", fonttypenames.fonttype_info)
    else
        call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & userlist(userindex).stats.minhit & "/" & userlist(userindex).stats.maxhit, fonttypenames.fonttype_info)
    end if
    
    if userlist(userindex).invent.armoureqpobjindex > 0 then
        if userlist(userindex).invent.escudoeqpobjindex > 0 then
            call writeconsolemsg(sendindex, "(cuerpo) min def/max def: " & objdata(userlist(userindex).invent.armoureqpobjindex).mindef + objdata(userlist(userindex).invent.escudoeqpobjindex).mindef & "/" & objdata(userlist(userindex).invent.armoureqpobjindex).maxdef + objdata(userlist(userindex).invent.escudoeqpobjindex).maxdef, fonttypenames.fonttype_info)
        else
            call writeconsolemsg(sendindex, "(cuerpo) min def/max def: " & objdata(userlist(userindex).invent.armoureqpobjindex).mindef & "/" & objdata(userlist(userindex).invent.armoureqpobjindex).maxdef, fonttypenames.fonttype_info)
        end if
    else
        call writeconsolemsg(sendindex, "(cuerpo) min def/max def: 0", fonttypenames.fonttype_info)
    end if
    
    if userlist(userindex).invent.cascoeqpobjindex > 0 then
        call writeconsolemsg(sendindex, "(cabeza) min def/max def: " & objdata(userlist(userindex).invent.cascoeqpobjindex).mindef & "/" & objdata(userlist(userindex).invent.cascoeqpobjindex).maxdef, fonttypenames.fonttype_info)
    else
        call writeconsolemsg(sendindex, "(cabeza) min def/max def: 0", fonttypenames.fonttype_info)
    end if
    
    guildi = userlist(userindex).guildindex
    if guildi > 0 then
        call writeconsolemsg(sendindex, "clan: " & modguilds.guildname(guildi), fonttypenames.fonttype_info)
        if ucase$(modguilds.guildleader(guildi)) = ucase$(userlist(sendindex).name) then
            call writeconsolemsg(sendindex, "status: lider", fonttypenames.fonttype_info)
        end if
        'guildpts no tienen objeto
    end if
    
    #if conuptime then
        dim tempdate as date
        dim tempsecs as long
        dim tempstr as string
        tempdate = now - userlist(userindex).logontime
        tempsecs = (userlist(userindex).uptime + (abs(day(tempdate) - 30) * 24 * 3600) + (hour(tempdate) * 3600) + (minute(tempdate) * 60) + second(tempdate))
        tempstr = (tempsecs \ 86400) & " dias, " & ((tempsecs mod 86400) \ 3600) & " horas, " & ((tempsecs mod 86400) mod 3600) \ 60 & " minutos, " & (((tempsecs mod 86400) mod 3600) mod 60) & " segundos."
        call writeconsolemsg(sendindex, "logeado hace: " & hour(tempdate) & ":" & minute(tempdate) & ":" & second(tempdate), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "total: " & tempstr, fonttypenames.fonttype_info)
    #end if
    
    call writeconsolemsg(sendindex, "oro: " & userlist(userindex).stats.gld & "  posicion: " & userlist(userindex).pos.x & "," & userlist(userindex).pos.y & " en mapa " & userlist(userindex).pos.map, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "dados: " & userlist(userindex).stats.useratributos(eatributos.fuerza) & ", " & userlist(userindex).stats.useratributos(eatributos.agilidad) & ", " & userlist(userindex).stats.useratributos(eatributos.inteligencia) & ", " & userlist(userindex).stats.useratributos(eatributos.carisma) & ", " & userlist(userindex).stats.useratributos(eatributos.constitucion), fonttypenames.fonttype_info)
  
end sub

sub senduserministatstxt(byval sendindex as integer, byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 23/01/2007
'shows the users stats when the user is online.
'23/01/2007 pablo (toxicwaste) - agrego de funciones y mejora de distribuci�n de par�metros.
'*************************************************
with userlist(userindex)
    call writeconsolemsg(sendindex, "pj: " & .name, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "ciudadanosmatados: " & .faccion.ciudadanosmatados & " criminalesmatados: " & .faccion.criminalesmatados & " usuariosmatados: " & .stats.usuariosmatados, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "npcsmuertos: " & .stats.npcsmuertos, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "clase: " & listaclases(.clase), fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "pena: " & .counters.pena, fonttypenames.fonttype_info)
    if .faccion.armadareal = 1 then
        call writeconsolemsg(sendindex, "armada real desde: " & .faccion.fechaingreso, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "ingres� en nivel: " & .faccion.nivelingreso & " con " & .faccion.matadosingreso & " ciudadanos matados.", fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
    elseif .faccion.fuerzascaos = 1 then
        call writeconsolemsg(sendindex, "legion oscura desde: " & .faccion.fechaingreso, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "ingres� en nivel: " & .faccion.nivelingreso, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
    elseif .faccion.recibioexpinicialreal = 1 then
        call writeconsolemsg(sendindex, "fue armada real", fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
    elseif .faccion.recibioexpinicialcaos = 1 then
        call writeconsolemsg(sendindex, "fue legionario", fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
    end if
    call writeconsolemsg(sendindex, "asesino: " & .reputacion.asesinorep, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "noble: " & .reputacion.noblerep, fonttypenames.fonttype_info)
    if .guildindex > 0 then
        call writeconsolemsg(sendindex, "clan: " & guildname(.guildindex), fonttypenames.fonttype_info)
    end if
    
end with

end sub

sub senduserministatstxtfromchar(byval sendindex as integer, byval charname as string)
'*************************************************
'author: unknown
'last modified: 23/01/2007
'shows the users stats when the user is offline.
'23/01/2007 pablo (toxicwaste) - agrego de funciones y mejora de distribuci�n de par�metros.
'*************************************************
dim charfile as string
dim ban as string
dim bandetailpath as string

    bandetailpath = app.path & "\logs\" & "bandetail.dat"
    charfile = charpath & charname & ".chr"
    
    if fileexist(charfile) then
        call writeconsolemsg(sendindex, "pj: " & charname, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "ciudadanosmatados: " & getvar(charfile, "facciones", "ciudmatados") & " criminalesmatados: " & getvar(charfile, "facciones", "crimmatados") & " usuariosmatados: " & getvar(charfile, "muertes", "usermuertes"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "npcsmuertos: " & getvar(charfile, "muertes", "npcsmuertes"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "clase: " & listaclases(getvar(charfile, "init", "clase")), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "pena: " & getvar(charfile, "counters", "pena"), fonttypenames.fonttype_info)
        if cbyte(getvar(charfile, "facciones", "ejercitoreal")) = 1 then
            call writeconsolemsg(sendindex, "armada real desde: " & getvar(charfile, "facciones", "fechaingreso"), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & cint(getvar(charfile, "facciones", "nivelingreso")) & " con " & cint(getvar(charfile, "facciones", "matadosingreso")) & " ciudadanos matados.", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        elseif cbyte(getvar(charfile, "facciones", "ejercitocaos")) = 1 then
            call writeconsolemsg(sendindex, "legion oscura desde: " & getvar(charfile, "facciones", "fechaingreso"), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & cint(getvar(charfile, "facciones", "nivelingreso")), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        elseif cbyte(getvar(charfile, "facciones", "rexreal")) = 1 then
            call writeconsolemsg(sendindex, "fue armada real", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        elseif cbyte(getvar(charfile, "facciones", "rexcaos")) = 1 then
            call writeconsolemsg(sendindex, "fue legionario", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        end if

        
        call writeconsolemsg(sendindex, "asesino: " & clng(getvar(charfile, "rep", "asesino")), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "noble: " & clng(getvar(charfile, "rep", "nobles")), fonttypenames.fonttype_info)
        
        if isnumeric(getvar(charfile, "guild", "guildindex")) then
            call writeconsolemsg(sendindex, "clan: " & modguilds.guildname(cint(getvar(charfile, "guild", "guildindex"))), fonttypenames.fonttype_info)
        end if
        
        ban = getvar(charfile, "flags", "ban")
        call writeconsolemsg(sendindex, "ban: " & ban, fonttypenames.fonttype_info)
        if ban = "1" then
            call writeconsolemsg(sendindex, "ban por: " & getvar(charfile, charname, "bannedby") & " motivo: " & getvar(bandetailpath, charname, "reason"), fonttypenames.fonttype_info)
        end if
    else
        call writeconsolemsg(sendindex, "el pj no existe: " & charname, fonttypenames.fonttype_info)
    end if
end sub

sub senduserinvtxt(byval sendindex as integer, byval userindex as integer)
on error resume next

    dim j as long
    
    
    call writeconsolemsg(sendindex, userlist(userindex).name, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "tiene " & userlist(userindex).invent.nroitems & " objetos.", fonttypenames.fonttype_info)
    
    for j = 1 to max_inventory_slots
        if userlist(userindex).invent.object(j).objindex > 0 then
            call writeconsolemsg(sendindex, " objeto " & j & " " & objdata(userlist(userindex).invent.object(j).objindex).name & " cantidad:" & userlist(userindex).invent.object(j).amount, fonttypenames.fonttype_info)
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
        call writeconsolemsg(sendindex, charname, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, " tiene " & getvar(charfile, "inventory", "cantidaditems") & " objetos.", fonttypenames.fonttype_info)
        
        for j = 1 to max_inventory_slots
            tmp = getvar(charfile, "inventory", "obj" & j)
            objind = readfield(1, tmp, asc("-"))
            objcant = readfield(2, tmp, asc("-"))
            if objind > 0 then
                call writeconsolemsg(sendindex, " objeto " & j & " " & objdata(objind).name & " cantidad:" & objcant, fonttypenames.fonttype_info)
            end if
        next j
    else
        call writeconsolemsg(sendindex, "usuario inexistente: " & charname, fonttypenames.fonttype_info)
    end if
    
end sub

sub senduserskillstxt(byval sendindex as integer, byval userindex as integer)
on error resume next
dim j as integer
call writeconsolemsg(sendindex, userlist(userindex).name, fonttypenames.fonttype_info)
for j = 1 to numskills
    call writeconsolemsg(sendindex, skillsnames(j) & " = " & userlist(userindex).stats.userskills(j), fonttypenames.fonttype_info)
next
call writeconsolemsg(sendindex, " skilllibres:" & userlist(userindex).stats.skillpts, fonttypenames.fonttype_info)
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
        if esmascotaciudadano then
            call writeconsolemsg(npclist(npcindex).maestrouser, "��" & userlist(userindex).name & " esta atacando tu mascota!!", fonttypenames.fonttype_info)
        end if
end if

end function

sub npcatacado(byval npcindex as integer, byval userindex as integer)
'**********************************************
'author: unknown
'last modification: 24/07/2007
'24/01/2007 -> pablo (toxicwaste): agrego para que se actualize el tag si corresponde.
'24/07/2007 -> pablo (toxicwaste): guardar primero que ataca npc y el que atacas ahora.
'**********************************************
dim eracriminal as boolean

'guardamos el usuario que ataco el npc.
npclist(npcindex).flags.attackedby = userlist(userindex).name

'npc que estabas atacando.
dim lastnpchit as integer
lastnpchit = userlist(userindex).flags.npcatacado
'guarda el npc que estas atacando ahora.
userlist(userindex).flags.npcatacado = npcindex

'revisamos robo de npc.
'guarda el primer nick que lo ataca.
if npclist(npcindex).flags.attackedfirstby = vbnullstring then
    'el que le pegabas antes ya no es tuyo
    if lastnpchit <> 0 then
        if npclist(lastnpchit).flags.attackedfirstby = userlist(userindex).name then
            npclist(lastnpchit).flags.attackedfirstby = vbnullstring
        end if
    end if
    npclist(npcindex).flags.attackedfirstby = userlist(userindex).name
elseif npclist(npcindex).flags.attackedfirstby <> userlist(userindex).name then
    'estas robando npc
    'el que le pegabas antes ya no es tuyo
    if lastnpchit <> 0 then
        if npclist(lastnpchit).flags.attackedfirstby = userlist(userindex).name then
            npclist(lastnpchit).flags.attackedfirstby = vbnullstring
        end if
    end if
end if

if npclist(npcindex).maestrouser > 0 then call allmascotasatacanuser(userindex, npclist(npcindex).maestrouser)

if esmascotaciudadano(npcindex, userindex) then
            call volvercriminal(userindex)
            npclist(npcindex).movement = tipoai.npcdefensa
            npclist(npcindex).hostile = 1
else
    eracriminal = criminal(userindex)
    
    'reputacion
    if npclist(npcindex).stats.alineacion = 0 then
       if npclist(npcindex).npctype = enpctype.guardiareal then
            call volvercriminal(userindex)
       else
            if not npclist(npcindex).maestrouser > 0 then   'mascotas nooo!
                call volvercriminal(userindex)
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
    
    if eracriminal and not criminal(userindex) then
        call volverciudadano(userindex)
    end if
end if

end sub

function puedeapu�alar(byval userindex as integer) as boolean

if userlist(userindex).invent.weaponeqpobjindex > 0 then
 puedeapu�alar = _
 ((userlist(userindex).stats.userskills(eskill.apu�alar) >= min_apu�alar) _
 and (objdata(userlist(userindex).invent.weaponeqpobjindex).apu�ala = 1)) _
 or _
  ((userlist(userindex).clase = eclass.assasin) and _
  (objdata(userlist(userindex).invent.weaponeqpobjindex).apu�ala = 1))
else
 puedeapu�alar = false
end if
end function

sub subirskill(byval userindex as integer, byval skill as integer)

    if userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0 then
        
        if userlist(userindex).stats.userskills(skill) = maxskillpoints then exit sub
        
        dim lvl as integer
        lvl = userlist(userindex).stats.elv
        
        if lvl > ubound(levelskill) then lvl = ubound(levelskill)
        
        if userlist(userindex).stats.userskills(skill) >= levelskill(lvl).levelvalue then exit sub
    
        dim aumenta as integer
        dim prob as integer
        
        if lvl <= 3 then
            prob = 25
        elseif lvl > 3 and lvl < 6 then
            prob = 35
        elseif lvl >= 6 and lvl < 10 then
            prob = 40
        elseif lvl >= 10 and lvl < 20 then
            prob = 45
        else
            prob = 50
        end if
        
        aumenta = randomnumber(1, prob)
        
        if aumenta = 7 then
            userlist(userindex).stats.userskills(skill) = userlist(userindex).stats.userskills(skill) + 1
            call writeconsolemsg(userindex, "�has mejorado tu skill " & skillsnames(skill) & " en un punto!. ahora tienes " & userlist(userindex).stats.userskills(skill) & " pts.", fonttypenames.fonttype_info)
            
            userlist(userindex).stats.exp = userlist(userindex).stats.exp + 50
            if userlist(userindex).stats.exp > maxexp then _
                userlist(userindex).stats.exp = maxexp
            
            call writeconsolemsg(userindex, "�has ganado 50 puntos de experiencia!", fonttypenames.fonttype_fight)
            
            call writeupdateexp(userindex)
            call checkuserlevel(userindex)
        end if
    end if

end sub

sub userdie(byval userindex as integer)
on error goto errorhandler

    'sonido
    if userlist(userindex).genero = egenero.mujer then
        call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.muerte_mujer)
    else
        call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.muerte_hombre)
    end if
    
    'quitar el dialogo del user muerto
    call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(userlist(userindex).char.charindex))
    
    userlist(userindex).stats.minhp = 0
    userlist(userindex).stats.minsta = 0
    userlist(userindex).flags.atacadoporuser = 0
    userlist(userindex).flags.envenenado = 0
    userlist(userindex).flags.muerto = 1
    
    
    dim an as integer
    
    an = userlist(userindex).flags.atacadopornpc
    if an > 0 then
        npclist(an).movement = npclist(an).flags.oldmovement
        npclist(an).hostile = npclist(an).flags.oldhostil
        npclist(an).flags.attackedby = vbnullstring
    end if
    
    an = userlist(userindex).flags.npcatacado
    if an > 0 then
        if npclist(an).flags.attackedfirstby = userlist(userindex).name then
            npclist(an).flags.attackedfirstby = vbnullstring
        end if
    end if
    userlist(userindex).flags.atacadopornpc = 0
    userlist(userindex).flags.npcatacado = 0
    
    '<<<< paralisis >>>>
    if userlist(userindex).flags.paralizado = 1 then
        userlist(userindex).flags.paralizado = 0
        call writeparalizeok(userindex)
    end if
    
    '<<< estupidez >>>
    if userlist(userindex).flags.estupidez = 1 then
        userlist(userindex).flags.estupidez = 0
        call writedumbnomore(userindex)
    end if
    
    '<<<< descansando >>>>
    if userlist(userindex).flags.descansar then
        userlist(userindex).flags.descansar = false
        call writerestok(userindex)
    end if
    
    '<<<< meditando >>>>
    if userlist(userindex).flags.meditando then
        userlist(userindex).flags.meditando = false
        call writemeditatetoggle(userindex)
    end if
    
    '<<<< invisible >>>>
    if userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1 then
        userlist(userindex).flags.oculto = 0
        userlist(userindex).counters.tiempooculto = 0
        userlist(userindex).flags.invisible = 0
        'no hace falta encriptar este nover
        call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, false))
    end if
    
    if triggerzonapelea(userindex, userindex) <> etrigger6.trigger6_permite then
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
    if userlist(userindex).invent.anilloeqpslot > 0 then
        call desequipar(userindex, userlist(userindex).invent.anilloeqpslot)
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
    call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, ningunarma, ningunescudo, ninguncasco)
    call writeupdateuserstats(userindex)
    
    
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
            if userlist(atacante).faccion.criminalesmatados < maxusermatados then _
                userlist(atacante).faccion.criminalesmatados = userlist(atacante).faccion.criminalesmatados + 1
        end if
        
        if userlist(atacante).faccion.recibioexpinicialcaos = 1 and userlist(muerto).faccion.fuerzascaos = 1 then
            userlist(atacante).faccion.reenlistadas = 200  'jaja que trucho
            
            'con esto evitamos que se vuelva a reenlistar
        end if
    else
        if userlist(atacante).flags.lastciudmatado <> userlist(muerto).name then
            userlist(atacante).flags.lastciudmatado = userlist(muerto).name
            if userlist(atacante).faccion.ciudadanosmatados < maxusermatados then _
                userlist(atacante).faccion.ciudadanosmatados = userlist(atacante).faccion.ciudadanosmatados + 1
        end if
    end if
end sub

sub tilelibre(byref pos as worldpos, byref npos as worldpos, byref obj as obj, byref agua as boolean, byref tierra as boolean)
'**************************************************************
'author: unknown
'last modify date: 23/01/2007
'23/01/2007 -> pablo (toxicwaste): el agua es ahora un tilelibre agregando las condiciones necesarias.
'**************************************************************
dim notfound as boolean
dim loopc as integer
dim tx as integer
dim ty as integer
dim hayobj as boolean
    hayobj = false
    npos.map = pos.map
    
    do while not legalpos(pos.map, npos.x, npos.y, agua, tierra) or hayobj
        
        if loopc > 15 then
            notfound = true
            exit do
        end if
        
        for ty = pos.y - loopc to pos.y + loopc
            for tx = pos.x - loopc to pos.x + loopc
            
                if legalpos(npos.map, tx, ty, agua, tierra) then
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
    call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(userlist(userindex).char.charindex))
    
    call writeremovealldialogs(userindex)
    
    oldmap = userlist(userindex).pos.map
    oldx = userlist(userindex).pos.x
    oldy = userlist(userindex).pos.y
    
    call eraseuserchar(userindex)
    
    if oldmap <> map then
        call writechangemap(userindex, map, mapinfo(userlist(userindex).pos.map).mapversion)
        call writeplaymidi(userindex, val(readfield(1, mapinfo(map).music, 45)))
        
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
    
    call makeuserchar(true, map, userindex, map, x, y)
    call writeusercharindexinserver(userindex)
    
    'force a flush, so user index is in there before it's destroyed for teleporting
    call flushbuffer(userindex)
    
    'seguis invisible al pasar de mapa
    if (userlist(userindex).flags.invisible = 1 or userlist(userindex).flags.oculto = 1) and (not userlist(userindex).flags.admininvisible = 1) then
        call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, true))
    end if
    
    if fx and userlist(userindex).flags.admininvisible = 0 then 'fx
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_warp))
        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, fxids.fxwarp, 0))
    end if
    
    call warpmascotas(userindex)
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
        call writeconsolemsg(userindex, "pierdes el control de tus mascotas.", fonttypenames.fonttype_info)
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
        userlist(userindex).counters.salir = iif((userlist(userindex).flags.privilegios and playertype.user) and mapinfo(userlist(userindex).pos.map).pk, tiempo, 0)
        
        call writeconsolemsg(userindex, "cerrando...se cerrar� el juego en " & userlist(userindex).counters.salir & " segundos...", fonttypenames.fonttype_info)
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
    call writeconsolemsg(sendindex, "pj inexistente", fonttypenames.fonttype_info)
else
    call writeconsolemsg(sendindex, "estadisticas de: " & nombre, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "nivel: " & getvar(charpath & nombre & ".chr", "stats", "elv") & "  exp: " & getvar(charpath & nombre & ".chr", "stats", "exp") & "/" & getvar(charpath & nombre & ".chr", "stats", "elu"), fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "vitalidad: " & getvar(charpath & nombre & ".chr", "stats", "minsta") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxsta"), fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, "salud: " & getvar(charpath & nombre & ".chr", "stats", "minhp") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxhp") & "  mana: " & getvar(charpath & nombre & ".chr", "stats", "minman") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxman"), fonttypenames.fonttype_info)
    
    call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & getvar(charpath & nombre & ".chr", "stats", "maxhit"), fonttypenames.fonttype_info)
    
    call writeconsolemsg(sendindex, "oro: " & getvar(charpath & nombre & ".chr", "stats", "gld"), fonttypenames.fonttype_info)
    
#if conuptime then
    dim tempsecs as long
    dim tempstr as string
    tempsecs = getvar(charpath & nombre & ".chr", "init", "uptime")
    tempstr = (tempsecs \ 86400) & " dias, " & ((tempsecs mod 86400) \ 3600) & " horas, " & ((tempsecs mod 86400) mod 3600) \ 60 & " minutos, " & (((tempsecs mod 86400) mod 3600) mod 60) & " segundos."
    call writeconsolemsg(sendindex, "tiempo logeado: " & tempstr, fonttypenames.fonttype_info)
#end if

end if

end sub

sub senduserorotxtfromchar(byval sendindex as integer, byval charname as string)
on error resume next
dim j as integer
dim charfile as string, tmp as string
dim objind as long, objcant as long

charfile = charpath & charname & ".chr"

if fileexist(charfile, vbnormal) then
    call writeconsolemsg(sendindex, charname, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, " tiene " & getvar(charfile, "stats", "banco") & " en el banco.", fonttypenames.fonttype_info)
else
    call writeconsolemsg(sendindex, "usuario inexistente: " & charname, fonttypenames.fonttype_info)
end if

end sub

sub volvercriminal(byval userindex as integer)
'**************************************************************
'author: unknown
'last modify date: 21/06/2006
'nacho: actualiza el tag al cliente
'**************************************************************
if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

if userlist(userindex).flags.privilegios and (playertype.user or playertype.consejero) then
    userlist(userindex).reputacion.burguesrep = 0
    userlist(userindex).reputacion.noblerep = 0
    userlist(userindex).reputacion.pleberep = 0
    userlist(userindex).reputacion.bandidorep = userlist(userindex).reputacion.bandidorep + vlasalto
    if userlist(userindex).reputacion.bandidorep > maxrep then _
        userlist(userindex).reputacion.bandidorep = maxrep
    if userlist(userindex).faccion.armadareal = 1 then call expulsarfaccionreal(userindex)
end if

call refreshcharstatus(userindex)

end sub

sub volverciudadano(byval userindex as integer)
'**************************************************************
'author: unknown
'last modify date: 21/06/2006
'nacho: actualiza el tag al cliente.
'**************************************************************

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

userlist(userindex).reputacion.ladronesrep = 0
userlist(userindex).reputacion.bandidorep = 0
userlist(userindex).reputacion.asesinorep = 0
userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlasalto
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

call refreshcharstatus(userindex)

end sub

