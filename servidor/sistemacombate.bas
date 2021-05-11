attribute vb_name = "sistemacombate"
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
'
'dise�o y correcci�n del modulo de combate por
'gerardo saiz, gerardosaiz@yahoo.com
'

option explicit

public const maxdistanciaarco as byte = 18
public const maxdistanciamagia as byte = 18

function modificadorevasion(byval clase as eclass) as single

select case clase
    case eclass.warrior
        modificadorevasion = 1
    case eclass.hunter
        modificadorevasion = 0.9
    case eclass.paladin
        modificadorevasion = 0.9
    case eclass.bandit
        modificadorevasion = 0.7
    case eclass.assasin
        modificadorevasion = 1.1
    case eclass.pirat
        modificadorevasion = 0.9
    case eclass.thief
        modificadorevasion = 1.1
    case eclass.bard
        modificadorevasion = 1.1
    case eclass.mage
        modificadorevasion = 0.4
    case eclass.druid
        modificadorevasion = 0.75
    case else
        modificadorevasion = 0.8
end select
end function

function modificadorpoderataquearmas(byval clase as eclass) as single
select case ucase$(clase)
    case eclass.warrior
        modificadorpoderataquearmas = 1
    case eclass.paladin
        modificadorpoderataquearmas = 0.9
    case eclass.hunter
        modificadorpoderataquearmas = 0.8
    case eclass.assasin
        modificadorpoderataquearmas = 0.85
    case eclass.pirat
        modificadorpoderataquearmas = 0.8
    case eclass.thief
        modificadorpoderataquearmas = 0.75
    case eclass.bandit
        modificadorpoderataquearmas = 0.7
    case eclass.cleric
        modificadorpoderataquearmas = 0.75
    case eclass.bard
        modificadorpoderataquearmas = 0.7
    case eclass.druid
        modificadorpoderataquearmas = 0.65
    case eclass.fisher
        modificadorpoderataquearmas = 0.6
    case eclass.lumberjack
        modificadorpoderataquearmas = 0.6
    case eclass.miner
        modificadorpoderataquearmas = 0.6
    case eclass.blacksmith
        modificadorpoderataquearmas = 0.6
    case eclass.carpenter
        modificadorpoderataquearmas = 0.6
    case else
        modificadorpoderataquearmas = 0.5
end select
end function

function modificadorpoderataqueproyectiles(byval clase as eclass) as single
select case ucase$(clase)
    case eclass.warrior
        modificadorpoderataqueproyectiles = 0.8
    case eclass.hunter
        modificadorpoderataqueproyectiles = 1
    case eclass.paladin
        modificadorpoderataqueproyectiles = 0.75
    case eclass.assasin
        modificadorpoderataqueproyectiles = 0.75
    case eclass.pirat
        modificadorpoderataqueproyectiles = 0.75
    case eclass.thief
        modificadorpoderataqueproyectiles = 0.8
    case eclass.bandit
        modificadorpoderataqueproyectiles = 0.75
    case eclass.cleric
        modificadorpoderataqueproyectiles = 0.7
    case eclass.bard
        modificadorpoderataqueproyectiles = 0.7
    case eclass.druid
        modificadorpoderataqueproyectiles = 0.75
    case eclass.fisher
        modificadorpoderataqueproyectiles = 0.65
    case eclass.lumberjack
        modificadorpoderataqueproyectiles = 0.7
    case eclass.miner
        modificadorpoderataqueproyectiles = 0.65
    case eclass.blacksmith
        modificadorpoderataqueproyectiles = 0.65
    case eclass.carpenter
        modificadorpoderataqueproyectiles = 0.7
    case else
        modificadorpoderataqueproyectiles = 0.5
end select
end function

function modicadorda�oclasearmas(byval clase as eclass) as single
select case ucase$(clase)
    case eclass.warrior
        modicadorda�oclasearmas = 1.1
    case eclass.paladin
        modicadorda�oclasearmas = 0.95
    case eclass.hunter
        modicadorda�oclasearmas = 0.9
    case eclass.assasin
        modicadorda�oclasearmas = 0.9
    case eclass.thief
        modicadorda�oclasearmas = 0.8
    case eclass.pirat
        modicadorda�oclasearmas = 0.8
    case eclass.bandit
        modicadorda�oclasearmas = 0.9
    case eclass.cleric
        modicadorda�oclasearmas = 0.8
    case eclass.bard
        modicadorda�oclasearmas = 0.75
    case eclass.druid
        modicadorda�oclasearmas = 0.7
    case eclass.fisher
        modicadorda�oclasearmas = 0.6
    case eclass.lumberjack
        modicadorda�oclasearmas = 0.7
    case eclass.miner
        modicadorda�oclasearmas = 0.75
    case eclass.blacksmith
        modicadorda�oclasearmas = 0.75
    case eclass.carpenter
        modicadorda�oclasearmas = 0.7
    case else
        modicadorda�oclasearmas = 0.5
end select
end function

function modicadorda�oclasewrestling(byval clase as eclass) as single
'pablo (toxicwaste): esto en proxima versi�n habr� que balancearlo para cada clase
'hoy por hoy est� solo hecho para el bandido.
select case ucase$(clase)
    case eclass.warrior
        modicadorda�oclasewrestling = 0.4
    case eclass.paladin
        modicadorda�oclasewrestling = 0.4
    case eclass.hunter
        modicadorda�oclasewrestling = 0.4
    case eclass.assasin
        modicadorda�oclasewrestling = 0.4
    case eclass.thief
        modicadorda�oclasewrestling = 0.4
    case eclass.pirat
        modicadorda�oclasewrestling = 0.4
    case eclass.bandit
        modicadorda�oclasewrestling = 1.1
    case eclass.cleric
        modicadorda�oclasewrestling = 0.4
    case eclass.bard
        modicadorda�oclasewrestling = 0.4
    case eclass.druid
        modicadorda�oclasewrestling = 0.4
    case eclass.fisher
        modicadorda�oclasewrestling = 0.4
    case eclass.lumberjack
        modicadorda�oclasewrestling = 0.4
    case eclass.miner
        modicadorda�oclasewrestling = 0.4
    case eclass.blacksmith
        modicadorda�oclasewrestling = 0.4
    case eclass.carpenter
        modicadorda�oclasewrestling = 0.4
    case else
        modicadorda�oclasewrestling = 0.4
