attribute vb_name = "sistemacombate"
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
'
'dise�o y correcci�n del modulo de combate por
'gerardo saiz, gerardosaiz@yahoo.com
'

option explicit

public const maxdistanciaarco as byte = 18
public const maxdistanciamagia as byte = 18

function modificadorevasion(byval clase as string) as single

select case ucase$(clase)
    case "guerrero"
        modificadorevasion = 1
    case "cazador"
        modificadorevasion = 0.9
    case "paladin"
        modificadorevasion = 0.9
    case "bandido"
        modificadorevasion = 0.9
    case "asesino"
        modificadorevasion = 1.1
    case "pirata"
        modificadorevasion = 0.9
    case "ladron"
        modificadorevasion = 1.1
    case "bardo"
        modificadorevasion = 1.1
    case else
        modificadorevasion = 0.8
end select
end function

function modificadorpoderataquearmas(byval clase as string) as single
select case ucase$(clase)
    case "guerrero"
        modificadorpoderataquearmas = 1
    case "cazador"
        modificadorpoderataquearmas = 0.8
    case "paladin"
        modificadorpoderataquearmas = 0.85
    case "asesino"
        modificadorpoderataquearmas = 0.85
    case "pirata"
        modificadorpoderataquearmas = 0.8
    case "ladron"
        modificadorpoderataquearmas = 0.75
    case "bandido"
        modificadorpoderataquearmas = 0.75
    case "clerigo"
        modificadorpoderataquearmas = 0.7
    case "bardo"
        modificadorpoderataquearmas = 0.7
    case "druida"
        modificadorpoderataquearmas = 0.7
    case "pescador"
        modificadorpoderataquearmas = 0.6
    case "le�ador"
        modificadorpoderataquearmas = 0.6
    case "minero"
        modificadorpoderataquearmas = 0.6
    case "herrero"
        modificadorpoderataquearmas = 0.6
    case "carpintero"
        modificadorpoderataquearmas = 0.6
    case else
        modificadorpoderataquearmas = 0.5
end select
end function

function modificadorpoderataqueproyectiles(byval clase as string) as single
select case ucase$(clase)
    case "guerrero"
        modificadorpoderataqueproyectiles = 0.8
    case "cazador"
        modificadorpoderataqueproyectiles = 1
    case "paladin"
        modificadorpoderataqueproyectiles = 0.75
    case "asesino"
        modificadorpoderataqueproyectiles = 0.75
    case "pirata"
        modificadorpoderataqueproyectiles = 0.75
    case "ladron"
        modificadorpoderataqueproyectiles = 0.8
    case "bandido"
        modificadorpoderataqueproyectiles = 0.8
    case "clerigo"
        modificadorpoderataqueproyectiles = 0.7
    case "bardo"
        modificadorpoderataqueproyectiles = 0.7
    case "druida"
        modificadorpoderataqueproyectiles = 0.75
    case "pescador"
        modificadorpoderataqueproyectiles = 0.65
    case "le�ador"
        modificadorpoderataqueproyectiles = 0.7
    case "minero"
        modificadorpoderataqueproyectiles = 0.65
    case "herrero"
        modificadorpoderataqueproyectiles = 0.65
    case "carpintero"
        modificadorpoderataqueproyectiles = 0.7
    case else
        modificadorpoderataqueproyectiles = 0.5
end select
end function

function modicadorda�oclasearmas(byval clase as string) as single
select case ucase$(clase)
    case "guerrero"
        modicadorda�oclasearmas = 1.1
    case "cazador"
        modicadorda�oclasearmas = 0.9
    case "paladin"
        modicadorda�oclasearmas = 0.9
    case "asesino"
        modicadorda�oclasearmas = 0.9
    case "ladron"
        modicadorda�oclasearmas = 0.8
    case "pirata"
        modicadorda�oclasearmas = 0.8
    case "bandido"
        modicadorda�oclasearmas = 0.8
    case "clerigo"
        modicadorda�oclasearmas = 0.8
    case "bardo"
        modicadorda�oclasearmas = 0.75
    case "druida"
        modicadorda�oclasearmas = 0.75
    case "pescador"
        modicadorda�oclasearmas = 0.6
    case "le�ador"
        modicadorda�oclasearmas = 0.7
    case "minero"
        modicadorda�oclasearmas = 0.75
    case "herrero"
        modicadorda�oclasearmas = 0.75
    case "carpintero"
        modicadorda�oclasearmas = 0.7
    case else
        modicadorda�oclasearmas = 0.5
