attribute vb_name = "mdlcomercioconusuario"
'modulo para comerciar con otro usuario
'por alejo (alejandro santos)
'
'
'[alejo]

option explicit

public type tcomerciousuario
    destusu as integer 'el otro usuario
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
public sub iniciarcomercioconusuario(origen as integer, destino as integer)
on error goto errhandler

'si ambos pusieron /comerciar entonces
if userlist(origen).comusu.destusu = destino and _
   userlist(destino).comusu.destusu = origen then
    'actualiza el inventario del usuario
    call updateuserinv(true, origen, 0)
    'decirle al origen que abra la ventanita.
    call senddata(toindex, origen, 0, "initcomusu")
    userlist(origen).flags.comerciando = true

    'actualiza el inventario del usuario
    call updateuserinv(true, destino, 0)
    'decirle al origen que abra la ventanita.
    call senddata(toindex, destino, 0, "initcomusu")
    userlist(destino).flags.comerciando = true

    'call enviarobjetotransaccion(origen)
else
    'es el primero que comercia ?
    call senddata(toindex, destino, 0, "||" & userlist(origen).name & " desea comerciar. si deseas aceptar, escribe /comerciar." & fonttype_talk)
    userlist(destino).flags.targetuser = origen
    
end if

exit sub
errhandler:

end sub

'envia a aquien el objeto del otro
public sub enviarobjetotransaccion(aquien as integer)
'dim object as userobj
dim objind as integer
dim objcant as long

'[alejo]: en esta funcion se centralizaba el problema
'         de no poder comerciar con mas de 32k de oro.
'         ahora si funciona!!!

'object.amount = userlist(userlist(aquien).comusu.destusu).comusu.cant
objcant = userlist(userlist(aquien).comusu.destusu).comusu.cant
if userlist(userlist(aquien).comusu.destusu).comusu.objeto = flagoro then
    'object.objindex = ioro
    objind = ioro
else
    'object.objindex = userlist(userlist(aquien).comusu.destusu).invent.object(userlist(userlist(aquien).comusu.destusu).comusu.objeto).objindex
    objind = userlist(userlist(aquien).comusu.destusu).invent.object(userlist(userlist(aquien).comusu.destusu).comusu.objeto).objindex
end if

if objcant <= 0 or objind <= 0 then exit sub

'if object.objindex > 0 and object.amount > 0 then
'    call senddata(toindex, aquien, 0, "comusuinv" & 1 & "," & object.objindex & "," & objdata(object.objindex).name & "," & object.amount & "," & object.equipped & "," & objdata(object.objindex).grhindex & "," _
'    & objdata(object.objindex).objtype & "," _
'    & objdata(object.objindex).maxhit & "," _
'    & objdata(object.objindex).minhit & "," _
'    & objdata(object.objindex).maxdef & "," _
'    & objdata(object.objindex).valor \ 3)
'end if
if objind > 0 and objcant > 0 then
    call senddata(toindex, aquien, 0, "comusuinv" & 1 & "," & objind & "," & objdata(objind).name & "," & objcant & "," & 0 & "," & objdata(objind).grhindex & "," _
    & objdata(objind).objtype & "," _
    & objdata(objind).maxhit & "," _
    & objdata(objind).minhit & "," _
    & objdata(objind).maxdef & "," _
    & objdata(objind).valor \ 3)
end if

end sub

public sub fincomerciarusu(userindex as integer)
userlist(userindex).comusu.acepto = false
userlist(userindex).comusu.cant = 0
userlist(userindex).comusu.destusu = 0
userlist(userindex).comusu.objeto = 0

userlist(userindex).flags.comerciando = false

call senddata(toindex, userindex, 0, "fincomusuok")
end sub

public sub aceptarcomerciousu(userindex as integer)
if userlist(userindex).comusu.destusu <= 0 or _
    userlist(userlist(userindex).comusu.destusu).comusu.destusu <> userindex then
    exit sub
end if

userlist(userindex).comusu.acepto = true

if userlist(userlist(userindex).comusu.destusu).comusu.acepto = false then
    call senddata(toindex, userindex, 0, "||el otro usuario aun no ha aceptado tu oferta." & fonttype_talk)
    exit sub
