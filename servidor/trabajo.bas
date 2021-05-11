attribute vb_name = "trabajo"
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

public sub dopermaneceroculto(byval userindex as integer)
on error goto errhandler
dim suerte as integer
dim res as integer

if userlist(userindex).stats.userskills(ocultarse) <= 10 _
   and userlist(userindex).stats.userskills(ocultarse) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(ocultarse) <= 20 _
   and userlist(userindex).stats.userskills(ocultarse) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(ocultarse) <= 30 _
   and userlist(userindex).stats.userskills(ocultarse) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(ocultarse) <= 40 _
   and userlist(userindex).stats.userskills(ocultarse) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(ocultarse) <= 50 _
   and userlist(userindex).stats.userskills(ocultarse) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(ocultarse) <= 60 _
   and userlist(userindex).stats.userskills(ocultarse) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(ocultarse) <= 70 _
   and userlist(userindex).stats.userskills(ocultarse) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(ocultarse) <= 80 _
   and userlist(userindex).stats.userskills(ocultarse) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(ocultarse) <= 90 _
   and userlist(userindex).stats.userskills(ocultarse) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(ocultarse) <= 100 _
   and userlist(userindex).stats.userskills(ocultarse) >= 91 then
                    exit sub
end if

if ucase$(userlist(userindex).clase) <> "ladron" then suerte = suerte + 50




res = randomnumber(1, suerte)

if res > 9 then
   userlist(userindex).flags.oculto = 0
   userlist(userindex).flags.invisible = 0
   'no hace falta encriptar este (se jode el gil que bypassea esto)
   call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
   call senddata(toindex, userindex, 0, "||�has vuelto a ser visible!" & fonttype_info)
end if


exit sub

errhandler:
    call logerror("error en sub dopermaneceroculto")


end sub
public sub doocultarse(byval userindex as integer)

on error goto errhandler

dim suerte as integer
dim res as integer

if userlist(userindex).stats.userskills(ocultarse) <= 10 _
   and userlist(userindex).stats.userskills(ocultarse) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(ocultarse) <= 20 _
   and userlist(userindex).stats.userskills(ocultarse) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(ocultarse) <= 30 _
   and userlist(userindex).stats.userskills(ocultarse) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(ocultarse) <= 40 _
   and userlist(userindex).stats.userskills(ocultarse) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(ocultarse) <= 50 _
   and userlist(userindex).stats.userskills(ocultarse) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(ocultarse) <= 60 _
   and userlist(userindex).stats.userskills(ocultarse) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(ocultarse) <= 70 _
   and userlist(userindex).stats.userskills(ocultarse) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(ocultarse) <= 80 _
   and userlist(userindex).stats.userskills(ocultarse) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(ocultarse) <= 90 _
   and userlist(userindex).stats.userskills(ocultarse) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(ocultarse) <= 100 _
   and userlist(userindex).stats.userskills(ocultarse) >= 91 then
                    suerte = 7
end if

if ucase$(userlist(userindex).clase) <> "ladron" then suerte = suerte + 50

res = randomnumber(1, suerte)

if res <= 5 then
   userlist(userindex).flags.oculto = 1
   userlist(userindex).flags.invisible = 1
   if encriptarprotocoloscriticos then
        call sendcrypteddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",1")
   else
        call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",1")
   end if
   call senddata(toindex, userindex, 0, "||�te has escondido entre las sombras!" & fonttype_info)
   call subirskill(userindex, ocultarse)
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 4 then
      call senddata(toindex, userindex, 0, "||�no has logrado esconderte!" & fonttype_info)
      userlist(userindex).flags.ultimomensaje = 4
    end if
    '[/cdt]
end if

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

exit sub

errhandler:
    call logerror("error en sub doocultarse")

end sub


public sub donavega(byval userindex as integer, byref barco as objdata, byval slot as integer)

dim modnave as long
modnave = modnavegacion(userlist(userindex).clase)

if userlist(userindex).stats.userskills(navegacion) / modnave < barco.minskill then
    call senddata(toindex, userindex, 0, "||no tenes suficientes conocimientos para usar este barco." & fonttype_info)
    call senddata(toindex, userindex, 0, "||para usar este barco necesitas " & barco.minskill * modnave & " puntos en navegacion." & fonttype_info)
    exit sub
end if

userlist(userindex).invent.barcoobjindex = userlist(userindex).invent.object(slot).objindex
userlist(userindex).invent.barcoslot = slot

if userlist(userindex).flags.navegando = 0 then
    
    userlist(userindex).char.head = 0
    
    if userlist(userindex).flags.muerto = 0 then
        userlist(userindex).char.body = barco.ropaje
    else
        userlist(userindex).char.body = ifragatafantasmal
    end if
    
    userlist(userindex).char.shieldanim = ningunescudo
    userlist(userindex).char.weaponanim = ningunarma
    userlist(userindex).char.cascoanim = ninguncasco
    userlist(userindex).flags.navegando = 1
    
else
    
    userlist(userindex).flags.navegando = 0
    
    if userlist(userindex).flags.muerto = 0 then
        userlist(userindex).char.head = userlist(userindex).origchar.head
        
        if userlist(userindex).invent.armoureqpobjindex > 0 then
            userlist(userindex).char.body = objdata(userlist(userindex).invent.armoureqpobjindex).ropaje
        else
            call darcuerpodesnudo(userindex)
        end if
            
        if userlist(userindex).invent.escudoeqpobjindex > 0 then _
            userlist(userindex).char.shieldanim = objdata(userlist(userindex).invent.escudoeqpobjindex).shieldanim
        if userlist(userindex).invent.weaponeqpobjindex > 0 then _
            userlist(userindex).char.weaponanim = objdata(userlist(userindex).invent.weaponeqpobjindex).weaponanim
        if userlist(userindex).invent.cascoeqpobjindex > 0 then _
            userlist(userindex).char.cascoanim = objdata(userlist(userindex).invent.cascoeqpobjindex).cascoanim
    else
        userlist(userindex).char.body = icuerpomuerto
        userlist(userindex).char.head = icabezamuerto
        userlist(userindex).char.shieldanim = ningunescudo
        userlist(userindex).char.weaponanim = ningunarma
        userlist(userindex).char.cascoanim = ninguncasco
    end if

