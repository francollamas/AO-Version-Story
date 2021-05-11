attribute vb_name = "comercio"
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
public const reductor_precioventa = 3

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%          modulo de comercio npc-user              %%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function usercompraobj(byval userindex as integer, byval objindex as integer, byval npcindex as integer, byval cantidad as integer) as boolean
on error goto errorh
    dim descuento as string
    dim unidad as long, monto as long
    dim slot as integer
    dim obji as integer
    dim encontre as boolean
    
    usercompraobj = false
    
    
    
    if (npclist(userlist(userindex).flags.targetnpc).invent.object(objindex).amount <= 0) then exit function
    
    obji = npclist(userlist(userindex).flags.targetnpc).invent.object(objindex).objindex
    
    
    '�ya tiene un objeto de este tipo?
    slot = 1
    do until userlist(userindex).invent.object(slot).objindex = obji and _
       userlist(userindex).invent.object(slot).amount + cantidad <= max_inventory_objs
        
        slot = slot + 1
        if slot > max_inventory_slots then
            exit do
        end if
    loop
    
    'sino se fija por un slot vacio
    if slot > max_inventory_slots then
        slot = 1
        do until userlist(userindex).invent.object(slot).objindex = 0
            slot = slot + 1
            
            if slot > max_inventory_slots then
                call writeconsolemsg(userindex, "no pod�s tener mas objetos.", fonttypenames.fonttype_info)
                exit function
            end if
        loop
        userlist(userindex).invent.nroitems = userlist(userindex).invent.nroitems + 1
    end if
    
    'desde aca para abajo se realiza la transaccion
    usercompraobj = true
    'mete el obj en el slot
    if userlist(userindex).invent.object(slot).amount + cantidad <= max_inventory_objs then
        'menor que max_inv_objs
        userlist(userindex).invent.object(slot).objindex = obji
        userlist(userindex).invent.object(slot).amount = userlist(userindex).invent.object(slot).amount + cantidad
        
        'le sustraemos el valor en oro del obj comprado
        descuento = userlist(userindex).flags.descuento
        if descuento = 0 then descuento = 1 'evitamos dividir por 0!
        unidad = ((objdata(npclist(npcindex).invent.object(objindex).objindex).valor) / descuento)
        monto = unidad * cantidad
        userlist(userindex).stats.gld = userlist(userindex).stats.gld - monto
        
        'tal vez suba el skill comerciar ;-)
        call subirskill(userindex, comerciar)
        
        if objdata(obji).objtype = eobjtype.otllaves then call logventacasa(userlist(userindex).name & " compro " & objdata(obji).name)
        
        call quitarnpcinvitem(userlist(userindex).flags.targetnpc, cbyte(objindex), cantidad)
    else
        call writeconsolemsg(userindex, "no pod�s tener mas objetos.", fonttypenames.fonttype_info)
    end if
exit function

errorh:
call logerror("error en usercompraobj. " & err.description)
end function


