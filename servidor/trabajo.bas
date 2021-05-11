attribute vb_name = "trabajo"
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

public sub dopermaneceroculto(byval userindex as integer)
'********************************************************
'autor: nacho (integer)
'last modif: 28/01/2007
'chequea si ya debe mostrarse
'pablo (toxicwaste): cambie los ordenes de prioridades porque sino no andaba.
'********************************************************

userlist(userindex).counters.tiempooculto = userlist(userindex).counters.tiempooculto - 1
if userlist(userindex).counters.tiempooculto <= 0 then
    
    userlist(userindex).counters.tiempooculto = intervalooculto
    if userlist(userindex).clase = eclass.hunter and userlist(userindex).stats.userskills(eskill.ocultarse) > 90 then
        if userlist(userindex).invent.armoureqpobjindex = 648 or userlist(userindex).invent.armoureqpobjindex = 360 then
            exit sub
        end if
    end if
    userlist(userindex).counters.tiempooculto = 0
    userlist(userindex).flags.oculto = 0
    call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, false))
    call writeconsolemsg(userindex, "�has vuelto a ser visible!", fonttypenames.fonttype_info)
end if



exit sub

errhandler:
    call logerror("error en sub dopermaneceroculto")


end sub

public sub doocultarse(byval userindex as integer)
'pablo (toxicwaste): no olvidar agregar intervalooculto=500 al server.ini.
'modifique la f�rmula y ahora anda bien.
on error goto errhandler

dim suerte as double
dim res as integer
dim skill as integer
skill = userlist(userindex).stats.userskills(eskill.ocultarse)

suerte = (((0.000002 * skill - 0.0002) * skill + 0.0064) * skill + 0.1124) * 100

res = randomnumber(1, 100)

if res <= suerte then

    userlist(userindex).flags.oculto = 1
    suerte = (-0.000001 * (100 - skill) ^ 3)
    suerte = suerte + (0.00009229 * (100 - skill) ^ 2)
    suerte = suerte + (-0.0088 * (100 - skill))
    suerte = suerte + (0.9571)
    suerte = suerte * intervalooculto
    userlist(userindex).counters.tiempooculto = suerte
  
    call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, true))

    call writeconsolemsg(userindex, "�te has escondido entre las sombras!", fonttypenames.fonttype_info)
    call subirskill(userindex, ocultarse)
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 4 then
        call writeconsolemsg(userindex, "�no has logrado esconderte!", fonttypenames.fonttype_info)
        userlist(userindex).flags.ultimomensaje = 4
    end if
    '[/cdt]
end if

userlist(userindex).counters.ocultando = userlist(userindex).counters.ocultando + 1

exit sub

errhandler:
    call logerror("error en sub doocultarse")

end sub


public sub donavega(byval userindex as integer, byref barco as objdata, byval slot as integer)

dim modnave as long
modnave = modnavegacion(userlist(userindex).clase)

if userlist(userindex).stats.userskills(eskill.navegacion) / modnave < barco.minskill then
    call writeconsolemsg(userindex, "no tenes suficientes conocimientos para usar este barco.", fonttypenames.fonttype_info)
    call writeconsolemsg(userindex, "para usar este barco necesitas " & barco.minskill * modnave & " puntos en navegacion.", fonttypenames.fonttype_info)
    exit sub
end if

userlist(userindex).invent.barcoobjindex = userlist(userindex).invent.object(slot).objindex
userlist(userindex).invent.barcoslot = slot

if userlist(userindex).flags.navegando = 0 then
    
    userlist(userindex).char.head = 0
    
    if userlist(userindex).flags.muerto = 0 then
        '(nacho)
        if userlist(userindex).faccion.armadareal = 1 then
            userlist(userindex).char.body = ifragatareal
        elseif userlist(userindex).faccion.fuerzascaos = 1 then
            userlist(userindex).char.body = ifragatacaos
        else
            userlist(userindex).char.body = barco.ropaje
        end if
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

call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
call writenavigatetoggle(userindex)

end sub

public sub fundirmineral(byval userindex as integer)
'call logtarea("sub fundirmineral")