end select
end function


function modicadorda�oclaseproyectiles(byval clase as eclass) as single
select case clase
    case eclass.hunter
        modicadorda�oclaseproyectiles = 1.1
    case eclass.warrior
        modicadorda�oclaseproyectiles = 0.9
    case eclass.paladin
        modicadorda�oclaseproyectiles = 0.8
    case eclass.assasin
        modicadorda�oclaseproyectiles = 0.8
    case eclass.thief
        modicadorda�oclaseproyectiles = 0.75
    case eclass.pirat
        modicadorda�oclaseproyectiles = 0.75
    case eclass.bandit
        modicadorda�oclaseproyectiles = 0.8
    case eclass.cleric
        modicadorda�oclaseproyectiles = 0.7
    case eclass.bard
        modicadorda�oclaseproyectiles = 0.7
    case eclass.druid
        modicadorda�oclaseproyectiles = 0.75
    case eclass.fisher
        modicadorda�oclaseproyectiles = 0.6
    case eclass.lumberjack
        modicadorda�oclaseproyectiles = 0.7
    case eclass.miner
        modicadorda�oclaseproyectiles = 0.6
    case eclass.blacksmith
        modicadorda�oclaseproyectiles = 0.6
    case eclass.carpenter
        modicadorda�oclaseproyectiles = 0.7
    case else
        modicadorda�oclaseproyectiles = 0.5
end select
end function

function modevasiondeescudoclase(byval clase as eclass) as single

select case clase
    case eclass.warrior
        modevasiondeescudoclase = 1
    case eclass.hunter
        modevasiondeescudoclase = 0.8
    case eclass.paladin
        modevasiondeescudoclase = 1
    case eclass.assasin
        modevasiondeescudoclase = 0.8
    case eclass.thief
        modevasiondeescudoclase = 0.7
    case eclass.bandit
        modevasiondeescudoclase = 2
    case eclass.pirat
        modevasiondeescudoclase = 0.75
    case eclass.cleric
        modevasiondeescudoclase = 0.85
    case eclass.bard
        modevasiondeescudoclase = 0.8
    case eclass.druid
        modevasiondeescudoclase = 0.75
    case eclass.fisher
        modevasiondeescudoclase = 0.7
    case eclass.lumberjack
        modevasiondeescudoclase = 0.7
    case eclass.miner
        modevasiondeescudoclase = 0.7
    case eclass.blacksmith
        modevasiondeescudoclase = 0.7
    case eclass.carpenter
        modevasiondeescudoclase = 0.7
    case else
        modevasiondeescudoclase = 0.6
end select

end function
function minimo(byval a as single, byval b as single) as single
if a > b then
    minimo = b
    else: minimo = a
end if
end function

function minimoint(byval a as integer, byval b as integer) as integer
if a > b then
    minimoint = b
    else: minimoint = a
end if
end function

function maximo(byval a as single, byval b as single) as single
if a > b then
    maximo = a
    else: maximo = b
end if
end function

function maximoint(byval a as integer, byval b as integer) as integer
if a > b then
    maximoint = a
    else: maximoint = b
end if
end function


function poderevasionescudo(byval userindex as integer) as long

poderevasionescudo = (userlist(userindex).stats.userskills(eskill.defensa) * _
modevasiondeescudoclase(userlist(userindex).clase)) / 2

end function

function poderevasion(byval userindex as integer) as long
    dim ltemp as long
     with userlist(userindex)
       ltemp = (.stats.userskills(eskill.tacticas) + _
          .stats.userskills(eskill.tacticas) / 33 * .stats.useratributos(eatributos.agilidad)) * _
          modificadorevasion(.clase)
       
        poderevasion = (ltemp + (2.5 * maximo(cint(.stats.elv) - 12, 0)))
    end with
end function

function poderataquearma(byval userindex as integer) as long
dim poderataquetemp as long

if userlist(userindex).stats.userskills(eskill.armas) < 31 then
    poderataquetemp = (userlist(userindex).stats.userskills(eskill.armas) * _
    modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.armas) < 61 then
    poderataquetemp = ((userlist(userindex).stats.userskills(eskill.armas) + _
    userlist(userindex).stats.useratributos(eatributos.agilidad)) * _
    modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.armas) < 91 then
    poderataquetemp = ((userlist(userindex).stats.userskills(eskill.armas) + _
    (2 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
    modificadorpoderataquearmas(userlist(userindex).clase))
else
   poderataquetemp = ((userlist(userindex).stats.userskills(eskill.armas) + _
   (3 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
   modificadorpoderataquearmas(userlist(userindex).clase))
end if

poderataquearma = (poderataquetemp + (2.5 * maximo(cint(userlist(userindex).stats.elv) - 12, 0)))
end function

function poderataqueproyectil(byval userindex as integer) as long
dim poderataquetemp as long

if userlist(userindex).stats.userskills(eskill.proyectiles) < 31 then
    poderataquetemp = (userlist(userindex).stats.userskills(eskill.proyectiles) * _
    modificadorpoderataqueproyectiles(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.proyectiles) < 61 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.proyectiles) + _
        userlist(userindex).stats.useratributos(eatributos.agilidad)) * _
        modificadorpoderataqueproyectiles(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.proyectiles) < 91 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.proyectiles) + _
        (2 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
        modificadorpoderataqueproyectiles(userlist(userindex).clase))
else
       poderataquetemp = ((userlist(userindex).stats.userskills(eskill.proyectiles) + _
      (3 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
      modificadorpoderataqueproyectiles(userlist(userindex).clase))
end if

poderataqueproyectil = (poderataquetemp + (2.5 * maximo(cint(userlist(userindex).stats.elv) - 12, 0)))

end function

function poderataquewrestling(byval userindex as integer) as long
dim poderataquetemp as long

if userlist(userindex).stats.userskills(eskill.wrestling) < 31 then
    poderataquetemp = (userlist(userindex).stats.userskills(eskill.wrestling) * _
    modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.wrestling) < 61 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wrestling) + _
        userlist(userindex).stats.useratributos(eatributos.agilidad)) * _
        modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.wrestling) < 91 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wrestling) + _
        (2 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
        modificadorpoderataquearmas(userlist(userindex).clase))
