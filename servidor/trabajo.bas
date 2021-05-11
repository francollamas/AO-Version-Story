attribute vb_name = "trabajo"
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

private const gasto_energia_trabajador as byte = 2
private const gasto_energia_no_trabajador as byte = 6


public sub dopermaneceroculto(byval userindex as integer)
'********************************************************
'autor: nacho (integer)
'last modif: 11/19/2009
'chequea si ya debe mostrarse
'pablo (toxicwaste): cambie los ordenes de prioridades porque sino no andaba.
'13/01/2010: zama - now hidden on boat pirats recover the proper boat body.
'13/01/2010: zama - arreglo condicional para que el bandido camine oculto.
'********************************************************
on error goto errhandler
    with userlist(userindex)
        .counters.tiempooculto = .counters.tiempooculto - 1
        if .counters.tiempooculto <= 0 then
            if .clase = eclass.hunter and .stats.userskills(eskill.ocultarse) > 90 then
                if .invent.armoureqpobjindex = 648 or .invent.armoureqpobjindex = 360 then
                    .counters.tiempooculto = intervalooculto
                    exit sub
                end if
            end if
            .counters.tiempooculto = 0
            .flags.oculto = 0
            
            if .flags.navegando = 1 then
                if .clase = eclass.pirat then
                    ' pierde la apariencia de fragata fantasmal
                    call toggleboatbody(userindex)
                    call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                    call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                        ningunescudo, ninguncasco)
                end if
            else
                if .flags.invisible = 0 then
                    call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
                    call setinvisible(userindex, .char.charindex, false)
                end if
            end if
        end if
    end with
    
    exit sub

errhandler:
    call logerror("error en sub dopermaneceroculto")


end sub

public sub doocultarse(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 13/01/2010 (zama)
'pablo (toxicwaste): no olvidar agregar intervalooculto=500 al server.ini.
'modifique la f�rmula y ahora anda bien.
'13/01/2010: zama - el pirata se transforma en galeon fantasmal cuando se oculta en agua.
'***************************************************

on error goto errhandler

    dim suerte as double
    dim res as integer
    dim skill as integer
    
    with userlist(userindex)
        skill = .stats.userskills(eskill.ocultarse)
        
        suerte = (((0.000002 * skill - 0.0002) * skill + 0.0064) * skill + 0.1124) * 100
        
        res = randomnumber(1, 100)
        
        if res <= suerte then
        
            .flags.oculto = 1
            suerte = (-0.000001 * (100 - skill) ^ 3)
            suerte = suerte + (0.00009229 * (100 - skill) ^ 2)
            suerte = suerte + (-0.0088 * (100 - skill))
            suerte = suerte + (0.9571)
            suerte = suerte * intervalooculto
            
            if .clase = eclass.bandit then
                .counters.tiempooculto = int(suerte / 2)
            else
                .counters.tiempooculto = suerte
            end if
            
            ' no es pirata o es uno sin barca
            if .flags.navegando = 0 then
                call setinvisible(userindex, .char.charindex, true)
        
                call writeconsolemsg(userindex, "�te has escondido entre las sombras!", fonttypenames.fonttype_info)
            ' es un pirata navegando
            else
                ' le cambiamos el body a galeon fantasmal
                .char.body = ifragatafantasmal
                ' actualizamos clientes
                call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                    ningunescudo, ninguncasco)
            end if
            
            call subirskill(userindex, eskill.ocultarse, true)
        else
            '[cdt 17-02-2004]
            if not .flags.ultimomensaje = 4 then
                call writeconsolemsg(userindex, "�no has logrado esconderte!", fonttypenames.fonttype_info)
                .flags.ultimomensaje = 4
            end if
            '[/cdt]
            
            call subirskill(userindex, eskill.ocultarse, false)
        end if
        
        .counters.ocultando = .counters.ocultando + 1
    end with
    
    exit sub

errhandler:
    call logerror("error en sub doocultarse")

end sub