if userlist(userindex).flags.targetobjinvindex > 0 then
   
   if objdata(userlist(userindex).flags.targetobjinvindex).objtype = eobjtype.otminerales and objdata(userlist(userindex).flags.targetobjinvindex).minskill <= userlist(userindex).stats.userskills(eskill.mineria) / modfundicion(userlist(userindex).clase) then
        call dolingotes(userindex)
   else
        call writeconsolemsg(userindex, "no tenes conocimientos de mineria suficientes para trabajar este mineral.", fonttypenames.fonttype_info)
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
                    call writeconsolemsg(userindex, "no tenes suficientes madera.", fonttypenames.fonttype_info)
                    carpinterotienemateriales = false
                    exit function
            end if
    end if
    
    carpinterotienemateriales = true

end function
 
function herrerotienemateriales(byval userindex as integer, byval itemindex as integer) as boolean
    if objdata(itemindex).lingh > 0 then
            if not tieneobjetos(lingotehierro, objdata(itemindex).lingh, userindex) then
                    call writeconsolemsg(userindex, "no tenes suficientes lingotes de hierro.", fonttypenames.fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    if objdata(itemindex).lingp > 0 then
            if not tieneobjetos(lingoteplata, objdata(itemindex).lingp, userindex) then
                    call writeconsolemsg(userindex, "no tenes suficientes lingotes de plata.", fonttypenames.fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    if objdata(itemindex).lingo > 0 then
            if not tieneobjetos(lingoteoro, objdata(itemindex).lingo, userindex) then
                    call writeconsolemsg(userindex, "no tenes suficientes lingotes de oro.", fonttypenames.fonttype_info)
                    herrerotienemateriales = false
                    exit function
            end if
    end if
    herrerotienemateriales = true
end function

public function puedeconstruir(byval userindex as integer, byval itemindex as integer) as boolean
puedeconstruir = herrerotienemateriales(userindex, itemindex) and userlist(userindex).stats.userskills(eskill.herreria) >= _
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
    if objdata(itemindex).objtype = eobjtype.otweapon then
        call writeconsolemsg(userindex, "has construido el arma!.", fonttypenames.fonttype_info)
    elseif objdata(itemindex).objtype = eobjtype.otescudo then
        call writeconsolemsg(userindex, "has construido el escudo!.", fonttypenames.fonttype_info)
    elseif objdata(itemindex).objtype = eobjtype.otcasco then
        call writeconsolemsg(userindex, "has construido el casco!.", fonttypenames.fonttype_info)
    elseif objdata(itemindex).objtype = eobjtype.otarmadura then
        call writeconsolemsg(userindex, "has construido la armadura!.", fonttypenames.fonttype_info)
    end if
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = itemindex
    if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    call subirskill(userindex, herreria)
    call updateuserinv(true, userindex, 0)
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(martilloherrero))
    
end if

userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1

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
   userlist(userindex).stats.userskills(eskill.carpinteria) >= _
   objdata(itemindex).skcarpinteria and _
   puedeconstruircarpintero(itemindex) and _
   userlist(userindex).invent.weaponeqpobjindex = serrucho_carpintero then

    call carpinteroquitarmateriales(userindex, itemindex)
    call writeconsolemsg(userindex, "has construido el objeto!.", fonttypenames.fonttype_info)
    
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = itemindex
    if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    
    call subirskill(userindex, carpinteria)
    call updateuserinv(true, userindex, 0)
    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(laburocarpintero))
end if

userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1

end sub

private function mineralesparalingote(byval lingote as iminerales) as integer
    select case lingote
        case iminerales.hierrocrudo
            mineralesparalingote = 14
        case iminerales.platacruda
            mineralesparalingote = 20
        case iminerales.orocrudo
            mineralesparalingote = 35
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
        objdata(obji).objtype <> eobjtype.otminerales then
            call writeconsolemsg(userindex, "no tienes suficientes minerales para hacer un lingote.", fonttypenames.fonttype_info)
            exit sub
    end if
    
    userlist(userindex).invent.object(slot).amount = userlist(userindex).invent.object(slot).amount - mineralesparalingote(obji)
    if userlist(userindex).invent.object(slot).amount < 1 then
        userlist(userindex).invent.object(slot).amount = 0
        userlist(userindex).invent.object(slot).objindex = 0
    end if
    
    dim npos as worldpos
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = objdata(userlist(userindex).flags.targetobjinvindex).lingoteindex
    if not meteritemeninventario(userindex, miobj) then
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    call updateuserinv(false, userindex, slot)
    call writeconsolemsg(userindex, "�has obtenido un lingote!", fonttypenames.fonttype_info)

    userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1
end sub

function modnavegacion(byval clase as eclass) as integer