else
       poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wrestling) + _
       (3 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
       modificadorpoderataquearmas(userlist(userindex).clase))
end if

poderataquewrestling = (poderataquetemp + (2.5 * maximo(cint(userlist(userindex).stats.elv) - 12, 0)))

end function


public function userimpactonpc(byval userindex as integer, byval npcindex as integer) as boolean
dim poderataque as long
dim arma as integer
dim proyectil as boolean
dim probexito as long

arma = userlist(userindex).invent.weaponeqpobjindex
if arma = 0 then proyectil = false else proyectil = objdata(arma).proyectil = 1

if arma > 0 then 'usando un arma
    if proyectil then
        poderataque = poderataqueproyectil(userindex)
    else
        poderataque = poderataquearma(userindex)
    end if
else 'peleando con pu�os
    poderataque = poderataquewrestling(userindex)
end if


probexito = maximo(10, minimo(90, 50 + ((poderataque - npclist(npcindex).poderevasion) * 0.4)))

userimpactonpc = (randomnumber(1, 100) <= probexito)

if userimpactonpc then
    if arma <> 0 then
       if proyectil then
            call subirskill(userindex, proyectiles)
       else
            call subirskill(userindex, armas)
       end if
    else
        call subirskill(userindex, wrestling)
    end if
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

probexito = maximo(10, minimo(90, 50 + ((npcpoderataque - userevasion) * 0.4)))

npcimpacto = (randomnumber(1, 100) <= probexito)

' el usuario esta usando un escudo ???
if userlist(userindex).invent.escudoeqpobjindex > 0 then
    if not npcimpacto then
        if skilldefensa + skilltacticas > 0 then  'evitamos divisi�n por cero
            probrechazo = maximo(10, minimo(90, 100 * (skilldefensa / (skilldefensa + skilltacticas))))
            rechazo = (randomnumber(1, 100) <= probrechazo)
            if rechazo = true then
                'se rechazo el ataque con el escudo
                call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_escudo))
                call writeblockedwithshielduser(userindex)
                call subirskill(userindex, defensa)
            end if
        end if
    end if
end if
end function

public function calcularda�o(byval userindex as integer, optional byval npcindex as integer = 0) as long
dim da�oarma as long, da�ousuario as long, arma as objdata, modifclase as single
dim proyectil as objdata
dim da�omaxarma as long

''sacar esto si no queremos q la matadracos mate el dragon si o si
dim matodragon as boolean
matodragon = false


if userlist(userindex).invent.weaponeqpobjindex > 0 then
    arma = objdata(userlist(userindex).invent.weaponeqpobjindex)
    
    
    ' ataca a un npc?
    if npcindex > 0 then
        
        'usa la mata dragones?
        if userlist(userindex).invent.weaponeqpobjindex = espadamatadragonesindex then ' usa la matadragones?
            modifclase = modicadorda�oclasearmas(userlist(userindex).clase)
            
            if npclist(npcindex).npctype = dragon then 'ataca dragon?
                da�oarma = randomnumber(arma.minhit, arma.maxhit)
                da�omaxarma = arma.maxhit
                matodragon = true ''sacar esto si no queremos q la matadracos mate el dragon si o si
            else ' sino es dragon da�o es 1
                da�oarma = 1
                da�omaxarma = 1
            end if
        else ' da�o comun
           if arma.proyectil = 1 then
                modifclase = modicadorda�oclaseproyectiles(userlist(userindex).clase)
                da�oarma = randomnumber(arma.minhit, arma.maxhit)
                da�omaxarma = arma.maxhit
                if arma.municion = 1 then
                    proyectil = objdata(userlist(userindex).invent.municioneqpobjindex)
                    da�oarma = da�oarma + randomnumber(proyectil.minhit, proyectil.maxhit)
                    da�omaxarma = arma.maxhit
                end if
           else
                modifclase = modicadorda�oclasearmas(userlist(userindex).clase)
                da�oarma = randomnumber(arma.minhit, arma.maxhit)
                da�omaxarma = arma.maxhit
           end if
        end if
    
    else ' ataca usuario
        if userlist(userindex).invent.weaponeqpobjindex = espadamatadragonesindex then
            modifclase = modicadorda�oclasearmas(userlist(userindex).clase)
            da�oarma = 1 ' si usa la espada matadragones da�o es 1
            da�omaxarma = 1
        else
           if arma.proyectil = 1 then
                modifclase = modicadorda�oclaseproyectiles(userlist(userindex).clase)
                da�oarma = randomnumber(arma.minhit, arma.maxhit)
                da�omaxarma = arma.maxhit
                
                if arma.municion = 1 then
                    proyectil = objdata(userlist(userindex).invent.municioneqpobjindex)
                    da�oarma = da�oarma + randomnumber(proyectil.minhit, proyectil.maxhit)
                    da�omaxarma = arma.maxhit
                end if
           else
                modifclase = modicadorda�oclasearmas(userlist(userindex).clase)
                da�oarma = randomnumber(arma.minhit, arma.maxhit)
                da�omaxarma = arma.maxhit
           end if
        end if
    end if
