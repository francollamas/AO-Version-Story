attribute vb_name = "modbinario"
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
'con ayuda de alejandro santos(alejolp)
'para la conversion a caracteres de n�meros

option explicit

public function bincbytes(byval numero as long) as integer
    if numero <= 255 then
        bincbytes = 1
    elseif numero <= 65534 then
        bincbytes = 2
    elseif numero <= 2147483647 then
        bincbytes = 4
    end if
end function

public function binbin2dec(byval strnum as string) as long
    dim i as integer
    for i = 1 to len(strnum)
        binbin2dec = cstr(cbyte(mid(strnum, i, 1)) * 2 ^ (len(strnum) - i)) + binbin2dec
    next i
end function

public function bindec2bin(byval num as long) as string
    dim i as integer: i = bincbytes(num)
    do
        bindec2bin = num mod 2 & bindec2bin
        num = num \ 2
    loop while not num = 0
    
    'relleno de 0
    for i = 0 to (i * 8) - 1 - len(bindec2bin)
        bindec2bin = "0" & bindec2bin
    next i
end function

public function binbin2asc(byval binnum as string) as string
    dim cbytes as integer, i as integer
    cbytes = len(binnum) / 8
    for i = 0 to cbytes - 1
        binbin2asc = binbin2asc & chr(binbin2dec(mid(binnum, i * 8 + 1, 8)))
    next i
end function

public function binasc2bin(byval ascnum as string) as string
    dim i as integer
    for i = 1 to len(ascnum)
        binasc2bin = binasc2bin & bindec2bin(asc(mid(ascnum, i, 1)))
    next i
end function

public function binasc2dec(byval ascnum as string) as long
    binasc2dec = binbin2dec(binasc2bin(ascnum))
end function

public function bindec2asc(byval numero as long, optional tipo as integer) as string
    bindec2asc = binbin2asc(bindec2bin(numero))
    
    dim i as integer
    select case tipo
        case vbinteger
            if len(bindec2asc) < 2 then for i = 1 to 2 - len(bindec2asc): bindec2asc = chr(0) & bindec2asc: next i
        case vblong
            if len(bindec2asc) < 4 then for i = 1 to 4 - len(bindec2asc): bindec2asc = chr(0) & bindec2asc: next i
    end select
end function

