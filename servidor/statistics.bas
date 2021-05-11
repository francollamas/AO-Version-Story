attribute vb_name = "statistics"
'**************************************************************
' modstatistics.bas - takes statistics on the game for later study.
'
' implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@gmail.com)
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

private type trainningdata
    starttick as long
    trainningtime as long
end type

private type fraglvlrace
    matrix(1 to 50, 1 to 5) as long
end type

private type fraglvllvl
    matrix(1 to 50, 1 to 50) as long
end type

private trainninginfo() as trainningdata

private fraglvlracedata(1 to 7) as fraglvlrace
private fraglvllvldata(1 to 7) as fraglvllvl
private fragalignmentlvldata(1 to 50, 1 to 4) as long

'currency just in case.... chats are way too often...
private keyocurrencies(255) as currency

public sub initialize()
    redim trainninginfo(1 to maxusers) as trainningdata
end sub

public sub userconnected(byval userindex as integer)
    'a new user connected, load it's trainning time count
    trainninginfo(userindex).trainningtime = val(getvar(charpath & ucase$(userlist(userindex).name) & ".chr", "research", "trainningtime", 30))
    
    trainninginfo(userindex).starttick = (gettickcount() and &h7fffffff)
end sub

public sub userdisconnected(byval userindex as integer)
    with trainninginfo(userindex)
        'update trainning time
        .trainningtime = .trainningtime + ((gettickcount() and &h7fffffff) - .starttick) / 1000
        
        .starttick = (gettickcount() and &h7fffffff)
        
        'store info in char file
        call writevar(charpath & ucase$(userlist(userindex).name) & ".chr", "research", "trainningtime", cstr(.trainningtime))
    end with
end sub

public sub userlevelup(byval userindex as integer)
    dim handle as integer
    handle = freefile()
    
    with trainninginfo(userindex)
        'log the data
        open app.path & "\logs\statistics.log" for append shared as handle
        
        print #handle, ucase$(userlist(userindex).name) & " complet� el nivel " & cstr(userlist(userindex).stats.elv) & " en " & cstr(.trainningtime + ((gettickcount() and &h7fffffff) - .starttick) / 1000) & " segundos."
        
        close handle
        
        'reset data
        .trainningtime = 0
        .starttick = (gettickcount() and &h7fffffff)
    end with
end sub

public sub storefrag(byval killer as integer, byval victim as integer)
    dim clase as integer
    dim raza as integer
    dim alignment as integer
    
    if userlist(victim).stats.elv > 50 or userlist(killer).stats.elv > 50 then exit sub
    
    select case userlist(killer).clase
        case eclass.assasin
            clase = 1
        
        case eclass.bard
            clase = 2
        
        case eclass.mage
            clase = 3
        
        case eclass.paladin
            clase = 4
        
        case eclass.warrior
            clase = 5
        
        case eclass.cleric
            clase = 6
        
        case eclass.hunter
            clase = 7
        
        case else
            exit sub
    end select
    
    select case userlist(killer).raza
        case eraza.elfo
            raza = 1
        
        case eraza.drow
            raza = 2
        
        case eraza.enano
            raza = 3
        
        case eraza.gnomo
            raza = 4
        
        case eraza.humano
            raza = 5
        
        case else
            exit sub
    end select
    
    if userlist(killer).faccion.armadareal then
        alignment = 1
    elseif userlist(killer).faccion.fuerzascaos then
        alignment = 2
    elseif criminal(killer) then
        alignment = 3
    else
        alignment = 4
    end if
    
    fraglvlracedata(clase).matrix(userlist(killer).stats.elv, raza) = fraglvlracedata(clase).matrix(userlist(killer).stats.elv, raza) + 1
    
    fraglvllvldata(clase).matrix(userlist(killer).stats.elv, userlist(victim).stats.elv) = fraglvllvldata(clase).matrix(userlist(killer).stats.elv, userlist(victim).stats.elv) + 1
    
    fragalignmentlvldata(userlist(killer).stats.elv, alignment) = fragalignmentlvldata(userlist(killer).stats.elv, alignment) + 1
