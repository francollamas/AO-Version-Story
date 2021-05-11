attribute vb_name = "modnuevotimer"
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
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

'
' las siguientes funciones devuelven true o false si el intervalo
' permite hacerlo. si devuelve true, setean automaticamente el
' timer para que no se pueda hacer la accion hasta el nuevo ciclo.
'

' casting de hechizos
public function intervalopermitelanzarspell(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerlanzarspell >= intervalouserpuedecastear then
    if actualizar then
        userlist(userindex).counters.timerlanzarspell = tactual
    end if
    intervalopermitelanzarspell = true
else
    intervalopermitelanzarspell = false
end if

end function

public function intervalopermiteatacar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timerpuedeatacar >= intervalouserpuedeatacar then
    if actualizar then
        userlist(userindex).counters.timerpuedeatacar = tactual
        userlist(userindex).counters.timergolpeusar = tactual
    end if
    intervalopermiteatacar = true
else
    intervalopermiteatacar = false
end if
end function

public function intervalopermitegolpeusar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: zama
'checks if the time that passed from the last hit is enough for the user to use a potion.
'last modification: 06/04/2009
'***************************************************

dim tactual as long

tactual = gettickcount() and &h7fffffff

if tactual - userlist(userindex).counters.timergolpeusar >= intervalogolpeusar then
    if actualizar then
        userlist(userindex).counters.timergolpeusar = tactual
    end if
    intervalopermitegolpeusar = true
else
    intervalopermitegolpeusar = false
end if
end function

public function intervalopermitemagiagolpe(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************
    dim tactual as long
    
    with userlist(userindex)
        if .counters.timermagiagolpe > .counters.timerlanzarspell then
            exit function
        end if
        
        tactual = gettickcount() and &h7fffffff
        
        if tactual - .counters.timerlanzarspell >= intervalomagiagolpe then
            if actualizar then
                .counters.timermagiagolpe = tactual
                .counters.timerpuedeatacar = tactual
                .counters.timergolpeusar = tactual
            end if
            intervalopermitemagiagolpe = true
        else
            intervalopermitemagiagolpe = false
        end if
    end with
end function

public function intervalopermitegolpemagia(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim tactual as long
    
    if userlist(userindex).counters.timergolpemagia > userlist(userindex).counters.timerpuedeatacar then
        exit function
    end if
    
    tactual = gettickcount() and &h7fffffff
    
    if tactual - userlist(userindex).counters.timerpuedeatacar >= intervalogolpemagia then
        if actualizar then
            userlist(userindex).counters.timergolpemagia = tactual
            userlist(userindex).counters.timerlanzarspell = tactual
        end if
        intervalopermitegolpemagia = true
    else
        intervalopermitegolpemagia = false
    end if
end function

' ataque cuerpo a cuerpo
'public function intervalopermiteatacar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'dim tactual as long
'
'tactual = gettickcount() and &h7fffffff''
'
'if tactual - userlist(userindex).counters.timerpuedeatacar >= intervalouserpuedeatacar then
'    if actualizar then userlist(userindex).counters.timerpuedeatacar = tactual
'    intervalopermiteatacar = true
'else
'    intervalopermiteatacar = false
'end if
'end function

' trabajo
public function intervalopermitetrabajar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    if tactual - userlist(userindex).counters.timerpuedetrabajar >= intervalouserpuedetrabajar then
        if actualizar then userlist(userindex).counters.timerpuedetrabajar = tactual
        intervalopermitetrabajar = true
    else
        intervalopermitetrabajar = false
    end if
end function

' usar objetos
public function intervalopermiteusar(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: 25/01/2010 (zama)
'25/01/2010: zama - general adjustments.
'***************************************************

    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    if tactual - userlist(userindex).counters.timerusar >= intervalouserpuedeusar then
        if actualizar then
            userlist(userindex).counters.timerusar = tactual
            'userlist(userindex).counters.failedusageattempts = 0
        end if
        intervalopermiteusar = true
    else
        intervalopermiteusar = false
        
        'userlist(userindex).counters.failedusageattempts = userlist(userindex).counters.failedusageattempts + 1
        
        'tolerancia arbitraria - 20 es muy alta, la est� chiteando zarpado
        'if userlist(userindex).counters.failedusageattempts = 20 then
            'call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(userlist(userindex).name & " kicked by the server por posible modificaci�n de intervalos.", fonttypenames.fonttype_fight))
            'call closesocket(userindex)
        'end if
    end if

end function

public function intervalopermiteusararcos(byval userindex as integer, optional byval actualizar as boolean = true) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    if tactual - userlist(userindex).counters.timerpuedeusararco >= intervaloflechascazadores then
        if actualizar then userlist(userindex).counters.timerpuedeusararco = tactual
        intervalopermiteusararcos = true
    else
        intervalopermiteusararcos = false
    end if

end function

public function intervalopermiteseratacado(byval userindex as integer, optional byval actualizar as boolean = false) as boolean
'**************************************************************
'author: zama
'last modify by: zama
'last modify date: 13/11/2009
'13/11/2009: zama - add the timer which determines wether the user can be atacked by a npc or not
'**************************************************************
    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    with userlist(userindex)
        ' inicializa el timer
        if actualizar then
            .counters.timerpuedeseratacado = tactual
            .flags.nopuedeseratacado = true
            intervalopermiteseratacado = false
        else
            if tactual - .counters.timerpuedeseratacado >= intervalopuedeseratacado then
                .flags.nopuedeseratacado = false
                intervalopermiteseratacado = true
            else
                intervalopermiteseratacado = false
            end if
        end if
    end with

end function

public function intervaloperdionpc(byval userindex as integer, optional byval actualizar as boolean = false) as boolean
'**************************************************************
'author: zama
'last modify by: zama
'last modify date: 13/11/2009
'13/11/2009: zama - add the timer which determines wether the user still owns a npc or not
'**************************************************************
    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    with userlist(userindex)
        ' inicializa el timer
        if actualizar then
            .counters.timerpertenecenpc = tactual
            intervaloperdionpc = false
        else
            if tactual - .counters.timerpertenecenpc >= intervaloownednpc then
                intervaloperdionpc = true
            else
                intervaloperdionpc = false
            end if
        end if
    end with

end function

public function intervaloestadoatacable(byval userindex as integer, optional byval actualizar as boolean = false) as boolean
'**************************************************************
'author: zama
'last modify by: zama
'last modify date: 13/01/2010
'13/01/2010: zama - add the timer which determines wether the user can be atacked by an user or not
'**************************************************************
    dim tactual as long
    
    tactual = gettickcount() and &h7fffffff
    
    with userlist(userindex)
        ' inicializa el timer
        if actualizar then
            .counters.timerestadoatacable = tactual
            intervaloestadoatacable = true
        else
            if tactual - .counters.timerestadoatacable >= intervaloatacable then
                intervaloestadoatacable = false
            else
                intervaloestadoatacable = true
            end if
        end if
    end with

end function