else
    'pablo (toxicwaste)
    modifclase = modicadorda�oclasewrestling(userlist(userindex).clase)
    da�oarma = randomnumber(1, 3) 'hacemos que sea "tipo" una daga el ataque de wrestling
    da�omaxarma = 3
end if

da�ousuario = randomnumber(userlist(userindex).stats.minhit, userlist(userindex).stats.maxhit)

''sacar esto si no queremos q la matadracos mate el dragon si o si
if matodragon then
    calcularda�o = npclist(npcindex).stats.minhp + npclist(npcindex).stats.def
else
    calcularda�o = (((3 * da�oarma) + ((da�omaxarma / 5) * maximo(0, (userlist(userindex).stats.useratributos(eatributos.fuerza) - 15))) + da�ousuario) * modifclase)
end if

end function

public sub userda�onpc(byval userindex as integer, byval npcindex as integer)
dim da�o as long



da�o = calcularda�o(userindex, npcindex)

'esta navegando? si es asi le sumamos el da�o del barco
if userlist(userindex).flags.navegando = 1 and userlist(userindex).invent.barcoobjindex > 0 then _
        da�o = da�o + randomnumber(objdata(userlist(userindex).invent.barcoobjindex).minhit, objdata(userlist(userindex).invent.barcoobjindex).maxhit)

da�o = da�o - npclist(npcindex).stats.def

if da�o < 0 then da�o = 0

'[kevin]
call writeuserhitnpc(userindex, da�o)
call calculardarexp(userindex, npcindex, da�o)
npclist(npcindex).stats.minhp = npclist(npcindex).stats.minhp - da�o
'[/kevin]

if npclist(npcindex).stats.minhp > 0 then
    'trata de apu�alar por la espalda al enemigo
    if puedeapu�alar(userindex) then
       call doapu�alar(userindex, npcindex, 0, da�o)
       call subirskill(userindex, apu�alar)
    end if
    'trata de dar golpe cr�tico
    call dogolpecritico(userindex, npcindex, 0, da�o)
    
end if

 
if npclist(npcindex).stats.minhp <= 0 then
        
        ' si era un dragon perdemos la espada matadragones
        if npclist(npcindex).npctype = dragon then
            'si tiene equipada la matadracos se la sacamos
            if userlist(userindex).invent.weaponeqpobjindex = espadamatadragonesindex then
                call quitarobjetos(espadamatadragonesindex, 1, userindex)
            end if
            if npclist(npcindex).stats.maxhp > 100000 then call logdesarrollo(userlist(userindex).name & " mat� un drag�n")
        end if
        
        
        ' para que las mascotas no sigan intentando luchar y
        ' comiencen a seguir al amo
        
        dim j as integer
        for j = 1 to maxmascotas
            if userlist(userindex).mascotasindex(j) > 0 then
                if npclist(userlist(userindex).mascotasindex(j)).targetnpc = npcindex then npclist(userlist(userindex).mascotasindex(j)).targetnpc = 0
                npclist(userlist(userindex).mascotasindex(j)).movement = tipoai.sigueamo
            end if
        next j
        
        call muerenpc(npcindex, userindex)
end if

end sub


public sub npcda�o(byval npcindex as integer, byval userindex as integer)

dim da�o as integer, lugar as integer, absorbido as integer, npcfile as string
dim antda�o as integer, defbarco as integer
dim obj as objdata



da�o = randomnumber(npclist(npcindex).stats.minhit, npclist(npcindex).stats.maxhit)
antda�o = da�o

if userlist(userindex).flags.navegando = 1 and userlist(userindex).invent.barcoobjindex > 0 then
    obj = objdata(userlist(userindex).invent.barcoobjindex)
    defbarco = randomnumber(obj.mindef, obj.maxdef)
end if


lugar = randomnumber(1, 6)


select case lugar
  case partescuerpo.bcabeza
        'si tiene casco absorbe el golpe
        if userlist(userindex).invent.cascoeqpobjindex > 0 then
           obj = objdata(userlist(userindex).invent.cascoeqpobjindex)
           absorbido = randomnumber(obj.mindef, obj.maxdef)
           absorbido = absorbido + defbarco
           da�o = da�o - absorbido
           if da�o < 1 then da�o = 1
        end if
  case else
        'si tiene armadura absorbe el golpe
        if userlist(userindex).invent.armoureqpobjindex > 0 then
           dim obj2 as objdata
           obj = objdata(userlist(userindex).invent.armoureqpobjindex)
           if userlist(userindex).invent.escudoeqpobjindex then
                obj2 = objdata(userlist(userindex).invent.escudoeqpobjindex)
                absorbido = randomnumber(obj.mindef + obj2.mindef, obj.maxdef + obj2.maxdef)
           else
                absorbido = randomnumber(obj.mindef, obj.maxdef)
           end if
           absorbido = absorbido + defbarco
           da�o = da�o - absorbido
           if da�o < 1 then da�o = 1
        end if
end select

call writenpchituser(userindex, lugar, da�o)

if userlist(userindex).flags.privilegios and playertype.user then userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - da�o

if userlist(userindex).flags.meditando then
    if da�o > fix(userlist(userindex).stats.minhp / 100 * userlist(userindex).stats.useratributos(eatributos.inteligencia) * userlist(userindex).stats.userskills(eskill.meditar) / 100 * 12 / (randomnumber(0, 5) + 7)) then
        userlist(userindex).flags.meditando = false
        call writemeditatetoggle(userindex)
        call writeconsolemsg(userindex, "dejas de meditar.", fonttypenames.fonttype_info)
        userlist(userindex).char.fx = 0
        userlist(userindex).char.loops = 0
        call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, 0, 0))
    end if
end if

'muere el usuario
if userlist(userindex).stats.minhp <= 0 then

    call writenpckilluser(userindex) ' le informamos que ha muerto ;)
    
    'si lo mato un guardia
    if criminal(userindex) and npclist(npcindex).npctype = enpctype.guardiareal then
        call restarcriminalidad(userindex)
        if not criminal(userindex) and userlist(userindex).faccion.fuerzascaos = 1 then call expulsarfaccioncaos(userindex)
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

