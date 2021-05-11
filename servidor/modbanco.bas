attribute vb_name = "modbanco"
'**************************************************************
' modbanco.bas - handles the character's bank accounts.
'
' implemented by kevin birmingham (neb)
' kbneb@hotmail.com
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

sub iniciardeposito(byval userindex as integer)
on error goto errhandler

'hacemos un update del inventario del usuario
call updatebanuserinv(true, userindex, 0)
'actualizamos el dinero
call writeupdateuserstats(userindex)
'mostramos la ventana pa' comerciar y ver ladear la osamenta. jajaja
call writebankinit(userindex)
userlist(userindex).flags.comerciando = true

errhandler:

end sub

sub sendbanobj(userindex as integer, slot as byte, object as userobj)

userlist(userindex).bancoinvent.object(slot) = object

call writechangebankslot(userindex, slot)

end sub

sub updatebanuserinv(byval updateall as boolean, byval userindex as integer, byval slot as byte)

dim nullobj as userobj
dim loopc as byte

'actualiza un solo slot
if not updateall then

    'actualiza el inventario
    if userlist(userindex).bancoinvent.object(slot).objindex > 0 then
        call sendbanobj(userindex, slot, userlist(userindex).bancoinvent.object(slot))
    else
        call sendbanobj(userindex, slot, nullobj)
    end if

else

'actualiza todos los slots
    for loopc = 1 to max_bancoinventory_slots

        'actualiza el inventario
        if userlist(userindex).bancoinvent.object(loopc).objindex > 0 then
            call sendbanobj(userindex, loopc, userlist(userindex).bancoinvent.object(loopc))
        else
            
            call sendbanobj(userindex, loopc, nullobj)
            
        end if

    next loopc

end if

end sub

sub userretiraitem(byval userindex as integer, byval i as integer, byval cantidad as integer)
on error goto errhandler


if cantidad < 1 then exit sub


call writeupdateuserstats(userindex)

   
       if userlist(userindex).bancoinvent.object(i).amount > 0 then
            if cantidad > userlist(userindex).bancoinvent.object(i).amount then cantidad = userlist(userindex).bancoinvent.object(i).amount
            'agregamos el obj que compro al inventario
            call userreciveobj(userindex, cint(i), cantidad)
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el banco
            call updatebanuserinv(true, userindex, 0)
       end if
            'actualizamos la ventana de comercio
            call updateventanabanco(userindex)


errhandler:

end sub

sub userreciveobj(byval userindex as integer, byval objindex as integer, byval cantidad as integer)

dim slot as integer
dim obji as integer


if userlist(userindex).bancoinvent.object(objindex).amount <= 0 then exit sub

obji = userlist(userindex).bancoinvent.object(objindex).objindex


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
                exit sub
            end if
        loop
        userlist(userindex).invent.nroitems = userlist(userindex).invent.nroitems + 1
end if



'mete el obj en el slot
if userlist(userindex).invent.object(slot).amount + cantidad <= max_inventory_objs then
    
    'menor que max_inv_objs
    userlist(userindex).invent.object(slot).objindex = obji
    userlist(userindex).invent.object(slot).amount = userlist(userindex).invent.object(slot).amount + cantidad
    
    call quitarbancoinvitem(userindex, cbyte(objindex), cantidad)
else
    call writeconsolemsg(userindex, "no pod�s tener mas objetos.", fonttypenames.fonttype_info)
end if


end sub

sub quitarbancoinvitem(byval userindex as integer, byval slot as byte, byval cantidad as integer)



dim objindex as integer
objindex = userlist(userindex).bancoinvent.object(slot).objindex

    'quita un obj

       userlist(userindex).bancoinvent.object(slot).amount = userlist(userindex).bancoinvent.object(slot).amount - cantidad
        
        if userlist(userindex).bancoinvent.object(slot).amount <= 0 then
            userlist(userindex).bancoinvent.nroitems = userlist(userindex).bancoinvent.nroitems - 1
            userlist(userindex).bancoinvent.object(slot).objindex = 0
            userlist(userindex).bancoinvent.object(slot).amount = 0
        end if

    
    
end sub

sub updateventanabanco(byval userindex as integer)
    call writebankok(userindex)
end sub

