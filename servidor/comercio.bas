attribute vb_name = "comercio"
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
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%          modulo de comercio npc-user              %%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function usercompraobj(byval userindex as integer, byval objindex as integer, byval npcindex as integer, byval cantidad as integer) as boolean
dim infla as long
dim descuento as string
dim unidad as long, monto as long
dim slot as integer
dim obji as integer
dim encontre as boolean

on error goto errorh

usercompraobj = false

if (npclist(userlist(userindex).flags.targetnpc).invent.object(objindex).amount <= 0) then exit function

obji = npclist(userlist(userindex).flags.targetnpc).invent.object(objindex).objindex

'es una armadura real y el tipo no es faccion?
if objdata(obji).real = 1 then
    if npclist(npcindex).name <> "sr" then
        call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "lo siento, la ropa faccionaria solo es para muestra, no tengo autorizaci�n para venderla. dir�jete al sastre de tu ej�rcito." & "�" & str(npclist(npcindex).char.charindex))
        exit function
    end if
end if
if objdata(obji).caos = 1 then
    if npclist(npcindex).name <> "sc" then
        call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "lo siento, la ropa faccionaria solo es para muestra, no tengo autorizaci�n para venderla. dir�jete al sastre de tu ej�rcito." & "�" & str(npclist(npcindex).char.charindex))
        exit function
    end if
end if

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
                call senddata(toindex, userindex, 0, "||no pod�s tener mas objetos." & fonttype_info)
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
    infla = (npclist(npcindex).inflacion * objdata(obji).valor) / 100
    descuento = userlist(userindex).flags.descuento
    if descuento = 0 then descuento = 1 'evitamos dividir por 0!
    unidad = ((objdata(npclist(npcindex).invent.object(objindex).objindex).valor + infla) / descuento)
    monto = unidad * cantidad
    userlist(userindex).stats.gld = userlist(userindex).stats.gld - monto
    
    'tal vez suba el skill comerciar ;-)
    call subirskill(userindex, comerciar)
    
    if objdata(obji).objtype = objtype_llaves then call logventacasa(userlist(userindex).name & " compro " & objdata(obji).name)

'    if userlist(userindex).stats.gld < 0 then userlist(userindex).stats.gld = 0
    
    call quitarnpcinvitem(userlist(userindex).flags.targetnpc, cbyte(objindex), cantidad)
else
    call senddata(toindex, userindex, 0, "||no pod�s tener mas objetos." & fonttype_info)
end if

exit function

errorh:
call logerror("error en usercompraobj. " & err.description)
end function


sub npccompraobj(byval userindex as integer, byval objindex as integer, byval cantidad as integer)

dim slot as integer
dim obji as integer
dim npcindex as integer
dim infla as long
dim monto as long
on error goto errorh
      
if cantidad < 1 then exit sub

npcindex = userlist(userindex).flags.targetnpc
obji = userlist(userindex).invent.object(objindex).objindex

if objdata(obji).newbie = 1 then
    call senddata(toindex, userindex, 0, "||no comercio objetos para newbies." & fonttype_info)
    exit sub
end if

if npclist(npcindex).tipoitems <> objtype_cualquiera then
    '�son los items con los que comercia el npc?
    if npclist(npcindex).tipoitems <> objdata(obji).objtype then
            call senddata(toindex, userindex, 0, "||el npc no esta interesado en comprar ese objeto." & fonttype_warning)
            exit sub
    end if
end if

if obji = ioro then
    call senddata(toindex, userindex, 0, "||el npc no esta interesado en comprar ese objeto." & fonttype_warning)
    exit sub
end if

'�ya tiene un objeto de este tipo?
slot = 1
do until npclist(npcindex).invent.object(slot).objindex = obji and _
         npclist(npcindex).invent.object(slot).amount + cantidad <= max_inventory_objs
            slot = slot + 1
        
            if slot > max_inventory_slots then
                exit do
            end if
loop

'sino se fija por un slot vacio antes del slot devuelto
if slot > max_inventory_slots then
        slot = 1
        do until npclist(npcindex).invent.object(slot).objindex = 0
            slot = slot + 1

            if slot > max_inventory_slots then
'                call senddata(toindex, npcindex, 0, "||el npc no puede cargar mas objetos." & fonttype_info)
'                exit sub
                exit do
            end if
        loop
        if slot <= max_inventory_slots then npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems + 1
        
        
