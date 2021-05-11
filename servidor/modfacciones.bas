attribute vb_name = "modfacciones"
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


public armaduraimperial1 as integer
public armaduraimperial2 as integer
public armaduraimperial3 as integer
public tunicamagoimperial as integer
public tunicamagoimperialenanos as integer
public armaduracaos1 as integer
public armaduracaos2 as integer
public armaduracaos3 as integer
public tunicamagocaos as integer
public tunicamagocaosenanos as integer

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



public const num_rangos_faccion as integer = 15
private const num_def_faccion_armours as byte = 3

public enum etipodefarmors
    iebaja
    iemedia
    iealta
end enum

public type tfaccionarmaduras
    armada(num_def_faccion_armours - 1) as integer
    caos(num_def_faccion_armours - 1) as integer
end type

' matriz que contiene las armaduras faccionarias segun raza, clase, faccion y defensa de armadura
public armadurasfaccion(1 to numclases, 1 to numrazas) as tfaccionarmaduras

' contiene la cantidad de exp otorgada cada vez que aumenta el rango
public recompensafacciones(num_rangos_faccion) as long

private function getarmouramount(byval rango as integer, byval tipodef as etipodefarmors) as integer
'***************************************************
'autor: zama
'last modification: 15/04/2010
'returns the amount of armours to give, depending on the specified rank
'***************************************************

    select case tipodef
        
        case etipodefarmors.iebaja
            getarmouramount = 20 / (rango + 1)
            
        case etipodefarmors.iemedia
            getarmouramount = rango * 2 / maximoint((rango - 4), 1)
            
        case etipodefarmors.iealta
            getarmouramount = rango * 1.35
            
    end select
    
end function

private sub givefactionarmours(byval userindex as integer, byval iscaos as boolean)
'***************************************************
'autor: zama
'last modification: 15/04/2010
'gives faction armours to user
'***************************************************
    
    dim objarmour as obj
    dim rango as integer
    
    with userlist(userindex)
    
        rango = val(iif(iscaos, .faccion.recompensascaos, .faccion.recompensasreal)) + 1
    
    
        ' entrego armaduras de defensa baja
        objarmour.amount = getarmouramount(rango, etipodefarmors.iebaja)
        
        if iscaos then
            objarmour.objindex = armadurasfaccion(.clase, .raza).caos(etipodefarmors.iebaja)
        else
            objarmour.objindex = armadurasfaccion(.clase, .raza).armada(etipodefarmors.iebaja)
        end if
        
        if not meteritemeninventario(userindex, objarmour) then
            call tiraritemalpiso(.pos, objarmour)
        end if
        
        
        ' entrego armaduras de defensa media
        objarmour.amount = getarmouramount(rango, etipodefarmors.iemedia)
        
        if iscaos then
            objarmour.objindex = armadurasfaccion(.clase, .raza).caos(etipodefarmors.iemedia)
        else
            objarmour.objindex = armadurasfaccion(.clase, .raza).armada(etipodefarmors.iemedia)
        end if
        
        if not meteritemeninventario(userindex, objarmour) then
            call tiraritemalpiso(.pos, objarmour)
        end if

    
        ' entrego armaduras de defensa alta
        objarmour.amount = getarmouramount(rango, etipodefarmors.iealta)
        
        if iscaos then
            objarmour.objindex = armadurasfaccion(.clase, .raza).caos(etipodefarmors.iealta)
        else
            objarmour.objindex = armadurasfaccion(.clase, .raza).armada(etipodefarmors.iealta)
        end if
        
        if not meteritemeninventario(userindex, objarmour) then
            call tiraritemalpiso(.pos, objarmour)
        end if

    end with

end sub