sub npccompraobj(byval userindex as integer, byval objindex as integer, byval cantidad as integer)
on error goto errorh
    dim slot as integer
    dim obji as integer
    dim npcindex as integer
    dim infla as long
    dim monto as long
          
    if cantidad < 1 then exit sub
    
    npcindex = userlist(userindex).flags.targetnpc
    obji = userlist(userindex).invent.object(objindex).objindex
    
    if objdata(obji).newbie = 1 then
        call writeconsolemsg(userindex, "no comercio objetos para newbies.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if npclist(npcindex).tipoitems <> eobjtype.otcualquiera then
        '�son los items con los que comercia el npc?
        if npclist(npcindex).tipoitems <> objdata(obji).objtype then
            call writeconsolemsg(userindex, "el npc no esta interesado en comprar ese objeto.", fonttypenames.fonttype_warning)
            exit sub
        end if
    end if
    
    if obji = ioro then
        call writeconsolemsg(userindex, "el npc no esta interesado en comprar ese objeto.", fonttypenames.fonttype_warning)
        exit sub
    end if
    
    '�ya tiene un objeto de este tipo?
    slot = 1
    do until (npclist(npcindex).invent.object(slot).objindex = obji _
      and npclist(npcindex).invent.object(slot).amount + cantidad <= max_inventory_objs)
        
        slot = slot + 1
        
        if slot > max_inventory_slots then exit do
    loop
    
    'sino se fija por un slot vacio antes del slot devuelto
    if slot > max_inventory_slots then
        slot = 1
        do until npclist(npcindex).invent.object(slot).objindex = 0
            slot = slot + 1
            if slot > max_inventory_slots then exit do
        loop
        if slot <= max_inventory_slots then npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems + 1
    end if
    
    if slot <= max_inventory_slots then 'slot valido
        'mete el obj en el slot
        npclist(npcindex).invent.object(slot).objindex = obji
        if npclist(npcindex).invent.object(slot).amount + cantidad <= max_inventory_objs then
            'menor que max_inv_objs
            npclist(npcindex).invent.object(slot).amount = npclist(npcindex).invent.object(slot).amount + cantidad
        else
            npclist(npcindex).invent.object(slot).amount = max_inventory_objs
        end if
    end if
    
    call quitaruserinvitem(userindex, cbyte(objindex), cantidad)
    'le sumamos al user el valor en oro del obj vendido
    monto = ((objdata(obji).valor \ 3) * cantidad)
    userlist(userindex).stats.gld = userlist(userindex).stats.gld + monto
    if userlist(userindex).stats.gld > maxoro then _
        userlist(userindex).stats.gld = maxoro
    
    'tal vez suba el skill comerciar ;-)
    call subirskill(userindex, comerciar)
exit sub

errorh:
    call logerror("error en npccompraobj. " & err.description)
end sub

sub iniciarcomercionpc(byval userindex as integer)
on error goto errhandler
    'mandamos el inventario
    call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
    'hacemos un update del inventario del usuario
    call updateuserinv(true, userindex, 0)
    'atcualizamos el dinero
    call writeupdateuserstats(userindex)
    'mostramos la ventana pa' comerciar y ver ladear la osamenta. jajaja
    userlist(userindex).flags.comerciando = true
    call writecommerceinit(userindex)
exit sub

errhandler:
    dim str as string
    str = "error en iniciarcomercionpc. ui=" & userindex
    if userindex > 0 then
        str = str & ".nombre: " & userlist(userindex).name & " ip:" & userlist(userindex).ip & " comerciando con "
        if userlist(userindex).flags.targetnpc > 0 then
            str = str & npclist(userlist(userindex).flags.targetnpc).name
        else
            str = str & "<npcindex 0>"
        end if
    else
        str = str & "<userindex 0>"
    end if
end sub

sub npcventaitem(byval userindex as integer, byval i as byte, byval cantidad as integer, byval npcindex as integer)
'listindex+1, cantidad
on error goto errhandler

    dim val as long
    dim desc as string
    
    if cantidad < 1 then exit sub
    
    'defensive programming
    if i < lbound(npclist(npcindex).invent.object()) or i > ubound(npclist(npcindex).invent.object()) then
        'actualizamos el inventario del usuario
        call updateuserinv(true, userindex, 0)
        'actualizamos la ventana de comercio
        call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
        call updateventanacomercio(userindex)
        exit sub
    end if
    
    'defensive programming
    if npclist(npcindex).invent.object(i).objindex = 0 then
        'actualizamos el inventario del usuario
        call updateuserinv(true, userindex, 0)
        'actualizamos la ventana de comercio
        call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
        call updateventanacomercio(userindex)
        exit sub
    end if
    
    'npc vende un obj a un usuario
    call writeupdateuserstats(userindex)
    
    if i > max_inventory_slots then
        call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("posible intento de romper el sistema de comercio. usuario: " & userlist(userindex).name, fonttypenames.fonttype_warning))
        exit sub
    end if
    
    if cantidad > max_inventory_objs then
        call senddata(sendtarget.toall, 0, preparemessageconsolemsg(userlist(userindex).name & " ha sido baneado por el sistema anti-cheats.", fonttypenames.fonttype_fight))
        call ban(userlist(userindex).name, "sistema anti cheats", "intentar hackear el sistema de comercio " & cantidad)
        userlist(userindex).flags.ban = 1
        call writeerrormsg(userindex, "has sido baneado por el sistema anti cheats")
        call flushbuffer(userindex)
        call closesocket(userindex)
        exit sub
    end if
    
    'calculamos el valor unitario
    desc = descuento(userindex)
    if desc = 0 then desc = 1 'evitamos dividir por 0!
    val = (objdata(npclist(npcindex).invent.object(i).objindex).valor) / desc
    
    if val = 0 then val = 1 'evita que un objeto valga 0
    
    if userlist(userindex).stats.gld >= (val * cantidad) then
        if npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount > 0 then
            if cantidad > npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount then
                cantidad = npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount
            end if
            
            'agregamos el obj que compro al inventario
            if not usercompraobj(userindex, cint(i), userlist(userindex).flags.targetnpc, cantidad) then
                call writeconsolemsg(userindex, "no puedes comprar este �tem.", fonttypenames.fonttype_info)
            end if
            
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el oro
            call writeupdateuserstats(userindex)
            'actualizamos la ventana de comercio
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            call updateventanacomercio(userindex)
        end if
    else
        call writeconsolemsg(userindex, "no tenes suficiente dinero.", fonttypenames.fonttype_info)
    end if
