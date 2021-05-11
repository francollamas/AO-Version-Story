attribute vb_name = "mod_general"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

public bk as long
public brk as long


public iplst as string
public banners as string

public bfogata as boolean

public blluvia() as byte ' array para determinar si
'debemos mostrar la animacion de la lluvia

public lframetimer as long
public shkeys() as string

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

public function sumadigitos(byval numero as integer) as integer
    'suma digitos
    do
        sumadigitos = sumadigitos + (numero mod 10)
        numero = numero \ 10
    loop while (numero > 0)
end function

public function sumadigitosmenos(byval numero as integer) as integer
    'suma digitos, y resta el total de d�gitos
    do
        sumadigitosmenos = sumadigitosmenos + (numero mod 10) - 1
        numero = numero \ 10
    loop while (numero > 0)
end function

public function complex(byval numero as integer) as integer
    if numero mod 2 <> 0 then
        complex = numero * sumadigitos(numero)
    else
        complex = numero * sumadigitosmenos(numero)
    end if
end function

public function validarloginmsg(byval numero as integer) as integer
    dim auxinteger as integer
    dim auxinteger2 as integer
    
    auxinteger = sumadigitos(numero)
    auxinteger2 = sumadigitosmenos(numero)
    validarloginmsg = complex(auxinteger + auxinteger2)
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
'******************************************
    with richtextbox
        if (len(.text)) > 10000 then .text = ""
        
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

    'unload the connect form
    unload frmconnect
    
    frmmain.label8.caption = username
    'load main form
    frmmain.visible = true
end sub

sub cargartip()
    dim n as integer
    n = randomnumber(1, ubound(tips))
    
    frmtip.tip.caption = tips(n)
end sub

sub moveto(byval direccion as e_heading)
'***************************************************
'author: alejandro santos (alejolp)
'last modify date: 06/03/2006
' 06/03/2006: alejolp - elimine las funciones move[nswe] y las converti a esta
'***************************************************
    dim legalok as boolean
    
    if cartel then cartel = false
    
    select case direccion
        case e_heading.north
            legalok = legalpos(userpos.x, userpos.y - 1)
        case e_heading.east
            legalok = legalpos(userpos.x + 1, userpos.y)
        case e_heading.south
            legalok = legalpos(userpos.x, userpos.y + 1)
        case e_heading.west
            legalok = legalpos(userpos.x - 1, userpos.y)
    end select
    
    if legalok then
        call senddata("m" & direccion)
        if not userdescansar and not usermeditar and not userparalizado then
            movecharbyhead usercharindex, direccion
            movescreen direccion
        end if
    else
        if charlist(usercharindex).heading <> direccion then
            call senddata("chea" & direccion)
        end if
    end if
    
end sub

sub randommove()
'***************************************************
'author: alejandro santos (alejolp)
'last modify date: 06/03/2006
' 06/03/2006: alejolp - ahora utiliza la funcion moveto
'***************************************************

    moveto randomnumber(1, 4)
    
end sub

sub checkkeys()
'*****************************************************************
'checks keys and respond
'*****************************************************************
on error resume next
    'don't allow any these keys during movement..
    if usermoving = 0 then
        if not userestupido then
            'move up
            if getkeystate(vbkeyup) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(north)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        
            'move right
            if getkeystate(vbkeyright) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(east)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        
            'move down
            if getkeystate(vbkeydown) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(south)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        
            'move left
            if getkeystate(vbkeyleft) < 0 then
                if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
                call moveto(west)
                frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
                exit sub
            end if
        else
            dim kp as boolean
            kp = (getkeystate(vbkeyup) < 0) or _
                getkeystate(vbkeyright) < 0 or _
                getkeystate(vbkeydown) < 0 or _
                getkeystate(vbkeyleft) < 0
            if kp then call randommove
            if frmmain.trainingmacro.enabled then frmmain.desactivarmacrohechizos
            frmmain.coord.caption = "(" & userpos.x & "," & userpos.y & ")"
        end if
    end if
end sub