end select
end function

function modicadorda�oclaseproyectiles(byval clase as string) as single
select case ucase$(clase)
    case "guerrero"
        modicadorda�oclaseproyectiles = 1
    case "cazador"
        modicadorda�oclaseproyectiles = 1.1
    case "paladin"
        modicadorda�oclaseproyectiles = 0.8
    case "asesino"
        modicadorda�oclaseproyectiles = 0.8
    case "ladron"
        modicadorda�oclaseproyectiles = 0.75
    case "pirata"
        modicadorda�oclaseproyectiles = 0.75
    case "bandido"
        modicadorda�oclaseproyectiles = 0.75
    case "clerigo"
        modicadorda�oclaseproyectiles = 0.7
    case "bardo"
        modicadorda�oclaseproyectiles = 0.7
    case "druida"
        modicadorda�oclaseproyectiles = 0.75
    case "pescador"
        modicadorda�oclaseproyectiles = 0.6
    case "le�ador"
        modicadorda�oclaseproyectiles = 0.7
    case "minero"
        modicadorda�oclaseproyectiles = 0.6
    case "herrero"
        modicadorda�oclaseproyectiles = 0.6
    case "carpintero"
        modicadorda�oclaseproyectiles = 0.7
    case else
        modicadorda�oclaseproyectiles = 0.5
end select
end function

function modevasiondeescudoclase(byval clase as string) as single

select case ucase$(clase)
case "guerrero"
        modevasiondeescudoclase = 1
    case "cazador"
        modevasiondeescudoclase = 0.8
    case "paladin"
        modevasiondeescudoclase = 1
    case "asesino"
        modevasiondeescudoclase = 0.8
    case "ladron"
        modevasiondeescudoclase = 0.7
    case "bandido"
        modevasiondeescudoclase = 0.8
    case "pirata"
        modevasiondeescudoclase = 0.75
    case "clerigo"
        modevasiondeescudoclase = 0.85
    case "bardo"
        modevasiondeescudoclase = 0.75
    case "druida"
        modevasiondeescudoclase = 0.75
    case "pescador"
        modevasiondeescudoclase = 0.7
    case "le�ador"
        modevasiondeescudoclase = 0.7
    case "minero"
        modevasiondeescudoclase = 0.7
    case "herrero"
        modevasiondeescudoclase = 0.7
    case "carpintero"
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
       
        poderevasion = (ltemp + (2.5 * maximo(.stats.elv - 12, 0)))
    end with
end function



'function poderevasion(byval userindex as integer) as long
'dim poderevasiontemp as long

'if userlist(userindex).stats.userskills(eskill.tacticas) < 31 then
'    poderevasiontemp = (userlist(userindex).stats.userskills(eskill.tacticas) * _
'    modificadorevasion(userlist(userindex).clase))
'elseif userlist(userindex).stats.userskills(eskill.tacticas) < 61 then
'        poderevasiontemp = ((userlist(userindex).stats.userskills(eskill.tacticas) + _
'        userlist(userindex).stats.useratributos(eatributos.agilidad)) * _
'        modificadorevasion(userlist(userindex).clase))
'elseif userlist(userindex).stats.userskills(eskill.tacticas) < 91 then
'        poderevasiontemp = ((userlist(userindex).stats.userskills(eskill.tacticas) + _
'        (2 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
'        modificadorevasion(userlist(userindex).clase))
'else
'        poderevasiontemp = ((userlist(userindex).stats.userskills(eskill.tacticas) + _
'        (3 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
'        modificadorevasion(userlist(userindex).clase))
'end if
'poderevasion = (poderevasiontemp + (2.5 * maximo(userlist(userindex).stats.elv - 12, 0)))
'
'end function
'
'
'



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

poderataquearma = (poderataquetemp + (2.5 * maximo(userlist(userindex).stats.elv - 12, 0)))
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

poderataqueproyectil = (poderataquetemp + (2.5 * maximo(userlist(userindex).stats.elv - 12, 0)))

end function

function poderataquewresterling(byval userindex as integer) as long
dim poderataquetemp as long

if userlist(userindex).stats.userskills(eskill.wresterling) < 31 then
    poderataquetemp = (userlist(userindex).stats.userskills(eskill.wresterling) * _
    modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.wresterling) < 61 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wresterling) + _
        userlist(userindex).stats.useratributos(eatributos.agilidad)) * _
        modificadorpoderataquearmas(userlist(userindex).clase))
