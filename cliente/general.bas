attribute vb_name = "mod_general"
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

public iplst as string

public bfogata as boolean

public blluvia() as byte ' array para determinar si
'debemos mostrar la animacion de la lluvia

private lframetimer as long

public function dirgraficos() as string
    dirgraficos = app.path & "\" & config_inicio.dirgraficos & "\"
end function

public function dirsound() as string
    dirsound = app.path & "\" & config_inicio.dirsonidos & "\"
end function

public function dirmidi() as string
    dirmidi = app.path & "\" & config_inicio.dirmusica & "\"
end function

public function dirmapas() as string
    dirmapas = app.path & "\" & config_inicio.dirmapas & "\"
end function

public function dirextras() as string
    dirextras = app.path & "\extras\"
end function

public function randomnumber(byval lowerbound as long, byval upperbound as long) as long
    'initialize randomizer
    randomize timer
    
    'generate random number
    randomnumber = (upperbound - lowerbound) * rnd + lowerbound
end function

public function getrawname(byref sname as string) as string
'***************************************************
'author: zama
'last modify date: 13/01/2010
'last modified by: -
'returns the char name without the clan name (if it has it).
'***************************************************

    dim pos as integer
    
    pos = instr(1, sname, "<")
    
    if pos > 0 then
        getrawname = trim(left(sname, pos - 1))
    else
        getrawname = sname
    end if

end function

sub cargaranimarmas()
on error resume next

    dim loopc as long
    dim arch as string
    
    arch = app.path & "\init\" & "armas.dat"
    
    numweaponanims = val(getvar(arch, "init", "numarmas"))
    
    redim weaponanimdata(1 to numweaponanims) as weaponanimdata
    
    for loopc = 1 to numweaponanims
        initgrh weaponanimdata(loopc).weaponwalk(1), val(getvar(arch, "arma" & loopc, "dir1")), 0
        initgrh weaponanimdata(loopc).weaponwalk(2), val(getvar(arch, "arma" & loopc, "dir2")), 0
        initgrh weaponanimdata(loopc).weaponwalk(3), val(getvar(arch, "arma" & loopc, "dir3")), 0
        initgrh weaponanimdata(loopc).weaponwalk(4), val(getvar(arch, "arma" & loopc, "dir4")), 0
    next loopc
end sub

sub cargarcolores()
on error resume next
    dim archivoc as string
    
    archivoc = app.path & "\init\colores.dat"
    
    if not fileexist(archivoc, vbarchive) then
'todo : si hay que reinstalar, porque no cierra???
        call msgbox("error: no se ha podido cargar los colores. falta el archivo colores.dat, reinstale el juego", vbcritical + vbokonly)
        exit sub
    end if
    
    dim i as long
    
    for i = 0 to 48 '49 y 50 reservados para ciudadano y criminal
        colorespj(i).r = cbyte(getvar(archivoc, cstr(i), "r"))
        colorespj(i).g = cbyte(getvar(archivoc, cstr(i), "g"))
        colorespj(i).b = cbyte(getvar(archivoc, cstr(i), "b"))
    next i
    
    ' crimi
    colorespj(50).r = cbyte(getvar(archivoc, "cr", "r"))
    colorespj(50).g = cbyte(getvar(archivoc, "cr", "g"))
    colorespj(50).b = cbyte(getvar(archivoc, "cr", "b"))
    
    ' ciuda
    colorespj(49).r = cbyte(getvar(archivoc, "ci", "r"))
    colorespj(49).g = cbyte(getvar(archivoc, "ci", "g"))
    colorespj(49).b = cbyte(getvar(archivoc, "ci", "b"))
    
    ' atacable
    colorespj(48).r = cbyte(getvar(archivoc, "at", "r"))
    colorespj(48).g = cbyte(getvar(archivoc, "at", "g"))
    colorespj(48).b = cbyte(getvar(archivoc, "at", "b"))
end sub

#if seguridadalkon then
sub initmi()
    dim alternativos as integer
    dim cualmitemp as integer
    
    alternativos = randomnumber(1, 7368)
    
    do
        cualmitemp = randomnumber(1, 1233)
    loop while cualmitemp = cualmi

    set mi(cualmitemp) = new clsmanagerinvisibles
    call mi(cualmitemp).inicializar(alternativos, 10000)
    
    if cualmi <> 0 then
        call mi(cualmitemp).copyfrom(mi(cualmi))
        set mi(cualmi) = nothing
    end if
    cualmi = cualmitemp
end sub
#end if

sub cargaranimescudos()
on error resume next

    dim loopc as long
    dim arch as string
    
    arch = app.path & "\init\" & "escudos.dat"
    
    numescudosanims = val(getvar(arch, "init", "numescudos"))
    
    redim shieldanimdata(1 to numescudosanims) as shieldanimdata
    
    for loopc = 1 to numescudosanims
        initgrh shieldanimdata(loopc).shieldwalk(1), val(getvar(arch, "esc" & loopc, "dir1")), 0
        initgrh shieldanimdata(loopc).shieldwalk(2), val(getvar(arch, "esc" & loopc, "dir2")), 0
        initgrh shieldanimdata(loopc).shieldwalk(3), val(getvar(arch, "esc" & loopc, "dir3")), 0
        initgrh shieldanimdata(loopc).shieldwalk(4), val(getvar(arch, "esc" & loopc, "dir4")), 0
    next loopc
end sub