sub userdepositaitem(byval userindex as integer, byval item as integer, byval cantidad as integer)
on error goto errhandler
    if userlist(userindex).invent.object(item).amount > 0 and cantidad > 0 then
        if cantidad > userlist(userindex).invent.object(item).amount then cantidad = userlist(userindex).invent.object(item).amount
        
        'agregamos el obj que deposita al banco
        call userdejaobj(userindex, cint(item), cantidad)
        
        'actualizamos el inventario del usuario
        call updateuserinv(true, userindex, 0)
        
        'actualizamos el inventario del banco
        call updatebanuserinv(true, userindex, 0)
    end if
    
    'actualizamos la ventana del banco
    call updateventanabanco(userindex)
errhandler:
end sub

sub userdejaobj(byval userindex as integer, byval objindex as integer, byval cantidad as integer)
    dim slot as integer
    dim obji as integer
    
    if cantidad < 1 then exit sub
    
    obji = userlist(userindex).invent.object(objindex).objindex
    
    '�ya tiene un objeto de este tipo?
    slot = 1
    do until userlist(userindex).bancoinvent.object(slot).objindex = obji and _
        userlist(userindex).bancoinvent.object(slot).amount + cantidad <= max_inventory_objs
        slot = slot + 1
        
        if slot > max_bancoinventory_slots then
            exit do
        end if
    loop
    
    'sino se fija por un slot vacio antes del slot devuelto
    if slot > max_bancoinventory_slots then
        slot = 1
        do until userlist(userindex).bancoinvent.object(slot).objindex = 0
            slot = slot + 1
            
            if slot > max_bancoinventory_slots then
                call writeconsolemsg(userindex, "no tienes mas espacio en el banco!!", fonttypenames.fonttype_info)
                exit sub
            end if
        loop
        
        userlist(userindex).bancoinvent.nroitems = userlist(userindex).bancoinvent.nroitems + 1
    end if
    
    if slot <= max_bancoinventory_slots then 'slot valido
        'mete el obj en el slot
        if userlist(userindex).bancoinvent.object(slot).amount + cantidad <= max_inventory_objs then
            
            'menor que max_inv_objs
            userlist(userindex).bancoinvent.object(slot).objindex = obji
            userlist(userindex).bancoinvent.object(slot).amount = userlist(userindex).bancoinvent.object(slot).amount + cantidad
            
            call quitaruserinvitem(userindex, cbyte(objindex), cantidad)
        else
            call writeconsolemsg(userindex, "el banco no puede cargar tantos objetos.", fonttypenames.fonttype_info)
        end if
    end if
end sub

sub senduserbovedatxt(byval sendindex as integer, byval userindex as integer)
on error resume next
dim j as integer

call writeconsolemsg(sendindex, userlist(userindex).name, fonttypenames.fonttype_info)
call writeconsolemsg(sendindex, " tiene " & userlist(userindex).bancoinvent.nroitems & " objetos.", fonttypenames.fonttype_info)

for j = 1 to max_bancoinventory_slots
    if userlist(userindex).bancoinvent.object(j).objindex > 0 then
        call writeconsolemsg(sendindex, " objeto " & j & " " & objdata(userlist(userindex).bancoinvent.object(j).objindex).name & " cantidad:" & userlist(userindex).bancoinvent.object(j).amount, fonttypenames.fonttype_info)
    end if
next

end sub

sub senduserbovedatxtfromchar(byval sendindex as integer, byval charname as string)
on error resume next
dim j as integer
dim charfile as string, tmp as string
dim objind as long, objcant as long

charfile = charpath & charname & ".chr"

if fileexist(charfile, vbnormal) then
    call writeconsolemsg(sendindex, charname, fonttypenames.fonttype_info)
    call writeconsolemsg(sendindex, " tiene " & getvar(charfile, "bancoinventory", "cantidaditems") & " objetos.", fonttypenames.fonttype_info)
    for j = 1 to max_bancoinventory_slots
        tmp = getvar(charfile, "bancoinventory", "obj" & j)
        objind = readfield(1, tmp, asc("-"))
        objcant = readfield(2, tmp, asc("-"))
        if objind > 0 then
            call writeconsolemsg(sendindex, " objeto " & j & " " & objdata(objind).name & " cantidad:" & objcant, fonttypenames.fonttype_info)
        end if
    next
else
    call writeconsolemsg(sendindex, "usuario inexistente: " & charname, fonttypenames.fonttype_info)
end if

end sub

