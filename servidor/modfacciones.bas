attribute vb_name = "modfacciones"
'argentum online 0.11.20
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

public const expalunirse = 50000
public const expx100 = 5000


public sub enlistararmadareal(byval userindex as integer)

if userlist(userindex).faccion.armadareal = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ya perteneces a las tropas reales!!! ve a combatir criminales!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.fuerzascaos = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "maldito insolente!!! vete de aqui seguidor de las sombras!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if criminal(userindex) then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no se permiten criminales en el ejercito imperial!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.criminalesmatados < 30 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes matar al menos 30 criminales, solo has matado " & userlist(userindex).faccion.criminalesmatados & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).stats.elv < 25 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if
 
if userlist(userindex).faccion.ciudadanosmatados > 0 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "has asesinado gente inocente, no aceptamos asesinos en las tropas reales!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.reenlistadas > 4 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "has sido expulsado de las fuerzas reales demasiadas veces!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

userlist(userindex).faccion.armadareal = 1
userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas + 1

userlist(userindex).faccion.recompensasreal = userlist(userindex).faccion.criminalesmatados \ 100

call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "���bienvenido a al ejercito imperial!!!, aqui tienes tus vestimentas. por cada centena de criminales que acabes te dar� un recompensa, buena suerte soldado!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))

if userlist(userindex).faccion.recibioarmadurareal = 0 then
    dim miobj as obj
    dim miobj2 as obj
    miobj.amount = 20
    miobj2.amount = 10
    
    
    
    
'public vestimentaimperialhumano as integer
'public vestimentaimperialenano as integer
'public tunicaconspicuahumano as integer
'public tunicaconspicuaenano as integer
'public armaduranobilisimahumano as integer
'public armaduranobilisimaenano as integer
'public armaduragransacerdote as integer

'public vestimentalegionhumano as integer
'public vestimentalegionenano as integer
'public tunicalobregahumano as integer
'public tunicalobregaenano as integer
'public tunicaegregiahumano as integer
'public tunicaegregiaenano as integer
'public sacerdotedemoniaco as integer
'
    
        
    if ucase$(userlist(userindex).raza) = "enano" or ucase$(userlist(userindex).raza) = "gnomo" then
        miobj.objindex = vestimentaimperialenano
        select case userlist(userindex).clase
            case "mago"
                miobj2.objindex = tunicaconspicuaenano
            case else
                miobj2.objindex = armaduranobilisimaenano
        end select
    else
        miobj.objindex = vestimentaimperialhumano
        select case userlist(userindex).clase
            case "mago"
                miobj2.objindex = tunicaconspicuahumano
            case "clerigo", "druida", "bardo"
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
end if

if userlist(userindex).faccion.recibioexpinicialreal = 0 then
    call addtovar(userlist(userindex).stats.exp, expalunirse, maxexp)
    call senddata(toindex, userindex, 0, "||has ganado " & expalunirse & " puntos de experiencia." & fonttype_fight)
    userlist(userindex).faccion.recibioexpinicialreal = 1
    call checkuserlevel(userindex)
end if


call logejercitoreal(userlist(userindex).name)

end sub

public sub recompensaarmadareal(byval userindex as integer)

if userlist(userindex).faccion.criminalesmatados \ 100 = _
   userlist(userindex).faccion.recompensasreal then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ya has recibido tu recompensa, mata 100 crinales mas para recibir la proxima!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
else
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "aqui tienes tu recompensa noble guerrero!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    call addtovar(userlist(userindex).stats.exp, expx100, maxexp)
    call senddata(toindex, userindex, 0, "||has ganado " & expx100 & " puntos de experiencia." & fonttype_fight)
    userlist(userindex).faccion.recompensasreal = userlist(userindex).faccion.recompensasreal + 1
    call checkuserlevel(userindex)
end if

end sub

public sub expulsarfaccionreal(byval userindex as integer)
userlist(userindex).faccion.armadareal = 0
'call perderitemsfaccionarios(userindex)
call senddata(toindex, userindex, 0, "||has sido expulsado de las tropas reales!!!." & fonttype_fight)
end sub

public sub expulsarfaccioncaos(byval userindex as integer)
userlist(userindex).faccion.fuerzascaos = 0
'call perderitemsfaccionarios(userindex)
call senddata(toindex, userindex, 0, "||has sido expulsado de la legi�n oscura!!!." & fonttype_fight)
end sub

public function tituloreal(byval userindex as integer) as string

select case userlist(userindex).faccion.recompensasreal
    case 0
        tituloreal = "aprendiz "
    case 1
        tituloreal = "escudero"
    case 2
        tituloreal = "caballero"
    case 3
        tituloreal = "capitan"
    case 4
        tituloreal = "teniente"
    case 5
        tituloreal = "comandante"
    case 6
        tituloreal = "mariscal"
    case 7
        tituloreal = "senescal"
    case 8
        tituloreal = "protector"
    case 9
        tituloreal = "guardian del bien"
    case else
        tituloreal = "campe�n de la luz"
end select

end function

public sub enlistarcaos(byval userindex as integer)

if not criminal(userindex) then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "largate de aqui, bufon!!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.fuerzascaos = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ya perteneces a la legi�n oscura!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.armadareal = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "las sombras reinaran en argentum, largate de aqui estupido ciudadano.!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

