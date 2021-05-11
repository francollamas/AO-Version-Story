attribute vb_name = "modinvisibles"
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
if encriptarprotocoloscriticos then
    call sendcrypteddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & "," & iif(estado, 1, 0))
else
    call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & "," & iif(estado, 1, 0))
end if

#else

dim estadoactual as boolean

' est� invisible ?
estadoactual = (userlist(userindex).flags.invisible = 1)

'if estadoactual <> modo then
    if modo = true then
        ' cuando se hace invisible se les envia a los
        ' clientes un borrar char
        userlist(userindex).flags.invisible = 1
'        'call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",1")
        call senddata(tomap, 0, userlist(userindex).pos.map, "bp" & userlist(userindex).char.charindex)
    else
        
    end if
'end if

#end if
end sub