sub addtorichtextbox(byref richtextbox as richtextbox, byval text as string, optional byval red as integer = -1, optional byval green as integer, optional byval blue as integer, optional byval bold as boolean = false, optional byval italic as boolean = false, optional byval bcrlf as boolean = true)
'******************************************
'adds text to a richtext box at the bottom.
'automatically scrolls to new text.
'text box must be multiline and have a 3d
'apperance!
'pablo (toxicwaste) 01/26/2007 : now the list refeshes properly.
'juan mart�n sotuyo dodero (maraxus) 03/29/2007 : replaced toxicwaste's code for extra performance.
'******************************************r
    with richtextbox
        if len(.text) > 1000 then
            'get rid of first line
            .selstart = instr(1, .text, vbcrlf) + 1
            .sellength = len(.text) - .selstart + 2
            .textrtf = .selrtf
        end if
        
        .selstart = len(.text)
        .sellength = 0
        .selbold = bold
        .selitalic = italic
        
        if not red = -1 then .selcolor = rgb(red, green, blue)
        
        if bcrlf and len(.text) > 0 then text = vbcrlf & text
        .seltext = text
        
        richtextbox.refresh
    end with
end sub

'todo : never was sure this is really necessary....
'todo : 08/03/2006 - (alejolp) esto hay que volarlo...
public sub refreshallchars()
'*****************************************************************
'goes through the charlist and replots all the characters on the map
'used to make sure everyone is visible
'*****************************************************************
    dim loopc as long
    
    for loopc = 1 to lastchar
        if charlist(loopc).active = 1 then
            mapdata(charlist(loopc).pos.x, charlist(loopc).pos.y).charindex = loopc
        end if
    next loopc
end sub

sub savegameini()
    'grabamos los datos del usuario en el game.ini
    config_inicio.name = "betatester"
    config_inicio.password = "dammlamers"
    config_inicio.puerto = userport
    
    call escribirgameini(config_inicio)
end sub

function asciivalidos(byval cad as string) as boolean
    dim car as byte
    dim i as long
    
    cad = lcase$(cad)
    
    for i = 1 to len(cad)
        car = asc(mid$(cad, i, 1))
        
        if ((car < 97 or car > 122) or car = asc("�")) and (car <> 255) and (car <> 32) then
            exit function
        end if
    next i
    
    asciivalidos = true
end function

function checkuserdata(byval checkemail as boolean) as boolean
    'validamos los datos del user
    dim loopc as long
    dim charascii as integer
    
    if checkemail and useremail = "" then
        msgbox ("direcci�n de email invalida")
        exit function
    end if
    
    if userpassword = "" then
        msgbox ("ingrese un password.")
        exit function
    end if
    
    for loopc = 1 to len(userpassword)
        charascii = asc(mid$(userpassword, loopc, 1))
        if not legalcharacter(charascii) then
            msgbox ("password inv�lido. el caract�r " & chr$(charascii) & " no est� permitido.")
            exit function
        end if
    next loopc
    
    if username = "" then
        msgbox ("ingrese un nombre de personaje.")
        exit function
    end if
    
    if len(username) > 30 then
        msgbox ("el nombre debe tener menos de 30 letras.")
        exit function
    end if
    
    for loopc = 1 to len(username)
        charascii = asc(mid$(username, loopc, 1))
        if not legalcharacter(charascii) then
            msgbox ("nombre inv�lido. el caract�r " & chr$(charascii) & " no est� permitido.")
            exit function
        end if
    next loopc
    
    checkuserdata = true
end function

sub unloadallforms()
on error resume next

#if seguridadalkon then
    call unprotectform
#end if

    dim mifrm as form
    
    for each mifrm in forms
        unload mifrm
    next
end sub

function legalcharacter(byval keyascii as integer) as boolean
'*****************************************************************
'only allow characters that are win 95 filename compatible
'*****************************************************************
    'if backspace allow
    if keyascii = 8 then
        legalcharacter = true
        exit function
    end if
    
    'only allow space, numbers, letters and special characters
    if keyascii < 32 or keyascii = 44 then
        exit function
    end if
    
    if keyascii > 126 then
        exit function
    end if
    
    'check for bad special characters in between
    if keyascii = 34 or keyascii = 42 or keyascii = 47 or keyascii = 58 or keyascii = 60 or keyascii = 62 or keyascii = 63 or keyascii = 92 or keyascii = 124 then
        exit function
    end if
    
    'else everything is cool
    legalcharacter = true
end function

sub setconnected()
'*****************************************************************
'sets the client to "connect" mode
'*****************************************************************
    'set connected
    connected = true
    
    call savegameini
    
#if seguridadalkon then
    'unprotect character creation form
    call unprotectform
#end if
    
    'unload the connect form
    unload frmcrearpersonaje
    unload frmconnect
    
    frmmain.lblname.caption = username
    'load main form
    frmmain.visible = true
    
    call frmmain.controlsm(esmtype.mspells, false)
    call frmmain.controlsm(esmtype.mwork, false)
    
    fpsflag = true
#if seguridadalkon then
    'protect the main form
    call protectform(frmmain)
#end if

end sub

sub cargartip()
    dim n as integer
    n = randomnumber(1, ubound(tips))
    
    frmtip.tip.caption = tips(n)
end sub

sub moveto(byval direccion as e_heading)
'***************************************************
'author: alejandro santos (alejolp)
'last modify date: 06/28/2008
'last modified by: lucas tavolaro ortiz (tavo)
' 06/03/2006: alejolp - elimine las funciones move[nswe] y las converti a esta
' 12/08/2007: tavo    - si el usuario esta paralizado no se puede mover.
' 06/28/2008: niconz - saqu� lo que imped�a que si el usuario estaba paralizado se ejecute el sub.
'***************************************************
    dim legalok as boolean
    
    if cartel then cartel = false
    
    select case direccion
        case e_heading.north
            legalok = movetolegalpos(userpos.x, userpos.y - 1)
        case e_heading.east
            legalok = movetolegalpos(userpos.x + 1, userpos.y)
        case e_heading.south
            legalok = movetolegalpos(userpos.x, userpos.y + 1)
        case e_heading.west
            legalok = movetolegalpos(userpos.x - 1, userpos.y)
    end select
    
    if legalok and not userparalizado then
        call writewalk(direccion)
        if not userdescansar and not usermeditar then
            movecharbyhead usercharindex, direccion
            movescreen direccion
        end if
    else
        if charlist(usercharindex).heading <> direccion then
            call writechangeheading(direccion)
        end if
    end if
    
    if frmmain.macrotrabajo.enabled then call frmmain.desactivarmacrotrabajo
    
    ' update 3d sounds!
    call audio.movelistener(userpos.x, userpos.y)
