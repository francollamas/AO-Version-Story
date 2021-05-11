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

public function randomnumber(byval lowerbound as long, byval upperbound as long) as long
    'initialize randomizer
    randomize timer
    
    'generate random number
    randomnumber = (upperbound - lowerbound) * rnd + lowerbound
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

sub cargarversiones()
on error goto errorh:

    versiones(1) = val(getvar(app.path & "\init\" & "versiones.ini", "graficos", "val"))
    versiones(2) = val(getvar(app.path & "\init\" & "versiones.ini", "wavs", "val"))
    versiones(3) = val(getvar(app.path & "\init\" & "versiones.ini", "midis", "val"))
    versiones(4) = val(getvar(app.path & "\init\" & "versiones.ini", "init", "val"))
    versiones(5) = val(getvar(app.path & "\init\" & "versiones.ini", "mapas", "val"))
    versiones(6) = val(getvar(app.path & "\init\" & "versiones.ini", "e", "val"))
    versiones(7) = val(getvar(app.path & "\init\" & "versiones.ini", "o", "val"))
exit sub

errorh:
    call msgbox("error cargando versiones")
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
    
    colorespj(50).r = cbyte(getvar(archivoc, "cr", "r"))
    colorespj(50).g = cbyte(getvar(archivoc, "cr", "g"))
    colorespj(50).b = cbyte(getvar(archivoc, "cr", "b"))
    colorespj(49).r = cbyte(getvar(archivoc, "ci", "r"))
    colorespj(49).g = cbyte(getvar(archivoc, "ci", "g"))
    colorespj(49).b = cbyte(getvar(archivoc, "ci", "b"))
end sub

#if seguridadalkon then
sub initmi()
    dim alternativos as integer
    dim cualmitemp as integer
    
    alternativos = randomnumber(1, 7368)
    cualmitemp = randomnumber(1, 1233)
    

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

sub addtorichtextbox(byref richtextbox as richtextbox, byval text as string, optional byval red as integer = -1, optional byval green as integer, optional byval blue as integer, optional byval bold as boolean = false, optional byval italic as boolean = false, optional byval bcrlf as boolean = false)
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
        
        .selstart = len(richtextbox.text)
        .sellength = 0
        .selbold = bold
        .selitalic = italic
        
        if not red = -1 then .selcolor = rgb(red, green, blue)
        
        .seltext = iif(bcrlf, text, text & vbcrlf)
        
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
    unload frmpasswd
    unload frmcrearpersonaje
    unload frmconnect
    
    
    
    frmmain.label8.caption = username
    'load main form
    frmmain.visible = true
    
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
    
    if frmmain.macrotrabajo.enabled then frmmain.desactivarmacrotrabajo
    
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
    if frmforo.visible then exit sub
    
    'if game is paused, abort movement.
    if pausa then exit sub
    
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
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
            
            'move right
            if getkeystate(customkeys.bindedkey(ekeytype.mkeyright)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(east)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        
            'move down
            if getkeystate(customkeys.bindedkey(ekeytype.mkeydown)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(south)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        
            'move left
            if getkeystate(customkeys.bindedkey(ekeytype.mkeyleft)) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(west)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
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
            frmmain.coord.caption = "(" & userpos.x & "," & userpos.y & ")"
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
    if fileexist(app.path & "\init\ao.dat", vbarchive) then
        call loadclientsetup
        
        if clientsetup.bdinamic then
            set surfacedb = new clssurfacemandyn
        else
            set surfacedb = new clssurfacemanstatic
        end if
    else
        'use dynamic by default
        set surfacedb = new clssurfacemandyn
    end if
    
    if findpreviousinstance then
        call msgbox("argentum online ya esta corriendo! no es posible correr otra instancia del juego. haga click en aceptar para salir.", vbapplicationmodal + vbinformation + vbokonly, "error al ejecutar")
        end
    end if
    
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
    
    frmcargando.show
    frmcargando.refresh
    
    frmconnect.version = "v" & app.major & "." & app.minor & " build: " & app.revision
    addtorichtextbox frmcargando.status, "buscando servidores... ", 0, 0, 0, 0, 0, 1

    call cargarservidores
'todo : esto de serverrecibidos no se podr�a sacar???
    serversrecibidos = true
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1
    addtorichtextbox frmcargando.status, "iniciando constantes... ", 0, 0, 0, 0, 0, 1
    
    call inicializarnombres
    
    ' initialize fonttypes
    call protocol.initfonts
    
    frmoldpersonaje.nametxt.text = config_inicio.name
    frmoldpersonaje.passwordtxt.text = ""
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1
    
    addtorichtextbox frmcargando.status, "iniciando motor gr�fico... ", 0, 0, 0, 0, 0, 1
    
    if not inittileengine(frmmain.hwnd, 160, 7, 32, 32, 13, 17, 9, 8, 8, 0.018) then
        call closeclient
    end if
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1
    
    call addtorichtextbox(frmcargando.status, "creando animaciones extra... ", , , , , , 1)
    
    call cargartips
    
usermap = 1
    
    call cargararraylluvia
    call cargaranimarmas
    call cargaranimescudos
    call cargarversiones
    call cargarcolores
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1
    
    addtorichtextbox frmcargando.status, "iniciando directsound... ", 0, 0, 0, 0, 0, true
    
    'inicializamos el sonido
    call audio.initialize(directx, frmmain.hwnd, app.path & "\" & config_inicio.dirsonidos & "\", app.path & "\" & config_inicio.dirmusica & "\")
    'enable / disable audio
    audio.musicactivated = not clientsetup.bnomusic
    audio.soundactivated = not clientsetup.bnosound
    audio.soundeffectsactivated = not clientsetup.bnosoundeffects
    'inicializamos el inventario gr�fico
    call inventario.initialize(directdraw, frmmain.picinv)
    
    call audio.playmidi(midi_inicio & ".mid")
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1, , false
    
#if seguridadalkon then
    cualmi = 0
    call initmi
#end if
    
    addtorichtextbox frmcargando.status, "                    �bienvenido a argentum online!", , , , 1
    
    'give the user enough time to read the welcome text
    call sleep(1750)
    
    unload frmcargando
    

    frmpres.picture = loadpicture(app.path & "\graficos\gs-zone.jpg")
    frmpres.show vbmodal    'es modal, as� que se detiene la ejecuci�n de main hasta que se desaparece
    
#if usarwrench = 1 then
    frmmain.socket1.startup
#end if

    frmconnect.visible = true
    
    'inicializaci�n de variables globales
    primeravez = true
    prgrun = true
    pausa = false
    
    'set the intervals of timers
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
    
    'set the dialog's font
    dialogos.font = frmmain.font
    dialogosclanes.font = frmmain.font
    
    
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
            if fpsflag then frmmain.caption = mod_tileengine.fps
            
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
    
    sspaces = space$(100) ' this tells the computer how long the longest string can be. if you want, you can change the number 100 to any number you wish
    
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
    
    'call aoupdate(uptodate, nores) ' gs - desactivo el aoupdate
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
'last modify date: 24/06/2006
'
'**************************************************************
    dim fhandle as integer
    
    fhandle = freefile
    open app.path & "\init\ao.dat" for binary access read lock write as fhandle
        get fhandle, , clientsetup
    close fhandle
    
    nores = clientsetup.bnores
    if clientsetup.sgraficos <> "" then
        graphicsfile = clientsetup.sgraficos
    else
        graphicsfile = "graficos3.ind"
    end if
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
    listaclases(eclass.fisher) = "pescador"
    listaclases(eclass.blacksmith) = "herrero"
    listaclases(eclass.lumberjack) = "le�ador"
    listaclases(eclass.miner) = "minero"
    listaclases(eclass.carpenter) = "carpintero"
    listaclases(eclass.pirat) = "pirata"
    
    skillsnames(eskill.suerte) = "suerte"
    skillsnames(eskill.magia) = "magia"
    skillsnames(eskill.robar) = "robar"
    skillsnames(eskill.tacticas) = "tacticas de combate"
    skillsnames(eskill.armas) = "combate con armas"
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
    skillsnames(eskill.proyectiles) = "armas de proyectiles"
    skillsnames(eskill.wrestling) = "wrestling"
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
    addtorichtextbox frmcargando.status, "liberando recursos...", 0, 0, 0, 0, 0, 1
    
    call resolution.resetresolution
    
    'stop tile engine
    call deinittileengine
    
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
