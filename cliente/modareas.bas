attribute vb_name = "modareas"
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

'las guardamos para procesar los mps y sabes si borrar personajes
public minlimitex as integer
public maxlimitex as integer
public minlimitey as integer
public maxlimitey as integer

public sub cambiodearea(byval x as byte, byval y as byte)
    dim loopx as long, loopy as long
    
    minlimitex = (x \ 9 - 1) * 9
    maxlimitex = minlimitex + 26
    
    minlimitey = (y \ 9 - 1) * 9
    maxlimitey = minlimitey + 26
    
    for loopx = 1 to 100
        for loopy = 1 to 100
            
            if (loopy < minlimitey) or (loopy > maxlimitey) or (loopx < minlimitex) or (loopx > maxlimitex) then
                'erase npcs
                
                if mapdata(loopx, loopy).charindex > 0 then
                    if mapdata(loopx, loopy).charindex <> usercharindex then
                        call erasechar(mapdata(loopx, loopy).charindex)
                    end if
                end if
                
                'erase objs
                mapdata(loopx, loopy).objgrh.grhindex = 0
            end if
        next loopy
    next loopx
    
    call refreshallchars
end sub