'todo : esto no es del tileengine??
sub movescreen(byval nheading as e_heading)
'******************************************
'starts the screen moving in a direction
'******************************************
    dim x as integer
    dim y as integer
    dim tx as integer
    dim ty as integer
    
    'figure out which way to move
    select case nheading
        case e_heading.north
            y = -1
    
        case e_heading.east
            x = 1
    
        case e_heading.south
            y = 1
        
        case e_heading.west
            x = -1
            
    end select
    
    'fill temp pos
    tx = userpos.x + x
    ty = userpos.y + y

    if not (tx < minxborder or tx > maxxborder or ty < minyborder or ty > maxyborder) then
        addtouserpos.x = x
        userpos.x = tx
        addtouserpos.y = y
        userpos.y = ty
        usermoving = 1
        
        btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
                mapdata(userpos.x, userpos.y).trigger = 2 or _
                mapdata(userpos.x, userpos.y).trigger = 4, true, false)
        exit sub
    end if
end sub

'todo : esto no es del tileengine??
function nextopenchar()
'******************************************
'finds next open char
'******************************************
    dim loopc as long
    
    loopc = 1
    do while charlist(loopc).active and loopc < ubound(charlist)
        loopc = loopc + 1
    loop
    
    nextopenchar = loopc
end function

'todo : si bien nunca estuvo all�, el mapa es algo independiente o a lo sumo dependiente del engine, no va ac�!!!
sub switchmap(byval map as integer)
'**************************************************************
'formato de mapas optimizado para reducir el espacio que ocupan.
'dise�ado y creado por juan mart�n sotuyo dodero (maraxus) (juansotuyo@hotmail.com)
'**************************************************************
    dim loopc as long
    dim y as long
    dim x as long
    dim tempint as integer
    dim byflags as byte
    
    open dirmapas & "mapa" & map & ".map" for binary as #1
    seek #1, 1
            
    'map header
    get #1, , mapinfo.mapversion
    get #1, , micabecera
    get #1, , tempint
    get #1, , tempint
    get #1, , tempint
    get #1, , tempint
    
    'load arrays
    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            get #1, , byflags
            
            mapdata(x, y).blocked = (byflags and 1)
            
            get #1, , mapdata(x, y).graphic(1).grhindex
            initgrh mapdata(x, y).graphic(1), mapdata(x, y).graphic(1).grhindex
            
            'layer 2 used?
            if byflags and 2 then
                get #1, , mapdata(x, y).graphic(2).grhindex
                initgrh mapdata(x, y).graphic(2), mapdata(x, y).graphic(2).grhindex
            else
                mapdata(x, y).graphic(2).grhindex = 0
            end if
                
            'layer 3 used?
            if byflags and 4 then
                get #1, , mapdata(x, y).graphic(3).grhindex
                initgrh mapdata(x, y).graphic(3), mapdata(x, y).graphic(3).grhindex
            else
                mapdata(x, y).graphic(3).grhindex = 0
            end if
                
            'layer 4 used?
            if byflags and 8 then
                get #1, , mapdata(x, y).graphic(4).grhindex
                initgrh mapdata(x, y).graphic(4), mapdata(x, y).graphic(4).grhindex
            else
                mapdata(x, y).graphic(4).grhindex = 0
            end if
            
            'trigger used?
            if byflags and 16 then
                get #1, , mapdata(x, y).trigger
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
    
    close #1
    
    mapinfo.name = ""
    mapinfo.music = ""
    
    curmap = map
end sub

'todo : reemplazar por la nueva versi�n, esta apesta!!!
public function readfield(byval pos as integer, byval text as string, byval sepascii as integer) as string
'*****************************************************************
'gets a field from a string
'*****************************************************************
    dim i as integer
    dim lastpos as integer
    dim curchar as string * 1
    dim fieldnum as integer
    dim seperator as string
    
    seperator = chr$(sepascii)
    lastpos = 0
    fieldnum = 0
    
    for i = 1 to len(text)
        curchar = mid$(text, i, 1)
        if curchar = seperator then
            fieldnum = fieldnum + 1
            if fieldnum = pos then
                readfield = mid$(text, lastpos + 1, (instr(lastpos + 1, text, seperator, vbtextcompare) - 1) - (lastpos))
                exit function
            end if
            lastpos = i
        end if
    next i
    fieldnum = fieldnum + 1
    
    if fieldnum = pos then
        readfield = mid$(text, lastpos + 1)
    end if
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
    end