select case clase
    case eclass.pirat
        modnavegacion = 1
    case eclass.fisher
        modnavegacion = 1.2
    case else
        modnavegacion = 2.3
end select

end function


function modfundicion(byval clase as eclass) as integer

select case clase
    case eclass.miner
        modfundicion = 1
    case eclass.blacksmith
        modfundicion = 1.2
    case else
        modfundicion = 3
end select

end function

function modcarpinteria(byval clase as eclass) as integer

select case clase
    case eclass.carpenter
        modcarpinteria = 1
    case else
        modcarpinteria = 3
end select

end function

function modherreria(byval clase as eclass) as integer

select case clase
    case eclass.blacksmith
        modherreria = 1
    case eclass.miner
        modherreria = 1.2
    case else
        modherreria = 4
end select

end function

function moddomar(byval clase as eclass) as integer
    select case clase
        case eclass.druid
            moddomar = 6
        case eclass.hunter
            moddomar = 6
        case eclass.cleric
            moddomar = 7
        case else
            moddomar = 10
    end select
end function

function calcularpoderdomador(byval userindex as integer) as long
    with userlist(userindex).stats
        calcularpoderdomador = .useratributos(eatributos.carisma) _
            * (.userskills(eskill.domar) / moddomar(userlist(userindex).clase)) _
            + randomnumber(1, .useratributos(eatributos.carisma) / 3) _
            + randomnumber(1, .useratributos(eatributos.carisma) / 3) _
            + randomnumber(1, .useratributos(eatributos.carisma) / 3)
    end with
end function

function freemascotaindex(byval userindex as integer) as integer
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
        call writeconsolemsg(userindex, "la criatura ya te ha aceptado como su amo.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if npclist(npcindex).maestronpc > 0 or npclist(npcindex).maestrouser > 0 then
        call writeconsolemsg(userindex, "la criatura ya tiene amo.", fonttypenames.fonttype_info)
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
        
        call writeconsolemsg(userindex, "la criatura te ha aceptado como su amo.", fonttypenames.fonttype_info)
        call subirskill(userindex, domar)
    else
        if not userlist(userindex).flags.ultimomensaje = 5 then
            call writeconsolemsg(userindex, "no has logrado domar la criatura.", fonttypenames.fonttype_info)
            userlist(userindex).flags.ultimomensaje = 5
        end if
    end if
else
    call writeconsolemsg(userindex, "no podes controlar mas criaturas.", fonttypenames.fonttype_info)
end if
end sub

sub doadmininvisible(byval userindex as integer)
    
    if userlist(userindex).flags.admininvisible = 0 then
        
        ' sacamos el mimetizmo
        if userlist(userindex).flags.mimetizado = 1 then
            userlist(userindex).char.body = userlist(userindex).charmimetizado.body
            userlist(userindex).char.head = userlist(userindex).charmimetizado.head
            userlist(userindex).char.cascoanim = userlist(userindex).charmimetizado.cascoanim
            userlist(userindex).char.shieldanim = userlist(userindex).charmimetizado.shieldanim
            userlist(userindex).char.weaponanim = userlist(userindex).charmimetizado.weaponanim
            userlist(userindex).counters.mimetismo = 0
            userlist(userindex).flags.mimetizado = 0
        end if
        
        userlist(userindex).flags.admininvisible = 1
        userlist(userindex).flags.invisible = 1
        userlist(userindex).flags.oculto = 1
        userlist(userindex).flags.oldbody = userlist(userindex).char.body
        userlist(userindex).flags.oldhead = userlist(userindex).char.head
        userlist(userindex).char.body = 0
        userlist(userindex).char.head = 0
        
    else
        
        userlist(userindex).flags.admininvisible = 0
        userlist(userindex).flags.invisible = 0
        userlist(userindex).flags.oculto = 0
        userlist(userindex).counters.tiempooculto = 0
        userlist(userindex).char.body = userlist(userindex).flags.oldbody
        userlist(userindex).char.head = userlist(userindex).flags.oldhead
        
    end if
    
    'vuelve a ser visible por la fuerza
    call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
    call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, false))
end sub

sub tratardehacerfogata(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)

dim suerte as byte
dim exito as byte
dim raise as byte
dim obj as obj
dim posmadera as worldpos

if not legalpos(map, x, y) then exit sub

with posmadera
    .map = map
    .x = x
    .y = y
end with

