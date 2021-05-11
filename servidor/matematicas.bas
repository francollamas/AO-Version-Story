attribute vb_name = "matematicas"
'argentum online 0.9.0.2
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

public function porcentaje(byval total as long, byval porc as long) as long
    porcentaje = (total * porc) / 100
end function

public function sd(byval n as integer) as integer
'call logtarea("function sd n:" & n)
'suma digitos

do
    sd = sd + (n mod 10)
    n = n \ 10
loop while (n > 0)

end function

public function sdm(byval n as integer) as integer
'call logtarea("function sdm n:" & n)
'suma digitos cada digito menos dos

do
    sdm = sdm + (n mod 10) - 1
    n = n \ 10
loop while (n > 0)

end function

public function complex(byval n as integer) as integer
'call logtarea("complex")

if n mod 2 <> 0 then
    complex = n * sd(n)
else
    complex = n * sdm(n)
end if

end function

function distancia(byref wp1 as worldpos, byref wp2 as worldpos) as long
    'encuentra la distancia entre dos worldpos
    distancia = abs(wp1.x - wp2.x) + abs(wp1.y - wp2.y) + (abs(wp1.map - wp2.map) * 100)
end function

function distance(x1 as variant, y1 as variant, x2 as variant, y2 as variant) as double

'encuentra la distancia entre dos puntos

distance = sqr(((y1 - y2) ^ 2 + (x1 - x2) ^ 2))

end function

public function randomnumber(byval lowerbound as long, byval upperbound as long) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'generates a random number in the range given - recoded to use longs and work properly with ranges
'**************************************************************
    randomize timer
    
    randomnumber = fix(rnd * (upperbound - lowerbound + 1)) + lowerbound
end function