elseif userlist(userindex).stats.userskills(eskill.wresterling) < 91 then
        poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wresterling) + _
        (2 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
        modificadorpoderataquearmas(userlist(userindex).clase))
else
       poderataquetemp = ((userlist(userindex).stats.userskills(eskill.wresterling) + _
       (3 * userlist(userindex).stats.useratributos(eatributos.agilidad))) * _
       modificadorpoderataquearmas(userlist(userindex).clase))
end if

poderataquewresterling = (poderataquetemp + (2.5 * maximo(userlist(userindex).stats.elv - 12, 0)))

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
    poderataque = poderataquewresterling(userindex)
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
        call subirskill(userindex, wresterling)
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
                call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_escudo)
                call senddata(sendtarget.toindex, userindex, 0, "7")
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
    calcularda�o = cint(userlist(userindex).stats.maxhit / 5)
    exit function
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
if userlist(userindex).flags.navegando = 1 then _
        da�o = da�o + randomnumber(objdata(userlist(userindex).invent.barcoobjindex).minhit, objdata(userlist(userindex).invent.barcoobjindex).maxhit)

da�o = da�o - npclist(npcindex).stats.def

if da�o < 0 then da�o = 0

'[kevin]
call senddata(sendtarget.toindex, userindex, 0, "u2" & da�o)
call calculardarexp(userindex, npcindex, da�o)
npclist(npcindex).stats.minhp = npclist(npcindex).stats.minhp - da�o
'[/kevin]

if npclist(npcindex).stats.minhp > 0 then
    'trata de apu�alar por la espalda al enemigo
    if puedeapu�alar(userindex) then
       call doapu�alar(userindex, npcindex, 0, da�o)
       call subirskill(userindex, apu�alar)
    end if
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

if userlist(userindex).flags.navegando = 1 then
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
           obj = objdata(userlist(userindex).invent.armoureqpobjindex)
           absorbido = randomnumber(obj.mindef, obj.maxdef)
           absorbido = absorbido + defbarco
           da�o = da�o - absorbido
           if da�o < 1 then da�o = 1
        end if
end select

call senddata(sendtarget.toindex, userindex, 0, "n2" & lugar & "," & da�o)

if userlist(userindex).flags.privilegios = playertype.user then userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - da�o

'muere el usuario
if userlist(userindex).stats.minhp <= 0 then

    call senddata(sendtarget.toindex, userindex, 0, "6") ' le informamos que ha muerto ;)
    
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
                    npclist(npcindex).flags.attackedby = ""
        end if
    end if
    
    call userdie(userindex)

end if

end sub

public sub restarcriminalidad(byval userindex as integer)
    'if userlist(userindex).reputacion.asesinorep > 0 then
    '     userlist(userindex).reputacion.asesinorep = userlist(userindex).reputacion.asesinorep - vlasesino
    '     if userlist(userindex).reputacion.asesinorep < 0 then userlist(userindex).reputacion.asesinorep = 0
    'else
    if userlist(userindex).reputacion.bandidorep > 0 then
         userlist(userindex).reputacion.bandidorep = userlist(userindex).reputacion.bandidorep - vlasalto
         if userlist(userindex).reputacion.bandidorep < 0 then userlist(userindex).reputacion.bandidorep = 0
    elseif userlist(userindex).reputacion.ladronesrep > 0 then
         userlist(userindex).reputacion.ladronesrep = userlist(userindex).reputacion.ladronesrep - (vlcazador * 10)
         if userlist(userindex).reputacion.ladronesrep < 0 then userlist(userindex).reputacion.ladronesrep = 0
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

if npclist(npcindex).flags.snd1 > 0 then call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & npclist(npcindex).flags.snd1)

if npcimpacto(npcindex, userindex) then
    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_impacto)
    
    if userlist(userindex).flags.meditando = false then
        if userlist(userindex).flags.navegando = 0 then call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxsangre & "," & 0)
    end if
    
    call npcda�o(npcindex, userindex)
    call senddata(sendtarget.toindex, userindex, 0, "ash" & userlist(userindex).stats.minhp)
    '�puede envenenar?
    if npclist(npcindex).veneno = 1 then call npcenvenenaruser(userindex)
else
    call senddata(sendtarget.toindex, userindex, 0, "n1")
