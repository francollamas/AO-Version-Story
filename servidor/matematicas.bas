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

sub addtovar(byref var as variant, byval addon as variant, byval max as variant)
'le suma un valor a una variable respetando el maximo valor

if var >= max then
    var = max
else
    var = var + addon
    if var > max then
        var = max
    end if
end if

end sub


public function porcentaje(byval total as long, byval porc as long) as long
porcentaje = (total * porc) / 100
end function

public function sd(byval n as integer) as integer
'call logtarea("function sd n:" & n)
'suma digitos
dim auxint as integer
dim digit as integer
dim suma as integer

auxint = n

do
    
    digit = (auxint mod 10)
    suma = suma + digit
    auxint = auxint \ 10
    
loop while (auxint > 0)

sd = suma

end function

public function sdm(byval n as integer) as integer
'call logtarea("function sdm n:" & n)
'suma digitos cada digito menos dos
dim auxint as integer
dim digit as integer
dim suma as integer

auxint = n
'if auxint < 0 then auxint = abs(auxint)

do
    
    digit = (auxint mod 10)
    digit = digit - 1
    suma = suma + digit
    auxint = auxint \ 10
    
   
loop while (auxint > 0)

sdm = suma

end function

public function complex(byval n as integer) as integer
'call logtarea("complex")

if n mod 2 <> 0 then
    complex = n * sd(n)
else
    complex = n * sdm(n)
end if

end function

function distancia(wp1 as worldpos, wp2 as worldpos)

'encuentra la distancia entre dos worldpos

distancia = abs(wp1.x - wp2.x) + abs(wp1.y - wp2.y) + (abs(wp1.map - wp2.map) * 100)

end function

function distance(x1 as variant, y1 as variant, x2 as variant, y2 as variant) as double

'encuentra la distancia entre dos puntos

distance = sqr(((y1 - y2) ^ 2 + (x1 - x2) ^ 2))

end function

function randomnumber(byval lowerbound as variant, byval upperbound as variant) as single

randomize timer

randomnumber = (upperbound - lowerbound + 1) * rnd + lowerbound
if randomnumber > upperbound then randomnumber = upperbound

end function

