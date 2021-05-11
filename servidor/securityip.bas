attribute vb_name = "securityip"
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


'**************************************************************
' general_ipsecurity.bas - maneja la seguridad de las ips
'
' escrito y dise�ado por dunga (ltourrilhes@gmail.com)
'**************************************************************
option explicit

'*************************************************  *************
' general_ipsecurity.bas - maneja la seguridad de las ips
'
' escrito y dise�ado por dunga (ltourrilhes@gmail.com)
'*************************************************  *************

private iptables()      as long 'usamos 2 longs: uno de la ip, seguido de uno de la info
private entryscounter   as long
private maxvalue        as long
private multiplicado    as long 'cuantas veces multiplike el entryscounter para que me entren?
private const intervaloentreconexiones as long = 5000

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'declaraciones para maximas conexiones por usuario
'agregado por el oso
private maxcontables()      as long
private maxcontablesentry   as long     'puntero a la ultima insertada

private const limiteconexionesxip as long = 10

private enum e_securityiptabla
    ip_intervalos = 1
    ip_limiteconexiones = 2
end enum

public sub initiptables(byval optcountersvalue as long)
'*************************************************  *************
'author: lucio n. tourrilhes (dunga)
'last modify date: el oso 21/01/06. soporte para maxcontables
'
'*************************************************  *************
    entryscounter = optcountersvalue
    multiplicado = 1

    redim iptables(entryscounter * 2 - 1) as long
    maxvalue = 0

    redim maxcontables(declaraciones.maxusers * 2 - 1) as long
    maxcontablesentry = 0

end sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''funciones para intervalos'''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

public sub ipsecuritymantenimientolista()
'*************************************************  *************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'*************************************************  *************
    'las borro todas cada 1 hora, asi se "renuevan"
    entryscounter = entryscounter \ multiplicado
    multiplicado = 1
    redim iptables(entryscounter * 2 - 1) as long
    maxvalue = 0
end sub

public function ipsecurityaceptarnuevaconexion(byval ip as long) as boolean
'*************************************************  *************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'*************************************************  *************
dim iptableindex as long
    

    iptableindex = findtableip(ip, ip_intervalos)
    
    if iptableindex >= 0 then
        if iptables(iptableindex + 1) + intervaloentreconexiones <= gettickcount then   'no est� saturando de connects?
            iptables(iptableindex + 1) = gettickcount
            ipsecurityaceptarnuevaconexion = true
            debug.print "conexion aceptada"
            exit function
        else
            ipsecurityaceptarnuevaconexion = false

            debug.print "conexion no aceptada"
            exit function
        end if
    else
        iptableindex = not iptableindex
        addnewipintervalo ip, iptableindex
        iptables(iptableindex + 1) = gettickcount
        ipsecurityaceptarnuevaconexion = true
        exit function
    end if

end function


private sub addnewipintervalo(byval ip as long, byval index as long)
'*************************************************  *************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'*************************************************  *************
    '2) pruebo si hay espacio, sino agrando la lista
    if maxvalue + 1 > entryscounter then
        entryscounter = entryscounter \ multiplicado
        multiplicado = multiplicado + 1
        entryscounter = entryscounter * multiplicado
        
        redim preserve iptables(entryscounter * 2 - 1) as long
    end if
    
    '4) corro todo el array para arriba
    call copymemory(iptables(index + 2), iptables(index), (maxvalue - index \ 2) * 8)   '*4 (peso del long) * 2(cantidad de elementos por c/u)
    iptables(index) = ip
    
    '3) subo el indicador de el maximo valor almacenado y listo :)
    maxvalue = maxvalue + 1
end sub

' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' ''''''''''''''''''''funciones para limites x ip''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

public function ipsecuritysuperalimiteconexiones(byval ip as long) as boolean
dim iptableindex as long

    iptableindex = findtableip(ip, ip_limiteconexiones)
    
    if iptableindex >= 0 then
        
        if maxcontables(iptableindex + 1) < limiteconexionesxip then
            logip ("agregamos conexion a " & ip & " iptableindex=" & iptableindex & ". conexiones: " & maxcontables(iptableindex + 1))
            debug.print "suma conexion a " & ip & " total " & maxcontables(iptableindex + 1) + 1
            maxcontables(iptableindex + 1) = maxcontables(iptableindex + 1) + 1
            ipsecuritysuperalimiteconexiones = false
        else
            logip ("rechazamos conexion de " & ip & " iptableindex=" & iptableindex & ". conexiones: " & maxcontables(iptableindex + 1))
            debug.print "rechaza conexion a " & ip
            ipsecuritysuperalimiteconexiones = true
        end if
    else
        ipsecuritysuperalimiteconexiones = false
        if maxcontablesentry < declaraciones.maxusers then  'si hay espacio..
            iptableindex = not iptableindex
            addnewiplimiteconexiones ip, iptableindex    'iptableindex es donde lo agrego
            maxcontables(iptableindex + 1) = 1
        else
            call logcriticevent("securityip.ipsecuritysuperalimiteconexiones: se supero la disponibilidad de slots.")
        end if
    end if

end function

private sub addnewiplimiteconexiones(byval ip as long, byval index as long)
'*************************************************  *************
'author: (el oso)
'last modify date: 16/2/2006
'05/21/10 - pato: saco el uso de buffer auxiliar
'*************************************************  *************
    'debug.print "agrega conexion a " & ip
    'debug.print "(declaraciones.maxusers - index) = " & (declaraciones.maxusers - index)
    '4) corro todo el array para arriba
    call copymemory(maxcontables(index + 2), maxcontables(index), (maxcontablesentry - index \ 2) * 8)    '*4 (peso del long) * 2(cantidad de elementos por c/u)
    maxcontables(index) = ip

    '3) subo el indicador de el maximo valor almacenado y listo :)
    maxcontablesentry = maxcontablesentry + 1
end sub

public sub iprestarconexion(byval ip as long)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

dim key as long
    'debug.print "resta conexion a " & ip
    
    key = findtableip(ip, ip_limiteconexiones)
    
    if key >= 0 then
        if maxcontables(key + 1) > 0 then
            maxcontables(key + 1) = maxcontables(key + 1) - 1
        end if
        'call logip("restamos conexion a " & ip & " key=" & key & ". conexiones: " & maxcontables(key + 1))
        'comento esto, sino se nos va el hd en logs, jaja
        if maxcontables(key + 1) <= 0 then
            'la limpiamos
            maxcontablesentry = maxcontablesentry - 1
            
            if key + 2 < ubound(maxcontables) then
                call copymemory(maxcontables(key), maxcontables(key + 2), (maxcontablesentry - (key \ 2)) * 8)
            end if
        end if
    else 'key < 0
        call logip("restamos conexion a " & ip & " key=" & key & ". negativo!!")
        'logcriticevent "securityip.iprestarconexion obtuvo un valor negativo en key"
    end if
    
    exit sub

errhandler:
    call logerror("error en iprestarconexion. error: " & err.number & " - " & err.description & ". ip: " & getascip(ip) & " key:" & key)
end sub



' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' ''''''''''''''''''''''''funciones generales''''''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


private function findtableip(byval ip as long, byval tabla as e_securityiptabla) as long
'*************************************************  *************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'modified by juan mart�n sotuyo dodero (maraxus) to use binary insertion
'*************************************************  *************
dim first as long
dim last as long
dim middle as long
    
    select case tabla
        case e_securityiptabla.ip_intervalos
            first = 0
            last = maxvalue - 1
            do while first <= last
                middle = (first + last) \ 2
                
                if (iptables(middle * 2) < ip) then
                    first = middle + 1
                elseif (iptables(middle * 2) > ip) then
                    last = middle - 1
                else
                    findtableip = middle * 2
                    exit function
                end if
            loop
            findtableip = not (first * 2)
        
        case e_securityiptabla.ip_limiteconexiones
            
            first = 0
            last = maxcontablesentry - 1

            do while first <= last
                middle = (first + last) \ 2

                if maxcontables(middle * 2) < ip then
                    first = middle + 1
                elseif maxcontables(middle * 2) > ip then
                    last = middle - 1
                else
                    findtableip = middle * 2
                    exit function
                end if
            loop
            findtableip = not (first * 2)
    end select
end function

public function dumptables()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i as integer

    for i = 0 to maxcontablesentry * 2 - 1 step 2
        call logcriticevent(getascip(maxcontables(i)) & " > " & maxcontables(i + 1))
    next i

end function