end sub

public sub initserverslist(byval lst as string)
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
        curserverport = cint(frmconnect.porttxt)
    end if
end function


sub main()
'todo : cambiar esto cuando se corrija el bug de los timers
'on error goto manejadorerrores
on error resume next

#if seguridadalkon then
    initsecurity
#end if

    call writeclientver
    call leerlineacomandos

    if app.previnstance then
        call msgbox("argentum online ya esta corriendo! no es posible correr otra instancia del juego. haga click en aceptar para salir.", vbapplicationmodal + vbinformation + vbokonly, "error al ejecutar")
        end
    end if

dim f as boolean
dim ulttick as long, esttick as long
dim timers(1 to 2) as integer

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
    
    'cargamos el archivo de configuracion inicial
    if fileexist(app.path & "\init\inicio.con", vbnormal) then
        config_inicio = leergameini()
    end if
    
    
    if fileexist(app.path & "\init\ao.dat", vbarchive) then
        call loadclientsetup
        
        if clientsetup.bdinamic then
            set surfacedb = new clssurfacemandyn
        else
            set surfacedb = new clssurfacemanstatic
        end if
    else
        'por default usamos el din�mico
        set surfacedb = new clssurfacemandyn
    end if
    
    
    tipf = config_inicio.tip
    
    frmcargando.show
    frmcargando.refresh
    
    frmconnect.version = "v" & app.major & "." & app.minor & " build: " & app.revision
    addtorichtextbox frmcargando.status, "buscando servidores....", 0, 0, 0, 0, 0, 1

#if usarwrench = 1 then
    frmmain.socket1.startup
#end if

    call cargarservidores
'todo : esto de serverrecibidos no se podr�a sacar???
    serversrecibidos = true
    
    addtorichtextbox frmcargando.status, "encontrado", , , , 1
    addtorichtextbox frmcargando.status, "iniciando constantes...", 0, 0, 0, 0, 0, 1
    
    call inicializarnombres
    
    frmoldpersonaje.nametxt.text = config_inicio.name
    frmoldpersonaje.passwordtxt.text = ""
    
    addtorichtextbox frmcargando.status, "hecho", , , , 1
    
    iniciarobjetosdirectx
    
    addtorichtextbox frmcargando.status, "cargando sonidos....", 0, 0, 0, 0, 0, 1
    addtorichtextbox frmcargando.status, "hecho", , , , 1

dim loopc as integer

lasttime = gettickcount

    call inittileengine(frmmain.hwnd, 152, 7, 32, 32, 13, 17, 9)
    
    call addtorichtextbox(frmcargando.status, "creando animaciones extra....")
    
    call cargaranimsextra
    call cargartips

usermap = 1

    call cargararraylluvia
    call cargaranimarmas
    call cargaranimescudos
    call cargarversiones
    call cargarcolores
    
#if seguridadalkon then
    cualmi = 0
    call initmi
#end if

    addtorichtextbox frmcargando.status, "                    �bienvenido a argentum online!", , , , 1
    
    unload frmcargando
    
    'inicializamos el sonido
    call addtorichtextbox(frmcargando.status, "iniciando directsound....", 0, 0, 0, 0, 0, true)
    call audio.initialize(directx, frmmain.hwnd, app.path & "\" & config_inicio.dirsonidos & "\", app.path & "\" & config_inicio.dirmusica & "\")
    call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)
    
    'inicializamos el inventario gr�fico
    call inventario.initialize(directdraw, frmmain.picinv)
    
    if musica then
        call audio.playmidi(midi_inicio & ".mid")
    end if

    frmpres.picture = loadpicture(app.path & "\graficos\bosquefinal.jpg")
    frmpres.show vbmodal    'es modal, as� que se detiene la ejecuci�n de main hasta que se desaparece
    
    frmconnect.visible = true