end if

if slot <= max_inventory_slots then 'slot valido
    'mete el obj en el slot
    if npclist(npcindex).invent.object(slot).amount + cantidad <= max_inventory_objs then
        
        'menor que max_inv_objs
        npclist(npcindex).invent.object(slot).objindex = obji
        npclist(npcindex).invent.object(slot).amount = npclist(npcindex).invent.object(slot).amount + cantidad
        
        call quitaruserinvitem(userindex, cbyte(objindex), cantidad)
        'le sumamos al user el valor en oro del obj vendido
        monto = ((objdata(obji).valor \ 3 + infla) * cantidad)
        call addtovar(userlist(userindex).stats.gld, monto, maxoro)
        'tal vez suba el skill comerciar ;-)
        call subirskill(userindex, comerciar)
    
    else
        call senddata(toindex, userindex, 0, "||el npc no puede cargar tantos objetos." & fonttype_info)
    end if

else
    call quitaruserinvitem(userindex, cbyte(objindex), cantidad)
    'le sumamos al user el valor en oro del obj vendido
    monto = ((objdata(obji).valor \ 3 + infla) * cantidad)
    call addtovar(userlist(userindex).stats.gld, monto, maxoro)
end if
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
call senduserstatsbox(userindex)
'mostramos la ventana pa' comerciar y ver ladear la osamenta. jajaja
userlist(userindex).flags.comerciando = true
senddata toindex, userindex, 0, "initcom"

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

sub npcventaitem(byval userindex as integer, byval i as integer, byval cantidad as integer, byval npcindex as integer)
'listindex+1, cantidad
on error goto errhandler

dim infla as long
dim val as long
dim desc as string

if cantidad < 1 then exit sub

'npc vende un obj a un usuario
call senduserstatsbox(userindex)

if i > max_inventory_slots then
    call senddata(toadmins, 0, 0, "posible intento de romper el sistema de comercio. usuario: " & userlist(userindex).name & fonttype_warning)
    exit sub
end if

if cantidad > max_inventory_objs then
    call senddata(toall, 0, 0, userlist(userindex).name & " ha sido baneado por el sistema anti-cheats." & fonttype_fight)
    call ban(userlist(userindex).name, "sistema anti cheats", "intentar hackear el sistema de comercio " & cantidad)
    userlist(userindex).flags.ban = 1
    call senddata(toindex, userindex, 0, "errhas sido baneado por el sistema anti cheats")
    call closesocket(userindex)
    exit sub
end if

'calculamos el valor unitario
infla = (npclist(npcindex).inflacion * objdata(npclist(npcindex).invent.object(i).objindex).valor) / 100
desc = descuento(userindex)
if desc = 0 then desc = 1 'evitamos dividir por 0!
val = (objdata(npclist(npcindex).invent.object(i).objindex).valor + infla) / desc



if userlist(userindex).stats.gld >= (val * cantidad) then
       
       if npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount > 0 then
            if cantidad > npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount then cantidad = npclist(userlist(userindex).flags.targetnpc).invent.object(i).amount
            'agregamos el obj que compro al inventario
            if not usercompraobj(userindex, cint(i), userlist(userindex).flags.targetnpc, cantidad) then
                call senddata(toindex, userindex, 0, "||no puedes comprar este �tem." & fonttype_info)
'                exit sub
            end if
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el oro
            call senduserstatsbox(userindex)
            'actualizamos la ventana de comercio
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            call updateventanacomercio(i, 0, userindex)
        
       end if
else
    call senddata(toindex, userindex, 0, "||no tenes suficiente dinero." & fonttype_info)
    exit sub
end if
exit sub

errhandler:
    call logerror("error en comprar item: " & err.description)
end sub

sub npccompraitem(byval userindex as integer, byval item as integer, byval cantidad as integer)

on error goto errhandler

'npc compra un obj a un usuario
call senduserstatsbox(userindex)
   
if userlist(userindex).invent.object(item).amount > 0 and userlist(userindex).invent.object(item).equipped = 0 then
            
            if cantidad > 0 and cantidad > userlist(userindex).invent.object(item).amount then cantidad = userlist(userindex).invent.object(item).amount
            'agregamos el obj que compro al inventario
            call npccompraobj(userindex, cint(item), cantidad)
            'actualizamos el inventario del usuario
            call updateuserinv(true, userindex, 0)
            'actualizamos el oro
            call senduserstatsbox(userindex)
            call enviarnpcinv(userindex, userlist(userindex).flags.targetnpc)
            'actualizamos la ventana de comercio
            
            call updateventanacomercio(item, 1, userindex)

