attribute vb_name = "mdlcomercioconusuario"
'**************************************************************
' mdlcomercioconusuarios.bas - allows players to commerce between themselves.
'
' designed and implemented by alejandro santos (alejolp)
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

'[alejo]
option explicit

private const max_oro_logueable as long = 50000
private const max_obj_logueable as long = 1000

public type tcomerciousuario
    destusu as integer 'el otro usuario
    destnick as string
    objeto as integer 'indice del inventario a comerciar, que objeto desea dar
    
    'el tipo de datos de cant ahora es long (antes integer)
    'asi se puede comerciar con oro > 32k
    '[corregido]
    cant as long 'cuantos comerciar, cuantos objetos desea dar
    '[/corregido]
    acepto as boolean
end type

'origen: origen de la transaccion, originador del comando
'destino: receptor de la transaccion
public sub iniciarcomercioconusuario(byval origen as integer, byval destino as integer)
on error goto errhandler

'si ambos pusieron /comerciar entonces
if userlist(origen).comusu.destusu = destino and _
   userlist(destino).comusu.destusu = origen then
    'actualiza el inventario del usuario
    call updateuserinv(true, origen, 0)
    'decirle al origen que abra la ventanita.
    call writeusercommerceinit(origen)
    userlist(origen).flags.comerciando = true

    'actualiza el inventario del usuario
    call updateuserinv(true, destino, 0)
    'decirle al origen que abra la ventanita.
    call writeusercommerceinit(destino)
    userlist(destino).flags.comerciando = true

    'call enviarobjetotransaccion(origen)
else
    'es el primero que comercia ?
    call writeconsolemsg(destino, userlist(origen).name & " desea comerciar. si deseas aceptar, escribe /comerciar.", fonttypenames.fonttype_talk)
    userlist(destino).flags.targetuser = origen
    
end if

call flushbuffer(destino)

exit sub
errhandler:
    call logerror("error en iniciarcomercioconusuario: " & err.description)
end sub

'envia a aquien el objeto del otro
public sub enviarobjetotransaccion(byval aquien as integer)
dim objind as integer
dim objcant as long

'[alejo]: en esta funcion se centralizaba el problema
'         de no poder comerciar con mas de 32k de oro.
'         ahora si funciona!!!

objcant = userlist(userlist(aquien).comusu.destusu).comusu.cant
if userlist(userlist(aquien).comusu.destusu).comusu.objeto = flagoro then
    objind = ioro
else
    objind = userlist(userlist(aquien).comusu.destusu).invent.object(userlist(userlist(aquien).comusu.destusu).comusu.objeto).objindex
end if

if objcant <= 0 or objind <= 0 then exit sub

if objind > 0 and objcant > 0 then
    call writechangeusertradeslot(aquien, objind, objcant)
    call flushbuffer(aquien)
end if

end sub

public sub fincomerciarusu(byval userindex as integer)
    with userlist(userindex)
        if .comusu.destusu > 0 then
            call writeusercommerceend(userindex)
        end if
        
        .comusu.acepto = false
        .comusu.cant = 0
        .comusu.destusu = 0
        .comusu.objeto = 0
        .comusu.destnick = vbnullstring
        .flags.comerciando = false
    end with
end sub

public sub aceptarcomerciousu(byval userindex as integer)
dim obj1 as obj, obj2 as obj
dim otrouserindex as integer
dim terminarahora as boolean

terminarahora = false

if userlist(userindex).comusu.destusu <= 0 or userlist(userindex).comusu.destusu > maxusers then
    terminarahora = true
end if

otrouserindex = userlist(userindex).comusu.destusu

if not terminarahora then
    if userlist(otrouserindex).flags.userlogged = false or userlist(userindex).flags.userlogged = false then
        terminarahora = true
    end if
end if

if not terminarahora then
    if userlist(otrouserindex).comusu.destusu <> userindex then
        terminarahora = true
    end if
end if

if not terminarahora then
    if userlist(otrouserindex).name <> userlist(userindex).comusu.destnick then
        terminarahora = true
    end if
end if

if not terminarahora then
    if userlist(userindex).name <> userlist(otrouserindex).comusu.destnick then
        terminarahora = true
    end if
end if

if terminarahora = true then
    call fincomerciarusu(userindex)
    
    if otrouserindex <= 0 or otrouserindex > maxusers then
        call fincomerciarusu(otrouserindex)
        call protocol.flushbuffer(otrouserindex)
    end if
    
    exit sub
end if

userlist(userindex).comusu.acepto = true
terminarahora = false

if userlist(otrouserindex).comusu.acepto = false then
    call writeconsolemsg(userindex, "el otro usuario aun no ha aceptado tu oferta.", fonttypenames.fonttype_talk)
    exit sub
end if

if userlist(userindex).comusu.objeto = flagoro then
    obj1.objindex = ioro
    if userlist(userindex).comusu.cant > userlist(userindex).stats.gld then
        call writeconsolemsg(userindex, "no tienes esa cantidad.", fonttypenames.fonttype_talk)
        terminarahora = true
    end if
else
    obj1.amount = userlist(userindex).comusu.cant
    obj1.objindex = userlist(userindex).invent.object(userlist(userindex).comusu.objeto).objindex
    if obj1.amount > userlist(userindex).invent.object(userlist(userindex).comusu.objeto).amount then
        call writeconsolemsg(userindex, "no tienes esa cantidad.", fonttypenames.fonttype_talk)
        terminarahora = true
    end if
end if

