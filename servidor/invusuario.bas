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

'17/09/02
'agregue que la funci�n se asegure que el objeto no es un barco

on error resume next

dim i as integer
dim objindex as integer

for i = 1 to max_inventory_slots
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

function clasepuedeusaritem(byval userindex as integer, byval objindex as integer) as boolean
on error goto manejador

'call logtarea("clasepuedeusaritem")

dim flag as boolean

'admins can use anything!
if userlist(userindex).flags.privilegios and playertype.user then
    if objdata(objindex).claseprohibida(1) <> 0 then
        dim i as integer
        for i = 1 to numclases
            if objdata(objindex).claseprohibida(i) = userlist(userindex).clase then
                clasepuedeusaritem = false
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
dim j as integer
for j = 1 to max_inventory_slots
        if userlist(userindex).invent.object(j).objindex > 0 then
             
             if objdata(userlist(userindex).invent.object(j).objindex).newbie = 1 then _
                    call quitaruserinvitem(userindex, j, max_inventory_objs)
                    call updateuserinv(false, userindex, j)
        
        end if
next j

'[barrin 17-12-03] si el usuario dej� de ser newbie, y estaba en el newbie dungeon
'es transportado a su hogar de origen ;)
if ucase$(mapinfo(userlist(userindex).pos.map).restringir) = "newbie" then
    
    dim dedonde as worldpos
    
    select case userlist(userindex).hogar
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

end sub

sub limpiarinventario(byval userindex as integer)


dim j as integer
for j = 1 to max_inventory_slots
        userlist(userindex).invent.object(j).objindex = 0
        userlist(userindex).invent.object(j).amount = 0
        userlist(userindex).invent.object(j).equipped = 0
        
next

userlist(userindex).invent.nroitems = 0

userlist(userindex).invent.armoureqpobjindex = 0
userlist(userindex).invent.armoureqpslot = 0

userlist(userindex).invent.weaponeqpobjindex = 0
userlist(userindex).invent.weaponeqpslot = 0

userlist(userindex).invent.cascoeqpobjindex = 0
userlist(userindex).invent.cascoeqpslot = 0

userlist(userindex).invent.escudoeqpobjindex = 0
userlist(userindex).invent.escudoeqpslot = 0

userlist(userindex).invent.anilloeqpobjindex = 0
userlist(userindex).invent.anilloeqpslot = 0

userlist(userindex).invent.municioneqpobjindex = 0
userlist(userindex).invent.municioneqpslot = 0

userlist(userindex).invent.barcoobjindex = 0
userlist(userindex).invent.barcoslot = 0

end sub

sub tiraroro(byval cantidad as long, byval userindex as integer)
'***************************************************
'autor: unknown (orginal version)
'last modification: 23/01/2007
'23/01/2007 -> pablo (toxicwaste): billetera invertida y explotar oro en el agua.
'***************************************************
on error goto errhandler

'if cantidad > 100000 then exit sub

'si el pjta tiene oro lo tiramos
if (cantidad > 0) and (cantidad <= userlist(userindex).stats.gld) then
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
            m = userlist(userindex).pos.map
            for j = userlist(userindex).pos.x - 10 to userlist(userindex).pos.x + 10
                for k = userlist(userindex).pos.y - 10 to userlist(userindex).pos.y + 10
                    if inmapbounds(m, j, k) then
                        if mapdata(m, j, k).userindex > 0 then
                            cercanos = cercanos & userlist(mapdata(m, j, k).userindex).name & ","
                        end if
                    end if
                next k
            next j
            call logdesarrollo(userlist(userindex).name & " tira oro. cercanos: " & cercanos)
        end if
        '/seguridad
        dim extra as long
        dim teniaoro as long
        teniaoro = userlist(userindex).stats.gld
        if cantidad > 500000 then 'para evitar explotar demasiado
            extra = cantidad - 500000
            cantidad = 500000
        end if
        
        do while (cantidad > 0)
            
            if cantidad > max_inventory_objs and userlist(userindex).stats.gld > max_inventory_objs then
                miobj.amount = max_inventory_objs
                cantidad = cantidad - miobj.amount
            else
                miobj.amount = cantidad
                cantidad = cantidad - miobj.amount
            end if

            miobj.objindex = ioro
            
            if esgm(userindex) then call loggm(userlist(userindex).name, "tiro cantidad:" & miobj.amount & " objeto:" & objdata(miobj.objindex).name)
            dim auxpos as worldpos
            
            if userlist(userindex).clase = eclass.pirat and userlist(userindex).invent.barcoobjindex = 476 then
                auxpos = tiraritemalpiso(userlist(userindex).pos, miobj, false)
                if auxpos.x <> 0 and auxpos.y <> 0 then
                    userlist(userindex).stats.gld = userlist(userindex).stats.gld - miobj.amount
                end if
            else
                auxpos = tiraritemalpiso(userlist(userindex).pos, miobj, true)
                if auxpos.x <> 0 and auxpos.y <> 0 then
                    userlist(userindex).stats.gld = userlist(userindex).stats.gld - miobj.amount
                end if
            end if
            
            'info debug
            loops = loops + 1
            if loops > 100 then
                logerror ("error en tiraroro")
                exit sub
            end if
            
        loop
        if teniaoro = userlist(userindex).stats.gld then extra = 0
        if extra > 0 then
            userlist(userindex).stats.gld = userlist(userindex).stats.gld - extra
        end if
    
