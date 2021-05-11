attribute vb_name = "modfacciones"
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

public armaduraimperial1 as integer 'primer jerarquia
public armaduraimperial2 as integer 'segunda jerarqu�a
public armaduraimperial3 as integer 'enanos
public tunicamagoimperial as integer 'magos
public tunicamagoimperialenanos as integer 'magos

public vestimentaimperialhumano as integer
public vestimentaimperialenano as integer
public tunicaconspicuahumano as integer
public tunicaconspicuaenano as integer
public armaduranobilisimahumano as integer
public armaduranobilisimaenano as integer
public armaduragransacerdote as integer

public vestimentalegionhumano as integer
public vestimentalegionenano as integer
public tunicalobregahumano as integer
public tunicalobregaenano as integer
public tunicaegregiahumano as integer
public tunicaegregiaenano as integer
public sacerdotedemoniaco as integer

public armaduracaos1 as integer
public tunicamagocaos as integer
public tunicamagocaosenanos as integer
public armaduracaos2 as integer
public armaduracaos3 as integer

public const expalunirse as long = 50000
public const expx100 as integer = 5000


public sub enlistararmadareal(byval userindex as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'handles the entrance of users to the "armada real"
'***************************************************
if userlist(userindex).faccion.armadareal = 1 then
    call writechatoverhead(userindex, "���ya perteneces a las tropas reales!!! ve a combatir criminales", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.fuerzascaos = 1 then
    call writechatoverhead(userindex, "���maldito insolente!!! vete de aqui seguidor de las sombras", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if criminal(userindex) then
    call writechatoverhead(userindex, "���no se permiten criminales en el ejercito imperial!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.criminalesmatados < 30 then
    call writechatoverhead(userindex, "para unirte a nuestras fuerzas debes matar al menos 30 criminales, solo has matado " & userlist(userindex).faccion.criminalesmatados, str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).stats.elv < 25 then
    call writechatoverhead(userindex, "���para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if
 
if userlist(userindex).faccion.ciudadanosmatados > 0 then
    call writechatoverhead(userindex, "�has asesinado gente inocente, no aceptamos asesinos en las tropas reales!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.reenlistadas > 4 then
    call writechatoverhead(userindex, "�has sido expulsado de las fuerzas reales demasiadas veces!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).reputacion.noblerep < 1000000 then
    call writechatoverhead(userindex, "necesitas ser a�n m�s noble para integrar el ejercito del rey, solo tienes " & userlist(userindex).reputacion.noblerep & "/1.000.000 puntos de nobleza", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

userlist(userindex).faccion.armadareal = 1
userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas + 1

call writechatoverhead(userindex, "���bienvenido al ejercito imperial!!!, aqui tienes tus vestimentas. cumple bien tu labor exterminando criminales y me encargar� de recompensarte.", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)

if userlist(userindex).faccion.recibioarmadurareal = 0 then
    dim miobj as obj
    dim miobj2 as obj
    miobj.amount = 20
    miobj2.amount = 10
        
    if userlist(userindex).raza = eraza.enano or userlist(userindex).raza = eraza.gnomo then
        miobj.objindex = vestimentaimperialenano
        select case userlist(userindex).clase
            case eclass.mage
                miobj2.objindex = tunicaconspicuaenano
            case else
                miobj2.objindex = armaduranobilisimaenano
        end select
    else
        miobj.objindex = vestimentaimperialhumano
        select case userlist(userindex).clase
            case eclass.mage
                miobj2.objindex = tunicaconspicuahumano
            case eclass.cleric, eclass.druid, eclass.bard
                miobj2.objindex = armaduragransacerdote
            case else
                miobj2.objindex = armaduranobilisimahumano
        end select
    end if
    
    if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    if not meteritemeninventario(userindex, miobj2) then
            call tiraritemalpiso(userlist(userindex).pos, miobj2)
    end if
    
    userlist(userindex).faccion.recibioarmadurareal = 1
    userlist(userindex).faccion.nivelingreso = userlist(userindex).stats.elv
    userlist(userindex).faccion.fechaingreso = date
    'esto por ahora es in�til, siempre va a ser cero, pero bueno, despues va a servir.
    userlist(userindex).faccion.matadosingreso = userlist(userindex).faccion.ciudadanosmatados

end if

if userlist(userindex).faccion.recibioexpinicialreal = 0 then
    userlist(userindex).stats.exp = userlist(userindex).stats.exp + expalunirse
    if userlist(userindex).stats.exp > maxexp then _
        userlist(userindex).stats.exp = maxexp
    call writeconsolemsg(userindex, "has ganado " & expalunirse & " puntos de experiencia.", fonttypenames.fonttype_fight)
    userlist(userindex).faccion.recibioexpinicialreal = 1
    userlist(userindex).faccion.recompensasreal = 0
    userlist(userindex).faccion.nextrecompensa = 70
    call checkuserlevel(userindex)
end if


call logejercitoreal(userlist(userindex).name & " ingres� el " & date & " cuando era nivel " & userlist(userindex).stats.elv)

end sub

public sub recompensaarmadareal(byval userindex as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'handles the way of gaining new ranks in the "armada real"
'***************************************************
dim crimis as long
dim lvl as byte
dim nextrecom as long
dim nobleza as long
lvl = userlist(userindex).stats.elv
crimis = userlist(userindex).faccion.criminalesmatados
nextrecom = userlist(userindex).faccion.nextrecompensa
nobleza = userlist(userindex).reputacion.noblerep

if crimis < nextrecom then
    call writechatoverhead(userindex, "mata " & nextrecom - crimis & " criminales m�s para recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

select case nextrecom
    case 70:
        userlist(userindex).faccion.recompensasreal = 1
        userlist(userindex).faccion.nextrecompensa = 130
    
    case 130:
        userlist(userindex).faccion.recompensasreal = 2
        userlist(userindex).faccion.nextrecompensa = 210
    
    case 210:
        userlist(userindex).faccion.recompensasreal = 3
        userlist(userindex).faccion.nextrecompensa = 320
    
    case 320:
        userlist(userindex).faccion.recompensasreal = 4
        userlist(userindex).faccion.nextrecompensa = 460
    
    case 460:
        userlist(userindex).faccion.recompensasreal = 5
        userlist(userindex).faccion.nextrecompensa = 640
    
    case 640:
        if lvl < 27 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 27 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 6
        userlist(userindex).faccion.nextrecompensa = 870
    
    case 870:
        userlist(userindex).faccion.recompensasreal = 7
        userlist(userindex).faccion.nextrecompensa = 1160
    
    case 1160:
        userlist(userindex).faccion.recompensasreal = 8
        userlist(userindex).faccion.nextrecompensa = 2000
    
    case 2000:
        if lvl < 30 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 30 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 9
        userlist(userindex).faccion.nextrecompensa = 2500
    
    case 2500:
        if nobleza < 2000000 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 2000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 10
        userlist(userindex).faccion.nextrecompensa = 3000
    
    case 3000:
        if nobleza < 3000000 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 3000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 11
        userlist(userindex).faccion.nextrecompensa = 3500
    
    case 3500:
        if lvl < 35 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 35 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        if nobleza < 4000000 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 4000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 12
        userlist(userindex).faccion.nextrecompensa = 4000
    
    case 4000:
        if lvl < 36 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 36 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        if nobleza < 5000000 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 5000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 13
        userlist(userindex).faccion.nextrecompensa = 5000
    
    case 5000:
        if lvl < 37 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 37 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        if nobleza < 6000000 then
            call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 6000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensasreal = 14
        userlist(userindex).faccion.nextrecompensa = 10000
    
    case 10000:
        call writechatoverhead(userindex, "eres uno de mis mejores soldados. mataste " & crimis & ", sigue asi. ya no tengo m�s recompensa para darte que mi agradescimiento. �felicidades!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
        exit sub
    
    case else:
        exit sub
end select

call writechatoverhead(userindex, "���aqui tienes tu recompensa " + tituloreal(userindex) + "!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
userlist(userindex).stats.exp = userlist(userindex).stats.exp + expx100
if userlist(userindex).stats.exp > maxexp then
    userlist(userindex).stats.exp = maxexp
end if
call writeconsolemsg(userindex, "has ganado " & expx100 & " puntos de experiencia.", fonttypenames.fonttype_fight)

call checkuserlevel(userindex)


end sub

public sub expulsarfaccionreal(byval userindex as integer)

    userlist(userindex).faccion.armadareal = 0
    'call perderitemsfaccionarios(userindex)
    call writeconsolemsg(userindex, "has sido expulsado de las tropas reales!!!.", fonttypenames.fonttype_fight)
    'desequipamos la armadura real si est� equipada
    if objdata(userlist(userindex).invent.armoureqpobjindex).real = 1 then call desequipar(userindex, userlist(userindex).invent.armoureqpslot)
end sub

public sub expulsarfaccioncaos(byval userindex as integer)

    userlist(userindex).faccion.fuerzascaos = 0
    'call perderitemsfaccionarios(userindex)
    call writeconsolemsg(userindex, "has sido expulsado de la legi�n oscura!!!.", fonttypenames.fonttype_fight)
    'desequipamos la armadura real si est� equipada
    if objdata(userlist(userindex).invent.armoureqpobjindex).caos = 1 then call desequipar(userindex, userlist(userindex).invent.armoureqpslot)
end sub

public function tituloreal(byval userindex as integer) as string
'***************************************************
'autor: unknown
'last modification: 23/01/2007 pablo (toxicwaste)
'handles the titles of the members of the "armada real"
'***************************************************
select case userlist(userindex).faccion.recompensasreal
'rango 1: aprendiz (30 criminales)
'rango 2: escudero (70 criminales)
'rango 3: soldado (130 criminales)
'rango 4: sargento (210 criminales)
'rango 5: caballero (320 criminales)
'rango 6: comandante (460 criminales)
'rango 7: capit�n (640 criminales + > lvl 27)
'rango 8: senescal (870 criminales)
'rango 9: mariscal (1160 criminales)
'rango 10: condestable (2000 criminales + > lvl 30)
'rangos de honor de la armada real: (consejo de bander)
'rango 11: ejecutor imperial (2500 criminales + 2.000.000 nobleza)
'rango 12: protector del reino (3000 criminales + 3.000.000 nobleza)
'rango 13: avatar de la justicia (3500 criminales + 4.000.000 nobleza + > lvl 35)
'rango 14: guardi�n del bien (4000 criminales + 5.000.000 nobleza + > lvl 36)
'rango 15: campe�n de la luz (5000 criminales + 6.000.000 nobleza + > lvl 37)
    
    case 0
        tituloreal = "aprendiz"
    case 1
        tituloreal = "escudero"
    case 2
        tituloreal = "soldado"
    case 3
        tituloreal = "sargento"
    case 4
        tituloreal = "caballero"
    case 5
        tituloreal = "comandante"
    case 6
        tituloreal = "capit�n"
    case 7
        tituloreal = "senescal"
    case 8
        tituloreal = "mariscal"
    case 9
        tituloreal = "condestable"
    case 10
        tituloreal = "ejecutor imperial"
    case 11
        tituloreal = "protector del reino"
    case 12
        tituloreal = "avatar de la justicia"
    case 13
        tituloreal = "guardi�n del bien"
    case else
        tituloreal = "campe�n de la luz"
end select


end function

public sub enlistarcaos(byval userindex as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'handles the entrance of users to the "legi�n oscura"
'***************************************************
if not criminal(userindex) then
    call writechatoverhead(userindex, "���l�rgate de aqui, buf�n!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.fuerzascaos = 1 then
    call writechatoverhead(userindex, "���ya perteneces a la legi�n oscura!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.armadareal = 1 then
    call writechatoverhead(userindex, "las sombras reinar�n en argentum. ���fuera de aqui insecto real!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

'[barrin 17-12-03] si era miembro de la armada real no se puede enlistar
if userlist(userindex).faccion.recibioexpinicialreal = 1 then 'tomamos el valor de ah�: �recibio la experiencia para entrar?
    call writechatoverhead(userindex, "no permitir� que ning�n insecto real ingrese a mis tropas.", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if
'[/barrin]

if not criminal(userindex) then
    call writechatoverhead(userindex, "��ja ja ja!! tu no eres bienvenido aqui asqueroso ciudadano", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).faccion.ciudadanosmatados < 70 then
    call writechatoverhead(userindex, "para unirte a nuestras fuerzas debes matar al menos 70 ciudadanos, solo has matado " & userlist(userindex).faccion.ciudadanosmatados, str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

if userlist(userindex).stats.elv < 25 then
    call writechatoverhead(userindex, "���para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if


if userlist(userindex).faccion.reenlistadas > 4 then
    if userlist(userindex).faccion.reenlistadas = 200 then
        call writechatoverhead(userindex, "has sido expulsado de las fuerzas oscuras y durante tu rebeld�a has atacado a mi ej�rcito. �vete de aqu�!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    else
        call writechatoverhead(userindex, "�has sido expulsado de las fuerzas oscuras demasiadas veces!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    end if
    exit sub
end if

userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas + 1
userlist(userindex).faccion.fuerzascaos = 1

call writechatoverhead(userindex, "���bienvenido al lado oscuro!!! aqui tienes tus armaduras. derrama sangre ciudadana y real y ser�s recompensado, lo prometo.", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
if userlist(userindex).faccion.recibioarmaduracaos = 0 then
    dim miobj as obj
    dim miobj2 as obj
    miobj.amount = 20
    miobj2.amount = 10
    
    if userlist(userindex).raza = eraza.enano or userlist(userindex).raza = eraza.gnomo then
        miobj.objindex = vestimentalegionenano
        select case userlist(userindex).clase
            case eclass.mage
                miobj2.objindex = tunicaegregiaenano
            case else
                miobj2.objindex = tunicalobregaenano
        end select
    else
        miobj.objindex = vestimentalegionhumano
        select case userlist(userindex).clase
            case eclass.mage
                miobj2.objindex = tunicaegregiahumano
            case eclass.cleric, eclass.druid, eclass.bard
                miobj2.objindex = sacerdotedemoniaco
            case else
                miobj2.objindex = tunicalobregahumano
        end select
    end if
    
    if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    if not meteritemeninventario(userindex, miobj2) then
            call tiraritemalpiso(userlist(userindex).pos, miobj2)
    end if
    
    userlist(userindex).faccion.recibioarmaduracaos = 1
    userlist(userindex).faccion.nivelingreso = userlist(userindex).stats.elv
    userlist(userindex).faccion.fechaingreso = date

end if

if userlist(userindex).faccion.recibioexpinicialcaos = 0 then
    userlist(userindex).stats.exp = userlist(userindex).stats.exp + expalunirse
    if userlist(userindex).stats.exp > maxexp then _
        userlist(userindex).stats.exp = maxexp
    call writeconsolemsg(userindex, "has ganado " & expalunirse & " puntos de experiencia.", fonttypenames.fonttype_fight)
    userlist(userindex).faccion.recibioexpinicialcaos = 1
    userlist(userindex).faccion.recompensascaos = 0
    userlist(userindex).faccion.nextrecompensa = 160
    call checkuserlevel(userindex)
end if


call logejercitocaos(userlist(userindex).name & " ingres� el " & date & " cuando era nivel " & userlist(userindex).stats.elv)

end sub

public sub recompensacaos(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste) & unknown (orginal version)
'last modification: 23/01/2007
'handles the way of gaining new ranks in the "legi�n oscura"
'***************************************************
dim ciudas as long
dim lvl as byte
dim nextrecom as long
lvl = userlist(userindex).stats.elv
ciudas = userlist(userindex).faccion.ciudadanosmatados
nextrecom = userlist(userindex).faccion.nextrecompensa

if ciudas < nextrecom then
    call writechatoverhead(userindex, "mata " & nextrecom - ciudas & " cuidadanos m�s para recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
    exit sub
end if

select case nextrecom
    case 160:
        userlist(userindex).faccion.recompensascaos = 1
        userlist(userindex).faccion.nextrecompensa = 300
    
    case 300:
        userlist(userindex).faccion.recompensascaos = 2
        userlist(userindex).faccion.nextrecompensa = 490
    
    case 490:
        userlist(userindex).faccion.recompensascaos = 3
        userlist(userindex).faccion.nextrecompensa = 740
    
    case 740:
        userlist(userindex).faccion.recompensascaos = 4
        userlist(userindex).faccion.nextrecompensa = 1100
    
    case 1100:
        userlist(userindex).faccion.recompensascaos = 5
        userlist(userindex).faccion.nextrecompensa = 1500
    
    case 1500:
        if lvl < 27 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 27 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 6
        userlist(userindex).faccion.nextrecompensa = 2010
    
    case 2010:
        userlist(userindex).faccion.recompensascaos = 7
        userlist(userindex).faccion.nextrecompensa = 2700
    
    case 2700:
        userlist(userindex).faccion.recompensascaos = 8
        userlist(userindex).faccion.nextrecompensa = 4600
    
    case 4600:
        if lvl < 30 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 30 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 9
        userlist(userindex).faccion.nextrecompensa = 5800
    
    case 5800:
        if lvl < 31 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 31 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 10
        userlist(userindex).faccion.nextrecompensa = 6990
    
    case 6990:
        if lvl < 33 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 33 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 11
        userlist(userindex).faccion.nextrecompensa = 8100
    
    case 8100:
        if lvl < 35 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 35 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 12
        userlist(userindex).faccion.nextrecompensa = 9300
    
    case 9300:
        if lvl < 36 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 36 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 13
        userlist(userindex).faccion.nextrecompensa = 11500
    
    case 11500:
        if lvl < 37 then
            call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 37 - lvl & " niveles para poder recibir la pr�xima recompensa", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
        userlist(userindex).faccion.recompensascaos = 14
        userlist(userindex).faccion.nextrecompensa = 23000
    
    case 23000:
        call writechatoverhead(userindex, "eres uno de mis mejores soldados. mataste " & ciudas & ". tu �nica recompensa ser� la sangre derramada. ��continua as�!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
        exit sub
    
    case else:
        exit sub
        
end select

call writechatoverhead(userindex, "���bien hecho " + titulocaos(userindex) + ", aqu� tienes tu recompensa!!!", str(npclist(userlist(userindex).flags.targetnpc).char.charindex), vbwhite)
userlist(userindex).stats.exp = userlist(userindex).stats.exp + expx100
if userlist(userindex).stats.exp > maxexp then
    userlist(userindex).stats.exp = maxexp
end if
call writeconsolemsg(userindex, "has ganado " & expx100 & " puntos de experiencia.", fonttypenames.fonttype_fight)
call checkuserlevel(userindex)


end sub

public function titulocaos(byval userindex as integer) as string
'***************************************************
'autor: unknown (orginal version)
'last modification: 23/01/2007 pablo (toxicwaste)
'handles the titles of the members of the "legi�n oscura"
'***************************************************
'rango 1: ac�lito (70)
'rango 2: alma corrupta (160)
'rango 3: paria (300)
'rango 4: condenado (490)
'rango 5: esbirro (740)
'rango 6: sanguinario (1100)
'rango 7: corruptor (1500 + lvl 27)
'rango 8: heraldo impio (2010)
'rango 9: caballero de la oscuridad (2700)
'rango 10: se�or del miedo (4600 + lvl 30)
'rango 11: ejecutor infernal (5800 + lvl 31)
'rango 12: protector del averno (6990 + lvl 33)
'rango 13: avatar de la destrucci�n (8100 + lvl 35)
'rango 14: guardi�n del mal (9300 + lvl 36)
'rango 15: campe�n de la oscuridad (11500 + lvl 37)

select case userlist(userindex).faccion.recompensascaos
    case 0
        titulocaos = "ac�lito"
    case 1
        titulocaos = "alma corrupta"
    case 2
        titulocaos = "paria"
    case 3
        titulocaos = "condenado"
    case 4
        titulocaos = "esbirro"
    case 5
        titulocaos = "sanguinario"
    case 6
        titulocaos = "corruptor"
    case 7
        titulocaos = "heraldo imp�o"
    case 8
        titulocaos = "caballero de la oscuridad"
    case 9
        titulocaos = "se�or del miedo"
    case 10
        titulocaos = "ejecutor infernal"
    case 11
        titulocaos = "protector del averno"
    case 12
        titulocaos = "avatar de la destrucci�n"
    case 13
        titulocaos = "guardi�n del mal"
    case else
        titulocaos = "campe�n de la oscuridad"
end select

end function
