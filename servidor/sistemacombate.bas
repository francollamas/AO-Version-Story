attribute vb_name = "sistemacombate"

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
'
'dise�o y correcci�n del modulo de combate por
'gerardo saiz, gerardosaiz@yahoo.com
'

'9/01/2008 pablo (toxicwaste) - ahora todos los modificadores de clase se controlan desde balance.dat


option explicit

public const maxdistanciaarco as byte = 18
public const maxdistanciamagia as byte = 18

public function minimoint(byval a as integer, byval b as integer) as integer
    if a > b then
        minimoint = b
    else
        minimoint = a
    end if
end function

public function maximoint(byval a as integer, byval b as integer) as integer
    if a > b then
        maximoint = a
    else
        maximoint = b
    end if
end function

private function poderevasionescudo(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    poderevasionescudo = (userlist(userindex).stats.userskills(eskill.defensa) * modclase(userlist(userindex).clase).escudo) / 2
end function

private function poderevasion(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    dim ltemp as long
    with userlist(userindex)
        ltemp = (.stats.userskills(eskill.tacticas) + _
          .stats.userskills(eskill.tacticas) / 33 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).evasion
       
        poderevasion = (ltemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

private function poderataquearma(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim poderataquetemp as long
    
    with userlist(userindex)
        if .stats.userskills(eskill.armas) < 31 then
            poderataquetemp = .stats.userskills(eskill.armas) * modclase(.clase).ataquearmas
        elseif .stats.userskills(eskill.armas) < 61 then
            poderataquetemp = (.stats.userskills(eskill.armas) + .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        elseif .stats.userskills(eskill.armas) < 91 then
            poderataquetemp = (.stats.userskills(eskill.armas) + 2 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        else
           poderataquetemp = (.stats.userskills(eskill.armas) + 3 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        end if
        
        poderataquearma = (poderataquetemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

private function poderataqueproyectil(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim poderataquetemp as long
    
    with userlist(userindex)
        if .stats.userskills(eskill.proyectiles) < 31 then
            poderataquetemp = .stats.userskills(eskill.proyectiles) * modclase(.clase).ataqueproyectiles
        elseif .stats.userskills(eskill.proyectiles) < 61 then
            poderataquetemp = (.stats.userskills(eskill.proyectiles) + .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataqueproyectiles
        elseif .stats.userskills(eskill.proyectiles) < 91 then
            poderataquetemp = (.stats.userskills(eskill.proyectiles) + 2 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataqueproyectiles
        else
            poderataquetemp = (.stats.userskills(eskill.proyectiles) + 3 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataqueproyectiles
        end if
        
        poderataqueproyectil = (poderataquetemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

private function poderataquewrestling(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim poderataquetemp as long
    
    with userlist(userindex)
        if .stats.userskills(eskill.wrestling) < 31 then
            poderataquetemp = .stats.userskills(eskill.wrestling) * modclase(.clase).ataquewrestling
        elseif .stats.userskills(eskill.wrestling) < 61 then
            poderataquetemp = (.stats.userskills(eskill.wrestling) + .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquewrestling
        elseif .stats.userskills(eskill.wrestling) < 91 then
            poderataquetemp = (.stats.userskills(eskill.wrestling) + 2 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquewrestling
        else
            poderataquetemp = (.stats.userskills(eskill.wrestling) + 3 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquewrestling
        end if
        
        poderataquewrestling = (poderataquetemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

public function userimpactonpc(byval userindex as integer, byval npcindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim poderataque as long
    dim arma as integer
    dim skill as eskill
    dim probexito as long
    
    arma = userlist(userindex).invent.weaponeqpobjindex
    
    if arma > 0 then 'usando un arma
        if objdata(arma).proyectil = 1 then
            poderataque = poderataqueproyectil(userindex)
            skill = eskill.proyectiles
        else
            poderataque = poderataquearma(userindex)
            skill = eskill.armas
        end if
    else 'peleando con pu�os
        poderataque = poderataquewrestling(userindex)
        skill = eskill.wrestling
    end if
    
    ' chances are rounded
    probexito = maximoint(10, minimoint(90, 50 + ((poderataque - npclist(npcindex).poderevasion) * 0.4)))
    
    userimpactonpc = (randomnumber(1, 100) <= probexito)
    
    if userimpactonpc then
        call subirskill(userindex, skill, true)
    else
        call subirskill(userindex, skill, false)
    end if
end function

public function npcimpacto(byval npcindex as integer, byval userindex as integer) as boolean
'*************************************************
'author: unknown
'last modified: 03/15/2006
'revisa si un npc logra impactar a un user o no
'03/15/2006 maraxus - evit� una divisi�n por cero que eliminaba npcs
'*************************************************
    dim rechazo as boolean
    dim probrechazo as long
    dim probexito as long
    dim userevasion as long
    dim npcpoderataque as long
    dim poderevasioescudo as long
    dim skilltacticas as long
    dim skilldefensa as long
    
    userevasion = poderevasion(userindex)
    npcpoderataque = npclist(npcindex).poderataque
    poderevasioescudo = poderevasionescudo(userindex)
    
    skilltacticas = userlist(userindex).stats.userskills(eskill.tacticas)
    skilldefensa = userlist(userindex).stats.userskills(eskill.defensa)
    
    'esta usando un escudo ???
    if userlist(userindex).invent.escudoeqpobjindex > 0 then userevasion = userevasion + poderevasioescudo
    
    ' chances are rounded
    probexito = maximoint(10, minimoint(90, 50 + ((npcpoderataque - userevasion) * 0.4)))
    
    npcimpacto = (randomnumber(1, 100) <= probexito)
    
    ' el usuario esta usando un escudo ???
    if userlist(userindex).invent.escudoeqpobjindex > 0 then
        if not npcimpacto then
            if skilldefensa + skilltacticas > 0 then  'evitamos divisi�n por cero
                ' chances are rounded
                probrechazo = maximoint(10, minimoint(90, 100 * skilldefensa / (skilldefensa + skilltacticas)))
                rechazo = (randomnumber(1, 100) <= probrechazo)
                
                if rechazo then
                    'se rechazo el ataque con el escudo
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_escudo, userlist(userindex).pos.x, userlist(userindex).pos.y))
                    call writemultimessage(userindex, emessages.blockedwithshielduser) 'call writeblockedwithshielduser(userindex)
                    call subirskill(userindex, eskill.defensa, true)
                else
                    call subirskill(userindex, eskill.defensa, false)
                end if
            end if
        end if
    end if
end function

public function calcularda�o(byval userindex as integer, optional byval npcindex as integer = 0) as long
'***************************************************
'author: unknown
'last modification: 01/04/2010 (zama)
'01/04/2010: zama - modifico el da�o de wrestling.
'01/04/2010: zama - agrego bonificadores de wrestling para los guantes.
'***************************************************
    dim da�oarma as long
    dim da�ousuario as long
    dim arma as objdata
    dim modifclase as single
    dim proyectil as objdata
    dim da�omaxarma as long
    dim da�ominarma as long
    dim objindex as integer
    
    ''sacar esto si no queremos q la matadracos mate el dragon si o si
    dim matodragon as boolean
    matodragon = false
    
    with userlist(userindex)
        if .invent.weaponeqpobjindex > 0 then
            arma = objdata(.invent.weaponeqpobjindex)
            
            ' ataca a un npc?
            if npcindex > 0 then
                if arma.proyectil = 1 then
                    modifclase = modclase(.clase).da�oproyectiles
                    da�oarma = randomnumber(arma.minhit, arma.maxhit)
                    da�omaxarma = arma.maxhit
                    
                    if arma.municion = 1 then
                        proyectil = objdata(.invent.municioneqpobjindex)
                        da�oarma = da�oarma + randomnumber(proyectil.minhit, proyectil.maxhit)
                        ' for some reason this isn't done...
                        'da�omaxarma = da�omaxarma + proyectil.maxhit
                    end if
                else
                    modifclase = modclase(.clase).da�oarmas
                    
                    if .invent.weaponeqpobjindex = espadamatadragonesindex then ' usa la mata dragones?
                        if npclist(npcindex).npctype = dragon then 'ataca dragon?
                            da�oarma = randomnumber(arma.minhit, arma.maxhit)
                            da�omaxarma = arma.maxhit
                            matodragon = true ''sacar esto si no queremos q la matadracos mate el dragon si o si
                        else ' sino es dragon da�o es 1
                            da�oarma = 1
                            da�omaxarma = 1
                        end if
                    else
                        da�oarma = randomnumber(arma.minhit, arma.maxhit)
                        da�omaxarma = arma.maxhit
                    end if
                end if
            else ' ataca usuario
                if arma.proyectil = 1 then
                    modifclase = modclase(.clase).da�oproyectiles
                    da�oarma = randomnumber(arma.minhit, arma.maxhit)
                    da�omaxarma = arma.maxhit
                     
                    if arma.municion = 1 then
                        proyectil = objdata(.invent.municioneqpobjindex)
                        da�oarma = da�oarma + randomnumber(proyectil.minhit, proyectil.maxhit)
                        ' for some reason this isn't done...
                        'da�omaxarma = da�omaxarma + proyectil.maxhit
                    end if
                else
                    modifclase = modclase(.clase).da�oarmas
                    
                    if .invent.weaponeqpobjindex = espadamatadragonesindex then
                        modifclase = modclase(.clase).da�oarmas
                        da�oarma = 1 ' si usa la espada matadragones da�o es 1
                        da�omaxarma = 1
                    else
                        da�oarma = randomnumber(arma.minhit, arma.maxhit)
                        da�omaxarma = arma.maxhit
                    end if
                end if
            end if
        else
            modifclase = modclase(.clase).da�owrestling
            
            ' da�o sin guantes
            da�ominarma = 4
            da�omaxarma = 9
            
            ' plus de guantes (en slot de anillo)
            objindex = .invent.anilloeqpobjindex
            if objindex > 0 then
                if objdata(objindex).guante = 1 then
                    da�ominarma = da�ominarma + objdata(objindex).minhit
                    da�omaxarma = da�omaxarma + objdata(objindex).maxhit
                end if
            end if
            
            da�oarma = randomnumber(da�ominarma, da�omaxarma)
            
        end if
        
        da�ousuario = randomnumber(.stats.minhit, .stats.maxhit)
        
        ''sacar esto si no queremos q la matadracos mate el dragon si o si
        if matodragon then
            calcularda�o = npclist(npcindex).stats.minhp + npclist(npcindex).stats.def
        else
            calcularda�o = (3 * da�oarma + ((da�omaxarma / 5) * maximoint(0, .stats.useratributos(eatributos.fuerza) - 15)) + da�ousuario) * modifclase
        end if
    end with
end function

public sub userda�onpc(byval userindex as integer, byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: 07/04/2010 (zama)
'25/01/2010: zama - agrego poder acuchillar npcs.
'07/04/2010: zama - los asesinos apu�alan acorde al da�o base sin descontar la defensa del npc.
'***************************************************

    dim da�o as long
    dim da�obase as long
    
    da�obase = calcularda�o(userindex, npcindex)
    
    'esta navegando? si es asi le sumamos el da�o del barco
    if userlist(userindex).flags.navegando = 1 then
        if userlist(userindex).invent.barcoobjindex > 0 then
            da�obase = da�obase + randomnumber(objdata(userlist(userindex).invent.barcoobjindex).minhit, _
                                        objdata(userlist(userindex).invent.barcoobjindex).maxhit)
        end if
    end if
    
    with npclist(npcindex)
        da�o = da�obase - .stats.def
        
        if da�o < 0 then da�o = 0
        
        'call writeuserhitnpc(userindex, da�o)
        call writemultimessage(userindex, emessages.userhitnpc, da�o)
        call calculardarexp(userindex, npcindex, da�o)
        .stats.minhp = .stats.minhp - da�o
        
        if .stats.minhp > 0 then
            'trata de apu�alar por la espalda al enemigo
            if puedeapu�alar(userindex) then
               call doapu�alar(userindex, npcindex, 0, da�obase)
            end if
            
            'trata de dar golpe cr�tico
            call dogolpecritico(userindex, npcindex, 0, da�o)
            
            if puedeacuchillar(userindex) then
                call doacuchillar(userindex, npcindex, 0, da�o)
            end if
        end if
        
        
        if .stats.minhp <= 0 then
            ' si era un dragon perdemos la espada matadragones
            if .npctype = dragon then
                'si tiene equipada la matadracos se la sacamos
                if userlist(userindex).invent.weaponeqpobjindex = espadamatadragonesindex then
                    call quitarobjetos(espadamatadragonesindex, 1, userindex)
                end if
                if .stats.maxhp > 100000 then call logdesarrollo(userlist(userindex).name & " mat� un drag�n")
            end if
            
            ' para que las mascotas no sigan intentando luchar y
            ' comiencen a seguir al amo
            dim j as integer
            for j = 1 to maxmascotas
                if userlist(userindex).mascotasindex(j) > 0 then
                    if npclist(userlist(userindex).mascotasindex(j)).targetnpc = npcindex then
                        npclist(userlist(userindex).mascotasindex(j)).targetnpc = 0
                        npclist(userlist(userindex).mascotasindex(j)).movement = tipoai.sigueamo
                    end if
                end if
            next j
            
            call muerenpc(npcindex, userindex)
        end if
    end with
end sub

public sub npcda�o(byval npcindex as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim da�o as integer
    dim lugar as integer
    dim absorbido as integer
    dim defbarco as integer
    dim obj as objdata
    
    da�o = randomnumber(npclist(npcindex).stats.minhit, npclist(npcindex).stats.maxhit)
    
    with userlist(userindex)
        if .flags.navegando = 1 and .invent.barcoobjindex > 0 then
            obj = objdata(.invent.barcoobjindex)
            defbarco = randomnumber(obj.mindef, obj.maxdef)
        end if
        
        lugar = randomnumber(partescuerpo.bcabeza, partescuerpo.btorso)
        
        select case lugar
            case partescuerpo.bcabeza
                'si tiene casco absorbe el golpe
                if .invent.cascoeqpobjindex > 0 then
                   obj = objdata(.invent.cascoeqpobjindex)
                   absorbido = randomnumber(obj.mindef, obj.maxdef)
                end if
          case else
                'si tiene armadura absorbe el golpe
                if .invent.armoureqpobjindex > 0 then
                    dim obj2 as objdata
                    obj = objdata(.invent.armoureqpobjindex)
                    if .invent.escudoeqpobjindex then
                        obj2 = objdata(.invent.escudoeqpobjindex)
                        absorbido = randomnumber(obj.mindef + obj2.mindef, obj.maxdef + obj2.maxdef)
                    else
                        absorbido = randomnumber(obj.mindef, obj.maxdef)
                   end if
                end if
        end select
        
        absorbido = absorbido + defbarco
        da�o = da�o - absorbido
        if da�o < 1 then da�o = 1
        
        call writemultimessage(userindex, emessages.npchituser, lugar, da�o)
        'call writenpchituser(userindex, lugar, da�o)
        
        if .flags.privilegios and playertype.user then .stats.minhp = .stats.minhp - da�o
        
        if .flags.meditando then
            if da�o > fix(.stats.minhp / 100 * .stats.useratributos(eatributos.inteligencia) * .stats.userskills(eskill.meditar) / 100 * 12 / (randomnumber(0, 5) + 7)) then
                .flags.meditando = false
                call writemeditatetoggle(userindex)
                call writeconsolemsg(userindex, "dejas de meditar.", fonttypenames.fonttype_info)
                .char.fx = 0
                .char.loops = 0
                call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, 0, 0))
            end if
        end if
        
        'muere el usuario
        if .stats.minhp <= 0 then
            call writemultimessage(userindex, emessages.npckilluser) 'call writenpckilluser(userindex) ' le informamos que ha muerto ;)
            
            'si lo mato un guardia
            if criminal(userindex) and npclist(npcindex).npctype = enpctype.guardiareal then
                call restarcriminalidad(userindex)
                if not criminal(userindex) and .faccion.fuerzascaos = 1 then call expulsarfaccioncaos(userindex)
            end if
            
            if npclist(npcindex).maestrouser > 0 then
                call allfollowamo(npclist(npcindex).maestrouser)
            else
                'al matarlo no lo sigue mas
                if npclist(npcindex).stats.alineacion = 0 then
                    npclist(npcindex).movement = npclist(npcindex).flags.oldmovement
                    npclist(npcindex).hostile = npclist(npcindex).flags.oldhostil
                    npclist(npcindex).flags.attackedby = vbnullstring
                end if
            end if
            
            call userdie(userindex)
        end if
    end with
end sub

public sub restarcriminalidad(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim eracriminal as boolean
    eracriminal = criminal(userindex)
    
    with userlist(userindex).reputacion
        if .bandidorep > 0 then
             .bandidorep = .bandidorep - vlasalto
             if .bandidorep < 0 then .bandidorep = 0
        elseif .ladronesrep > 0 then
             .ladronesrep = .ladronesrep - (vlcazador * 10)
             if .ladronesrep < 0 then .ladronesrep = 0
        end if
    end with
    
    if eracriminal and not criminal(userindex) then
        call refreshcharstatus(userindex)
    end if
end sub

public sub checkpets(byval npcindex as integer, byval userindex as integer, optional byval checkelementales as boolean = true)
'***************************************************
'author: unknown
'last modification: 15/04/2010
'15/04/2010: zama - las mascotas no se apropian de npcs.
'***************************************************

    dim j as integer
    
    ' si no tengo mascotas, para que cheaquear lo demas?
    if userlist(userindex).nromascotas = 0 then exit sub
    
    if not puedeatacarnpc(userindex, npcindex, , true) then exit sub
    
    with userlist(userindex)
        for j = 1 to maxmascotas
            if .mascotasindex(j) > 0 then
               if .mascotasindex(j) <> npcindex then
                if checkelementales or (npclist(.mascotasindex(j)).numero <> elementalfuego and npclist(.mascotasindex(j)).numero <> elementaltierra) then
                    
                    if npclist(.mascotasindex(j)).targetnpc = 0 then npclist(.mascotasindex(j)).targetnpc = npcindex
                    npclist(.mascotasindex(j)).movement = tipoai.npcatacanpc
                end if
               end if
            end if
        next j
    end with
end sub

public sub allfollowamo(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim j as integer
    
    for j = 1 to maxmascotas
        if userlist(userindex).mascotasindex(j) > 0 then
            call followamo(userlist(userindex).mascotasindex(j))
        end if
    next j
end sub

public function npcatacauser(byval npcindex as integer, byval userindex as integer) as boolean
'*************************************************
'author: unknown
'last modified: -
'
'*************************************************

    with userlist(userindex)
        if .flags.admininvisible = 1 then exit function
        if (not .flags.privilegios and playertype.user) <> 0 and not .flags.adminperseguible then exit function
    end with
    
    with npclist(npcindex)
        ' el npc puede atacar ???
        if .canattack = 1 then
            npcatacauser = true
            call checkpets(npcindex, userindex, false)
            
            if .target = 0 then .target = userindex
            
            if userlist(userindex).flags.atacadopornpc = 0 and userlist(userindex).flags.atacadoporuser = 0 then
                userlist(userindex).flags.atacadopornpc = npcindex
            end if
        else
            npcatacauser = false
            exit function
        end if
        
        .canattack = 0
        
        if .flags.snd1 > 0 then
            call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(.flags.snd1, .pos.x, .pos.y))
        end if
    end with
    
    if npcimpacto(npcindex, userindex) then
        with userlist(userindex)
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_impacto, .pos.x, .pos.y))
            
            if .flags.meditando = false then
                if .flags.navegando = 0 then
                    call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, fxsangre, 0))
                end if
            end if
            
            call npcda�o(npcindex, userindex)
            call writeupdatehp(userindex)
            
            '�puede envenenar?
            if npclist(npcindex).veneno = 1 then call npcenvenenaruser(userindex)
        end with
        
        call subirskill(userindex, eskill.tacticas, false)
    else
        call writemultimessage(userindex, emessages.npcswing)
        call subirskill(userindex, eskill.tacticas, true)
    end if
    
    'controla el nivel del usuario
    call checkuserlevel(userindex)
end function

private function npcimpactonpc(byval atacante as integer, byval victima as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim poderatt as long
    dim podereva as long
    dim probexito as long
    
    poderatt = npclist(atacante).poderataque
    podereva = npclist(victima).poderevasion
    
    ' chances are rounded
    probexito = maximoint(10, minimoint(90, 50 + (poderatt - podereva) * 0.4))
    npcimpactonpc = (randomnumber(1, 100) <= probexito)
end function

public sub npcda�onpc(byval atacante as integer, byval victima as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim da�o as integer
    
    with npclist(atacante)
        da�o = randomnumber(.stats.minhit, .stats.maxhit)
        npclist(victima).stats.minhp = npclist(victima).stats.minhp - da�o
        
        if npclist(victima).stats.minhp < 1 then
            .movement = .flags.oldmovement
            
            if lenb(.flags.attackedby) <> 0 then
                .hostile = .flags.oldhostil
            end if
            
            if .maestrouser > 0 then
                call followamo(atacante)
            end if
            
            call muerenpc(victima, .maestrouser)
        end if
    end with
end sub

public sub npcatacanpc(byval atacante as integer, byval victima as integer, optional byval cambiarmovimiento as boolean = true)
'*************************************************
'author: unknown
'last modified: 01/03/2009
'01/03/2009: zama - las mascotas no pueden atacar al rey si quedan pretorianos vivos.
'*************************************************
    
    with npclist(atacante)
        
        'es el rey preatoriano?
        if npclist(victima).numero = prking_npc then
            if pretorianosvivos > 0 then
                call writeconsolemsg(.maestrouser, "debes matar al resto del ej�rcito antes de atacar al rey!", fonttypenames.fonttype_fight)
                .targetnpc = 0
                exit sub
            end if
        end if
        
        ' el npc puede atacar ???
        if .canattack = 1 then
            .canattack = 0
            if cambiarmovimiento then
                npclist(victima).targetnpc = atacante
                npclist(victima).movement = tipoai.npcatacanpc
            end if
        else
            exit sub
        end if
        
        if .flags.snd1 > 0 then
            call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(.flags.snd1, .pos.x, .pos.y))
        end if
        
        if npcimpactonpc(atacante, victima) then
            if npclist(victima).flags.snd2 > 0 then
                call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(npclist(victima).flags.snd2, npclist(victima).pos.x, npclist(victima).pos.y))
            else
                call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_impacto2, npclist(victima).pos.x, npclist(victima).pos.y))
            end if
        
            if .maestrouser > 0 then
                call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(snd_impacto, .pos.x, .pos.y))
            else
                call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_impacto, npclist(victima).pos.x, npclist(victima).pos.y))
            end if
            
            call npcda�onpc(atacante, victima)
        else
            if .maestrouser > 0 then
                call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            else
                call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_swing, npclist(victima).pos.x, npclist(victima).pos.y))
            end if
        end if
    end with
end sub

public function usuarioatacanpc(byval userindex as integer, byval npcindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'12/01/2010: zama - los druidas pierden la inmunidad de ser atacados por npcs cuando los atacan.
'14/01/2010: zama - lo transformo en funci�n, para que no se pierdan municiones al atacar targets inv�lidos.
'***************************************************

on error goto errhandler

    if not puedeatacarnpc(userindex, npcindex) then exit function
    
    call npcatacado(npcindex, userindex)
    
    if userimpactonpc(userindex, npcindex) then
        if npclist(npcindex).flags.snd2 > 0 then
            call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(npclist(npcindex).flags.snd2, npclist(npcindex).pos.x, npclist(npcindex).pos.y))
        else
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_impacto2, npclist(npcindex).pos.x, npclist(npcindex).pos.y))
        end if
        
        call userda�onpc(userindex, npcindex)
    else
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing, userlist(userindex).pos.x, userlist(userindex).pos.y))
        call writemultimessage(userindex, emessages.userswing)
    end if
    
    ' revel� su condici�n de usuario al atacar, los npcs lo van a atacar
    userlist(userindex).flags.ignorado = false
    
    usuarioatacanpc = true
    
    exit function
    
errhandler:
    call logerror("error en usuarioatacanpc. error " & err.number & " : " & err.description)
    
end function

public sub usuarioataca(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim index as integer
    dim attackpos as worldpos
    
    'check bow's interval
    if not intervalopermiteusararcos(userindex, false) then exit sub
    
    'check spell-magic interval
    if not intervalopermitemagiagolpe(userindex) then
        'check attack interval
        if not intervalopermiteatacar(userindex) then
            exit sub
        end if
    end if
    
    with userlist(userindex)
        'quitamos stamina
        if .stats.minsta >= 10 then
            call quitarsta(userindex, randomnumber(1, 10))
        else
            if .genero = egenero.hombre then
                call writeconsolemsg(userindex, "est�s muy cansado para luchar.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "est�s muy cansada para luchar.", fonttypenames.fonttype_info)
            end if
            exit sub
        end if
        
        attackpos = .pos
        call headtopos(.char.heading, attackpos)
        
        'exit if not legal
        if attackpos.x < xminmapsize or attackpos.x > xmaxmapsize or attackpos.y <= yminmapsize or attackpos.y > ymaxmapsize then
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            exit sub
        end if
        
        index = mapdata(attackpos.map, attackpos.x, attackpos.y).userindex
        
        'look for user
        if index > 0 then
            call usuarioatacausuario(userindex, index)
            call writeupdateuserstats(userindex)
            call writeupdateuserstats(index)
            exit sub
        end if
        
        index = mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex
        
        'look for npc
        if index > 0 then
            if npclist(index).attackable then
                if npclist(index).maestrouser > 0 and mapinfo(npclist(index).pos.map).pk = false then
                    call writeconsolemsg(userindex, "no puedes atacar mascotas en zona segura.", fonttypenames.fonttype_fight)
                    exit sub
                end if
                
                call usuarioatacanpc(userindex, index)
            else
                call writeconsolemsg(userindex, "no puedes atacar a este npc.", fonttypenames.fonttype_fight)
            end if
            
            call writeupdateuserstats(userindex)
            
            exit sub
        end if
        
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
        call writeupdateuserstats(userindex)
        
        if .counters.trabajando then .counters.trabajando = .counters.trabajando - 1
            
        if .counters.ocultando then .counters.ocultando = .counters.ocultando - 1
    end with
end sub

public function usuarioimpacto(byval atacanteindex as integer, byval victimaindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    dim probrechazo as long
    dim rechazo as boolean
    dim probexito as long
    dim poderataque as long
    dim userpoderevasion as long
    dim userpoderevasionescudo as long
    dim arma as integer
    dim skilltacticas as long
    dim skilldefensa as long
    dim probevadir as long
    dim skill as eskill
    
    skilltacticas = userlist(victimaindex).stats.userskills(eskill.tacticas)
    skilldefensa = userlist(victimaindex).stats.userskills(eskill.defensa)
    
    arma = userlist(atacanteindex).invent.weaponeqpobjindex
    
    'calculamos el poder de evasion...
    userpoderevasion = poderevasion(victimaindex)
    
    if userlist(victimaindex).invent.escudoeqpobjindex > 0 then
       userpoderevasionescudo = poderevasionescudo(victimaindex)
       userpoderevasion = userpoderevasion + userpoderevasionescudo
    else
        userpoderevasionescudo = 0
    end if
    
    'esta usando un arma ???
    if userlist(atacanteindex).invent.weaponeqpobjindex > 0 then
        if objdata(arma).proyectil = 1 then
            poderataque = poderataqueproyectil(atacanteindex)
            skill = eskill.proyectiles
        else
            poderataque = poderataquearma(atacanteindex)
            skill = eskill.armas
        end if
    else
        poderataque = poderataquewrestling(atacanteindex)
        skill = eskill.wrestling
    end if
    
    ' chances are rounded
    probexito = maximoint(10, minimoint(90, 50 + (poderataque - userpoderevasion) * 0.4))
    
    ' se reduce la evasion un 25%
    if userlist(victimaindex).flags.meditando = true then
        probevadir = (100 - probexito) * 0.75
        probexito = minimoint(90, 100 - probevadir)
    end if
    
    usuarioimpacto = (randomnumber(1, 100) <= probexito)
    
    ' el usuario esta usando un escudo ???
    if userlist(victimaindex).invent.escudoeqpobjindex > 0 then
        'fallo ???
        if not usuarioimpacto then
            ' chances are rounded
            probrechazo = maximoint(10, minimoint(90, 100 * skilldefensa / (skilldefensa + skilltacticas)))
            rechazo = (randomnumber(1, 100) <= probrechazo)
            if rechazo then
                'se rechazo el ataque con el escudo
                call senddata(sendtarget.topcarea, victimaindex, preparemessageplaywave(snd_escudo, userlist(victimaindex).pos.x, userlist(victimaindex).pos.y))
                  
                call writemultimessage(atacanteindex, emessages.blockedwithshieldother)
                call writemultimessage(victimaindex, emessages.blockedwithshielduser)
                
                call subirskill(victimaindex, eskill.defensa, true)
            else
                call subirskill(victimaindex, eskill.defensa, false)
            end if
        end if
    end if
    
    if not usuarioimpacto then
        call subirskill(atacanteindex, skill, false)
    end if
    
    call flushbuffer(victimaindex)
    
    exit function
    
errhandler:
    dim atacantenick as string
    dim victimanick as string
    
    if atacanteindex > 0 then atacantenick = userlist(atacanteindex).name
    if victimaindex > 0 then victimanick = userlist(victimaindex).name
    
    call logerror("error en usuarioimpacto. error " & err.number & " : " & err.description & " atacanteindex: " & _
             atacanteindex & " nick: " & atacantenick & " victimaindex: " & victimaindex & " nick: " & victimanick)
end function

public function usuarioatacausuario(byval atacanteindex as integer, byval victimaindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - lo transformo en funci�n, para que no se pierdan municiones al atacar targets
'                    inv�lidos, y evitar un doble chequeo innecesario
'***************************************************

on error goto errhandler

    if not puedeatacar(atacanteindex, victimaindex) then exit function
    
    with userlist(atacanteindex)
        if distancia(.pos, userlist(victimaindex).pos) > maxdistanciaarco then
           call writeconsolemsg(atacanteindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
           exit function
        end if
        
        call usuarioatacadoporusuario(atacanteindex, victimaindex)
        
        if usuarioimpacto(atacanteindex, victimaindex) then
            call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_impacto, .pos.x, .pos.y))
            
            if userlist(victimaindex).flags.navegando = 0 then
                call senddata(sendtarget.topcarea, victimaindex, preparemessagecreatefx(userlist(victimaindex).char.charindex, fxsangre, 0))
            end if
            
            'pablo (toxicwaste): guantes de hurto del bandido en acci�n
            if .clase = eclass.bandit then
                call dodesequipar(atacanteindex, victimaindex)
                
            'y ahora, el ladr�n puede llegar a paralizar con el golpe.
            elseif .clase = eclass.thief then
                call dohandinmo(atacanteindex, victimaindex)
            end if
            
            call subirskill(victimaindex, eskill.tacticas, false)
            call userda�ouser(atacanteindex, victimaindex)
        else
            ' invisible admins doesn't make sound to other clients except itself
            if .flags.admininvisible = 1 then
                call enviardatosaslot(atacanteindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            else
                call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            end if
            
            call writemultimessage(atacanteindex, emessages.userswing)
            call writemultimessage(victimaindex, emessages.userattackedswing, atacanteindex)
            call subirskill(victimaindex, eskill.tacticas, true)
        end if
        
        if .clase = eclass.thief then call desarmar(atacanteindex, victimaindex)
    end with
    
    usuarioatacausuario = true
    
    exit function
    
errhandler:
    call logerror("error en usuarioatacausuario. error " & err.number & " : " & err.description)
end function

public sub userda�ouser(byval atacanteindex as integer, byval victimaindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/2010 (zama)
'12/01/2010: zama - implemento armas arrojadizas y probabilidad de acuchillar
'11/03/2010: zama - ahora no cuenta la muerte si estaba en estado atacable, y no se vuelve criminal
'***************************************************
    
on error goto errhandler

    dim da�o as long
    dim lugar as byte
    dim absorbido as long
    dim defbarco as integer
    dim obj as objdata
    dim resist as byte
    
    da�o = calcularda�o(atacanteindex)
    
    call userenvenena(atacanteindex, victimaindex)
    
    with userlist(atacanteindex)
        if .flags.navegando = 1 and .invent.barcoobjindex > 0 then
             obj = objdata(.invent.barcoobjindex)
             da�o = da�o + randomnumber(obj.minhit, obj.maxhit)
        end if
        
        if userlist(victimaindex).flags.navegando = 1 and userlist(victimaindex).invent.barcoobjindex > 0 then
             obj = objdata(userlist(victimaindex).invent.barcoobjindex)
             defbarco = randomnumber(obj.mindef, obj.maxdef)
        end if
        
        if .invent.weaponeqpobjindex > 0 then
            resist = objdata(.invent.weaponeqpobjindex).refuerzo
        end if
        
        lugar = randomnumber(partescuerpo.bcabeza, partescuerpo.btorso)
        
        select case lugar
            case partescuerpo.bcabeza
                'si tiene casco absorbe el golpe
                if userlist(victimaindex).invent.cascoeqpobjindex > 0 then
                    obj = objdata(userlist(victimaindex).invent.cascoeqpobjindex)
                    absorbido = randomnumber(obj.mindef, obj.maxdef)
                    absorbido = absorbido + defbarco - resist
                    da�o = da�o - absorbido
                    if da�o < 0 then da�o = 1
                end if
            
            case else
                'si tiene armadura absorbe el golpe
                if userlist(victimaindex).invent.armoureqpobjindex > 0 then
                    obj = objdata(userlist(victimaindex).invent.armoureqpobjindex)
                    dim obj2 as objdata
                    if userlist(victimaindex).invent.escudoeqpobjindex then
                        obj2 = objdata(userlist(victimaindex).invent.escudoeqpobjindex)
                        absorbido = randomnumber(obj.mindef + obj2.mindef, obj.maxdef + obj2.maxdef)
                    else
                        absorbido = randomnumber(obj.mindef, obj.maxdef)
                    end if
                    absorbido = absorbido + defbarco - resist
                    da�o = da�o - absorbido
                    if da�o < 0 then da�o = 1
                end if
        end select
        
        call writemultimessage(atacanteindex, emessages.userhitteduser, userlist(victimaindex).char.charindex, lugar, da�o)
        call writemultimessage(victimaindex, emessages.userhittedbyuser, .char.charindex, lugar, da�o)
        
        userlist(victimaindex).stats.minhp = userlist(victimaindex).stats.minhp - da�o
        
        if .flags.hambre = 0 and .flags.sed = 0 then
            'si usa un arma quizas suba "combate con armas"
            if .invent.weaponeqpobjindex > 0 then
                if objdata(.invent.weaponeqpobjindex).proyectil then
                    'es un arco. sube armas a distancia
                    call subirskill(atacanteindex, eskill.proyectiles, true)
                    
                    ' si es arma arrojadiza..
                    if objdata(.invent.weaponeqpobjindex).municion = 0 then
                        ' si acuchilla
                        if objdata(.invent.weaponeqpobjindex).acuchilla = 1 then
                            call doacuchillar(atacanteindex, 0, victimaindex, da�o)
                        end if
                    end if
                else
                    'sube combate con armas.
                    call subirskill(atacanteindex, eskill.armas, true)
                end if
            else
                'sino tal vez lucha libre
                call subirskill(atacanteindex, eskill.wrestling, true)
            end if
                    
            'trata de apu�alar por la espalda al enemigo
            if puedeapu�alar(atacanteindex) then
                call doapu�alar(atacanteindex, 0, victimaindex, da�o)
            end if
            'e intenta dar un golpe cr�tico [pablo (toxicwaste)]
            call dogolpecritico(atacanteindex, 0, victimaindex, da�o)
        end if
        
        if userlist(victimaindex).stats.minhp <= 0 then
            
            ' no cuenta la muerte si estaba en estado atacable
            if userlist(victimaindex).flags.atacablepor <> atacanteindex then
                'store it!
                call statistics.storefrag(atacanteindex, victimaindex)
                
                call contarmuerte(victimaindex, atacanteindex)
            end if
            
            ' para que las mascotas no sigan intentando luchar y
            ' comiencen a seguir al amo
            dim j as integer
            for j = 1 to maxmascotas
                if .mascotasindex(j) > 0 then
                    if npclist(.mascotasindex(j)).target = victimaindex then
                        npclist(.mascotasindex(j)).target = 0
                        call followamo(.mascotasindex(j))
                    end if
                end if
            next j
            
            call actstats(victimaindex, atacanteindex)
            call userdie(victimaindex)
        else
            'est� vivo - actualizamos el hp
            call writeupdatehp(victimaindex)
        end if
    end with
    
    'controla el nivel del usuario
    call checkuserlevel(atacanteindex)
    
    call flushbuffer(victimaindex)
    
    exit sub
    
errhandler:
    dim atacantenick as string
    dim victimanick as string
    
    if atacanteindex > 0 then atacantenick = userlist(atacanteindex).name
    if victimaindex > 0 then victimanick = userlist(victimaindex).name
    
    call logerror("error en userda�ouser. error " & err.number & " : " & err.description & " atacanteindex: " & _
             atacanteindex & " nick: " & atacantenick & " victimaindex: " & victimaindex & " nick: " & victimanick)
end sub

sub usuarioatacadoporusuario(byval attackerindex as integer, byval victimindex as integer)
'***************************************************
'autor: unknown
'last modification: 05/05/2010
'last modified by: lucas tavolaro ortiz (tavo)
'10/01/2008: tavo - se cancela la salida del juego si el user esta saliendo
'05/05/2010: zama - ahora no suma puntos de bandido al atacar a alguien en estado atacable.
'***************************************************

    if triggerzonapelea(attackerindex, victimindex) = trigger6_permite then exit sub
    
    dim eracriminal as boolean
    dim victimaesatacable as boolean
    
    if not criminal(attackerindex) then
        if not criminal(victimindex) then
            ' si la victima no es atacable por el agresor, entonces se hace pk
            victimaesatacable = userlist(victimindex).flags.atacablepor = attackerindex
            if not victimaesatacable then call volvercriminal(attackerindex)
        end if
    end if
    
    with userlist(victimindex)
        if .flags.meditando then
            .flags.meditando = false
            call writemeditatetoggle(victimindex)
            call writeconsolemsg(victimindex, "dejas de meditar.", fonttypenames.fonttype_info)
            .char.fx = 0
            .char.loops = 0
            call senddata(sendtarget.topcarea, victimindex, preparemessagecreatefx(.char.charindex, 0, 0))
        end if
    end with
    
    eracriminal = criminal(attackerindex)
    
    ' si ataco a un atacable, no suma puntos de bandido
    if not victimaesatacable then
        with userlist(attackerindex).reputacion
            if not criminal(victimindex) then
                .bandidorep = .bandidorep + vlasalto
                if .bandidorep > maxrep then .bandidorep = maxrep
                
                .noblerep = .noblerep * 0.5
                if .noblerep < 0 then .noblerep = 0
            else
                .noblerep = .noblerep + vlnoble
                if .noblerep > maxrep then .noblerep = maxrep
            end if
        end with
    end if
    
    if criminal(attackerindex) then
        if userlist(attackerindex).faccion.armadareal = 1 then call expulsarfaccionreal(attackerindex)
        
        if not eracriminal then call refreshcharstatus(attackerindex)
    elseif eracriminal then
        call refreshcharstatus(attackerindex)
    end if
    
    call allmascotasatacanuser(attackerindex, victimindex)
    call allmascotasatacanuser(victimindex, attackerindex)
    
    'si la victima esta saliendo se cancela la salida
    call cancelexit(victimindex)
    call flushbuffer(victimindex)
end sub

sub allmascotasatacanuser(byval victim as integer, byval maestro as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    'reaccion de las mascotas
    dim icount as integer
    
    for icount = 1 to maxmascotas
        if userlist(maestro).mascotasindex(icount) > 0 then
            npclist(userlist(maestro).mascotasindex(icount)).flags.attackedby = userlist(victim).name
            npclist(userlist(maestro).mascotasindex(icount)).movement = tipoai.npcdefensa
            npclist(userlist(maestro).mascotasindex(icount)).hostile = 1
        end if
    next icount
end sub

public function puedeatacar(byval attackerindex as integer, byval victimindex as integer) as boolean
'***************************************************
'autor: unknown
'last modification: 02/04/2010
'returns true if the attackerindex is allowed to attack the victimindex.
'24/01/2007 pablo (toxicwaste) - ordeno todo y agrego situacion de defensa en ciudad armada y caos.
'24/02/2009: zama - los usuarios pueden atacarse entre si.
'02/04/2010: zama - los armadas no pueden atacar nunca a los ciudas, salvo que esten atacables.
'***************************************************
on error goto errhandler

    'muy importante el orden de estos "if"...
    
    'estas muerto no podes atacar
    if userlist(attackerindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "��est�s muerto!!", fonttypenames.fonttype_info)
        puedeatacar = false
        exit function
    end if
    
    'no podes atacar a alguien muerto
    if userlist(victimindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "no puedes atacar a un esp�ritu.", fonttypenames.fonttype_info)
        puedeatacar = false
        exit function
    end if
    
    ' no podes atacar si estas en consulta
    if userlist(attackerindex).flags.enconsulta then
        call writeconsolemsg(attackerindex, "no puedes atacar usuarios mientras estas en consulta.", fonttypenames.fonttype_info)
        exit function
    end if
    
    ' no podes atacar si esta en consulta
    if userlist(victimindex).flags.enconsulta then
        call writeconsolemsg(attackerindex, "no puedes atacar usuarios mientras estan en consulta.", fonttypenames.fonttype_info)
        exit function
    end if

    'estamos en una arena? o un trigger zona segura?
    select case triggerzonapelea(attackerindex, victimindex)
        case etrigger6.trigger6_permite
            puedeatacar = (userlist(victimindex).flags.admininvisible = 0)
            exit function
        
        case etrigger6.trigger6_prohibe
            puedeatacar = false
            exit function
        
        case etrigger6.trigger6_ausente
            'si no estamos en el trigger 6 entonces es imposible atacar un gm
            if (userlist(victimindex).flags.privilegios and playertype.user) = 0 then
                if userlist(victimindex).flags.admininvisible = 0 then call writeconsolemsg(attackerindex, "el ser es demasiado poderoso.", fonttypenames.fonttype_warning)
                puedeatacar = false
                exit function
            end if
    end select
    
    'ataca un ciudadano?
    if not criminal(victimindex) then
        ' el atacante es ciuda?
        if not criminal(attackerindex) then
            ' el atacante es armada?
            if esarmada(attackerindex) then
                ' la victima es armada?
                if esarmada(victimindex) then
                    ' no puede
                    call writeconsolemsg(attackerindex, "los soldados del ej�rcito real tienen prohibido atacar ciudadanos.", fonttypenames.fonttype_warning)
                    exit function
                end if
            end if
            
            ' ciuda (o army) atacando a otro ciuda (o army)
            if userlist(victimindex).flags.atacablepor = attackerindex then
                ' se vuelve atacable.
                if toogletoatackable(attackerindex, victimindex, false) then
                    puedeatacar = true
                    exit function
                end if
            end if
        end if
    ' ataca a un criminal
    else
        'sos un caos atacando otro caos?
        if escaos(victimindex) then
            if escaos(attackerindex) then
                call writeconsolemsg(attackerindex, "los miembros de la legi�n oscura tienen prohibido atacarse entre s�.", fonttypenames.fonttype_warning)
                exit function
            end if
        end if
    end if
    
    'tenes puesto el seguro?
    if userlist(attackerindex).flags.seguro then
        if not criminal(victimindex) then
            call writeconsolemsg(attackerindex, "no puedes atacar ciudadanos, para hacerlo debes desactivar el seguro.", fonttypenames.fonttype_warning)
            puedeatacar = false
            exit function
        end if
    else
        ' un ciuda es atacado
        if not criminal(victimindex) then
            ' por un armada sin seguro
            if esarmada(attackerindex) then
                ' no puede
                call writeconsolemsg(attackerindex, "los soldados del ej�rcito real tienen prohibido atacar ciudadanos.", fonttypenames.fonttype_warning)
                puedeatacar = false
                exit function
            end if
        end if
    end if
    
    'estas en un mapa seguro?
    if mapinfo(userlist(victimindex).pos.map).pk = false then
        if esarmada(attackerindex) then
            if userlist(attackerindex).faccion.recompensasreal > 11 then
                if userlist(victimindex).pos.map = 58 or userlist(victimindex).pos.map = 59 or userlist(victimindex).pos.map = 60 then
                call writeconsolemsg(victimindex, "�huye de la ciudad! est�s siendo atacado y no podr�s defenderte.", fonttypenames.fonttype_warning)
                puedeatacar = true 'beneficio de armadas que atacan en su ciudad.
                exit function
                end if
            end if
        end if
        if escaos(attackerindex) then
            if userlist(attackerindex).faccion.recompensascaos > 11 then
                if userlist(victimindex).pos.map = 151 or userlist(victimindex).pos.map = 156 then
                call writeconsolemsg(victimindex, "�huye de la ciudad! est�s siendo atacado y no podr�s defenderte.", fonttypenames.fonttype_warning)
                puedeatacar = true 'beneficio de caos que atacan en su ciudad.
                exit function
                end if
            end if
        end if
        call writeconsolemsg(attackerindex, "esta es una zona segura, aqu� no puedes atacar a otros usuarios.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    'estas atacando desde un trigger seguro? o tu victima esta en uno asi?
    if mapdata(userlist(victimindex).pos.map, userlist(victimindex).pos.x, userlist(victimindex).pos.y).trigger = etrigger.zonasegura or _
        mapdata(userlist(attackerindex).pos.map, userlist(attackerindex).pos.x, userlist(attackerindex).pos.y).trigger = etrigger.zonasegura then
        call writeconsolemsg(attackerindex, "no puedes pelear aqu�.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    puedeatacar = true
exit function

errhandler:
    call logerror("error en puedeatacar. error " & err.number & " : " & err.description)
end function

public function puedeatacarnpc(byval attackerindex as integer, byval npcindex as integer, _
                optional byval paraliza as boolean = false, optional byval ispet as boolean = false) as boolean
'***************************************************
'autor: unknown author (original version)
'returns true if attackerindex can attack the npcindex
'last modification: 16/11/2009
'24/01/2007 pablo (toxicwaste) - orden y correcci�n de ataque sobre una mascota y guardias
'14/08/2007 pablo (toxicwaste) - reescribo y agrego todos los casos posibles cosa de usar
'esta funci�n para todo lo referente a ataque a un npc. ya sea magia, f�sico o a distancia.
'16/11/2009: zama - agrego validacion de pertenencia de npc.
'02/04/2010: zama - los armadas ya no peuden atacar npcs no hotiles.
'***************************************************
    
    dim owneruserindex as integer
    
    'estas muerto?
    if userlist(attackerindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "��est�s muerto!!", fonttypenames.fonttype_info)
        exit function
    end if
    
    'sos consejero?
    if userlist(attackerindex).flags.privilegios and playertype.consejero then
        'no pueden atacar npc los consejeros.
        exit function
    end if
    
    ' no podes atacar si estas en consulta
    if userlist(attackerindex).flags.enconsulta then
        call writeconsolemsg(attackerindex, "no puedes atacar npcs mientras estas en consulta.", fonttypenames.fonttype_info)
        exit function
    end if
    
    'es una criatura atacable?
    if npclist(npcindex).attackable = 0 then
        call writeconsolemsg(attackerindex, "no puedes atacar esta criatura.", fonttypenames.fonttype_info)
        exit function
    end if
    
    'es valida la distancia a la cual estamos atacando?
    if distancia(userlist(attackerindex).pos, npclist(npcindex).pos) >= maxdistanciaarco then
       call writeconsolemsg(attackerindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
       exit function
    end if
    
    'es una criatura no-hostil?
    if npclist(npcindex).hostile = 0 then
        'es guardia del caos?
        if npclist(npcindex).npctype = enpctype.guardiascaos then
            'lo quiere atacar un caos?
            if escaos(attackerindex) then
                call writeconsolemsg(attackerindex, "no puedes atacar guardias del caos siendo de la legi�n oscura.", fonttypenames.fonttype_info)
                exit function
            end if
        'es guardia real?
        elseif npclist(npcindex).npctype = enpctype.guardiareal then
            'lo quiere atacar un armada?
            if esarmada(attackerindex) then
                call writeconsolemsg(attackerindex, "no puedes atacar guardias reales siendo del ej�rcito real.", fonttypenames.fonttype_info)
                exit function
            end if
            'tienes el seguro puesto?
            if userlist(attackerindex).flags.seguro then
                call writeconsolemsg(attackerindex, "para poder atacar guardias reales debes quitarte el seguro.", fonttypenames.fonttype_info)
                exit function
            else
                call writeconsolemsg(attackerindex, "�atacaste un guardia real! eres un criminal.", fonttypenames.fonttype_info)
                call volvercriminal(attackerindex)
                puedeatacarnpc = true
                exit function
            end if
    
        'no era un guardia, asi que es una criatura no-hostil com�n.
        'para asegurarnos que no sea una mascota:
        elseif npclist(npcindex).maestrouser = 0 then
            'si sos ciudadano tenes que quitar el seguro para atacarla.
            if not criminal(attackerindex) then
                
                ' si sos armada no podes atacarlo directamente
                if esarmada(attackerindex) then
                    call writeconsolemsg(attackerindex, "los miembros del ej�rcito real no pueden atacar npcs no hostiles.", fonttypenames.fonttype_info)
                    exit function
                end if
            
                'sos ciudadano, tenes el seguro puesto?
                if userlist(attackerindex).flags.seguro then
                    call writeconsolemsg(attackerindex, "para atacar a este npc debes quitarte el seguro.", fonttypenames.fonttype_info)
                    exit function
                else
                    'no tiene seguro puesto. puede atacar pero es penalizado.
                    call writeconsolemsg(attackerindex, "atacaste un npc no-hostil. contin�a haci�ndolo y te podr�s convertir en criminal.", fonttypenames.fonttype_info)
                    'niconz: cambio para que al atacar npcs no hostiles no bajen puntos de nobleza
                    call disnobauban(attackerindex, 0, 1000)
                    puedeatacarnpc = true
                    exit function
                end if
            end if
        end if
    end if
    
    'es el npc mascota de alguien?
    if npclist(npcindex).maestrouser > 0 then
        if not criminal(npclist(npcindex).maestrouser) then
        
            'es mascota de un ciudadano.
            if esarmada(attackerindex) then
                'el atacante es armada y esta intentando atacar mascota de un ciudadano
                call writeconsolemsg(attackerindex, "los miembros del ej�rcito real no pueden atacar mascotas de ciudadanos.", fonttypenames.fonttype_info)
                exit function
            end if
            
            if not criminal(attackerindex) then
                
                'el atacante es ciudadano y esta intentando atacar mascota de un ciudadano.
                if userlist(attackerindex).flags.seguro then
                    'el atacante tiene el seguro puesto. no puede atacar.
                    call writeconsolemsg(attackerindex, "para atacar mascotas de ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                    exit function
                else
                    'el atacante no tiene el seguro puesto. recibe penalizaci�n.
                    call writeconsolemsg(attackerindex, "has atacado la mascota de un ciudadano. eres un criminal.", fonttypenames.fonttype_info)
                    call volvercriminal(attackerindex)
                    puedeatacarnpc = true
                    exit function
                end if
            else
                'el atacante es criminal y quiere atacar un elemental ciuda, pero tiene el seguro puesto (niconz)
                if userlist(attackerindex).flags.seguro then
                    call writeconsolemsg(attackerindex, "para atacar mascotas de ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                    exit function
                end if
            end if
        else
            'es mascota de un criminal.
            if escaos(npclist(npcindex).maestrouser) then
                'es caos el due�o.
                if escaos(attackerindex) then
                    'un caos intenta atacar una criatura de un caos. no puede atacar.
                    call writeconsolemsg(attackerindex, "los miembros de la legi�n oscura no pueden atacar mascotas de otros legionarios. ", fonttypenames.fonttype_info)
                    exit function
                end if
            end if
        end if
    end if
    
    with npclist(npcindex)
        ' el npc le pertenece a alguien?
        owneruserindex = .owner
        
        if owneruserindex > 0 then
            
            ' puede atacar a su propia criatura!
            if owneruserindex = attackerindex then
                puedeatacarnpc = true
                call intervaloperdionpc(owneruserindex, true) ' renuevo el timer
                exit function
            end if
            
            ' esta compartiendo el npc con el atacante? => puede atacar!
            if userlist(owneruserindex).flags.sharenpcwith = attackerindex then
                puedeatacarnpc = true
                exit function
            end if
            
            ' si son del mismo clan o party, pueden atacar (no renueva el timer)
            if not sameclan(owneruserindex, attackerindex) and not sameparty(owneruserindex, attackerindex) then
            
                ' si se le agoto el tiempo
                if intervaloperdionpc(owneruserindex) then ' se lo roba :p
                    call perdionpc(owneruserindex)
                    call apropionpc(attackerindex, npcindex)
                    puedeatacarnpc = true
                    exit function
                    
                ' si lanzo un hechizo de para o inmo
                elseif paraliza then
                
                    ' si ya esta paralizado o inmobilizado, no puedo inmobilizarlo de nuevo
                    if .flags.inmovilizado = 1 or .flags.paralizado = 1 then
                        
                        'todo_zama: si dejo esto asi, los pks con seguro peusto van a poder inmobilizar criaturas con due�o
                        ' si es pk neutral, puede hacer lo que quiera :p.
                        if not criminal(attackerindex) and not criminal(owneruserindex) then
                        
                             'el atacante es armada
                            if esarmada(attackerindex) then
                                
                                 'intententa paralizar un npc de un armada?
                                if esarmada(owneruserindex) then
                                    'el atacante es armada y esta intentando paralizar un npc de un armada: no puede
                                    call writeconsolemsg(attackerindex, "los miembros del ej�rcito real no pueden paralizar criaturas ya paralizadas pertenecientes a otros miembros del ej�rcito real", fonttypenames.fonttype_info)
                                    exit function
                                
                                'el atacante es armada y esta intentando paralizar un npc de un ciuda
                                else
                                    ' si tiene seguro no puede
                                    if userlist(attackerindex).flags.seguro then
                                        call writeconsolemsg(attackerindex, "para paralizar criaturas ya paralizadas pertenecientes a ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                                        exit function
                                    else
                                        ' si ya estaba atacable, no podr� atacar a un npc perteneciente a otro ciuda
                                        if toogletoatackable(attackerindex, owneruserindex) then
                                            call writeconsolemsg(attackerindex, "has paralizado la criatura de un ciudadano, ahora eres atacable por �l.", fonttypenames.fonttype_info)
                                            puedeatacarnpc = true
                                        end if
                                        
                                        exit function
                                        
                                    end if
                                end if
                                
                            ' el atacante es ciuda
                            else
                                'el atacante tiene el seguro puesto, no puede paralizar
                                if userlist(attackerindex).flags.seguro then
                                    call writeconsolemsg(attackerindex, "para paralizar criaturas ya paralizadas pertenecientes a ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                                    exit function
                                    
                                'el atacante no tiene el seguro puesto, ataca.
                                else
                                    ' si ya estaba atacable, no podr� atacar a un npc perteneciente a otro ciuda
                                    if toogletoatackable(attackerindex, owneruserindex) then
                                        call writeconsolemsg(attackerindex, "has paralizado la criatura de un ciudadano, ahora eres atacable por �l.", fonttypenames.fonttype_info)
                                        puedeatacarnpc = true
                                    end if
                                    
                                    exit function
                                end if
                            end if
                            
                        ' al menos uno de los dos es criminal
                        else
                            ' si ambos son caos
                            if escaos(attackerindex) and escaos(owneruserindex) then
                                'el atacante es caos y esta intentando paralizar un npc de un caos
                                call writeconsolemsg(attackerindex, "los miembros de la legi�n oscura no pueden paralizar criaturas ya paralizadas por otros legionarios.", fonttypenames.fonttype_info)
                                exit function
                            end if
                        end if
                    
                    ' el npc no esta inmobilizado ni paralizado
                    else
                        ' si no tiene due�o, puede apropiarselo
                        if owneruserindex = 0 then
                            ' siempre que no posea uno ya (el inmo/para no cambia pertenencia de npcs).
                            if userlist(attackerindex).flags.ownednpc = 0 then
                                call apropionpc(attackerindex, npcindex)
                            end if
                        end if
                        
                        ' siempre se pueden paralizar/inmobilizar npcs con o sin due�o
                        ' que no tengan ese estado
                        puedeatacarnpc = true
                        exit function

                    end if
                    
                ' no lanz� hechizos inmobilizantes
                else
                    
                    ' el npc le pertenece a un ciudadano
                    if not criminal(owneruserindex) then
                        
                        'el atacante es armada y esta intentando atacar un npc de un ciudadano
                        if esarmada(attackerindex) then
                        
                            'intententa atacar un npc de un armada?
                            if esarmada(owneruserindex) then
                                'el atacante es armada y esta intentando atacar el npc de un armada: no puede
                                call writeconsolemsg(attackerindex, "los miembros del ej�rcito real no pueden atacar criaturas pertenecientes a otros miembros del ej�rcito real", fonttypenames.fonttype_info)
                                exit function
                            
                            'el atacante es armada y esta intentando atacar un npc de un ciuda
                            else
                                
                                ' si tiene seguro no puede
                                if userlist(attackerindex).flags.seguro then
                                    call writeconsolemsg(attackerindex, "para atacar criaturas ya pertenecientes a ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                                    exit function
                                else
                                    ' si ya estaba atacable, no podr� atacar a un npc perteneciente a otro ciuda
                                    if toogletoatackable(attackerindex, owneruserindex) then
                                        call writeconsolemsg(attackerindex, "has atacado a la criatura de un ciudadano, ahora eres atacable por �l.", fonttypenames.fonttype_info)
                                        puedeatacarnpc = true
                                    end if
                                    
                                    exit function
                                end if
                            end if
                            
                        ' no es aramda, puede ser criminal o ciuda
                        else
                            
                            'el atacante es ciudadano y esta intentando atacar un npc de un ciudadano.
                            if not criminal(attackerindex) then
                                
                                if userlist(attackerindex).flags.seguro then
                                    'el atacante tiene el seguro puesto. no puede atacar.
                                    call writeconsolemsg(attackerindex, "para atacar criaturas pertenecientes a ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                                    exit function
                                
                                'el atacante no tiene el seguro puesto, ataca.
                                else
                                    if toogletoatackable(attackerindex, owneruserindex) then
                                        call writeconsolemsg(attackerindex, "has atacado a la criatura de un ciudadano, ahora eres atacable por �l.", fonttypenames.fonttype_info)
                                        puedeatacarnpc = true
                                    end if
                                    
                                    exit function
                                end if
                                
                            'el atacante es criminal y esta intentando atacar un npc de un ciudadano.
                            else
                                ' es criminal atacando un npc de un ciuda, con seguro puesto.
                                if userlist(attackerindex).flags.seguro then
                                    call writeconsolemsg(attackerindex, "para atacar criaturas pertenecientes a ciudadanos debes quitarte el seguro.", fonttypenames.fonttype_info)
                                    exit function
                                end if
                                
                                puedeatacarnpc = true
                            end if
                        end if
                        
                    ' es npc de un criminal
                    else
                        if escaos(owneruserindex) then
                            'es caos el due�o.
                            if escaos(attackerindex) then
                                'un caos intenta atacar una npc de un caos. no puede atacar.
                                call writeconsolemsg(attackerindex, "los miembros de la legi�n oscura no pueden atacar criaturas de otros legionarios. ", fonttypenames.fonttype_info)
                                exit function
                            end if
                        end if
                    end if
                end if
            end if
            
        ' si no tiene due�o el npc, se lo apropia
        else
            ' solo pueden apropiarse de npcs los caos, armadas o ciudas.
            if not criminal(attackerindex) or escaos(attackerindex) then
                ' no puede apropiarse de los pretos!
                if not (espretoriano(npcindex) <> 0) then
                    ' si es una mascota atacando, no se apropia del npc
                    if not ispet then
                        ' no es due�o de ningun npc => se lo apropia.
                        if userlist(attackerindex).flags.ownednpc = 0 then
                            call apropionpc(attackerindex, npcindex)
                        ' es due�o de un npc, pero no puede ser de este porque no tiene propietario.
                        else
                            ' se va a adue�ar del npc (y perder el otro) solo si no inmobiliza/paraliza
                            if not paraliza then call apropionpc(attackerindex, npcindex)
                        end if
                    end if
                end if
            end if
        end if
    end with
    
    'es el rey preatoriano?
    if espretoriano(npcindex) = 4 then
        if pretorianosvivos > 0 then
            call writeconsolemsg(attackerindex, "debes matar al resto del ej�rcito antes de atacar al rey.", fonttypenames.fonttype_fight)
            exit function
        end if
    end if
    
    puedeatacarnpc = true
end function

private function sameclan(byval userindex as integer, byval otheruserindex as integer) as boolean
'***************************************************
'autor: zama
'returns true if both players belong to the same clan.
'last modification: 16/11/2009
'***************************************************
    sameclan = (userlist(userindex).guildindex = userlist(otheruserindex).guildindex) and _
                userlist(userindex).guildindex <> 0
end function

private function sameparty(byval userindex as integer, byval otheruserindex as integer) as boolean
'***************************************************
'autor: zama
'returns true if both players belong to the same party.
'last modification: 16/11/2009
'***************************************************
    sameparty = userlist(userindex).partyindex = userlist(otheruserindex).partyindex and _
                userlist(userindex).partyindex <> 0
end function

sub calculardarexp(byval userindex as integer, byval npcindex as integer, byval elda�o as long)
'***************************************************
'autor: nacho (integer)
'last modification: 03/09/06 nacho
'reescribi gran parte del sub
'ahora, da toda la experiencia del npc mientras este vivo.
'***************************************************
    dim expadar as long
    
    '[nacho] chekeamos que las variables sean validas para las operaciones
    if elda�o <= 0 then elda�o = 0
    if npclist(npcindex).stats.maxhp <= 0 then exit sub
    if elda�o > npclist(npcindex).stats.minhp then elda�o = npclist(npcindex).stats.minhp
    
    '[nacho] la experiencia a dar es la porcion de vida quitada * toda la experiencia
    expadar = clng(elda�o * (npclist(npcindex).giveexp / npclist(npcindex).stats.maxhp))
    if expadar <= 0 then exit sub
    
    '[nacho] vamos contando cuanta experiencia sacamos, porque se da toda la que no se dio al user que mata al npc
            'esto es porque cuando un elemental ataca, no se da exp, y tambien porque la cuenta que hicimos antes
            'podria dar un numero fraccionario, esas fracciones se acumulan hasta formar enteros ;p
    if expadar > npclist(npcindex).flags.expcount then
        expadar = npclist(npcindex).flags.expcount
        npclist(npcindex).flags.expcount = 0
    else
        npclist(npcindex).flags.expcount = npclist(npcindex).flags.expcount - expadar
    end if
    
    '[nacho] le damos la exp al user
    if expadar > 0 then
        if userlist(userindex).partyindex > 0 then
            call mdparty.obtenerexito(userindex, expadar, npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y)
        else
            userlist(userindex).stats.exp = userlist(userindex).stats.exp + expadar
            if userlist(userindex).stats.exp > maxexp then _
                userlist(userindex).stats.exp = maxexp
            call writeconsolemsg(userindex, "has ganado " & expadar & " puntos de experiencia.", fonttypenames.fonttype_fight)
        end if
        
        call checkuserlevel(userindex)
    end if
end sub

public function triggerzonapelea(byval origen as integer, byval destino as integer) as etrigger6
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'todo: pero que rebuscado!!
'nigo:  te lo redise�e, pero no te borro el todo para que lo revises.
on error goto errhandler
    dim torg as etrigger
    dim tdst as etrigger
    
    torg = mapdata(userlist(origen).pos.map, userlist(origen).pos.x, userlist(origen).pos.y).trigger
    tdst = mapdata(userlist(destino).pos.map, userlist(destino).pos.x, userlist(destino).pos.y).trigger
    
    if torg = etrigger.zonapelea or tdst = etrigger.zonapelea then
        if torg = tdst then
            triggerzonapelea = trigger6_permite
        else
            triggerzonapelea = trigger6_prohibe
        end if
    else
        triggerzonapelea = trigger6_ausente
    end if

exit function
errhandler:
    triggerzonapelea = trigger6_ausente
    logerror ("error en triggerzonapelea - " & err.description)
end function

sub userenvenena(byval atacanteindex as integer, byval victimaindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim objind as integer
    
    objind = userlist(atacanteindex).invent.weaponeqpobjindex
    
    if objind > 0 then
        if objdata(objind).proyectil = 1 then
            objind = userlist(atacanteindex).invent.municioneqpobjindex
        end if
        
        if objind > 0 then
            if objdata(objind).envenena = 1 then
                
                if randomnumber(1, 100) < 60 then
                    userlist(victimaindex).flags.envenenado = 1
                    call writeconsolemsg(victimaindex, "��" & userlist(atacanteindex).name & " te ha envenenado!!", fonttypenames.fonttype_fight)
                    call writeconsolemsg(atacanteindex, "��has envenenado a " & userlist(victimaindex).name & "!!", fonttypenames.fonttype_fight)
                end if
            end if
        end if
    end if
    
    call flushbuffer(victimaindex)
end sub