public sub donavega(byval userindex as integer, byref barco as objdata, byval slot as integer)
'***************************************************
'author: unknown
'last modification: 13/01/2010 (zama)
'13/01/2010: zama - el pirata pierde el ocultar si desequipa barca.
'16/09/2010: zama - ahora siempre se va el invi para los clientes al equipar la barca (evita cortes de cabeza).
'10/12/2010: pato - limpio las variables del inventario que hacen referencia a la barca, sino el pirata que la �ltima barca que equipo era el gale�n no explotaba(y capaz no la ten�a equipada :p).
'***************************************************

    dim modnave as single
    
    with userlist(userindex)
        modnave = modnavegacion(.clase, userindex)
        
        if .stats.userskills(eskill.navegacion) / modnave < barco.minskill then
            call writeconsolemsg(userindex, "no tienes suficientes conocimientos para usar este barco.", fonttypenames.fonttype_info)
            call writeconsolemsg(userindex, "para usar este barco necesitas " & barco.minskill * modnave & " puntos en navegacion.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        ' no estaba navegando
        if .flags.navegando = 0 then
            .invent.barcoobjindex = .invent.object(slot).objindex
            .invent.barcoslot = slot
            
            .char.head = 0
            
            ' no esta muerto
            if .flags.muerto = 0 then
            
                call toggleboatbody(userindex)
                
                ' pierde el ocultar
                if .flags.oculto = 1 then
                    .flags.oculto = 0
                    call setinvisible(userindex, .char.charindex, false)
                    call writeconsolemsg(userindex, "�has vuelto a ser visible!", fonttypenames.fonttype_info)
                end if
               
                ' siempre se ve la barca (nunca esta invisible), pero solo para el cliente.
                if .flags.invisible = 1 then
                    call setinvisible(userindex, .char.charindex, false)
                end if
                
            ' esta muerto
            else
                .char.body = ifragatafantasmal
                .char.shieldanim = ningunescudo
                .char.weaponanim = ningunarma
                .char.cascoanim = ninguncasco
            end if
            
            ' comienza a navegar
            .flags.navegando = 1
        
        ' estaba navegando
        else
            .invent.barcoobjindex = 0
            .invent.barcoslot = 0
        
            ' no esta muerto
            if .flags.muerto = 0 then
                .char.head = .origchar.head
                
                if .clase = eclass.pirat then
                    if .flags.oculto = 1 then
                        ' al desequipar barca, perdi� el ocultar
                        .flags.oculto = 0
                        .counters.ocultando = 0
                        call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                    end if
                end if
                
                if .invent.armoureqpobjindex > 0 then
                    .char.body = objdata(.invent.armoureqpobjindex).ropaje
                else
                    call darcuerpodesnudo(userindex)
                end if
                
                if .invent.escudoeqpobjindex > 0 then _
                    .char.shieldanim = objdata(.invent.escudoeqpobjindex).shieldanim
                if .invent.weaponeqpobjindex > 0 then _
                    .char.weaponanim = getweaponanim(userindex, .invent.weaponeqpobjindex)
                if .invent.cascoeqpobjindex > 0 then _
                    .char.cascoanim = objdata(.invent.cascoeqpobjindex).cascoanim
                
                
                ' al dejar de navegar, si estaba invisible actualizo los clientes
                if .flags.invisible = 1 then
                    call setinvisible(userindex, .char.charindex, true)
                end if
                
            ' esta muerto
            else
                .char.body = icuerpomuerto
                .char.head = icabezamuerto
                .char.shieldanim = ningunescudo
                .char.weaponanim = ningunarma
                .char.cascoanim = ninguncasco
            end if
            
            ' termina de navegar
            .flags.navegando = 0
        end if
        
        ' actualizo clientes
        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
    end with
    
    call writenavigatetoggle(userindex)

end sub

public sub fundirmineral(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    with userlist(userindex)
        if .flags.targetobjinvindex > 0 then
           
           if objdata(.flags.targetobjinvindex).objtype = eobjtype.otminerales and _
                objdata(.flags.targetobjinvindex).minskill <= .stats.userskills(eskill.mineria) / modfundicion(.clase) then
                call dolingotes(userindex)
           else
                call writeconsolemsg(userindex, "no tienes conocimientos de miner�a suficientes para trabajar este mineral.", fonttypenames.fonttype_info)
           end if
        
        end if
    end with

    exit sub

errhandler:
    call logerror("error en fundirmineral. error " & err.number & " : " & err.description)

end sub

public sub fundirarmas(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    with userlist(userindex)
        if .flags.targetobjinvindex > 0 then
            if objdata(.flags.targetobjinvindex).objtype = eobjtype.otweapon then
                if objdata(.flags.targetobjinvindex).skherreria <= .stats.userskills(eskill.herreria) / modherreria(.clase) then
                    call dofundir(userindex)
                else
                    call writeconsolemsg(userindex, "no tienes los conocimientos suficientes en herrer�a para fundir este objeto.", fonttypenames.fonttype_info)
                end if
            end if
        end if
    end with
    
    exit sub
errhandler:
    call logerror("error en fundirarmas. error " & err.number & " : " & err.description)
end sub

function tieneobjetos(byval itemindex as integer, byval cant as long, byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 10/07/2010
'10/07/2010: zama - ahora cant es long para evitar un overflow.
'***************************************************

    dim i as integer
    dim total as long
    for i = 1 to userlist(userindex).currentinventoryslots
        if userlist(userindex).invent.object(i).objindex = itemindex then
            total = total + userlist(userindex).invent.object(i).amount
        end if
    next i
    
    if cant <= total then
        tieneobjetos = true
        exit function
    end if
        
end function

public sub quitarobjetos(byval itemindex as integer, byval cant as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 05/08/09
'05/08/09: pato - cambie la funcion a procedimiento ya que se usa como procedimiento siempre, y fixie el bug 2788199
'***************************************************

    dim i as integer
    for i = 1 to userlist(userindex).currentinventoryslots
        with userlist(userindex).invent.object(i)
            if .objindex = itemindex then
                if .amount <= cant and .equipped = 1 then call desequipar(userindex, i)
                
                .amount = .amount - cant
                if .amount <= 0 then
                    cant = abs(.amount)
                    userlist(userindex).invent.nroitems = userlist(userindex).invent.nroitems - 1
                    .amount = 0
                    .objindex = 0
                else
                    cant = 0
                end if
                
                call updateuserinv(false, userindex, i)
                
                if cant = 0 then exit sub
            end if
        end with
    next i

end sub

sub herreroquitarmateriales(byval userindex as integer, byval itemindex as integer, byval cantidaditems as integer)
'***************************************************
'author: unknown
'last modification: 16/11/2009
'16/11/2009: zama - ahora considera la cantidad de items a construir
'***************************************************
    with objdata(itemindex)
        if .lingh > 0 then call quitarobjetos(lingotehierro, .lingh * cantidaditems, userindex)
        if .lingp > 0 then call quitarobjetos(lingoteplata, .lingp * cantidaditems, userindex)
        if .lingo > 0 then call quitarobjetos(lingoteoro, .lingo * cantidaditems, userindex)
    end with
end sub

sub carpinteroquitarmateriales(byval userindex as integer, byval itemindex as integer, byval cantidaditems as integer)
'***************************************************
'author: unknown
'last modification: 16/11/2009
'16/11/2009: zama - ahora quita tambien madera elfica
'***************************************************
    with objdata(itemindex)
        if .madera > 0 then call quitarobjetos(le�a, .madera * cantidaditems, userindex)
        if .maderaelfica > 0 then call quitarobjetos(le�aelfica, .maderaelfica * cantidaditems, userindex)
    end with
end sub

function carpinterotienemateriales(byval userindex as integer, byval itemindex as integer, byval cantidad as integer, optional byval showmsg as boolean = false) as boolean
'***************************************************
'author: unknown
'last modification: 16/11/2009
'16/11/2009: zama - agregada validacion a madera elfica.
'16/11/2009: zama - ahora considera la cantidad de items a construir
'***************************************************
    
    with objdata(itemindex)
        if .madera > 0 then
            if not tieneobjetos(le�a, .madera * cantidad, userindex) then
                if showmsg then call writeconsolemsg(userindex, "no tienes suficiente madera.", fonttypenames.fonttype_info)
                carpinterotienemateriales = false
                exit function
            end if
        end if
        
        if .maderaelfica > 0 then
            if not tieneobjetos(le�aelfica, .maderaelfica * cantidad, userindex) then
                if showmsg then call writeconsolemsg(userindex, "no tienes suficiente madera �lfica.", fonttypenames.fonttype_info)
                carpinterotienemateriales = false
                exit function
            end if
        end if
    
    end with
    carpinterotienemateriales = true

end function
 
function herrerotienemateriales(byval userindex as integer, byval itemindex as integer, byval cantidaditems as integer) as boolean
'***************************************************
'author: unknown
'last modification: 16/11/2009
'16/11/2009: zama - agregada validacion a madera elfica.
'***************************************************
    with objdata(itemindex)
        if .lingh > 0 then
            if not tieneobjetos(lingotehierro, .lingh * cantidaditems, userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de hierro.", fonttypenames.fonttype_info)
                herrerotienemateriales = false
                exit function
            end if
        end if
        if .lingp > 0 then
            if not tieneobjetos(lingoteplata, .lingp * cantidaditems, userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de plata.", fonttypenames.fonttype_info)
                herrerotienemateriales = false
                exit function
            end if
        end if
        if .lingo > 0 then
            if not tieneobjetos(lingoteoro, .lingo * cantidaditems, userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de oro.", fonttypenames.fonttype_info)
                herrerotienemateriales = false
                exit function
            end if
        end if
    end with
    herrerotienemateriales = true
end function

function tienematerialesupgrade(byval userindex as integer, byval itemindex as integer) as boolean
'***************************************************
'author: torres patricio (pato)
'last modification: 12/08/2009
'
'***************************************************
    dim itemupgrade as integer
    
    itemupgrade = objdata(itemindex).upgrade
    
    with objdata(itemupgrade)
        if .lingh > 0 then
            if not tieneobjetos(lingotehierro, cint(.lingh - objdata(itemindex).lingh * porcentaje_materiales_upgrade), userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de hierro.", fonttypenames.fonttype_info)
                tienematerialesupgrade = false
                exit function
            end if
        end if
        
        if .lingp > 0 then
            if not tieneobjetos(lingoteplata, cint(.lingp - objdata(itemindex).lingp * porcentaje_materiales_upgrade), userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de plata.", fonttypenames.fonttype_info)
                tienematerialesupgrade = false
                exit function
            end if
        end if
        
        if .lingo > 0 then
            if not tieneobjetos(lingoteoro, cint(.lingo - objdata(itemindex).lingo * porcentaje_materiales_upgrade), userindex) then
                call writeconsolemsg(userindex, "no tienes suficientes lingotes de oro.", fonttypenames.fonttype_info)
                tienematerialesupgrade = false
                exit function
            end if
        end if
        
        if .madera > 0 then
            if not tieneobjetos(le�a, cint(.madera - objdata(itemindex).madera * porcentaje_materiales_upgrade), userindex) then
                call writeconsolemsg(userindex, "no tienes suficiente madera.", fonttypenames.fonttype_info)
                tienematerialesupgrade = false
                exit function
            end if
        end if
        
        if .maderaelfica > 0 then
            if not tieneobjetos(le�aelfica, cint(.maderaelfica - objdata(itemindex).maderaelfica * porcentaje_materiales_upgrade), userindex) then
                call writeconsolemsg(userindex, "no tienes suficiente madera �lfica.", fonttypenames.fonttype_info)
                tienematerialesupgrade = false
                exit function
            end if
        end if
    end with
    
    tienematerialesupgrade = true
end function

sub quitarmaterialesupgrade(byval userindex as integer, byval itemindex as integer)
'***************************************************
'author: torres patricio (pato)
'last modification: 12/08/2009
'
'***************************************************
    dim itemupgrade as integer
    
    itemupgrade = objdata(itemindex).upgrade
    
    with objdata(itemupgrade)
        if .lingh > 0 then call quitarobjetos(lingotehierro, cint(.lingh - objdata(itemindex).lingh * porcentaje_materiales_upgrade), userindex)
        if .lingp > 0 then call quitarobjetos(lingoteplata, cint(.lingp - objdata(itemindex).lingp * porcentaje_materiales_upgrade), userindex)
        if .lingo > 0 then call quitarobjetos(lingoteoro, cint(.lingo - objdata(itemindex).lingo * porcentaje_materiales_upgrade), userindex)
        if .madera > 0 then call quitarobjetos(le�a, cint(.madera - objdata(itemindex).madera * porcentaje_materiales_upgrade), userindex)
        if .maderaelfica > 0 then call quitarobjetos(le�aelfica, cint(.maderaelfica - objdata(itemindex).maderaelfica * porcentaje_materiales_upgrade), userindex)
    end with
    
    call quitarobjetos(itemindex, 1, userindex)
end sub

public function puedeconstruir(byval userindex as integer, byval itemindex as integer, byval cantidaditems as integer) as boolean
'***************************************************
'author: unknown
'last modification: 24/08/2009
'24/08/2008: zama - validates if the player has the required skill
'16/11/2009: zama - validates if the player has the required amount of materials, depending on the number of items to make
'***************************************************
puedeconstruir = herrerotienemateriales(userindex, itemindex, cantidaditems) and _
                    round(userlist(userindex).stats.userskills(eskill.herreria) / modherreria(userlist(userindex).clase), 0) >= objdata(itemindex).skherreria
end function

public function puedeconstruirherreria(byval itemindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
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
'***************************************************
'author: unknown
'last modification: 30/05/2010
'16/11/2009: zama - implementado nuevo sistema de construccion de items.
'22/05/2010: zama - los caos ya no suben plebe al trabajar.
'30/05/2010: zama - los pks no suben plebe al trabajar.
'***************************************************
dim cantidaditems as integer
dim tienemateriales as boolean
dim otrouserindex as integer

with userlist(userindex)
    if .flags.comerciando then
        otrouserindex = .comusu.destusu
            
        if otrouserindex > 0 and otrouserindex <= maxusers then
            call writeconsolemsg(userindex, "��comercio cancelado, no puedes comerciar mientras trabajas!!", fonttypenames.fonttype_talk)
            call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
            
            call limpiarcomercioseguro(userindex)
            call protocol.flushbuffer(otrouserindex)
        end if
    end if
        
    cantidaditems = .construir.porciclo
    
    if .construir.cantidad < cantidaditems then _
        cantidaditems = .construir.cantidad
        
    if .construir.cantidad > 0 then _
        .construir.cantidad = .construir.cantidad - cantidaditems
        
    if cantidaditems = 0 then
        call writestopworking(userindex)
        exit sub
    end if
    
    if puedeconstruirherreria(itemindex) then
        
        while cantidaditems > 0 and not tienemateriales
            if puedeconstruir(userindex, itemindex, cantidaditems) then
                tienemateriales = true
            else
                cantidaditems = cantidaditems - 1
            end if
        wend
        
        ' chequeo si puede hacer al menos 1 item
        if not tienemateriales then
            call writeconsolemsg(userindex, "no tienes suficientes materiales.", fonttypenames.fonttype_info)
            call writestopworking(userindex)
            exit sub
        end if
        
        'sacamos energ�a
        if .clase = eclass.worker then
            'chequeamos que tenga los puntos antes de sacarselos
            if .stats.minsta >= gasto_energia_trabajador then
                .stats.minsta = .stats.minsta - gasto_energia_trabajador
                call writeupdatesta(userindex)
            else
                call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
                exit sub
            end if
        else
            'chequeamos que tenga los puntos antes de sacarselos
            if .stats.minsta >= gasto_energia_no_trabajador then
                .stats.minsta = .stats.minsta - gasto_energia_no_trabajador
                call writeupdatesta(userindex)
            else
                call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
                exit sub
            end if
        end if
        
        call herreroquitarmateriales(userindex, itemindex, cantidaditems)
        ' agregar fx
        
        select case objdata(itemindex).objtype
        
            case eobjtype.otweapon
                call writeconsolemsg(userindex, "has construido " & iif(cantidaditems > 1, cantidaditems & " armas!", "el arma!"), fonttypenames.fonttype_info)
            case eobjtype.otescudo
                call writeconsolemsg(userindex, "has construido " & iif(cantidaditems > 1, cantidaditems & " escudos!", "el escudo!"), fonttypenames.fonttype_info)
            case is = eobjtype.otcasco
                call writeconsolemsg(userindex, "has construido " & iif(cantidaditems > 1, cantidaditems & " cascos!", "el casco!"), fonttypenames.fonttype_info)
            case eobjtype.otarmadura
                call writeconsolemsg(userindex, "has construido " & iif(cantidaditems > 1, cantidaditems & " armaduras", "la armadura!"), fonttypenames.fonttype_info)
        
        end select
        
        dim miobj as obj
        
        miobj.amount = cantidaditems
        miobj.objindex = itemindex
        if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(.pos, miobj)
        end if
        
        'log de construcci�n de items. pablo (toxicwaste) 10/09/07
        if objdata(miobj.objindex).log = 1 then
            call logdesarrollo(.name & " ha constru�do " & miobj.amount & " " & objdata(miobj.objindex).name)
        end if
        
        call subirskill(userindex, eskill.herreria, true)
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(martilloherrero, .pos.x, .pos.y))
        
        if not criminal(userindex) then
            .reputacion.pleberep = .reputacion.pleberep + vlproleta
            if .reputacion.pleberep > maxrep then _
                .reputacion.pleberep = maxrep
        end if
        
        .counters.trabajando = .counters.trabajando + 1
    end if
end with
end sub

public function puedeconstruircarpintero(byval itemindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
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
'***************************************************
'author: unknown
'last modification: 28/05/2010
'24/08/2008: zama - validates if the player has the required skill
'16/11/2009: zama - implementado nuevo sistema de construccion de items
'22/05/2010: zama - los caos ya no suben plebe al trabajar.
'28/05/2010: zama - los pks no suben plebe al trabajar.
'***************************************************
on error goto errhandler

    dim cantidaditems as integer
    dim tienemateriales as boolean
    dim weaponindex as integer
    dim otrouserindex as integer
    
    with userlist(userindex)
        if .flags.comerciando then
            otrouserindex = .comusu.destusu
                
            if otrouserindex > 0 and otrouserindex <= maxusers then
                call writeconsolemsg(userindex, "��comercio cancelado, no puedes comerciar mientras trabajas!!", fonttypenames.fonttype_talk)
                call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
                
                call limpiarcomercioseguro(userindex)
                call protocol.flushbuffer(otrouserindex)
            end if
        end if
        
        weaponindex = .invent.weaponeqpobjindex
    
        if weaponindex <> serrucho_carpintero and weaponindex <> serrucho_carpintero_newbie then
            call writeconsolemsg(userindex, "debes tener equipado el serrucho para trabajar.", fonttypenames.fonttype_info)
            call writestopworking(userindex)
            exit sub
        end if
        
        cantidaditems = .construir.porciclo
        
        if .construir.cantidad < cantidaditems then _
            cantidaditems = .construir.cantidad
            
        if .construir.cantidad > 0 then _
            .construir.cantidad = .construir.cantidad - cantidaditems
            
        if cantidaditems = 0 then
            call writestopworking(userindex)
            exit sub
        end if
    
        if round(.stats.userskills(eskill.carpinteria) \ modcarpinteria(.clase), 0) >= _
           objdata(itemindex).skcarpinteria and _
           puedeconstruircarpintero(itemindex) then
           
            ' calculo cuantos item puede construir
            while cantidaditems > 0 and not tienemateriales
                if carpinterotienemateriales(userindex, itemindex, cantidaditems) then
                    tienemateriales = true
                else
                    cantidaditems = cantidaditems - 1
                end if
            wend
            
            ' no tiene los materiales ni para construir 1 item?
            if not tienemateriales then
                ' para que muestre el mensaje
                call carpinterotienemateriales(userindex, itemindex, 1, true)
                call writestopworking(userindex)
                exit sub
            end if
           
            'sacamos energ�a
            if .clase = eclass.worker then
                'chequeamos que tenga los puntos antes de sacarselos
                if .stats.minsta >= gasto_energia_trabajador then
                    .stats.minsta = .stats.minsta - gasto_energia_trabajador
                    call writeupdatesta(userindex)
                else
                    call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
                    exit sub
                end if
            else
                'chequeamos que tenga los puntos antes de sacarselos
                if .stats.minsta >= gasto_energia_no_trabajador then
                    .stats.minsta = .stats.minsta - gasto_energia_no_trabajador
                    call writeupdatesta(userindex)
                else
                    call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
                    exit sub
                end if
            end if
            
            call carpinteroquitarmateriales(userindex, itemindex, cantidaditems)
            call writeconsolemsg(userindex, "has construido " & cantidaditems & _
                                iif(cantidaditems = 1, " objeto!", " objetos!"), fonttypenames.fonttype_info)
            
            dim miobj as obj
            miobj.amount = cantidaditems
            miobj.objindex = itemindex
            if not meteritemeninventario(userindex, miobj) then
                call tiraritemalpiso(.pos, miobj)
            end if
            
            'log de construcci�n de items. pablo (toxicwaste) 10/09/07
            if objdata(miobj.objindex).log = 1 then
                call logdesarrollo(.name & " ha constru�do " & miobj.amount & " " & objdata(miobj.objindex).name)
            end if
            
            call subirskill(userindex, eskill.carpinteria, true)
            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(laburocarpintero, .pos.x, .pos.y))
            
            if not criminal(userindex) then
                .reputacion.pleberep = .reputacion.pleberep + vlproleta
                if .reputacion.pleberep > maxrep then _
                    .reputacion.pleberep = maxrep
            end if
            
            .counters.trabajando = .counters.trabajando + 1
        end if
    end with
    
    exit sub
errhandler:
    call logerror("error en carpinteroconstruiritem. error " & err.number & " : " & err.description & ". userindex:" & userindex & ". itemindex:" & itemindex)
end sub

private function mineralesparalingote(byval lingote as iminerales) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
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
'***************************************************
'author: unknown
'last modification: 16/11/2009
'16/11/2009: zama - implementado nuevo sistema de construccion de items
'***************************************************
'    call logtarea("sub dolingotes")
    dim slot as integer
    dim obji as integer
    dim cantidaditems as integer
    dim tieneminerales as boolean
    dim otrouserindex as integer
    
    with userlist(userindex)
        if .flags.comerciando then
            otrouserindex = .comusu.destusu
                
            if otrouserindex > 0 and otrouserindex <= maxusers then
                call writeconsolemsg(userindex, "��comercio cancelado, no puedes comerciar mientras trabajas!!", fonttypenames.fonttype_talk)
                call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
                
                call limpiarcomercioseguro(userindex)
                call protocol.flushbuffer(otrouserindex)
            end if
        end if
        
        cantidaditems = maximoint(1, cint((.stats.elv - 4) / 5))

        slot = .flags.targetobjinvslot
        obji = .invent.object(slot).objindex
        
        while cantidaditems > 0 and not tieneminerales
            if .invent.object(slot).amount >= mineralesparalingote(obji) * cantidaditems then
                tieneminerales = true
            else
                cantidaditems = cantidaditems - 1
            end if
        wend
        
        if not tieneminerales or objdata(obji).objtype <> eobjtype.otminerales then
            call writeconsolemsg(userindex, "no tienes suficientes minerales para hacer un lingote.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        .invent.object(slot).amount = .invent.object(slot).amount - mineralesparalingote(obji) * cantidaditems
        if .invent.object(slot).amount < 1 then
            .invent.object(slot).amount = 0
            .invent.object(slot).objindex = 0
        end if
        
        dim miobj as obj
        miobj.amount = cantidaditems
        miobj.objindex = objdata(.flags.targetobjinvindex).lingoteindex
        if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(.pos, miobj)
        end if
        
        call updateuserinv(false, userindex, slot)
        call writeconsolemsg(userindex, "�has obtenido " & cantidaditems & " lingote" & _
                            iif(cantidaditems = 1, "", "s") & "!", fonttypenames.fonttype_info)
    
        .counters.trabajando = .counters.trabajando + 1
    end with
end sub

public sub dofundir(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 03/06/2010
'03/06/2010 - pato: si es el �ltimo �tem a fundir y est� equipado lo desequipamos.
'11/03/2010 - zama: reemplazo divisi�n por producto para uan mejor performanse.
'***************************************************
dim i as integer
dim num as integer
dim slot as byte
dim lingotes(2) as integer
dim otrouserindex as integer

    with userlist(userindex)
        if .flags.comerciando then
            otrouserindex = .comusu.destusu
                
            if otrouserindex > 0 and otrouserindex <= maxusers then
                call writeconsolemsg(userindex, "��comercio cancelado, no puedes comerciar mientras trabajas!!", fonttypenames.fonttype_talk)
                call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
                
                call limpiarcomercioseguro(userindex)
                call protocol.flushbuffer(otrouserindex)
            end if
        end if
        
        slot = .flags.targetobjinvslot
        
        with .invent.object(slot)
            .amount = .amount - 1
            
            if .amount < 1 then
                if .equipped = 1 then call desequipar(userindex, slot)
                
                .amount = 0
                .objindex = 0
            end if
        end with
        
        num = randomnumber(10, 25)
        
        lingotes(0) = (objdata(.flags.targetobjinvindex).lingh * num) * 0.01
        lingotes(1) = (objdata(.flags.targetobjinvindex).lingp * num) * 0.01
        lingotes(2) = (objdata(.flags.targetobjinvindex).lingo * num) * 0.01
    
        dim miobj(2) as obj
        
        for i = 0 to 2
            miobj(i).amount = lingotes(i)
            miobj(i).objindex = lingotehierro + i 'una gran negrada pero pr�ctica
            
            if miobj(i).amount > 0 then
                if not meteritemeninventario(userindex, miobj(i)) then
                    call tiraritemalpiso(.pos, miobj(i))
                end if
            end if
        next i
        
        call updateuserinv(false, userindex, slot)
        call writeconsolemsg(userindex, "�has obtenido el " & num & "% de los lingotes utilizados para la construcci�n del objeto!", fonttypenames.fonttype_info)
    
        .counters.trabajando = .counters.trabajando + 1
    end with

end sub

public sub doupgrade(byval userindex as integer, byval itemindex as integer)
'***************************************************
'author: torres patricio (pato)
'last modification: 12/08/2009
'12/08/2009: pato - implementado nuevo sistema de mejora de items
'***************************************************
dim itemupgrade as integer
dim weaponindex as integer
dim otrouserindex as integer

itemupgrade = objdata(itemindex).upgrade

with userlist(userindex)
    if .flags.comerciando then
        otrouserindex = .comusu.destusu
            
        if otrouserindex > 0 and otrouserindex <= maxusers then
            call writeconsolemsg(userindex, "��comercio cancelado, no puedes comerciar mientras trabajas!!", fonttypenames.fonttype_talk)
            call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
            
            call limpiarcomercioseguro(userindex)
            call protocol.flushbuffer(otrouserindex)
        end if
    end if
        
    'sacamos energ�a
    if .clase = eclass.worker then
        'chequeamos que tenga los puntos antes de sacarselos
        if .stats.minsta >= gasto_energia_trabajador then
            .stats.minsta = .stats.minsta - gasto_energia_trabajador
            call writeupdatesta(userindex)
        else
            call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
            exit sub
        end if
    else
        'chequeamos que tenga los puntos antes de sacarselos
        if .stats.minsta >= gasto_energia_no_trabajador then
            .stats.minsta = .stats.minsta - gasto_energia_no_trabajador
            call writeupdatesta(userindex)
        else
            call writeconsolemsg(userindex, "no tienes suficiente energ�a.", fonttypenames.fonttype_info)
            exit sub
        end if
    end if
    
    if itemupgrade <= 0 then exit sub
    if not tienematerialesupgrade(userindex, itemindex) then exit sub
    
    if puedeconstruirherreria(itemupgrade) then
        
        weaponindex = .invent.weaponeqpobjindex
    
        if weaponindex <> martillo_herrero and weaponindex <> martillo_herrero_newbie then
            call writeconsolemsg(userindex, "debes equiparte el martillo de herrero.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if round(.stats.userskills(eskill.herreria) / modherreria(.clase), 0) < objdata(itemupgrade).skherreria then
            call writeconsolemsg(userindex, "no tienes suficientes skills.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        select case objdata(itemindex).objtype
            case eobjtype.otweapon
                call writeconsolemsg(userindex, "has mejorado el arma!", fonttypenames.fonttype_info)
                
            case eobjtype.otescudo 'todav�a no hay, pero just in case
                call writeconsolemsg(userindex, "has mejorado el escudo!", fonttypenames.fonttype_info)
            
            case eobjtype.otcasco
                call writeconsolemsg(userindex, "has mejorado el casco!", fonttypenames.fonttype_info)
            
            case eobjtype.otarmadura
                call writeconsolemsg(userindex, "has mejorado la armadura!", fonttypenames.fonttype_info)
        end select
        
        call subirskill(userindex, eskill.herreria, true)
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(martilloherrero, .pos.x, .pos.y))
    
    elseif puedeconstruircarpintero(itemupgrade) then
        
        weaponindex = .invent.weaponeqpobjindex
        if weaponindex <> serrucho_carpintero and weaponindex <> serrucho_carpintero_newbie then
            call writeconsolemsg(userindex, "debes equiparte un serrucho.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if round(.stats.userskills(eskill.carpinteria) \ modcarpinteria(.clase), 0) < objdata(itemupgrade).skcarpinteria then
            call writeconsolemsg(userindex, "no tienes suficientes skills.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        select case objdata(itemindex).objtype
            case eobjtype.otflechas
                call writeconsolemsg(userindex, "has mejorado la flecha!", fonttypenames.fonttype_info)
                
            case eobjtype.otweapon
                call writeconsolemsg(userindex, "has mejorado el arma!", fonttypenames.fonttype_info)
                
            case eobjtype.otbarcos
                call writeconsolemsg(userindex, "has mejorado el barco!", fonttypenames.fonttype_info)
        end select
        
        call subirskill(userindex, eskill.carpinteria, true)
        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(laburocarpintero, .pos.x, .pos.y))
    else
        exit sub
    end if
    
    call quitarmaterialesupgrade(userindex, itemindex)
    
    dim miobj as obj
    miobj.amount = 1
    miobj.objindex = itemupgrade
    
    if not meteritemeninventario(userindex, miobj) then
        call tiraritemalpiso(.pos, miobj)
    end if
    
    if objdata(itemindex).log = 1 then _
        call logdesarrollo(.name & " ha mejorado el �tem " & objdata(itemindex).name & " a " & objdata(itemupgrade).name)
        
    .reputacion.pleberep = .reputacion.pleberep + vlproleta
    if .reputacion.pleberep > maxrep then _
        .reputacion.pleberep = maxrep
        
    .counters.trabajando = .counters.trabajando + 1
end with
end sub

function modnavegacion(byval clase as eclass, byval userindex as integer) as single
'***************************************************
'autor: unknown (orginal version)
'last modification: 27/11/2009
'27/11/2009: zama - a worker can navigate before only if it's an expert fisher
'12/04/2010: zama - arreglo modificador de pescador, para que navegue con 60 skills.
'***************************************************
select case clase
    case eclass.pirat
        modnavegacion = 1
    case eclass.worker
        if userlist(userindex).stats.userskills(eskill.pesca) = 100 then
            modnavegacion = 1.71
        else
            modnavegacion = 2
        end if
    case else
        modnavegacion = 2
end select

end function


function modfundicion(byval clase as eclass) as single
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

select case clase
    case eclass.worker
        modfundicion = 1
    case else
        modfundicion = 3
end select

end function

function modcarpinteria(byval clase as eclass) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

select case clase
    case eclass.worker
        modcarpinteria = 1
    case else
        modcarpinteria = 3
end select

end function

function modherreria(byval clase as eclass) as single
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
select case clase
    case eclass.worker
        modherreria = 1
    case else
        modherreria = 4
end select

end function

function moddomar(byval clase as eclass) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
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

function freemascotaindex(byval userindex as integer) as integer
'***************************************************
'author: unknown
'last modification: 02/03/09
'02/03/09: zama - busca un indice libre de mascotas, revisando los types y no los indices de los npcs
'***************************************************
    dim j as integer
    for j = 1 to maxmascotas
        if userlist(userindex).mascotastype(j) = 0 then
            freemascotaindex = j
            exit function
        end if
    next j
end function

sub dodomar(byval userindex as integer, byval npcindex as integer)
'***************************************************
'author: nacho (integer)
'last modification: 01/05/2010
'12/15/2008: zama - limits the number of the same type of pet to 2.
'02/03/2009: zama - las criaturas domadas en zona segura, esperan afuera (desaparecen).
'01/05/2010: zama - agrego bonificacion 11% para domar con flauta magica.
'***************************************************

on error goto errhandler

    dim puntosdomar as integer
    dim puntosrequeridos as integer
    dim canstay as boolean
    dim pettype as integer
    dim nropets as integer
    
    
    if npclist(npcindex).maestrouser = userindex then
        call writeconsolemsg(userindex, "ya domaste a esa criatura.", fonttypenames.fonttype_info)
        exit sub
    end if

    with userlist(userindex)
        if .nromascotas < maxmascotas then
            
            if npclist(npcindex).maestronpc > 0 or npclist(npcindex).maestrouser > 0 then
                call writeconsolemsg(userindex, "la criatura ya tiene amo.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            if not puededomarmascota(userindex, npcindex) then
                call writeconsolemsg(userindex, "no puedes domar m�s de dos criaturas del mismo tipo.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            puntosdomar = cint(.stats.useratributos(eatributos.carisma)) * cint(.stats.userskills(eskill.domar))
            
            ' 20% de bonificacion
            if .invent.anilloeqpobjindex = flautaelfica then
                puntosrequeridos = npclist(npcindex).flags.domable * 0.8
            
            ' 11% de bonificacion
            elseif .invent.anilloeqpobjindex = flautamagica then
                puntosrequeridos = npclist(npcindex).flags.domable * 0.89
                
            else
                puntosrequeridos = npclist(npcindex).flags.domable
            end if
            
            if puntosrequeridos <= puntosdomar and randomnumber(1, 5) = 1 then
                dim index as integer
                .nromascotas = .nromascotas + 1
                index = freemascotaindex(userindex)
                .mascotasindex(index) = npcindex
                .mascotastype(index) = npclist(npcindex).numero
                
                npclist(npcindex).maestrouser = userindex
                
                call followamo(npcindex)
                call respawnnpc(npclist(npcindex))
                
                call writeconsolemsg(userindex, "la criatura te ha aceptado como su amo.", fonttypenames.fonttype_info)
                
                ' es zona segura?
                canstay = (mapinfo(.pos.map).pk = true)
                
                if not canstay then
                    pettype = npclist(npcindex).numero
                    nropets = .nromascotas
                    
                    call quitarnpc(npcindex)
                    
                    .mascotastype(index) = pettype
                    .nromascotas = nropets
                    
                    call writeconsolemsg(userindex, "no se permiten mascotas en zona segura. �stas te esperar�n afuera.", fonttypenames.fonttype_info)
                end if
                
                call subirskill(userindex, eskill.domar, true)
        
            else
                if not .flags.ultimomensaje = 5 then
                    call writeconsolemsg(userindex, "no has logrado domar la criatura.", fonttypenames.fonttype_info)
                    .flags.ultimomensaje = 5
                end if
                
                call subirskill(userindex, eskill.domar, false)
            end if
        else
            call writeconsolemsg(userindex, "no puedes controlar m�s criaturas.", fonttypenames.fonttype_info)
        end if
    end with
    
    exit sub

errhandler:
    call logerror("error en dodomar. error " & err.number & " : " & err.description)

end sub

''
' checks if the user can tames a pet.
'
' @param integer userindex the user id from who wants tame the pet.
' @param integer npcindex the index of the npc to tome.
' @return boolean true if can, false if not.
private function puededomarmascota(byval userindex as integer, byval npcindex as integer) as boolean
'***************************************************
'author: zama
'this function checks how many npcs of the same type have
'been tamed by the user.
'returns true if that amount is less than two.
'***************************************************
    dim i as long
    dim nummascotas as long
    
    for i = 1 to maxmascotas
        if userlist(userindex).mascotastype(i) = npclist(npcindex).numero then
            nummascotas = nummascotas + 1
        end if
    next i
    
    if nummascotas <= 1 then puededomarmascota = true
    
end function

sub doadmininvisible(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/2010 (zama)
'makes an admin invisible o visible.
'13/07/2009: zama - now invisible admins' chars are erased from all clients, except from themselves.
'12/01/2010: zama - los druidas pierden la inmunidad de ser atacados cuando pierden el efecto del mimetismo.
'***************************************************
    
    with userlist(userindex)
        if .flags.admininvisible = 0 then
            ' sacamos el mimetizmo
            if .flags.mimetizado = 1 then
                .char.body = .charmimetizado.body
                .char.head = .charmimetizado.head
                .char.cascoanim = .charmimetizado.cascoanim
                .char.shieldanim = .charmimetizado.shieldanim
                .char.weaponanim = .charmimetizado.weaponanim
                .counters.mimetismo = 0
                .flags.mimetizado = 0
                ' se fue el efecto del mimetismo, puede ser atacado por npcs
                .flags.ignorado = false
            end if
            
            .flags.admininvisible = 1
            .flags.invisible = 1
            .flags.oculto = 1
            .flags.oldbody = .char.body
            .flags.oldhead = .char.head
            .char.body = 0
            .char.head = 0
            
            ' solo el admin sabe que se hace invi
            call enviardatosaslot(userindex, preparemessagesetinvisible(.char.charindex, true))
            'le mandamos el mensaje para que borre el personaje a los clientes que est�n cerca
            call senddata(sendtarget.topcareabutindex, userindex, preparemessagecharacterremove(.char.charindex))
        else
            .flags.admininvisible = 0
            .flags.invisible = 0
            .flags.oculto = 0
            .counters.tiempooculto = 0
            .char.body = .flags.oldbody
            .char.head = .flags.oldhead
            
            ' solo el admin sabe que se hace visible
            call enviardatosaslot(userindex, preparemessagecharacterchange(.char.body, .char.head, .char.heading, _
            .char.charindex, .char.weaponanim, .char.shieldanim, .char.fx, .char.loops, .char.cascoanim))
            call enviardatosaslot(userindex, preparemessagesetinvisible(.char.charindex, false))
             
            'le mandamos el mensaje para crear el personaje a los clientes que est�n cerca
            call makeuserchar(true, .pos.map, userindex, .pos.map, .pos.x, .pos.y, true)
        end if
    end with
    
end sub

sub tratardehacerfogata(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim suerte as byte
dim exito as byte
dim obj as obj
dim posmadera as worldpos

if not legalpos(map, x, y) then exit sub

with posmadera
    .map = map
    .x = x
    .y = y
end with

if mapdata(map, x, y).objinfo.objindex <> 58 then
    call writeconsolemsg(userindex, "necesitas clickear sobre le�a para hacer ramitas.", fonttypenames.fonttype_info)
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

dim supervivenciaskill as byte

supervivenciaskill = userlist(userindex).stats.userskills(eskill.supervivencia)

if supervivenciaskill < 6 then
    suerte = 3
elseif supervivenciaskill <= 34 then
    suerte = 2
else
    suerte = 1
end if

exito = randomnumber(1, suerte)

if exito = 1 then
    obj.objindex = fogata_apag
    obj.amount = mapdata(map, x, y).objinfo.amount \ 3
    
    call writeconsolemsg(userindex, "has hecho " & obj.amount & " fogatas.", fonttypenames.fonttype_info)
    
    call makeobj(obj, map, x, y)
    
    'seteamos la fogata como el nuevo targetobj del user
    userlist(userindex).flags.targetobj = fogata_apag
    
    call subirskill(userindex, eskill.supervivencia, true)
else
    '[cdt 17-02-2004]
    if not userlist(userindex).flags.ultimomensaje = 10 then
        call writeconsolemsg(userindex, "no has podido hacer la fogata.", fonttypenames.fonttype_info)
        userlist(userindex).flags.ultimomensaje = 10
    end if
    '[/cdt]
    
    call subirskill(userindex, eskill.supervivencia, false)
end if

end sub

public sub dopescar(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 28/05/2010
'16/11/2009: zama - implementado nuevo sistema de extraccion.
'11/05/2010: zama - arreglo formula de maximo de items contruibles/extraibles.
'05/13/2010: pato - refix a la formula de maximo de items construibles/extraibles.
'22/05/2010: zama - los caos ya no suben plebe al trabajar.
'28/05/2010: zama - los pks no suben plebe al trabajar.
'***************************************************
on error goto errhandler

dim suerte as integer
dim res as integer
dim cantidaditems as integer
dim skill as integer

with userlist(userindex)
    if .clase = eclass.worker then
        call quitarsta(userindex, esfuerzopescarpescador)
    else
        call quitarsta(userindex, esfuerzopescargeneral)
    end if
    
    
    skill = .stats.userskills(eskill.pesca)
    suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)
    
    res = randomnumber(1, suerte)
    
    if res <= 6 then
        dim miobj as obj
        
        if .clase = eclass.worker then
            cantidaditems = maxitemsextraibles(.stats.elv)
            
            miobj.amount = randomnumber(1, cantidaditems)
        else
            miobj.amount = 1
        end if
        
        miobj.objindex = pescado
        
        if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(.pos, miobj)
        end if
        
        call writeconsolemsg(userindex, "�has pescado un lindo pez!", fonttypenames.fonttype_info)
        
        call subirskill(userindex, eskill.pesca, true)
    else
        '[cdt 17-02-2004]
        if not .flags.ultimomensaje = 6 then
          call writeconsolemsg(userindex, "�no has pescado nada!", fonttypenames.fonttype_info)
          .flags.ultimomensaje = 6
        end if
        '[/cdt]
        
        call subirskill(userindex, eskill.pesca, false)
    end if
    
    if not criminal(userindex) then
        .reputacion.pleberep = .reputacion.pleberep + vlproleta
        if .reputacion.pleberep > maxrep then _
            .reputacion.pleberep = maxrep
    end if
    
    .counters.trabajando = .counters.trabajando + 1
end with

exit sub

errhandler:
    call logerror("error en dopescar. error " & err.number & " : " & err.description)
end sub

public sub dopescarred(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
on error goto errhandler

    dim iskill as integer
    dim suerte as integer
    dim res as integer
    dim espescador as boolean
    dim cantidaditems as integer
    
    with userlist(userindex)
    
        if .clase = eclass.worker then
            call quitarsta(userindex, esfuerzopescarpescador)
            espescador = true
        else
            call quitarsta(userindex, esfuerzopescargeneral)
            espescador = false
        end if
        
        iskill = .stats.userskills(eskill.pesca)
        
        ' m = (60-11)/(1-10)
        ' y = mx - m*10 + 11
        
        suerte = int(-0.00125 * iskill * iskill - 0.3 * iskill + 49)

        if suerte > 0 then
            res = randomnumber(1, suerte)
            
            if res <= 6 then
            
                dim miobj as obj
                
                if espescador then
                    cantidaditems = maxitemsextraibles(.stats.elv)
                    miobj.amount = randomnumber(1, cantidaditems)
                else
                    miobj.amount = 1
                end if
                
                miobj.objindex = listapeces(randomnumber(1, num_peces))
                
                if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(.pos, miobj)
                end if
                
                call writeconsolemsg(userindex, "�has pescado algunos peces!", fonttypenames.fonttype_info)
                
                call subirskill(userindex, eskill.pesca, true)
            else
                if not .flags.ultimomensaje = 6 then
                  call writeconsolemsg(userindex, "�no has pescado nada!", fonttypenames.fonttype_info)
                  .flags.ultimomensaje = 6
                end if
                
                call subirskill(userindex, eskill.pesca, false)
            end if
        end if
        
        .reputacion.pleberep = .reputacion.pleberep + vlproleta
        if .reputacion.pleberep > maxrep then .reputacion.pleberep = maxrep
    
    end with
    
    exit sub

errhandler:
    call logerror("error en dopescarred")
end sub

''
' try to steal an item / gold to another character
'
' @param ladronindex specifies reference to user that stoles
' @param victimaindex specifies reference to user that is being stolen

public sub dorobar(byval ladronindex as integer, byval victimaindex as integer)
'*************************************************
'author: unknown
'last modified: 05/04/2010
'last modification by: zama
'24/07/08: marco - now it calls to writeupdategold(victimaindex and ladronindex) when the thief stoles gold. (markoxx)
'27/11/2009: zama - optimizacion de codigo.
'18/12/2009: zama - los ladrones ciudas pueden robar a pks.
'01/04/2010: zama - los ladrones pasan a robar oro acorde a su nivel.
'05/04/2010: zama - los armadas no pueden robarle a ciudadanos jamas.
'23/04/2010: zama - no se puede robar mas sin energia.
'23/04/2010: zama - el alcance de robo pasa a ser de 1 tile.
'*************************************************

on error goto errhandler

    dim otrouserindex as integer

    if not mapinfo(userlist(victimaindex).pos.map).pk then exit sub
    
    if userlist(victimaindex).flags.enconsulta then
        call writeconsolemsg(ladronindex, "���no puedes robar a usuarios en consulta!!!", fonttypenames.fonttype_info)
        exit sub
    end if
    
    with userlist(ladronindex)
    
        if .flags.seguro then
            if not criminal(victimaindex) then
                call writeconsolemsg(ladronindex, "debes quitarte el seguro para robarle a un ciudadano.", fonttypenames.fonttype_fight)
                exit sub
            end if
        else
            if .faccion.armadareal = 1 then
                if not criminal(victimaindex) then
                    call writeconsolemsg(ladronindex, "los miembros del ej�rcito real no tienen permitido robarle a ciudadanos.", fonttypenames.fonttype_fight)
                    exit sub
                end if
            end if
        end if
        
        ' caos robando a caos?
        if userlist(victimaindex).faccion.fuerzascaos = 1 and .faccion.fuerzascaos = 1 then
            call writeconsolemsg(ladronindex, "no puedes robar a otros miembros de la legi�n oscura.", fonttypenames.fonttype_fight)
            exit sub
        end if
        
        if triggerzonapelea(ladronindex, victimaindex) <> trigger6_ausente then exit sub
    
        
        ' tiene energia?
        if .stats.minsta < 15 then
            if .genero = egenero.hombre then
                call writeconsolemsg(ladronindex, "est�s muy cansado para robar.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(ladronindex, "est�s muy cansada para robar.", fonttypenames.fonttype_info)
            end if
            
            exit sub
        end if
        
        ' quito energia
        call quitarsta(ladronindex, 15)
        
        dim guanteshurto as boolean
    
        if .invent.anilloeqpobjindex = guante_hurto then guanteshurto = true
        
        if userlist(victimaindex).flags.privilegios and playertype.user then
            
            dim suerte as integer
            dim res as integer
            dim robarskill as byte
            
            robarskill = .stats.userskills(eskill.robar)
                
            if robarskill <= 10 then
                suerte = 35
            elseif robarskill <= 20 then
                suerte = 30
            elseif robarskill <= 30 then
                suerte = 28
            elseif robarskill <= 40 then
                suerte = 24
            elseif robarskill <= 50 then
                suerte = 22
            elseif robarskill <= 60 then
                suerte = 20
            elseif robarskill <= 70 then
                suerte = 18
            elseif robarskill <= 80 then
                suerte = 15
            elseif robarskill <= 90 then
                suerte = 10
            elseif robarskill < 100 then
                suerte = 7
            else
                suerte = 5
            end if
            
            res = randomnumber(1, suerte)
                
            if res < 3 then 'exito robo
                if userlist(victimaindex).flags.comerciando then
                    otrouserindex = userlist(victimaindex).comusu.destusu
                        
                    if otrouserindex > 0 and otrouserindex <= maxusers then
                        call writeconsolemsg(victimaindex, "��comercio cancelado, te est�n robando!!", fonttypenames.fonttype_talk)
                        call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
                        
                        call limpiarcomercioseguro(victimaindex)
                        call protocol.flushbuffer(otrouserindex)
                    end if
                end if
               
                if (randomnumber(1, 50) < 25) and (.clase = eclass.thief) then
                    if tieneobjetosrobables(victimaindex) then
                        call robarobjeto(ladronindex, victimaindex)
                    else
                        call writeconsolemsg(ladronindex, userlist(victimaindex).name & " no tiene objetos.", fonttypenames.fonttype_info)
                    end if
                else 'roba oro
                    if userlist(victimaindex).stats.gld > 0 then
                        dim n as long
                        
                        if .clase = eclass.thief then
                        ' si no tine puestos los guantes de hurto roba un 50% menos. pablo (toxicwaste)
                            if guanteshurto then
                                n = randomnumber(.stats.elv * 50, .stats.elv * 100)
                            else
                                n = randomnumber(.stats.elv * 25, .stats.elv * 50)
                            end if
                        else
                            n = randomnumber(1, 100)
                        end if
                        if n > userlist(victimaindex).stats.gld then n = userlist(victimaindex).stats.gld
                        userlist(victimaindex).stats.gld = userlist(victimaindex).stats.gld - n
                        
                        .stats.gld = .stats.gld + n
                        if .stats.gld > maxoro then _
                            .stats.gld = maxoro
                        
                        call writeconsolemsg(ladronindex, "le has robado " & n & " monedas de oro a " & userlist(victimaindex).name, fonttypenames.fonttype_info)
                        call writeupdategold(ladronindex) 'le actualizamos la billetera al ladron
                        
                        call writeupdategold(victimaindex) 'le actualizamos la billetera a la victima
                        call flushbuffer(victimaindex)
                    else
                        call writeconsolemsg(ladronindex, userlist(victimaindex).name & " no tiene oro.", fonttypenames.fonttype_info)
                    end if
                end if
                
                call subirskill(ladronindex, eskill.robar, true)
            else
                call writeconsolemsg(ladronindex, "�no has logrado robar nada!", fonttypenames.fonttype_info)
                call writeconsolemsg(victimaindex, "�" & .name & " ha intentado robarte!", fonttypenames.fonttype_info)
                call flushbuffer(victimaindex)
                
                call subirskill(ladronindex, eskill.robar, false)
            end if
        
            if not criminal(ladronindex) then
                if not criminal(victimaindex) then
                    call volvercriminal(ladronindex)
                end if
            end if
            
            ' se pudo haber convertido si robo a un ciuda
            if criminal(ladronindex) then
                .reputacion.ladronesrep = .reputacion.ladronesrep + vlladron
                if .reputacion.ladronesrep > maxrep then _
                    .reputacion.ladronesrep = maxrep
            end if
        end if
    end with

exit sub

errhandler:
    call logerror("error en dorobar. error " & err.number & " : " & err.description)

end sub

''
' check if one item is stealable
'
' @param victimaindex specifies reference to victim
' @param slot specifies reference to victim's inventory slot
' @return if the item is stealable
public function objesrobable(byval victimaindex as integer, byval slot as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
' agregu� los barcos
' esta funcion determina qu� objetos son robables.
' 22/05/2010: los items newbies ya no son robables.
'***************************************************

dim oi as integer

oi = userlist(victimaindex).invent.object(slot).objindex

objesrobable = _
objdata(oi).objtype <> eobjtype.otllaves and _
userlist(victimaindex).invent.object(slot).equipped = 0 and _
objdata(oi).real = 0 and _
objdata(oi).caos = 0 and _
objdata(oi).objtype <> eobjtype.otbarcos and _
not itemnewbie(oi)

end function

''
' try to steal an item to another character
'
' @param ladronindex specifies reference to user that stoles
' @param victimaindex specifies reference to user that is being stolen
public sub robarobjeto(byval ladronindex as integer, byval victimaindex as integer)
'***************************************************
'author: unknown
'last modification: 02/04/2010
'02/04/2010: zama - modifico la cantidad de items robables por el ladron.
'***************************************************

dim flag as boolean
dim i as integer

flag = false

with userlist(victimaindex)
    if randomnumber(1, 12) < 6 then 'comenzamos por el principio o el final?
        i = 1
        do while not flag and i <= .currentinventoryslots
            'hay objeto en este slot?
            if .invent.object(i).objindex > 0 then
               if objesrobable(victimaindex, i) then
                     if randomnumber(1, 10) < 4 then flag = true
               end if
            end if
            if not flag then i = i + 1
        loop
    else
        i = .currentinventoryslots
        do while not flag and i > 0
          'hay objeto en este slot?
          if .invent.object(i).objindex > 0 then
             if objesrobable(victimaindex, i) then
                   if randomnumber(1, 10) < 4 then flag = true
             end if
          end if
          if not flag then i = i - 1
        loop
    end if
    
    if flag then
        dim miobj as obj
        dim num as integer
        dim objamount as integer
        
        objamount = .invent.object(i).amount
        
        'cantidad al azar entre el 5% y el 10% del total, con minimo 1.
        num = maximoint(1, randomnumber(objamount * 0.05, objamount * 0.1))
                                    
        miobj.amount = num
        miobj.objindex = .invent.object(i).objindex
        
        .invent.object(i).amount = objamount - num
                    
        if .invent.object(i).amount <= 0 then
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

    'if exiting, cancel de quien es robado
    call cancelexit(victimaindex)
end with

end sub

public sub doapu�alar(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as long)
'***************************************************
'autor: nacho (integer) & unknown (orginal version)
'last modification: 04/17/08 - (niconz)
'simplifique la cuenta que hacia para sacar la suerte
'y arregle la cuenta que hacia para sacar el da�o
'***************************************************
dim suerte as integer
dim skill as integer

skill = userlist(userindex).stats.userskills(eskill.apu�alar)

select case userlist(userindex).clase
    case eclass.assasin
        suerte = int(((0.00003 * skill - 0.002) * skill + 0.098) * skill + 4.25)
    
    case eclass.cleric, eclass.paladin, eclass.pirat
        suerte = int(((0.000003 * skill + 0.0006) * skill + 0.0107) * skill + 4.93)
    
    case eclass.bard
        suerte = int(((0.000002 * skill + 0.0002) * skill + 0.032) * skill + 4.81)
    
    case else
        suerte = int(0.0361 * skill + 4.39)
end select


if randomnumber(0, 100) < suerte then
    if victimuserindex <> 0 then
        if userlist(userindex).clase = eclass.assasin then
            da�o = round(da�o * 1.4, 0)
        else
            da�o = round(da�o * 1.5, 0)
        end if
        
        with userlist(victimuserindex)
            .stats.minhp = .stats.minhp - da�o
            call writeconsolemsg(userindex, "has apu�alado a " & .name & " por " & da�o, fonttypenames.fonttype_fight)
            call writeconsolemsg(victimuserindex, "te ha apu�alado " & userlist(userindex).name & " por " & da�o, fonttypenames.fonttype_fight)
        end with
        
        call flushbuffer(victimuserindex)
    else
        npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - int(da�o * 2)
        call writeconsolemsg(userindex, "has apu�alado la criatura por " & int(da�o * 2), fonttypenames.fonttype_fight)
        '[alejo]
        call calculardarexp(userindex, victimnpcindex, da�o * 2)
    end if
    
    call subirskill(userindex, eskill.apu�alar, true)
else
    call writeconsolemsg(userindex, "�no has logrado apu�alar a tu enemigo!", fonttypenames.fonttype_fight)
    call subirskill(userindex, eskill.apu�alar, false)
end if

end sub

public sub doacuchillar(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as integer)
'***************************************************
'autor: zama
'last modification: 12/01/2010
'***************************************************

    if randomnumber(1, 100) <= prob_acuchillar then
        da�o = int(da�o * da�o_acuchillar)
        
        if victimuserindex <> 0 then
        
            with userlist(victimuserindex)
                .stats.minhp = .stats.minhp - da�o
                call writeconsolemsg(userindex, "has acuchillado a " & .name & " por " & da�o, fonttypenames.fonttype_fight)
                call writeconsolemsg(victimuserindex, userlist(userindex).name & " te ha acuchillado por " & da�o, fonttypenames.fonttype_fight)
            end with
            
        else
        
            npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - da�o
            call writeconsolemsg(userindex, "has acuchillado a la criatura por " & da�o, fonttypenames.fonttype_fight)
            call calculardarexp(userindex, victimnpcindex, da�o)
        
        end if
    end if
    
end sub

public sub dogolpecritico(byval userindex as integer, byval victimnpcindex as integer, byval victimuserindex as integer, byval da�o as long)
'***************************************************
'autor: pablo (toxicwaste)
'last modification: 28/01/2007
'01/06/2010: zama - valido si tiene arma equipada antes de preguntar si es vikinga.
'***************************************************
    dim suerte as integer
    dim skill as integer
    dim weaponindex as integer
    
    with userlist(userindex)
        ' es bandido?
        if .clase <> eclass.bandit then exit sub
        
        weaponindex = .invent.weaponeqpobjindex
        
        ' es una espada vikinga?
        if weaponindex <> espada_vikinga then exit sub
    
        skill = .stats.userskills(eskill.wrestling)
    end with
    
    suerte = int((((0.00000003 * skill + 0.000006) * skill + 0.000107) * skill + 0.0893) * 100)
    
    if randomnumber(1, 100) <= suerte then
    
        da�o = int(da�o * 0.75)
        
        if victimuserindex <> 0 then
            
            with userlist(victimuserindex)
                .stats.minhp = .stats.minhp - da�o
                call writeconsolemsg(userindex, "has golpeado cr�ticamente a " & .name & " por " & da�o & ".", fonttypenames.fonttype_fight)
                call writeconsolemsg(victimuserindex, userlist(userindex).name & " te ha golpeado cr�ticamente por " & da�o & ".", fonttypenames.fonttype_fight)
            end with
            
        else
        
            npclist(victimnpcindex).stats.minhp = npclist(victimnpcindex).stats.minhp - da�o
            call writeconsolemsg(userindex, "has golpeado cr�ticamente a la criatura por " & da�o & ".", fonttypenames.fonttype_fight)
            call calculardarexp(userindex, victimnpcindex, da�o)
            
        end if
        
    end if

end sub

public sub quitarsta(byval userindex as integer, byval cantidad as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    userlist(userindex).stats.minsta = userlist(userindex).stats.minsta - cantidad
    if userlist(userindex).stats.minsta < 0 then userlist(userindex).stats.minsta = 0
    call writeupdatesta(userindex)
    
exit sub

errhandler:
    call logerror("error en quitarsta. error " & err.number & " : " & err.description)
    
end sub

public sub dotalar(byval userindex as integer, optional byval darmaderaelfica as boolean = false)
'***************************************************
'autor: unknown
'last modification: 28/05/2010
'16/11/2009: zama - ahora se puede dar madera elfica.
'16/11/2009: zama - implementado nuevo sistema de extraccion.
'11/05/2010: zama - arreglo formula de maximo de items contruibles/extraibles.
'05/13/2010: pato - refix a la formula de maximo de items construibles/extraibles.
'22/05/2010: zama - los caos ya no suben plebe al trabajar.
'28/05/2010: zama - los pks no suben plebe al trabajar.
'***************************************************
on error goto errhandler

dim suerte as integer
dim res as integer
dim cantidaditems as integer
dim skill as integer

with userlist(userindex)
    if .clase = eclass.worker then
        call quitarsta(userindex, esfuerzotalarle�ador)
    else
        call quitarsta(userindex, esfuerzotalargeneral)
    end if
    
    skill = .stats.userskills(eskill.talar)
    suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)
    
    res = randomnumber(1, suerte)
    
    if res <= 6 then
        dim miobj as obj
        
        if .clase = eclass.worker then
            cantidaditems = maxitemsextraibles(.stats.elv)
            
            miobj.amount = randomnumber(1, cantidaditems)
        else
            miobj.amount = 1
        end if
        
        miobj.objindex = iif(darmaderaelfica, le�aelfica, le�a)
        
        if not meteritemeninventario(userindex, miobj) then
            call tiraritemalpiso(.pos, miobj)
        end if
        
        call writeconsolemsg(userindex, "�has conseguido algo de le�a!", fonttypenames.fonttype_info)
        
        call subirskill(userindex, eskill.talar, true)
    else
        '[cdt 17-02-2004]
        if not .flags.ultimomensaje = 8 then
            call writeconsolemsg(userindex, "�no has obtenido le�a!", fonttypenames.fonttype_info)
            .flags.ultimomensaje = 8
        end if
        '[/cdt]
        call subirskill(userindex, eskill.talar, false)
    end if
    
    if not criminal(userindex) then
        .reputacion.pleberep = .reputacion.pleberep + vlproleta
        if .reputacion.pleberep > maxrep then _
            .reputacion.pleberep = maxrep
    end if
    
    .counters.trabajando = .counters.trabajando + 1
end with

exit sub

errhandler:
    call logerror("error en dotalar")

end sub

public sub domineria(byval userindex as integer)
'***************************************************
'autor: unknown
'last modification: 28/05/2010
'16/11/2009: zama - implementado nuevo sistema de extraccion.
'11/05/2010: zama - arreglo formula de maximo de items contruibles/extraibles.
'05/13/2010: pato - refix a la formula de maximo de items construibles/extraibles.
'22/05/2010: zama - los caos ya no suben plebe al trabajar.
'28/05/2010: zama - los pks no suben plebe al trabajar.
'***************************************************
on error goto errhandler

dim suerte as integer
dim res as integer
dim cantidaditems as integer

with userlist(userindex)
    if .clase = eclass.worker then
        call quitarsta(userindex, esfuerzoexcavarminero)
    else
        call quitarsta(userindex, esfuerzoexcavargeneral)
    end if
    
    dim skill as integer
    skill = .stats.userskills(eskill.mineria)
    suerte = int(-0.00125 * skill * skill - 0.3 * skill + 49)
    
    res = randomnumber(1, suerte)
    
    if res <= 5 then
        dim miobj as obj
        
        if .flags.targetobj = 0 then exit sub
        
        miobj.objindex = objdata(.flags.targetobj).mineralindex
        
        if .clase = eclass.worker then
            cantidaditems = maxitemsextraibles(.stats.elv)
            
            miobj.amount = randomnumber(1, cantidaditems)
        else
            miobj.amount = 1
        end if
        
        if not meteritemeninventario(userindex, miobj) then _
            call tiraritemalpiso(.pos, miobj)
        
        call writeconsolemsg(userindex, "�has extraido algunos minerales!", fonttypenames.fonttype_info)
        
        call subirskill(userindex, eskill.mineria, true)
    else
        '[cdt 17-02-2004]
        if not .flags.ultimomensaje = 9 then
            call writeconsolemsg(userindex, "�no has conseguido nada!", fonttypenames.fonttype_info)
            .flags.ultimomensaje = 9
        end if
        '[/cdt]
        call subirskill(userindex, eskill.mineria, false)
    end if
    
    if not criminal(userindex) then
        .reputacion.pleberep = .reputacion.pleberep + vlproleta
        if .reputacion.pleberep > maxrep then _
            .reputacion.pleberep = maxrep
    end if
    
    .counters.trabajando = .counters.trabajando + 1
end with

exit sub

errhandler:
    call logerror("error en sub domineria")

end sub

public sub domeditar(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with userlist(userindex)
        .counters.idlecount = 0
        
        dim suerte as integer
        dim res as integer
        dim cant as integer
        dim meditarskill as byte
    
    
        'barrin 3/10/03
        'esperamos a que se termine de concentrar
        dim tactual as long
        tactual = gettickcount() and &h7fffffff
        if tactual - .counters.tiniciomeditar < tiempo_iniciomeditar then
            exit sub
        end if
        
        if .counters.bpuedemeditar = false then
            .counters.bpuedemeditar = true
        end if
            
        if .stats.minman >= .stats.maxman then
            call writeconsolemsg(userindex, "has terminado de meditar.", fonttypenames.fonttype_info)
            call writemeditatetoggle(userindex)
            .flags.meditando = false
            .char.fx = 0
            .char.loops = 0
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, 0, 0))
            exit sub
        end if
        
        meditarskill = .stats.userskills(eskill.meditar)
        
        if meditarskill <= 10 then
            suerte = 35
        elseif meditarskill <= 20 then
            suerte = 30
        elseif meditarskill <= 30 then
            suerte = 28
        elseif meditarskill <= 40 then
            suerte = 24
        elseif meditarskill <= 50 then
            suerte = 22
        elseif meditarskill <= 60 then
            suerte = 20
        elseif meditarskill <= 70 then
            suerte = 18
        elseif meditarskill <= 80 then
            suerte = 15
        elseif meditarskill <= 90 then
            suerte = 10
        elseif meditarskill < 100 then
            suerte = 7
        else
            suerte = 5
        end if
        res = randomnumber(1, suerte)
        
        if res = 1 then
            
            cant = porcentaje(.stats.maxman, porcentajerecuperomana)
            if cant <= 0 then cant = 1
            .stats.minman = .stats.minman + cant
            if .stats.minman > .stats.maxman then _
                .stats.minman = .stats.maxman
            
            if not .flags.ultimomensaje = 22 then
                call writeconsolemsg(userindex, "�has recuperado " & cant & " puntos de man�!", fonttypenames.fonttype_info)
                .flags.ultimomensaje = 22
            end if
            
            call writeupdatemana(userindex)
            call subirskill(userindex, eskill.meditar, true)
        else
            call subirskill(userindex, eskill.meditar, false)
        end if
    end with
end sub

public sub dodesequipar(byval userindex as integer, byval victimindex as integer)
'***************************************************
'author: zama
'last modif: 15/04/2010
'unequips either shield, weapon or helmet from target user.
'***************************************************

    dim probabilidad as integer
    dim resultado as integer
    dim wrestlingskill as byte
    dim algoequipado as boolean
    
    with userlist(userindex)
        ' si no tiene guantes de hurto no desequipa.
        if .invent.anilloeqpobjindex <> guante_hurto then exit sub
        
        ' si no esta solo con manos, no desequipa tampoco.
        if .invent.weaponeqpobjindex > 0 then exit sub
        
        wrestlingskill = .stats.userskills(eskill.wrestling)
        
        probabilidad = wrestlingskill * 0.2 + .stats.elv * 0.66
   end with
   
   with userlist(victimindex)
        ' si tiene escudo, intenta desequiparlo
        if .invent.escudoeqpobjindex > 0 then
            
            resultado = randomnumber(1, 100)
            
            if resultado <= probabilidad then
                ' se lo desequipo
                call desequipar(victimindex, .invent.escudoeqpslot)
                
                call writeconsolemsg(userindex, "has logrado desequipar el escudo de tu oponente!", fonttypenames.fonttype_fight)
                
                if .stats.elv < 20 then
                    call writeconsolemsg(victimindex, "�tu oponente te ha desequipado el escudo!", fonttypenames.fonttype_fight)
                end if
                
                call flushbuffer(victimindex)
                
                exit sub
            end if
            
            algoequipado = true
        end if
        
        ' no tiene escudo, o fallo desequiparlo, entonces trata de desequipar arma
        if .invent.weaponeqpobjindex > 0 then
            
            resultado = randomnumber(1, 100)
            
            if resultado <= probabilidad then
                ' se lo desequipo
                call desequipar(victimindex, .invent.weaponeqpslot)
                
                call writeconsolemsg(userindex, "has logrado desarmar a tu oponente!", fonttypenames.fonttype_fight)
                
                if .stats.elv < 20 then
                    call writeconsolemsg(victimindex, "�tu oponente te ha desarmado!", fonttypenames.fonttype_fight)
                end if
                
                call flushbuffer(victimindex)
                
                exit sub
            end if
            
            algoequipado = true
        end if
        
        ' no tiene arma, o fallo desequiparla, entonces trata de desequipar casco
        if .invent.cascoeqpobjindex > 0 then
            
            resultado = randomnumber(1, 100)
            
            if resultado <= probabilidad then
                ' se lo desequipo
                call desequipar(victimindex, .invent.cascoeqpslot)
                
                call writeconsolemsg(userindex, "has logrado desequipar el casco de tu oponente!", fonttypenames.fonttype_fight)
                
                if .stats.elv < 20 then
                    call writeconsolemsg(victimindex, "�tu oponente te ha desequipado el casco!", fonttypenames.fonttype_fight)
                end if
                
                call flushbuffer(victimindex)
                
                exit sub
            end if
            
            algoequipado = true
        end if
    
        if algoequipado then
            call writeconsolemsg(userindex, "tu oponente no tiene equipado items!", fonttypenames.fonttype_fight)
        else
            call writeconsolemsg(userindex, "no has logrado desequipar ning�n item a tu oponente!", fonttypenames.fonttype_fight)
        end if
    
    end with


end sub

public sub dohurtar(byval userindex as integer, byval victimaindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modif: 03/03/2010
'implements the pick pocket skill of the bandit :)
'03/03/2010 - pato: s�lo se puede hurtar si no est� en trigger 6 :)
'***************************************************
dim otrouserindex as integer

if triggerzonapelea(userindex, victimaindex) <> trigger6_ausente then exit sub

if userlist(userindex).clase <> eclass.bandit then exit sub
'esto es precario y feo, pero por ahora no se me ocurri� nada mejor.
'uso el slot de los anillos para "equipar" los guantes.
'y los reconozco porque les puse defensamagicamin y max = 0
if userlist(userindex).invent.anilloeqpobjindex <> guante_hurto then exit sub

dim res as integer
res = randomnumber(1, 100)
if (res < 20) then
    if tieneobjetosrobables(victimaindex) then
    
        if userlist(victimaindex).flags.comerciando then
            otrouserindex = userlist(victimaindex).comusu.destusu
                
            if otrouserindex > 0 and otrouserindex <= maxusers then
                call writeconsolemsg(victimaindex, "��comercio cancelado, te est�n robando!!", fonttypenames.fonttype_talk)
                call writeconsolemsg(otrouserindex, "��comercio cancelado por el otro usuario!!", fonttypenames.fonttype_talk)
                
                call limpiarcomercioseguro(victimaindex)
                call protocol.flushbuffer(otrouserindex)
            end if
        end if
                
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
        
    
    if userlist(userindex).invent.anilloeqpobjindex <> guante_hurto then exit sub
        
    dim res as integer
    res = randomnumber(0, 100)
    if res < (userlist(userindex).stats.userskills(eskill.wrestling) / 4) then
        userlist(victimaindex).flags.paralizado = 1
        userlist(victimaindex).counters.paralisis = intervaloparalizado / 2
        
        userlist(victimaindex).flags.paralizedbyindex = userindex
        userlist(victimaindex).flags.paralizedby = userlist(userindex).name
        
        call writeparalizeok(victimaindex)
        call writeconsolemsg(userindex, "tu golpe ha dejado inm�vil a tu oponente", fonttypenames.fonttype_info)
        call writeconsolemsg(victimaindex, "�el golpe te ha dejado inm�vil!", fonttypenames.fonttype_info)
    end if

end sub

public sub desarmar(byval userindex as integer, byval victimindex as integer)
'***************************************************
'author: unknown
'last modification: 02/04/2010 (zama)
'02/04/2010: zama - nueva formula para desarmar.
'***************************************************

    dim probabilidad as integer
    dim resultado as integer
    dim wrestlingskill as byte
    
    with userlist(userindex)
        wrestlingskill = .stats.userskills(eskill.wrestling)
        
        probabilidad = wrestlingskill * 0.2 + .stats.elv * 0.66
        
        resultado = randomnumber(1, 100)
        
        if resultado <= probabilidad then
            call desequipar(victimindex, userlist(victimindex).invent.weaponeqpslot)
            call writeconsolemsg(userindex, "has logrado desarmar a tu oponente!", fonttypenames.fonttype_fight)
            if userlist(victimindex).stats.elv < 20 then
                call writeconsolemsg(victimindex, "�tu oponente te ha desarmado!", fonttypenames.fonttype_fight)
            end if
            call flushbuffer(victimindex)
        end if
    end with
    
end sub

public function maxitemsconstruibles(byval userindex as integer) as integer
'***************************************************
'author: zama
'last modification: 29/01/2010
'11/05/2010: zama - arreglo formula de maximo de items contruibles/extraibles.
'05/13/2010: pato - refix a la formula de maximo de items construibles/extraibles.
'***************************************************
    
    with userlist(userindex)
        if .clase = eclass.worker then
            maxitemsconstruibles = maximoint(1, cint((.stats.elv - 2) * 0.2))
        else
            maxitemsconstruibles = 1
        end if
    end with
end function

public function maxitemsextraibles(byval userlevel as integer) as integer
'***************************************************
'author: zama
'last modification: 14/05/2010
'***************************************************
    maxitemsextraibles = maximoint(1, cint((userlevel - 2) * 0.2)) + 1
end function

public sub imitatenpc(byval userindex as integer, byval npcindex as integer)
'***************************************************
'author: zama
'last modification: 20/11/2010
'copies body, head and desc from previously clicked npc.
'***************************************************
    
    with userlist(userindex)
        
        ' copy desc
        .descrm = npclist(npcindex).name
        
        ' remove anims (npcs don't use equipment anims yet)
        .char.cascoanim = ninguncasco
        .char.shieldanim = ningunescudo
        .char.weaponanim = ningunarma
        
        ' if admin is invisible the store it in old char
        if .flags.admininvisible = 1 or .flags.invisible = 1 or .flags.oculto = 1 then
            
            .flags.oldbody = npclist(npcindex).char.body
            .flags.oldhead = npclist(npcindex).char.head
        else
            .char.body = npclist(npcindex).char.body
            .char.head = npclist(npcindex).char.head
            
            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        end if
    
    end with
    
end sub