'todo : esto va en engine initialization
    mainviewrect.left = mainviewleft
    mainviewrect.top = mainviewtop
    mainviewrect.right = mainviewrect.left + mainviewwidth
    mainviewrect.bottom = mainviewrect.top + mainviewheight
    
'todo : esto va en engine initialization
    maindestrect.left = tilepixelwidth * tilebuffersize - tilepixelwidth
    maindestrect.top = tilepixelheight * tilebuffersize - tilepixelheight
    maindestrect.right = maindestrect.left + mainviewwidth
    maindestrect.bottom = maindestrect.top + mainviewheight
    
    'inicializaci�n de variables globales
    primeravez = true
    prgrun = true
    pausa = false
    
    do while prgrun
        's�lo dibujamos si la ventana no est� minimizada
        if frmmain.windowstate <> 1 and frmmain.visible then
            call shownextframe
            
            'play ambient sounds
            call rendersounds
        end if
        
'todo : porque el pausado de 20 ms???
        if gettickcount - lasttime > 20 then
            if not pausa and frmmain.visible and not frmforo.visible and not frmcomerciar.visible and not frmcomerciarusu.visible and not frmbancoobj.visible then
                checkkeys
                lasttime = gettickcount
            end if
        end if
        
        'limitamos los fps a 18 (con el nuevo engine 60 es un n�mero mucho mejor)
        while (gettickcount - lframetimer) \ 56 < framesperseccounter
            sleep 5
        wend
        
        'fps counter - mostramos las fps
        if gettickcount - lframetimer >= 1000 then
            framespersec = framesperseccounter
            
            if fpsflag then frmmain.caption = framespersec
            
            framesperseccounter = 0
            lframetimer = gettickcount
        end if
        
'todo : ser�a mejor comparar el tiempo desde la �ltima vez que se hizo hasta el actual solo cuando se precisa. adem�s evit�s el corte de intervalos con 2 golpes seguidos.
        'sistema de timers renovado:
        esttick = gettickcount
        for loopc = 1 to ubound(timers)
            timers(loopc) = timers(loopc) + (esttick - ulttick)
            'timer de trabajo
            if timers(1) >= tus then
                timers(1) = 0
                nopuedeusar = false
            end if
            'timer de attaque (77)
            if timers(2) >= tat then
                timers(2) = 0
                usercanattack = 1
                userpuederefrescar = true
            end if
        next loopc
        ulttick = gettickcount
        
#if seguridadalkon then
        call checksecurity
#end if
        
        doevents
    loop

    enginerun = false
    frmcargando.show
    addtorichtextbox frmcargando.status, "liberando recursos...", 0, 0, 0, 0, 0, 1
    liberarobjetosdx

'todo : esto deber�a ir en otro lado como al cambair a esta res
    if not bnoreschange then
        dim typdevm as typdevmode
        dim lres as long
        
        lres = enumdisplaysettings(0, 0, typdevm)
        with typdevm
            .dmfields = dm_pelswidth or dm_pelsheight
            .dmpelswidth = oldreswidth
            .dmpelsheight = oldresheight
        end with
        lres = changedisplaysettings(typdevm, cds_test)
    end if

    'destruimos los objetos p�blicos creados
    set surfacedb = nothing
    set dialogos = nothing
    set dialogosclanes = nothing
    set audio = nothing
    set inventario = nothing
#if seguridadalkon then
    set md5 = nothing
#end if
    
    call unloadallforms
    
    'actualizar tip
    config_inicio.tip = tipf
    call escribirgameini(config_inicio)
    
#if seguridadalkon then
    deinitsecurity
#end if
end

manejadorerrores:
    msgbox "ha ocurrido un error irreparable, el cliente se cerrar�."
    logerror "contexto:" & err.helpcontext & " desc:" & err.description & " fuente:" & err.source
    end
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