end if

exit sub

errhandler:

end sub

sub quitaruserinvitem(byval userindex as integer, byval slot as byte, byval cantidad as integer)

on error goto errhandler

    if slot < 1 or slot > max_inventory_slots then exit sub
    
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

on error goto errhandler

dim nullobj as userobj
dim loopc as long

'actualiza un solo slot
if not updateall then

    'actualiza el inventario
    if userlist(userindex).invent.object(slot).objindex > 0 then
        call changeuserinv(userindex, slot, userlist(userindex).invent.object(slot))
    else
        call changeuserinv(userindex, slot, nullobj)
    end if

else

'actualiza todos los slots
    for loopc = 1 to max_inventory_slots
        'actualiza el inventario
        if userlist(userindex).invent.object(loopc).objindex > 0 then
            call changeuserinv(userindex, loopc, userlist(userindex).invent.object(loopc))
        else
            call changeuserinv(userindex, loopc, nullobj)
        end if
    next loopc
end if

exit sub

errhandler:
    call logerror("error en updateuserinv. error " & err.number & " : " & err.description)

end sub

sub dropobj(byval userindex as integer, byval slot as byte, byval num as integer, byval map as integer, byval x as integer, byval y as integer)

dim obj as obj

if num > 0 then
  
  if num > userlist(userindex).invent.object(slot).amount then num = userlist(userindex).invent.object(slot).amount
  
  'check objeto en el suelo
  if mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex = 0 or mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex = userlist(userindex).invent.object(slot).objindex then
        obj.objindex = userlist(userindex).invent.object(slot).objindex
        
        if num + mapdata(userlist(userindex).pos.map, x, y).objinfo.amount > max_inventory_objs then
            num = max_inventory_objs - mapdata(userlist(userindex).pos.map, x, y).objinfo.amount
        end if
        
        obj.amount = num
        
        call makeobj(obj, map, x, y)
        call quitaruserinvitem(userindex, slot, num)
        call updateuserinv(false, userindex, slot)
        
        if objdata(obj.objindex).objtype = eobjtype.otbarcos then
            call writeconsolemsg(userindex, "��atencion!! �acabas de tirar tu barca!", fonttypenames.fonttype_talk)
        end if
        
        if not userlist(userindex).flags.privilegios and playertype.user then call loggm(userlist(userindex).name, "tiro cantidad:" & num & " objeto:" & objdata(obj.objindex).name)
        
        'log de objetos que se tiran al piso. pablo (toxicwaste) 07/09/07
        'es un objeto que tenemos que loguear?
        if objdata(obj.objindex).log = 1 then
            call logdesarrollo(userlist(userindex).name & " tir� al piso " & obj.amount & " " & objdata(obj.objindex).name & " mapa: " & map & " x: " & x & " y: " & y)
        elseif obj.amount > 5000 then 'es mucha cantidad? > sub� a 5000 el minimo porque si no se llenaba el log de cosas al pedo. (niconz)
        'si no es de los prohibidos de loguear, lo logueamos.
            if objdata(obj.objindex).nolog <> 1 then
                call logdesarrollo(userlist(userindex).name & " tir� al piso " & obj.amount & " " & objdata(obj.objindex).name & " mapa: " & map & " x: " & x & " y: " & y)
            end if
        end if
  else
    call writeconsolemsg(userindex, "no hay espacio en el piso.", fonttypenames.fonttype_info)
  end if
    