exit sub

errhandler:
    call logerror("error en comprar item: " & err.description)
end sub

sub npccompraitem(byval userindex as integer, byval item as byte, byval cantidad as integer)
on error goto errhandler
    dim npcindex as integer
    
    'defensive programing
    if item < lbound(userlist(userindex).invent.object()) or item > ubound(userlist(userindex).invent.object()) then
        'actualizamos la ventana de comercio
        call updateventanacomercio(userindex)
        call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
        exit sub
    end if
    
    'defensive programing
    if userlist(userindex).invent.object(item).objindex = 0 then
        'actualizamos la ventana de comercio
        call updateventanacomercio(userindex)
        call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
        exit sub
    end if
    
    npcindex = userlist(userindex).flags.targetnpc
    
    'si es una armadura faccionaria vemos que la est� intentando vender al sastre
    if objdata(userlist(userindex).invent.object(item).objindex).real = 1 then
        if npclist(npcindex).name <> "sr" then
            call writeconsolemsg(userindex, "las armaduras faccionarias s�lo las puedes vender a sus respectivos sastres", fonttypenames.fonttype_warning)
            
            'actualizamos la ventana de comercio
            call updateventanacomercio(userindex)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            exit sub
        end if
    elseif objdata(userlist(userindex).invent.object(item).objindex).caos = 1 then
        if npclist(npcindex).name <> "sc" then
            call writeconsolemsg(userindex, "las armaduras faccionarias s�lo las puedes vender a sus respectivos sastres", fonttypenames.fonttype_warning)
            
            'actualizamos la ventana de comercio
            call updateventanacomercio(userindex)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            exit sub
        end if
    elseif userlist(userindex).flags.privilegios and playertype.consejero then
        call writeconsolemsg(userindex, "no puedes vender items.", fonttypenames.fonttype_warning)
        exit sub
    end if
    
    'npc compra un obj a un usuario
    call writeupdateuserstats(userindex)
   
    if userlist(userindex).invent.object(item).amount > 0 and userlist(userindex).invent.object(item).equipped = 0 then
        if cantidad > userlist(userindex).invent.object(item).amount then
            cantidad = userlist(userindex).invent.object(item).amount
        end if
        
        if cantidad > 0 then
            'agregamos el obj que compro al inventario
            call npccompraobj(userindex, item, cantidad)
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el oro
            call writeupdateuserstats(userindex)
        end if
        
        call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
        'actualizamos la ventana de comercio
        call updateventanacomercio(userindex)
    end if
exit sub

errhandler:
    call logerror("error en vender item: " & err.description)
end sub

sub updateventanacomercio(byval userindex as integer)
    call writetradeok(userindex)
end sub

function descuento(byval userindex as integer) as single
    'calcula el descuento al comerciar
    descuento = 1 + userlist(userindex).stats.userskills(eskill.comerciar) / 100
    userlist(userindex).flags.descuento = descuento
end function

sub enviarnpcinv(byval userindex as integer, byval npcindex as integer)
    'enviamos el inventario del npc con el cual el user va a comerciar...
    dim i as integer
    dim desc as string
    dim val as long

    desc = descuento(userindex)
    if desc = 0 then desc = 1 'evitamos dividir por 0!
    
    for i = 1 to max_inventory_slots
        if npclist(npcindex).invent.object(i).objindex > 0 then
            dim thisobj as obj
            thisobj.objindex = npclist(npcindex).invent.object(i).objindex
            thisobj.amount = npclist(npcindex).invent.object(i).amount
            'calculamos el porc de inflacion del npc
            val = (objdata(npclist(npcindex).invent.object(i).objindex).valor) / desc
            
            call writechangenpcinventoryslot(userindex, thisobj, val)
        else
             dim dummyobj as obj
             call writechangenpcinventoryslot(userindex, dummyobj, 0)
        end if
    next i
end sub