'[barrin 17-12-03] si era miembro de la armada real no se puede enlistar
if userlist(userindex).faccion.recibioexpinicialreal = 1 then 'tomamos el valor de ah�: �recibio la experiencia para entrar?
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "no permitir� que ning�n insecto real ingrese �traidor del rey!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if
'[/barrin]

if not criminal(userindex) then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ja ja ja tu no eres bienvenido aqui!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.ciudadanosmatados < 70 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes matar al menos 70 ciudadanos, solo has matado " & userlist(userindex).faccion.ciudadanosmatados & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).stats.elv < 25 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if


if userlist(userindex).faccion.reenlistadas > 4 then
    if userlist(userindex).faccion.reenlistadas = 200 then
        call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "has sido expulsado de las fuerzas oscuras y durante tu rebeld�a has atacado a mi ej�rcito. vete de aqu�!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    else
        call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "has sido expulsado de las fuerzas oscuras demasiadas veces!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    end if
    exit sub
end if

userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas + 1
userlist(userindex).faccion.fuerzascaos = 1
userlist(userindex).faccion.recompensascaos = userlist(userindex).faccion.ciudadanosmatados \ 100

call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "bienvenido a al lado oscuro!!!, aqui tienes tu armadura. por cada centena de ciudadanos que acabes te dar� un recompensa, buena suerte soldado!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))

if userlist(userindex).faccion.recibioarmaduracaos = 0 then
    dim miobj as obj
    dim miobj2 as obj
    miobj.amount = 20
    miobj2.amount = 10
    
    if ucase$(userlist(userindex).raza) = "enano" or ucase$(userlist(userindex).raza) = "gnomo" then
        miobj.objindex = vestimentalegionenano
        select case userlist(userindex).clase
            case "mago"
                miobj2.objindex = tunicaegregiaenano
            case else
                miobj2.objindex = tunicalobregaenano
        end select
    else
        miobj.objindex = vestimentaimperialhumano
        select case userlist(userindex).clase
            case "mago"
                miobj2.objindex = tunicaegregiahumano
            case "clerigo", "druida", "bardo"
                miobj2.objindex = sacerdotedemoniaco
            case else
                miobj2.objindex = tunicaegregiahumano
        end select
    end if
    
    if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    if not meteritemeninventario(userindex, miobj2) then
            call tiraritemalpiso(userlist(userindex).pos, miobj2)
    end if
    
    userlist(userindex).faccion.recibioarmaduracaos = 1
    


end if

if userlist(userindex).faccion.recibioexpinicialcaos = 0 then
    call addtovar(userlist(userindex).stats.exp, expalunirse, maxexp)
    call senddata(toindex, userindex, 0, "||has ganado " & expalunirse & " puntos de experiencia." & fonttype_fight)
    userlist(userindex).faccion.recibioexpinicialcaos = 1
    call checkuserlevel(userindex)
end if


call logejercitocaos(userlist(userindex).name)

end sub

public sub recompensacaos(byval userindex as integer)

if userlist(userindex).faccion.ciudadanosmatados \ 100 = _
   userlist(userindex).faccion.recompensascaos then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ya has recibido tu recompensa, mata 100 ciudadanos mas para recibir la proxima!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
else
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "aqui tienes tu recompensa noble guerrero!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    call addtovar(userlist(userindex).stats.exp, expx100, maxexp)
    call senddata(toindex, userindex, 0, "||has ganado " & expx100 & " puntos de experiencia." & fonttype_fight)
    userlist(userindex).faccion.recompensascaos = userlist(userindex).faccion.recompensascaos + 1
    call checkuserlevel(userindex)
end if


end sub

public function titulocaos(byval userindex as integer) as string
select case userlist(userindex).faccion.recompensascaos
    case 0
        titulocaos = "esbirro"
    case 1
        titulocaos = "servidor de las sombras"
    case 2
        titulocaos = "ac�lito"
    case 3
        titulocaos = "guerrero sombr�o"
    case 4
        titulocaos = "sanguinario"
    case 5
        titulocaos = "caballero de la oscuridad"
    case 6
        titulocaos = "condenado"
    case 7
        titulocaos = "heraldo imp�o"
    case 8
        titulocaos = "corruptor"
    case else
        titulocaos = "devorador de almas"
end select


end function

'[barrin 17-12-03]
'sub perderitemsfaccionarios(byval userindex as integer)
'dim i as byte
'dim miobj as obj
'dim itemindex as integer
'
'for i = 1 to max_inventory_slots
'  itemindex = userlist(userindex).invent.object(i).objindex
'  if itemindex > 0 then
'         if objdata(itemindex).real = 1 or objdata(itemindex).caos = 1 then
'            call quitaruserinvitem(userindex, i, userlist(userindex).invent.object(i).amount)
'            call updateuserinv(false, userindex, i)
'            if objdata(itemindex).objtype = objtype_armour then
'                if objdata(itemindex).real = 1 then userlist(userindex).faccion.recibioarmadurareal = 0
'                if objdata(itemindex).caos = 1 then userlist(userindex).faccion.recibioarmaduracaos = 0
'            else
'                userlist(userindex).faccion.recibioitemfaccionario = 0
'            end if
'         end if
'
'  end if
'next i
'
'end sub
'[/barrin]
