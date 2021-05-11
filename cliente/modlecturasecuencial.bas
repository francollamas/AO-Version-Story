attribute vb_name = "modlecturasecuencial"
'argentum online 0.9.0.4
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
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

'modulo realizado por gonzalo larralde(cdt) <gonzalolarralde@yahoo.com.ar>
'para la lectura secuencial de una cadena

option explicit

private type tleccadena
    leccadena as string
    lecposicion as integer
end type

private leclecturasecuencial() as tleccadena, leciniciado as boolean

public function leccambiarcadena(cadena as string) as integer
    if not leciniciado then redim leclecturasecuencial(0): leciniciado = true
    
    leccambiarcadena = leccadenalibre
    
    leclecturasecuencial(leccambiarcadena).leccadena = cadena
    leclecturasecuencial(leccambiarcadena).lecposicion = 1
end function

public function lecleer(cadena as integer, optional initpos as integer, optional longitud as integer) as string
    if not leciniciado then redim leclecturasecuencial(0): leciniciado = true
    
    if cadena > ubound(leclecturasecuencial) or leclecturasecuencial(cadena).leccadena = "" then lecleer = -1: exit function
    if initpos > 0 and initpos < len(leclecturasecuencial(cadena).leccadena) then leclecturasecuencial(cadena).lecposicion = initpos
    if leclecturasecuencial(cadena).lecposicion + longitud = len(leclecturasecuencial(cadena).leccadena) + 2 then lecleer = -1: exit function
    if longitud = 0 then longitud = len(leclecturasecuencial(cadena).leccadena) - leclecturasecuencial(cadena).lecposicion
    
    lecleer = mid$(leclecturasecuencial(cadena).leccadena, leclecturasecuencial(cadena).lecposicion, longitud)
    leclecturasecuencial(cadena).lecposicion = leclecturasecuencial(cadena).lecposicion + longitud
end function

public function leccerrarcadena(cadena as integer) as boolean
    if not leciniciado then redim leclecturasecuencial(0): leciniciado = true
    
    if cadena > ubound(leclecturasecuencial) then leccerrarcadena = false: exit function
    if cadena = ubound(leclecturasecuencial) then redim preserve leclecturasecuencial(ubound(leclecturasecuencial) - 1): exit function
    leclecturasecuencial(cadena).leccadena = ""
    leclecturasecuencial(cadena).lecposicion = 0
end function

private function leccadenalibre() as integer
    dim i as integer
    for i = 1 to ubound(leclecturasecuencial)
        if leclecturasecuencial(i).leccadena = "" then
            leccadenalibre = i
            exit function
        end if
    next i
    leccadenalibre = ubound(leclecturasecuencial) + 1
    redim preserve leclecturasecuencial(leccadenalibre)
end function


