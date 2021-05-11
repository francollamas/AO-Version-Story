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
    poderevasionescudo = (userlist(userindex).stats.userskills(eskill.defensa) * modclase(userlist(userindex).clase).evasion) / 2
end function

private function poderevasion(byval userindex as integer) as long
    dim ltemp as long
    with userlist(userindex)
        ltemp = (.stats.userskills(eskill.tacticas) + _
          .stats.userskills(eskill.tacticas) / 33 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).evasion
       
        poderevasion = (ltemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

private function poderataquearma(byval userindex as integer) as long
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
    dim poderataquetemp as long
    
    with userlist(userindex)
        if .stats.userskills(eskill.wrestling) < 31 then
            poderataquetemp = .stats.userskills(eskill.wrestling) * modclase(.clase).ataquearmas
        elseif .stats.userskills(eskill.wrestling) < 61 then
            poderataquetemp = (.stats.userskills(eskill.wrestling) + .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        elseif .stats.userskills(eskill.wrestling) < 91 then
            poderataquetemp = (.stats.userskills(eskill.wrestling) + 2 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        else
            poderataquetemp = (.stats.userskills(eskill.wrestling) + 3 * .stats.useratributos(eatributos.agilidad)) * modclase(.clase).ataquearmas
        end if
        
        poderataquewrestling = (poderataquetemp + (2.5 * maximoint(.stats.elv - 12, 0)))
    end with
end function

public function userimpactonpc(byval userindex as integer, byval npcindex as integer) as boolean
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
        call subirskill(userindex, skill)
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
                    call writeblockedwithshielduser(userindex)
                    call subirskill(userindex, defensa)
                end if
            end if
        end if
    end if
end function

public function calcularda�o(byval userindex as integer, optional byval npcindex as integer = 0) as long
    dim da�oarma as long
    dim da�ousuario as long
    dim arma as objdata
    dim modifclase as single
    dim proyectil as objdata
    dim da�omaxarma as long
    
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
            da�oarma = randomnumber(1, 3) 'hacemos que sea "tipo" una daga el ataque de wrestling
            da�omaxarma = 3
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
    dim da�o as long
    
    da�o = calcularda�o(userindex, npcindex)
    
    'esta navegando? si es asi le sumamos el da�o del barco
    if userlist(userindex).flags.navegando = 1 and userlist(userindex).invent.barcoobjindex > 0 then
        da�o = da�o + randomnumber(objdata(userlist(userindex).invent.barcoobjindex).minhit, objdata(userlist(userindex).invent.barcoobjindex).maxhit)
    end if
    
    with npclist(npcindex)
        da�o = da�o - .stats.def
        
        if da�o < 0 then da�o = 0
        
        call writeuserhitnpc(userindex, da�o)
        call calculardarexp(userindex, npcindex, da�o)
        .stats.minhp = .stats.minhp - da�o
        
        if .stats.minhp > 0 then
            'trata de apu�alar por la espalda al enemigo
            if puedeapu�alar(userindex) then
               call doapu�alar(userindex, npcindex, 0, da�o)
               call subirskill(userindex, apu�alar)
            end if
            
            'trata de dar golpe cr�tico
            call dogolpecritico(userindex, npcindex, 0, da�o)
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
        
        call writenpchituser(userindex, lugar, da�o)
        
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
            call writenpckilluser(userindex) ' le informamos que ha muerto ;)
            
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
    dim j as integer
    
    for j = 1 to maxmascotas
        if userlist(userindex).mascotasindex(j) > 0 then
           if userlist(userindex).mascotasindex(j) <> npcindex then
            if checkelementales or (npclist(userlist(userindex).mascotasindex(j)).numero <> elementalfuego and npclist(userlist(userindex).mascotasindex(j)).numero <> elementaltierra) then
                if npclist(userlist(userindex).mascotasindex(j)).targetnpc = 0 then npclist(userlist(userindex).mascotasindex(j)).targetnpc = npcindex
                npclist(userlist(userindex).mascotasindex(j)).movement = tipoai.npcatacanpc
            end if
           end if
        end if
    next j
end sub

public sub allfollowamo(byval userindex as integer)
    dim j as integer
    
    for j = 1 to maxmascotas
        if userlist(userindex).mascotasindex(j) > 0 then
            call followamo(userlist(userindex).mascotasindex(j))
        end if
    next j
end sub

public function npcatacauser(byval npcindex as integer, byval userindex as integer) as boolean

    if userlist(userindex).flags.admininvisible = 1 then exit function
    if (not userlist(userindex).flags.privilegios and playertype.user) <> 0 and not userlist(userindex).flags.adminperseguible then exit function
    
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
    else
        call writenpcswing(userindex)
    end if
    
    '-----tal vez suba los skills------
    call subirskill(userindex, tacticas)
    
    'controla el nivel del usuario
    call checkuserlevel(userindex)
end function

private function npcimpactonpc(byval atacante as integer, byval victima as integer) as boolean
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

public sub usuarioatacanpc(byval userindex as integer, byval npcindex as integer)

on error goto errhandler

    if not puedeatacarnpc(userindex, npcindex) then
        exit sub
    end if
    
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
        call writeuserswing(userindex)
    end if
exit sub
    
errhandler:
    call logerror("error en usuarioatacanpc. error " & err.number & " : " & err.description)
    
end sub

public sub usuarioataca(byval userindex as integer)
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
                call writeconsolemsg(userindex, "estas muy cansado para luchar.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "estas muy cansada para luchar.", fonttypenames.fonttype_info)
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
                    call writeconsolemsg(userindex, "no pod�s atacar mascotas en zonas seguras", fonttypenames.fonttype_fight)
                    exit sub
                end if
                
                call usuarioatacanpc(userindex, index)
            else
                call writeconsolemsg(userindex, "no pod�s atacar a este npc", fonttypenames.fonttype_fight)
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
        else
            poderataque = poderataquearma(atacanteindex)
        end if
    else
        poderataque = poderataquewrestling(atacanteindex)
    end if
    
    ' chances are rounded
    probexito = maximoint(10, minimoint(90, 50 + (poderataque - userpoderevasion) * 0.4))
    
    usuarioimpacto = (randomnumber(1, 100) <= probexito)
    
    ' el usuario esta usando un escudo ???
    if userlist(victimaindex).invent.escudoeqpobjindex > 0 then
        'fallo ???
        if not usuarioimpacto then
            ' chances are rounded
            probrechazo = maximoint(10, minimoint(90, 100 * skilldefensa / (skilldefensa + skilltacticas)))
            rechazo = (randomnumber(1, 100) <= probrechazo)
            if rechazo = true then
                'se rechazo el ataque con el escudo
                call senddata(sendtarget.topcarea, victimaindex, preparemessageplaywave(snd_escudo, userlist(victimaindex).pos.x, userlist(victimaindex).pos.y))
                  
                call writeblockedwithshieldother(atacanteindex)
                call writeblockedwithshielduser(victimaindex)
                
                call subirskill(victimaindex, defensa)
            end if
        end if
    end if
    
    call flushbuffer(victimaindex)
    
    exit function
    
errhandler:
    call logerror("error en usuarioimpacto. error " & err.number & " : " & err.description)
end function

public sub usuarioatacausuario(byval atacanteindex as integer, byval victimaindex as integer)

on error goto errhandler

    if not puedeatacar(atacanteindex, victimaindex) then exit sub
    
    with userlist(atacanteindex)
        if distancia(.pos, userlist(victimaindex).pos) > maxdistanciaarco then
           call writeconsolemsg(atacanteindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
           exit sub
        end if
        
        call usuarioatacadoporusuario(atacanteindex, victimaindex)
        
        if usuarioimpacto(atacanteindex, victimaindex) then
            call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_impacto, .pos.x, .pos.y))
            
            if userlist(victimaindex).flags.navegando = 0 then
                call senddata(sendtarget.topcarea, victimaindex, preparemessagecreatefx(userlist(victimaindex).char.charindex, fxsangre, 0))
            end if
            
            'pablo (toxicwaste): guantes de hurto del bandido en acci�n
            if .clase = eclass.bandit then
                call dohurtar(atacanteindex, victimaindex)
            'y ahora, el ladr�n puede llegar a paralizar con el golpe.
            elseif .clase = eclass.thief then
                call dohandinmo(atacanteindex, victimaindex)
            end if
            
            call userda�ouser(atacanteindex, victimaindex)
        else
            ' invisible admins doesn't make sound to other clients except itself
            if .flags.admininvisible = 1 then
                call enviardatosaslot(atacanteindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            else
                call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_swing, .pos.x, .pos.y))
            end if
            
            call writeuserswing(atacanteindex)
            call writeuserattackedswing(victimaindex, atacanteindex)
        end if
        
        if .clase = eclass.thief then call desarmar(atacanteindex, victimaindex)
    end with
exit sub
    
errhandler:
    call logerror("error en usuarioatacausuario. error " & err.number & " : " & err.description)
end sub

public sub userda�ouser(byval atacanteindex as integer, byval victimaindex as integer)
    
on error goto errhandler

    dim da�o as long
    dim lugar as integer
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
        
        call writeuserhitteduser(atacanteindex, lugar, userlist(victimaindex).char.charindex, da�o)
        call writeuserhittedbyuser(victimaindex, lugar, .char.charindex, da�o)
        
        userlist(victimaindex).stats.minhp = userlist(victimaindex).stats.minhp - da�o
        
        call subirskill(victimaindex, tacticas)
        
        if .flags.hambre = 0 and .flags.sed = 0 then
            'si usa un arma quizas suba "combate con armas"
            if .invent.weaponeqpobjindex > 0 then
                if objdata(.invent.weaponeqpobjindex).proyectil then
                    'es un arco. sube armas a distancia
                    call subirskill(atacanteindex, proyectiles)
                else
                    'sube combate con armas.
                    call subirskill(atacanteindex, armas)
                end if
            else
            'sino tal vez lucha libre
                call subirskill(atacanteindex, wrestling)
            end if
                    
            'trata de apu�alar por la espalda al enemigo
            if puedeapu�alar(atacanteindex) then
                call doapu�alar(atacanteindex, 0, victimaindex, da�o)
                call subirskill(atacanteindex, apu�alar)
            end if
            'e intenta dar un golpe cr�tico [pablo (toxicwaste)]
            call dogolpecritico(atacanteindex, 0, victimaindex, da�o)
        end if
        
        if userlist(victimaindex).stats.minhp <= 0 then
            'store it!
            call statistics.storefrag(atacanteindex, victimaindex)
            
            call contarmuerte(victimaindex, atacanteindex)
            
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
    
errhandler:
    dim atacantenick as string
    dim victimanick as string
    
    if atacanteindex > 0 then atacantenick = userlist(atacanteindex).name
    if victimaindex > 0 then victimanick = userlist(victimaindex).name
    
    call logerror("error en usuarioimpacto. error " & err.number & " : " & err.description & " atacanteindex: " & _
             atacanteindex & " nick: " & atacantenick & " victimaindex: " & victimaindex & " nick: " & victimanick)
end sub

sub usuarioatacadoporusuario(byval attackerindex as integer, byval victimindex as integer)
'***************************************************
'autor: unknown
'last modification: 10/01/08
'last modified by: lucas tavolaro ortiz (tavo)
' 10/01/2008: tavo - se cancela la salida del juego si el user esta saliendo
'***************************************************

    if triggerzonapelea(attackerindex, victimindex) = trigger6_permite then exit sub
    
    dim eracriminal as boolean
    
    if not criminal(attackerindex) and not criminal(victimindex) then
        call volvercriminal(attackerindex)
    end if
    
    if userlist(victimindex).flags.meditando then
        userlist(victimindex).flags.meditando = false
        call writemeditatetoggle(victimindex)
        call writeconsolemsg(victimindex, "dejas de meditar.", fonttypenames.fonttype_info)
        userlist(victimindex).char.fx = 0
        userlist(victimindex).char.loops = 0
        call senddata(sendtarget.topcarea, victimindex, preparemessagecreatefx(userlist(victimindex).char.charindex, 0, 0))
    end if
    
    eracriminal = criminal(attackerindex)
    
    with userlist(attackerindex).reputacion
        if not criminal(victimindex) then
            .bandidorep = .bandidorep + vlasalto
            if .bandidorep > maxrep then .bandidorep = maxrep
            
            .noblerep = .noblerep / 2
            if .noblerep < 0 then .noblerep = 0
        else
            .noblerep = .noblerep + vlnoble
            if .noblerep > maxrep then .noblerep = maxrep
        end if
    end with
    
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
'last modification: 24/02/2009
'returns true if the attackerindex is allowed to attack the victimindex.
'24/01/2007 pablo (toxicwaste) - ordeno todo y agrego situacion de defensa en ciudad armada y caos.
'24/02/2009: zama - los usuarios pueden atacarse entre si.
'***************************************************
on error goto errhandler

    'muy importante el orden de estos "if"...
    
    'estas muerto no podes atacar
    if userlist(attackerindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "no pod�s atacar porque estas muerto", fonttypenames.fonttype_info)
        puedeatacar = false
        exit function
    end if
    
    'no podes atacar a alguien muerto
    if userlist(victimindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "no pod�s atacar a un espiritu", fonttypenames.fonttype_info)
        puedeatacar = false
        exit function
    end if
    
    'estamos en una arena? o un trigger zona segura?
    select case triggerzonapelea(attackerindex, victimindex)
        case etrigger6.trigger6_permite
            puedeatacar = true
            exit function
        
        case etrigger6.trigger6_prohibe
            puedeatacar = false
            exit function
        
        case etrigger6.trigger6_ausente
            'si no estamos en el trigger 6 entonces es imposible atacar un gm
            if (userlist(victimindex).flags.privilegios and playertype.user) = 0 then
                if userlist(victimindex).flags.admininvisible = 0 then call writeconsolemsg(attackerindex, "el ser es demasiado poderoso", fonttypenames.fonttype_warning)
                puedeatacar = false
                exit function
            end if
    end select
    
    'sos un armada atacando un ciudadano?
    if (not criminal(victimindex)) and (esarmada(attackerindex)) then
        call writeconsolemsg(attackerindex, "los soldados del ej�rcito real tienen prohibido atacar ciudadanos.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    'sos un caos atacando otro caos?
    if escaos(victimindex) and escaos(attackerindex) then
        call writeconsolemsg(attackerindex, "los miembros de la legi�n oscura tienen prohibido atacarse entre s�.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    'tenes puesto el seguro?
    if userlist(attackerindex).flags.seguro then
        if not criminal(victimindex) then
            call writeconsolemsg(attackerindex, "no podes atacar ciudadanos, para hacerlo debes desactivar el seguro ingresando /seg", fonttypenames.fonttype_warning)
            puedeatacar = false
            exit function
        end if
    end if
    
    'estas en un mapa seguro?
    if mapinfo(userlist(victimindex).pos.map).pk = false then
        if esarmada(attackerindex) then
            if userlist(attackerindex).faccion.recompensasreal > 11 then
                if userlist(victimindex).pos.map = 58 or userlist(victimindex).pos.map = 59 or userlist(victimindex).pos.map = 60 then
                call writeconsolemsg(victimindex, "huye de la ciudad! estas siendo atacado y no podr�s defenderte.", fonttypenames.fonttype_warning)
                puedeatacar = true 'beneficio de armadas que atacan en su ciudad.
                exit function
                end if
            end if
        end if
        if escaos(attackerindex) then
            if userlist(attackerindex).faccion.recompensascaos > 11 then
                if userlist(victimindex).pos.map = 151 or userlist(victimindex).pos.map = 156 then
                call writeconsolemsg(victimindex, "huye de la ciudad! estas siendo atacado y no podr�s defenderte.", fonttypenames.fonttype_warning)
                puedeatacar = true 'beneficio de caos que atacan en su ciudad.
                exit function
                end if
            end if
        end if
        call writeconsolemsg(attackerindex, "esta es una zona segura, aqui no podes atacar otros usuarios.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    'estas atacando desde un trigger seguro? o tu victima esta en uno asi?
    if mapdata(userlist(victimindex).pos.map, userlist(victimindex).pos.x, userlist(victimindex).pos.y).trigger = etrigger.zonasegura or _
        mapdata(userlist(attackerindex).pos.map, userlist(attackerindex).pos.x, userlist(attackerindex).pos.y).trigger = etrigger.zonasegura then
        call writeconsolemsg(attackerindex, "no podes pelear aqui.", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
    
    puedeatacar = true
exit function

errhandler:
    call logerror("error en puedeatacar. error " & err.number & " : " & err.description)
end function

public function puedeatacarnpc(byval attackerindex as integer, byval npcindex as integer) as boolean
'***************************************************
'autor: unknown author (original version)
'returns true if attackerindex can attack the npcindex
'last modification: 24/01/2007
'24/01/2007 pablo (toxicwaste) - orden y correcci�n de ataque sobre una mascota y guardias
'14/08/2007 pablo (toxicwaste) - reescribo y agrego todos los casos posibles cosa de usar
'esta funci�n para todo lo referente a ataque a un npc. ya sea magia, f�sico o a distancia.
'***************************************************

    'estas muerto?
    if userlist(attackerindex).flags.muerto = 1 then
        call writeconsolemsg(attackerindex, "no pod�s atacar porque estas muerto", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    
    'sos consejero?
    if userlist(attackerindex).flags.privilegios and playertype.consejero then
        'no pueden atacar npc los consejeros.
        puedeatacarnpc = false
        exit function
    end if
    
    'estas en modo combate?
    if not userlist(attackerindex).flags.modocombate then
        call writeconsolemsg(attackerindex, "debes estar en modo de combate poder atacar al npc.", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    
    'es una criatura atacable?
    if npclist(npcindex).attackable = 0 then
        call writeconsolemsg(attackerindex, "no puedes atacar esta criatura.", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    
    'es valida la distancia a la cual estamos atacando?
    if distancia(userlist(attackerindex).pos, npclist(npcindex).pos) >= maxdistanciaarco then
       call writeconsolemsg(attackerindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
       puedeatacarnpc = false
       exit function
    end if
    
    'es una criatura no-hostil?
    if npclist(npcindex).hostile = 0 then
        'es guardia del caos?
        if npclist(npcindex).npctype = enpctype.guardiascaos then
            'lo quiere atacar un caos?
            if escaos(attackerindex) then
                call writeconsolemsg(attackerindex, "no puedes atacar guardias del caos siendo legionario", fonttypenames.fonttype_info)
                puedeatacarnpc = false
                exit function
            end if
        'es guardia real?
        elseif npclist(npcindex).npctype = enpctype.guardiareal then
            'lo quiere atacar un armada?
            if esarmada(attackerindex) then
                call writeconsolemsg(attackerindex, "no puedes atacar guardias reales siendo armada real", fonttypenames.fonttype_info)
                puedeatacarnpc = false
                exit function
            end if
            'tienes el seguro puesto?
            if userlist(attackerindex).flags.seguro then
                call writeconsolemsg(attackerindex, "debes quitar el seguro para poder atacar guardias reales utilizando /seg", fonttypenames.fonttype_info)
                puedeatacarnpc = false
                exit function
            else
                call writeconsolemsg(attackerindex, "atacaste un guardia real! eres un criminal.", fonttypenames.fonttype_info)
                call volvercriminal(attackerindex)
                puedeatacarnpc = true
                exit function
            end if
    
        'no era un guardia, asi que es una criatura no-hostil com�n.
        'para asegurarnos que no sea una mascota:
        elseif npclist(npcindex).maestrouser = 0 then
            'si sos ciudadano tenes que quitar el seguro para atacarla.
            if not criminal(attackerindex) then
                'sos ciudadano, tenes el seguro puesto?
                if userlist(attackerindex).flags.seguro then
                    call writeconsolemsg(attackerindex, "para atacar a este npc deb�s quitar el seguro", fonttypenames.fonttype_info)
                    puedeatacarnpc = false
                    exit function
                else
                    'no tiene seguro puesto. puede atacar pero es penalizado.
                    call writeconsolemsg(attackerindex, "atacaste un npc no-hostil. continua haciendolo y ser�s criminal.", fonttypenames.fonttype_info)
                    'niconz: cambio para que al atacar npcs no hostiles no bajen puntos de nobleza
                    'call disnobauban(attackerindex, 1000, 1000)
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
                call writeconsolemsg(attackerindex, "los armadas no pueden atacar mascotas de ciudadanos.", fonttypenames.fonttype_info)
                puedeatacarnpc = false
                exit function
            end if
            if not criminal(attackerindex) then
                'el atacante es ciudadano y esta intentando atacar mascota de un ciudadano.
                if userlist(attackerindex).flags.seguro then
                    'el atacante tiene el seguro puesto. no puede atacar.
                    call writeconsolemsg(attackerindex, "para atacar mascotas de ciudadanos debes quitar el seguro utilizando /seg", fonttypenames.fonttype_info)
                    puedeatacarnpc = false
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
                    call writeconsolemsg(attackerindex, "para atacar mascotas de ciudadanos debes quitar el seguro utilizando /seg", fonttypenames.fonttype_info)
                    puedeatacarnpc = false
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
                    puedeatacarnpc = false
                    exit function
                end if
            end if
        end if
    end if
    
    'es el rey preatoriano?
    if espretoriano(npcindex) = 4 then
        if pretorianosvivos > 0 then
            call writeconsolemsg(attackerindex, "debes matar al resto del ej�rcito antes de atacar al rey!", fonttypenames.fonttype_fight)
            puedeatacarnpc = false
            exit function
        end if
    end if
    
    puedeatacarnpc = true
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
                    call writeconsolemsg(victimaindex, userlist(atacanteindex).name & " te ha envenenado!!", fonttypenames.fonttype_fight)
                    call writeconsolemsg(atacanteindex, "has envenenado a " & userlist(victimaindex).name & "!!", fonttypenames.fonttype_fight)
                end if
            end if
        end if
    end if
    
    call flushbuffer(victimaindex)
end sub