end if

dim obj1 as obj, obj2 as obj
dim otrouserindex as integer
dim terminarahora as boolean

terminarahora = false
otrouserindex = userlist(userindex).comusu.destusu

'[alejo]: creo haber podido erradicar el bug de
'         no poder comerciar con mas de 32k de oro.
'         las lineas comentadas en los siguientes
'         2 grandes bloques if (4 lineas) son las
'         que originaban el problema.

if userlist(userindex).comusu.objeto = flagoro then
    'obj1.amount = userlist(userindex).comusu.cant
    obj1.objindex = ioro
    'if obj1.amount > userlist(userindex).stats.gld then
    if userlist(userindex).comusu.cant > userlist(userindex).stats.gld then
        call senddata(toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
        terminarahora = true
    end if
else
    obj1.amount = userlist(userindex).comusu.cant
    obj1.objindex = userlist(userindex).invent.object(userlist(userindex).comusu.objeto).objindex
    if obj1.amount > userlist(userindex).invent.object(userlist(userindex).comusu.objeto).amount then
        call senddata(toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
        terminarahora = true
    end if
end if
if userlist(otrouserindex).comusu.objeto = flagoro then
    'obj2.amount = userlist(otrouserindex).comusu.cant
    obj2.objindex = ioro
    'if obj2.amount > userlist(otrouserindex).stats.gld then
    if userlist(otrouserindex).comusu.cant > userlist(otrouserindex).stats.gld then
        call senddata(toindex, otrouserindex, 0, "||no tienes esa cantidad." & fonttype_talk)
        terminarahora = true
    end if
else
    obj2.amount = userlist(otrouserindex).comusu.cant
    obj2.objindex = userlist(otrouserindex).invent.object(userlist(otrouserindex).comusu.objeto).objindex
    if obj2.amount > userlist(otrouserindex).invent.object(userlist(otrouserindex).comusu.objeto).amount then
        call senddata(toindex, otrouserindex, 0, "||no tienes esa cantidad." & fonttype_talk)
        terminarahora = true
    end if
end if

'por si las moscas...
if terminarahora = true then
    call fincomerciarusu(userindex)
    call fincomerciarusu(otrouserindex)
    exit sub
end if

'[corregido]
'desde ac� correg� el bug que cuando se ofrecian mas de
'10k de oro no le llegaban al destinatario.

'pone el oro directamente en la billetera
if userlist(otrouserindex).comusu.objeto = flagoro then
    'quito la cantidad de oro ofrecida
    userlist(otrouserindex).stats.gld = userlist(otrouserindex).stats.gld - userlist(otrouserindex).comusu.cant
    call senduserstatsbox(otrouserindex)
    'y se la doy al otro
    userlist(userindex).stats.gld = userlist(userindex).stats.gld + userlist(otrouserindex).comusu.cant
    call senduserstatsbox(userindex)
else
    'quita el objeto y se lo da al otro
    if meteritemeninventario(userindex, obj2) = false then
        call tiraritemalpiso(userlist(userindex).pos, obj2)
    end if
    call quitarobjetos(obj2.objindex, obj2.amount, otrouserindex)
end if

'pone el oro directamente en la billetera
if userlist(userindex).comusu.objeto = flagoro then
    'quito la cantidad de oro ofrecida
    userlist(userindex).stats.gld = userlist(userindex).stats.gld - userlist(userindex).comusu.cant
    call senduserstatsbox(userindex)
    'y se la doy al otro
    userlist(otrouserindex).stats.gld = userlist(otrouserindex).stats.gld + userlist(userindex).comusu.cant
    call senduserstatsbox(otrouserindex)
else
    'quita el objeto y se lo da al otro
    if meteritemeninventario(otrouserindex, obj1) = false then
        call tiraritemalpiso(userlist(otrouserindex).pos, obj2)
    end if
    call quitarobjetos(obj1.objindex, obj1.amount, userindex)
end if

'[/corregido] :p

call updateuserinv(true, userindex, 0)
call updateuserinv(true, otrouserindex, 0)

call fincomerciarusu(userindex)
call fincomerciarusu(otrouserindex)
 
end sub

'[/alejo]

