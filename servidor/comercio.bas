attribute vb_name = "modsistemacomercio"
'*****************************************************
'sistema de comercio para argentum online
'programado por nacho (integer)
'integer-x@hotmail.com
'*****************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'(at your option) any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

option explicit

enum emodocomercio
    compra = 1
    venta = 2
end enum

public const reductor_precioventa as byte = 3

''
' makes a trade. (buy or sell)
'
' @param modo the trade type (sell or buy)
' @param userindex specifies the index of the user
' @param npcindex specifies the index of the npc
' @param slot specifies which slot are you trying to sell / buy
' @param cantidad specifies how many items in that slot are you trying to sell / buy
public sub comercio(byval modo as emodocomercio, byval userindex as integer, byval npcindex as integer, byval slot as integer, byval cantidad as integer)
'*************************************************
'author: nacho (integer)
'last modified: 27/07/08 (markoxx) | new changes in the way of trading (now when you buy it rounds to ceil and when you sell it rounds to floor)
'  - 06/13/08 (niconz)
'*************************************************
    dim precio as long
    dim objeto as obj
    
    if cantidad < 1 or slot < 1 then exit sub
    
    if modo = emodocomercio.compra then
        if slot > max_inventory_slots then
            exit sub
        elseif cantidad > max_inventory_objs then
            call senddata(sendtarget.toall, 0, preparemessageconsolemsg(userlist(userindex).name & " ha sido baneado por el sistema anti-cheats.", fonttypenames.fonttype_fight))
            call ban(userlist(userindex).name, "sistema anti cheats", "intentar hackear el sistema de comercio. quiso comprar demasiados �tems:" & cantidad)
            userlist(userindex).flags.ban = 1
            call writeerrormsg(userindex, "has sido baneado por el sistema anticheat.")
            call flushbuffer(userindex)
            call closesocket(userindex)
            exit sub
        elseif not npclist(npcindex).invent.object(slot).amount > 0 then
            exit sub
        end if
        
        if cantidad > npclist(npcindex).invent.object(slot).amount then cantidad = npclist(userlist(userindex).flags.targetnpc).invent.object(slot).amount
        
        objeto.amount = cantidad
        objeto.objindex = npclist(npcindex).invent.object(slot).objindex
        
        'el precio, cuando nos venden algo, lo tenemos que redondear para arriba.
        'es decir, 1.1 = 2, por lo cual se hace de la siguiente forma precio = clng(preciofinal + 0.5) siempre va a darte el proximo numero. o el "techo" (markoxx)
        
        precio = clng((objdata(npclist(npcindex).invent.object(slot).objindex).valor / descuento(userindex) * cantidad) + 0.5)

        if userlist(userindex).stats.gld < precio then
            call writeconsolemsg(userindex, "no tienes suficiente dinero.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        
        if meteritemeninventario(userindex, objeto) = false then
            'call writeconsolemsg(userindex, "no puedes cargar mas objetos.", fonttypenames.fonttype_info)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            call writetradeok(userindex)
            exit sub
        end if
        
        userlist(userindex).stats.gld = userlist(userindex).stats.gld - precio
        
        call quitarnpcinvitem(userlist(userindex).flags.targetnpc, cbyte(slot), cantidad)
        
        'bien, ahora logueo de ser necesario. pablo (toxicwaste) 07/09/07
        'es un objeto que tenemos que loguear?
        if objdata(objeto.objindex).log = 1 then
            call logdesarrollo(userlist(userindex).name & " compr� del npc " & objeto.amount & " " & objdata(objeto.objindex).name)
        elseif objeto.amount = 1000 then 'es mucha cantidad?
            'si no es de los prohibidos de loguear, lo logueamos.
            if objdata(objeto.objindex).nolog <> 1 then
                call logdesarrollo(userlist(userindex).name & " compr� del npc " & objeto.amount & " " & objdata(objeto.objindex).name)
            end if
        end if
        
        'agregado para que no se vuelvan a vender las llaves si se recargan los .dat.
        if objdata(objeto.objindex).objtype = otllaves then
            call writevar(datpath & "npcs.dat", "npc" & npclist(npcindex).numero, "obj" & slot, objeto.objindex & "-0")
            call logventacasa(userlist(userindex).name & " compr� " & objdata(objeto.objindex).name)
        end if
        
    elseif modo = emodocomercio.venta then
        
        if cantidad > userlist(userindex).invent.object(slot).amount then cantidad = userlist(userindex).invent.object(slot).amount
        
        objeto.amount = cantidad
        objeto.objindex = userlist(userindex).invent.object(slot).objindex
        
        if objeto.objindex = 0 then
            exit sub
        elseif (npclist(npcindex).tipoitems <> objdata(objeto.objindex).objtype and npclist(npcindex).tipoitems <> eobjtype.otcualquiera) or objeto.objindex = ioro then
            call writeconsolemsg(userindex, "lo siento, no estoy interesado en este tipo de objetos.", fonttypenames.fonttype_info)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            call writetradeok(userindex)
            exit sub
        elseif objdata(objeto.objindex).real = 1 then
            if npclist(npcindex).name <> "sr" then
                call writeconsolemsg(userindex, "las armaduras del ej�rcito real s�lo pueden ser vendidas a los sastres reales.", fonttypenames.fonttype_info)
                call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
                call writetradeok(userindex)
                exit sub
            end if
        elseif objdata(objeto.objindex).caos = 1 then
            if npclist(npcindex).name <> "sc" then
                call writeconsolemsg(userindex, "las armaduras de la legi�n oscura s�lo pueden ser vendidas a los sastres del demonio.", fonttypenames.fonttype_info)
                call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
                call writetradeok(userindex)
                exit sub
            end if
        elseif userlist(userindex).invent.object(slot).amount < 0 or cantidad = 0 then
            exit sub
        elseif slot < lbound(userlist(userindex).invent.object()) or slot > ubound(userlist(userindex).invent.object()) then
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            exit sub
        elseif userlist(userindex).flags.privilegios and playertype.consejero then
            call writeconsolemsg(userindex, "no puedes vender �tems.", fonttypenames.fonttype_warning)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            call writetradeok(userindex)
            exit sub
        end if
        
        call quitaruserinvitem(userindex, slot, cantidad)
        
        'precio = round(objdata(objeto.objindex).valor / reductor_precioventa * cantidad, 0)
        precio = fix(saleprice(objeto.objindex) * cantidad)
        userlist(userindex).stats.gld = userlist(userindex).stats.gld + precio
        
        if userlist(userindex).stats.gld > maxoro then _
            userlist(userindex).stats.gld = maxoro
        
        dim npcslot as integer
        npcslot = slotennpcinv(npcindex, objeto.objindex, objeto.amount)
        
        if npcslot <= max_inventory_slots then 'slot valido
            'mete el obj en el slot
            npclist(npcindex).invent.object(npcslot).objindex = objeto.objindex
            npclist(npcindex).invent.object(npcslot).amount = npclist(npcindex).invent.object(npcslot).amount + objeto.amount
            if npclist(npcindex).invent.object(npcslot).amount > max_inventory_objs then
                npclist(npcindex).invent.object(npcslot).amount = max_inventory_objs
            end if
        end if
        
        'bien, ahora logueo de ser necesario. pablo (toxicwaste) 07/09/07
        'es un objeto que tenemos que loguear?
        if objdata(objeto.objindex).log = 1 then
            call logdesarrollo(userlist(userindex).name & " vendi� al npc " & objeto.amount & " " & objdata(objeto.objindex).name)
        elseif objeto.amount = 1000 then 'es mucha cantidad?
            'si no es de los prohibidos de loguear, lo logueamos.
            if objdata(objeto.objindex).nolog <> 1 then
                call logdesarrollo(userlist(userindex).name & " vendi� al npc " & objeto.amount & " " & objdata(objeto.objindex).name)
            end if
        end if
        
    end if
    
    call updateuserinv(true, userindex, 0)
    call writeupdateuserstats(userindex)
    call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
    call writetradeok(userindex)
        
    call subirskill(userindex, eskill.comerciar, true)
end sub

public sub iniciarcomercionpc(byval userindex as integer)
'*************************************************
'author: nacho (integer)
'last modified: 2/8/06
'*************************************************
    call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
    userlist(userindex).flags.comerciando = true
    call writecommerceinit(userindex)
end sub

private function slotennpcinv(byval npcindex as integer, byval objeto as integer, byval cantidad as integer) as integer
'*************************************************
'author: nacho (integer)
'last modified: 2/8/06
'*************************************************
    slotennpcinv = 1
    do until npclist(npcindex).invent.object(slotennpcinv).objindex = objeto _
      and npclist(npcindex).invent.object(slotennpcinv).amount + cantidad <= max_inventory_objs
        
        slotennpcinv = slotennpcinv + 1
        if slotennpcinv > max_inventory_slots then exit do
        
    loop
    
    if slotennpcinv > max_inventory_slots then
    
        slotennpcinv = 1
        
        do until npclist(npcindex).invent.object(slotennpcinv).objindex = 0
        
            slotennpcinv = slotennpcinv + 1
            if slotennpcinv > max_inventory_slots then exit do
            
        loop
        
        if slotennpcinv <= max_inventory_slots then npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems + 1
    
    end if
    
end function

private function descuento(byval userindex as integer) as single
'*************************************************
'author: nacho (integer)
'last modified: 2/8/06
'*************************************************
    descuento = 1 + userlist(userindex).stats.userskills(eskill.comerciar) / 100
end function

''
' send the inventory of the npc to the user
'
' @param userindex the index of the user
' @param npcindex the index of the npc

private sub enviarnpcinv(byval userindex as integer, byval npcindex as integer)
'*************************************************
'author: nacho (integer)
'last modified: 06/14/08
'last modified by: nicol�s ezequiel bouhid (niconz)
'*************************************************
    dim slot as byte
    dim val as single
    
    for slot = 1 to max_normal_inventory_slots
        if npclist(npcindex).invent.object(slot).objindex > 0 then
            dim thisobj as obj
            
            thisobj.objindex = npclist(npcindex).invent.object(slot).objindex
            thisobj.amount = npclist(npcindex).invent.object(slot).amount
            
            val = (objdata(thisobj.objindex).valor) / descuento(userindex)
            
            call writechangenpcinventoryslot(userindex, slot, thisobj, val)
        else
            dim dummyobj as obj
            call writechangenpcinventoryslot(userindex, slot, dummyobj, 0)
        end if
    next slot
end sub

''
' devuelve el valor de venta del objeto
'
' @param objindex  el n�mero de objeto al cual le calculamos el precio de venta

public function saleprice(byval objindex as integer) as single
'*************************************************
'author: nicol�s (niconz)
'
'*************************************************
    if objindex < 1 or objindex > ubound(objdata) then exit function
    if itemnewbie(objindex) then exit function
    
    saleprice = objdata(objindex).valor / reductor_precioventa
end function