end sub

public sub restarcriminalidad(byval userindex as integer)
    
    dim eracriminal as boolean
    eracriminal = criminal(userindex)
    
    if userlist(userindex).reputacion.bandidorep > 0 then
         userlist(userindex).reputacion.bandidorep = userlist(userindex).reputacion.bandidorep - vlasalto
         if userlist(userindex).reputacion.bandidorep < 0 then userlist(userindex).reputacion.bandidorep = 0
    elseif userlist(userindex).reputacion.ladronesrep > 0 then
         userlist(userindex).reputacion.ladronesrep = userlist(userindex).reputacion.ladronesrep - (vlcazador * 10)
         if userlist(userindex).reputacion.ladronesrep < 0 then userlist(userindex).reputacion.ladronesrep = 0
    end if
    
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
            'npclist(userlist(userindex).mascotasindex(j)).flags.oldmovement = npclist(userlist(userindex).mascotasindex(j)).movement
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

' el npc puede atacar ???
if npclist(npcindex).canattack = 1 then
    npcatacauser = true
    call checkpets(npcindex, userindex, false)

    if npclist(npcindex).target = 0 then npclist(npcindex).target = userindex

    if userlist(userindex).flags.atacadopornpc = 0 and _
       userlist(userindex).flags.atacadoporuser = 0 then userlist(userindex).flags.atacadopornpc = npcindex
else
    npcatacauser = false
    exit function
end if

npclist(npcindex).canattack = 0

if npclist(npcindex).flags.snd1 > 0 then
    call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(npclist(npcindex).flags.snd1))
end if

if npcimpacto(npcindex, userindex) then
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_impacto))
    
    if userlist(userindex).flags.meditando = false then
        if userlist(userindex).flags.navegando = 0 then
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, fxsangre, 0))
        end if
    end if
    
    call npcda�o(npcindex, userindex)
    call writeupdatehp(userindex)
    '�puede envenenar?
    if npclist(npcindex).veneno = 1 then call npcenvenenaruser(userindex)
else
    call writenpcswing(userindex)
end if



'-----tal vez suba los skills------
call subirskill(userindex, tacticas)

'controla el nivel del usuario
call checkuserlevel(userindex)

end function

function npcimpactonpc(byval atacante as integer, byval victima as integer) as boolean
dim poderatt as long, podereva as long, dif as long
dim probexito as long

poderatt = npclist(atacante).poderataque
podereva = npclist(victima).poderevasion
probexito = maximo(10, minimo(90, 50 + _
            ((poderatt - podereva) * 0.4)))
npcimpactonpc = (randomnumber(1, 100) <= probexito)


end function

public sub npcda�onpc(byval atacante as integer, byval victima as integer)
dim da�o as integer
dim anpc as npc, dnpc as npc
anpc = npclist(atacante)

da�o = randomnumber(anpc.stats.minhit, anpc.stats.maxhit)
npclist(victima).stats.minhp = npclist(victima).stats.minhp - da�o

if npclist(victima).stats.minhp < 1 then
        
        if lenb(npclist(atacante).flags.attackedby) <> 0 then
            npclist(atacante).movement = npclist(atacante).flags.oldmovement
            npclist(atacante).hostile = npclist(atacante).flags.oldhostil
        else
            npclist(atacante).movement = npclist(atacante).flags.oldmovement
        end if
        
        call followamo(atacante)
        
        call muerenpc(victima, npclist(atacante).maestrouser)
end if

end sub

public sub npcatacanpc(byval atacante as integer, byval victima as integer, optional byval cambiarmovimiento as boolean = true)

' el npc puede atacar ???
if npclist(atacante).canattack = 1 then
       npclist(atacante).canattack = 0
        if cambiarmovimiento then
            npclist(victima).targetnpc = atacante
            npclist(victima).movement = tipoai.npcatacanpc
        end if
else
    exit sub
end if

if npclist(atacante).flags.snd1 > 0 then
    call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(npclist(atacante).flags.snd1))
end if

if npcimpactonpc(atacante, victima) then
    
    if npclist(victima).flags.snd2 > 0 then
        call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(npclist(victima).flags.snd2))
    else
        call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_impacto2))
    end if

    if npclist(atacante).maestrouser > 0 then
        call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(snd_impacto))
    else
        call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_impacto))
    end if
    call npcda�onpc(atacante, victima)
    
else
    if npclist(atacante).maestrouser > 0 then
        call senddata(sendtarget.tonpcarea, atacante, preparemessageplaywave(snd_swing))
    else
        call senddata(sendtarget.tonpcarea, victima, preparemessageplaywave(snd_swing))
    end if
end if

end sub

public sub usuarioatacanpc(byval userindex as integer, byval npcindex as integer)

if userlist(userindex).flags.privilegios and playertype.consejero then exit sub