end if



'-----tal vez suba los skills------
call subirskill(userindex, tacticas)

'call senduserstatsbox(userindex)
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
        
        if npclist(atacante).flags.attackedby <> "" then
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

if npclist(atacante).flags.snd1 > 0 then call senddata(sendtarget.tonpcarea, atacante, npclist(atacante).pos.map, "tw" & npclist(atacante).flags.snd1)

if npcimpactonpc(atacante, victima) then
    
    if npclist(victima).flags.snd2 > 0 then
        call senddata(sendtarget.tonpcarea, victima, npclist(victima).pos.map, "tw" & npclist(victima).flags.snd2)
    else
        call senddata(sendtarget.tonpcarea, victima, npclist(victima).pos.map, "tw" & snd_impacto2)
    end if

    if npclist(atacante).maestrouser > 0 then
        call senddata(sendtarget.tonpcarea, atacante, npclist(atacante).pos.map, "tw" & snd_impacto)
    else
        call senddata(sendtarget.tonpcarea, victima, npclist(victima).pos.map, "tw" & snd_impacto)
    end if
    call npcda�onpc(atacante, victima)
    
else
    if npclist(atacante).maestrouser > 0 then
        call senddata(sendtarget.tonpcarea, atacante, npclist(atacante).pos.map, "tw" & snd_swing)
    else
        call senddata(sendtarget.tonpcarea, victima, npclist(victima).pos.map, "tw" & snd_swing)
    end if
end if

end sub

public sub usuarioatacanpc(byval userindex as integer, byval npcindex as integer)

if userlist(userindex).flags.privilegios = playertype.consejero then exit sub

if distancia(userlist(userindex).pos, npclist(npcindex).pos) > maxdistanciaarco then
   call senddata(sendtarget.toindex, userindex, 0, "||est�s muy lejos para disparar." & fonttype_fight)
   exit sub
end if

if userlist(userindex).flags.seguro and npclist(npcindex).maestrouser <> 0 then
    if not criminal(npclist(npcindex).maestrouser) then
        call senddata(sendtarget.toindex, userindex, 0, "||debes sacar el seguro antes de poder atacar una mascota de un ciudadano." & fonttype_warning)
        exit sub
    end if
end if

if userlist(userindex).faccion.armadareal = 1 and npclist(npcindex).maestrouser <> 0 then
    if not criminal(npclist(npcindex).maestrouser) then
        call senddata(sendtarget.toindex, userindex, 0, "||los soldados del ejercito real tienen prohibido atacar ciudadanos y sus macotas." & fonttype_warning)
        exit sub
    end if
end if

if npclist(npcindex).npctype = enpctype.guardiareal and userlist(userindex).flags.seguro then
    call senddata(sendtarget.toindex, userindex, 0, "||debes quitar el seguro para atacar guardias." & fonttype_fight)
    exit sub
end if


call npcatacado(npcindex, userindex)

if userimpactonpc(userindex, npcindex) then
    
    if npclist(npcindex).flags.snd2 > 0 then
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & npclist(npcindex).flags.snd2)
    else
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_impacto2)
    end if
    
    call userda�onpc(userindex, npcindex)
   
else
    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_swing)
    call senddata(sendtarget.toindex, userindex, 0, "u1")
end if

end sub

public sub usuarioataca(byval userindex as integer)

'if userlist(userindex).flags.puedeatacar = 1 then
if intervalopermiteatacar(userindex) then
    
    'quitamos stamina
    if userlist(userindex).stats.minsta >= 10 then
        call quitarsta(userindex, randomnumber(1, 10))
    else
        call senddata(sendtarget.toindex, userindex, 0, "||estas muy cansado para luchar." & fonttype_info)
        exit sub
    end if
    
    'userlist(userindex).flags.puedeatacar = 0
    
    dim attackpos as worldpos
    attackpos = userlist(userindex).pos
    call headtopos(userlist(userindex).char.heading, attackpos)
    
    'exit if not legal
    if attackpos.x < xminmapsize or attackpos.x > xmaxmapsize or attackpos.y <= yminmapsize or attackpos.y > ymaxmapsize then
        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_swing)
        exit sub
    end if
    
    dim index as integer
    index = mapdata(attackpos.map, attackpos.x, attackpos.y).userindex
        
    'look for user
    if index > 0 then
        call usuarioatacausuario(userindex, mapdata(attackpos.map, attackpos.x, attackpos.y).userindex)
        call senduserstatsbox(userindex)
        call senduserstatsbox(mapdata(attackpos.map, attackpos.x, attackpos.y).userindex)
        exit sub
    end if
    
    'look for npc
    if mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex > 0 then
    
        if npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).attackable then
            
            if npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).maestrouser > 0 and _
               mapinfo(npclist(mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex).pos.map).pk = false then
                    call senddata(sendtarget.toindex, userindex, 0, "||no pod�s atacar mascotas en zonas seguras" & fonttype_fight)
                    exit sub
            end if

            call usuarioatacanpc(userindex, mapdata(attackpos.map, attackpos.x, attackpos.y).npcindex)
            
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no pod�s atacar a este npc" & fonttype_fight)
        end if
        
        call senduserstatsbox(userindex)
        
        exit sub
    end if
    
    
    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_swing)
    call senduserstatsbox(userindex)
