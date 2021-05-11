attribute vb_name = "matematicas"
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

public function porcentaje(byval total as long, byval porc as long) as long
    porcentaje = (total * porc) / 100
end function

function distancia(byref wp1 as worldpos, byref wp2 as worldpos) as long
    'encuentra la distancia entre dos worldpos
    distancia = abs(wp1.x - wp2.x) + abs(wp1.y - wp2.y) + (abs(wp1.map - wp2.map) * 100)
end function

function distance(byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer) as double

'encuentra la distancia entre dos puntos

distance = sqr(((y1 - y2) ^ 2 + (x1 - x2) ^ 2))

end function

public function randomnumber(byval lowerbound as long, byval upperbound as long) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'generates a random number in the range given - recoded to use longs and work properly with ranges
'**************************************************************
    randomnumber = fix(rnd * (upperbound - lowerbound + 1)) + lowerbound
end function
