attribute vb_name = "usuarios"
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

'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'rutinas de los usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

sub actstats(byval victimindex as integer, byval attackerindex as integer)
    dim daexp as integer
    dim eracriminal as boolean
    
    daexp = cint(userlist(victimindex).stats.elv) * 2
    
    with userlist(attackerindex)
        .stats.exp = .stats.exp + daexp
        if .stats.exp > maxexp then .stats.exp = maxexp
        
        'lo mata
        call writeconsolemsg(attackerindex, "has matado a " & userlist(victimindex).name & "!", fonttypenames.fonttype_fight)
        call writeconsolemsg(attackerindex, "has ganado " & daexp & " puntos de experiencia.", fonttypenames.fonttype_fight)
              
        call writeconsolemsg(victimindex, "�" & .name & " te ha matado!", fonttypenames.fonttype_fight)
        
        if triggerzonapelea(victimindex, attackerindex) <> trigger6_permite then
            eracriminal = criminal(attackerindex)
            
            with .reputacion
                if not criminal(victimindex) then
                    .asesinorep = .asesinorep + vlasesino * 2
                    if .asesinorep > maxrep then .asesinorep = maxrep
                    .burguesrep = 0
                    .noblerep = 0
                    .pleberep = 0
                else
                    .noblerep = .noblerep + vlnoble
                    if .noblerep > maxrep then .noblerep = maxrep
                end if
            end with
            
            if criminal(attackerindex) then
                if not eracriminal then call refreshcharstatus(attackerindex)
            else
                if eracriminal then call refreshcharstatus(attackerindex)
            end if
        end if
        
        'call userdie(victimindex)
        
        call flushbuffer(victimindex)
        
        'log
        call logasesinato(.name & " asesino a " & userlist(victimindex).name)
    end with
end sub

sub revivirusuario(byval userindex as integer)
    with userlist(userindex)
        .flags.muerto = 0
        .stats.minhp = .stats.useratributos(eatributos.constitucion)
        
        if .stats.minhp > .stats.maxhp then
            .stats.minhp = .stats.maxhp
        end if
        
        if .flags.navegando = 1 then
            dim barco as objdata
            barco = objdata(.invent.barcoobjindex)
            .char.head = 0
            
            if .faccion.armadareal = 1 then
                .char.body = ifragatareal
            elseif .faccion.fuerzascaos = 1 then
                .char.body = ifragatacaos
            else
                if criminal(userindex) then
                    select case barco.ropaje
                        case ibarca
                            .char.body = ibarcapk
                        
                        case igalera
                            .char.body = igalerapk
                        
                        case igaleon
                            .char.body = igaleonpk
                    end select
                else
                    select case barco.ropaje
                        case ibarca
                            .char.body = ibarcaciuda
                        
                        case igalera
                            .char.body = igaleraciuda
                        
                        case igaleon
                            .char.body = igaleonciuda
                    end select
                end if
            end if
            
            .char.shieldanim = ningunescudo
            .char.weaponanim = ningunarma
            .char.cascoanim = ninguncasco
        else
            call darcuerpodesnudo(userindex)
            
            .char.head = .origchar.head
        end if
        
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        call writeupdateuserstats(userindex)
    end with
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
        
        call senddata(sendtarget.topcarea, userindex, preparemessagecharacterchange(body, head, heading, .charindex, arma, escudo, .fx, .loops, casco))
    end with
end sub

sub enviarfama(byval userindex as integer)
    dim l as long
    
    with userlist(userindex).reputacion
        l = (-.asesinorep) + _
            (-.bandidorep) + _
            .burguesrep + _
            (-.ladronesrep) + _
            .noblerep + _
            .pleberep
        l = round(l / 6)
        
        .promedio = l
    end with
    
    call writefame(userindex)
end sub

sub eraseuserchar(byval userindex as integer, byval isadmininvisible as boolean)
'*************************************************
'author: unknown
'last modified: 08/01/2009
'08/01/2009: zama - no se borra el char de un admin invisible en todos los clientes excepto en su mismo cliente.
'*************************************************

on error goto errorhandler
    
    with userlist(userindex)
        charlist(.char.charindex) = 0
        
        if .char.charindex = lastchar then
            do until charlist(lastchar) > 0
                lastchar = lastchar - 1
                if lastchar <= 1 then exit do
            loop
        end if
        
        ' si esta invisible, solo el sabe de su propia existencia, es innecesario borrarlo en los demas clientes
        if isadmininvisible then
            call enviardatosaslot(userindex, preparemessagecharacterremove(.char.charindex))
        else
            'le mandamos el mensaje para que borre el personaje a los clientes que est�n cerca
            call senddata(sendtarget.topcarea, userindex, preparemessagecharacterremove(.char.charindex))
        end if
        
        call quitaruser(userindex, .pos.map)
        
        mapdata(.pos.map, .pos.x, .pos.y).userindex = 0
        .char.charindex = 0
    end with
    
    numchars = numchars - 1
exit sub
    
errorhandler:
    call logerror("error en eraseuserchar " & err.number & ": " & err.description)
end sub

sub refreshcharstatus(byval userindex as integer)
'*************************************************
'author: tararira
'last modified: 04/07/2009
'refreshes the status and tag of userindex.
'04/07/2009: zama - ahora mantenes la fragata fantasmal si estas muerto.
'*************************************************
    dim klan as string
    dim barco as objdata
    dim escriminal as boolean
    
    with userlist(userindex)
        if .guildindex > 0 then
            klan = modguilds.guildname(.guildindex)
            klan = " <" & klan & ">"
        end if
        
        escriminal = criminal(userindex)
        
        if .showname then
            call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, escriminal, .name & klan))
        else
            call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, escriminal, vbnullstring))
        end if
        
        'si esta navengando, se cambia la barca.
        if .flags.navegando then
            if .flags.muerto = 1 then
                .char.body = ifragatafantasmal
            else
                barco = objdata(.invent.object(.invent.barcoslot).objindex)
                
                if .faccion.armadareal = 1 then
                    .char.body = ifragatareal
                elseif userlist(userindex).faccion.fuerzascaos = 1 then
                    .char.body = ifragatacaos
                else
                    if escriminal then
                        select case barco.ropaje
                            case ibarca
                                .char.body = ibarcapk
                            
                            case igalera
                                .char.body = igalerapk
                            
                            case igaleon
                                .char.body = igaleonpk
                        end select
                    else
                        select case barco.ropaje
                            case ibarca
                                .char.body = ibarcaciuda
                            
                            case igalera
                                .char.body = igaleraciuda
                            
                            case igaleon
                                .char.body = igaleonciuda
                        end select
                    end if
                end if
            end if
            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        end if
    end with