if distancia(userlist(userindex).pos, npclist(npcindex).pos) > maxdistanciaarco then
   call writeconsolemsg(userindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
   exit sub
end if

if userlist(userindex).flags.seguro and npclist(npcindex).maestrouser <> 0 then
    if not criminal(npclist(npcindex).maestrouser) then
        call writeconsolemsg(userindex, "debes sacar el seguro antes de poder atacar una mascota de un ciudadano.", fonttypenames.fonttype_warning)
        exit sub
    end if
end if

'para atacar a un npc bueno hay que quitar el seguro
if (npclist(npcindex).stats.alineacion = 0) and userlist(userindex).flags.seguro then
    call writeconsolemsg(userindex, "debes quitar el seguro para atacar estas criaturas.", fonttypenames.fonttype_fight)
    exit sub
end if

if npclist(npcindex).maestrouser > 0 then 'es mascota?
    'es mascota de un caos y vos sos un caos?
    if userlist(npclist(npcindex).maestrouser).faccion.fuerzascaos & userlist(userindex).faccion.fuerzascaos then
        call writeconsolemsg(userindex, "no puedes atacar mascotas de legionarios siendo legionario", fonttypenames.fonttype_warning)
        exit sub
    end if
end if

if userlist(userindex).faccion.armadareal = 1 and npclist(npcindex).maestrouser <> 0 then
    if not criminal(npclist(npcindex).maestrouser) then
        call writeconsolemsg(userindex, "los soldados del ejercito real tienen prohibido atacar ciudadanos y sus macotas.", fonttypenames.fonttype_warning)
        exit sub
    end if
end if

if npclist(npcindex).npctype = enpctype.guardiareal and userlist(userindex).flags.seguro then
    call writeconsolemsg(userindex, "debes quitar el seguro para atacar guardias.", fonttypenames.fonttype_fight)
    exit sub
end if

'revisa que el rey pretoriano no est� solo.
if espretoriano(npcindex) = 4 then
    if npclist(npcindex).pos.x < 50 then
        if pretorianosvivos(1) > 0 then
            call writeconsolemsg(userindex, "debes matar al resto del ejercito antes de atacar al rey!", fonttypenames.fonttype_fight)
            exit sub
        end if
    else
        if pretorianosvivos(2) > 0 then
            call writeconsolemsg(userindex, "debes matar al resto del ejercito antes de atacar al rey!", fonttypenames.fonttype_fight)
            exit sub
        end if
    end if
end if

call npcatacado(npcindex, userindex)

if userimpactonpc(userindex, npcindex) then
    
    if npclist(npcindex).flags.snd2 > 0 then
        call senddata(sendtarget.tonpcarea, npcindex, preparemessageplaywave(npclist(npcindex).flags.snd2))
    else
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_impacto2))
    end if
    
    call userda�onpc(userindex, npcindex)
   
else
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing))
    call writeuserswing(userindex)
end if

end sub

public sub usuarioataca(byval userindex as integer)

'if userlist(userindex).flags.puedeatacar = 1 then
'check bow's interval
if not intervalopermiteusararcos(userindex, false) then exit sub

'check spell-magic interval
if not intervalopermitemagiagolpe(userindex) then
    'check attack interval
    if not intervalopermiteatacar(userindex) then
        exit sub
    end if
end if

'quitamos stamina
if userlist(userindex).stats.minsta >= 10 then
    call quitarsta(userindex, randomnumber(1, 10))
else
    call writeconsolemsg(userindex, "estas muy cansado para luchar.", fonttypenames.fonttype_info)
    exit sub
end if
 
'userlist(userindex).flags.puedeatacar = 0

dim attackpos as worldpos
attackpos = userlist(userindex).pos
call headtopos(userlist(userindex).char.heading, attackpos)
   
'exit if not legal
if attackpos.x < xminmapsize or attackpos.x > xmaxmapsize or attackpos.y <= yminmapsize or attackpos.y > ymaxmapsize then
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing))
    exit sub
end if
    
dim index as integer
index = mapdata(attackpos.map, attackpos.x, attackpos.y).userindex
    
'look for user
if index > 0 then
    call usuarioatacausuario(userindex, index)
    call writeupdateuserstats(userindex)
    call writeupdateuserstats(index)
    exit sub
end if
    
'look for npc
if mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex > 0 then
    
    if npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).attackable then
            
        if npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).maestrouser > 0 and _
            mapinfo(npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).pos.map).pk = false then
                call writeconsolemsg(userindex, "no pod�s atacar mascotas en zonas seguras", fonttypenames.fonttype_fight)
                exit sub
        end if

        call usuarioatacanpc(userindex, mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex)
            
    else
        call writeconsolemsg(userindex, "no pod�s atacar a este npc", fonttypenames.fonttype_fight)
    end if
        
    call writeupdateuserstats(userindex)
        
    exit sub
end if
    
call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_swing))
call writeupdateuserstats(userindex)


if userlist(userindex).counters.trabajando then _
    userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando - 1
    
if userlist(userindex).counters.ocultando then _
    userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando - 1

end sub

public function usuarioimpacto(byval atacanteindex as integer, byval victimaindex as integer) as boolean

dim probrechazo as long
dim rechazo as boolean
dim probexito as long
dim poderataque as long
dim userpoderevasion as long
dim userpoderevasionescudo as long
dim arma as integer
dim proyectil as boolean
dim skilltacticas as long
dim skilldefensa as long

skilltacticas = userlist(victimaindex).stats.userskills(eskill.tacticas)
skilldefensa = userlist(victimaindex).stats.userskills(eskill.defensa)

arma = userlist(atacanteindex).invent.weaponeqpobjindex
if arma > 0 then
    proyectil = objdata(arma).proyectil = 1
else
    proyectil = false
end if

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
    
    if proyectil then
        poderataque = poderataqueproyectil(atacanteindex)
    else
        poderataque = poderataquearma(atacanteindex)
    end if
    probexito = maximo(10, minimo(90, 50 + _
                ((poderataque - userpoderevasion) * 0.4)))
   
else
    poderataque = poderataquewrestling(atacanteindex)
    probexito = maximo(10, minimo(90, 50 + _
                ((poderataque - userpoderevasion) * 0.4)))
    
end if
usuarioimpacto = (randomnumber(1, 100) <= probexito)

' el usuario esta usando un escudo ???
if userlist(victimaindex).invent.escudoeqpobjindex > 0 then
    
    'fallo ???
    if usuarioimpacto = false then
      probrechazo = maximo(10, minimo(90, 100 * (skilldefensa / (skilldefensa + skilltacticas))))
      rechazo = (randomnumber(1, 100) <= probrechazo)
      if rechazo = true then
      'se rechazo el ataque con el escudo
              call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_escudo))
              
              call writeblockedwithshieldother(atacanteindex)
              call writeblockedwithshielduser(victimaindex)
              
              call subirskill(victimaindex, defensa)
      end if
    end if
