attribute vb_name = "carteles"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

const xposcartel = 360
const yposcartel = 335
const maxlong = 40

'carteles
public cartel as boolean
public leyenda as string
public leyendaformateada() as string
public textura as integer


sub initcartel(ley as string, grh as integer)
if not cartel then
    leyenda = ley
    textura = grh
    cartel = true
    redim leyendaformateada(0 to (len(ley) \ (maxlong \ 2)))
                
    dim i as integer, k as integer, anti as integer
    anti = 1
    k = 0
    i = 0
    call darformato(leyenda, i, k, anti)
    i = 0
    do while leyendaformateada(i) <> "" and i < ubound(leyendaformateada)
        
       i = i + 1
    loop
    redim preserve leyendaformateada(0 to i)
else
    exit sub
end if
end sub


private function darformato(s as string, i as integer, k as integer, anti as integer)
if anti + i <= len(s) + 1 then
    if ((i >= maxlong) and mid$(s, anti + i, 1) = " ") or (anti + i = len(s)) then
        leyendaformateada(k) = mid(s, anti, i + 1)
        k = k + 1
        anti = anti + i + 1
        i = 0
    else
        i = i + 1
    end if
    call darformato(s, i, k, anti)
end if
end function


sub dibujarcartel()
if not cartel then exit sub
dim x as integer, y as integer
x = xposcartel + 20
y = yposcartel + 60
call ddrawtransgrhindextosurface(backbuffersurface, textura, xposcartel, yposcartel, 0, 0)
dim j as integer, desp as integer

for j = 0 to ubound(leyendaformateada)
dialogos.drawtext x, y + desp, leyendaformateada(j), vbwhite
  desp = desp + (frmmain.font.size) + 5
next
end sub

