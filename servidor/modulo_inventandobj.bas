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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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

public sub npc_tirar_items(byref npc as npc, byval ispretoriano as boolean)
'***************************************************
'autor: unknown (orginal version)
'last modification: 28/11/2009
'give away npc's items.
'28/11/2009: zama - implementado drops complejos
'02/04/2010: zama - los pretos vuelven a tirar oro.
'***************************************************
on error resume next

    with npc
        
        dim i as byte
        dim miobj as obj
        dim nrodrop as integer
        dim random as integer
        dim objindex as integer
        
        
        ' tira todo el inventario
        if ispretoriano then
            for i = 1 to max_inventory_slots
                if .invent.object(i).objindex > 0 then
                      miobj.amount = .invent.object(i).amount
                      miobj.objindex = .invent.object(i).objindex
                      call tiraritemalpiso(.pos, miobj)
                end if
            next i
            
            ' dropea oro?
            if .givegld > 0 then _
                call tiraroronpc(.givegld, .pos)
                
            exit sub
        end if
        
        random = randomnumber(1, 100)
        
        ' tiene 10% de prob de no tirar nada
        if random <= 90 then
            nrodrop = 1
            
            if random <= 10 then
                nrodrop = nrodrop + 1
                 
                for i = 1 to 3
                    ' 10% de ir pasando de etapas
                    if randomnumber(1, 100) <= 10 then
                        nrodrop = nrodrop + 1
                    else
                        exit for
                    end if
                next i
                
            end if
            

            objindex = .drop(nrodrop).objindex
            if objindex > 0 then
            
                if objindex = ioro then
                    call tiraroronpc(.drop(nrodrop).amount, npc.pos)
                else
                    miobj.amount = .drop(nrodrop).amount
                    miobj.objindex = .drop(nrodrop).objindex
                    
                    call tiraritemalpiso(.pos, miobj)
                end if
            end if

        end if

    end with

end sub

function quedanitems(byval npcindex as integer, byval objindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

    dim i as integer
    
    with npclist(npcindex)
        .invent.nroitems = 0
        
        for i = 1 to max_inventory_slots
           .invent.object(i).objindex = 0
           .invent.object(i).amount = 0
        next i
        
        .invrespawn = 0
    end with

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
'last modification: 23/11/2009
'last modification by: marco vanotti (marco)
' - 03/09/08 now this sub checks that te npc has an item before respawning it (marco)
'23/11/2009: zama - optimizacion de codigo.
'***************************************************
    dim objindex as integer
    dim icant as integer
    
    with npclist(npcindex)
        objindex = .invent.object(slot).objindex
    
        'quita un obj
        if objdata(.invent.object(slot).objindex).crucial = 0 then
            .invent.object(slot).amount = .invent.object(slot).amount - cantidad
            
            if .invent.object(slot).amount <= 0 then
                .invent.nroitems = .invent.nroitems - 1
                .invent.object(slot).objindex = 0
                .invent.object(slot).amount = 0
                if .invent.nroitems = 0 and .invrespawn <> 1 then
                   call cargarinvent(npcindex) 'reponemos el inventario
                end if
            end if
        else
            .invent.object(slot).amount = .invent.object(slot).amount - cantidad
            
            if .invent.object(slot).amount <= 0 then
                .invent.nroitems = .invent.nroitems - 1
                .invent.object(slot).objindex = 0
                .invent.object(slot).amount = 0
                
                if not quedanitems(npcindex, objindex) then
                    'check if the item is in the npc's dat.
                    icant = encontrarcant(npcindex, objindex)
                    if icant then
                        .invent.object(slot).objindex = objindex
                        .invent.object(slot).amount = icant
                        .invent.nroitems = .invent.nroitems + 1
                    end if
                end if
                
                if .invent.nroitems = 0 and .invrespawn <> 1 then
                   call cargarinvent(npcindex) 'reponemos el inventario
                end if
            end if
        end if
    end with
end sub

sub cargarinvent(byval npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'vuelve a cargar el inventario del npc npcindex
    dim loopc as integer
    dim ln as string
    dim npcfile as string
    
    npcfile = datpath & "npcs.dat"
    
    with npclist(npcindex)
        .invent.nroitems = val(getvar(npcfile, "npc" & .numero, "nroitems"))
        
        for loopc = 1 to .invent.nroitems
            ln = getvar(npcfile, "npc" & .numero, "obj" & loopc)
            .invent.object(loopc).objindex = val(readfield(1, ln, 45))
            .invent.object(loopc).amount = val(readfield(2, ln, 45))
            
        next loopc
    end with

end sub


public sub tiraroronpc(byval cantidad as long, byref pos as worldpos)
'***************************************************
'autor: zama
'last modification: 13/02/2010
'***************************************************
on error goto errhandler

    if cantidad > 0 then
        dim i as byte
        dim miobj as obj
        dim remaininggold as long
        
        remaininggold = cantidad
        
        while (remaininggold > 0)
            
            ' tira pilon de 10k
            if remaininggold > max_inventory_objs then
                miobj.amount = max_inventory_objs
                remaininggold = remaininggold - max_inventory_objs
                
            ' tira lo que quede
            else
                miobj.amount = remaininggold
                remaininggold = 0
            end if

            miobj.objindex = ioro
            
            call tiraritemalpiso(pos, miobj)
        wend
    end if

    exit sub

errhandler:
    call logerror("error en tiraroro. error " & err.number & " : " & err.description)
end sub