end if

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
    poderataque = poderataquewresterling(atacanteindex)
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
              call senddata(sendtarget.topcarea, atacanteindex, userlist(atacanteindex).pos.map, "tw" & snd_escudo)
              call senddata(sendtarget.toindex, atacanteindex, 0, "8")
              call senddata(sendtarget.toindex, victimaindex, 0, "7")
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
        call subirskill(atacanteindex, wresterling)
   end if
end if

end function

public sub usuarioatacausuario(byval atacanteindex as integer, byval victimaindex as integer)

if not puedeatacar(atacanteindex, victimaindex) then exit sub

if distancia(userlist(atacanteindex).pos, userlist(victimaindex).pos) > maxdistanciaarco then
   call senddata(sendtarget.toindex, atacanteindex, 0, "||est�s muy lejos para disparar." & fonttype_fight)
   exit sub
end if


call usuarioatacadoporusuario(atacanteindex, victimaindex)

if usuarioimpacto(atacanteindex, victimaindex) then
    call senddata(sendtarget.topcarea, atacanteindex, userlist(atacanteindex).pos.map, "tw" & snd_impacto)
    
    if userlist(victimaindex).flags.navegando = 0 then call senddata(sendtarget.topcarea, victimaindex, userlist(victimaindex).pos.map, "cfx" & userlist(victimaindex).char.charindex & "," & fxsangre & "," & 0)
    
    call userda�ouser(atacanteindex, victimaindex)
else
    call senddata(sendtarget.topcarea, atacanteindex, userlist(atacanteindex).pos.map, "tw" & snd_swing)
    call senddata(sendtarget.toindex, atacanteindex, 0, "u1")
    call senddata(sendtarget.toindex, victimaindex, 0, "u3" & userlist(atacanteindex).name)
end if

if ucase$(userlist(atacanteindex).clase) = "ladron" then call desarmar(atacanteindex, victimaindex)

end sub

public sub userda�ouser(byval atacanteindex as integer, byval victimaindex as integer)
dim da�o as long, antda�o as integer
dim lugar as integer, absorbido as long
dim defbarco as integer

dim obj as objdata

da�o = calcularda�o(atacanteindex)
antda�o = da�o

call userenvenena(atacanteindex, victimaindex)

if userlist(atacanteindex).flags.navegando = 1 then
     obj = objdata(userlist(atacanteindex).invent.barcoobjindex)
     da�o = da�o + randomnumber(obj.minhit, obj.maxhit)
end if

if userlist(victimaindex).flags.navegando = 1 then
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
           absorbido = randomnumber(obj.mindef, obj.maxdef)
           absorbido = absorbido + defbarco - resist
           da�o = da�o - absorbido
           if da�o < 0 then da�o = 1
        end if
end select

call senddata(sendtarget.toindex, atacanteindex, 0, "n5" & lugar & "," & da�o & "," & userlist(victimaindex).name)
call senddata(sendtarget.toindex, victimaindex, 0, "n4" & lugar & "," & da�o & "," & userlist(atacanteindex).name)

userlist(victimaindex).stats.minhp = userlist(victimaindex).stats.minhp - da�o