if userlist(otrouserindex).comusu.objeto = flagoro then
    obj2.objindex = ioro
    if userlist(otrouserindex).comusu.cant > userlist(otrouserindex).stats.gld then
        call writeconsolemsg(otrouserindex, "no tienes esa cantidad.", fonttypenames.fonttype_talk)
        terminarahora = true
    end if
else
    obj2.amount = userlist(otrouserindex).comusu.cant
    obj2.objindex = userlist(otrouserindex).invent.object(userlist(otrouserindex).comusu.objeto).objindex
    if obj2.amount > userlist(otrouserindex).invent.object(userlist(otrouserindex).comusu.objeto).amount then
        call writeconsolemsg(otrouserindex, "no tienes esa cantidad.", fonttypenames.fonttype_talk)
        terminarahora = true
    end if
end if

'por si las moscas...
if terminarahora = true then
    call fincomerciarusu(userindex)
    
    call fincomerciarusu(otrouserindex)
    call flushbuffer(otrouserindex)
    exit sub
end if

call flushbuffer(otrouserindex)

'[corregido]
'desde ac� correg� el bug que cuando se ofrecian mas de
'10k de oro no le llegaban al destinatario.

'pone el oro directamente en la billetera
if userlist(otrouserindex).comusu.objeto = flagoro then
    'quito la cantidad de oro ofrecida
    userlist(otrouserindex).stats.gld = userlist(otrouserindex).stats.gld - userlist(otrouserindex).comusu.cant
    if userlist(otrouserindex).comusu.cant > max_oro_logueable then call logdesarrollo(userlist(otrouserindex).name & " solto oro en comercio seguro con " & userlist(userindex).name & ". cantidad: " & userlist(otrouserindex).comusu.cant)
    call writeupdateuserstats(otrouserindex)
    'y se la doy al otro
    userlist(userindex).stats.gld = userlist(userindex).stats.gld + userlist(otrouserindex).comusu.cant
    if userlist(otrouserindex).comusu.cant > max_oro_logueable then call logdesarrollo(userlist(userindex).name & " recibio oro en comercio seguro con " & userlist(otrouserindex).name & ". cantidad: " & userlist(otrouserindex).comusu.cant)
    'esta linea del log es al pedo. > vuelvo a ponerla a pedido del cgms
    call writeupdateuserstats(userindex)
else
    'quita el objeto y se lo da al otro
    if meteritemeninventario(userindex, obj2) = false then
        call tiraritemalpiso(userlist(userindex).pos, obj2)
    end if
    call quitarobjetos(obj2.objindex, obj2.amount, otrouserindex)
    
    'es un objeto que tenemos que loguear? pablo (toxicwaste) 07/09/07
    if objdata(obj2.objindex).log = 1 then
        call logdesarrollo(userlist(otrouserindex).name & " le pas� en comercio seguro a " & userlist(userindex).name & " " & obj2.amount & " " & objdata(obj2.objindex).name)
    end if
    'es mucha cantidad?
    if obj2.amount > max_obj_logueable then
    'si no es de los prohibidos de loguear, lo logueamos.
        if objdata(obj2.objindex).nolog <> 1 then
            call logdesarrollo(userlist(otrouserindex).name & " le pas� en comercio seguro a " & userlist(userindex).name & " " & obj2.amount & " " & objdata(obj2.objindex).name)
        end if
    end if
end if

'pone el oro directamente en la billetera
if userlist(userindex).comusu.objeto = flagoro then
    'quito la cantidad de oro ofrecida
    userlist(userindex).stats.gld = userlist(userindex).stats.gld - userlist(userindex).comusu.cant
    if userlist(userindex).comusu.cant > max_oro_logueable then call logdesarrollo(userlist(userindex).name & " solt� oro en comercio seguro con " & userlist(otrouserindex).name & ". cantidad: " & userlist(userindex).comusu.cant)
    call writeupdateuserstats(userindex)
    'y se la doy al otro
    userlist(otrouserindex).stats.gld = userlist(otrouserindex).stats.gld + userlist(userindex).comusu.cant
    'if userlist(userindex).comusu.cant > max_oro_logueable then call logdesarrollo(userlist(otrouserindex).name & " recibio oro en comercio seguro con " & userlist(userindex).name & ". cantidad: " & userlist(userindex).comusu.cant)
    'esta linea del log es al pedo.
    call writeupdateuserstats(otrouserindex)
else
    'quita el objeto y se lo da al otro
    if meteritemeninventario(otrouserindex, obj1) = false then
        call tiraritemalpiso(userlist(otrouserindex).pos, obj1)
    end if
    call quitarobjetos(obj1.objindex, obj1.amount, userindex)
    
    'es un objeto que tenemos que loguear? pablo (toxicwaste) 07/09/07
    if objdata(obj1.objindex).log = 1 then
        call logdesarrollo(userlist(userindex).name & " le pas� en comercio seguro a " & userlist(otrouserindex).name & " " & obj1.amount & " " & objdata(obj1.objindex).name)
    end if
    'es mucha cantidad?
    if obj1.amount > max_obj_logueable then
    'si no es de los prohibidos de loguear, lo logueamos.
        if objdata(obj1.objindex).nolog <> 1 then
            call logdesarrollo(userlist(otrouserindex).name & " le pas� en comercio seguro a " & userlist(userindex).name & " " & obj1.amount & " " & objdata(obj1.objindex).name)
        end if
    end if
    
end if

'[/corregido] :p

call updateuserinv(true, userindex, 0)
call updateuserinv(true, otrouserindex, 0)

call fincomerciarusu(userindex)
call fincomerciarusu(otrouserindex)
 
end sub

'[/alejo]
