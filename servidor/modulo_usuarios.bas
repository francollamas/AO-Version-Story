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

public sub actstats(byval victimindex as integer, byval attackerindex as integer)
'***************************************************
'author: unknown
'last modification: 11/03/2010
'11/03/2010: zama - ahora no te vuelve cirminal por matar un atacable
'***************************************************

    dim daexp as integer
    dim eracriminal as boolean
    
    daexp = cint(userlist(victimindex).stats.elv) * 2
    
    with userlist(attackerindex)
        .stats.exp = .stats.exp + daexp
        if .stats.exp > maxexp then .stats.exp = maxexp
        
        if triggerzonapelea(victimindex, attackerindex) <> trigger6_permite then
        
            ' es legal matarlo si estaba en atacable
            if userlist(victimindex).flags.atacablepor <> attackerindex then
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
                
                dim escriminal as boolean
                escriminal = criminal(attackerindex)
                
                if eracriminal <> escriminal then
                    call refreshcharstatus(attackerindex)
                end if
                
            end if
        end if
        
        'lo mata
        call writemultimessage(attackerindex, emessages.havekilleduser, victimindex, daexp)
        call writemultimessage(victimindex, emessages.userkill, attackerindex)
        
        call flushbuffer(victimindex)
        
        'log
        call logasesinato(.name & " asesino a " & userlist(victimindex).name)
    end with
end sub

