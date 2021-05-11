attribute vb_name = "modbanco"
option explicit

'modulo programado por neb
'kevin birmingham
'kbneb@hotmail.com

sub iniciardeposito(byval userindex as integer)
on error goto errhandler

'hacemos un update del inventario del usuario
call updatebanuserinv(true, userindex, 0)
'atcualizamos el dinero
call senduserstatsbox(userindex)
'mostramos la ventana pa' comerciar y ver ladear la osamenta. jajaja
senddata sendtarget.toindex, userindex, 0, "initbanco"
userlist(userindex).flags.comerciando = true

errhandler:

end sub

sub sendbanobj(userindex as integer, slot as byte, object as userobj)


userlist(userindex).bancoinvent.object(slot) = object

if object.objindex > 0 then

    call senddata(sendtarget.toindex, userindex, 0, "sbo" & slot & "," & object.objindex & "," & objdata(object.objindex).name & "," & object.amount & "," & objdata(object.objindex).grhindex & "," _
    & objdata(object.objindex).objtype & "," _
    & objdata(object.objindex).maxhit & "," _
    & objdata(object.objindex).minhit & "," _
    & objdata(object.objindex).maxdef)

else

    call senddata(sendtarget.toindex, userindex, 0, "sbo" & slot & "," & "0" & "," & "(none)" & "," & "0" & "," & "0")

end if


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


call senduserstatsbox(userindex)

   
       if userlist(userindex).bancoinvent.object(i).amount > 0 then
            if cantidad > userlist(userindex).bancoinvent.object(i).amount then cantidad = userlist(userindex).bancoinvent.object(i).amount
            'agregamos el obj que compro al inventario
            call userreciveobj(userindex, cint(i), cantidad)
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el banco
            call updatebanuserinv(true, userindex, 0)
            'actualizamos la ventana de comercio
            call updateventanabanco(i, 0, userindex)
       end if



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
                call senddata(sendtarget.toindex, userindex, 0, "||no pod�s tener mas objetos." & fonttype_info)
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
    call senddata(sendtarget.toindex, userindex, 0, "||no pod�s tener mas objetos." & fonttype_info)
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

sub updateventanabanco(byval slot as integer, byval npcinv as byte, byval userindex as integer)
 
 
 call senddata(sendtarget.toindex, userindex, 0, "bancook" & slot & "," & npcinv)
 
end sub

sub userdepositaitem(byval userindex as integer, byval item as integer, byval cantidad as integer)

on error goto errhandler

'el usuario deposita un item
call senduserstatsbox(userindex)
   
if userlist(userindex).invent.object(item).amount > 0 and userlist(userindex).invent.object(item).equipped = 0 then
            
            if cantidad > 0 and cantidad > userlist(userindex).invent.object(item).amount then cantidad = userlist(userindex).invent.object(item).amount
            'agregamos el obj que compro al inventario
            call userdejaobj(userindex, cint(item), cantidad)
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el inventario del banco
            call updatebanuserinv(true, userindex, 0)
            'actualizamos la ventana del banco
            
            call updateventanabanco(item, 1, userindex)
            
end if

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
                call senddata(sendtarget.toindex, userindex, 0, "||no tienes mas espacio en el banco!!" & fonttype_info)
                exit sub
                exit do
            end if
        loop
        if slot <= max_bancoinventory_slots then userlist(userindex).bancoinvent.nroitems = userlist(userindex).bancoinvent.nroitems + 1
        
        
end if

if slot <= max_bancoinventory_slots then 'slot valido
    'mete el obj en el slot
    if userlist(userindex).bancoinvent.object(slot).amount + cantidad <= max_inventory_objs then
        
        'menor que max_inv_objs
        userlist(userindex).bancoinvent.object(slot).objindex = obji
        userlist(userindex).bancoinvent.object(slot).amount = userlist(userindex).bancoinvent.object(slot).amount + cantidad
        
        call quitaruserinvitem(userindex, cbyte(objindex), cantidad)

    else
        call senddata(sendtarget.toindex, userindex, 0, "||el banco no puede cargar tantos objetos." & fonttype_info)
    end if

else
    call quitaruserinvitem(userindex, cbyte(objindex), cantidad)
end if

end sub

sub senduserbovedatxt(byval sendindex as integer, byval userindex as integer)
on error resume next
dim j as integer
call senddata(sendtarget.toindex, sendindex, 0, "||" & userlist(userindex).name & fonttype_info)
call senddata(sendtarget.toindex, sendindex, 0, "|| tiene " & userlist(userindex).bancoinvent.nroitems & " objetos." & fonttype_info)
for j = 1 to max_bancoinventory_slots
    if userlist(userindex).bancoinvent.object(j).objindex > 0 then
        call senddata(sendtarget.toindex, sendindex, 0, "|| objeto " & j & " " & objdata(userlist(userindex).bancoinvent.object(j).objindex).name & " cantidad:" & userlist(userindex).bancoinvent.object(j).amount & fonttype_info)
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
    call senddata(sendtarget.toindex, sendindex, 0, "||" & charname & fonttype_info)
    call senddata(sendtarget.toindex, sendindex, 0, "|| tiene " & getvar(charfile, "bancoinventory", "cantidaditems") & " objetos." & fonttype_info)
    for j = 1 to max_bancoinventory_slots
        tmp = getvar(charfile, "bancoinventory", "obj" & j)
        objind = readfield(1, tmp, asc("-"))
        objcant = readfield(2, tmp, asc("-"))
        if objind > 0 then
            call senddata(sendtarget.toindex, sendindex, 0, "|| objeto " & j & " " & objdata(objind).name & " cantidad:" & objcant & fonttype_info)
        end if
    next
else
    call senddata(sendtarget.toindex, sendindex, 0, "||usuario inexistente: " & charname & fonttype_info)
end if

end sub

