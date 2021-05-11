attribute vb_name = "modfacciones"
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


option explicit

public armaduraimperial1 as integer 'primer jerarquia
public armaduraimperial2 as integer 'segunda jerarqu�a
public armaduraimperial3 as integer 'enanos
public tunicamagoimperial as integer 'magos
public tunicamagoimperialenanos as integer 'magos


public armaduracaos1 as integer
public tunicamagocaos as integer
public tunicamagocaosenanos as integer
public armaduracaos2 as integer
public armaduracaos3 as integer

public const expalunirse = 100000
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

if userlist(userindex).faccion.criminalesmatados < 10 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes matar al menos 10 criminales, solo has matado " & userlist(userindex).faccion.criminalesmatados & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).stats.elv < 18 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes ser al menos de nivel 18!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if
 
if userlist(userindex).faccion.ciudadanosmatados > 0 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "has asesinado gente inocente, no aceptamos asesinos en las tropas reales!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

userlist(userindex).faccion.armadareal = 1
userlist(userindex).faccion.recompensasreal = userlist(userindex).faccion.criminalesmatados \ 100

call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "bienvenido a al ejercito imperial!!!, aqui tienes tu armadura. por cada centena de criminales que acabes te dare un recompensa, buena suerte soldado!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))

if userlist(userindex).faccion.recibioarmadurareal = 0 then
    dim miobj as obj
    miobj.amount = 1
    if ucase$(userlist(userindex).clase) = "mago" then
           if ucase$(userlist(userindex).raza) = "enano" or _
              ucase$(userlist(userindex).raza) = "gnomo" then
                  miobj.objindex = tunicamagoimperialenanos
           else
                  miobj.objindex = tunicamagoimperial
           end if
    elseif ucase$(userlist(userindex).clase) = "guerrero" or _
           ucase$(userlist(userindex).clase) = "cazador" or _
           ucase$(userlist(userindex).clase) = "paladin" or _
           ucase$(userlist(userindex).clase) = "bandido" or _
           ucase$(userlist(userindex).clase) = "asesino" then
              if ucase$(userlist(userindex).raza) = "enano" or _
                 ucase$(userlist(userindex).raza) = "gnomo" then
                  miobj.objindex = armaduraimperial3
              else
                  miobj.objindex = armaduraimperial1
              end if
    else
              if ucase$(userlist(userindex).raza) = "enano" or _
                 ucase$(userlist(userindex).raza) = "gnomo" then
                  miobj.objindex = armaduraimperial3
              else
                  miobj.objindex = armaduraimperial2
              end if
    end if
    
    if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
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
call senddata(toindex, userindex, 0, "||has sido expulsado de las tropas reales!!!." & fonttype_fight)
end sub

public sub expulsarfaccioncaos(byval userindex as integer)
userlist(userindex).faccion.fuerzascaos = 0
call senddata(toindex, userindex, 0, "||has sido expulsado de las fuerzas del caos!!!." & fonttype_fight)
end sub

public function tituloreal(byval userindex as integer) as string

select case userlist(userindex).faccion.recompensasreal
    case 0
        tituloreal = "aprendiz real"
    case 1
        tituloreal = "soldado real"
    case 2
        tituloreal = "teniente real"
    case 3
        tituloreal = "comandante real"
    case 4
        tituloreal = "general real"
    case 5
        tituloreal = "elite real"
    case 6
        tituloreal = "guardian del bien"
    case 7
        tituloreal = "caballero imperial"
    case 8
        tituloreal = "guardian del bien"
    case else
        tituloreal = "protector de newbies"
end select

end function

public sub enlistarcaos(byval userindex as integer)

if not criminal(userindex) then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "largate de aqui, bufon!!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.fuerzascaos = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ya perteneces a las tropas del caos!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.armadareal = 1 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "las sombras reinaran en argentum, largate de aqui estupido ciudadano.!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if not criminal(userindex) then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "ja ja ja tu no eres bienvenido aqui!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).faccion.ciudadanosmatados < 150 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes matar al menos 150 ciudadanos, solo has matado " & userlist(userindex).faccion.ciudadanosmatados & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

if userlist(userindex).stats.elv < 25 then
    call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "para unirte a nuestras fuerzas debes ser al menos de nivel 25!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
    exit sub
end if

userlist(userindex).faccion.fuerzascaos = 1
userlist(userindex).faccion.recompensascaos = userlist(userindex).faccion.ciudadanosmatados \ 100

call senddata(toindex, userindex, 0, "||" & vbwhite & "�" & "bienvenido a al lado oscuro!!!, aqui tienes tu armadura. por cada centena de ciudadanos que acabes te dare un recompensa, buena suerte soldado!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))

if userlist(userindex).faccion.recibioarmaduracaos = 0 then
    dim miobj as obj
    miobj.amount = 1
    if ucase$(userlist(userindex).clase) = "mago" then
                  miobj.objindex = tunicamagocaos
    elseif ucase$(userlist(userindex).clase) = "guerrero" or _
           ucase$(userlist(userindex).clase) = "cazador" or _
           ucase$(userlist(userindex).clase) = "paladin" or _
           ucase$(userlist(userindex).clase) = "bandido" or _
           ucase$(userlist(userindex).clase) = "asesino" then
              if ucase$(userlist(userindex).raza) = "enano" or _
                 ucase$(userlist(userindex).raza) = "gnomo" then
                  miobj.objindex = armaduracaos3
              else
                  miobj.objindex = armaduracaos1
              end if
    else
              if ucase$(userlist(userindex).raza) = "enano" or _
                 ucase$(userlist(userindex).raza) = "gnomo" then
                  miobj.objindex = armaduracaos3
              else
                  miobj.objindex = armaduracaos2
              end if
    end if
    
    if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
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

public sub expulsarcaos(byval userindex as integer)
userlist(userindex).faccion.fuerzascaos = 0
call senddata(toindex, userindex, 0, "||has sido expulsado del ejercito del caos!!!." & fonttype_fight)
end sub

public function titulocaos(byval userindex as integer) as string
select case userlist(userindex).faccion.recompensascaos
    case 1
        titulocaos = "esclavo de las sombras"
    case 2
        titulocaos = "guerrero del caos"
    case 3
        titulocaos = "teniente del caos"
    case 4
        titulocaos = "comandante del caos"
    case 5
        titulocaos = "general del caos"
    case 6
        titulocaos = "elite caos"
    case 7
        titulocaos = "asolador de las sombras"
    case 8
        titulocaos = "caballero oscuro"
    case 9
        titulocaos = "asesino del caos"
    case else
        titulocaos = "adorador del demonio"
end select


end function