public sub giveexpreward(byval userindex as integer, byval rango as long)
'***************************************************
'autor: zama
'last modification: 15/04/2010
'gives reward exp to user
'***************************************************
    
    dim givenexp as long
    
    with userlist(userindex)
        
        givenexp = recompensafacciones(rango)
        
        .stats.exp = .stats.exp + givenexp
        
        if .stats.exp > maxexp then .stats.exp = maxexp
        
        call writeconsolemsg(userindex, "has sido recompensado con " & givenexp & " puntos de experiencia.", fonttypenames.fonttype_fight)

        call checkuserlevel(userindex)
        
    end with
    
end sub

public sub enlistararmadareal(byval userindex as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 15/04/2010
'handles the entrance of users to the "armada real"
'15/03/2009: zama - no se puede enlistar el fundador de un clan con alineaci�n neutral.
'27/11/2009: zama - ahora no se puede enlistar un miembro de un clan neutro, por ende saque la antifaccion.
'15/04/2010: zama - cambio en recompensas iniciales.
'***************************************************

with userlist(userindex)
    if .faccion.armadareal = 1 then
        call writechatoverhead(userindex, "���ya perteneces a las tropas reales!!! ve a combatir criminales.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.fuerzascaos = 1 then
        call writechatoverhead(userindex, "���maldito insolente!!! vete de aqu� seguidor de las sombras.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if criminal(userindex) then
        call writechatoverhead(userindex, "���no se permiten criminales en el ej�rcito real!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.criminalesmatados < 30 then
        call writechatoverhead(userindex, "para unirte a nuestras fuerzas debes matar al menos 30 criminales, s�lo has matado " & .faccion.criminalesmatados & ".", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .stats.elv < 25 then
        call writechatoverhead(userindex, "���para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
     
    if .faccion.ciudadanosmatados > 0 then
        call writechatoverhead(userindex, "�has asesinado gente inocente, no aceptamos asesinos en las tropas reales!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.reenlistadas > 4 then
        call writechatoverhead(userindex, "�has sido expulsado de las fuerzas reales demasiadas veces!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .reputacion.noblerep < 1000000 then
        call writechatoverhead(userindex, "necesitas ser a�n m�s noble para integrar el ej�rcito real, s�lo tienes " & .reputacion.noblerep & "/1.000.000 puntos de nobleza", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .guildindex > 0 then
        if modguilds.guildalignment(.guildindex) = "neutral" then
            call writechatoverhead(userindex, "���perteneces a un clan neutro, sal de �l si quieres unirte a nuestras fuerzas!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
    end if
    
    .faccion.armadareal = 1
    .faccion.reenlistadas = .faccion.reenlistadas + 1
    
    call writechatoverhead(userindex, "���bienvenido al ej�rcito real!!! aqu� tienes tus vestimentas. cumple bien tu labor exterminando criminales y me encargar� de recompensarte.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
    
    ' todo: dejo esta variable por ahora, pero con chequear las reenlistadas deberia ser suficiente :s
    if .faccion.recibioarmadurareal = 0 then
        
        call givefactionarmours(userindex, false)
        call giveexpreward(userindex, 0)
        
        .faccion.recibioarmadurareal = 1
        .faccion.nivelingreso = .stats.elv
        .faccion.fechaingreso = date
        'esto por ahora es in�til, siempre va a ser cero, pero bueno, despues va a servir.
        .faccion.matadosingreso = .faccion.ciudadanosmatados
        
        .faccion.recibioexpinicialreal = 1
        .faccion.recompensasreal = 0
        .faccion.nextrecompensa = 70
        
    end if
    
    if .flags.navegando then call refreshcharstatus(userindex) 'actualizamos la barca si esta navegando (niconz)
    
    call logejercitoreal(.name & " ingres� el " & date & " cuando era nivel " & .stats.elv)
end with

end sub

public sub recompensaarmadareal(byval userindex as integer)
'***************************************************
'autor: pablo (toxicwaste) & unknown (orginal version)
'last modification: 15/04/2010
'handles the way of gaining new ranks in the "armada real"
'15/04/2010: zama - agrego recompensas de oro y armaduras
'***************************************************
dim crimis as long
dim lvl as byte
dim nextrecom as long
dim nobleza as long

with userlist(userindex)
    lvl = .stats.elv
    crimis = .faccion.criminalesmatados
    nextrecom = .faccion.nextrecompensa
    nobleza = .reputacion.noblerep
    
    if crimis < nextrecom then
        call writechatoverhead(userindex, "mata " & nextrecom - crimis & " criminales m�s para recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    select case nextrecom
        case 70:
            .faccion.recompensasreal = 1
            .faccion.nextrecompensa = 130
        
        case 130:
            .faccion.recompensasreal = 2
            .faccion.nextrecompensa = 210
        
        case 210:
            .faccion.recompensasreal = 3
            .faccion.nextrecompensa = 320
        
        case 320:
            .faccion.recompensasreal = 4
            .faccion.nextrecompensa = 460
        
        case 460:
            .faccion.recompensasreal = 5
            .faccion.nextrecompensa = 640
        
        case 640:
            if lvl < 27 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 27 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 6
            .faccion.nextrecompensa = 870
        
        case 870:
            .faccion.recompensasreal = 7
            .faccion.nextrecompensa = 1160
        
        case 1160:
            .faccion.recompensasreal = 8
            .faccion.nextrecompensa = 2000
        
        case 2000:
            if lvl < 30 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 30 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 9
            .faccion.nextrecompensa = 2500
        
        case 2500:
            if nobleza < 2000000 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 2000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 10
            .faccion.nextrecompensa = 3000
        
        case 3000:
            if nobleza < 3000000 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 3000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 11
            .faccion.nextrecompensa = 3500
        
        case 3500:
            if lvl < 35 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 35 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            if nobleza < 4000000 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 4000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 12
            .faccion.nextrecompensa = 4000
        
        case 4000:
            if lvl < 36 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 36 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            if nobleza < 5000000 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 5000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 13
            .faccion.nextrecompensa = 5000
        
        case 5000:
            if lvl < 37 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 37 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            if nobleza < 6000000 then
                call writechatoverhead(userindex, "mataste suficientes criminales, pero te faltan " & 6000000 - nobleza & " puntos de nobleza para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensasreal = 14
            .faccion.nextrecompensa = 10000
        
        case 10000:
            call writechatoverhead(userindex, "eres uno de mis mejores soldados. mataste " & crimis & " criminales, sigue as�. ya no tengo m�s recompensa para darte que mi agradecimiento. �felicidades!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
            exit sub
        
        case else:
            exit sub
    end select
    
    call writechatoverhead(userindex, "���aqu� tienes tu recompensa " & tituloreal(userindex) & "!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)

    ' recompensas de armaduras y exp
    call givefactionarmours(userindex, false)
    call giveexpreward(userindex, .faccion.recompensasreal)

end with

end sub

public sub expulsarfaccionreal(byval userindex as integer, optional expulsado as boolean = true)
'***************************************************
'author: unknown
'last modification: -
' 09/28/2010 c4b3z0n - arreglado rt6 overflow, el desequipar() del escudo, pon�a de parametro el objindex del escudo en vez del eqpslot.
'***************************************************

with userlist(userindex)
    .faccion.armadareal = 0
    'call perderitemsfaccionarios(userindex)
    if expulsado then
        call writeconsolemsg(userindex, "���has sido expulsado del ej�rcito real!!!", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "���te has retirado del ej�rcito real!!!", fonttypenames.fonttype_fight)
    end if
    
    if .invent.armoureqpobjindex <> 0 then
        'desequipamos la armadura real si est� equipada
        if objdata(.invent.armoureqpobjindex).real = 1 then call desequipar(userindex, .invent.armoureqpslot)
    end if
    
    if .invent.escudoeqpobjindex <> 0 then
        'desequipamos el escudo de caos si est� equipado
        if objdata(.invent.escudoeqpobjindex).real = 1 then call desequipar(userindex, .invent.escudoeqpslot)
    end if
    
    if .flags.navegando then call refreshcharstatus(userindex) 'actualizamos la barca si esta navegando (niconz)
end with

end sub

public sub expulsarfaccioncaos(byval userindex as integer, optional expulsado as boolean = true)
'***************************************************
'author: unknown
'last modification: -
' 09/28/2010 c4b3z0n - arreglado rt6 overflow, el desequipar() del escudo, pon�a de parametro el objindex del escudo en vez del eqpslot.
'***************************************************

with userlist(userindex)
    .faccion.fuerzascaos = 0
    'call perderitemsfaccionarios(userindex)
    if expulsado then
        call writeconsolemsg(userindex, "���has sido expulsado de la legi�n oscura!!!", fonttypenames.fonttype_fight)
    else
        call writeconsolemsg(userindex, "���te has retirado de la legi�n oscura!!!", fonttypenames.fonttype_fight)
    end if
    
    if .invent.armoureqpobjindex <> 0 then
        'desequipamos la armadura de caos si est� equipada
        if objdata(.invent.armoureqpobjindex).caos = 1 then call desequipar(userindex, .invent.armoureqpslot)
    end if
    
    if .invent.escudoeqpobjindex <> 0 then
        'desequipamos el escudo de caos si est� equipado
        if objdata(.invent.escudoeqpobjindex).caos = 1 then call desequipar(userindex, .invent.escudoeqpslot)
    end if
    
    if .flags.navegando then call refreshcharstatus(userindex) 'actualizamos la barca si esta navegando (niconz)
end with

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
        tituloreal = "teniente"
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
'last modification: 27/11/2009
'15/03/2009: zama - no se puede enlistar el fundador de un clan con alineaci�n neutral.
'27/11/2009: zama - ahora no se puede enlistar un miembro de un clan neutro, por ende saque la antifaccion.
'handles the entrance of users to the "legi�n oscura"
'***************************************************

with userlist(userindex)
    if not criminal(userindex) then
        call writechatoverhead(userindex, "���l�rgate de aqu�, buf�n!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.fuerzascaos = 1 then
        call writechatoverhead(userindex, "���ya perteneces a la legi�n oscura!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.armadareal = 1 then
        call writechatoverhead(userindex, "las sombras reinar�n en argentum. ���fuera de aqu� insecto real!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    '[barrin 17-12-03] si era miembro de la armada real no se puede enlistar
    if .faccion.recibioexpinicialreal = 1 then 'tomamos el valor de ah�: �recibio la experiencia para entrar?
        call writechatoverhead(userindex, "no permitir� que ning�n insecto real ingrese a mis tropas.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    '[/barrin]
    
    if not criminal(userindex) then
        call writechatoverhead(userindex, "��ja ja ja!! t� no eres bienvenido aqu� asqueroso ciudadano.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .faccion.ciudadanosmatados < 70 then
        call writechatoverhead(userindex, "para unirte a nuestras fuerzas debes matar al menos 70 ciudadanos, s�lo has matado " & .faccion.ciudadanosmatados & ".", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .stats.elv < 25 then
        call writechatoverhead(userindex, "���para unirte a nuestras fuerzas debes ser al menos nivel 25!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    if .guildindex > 0 then
        if modguilds.guildalignment(.guildindex) = "neutral" then
            call writechatoverhead(userindex, "���perteneces a un clan neutro, sal de �l si quieres unirte a nuestras fuerzas!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
            exit sub
        end if
    end if
    
    
    if .faccion.reenlistadas > 4 then
        if .faccion.reenlistadas = 200 then
            call writechatoverhead(userindex, "has sido expulsado de las fuerzas oscuras y durante tu rebeld�a has atacado a mi ej�rcito. �vete de aqu�!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        else
            call writechatoverhead(userindex, "�has sido expulsado de las fuerzas oscuras demasiadas veces!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        end if
        exit sub
    end if
    
    .faccion.reenlistadas = .faccion.reenlistadas + 1
    .faccion.fuerzascaos = 1
    
    call writechatoverhead(userindex, "���bienvenido al lado oscuro!!! aqu� tienes tus armaduras. derrama sangre ciudadana y real, y ser�s recompensado, lo prometo.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
    
    if .faccion.recibioarmaduracaos = 0 then
                
        call givefactionarmours(userindex, true)
        call giveexpreward(userindex, 0)
        
        .faccion.recibioarmaduracaos = 1
        .faccion.nivelingreso = .stats.elv
        .faccion.fechaingreso = date
    
        .faccion.recibioexpinicialcaos = 1
        .faccion.recompensascaos = 0
        .faccion.nextrecompensa = 160
    end if
    
    if .flags.navegando then call refreshcharstatus(userindex) 'actualizamos la barca si esta navegando (niconz)

    call logejercitocaos(.name & " ingres� el " & date & " cuando era nivel " & .stats.elv)
end with

end sub

public sub recompensacaos(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste) & unknown (orginal version)
'last modification: 15/04/2010
'handles the way of gaining new ranks in the "legi�n oscura"
'15/04/2010: zama - agrego recompensas de oro y armaduras
'***************************************************
dim ciudas as long
dim lvl as byte
dim nextrecom as long

with userlist(userindex)
    lvl = .stats.elv
    ciudas = .faccion.ciudadanosmatados
    nextrecom = .faccion.nextrecompensa
    
    if ciudas < nextrecom then
        call writechatoverhead(userindex, "mata " & nextrecom - ciudas & " cuidadanos m�s para recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
        exit sub
    end if
    
    select case nextrecom
        case 160:
            .faccion.recompensascaos = 1
            .faccion.nextrecompensa = 300
        
        case 300:
            .faccion.recompensascaos = 2
            .faccion.nextrecompensa = 490
        
        case 490:
            .faccion.recompensascaos = 3
            .faccion.nextrecompensa = 740
        
        case 740:
            .faccion.recompensascaos = 4
            .faccion.nextrecompensa = 1100
        
        case 1100:
            .faccion.recompensascaos = 5
            .faccion.nextrecompensa = 1500
        
        case 1500:
            if lvl < 27 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 27 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 6
            .faccion.nextrecompensa = 2010
        
        case 2010:
            .faccion.recompensascaos = 7
            .faccion.nextrecompensa = 2700
        
        case 2700:
            .faccion.recompensascaos = 8
            .faccion.nextrecompensa = 4600
        
        case 4600:
            if lvl < 30 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 30 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 9
            .faccion.nextrecompensa = 5800
        
        case 5800:
            if lvl < 31 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 31 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 10
            .faccion.nextrecompensa = 6990
        
        case 6990:
            if lvl < 33 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 33 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 11
            .faccion.nextrecompensa = 8100
        
        case 8100:
            if lvl < 35 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 35 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 12
            .faccion.nextrecompensa = 9300
        
        case 9300:
            if lvl < 36 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 36 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 13
            .faccion.nextrecompensa = 11500
        
        case 11500:
            if lvl < 37 then
                call writechatoverhead(userindex, "mataste suficientes ciudadanos, pero te faltan " & 37 - lvl & " niveles para poder recibir la pr�xima recompensa.", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
                exit sub
            end if
            .faccion.recompensascaos = 14
            .faccion.nextrecompensa = 23000
        
        case 23000:
            call writechatoverhead(userindex, "eres uno de mis mejores soldados. mataste " & ciudas & " ciudadanos . tu �nica recompensa ser� la sangre derramada. ��contin�a as�!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
            exit sub
        
        case else:
            exit sub
            
    end select
    
    call writechatoverhead(userindex, "���bien hecho " & titulocaos(userindex) & ", aqu� tienes tu recompensa!!!", str(npclist(.flags.targetnpc).char.charindex), vbwhite)
    
    ' recompensas de armaduras y exp
    call givefactionarmours(userindex, true)
    call giveexpreward(userindex, .faccion.recompensascaos)
    
end with

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

