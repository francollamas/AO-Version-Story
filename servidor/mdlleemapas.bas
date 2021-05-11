attribute vb_name = "mdlleemapas"
'argentum online 0.11.20
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

'unsigned int dllimport mapcargamapa (const char *archmap, const char *archinf);
'unsigned int dllimport mapcierramapa(unsigned int dm);
'
'unsigned int dllimport mapleemapa(unsigned int dm, bloque *tile_map, bloque_inf *tile_inf );
'

public type tilemap
    bloqueado as byte
    grafs(1 to 4) as integer
    trigger as integer

    t1 as integer 'espacio al pedo
end type

public type tileinf
    dest_mapa as integer
    dest_x as integer
    dest_y as integer
    
    npc as integer
    
    obj_ind as integer
    obj_cant as integer
    
    t1 as integer
    t2 as integer
end type

'public declare function mapcargamapa lib "leemapas.dll" (byval archmap as string, byval archinf as string) as long
'public declare function mapcierramapa lib "leemapas.dll" (byval dm as long) as long
'
'public declare function mapleemapa lib "leemapas.dll" (byval dm as long, tile_map as tilemap, tile_inf as tileinf) as long