end sub

sub makeuserchar(byval tomap as boolean, byval sndindex as integer, byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
'*************************************************
'author: unknown
'last modified: 23/07/2009
'
'23/07/2009: budi - ahora se env�a el nick
'*************************************************

on error goto hayerror
    dim charindex as integer
    
    with userlist(userindex)
    
        if inmapbounds(map, x, y) then
            'if needed make a new character in list
            if .char.charindex = 0 then
                charindex = nextopencharindex
                .char.charindex = charindex
                charlist(charindex) = userindex
            end if
            
            'place character on map if needed
            if tomap then mapdata(map, x, y).userindex = userindex
            
            'send make character command to clients
            dim klan as string
            if .guildindex > 0 then
                klan = modguilds.guildname(.guildindex)
            end if
            
            dim bcr as byte
            dim bnick as string
            dim bpriv as byte
            
            bcr = criminal(userindex)
            bpriv = .flags.privilegios
            'preparo el nick
            if .showname then
                if userlist(sndindex).flags.privilegios and playertype.user then
                    if lenb(klan) <> 0 then
                        bnick = .name & " <" & klan & ">"
                    else
                        bnick = .name
                    end if
'                    bpriv = .flags.privilegios
                else
                    if .flags.invisible or .flags.oculto then
                        bnick = .name & " " & tag_user_invisible
                    else
                        if lenb(klan) <> 0 then
                            bnick = .name & " <" & klan & ">"
                        else
                            bnick = .name
                        end if
                    end if
'                    bpriv = .flags.privilegios
                end if
            else
                bnick = vbnullstring
'                bpriv = playertype.user
            end if
            
            if not tomap then
                call writecharactercreate(sndindex, .char.body, .char.head, .char.heading, _
                            .char.charindex, x, y, _
                            .char.weaponanim, .char.shieldanim, .char.fx, 999, .char.cascoanim, _
                            bnick, bcr, bpriv)
            else
                'hide the name and clan - set privs as normal user
                 call agregaruser(userindex, .pos.map)
            end if
            
        end if
    end with
exit sub

hayerror:
    logerror ("makeuserchar: num: " & err.number & " desc: " & err.description)
    'resume next
    call closesocket(userindex)
end sub

''
' checks if the user gets the next level.
'
' @param userindex specifies reference to user

sub checkuserlevel(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 12/09/2007
'chequea que el usuario no halla alcanzado el siguiente nivel,
'de lo contrario le da la vida, mana, etc, correspodiente.
'07/08/2006 integer - modificacion de los valores
'01/10/2007 tavo - corregido el bug de stat_maxelv
'24/01/2007 pablo (toxicwaste) - agrego modificaciones en elu al subir de nivel.
'24/01/2007 pablo (toxicwaste) - agrego modificaciones de la subida de mana de los magos por lvl.
'13/03/2007 pablo (toxicwaste) - agrego diferencias entre el 18 y el 19 en constituci�n.
'09/01/2008 pablo (toxicwaste) - ahora el incremento de vida por consituci�n se controla desde balance.dat
'12/09/2008 marco vanotti (marco) - ahora si se llega a nivel 25 y est� en un clan, se lo expulsa para no sumar antifacci�n
'02/03/2009 zama - arreglada la validacion de expulsion para miembros de clanes faccionarios que llegan a 25.
'*************************************************
    dim pts as integer
    dim aumentohit as integer
    dim aumentomana as integer
    dim aumentosta as integer
    dim aumentohp as integer
    dim wasnewbie as boolean
    dim promedio as double
    dim aux as integer
    dim distvida(1 to 5) as integer
    dim gi as integer 'guild index
    
on error goto errhandler
    
    wasnewbie = esnewbie(userindex)
    
    with userlist(userindex)
        do while .stats.exp >= .stats.elu
            
            'checkea si alcanz� el m�ximo nivel
            if .stats.elv >= stat_maxelv then
                .stats.exp = 0
                .stats.elu = 0
                exit sub
            end if
            
            'store it!
            call statistics.userlevelup(userindex)
            
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_nivel, .pos.x, .pos.y))
            call writeconsolemsg(userindex, "�has subido de nivel!", fonttypenames.fonttype_info)
            
            if .stats.elv = 1 then
                pts = 10
            else
                'for multiple levels being rised at once
                pts = pts + 5
            end if
            
            .stats.elv = .stats.elv + 1
            
            .stats.exp = .stats.exp - .stats.elu
            
            'nueva subida de exp x lvl. pablo (toxicwaste)
            if .stats.elv < 15 then
                .stats.elu = .stats.elu * 1.4
            elseif .stats.elv < 21 then
                .stats.elu = .stats.elu * 1.35
            elseif .stats.elv < 33 then
                .stats.elu = .stats.elu * 1.3
            elseif .stats.elv < 41 then
                .stats.elu = .stats.elu * 1.225
            else
                .stats.elu = .stats.elu * 1.25
            end if
            
            'calculo subida de vida
            promedio = modvida(.clase) - (21 - .stats.useratributos(eatributos.constitucion)) * 0.5
            aux = randomnumber(0, 100)
            
        
            if promedio - int(promedio) = 0.5 then
                'es promedio semientero
                distvida(1) = distribucionsemienteravida(1)
                distvida(2) = distvida(1) + distribucionsemienteravida(2)
                distvida(3) = distvida(2) + distribucionsemienteravida(3)
                distvida(4) = distvida(3) + distribucionsemienteravida(4)
                
                if aux <= distvida(1) then
                    aumentohp = promedio + 1.5
                elseif aux <= distvida(2) then
                    aumentohp = promedio + 0.5
                elseif aux <= distvida(3) then
                    aumentohp = promedio - 0.5
                else
                    aumentohp = promedio - 1.5
                end if
            else
                'es promedio entero
                