end sub

sub randommove()
'***************************************************
'author: alejandro santos (alejolp)
'last modify date: 06/03/2006
' 06/03/2006: alejolp - ahora utiliza la funcion moveto
'***************************************************
    call moveto(randomnumber(north, west))
end sub

private sub checkkeys()
'*****************************************************************
'checks keys and respond
'*****************************************************************
    static lastmovement as long
    
    'no input allowed while argentum is not the active window
    if not application.isappactive() then exit sub
    
    'no walking when in commerce or banking.
    if comerciando then exit sub
    
    'no walking while writting in the forum.
    if mirandoforo then exit sub
    
    'if game is paused, abort movement.
    if pausa then exit sub
    
    'todo: deber�a informarle por consola?
    if traveling then exit sub

    'control movement interval (this enforces the 1 step loss when meditating / resting client-side)
    if gettickcount - lastmovement > 56 then
        lastmovement = gettickcount
    else
        exit sub
    end if
    
    'don't allow any these keys during movement..
    if usermoving = 0 then
        if not userestupido then
            'move up
            if getkeystate(customkeys.bindedkey(ekeytype.mkeyup)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(north)
                frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
                exit sub
            end if
            
            'move right
            if getkeystate(customkeys.bindedkey(ekeytype.mkeyright)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(east)
                'frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
                exit sub
            end if
        
            'move down
            if getkeystate(customkeys.bindedkey(ekeytype.mkeydown)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(south)
                frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
                exit sub
            end if
        
            'move left
            if getkeystate(customkeys.bindedkey(ekeytype.mkeyleft)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(west)
                frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
                exit sub
            end if
            
            ' we haven't moved - update 3d sounds!
            call audio.movelistener(userpos.x, userpos.y)
        else
            dim kp as boolean
            kp = (getkeystate(customkeys.bindedkey(ekeytype.mkeyup)) < 0) or _
                getkeystate(customkeys.bindedkey(ekeytype.mkeyright)) < 0 or _
                getkeystate(customkeys.bindedkey(ekeytype.mkeydown)) < 0 or _
                getkeystate(customkeys.bindedkey(ekeytype.mkeyleft)) < 0
            
            if kp then
                call randommove
            else
                ' we haven't moved - update 3d sounds!
                call audio.movelistener(userpos.x, userpos.y)
            end if
            
            if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
            'frmmain.coord.caption = "(" & userpos.x & "," & userpos.y & ")"
            frmmain.coord.caption = "x: " & userpos.x & " y: " & userpos.y
        end if
    end if
end sub

'todo : si bien nunca estuvo all�, el mapa es algo independiente o a lo sumo dependiente del engine, no va ac�!!!
sub switchmap(byval map as integer)
'**************************************************************
'formato de mapas optimizado para reducir el espacio que ocupan.
'dise�ado y creado por juan mart�n sotuyo dodero (maraxus) (juansotuyo@hotmail.com)
'**************************************************************
    dim y as long
    dim x as long
    dim tempint as integer
    dim byflags as byte
    dim handle as integer
    
    handle = freefile()
    
    open dirmapas & "mapa" & map & ".map" for binary as handle
    seek handle, 1
            
    'map header
    get handle, , mapinfo.mapversion
    get handle, , micabecera
    get handle, , tempint
    get handle, , tempint
    get handle, , tempint
    get handle, , tempint
    
    'load arrays
    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            get handle, , byflags
            
            mapdata(x, y).blocked = (byflags and 1)
            
            get handle, , mapdata(x, y).graphic(1).grhindex
            initgrh mapdata(x, y).graphic(1), mapdata(x, y).graphic(1).grhindex
            
            'layer 2 used?
            if byflags and 2 then
                get handle, , mapdata(x, y).graphic(2).grhindex
                initgrh mapdata(x, y).graphic(2), mapdata(x, y).graphic(2).grhindex
            else
                mapdata(x, y).graphic(2).grhindex = 0
            end if
                
            'layer 3 used?
            if byflags and 4 then
                get handle, , mapdata(x, y).graphic(3).grhindex
                initgrh mapdata(x, y).graphic(3), mapdata(x, y).graphic(3).grhindex
            else
                mapdata(x, y).graphic(3).grhindex = 0
            end if
                
            'layer 4 used?
            if byflags and 8 then
                get handle, , mapdata(x, y).graphic(4).grhindex
                initgrh mapdata(x, y).graphic(4), mapdata(x, y).graphic(4).grhindex
            else
                mapdata(x, y).graphic(4).grhindex = 0
            end if
            
            'trigger used?
            if byflags and 16 then
                get handle, , mapdata(x, y).trigger
            else
                mapdata(x, y).trigger = 0
            end if
            
            'erase npcs
            if mapdata(x, y).charindex > 0 then
                call erasechar(mapdata(x, y).charindex)
            end if
            
            'erase objs
            mapdata(x, y).objgrh.grhindex = 0
        next x
    next y
    
    close handle
    
    mapinfo.name = ""
    mapinfo.music = ""
    
    curmap = map
end sub

function readfield(byval pos as integer, byref text as string, byval sepascii as byte) as string
'*****************************************************************
'gets a field from a delimited string
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/15/2004
'*****************************************************************
    dim i as long
    dim lastpos as long
    dim currentpos as long
    dim delimiter as string * 1
    
    delimiter = chr$(sepascii)
    
    for i = 1 to pos
        lastpos = currentpos
        currentpos = instr(lastpos + 1, text, delimiter, vbbinarycompare)
    next i
    
    if currentpos = 0 then
        readfield = mid$(text, lastpos + 1, len(text) - lastpos)
    else
        readfield = mid$(text, lastpos + 1, currentpos - lastpos - 1)
    end if
end function

function fieldcount(byref text as string, byval sepascii as byte) as long
'*****************************************************************
'gets the number of fields in a delimited string
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 07/29/2007
'*****************************************************************
    dim count as long
    dim curpos as long
    dim delimiter as string * 1
    
    if lenb(text) = 0 then exit function
    
    delimiter = chr$(sepascii)
    
    curpos = 0
    
    do
        curpos = instr(curpos + 1, text, delimiter)
        count = count + 1
    loop while curpos <> 0
    
    fieldcount = count
end function

function fileexist(byval file as string, byval filetype as vbfileattribute) as boolean
    fileexist = (dir$(file, filetype) <> "")
end function

sub writeclientver()
    dim hfile as integer
        
    hfile = freefile()
    open app.path & "\init\ver.bin" for binary access write lock read as #hfile
    put #hfile, , clng(777)
    put #hfile, , clng(777)
    put #hfile, , clng(777)
    
    put #hfile, , cint(app.major)
    put #hfile, , cint(app.minor)
    put #hfile, , cint(app.revision)
    
    close #hfile
end sub

public function isip(byval ip as string) as boolean
    dim i as long
    
    for i = 1 to ubound(serverslst)
        if serverslst(i).ip = ip then
            isip = true
            exit function
        end if
    next i
end function

public sub cargarservidores()
'********************************
'author: unknown
'last modification: 07/26/07
'last modified by: rapsodius
'added instruction "closeclient" before end so the mutex is cleared
'********************************
on error goto errorh
    dim f as string
    dim c as integer
    dim i as long
    
    f = app.path & "\init\sinfo.dat"
    c = val(getvar(f, "init", "cant"))
    
    redim serverslst(1 to c) as tserverinfo
    for i = 1 to c
        serverslst(i).desc = getvar(f, "s" & i, "desc")
        serverslst(i).ip = trim$(getvar(f, "s" & i, "ip"))
        serverslst(i).passrecport = cint(getvar(f, "s" & i, "p2"))
        serverslst(i).puerto = cint(getvar(f, "s" & i, "pj"))
    next i
    curserver = 1
exit sub

errorh:
    call msgbox("error cargando los servidores, actualicelos de la web", vbcritical + vbokonly, "argentum online")
    
    call closeclient
end sub

public sub initserverslist()
on error resume next
    dim numservers as integer
    dim i as integer
    dim cont as integer
    
    i = 1
    
    do while (readfield(i, rawserverslist, asc(";")) <> "")
        i = i + 1
        cont = cont + 1
    loop
    
    redim serverslst(1 to cont) as tserverinfo
    
    for i = 1 to cont
        dim cur$
        cur$ = readfield(i, rawserverslist, asc(";"))
        serverslst(i).ip = readfield(1, cur$, asc(":"))
        serverslst(i).puerto = readfield(2, cur$, asc(":"))
        serverslst(i).desc = readfield(4, cur$, asc(":"))
        serverslst(i).passrecport = readfield(3, cur$, asc(":"))
    next i
    
    curserver = 1
end sub

public function curserverpasrecport() as integer
    if curserver <> 0 then
        curserverpasrecport = 7667
    else
        curserverpasrecport = cint(frmconnect.porttxt)
    end if
end function

public function curserverip() as string
    if curserver <> 0 then
        curserverip = serverslst(curserver).ip
    else
        curserverip = frmconnect.iptxt
    end if
end function

public function curserverport() as integer
    if curserver <> 0 then
        curserverport = serverslst(curserver).puerto
    else
        curserverport = val(frmconnect.porttxt)
    end if
end function

sub main()
    call writeclientver
    
    'load config file
    if fileexist(app.path & "\init\inicio.con", vbnormal) then
        config_inicio = leergameini()
    end if
    
    'load ao.dat config file
    call loadclientsetup
    
    if clientsetup.bdinamic then
        set surfacedb = new clssurfacemandyn
    else
        set surfacedb = new clssurfacemanstatic
    end if
 
#if testeo = 0 then
    if findpreviousinstance then
        call msgbox("argentum online ya esta corriendo! no es posible correr otra instancia del juego. haga click en aceptar para salir.", vbapplicationmodal + vbinformation + vbokonly, "error al ejecutar")
        end
    end if
#end if

    'read command line. do it after config file is loaded to prevent this from
    'canceling the effects of "/nores" option.
    call leerlineacomandos
    
    'usaremos esto para ayudar en los parches
    call savesetting("argentumonlinecliente", "init", "path", app.path & "\")
    
    chdrive app.path
    chdir app.path

#if seguridadalkon then
    'obtener el hushmd5
    dim fmd5hushyo as string * 32
    
    fmd5hushyo = md5.getmd5file(app.path & "\" & app.exename & ".exe")
    call md5.md5reset
    md5hushyo = txtoffset(hexmd52asc(fmd5hushyo), 55)
    
    debug.print fmd5hushyo
#else
    md5hushyo = "0123456789abcdef"  'we aren't using a real md5
#end if
    
    tipf = config_inicio.tip
    
    'set resolution before the loading form is displayed, therefore it will be centered.
    call resolution.setresolution
    
    ' load constants, classes, flags, graphics..
    loadinitialconfig

#if testeo <> 1 then
    dim prespath as string
    prespath = dirgraficos & "presentacion" & randomnumber(1, 4) & ".jpg"
    
    frmpres.picture = loadpicture(prespath)
    frmpres.show vbmodal    'es modal, as� que se detiene la ejecuci�n de main hasta que se desaparece
#end if

#if usarwrench = 1 then
    frmmain.socket1.startup
#end if

    frmconnect.visible = true
    
    'inicializaci�n de variables globales
    primeravez = true
    prgrun = true
    pausa = false
    
    ' intervals
    loadtimerintervals
        
    'set the dialog's font
    dialogos.font = frmmain.font
    dialogosclanes.font = frmmain.font
    
    lframetimer = gettickcount
    
    ' load the form for screenshots
    call load(frmscreenshots)
        
    do while prgrun
        's�lo dibujamos si la ventana no est� minimizada
        if frmmain.windowstate <> 1 and frmmain.visible then
            call shownextframe(frmmain.top, frmmain.left, frmmain.mousex, frmmain.mousey)
            
            'play ambient sounds
            call rendersounds
            
            call checkkeys
        end if
        'fps counter - mostramos las fps
        if gettickcount - lframetimer >= 1000 then
            if fpsflag then frmmain.lblfps.caption = mod_tileengine.fps
            
            lframetimer = gettickcount
        end if
        
#if seguridadalkon then
        call checksecurity
#end if
        
        ' if there is anything to be sent, we send it
        call flushbuffer
        
        doevents
    loop
    
    call closeclient
end sub

private sub loadinitialconfig()
'***************************************************
'author: zama
'last modification: 15/03/2011
'15/03/2011: zama - initialize classes lazy way.
'***************************************************

    dim i as long

    frmcargando.show
    frmcargando.refresh

    frmconnect.version = "v" & app.major & "." & app.minor & " build: " & app.revision
    
    '###########
    ' servidores
    'todo : esto de serverrecibidos no se podr�a sacar???
    call addtorichtextbox(frmcargando.status, "buscando servidores... ", 255, 255, 255, true, false, true)
    call cargarservidores
    serversrecibidos = true
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
    '###########
    ' constantes
    call addtorichtextbox(frmcargando.status, "iniciando constantes... ", 255, 255, 255, true, false, true)
    call inicializarnombres
    ' initialize fonttypes
    call protocol.initfonts
    
    with frmconnect
        .txtnombre = config_inicio.name
        .txtnombre.selstart = 0
        .txtnombre.sellength = len(.txtnombre)
    end with
    
    usermap = 1
    
    ' mouse pointer (loaded before opening any form with buttons in it)
    if fileexist(dirextras & "hand.ico", vbarchive) then _
        set picmouseicon = loadpicture(dirextras & "hand.ico")
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
    '#######
    ' clases
    call addtorichtextbox(frmcargando.status, "instanciando clases... ", 255, 255, 255, true, false, true)
    set dialogos = new clsdialogs
    set audio = new clsaudio
    set inventario = new clsgrapchicalinventory
    set customkeys = new clscustomkeys
    set custommessages = new clscustommessages
    set incomingdata = new clsbytequeue
    set outgoingdata = new clsbytequeue
    set maintimer = new clstimer
    set clsforos = new clsforum
    
#if seguridadalkon then
    set md5 = new clsmd5
#end if
    set directx = new directx7
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
    '##############
    ' motor gr�fico
    call addtorichtextbox(frmcargando.status, "iniciando motor gr�fico... ", 255, 255, 255, true, false, true)
    
    if not inittileengine(frmmain.hwnd, 149, 13, 32, 32, 13, 17, 9, 8, 8, 0.018) then
        call closeclient
    end if
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
    '###################
    ' animaciones extras
    call addtorichtextbox(frmcargando.status, "creando animaciones extra... ", 255, 255, 255, true, false, true)
    call cargartips
    call cargararraylluvia
    call cargaranimarmas
    call cargaranimescudos
    call cargarcolores
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
    '#############
    ' direct sound
    call addtorichtextbox(frmcargando.status, "iniciando directsound... ", 255, 255, 255, true, false, true)
    'inicializamos el sonido
    call audio.initialize(directx, frmmain.hwnd, app.path & "\" & config_inicio.dirsonidos & "\", app.path & "\" & config_inicio.dirmusica & "\")
    'enable / disable audio
    audio.musicactivated = not clientsetup.bnomusic
    audio.soundactivated = not clientsetup.bnosound
    audio.soundeffectsactivated = not clientsetup.bnosoundeffects
    'inicializamos el inventario gr�fico
    call inventario.initialize(directdraw, frmmain.picinv, max_inventory_slots, , , , , , , , , true)
    call audio.musicmp3play(app.path & "\mp3\" & mp3_inicio & ".mp3")
    call addtorichtextbox(frmcargando.status, "hecho", 255, 0, 0, true, false, false)
    
#if seguridadalkon then
    cualmi = 0
    call initmi
#end if
    
    call addtorichtextbox(frmcargando.status, "                    �bienvenido a argentum online!", 255, 255, 255, true, false, true)

    'give the user enough time to read the welcome text
    call sleep(500)
    
    unload frmcargando
    
end sub

private sub loadtimerintervals()
'***************************************************
'author: zama
'last modification: 15/03/2011
'set the intervals of timers
'***************************************************
    
    call maintimer.setinterval(timersindex.attack, int_attack)
    call maintimer.setinterval(timersindex.work, int_work)
    call maintimer.setinterval(timersindex.useitemwithu, int_useitemu)
    call maintimer.setinterval(timersindex.useitemwithdblclick, int_useitemdck)
    call maintimer.setinterval(timersindex.sendrpu, int_sentrpu)
    call maintimer.setinterval(timersindex.castspell, int_cast_spell)
    call maintimer.setinterval(timersindex.arrows, int_arrows)
    call maintimer.setinterval(timersindex.castattack, int_cast_attack)
    
    frmmain.macrotrabajo.interval = int_macro_trabajo
    frmmain.macrotrabajo.enabled = false
    
   'init timers
    call maintimer.start(timersindex.attack)
    call maintimer.start(timersindex.work)
    call maintimer.start(timersindex.useitemwithu)
    call maintimer.start(timersindex.useitemwithdblclick)
    call maintimer.start(timersindex.sendrpu)
    call maintimer.start(timersindex.castspell)
    call maintimer.start(timersindex.arrows)
    call maintimer.start(timersindex.castattack)

end sub

sub writevar(byval file as string, byval main as string, byval var as string, byval value as string)
'*****************************************************************
'writes a var to a text file
'*****************************************************************
    writeprivateprofilestring main, var, value, file
end sub

function getvar(byval file as string, byval main as string, byval var as string) as string
'*****************************************************************
'gets a var from a text file
'*****************************************************************
    dim sspaces as string ' this will hold the input that the program will retrieve
    
    sspaces = space$(500) ' this tells the computer how long the longest string can be. if you want, you can change the number 100 to any number you wish
    
    getprivateprofilestring main, var, vbnullstring, sspaces, len(sspaces), file
    
    getvar = rtrim$(sspaces)
    getvar = left$(getvar, len(getvar) - 1)
end function

'[code 002]:matux
'
'  funci�n para chequear el email
'
'  corregida por maraxus para que reconozca como v�lidas casillas con puntos antes de la arroba y evitar un chequeo innecesario
public function checkmailstring(byval sstring as string) as boolean
on error goto errhnd
    dim lpos  as long
    dim lx    as long
    dim iasc  as integer
    
    '1er test: busca un simbolo @
    lpos = instr(sstring, "@")
    if (lpos <> 0) then
        '2do test: busca un simbolo . despu�s de @ + 1
        if not (instr(lpos, sstring, ".", vbbinarycompare) > lpos + 1) then _
            exit function
        
        '3er test: recorre todos los caracteres y los val�da
        for lx = 0 to len(sstring) - 1
            if not (lx = (lpos - 1)) then   'no chequeamos la '@'
                iasc = asc(mid$(sstring, (lx + 1), 1))
                if not cmsvalidatechar_(iasc) then _
                    exit function
            end if
        next lx
        
        'finale
        checkmailstring = true
    end if
errhnd:
end function

'  corregida por maraxus para que reconozca como v�lidas casillas con puntos antes de la arroba
private function cmsvalidatechar_(byval iasc as integer) as boolean
    cmsvalidatechar_ = (iasc >= 48 and iasc <= 57) or _
                        (iasc >= 65 and iasc <= 90) or _
                        (iasc >= 97 and iasc <= 122) or _
                        (iasc = 95) or (iasc = 45) or (iasc = 46)
end function

'todo : como todo lo relativo a mapas, no tiene nada que hacer ac�....
function hayagua(byval x as integer, byval y as integer) as boolean
    hayagua = ((mapdata(x, y).graphic(1).grhindex >= 1505 and mapdata(x, y).graphic(1).grhindex <= 1520) or _
            (mapdata(x, y).graphic(1).grhindex >= 5665 and mapdata(x, y).graphic(1).grhindex <= 5680) or _
            (mapdata(x, y).graphic(1).grhindex >= 13547 and mapdata(x, y).graphic(1).grhindex <= 13562)) and _
                mapdata(x, y).graphic(2).grhindex = 0
                
end function

public sub showsendtxt()
    if not frmcantidad.visible then
        frmmain.sendtxt.visible = true
        frmmain.sendtxt.setfocus
    end if
end sub

public sub showsendcmsgtxt()
    if not frmcantidad.visible then
        frmmain.sendcmstxt.visible = true
        frmmain.sendcmstxt.setfocus
    end if
end sub

''
' checks the command line parameters, if you are running ao with /nores command and checks the aoupdate parameters
'
'

public sub leerlineacomandos()
'*************************************************
'author: unknown
'last modified: 25/11/2008 (brianpr)
'
'*************************************************
    dim t() as string
    dim i as long
    
    dim uptodate as boolean
    dim patch as string
    
    'parseo los comandos
    t = split(command, " ")
    for i = lbound(t) to ubound(t)
        select case ucase$(t(i))
            case "/nores" 'no cambiar la resolucion
                nores = true
            case "/uptodate"
                uptodate = true
        end select
    next i
    
#if testeo = 0 then
    call aoupdate(uptodate, nores)
#end if

end sub

''
' runs aoupdate if we haven't updated yet, patches aoupdate and runs client normally if we are updated.
'
' @param uptodate specifies if we have checked for updates or not
' @param nores specifies if we have to set nores arg when running the client once again (if the aoupdate is executed).

private sub aoupdate(byval uptodate as boolean, byval nores as boolean)
'*************************************************
'author: brianpr
'created: 25/11/2008
'last modified: 25/11/2008
'
'*************************************************
on error goto error
    dim extraargs as string
    if not uptodate then
        'no recibe update, ejecutar au
        'ejecuto el aoupdate, sino me voy
        if dir(app.path & "\aoupdate.exe", vbarchive) = vbnullstring then
            msgbox "no se encuentra el archivo de actualizaci�n aoupdate.exe por favor descarguelo y vuelva a intentar", vbcritical
            end
        else
            filecopy app.path & "\aoupdate.exe", app.path & "\aoupdatetmp.exe"
            
            if nores then
                extraargs = " /nores"
            end if
            
            call shellexecute(0, "open", app.path & "\aoupdatetmp.exe", app.exename & ".exe" & extraargs, app.path, sw_shownormal)
            end
        end if
    else
        if fileexist(app.path & "\aoupdatetmp.exe", vbarchive) then kill app.path & "\aoupdatetmp.exe"
    end if
exit sub

error:
    if err.number = 75 then 'si el archivo aoupdatetmp.exe est� en uso, entonces esperamos 5 ms y volvemos a intentarlo hasta que nos deje.
        sleep 5
        resume
    else
        msgbox err.description & vbcrlf, vbinformation, "[ " & err.number & " ]" & " error "
        end
    end if
end sub

private sub loadclientsetup()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/19/09
'11/19/09: pato - is optional show the frmguildnews form
'**************************************************************
    dim fhandle as integer
    
    if fileexist(app.path & "\init\ao.dat", vbarchive) then
        fhandle = freefile
        
        open app.path & "\init\ao.dat" for binary access read lock write as fhandle
            get fhandle, , clientsetup
        close fhandle
    else
        'use dynamic by default
        clientsetup.bdinamic = true
    end if
    
    nores = clientsetup.bnores
    
    if instr(1, clientsetup.sgraficos, "graficos") then
        graphicsfile = clientsetup.sgraficos
    else
        graphicsfile = "graficos3.ind"
    end if
    
    clientsetup.bguildnews = not clientsetup.bguildnews
    set dialogosclanes = new clsguilddlg
    dialogosclanes.activo = not clientsetup.bgldmsgconsole
    dialogosclanes.cantidaddialogos = clientsetup.bcantmsgs
end sub

private sub saveclientsetup()
'**************************************************************
'author: torres patricio (pato)
'last modify date: 03/11/10
'
'**************************************************************
    dim fhandle as integer
    
    fhandle = freefile
    
    clientsetup.bnomusic = not audio.musicactivated
    clientsetup.bnosound = not audio.soundactivated
    clientsetup.bnosoundeffects = not audio.soundeffectsactivated
    clientsetup.bguildnews = not clientsetup.bguildnews
    clientsetup.bgldmsgconsole = not dialogosclanes.activo
    clientsetup.bcantmsgs = dialogosclanes.cantidaddialogos
    
    open app.path & "\init\ao.dat" for binary as fhandle
        put fhandle, , clientsetup
    close fhandle
end sub

private sub inicializarnombres()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/27/2005
'inicializa los nombres de razas, ciudades, clases, skills, atributos, etc.
'**************************************************************
    ciudades(eciudad.cullathorpe) = "ullathorpe"
    ciudades(eciudad.cnix) = "nix"
    ciudades(eciudad.cbanderbill) = "banderbill"
    ciudades(eciudad.clindos) = "lindos"
    ciudades(eciudad.carghal) = "argh�l"
    
    listarazas(eraza.humano) = "humano"
    listarazas(eraza.elfo) = "elfo"
    listarazas(eraza.elfooscuro) = "elfo oscuro"
    listarazas(eraza.gnomo) = "gnomo"
    listarazas(eraza.enano) = "enano"

    listaclases(eclass.mage) = "mago"
    listaclases(eclass.cleric) = "clerigo"
    listaclases(eclass.warrior) = "guerrero"
    listaclases(eclass.assasin) = "asesino"
    listaclases(eclass.thief) = "ladron"
    listaclases(eclass.bard) = "bardo"
    listaclases(eclass.druid) = "druida"
    listaclases(eclass.bandit) = "bandido"
    listaclases(eclass.paladin) = "paladin"
    listaclases(eclass.hunter) = "cazador"
    listaclases(eclass.worker) = "trabajador"
    listaclases(eclass.pirat) = "pirata"
    
    skillsnames(eskill.magia) = "magia"
    skillsnames(eskill.robar) = "robar"
    skillsnames(eskill.tacticas) = "evasi�n en combate"
    skillsnames(eskill.armas) = "combate cuerpo a cuerpo"
    skillsnames(eskill.meditar) = "meditar"
    skillsnames(eskill.apu�alar) = "apu�alar"
    skillsnames(eskill.ocultarse) = "ocultarse"
    skillsnames(eskill.supervivencia) = "supervivencia"
    skillsnames(eskill.talar) = "talar �rboles"
    skillsnames(eskill.comerciar) = "comercio"
    skillsnames(eskill.defensa) = "defensa con escudos"
    skillsnames(eskill.pesca) = "pesca"
    skillsnames(eskill.mineria) = "mineria"
    skillsnames(eskill.carpinteria) = "carpinteria"
    skillsnames(eskill.herreria) = "herreria"
    skillsnames(eskill.liderazgo) = "liderazgo"
    skillsnames(eskill.domar) = "domar animales"
    skillsnames(eskill.proyectiles) = "combate a distancia"
    skillsnames(eskill.wrestling) = "combate sin armas"
    skillsnames(eskill.navegacion) = "navegacion"

    atributosnames(eatributos.fuerza) = "fuerza"
    atributosnames(eatributos.agilidad) = "agilidad"
    atributosnames(eatributos.inteligencia) = "inteligencia"
    atributosnames(eatributos.carisma) = "carisma"
    atributosnames(eatributos.constitucion) = "constitucion"
end sub

''
' removes all text from the console and dialogs

public sub cleandialogs()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/27/2005
'removes all text from the console and dialogs
'**************************************************************
    'clean console and dialogs
    frmmain.rectxt.text = vbnullstring
    
    call dialogosclanes.removedialogs
    
    call dialogos.removealldialogs
end sub

public sub closeclient()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 8/14/2007
'frees all used resources, cleans up and leaves
'**************************************************************
    ' allow new instances of the client to be opened
    call previnstance.releaseinstance
    
    enginerun = false
    frmcargando.show
    call addtorichtextbox(frmcargando.status, "liberando recursos...", 0, 0, 0, 0, 0, 0)
    
    call resolution.resetresolution
    
    'stop tile engine
    call deinittileengine
    
    call saveclientsetup
    
    'destruimos los objetos p�blicos creados
    set custommessages = nothing
    set customkeys = nothing
    set surfacedb = nothing
    set dialogos = nothing
    set dialogosclanes = nothing
    set audio = nothing
    set inventario = nothing
    set maintimer = nothing
    set incomingdata = nothing
    set outgoingdata = nothing
    
#if seguridadalkon then
    set md5 = nothing
#end if
    
    call unloadallforms
    
    'actualizar tip
    config_inicio.tip = tipf
    call escribirgameini(config_inicio)
    end
end sub

public function esgm(charindex as integer) as boolean
esgm = false
if charlist(charindex).priv >= 1 and charlist(charindex).priv <= 5 or charlist(charindex).priv = 25 then _
    esgm = true

end function

public function gettagposition(byval nick as string) as integer
dim buf as integer
buf = instr(nick, "<")
if buf > 0 then
    gettagposition = buf
    exit function
end if
buf = instr(nick, "[")
if buf > 0 then
    gettagposition = buf
    exit function
end if
gettagposition = len(nick) + 2
end function

public sub checktext(byval text as string)
dim nivel as integer
if right(text, len(mensaje_fragshooter_te_ha_matado)) = mensaje_fragshooter_te_ha_matado then
    call screencapture(true)
    exit sub
end if
if left(text, len(mensaje_fragshooter_has_matado)) = mensaje_fragshooter_has_matado then
    esperandolevel = true
    exit sub
end if
if esperandolevel then
    if right(text, len(mensaje_fragshooter_puntos_de_experiencia)) = mensaje_fragshooter_puntos_de_experiencia then
        if cint(mid(text, len(mensaje_fragshooter_has_ganado), (len(text) - (len(mensaje_fragshooter_puntos_de_experiencia) + len(mensaje_fragshooter_has_ganado))))) / 2 > clientsetup.bymurderedlevel then
            call screencapture(true)
        end if
    end if
end if
esperandolevel = false
end sub

public function getstrenghtcolor() as long
dim m as long
m = 255 / maxatributos
getstrenghtcolor = rgb(255 - (m * userfuerza), (m * userfuerza), 0)
end function
public function getdexteritycolor() as long
dim m as long
m = 255 / maxatributos
getdexteritycolor = rgb(255, m * useragilidad, 0)
end function

public function getcharindexbyname(byval name as string) as integer
dim i as long
for i = 1 to lastchar
    if charlist(i).nombre = name then
        getcharindexbyname = i
        exit function
    end if
next i
end function

public function esanuncio(byval forumtype as byte) as boolean
'***************************************************
'author: zama
'last modification: 22/02/2010
'returns true if the post is sticky.
'***************************************************
    select case forumtype
        case eforummsgtype.iecaos_sticky
            esanuncio = true
            
        case eforummsgtype.iegeneral_sticky
            esanuncio = true
            
        case eforummsgtype.iereal_sticky
            esanuncio = true
            
    end select
    
end function

public function forumalignment(byval yforumtype as byte) as byte
'***************************************************
'author: zama
'last modification: 01/03/2010
'returns the forum alignment.
'***************************************************
    select case yforumtype
        case eforummsgtype.iecaos, eforummsgtype.iecaos_sticky
            forumalignment = eforumtype.iecaos
            
        case eforummsgtype.iegeneral, eforummsgtype.iegeneral_sticky
            forumalignment = eforumtype.iegeneral
            
        case eforummsgtype.iereal, eforummsgtype.iereal_sticky
            forumalignment = eforumtype.iereal
            
    end select
    
end function

public sub resetallinfo()
    
    ' save config.ini
    savegameini
    
    ' disable timers
    frmmain.second.enabled = false
    frmmain.macrotrabajo.enabled = false
    connected = false
    
    'unload all forms except frmmain, frmconnect and frmcrearpersonaje
    dim frm as form
    for each frm in forms
        if frm.name <> frmmain.name and frm.name <> frmconnect.name and _
            frm.name <> frmcrearpersonaje.name then
            
            unload frm
        end if
    next
    
    on local error goto 0
    
    ' return to connection screen
    frmconnect.mousepointer = vbnormal
    if not frmcrearpersonaje.visible then frmconnect.visible = true
    frmmain.visible = false
    
    'stop audio
    call audio.stopwave
    frmmain.isplaying = playloop.plnone

    
    ' reset flags
    pausa = false
    usermeditar = false
    userestupido = false
    userciego = false
    userdescansar = false
    userparalizado = false
    traveling = false
    usernavegando = false
    brain = false
    bfogata = false
    comerciando = false
    bshowtutorial = false
    
    mirandoasignarskills = false
    mirandocarpinteria = false
    mirandoestadisticas = false
    mirandoforo = false
    mirandoherreria = false
    mirandoparty = false
    
    'delete all kind of dialogs
    call cleandialogs
    
#if seguridadalkon then
    logging = false
    logstring = false
    seglastpressed = 0
    lastmouse = false
    lastamount = 0
#end if

    'reset some char variables...
    dim i as long
    for i = 1 to lastchar
        charlist(i).invisible = false
    next i

    ' reset stats
    userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    skillpoints = 0
    alocados = 0
    
    ' reset skills
    for i = 1 to numskills
        userskills(i) = 0
    next i

    ' reset attributes
    for i = 1 to numatributos
        useratributos(i) = 0
    next i
    
    ' clear inventory slots
    inventario.clearallslots

#if seguridadalkon then
    call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if

    ' connection screen midi
    call audio.playmidi("2.mid")

end sub