end sub

public sub dumpstatistics()
    dim handle as integer
    handle = freefile()
    
    dim line as string
    dim i as long
    dim j as long
    
    open app.path & "\logs\frags.txt" for output as handle
    
    'save lvl vs lvl frag matrix for each class - we use gnu octave's ascii file format
    
    print #handle, "# name: fraglvllvl_ase"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(1).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_bar"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(2).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_mag"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(3).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_pal"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(4).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_gue"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(5).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_cle"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(6).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvllvl_caz"
    print #handle, "# type: matrix"
    print #handle, "# rows: 50"
    print #handle, "# columns: 50"
    
    for j = 1 to 50
        for i = 1 to 50
            line = line & " " & cstr(fraglvllvldata(7).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    
    
    
    
    'save lvl vs race frag matrix for each class - we use gnu octave's ascii file format
    
    print #handle, "# name: fraglvlrace_ase"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(1).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_bar"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(2).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_mag"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(3).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_pal"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(4).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_gue"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(5).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_cle"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(6).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlrace_caz"
    print #handle, "# type: matrix"
    print #handle, "# rows: 5"
    print #handle, "# columns: 50"
    
    for j = 1 to 5
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(7).matrix(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    
    
    
    
    
    'save lvl vs class frag matrix for each race - we use gnu octave's ascii file format
    
    print #handle, "# name: fraglvlclass_elf"
    print #handle, "# type: matrix"
    print #handle, "# rows: 7"
    print #handle, "# columns: 50"
    
    for j = 1 to 7
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(j).matrix(i, 1))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlclass_dar"
    print #handle, "# type: matrix"
    print #handle, "# rows: 7"
    print #handle, "# columns: 50"
    
    for j = 1 to 7
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(j).matrix(i, 2))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlclass_dwa"
    print #handle, "# type: matrix"
    print #handle, "# rows: 7"
    print #handle, "# columns: 50"
    
    for j = 1 to 7
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(j).matrix(i, 3))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlclass_gno"
    print #handle, "# type: matrix"
    print #handle, "# rows: 7"
    print #handle, "# columns: 50"
    
    for j = 1 to 7
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(j).matrix(i, 4))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    print #handle, "# name: fraglvlclass_hum"
    print #handle, "# type: matrix"
    print #handle, "# rows: 7"
    print #handle, "# columns: 50"
    
    for j = 1 to 7
        for i = 1 to 50
            line = line & " " & cstr(fraglvlracedata(j).matrix(i, 5))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    
    
    
    'save lvl vs alignment frag matrix for each race - we use gnu octave's ascii file format
    
    print #handle, "# name: fragalignmentlvl"
    print #handle, "# type: matrix"
    print #handle, "# rows: 4"
    print #handle, "# columns: 50"
    
    for j = 1 to 4
        for i = 1 to 50
            line = line & " " & cstr(fragalignmentlvldata(i, j))
        next i
        
        print #handle, line
        line = vbnullstring
    next j
    
    close handle
    
    
    
    'dump chat statistics
    handle = freefile()
    
    open app.path & "\logs\huffman.log" for output as handle
    
    dim total as currency
    
    'compute total characters
    for i = 0 to 255
        total = total + keyocurrencies(i)
    next i
    
    'show each character's ocurrencies
    if total <> 0 then
        for i = 0 to 255
            print #handle, cstr(i) & "    " & cstr(round(keyocurrencies(i) / total, 8))
        next i
    end if
    
    print #handle, "total =    " & cstr(total)
    
    close handle
end sub

public sub parsechat(byref s as string)
    dim i as long
    dim key as integer
    
    for i = 1 to len(s)
        key = asc(mid$(s, i, 1))
        
        keyocurrencies(key) = keyocurrencies(key) + 1
    next i
    
    'add a null-terminated to consider that possibility too....
    keyocurrencies(0) = keyocurrencies(0) + 1
end sub