'todo : sacar este if en la 0.13 y dejar s�lo el else (toxicwaste)
                if .clase = eclass.mage then
                    if aux <= 33 then
                        aumentohp = promedio + 1
                    elseif aux <= 66 then
                        aumentohp = promedio
                    else
                        aumentohp = promedio - 1
                    end if
                else
                    distvida(1) = distribucionsemienteravida(1)
                    distvida(2) = distvida(1) + distribucionenteravida(2)
                    distvida(3) = distvida(2) + distribucionenteravida(3)
                    distvida(4) = distvida(3) + distribucionenteravida(4)
                    distvida(5) = distvida(4) + distribucionenteravida(5)
                    
                    if aux <= distvida(1) then
                        aumentohp = promedio + 2
                    elseif aux <= distvida(2) then
                        aumentohp = promedio + 1
                    elseif aux <= distvida(3) then
                        aumentohp = promedio
                    elseif aux <= distvida(4) then
                        aumentohp = promedio - 1
                    else
                        aumentohp = promedio - 2
                    end if
                end if
            end if
        
            select case .clase
                case eclass.warrior
                    aumentohit = iif(.stats.elv > 35, 2, 3)
                    aumentosta = aumentostdef
                
                case eclass.hunter
                    aumentohit = iif(.stats.elv > 35, 2, 3)
                    aumentosta = aumentostdef
                
                case eclass.pirat
                    aumentohit = 3
                    aumentosta = aumentostdef
                
                case eclass.paladin
                    aumentohit = iif(.stats.elv > 35, 1, 3)
                    aumentomana = .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostdef
                
                case eclass.thief
                    aumentohit = 1
                    aumentosta = aumentostladron
                
                case eclass.mage
                    aumentohit = 1
                    aumentomana = 2.8 * .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostmago
                
                case eclass.lumberjack
                    aumentohit = 2
                    aumentosta = aumentostle�ador
                
                case eclass.miner
                    aumentohit = 2
                    aumentosta = aumentostminero
                
                case eclass.fisher
                    aumentohit = 1
                    aumentosta = aumentostpescador
                
                case eclass.cleric
                    aumentohit = 2
                    aumentomana = 2 * .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostdef
                
                case eclass.druid
                    aumentohit = 2
                    aumentomana = 2 * .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostdef
                
                case eclass.assasin
                    aumentohit = iif(.stats.elv > 35, 1, 3)
                    aumentomana = .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostdef
                
                case eclass.bard
                    aumentohit = 2
                    aumentomana = 2 * .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostdef
                
                case eclass.blacksmith, eclass.carpenter
                    aumentohit = 2
                    aumentosta = aumentostdef
                    
                case eclass.bandit
                    aumentohit = iif(.stats.elv > 35, 1, 3)
                    aumentomana = iif(.stats.maxman = 300, 0, .stats.useratributos(eatributos.inteligencia) - 10)
                    if aumentomana < 4 then aumentomana = 4
                    aumentosta = aumentostle�ador
                
                case else
                    aumentohit = 2
                    aumentosta = aumentostdef
            end select
            
            'actualizamos hitpoints
            .stats.maxhp = .stats.maxhp + aumentohp
            if .stats.maxhp > stat_maxhp then .stats.maxhp = stat_maxhp
            
            'actualizamos stamina
            .stats.maxsta = .stats.maxsta + aumentosta
            if .stats.maxsta > stat_maxsta then .stats.maxsta = stat_maxsta
            
            'actualizamos mana
            .stats.maxman = .stats.maxman + aumentomana
            if .stats.maxman > stat_maxman then .stats.maxman = stat_maxman
            
            if .clase = eclass.bandit then 'mana del bandido restringido hasta 300
                if .stats.maxman > 300 then
                    .stats.maxman = 300
                end if
            end if
            
            'actualizamos golpe m�ximo
            .stats.maxhit = .stats.maxhit + aumentohit
            if .stats.elv < 36 then
                if .stats.maxhit > stat_maxhit_under36 then _
                    .stats.maxhit = stat_maxhit_under36
            else
                if .stats.maxhit > stat_maxhit_over36 then _
                    .stats.maxhit = stat_maxhit_over36
            end if
            
            'actualizamos golpe m�nimo
            .stats.minhit = .stats.minhit + aumentohit
            if .stats.elv < 36 then
                if .stats.minhit > stat_maxhit_under36 then _
                    .stats.minhit = stat_maxhit_under36
            else
                if .stats.minhit > stat_maxhit_over36 then _
                    .stats.minhit = stat_maxhit_over36
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
                call writeconsolemsg(userindex, "tu golpe m�ximo aument� en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
                call writeconsolemsg(userindex, "tu golpe minimo aument� en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
            end if
            
            call logdesarrollo(.name & " paso a nivel " & .stats.elv & " gano hp: " & aumentohp)
            
            .stats.minhp = .stats.maxhp

                'if user is in a party, we modify the variable p_sumaniveleselevados
                call mdparty.actualizarsumaniveleselevados(userindex)
                    'if user reaches lvl 25 and he is in a guild, we check the guild's alignment and expulses the user if guild has factionary alignment
        
            if .stats.elv = 25 then
                gi = .guildindex
                if gi > 0 then
                    if modguilds.guildalignment(gi) = "legi�n oscura" or modguilds.guildalignment(gi) = "armada real" then
                        'we get here, so guild has factionary alignment, we have to expulse the user
                        call modguilds.m_echarmiembrodeclan(-1, .name)
                        call senddata(sendtarget.toguildmembers, gi, preparemessageconsolemsg(.name & " deja el clan.", fonttypenames.fonttype_guild))
                        call writeconsolemsg(userindex, "�ya tienes la madurez suficiente como para decidir bajo que estandarte pelear�s! por esta raz�n, hasta tanto no te enlistes en la facci�n bajo la cual tu clan est� alineado, estar�s exclu�do del mismo.", fonttypenames.fonttype_guild)
                    end if
                end if
            end if

        loop
        
        'if it ceased to be a newbie, remove newbie items and get char away from newbie dungeon
        if not esnewbie(userindex) and wasnewbie then
            call quitarnewbieobj(userindex)
            if ucase$(mapinfo(.pos.map).restringir) = "newbie" then
                call warpuserchar(userindex, 1, 50, 50, true)
                call writeconsolemsg(userindex, "debes abandonar el dungeon newbie.", fonttypenames.fonttype_info)
            end if
        end if
        
        'send all gained skill points at once (if any)
        if pts > 0 then
            call writelevelup(userindex, pts)
            
            .stats.skillpts = .stats.skillpts + pts
            
            call writeconsolemsg(userindex, "has ganado un total de " & pts & " skillpoints.", fonttypenames.fonttype_info)
        end if
        
    end with
    
    call writeupdateuserstats(userindex)
exit sub

errhandler:
    call logerror("error en la subrutina checkuserlevel - error : " & err.number & " - description : " & err.description)
end sub

public function puedeatravesaragua(byval userindex as integer) as boolean
    puedeatravesaragua = userlist(userindex).flags.navegando = 1 _
                    or userlist(userindex).flags.vuela = 1
end function

sub moveuserchar(byval userindex as integer, byval nheading as eheading)
'*************************************************
'author: unknown
'last modified: 13/07/2009
'moves the char, sending the message to everyone in range.
'30/03/2009: zama - now it's legal to move where a casper is, changing its pos to where the moving char was.
'28/05/2009: zama - when you are moved out of an arena, the resurrection safe is activated.
'13/07/2009: zama - now all the clients don't know when an invisible admin moves, they force the admin to move.
'13/07/2009: zama - invisible admins aren't allowed to force dead characater to move
'*************************************************
    dim npos as worldpos
    dim sailing as boolean
    dim casperindex as integer
    dim casperheading as eheading
    dim casperpos as worldpos
    
    sailing = puedeatravesaragua(userindex)
    npos = userlist(userindex).pos
    call headtopos(nheading, npos)
        
    if movetolegalpos(userlist(userindex).pos.map, npos.x, npos.y, sailing, not sailing) then
        'si no estoy solo en el mapa...
        if mapinfo(userlist(userindex).pos.map).numusers > 1 then
               
            casperindex = mapdata(userlist(userindex).pos.map, npos.x, npos.y).userindex
            'si hay un usuario, y paso la validacion, entonces es un casper
            if casperindex > 0 then
                ' los admins invisibles no pueden patear caspers
                if not (userlist(userindex).flags.admininvisible = 1) then
                    
                    if triggerzonapelea(userindex, casperindex) = trigger6_prohibe then
                        if userlist(casperindex).flags.seguroresu = false then
                            userlist(casperindex).flags.seguroresu = true
                            call writeresuscitationsafeon(casperindex)
                        end if
                    end if
    
                    casperheading = invertheading(nheading)
                    casperpos = userlist(casperindex).pos
                    call headtopos(casperheading, casperpos)
    
                    with userlist(casperindex)
                        
                        ' si es un admin invisible, no se avisa a los demas clientes
                        if not .flags.admininvisible = 1 then _
                            call senddata(sendtarget.topcareabutindex, casperindex, preparemessagecharactermove(.char.charindex, casperpos.x, casperpos.y))
                        
                        call writeforcecharmove(casperindex, casperheading)
                            
                        'update map and user pos
                        .pos = casperpos
                        .char.heading = casperheading
                        mapdata(.pos.map, casperpos.x, casperpos.y).userindex = casperindex
                    
                    end with
                
                    'actualizamos las �reas de ser necesario
                    call modareas.checkupdateneededuser(casperindex, casperheading)
                end if
            end if

            
            ' si es un admin invisible, no se avisa a los demas clientes
            if not userlist(userindex).flags.admininvisible = 1 then _
                call senddata(sendtarget.topcareabutindex, userindex, preparemessagecharactermove(userlist(userindex).char.charindex, npos.x, npos.y))
            
        end if
        
        ' los admins invisibles no pueden patear caspers
        if not ((userlist(userindex).flags.admininvisible = 1) and casperindex <> 0) then
            dim olduserindex as integer
            
            olduserindex = mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex
            
            ' si no hay intercambio de pos con nadie
            if olduserindex = userindex then
                mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = 0
            end if
            
            userlist(userindex).pos = npos
            userlist(userindex).char.heading = nheading
            mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).userindex = userindex
            
            'actualizamos las �reas de ser necesario
            call modareas.checkupdateneededuser(userindex, nheading)
        else
            call writeposupdate(userindex)
        end if

    else
        call writeposupdate(userindex)
    end if
    
    if userlist(userindex).counters.trabajando then _
        userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando - 1

    if userlist(userindex).counters.ocultando then _
        userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando - 1
end sub

public function invertheading(byval nheading as eheading) as eheading
'*************************************************
'author: zama
'last modified: 30/03/2009
'returns the heading opposite to the one passed by val.
'*************************************************
    select case nheading
        case eheading.east
            invertheading = west
        case eheading.west
            invertheading = east
        case eheading.south
            invertheading = north
        case eheading.north
            invertheading = south
    end select
end function

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

public sub senduserstatstxt(byval sendindex as integer, byval userindex as integer)
    dim guildi as integer
    
    with userlist(userindex)
        call writeconsolemsg(sendindex, "estadisticas de: " & .name, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "nivel: " & .stats.elv & "  exp: " & .stats.exp & "/" & .stats.elu, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "salud: " & .stats.minhp & "/" & .stats.maxhp & "  mana: " & .stats.minman & "/" & .stats.maxman & "  vitalidad: " & .stats.minsta & "/" & .stats.maxsta, fonttypenames.fonttype_info)
        
        if .invent.weaponeqpobjindex > 0 then
            call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & .stats.minhit & "/" & .stats.maxhit & " (" & objdata(.invent.weaponeqpobjindex).minhit & "/" & objdata(.invent.weaponeqpobjindex).maxhit & ")", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & .stats.minhit & "/" & .stats.maxhit, fonttypenames.fonttype_info)
        end if
        
        if .invent.armoureqpobjindex > 0 then
            if .invent.escudoeqpobjindex > 0 then
                call writeconsolemsg(sendindex, "(cuerpo) min def/max def: " & objdata(.invent.armoureqpobjindex).mindef + objdata(.invent.escudoeqpobjindex).mindef & "/" & objdata(.invent.armoureqpobjindex).maxdef + objdata(.invent.escudoeqpobjindex).maxdef, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(sendindex, "(cuerpo) min def/max def: " & objdata(.invent.armoureqpobjindex).mindef & "/" & objdata(.invent.armoureqpobjindex).maxdef, fonttypenames.fonttype_info)
            end if
        else
            call writeconsolemsg(sendindex, "(cuerpo) min def/max def: 0", fonttypenames.fonttype_info)
        end if
        
        if .invent.cascoeqpobjindex > 0 then
            call writeconsolemsg(sendindex, "(cabeza) min def/max def: " & objdata(.invent.cascoeqpobjindex).mindef & "/" & objdata(.invent.cascoeqpobjindex).maxdef, fonttypenames.fonttype_info)
        else
            call writeconsolemsg(sendindex, "(cabeza) min def/max def: 0", fonttypenames.fonttype_info)
        end if
        
        guildi = .guildindex
        if guildi > 0 then
            call writeconsolemsg(sendindex, "clan: " & modguilds.guildname(guildi), fonttypenames.fonttype_info)
            if ucase$(modguilds.guildleader(guildi)) = ucase$(.name) then
                call writeconsolemsg(sendindex, "status: lider", fonttypenames.fonttype_info)
            end if
            'guildpts no tienen objeto
        end if
        
#if conuptime then
        dim tempdate as date
        dim tempsecs as long
        dim tempstr as string
        tempdate = now - .logontime
        tempsecs = (.uptime + (abs(day(tempdate) - 30) * 24 * 3600) + (hour(tempdate) * 3600) + (minute(tempdate) * 60) + second(tempdate))
        tempstr = (tempsecs \ 86400) & " dias, " & ((tempsecs mod 86400) \ 3600) & " horas, " & ((tempsecs mod 86400) mod 3600) \ 60 & " minutos, " & (((tempsecs mod 86400) mod 3600) mod 60) & " segundos."
        call writeconsolemsg(sendindex, "logeado hace: " & hour(tempdate) & ":" & minute(tempdate) & ":" & second(tempdate), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "total: " & tempstr, fonttypenames.fonttype_info)
#end if
        
        call writeconsolemsg(sendindex, "oro: " & .stats.gld & "  posicion: " & .pos.x & "," & .pos.y & " en mapa " & .pos.map, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "dados: " & .stats.useratributos(eatributos.fuerza) & ", " & .stats.useratributos(eatributos.agilidad) & ", " & .stats.useratributos(eatributos.inteligencia) & ", " & .stats.useratributos(eatributos.carisma) & ", " & .stats.useratributos(eatributos.constitucion), fonttypenames.fonttype_info)
    end with
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
    
    with userlist(userindex)
        call writeconsolemsg(sendindex, .name, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "tiene " & .invent.nroitems & " objetos.", fonttypenames.fonttype_info)
        
        for j = 1 to max_inventory_slots
            if .invent.object(j).objindex > 0 then
                call writeconsolemsg(sendindex, " objeto " & j & " " & objdata(.invent.object(j).objindex).name & " cantidad:" & .invent.object(j).amount, fonttypenames.fonttype_info)
            end if
        next j
    end with
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
    next j
    
    call writeconsolemsg(sendindex, " skilllibres:" & userlist(userindex).stats.skillpts, fonttypenames.fonttype_info)
end sub

private function esmascotaciudadano(byval npcindex as integer, byval userindex as integer) as boolean

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
'last modification: 06/28/2008
'24/01/2007 -> pablo (toxicwaste): agrego para que se actualize el tag si corresponde.
'24/07/2007 -> pablo (toxicwaste): guardar primero que ataca npc y el que atacas ahora.
'06/28/2008 -> niconz: los elementales al atacarlos por su amo no se paran m�s al lado de �l sin hacer nada.
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
    
    if npclist(npcindex).maestrouser > 0 then
        if npclist(npcindex).maestrouser <> userindex then
            call allmascotasatacanuser(userindex, npclist(npcindex).maestrouser)
        end if
    end if
    
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
        
        if npclist(npcindex).maestrouser <> userindex then
            'hacemos que el npc se defienda
            npclist(npcindex).movement = tipoai.npcdefensa
            npclist(npcindex).hostile = 1
        end if
        
        if eracriminal and not criminal(userindex) then
            call volverciudadano(userindex)
        end if
    end if
end sub
public function puedeapu�alar(byval userindex as integer) as boolean

    if userlist(userindex).invent.weaponeqpobjindex > 0 then
        if objdata(userlist(userindex).invent.weaponeqpobjindex).apu�ala = 1 then
            puedeapu�alar = userlist(userindex).stats.userskills(eskill.apu�alar) >= min_apu�alar _
                        or userlist(userindex).clase = eclass.assasin
        end if
    end if
end function

sub subirskill(byval userindex as integer, byval skill as integer)

    with userlist(userindex)
        if .flags.hambre = 0 and .flags.sed = 0 then
            
            if .stats.userskills(skill) = maxskillpoints then exit sub
            
            dim lvl as integer
            lvl = .stats.elv
            
            if lvl > ubound(levelskill) then lvl = ubound(levelskill)
            
            if .stats.userskills(skill) >= levelskill(lvl).levelvalue then exit sub
            
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
            
            
            if randomnumber(1, prob) = 7 then
                .stats.userskills(skill) = .stats.userskills(skill) + 1
                call writeconsolemsg(userindex, "�has mejorado tu skill " & skillsnames(skill) & " en un punto!. ahora tienes " & .stats.userskills(skill) & " pts.", fonttypenames.fonttype_info)
                
                .stats.exp = .stats.exp + 50
                if .stats.exp > maxexp then .stats.exp = maxexp
                
                call writeconsolemsg(userindex, "�has ganado 50 puntos de experiencia!", fonttypenames.fonttype_fight)
                
                call writeupdateexp(userindex)
                call checkuserlevel(userindex)
            end if
        end if
    end with
end sub

''
' muere un usuario
'
' @param userindex  indice del usuario que muere
'

sub userdie(byval userindex as integer)
'************************************************
'author: uknown
'last modified: 21/07/2009
'04/15/2008: niconz - ahora se resetea el counter del invi
'13/02/2009: zama - ahora se borran las mascotas cuando moris en agua.
'27/05/2009: zama - el seguro de resu no se activa si estas en una arena.
'21/07/2009: marco - al morir se desactiva el comercio seguro.
'************************************************
on error goto errorhandler
    dim i as long
    dim an as integer
    
    with userlist(userindex)
        'sonido
        if .genero = egenero.mujer then
            call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.muerte_mujer)
        else
            call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.muerte_hombre)
        end if
        
        'quitar el dialogo del user muerto
        call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(.char.charindex))
        
        .stats.minhp = 0
        .stats.minsta = 0
        .flags.atacadoporuser = 0
        .flags.envenenado = 0
        .flags.muerto = 1
        ' no se activa en arenas
        if triggerzonapelea(userindex, userindex) <> trigger6_permite then
            .flags.seguroresu = true
            call writeresuscitationsafeon(userindex)
        else
            .flags.seguroresu = false
            call writeresuscitationsafeoff(userindex)
        end if
        
        an = .flags.atacadopornpc
        if an > 0 then
            npclist(an).movement = npclist(an).flags.oldmovement
            npclist(an).hostile = npclist(an).flags.oldhostil
            npclist(an).flags.attackedby = vbnullstring
        end if
        
        an = .flags.npcatacado
        if an > 0 then
            if npclist(an).flags.attackedfirstby = .name then
                npclist(an).flags.attackedfirstby = vbnullstring
            end if
        end if
        .flags.atacadopornpc = 0
        .flags.npcatacado = 0
        
        '<<<< paralisis >>>>
        if .flags.paralizado = 1 then
            .flags.paralizado = 0
            call writeparalizeok(userindex)
        end if
        
        '<<< estupidez >>>
        if .flags.estupidez = 1 then
            .flags.estupidez = 0
            call writedumbnomore(userindex)
        end if
        
        '<<<< descansando >>>>
        if .flags.descansar then
            .flags.descansar = false
            call writerestok(userindex)
        end if
        
        '<<<< meditando >>>>
        if .flags.meditando then
            .flags.meditando = false
            call writemeditatetoggle(userindex)
        end if
        
        '<<<< invisible >>>>
        if .flags.invisible = 1 or .flags.oculto = 1 then
            .flags.oculto = 0
            .flags.invisible = 0
            .counters.tiempooculto = 0
            .counters.invisibilidad = 0
            
            'call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(.char.charindex, false))
            call setinvisible(userindex, userlist(userindex).char.charindex, false)
        end if
        
        if triggerzonapelea(userindex, userindex) <> etrigger6.trigger6_permite then
            ' << si es newbie no pierde el inventario >>
            if not esnewbie(userindex) or criminal(userindex) then
                call tirartodo(userindex)
            else
                call tirartodoslositemsnonewbies(userindex)
            end if
        end if
        
        ' desequipa todos los objetos
        'desequipar armadura
        if .invent.armoureqpobjindex > 0 then
            call desequipar(userindex, .invent.armoureqpslot)
        end if
        
        'desequipar arma
        if .invent.weaponeqpobjindex > 0 then
            call desequipar(userindex, .invent.weaponeqpslot)
        end if
        
        'desequipar casco
        if .invent.cascoeqpobjindex > 0 then
            call desequipar(userindex, .invent.cascoeqpslot)
        end if
        
        'desequipar herramienta
        if .invent.anilloeqpslot > 0 then
            call desequipar(userindex, .invent.anilloeqpslot)
        end if
        
        'desequipar municiones
        if .invent.municioneqpobjindex > 0 then
            call desequipar(userindex, .invent.municioneqpslot)
        end if
        
        'desequipar escudo
        if .invent.escudoeqpobjindex > 0 then
            call desequipar(userindex, .invent.escudoeqpslot)
        end if
        
        ' << reseteamos los posibles fx sobre el personaje >>
        if .char.loops = infinite_loops then
            .char.fx = 0
            .char.loops = 0
        end if
        
        ' << restauramos el mimetismo
        if .flags.mimetizado = 1 then
            .char.body = .charmimetizado.body
            .char.head = .charmimetizado.head
            .char.cascoanim = .charmimetizado.cascoanim
            .char.shieldanim = .charmimetizado.shieldanim
            .char.weaponanim = .charmimetizado.weaponanim
            .counters.mimetismo = 0
            .flags.mimetizado = 0
        end if
        
        ' << restauramos los atributos >>
        if .flags.tomopocion = true then
            for i = 1 to 5
                .stats.useratributos(i) = .stats.useratributosbackup(i)
            next i
        end if
        
        '<< cambiamos la apariencia del char >>
        if .flags.navegando = 0 then
            .char.body = icuerpomuerto
            .char.head = icabezamuerto
            .char.shieldanim = ningunescudo
            .char.weaponanim = ningunarma
            .char.cascoanim = ninguncasco
        else
            .char.body = ifragatafantasmal
        end if
        
        for i = 1 to maxmascotas
            if .mascotasindex(i) > 0 then
                call muerenpc(.mascotasindex(i), 0)
            ' si estan en agua o zona segura
            else
                .mascotastype(i) = 0
            end if
        next i
        
        .nromascotas = 0
        
        '<< actualizamos clientes >>
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, ningunescudo, ninguncasco)
        call writeupdateuserstats(userindex)
        
        '<<castigos por party>>
        if .partyindex > 0 then
            call mdparty.obtenerexito(userindex, .stats.elv * -10 * mdparty.cantmiembros(userindex), .pos.map, .pos.x, .pos.y)
        end if
        
        '<<cerramos comercio seguro>>
        call limpiarcomercioseguro(userindex)
    end with
