attribute vb_name = "mod_lighting"
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

dim surface as ddsurfacedesc2
dim numredbits as integer
dim numgreenbits as integer
dim numbluebits as integer

'public sub getpixelformat()
'    dim format as ddpixelformat
'    dim logreenbit as integer
'    dim higreenbit as integer
'
'    backbuffersurface.getpixelformat format
'    logreenbit = lowbitpos(format.lgbitmask)
'    higreenbit = highbitpos(format.lgbitmask)
'    numgreenbits = (higreenbit - logreenbit) + 1
'
'    if numgreenbits = 5 then
'        numredbits = 10
'    else
'        numredbits = 11
'    end if
'end sub