public sub revivirusuario(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with userlist(userindex)
        .flags.muerto = 0
        .stats.minhp = .stats.useratributos(eatributos.constitucion)
        
        if .stats.minhp > .stats.maxhp then
            .stats.minhp = .stats.maxhp
        end if
        
        if .flags.navegando = 1 then
            call toggleboatbody(userindex)
        else
            call darcuerpodesnudo(userindex)
            
            .char.head = .origchar.head
        end if
        
        if .flags.traveling then
            .flags.traveling = 0
            .counters.gohome = 0
            call writemultimessage(userindex, emessages.cancelhome)
        end if
        
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        call writeupdateuserstats(userindex)
    end with
end sub

public sub toggleboatbody(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 25/07/2010
'gives boat body depending on user alignment.
'25/07/2010: zama - now makes difference depending on faccion and atacable status.
'***************************************************

    dim ropaje as integer
    dim esfaccionario as boolean
    dim newbody as integer
    
    with userlist(userindex)
 
        .char.head = 0
        if .invent.barcoobjindex = 0 then exit sub
        
        ropaje = objdata(.invent.barcoobjindex).ropaje
        
        ' criminales y caos
        if criminal(userindex) then
            
            esfaccionario = escaos(userindex)
            
            select case ropaje
                case ibarca
                    if esfaccionario then
                        newbody = ibarcacaos
                    else
                        newbody = ibarcapk
                    end if
                
                case igalera
                    if esfaccionario then
                        newbody = igaleracaos
                    else
                        newbody = igalerapk
                    end if
                    
                case igaleon
                    if esfaccionario then
                        newbody = igaleoncaos
                    else
                        newbody = igaleonpk
                    end if
            end select
        
        ' ciudas y armadas
        else
            
            esfaccionario = esarmada(userindex)
            
            ' atacable
            if .flags.atacablepor <> 0 then
                
                select case ropaje
                    case ibarca
                        if esfaccionario then
                            newbody = ibarcarealatacable
                        else
                            newbody = ibarcaciudaatacable
                        end if
                    
                    case igalera
                        if esfaccionario then
                            newbody = igalerarealatacable
                        else
                            newbody = igaleraciudaatacable
                        end if
                        
                    case igaleon
                        if esfaccionario then
                            newbody = igaleonrealatacable
                        else
                            newbody = igaleonciudaatacable
                        end if
                end select
            
            ' normal
            else
            
                select case ropaje
                    case ibarca
                        if esfaccionario then
                            newbody = ibarcareal
                        else
                            newbody = ibarcaciuda
                        end if
                    
                    case igalera
                        if esfaccionario then
                            newbody = igalerareal
                        else
                            newbody = igaleraciuda
                        end if
                        
                    case igaleon
                        if esfaccionario then
                            newbody = igaleonreal
                        else
                            newbody = igaleonciuda
                        end if
                end select
            
            end if
            
        end if
        
        .char.body = newbody
        .char.shieldanim = ningunescudo
        .char.weaponanim = ningunarma
        .char.cascoanim = ninguncasco
    end with

end sub

public sub changeuserchar(byval userindex as integer, byval body as integer, byval head as integer, byval heading as byte, _
                    byval arma as integer, byval escudo as integer, byval casco as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
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

public function getweaponanim(byval userindex as integer, byval objindex as integer) as integer
'***************************************************
'author: torres patricio (pato)
'last modification: 03/29/10
'
'***************************************************
    dim tmp as integer

    with userlist(userindex)
        tmp = objdata(objindex).weaponrazaenanaanim
            
        if tmp > 0 then
            if .raza = eraza.enano or .raza = eraza.gnomo then
                getweaponanim = tmp
                exit function
            end if
        end if
        
        getweaponanim = objdata(objindex).weaponanim
    end with
end function

public sub enviarfama(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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

public sub eraseuserchar(byval userindex as integer, byval isadmininvisible as boolean)
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
    
    dim username as string
    dim charindex as integer
    
    if userindex > 0 then
        username = userlist(userindex).name
        charindex = userlist(userindex).char.charindex
    end if

    call logerror("error en eraseuserchar " & err.number & ": " & err.description & _
                  ". user: " & username & "(ui: " & userindex & " - ci: " & charindex & ")")
end sub

public sub refreshcharstatus(byval userindex as integer)
'*************************************************
'author: tararira
'last modified: 04/07/2009
'refreshes the status and tag of userindex.
'04/07/2009: zama - ahora mantenes la fragata fantasmal si estas muerto.
'*************************************************
    dim clantag as string
    dim nickcolor as byte
    
    with userlist(userindex)
        if .guildindex > 0 then
            clantag = modguilds.guildname(.guildindex)
            clantag = " <" & clantag & ">"
        end if
        
        nickcolor = getnickcolor(userindex)
        
        if .showname then
            call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, nickcolor, .name & clantag))
        else
            call senddata(sendtarget.topcarea, userindex, preparemessageupdatetagandstatus(userindex, nickcolor, vbnullstring))
        end if
        
        'si esta navengando, se cambia la barca.
        if .flags.navegando then
            if .flags.muerto = 1 then
                .char.body = ifragatafantasmal
            else
                call toggleboatbody(userindex)
            end if
            
            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        end if
    end with
end sub

public function getnickcolor(byval userindex as integer) as byte
'*************************************************
'author: zama
'last modified: 15/01/2010
'
'*************************************************
    
    with userlist(userindex)
        
        if criminal(userindex) then
            getnickcolor = enickcolor.iecriminal
        else
            getnickcolor = enickcolor.ieciudadano
        end if
        
        if .flags.atacablepor > 0 then getnickcolor = getnickcolor or enickcolor.ieatacable
    end with
    
end function

public sub makeuserchar(byval tomap as boolean, byval sndindex as integer, byval userindex as integer, _
        byval map as integer, byval x as integer, byval y as integer, optional butindex as boolean = false)
'*************************************************
'author: unknown
'last modified: 15/01/2010
'23/07/2009: budi - ahora se env�a el nick
'15/01/2010: zama - ahora se envia el color del nick.
'*************************************************

on error goto errhandler

    dim charindex as integer
    dim clantag as string
    dim nickcolor as byte
    dim username as string
    dim privileges as byte
    
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
            if not tomap then
                if .guildindex > 0 then
                    clantag = modguilds.guildname(.guildindex)
                end if
                
                nickcolor = getnickcolor(userindex)
                privileges = .flags.privilegios
                
                'preparo el nick
                if .showname then
                    username = .name
                    
                    if .flags.enconsulta then
                        username = username & " " & tag_consult_mode
                    else
                        if userlist(sndindex).flags.privilegios and (playertype.user or playertype.consejero or playertype.rolemaster) then
                            if lenb(clantag) <> 0 then _
                                username = username & " <" & clantag & ">"
                        else
                            if (.flags.invisible or .flags.oculto) and (not .flags.admininvisible = 1) then
                                username = username & " " & tag_user_invisible
                            else
                                if lenb(clantag) <> 0 then _
                                    username = username & " <" & clantag & ">"
                            end if
                        end if
                    end if
                end if
            
                call writecharactercreate(sndindex, .char.body, .char.head, .char.heading, _
                            .char.charindex, x, y, _
                            .char.weaponanim, .char.shieldanim, .char.fx, 999, .char.cascoanim, _
                            username, nickcolor, privileges)
            else
                'hide the name and clan - set privs as normal user
                 call agregaruser(userindex, .pos.map, butindex)
            end if
        end if
    end with
exit sub

errhandler:
    logerror ("makeuserchar: num: " & err.number & " desc: " & err.description)
    'resume next
    call closesocket(userindex)
end sub

''
' checks if the user gets the next level.
'
' @param userindex specifies reference to user

public sub checkuserlevel(byval userindex as integer)
'*************************************************
'author: unknown
'last modified: 08/04/2011
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
'11/19/2009 pato - modifico la nueva f�rmula de man� ganada para el bandido y se la limito a 499
'02/04/2010: zama - modifico la ganancia de hit por nivel del ladron.
'08/04/2011: amraphen - arreglada la distribuci�n de probabilidades para la vida en el caso de promedio entero.
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
            elseif .stats.elv < 26 then
                .stats.elu = .stats.elu * 1.3
            elseif .stats.elv < 35 then
                .stats.elu = .stats.elu * 1.2
            elseif .stats.elv < 40 then
                .stats.elu = .stats.elu * 1.3
            else
                .stats.elu = .stats.elu * 1.375
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
                distvida(1) = distribucionenteravida(1)
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
                    aumentohit = 2
                    aumentosta = aumentostladron
                
                case eclass.mage
                    aumentohit = 1
                    aumentomana = 2.8 * .stats.useratributos(eatributos.inteligencia)
                    aumentosta = aumentostmago
                
                case eclass.worker
                    aumentohit = 2
                    aumentosta = aumentosttrabajador
                
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
                    
                case eclass.bandit
                    aumentohit = iif(.stats.elv > 35, 1, 3)
                    aumentomana = .stats.useratributos(eatributos.inteligencia) / 3 * 2
                    aumentosta = aumentostbandido
                
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
                call writeconsolemsg(userindex, "has ganado " & aumentosta & " puntos de energ�a.", fonttypenames.fonttype_info)
            end if
            if aumentomana > 0 then
                call writeconsolemsg(userindex, "has ganado " & aumentomana & " puntos de man�.", fonttypenames.fonttype_info)
            end if
            if aumentohit > 0 then
                call writeconsolemsg(userindex, "tu golpe m�ximo aument� en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
                call writeconsolemsg(userindex, "tu golpe m�nimo aument� en " & aumentohit & " puntos.", fonttypenames.fonttype_info)
            end if
            
            call logdesarrollo(.name & " paso a nivel " & .stats.elv & " gano hp: " & aumentohp)
            
            .stats.minhp = .stats.maxhp

                'if user is in a party, we modify the variable p_sumaniveleselevados
                call mdparty.actualizarsumaniveleselevados(userindex)
                    'if user reaches lvl 25 and he is in a guild, we check the guild's alignment and expulses the user if guild has factionary alignment
        
            if .stats.elv = 25 then
                gi = .guildindex
                if gi > 0 then
                    if modguilds.guildalignment(gi) = "del mal" or modguilds.guildalignment(gi) = "real" then
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
            if mapinfo(.pos.map).restringir = erestrict.restrict_newbie then
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
    dim isadmininvi as boolean
    
    sailing = puedeatravesaragua(userindex)
    npos = userlist(userindex).pos
    call headtopos(nheading, npos)
        
    isadmininvi = (userlist(userindex).flags.admininvisible = 1)
    
    if movetolegalpos(userlist(userindex).pos.map, npos.x, npos.y, sailing, not sailing) then
        'si no estoy solo en el mapa...
        if mapinfo(userlist(userindex).pos.map).numusers > 1 then
               
            casperindex = mapdata(userlist(userindex).pos.map, npos.x, npos.y).userindex
            'si hay un usuario, y paso la validacion, entonces es un casper
            if casperindex > 0 then
                ' los admins invisibles no pueden patear caspers
                if not isadmininvi then
                    
                    if triggerzonapelea(userindex, casperindex) = trigger6_prohibe then
                        if userlist(casperindex).flags.seguroresu = false then
                            userlist(casperindex).flags.seguroresu = true
                            call writemultimessage(casperindex, emessages.resuscitationsafeon)
                        end if
                    end if
    
                    with userlist(casperindex)
                        casperheading = invertheading(nheading)
                        call headtopos(casperheading, .pos)
                    
                        ' si es un admin invisible, no se avisa a los demas clientes
                        if not .flags.admininvisible = 1 then _
                            call senddata(sendtarget.topcareabutindex, casperindex, preparemessagecharactermove(.char.charindex, .pos.x, .pos.y))
                        
                        call writeforcecharmove(casperindex, casperheading)
                            
                        'update map and char
                        .char.heading = casperheading
                        mapdata(.pos.map, .pos.x, .pos.y).userindex = casperindex
                    end with
                
                    'actualizamos las �reas de ser necesario
                    call modareas.checkupdateneededuser(casperindex, casperheading)
                end if
            end if
            
            ' si es un admin invisible, no se avisa a los demas clientes
            if not isadmininvi then _
                call senddata(sendtarget.topcareabutindex, userindex, preparemessagecharactermove(userlist(userindex).char.charindex, npos.x, npos.y))
            
        end if
        
        ' los admins invisibles no pueden patear caspers
        if not (isadmininvi and (casperindex <> 0)) then
            dim olduserindex as integer
            
            with userlist(userindex)
                olduserindex = mapdata(.pos.map, .pos.x, .pos.y).userindex
                
                ' si no hay intercambio de pos con nadie
                if olduserindex = userindex then
                    mapdata(.pos.map, .pos.x, .pos.y).userindex = 0
                end if
                
                .pos = npos
                .char.heading = nheading
                mapdata(.pos.map, .pos.x, .pos.y).userindex = userindex
                
                call dotileevents(userindex, .pos.map, .pos.x, .pos.y)
            end with
            
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    userlist(userindex).invent.object(slot) = object
    call writechangeinventoryslot(userindex, slot)
end sub

function nextopencharindex() as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim loopc as long
    
    for loopc = 1 to maxusers + 1
        if loopc > maxusers then exit for
        if (userlist(loopc).connid = -1 and userlist(loopc).flags.userlogged = false) then exit for
    next loopc
    
    nextopenuser = loopc
end function

public sub senduserstatstxt(byval sendindex as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim guildi as integer
    
    with userlist(userindex)
        call writeconsolemsg(sendindex, "estad�sticas de: " & .name, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "nivel: " & .stats.elv & "  exp: " & .stats.exp & "/" & .stats.elu, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "salud: " & .stats.minhp & "/" & .stats.maxhp & "  man�: " & .stats.minman & "/" & .stats.maxman & "  energ�a: " & .stats.minsta & "/" & .stats.maxsta, fonttypenames.fonttype_info)
        
        if .invent.weaponeqpobjindex > 0 then
            call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & .stats.minhit & "/" & .stats.maxhit & " (" & objdata(.invent.weaponeqpobjindex).minhit & "/" & objdata(.invent.weaponeqpobjindex).maxhit & ")", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & .stats.minhit & "/" & .stats.maxhit, fonttypenames.fonttype_info)
        end if
        
        if .invent.armoureqpobjindex > 0 then
            if .invent.escudoeqpobjindex > 0 then
                call writeconsolemsg(sendindex, "(cuerpo) m�n def/m�x def: " & objdata(.invent.armoureqpobjindex).mindef + objdata(.invent.escudoeqpobjindex).mindef & "/" & objdata(.invent.armoureqpobjindex).maxdef + objdata(.invent.escudoeqpobjindex).maxdef, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(sendindex, "(cuerpo) m�n def/m�x def: " & objdata(.invent.armoureqpobjindex).mindef & "/" & objdata(.invent.armoureqpobjindex).maxdef, fonttypenames.fonttype_info)
            end if
        else
            call writeconsolemsg(sendindex, "(cuerpo) m�n def/m�x def: 0", fonttypenames.fonttype_info)
        end if
        
        if .invent.cascoeqpobjindex > 0 then
            call writeconsolemsg(sendindex, "(cabeza) m�n def/m�x def: " & objdata(.invent.cascoeqpobjindex).mindef & "/" & objdata(.invent.cascoeqpobjindex).maxdef, fonttypenames.fonttype_info)
        else
            call writeconsolemsg(sendindex, "(cabeza) m�n def/m�x def: 0", fonttypenames.fonttype_info)
        end if
        
        guildi = .guildindex
        if guildi > 0 then
            call writeconsolemsg(sendindex, "clan: " & modguilds.guildname(guildi), fonttypenames.fonttype_info)
            if ucase$(modguilds.guildleader(guildi)) = ucase$(.name) then
                call writeconsolemsg(sendindex, "status: l�der", fonttypenames.fonttype_info)
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
        if .flags.traveling = 1 then
            call writeconsolemsg(sendindex, "tiempo restante para llegar a tu hogar: " & gethomearrivaltime(userindex) & " segundos.", fonttypenames.fonttype_info)
        end if
        
        call writeconsolemsg(sendindex, "oro: " & .stats.gld & "  posici�n: " & .pos.x & "," & .pos.y & " en mapa " & .pos.map, fonttypenames.fonttype_info)
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
        call writeconsolemsg(sendindex, "ciudadanos matados: " & .faccion.ciudadanosmatados & " criminales matados: " & .faccion.criminalesmatados & " usuarios matados: " & .stats.usuariosmatados, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "npcs muertos: " & .stats.npcsmuertos, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "clase: " & listaclases(.clase), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "pena: " & .counters.pena, fonttypenames.fonttype_info)
        
        if .faccion.armadareal = 1 then
            call writeconsolemsg(sendindex, "ej�rcito real desde: " & .faccion.fechaingreso, fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & .faccion.nivelingreso & " con " & .faccion.matadosingreso & " ciudadanos matados.", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
        
        elseif .faccion.fuerzascaos = 1 then
            call writeconsolemsg(sendindex, "legi�n oscura desde: " & .faccion.fechaingreso, fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & .faccion.nivelingreso, fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
        
        elseif .faccion.recibioexpinicialreal = 1 then
            call writeconsolemsg(sendindex, "fue ej�rcito real", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & .faccion.reenlistadas, fonttypenames.fonttype_info)
        
        elseif .faccion.recibioexpinicialcaos = 1 then
            call writeconsolemsg(sendindex, "fue legi�n oscura", fonttypenames.fonttype_info)
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
        call writeconsolemsg(sendindex, "ciudadanos matados: " & getvar(charfile, "facciones", "ciudmatados") & " criminalesmatados: " & getvar(charfile, "facciones", "crimmatados") & " usuarios matados: " & getvar(charfile, "muertes", "usermuertes"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "npcs muertos: " & getvar(charfile, "muertes", "npcsmuertes"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "clase: " & listaclases(getvar(charfile, "init", "clase")), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "pena: " & getvar(charfile, "counters", "pena"), fonttypenames.fonttype_info)
        
        if cbyte(getvar(charfile, "facciones", "ejercitoreal")) = 1 then
            call writeconsolemsg(sendindex, "ej�rcito real desde: " & getvar(charfile, "facciones", "fechaingreso"), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & cint(getvar(charfile, "facciones", "nivelingreso")) & " con " & cint(getvar(charfile, "facciones", "matadosingreso")) & " ciudadanos matados.", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        
        elseif cbyte(getvar(charfile, "facciones", "ejercitocaos")) = 1 then
            call writeconsolemsg(sendindex, "legi�n oscura desde: " & getvar(charfile, "facciones", "fechaingreso"), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "ingres� en nivel: " & cint(getvar(charfile, "facciones", "nivelingreso")), fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        
        elseif cbyte(getvar(charfile, "facciones", "rexreal")) = 1 then
            call writeconsolemsg(sendindex, "fue ej�rcito real", fonttypenames.fonttype_info)
            call writeconsolemsg(sendindex, "veces que ingres�: " & cbyte(getvar(charfile, "facciones", "reenlistadas")), fonttypenames.fonttype_info)
        
        elseif cbyte(getvar(charfile, "facciones", "rexcaos")) = 1 then
            call writeconsolemsg(sendindex, "fue legi�n oscura", fonttypenames.fonttype_info)
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

    dim j as long
    
    with userlist(userindex)
        call writeconsolemsg(sendindex, .name, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "tiene " & .invent.nroitems & " objetos.", fonttypenames.fonttype_info)
        
        for j = 1 to .currentinventoryslots
            if .invent.object(j).objindex > 0 then
                call writeconsolemsg(sendindex, "objeto " & j & " " & objdata(.invent.object(j).objindex).name & " cantidad:" & .invent.object(j).amount, fonttypenames.fonttype_info)
            end if
        next j
    end with
end sub

sub senduserinvtxtfromchar(byval sendindex as integer, byval charname as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

    dim j as long
    dim charfile as string, tmp as string
    dim objind as long, objcant as long
    
    charfile = charpath & charname & ".chr"
    
    if fileexist(charfile, vbnormal) then
        call writeconsolemsg(sendindex, charname, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "tiene " & getvar(charfile, "inventory", "cantidaditems") & " objetos.", fonttypenames.fonttype_info)
        
        for j = 1 to max_inventory_slots
            tmp = getvar(charfile, "inventory", "obj" & j)
            objind = readfield(1, tmp, asc("-"))
            objcant = readfield(2, tmp, asc("-"))
            if objind > 0 then
                call writeconsolemsg(sendindex, "objeto " & j & " " & objdata(objind).name & " cantidad:" & objcant, fonttypenames.fonttype_info)
            end if
        next j
    else
        call writeconsolemsg(sendindex, "usuario inexistente: " & charname, fonttypenames.fonttype_info)
    end if
end sub

sub senduserskillstxt(byval sendindex as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next
    dim j as integer
    
    call writeconsolemsg(sendindex, userlist(userindex).name, fonttypenames.fonttype_info)
    
    for j = 1 to numskills
        call writeconsolemsg(sendindex, skillsnames(j) & " = " & userlist(userindex).stats.userskills(j), fonttypenames.fonttype_info)
    next j
    
    call writeconsolemsg(sendindex, "skilllibres:" & userlist(userindex).stats.skillpts, fonttypenames.fonttype_info)
end sub

private function esmascotaciudadano(byval npcindex as integer, byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'last modification: 02/04/2010
'24/01/2007 -> pablo (toxicwaste): agrego para que se actualize el tag si corresponde.
'24/07/2007 -> pablo (toxicwaste): guardar primero que ataca npc y el que atacas ahora.
'06/28/2008 -> niconz: los elementales al atacarlos por su amo no se paran m�s al lado de �l sin hacer nada.
'02/04/2010: zama: un ciuda no se vuelve mas criminal al atacar un npc no hostil.
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    
    dim weaponindex as integer
     
    with userlist(userindex)
        
        weaponindex = .invent.weaponeqpobjindex
        
        if weaponindex > 0 then
            if objdata(weaponindex).apu�ala = 1 then
                puedeapu�alar = .stats.userskills(eskill.apu�alar) >= min_apu�alar _
                                or .clase = eclass.assasin
            end if
        end if
        
    end with
    
end function

public function puedeacuchillar(byval userindex as integer) as boolean
'***************************************************
'author: zama
'last modification: 25/01/2010 (zama)
'
'***************************************************
    
    dim weaponindex as integer
    
    with userlist(userindex)
        if .clase = eclass.pirat then
        
            weaponindex = .invent.weaponeqpobjindex
            if weaponindex > 0 then
                puedeacuchillar = (objdata(weaponindex).acuchilla = 1)
            end if
        end if
    end with
    
end function

sub subirskill(byval userindex as integer, byval skill as integer, byval acerto as boolean)
'*************************************************
'author: unknown
'last modified: 11/19/2009
'11/19/2009 pato - implement the new system to train the skills.
'*************************************************
    with userlist(userindex)
        if .flags.hambre = 0 and .flags.sed = 0 then
            if .counters.asignedskills < 10 then
                if not .flags.ultimomensaje = 7 then
                    call writeconsolemsg(userindex, "para poder entrenar un skill debes asignar los 10 skills iniciales.", fonttypenames.fonttype_info)
                    .flags.ultimomensaje = 7
                end if
                
                exit sub
            end if
                
            with .stats
                if .userskills(skill) = maxskillpoints then exit sub
                
                dim lvl as integer
                lvl = .elv
                
                if lvl > ubound(levelskill) then lvl = ubound(levelskill)
                
                if .userskills(skill) >= levelskill(lvl).levelvalue then exit sub
                
                if acerto then
                    .expskills(skill) = .expskills(skill) + exp_acierto_skill
                else
                    .expskills(skill) = .expskills(skill) + exp_fallo_skill
                end if
                
                if .expskills(skill) >= .eluskills(skill) then
                    .userskills(skill) = .userskills(skill) + 1
                    call writeconsolemsg(userindex, "�has mejorado tu skill " & skillsnames(skill) & " en un punto! ahora tienes " & .userskills(skill) & " pts.", fonttypenames.fonttype_info)
                    
                    .exp = .exp + 50
                    if .exp > maxexp then .exp = maxexp
                    
                    call writeconsolemsg(userindex, "�has ganado 50 puntos de experiencia!", fonttypenames.fonttype_fight)
                    
                    call writeupdateexp(userindex)
                    call checkuserlevel(userindex)
                    call checkeluskill(userindex, skill, false)
                end if
            end with
        end if
    end with
end sub

''
' muere un usuario
'
' @param userindex  indice del usuario que muere
'

public sub userdie(byval userindex as integer)
'************************************************
'author: uknown
'last modified: 12/01/2010 (zama)
'04/15/2008: niconz - ahora se resetea el counter del invi
'13/02/2009: zama - ahora se borran las mascotas cuando moris en agua.
'27/05/2009: zama - el seguro de resu no se activa si estas en una arena.
'21/07/2009: marco - al morir se desactiva el comercio seguro.
'16/11/2009: zama - al morir perdes la criatura que te pertenecia.
'27/11/2009: budi - al morir envia los atributos originales.
'12/01/2010: zama - los druidas pierden la inmunidad de ser atacados cuando mueren.
'************************************************
on error goto errorhandler
    dim i as long
    dim an as integer
    
    dim isounddeath as integer
    
    with userlist(userindex)
        'sonido
        if .genero = egenero.mujer then
            if hayagua(.pos.map, .pos.x, .pos.y) then
                isounddeath = e_soundindex.muerte_mujer_agua
            else
                isounddeath = e_soundindex.muerte_mujer
            end if
        else
            if hayagua(.pos.map, .pos.x, .pos.y) then
                isounddeath = e_soundindex.muerte_hombre_agua
            else
                isounddeath = e_soundindex.muerte_hombre
            end if
        end if
        
        call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, isounddeath)
        
        'quitar el dialogo del user muerto
        call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(.char.charindex))
        
        .stats.minhp = 0
        .stats.minsta = 0
        .flags.atacadoporuser = 0
        .flags.envenenado = 0
        .flags.muerto = 1
        
        .counters.trabajando = 0
        
        ' no se activa en arenas
        if triggerzonapelea(userindex, userindex) <> trigger6_permite then
            .flags.seguroresu = true
            call writemultimessage(userindex, emessages.resuscitationsafeon) 'call writeresuscitationsafeon(userindex)
        else
            .flags.seguroresu = false
            call writemultimessage(userindex, emessages.resuscitationsafeoff) 'call writeresuscitationsafeoff(userindex)
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
        
        call perdionpc(userindex, false)
        
        '<<<< atacable >>>>
        if .flags.atacablepor > 0 then
            .flags.atacablepor = 0
            call refreshcharstatus(userindex)
        end if
        
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
            if not esnewbie(userindex) then
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
            ' puede ser atacado por npcs (cuando resucite)
            .flags.ignorado = false
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
        call writeupdatestrenghtanddexterity(userindex)
        '<<castigos por party>>
        if .partyindex > 0 then
            call mdparty.obtenerexito(userindex, .stats.elv * -10 * mdparty.cantmiembros(userindex), .pos.map, .pos.x, .pos.y)
        end if
        
        '<<cerramos comercio seguro>>
        call limpiarcomercioseguro(userindex)
        
        ' hay que teletransportar?
        dim mapa as integer
        mapa = .pos.map
        dim mapatelep as integer
        mapatelep = mapinfo(mapa).ondeathgoto.map
        
        if mapatelep <> 0 then
            call writeconsolemsg(userindex, "���tu estado no te permite permanecer en el mapa!!!", fonttypenames.fonttype_infobold)
            call warpuserchar(userindex, mapatelep, mapinfo(mapa).ondeathgoto.x, _
                mapinfo(mapa).ondeathgoto.y, true, true)
        end if
        
    end with
exit sub

errorhandler:
    call logerror("error en sub userdie. error: " & err.number & " descripci�n: " & err.description)
end sub

public sub contarmuerte(byval muerto as integer, byval atacante as integer)
'***************************************************
'author: unknown
'last modification: 13/07/2010
'13/07/2010: zama - los matados en estado atacable ya no suman frag.
'***************************************************

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

sub tilelibre(byref pos as worldpos, byref npos as worldpos, byref obj as obj, _
              byref puedeagua as boolean, byref puedetierra as boolean)
'**************************************************************
'author: unknown
'last modify date: 18/09/2010
'23/01/2007 -> pablo (toxicwaste): el agua es ahora un tilelibre agregando las condiciones necesarias.
'18/09/2010: zama - aplico optimizacion de busqueda de tile libre en forma de rombo.
'**************************************************************
on error goto errhandler

    dim found as boolean
    dim loopc as integer
    dim tx as long
    dim ty as long
    
    npos = pos
    tx = pos.x
    ty = pos.y
    
    loopc = 1
    
    ' la primera posicion es valida?
    if legalpos(pos.map, npos.x, npos.y, puedeagua, puedetierra, true) then
        
        if not hayobjeto(pos.map, npos.x, npos.y, obj.objindex, obj.amount) then
            found = true
        end if
        
    end if
    
    ' busca en las demas posiciones, en forma de "rombo"
    if not found then
        while (not found) and loopc <= 16
            if rhomblegaltilepos(pos, tx, ty, loopc, obj.objindex, obj.amount, puedeagua, puedetierra) then
                npos.x = tx
                npos.y = ty
                found = true
            end if
        
            loopc = loopc + 1
        wend
        
    end if
    
    if not found then
        npos.x = 0
        npos.y = 0
    end if
    
    exit sub
    
errhandler:
    call logerror("error en tilelibre. error: " & err.number & " - " & err.description)
end sub

sub warpuserchar(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer, _
byval fx as boolean, optional byval teletransported as boolean)
'**************************************************************
'author: unknown
'last modify date: 11/23/2010
'15/07/2009 - zama: automatic toogle navigate after warping to water.
'13/11/2009 - zama: now it's activated the timer which determines if the npc can atacak the user.
'16/09/2010 - zama: no se pierde la visibilidad al cambiar de mapa al estar navegando invisible.
'11/23/2010 - c4b3z0n: ahora si no se permite invi o ocultar en el mapa al que cambias, te lo saca
'**************************************************************
    dim oldmap as integer
    dim oldx as integer
    dim oldy as integer
    
    with userlist(userindex)
        'quitar el dialogo
        call senddata(sendtarget.topcarea, userindex, preparemessageremovechardialog(.char.charindex))
        
        oldmap = .pos.map
        oldx = .pos.x
        oldy = .pos.y

        call eraseuserchar(userindex, .flags.admininvisible = 1)
        
        if oldmap <> map then
            call writechangemap(userindex, map, mapinfo(.pos.map).mapversion)
            
            if .flags.privilegios and playertype.user then 'el chequeo de invi/ocultar solo afecta a usuarios (c4b3z0n)
                dim ahoravisible as boolean 'para enviar el mensaje de invi y hacer visible (c4b3z0n)
                dim wasinvi as boolean
                'chequeo de flags de mapa por invisibilidad (c4b3z0n)
                if mapinfo(map).invisinefecto > 0 and .flags.invisible = 1 then
                    .flags.invisible = 0
                    .counters.invisibilidad = 0
                    ahoravisible = true
                    wasinvi = true 'si era invi, para el string
                end if
                'chequeo de flags de mapa por ocultar (c4b3z0n)
                if mapinfo(map).ocultarsinefecto > 0 and .flags.oculto = 1 then
                    ahoravisible = true
                    .flags.oculto = 0
                    .counters.tiempooculto = 0
                end if
                
                if ahoravisible then 'si no era visible y ahora es, le avisa. (c4b3z0n)
                    call setinvisible(userindex, .char.charindex, false)
                    if wasinvi then 'era invi
                        call writeconsolemsg(userindex, "has vuelto a ser visible ya que no esta permitida la invisibilidad en este mapa.", fonttypenames.fonttype_info)
                    else 'estaba oculto
                        call writeconsolemsg(userindex, "has vuelto a ser visible ya que no esta permitido ocultarse en este mapa.", fonttypenames.fonttype_info)
                    end if
                end if
            end if
            
            call writeplaymidi(userindex, val(readfield(1, mapinfo(map).music, 45)))
            
            'update new map users
            mapinfo(map).numusers = mapinfo(map).numusers + 1
            
            'update old map users
            mapinfo(oldmap).numusers = mapinfo(oldmap).numusers - 1
            if mapinfo(oldmap).numusers < 0 then
                mapinfo(oldmap).numusers = 0
            end if
        
            'si el mapa al que entro no es superficial and en el que estaba tampoco es superficial, entonces
            dim nextmap, previousmap as boolean
            nextmap = iif(distancetocities(map).distancetocity(.hogar) >= 0, true, false)
            previousmap = iif(distancetocities(.pos.map).distancetocity(.hogar) >= 0, true, false)

            if previousmap and nextmap then '138 => 139 (ambos superficiales, no tiene que pasar nada)
                'no pasa nada porque no entro a un dungeon.
            elseif previousmap and not nextmap then '139 => 140 (139 es superficial, 140 no. por lo tanto 139 es el ultimo mapa superficial)
                .flags.lastmap = .pos.map
            elseif not previousmap and nextmap then '140 => 139 (140 es no es superficial, 139 si. por lo tanto, el �ltimo mapa es 0 ya que no esta en un dungeon)
                .flags.lastmap = 0
            elseif not previousmap and not nextmap then '140 => 141 (ninguno es superficial, el ultimo mapa es el mismo de antes)
                .flags.lastmap = .flags.lastmap
            end if
            
            call writeremovealldialogs(userindex)
        end if
        
        .pos.x = x
        .pos.y = y
        .pos.map = map
        
        call makeuserchar(true, map, userindex, map, x, y)
        call writeusercharindexinserver(userindex)
        
        call dotileevents(userindex, map, x, y)
        
        'force a flush, so user index is in there before it's destroyed for teleporting
        call flushbuffer(userindex)
        
        'seguis invisible al pasar de mapa
        if (.flags.invisible = 1 or .flags.oculto = 1) and (not .flags.admininvisible = 1) then
            
            ' no si estas navegando
            if .flags.navegando = 0 then
                call setinvisible(userindex, .char.charindex, true)
            end if
        end if
        
        if teletransported then
            if .flags.traveling = 1 then
                .flags.traveling = 0
                .counters.gohome = 0
                call writemultimessage(userindex, emessages.cancelhome)
            end if
        end if
        
        if fx and .flags.admininvisible = 0 then 'fx
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_warp, x, y))
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, fxids.fxwarp, 0))
        end if
        
        if .nromascotas then call warpmascotas(userindex)
        
        ' no puede ser atacado cuando cambia de mapa, por cierto tiempo
        call intervalopermiteseratacado(userindex, true)
        
        ' perdes el npc al cambiar de mapa
        call perdionpc(userindex, false)
        
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
'last modified: 26/10/2010
'13/02/2009: zama - arreglado respawn de mascotas al cambiar de mapa.
'13/02/2009: zama - las mascotas no regeneran su vida al cambiar de mapa (solo entre mapas inseguros).
'11/05/2009: zama - chequeo si la mascota pueden spwnear para asiganrle los stats.
'26/10/2010: zama - ahora las mascotas rapswnean de forma aleatoria.
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
        
            dim spawnpos as worldpos
        
            spawnpos.map = userlist(userindex).pos.map
            spawnpos.x = userlist(userindex).pos.x + randomnumber(-3, 3)
            spawnpos.y = userlist(userindex).pos.y + randomnumber(-3, 3)
        
            index = spawnnpc(pettype, spawnpos, false, petrespawn)
            
            'controlamos que se sumoneo ok - should never happen. continue to allow removal of other pets if not alone
            ' exception: pets don't spawn in water if they can't swim
            if index = 0 then
                call writeconsolemsg(userindex, "tus mascotas no pueden transitar este mapa.", fonttypenames.fonttype_info)
            else
                userlist(userindex).mascotasindex(i) = index

                ' nos aseguramos de que conserve el hp, si estaba da�ado
                npclist(index).stats.minhp = iif(iminhp = 0, npclist(index).stats.minhp, iminhp)
            
                npclist(index).maestrouser = userindex
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

public sub warpmascota(byval userindex as integer, byval petindex as integer)
'************************************************
'author: zama
'last modified: 18/11/2009
'warps a pet without changing its stats
'************************************************
    dim pettype as integer
    dim npcindex as integer
    dim iminhp as integer
    dim targetpos as worldpos
    
    with userlist(userindex)
        
        targetpos.map = .flags.targetmap
        targetpos.x = .flags.targetx
        targetpos.y = .flags.targety
        
        npcindex = .mascotasindex(petindex)
            
        'store data and remove npc to recreate it after warp
        pettype = .mascotastype(petindex)
        
        ' guardamos el hp, para restaurarlo cuando se cree el npc
        iminhp = npclist(npcindex).stats.minhp
        
        call quitarnpc(npcindex)
        
        ' restauramos el valor de la variable
        .mascotastype(petindex) = pettype
        .nromascotas = .nromascotas + 1
        npcindex = spawnnpc(pettype, targetpos, false, false)
        
        'controlamos que se sumoneo ok - should never happen. continue to allow removal of other pets if not alone
        ' exception: pets don't spawn in water if they can't swim
        if npcindex = 0 then
            call writeconsolemsg(userindex, "tu mascota no pueden transitar este sector del mapa, intenta invocarla en otra parte.", fonttypenames.fonttype_info)
        else
            .mascotasindex(petindex) = npcindex

            with npclist(npcindex)
                ' nos aseguramos de que conserve el hp, si estaba da�ado
                .stats.minhp = iif(iminhp = 0, .stats.minhp, iminhp)
            
                .maestrouser = userindex
                .movement = tipoai.sigueamo
                .target = 0
                .targetnpc = 0
            end with
            
            call followamo(npcindex)
        end if
    end with
end sub


''
' se inicia la salida de un usuario.
'
' @param    userindex   el index del usuario que va a salir

sub cerrar_usuario(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 16/09/2010
'16/09/2010 - zama: cuando se va el invi estando navegando, no se saca el invi (ya esta visible).
'***************************************************
    dim isnotvisible as boolean
    dim hiddenpirat as boolean
    
    with userlist(userindex)
        if .flags.userlogged and not .counters.saliendo then
            .counters.saliendo = true
            .counters.salir = iif((.flags.privilegios and playertype.user) and mapinfo(.pos.map).pk, intervalocerrarconexion, 0)
            
            isnotvisible = (.flags.oculto or .flags.invisible)
            if isnotvisible then
                .flags.invisible = 0
                
                if .flags.oculto then
                    if .flags.navegando = 1 then
                        if .clase = eclass.pirat then
                            ' pierde la apariencia de fragata fantasmal
                            call toggleboatbody(userindex)
                            call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                            call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                                ningunescudo, ninguncasco)
                            hiddenpirat = true
                        end if
                    end if
                end if
                
                .flags.oculto = 0
                
                ' para no repetir mensajes
                if not hiddenpirat then call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
                
                ' si esta navegando ya esta visible
                if .flags.navegando = 0 then
                    call setinvisible(userindex, .char.charindex, false)
                end if
            end if
            
            if .flags.traveling = 1 then
                call writemultimessage(userindex, emessages.cancelhome)
                .flags.traveling = 0
                .counters.gohome = 0
            end if
            
            call writeconsolemsg(userindex, "cerrando...se cerrar� el juego en " & .counters.salir & " segundos...", fonttypenames.fonttype_info)
        end if
    end with
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if fileexist(charpath & nombre & ".chr", vbarchive) = false then
        call writeconsolemsg(sendindex, "pj inexistente", fonttypenames.fonttype_info)
    else
        call writeconsolemsg(sendindex, "estad�sticas de: " & nombre, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "nivel: " & getvar(charpath & nombre & ".chr", "stats", "elv") & "  exp: " & getvar(charpath & nombre & ".chr", "stats", "exp") & "/" & getvar(charpath & nombre & ".chr", "stats", "elu"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "energ�a: " & getvar(charpath & nombre & ".chr", "stats", "minsta") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxsta"), fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "salud: " & getvar(charpath & nombre & ".chr", "stats", "minhp") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxhp") & "  man�: " & getvar(charpath & nombre & ".chr", "stats", "minman") & "/" & getvar(charpath & nombre & ".chr", "stats", "maxman"), fonttypenames.fonttype_info)
        
        call writeconsolemsg(sendindex, "menor golpe/mayor golpe: " & getvar(charpath & nombre & ".chr", "stats", "maxhit"), fonttypenames.fonttype_info)
        
        call writeconsolemsg(sendindex, "oro: " & getvar(charpath & nombre & ".chr", "stats", "gld"), fonttypenames.fonttype_info)
        
#if conuptime then
        dim tempsecs as long
        dim tempstr as string
        tempsecs = getvar(charpath & nombre & ".chr", "init", "uptime")
        tempstr = (tempsecs \ 86400) & " d�as, " & ((tempsecs mod 86400) \ 3600) & " horas, " & ((tempsecs mod 86400) mod 3600) \ 60 & " minutos, " & (((tempsecs mod 86400) mod 3600) mod 60) & " segundos."
        call writeconsolemsg(sendindex, "tiempo logeado: " & tempstr, fonttypenames.fonttype_info)
#end if
    
        call writeconsolemsg(sendindex, "dados: " & getvar(charpath & nombre & ".chr", "atributos", "at1") & ", " & getvar(charpath & nombre & ".chr", "atributos", "at2") & ", " & getvar(charpath & nombre & ".chr", "atributos", "at3") & ", " & getvar(charpath & nombre & ".chr", "atributos", "at4") & ", " & getvar(charpath & nombre & ".chr", "atributos", "at5"), fonttypenames.fonttype_info)
    end if
end sub

sub senduserorotxtfromchar(byval sendindex as integer, byval charname as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim charfile as string
    
on error resume next
    charfile = charpath & charname & ".chr"
    
    if fileexist(charfile, vbnormal) then
        call writeconsolemsg(sendindex, charname, fonttypenames.fonttype_info)
        call writeconsolemsg(sendindex, "tiene " & getvar(charfile, "stats", "banco") & " en el banco.", fonttypenames.fonttype_info)
    else
        call writeconsolemsg(sendindex, "usuario inexistente: " & charname, fonttypenames.fonttype_info)
    end if
end sub

sub volvercriminal(byval userindex as integer)
'**************************************************************
'author: unknown
'last modify date: 21/02/2010
'nacho: actualiza el tag al cliente
'21/02/2010: zama - ahora deja de ser atacable si se hace criminal.
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
            
            if .flags.atacablepor > 0 then .flags.atacablepor = 0

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim sndnick as string

with userlist(userindex)
    call senddata(sendtarget.tousersandrmsandcounselorsareabutgms, userindex, preparemessagesetinvisible(usercharindex, invisible))
    
    sndnick = .name
    
    if invisible then
        sndnick = sndnick & " " & tag_user_invisible
    else
        if .guildindex > 0 then
            sndnick = sndnick & " <" & modguilds.guildname(.guildindex) & ">"
        end if
    end if
    
    call senddata(sendtarget.togmsareabutrmsorcounselors, userindex, preparemessagecharacterchangenick(usercharindex, sndnick))
end with
end sub

public sub setconsulatmode(byval userindex as integer)
'***************************************************
'author: torres patricio (pato)
'last modification: 05/06/10
'
'***************************************************

dim sndnick as string

with userlist(userindex)
    sndnick = .name
    
    if .flags.enconsulta then
        sndnick = sndnick & " " & tag_consult_mode
    else
        if .guildindex > 0 then
            sndnick = sndnick & " <" & modguilds.guildname(.guildindex) & ">"
        end if
    end if
    
    call senddata(sendtarget.topcarea, userindex, preparemessagecharacterchangenick(.char.charindex, sndnick))
end with
end sub

public function isarena(byval userindex as integer) as boolean
'**************************************************************
'author: zama
'last modify date: 10/11/2009
'returns true if the user is in an arena
'**************************************************************
    isarena = (triggerzonapelea(userindex, userindex) = trigger6_permite)
end function

public sub perdionpc(byval userindex as integer, optional byval checkpets as boolean = true)
'**************************************************************
'author: zama
'last modify date: 11/07/2010 (zama)
'the user loses his owned npc
'18/01/2010: zama - las mascotas dejan de atacar al npc que se perdi�.
'11/07/2010: zama - coloco el indice correcto de las mascotas y ahora siguen al amo si existen.
'13/07/2010: zama - ahora solo dejan de atacar las mascotas si estan atacando al npc que pierde su amo.
'**************************************************************

    dim petcounter as long
    dim petindex as integer
    dim npcindex as integer
    
    with userlist(userindex)
        
        npcindex = .flags.ownednpc
        if npcindex > 0 then
            
            if checkpets then
                ' dejan de atacar las mascotas
                if .nromascotas > 0 then
                    for petcounter = 1 to maxmascotas
                    
                        petindex = .mascotasindex(petcounter)
                        
                        if petindex > 0 then
                            ' si esta atacando al npc deja de hacerlo
                            if npclist(petindex).targetnpc = npcindex then
                                call followamo(petindex)
                            end if
                        end if
                        
                    next petcounter
                end if
            end if
            
            ' reset flags
            npclist(npcindex).owner = 0
            .flags.ownednpc = 0

        end if
    end with
end sub

public sub apropionpc(byval userindex as integer, byval npcindex as integer)
'**************************************************************
'author: zama
'last modify date: 27/07/2010 (zama)
'the user owns a new npc
'18/01/2010: zama - el sistema no aplica a zonas seguras.
'19/04/2010: zama - ahora los admins no se pueden apropiar de npcs.
'27/07/2010: zama - el sistema no aplica a mapas seguros.
'**************************************************************

    with userlist(userindex)
        ' los admins no se pueden apropiar de npcs
        if esgm(userindex) then exit sub
        
        dim mapa as integer
        mapa = .pos.map
        
        ' no aplica a triggers seguras
        if mapdata(mapa, .pos.x, .pos.y).trigger = etrigger.zonasegura then exit sub
        
        ' no se aplica a mapas seguros
        if mapinfo(mapa).pk = false then exit sub
        
        ' no aplica a algunos mapas que permiten el robo de npcs
        if mapinfo(mapa).robonpcspermitido = 1 then exit sub
        
        ' pierde el npc anterior
        if .flags.ownednpc > 0 then npclist(.flags.ownednpc).owner = 0
        
        ' si tenia otro due�o, lo perdio aca
        npclist(npcindex).owner = userindex
        .flags.ownednpc = npcindex
    end with
    
    ' inicializo o actualizo el timer de pertenencia
    call intervaloperdionpc(userindex, true)
end sub

public function getdireccion(byval userindex as integer, byval otheruserindex as integer) as string
'**************************************************************
'author: zama
'last modify date: 17/11/2009
'devuelve la direccion hacia donde esta el usuario
'**************************************************************
    dim x as integer
    dim y as integer
    
    x = userlist(userindex).pos.x - userlist(otheruserindex).pos.x
    y = userlist(userindex).pos.y - userlist(otheruserindex).pos.y
    
    if x = 0 and y > 0 then
        getdireccion = "sur"
    elseif x = 0 and y < 0 then
        getdireccion = "norte"
    elseif x > 0 and y = 0 then
        getdireccion = "este"
    elseif x < 0 and y = 0 then
        getdireccion = "oeste"
    elseif x > 0 and y < 0 then
        getdireccion = "noreste"
    elseif x < 0 and y < 0 then
        getdireccion = "noroeste"
    elseif x > 0 and y > 0 then
        getdireccion = "sureste"
    elseif x < 0 and y > 0 then
        getdireccion = "suroeste"
    end if

end function

public function samefaccion(byval userindex as integer, byval otheruserindex as integer) as boolean
'**************************************************************
'author: zama
'last modify date: 17/11/2009
'devuelve true si son de la misma faccion
'**************************************************************
    samefaccion = (escaos(userindex) and escaos(otheruserindex)) or _
                    (esarmada(userindex) and esarmada(otheruserindex))
end function

public function farthestpet(byval userindex as integer) as integer
'**************************************************************
'author: zama
'last modify date: 18/11/2009
'devuelve el indice de la mascota mas lejana.
'**************************************************************
on error goto errhandler
    
    dim petindex as integer
    dim distancia as integer
    dim otradistancia as integer
    
    with userlist(userindex)
        if .nromascotas = 0 then exit function
    
        for petindex = 1 to maxmascotas
            ' solo pos invocar criaturas que exitan!
            if .mascotasindex(petindex) > 0 then
                ' solo aplica a mascota, nada de elementales..
                if npclist(.mascotasindex(petindex)).contadores.tiempoexistencia = 0 then
                    if farthestpet = 0 then
                        ' por si tiene 1 sola mascota
                        farthestpet = petindex
                        distancia = abs(.pos.x - npclist(.mascotasindex(petindex)).pos.x) + _
                                    abs(.pos.y - npclist(.mascotasindex(petindex)).pos.y)
                    else
                        ' la distancia de la proxima mascota
                        otradistancia = abs(.pos.x - npclist(.mascotasindex(petindex)).pos.x) + _
                                        abs(.pos.y - npclist(.mascotasindex(petindex)).pos.y)
                        ' esta mas lejos?
                        if otradistancia > distancia then
                            distancia = otradistancia
                            farthestpet = petindex
                        end if
                    end if
                end if
            end if
        next petindex
    end with

    exit function
    
errhandler:
    call logerror("error en farthestpet")
end function

''
' set the eluskill value at the skill.
'
' @param userindex  specifies reference to user
' @param skill      number of the skill to check
' @param allocation true if the motive of the modification is the allocation, false if the skill increase by training

public sub checkeluskill(byval userindex as integer, byval skill as byte, byval allocation as boolean)
'*************************************************
'author: torres patricio (pato)
'last modified: 11/20/2009
'
'*************************************************

with userlist(userindex).stats
    if .userskills(skill) < maxskillpoints then
        if allocation then
            .expskills(skill) = 0
        else
            .expskills(skill) = .expskills(skill) - .eluskills(skill)
        end if
        
        .eluskills(skill) = elu_skill_inicial * 1.05 ^ .userskills(skill)
    else
        .expskills(skill) = 0
        .eluskills(skill) = 0
    end if
end with

end sub

public function hasenoughitems(byval userindex as integer, byval objindex as integer, byval amount as long) as boolean
'**************************************************************
'author: zama
'last modify date: 25/11/2009
'cheks wether the user has the required amount of items in the inventory or not
'**************************************************************

    dim slot as long
    dim iteminvamount as long
    
    with userlist(userindex)
        for slot = 1 to .currentinventoryslots
            ' si es el item que busco
            if .invent.object(slot).objindex = objindex then
                ' lo sumo a la cantidad total
                iteminvamount = iteminvamount + .invent.object(slot).amount
            end if
        next slot
    end with
    
    hasenoughitems = amount <= iteminvamount
end function

public function totalofferitems(byval objindex as integer, byval userindex as integer) as long
'**************************************************************
'author: zama
'last modify date: 25/11/2009
'cheks the amount of items the user has in offerslots.
'**************************************************************
    dim slot as byte
    
    for slot = 1 to max_offer_slots
            ' si es el item que busco
        if userlist(userindex).comusu.objeto(slot) = objindex then
            ' lo sumo a la cantidad total
            totalofferitems = totalofferitems + userlist(userindex).comusu.cant(slot)
        end if
    next slot

end function

public function getmaxinventoryslots(byval userindex as integer) as byte
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

if userlist(userindex).invent.mochilaeqpobjindex > 0 then
    getmaxinventoryslots = max_normal_inventory_slots + objdata(userlist(userindex).invent.mochilaeqpobjindex).mochilatype * 5 '5=slots por fila, hacer constante
else
    getmaxinventoryslots = max_normal_inventory_slots
end if
end function

public sub gohome(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 01/06/2010
'01/06/2010: zama - ahora usa otro tipo de intervalo (lo saque de tpiquetec)
'***************************************************

    dim distance as long
    dim tiempo as long
    
    with userlist(userindex)
        if .flags.muerto = 1 then
            if .flags.lastmap = 0 then
                distance = distancetocities(.pos.map).distancetocity(.hogar)
            else
                distance = distancetocities(.flags.lastmap).distancetocity(.hogar) + gohome_penalty
            end if
            
            tiempo = (distance + 1) * 30 'seg
            
            call intervalogohome(userindex, tiempo * 1000, true)
                
            call writemultimessage(userindex, emessages.home, distance, tiempo, , mapinfo(ciudades(.hogar).map).name)
        else
            call writeconsolemsg(userindex, "debes estar muerto para poder utilizar este comando.", fonttypenames.fonttype_fight)
        end if
        
    end with
    
end sub

public function toogletoatackable(byval userindex as integer, byval ownerindex as integer, optional byval stealingnpc as boolean = true) as boolean
'***************************************************
'author: zama
'last modification: 15/01/2010
'change to atackable mode.
'***************************************************
    
    dim atacablepor as integer
    
    with userlist(userindex)
        
        if mapinfo(.pos.map).pk = false then
            call writeconsolemsg(userindex, "no puedes robar npcs en zonas seguras.", fonttypenames.fonttype_info)
            exit function
        end if
        
        atacablepor = .flags.atacablepor
            
        if atacablepor > 0 then
            ' intenta robar un npc
            if stealingnpc then
                ' puede atacar el mismo npc que ya estaba robando, pero no una nuevo.
                if atacablepor <> ownerindex then
                    call writeconsolemsg(userindex, "no puedes atacar otra criatura con due�o hasta que haya terminado tu castigo.", fonttypenames.fonttype_info)
                    exit function
                end if
            ' esta atacando a alguien en estado atacable => se renueva el timer de atacable
            else
                ' renovar el timer
                call intervaloestadoatacable(userindex, true)
                toogletoatackable = true
                exit function
            end if
        end if
        
        .flags.atacablepor = ownerindex
    
        ' actualizar clientes
        call refreshcharstatus(userindex)
        
        ' inicializar el timer
        call intervaloestadoatacable(userindex, true)
        
        toogletoatackable = true
        
    end with
    
end function

public sub sethome(byval userindex as integer, byval newhome as eciudad, byval npcindex as integer)
'***************************************************
'author: budi
'last modification: 01/06/2010
'30/04/2010: zama - ahora el npc avisa que se cambio de hogar.
'01/06/2010: zama - ahora te avisa si ya tenes ese hogar.
'***************************************************
    if newhome < eciudad.cullathorpe or newhome > eciudad.clastcity - 1 then exit sub
    
    if userlist(userindex).hogar <> newhome then
        userlist(userindex).hogar = newhome
    
        call writechatoverhead(userindex, "���bienvenido a nuestra humilde comunidad, este es ahora tu nuevo hogar!!!", npclist(npcindex).char.charindex, vbwhite)
    else
        call writechatoverhead(userindex, "���ya eres miembro de nuestra humilde comunidad!!!", npclist(npcindex).char.charindex, vbwhite)
    end if

end sub

public function gethomearrivaltime(byval userindex as integer) as integer
'**************************************************************
'author: zama
'last modify by: zama
'last modify date: 01/06/2010
'calculates the time left to arrive home.
'**************************************************************
    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    with userlist(userindex)
        gethomearrivaltime = (.counters.gohome - tactual) * 0.001
    end with

end function

public sub homearrival(byval userindex as integer)
'**************************************************************
'author: zama
'last modify by: zama
'last modify date: 01/06/2010
'teleports user to its home.
'**************************************************************
    
    dim tx as integer
    dim ty as integer
    dim tmap as integer

    with userlist(userindex)

        'antes de que el pj llegue a la ciudad, lo hacemos dejar de navegar para que no se buguee.
        if .flags.navegando = 1 then
            .char.body = icuerpomuerto
            .char.head = icabezamuerto
            .char.shieldanim = ningunescudo
            .char.weaponanim = ningunarma
            .char.cascoanim = ninguncasco
            
            .flags.navegando = 0
            
            call writenavigatetoggle(userindex)
            'le sacamos el navegando, pero no le mostramos a los dem�s porque va a ser sumoneado hasta ulla.
        end if
        
        tx = ciudades(.hogar).x
        ty = ciudades(.hogar).y
        tmap = ciudades(.hogar).map
        
        call findlegalpos(userindex, tmap, tx, ty)
        call warpuserchar(userindex, tmap, tx, ty, true)
        
        call writemultimessage(userindex, emessages.finishhome)
        
        .flags.traveling = 0
        .counters.gohome = 0
        
    end with
    
end sub