exit sub

errorhandler:
    call logerror("error en sub userdie. error: " & err.number & " descripci�n: " & err.description)
end sub

sub contarmuerte(byval muerto as integer, byval atacante as integer)

    if esnewbie(muerto) then exit sub
    
    with userlist(atacante)
        if triggerzonapelea(muerto, atacante) = trigger6_permite then exit sub
        
        if criminal(muerto) then
            if .flags.lastcrimmatado <> userlist(muerto).name then
                .flags.lastcrimmatado = userlist(muerto).name
                if .faccion.criminalesmatados < maxusermatados then _
                    .faccion.criminalesmatados = .faccion.criminalesmatados + 1
            end if
            
            if .faccion.recibioexpinicialcaos = 1 and userlist(muerto).faccion.fuerzascaos = 1 then
                .faccion.reenlistadas = 200  'jaja que trucho
                
                'con esto evitamos que se vuelva a reenlistar
            end if
        else
            if .flags.lastciudmatado <> userlist(muerto).name then
                .flags.lastciudmatado = userlist(muerto).name
                if .faccion.ciudadanosmatados < maxusermatados then _
                    .faccion.ciudadanosmatados = .faccion.ciudadanosmatados + 1
            end if
        end if
        
        if .stats.usuariosmatados < maxusermatados then _
            .stats.usuariosmatados = .stats.usuariosmatados + 1
    end with
