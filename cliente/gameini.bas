attribute vb_name = "gameini"
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

public type tsetupmods
    bdinamic    as boolean
    bymemory    as byte
    busevideo   as boolean
    bnomusic    as boolean
    bnosound    as boolean
    bnores      as boolean ' 24/06/2006 - ^[gs]^
    bnosoundeffects as boolean
    sgraficos   as string * 13
end type

public clientsetup as tsetupmods

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