end if
exit sub
errhandler:
    call logerror("error en vender item: " & err.description)
end sub


sub updateventanacomercio(byval slot as integer, byval npcinv as byte, byval userindex as integer)
 
 
 call senddata(toindex, userindex, 0, "transok" & slot & "," & npcinv)
 
end sub



function descuento(byval userindex as integer) as single
   'calcula el descuento al comerciar
  descuento = 1 + userlist(userindex).stats.userskills(comerciar) / 100
  userlist(userindex).flags.descuento = descuento

end function



'function descuento(byval userindex as integer) as string
'establece el descuento en funcion del skill comercio
'dim ptscomercio as integer
'ptscomercio = userlist(userindex).stats.userskills(comerciar)

'if ptscomercio <= 10 and ptscomercio > 5 then
'    userlist(userindex).flags.descuento = 1.1
'    descuento = 1.1
'elseif ptscomercio <= 20 and ptscomercio >= 11 then
'    userlist(userindex).flags.descuento = 1.2
'    descuento = 1.2
'elseif ptscomercio <= 30 and ptscomercio >= 19 then
'    userlist(userindex).flags.descuento = 1.3
'    descuento = 1.3
'elseif ptscomercio <= 40 and ptscomercio >= 29 then
'    userlist(userindex).flags.descuento = 1.4
'    descuento = 1.4
'elseif ptscomercio <= 50 and ptscomercio >= 39 then
'    userlist(userindex).flags.descuento = 1.5
'    descuento = 1.5
'elseif ptscomercio <= 60 and ptscomercio >= 49 then
'    userlist(userindex).flags.descuento = 1.6
'    descuento = 1.6
'elseif ptscomercio <= 70 and ptscomercio >= 59 then
'    userlist(userindex).flags.descuento = 1.7
'    descuento = 1.7
'elseif ptscomercio <= 80 and ptscomercio >= 69 then
'    userlist(userindex).flags.descuento = 1.8
'    descuento = 1.8
'elseif ptscomercio <= 99 and ptscomercio >= 79 then
'    userlist(userindex).flags.descuento = 1.9
'    descuento = 1.9
'elseif ptscomercio <= 999999 and ptscomercio >= 99 then
'    userlist(userindex).flags.descuento = 2
'    descuento = 2
'else
'    userlist(userindex).flags.descuento = 0
'    descuento = 0
'end if'
'
'end function
'
'
'
'
'

sub enviarnpcinv(byval userindex as integer, byval npcindex as integer)

'enviamos el inventario del npc con el cual el user va a comerciar...
dim i as integer
dim infla as long
dim desc as string
dim val as long
desc = descuento(userindex)
if desc = 0 then desc = 1 'evitamos dividir por 0!

for i = 1 to max_inventory_slots
  if npclist(npcindex).invent.object(i).objindex > 0 then
        'calculamos el porc de inflacion del npc
        infla = (npclist(npcindex).inflacion * objdata(npclist(npcindex).invent.object(i).objindex).valor) / 100
        val = (objdata(npclist(npcindex).invent.object(i).objindex).valor + infla) / desc
        senddata toindex, userindex, 0, "npci" & _
        objdata(npclist(npcindex).invent.object(i).objindex).name _
        & "," & npclist(npcindex).invent.object(i).amount & _
        "," & val _
        & "," & objdata(npclist(npcindex).invent.object(i).objindex).grhindex _
        & "," & npclist(npcindex).invent.object(i).objindex _
        & "," & objdata(npclist(npcindex).invent.object(i).objindex).objtype _
        & "," & objdata(npclist(npcindex).invent.object(i).objindex).maxhit _
        & "," & objdata(npclist(npcindex).invent.object(i).objindex).minhit _
        & "," & objdata(npclist(npcindex).invent.object(i).objindex).maxdef
        
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(1) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(2) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(3) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(4) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(5) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(6) _
'        & "," & objdata(npclist(npcindex).invent.object(i).objindex).claseprohibida(7)
  else
        senddata toindex, userindex, 0, "npci" & _
        "nada" _
        & "," & 0 & _
        "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0 _
        & "," & 0
  end if
  
next
end sub