end sub

sub tilelibre(byref pos as worldpos, byref npos as worldpos, byref obj as obj, byref agua as boolean, byref tierra as boolean)
'**************************************************************
'author: unknown
'last modify date: 23/01/2007
'23/01/2007 -> pablo (toxicwaste): el agua es ahora un tilelibre agregando las condiciones necesarias.
'**************************************************************
    dim loopc as integer
    dim tx as long
    dim ty as long
    dim hayobj as boolean
    
    hayobj = false
    npos.map = pos.map
    npos.x = 0
    npos.y = 0
    
    do while not legalpos(pos.map, npos.x, npos.y, agua, tierra) or hayobj
        
        if loopc > 15 then
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
                        
                        'break both fors
                        tx = pos.x + loopc
                        ty = pos.y + loopc
                    end if
                end if
            
            next tx
        next ty
        
        loopc = loopc + 1
    loop
end sub

sub warpuserchar(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer, byval fx as boolean)
'**************************************************************
'author: unknown
'last modify date: 15/07/2009
'15/07/2009 - zama: automatic toogle navigate after warping to water.
'**************************************************************
    dim oldmap as integer
    dim oldx as integer
    dim oldy as integer
    
    with userlist(userindex)
        'quitar el dialogo
        call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(.char.charindex))
        
        call writeremovealldialogs(userindex)
        
        oldmap = .pos.map
        oldx = .pos.x
        oldy = .pos.y

        call eraseuserchar(userindex, .flags.admininvisible = 1)
        
        if oldmap <> map then
            call writechangemap(userindex, map, mapinfo(.pos.map).mapversion)
            call writeplaymidi(userindex, val(readfield(1, mapinfo(map).music, 45)))
            
            'update new map users
            mapinfo(map).numusers = mapinfo(map).numusers + 1
            
            'update old map users
            mapinfo(oldmap).numusers = mapinfo(oldmap).numusers - 1
            if mapinfo(oldmap).numusers < 0 then
                mapinfo(oldmap).numusers = 0
            end if
        end if
        
        .pos.x = x
        .pos.y = y
        .pos.map = map
        
        call makeuserchar(true, map, userindex, map, x, y)
        call writeusercharindexinserver(userindex)
        
        'force a flush, so user index is in there before it's destroyed for teleporting
        call flushbuffer(userindex)
        
        'seguis invisible al pasar de mapa
        if (.flags.invisible = 1 or .flags.oculto = 1) and (not .flags.admininvisible = 1) then
            call setinvisible(userindex, .char.charindex, true)
            'call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(.char.charindex, true))
        end if
        
        if fx and .flags.admininvisible = 0 then 'fx
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_warp, x, y))
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, fxids.fxwarp, 0))
        end if
        
        if .nromascotas then call warpmascotas(userindex)
        
        
        ' automatic toogle navigate
        if (.flags.privilegios and (playertype.user or playertype.consejero)) = 0 then
            if hayagua(.pos.map, .pos.x, .pos.y) then
                if .flags.navegando = 0 then
                    .flags.navegando = 1
                        
                    'tell the client that we are navigating.
                    call writenavigatetoggle(userindex)
                end if
            else
                if .flags.navegando = 1 then
                    .flags.navegando = 0
                            
                    'tell the client that we are navigating.
                    call writenavigatetoggle(userindex)
                end if
            end if
        end if
      
    end with
