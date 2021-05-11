attribute vb_name = "modinvisibles"
option explicit

' 0 = viejo
' 1 = nuevo
#const modo_invisibilidad = 0

' cambia el estado de invisibilidad a 1 o 0 dependiendo del modo: true o false
'
public sub ponerinvisible(byval userindex as integer, byval estado as boolean)
#if modo_invisibilidad = 0 then

userlist(userindex).flags.invisible = iif(estado, 1, 0)
userlist(userindex).flags.oculto = iif(estado, 1, 0)
userlist(userindex).counters.invisibilidad = 0

call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, not estado))


#else

dim estadoactual as boolean

' est� invisible ?
estadoactual = (userlist(userindex).flags.invisible = 1)

'if estadoactual <> modo then
    if modo = true then
        ' cuando se hace invisible se les envia a los
        ' clientes un borrar char
        userlist(userindex).flags.invisible = 1
'        'call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",1")
        call senddata(sendtarget.tomap, userlist(userindex).pos.map, preparemessagecharacterremove(userlist(userindex).char.charindex))
    else
        
    end if
'end if

#end if
end sub

