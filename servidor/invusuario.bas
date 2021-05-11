attribute vb_name = "invusuario"
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

public function tieneobjetosrobables(byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'17/09/02
'agregue que la funci�n se asegure que el objeto no es un barco

on error resume next

dim i as integer
dim objindex as integer

for i = 1 to userlist(userindex).currentinventoryslots
    objindex = userlist(userindex).invent.object(i).objindex
    if objindex > 0 then
            if (objdata(objindex).objtype <> eobjtype.otllaves and _
                objdata(objindex).objtype <> eobjtype.otbarcos) then
                  tieneobjetosrobables = true
                  exit function
            end if
    
    end if
next i
end function

function clasepuedeusaritem(byval userindex as integer, byval objindex as integer, optional byref smotivo as string) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - agrego el motivo por el que no puede equipar/usar el item.
'***************************************************

on error goto manejador

    dim flag as boolean
    
    'admins can use anything!
    if userlist(userindex).flags.privilegios and playertype.user then
        if objdata(objindex).claseprohibida(1) <> 0 then
            dim i as integer
            for i = 1 to numclases
                if objdata(objindex).claseprohibida(i) = userlist(userindex).clase then
                    clasepuedeusaritem = false
                    smotivo = "tu clase no puede usar este objeto."
                    exit function
                end if
            next i
        end if
    end if
    
    clasepuedeusaritem = true

exit function

manejador:
    logerror ("error en clasepuedeusaritem")
end function

sub quitarnewbieobj(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim j as integer

with userlist(userindex)
    for j = 1 to userlist(userindex).currentinventoryslots
        if .invent.object(j).objindex > 0 then
             
             if objdata(.invent.object(j).objindex).newbie = 1 then _
                    call quitaruserinvitem(userindex, j, max_inventory_objs)
                    call updateuserinv(false, userindex, j)
        
        end if
    next j
    
    '[barrin 17-12-03] si el usuario dej� de ser newbie, y estaba en el newbie dungeon
    'es transportado a su hogar de origen ;)
    if ucase$(mapinfo(.pos.map).restringir) = "newbie" then
        
        dim dedonde as worldpos
        
        select case .hogar
            case eciudad.clindos 'vamos a tener que ir por todo el desierto... uff!
                dedonde = lindos
            case eciudad.cullathorpe
                dedonde = ullathorpe
            case eciudad.cbanderbill
                dedonde = banderbill
            case else
                dedonde = nix
        end select
        
        call warpuserchar(userindex, dedonde.map, dedonde.x, dedonde.y, true)
    
    end if
    '[/barrin]
end with

end sub

sub limpiarinventario(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim j as integer

with userlist(userindex)
    for j = 1 to .currentinventoryslots
        .invent.object(j).objindex = 0
        .invent.object(j).amount = 0
        .invent.object(j).equipped = 0
    next j
    
    .invent.nroitems = 0
    
    .invent.armoureqpobjindex = 0
    .invent.armoureqpslot = 0
    
    .invent.weaponeqpobjindex = 0
    .invent.weaponeqpslot = 0
    
    .invent.cascoeqpobjindex = 0
    .invent.cascoeqpslot = 0
    
    .invent.escudoeqpobjindex = 0
    .invent.escudoeqpslot = 0
    
    .invent.anilloeqpobjindex = 0
    .invent.anilloeqpslot = 0
    
    .invent.municioneqpobjindex = 0
    .invent.municioneqpslot = 0
    
    .invent.barcoobjindex = 0
    .invent.barcoslot = 0
    
    .invent.mochilaeqpobjindex = 0
    .invent.mochilaeqpslot = 0
end with

end sub

sub tiraroro(byval cantidad as long, byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 23/01/2007
'23/01/2007 -> pablo (toxicwaste): billetera invertida y explotar oro en el agua.
'***************************************************
on error goto errhandler

'if cantidad > 100000 then exit sub

with userlist(userindex)
    'si el pjta tiene oro lo tiramos
    if (cantidad > 0) and (cantidad <= .stats.gld) then
            dim i as byte
            dim miobj as obj
            'info debug
            dim loops as integer
            
            'seguridad alkon (guardo el oro tirado si supera los 50k)
            if cantidad > 50000 then
                dim j as integer
                dim k as integer
                dim m as integer
                dim cercanos as string
                m = .pos.map
                for j = .pos.x - 10 to .pos.x + 10
                    for k = .pos.y - 10 to .pos.y + 10
                        if inmapbounds(m, j, k) then
                            if mapdata(m, j, k).userindex > 0 then
                                cercanos = cercanos & userlist(mapdata(m, j, k).userindex).name & ","
                            end if
                        end if
                    next k
                next j
                call logdesarrollo(.name & " tira oro. cercanos: " & cercanos)
            end if
            '/seguridad
            dim extra as long
            dim teniaoro as long
            teniaoro = .stats.gld
            if cantidad > 500000 then 'para evitar explotar demasiado
                extra = cantidad - 500000
                cantidad = 500000
            end if
            
            do while (cantidad > 0)
                
                if cantidad > max_inventory_objs and .stats.gld > max_inventory_objs then
                    miobj.amount = max_inventory_objs
                    cantidad = cantidad - miobj.amount
                else
                    miobj.amount = cantidad
                    cantidad = cantidad - miobj.amount
                end if
    
                miobj.objindex = ioro
                
                if esgm(userindex) then call loggm(.name, "tir� cantidad:" & miobj.amount & " objeto:" & objdata(miobj.objindex).name)
                dim auxpos as worldpos
                
                if .clase = eclass.pirat and .invent.barcoobjindex = 476 then
                    auxpos = tiraritemalpiso(.pos, miobj, false)
                    if auxpos.x <> 0 and auxpos.y <> 0 then
                        .stats.gld = .stats.gld - miobj.amount
                    end if
                else
                    auxpos = tiraritemalpiso(.pos, miobj, true)
                    if auxpos.x <> 0 and auxpos.y <> 0 then
                        .stats.gld = .stats.gld - miobj.amount
                    end if
                end if
                
                'info debug
                loops = loops + 1
                if loops > 100 then
                    logerror ("error en tiraroro")
                    exit sub
                end if
                
            loop
            if teniaoro = .stats.gld then extra = 0
            if extra > 0 then
                .stats.gld = .stats.gld - extra
            end if
        
    end if
end with

exit sub

errhandler:
    call logerror("error en tiraroro. error " & err.number & " : " & err.description)
end sub

sub quitaruserinvitem(byval userindex as integer, byval slot as byte, byval cantidad as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    if slot < 1 or slot > userlist(userindex).currentinventoryslots then exit sub
    
    with userlist(userindex).invent.object(slot)
        if .amount <= cantidad and .equipped = 1 then
            call desequipar(userindex, slot)
        end if
        
        'quita un objeto
        .amount = .amount - cantidad
        '�quedan mas?
        if .amount <= 0 then
            userlist(userindex).invent.nroitems = userlist(userindex).invent.nroitems - 1
            .objindex = 0
            .amount = 0
        end if
    end with

exit sub

errhandler:
    call logerror("error en quitaruserinvitem. error " & err.number & " : " & err.description)
    
end sub

sub updateuserinv(byval updateall as boolean, byval userindex as integer, byval slot as byte)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

dim nullobj as userobj
dim loopc as long

with userlist(userindex)
    'actualiza un solo slot
    if not updateall then
    
        'actualiza el inventario
        if .invent.object(slot).objindex > 0 then
            call changeuserinv(userindex, slot, .invent.object(slot))
        else
            call changeuserinv(userindex, slot, nullobj)
        end if
    
    else
    
    'actualiza todos los slots
        for loopc = 1 to .currentinventoryslots
            'actualiza el inventario
            if .invent.object(loopc).objindex > 0 then
                call changeuserinv(userindex, loopc, .invent.object(loopc))
            else
                call changeuserinv(userindex, loopc, nullobj)
            end if
        next loopc
    end if
    
    exit sub
end with

errhandler:
    call logerror("error en updateuserinv. error " & err.number & " : " & err.description)

end sub

sub dropobj(byval userindex as integer, byval slot as byte, byval num as integer, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim obj as obj

with userlist(userindex)
    if num > 0 then
    
        if num > .invent.object(slot).amount then num = .invent.object(slot).amount
        
        obj.objindex = .invent.object(slot).objindex
        obj.amount = num
        
        if (itemnewbie(obj.objindex) and (.flags.privilegios and playertype.user)) then
            call writeconsolemsg(userindex, "no puedes tirar objetos newbie.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'check objeto en el suelo
        if mapdata(.pos.map, x, y).objinfo.objindex = 0 or mapdata(.pos.map, x, y).objinfo.objindex = obj.objindex then
            if num + mapdata(.pos.map, x, y).objinfo.amount > max_inventory_objs then
                num = max_inventory_objs - mapdata(.pos.map, x, y).objinfo.amount
            end if
            
            call makeobj(obj, map, x, y)
            call quitaruserinvitem(userindex, slot, num)
            call updateuserinv(false, userindex, slot)
            
            if objdata(obj.objindex).objtype = eobjtype.otbarcos then
                call writeconsolemsg(userindex, "��atenci�n!! �acabas de tirar tu barca!", fonttypenames.fonttype_talk)
            end if
            
            if not .flags.privilegios and playertype.user then call loggm(.name, "tir� cantidad:" & num & " objeto:" & objdata(obj.objindex).name)
            
            'log de objetos que se tiran al piso. pablo (toxicwaste) 07/09/07
            'es un objeto que tenemos que loguear?
            if objdata(obj.objindex).log = 1 then
                call logdesarrollo(.name & " tir� al piso " & obj.amount & " " & objdata(obj.objindex).name & " mapa: " & map & " x: " & x & " y: " & y)
            elseif obj.amount > 5000 then 'es mucha cantidad? > sub� a 5000 el minimo porque si no se llenaba el log de cosas al pedo. (niconz)
                'si no es de los prohibidos de loguear, lo logueamos.
                if objdata(obj.objindex).nolog <> 1 then
                    call logdesarrollo(.name & " tir� al piso " & obj.amount & " " & objdata(obj.objindex).name & " mapa: " & map & " x: " & x & " y: " & y)
                end if
            end if
        else
            call writeconsolemsg(userindex, "no hay espacio en el piso.", fonttypenames.fonttype_info)
        end if
    end if
end with

end sub

sub eraseobj(byval num as integer, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

with mapdata(map, x, y)
    .objinfo.amount = .objinfo.amount - num
    
    if .objinfo.amount <= 0 then
        .objinfo.objindex = 0
        .objinfo.amount = 0
        
        call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectdelete(x, y))
    end if
end with

end sub

sub makeobj(byref obj as obj, byval map as integer, byval x as integer, byval y as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    
    if obj.objindex > 0 and obj.objindex <= ubound(objdata) then
    
        with mapdata(map, x, y)
            if .objinfo.objindex = obj.objindex then
                .objinfo.amount = .objinfo.amount + obj.amount
            else
                .objinfo = obj
                
                call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectcreate(objdata(obj.objindex).grhindex, x, y))
            end if
        end with
    end if

end sub

function meteritemeninventario(byval userindex as integer, byref miobj as obj) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    dim x as integer
    dim y as integer
    dim slot as byte
    
    with userlist(userindex)
        '�el user ya tiene un objeto del mismo tipo?
        slot = 1
        do until .invent.object(slot).objindex = miobj.objindex and _
                 .invent.object(slot).amount + miobj.amount <= max_inventory_objs
           slot = slot + 1
           if slot > .currentinventoryslots then
                 exit do
           end if
        loop
            
        'sino busca un slot vacio
        if slot > .currentinventoryslots then
           slot = 1
           do until .invent.object(slot).objindex = 0
               slot = slot + 1
               if slot > .currentinventoryslots then
                   call writeconsolemsg(userindex, "no puedes cargar m�s objetos.", fonttypenames.fonttype_fight)
                   meteritemeninventario = false
                   exit function
               end if
           loop
           .invent.nroitems = .invent.nroitems + 1
        end if
    
        if slot > max_normal_inventory_slots and slot < max_inventory_slots then
            if not itemsecae(miobj.objindex) then
                call writeconsolemsg(userindex, "no puedes contener objetos especiales en tu " & objdata(.invent.mochilaeqpobjindex).name & ".", fonttypenames.fonttype_fight)
                meteritemeninventario = false
                exit function
            end if
        end if
        'mete el objeto
        if .invent.object(slot).amount + miobj.amount <= max_inventory_objs then
           'menor que max_inv_objs
           .invent.object(slot).objindex = miobj.objindex
           .invent.object(slot).amount = .invent.object(slot).amount + miobj.amount
        else
           .invent.object(slot).amount = max_inventory_objs
        end if
    end with
    
    meteritemeninventario = true
           
    call updateuserinv(false, userindex, slot)
    
    
    exit function
errhandler:
    call logerror("error en meteritemeninventario. error " & err.number & " : " & err.description)
end function

sub getobj(byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 18/12/2009
'18/12/2009: zama - oro directo a la billetera.
'***************************************************

    dim obj as objdata
    dim miobj as obj
    dim objpos as string
    
    with userlist(userindex)
        '�hay algun obj?
        if mapdata(.pos.map, .pos.x, .pos.y).objinfo.objindex > 0 then
            '�esta permitido agarrar este obj?
            if objdata(mapdata(.pos.map, .pos.x, .pos.y).objinfo.objindex).agarrable <> 1 then
                dim x as integer
                dim y as integer
                dim slot as byte
                
                x = .pos.x
                y = .pos.y
                
                obj = objdata(mapdata(.pos.map, .pos.x, .pos.y).objinfo.objindex)
                miobj.amount = mapdata(.pos.map, x, y).objinfo.amount
                miobj.objindex = mapdata(.pos.map, x, y).objinfo.objindex
                
                ' oro directo a la billetera!
                if obj.objtype = otguita then
                    .stats.gld = .stats.gld + miobj.amount
                    'quitamos el objeto
                    call eraseobj(mapdata(.pos.map, x, y).objinfo.amount, .pos.map, .pos.x, .pos.y)
                        
                    call writeupdategold(userindex)
                else
                    if meteritemeninventario(userindex, miobj) then
                    
                        'quitamos el objeto
                        call eraseobj(mapdata(.pos.map, x, y).objinfo.amount, .pos.map, .pos.x, .pos.y)
                        if not .flags.privilegios and playertype.user then call loggm(.name, "agarro:" & miobj.amount & " objeto:" & objdata(miobj.objindex).name)
        
                        'log de objetos que se agarran del piso. pablo (toxicwaste) 07/09/07
                        'es un objeto que tenemos que loguear?
                        if objdata(miobj.objindex).log = 1 then
                            objpos = " mapa: " & .pos.map & " x: " & .pos.x & " y: " & .pos.y
                            call logdesarrollo(.name & " junt� del piso " & miobj.amount & " " & objdata(miobj.objindex).name & objpos)
                        elseif miobj.amount > max_inventory_objs - 1000 then 'es mucha cantidad?
                            'si no es de los prohibidos de loguear, lo logueamos.
                            if objdata(miobj.objindex).nolog <> 1 then
                                objpos = " mapa: " & .pos.map & " x: " & .pos.x & " y: " & .pos.y
                                call logdesarrollo(.name & " junt� del piso " & miobj.amount & " " & objdata(miobj.objindex).name & objpos)
                            end if
                        end if
                    end if
                end if
            end if
        else
            call writeconsolemsg(userindex, "no hay nada aqu�.", fonttypenames.fonttype_info)
        end if
    end with

end sub

sub desequipar(byval userindex as integer, byval slot as byte)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

    'desequipa el item slot del inventario
    dim obj as objdata
    
    with userlist(userindex)
        with .invent
            if (slot < lbound(.object)) or (slot > ubound(.object)) then
                exit sub
            elseif .object(slot).objindex = 0 then
                exit sub
            end if
            
            obj = objdata(.object(slot).objindex)
        end with
        
        select case obj.objtype
            case eobjtype.otweapon
                with .invent
                    .object(slot).equipped = 0
                    .weaponeqpobjindex = 0
                    .weaponeqpslot = 0
                end with
                
                if not .flags.mimetizado = 1 then
                    with .char
                        .weaponanim = ningunarma
                        call changeuserchar(userindex, .body, .head, .heading, .weaponanim, .shieldanim, .cascoanim)
                    end with
                end if
            
            case eobjtype.otflechas
                with .invent
                    .object(slot).equipped = 0
                    .municioneqpobjindex = 0
                    .municioneqpslot = 0
                end with
            
            case eobjtype.otanillo
                with .invent
                    .object(slot).equipped = 0
                    .anilloeqpobjindex = 0
                    .anilloeqpslot = 0
                end with
            
            case eobjtype.otarmadura
                with .invent
                    .object(slot).equipped = 0
                    .armoureqpobjindex = 0
                    .armoureqpslot = 0
                end with
                
                call darcuerpodesnudo(userindex, .flags.mimetizado = 1)
                with .char
                    call changeuserchar(userindex, .body, .head, .heading, .weaponanim, .shieldanim, .cascoanim)
                end with
                 
            case eobjtype.otcasco
                with .invent
                    .object(slot).equipped = 0
                    .cascoeqpobjindex = 0
                    .cascoeqpslot = 0
                end with
                
                if not .flags.mimetizado = 1 then
                    with .char
                        .cascoanim = ninguncasco
                        call changeuserchar(userindex, .body, .head, .heading, .weaponanim, .shieldanim, .cascoanim)
                    end with
                end if
            
            case eobjtype.otescudo
                with .invent
                    .object(slot).equipped = 0
                    .escudoeqpobjindex = 0
                    .escudoeqpslot = 0
                end with
                
                if not .flags.mimetizado = 1 then
                    with .char
                        .shieldanim = ningunescudo
                        call changeuserchar(userindex, .body, .head, .heading, .weaponanim, .shieldanim, .cascoanim)
                    end with
                end if
            
            case eobjtype.otmochilas
                with .invent
                    .object(slot).equipped = 0
                    .mochilaeqpobjindex = 0
                    .mochilaeqpslot = 0
                end with
                
                call invusuario.tirartodoslositemsenmochila(userindex)
                .currentinventoryslots = max_normal_inventory_slots
        end select
    end with
    
    call writeupdateuserstats(userindex)
    call updateuserinv(false, userindex, slot)
    
    exit sub

errhandler:
    call logerror("error en desquipar. error " & err.number & " : " & err.description)

end sub

function sexopuedeusaritem(byval userindex as integer, byval objindex as integer, optional byref smotivo as string) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - agrego el motivo por el que no puede equipar/usar el item.
'***************************************************

on error goto errhandler
    
    if objdata(objindex).mujer = 1 then
        sexopuedeusaritem = userlist(userindex).genero <> egenero.hombre
    elseif objdata(objindex).hombre = 1 then
        sexopuedeusaritem = userlist(userindex).genero <> egenero.mujer
    else
        sexopuedeusaritem = true
    end if
    
    if not sexopuedeusaritem then smotivo = "tu g�nero no puede usar este objeto."
    
    exit function
errhandler:
    call logerror("sexopuedeusaritem")
end function


function faccionpuedeusaritem(byval userindex as integer, byval objindex as integer, optional byref smotivo as string) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - agrego el motivo por el que no puede equipar/usar el item.
'***************************************************

    if objdata(objindex).real = 1 then
        if not criminal(userindex) then
            faccionpuedeusaritem = esarmada(userindex)
        else
            faccionpuedeusaritem = false
        end if
    elseif objdata(objindex).caos = 1 then
        if criminal(userindex) then
            faccionpuedeusaritem = escaos(userindex)
        else
            faccionpuedeusaritem = false
        end if
    else
        faccionpuedeusaritem = true
    end if
    
    if not faccionpuedeusaritem then smotivo = "tu alineaci�n no puede usar este objeto."

end function

sub equiparinvitem(byval userindex as integer, byval slot as byte)
'*************************************************
'author: unknown
'last modified: 14/01/2010 (zama)
'01/08/2009: zama - now it's not sent any sound made by an invisible admin
'14/01/2010: zama - agrego el motivo especifico por el que no puede equipar/usar el item.
'*************************************************

on error goto errhandler

    'equipa un item del inventario
    dim obj as objdata
    dim objindex as integer
    dim smotivo as string
    
    with userlist(userindex)
        objindex = .invent.object(slot).objindex
        obj = objdata(objindex)
        
        if obj.newbie = 1 and not esnewbie(userindex) then
             call writeconsolemsg(userindex, "s�lo los newbies pueden usar este objeto.", fonttypenames.fonttype_info)
             exit sub
        end if
                
        select case obj.objtype
            case eobjtype.otweapon
               if clasepuedeusaritem(userindex, objindex, smotivo) and _
                  faccionpuedeusaritem(userindex, objindex, smotivo) then
                    'si esta equipado lo quita
                    if .invent.object(slot).equipped then
                        'quitamos del inv el item
                        call desequipar(userindex, slot)
                        'animacion por defecto
                        if .flags.mimetizado = 1 then
                            .charmimetizado.weaponanim = ningunarma
                        else
                            .char.weaponanim = ningunarma
                            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                        end if
                        exit sub
                    end if
                    
                    'quitamos el elemento anterior
                    if .invent.weaponeqpobjindex > 0 then
                        call desequipar(userindex, .invent.weaponeqpslot)
                    end if
                    
                    .invent.object(slot).equipped = 1
                    .invent.weaponeqpobjindex = objindex
                    .invent.weaponeqpslot = slot
                    
                    'el sonido solo se envia si no lo produce un admin invisible
                    if not (.flags.admininvisible = 1) then _
                        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_sacararma, .pos.x, .pos.y))
                    
                    if .flags.mimetizado = 1 then
                        .charmimetizado.weaponanim = getweaponanim(userindex, objindex)
                    else
                        .char.weaponanim = getweaponanim(userindex, objindex)
                        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                    end if
               else
                    call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
               end if
            
            case eobjtype.otanillo
               if clasepuedeusaritem(userindex, objindex, smotivo) and _
                  faccionpuedeusaritem(userindex, objindex, smotivo) then
                        'si esta equipado lo quita
                        if .invent.object(slot).equipped then
                            'quitamos del inv el item
                            call desequipar(userindex, slot)
                            exit sub
                        end if
                        
                        'quitamos el elemento anterior
                        if .invent.anilloeqpobjindex > 0 then
                            call desequipar(userindex, .invent.anilloeqpslot)
                        end if
                
                        .invent.object(slot).equipped = 1
                        .invent.anilloeqpobjindex = objindex
                        .invent.anilloeqpslot = slot
                        
               else
                    call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
               end if
            
            case eobjtype.otflechas
               if clasepuedeusaritem(userindex, objindex, smotivo) and _
                  faccionpuedeusaritem(userindex, objindex, smotivo) then
                        
                        'si esta equipado lo quita
                        if .invent.object(slot).equipped then
                            'quitamos del inv el item
                            call desequipar(userindex, slot)
                            exit sub
                        end if
                        
                        'quitamos el elemento anterior
                        if .invent.municioneqpobjindex > 0 then
                            call desequipar(userindex, .invent.municioneqpslot)
                        end if
                
                        .invent.object(slot).equipped = 1
                        .invent.municioneqpobjindex = objindex
                        .invent.municioneqpslot = slot
                        
               else
                    call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
               end if
            
            case eobjtype.otarmadura
                if .flags.navegando = 1 then exit sub
                
                'nos aseguramos que puede usarla
                if clasepuedeusaritem(userindex, objindex, smotivo) and _
                   sexopuedeusaritem(userindex, objindex, smotivo) and _
                   checkrazausaropa(userindex, objindex, smotivo) and _
                   faccionpuedeusaritem(userindex, objindex, smotivo) then
                   
                   'si esta equipado lo quita
                    if .invent.object(slot).equipped then
                        call desequipar(userindex, slot)
                        call darcuerpodesnudo(userindex, .flags.mimetizado = 1)
                        if not .flags.mimetizado = 1 then
                            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                        end if
                        exit sub
                    end if
            
                    'quita el anterior
                    if .invent.armoureqpobjindex > 0 then
                        call desequipar(userindex, .invent.armoureqpslot)
                    end if
            
                    'lo equipa
                    .invent.object(slot).equipped = 1
                    .invent.armoureqpobjindex = objindex
                    .invent.armoureqpslot = slot
                        
                    if .flags.mimetizado = 1 then
                        .charmimetizado.body = obj.ropaje
                    else
                        .char.body = obj.ropaje
                        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                    end if
                    .flags.desnudo = 0
                else
                    call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
                end if
            
            case eobjtype.otcasco
                if .flags.navegando = 1 then exit sub
                if clasepuedeusaritem(userindex, objindex, smotivo) then
                    'si esta equipado lo quita
                    if .invent.object(slot).equipped then
                        call desequipar(userindex, slot)
                        if .flags.mimetizado = 1 then
                            .charmimetizado.cascoanim = ninguncasco
                        else
                            .char.cascoanim = ninguncasco
                            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                        end if
                        exit sub
                    end if
            
                    'quita el anterior
                    if .invent.cascoeqpobjindex > 0 then
                        call desequipar(userindex, .invent.cascoeqpslot)
                    end if
            
                    'lo equipa
                    
                    .invent.object(slot).equipped = 1
                    .invent.cascoeqpobjindex = objindex
                    .invent.cascoeqpslot = slot
                    if .flags.mimetizado = 1 then
                        .charmimetizado.cascoanim = obj.cascoanim
                    else
                        .char.cascoanim = obj.cascoanim
                        call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                    end if
                else
                    call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
                end if
            
            case eobjtype.otescudo
                if .flags.navegando = 1 then exit sub
                
                 if clasepuedeusaritem(userindex, objindex, smotivo) and _
                     faccionpuedeusaritem(userindex, objindex, smotivo) then
        
                     'si esta equipado lo quita
                     if .invent.object(slot).equipped then
                         call desequipar(userindex, slot)
                         if .flags.mimetizado = 1 then
                             .charmimetizado.shieldanim = ningunescudo
                         else
                             .char.shieldanim = ningunescudo
                             call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                         end if
                         exit sub
                     end if
             
                     'quita el anterior
                     if .invent.escudoeqpobjindex > 0 then
                         call desequipar(userindex, .invent.escudoeqpslot)
                     end if
             
                     'lo equipa
                     
                     .invent.object(slot).equipped = 1
                     .invent.escudoeqpobjindex = objindex
                     .invent.escudoeqpslot = slot
                     
                     if .flags.mimetizado = 1 then
                         .charmimetizado.shieldanim = obj.shieldanim
                     else
                         .char.shieldanim = obj.shieldanim
                         
                         call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                     end if
                 else
                     call writeconsolemsg(userindex, smotivo, fonttypenames.fonttype_info)
                 end if
                 
            case eobjtype.otmochilas
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
                    exit sub
                end if
                if .invent.object(slot).equipped then
                    call desequipar(userindex, slot)
                    exit sub
                end if
                if .invent.mochilaeqpobjindex > 0 then
                    call desequipar(userindex, .invent.mochilaeqpslot)
                end if
                .invent.object(slot).equipped = 1
                .invent.mochilaeqpobjindex = objindex
                .invent.mochilaeqpslot = slot
                .currentinventoryslots = max_normal_inventory_slots + obj.mochilatype * 5
                call writeaddslots(userindex, obj.mochilatype)
        end select
    end with
    
    'actualiza
    call updateuserinv(false, userindex, slot)
    
    exit sub
    
errhandler:
    call logerror("equiparinvitem slot:" & slot & " - error: " & err.number & " - error description : " & err.description)
end sub

private function checkrazausaropa(byval userindex as integer, itemindex as integer, optional byref smotivo as string) as boolean
'***************************************************
'author: unknown
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - agrego el motivo por el que no puede equipar/usar el item.
'***************************************************

on error goto errhandler

    with userlist(userindex)
        'verifica si la raza puede usar la ropa
        if .raza = eraza.humano or _
           .raza = eraza.elfo or _
           .raza = eraza.drow then
                checkrazausaropa = (objdata(itemindex).razaenana = 0)
        else
                checkrazausaropa = (objdata(itemindex).razaenana = 1)
        end if
        
        'solo se habilita la ropa exclusiva para drows por ahora. pablo (toxicwaste)
        if (.raza <> eraza.drow) and objdata(itemindex).razadrow then
            checkrazausaropa = false
        end if
    end with
    
    if not checkrazausaropa then smotivo = "tu raza no puede usar este objeto."
    
    exit function
    
errhandler:
    call logerror("error checkrazausaropa itemindex:" & itemindex)

end function

sub useinvitem(byval userindex as integer, byval slot as byte)
'*************************************************
'author: unknown
'last modified: 10/12/2009
'handels the usage of items from inventory box.
'24/01/2007 pablo (toxicwaste) - agrego el cuerno de la armada y la legi�n.
'24/01/2007 pablo (toxicwaste) - utilizaci�n nueva de barco en lvl 20 por clase pirata y pescador.
'01/08/2009: zama - now it's not sent any sound made by an invisible admin, except to its own client
'17/11/2009: zama - ahora se envia una orientacion de la posicion hacia donde esta el que uso el cuerno.
'27/11/2009: budi - se envia indivualmente cuando se modifica a la agilidad o la fuerza del personaje.
'08/12/2009: zama - agrego el uso de hacha de madera elfica.
'10/12/2009: zama - arreglos y validaciones en todos las herramientas de trabajo.
'*************************************************

    dim obj as objdata
    dim objindex as integer
    dim targobj as objdata
    dim miobj as obj
    
    with userlist(userindex)
    
        if .invent.object(slot).amount = 0 then exit sub
        
        obj = objdata(.invent.object(slot).objindex)
        
        if obj.newbie = 1 and not esnewbie(userindex) then
            call writeconsolemsg(userindex, "s�lo los newbies pueden usar estos objetos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if obj.objtype = eobjtype.otweapon then
            if obj.proyectil = 1 then
                
                'valido para evitar el flood pero no bloqueo. el bloqueo se hace en wlc con proyectiles.
                if not intervalopermiteusar(userindex, false) then exit sub
            else
                'dagas
                if not intervalopermiteusar(userindex) then exit sub
            end if
        else
            if not intervalopermiteusar(userindex) then exit sub
        end if
        
        objindex = .invent.object(slot).objindex
        .flags.targetobjinvindex = objindex
        .flags.targetobjinvslot = slot
        
        select case obj.objtype
            case eobjtype.otuseonce
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
        
                'usa el item
                .stats.minham = .stats.minham + obj.minham
                if .stats.minham > .stats.maxham then _
                    .stats.minham = .stats.maxham
                .flags.hambre = 0
                call writeupdatehungerandthirst(userindex)
                'sonido
                
                if objindex = e_objetoscriticos.manzana or objindex = e_objetoscriticos.manzana2 or objindex = e_objetoscriticos.manzananewbie then
                    call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.morfar_manzana)
                else
                    call sonidosmapas.reproducirsonido(sendtarget.topcarea, userindex, e_soundindex.sound_comida)
                end if
                
                'quitamos del inv el item
                call quitaruserinvitem(userindex, slot, 1)
                
                call updateuserinv(false, userindex, slot)
        
            case eobjtype.otguita
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                .stats.gld = .stats.gld + .invent.object(slot).amount
                .invent.object(slot).amount = 0
                .invent.object(slot).objindex = 0
                .invent.nroitems = .invent.nroitems - 1
                
                call updateuserinv(false, userindex, slot)
                call writeupdategold(userindex)
                
            case eobjtype.otweapon
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if not .stats.minsta > 0 then
                    call writeconsolemsg(userindex, "est�s muy cansad" & _
                                iif(.genero = egenero.hombre, "o", "a") & ".", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if objdata(objindex).proyectil = 1 then
                    if .invent.object(slot).equipped = 0 then
                        call writeconsolemsg(userindex, "antes de usar la herramienta deber�as equipartela.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    call writemultimessage(userindex, emessages.workrequesttarget, eskill.proyectiles)  'call writeworkrequesttarget(userindex, proyectiles)
                elseif .flags.targetobj = le�a then
                    if .invent.object(slot).objindex = daga then
                        if .invent.object(slot).equipped = 0 then
                            call writeconsolemsg(userindex, "antes de usar la herramienta deber�as equipartela.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                            
                        call tratardehacerfogata(.flags.targetobjmap, _
                            .flags.targetobjx, .flags.targetobjy, userindex)
                    end if
                else
                
                    select case objindex
                        case ca�a_pesca, red_pesca
                            if .invent.weaponeqpobjindex = ca�a_pesca or .invent.weaponeqpobjindex = red_pesca then
                                call writemultimessage(userindex, emessages.workrequesttarget, eskill.pesca)  'call writeworkrequesttarget(userindex, eskill.pesca)
                            else
                                 call writeconsolemsg(userindex, "debes tener equipada la herramienta para trabajar.", fonttypenames.fonttype_info)
                            end if
                            
                        case hacha_le�ador, hacha_le�a_elfica
                            if .invent.weaponeqpobjindex = hacha_le�ador or .invent.weaponeqpobjindex = hacha_le�a_elfica then
                                call writemultimessage(userindex, emessages.workrequesttarget, eskill.talar)
                            else
                                call writeconsolemsg(userindex, "debes tener equipada la herramienta para trabajar.", fonttypenames.fonttype_info)
                            end if
                            
                        case piquete_minero
                            if .invent.weaponeqpobjindex = piquete_minero then
                                call writemultimessage(userindex, emessages.workrequesttarget, eskill.mineria)
                            else
                                call writeconsolemsg(userindex, "debes tener equipada la herramienta para trabajar.", fonttypenames.fonttype_info)
                            end if
                            
                        case martillo_herrero
                            if .invent.weaponeqpobjindex = martillo_herrero then
                                call writemultimessage(userindex, emessages.workrequesttarget, eskill.herreria)
                            else
                                call writeconsolemsg(userindex, "debes tener equipada la herramienta para trabajar.", fonttypenames.fonttype_info)
                            end if
                            
                        case serrucho_carpintero
                            if .invent.weaponeqpobjindex = serrucho_carpintero then
                                call enivarobjconstruibles(userindex)
                                call writeshowcarpenterform(userindex)
                            else
                                call writeconsolemsg(userindex, "debes tener equipada la herramienta para trabajar.", fonttypenames.fonttype_info)
                            end if
                            
                        case else ' las herramientas no se pueden fundir
                            if objdata(objindex).skherreria > 0 then
                                ' solo objetos que pueda hacer el herrero
                                call writemultimessage(userindex, emessages.workrequesttarget, fundirmetal) 'call writeworkrequesttarget(userindex, fundirmetal)
                            end if
                    end select
                end if
            
            case eobjtype.otpociones
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo. ", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if not intervalopermitegolpeusar(userindex, false) then
                    call writeconsolemsg(userindex, "��debes esperar unos momentos para tomar otra poci�n!!", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                .flags.tomopocion = true
                .flags.tipopocion = obj.tipopocion
                        
                select case .flags.tipopocion
                
                    case 1 'modif la agilidad
                        .flags.duracionefecto = obj.duracionefecto
                
                        'usa el item
                        .stats.useratributos(eatributos.agilidad) = .stats.useratributos(eatributos.agilidad) + randomnumber(obj.minmodificador, obj.maxmodificador)
                        if .stats.useratributos(eatributos.agilidad) > maxatributos then _
                            .stats.useratributos(eatributos.agilidad) = maxatributos
                        if .stats.useratributos(eatributos.agilidad) > 2 * .stats.useratributosbackup(agilidad) then .stats.useratributos(eatributos.agilidad) = 2 * .stats.useratributosbackup(agilidad)
                        
                        'quitamos del inv el item
                        call quitaruserinvitem(userindex, slot, 1)
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        else
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        end if
                        call writeupdatedexterity(userindex)
                        
                    case 2 'modif la fuerza
                        .flags.duracionefecto = obj.duracionefecto
                
                        'usa el item
                        .stats.useratributos(eatributos.fuerza) = .stats.useratributos(eatributos.fuerza) + randomnumber(obj.minmodificador, obj.maxmodificador)
                        if .stats.useratributos(eatributos.fuerza) > maxatributos then _
                            .stats.useratributos(eatributos.fuerza) = maxatributos
                        if .stats.useratributos(eatributos.fuerza) > 2 * .stats.useratributosbackup(fuerza) then .stats.useratributos(eatributos.fuerza) = 2 * .stats.useratributosbackup(fuerza)
                        
                        
                        'quitamos del inv el item
                        call quitaruserinvitem(userindex, slot, 1)
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        else
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        end if
                        call writeupdatestrenght(userindex)
                        
                    case 3 'pocion roja, restaura hp
                        'usa el item
                        .stats.minhp = .stats.minhp + randomnumber(obj.minmodificador, obj.maxmodificador)
                        if .stats.minhp > .stats.maxhp then _
                            .stats.minhp = .stats.maxhp
                        
                        'quitamos del inv el item
                        call quitaruserinvitem(userindex, slot, 1)
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        else
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        end if
                    
                    case 4 'pocion azul, restaura mana
                        'usa el item
                        'nuevo calculo para recargar mana
                        .stats.minman = .stats.minman + porcentaje(.stats.maxman, 4) + .stats.elv \ 2 + 40 / .stats.elv
                        if .stats.minman > .stats.maxman then _
                            .stats.minman = .stats.maxman
                        
                        'quitamos del inv el item
                        call quitaruserinvitem(userindex, slot, 1)
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        else
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        end if
                        
                    case 5 ' pocion violeta
                        if .flags.envenenado = 1 then
                            .flags.envenenado = 0
                            call writeconsolemsg(userindex, "te has curado del envenenamiento.", fonttypenames.fonttype_info)
                        end if
                        'quitamos del inv el item
                        call quitaruserinvitem(userindex, slot, 1)
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        else
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                        end if
                        
                    case 6  ' pocion negra
                        if .flags.privilegios and playertype.user then
                            call quitaruserinvitem(userindex, slot, 1)
                            call userdie(userindex)
                            call writeconsolemsg(userindex, "sientes un gran mareo y pierdes el conocimiento.", fonttypenames.fonttype_fight)
                        end if
               end select
               call writeupdateuserstats(userindex)
               call updateuserinv(false, userindex, slot)
        
             case eobjtype.otbebidas
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                .stats.minagu = .stats.minagu + obj.minsed
                if .stats.minagu > .stats.maxagu then _
                    .stats.minagu = .stats.maxagu
                .flags.sed = 0
                call writeupdatehungerandthirst(userindex)
                
                'quitamos del inv el item
                call quitaruserinvitem(userindex, slot, 1)
                
                ' los admin invisibles solo producen sonidos a si mismos
                if .flags.admininvisible = 1 then
                    call enviardatosaslot(userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                else
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_beber, .pos.x, .pos.y))
                end if
                
                call updateuserinv(false, userindex, slot)
            
            case eobjtype.otllaves
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if .flags.targetobj = 0 then exit sub
                targobj = objdata(.flags.targetobj)
                '�el objeto clickeado es una puerta?
                if targobj.objtype = eobjtype.otpuertas then
                    '�esta cerrada?
                    if targobj.cerrada = 1 then
                          '�cerrada con llave?
                          if targobj.llave > 0 then
                             if targobj.clave = obj.clave then
                 
                                mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex _
                                = objdata(mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex).indexcerrada
                                .flags.targetobj = mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex
                                call writeconsolemsg(userindex, "has abierto la puerta.", fonttypenames.fonttype_info)
                                exit sub
                             else
                                call writeconsolemsg(userindex, "la llave no sirve.", fonttypenames.fonttype_info)
                                exit sub
                             end if
                          else
                             if targobj.clave = obj.clave then
                                mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex _
                                = objdata(mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex).indexcerradallave
                                call writeconsolemsg(userindex, "has cerrado con llave la puerta.", fonttypenames.fonttype_info)
                                .flags.targetobj = mapdata(.flags.targetobjmap, .flags.targetobjx, .flags.targetobjy).objinfo.objindex
                                exit sub
                             else
                                call writeconsolemsg(userindex, "la llave no sirve.", fonttypenames.fonttype_info)
                                exit sub
                             end if
                          end if
                    else
                          call writeconsolemsg(userindex, "no est� cerrada.", fonttypenames.fonttype_info)
                          exit sub
                    end if
                end if
            
            case eobjtype.otbotellavacia
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                if not hayagua(.pos.map, .flags.targetx, .flags.targety) then
                    call writeconsolemsg(userindex, "no hay agua all�.", fonttypenames.fonttype_info)
                    exit sub
                end if
                miobj.amount = 1
                miobj.objindex = objdata(.invent.object(slot).objindex).indexabierta
                call quitaruserinvitem(userindex, slot, 1)
                if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(.pos, miobj)
                end if
                
                call updateuserinv(false, userindex, slot)
            
            case eobjtype.otbotellallena
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                .stats.minagu = .stats.minagu + obj.minsed
                if .stats.minagu > .stats.maxagu then _
                    .stats.minagu = .stats.maxagu
                .flags.sed = 0
                call writeupdatehungerandthirst(userindex)
                miobj.amount = 1
                miobj.objindex = objdata(.invent.object(slot).objindex).indexcerrada
                call quitaruserinvitem(userindex, slot, 1)
                if not meteritemeninventario(userindex, miobj) then
                    call tiraritemalpiso(.pos, miobj)
                end if
                
                call updateuserinv(false, userindex, slot)
            
            case eobjtype.otpergaminos
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if .stats.maxman > 0 then
                    if .flags.hambre = 0 and _
                        .flags.sed = 0 then
                        call agregarhechizo(userindex, slot)
                        call updateuserinv(false, userindex, slot)
                    else
                        call writeconsolemsg(userindex, "est�s demasiado hambriento y sediento.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "no tienes conocimientos de las artes arcanas.", fonttypenames.fonttype_info)
                end if
            case eobjtype.otminerales
                if .flags.muerto = 1 then
                     call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                     exit sub
                end if
                call writemultimessage(userindex, emessages.workrequesttarget, fundirmetal) 'call writeworkrequesttarget(userindex, fundirmetal)
               
            case eobjtype.otinstrumentos
                if .flags.muerto = 1 then
                    call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if obj.real then '�es el cuerno real?
                    if faccionpuedeusaritem(userindex, objindex) then
                        if mapinfo(.pos.map).pk = false then
                            call writeconsolemsg(userindex, "no hay peligro aqu�. es zona segura.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                        else
                            call alertarfaccionarios(userindex)
                            call senddata(sendtarget.tomap, .pos.map, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                        end if
                        
                        exit sub
                    else
                        call writeconsolemsg(userindex, "s�lo miembros del ej�rcito real pueden usar este cuerno.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                elseif obj.caos then '�es el cuerno legi�n?
                    if faccionpuedeusaritem(userindex, objindex) then
                        if mapinfo(.pos.map).pk = false then
                            call writeconsolemsg(userindex, "no hay peligro aqu�. es zona segura.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                        
                        ' los admin invisibles solo producen sonidos a si mismos
                        if .flags.admininvisible = 1 then
                            call enviardatosaslot(userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                        else
                            call alertarfaccionarios(userindex)
                            call senddata(sendtarget.tomap, .pos.map, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                        end if
                        
                        exit sub
                    else
                        call writeconsolemsg(userindex, "s�lo miembros de la legi�n oscura pueden usar este cuerno.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                end if
                'si llega aca es porque es o laud o tambor o flauta
                ' los admin invisibles solo producen sonidos a si mismos
                if .flags.admininvisible = 1 then
                    call enviardatosaslot(userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                else
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                end if
               
            case eobjtype.otbarcos
                'verifica si esta aproximado al agua antes de permitirle navegar
                if .stats.elv < 25 then
                    if .clase <> eclass.worker and .clase <> eclass.pirat then
                        call writeconsolemsg(userindex, "para recorrer los mares debes ser nivel 25 o superior.", fonttypenames.fonttype_info)
                        exit sub
                    else
                        if .stats.elv < 20 then
                            call writeconsolemsg(userindex, "para recorrer los mares debes ser nivel 20 o superior.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                    end if
                end if
                
                if ((legalpos(.pos.map, .pos.x - 1, .pos.y, true, false) _
                        or legalpos(.pos.map, .pos.x, .pos.y - 1, true, false) _
                        or legalpos(.pos.map, .pos.x + 1, .pos.y, true, false) _
                        or legalpos(.pos.map, .pos.x, .pos.y + 1, true, false)) _
                        and .flags.navegando = 0) _
                        or .flags.navegando = 1 then
                    call donavega(userindex, obj, slot)
                else
                    call writeconsolemsg(userindex, "�debes aproximarte al agua para usar el barco!", fonttypenames.fonttype_info)
                end if
                
        end select
    
    end with

end sub

sub enivararmasconstruibles(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    call writeblacksmithweapons(userindex)
end sub
 
sub enivarobjconstruibles(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    call writecarpenterobjects(userindex)
end sub

sub enivararmadurasconstruibles(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    call writeblacksmitharmors(userindex)
end sub

sub tirartodo(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

    with userlist(userindex)
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = 6 then exit sub
        
        call tirartodoslositems(userindex)
        
        dim cantidad as long
        cantidad = .stats.gld - clng(.stats.elv) * 10000
        
        if cantidad > 0 then _
            call tiraroro(cantidad, userindex)
    end with

end sub

public function itemsecae(byval index as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with objdata(index)
        itemsecae = (.real <> 1 or .nosecae = 0) and _
                    (.caos <> 1 or .nosecae = 0) and _
                    .objtype <> eobjtype.otllaves and _
                    .objtype <> eobjtype.otbarcos and _
                    .nosecae = 0
    end with

end function

sub tirartodoslositems(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/2010 (zama)
'12/01/2010: zama - ahora los piratas no explotan items solo si estan entre 20 y 25
'***************************************************

    dim i as byte
    dim nuevapos as worldpos
    dim miobj as obj
    dim itemindex as integer
    dim dropagua as boolean
    
    with userlist(userindex)
        for i = 1 to .currentinventoryslots
            itemindex = .invent.object(i).objindex
            if itemindex > 0 then
                 if itemsecae(itemindex) then
                    nuevapos.x = 0
                    nuevapos.y = 0
                    
                    'creo el obj
                    miobj.amount = .invent.object(i).amount
                    miobj.objindex = itemindex

                    dropagua = true
                    ' es pirata?
                    if .clase = eclass.pirat then
                        ' si tiene galeon equipado
                        if .invent.barcoobjindex = 476 then
                            ' limitaci�n por nivel, despu�s dropea normalmente
                            if .stats.elv >= 20 and .stats.elv <= 25 then
                                ' no dropea en agua
                                dropagua = false
                            end if
                        end if
                    end if
                    
                    call tilelibre(.pos, nuevapos, miobj, dropagua, true)
                    
                    if nuevapos.x <> 0 and nuevapos.y <> 0 then
                        call dropobj(userindex, i, max_inventory_objs, nuevapos.map, nuevapos.x, nuevapos.y)
                    end if
                 end if
            end if
        next i
    end with
end sub

function itemnewbie(byval itemindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if itemindex < 1 or itemindex > ubound(objdata) then exit function
    
    itemnewbie = objdata(itemindex).newbie = 1
end function

sub tirartodoslositemsnonewbies(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 23/11/2009
'07/11/09: pato - fix bug #2819911
'23/11/2009: zama - optimizacion de codigo.
'***************************************************
    dim i as byte
    dim nuevapos as worldpos
    dim miobj as obj
    dim itemindex as integer
    
    with userlist(userindex)
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = 6 then exit sub
        
        for i = 1 to userlist(userindex).currentinventoryslots
            itemindex = .invent.object(i).objindex
            if itemindex > 0 then
                if itemsecae(itemindex) and not itemnewbie(itemindex) then
                    nuevapos.x = 0
                    nuevapos.y = 0
                    
                    'creo miobj
                    miobj.amount = .invent.object(i).amount
                    miobj.objindex = itemindex
                    'pablo (toxicwaste) 24/01/2007
                    'tira los items no newbies en todos lados.
                    tilelibre .pos, nuevapos, miobj, true, true
                    if nuevapos.x <> 0 and nuevapos.y <> 0 then
                        call dropobj(userindex, i, max_inventory_objs, nuevapos.map, nuevapos.x, nuevapos.y)
                    end if
                end if
            end if
        next i
    end with

end sub

sub tirartodoslositemsenmochila(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 12/01/09 (budi)
'***************************************************
    dim i as byte
    dim nuevapos as worldpos
    dim miobj as obj
    dim itemindex as integer
    
    with userlist(userindex)
        if mapdata(.pos.map, .pos.x, .pos.y).trigger = 6 then exit sub
        
        for i = max_normal_inventory_slots + 1 to .currentinventoryslots
            itemindex = .invent.object(i).objindex
            if itemindex > 0 then
                if itemsecae(itemindex) then
                    nuevapos.x = 0
                    nuevapos.y = 0
                    
                    'creo miobj
                    miobj.amount = .invent.object(i).amount
                    miobj.objindex = itemindex
                    tilelibre .pos, nuevapos, miobj, true, true
                    if nuevapos.x <> 0 and nuevapos.y <> 0 then
                        call dropobj(userindex, i, max_inventory_objs, nuevapos.map, nuevapos.x, nuevapos.y)
                    end if
                end if
            end if
        next i
    end with

end sub

public function getobjtype(byval objindex as integer) as eobjtype
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if objindex > 0 then
        getobjtype = objdata(objindex).objtype
    end if
    
end function