end if

end sub

sub eraseobj(byval num as integer, byval map as integer, byval x as integer, byval y as integer)

mapdata(map, x, y).objinfo.amount = mapdata(map, x, y).objinfo.amount - num

if mapdata(map, x, y).objinfo.amount <= 0 then
    mapdata(map, x, y).objinfo.objindex = 0
    mapdata(map, x, y).objinfo.amount = 0
    
    call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectdelete(x, y))
end if

end sub

sub makeobj(byref obj as obj, byval map as integer, byval x as integer, byval y as integer)

if obj.objindex > 0 and obj.objindex <= ubound(objdata) then

    if mapdata(map, x, y).objinfo.objindex = obj.objindex then
        mapdata(map, x, y).objinfo.amount = mapdata(map, x, y).objinfo.amount + obj.amount
    else
        mapdata(map, x, y).objinfo = obj
        
        call modsenddata.sendtoareabypos(map, x, y, preparemessageobjectcreate(objdata(obj.objindex).grhindex, x, y))
    end if
end if

end sub

function meteritemeninventario(byval userindex as integer, byref miobj as obj) as boolean
on error goto errhandler

'call logtarea("meteritemeninventario")
 
dim x as integer
dim y as integer
dim slot as byte

'�el user ya tiene un objeto del mismo tipo?
slot = 1
do until userlist(userindex).invent.object(slot).objindex = miobj.objindex and _
         userlist(userindex).invent.object(slot).amount + miobj.amount <= max_inventory_objs
   slot = slot + 1
   if slot > max_inventory_slots then
         exit do
   end if
loop
    
'sino busca un slot vacio
if slot > max_inventory_slots then
   slot = 1
   do until userlist(userindex).invent.object(slot).objindex = 0
       slot = slot + 1
       if slot > max_inventory_slots then
           call writeconsolemsg(userindex, "no podes cargar mas objetos.", fonttypenames.fonttype_fight)
           meteritemeninventario = false
           exit function
       end if
   loop
   userlist(userindex).invent.nroitems = userlist(userindex).invent.nroitems + 1
end if
    
'mete el objeto
if userlist(userindex).invent.object(slot).amount + miobj.amount <= max_inventory_objs then
   'menor que max_inv_objs
   userlist(userindex).invent.object(slot).objindex = miobj.objindex
   userlist(userindex).invent.object(slot).amount = userlist(userindex).invent.object(slot).amount + miobj.amount
else
   userlist(userindex).invent.object(slot).amount = max_inventory_objs
end if
    
meteritemeninventario = true
       
call updateuserinv(false, userindex, slot)


exit function
errhandler:

end function


sub getobj(byval userindex as integer)

dim obj as objdata
dim miobj as obj
dim objpos as string