end if
    
if usuarioimpacto then
   if arma > 0 then
           if not proyectil then
                  call subirskill(atacanteindex, armas)
           else
                  call subirskill(atacanteindex, proyectiles)
           end if
   else
        call subirskill(atacanteindex, wrestling)
   end if
end if

call flushbuffer(victimaindex)
end function

public sub usuarioatacausuario(byval atacanteindex as integer, byval victimaindex as integer)

if not puedeatacar(atacanteindex, victimaindex) then exit sub

if distancia(userlist(atacanteindex).pos, userlist(victimaindex).pos) > maxdistanciaarco then
   call writeconsolemsg(atacanteindex, "est�s muy lejos para disparar.", fonttypenames.fonttype_fight)
   exit sub
end if


call usuarioatacadoporusuario(atacanteindex, victimaindex)

if usuarioimpacto(atacanteindex, victimaindex) then
    call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_impacto))
    
    if userlist(victimaindex).flags.navegando = 0 then
        call senddata(sendtarget.topcarea, victimaindex, preparemessagecreatefx(userlist(victimaindex).char.charindex, fxsangre, 0))
    end if
    
    call userda�ouser(atacanteindex, victimaindex)
    'pablo (toxicwaste): guantes de hurto del bandido en acci�n
    if userlist(atacanteindex).clase = eclass.bandit then call dohurtar(atacanteindex, victimaindex)
    'y ahora, el ladr�n puede llegar a paralizar con el golpe.
    if userlist(atacanteindex).clase = eclass.thief then call dohandinmo(atacanteindex, victimaindex)
    
else
    call senddata(sendtarget.topcarea, atacanteindex, preparemessageplaywave(snd_swing))
    call writeuserswing(atacanteindex)
    call writeuserattackedswing(victimaindex, atacanteindex)
end if

if userlist(atacanteindex).clase = eclass.thief then call desarmar(atacanteindex, victimaindex)

end sub

public sub userda�ouser(byval atacanteindex as integer, byval victimaindex as integer)
dim da�o as long, antda�o as integer
dim lugar as integer, absorbido as long
dim defbarco as integer

dim obj as objdata

da�o = calcularda�o(atacanteindex)
antda�o = da�o

call userenvenena(atacanteindex, victimaindex)

if userlist(atacanteindex).flags.navegando = 1 and userlist(atacanteindex).invent.barcoobjindex > 0 then
     obj = objdata(userlist(atacanteindex).invent.barcoobjindex)
     da�o = da�o + randomnumber(obj.minhit, obj.maxhit)
end if

if userlist(victimaindex).flags.navegando = 1 and userlist(victimaindex).invent.barcoobjindex > 0 then
     obj = objdata(userlist(victimaindex).invent.barcoobjindex)
     defbarco = randomnumber(obj.mindef, obj.maxdef)
end if

dim resist as byte
if userlist(atacanteindex).invent.weaponeqpobjindex > 0 then
    resist = objdata(userlist(atacanteindex).invent.weaponeqpobjindex).refuerzo
end if

lugar = randomnumber(1, 6)

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
call writeuserhittedbyuser(victimaindex, lugar, userlist(atacanteindex).char.charindex, da�o)

userlist(victimaindex).stats.minhp = userlist(victimaindex).stats.minhp - da�o

if userlist(atacanteindex).flags.hambre = 0 and userlist(atacanteindex).flags.sed = 0 then
        'si usa un arma quizas suba "combate con armas"
        if userlist(atacanteindex).invent.weaponeqpobjindex > 0 then
            if objdata(userlist(atacanteindex).invent.weaponeqpobjindex).proyectil then
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
        
        call subirskill(victimaindex, tacticas)
        
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
        if userlist(atacanteindex).mascotasindex(j) > 0 then
            if npclist(userlist(atacanteindex).mascotasindex(j)).target = victimaindex then npclist(userlist(atacanteindex).mascotasindex(j)).target = 0
            call followamo(userlist(atacanteindex).mascotasindex(j))
        end if
    next j
    
    call actstats(victimaindex, atacanteindex)
else
    'est� vivo - actualizamos el hp
    call writeupdatehp(victimaindex)
end if

'controla el nivel del usuario
call checkuserlevel(atacanteindex)

call flushbuffer(victimaindex)
end sub

sub usuarioatacadoporusuario(byval attackerindex as integer, byval victimindex as integer)
'***************************************************
'autor: unknown
'last modification: 03/09/06 nacho
'usuario deja de meditar
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
    
    if not criminal(victimindex) then
        userlist(attackerindex).reputacion.bandidorep = userlist(attackerindex).reputacion.bandidorep + vlasalto
        if userlist(attackerindex).reputacion.bandidorep > maxrep then _
            userlist(attackerindex).reputacion.bandidorep = maxrep
        userlist(attackerindex).reputacion.noblerep = userlist(attackerindex).reputacion.noblerep / 2
        if userlist(attackerindex).reputacion.noblerep < 0 then _
            userlist(attackerindex).reputacion.noblerep = 0
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

    if criminal(attackerindex) then if userlist(attackerindex).faccion.armadareal = 1 then call expulsarfaccionreal(attackerindex)
    
    call allmascotasatacanuser(attackerindex, victimindex)
    call allmascotasatacanuser(victimindex, attackerindex)
    
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
'last modification: 24/01/2007
'returns true if the attackerindex is allowed to attack the victimindex.
'24/01/2007 pablo (toxicwaste) - ordeno todo y agrego situacion de defensa en ciudad armada y caos.
'***************************************************
dim t as etrigger6
dim rank as integer
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
t = triggerzonapelea(attackerindex, victimindex)

if t = etrigger6.trigger6_permite then
    puedeatacar = true
    exit function