if mapdata(map, x, y).objinfo.objindex <> 58 then
    call writeconsolemsg(userindex, "necesitas clickear sobre le�a para hacer ramitas", fonttypenames.fonttype_info)
    exit sub
end if

if distancia(posmadera, userlist(userindex).pos) > 2 then
    call writeconsolemsg(userindex, "est�s demasiado lejos para prender la fogata.", fonttypenames.fonttype_info)
    exit sub
end if

if userlist(userindex).flags.muerto = 1 then
    call writeconsolemsg(userindex, "no puedes hacer fogatas estando muerto.", fonttypenames.fonttype_info)
    exit sub
end if

if mapdata(map, x, y).objinfo.amount < 3 then
    call writeconsolemsg(userindex, "necesitas por lo menos tres troncos para hacer una fogata.", fonttypenames.fonttype_info)
    exit sub
end if


if userlist(userindex).stats.userskills(eskill.supervivencia) >= 0 and userlist(userindex).stats.userskills(eskill.supervivencia) < 6 then
    suerte = 3
elseif userlist(userindex).stats.userskills(eskill.supervivencia) >= 6 and userlist(userindex).stats.userskills(eskill.supervivencia) <= 34 then
    suerte = 2
elseif userlist(userindex).stats.userskills(eskill.supervivencia) >= 35 then
    suerte = 1
end if

exito = randomnumber(1, suerte)

if exito = 1 then
    obj.objindex = fogata_apag
    obj.amount = mapdata(map, x, y).objinfo.amount \ 3
    
    call writeconsolemsg(userindex, "has hecho " & obj.amount & " fogatas.", fonttypenames.fonttype_info)
    
    call makeobj(map, obj, map, x, y)
    
    'seteamos la fogata como el nuevo targetobj del user
    userlist(userindex).flags.targetobj = fogata_apag
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 10 then
        call writeconsolemsg(userindex, "no has podido hacer la fogata.", fonttypenames.fonttype_info)
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


if userlist(userindex).clase = eclass.fisher then
    call quitarsta(userindex, esfuerzopescarpescador)
else
    call quitarsta(userindex, esfuerzopescargeneral)
end if

dim skill as integer
skill = userlist(userindex).stats.userskills(eskill.pesca)
suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)

res = randomnumber(1, suerte)

