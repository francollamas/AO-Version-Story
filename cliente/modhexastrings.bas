attribute vb_name = "modhexastrings"
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
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

public function hexmd52asc(byval md5 as string) as string
    dim i as integer, l as string
    
    md5 = ucase$(md5)
    if len(md5) mod 2 = 1 then md5 = "0" & md5
    
    for i = 1 to len(md5) \ 2
        l = mid(md5, (2 * i) - 1, 2)
        hexmd52asc = hexmd52asc & chr(hexhex2dec(l))
    next i
end function

public function hexhex2dec(byval hex as string) as long
    dim i as integer, l as string
    for i = 1 to len(hex)
        l = mid(hex, i, 1)
        select case l
            case "a": l = 10
            case "b": l = 11
            case "c": l = 12
            case "d": l = 13
            case "e": l = 14
            case "f": l = 15
        end select
        
        hexhex2dec = (l * 16 ^ ((len(hex) - i))) + hexhex2dec
    next i
end function

public function txtoffset(byval text as string, byval off as integer) as string
    dim i as integer, l as string
    for i = 1 to len(text)
        l = mid(text, i, 1)
        txtoffset = txtoffset & chr((asc(l) + off) mod 256)
    next i
end function