end if

call changeuserchar(tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
call senddata(toindex, userindex, 0, "naveg")

end sub

public sub fundirmineral(byval userindex as integer)
'call logtarea("sub fundirmineral")

if userlist(userindex).flags.targetobjinvindex > 0 then
   
   if objdata(userlist(userindex).flags.targetobjinvindex).objtype = objtype_minerales and objdata(userlist(userindex).flags.targetobjinvindex).minskill <= userlist(userindex).stats.userskills(mineria) / modfundicion(userlist(userindex).clase) then
        call dolingotes(userindex)
   else
        call senddata(toindex, userindex, 0, "||no tenes conocimientos de mineria suficientes para trabajar este mineral." & fonttype_info)
   end if

end if

end sub
function tieneobjetos(byval itemindex as integer, byval cant as integer, byval userindex as integer) as boolean
'call logtarea("sub tieneobjetos")

dim i as integer
dim total as long
for i = 1 to max_inventory_slots
    if userlist(userindex).invent.object(i).objindex = itemindex then
        total = total + userlist(userindex).invent.object(i).amount
    end if
next i

if cant <= total then
    tieneobjetos = true
    exit function
end if
        
end function

function quitarobjetos(byval itemindex as integer, byval cant as integer, byval userindex as integer) as boolean
'call logtarea("sub quitarobjetos")

dim i as integer
for i = 1 to max_inventory_slots
    if userlist(userindex).invent.object(i).objindex = itemindex then
        
        call desequipar(userindex, i)
        
        userlist(userindex).invent.object(i).amount = userlist(userindex).invent.object(i).amount - cant
        if (userlist(userindex).invent.object(i).amount <= 0) then
            cant = abs(userlist(userindex).invent.object(i).amount)
            userlist(userindex).invent.object(i).amount = 0
            userlist(userindex).invent.object(i).objindex = 0
        else
            cant = 0
        end if
        
        call updateuserinv(false, userindex, i)
        
        if (cant = 0) then
            quitarobjetos = true
            exit function
        end if
    end if
next i

end function

sub herreroquitarmateriales(byval userindex as integer, byval itemindex as integer)
    if objdata(itemindex).lingh > 0 then call quitarobjetos(lingotehierro, objdata(itemindex).lingh, userindex)
    if objdata(itemindex).lingp > 0 then call quitarobjetos(lingoteplata, objdata(itemindex).lingp, userindex)
    if objdata(itemindex).lingo > 0 then call quitarobjetos(lingoteoro, objdata(itemindex).lingo, userindex)
end sub

sub carpinteroquitarmateriales(byval userindex as integer, byval itemindex as integer)
    if objdata(itemindex).madera > 0 then call quitarobjetos(le�a, objdata(itemindex).madera, userindex)
end sub

function carpinterotienemateriales(byval userindex as integer, byval itemindex as integer) as boolean
    
    if objdata(itemindex).madera > 0 then
            if not tieneobjetos(le�a, objdata(itemindex).madera, userindex) then
                    call senddata(toindex, userindex, 0, "||no tenes suficientes madera." & fonttype_info)
                    carpinterotienemateriales = false
                    exit function
            end if
    end if
    
    carpinterotienemateriales = true

end function
 
function herrerotienemateriales(byval userindex as integer, byval itemindex as integer) as boolean
    if objdata(itemindex).lingh > 0 then
            if not tieneobjetos(lingotehierro, objdata(itemindex).lingh, userindex) then
                    call senddata(toindex, userindex, 0, "||no tenes suficientes lingotes de hierro." & fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    if objdata(itemindex).lingp > 0 then
            if not tieneobjetos(lingoteplata, objdata(itemindex).lingp, userindex) then
                    call senddata(toindex, userindex, 0, "||no tenes suficientes lingotes de plata." & fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    if objdata(itemindex).lingo > 0 then
            if not tieneobjetos(lingoteoro, objdata(itemindex).lingp, userindex) then
                    call senddata(toindex, userindex, 0, "||no tenes suficientes lingotes de oro." & fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    herrerotienemateriales = true
end function

public function puedeconstruir(byval userindex as integer, byval itemindex as integer) as boolean
puedeconstruir = herrerotienemateriales(userindex, itemindex) and userlist(userindex).stats.userskills(herreria) >= _
 objdata(itemindex).skherreria
end function

public function puedeconstruirherreria(byval itemindex as integer) as boolean
dim i as long

for i = 1 to ubound(armasherrero)
    if armasherrero(i) = itemindex then
        puedeconstruirherreria = true
        exit function
    end if
next i
for i = 1 to ubound(armadurasherrero)
    if armadurasherrero(i) = itemindex then
        puedeconstruirherreria = true
        exit function
    end if
next i
puedeconstruirherreria = false
end function


public sub herreroconstruiritem(byval userindex as integer, byval itemindex as integer)
'call logtarea("sub herreroconstruiritem")
if puedeconstruir(userindex, itemindex) and puedeconstruirherreria(itemindex) then
    call herreroquitarmateriales(userindex, itemindex)
    ' agregar fx
    if objdata(itemindex).objtype = objtype_weapon then
        call senddata(toindex, userindex, 0, "||has construido el arma!." & fonttype_info)
    elseif objdata(itemindex).objtype = objtype_escudo then
        call senddata(toindex, userindex, 0, "||has construido el escudo!." & fonttype_info)
    elseif objdata(itemindex).objtype = objtype_casco then
        call senddata(toindex, userindex, 0, "||has construido el casco!." & fonttype_info)
    elseif objdata(itemindex).objtype = objtype_armour then
        call senddata(toindex, userindex, 0, "||has construido la armadura!." & fonttype_info)
    end if
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = itemindex
    if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    call subirskill(userindex, herreria)
    call updateuserinv(true, userindex, 0)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & martilloherrero)
    
end if

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

end sub

public function puedeconstruircarpintero(byval itemindex as integer) as boolean
dim i as long

for i = 1 to ubound(objcarpintero)
    if objcarpintero(i) = itemindex then
        puedeconstruircarpintero = true
        exit function
    end if
next i
puedeconstruircarpintero = false

end function

public sub carpinteroconstruiritem(byval userindex as integer, byval itemindex as integer)

if carpinterotienemateriales(userindex, itemindex) and _
   userlist(userindex).stats.userskills(carpinteria) >= _
   objdata(itemindex).skcarpinteria and _
   puedeconstruircarpintero(itemindex) and _
   userlist(userindex).invent.herramientaeqpobjindex = serrucho_carpintero then

    call carpinteroquitarmateriales(userindex, itemindex)
    call senddata(toindex, userindex, 0, "||has construido el objeto!" & fonttype_info)
    
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = itemindex
    if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    
    call subirskill(userindex, carpinteria)
    call updateuserinv(true, userindex, 0)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "tw" & laburocarpintero)
end if

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

end sub

private function mineralesparalingote(byval lingote as iminerales) as integer
    select case lingote
        case iminerales.hierrocrudo
            mineralesparalingote = 13
        case iminerales.platacruda
            mineralesparalingote = 25
        case iminerales.orocrudo
            mineralesparalingote = 50
        case else
            mineralesparalingote = 10000
    end select
end function


public sub dolingotes(byval userindex as integer)
'    call logtarea("sub dolingotes")
dim slot as integer
dim obji as integer

    slot = userlist(userindex).flags.targetobjinvslot
    obji = userlist(userindex).invent.object(slot).objindex
    
    if userlist(userindex).invent.object(slot).amount < mineralesparalingote(obji) or _
        objdata(obji).objtype <> objtype_minerales then
            call senddata(toindex, userindex, 0, "||no tienes suficientes minerales para hacer un lingote." & fonttype_info)
            exit sub
    end if
    
    userlist(userindex).invent.object(slot).amount = userlist(userindex).invent.object(slot).amount - mineralesparalingote(obji)
    if userlist(userindex).invent.object(slot).amount < 1 then
        userlist(userindex).invent.object(slot).amount = 0
        userlist(userindex).invent.object(slot).objindex = 0
    end if
    call senddata(toindex, userindex, 0, "||has obtenido un lingote!!!" & fonttype_info)
    dim npos as worldpos
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = objdata(userlist(userindex).flags.targetobjinvindex).lingoteindex
    if not meteritemeninventario(userindex, miobj) then
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    call updateuserinv(false, userindex, slot)
    call senddata(toindex, userindex, 0, "||�has obtenido un lingote!" & fonttype_info)
    
    
    
'    if randomnumber(1, objdata(userlist(userindex).flags.targetobjinvindex).minskill) < 10 then
'                userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount = userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount - 5
'                if userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount < 1 then
'                    userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount = 0
'                    userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).objindex = 0
'                end if
'                call senddata(toindex, userindex, 0, "||has obtenido un lingote!!!" & fonttype_info)
'                dim npos as worldpos
'                dim miobj as obj
'                miobj.amount = 1
'                miobj.objindex = objdata(userlist(userindex).flags.targetobjinvindex).lingoteindex
'                if not meteritemeninventario(userindex, miobj) then
'                    call tiraritemalpiso(userlist(userindex).pos, miobj)
'                end if
'                call updateuserinv(false, userindex, userlist(userindex).flags.targetobjinvslot)
'                call senddata(toindex, userindex, 0, "||�has obtenido un lingote!" & fonttype_info)
'    else
'
'        userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount = userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount - 5
'        if userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount < 1 then
'                userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount = 0
'                userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).objindex = 0
'        end if
'        call updateuserinv(false, userindex, userlist(userindex).flags.targetobjinvslot)
'       '[cdt 17-02-2004]
'       if not userlist(userindex).flags.ultimomensaje = 7 then
'         call senddata(toindex, userindex, 0, "||los minerales no eran de buena calidad, no has logrado hacer un lingote." & fonttype_info)
'         userlist(userindex).flags.ultimomensaje = 7
'       end if
'       '[/cdt]
'    end if


'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

end sub

function modnavegacion(byval clase as string) as integer

select case ucase$(clase)
    case "pirata"
        modnavegacion = 1
    case "pescador"
        modnavegacion = 1.2
    case else
        modnavegacion = 2.3
end select

end function


function modfundicion(byval clase as string) as integer

select case ucase$(clase)
    case "minero"
        modfundicion = 1
    case "herrero"
        modfundicion = 1.2
    case else
        modfundicion = 3
end select

end function

function modcarpinteria(byval clase as string) as integer

select case ucase$(clase)
    case "carpintero"
        modcarpinteria = 1
    case else
        modcarpinteria = 3
end select

end function

function modherreria(byval clase as string) as integer

select case ucase$(clase)
    case "herrero"
        modherreria = 1
    case "minero"
        modherreria = 1.2
    case else
        modherreria = 4
end select

end function

function moddomar(byval clase as string) as integer
select case ucase$(clase)
    case "druida"
        moddomar = 6
    case "cazador"
        moddomar = 6
    case "clerigo"
        moddomar = 7
    case else
        moddomar = 10
end select
end function

function calcularpoderdomador(byval userindex as integer) as long
calcularpoderdomador = _
userlist(userindex).stats.useratributos(carisma) * _
(userlist(userindex).stats.userskills(domar) / moddomar(userlist(userindex).clase)) _
+ randomnumber(1, userlist(userindex).stats.useratributos(carisma) / 3) _
+ randomnumber(1, userlist(userindex).stats.useratributos(carisma) / 3) _
+ randomnumber(1, userlist(userindex).stats.useratributos(carisma) / 3)
end function
function freemascotaindex(byval userindex as integer) as integer
'call logtarea("sub freemascotaindex")
dim j as integer
for j = 1 to maxmascotas
    if userlist(userindex).mascotasindex(j) = 0 then
        freemascotaindex = j
        exit function
    end if
next j
end function
sub dodomar(byval userindex as integer, byval npcindex as integer)
'call logtarea("sub dodomar")

if userlist(userindex).nromacotas < maxmascotas then
    
    if npclist(npcindex).maestrouser = userindex then
        call senddata(toindex, userindex, 0, "||la criatura ya te ha aceptado como su amo." & fonttype_info)
        exit sub
    end if
    
    if npclist(npcindex).maestronpc > 0 or npclist(npcindex).maestrouser > 0 then
        call senddata(toindex, userindex, 0, "||la criatura ya tiene amo." & fonttype_info)
        exit sub
    end if
    
    if npclist(npcindex).flags.domable <= calcularpoderdomador(userindex) then
        dim index as integer
        userlist(userindex).nromacotas = userlist(userindex).nromacotas + 1
        index = freemascotaindex(userindex)
        userlist(userindex).mascotasindex(index) = npcindex
        userlist(userindex).mascotastype(index) = npclist(npcindex).numero
        
        npclist(npcindex).maestrouser = userindex
        
        call followamo(npcindex)
        
        call senddata(toindex, userindex, 0, "||la criatura te ha aceptado como su amo." & fonttype_info)
        call subirskill(userindex, domar)
        
    else
          '[cdt 17-02-2004]
          if not userlist(userindex).flags.ultimomensaje = 5 then
            call senddata(toindex, userindex, 0, "||no has logrado domar la criatura." & fonttype_info)
            userlist(userindex).flags.ultimomensaje = 5
          end if
          '[/cdt]
        
    end if
else
    call senddata(toindex, userindex, 0, "||no podes controlar mas criaturas." & fonttype_info)
end if
end sub

sub doadmininvisible(byval userindex as integer)
    
    if userlist(userindex).flags.admininvisible = 0 then
        
        userlist(userindex).flags.admininvisible = 1
        userlist(userindex).flags.invisible = 1
        userlist(userindex).flags.oldbody = userlist(userindex).char.body
        userlist(userindex).flags.oldhead = userlist(userindex).char.head
        userlist(userindex).char.body = 0
        userlist(userindex).char.head = 0
        
    else
        
        userlist(userindex).flags.admininvisible = 0
        userlist(userindex).flags.invisible = 0
        userlist(userindex).char.body = userlist(userindex).flags.oldbody
        userlist(userindex).char.head = userlist(userindex).flags.oldhead
        
    end if
    
    
    call changeuserchar(tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
    
end sub
sub tratardehacerfogata(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)

dim suerte as byte
dim exito as byte
dim raise as byte
dim obj as obj

if not legalpos(map, x, y) then exit sub

if mapdata(map, x, y).trigger = 4 or mapinfo(map).pk = false then
    call senddata(toindex, userindex, 0, "||en zona segura no puedes hacer fogatas." & fonttype_info)
    exit sub
end if

if mapdata(map, x, y).objinfo.amount < 3 then
    call senddata(toindex, userindex, 0, "||necesitas por lo menos tres troncos para hacer una fogata." & fonttype_info)
    exit sub
end if


if userlist(userindex).stats.userskills(supervivencia) >= 0 and userlist(userindex).stats.userskills(supervivencia) < 6 then
            suerte = 3
elseif userlist(userindex).stats.userskills(supervivencia) >= 6 and userlist(userindex).stats.userskills(supervivencia) <= 34 then
            suerte = 2
elseif userlist(userindex).stats.userskills(supervivencia) >= 35 then
            suerte = 1
end if

exito = randomnumber(1, suerte)

if exito = 1 then
    obj.objindex = fogata_apag
    obj.amount = mapdata(map, x, y).objinfo.amount / 3
    
    if obj.amount > 1 then
        call senddata(toindex, userindex, 0, "||has hecho " & obj.amount & " fogatas." & fonttype_info)
    else
        call senddata(toindex, userindex, 0, "||has hecho una fogata." & fonttype_info)
    end if
    
    call makeobj(tomap, 0, map, obj, map, x, y)
    
    dim fogatita as new cgarbage
    fogatita.map = map
    fogatita.x = x
    fogatita.y = y
    call trashcollector.add(fogatita)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 10 then
        call senddata(toindex, userindex, 0, "||no has podido hacer la fogata." & fonttype_info)
        userlist(userindex).flags.ultimomensaje = 10
    end if
    '[/cdt]
end if

call subirskill(userindex, supervivencia)


end sub

public sub dopescar(byval userindex as integer)
on error goto errhandler

dim suerte as integer
dim res as integer


if userlist(userindex).clase = "pescador" then
    call quitarsta(userindex, esfuerzopescarpescador)
else
    call quitarsta(userindex, esfuerzopescargeneral)
end if

if userlist(userindex).stats.userskills(pesca) <= 10 _
   and userlist(userindex).stats.userskills(pesca) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(pesca) <= 20 _
   and userlist(userindex).stats.userskills(pesca) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(pesca) <= 30 _
   and userlist(userindex).stats.userskills(pesca) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(pesca) <= 40 _
   and userlist(userindex).stats.userskills(pesca) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(pesca) <= 50 _
   and userlist(userindex).stats.userskills(pesca) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(pesca) <= 60 _
   and userlist(userindex).stats.userskills(pesca) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(pesca) <= 70 _
   and userlist(userindex).stats.userskills(pesca) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(pesca) <= 80 _
   and userlist(userindex).stats.userskills(pesca) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(pesca) <= 90 _
   and userlist(userindex).stats.userskills(pesca) >= 81 then
                    suerte = 13
elseif userlist(userindex).stats.userskills(pesca) <= 100 _
   and userlist(userindex).stats.userskills(pesca) >= 91 then
                    suerte = 7
end if
res = randomnumber(1, suerte)

if res < 6 then
    dim npos as worldpos
    dim miobj as obj
    
    miobj.amount = 1
    miobj.objindex = pescado
    
    if not meteritemeninventario(userindex, miobj) then
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    
    call senddata(toindex, userindex, 0, "||�has pescado un lindo pez!" & fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 6 then
      call senddata(toindex, userindex, 0, "||�no has pescado nada!" & fonttype_info)
      userlist(userindex).flags.ultimomensaje = 6
    end if
    '[/cdt]
end if

call subirskill(userindex, pesca)

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

exit sub

errhandler:
    call logerror("error en dopescar")
end sub

public sub dopescarred(byval userindex as integer)
on error goto errhandler

dim iskill as integer
dim suerte as integer
dim res as integer
dim espescador as boolean

if ucase(userlist(userindex).clase) = "pescador" then
    call quitarsta(userindex, esfuerzopescarpescador)
    espescador = true
else
    call quitarsta(userindex, esfuerzopescargeneral)
    espescador = false
end if

iskill = userlist(userindex).stats.userskills(pesca)

' m = (60-11)/(1-10)
' y = mx - m*10 + 11

select case iskill
case 0:         suerte = 0
case 1 to 10:   suerte = 60
case 11 to 20:  suerte = 54
case 21 to 30:  suerte = 49
case 31 to 40:  suerte = 43
case 41 to 50:  suerte = 38
case 51 to 60:  suerte = 32
case 61 to 70:  suerte = 27
case 71 to 80:  suerte = 21
case 81 to 90:  suerte = 16
case 91 to 100: suerte = 11
case else:      suerte = 0
end select

if suerte > 0 then
    res = randomnumber(1, suerte)
    
    if res < 6 then
        dim npos as worldpos
        dim miobj as obj
        dim pecesposibles(1 to 4) as integer
        
        pecesposibles(1) = pescado1
        pecesposibles(2) = pescado2
        pecesposibles(3) = pescado3
        pecesposibles(4) = pescado4
        
        if espescador = true then
            miobj.amount = randomnumber(1, 5)
        else
            miobj.amount = 1
        end if
        miobj.objindex = pecesposibles(randomnumber(lbound(pecesposibles), ubound(pecesposibles)))
        
        if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(userlist(userindex).pos, miobj)
        end if
        
        call senddata(toindex, userindex, 0, "||�has pescado algunos peces!" & fonttype_info)
        
    else
        call senddata(toindex, userindex, 0, "||�no has pescado nada!" & fonttype_info)
    end if
    
    call subirskill(userindex, pesca)
end if

exit sub

errhandler:
    call logerror("error en dopescarred")
end sub

public sub dorobar(byval ladronindex as integer, byval victimaindex as integer)

if mapinfo(userlist(victimaindex).pos.map).pk = 1 then exit sub
if userlist(ladronindex).flags.seguro then
    call senddata(toindex, ladronindex, 0, "||debes quitar el seguro para robar" & fonttype_fight)
    exit sub
end if

if triggerzonapelea(ladronindex, victimaindex) <> trigger6_ausente then exit sub

if userlist(victimaindex).flags.privilegios = 0 then
    dim suerte as integer
    dim res as integer
    
       
    if userlist(ladronindex).stats.userskills(robar) <= 10 _
       and userlist(ladronindex).stats.userskills(robar) >= -1 then
                        suerte = 35
    elseif userlist(ladronindex).stats.userskills(robar) <= 20 _
       and userlist(ladronindex).stats.userskills(robar) >= 11 then
                        suerte = 30
    elseif userlist(ladronindex).stats.userskills(robar) <= 30 _
       and userlist(ladronindex).stats.userskills(robar) >= 21 then
                        suerte = 28
    elseif userlist(ladronindex).stats.userskills(robar) <= 40 _
       and userlist(ladronindex).stats.userskills(robar) >= 31 then
                        suerte = 24
    elseif userlist(ladronindex).stats.userskills(robar) <= 50 _
       and userlist(ladronindex).stats.userskills(robar) >= 41 then
                        suerte = 22
    elseif userlist(ladronindex).stats.userskills(robar) <= 60 _
       and userlist(ladronindex).stats.userskills(robar) >= 51 then
                        suerte = 20
    elseif userlist(ladronindex).stats.userskills(robar) <= 70 _
       and userlist(ladronindex).stats.userskills(robar) >= 61 then
                        suerte = 18
    elseif userlist(ladronindex).stats.userskills(robar) <= 80 _
       and userlist(ladronindex).stats.userskills(robar) >= 71 then
                        suerte = 15
    elseif userlist(ladronindex).stats.userskills(robar) <= 90 _
       and userlist(ladronindex).stats.userskills(robar) >= 81 then
                        suerte = 10
    elseif userlist(ladronindex).stats.userskills(robar) <= 100 _
       and userlist(ladronindex).stats.userskills(robar) >= 91 then
                        suerte = 5
    end if
    res = randomnumber(1, suerte)
    
    if res < 3 then 'exito robo
       
        if (randomnumber(1, 50) < 25) and (ucase$(userlist(ladronindex).clase) = "ladron") then
            if tieneobjetosrobables(victimaindex) then
                call robarobjeto(ladronindex, victimaindex)
            else
                call senddata(toindex, ladronindex, 0, "||" & userlist(victimaindex).name & " no tiene objetos." & fonttype_info)
            end if
        else 'roba oro
            if userlist(victimaindex).stats.gld > 0 then
                dim n as integer
                
                if ucase$(userlist(ladronindex).clase) = "ladron" then
                    n = randomnumber(100, 1000)
                else
                    n = randomnumber(1, 100)
                end if
                if n > userlist(victimaindex).stats.gld then n = userlist(victimaindex).stats.gld
                userlist(victimaindex).stats.gld = userlist(victimaindex).stats.gld - n
                
                call addtovar(userlist(ladronindex).stats.gld, n, maxoro)
                
                call senddata(toindex, ladronindex, 0, "||le has robado " & n & " monedas de oro a " & userlist(victimaindex).name & fonttype_info)
            else
                call senddata(toindex, ladronindex, 0, "||" & userlist(victimaindex).name & " no tiene oro." & fonttype_info)
            end if
        end if
    else
        call senddata(toindex, ladronindex, 0, "||�no has logrado robar nada!" & fonttype_info)
        call senddata(toindex, victimaindex, 0, "||�" & userlist(ladronindex).name & " ha intentado robarte!" & fonttype_info)
        call senddata(toindex, victimaindex, 0, "||�" & userlist(ladronindex).name & " es un criminal!" & fonttype_info)
    end if

    if not criminal(ladronindex) then
            call volvercriminal(ladronindex)
    end if
    
    if userlist(ladronindex).faccion.armadareal = 1 then call expulsarfaccionreal(ladronindex)

    call addtovar(userlist(ladronindex).reputacion.ladronesrep, vlladron, maxrep)
    call subirskill(ladronindex, robar)

end if


end sub


public function objesrobable(byval victimaindex as integer, byval slot as integer) as boolean
' agregu� los barcos
' esta funcion determina qu� objetos son robables.

dim oi as integer

oi = userlist(victimaindex).invent.object(slot).objindex

objesrobable = _
objdata(oi).objtype <> objtype_llaves and _
userlist(victimaindex).invent.object(slot).equipped = 0 and _
objdata(oi).real = 0 and _
objdata(oi).caos = 0 and _
objdata(oi).objtype <> objtype_barcos

end function

public sub robarobjeto(byval ladronindex as integer, byval victimaindex as integer)
'call logtarea("sub robarobjeto")
dim flag as boolean
dim i as integer
flag = false

if randomnumber(1, 12) < 6 then 'comenzamos por el principio o el final?
    i = 1
    do while not flag and i <= max_inventory_slots
        'hay objeto en este slot?
        if userlist(victimaindex).invent.object(i).objindex > 0 then
           if objesrobable(victimaindex, i) then
                 if randomnumber(1, 10) < 4 then flag = true
           end if
        end if
        if not flag then i = i + 1
    loop
else
    i = 20
    do while not flag and i > 0
      'hay objeto en este slot?
      if userlist(victimaindex).invent.object(i).objindex > 0 then
         if objesrobable(victimaindex, i) then
               if randomnumber(1, 10) < 4 then flag = true
         end if
      end if
      if not flag then i = i - 1
    loop
end if

if flag then
    dim miobj as obj
    dim num as byte
    'cantidad al azar
    num = randomnumber(1, 5)
                
    if num > userlist(victimaindex).invent.object(i).amount then
         num = userlist(victimaindex).invent.object(i).amount
    end if
                
    miobj.amount = num
    miobj.objindex = userlist(victimaindex).invent.object(i).objindex
    
    userlist(victimaindex).invent.object(i).amount = userlist(victimaindex).invent.object(i).amount - num
                
    if userlist(victimaindex).invent.object(i).amount <= 0 then
          call quitaruserinvitem(victimaindex, cbyte(i), 1)
    end if
            
    call updateuserinv(false, victimaindex, cbyte(i))
                
    if not meteritemeninventario(ladronindex, miobj) then
        call tiraritemalpiso(userlist(ladronindex).pos, miobj)
    end if
    
    call senddata(toindex, ladronindex, 0, "||has robado " & miobj.amount & " " & objdata(miobj.objindex).name & fonttype_info)
else
    call senddata(toindex, ladronindex, 0, "||no has logrado robar un objetos." & fonttype_info)
end if

end sub
public sub doapu�alar(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as integer)

dim suerte as integer
dim res as integer

if userlist(userindex).stats.userskills(apu�alar) <= 10 _
   and userlist(userindex).stats.userskills(apu�alar) >= -1 then
                    suerte = 200
elseif userlist(userindex).stats.userskills(apu�alar) <= 20 _
   and userlist(userindex).stats.userskills(apu�alar) >= 11 then
                    suerte = 190
elseif userlist(userindex).stats.userskills(apu�alar) <= 30 _
   and userlist(userindex).stats.userskills(apu�alar) >= 21 then
                    suerte = 180
elseif userlist(userindex).stats.userskills(apu�alar) <= 40 _
   and userlist(userindex).stats.userskills(apu�alar) >= 31 then
                    suerte = 170
elseif userlist(userindex).stats.userskills(apu�alar) <= 50 _
   and userlist(userindex).stats.userskills(apu�alar) >= 41 then
                    suerte = 160
elseif userlist(userindex).stats.userskills(apu�alar) <= 60 _
   and userlist(userindex).stats.userskills(apu�alar) >= 51 then
                    suerte = 150
elseif userlist(userindex).stats.userskills(apu�alar) <= 70 _
   and userlist(userindex).stats.userskills(apu�alar) >= 61 then
                    suerte = 140
elseif userlist(userindex).stats.userskills(apu�alar) <= 80 _
   and userlist(userindex).stats.userskills(apu�alar) >= 71 then
                    suerte = 130
elseif userlist(userindex).stats.userskills(apu�alar) <= 90 _
   and userlist(userindex).stats.userskills(apu�alar) >= 81 then
                    suerte = 120
elseif userlist(userindex).stats.userskills(apu�alar) < 100 _
   and userlist(userindex).stats.userskills(apu�alar) >= 91 then
                    suerte = 110
elseif userlist(userindex).stats.userskills(apu�alar) = 100 then
                    suerte = 100
end if

if ucase$(userlist(userindex).clase) = "asesino" then
    res = randomnumber(0, suerte)
    if res < 25 then res = 0
else
    res = randomnumber(0, suerte * 1.25)
end if

if res < 15 then
    if victimuserindex <> 0 then
        userlist(victimuserindex).stats.minhp = userlist(victimuserindex).stats.minhp - int(da�o * 1.5)
        call senddata(toindex, userindex, 0, "||has apu�alado a " & userlist(victimuserindex).name & " por " & int(da�o * 1.5) & fonttype_fight)
        call senddata(toindex, victimuserindex, 0, "||te ha apu�alado " & userlist(userindex).name & " por " & int(da�o * 1.5) & fonttype_fight)
    else
        npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - int(da�o * 2)
        call senddata(toindex, userindex, 0, "||has apu�alado la criatura por " & int(da�o * 2) & fonttype_fight)
        call subirskill(userindex, apu�alar)
        '[alejo]
        call calculardarexp(userindex, victimnpcindex, int(da�o * 2))
    end if
else
    call senddata(toindex, userindex, 0, "||�no has logrado apu�alar a tu enemigo!" & fonttype_fight)
end if

end sub

public sub quitarsta(byval userindex as integer, byval cantidad as integer)
userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - cantidad
if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
end sub

public sub dotalar(byval userindex as integer)
on error goto errhandler

dim suerte as integer
dim res as integer


if userlist(userindex).clase = "le�ador" then
    call quitarsta(userindex, esfuerzotalarle�ador)
else
    call quitarsta(userindex, esfuerzotalargeneral)
end if

if userlist(userindex).stats.userskills(talar) <= 10 _
   and userlist(userindex).stats.userskills(talar) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(talar) <= 20 _
   and userlist(userindex).stats.userskills(talar) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(talar) <= 30 _
   and userlist(userindex).stats.userskills(talar) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(talar) <= 40 _
   and userlist(userindex).stats.userskills(talar) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(talar) <= 50 _
   and userlist(userindex).stats.userskills(talar) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(talar) <= 60 _
   and userlist(userindex).stats.userskills(talar) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(talar) <= 70 _
   and userlist(userindex).stats.userskills(talar) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(talar) <= 80 _
   and userlist(userindex).stats.userskills(talar) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(talar) <= 90 _
   and userlist(userindex).stats.userskills(talar) >= 81 then
                    suerte = 13
elseif userlist(userindex).stats.userskills(talar) <= 100 _
   and userlist(userindex).stats.userskills(talar) >= 91 then
                    suerte = 7
end if
res = randomnumber(1, suerte)

if res < 6 then
    dim npos as worldpos
    dim miobj as obj
    
    if userlist(userindex).clase = "le�ador" then
        miobj.amount = randomnumber(1, 5)
    else
        miobj.amount = 1
    end if
    
    miobj.objindex = le�a
    
    
    if not meteritemeninventario(userindex, miobj) then
        
        call tiraritemalpiso(userlist(userindex).pos, miobj)
        
    end if
    
    call senddata(toindex, userindex, 0, "||�has conseguido algo de le�a!" & fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 8 then
        call senddata(toindex, userindex, 0, "||�no has obtenido le�a!" & fonttype_info)
        userlist(userindex).flags.ultimomensaje = 8
    end if
    '[/cdt]
end if

call subirskill(userindex, talar)

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

exit sub

errhandler:
    call logerror("error en dotalar")

end sub

sub volvercriminal(byval userindex as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

if userlist(userindex).flags.privilegios < 2 then
    userlist(userindex).reputacion.burguesrep = 0
    userlist(userindex).reputacion.noblerep = 0
    userlist(userindex).reputacion.pleberep = 0
    call addtovar(userlist(userindex).reputacion.bandidorep, vlasalto, maxrep)
    if userlist(userindex).faccion.armadareal = 1 then call expulsarfaccionreal(userindex)
end if

end sub

sub volverciudadano(byval userindex as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

userlist(userindex).reputacion.ladronesrep = 0
userlist(userindex).reputacion.bandidorep = 0
userlist(userindex).reputacion.asesinorep = 0
call addtovar(userlist(userindex).reputacion.pleberep, vlasalto, maxrep)

end sub


public sub doplayinstrumento(byval userindex as integer)

end sub

public sub domineria(byval userindex as integer)
on error goto errhandler

dim suerte as integer
dim res as integer
dim metal as integer

if userlist(userindex).clase = "minero" then
    call quitarsta(userindex, esfuerzoexcavarminero)
else
    call quitarsta(userindex, esfuerzoexcavargeneral)
end if

if userlist(userindex).stats.userskills(mineria) <= 10 _
   and userlist(userindex).stats.userskills(mineria) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(mineria) <= 20 _
   and userlist(userindex).stats.userskills(mineria) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(mineria) <= 30 _
   and userlist(userindex).stats.userskills(mineria) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(mineria) <= 40 _
   and userlist(userindex).stats.userskills(mineria) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(mineria) <= 50 _
   and userlist(userindex).stats.userskills(mineria) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(mineria) <= 60 _
   and userlist(userindex).stats.userskills(mineria) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(mineria) <= 70 _
   and userlist(userindex).stats.userskills(mineria) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(mineria) <= 80 _
   and userlist(userindex).stats.userskills(mineria) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(mineria) <= 90 _
   and userlist(userindex).stats.userskills(mineria) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(mineria) <= 100 _
   and userlist(userindex).stats.userskills(mineria) >= 91 then
                    suerte = 7
end if
res = randomnumber(1, suerte)

if res <= 5 then
    dim miobj as obj
    dim npos as worldpos
    
    if userlist(userindex).flags.targetobj = 0 then exit sub
    
    miobj.objindex = objdata(userlist(userindex).flags.targetobj).mineralindex
    
    if userlist(userindex).clase = "minero" then
        miobj.amount = randomnumber(1, 6)
    else
        miobj.amount = 1
    end if
    
    if not meteritemeninventario(userindex, miobj) then _
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    
    call senddata(toindex, userindex, 0, "||�has extraido algunos minerales!" & fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 9 then
        call senddata(toindex, userindex, 0, "||�no has conseguido nada!" & fonttype_info)
        userlist(userindex).flags.ultimomensaje = 9
    end if
    '[/cdt]
end if

call subirskill(userindex, mineria)

'[barrin 30-11-03]
userlist(userindex).flags.trabajando = true
'[/barrin 30-11-03]

exit sub

errhandler:
    call logerror("error en sub domineria")

end sub



public sub domeditar(byval userindex as integer)

userlist(userindex).counters.idlecount = 0

dim suerte as integer
dim res as integer
dim cant as integer

'barrin 3/10/03
'esperamos a que se termine de concentrar
dim tactual as long
tactual = gettickcount() and &h7fffffff
if tactual - userlist(userindex).counters.tiniciomeditar < tiempo_iniciomeditar then
    exit sub
end if

if userlist(userindex).counters.bpuedemeditar = false then
    userlist(userindex).counters.bpuedemeditar = true
end if
if userlist(userindex).counters.bpuedemeditar = false then exit sub

if userlist(userindex).stats.minman >= userlist(userindex).stats.maxman then
    call senddata(toindex, userindex, 0, "||has terminado de meditar." & fonttype_info)
    call senddata(toindex, userindex, 0, "medok")
    userlist(userindex).flags.meditando = false
    userlist(userindex).char.fx = 0
    userlist(userindex).char.loops = 0
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
    exit sub
end if

if userlist(userindex).stats.userskills(meditar) <= 10 _
   and userlist(userindex).stats.userskills(meditar) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(meditar) <= 20 _
   and userlist(userindex).stats.userskills(meditar) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(meditar) <= 30 _
   and userlist(userindex).stats.userskills(meditar) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(meditar) <= 40 _
   and userlist(userindex).stats.userskills(meditar) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(meditar) <= 50 _
   and userlist(userindex).stats.userskills(meditar) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(meditar) <= 60 _
   and userlist(userindex).stats.userskills(meditar) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(meditar) <= 70 _
   and userlist(userindex).stats.userskills(meditar) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(meditar) <= 80 _
   and userlist(userindex).stats.userskills(meditar) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(meditar) <= 90 _
   and userlist(userindex).stats.userskills(meditar) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(meditar) <= 100 _
   and userlist(userindex).stats.userskills(meditar) >= 91 then
                    suerte = 5
end if
res = randomnumber(1, suerte)

if res = 1 then
    cant = porcentaje(userlist(userindex).stats.maxman, 3)
    call addtovar(userlist(userindex).stats.minman, cant, userlist(userindex).stats.maxman)
    call senddata(toindex, userindex, 0, "||�has recuperado " & cant & " puntos de mana!" & fonttype_info)
    call senduserstatsbox(userindex)
    call subirskill(userindex, meditar)
end if

end sub



public sub desarmar(byval userindex as integer, byval victimindex as integer)

dim suerte as integer
dim res as integer

if userlist(userindex).stats.userskills(wresterling) <= 10 _
   and userlist(userindex).stats.userskills(wresterling) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(wresterling) <= 20 _
   and userlist(userindex).stats.userskills(wresterling) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(wresterling) <= 30 _
   and userlist(userindex).stats.userskills(wresterling) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(wresterling) <= 40 _
   and userlist(userindex).stats.userskills(wresterling) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(wresterling) <= 50 _
   and userlist(userindex).stats.userskills(wresterling) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(wresterling) <= 60 _
   and userlist(userindex).stats.userskills(wresterling) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(wresterling) <= 70 _
   and userlist(userindex).stats.userskills(wresterling) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(wresterling) <= 80 _
   and userlist(userindex).stats.userskills(wresterling) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(wresterling) <= 90 _
   and userlist(userindex).stats.userskills(wresterling) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(wresterling) <= 100 _
   and userlist(userindex).stats.userskills(wresterling) >= 91 then
                    suerte = 5
end if
res = randomnumber(1, suerte)

if res <= 2 then
        call desequipar(victimindex, userlist(victimindex).invent.weaponeqpslot)
        call senddata(toindex, userindex, 0, "||has logrado desarmar a tu oponente!" & fonttype_fight)
        if userlist(victimindex).stats.elv < 20 then call senddata(toindex, victimindex, 0, "||tu oponente te ha desarmado!" & fonttype_fight)
    end if
end sub