end sub

private sub warpmascotas(byval userindex as integer)
'************************************************
'author: uknown
'last modified: 11/05/2009
'13/02/2009: zama - arreglado respawn de mascotas al cambiar de mapa.
'13/02/2009: zama - las mascotas no regeneran su vida al cambiar de mapa (solo entre mapas inseguros).
'11/05/2009: zama - chequeo si la mascota pueden spwnear para asiganrle los stats.
'************************************************
    dim i as integer
    dim pettype as integer
    dim petrespawn as boolean
    dim pettiempodevida as integer
    dim nropets as integer
    dim invocadosmatados as integer
    dim canwarp as boolean
    dim index as integer
    dim iminhp as integer
    
    nropets = userlist(userindex).nromascotas
    canwarp = (mapinfo(userlist(userindex).pos.map).pk = true)
    
    for i = 1 to maxmascotas
        index = userlist(userindex).mascotasindex(i)
        
        if index > 0 then
            ' si la mascota tiene tiempo de vida > 0 significa q fue invocada => we kill it
            if npclist(index).contadores.tiempoexistencia > 0 then
                call quitarnpc(index)
                userlist(userindex).mascotasindex(i) = 0
                invocadosmatados = invocadosmatados + 1
                nropets = nropets - 1
                
                pettype = 0
            else
                'store data and remove npc to recreate it after warp
                'petrespawn = npclist(index).flags.respawn = 0
                pettype = userlist(userindex).mascotastype(i)
                'pettiempodevida = npclist(index).contadores.tiempoexistencia
                
                ' guardamos el hp, para restaurarlo uando se cree el npc
                iminhp = npclist(index).stats.minhp
                
                call quitarnpc(index)
                
                ' restauramos el valor de la variable
                userlist(userindex).mascotastype(i) = pettype

            end if
        elseif userlist(userindex).mascotastype(i) > 0 then
            'store data and remove npc to recreate it after warp
            petrespawn = true
            pettype = userlist(userindex).mascotastype(i)
            pettiempodevida = 0
        else
            pettype = 0
        end if
        
        if pettype > 0 and canwarp then
            index = spawnnpc(pettype, userlist(userindex).pos, false, petrespawn)
            
            'controlamos que se sumoneo ok - should never happen. continue to allow removal of other pets if not alone
            ' exception: pets don't spawn in water if they can't swim
            if index = 0 then
                call writeconsolemsg(userindex, "tus mascotas no pueden transitar este mapa.", fonttypenames.fonttype_info)
            else
                userlist(userindex).mascotasindex(i) = index

                ' nos aseguramos de que conserve el hp, si estaba da�ado
                npclist(index).stats.minhp = iif(iminhp = 0, npclist(index).stats.minhp, iminhp)
            
                npclist(index).maestrouser = userindex
                npclist(index).movement = tipoai.sigueamo
                npclist(index).target = 0
                npclist(index).targetnpc = 0
                npclist(index).contadores.tiempoexistencia = pettiempodevida
                call followamo(index)
            end if
        end if
    next i
    
    if invocadosmatados > 0 then
        call writeconsolemsg(userindex, "pierdes el control de tus mascotas invocadas.", fonttypenames.fonttype_info)
    end if
    
    if not canwarp then
        call writeconsolemsg(userindex, "no se permiten mascotas en zona segura. �stas te esperar�n afuera.", fonttypenames.fonttype_info)
    end if
    
    userlist(userindex).nromascotas = nropets