if userlist(atacanteindex).flags.hambre = 0 and userlist(atacanteindex).flags.sed = 0 then
        'si usa un arma quizas suba "combate con armas"
        if userlist(atacanteindex).invent.weaponeqpobjindex > 0 then
                call subirskill(atacanteindex, armas)
        else
        'sino tal vez lucha libre
                call subirskill(atacanteindex, wresterling)
        end if
        
        call subirskill(atacanteindex, tacticas)
        
        'trata de apu�alar por la espalda al enemigo
        if puedeapu�alar(atacanteindex) then
                call doapu�alar(atacanteindex, 0, victimaindex, da�o)
                call subirskill(atacanteindex, apu�alar)
        end if
end if


if userlist(victimaindex).stats.minhp <= 0 then
    
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
    call senddata(sendtarget.toindex, victimaindex, 0, "ash" & userlist(victimaindex).stats.minhp)
end if

'controla el nivel del usuario
call checkuserlevel(atacanteindex)

end sub

sub usuarioatacadoporusuario(byval attackerindex as integer, byval victimindex as integer)
    if triggerzonapelea(attackerindex, victimindex) = trigger6_permite then exit sub

    if not criminal(attackerindex) and not criminal(victimindex) then
        call volvercriminal(attackerindex)
    end if
    
    if not criminal(victimindex) then
        userlist(attackerindex).reputacion.bandidorep = userlist(attackerindex).reputacion.bandidorep + vlasalto
        if userlist(attackerindex).reputacion.bandidorep > maxrep then _
            userlist(attackerindex).reputacion.bandidorep = maxrep
    else
        userlist(attackerindex).reputacion.noblerep = userlist(attackerindex).reputacion.noblerep + vlnoble
        if userlist(attackerindex).reputacion.noblerep > maxrep then _
            userlist(attackerindex).reputacion.noblerep = maxrep
    end if
    
    call allmascotasatacanuser(attackerindex, victimindex)
    call allmascotasatacanuser(victimindex, attackerindex)
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

dim t as etrigger6

if userlist(victimindex).flags.muerto = 1 then
    senddata sendtarget.toindex, attackerindex, 0, "||no podes atacar a un espiritu" & fonttype_info
    puedeatacar = false
    exit function
end if

t = triggerzonapelea(attackerindex, victimindex)

if t = trigger6_permite then
    puedeatacar = true
    exit function
elseif t = trigger6_prohibe then
    puedeatacar = false
    exit function
end if


if mapinfo(userlist(victimindex).pos.map).pk = false then
    call senddata(sendtarget.toindex, attackerindex, 0, "||esta es una zona segura, aqui no podes atacar otros usuarios." & fonttype_warning)
    puedeatacar = false
    exit function
end if

if mapdata(userlist(victimindex).pos.map, userlist(victimindex).pos.x, userlist(victimindex).pos.y).trigger = etrigger.zonasegura or _
    mapdata(userlist(attackerindex).pos.map, userlist(attackerindex).pos.x, userlist(attackerindex).pos.y).trigger = etrigger.zonasegura then
    call senddata(sendtarget.toindex, attackerindex, 0, "||no podes pelear aqui." & fonttype_warning)
    puedeatacar = false
    exit function
end if

if (not criminal(victimindex)) and (userlist(attackerindex).faccion.armadareal = 1) then
    call senddata(sendtarget.toindex, attackerindex, 0, "||los soldados del ejercito real tienen prohibido atacar ciudadanos." & fonttype_warning)
    puedeatacar = false
    exit function
end if

'[barrin 17-12-03]
if (userlist(victimindex).faccion.fuerzascaos = 1) and (userlist(attackerindex).faccion.fuerzascaos = 1) then
    call senddata(sendtarget.toindex, attackerindex, 0, "||los miembros de la legi�n oscura tienen prohibido atacarse entre s�." & fonttype_warning)
    puedeatacar = false
    exit function
end if
'[/barrin]

if userlist(attackerindex).flags.privilegios = playertype.consejero then
    puedeatacar = false
    exit function
end if

'se asegura que la victima no es un gm
if userlist(victimindex).flags.privilegios >= playertype.consejero then
    senddata sendtarget.toindex, attackerindex, 0, "||��no podes atacar a los administradores del juego!! " & fonttype_warning
    puedeatacar = false
    exit function
end if

if userlist(attackerindex).flags.muerto = 1 then
    senddata sendtarget.toindex, attackerindex, 0, "||no podes atacar porque estas muerto" & fonttype_info
    puedeatacar = false
    exit function
end if

if userlist(attackerindex).flags.seguro then
        if not criminal(victimindex) then
                call senddata(sendtarget.toindex, attackerindex, 0, "||no podes atacar ciudadanos, para hacerlo debes desactivar el seguro apretando la tecla s" & fonttype_fight)
                exit function
        end if
