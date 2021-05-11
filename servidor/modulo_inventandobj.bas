attribute vb_name = "invnpc"
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
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        modulo inv & obj
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'modulo para controlar los objetos y los inventarios.
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
public function tiraritemalpiso(pos as worldpos, obj as obj, optional notpirata as boolean = true) as worldpos
on error goto errhandler

    dim nuevapos as worldpos
    nuevapos.x = 0
    nuevapos.y = 0
    
    tilelibre pos, nuevapos, obj, notpirata, true
    if nuevapos.x <> 0 and nuevapos.y <> 0 then
        call makeobj(obj, pos.map, nuevapos.x, nuevapos.y)
    end if
    tiraritemalpiso = nuevapos

exit function
errhandler:

end function

public sub npc_tirar_items(byref npc as npc)
'tira todos los items del npc
on error resume next

if npc.invent.nroitems > 0 then
    
    dim i as byte
    dim miobj as obj
    
    for i = 1 to max_inventory_slots
    
        if npc.invent.object(i).objindex > 0 then
              miobj.amount = npc.invent.object(i).amount
              miobj.objindex = npc.invent.object(i).objindex
              call tiraritemalpiso(npc.pos, miobj)
        end if
      
    next i

end if

end sub

function quedanitems(byval npcindex as integer, byval objindex as integer) as boolean
on error resume next
'call logtarea("function quedanitems npcindex:" & npcindex & " objindex:" & objindex)

dim i as integer
if npclist(npcindex).invent.nroitems > 0 then
    for i = 1 to max_inventory_slots
        if npclist(npcindex).invent.object(i).objindex = objindex then
            quedanitems = true
            exit function
        end if
    next
end if
quedanitems = false
end function

''
' gets the amount of a certain item that an npc has.
'
' @param npcindex specifies reference to npcmerchant
' @param objindex specifies reference to object
' @return   the amount of the item that the npc has
' @remarks this function reads the npc.dat file
function encontrarcant(byval npcindex as integer, byval objindex as integer) as integer
'***************************************************
'author: unknown
'last modification: 03/09/08
'last modification by: marco vanotti (marco)
' - 03/09/08 encontrarcant now returns 0 if the npc doesn't have it (marco)
'***************************************************
on error resume next
'devuelve la cantidad original del obj de un npc

dim ln as string, npcfile as string
dim i as integer

npcfile = datpath & "npcs.dat"
 
for i = 1 to max_inventory_slots
    ln = getvar(npcfile, "npc" & npclist(npcindex).numero, "obj" & i)
    if objindex = val(readfield(1, ln, 45)) then
        encontrarcant = val(readfield(2, ln, 45))
        exit function
    end if
next
                   
encontrarcant = 0

end function

sub resetnpcinv(byval npcindex as integer)
on error resume next

dim i as integer

npclist(npcindex).invent.nroitems = 0

for i = 1 to max_inventory_slots
   npclist(npcindex).invent.object(i).objindex = 0
   npclist(npcindex).invent.object(i).amount = 0
next i

npclist(npcindex).invrespawn = 0

end sub

''
' removes a certain amount of items from a slot of an npc's inventory
'
' @param npcindex specifies reference to npcmerchant
' @param slot specifies reference to npc's inventory's slot
' @param antidad specifies amount of items that will be removed
sub quitarnpcinvitem(byval npcindex as integer, byval slot as byte, byval cantidad as integer)
'***************************************************
'author: unknown
'last modification: 03/09/08
'last modification by: marco vanotti (marco)
' - 03/09/08 now this sub checks that te npc has an item before respawning it (marco)
'***************************************************
dim objindex as integer
dim icant as integer
objindex = npclist(npcindex).invent.object(slot).objindex

    'quita un obj
    if objdata(npclist(npcindex).invent.object(slot).objindex).crucial = 0 then
        npclist(npcindex).invent.object(slot).amount = npclist(npcindex).invent.object(slot).amount - cantidad
        
        if npclist(npcindex).invent.object(slot).amount <= 0 then
            npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems - 1
            npclist(npcindex).invent.object(slot).objindex = 0
            npclist(npcindex).invent.object(slot).amount = 0
            if npclist(npcindex).invent.nroitems = 0 and npclist(npcindex).invrespawn <> 1 then
               call cargarinvent(npcindex) 'reponemos el inventario
            end if
        end if
    else
        npclist(npcindex).invent.object(slot).amount = npclist(npcindex).invent.object(slot).amount - cantidad
        
        if npclist(npcindex).invent.object(slot).amount <= 0 then
            npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems - 1
            npclist(npcindex).invent.object(slot).objindex = 0
            npclist(npcindex).invent.object(slot).amount = 0
            
            if not quedanitems(npcindex, objindex) then
                'check if the item is in the npc's dat.
                icant = encontrarcant(npcindex, objindex)
                if icant then
                    npclist(npcindex).invent.object(slot).objindex = objindex
                    npclist(npcindex).invent.object(slot).amount = icant
                    npclist(npcindex).invent.nroitems = npclist(npcindex).invent.nroitems + 1
                end if
            end if
            
            if npclist(npcindex).invent.nroitems = 0 and npclist(npcindex).invrespawn <> 1 then
               call cargarinvent(npcindex) 'reponemos el inventario
            end if
        end if
    
    
    
    end if
end sub

sub cargarinvent(byval npcindex as integer)

'vuelve a cargar el inventario del npc npcindex
dim loopc as integer
dim ln as string
dim npcfile as string

npcfile = datpath & "npcs.dat"

npclist(npcindex).invent.nroitems = val(getvar(npcfile, "npc" & npclist(npcindex).numero, "nroitems"))

for loopc = 1 to npclist(npcindex).invent.nroitems
    ln = getvar(npcfile, "npc" & npclist(npcindex).numero, "obj" & loopc)
    npclist(npcindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
    npclist(npcindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
    
next loopc

end sub