if res < 6 then
    dim npos as worldpos
    dim miobj as obj
    
    if userlist(userindex).clase = eclass.fisher then
        miobj.amount = randomnumber(1, 4)
    else
        miobj.amount = 1
    end if
    miobj.objindex = pescado
    
    if not meteritemeninventario(userindex, miobj) then
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    end if
    
    call writeconsolemsg(userindex, "�has pescado un lindo pez!", fonttypenames.fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 6 then
      call writeconsolemsg(userindex, "�no has pescado nada!", fonttypenames.fonttype_info)
      userlist(userindex).flags.ultimomensaje = 6
    end if
    '[/cdt]
end if

call subirskill(userindex, pesca)

userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1

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

if userlist(userindex).clase = eclass.fisher then
    call quitarsta(userindex, esfuerzopescarpescador)
    espescador = true
else
    call quitarsta(userindex, esfuerzopescargeneral)
    espescador = false
end if

iskill = userlist(userindex).stats.userskills(eskill.pesca)

' m = (60-11)/(1-10)
' y = mx - m*10 + 11

suerte = int(-0.00125 * iskill * iskill - 0.3 * iskill + 49)

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
        
        call writeconsolemsg(userindex, "�has pescado algunos peces!", fonttypenames.fonttype_info)
        
    else
        call writeconsolemsg(userindex, "�no has pescado nada!", fonttypenames.fonttype_info)
    end if
    
    call subirskill(userindex, pesca)
end if

    userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
    if userlist(userindex).reputacion.pleberep > maxrep then _
        userlist(userindex).reputacion.pleberep = maxrep
        
exit sub

errhandler:
    call logerror("error en dopescarred")
end sub

public sub dorobar(byval ladronindex as integer, byval victimaindex as integer)

if not mapinfo(userlist(victimaindex).pos.map).pk then exit sub

if userlist(ladronindex).flags.seguro then
    call writeconsolemsg(ladronindex, "debes quitar el seguro para robar", fonttypenames.fonttype_fight)
    exit sub
end if

if triggerzonapelea(ladronindex, victimaindex) <> trigger6_ausente then exit sub

if userlist(victimaindex).faccion.fuerzascaos = 1 and userlist(ladronindex).faccion.fuerzascaos = 1 then
    call writeconsolemsg(ladronindex, "no puedes robar a otros miembros de las fuerzas del caos", fonttypenames.fonttype_fight)
    exit sub
end if

call quitarsta(ladronindex, 15)

dim guanteshurto as boolean
'tiene los guantes de hurto equipados?
guanteshurto = true
if userlist(ladronindex).invent.anilloeqpobjindex = 0 then
    guanteshurto = false
else
    if objdata(userlist(ladronindex).invent.anilloeqpobjindex).defensamagicamin <> 0 then guanteshurto = false
    if objdata(userlist(ladronindex).invent.anilloeqpobjindex).defensamagicamax <> 0 then guanteshurto = false
end if


if userlist(victimaindex).flags.privilegios and playertype.user then
    dim suerte as integer
    dim res as integer
    
    if userlist(ladronindex).stats.userskills(eskill.robar) <= 10 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= -1 then
                        suerte = 35
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 20 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 11 then
                        suerte = 30
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 30 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 21 then
                        suerte = 28
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 40 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 31 then
                        suerte = 24
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 50 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 41 then
                        suerte = 22
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 60 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 51 then
                        suerte = 20
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 70 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 61 then
                        suerte = 18
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 80 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 71 then
                        suerte = 15
    elseif userlist(ladronindex).stats.userskills(eskill.robar) <= 90 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 81 then
                        suerte = 10
    elseif userlist(ladronindex).stats.userskills(eskill.robar) < 100 _
       and userlist(ladronindex).stats.userskills(eskill.robar) >= 91 then
                        suerte = 7
    elseif userlist(ladronindex).stats.userskills(eskill.robar) = 100 then
                        suerte = 5
    end if
    res = randomnumber(1, suerte)
        
    if res < 3 then 'exito robo
       
        if (randomnumber(1, 50) < 25) and (userlist(ladronindex).clase = eclass.thief) then
            if tieneobjetosrobables(victimaindex) then
                call robarobjeto(ladronindex, victimaindex)
            else
                call writeconsolemsg(ladronindex, userlist(victimaindex).name & " no tiene objetos.", fonttypenames.fonttype_info)
            end if
        else 'roba oro
            if userlist(victimaindex).stats.gld > 0 then
                dim n as integer
                
                if userlist(ladronindex).clase = eclass.thief then
                ' si no tine puestos los guantes de hurto roba un 20% menos. pablo (toxicwaste)
                    if guanteshurto then
                        n = randomnumber(100, 1000)
                    else
                        n = randomnumber(80, 800)
                    end if
                else
                    n = randomnumber(1, 100)
                end if
                if n > userlist(victimaindex).stats.gld then n = userlist(victimaindex).stats.gld
                userlist(victimaindex).stats.gld = userlist(victimaindex).stats.gld - n
                
                userlist(ladronindex).stats.gld = userlist(ladronindex).stats.gld + n
                if userlist(ladronindex).stats.gld > maxoro then _
                    userlist(ladronindex).stats.gld = maxoro
                
                call writeconsolemsg(ladronindex, "le has robado " & n & " monedas de oro a " & userlist(victimaindex).name, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(ladronindex, userlist(victimaindex).name & " no tiene oro.", fonttypenames.fonttype_info)
            end if
        end if
    else
        call writeconsolemsg(ladronindex, "�no has logrado robar nada!", fonttypenames.fonttype_info)
        call writeconsolemsg(victimaindex, "�" & userlist(ladronindex).name & " ha intentado robarte!", fonttypenames.fonttype_info)
        call writeconsolemsg(victimaindex, "�" & userlist(ladronindex).name & " es un criminal!", fonttypenames.fonttype_info)
        call flushbuffer(victimaindex)
    end if

    if not criminal(ladronindex) then
        call volvercriminal(ladronindex)
    end if
    
    if userlist(ladronindex).faccion.armadareal = 1 then call expulsarfaccionreal(ladronindex)

    userlist(ladronindex).reputacion.ladronesrep = userlist(ladronindex).reputacion.ladronesrep + vlladron
    if userlist(ladronindex).reputacion.ladronesrep > maxrep then _
        userlist(ladronindex).reputacion.ladronesrep = maxrep
    call subirskill(ladronindex, robar)
end if


end sub


public function objesrobable(byval victimaindex as integer, byval slot as integer) as boolean
' agregu� los barcos
' esta funcion determina qu� objetos son robables.

dim oi as integer

oi = userlist(victimaindex).invent.object(slot).objindex

objesrobable = _
objdata(oi).objtype <> eobjtype.otllaves and _
userlist(victimaindex).invent.object(slot).equipped = 0 and _
objdata(oi).real = 0 and _
objdata(oi).caos = 0 and _
objdata(oi).objtype <> eobjtype.otbarcos

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
    
    if userlist(ladronindex).clase = eclass.thief then
        call writeconsolemsg(ladronindex, "has robado " & miobj.amount & " " & objdata(miobj.objindex).name, fonttypenames.fonttype_info)
    else
        call writeconsolemsg(ladronindex, "has hurtado " & miobj.amount & " " & objdata(miobj.objindex).name, fonttypenames.fonttype_info)
    end if
else
    call writeconsolemsg(ladronindex, "no has logrado robar ning�n objeto.", fonttypenames.fonttype_info)
end if

end sub

public sub doapu�alar(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as integer)
'***************************************************
'autor: nacho (integer) & unknown (orginal version)
'last modification: 07/20/06
'***************************************************
dim suerte as integer
dim skill as integer

skill = userlist(userindex).stats.userskills(eskill.apu�alar)

select case userlist(userindex).clase
    case eclass.assasin
        suerte = int((((0.0000003 * skill - 0.00002) * skill + 0.00098) * skill + 0.0425) * 100)
    
    case eclass.cleric, eclass.paladin
        suerte = int((((0.00000003 * skill + 0.000006) * skill + 0.000107) * skill + 0.0493) * 100)
    
    case eclass.bard
        suerte = int((((0.00000002 * skill + 0.000002) * skill + 0.00032) * skill + 0.0481) * 100)
    
    case else
        suerte = int((0.000361 * skill + 0.0439) * 100)
end select


if randomnumber(0, 100) < suerte then
    if victimuserindex <> 0 then
        if userlist(userindex).clase = eclass.assasin then
            da�o = int(da�o * 1.4)
        else
            da�o = int(da�o * 1.5)
        end if
        
        userlist(victimuserindex).stats.minhp = userlist(victimuserindex).stats.minhp - da�o
        call writeconsolemsg(userindex, "has apu�alado a " & userlist(victimuserindex).name & " por " & da�o, fonttypenames.fonttype_fight)
        call writeconsolemsg(victimuserindex, "te ha apu�alado " & userlist(userindex).name & " por " & da�o, fonttypenames.fonttype_fight)
    else
        npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - int(da�o * 2)
        call writeconsolemsg(userindex, "has apu�alado la criatura por " & int(da�o * 2), fonttypenames.fonttype_fight)
        call subirskill(userindex, apu�alar)
        '[alejo]
        call calculardarexp(userindex, victimnpcindex, int(da�o * 2))
    end if
else
    call writeconsolemsg(userindex, "�no has logrado apu�alar a tu enemigo!", fonttypenames.fonttype_fight)
end if

'pablo (toxicwaste): revisar, saque este porque hac�a que se me cuelgue.
'call flushbuffer(victimuserindex)
end sub

public sub dogolpecritico(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as integer)
'***************************************************
'autor: pablo (toxicwaste)
'last modification: 28/01/2007
'***************************************************
dim suerte as integer
dim skill as integer

if userlist(userindex).clase <> eclass.bandit then exit sub
if userlist(userindex).invent.weaponeqpslot = 0 then exit sub
if objdata(userlist(userindex).invent.weaponeqpobjindex).name <> "espada vikinga" then exit sub


skill = userlist(userindex).stats.userskills(eskill.wrestling)

suerte = int((((0.00000003 * skill + 0.000006) * skill + 0.000107) * skill + 0.0493) * 100)

if randomnumber(0, 100) < suerte then
    da�o = int(da�o * 0.5)
    if victimuserindex <> 0 then
        userlist(victimuserindex).stats.minhp = userlist(victimuserindex).stats.minhp - da�o
        call writeconsolemsg(userindex, "has golpeado cr�ticamente a " & userlist(victimuserindex).name & " por " & da�o, fonttypenames.fonttype_fight)
        call writeconsolemsg(victimuserindex, userlist(userindex).name & " te ha golpeado cr�ticamente por " & da�o, fonttypenames.fonttype_fight)
    else
        npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - da�o
        call writeconsolemsg(userindex, "has golpeado cr�ticamente a la criatura por " & da�o, fonttypenames.fonttype_fight)
        '[alejo]
        call calculardarexp(userindex, victimnpcindex, da�o)
    end if
end if

end sub

public sub quitarsta(byval userindex as integer, byval cantidad as integer)
    userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - cantidad
    if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
    call writeupdatesta(userindex)
end sub

public sub dotalar(byval userindex as integer)
on error goto errhandler

dim suerte as integer
dim res as integer


if userlist(userindex).clase = eclass.lumberjack then
    call quitarsta(userindex, esfuerzotalarle�ador)
else
    call quitarsta(userindex, esfuerzotalargeneral)
end if

dim skill as integer
skill = userlist(userindex).stats.userskills(eskill.talar)
suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)

res = randomnumber(1, suerte)

if res < 6 then
    dim npos as worldpos
    dim miobj as obj
    
    if userlist(userindex).clase = eclass.lumberjack then
        miobj.amount = randomnumber(1, 4)
    else
        miobj.amount = 1
    end if
    
    miobj.objindex = le�a
    
    
    if not meteritemeninventario(userindex, miobj) then
        
        call tiraritemalpiso(userlist(userindex).pos, miobj)
        
    end if
    
    call writeconsolemsg(userindex, "�has conseguido algo de le�a!", fonttypenames.fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 8 then
        call writeconsolemsg(userindex, "�no has obtenido le�a!", fonttypenames.fonttype_info)
        userlist(userindex).flags.ultimomensaje = 8
    end if
    '[/cdt]
end if

call subirskill(userindex, talar)

userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1

exit sub

errhandler:
    call logerror("error en dotalar")

end sub

public sub domineria(byval userindex as integer)
on error goto errhandler

dim suerte as integer
dim res as integer
dim metal as integer

if userlist(userindex).clase = eclass.miner then
    call quitarsta(userindex, esfuerzoexcavarminero)
else
    call quitarsta(userindex, esfuerzoexcavargeneral)
end if

dim skill as integer
skill = userlist(userindex).stats.userskills(eskill.mineria)
suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)

res = randomnumber(1, suerte)

if res <= 5 then
    dim miobj as obj
    dim npos as worldpos
    
    if userlist(userindex).flags.targetobj = 0 then exit sub
    
    miobj.objindex = objdata(userlist(userindex).flags.targetobj).mineralindex
    
    if userlist(userindex).clase = eclass.miner then
        miobj.amount = randomnumber(1, 5)
    else
        miobj.amount = 1
    end if
    
    if not meteritemeninventario(userindex, miobj) then _
        call tiraritemalpiso(userlist(userindex).pos, miobj)
    
    call writeconsolemsg(userindex, "�has extraido algunos minerales!", fonttypenames.fonttype_info)
    
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 9 then
        call writeconsolemsg(userindex, "�no has conseguido nada!", fonttypenames.fonttype_info)
        userlist(userindex).flags.ultimomensaje = 9
    end if
    '[/cdt]
end if

call subirskill(userindex, mineria)

userlist(userindex).reputacion.pleberep = userlist(userindex).reputacion.pleberep + vlproleta
if userlist(userindex).reputacion.pleberep > maxrep then _
    userlist(userindex).reputacion.pleberep = maxrep

userlist(userindex).counters.trabajando = userlist(userindex).counters.trabajando + 1

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

if userlist(userindex).stats.minman >= userlist(userindex).stats.maxman then
    call writeconsolemsg(userindex, "has terminado de meditar.", fonttypenames.fonttype_info)
    call writemeditatetoggle(userindex)
    userlist(userindex).flags.meditando = false
    userlist(userindex).char.fx = 0
    userlist(userindex).char.loops = 0
    call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(userlist(userindex).char.charindex, 0, 0))
    exit sub
