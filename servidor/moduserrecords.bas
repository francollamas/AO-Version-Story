attribute vb_name = "moduserrecords"
'argentum online 0.13.0
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

public sub loadrecords()
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'carga los seguimientos de usuarios.
'**************************************************************
dim reader as clsinimanager
dim tmpstr as string
dim i as long
dim j as long

    set reader = new clsinimanager
    
    if not fileexist(datpath & "records.dat") then
        call createrecordsfile
    end if
    
    call reader.initialize(datpath & "records.dat")

    numrecords = reader.getvalue("init", "numrecords")
    if numrecords then redim records(1 to numrecords)
    
    for i = 1 to numrecords
        with records(i)
            .usuario = reader.getvalue("record" & i, "usuario")
            .creador = reader.getvalue("record" & i, "creador")
            .fecha = reader.getvalue("record" & i, "fecha")
            .motivo = reader.getvalue("record" & i, "motivo")

            .numobs = val(reader.getvalue("record" & i, "numobs"))
            if .numobs then redim .obs(1 to .numobs)
            
            for j = 1 to .numobs
                tmpstr = reader.getvalue("record" & i, "obs" & j)
                
                .obs(j).creador = readfield(1, tmpstr, 45)
                .obs(j).fecha = readfield(2, tmpstr, 45)
                .obs(j).detalles = readfield(3, tmpstr, 45)
            next j
        end with
    next i
end sub

public sub saverecords()
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'guarda los seguimientos de usuarios.
'**************************************************************
dim writer as clsinimanager
dim tmpstr as string
dim i as long
dim j as long

    set writer = new clsinimanager

    call writer.changevalue("init", "numrecords", numrecords)
    
    for i = 1 to numrecords
        with records(i)
            call writer.changevalue("record" & i, "usuario", .usuario)
            call writer.changevalue("record" & i, "creador", .creador)
            call writer.changevalue("record" & i, "fecha", .fecha)
            call writer.changevalue("record" & i, "motivo", .motivo)
            
            call writer.changevalue("record" & i, "numobs", .numobs)
            
            for j = 1 to .numobs
                tmpstr = .obs(j).creador & "-" & .obs(j).fecha & "-" & .obs(j).detalles
                call writer.changevalue("record" & i, "obs" & j, tmpstr)
            next j
        end with
    next i
    
    call writer.dumpfile(datpath & "records.dat")
end sub

public sub addrecord(byval userindex as integer, byval nickname as string, byval reason as string)
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'agrega un seguimiento.
'**************************************************************
    numrecords = numrecords + 1
    redim preserve records(1 to numrecords)
    
    with records(numrecords)
        .usuario = ucase$(nickname)
        .fecha = format(now, "dd/mm/yyyy hh:mm:ss")
        .creador = ucase$(userlist(userindex).name)
        .motivo = reason
        .numobs = 0
    end with
end sub

public sub addobs(byval userindex as integer, byval recordindex as integer, byval obs as string)
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'agrega una observaci�n.
'**************************************************************
    with records(recordindex)
        .numobs = .numobs + 1
        redim preserve .obs(1 to .numobs)
        
        .obs(.numobs).creador = ucase$(userlist(userindex).name)
        .obs(.numobs).fecha = now
        .obs(.numobs).detalles = obs
    end with
end sub

public sub removerecord(byval recordindex as integer)
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'elimina un seguimiento.
'**************************************************************
dim i as long
    
    if recordindex = numrecords then
        numrecords = numrecords - 1
        if numrecords > 0 then
            redim preserve records(1 to numrecords)
        end if
    else
        numrecords = numrecords - 1
        for i = recordindex to numrecords
            records(i) = records(i + 1)
        next i

        redim preserve records(1 to numrecords)
    end if
end sub

public sub createrecordsfile()
'**************************************************************
'author: amraphen
'last modify date: 29/11/2010
'crea el archivo de seguimientos.
'**************************************************************
dim intfile as integer

    intfile = freefile
    
    open datpath & "records.dat" for output as #intfile
        print #intfile, "[init]"
        print #intfile, "numrecords=0"
    close #intfile
end sub
