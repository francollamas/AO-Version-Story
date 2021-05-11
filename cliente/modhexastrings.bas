attribute vb_name = "modhexastrings"
#if seguridadalkon then
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
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

'modulo realizado por gonzalo larralde(cdt) <gonzalolarralde@yahoo.com.ar>
'para la conversion a caracteres de cadenas md5 y de
'semi encriptaci�n de cadenas por ascii table offset

option explicit

public function hexmd52asc(byval md5 as string) as string
    dim i as long
    dim l as string
    
    if len(md5) and &h1 then md5 = "0" & md5
    
    for i = 1 to len(md5) \ 2
        l = mid$(md5, (2 * i) - 1, 2)
        hexmd52asc = hexmd52asc & chr$(hexhex2dec(l))
    next i
end function

public function hexhex2dec(byval hex as string) as long
    dim i as integer, l as string
    for i = 1 to len(hex)
        l = mid$(hex, i, 1)
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
    dim i as long
    dim l as string
    
    for i = 1 to len(text)
        l = mid$(text, i, 1)
        txtoffset = txtoffset & chr$((asc(l) + off) and &hff)
    next i
end function
#end if