end if
   

puedeatacar = true

end function


public function puedeatacarnpc(byval attackerindex as integer, byval npcindex as integer) as boolean

if npclist(npcindex).maestrouser > 0 then
    if not criminal(attackerindex) and not criminal(npclist(npcindex).maestrouser) then
        if userlist(attackerindex).flags.seguro then
            call senddata(sendtarget.toindex, attackerindex, 0, "||para atacar mascotas de ciudadanos debes quitarte el seguro" & fonttype_fight)
            puedeatacarnpc = false
            exit function
        end if
    end if
end if

if userlist(attackerindex).flags.muerto = 1 then
    senddata sendtarget.toindex, attackerindex, 0, "||no podes atacar porque estas muerto" & fonttype_info
    puedeatacarnpc = false
    exit function
end if

if userlist(attackerindex).flags.privilegios = playertype.consejero then
    puedeatacarnpc = false
    exit function
end if


puedeatacarnpc = true

end function


'[kevin]
'
'[alejo]
'modifique un poco el sistema de exp por golpe, ahora
'son 2/3 de la exp mientras esta vivo, el resto se
'obtiene al matarlo.
'ahora adem�s
sub calculardarexp(byval userindex as integer, byval npcindex as integer, byval elda�o as long)

dim expsinmorir as long
dim expadar as long
dim totalnpcvida as long

if elda�o <= 0 then elda�o = 0

'2/3 de la experiencia se dan cuando se le golpea, el resto
'se obtiene al matarlo
expsinmorir = (2 * npclist(npcindex).giveexp) / 3

totalnpcvida = npclist(npcindex).stats.maxhp
if totalnpcvida <= 0 then exit sub

if elda�o > npclist(npcindex).stats.minhp then elda�o = npclist(npcindex).stats.minhp

'totalnpcvida _____ expsinmorir
'da�o         _____ (da�o * expsinmorir) / totalnpcvida

expadar = clng((elda�o) * (expsinmorir / totalnpcvida))
if expadar <= 0 then exit sub

if expadar > npclist(npcindex).flags.expcount then
    expadar = npclist(npcindex).flags.expcount
    npclist(npcindex).flags.expcount = 0
else
    npclist(npcindex).flags.expcount = npclist(npcindex).flags.expcount - expadar
end if

if expadar > 0 then
    if userlist(userindex).partyindex > 0 then
        call mdparty.obtenerexito(userindex, expadar, npclist(npcindex).pos.map, npclist(npcindex).pos.x, npclist(npcindex).pos.y)
    else
        userlist(userindex).stats.exp = userlist(userindex).stats.exp + expadar
        if userlist(userindex).stats.exp > maxexp then _
            userlist(userindex).stats.exp = maxexp
        call senddata(sendtarget.toindex, userindex, 0, "||has ganado " & expadar & " puntos de experiencia." & fonttype_fight)
    end if
    
    call checkuserlevel(userindex)
end if

'[/kevin]
end sub

public function triggerzonapelea(byval origen as integer, byval destino as integer) as etrigger6

if origen > 0 and destino > 0 and origen <= ubound(userlist) and destino <= ubound(userlist) then
    if mapdata(userlist(origen).pos.map, userlist(origen).pos.x, userlist(origen).pos.y).trigger = etrigger.zonapelea or _
        mapdata(userlist(destino).pos.map, userlist(destino).pos.x, userlist(destino).pos.y).trigger = etrigger.zonapelea then
        if (mapdata(userlist(origen).pos.map, userlist(origen).pos.x, userlist(origen).pos.y).trigger = mapdata(userlist(destino).pos.map, userlist(destino).pos.x, userlist(destino).pos.y).trigger) then
            triggerzonapelea = trigger6_permite
        else
            triggerzonapelea = trigger6_prohibe
        end if
    else
        triggerzonapelea = trigger6_ausente
    end if
else
    triggerzonapelea = trigger6_ausente
end if

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
                call senddata(sendtarget.toindex, victimaindex, 0, "||" & userlist(atacanteindex).name & " te ha envenenado!!" & fonttype_fight)
                call senddata(sendtarget.toindex, atacanteindex, 0, "||has envenenado a " & userlist(victimaindex).name & "!!" & fonttype_fight)
            end if
        end if
    end if
end if

end sub