'todo : como todo lorelativo a mapas, no tiene anda que hacer ac�....
function hayagua(byval x as integer, byval y as integer) as boolean

    hayagua = mapdata(x, y).graphic(1).grhindex >= 1505 and _
                mapdata(x, y).graphic(1).grhindex <= 1520 and _
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
    
public sub leerlineacomandos()
    dim t() as string
    dim i as long
    
    'parseo los comandos
    t = split(command, " ")
    
    for i = lbound(t) to ubound(t)
        select case ucase$(t(i))
            case "/nores" 'no cambiar la resolucion
                nores = true
        end select
    next i
end sub

private sub loadclientsetup()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/27/2005
'
'**************************************************************
    dim fhandle as integer
    
    fhandle = freefile
    open app.path & "\init\ao.dat" for binary access read lock write as fhandle
        get fhandle, , clientsetup
    close fhandle
    
    musica = not clientsetup.bnomusic
    sound = not clientsetup.bnosound
end sub

private sub inicializarnombres()
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/27/2005
'inicializa los nombres de razas, ciudades, clases, skills, atributos, etc.
'**************************************************************
    ciudades(1) = "ullathorpe"
    ciudades(2) = "nix"
    ciudades(3) = "banderbill"

    citydesc(1) = "ullathorpe est� establecida en el medio de los grandes bosques de argentum, es principalmente un pueblo de campesinos y le�adores. su ubicaci�n hace de ullathorpe un punto de paso obligado para todos los aventureros ya que se encuentra cerca de los lugares m�s legendarios de este mundo."
    citydesc(2) = "nix es una gran ciudad. edificada sobre la costa oeste del principal continente de argentum."
    citydesc(3) = "banderbill se encuentra al norte de ullathorpe y nix, es una de las ciudades m�s importantes de todo el imperio."

    listarazas(1) = "humano"
    listarazas(2) = "elfo"
    listarazas(3) = "elfo oscuro"
    listarazas(4) = "gnomo"
    listarazas(5) = "enano"

    listaclases(1) = "mago"
    listaclases(2) = "clerigo"
    listaclases(3) = "guerrero"
    listaclases(4) = "asesino"
    listaclases(5) = "ladron"
    listaclases(6) = "bardo"
    listaclases(7) = "druida"
    listaclases(8) = "bandido"
    listaclases(9) = "paladin"
    listaclases(10) = "cazador"
    listaclases(11) = "pescador"
    listaclases(12) = "herrero"
    listaclases(13) = "le�ador"
    listaclases(14) = "minero"
    listaclases(15) = "carpintero"
    listaclases(16) = "pirata"

    skillsnames(skills.suerte) = "suerte"
    skillsnames(skills.magia) = "magia"
    skillsnames(skills.robar) = "robar"
    skillsnames(skills.tacticas) = "tacticas de combate"
    skillsnames(skills.armas) = "combate con armas"
    skillsnames(skills.meditar) = "meditar"
    skillsnames(skills.apu�alar) = "apu�alar"
    skillsnames(skills.ocultarse) = "ocultarse"
    skillsnames(skills.supervivencia) = "supervivencia"
    skillsnames(skills.talar) = "talar �rboles"
    skillsnames(skills.comerciar) = "comercio"
    skillsnames(skills.defensa) = "defensa con escudos"
    skillsnames(skills.pesca) = "pesca"
    skillsnames(skills.mineria) = "mineria"
    skillsnames(skills.carpinteria) = "carpinteria"
    skillsnames(skills.herreria) = "herreria"
    skillsnames(skills.liderazgo) = "liderazgo"
    skillsnames(skills.domar) = "domar animales"
    skillsnames(skills.proyectiles) = "armas de proyectiles"
    skillsnames(skills.wresterling) = "wresterling"
    skillsnames(skills.navegacion) = "navegacion"

    atributosnames(1) = "fuerza"
    atributosnames(2) = "agilidad"
    atributosnames(3) = "inteligencia"
    atributosnames(4) = "carisma"
    atributosnames(5) = "constitucion"
end sub