'�hay algun obj?
if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).objinfo.objindex > 0 then
    '�esta permitido agarrar este obj?
    if objdata(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).objinfo.objindex).agarrable <> 1 then
        dim x as integer
        dim y as integer
        dim slot as byte
        
        x = userlist(userindex).pos.x
        y = userlist(userindex).pos.y
        obj = objdata(mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).objinfo.objindex)
        miobj.amount = mapdata(userlist(userindex).pos.map, x, y).objinfo.amount
        miobj.objindex = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
        
        if meteritemeninventario(userindex, miobj) then
            'quitamos el objeto
            call eraseobj(mapdata(userlist(userindex).pos.map, x, y).objinfo.amount, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
            if not userlist(userindex).flags.privilegios and playertype.user then call loggm(userlist(userindex).name, "agarro:" & miobj.amount & " objeto:" & objdata(miobj.objindex).name)
            
            'log de objetos que se agarran del piso. pablo (toxicwaste) 07/09/07
            'es un objeto que tenemos que loguear?
            if objdata(miobj.objindex).log = 1 then
                objpos = " mapa: " & userlist(userindex).pos.map & " x: " & userlist(userindex).pos.x & " y: " & userlist(userindex).pos.y
                call logdesarrollo(userlist(userindex).name & " junt� del piso " & miobj.amount & " " & objdata(miobj.objindex).name & objpos)
            elseif miobj.amount > max_inventory_objs - 1000 then 'es mucha cantidad?
                'si no es de los prohibidos de loguear, lo logueamos.
                if objdata(miobj.objindex).nolog <> 1 then
                    objpos = " mapa: " & userlist(userindex).pos.map & " x: " & userlist(userindex).pos.x & " y: " & userlist(userindex).pos.y
                    call logdesarrollo(userlist(userindex).name & " junt� del piso " & miobj.amount & " " & objdata(miobj.objindex).name & objpos)
                end if
            end if
        end if
        
    end if
else
    call writeconsolemsg(userindex, "no hay nada aqu�.", fonttypenames.fonttype_info)
end if

end sub

sub desequipar(byval userindex as integer, byval slot as byte)

on error goto errhandler

'desequipa el item slot del inventario
dim obj as objdata


if (slot < lbound(userlist(userindex).invent.object)) or (slot > ubound(userlist(userindex).invent.object)) then
    exit sub
elseif userlist(userindex).invent.object(slot).objindex = 0 then
    exit sub
end if

obj = objdata(userlist(userindex).invent.object(slot).objindex)

select case obj.objtype
    case eobjtype.otweapon
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.weaponeqpobjindex = 0
        userlist(userindex).invent.weaponeqpslot = 0
        if not userlist(userindex).flags.mimetizado = 1 then
            userlist(userindex).char.weaponanim = ningunarma
            call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
        end if
    
    case eobjtype.otflechas
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.municioneqpobjindex = 0
        userlist(userindex).invent.municioneqpslot = 0
    
    case eobjtype.otanillo
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.anilloeqpobjindex = 0
        userlist(userindex).invent.anilloeqpslot = 0
    
    case eobjtype.otarmadura
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.armoureqpobjindex = 0
        userlist(userindex).invent.armoureqpslot = 0
        call darcuerpodesnudo(userindex, userlist(userindex).flags.mimetizado = 1)
        call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            
    case eobjtype.otcasco
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.cascoeqpobjindex = 0
        userlist(userindex).invent.cascoeqpslot = 0
        if not userlist(userindex).flags.mimetizado = 1 then
            userlist(userindex).char.cascoanim = ninguncasco
            call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
        end if
    
    case eobjtype.otescudo
        userlist(userindex).invent.object(slot).equipped = 0
        userlist(userindex).invent.escudoeqpobjindex = 0
        userlist(userindex).invent.escudoeqpslot = 0
        if not userlist(userindex).flags.mimetizado = 1 then
            userlist(userindex).char.shieldanim = ningunescudo
            call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
        end if
end select

call writeupdateuserstats(userindex)
call updateuserinv(false, userindex, slot)

exit sub

errhandler:
    call logerror("error en desquipar. error " & err.number & " : " & err.description)

end sub

function sexopuedeusaritem(byval userindex as integer, byval objindex as integer) as boolean
on error goto errhandler

if objdata(objindex).mujer = 1 then
    sexopuedeusaritem = userlist(userindex).genero <> egenero.hombre
elseif objdata(objindex).hombre = 1 then
    sexopuedeusaritem = userlist(userindex).genero <> egenero.mujer
else
    sexopuedeusaritem = true
end if

exit function
errhandler:
    call logerror("sexopuedeusaritem")
end function


function faccionpuedeusaritem(byval userindex as integer, byval objindex as integer) as boolean

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

end function

sub equiparinvitem(byval userindex as integer, byval slot as byte)
'*************************************************
'author: unknown
'last modified: 01/08/2009
'01/08/2009: zama - now it's not sent any sound made by an invisible admin
'*************************************************

on error goto errhandler

'equipa un item del inventario
dim obj as objdata
dim objindex as integer

objindex = userlist(userindex).invent.object(slot).objindex
obj = objdata(objindex)

if obj.newbie = 1 and not esnewbie(userindex) then
     call writeconsolemsg(userindex, "solo los newbies pueden usar este objeto.", fonttypenames.fonttype_info)
     exit sub
end if
        
select case obj.objtype
    case eobjtype.otweapon
       if clasepuedeusaritem(userindex, objindex) and _
          faccionpuedeusaritem(userindex, objindex) then
            'si esta equipado lo quita
            if userlist(userindex).invent.object(slot).equipped then
                'quitamos del inv el item
                call desequipar(userindex, slot)
                'animacion por defecto
                if userlist(userindex).flags.mimetizado = 1 then
                    userlist(userindex).charmimetizado.weaponanim = ningunarma
                else
                    userlist(userindex).char.weaponanim = ningunarma
                    call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
                end if
                exit sub
            end if
            
            'quitamos el elemento anterior
            if userlist(userindex).invent.weaponeqpobjindex > 0 then
                call desequipar(userindex, userlist(userindex).invent.weaponeqpslot)
            end if
            
            userlist(userindex).invent.object(slot).equipped = 1
            userlist(userindex).invent.weaponeqpobjindex = userlist(userindex).invent.object(slot).objindex
            userlist(userindex).invent.weaponeqpslot = slot
            
            'el sonido solo se envia si no lo produce un admin invisible
            if not (userlist(userindex).flags.admininvisible = 1) then _
                call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_sacararma, userlist(userindex).pos.x, userlist(userindex).pos.y))
            
            if userlist(userindex).flags.mimetizado = 1 then
                userlist(userindex).charmimetizado.weaponanim = obj.weaponanim
            else
                userlist(userindex).char.weaponanim = obj.weaponanim
                call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            end if
       else
            call writeconsolemsg(userindex, "tu clase no puede usar este objeto.", fonttypenames.fonttype_info)
       end if
    
    case eobjtype.otanillo
       if clasepuedeusaritem(userindex, objindex) and _
          faccionpuedeusaritem(userindex, objindex) then
                'si esta equipado lo quita
                if userlist(userindex).invent.object(slot).equipped then
                    'quitamos del inv el item
                    call desequipar(userindex, slot)
                    exit sub
                end if
                
                'quitamos el elemento anterior
                if userlist(userindex).invent.anilloeqpobjindex > 0 then
                    call desequipar(userindex, userlist(userindex).invent.anilloeqpslot)
                end if
        
                userlist(userindex).invent.object(slot).equipped = 1
                userlist(userindex).invent.anilloeqpobjindex = objindex
                userlist(userindex).invent.anilloeqpslot = slot
                
       else
            call writeconsolemsg(userindex, "tu clase no puede usar este objeto.", fonttypenames.fonttype_info)
       end if
    
    case eobjtype.otflechas
       if clasepuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) and _
          faccionpuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) then
                
                'si esta equipado lo quita
                if userlist(userindex).invent.object(slot).equipped then
                    'quitamos del inv el item
                    call desequipar(userindex, slot)
                    exit sub
                end if
                
                'quitamos el elemento anterior
                if userlist(userindex).invent.municioneqpobjindex > 0 then
                    call desequipar(userindex, userlist(userindex).invent.municioneqpslot)
                end if
        
                userlist(userindex).invent.object(slot).equipped = 1
                userlist(userindex).invent.municioneqpobjindex = userlist(userindex).invent.object(slot).objindex
                userlist(userindex).invent.municioneqpslot = slot
                
       else
            call writeconsolemsg(userindex, "tu clase no puede usar este objeto.", fonttypenames.fonttype_info)
       end if
    
    case eobjtype.otarmadura
        if userlist(userindex).flags.navegando = 1 then exit sub
        'nos aseguramos que puede usarla
        if clasepuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) and _
           sexopuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) and _
           checkrazausaropa(userindex, userlist(userindex).invent.object(slot).objindex) and _
           faccionpuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) then
           
           'si esta equipado lo quita
            if userlist(userindex).invent.object(slot).equipped then
                call desequipar(userindex, slot)
                call darcuerpodesnudo(userindex, userlist(userindex).flags.mimetizado = 1)
                if not userlist(userindex).flags.mimetizado = 1 then
                    call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
                end if
                exit sub
            end if
    
            'quita el anterior
            if userlist(userindex).invent.armoureqpobjindex > 0 then
                call desequipar(userindex, userlist(userindex).invent.armoureqpslot)
            end if
    
            'lo equipa
            userlist(userindex).invent.object(slot).equipped = 1
            userlist(userindex).invent.armoureqpobjindex = userlist(userindex).invent.object(slot).objindex
            userlist(userindex).invent.armoureqpslot = slot
                
            if userlist(userindex).flags.mimetizado = 1 then
                userlist(userindex).charmimetizado.body = obj.ropaje
            else
                userlist(userindex).char.body = obj.ropaje
                call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            end if
            userlist(userindex).flags.desnudo = 0
            

        else
            call writeconsolemsg(userindex, "tu clase,genero o raza no puede usar este objeto.", fonttypenames.fonttype_info)
        end if
    
    case eobjtype.otcasco
        if userlist(userindex).flags.navegando = 1 then exit sub
        if clasepuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) then
            'si esta equipado lo quita
            if userlist(userindex).invent.object(slot).equipped then
                call desequipar(userindex, slot)
                if userlist(userindex).flags.mimetizado = 1 then
                    userlist(userindex).charmimetizado.cascoanim = ninguncasco
                else
                    userlist(userindex).char.cascoanim = ninguncasco
                    call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
                end if
                exit sub
            end if
    
            'quita el anterior
            if userlist(userindex).invent.cascoeqpobjindex > 0 then
                call desequipar(userindex, userlist(userindex).invent.cascoeqpslot)
            end if
    
            'lo equipa
            
            userlist(userindex).invent.object(slot).equipped = 1
            userlist(userindex).invent.cascoeqpobjindex = userlist(userindex).invent.object(slot).objindex
            userlist(userindex).invent.cascoeqpslot = slot
            if userlist(userindex).flags.mimetizado = 1 then
                userlist(userindex).charmimetizado.cascoanim = obj.cascoanim
            else
                userlist(userindex).char.cascoanim = obj.cascoanim
                call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            end if
        else
            call writeconsolemsg(userindex, "tu clase no puede usar este objeto.", fonttypenames.fonttype_info)
        end if
    
    case eobjtype.otescudo
        if userlist(userindex).flags.navegando = 1 then exit sub
         if clasepuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) and _
             faccionpuedeusaritem(userindex, userlist(userindex).invent.object(slot).objindex) then

             'si esta equipado lo quita
             if userlist(userindex).invent.object(slot).equipped then
                 call desequipar(userindex, slot)
                 if userlist(userindex).flags.mimetizado = 1 then
                     userlist(userindex).charmimetizado.shieldanim = ningunescudo
                 else
                     userlist(userindex).char.shieldanim = ningunescudo
                     call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
                 end if
                 exit sub
             end if
     
             'quita el anterior
             if userlist(userindex).invent.escudoeqpobjindex > 0 then
                 call desequipar(userindex, userlist(userindex).invent.escudoeqpslot)
             end if
     
             'lo equipa
             
             userlist(userindex).invent.object(slot).equipped = 1
             userlist(userindex).invent.escudoeqpobjindex = userlist(userindex).invent.object(slot).objindex
             userlist(userindex).invent.escudoeqpslot = slot
             
             if userlist(userindex).flags.mimetizado = 1 then
                 userlist(userindex).charmimetizado.shieldanim = obj.shieldanim
             else
                 userlist(userindex).char.shieldanim = obj.shieldanim
                 
                 call changeuserchar(userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
             end if
         else
             call writeconsolemsg(userindex, "tu clase no puede usar este objeto.", fonttypenames.fonttype_info)
         end if
end select

'actualiza
call updateuserinv(false, userindex, slot)

exit sub
errhandler:
call logerror("equiparinvitem slot:" & slot & " - error: " & err.number & " - error description : " & err.description)
end sub

private function checkrazausaropa(byval userindex as integer, itemindex as integer) as boolean
on error goto errhandler

'verifica si la raza puede usar la ropa
if userlist(userindex).raza = eraza.humano or _
   userlist(userindex).raza = eraza.elfo or _
   userlist(userindex).raza = eraza.drow then
        checkrazausaropa = (objdata(itemindex).razaenana = 0)
else
        checkrazausaropa = (objdata(itemindex).razaenana = 1)
end if

'solo se habilita la ropa exclusiva para drows por ahora. pablo (toxicwaste)
if (userlist(userindex).raza <> eraza.drow) and objdata(itemindex).razadrow then
    checkrazausaropa = false
end if

exit function
errhandler:
    call logerror("error checkrazausaropa itemindex:" & itemindex)

end function

sub useinvitem(byval userindex as integer, byval slot as byte)
'*************************************************
'author: unknown
'last modified: 01/08/2009
'handels the usage of items from inventory box.
'24/01/2007 pablo (toxicwaste) - agrego el cuerno de la armada y la legi�n.
'24/01/2007 pablo (toxicwaste) - utilizaci�n nueva de barco en lvl 20 por clase pirata y pescador.
'01/08/2009: zama - now it's not sent any sound made by an invisible admin, except to its own client
'*************************************************

dim obj as objdata
dim objindex as integer
dim targobj as objdata
dim miobj as obj

with userlist(userindex)

if .invent.object(slot).amount = 0 then exit sub

obj = objdata(.invent.object(slot).objindex)

if obj.newbie = 1 and not esnewbie(userindex) then
    call writeconsolemsg(userindex, "solo los newbies pueden usar estos objetos.", fonttypenames.fonttype_info)
    exit sub
end if

if obj.objtype = eobjtype.otweapon then
    if obj.proyectil = 1 then
        if not .flags.modocombate then
            call writeconsolemsg(userindex, "no est�s en modo de combate, presiona la tecla ""c"" para pasar al modo combate.", fonttypenames.fonttype_info)
            exit sub
        end if
        
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if not .stats.minsta > 0 then
            if .genero = egenero.hombre then
                call writeconsolemsg(userindex, "estas muy cansado", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "estas muy cansada", fonttypenames.fonttype_info)
            end if
            exit sub
        end if
        
        
        if objdata(objindex).proyectil = 1 then
            if .invent.object(slot).equipped = 0 then
                call writeconsolemsg(userindex, "antes de usar la herramienta deberias equipartela.", fonttypenames.fonttype_info)
                exit sub
            end if
            'liquid: muevo esto aca adentro, para que solo pida modo combate si estamos por usar el arco
            if not .flags.modocombate then
                call writeconsolemsg(userindex, "no est�s en modo de combate, presiona la tecla ""c"" para pasar al modo combate.", fonttypenames.fonttype_info)
                exit sub
            end if
            call writeworkrequesttarget(userindex, proyectiles)
        else
            if .flags.targetobj = le�a then
                if .invent.object(slot).objindex = daga then
                    if .invent.object(slot).equipped = 0 then
                        call writeconsolemsg(userindex, "antes de usar la herramienta deberias equipartela.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    call tratardehacerfogata(.flags.targetobjmap, _
                         .flags.targetobjx, .flags.targetobjy, userindex)
                end if
            end if
        end if

        
        select case objindex
            case ca�a_pesca, red_pesca
                call writeworkrequesttarget(userindex, eskill.pesca)
            case hacha_le�ador
                call writeworkrequesttarget(userindex, eskill.talar)
            case piquete_minero
                call writeworkrequesttarget(userindex, eskill.mineria)
            case martillo_herrero
                call writeworkrequesttarget(userindex, eskill.herreria)
            case serrucho_carpintero
                call enivarobjconstruibles(userindex)
                call writeshowcarpenterform(userindex)
        end select
        
    
    case eobjtype.otpociones
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
                  call writeconsolemsg(userindex, "no esta cerrada.", fonttypenames.fonttype_info)
                  exit sub
            end if
        end if
    
    case eobjtype.otbotellavacia
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
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
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if .stats.maxman > 0 then
            if .flags.hambre = 0 and _
                .flags.sed = 0 then
                call agregarhechizo(userindex, slot)
                call updateuserinv(false, userindex, slot)
            else
                call writeconsolemsg(userindex, "estas demasiado hambriento y sediento.", fonttypenames.fonttype_info)
            end if
        else
            call writeconsolemsg(userindex, "no tienes conocimientos de las artes arcanas.", fonttypenames.fonttype_info)
        end if
    case eobjtype.otminerales
        if .flags.muerto = 1 then
             call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
             exit sub
        end if
        call writeworkrequesttarget(userindex, fundirmetal)
       
    case eobjtype.otinstrumentos
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��estas muerto!! solo podes usar items cuando estas vivo. ", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if obj.real then '�es el cuerno real?
            if faccionpuedeusaritem(userindex, objindex) then
                if mapinfo(.pos.map).pk = false then
                    call writeconsolemsg(userindex, "no hay peligro aqu�. es zona segura ", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                ' los admin invisibles solo producen sonidos a si mismos
                if .flags.admininvisible = 1 then
                    call enviardatosaslot(userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                else
                    call senddata(sendtarget.tomap, .pos.map, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                end if
                
                exit sub
            else
                call writeconsolemsg(userindex, "solo miembros de la armada real pueden usar este cuerno.", fonttypenames.fonttype_info)
                exit sub
            end if
        elseif obj.caos then '�es el cuerno legi�n?
            if faccionpuedeusaritem(userindex, objindex) then
                if mapinfo(.pos.map).pk = false then
                    call writeconsolemsg(userindex, "no hay peligro aqu�. es zona segura ", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                ' los admin invisibles solo producen sonidos a si mismos
                if .flags.admininvisible = 1 then
                    call enviardatosaslot(userindex, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                else
                    call senddata(sendtarget.tomap, .pos.map, preparemessageplaywave(obj.snd1, .pos.x, .pos.y))
                end if
                
                exit sub
            else
                call writeconsolemsg(userindex, "solo miembros de la legi�n oscura pueden usar este cuerno.", fonttypenames.fonttype_info)
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
            if .clase <> eclass.fisher and .clase <> eclass.pirat then
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

call writeblacksmithweapons(userindex)

end sub
 
sub enivarobjconstruibles(byval userindex as integer)

call writecarpenterobjects(userindex)

end sub

sub enivararmadurasconstruibles(byval userindex as integer)

call writeblacksmitharmors(userindex)

end sub

sub tirartodo(byval userindex as integer)
on error resume next

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

call tirartodoslositems(userindex)

dim cantidad as long
cantidad = userlist(userindex).stats.gld - clng(userlist(userindex).stats.elv) * 10000

if cantidad > 0 then _
    call tiraroro(cantidad, userindex)

end sub

public function itemsecae(byval index as integer) as boolean

itemsecae = (objdata(index).real <> 1 or objdata(index).nosecae = 0) and _
            (objdata(index).caos <> 1 or objdata(index).nosecae = 0) and _
            objdata(index).objtype <> eobjtype.otllaves and _
            objdata(index).objtype <> eobjtype.otbarcos and _
            objdata(index).nosecae = 0


end function

sub tirartodoslositems(byval userindex as integer)
    dim i as byte
    dim nuevapos as worldpos
    dim miobj as obj
    dim itemindex as integer
    
    for i = 1 to max_inventory_slots
        itemindex = userlist(userindex).invent.object(i).objindex
        if itemindex > 0 then
             if itemsecae(itemindex) then
                nuevapos.x = 0
                nuevapos.y = 0
                
                'creo el obj
                miobj.amount = userlist(userindex).invent.object(i).amount
                miobj.objindex = itemindex
                'pablo (toxicwaste) 24/01/2007
                'si es pirata y usa un gale�n entonces no explota los items. (en el agua)
                if userlist(userindex).clase = eclass.pirat and userlist(userindex).invent.barcoobjindex = 476 then
                    tilelibre userlist(userindex).pos, nuevapos, miobj, false, true
                else
                    tilelibre userlist(userindex).pos, nuevapos, miobj, true, true
                end if
                
                if nuevapos.x <> 0 and nuevapos.y <> 0 then
                    call dropobj(userindex, i, max_inventory_objs, nuevapos.map, nuevapos.x, nuevapos.y)
                end if
             end if
        end if
    next i
end sub

function itemnewbie(byval itemindex as integer) as boolean

itemnewbie = objdata(itemindex).newbie = 1

end function

sub tirartodoslositemsnonewbies(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: 07/11/09
'07/11/09: pato - fix bug #2819911
'***************************************************
dim i as byte
dim nuevapos as worldpos
dim miobj as obj
dim itemindex as integer

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 6 then exit sub

for i = 1 to max_inventory_slots
    itemindex = userlist(userindex).invent.object(i).objindex
    if itemindex > 0 then
        if itemsecae(itemindex) and not itemnewbie(itemindex) then
            nuevapos.x = 0
            nuevapos.y = 0
            
            'creo miobj
            miobj.amount = userlist(userindex).invent.object(i).amount
            miobj.objindex = itemindex
            'pablo (toxicwaste) 24/01/2007
            'tira los items no newbies en todos lados.
            tilelibre userlist(userindex).pos, nuevapos, miobj, true, true
            if nuevapos.x <> 0 and nuevapos.y <> 0 then
                call dropobj(userindex, i, max_inventory_objs, nuevapos.map, nuevapos.x, nuevapos.y)
            end if
        end if
    end if
next i

end sub