end sub

''
' se inicia la salida de un usuario.
'
' @param    userindex   el index del usuario que va a salir

sub cerrar_usuario(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 09/04/08 (niconz)
'
'***************************************************
    dim isnotvisible as boolean
    
    if userlist(userindex).flags.userlogged and not userlist(userindex).counters.saliendo then
        userlist(userindex).counters.saliendo = true
        userlist(userindex).counters.salir = iif((userlist(userindex).flags.privilegios and playertype.user) and mapinfo(userlist(userindex).pos.map).pk, intervalocerrarconexion, 0)
        
        isnotvisible = (userlist(userindex).flags.oculto or userlist(userindex).flags.invisible)
        if isnotvisible then
            userlist(userindex).flags.oculto = 0
            userlist(userindex).flags.invisible = 0
            call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
            call setinvisible(userindex, userlist(userindex).char.charindex, false)
            'call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, false))
        end if
        
        call writeconsolemsg(userindex, "cerrando...se cerrar� el juego en " & userlist(userindex).counters.salir & " segundos...", fonttypenames.fonttype_info)
    end if
end sub

''
' cancels the exit of a user. if it's disconnected it's reset.
'
' @param    userindex   the index of the user whose exit is being reset.

public sub cancelexit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/02/08
'
'***************************************************
    if userlist(userindex).counters.saliendo then
        ' is the user still connected?
        if userlist(userindex).connidvalida then
            userlist(userindex).counters.saliendo = false
            userlist(userindex).counters.salir = 0
            call writeconsolemsg(userindex, "/salir cancelado.", fonttypenames.fonttype_warning)
        else
            'simply reset
            userlist(userindex).counters.salir = iif((userlist(userindex).flags.privilegios and playertype.user) and mapinfo(userlist(userindex).pos.map).pk, intervalocerrarconexion, 0)
        end if
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
    dim charfile as string
    
on error resume next
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
    with userlist(userindex)
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = etrigger.zonapelea then exit sub
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then
            .reputacion.burguesrep = 0
            .reputacion.noblerep = 0
            .reputacion.pleberep = 0
            .reputacion.bandidorep = .reputacion.bandidorep + vlasalto
            if .reputacion.bandidorep > maxrep then .reputacion.bandidorep = maxrep
            if .faccion.armadareal = 1 then call expulsarfaccionreal(userindex)
        end if
    end with
    
    call refreshcharstatus(userindex)
end sub

sub volverciudadano(byval userindex as integer)
'**************************************************************
'author: unknown
'last modify date: 21/06/2006
'nacho: actualiza el tag al cliente.
'**************************************************************
    with userlist(userindex)
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = 6 then exit sub
        
        .reputacion.ladronesrep = 0
        .reputacion.bandidorep = 0
        .reputacion.asesinorep = 0
        .reputacion.pleberep = .reputacion.pleberep + vlasalto
        if .reputacion.pleberep > maxrep then .reputacion.pleberep = maxrep
    end with
    
    call refreshcharstatus(userindex)
end sub

''
'checks if a given body index is a boat or not.
'
'@param body    the body index to bechecked.
'@return    true if the body is a boat, false otherwise.

public function bodyisboat(byval body as integer) as boolean
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 10/07/2008
'checks if a given body index is a boat
'**************************************************************
'todo : this should be checked somehow else. this is nasty....
    if body = ifragatareal or body = ifragatacaos or body = ibarcapk or _
            body = igalerapk or body = igaleonpk or body = ibarcaciuda or _
            body = igaleraciuda or body = igaleonciuda or body = ifragatafantasmal then
        bodyisboat = true
    end if
end function

public sub setinvisible(byval userindex as integer, byval usercharindex as integer, byval invisible as boolean)
dim sndnick as string
dim klan as string
call senddata(sendtarget.tousersareabutgms, userindex, preparemessagesetinvisible(usercharindex, invisible))

if invisible then
    sndnick = userlist(userindex).name & " " & tag_user_invisible
else
    sndnick = userlist(userindex).name
    if userlist(userindex).guildindex > 0 then
        sndnick = sndnick & " <" & modguilds.guildname(userlist(userindex).guildindex) & ">"
    end if
end if

call senddata(sendtarget.togmsarea, userindex, preparemessagecharacterchangenick(usercharindex, sndnick))
end sub