end if

if userlist(userindex).stats.userskills(eskill.meditar) <= 10 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 20 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 30 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 40 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 50 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 60 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 70 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 80 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(eskill.meditar) <= 90 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(eskill.meditar) < 100 _
   and userlist(userindex).stats.userskills(eskill.meditar) >= 91 then
                    suerte = 7
elseif userlist(userindex).stats.userskills(eskill.meditar) = 100 then
                    suerte = 5
end if
res = randomnumber(1, suerte)

if res = 1 then
    
    cant = porcentaje(userlist(userindex).stats.maxman, porcentajerecuperomana)
    if cant <= 0 then cant = 1
    userlist(userindex).stats.minman = userlist(userindex).stats.minman + cant
    if userlist(userindex).stats.minman > userlist(userindex).stats.maxman then _
        userlist(userindex).stats.minman = userlist(userindex).stats.maxman
    
    if not userlist(userindex).flags.ultimomensaje = 22 then
        call writeconsolemsg(userindex, "�has recuperado " & cant & " puntos de mana!", fonttypenames.fonttype_info)
        userlist(userindex).flags.ultimomensaje = 22
    end if
    
    call writeupdatemana(userindex)
    call subirskill(userindex, meditar)
end if

end sub

public sub dohurtar(byval userindex as integer, byval victimaindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modif: 28/01/2007
'implements the pick pocket skill of the bandit :)
'***************************************************
if userlist(userindex).clase <> eclass.bandit then exit sub
'esto es precario y feo, pero por ahora no se me ocurri� nada mejor.
'uso el slot de los anillos para "equipar" los guantes.
'y los reconozco porque les puse defensamagicamin y max = 0
if userlist(userindex).invent.anilloeqpobjindex = 0 then
    exit sub
else
    if objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamin <> 0 then exit sub
    if objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamax <> 0 then exit sub
end if

dim res as integer
res = randomnumber(1, 100)
if (res < 20) then
    if tieneobjetosrobables(victimaindex) then
        call robarobjeto(userindex, victimaindex)
        call writeconsolemsg(victimaindex, "�" & userlist(userindex).name & " es un bandido!", fonttypenames.fonttype_info)
    else
        call writeconsolemsg(userindex, userlist(victimaindex).name & " no tiene objetos.", fonttypenames.fonttype_info)
    end if
end if

end sub

public sub dohandinmo(byval userindex as integer, byval victimaindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modif: 17/02/2007
'implements the special skill of the thief
'***************************************************
if userlist(victimaindex).flags.paralizado = 1 then exit sub
if userlist(userindex).clase <> eclass.thief then exit sub
    
'una vez m�s, la forma de reconocer los guantes es medio pat�tica.
if userlist(userindex).invent.anilloeqpobjindex = 0 then
    exit sub
else
    if objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamin <> 0 then exit sub
    if objdata(userlist(userindex).invent.anilloeqpobjindex).defensamagicamax <> 0 then exit sub
end if

    
dim res as integer
res = randomnumber(0, 100)
if res < (userlist(userindex).stats.userskills(eskill.wrestling) / 4) then
    userlist(victimaindex).flags.paralizado = 1
    userlist(victimaindex).counters.paralisis = intervaloparalizado / 2
    call writeparalizeok(victimaindex)
    call writeconsolemsg(userindex, "tu golpe ha dejado inm�vil a tu oponente", fonttypenames.fonttype_info)
    call writeconsolemsg(victimaindex, "�el golpe te ha dejado inm�vil!", fonttypenames.fonttype_info)
end if

end sub

public sub desarmar(byval userindex as integer, byval victimindex as integer)

dim suerte as integer
dim res as integer

if userlist(userindex).stats.userskills(eskill.wrestling) <= 10 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= -1 then
                    suerte = 35
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 20 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 11 then
                    suerte = 30
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 30 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 21 then
                    suerte = 28
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 40 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 31 then
                    suerte = 24
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 50 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 41 then
                    suerte = 22
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 60 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 51 then
                    suerte = 20
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 70 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 61 then
                    suerte = 18
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 80 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 71 then
                    suerte = 15
elseif userlist(userindex).stats.userskills(eskill.wrestling) <= 90 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 81 then
                    suerte = 10
elseif userlist(userindex).stats.userskills(eskill.wrestling) < 100 _
   and userlist(userindex).stats.userskills(eskill.wrestling) >= 91 then
                    suerte = 7
elseif userlist(userindex).stats.userskills(eskill.wrestling) = 100 then
                    suerte = 5
end if
res = randomnumber(1, suerte)

if res <= 2 then
        call desequipar(victimindex, userlist(victimindex).invent.weaponeqpslot)
        call writeconsolemsg(userindex, "has logrado desarmar a tu oponente!", fonttypenames.fonttype_fight)
        if userlist(victimindex).stats.elv < 20 then
            call writeconsolemsg(victimindex, "tu oponente te ha desarmado!", fonttypenames.fonttype_fight)
        end if
        call flushbuffer(victimindex)
    end if
end sub

