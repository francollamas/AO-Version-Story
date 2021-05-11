attribute vb_name = "gameini"
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

public type tcabecera 'cabecera de los con
    desc as string * 255
    crc as long
    magicword as long
end type

public type tgameini
    puerto as long
    musica as byte
    fx as byte
    tip as byte
    password as string
    name as string
    dirgraficos as string
    dirsonidos as string
    dirmusica as string
    dirmapas as string
    numerodebmps as long
    numeromapas as integer
end type

'[code 005]:matux
    public type trendermods
        sname      as string * 7
        busevideo  as long
        bnocostas  as long
        busemmx    as long
        bnoalpha   as long
        bnotscan   as long
        bnomusic   as long
        bnosound   as long
        iimagesize as long
    end type

    public rendermod as trendermods
'[end]'

public micabecera as tcabecera
public config_inicio as tgameini

public sub iniciarcabecera(byref cabecera as tcabecera)
cabecera.desc = "argentum online by noland studios. copyright noland-studios 2001, pablomarquez@noland-studios.com.ar"
cabecera.crc = rnd * 100
cabecera.magicword = rnd * 10
end sub

public function leergameini() as tgameini
dim n as integer
dim gameini as tgameini
n = freefile
open app.path & "\init\inicio.con" for binary as #n
get #n, , micabecera

get #n, , gameini

close #n
leergameini = gameini
end function

public sub escribirgameini(byref gameiniconfiguration as tgameini)
on local error resume next

dim n as integer
n = freefile
open app.path & "\init\inicio.con" for binary as #n
put #n, , micabecera
put #n, , gameiniconfiguration
close #n
end sub