elseif t = etrigger6.trigger6_prohibe then
    puedeatacar = false
    exit function
elseif t = etrigger6.trigger6_ausente then
    'si no estamos en el trigger 6 entonces es imposible atacar un gm
    if not userlist(victimindex).flags.privilegios and playertype.user then
        if userlist(victimindex).flags.admininvisible = 0 then call writeconsolemsg(attackerindex, "el ser es demasiado poderoso", fonttypenames.fonttype_warning)
        puedeatacar = false
        exit function
    end if
end if

'consejeros no pueden atacar
'if userlist(attackerindex).flags.privilegios and playertype.consejero then
'    puedeatacar = false
'    exit sub
'end if

'estas queriendo atacar a un gm?
rank = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero

if (userlist(victimindex).flags.privilegios and rank) > (userlist(attackerindex).flags.privilegios and rank) then
    if userlist(victimindex).flags.admininvisible = 0 then call writeconsolemsg(attackerindex, "el ser es demasiado poderoso", fonttypenames.fonttype_warning)
    puedeatacar = false
    exit function
end if

'sos un armada atacando un ciudadano?
if (not criminal(victimindex)) and (esarmada(attackerindex)) then
    call writeconsolemsg(attackerindex, "los soldados del ejercito real tienen prohibido atacar ciudadanos.", fonttypenames.fonttype_warning)
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

end function

public function puedeatacarnpc(byval attackerindex as integer, byval npcindex as integer) as boolean
'***************************************************
'autor: unknown author (original version)
'returns true if attackerindex can attack the npcindex
'last modification: 24/01/2007
'24/01/2007 pablo (toxicwaste) - orden y correcci�n de ataque sobre una mascota y guardias
'***************************************************

'estas muerto?
if userlist(attackerindex).flags.muerto = 1 then
    call writeconsolemsg(attackerindex, "no pod�s atacar porque estas muerto", fonttypenames.fonttype_info)
    puedeatacarnpc = false
    exit function
end if

'es el npc mascota de alguien?
if npclist(npcindex).maestrouser > 0 then
    'de un cudadanos y sos armada?
    if esarmada(attackerindex) and not criminal(npclist(npcindex).maestrouser) then
        call writeconsolemsg(attackerindex, "los armadas no pueden atacar mascotas de ciudadanos. ", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    'de un caos y sos caos?
    if escaos(attackerindex) and escaos(npclist(npcindex).maestrouser) then
        call writeconsolemsg(attackerindex, "los miembros de la legi�n no pueden atacar mascotas de otros legionarios. ", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    
    'de un ciudadano y sos ciudadano?
    if not criminal(attackerindex) and not criminal(npclist(npcindex).maestrouser) then
        'estas con seguro?
        if userlist(attackerindex).flags.seguro then
            call writeconsolemsg(attackerindex, "para atacar mascotas de ciudadanos debes quitar el seguro utilizando /seg", fonttypenames.fonttype_info)
            puedeatacarnpc = false
            exit function
        else
            call volvercriminal(attackerindex)
            puedeatacarnpc = true
            exit function
        end if
    end if
end if

'es guardia caos?
if npclist(npcindex).npctype = enpctype.guardiascaos then
    if escaos(attackerindex) then 'lo quiere atacar un caos?
        call writeconsolemsg(attackerindex, "no puedes atacar guardias del caos siendo legionario", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
end if

'es guardia real?
if npclist(npcindex).npctype = enpctype.guardiareal then
    if esarmada(attackerindex) then 'lo quiere atacar un armada?
        call writeconsolemsg(attackerindex, "no puedes atacar guardias reales siendo armada real", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    end if
    if userlist(attackerindex).flags.seguro then 'tienes el seguro puesto?
        call writeconsolemsg(attackerindex, "debes quitar el seguro para poder atacar guardias reales utilizando /seg", fonttypenames.fonttype_info)
        puedeatacarnpc = false
        exit function
    else
        call volvercriminal(attackerindex)  'si ya era criminal, suma puntos de bandido la funci�n solamente
        puedeatacarnpc = true
        exit function
    end if
end if

'sos consejero? no podes atacar nunca.
if userlist(attackerindex).flags.privilegios and playertype.consejero then
    puedeatacarnpc = false
    exit function
end if

'es el rey preatoriano?
if espretoriano(npcindex) = 4 then
    if npclist(npcindex).pos.x < 50 then
        if pretorianosvivos(1) > 0 then
            call writeconsolemsg(attackerindex, "debes matar al resto del ejercito antes de atacar al rey!", fonttypenames.fonttype_fight)
            puedeatacarnpc = false
            exit function
        end if
    else
        if pretorianosvivos(2) > 0 then
            call writeconsolemsg(attackerindex, "debes matar al resto del ejercito antes de atacar al rey!", fonttypenames.fonttype_fight)
            puedeatacarnpc = false
            exit function
        end if
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
expadar = clng((elda�o) * (npclist(npcindex).giveexp / npclist(npcindex).stats.maxhp))
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
dim armaobjind as integer, objind as integer
dim num as long

armaobjind = userlist(atacanteindex).invent.weaponeqpobjindex
objind = 0

if armaobjind > 0 then
    if objdata(armaobjind).proyectil = 0 then
        objind = armaobjind
    else
        objind = userlist(atacanteindex).invent.municioneqpobjindex
    end if
    
    if objind > 0 then
        if (objdata(objind).envenena = 1) then
            num = randomnumber(1, 100)
            
            if num < 60 then
                userlist(victimaindex).flags.envenenado = 1
                call writeconsolemsg(victimaindex, userlist(atacanteindex).name & " te ha envenenado!!", fonttypenames.fonttype_fight)
                call writeconsolemsg(atacanteindex, "has envenenado a " & userlist(victimaindex).name & "!!", fonttypenames.fonttype_fight)
            end if
        end if
    end if
end if

call flushbuffer(victimaindex)
end sub
