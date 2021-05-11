attribute vb_name = "modnuevotimer"
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

'
' las siguientes funciones devuelven true o false si el intervalo
' permite hacerlo. si devuelve true, setean automaticamente el
' timer para que no se pueda hacer la accion hasta el nuevo ciclo.
'

' casting de hechizos
public function intervalopermitelanzarspell(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerlanzarspell >= 40 * intervalouserpuedecastear then
    if actualizar then userlist(userindex).counters.timerlanzarspell = tactual
    intervalopermitelanzarspell = true
else
    intervalopermitelanzarspell = false
end if

end function


public function intervalopermiteatacar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerpuedeatacar >= 40 * intervalouserpuedeatacar then
    if actualizar then userlist(userindex).counters.timerpuedeatacar = tactual
    intervalopermiteatacar = true
else
    intervalopermiteatacar = false
end if
end function


' ataque cuerpo a cuerpo
'public function intervalopermiteatacar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'dim tactual as long
'
'tactual = gettickcount() and &h7fffffff''
'
'if tactual - userlist(userindex).counters.timerpuedeatacar >= 40 * intervalouserpuedeatacar then
'    if actualizar then userlist(userindex).counters.timerpuedeatacar = tactual
'    intervalopermiteatacar = true
'else
'    intervalopermiteatacar = false
'end if
'end function

' trabajo
public function intervalopermitetrabajar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerpuedetrabajar >= 40 * intervalouserpuedetrabajar then
    if actualizar then userlist(userindex).counters.timerpuedetrabajar = tactual
    intervalopermitetrabajar = true
else
    intervalopermitetrabajar = false
end if
end function

' usar objetos
public function intervalopermiteusar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerusar >= intervalouserpuedeusar then
    if actualizar then userlist(userindex).counters.timerusar = tactual
    intervalopermiteusar = true
else
    intervalopermiteusar = false
end if

end function

public function intervalopermiteusararcos(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerusar >= intervaloflechascazadores then
    if actualizar then userlist(userindex).counters.timerusar = tactual
    intervalopermiteusararcos = true
else
    intervalopermiteusararcos = false
end if

end function


