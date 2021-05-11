attribute vb_name = "mod_tileengine"
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

'map sizes in tiles
public const xmaxmapsize as byte = 100
public const xminmapsize as byte = 1
public const ymaxmapsize as byte = 100
public const yminmapsize as byte = 1

private const grhfogata as integer = 1521

''
'sets a grh animation to loop indefinitely.
private const infinite_loops as integer = -1


'encabezado bmp
type bitmapfileheader
    bftype as integer
    bfsize as long
    bfreserved1 as integer
    bfreserved2 as integer
    bfoffbits as long
end type

'info del encabezado del bmp
type bitmapinfoheader
    bisize as long
    biwidth as long
    biheight as long
    biplanes as integer
    bibitcount as integer
    bicompression as long
    bisizeimage as long
    bixpelspermeter as long
    biypelspermeter as long
    biclrused as long
    biclrimportant as long
end type

'posicion en un mapa
public type position
    x as long
    y as long
end type

'posicion en el mundo
public type worldpos
    map as integer
    x as integer
    y as integer
end type

'contiene info acerca de donde se puede encontrar un grh tama�o y animacion
public type grhdata
    sx as integer
    sy as integer
    
    filenum as long
    
    pixelwidth as integer
    pixelheight as integer
    
    tilewidth as single
    tileheight as single
    
    numframes as integer
    frames() as long
    
    speed as single
end type

'apunta a una estructura grhdata y mantiene la animacion
public type grh
    grhindex as integer
    framecounter as single
    speed as single
    started as byte
    loops as integer
end type

'lista de cuerpos
public type bodydata
    walk(e_heading.north to e_heading.west) as grh
    headoffset as position
end type

'lista de cabezas
public type headdata
    head(e_heading.north to e_heading.west) as grh
end type

'lista de las animaciones de las armas
type weaponanimdata
    weaponwalk(e_heading.north to e_heading.west) as grh
end type

'lista de las animaciones de los escudos
type shieldanimdata
    shieldwalk(e_heading.north to e_heading.west) as grh
end type


'apariencia del personaje
public type char
    active as byte
    heading as e_heading
    pos as position
    
    ihead as integer
    ibody as integer
    body as bodydata
    head as headdata
    casco as headdata
    arma as weaponanimdata
    escudo as shieldanimdata
    usandoarma as boolean
    
    fx as grh
    fxindex as integer
    
    criminal as byte
    
    nombre as string
    
    scrolldirectionx as integer
    scrolldirectiony as integer
    
    moving as byte
    moveoffsetx as single
    moveoffsety as single
    
    pie as boolean
    muerto as boolean
    invisible as boolean
    priv as byte
end type

'info de un objeto
public type obj
    objindex as integer
    amount as integer
end type

'tipo de las celdas del mapa
public type mapblock
    graphic(1 to 4) as grh
    charindex as integer
    objgrh as grh
    
    npcindex as integer
    objinfo as obj
    tileexit as worldpos
    blocked as byte
    
    trigger as integer
end type

'info de cada mapa
public type mapinfo
    music as string
    name as string
    startpos as worldpos
    mapversion as integer
end type

'dx7 objects
public directx as new directx7
public directdraw as directdraw7
private primarysurface as directdrawsurface7
private primaryclipper as directdrawclipper
private backbuffersurface as directdrawsurface7

public inipath as string
public mappath as string


'bordes del mapa
public minxborder as byte
public maxxborder as byte
public minyborder as byte
public maxyborder as byte

'status del user
public curmap as integer 'mapa actual
public userindex as integer
public usermoving as byte
public userbody as integer
public userhead as integer
public userpos as position 'posicion
public addtouserpos as position 'si se mueve
public usercharindex as integer

public enginerun as boolean

public fps as long
public framesperseccounter as long
private fpslastcheck as long

'tama�o del la vista en tiles
private windowtilewidth as integer
private windowtileheight as integer

private halfwindowtilewidth as integer
private halfwindowtileheight as integer

'offset del desde 0,0 del main view
private mainviewtop as integer
private mainviewleft as integer

'cuantos tiles el engine mete en el buffer cuando
'dibuja el mapa. ojo un tama�o muy grande puede
'volver el engine muy lento
public tilebuffersize as integer

private tilebufferpixeloffsetx as integer
private tilebufferpixeloffsety as integer

'tama�o de los tiles en pixels
public tilepixelheight as integer
public tilepixelwidth as integer

'number of pixels the engine scrolls per frame. must divide evenly into pixels per tile
public scrollpixelsperframex as integer
public scrollpixelsperframey as integer

dim timerelapsedtime as single
dim timerticksperframe as single
dim enginebasespeed as single


public numbodies as integer
public numheads as integer
public numfxs as integer

public numchars as integer
public lastchar as integer
public numweaponanims as integer
public numshieldanims as integer


private maindestrect   as rect
private mainviewrect   as rect
private backbufferrect as rect

private mainviewwidth as integer
private mainviewheight as integer

private mousetilex as byte
private mousetiley as byte




'�?�?�?�?�?�?�?�?�?�graficos�?�?�?�?�?�?�?�?�?�?�?
public grhdata() as grhdata 'guarda todos los grh
public bodydata() as bodydata
public headdata() as headdata
public fxdata() as tindicefx
public weaponanimdata() as weaponanimdata
public shieldanimdata() as shieldanimdata
public cascoanimdata() as headdata
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

'�?�?�?�?�?�?�?�?�?�mapa?�?�?�?�?�?�?�?�?�?�?�?
public mapdata() as mapblock ' mapa
public mapinfo as mapinfo ' info acerca del mapa en uso
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

public brain        as boolean 'est� raineando?
public btecho       as boolean 'hay techo?
public brsttick     as long

private rlluvia(7)  as rect  'rect de la lluvia
private iframeindex as byte  'frame actual de la ll
private lltick      as long  'contador
private ltlluvia(4) as integer

public charlist(1 to 10000) as char

#if seguridadalkon then

public mi(1 to 1233) as clsmanagerinvisibles
public cualmi as integer

#end if

' used by gettextextentpoint32
private type size
    cx as long
    cy as long
end type

'[code 001]:matux
public enum playloop
    plnone = 0
    pllluviain = 1
    pllluviaout = 2
end enum
'[end]'
'
'       [end]
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

#if conalfab then

private declare function bltalphafast lib "vbabdx" (byref lpddsdest as any, byref lpddssource as any, byval iwidth as long, byval iheight as long, _
        byval pitchsrc as long, byval pitchdst as long, byval dwmode as long) as long
private declare function bltefectonoche lib "vbabdx" (byref lpddsdest as any, byval iwidth as long, byval iheight as long, _
        byval pitchdst as long, byval dwmode as long) as long

#end if

'very percise counter 64bit system counter
private declare function queryperformancefrequency lib "kernel32" (lpfrequency as currency) as long
private declare function queryperformancecounter lib "kernel32" (lpperformancecount as currency) as long

'text width computation. needed to center text.
private declare function gettextextentpoint32 lib "gdi32" alias "gettextextentpoint32a" (byval hdc as long, byval lpsz as string, byval cbstring as long, lpsize as size) as long

sub cargarcabezas()
    dim n as integer
    dim i as long
    dim numheads as integer
    dim miscabezas() as tindicecabeza
    
    n = freefile()
    open app.path & "\init\cabezas.ind" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , numheads
    
    'resize array
    redim headdata(0 to numheads) as headdata
    redim miscabezas(0 to numheads) as tindicecabeza
    
    for i = 1 to numheads
        get #n, , miscabezas(i)
        
        if miscabezas(i).head(1) then
            call initgrh(headdata(i).head(1), miscabezas(i).head(1), 0)
            call initgrh(headdata(i).head(2), miscabezas(i).head(2), 0)
            call initgrh(headdata(i).head(3), miscabezas(i).head(3), 0)
            call initgrh(headdata(i).head(4), miscabezas(i).head(4), 0)
        end if
    next i
    
    close #n
end sub

sub cargarcascos()
    dim n as integer
    dim i as long
    dim numcascos as integer

    dim miscabezas() as tindicecabeza
    
    n = freefile()
    open app.path & "\init\cascos.ind" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , numcascos
    
    'resize array
    redim cascoanimdata(0 to numcascos) as headdata
    redim miscabezas(0 to numcascos) as tindicecabeza
    
    for i = 1 to numcascos
        get #n, , miscabezas(i)
        
        if miscabezas(i).head(1) then
            call initgrh(cascoanimdata(i).head(1), miscabezas(i).head(1), 0)
            call initgrh(cascoanimdata(i).head(2), miscabezas(i).head(2), 0)
            call initgrh(cascoanimdata(i).head(3), miscabezas(i).head(3), 0)
            call initgrh(cascoanimdata(i).head(4), miscabezas(i).head(4), 0)
        end if
    next i
    
    close #n
end sub

sub cargarcuerpos()
    dim n as integer
    dim i as long
    dim numcuerpos as integer
    dim miscuerpos() as tindicecuerpo
    
    n = freefile()
    open app.path & "\init\personajes.ind" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , numcuerpos
    
    'resize array
    redim bodydata(0 to numcuerpos) as bodydata
    redim miscuerpos(0 to numcuerpos) as tindicecuerpo
    
    for i = 1 to numcuerpos
        get #n, , miscuerpos(i)
        
        if miscuerpos(i).body(1) then
            initgrh bodydata(i).walk(1), miscuerpos(i).body(1), 0
            initgrh bodydata(i).walk(2), miscuerpos(i).body(2), 0
            initgrh bodydata(i).walk(3), miscuerpos(i).body(3), 0
            initgrh bodydata(i).walk(4), miscuerpos(i).body(4), 0
            
            bodydata(i).headoffset.x = miscuerpos(i).headoffsetx
            bodydata(i).headoffset.y = miscuerpos(i).headoffsety
        end if
    next i
    
    close #n
end sub

sub cargarfxs()
    dim n as integer
    dim i as long
    dim numfxs as integer
    
    n = freefile()
    open app.path & "\init\fxs.ind" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , numfxs
    
    'resize array
    redim fxdata(1 to numfxs) as tindicefx
    
    for i = 1 to numfxs
        get #n, , fxdata(i)
    next i
    
    close #n
end sub

sub cargartips()
    dim n as integer
    dim i as long
    dim numtips as integer
    
    n = freefile
    open app.path & "\init\tips.ayu" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , numtips
    
    'resize array
    redim tips(1 to numtips) as string * 255
    
    for i = 1 to numtips
        get #n, , tips(i)
    next i
    
    close #n
end sub

sub cargararraylluvia()
    dim n as integer
    dim i as long
    dim nu as integer
    
    n = freefile()
    open app.path & "\init\fk.ind" for binary access read as #n
    
    'cabecera
    get #n, , micabecera
    
    'num de cabezas
    get #n, , nu
    
    'resize array
    redim blluvia(1 to nu) as byte
    
    for i = 1 to nu
        get #n, , blluvia(i)
    next i
    
    close #n
end sub

sub convertcptotp(byval viewportx as integer, byval viewporty as integer, byref tx as byte, byref ty as byte)
'******************************************
'converts where the mouse is in the main window to a tile position. must be called eveytime the mouse moves.
'******************************************
    tx = userpos.x + viewportx \ tilepixelwidth - windowtilewidth \ 2
    ty = userpos.y + viewporty \ tilepixelheight - windowtileheight \ 2
end sub

sub makechar(byval charindex as integer, byval body as integer, byval head as integer, byval heading as byte, byval x as integer, byval y as integer, byval arma as integer, byval escudo as integer, byval casco as integer)
on error resume next
    'apuntamos al ultimo char
    if charindex > lastchar then lastchar = charindex
    
    with charlist(charindex)
        'if the char wasn't allready active (we are rewritting it) don't increase char count
        if .active = 0 then _
            numchars = numchars + 1
        
        if arma = 0 then arma = 2
        if escudo = 0 then escudo = 2
        if casco = 0 then casco = 2
        
        .ihead = head
        .ibody = body
        .head = headdata(head)
        .body = bodydata(body)
        .arma = weaponanimdata(arma)
        
        .escudo = shieldanimdata(escudo)
        .casco = cascoanimdata(casco)
        
        .heading = heading
        
        'reset moving stats
        .moving = 0
        .moveoffsetx = 0
        .moveoffsety = 0
        
        'update position
        .pos.x = x
        .pos.y = y
        
        'make active
        .active = 1
    end with
    
    'plot on map
    mapdata(x, y).charindex = charindex
end sub

sub resetcharinfo(byval charindex as integer)
    with charlist(charindex)
        .active = 0
        .criminal = 0
        .fxindex = 0
        .invisible = false
        
#if seguridadalkon then
        call mi(cualmi).resetinvisible(charindex)
#end if
        
        .moving = 0
        .muerto = false
        .nombre = ""
        .pie = false
        .pos.x = 0
        .pos.y = 0
        .usandoarma = false
    end with
end sub

sub erasechar(byval charindex as integer)
'*****************************************************************
'erases a character from charlist and map
'*****************************************************************
on error resume next
    charlist(charindex).active = 0
    
    'update lastchar
    if charindex = lastchar then
        do until charlist(lastchar).active = 1
            lastchar = lastchar - 1
            if lastchar = 0 then exit do
        loop
    end if
    
    mapdata(charlist(charindex).pos.x, charlist(charindex).pos.y).charindex = 0
    
    'remove char's dialog
    call dialogos.removedialog(charindex)
    
    call resetcharinfo(charindex)
    
    'update numchars
    numchars = numchars - 1
end sub

public sub initgrh(byref grh as grh, byval grhindex as integer, optional byval started as byte = 2)
'*****************************************************************
'sets up a grh. must be done before rendering
'*****************************************************************
    grh.grhindex = grhindex
    
    if started = 2 then
        if grhdata(grh.grhindex).numframes > 1 then
            grh.started = 1
        else
            grh.started = 0
        end if
    else
        'make sure the graphic can be started
        if grhdata(grh.grhindex).numframes = 1 then started = 0
        grh.started = started
    end if
    
    
    if grh.started then
        grh.loops = infinite_loops
    else
        grh.loops = 0
    end if
    
    grh.framecounter = 1
    grh.speed = grhdata(grh.grhindex).speed
end sub

sub movecharbyhead(byval charindex as integer, byval nheading as e_heading)
'*****************************************************************
'starts the movement of a character in nheading direction
'*****************************************************************
    dim addx as integer
    dim addy as integer
    dim x as integer
    dim y as integer
    dim nx as integer
    dim ny as integer
    
    with charlist(charindex)
        x = .pos.x
        y = .pos.y
        
        'figure out which way to move
        select case nheading
            case e_heading.north
                addy = -1
        
            case e_heading.east
                addx = 1
        
            case e_heading.south
                addy = 1
            
            case e_heading.west
                addx = -1
        end select
        
        nx = x + addx
        ny = y + addy
        
        mapdata(nx, ny).charindex = charindex
        .pos.x = nx
        .pos.y = ny
        mapdata(x, y).charindex = 0
        
        .moveoffsetx = -1 * (tilepixelwidth * addx)
        .moveoffsety = -1 * (tilepixelheight * addy)
        
        .moving = 1
        .heading = nheading
        
        .scrolldirectionx = addx
        .scrolldirectiony = addy
    end with
    
    if userestado = 0 then call dopasosfx(charindex)
    
    'areas viejos
    if (ny < minlimitey) or (ny > maxlimitey) or (nx < minlimitex) or (nx > maxlimitex) then
        if charindex <> usercharindex then
            call erasechar(charindex)
        end if
    end if
end sub

public sub dofogatafx()
    dim location as position
    
    if bfogata then
        bfogata = hayfogata(location)
        if not bfogata then
            call audio.stopwave(fogatabufferindex)
            fogatabufferindex = 0
        end if
    else
        bfogata = hayfogata(location)
        if bfogata and fogatabufferindex = 0 then fogatabufferindex = audio.playwave("fuego.wav", location.x, location.y, loopstyle.enabled)
    end if
end sub

private function estapcarea(byval charindex as integer) as boolean
    with charlist(charindex).pos
        estapcarea = .x > userpos.x - minxborder and .x < userpos.x + minxborder and .y > userpos.y - minyborder and .y < userpos.y + minyborder
    end with
end function

sub dopasosfx(byval charindex as integer)
    if not usernavegando then
        with charlist(charindex)
            if not .muerto and estapcarea(charindex) and (.priv = 0 or .priv > 5) then
                .pie = not .pie
                
                if .pie then
                    call audio.playwave(snd_pasos1, .pos.x, .pos.y)
                else
                    call audio.playwave(snd_pasos2, .pos.x, .pos.y)
                end if
            end if
        end with
    else
' todo : actually we would have to check if the charindex char is in the water or not....
        call audio.playwave(snd_navegando, charlist(charindex).pos.x, charlist(charindex).pos.y)
    end if
end sub

sub movecharbypos(byval charindex as integer, byval nx as integer, byval ny as integer)
on error resume next
    dim x as integer
    dim y as integer
    dim addx as integer
    dim addy as integer
    dim nheading as e_heading
    
    with charlist(charindex)
        x = .pos.x
        y = .pos.y
        
        mapdata(x, y).charindex = 0
        
        addx = nx - x
        addy = ny - y
        
        if sgn(addx) = 1 then
            nheading = e_heading.east
        elseif sgn(addx) = -1 then
            nheading = e_heading.west
        elseif sgn(addy) = -1 then
            nheading = e_heading.north
        elseif sgn(addy) = 1 then
            nheading = e_heading.south
        end if
        
        mapdata(nx, ny).charindex = charindex
        
        .pos.x = nx
        .pos.y = ny
        
        .moveoffsetx = -1 * (tilepixelwidth * addx)
        .moveoffsety = -1 * (tilepixelheight * addy)
        
        .moving = 1
        .heading = nheading
        
        .scrolldirectionx = sgn(addx)
        .scrolldirectiony = sgn(addy)
        
        'parche para que no medite cuando camina
        if .fxindex = fxmeditar.chico or .fxindex = fxmeditar.grande or .fxindex = fxmeditar.mediano or .fxindex = fxmeditar.xgrande or .fxindex = fxmeditar.xxgrande then
            .fxindex = 0
        end if
    end with
    
    if not estapcarea(charindex) then call dialogos.removedialog(charindex)
    
    if (ny < minlimitey) or (ny > maxlimitey) or (nx < minlimitex) or (nx > maxlimitex) then
        call erasechar(charindex)
    end if
end sub

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
    
    'check to see if its out of bounds
    if tx < minxborder or tx > maxxborder or ty < minyborder or ty > maxyborder then
        exit sub
    else
        'start moving... mainloop does the rest
        addtouserpos.x = x
        userpos.x = tx
        addtouserpos.y = y
        userpos.y = ty
        usermoving = 1
        
        btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
                mapdata(userpos.x, userpos.y).trigger = 2 or _
                mapdata(userpos.x, userpos.y).trigger = 4, true, false)
    end if
end sub

private function hayfogata(byref location as position) as boolean
    dim j as long
    dim k as long
    
    for j = userpos.x - 8 to userpos.x + 8
        for k = userpos.y - 6 to userpos.y + 6
            if inmapbounds(j, k) then
                if mapdata(j, k).objgrh.grhindex = grhfogata then
                    location.x = j
                    location.y = k
                    
                    hayfogata = true
                    exit function
                end if
            end if
        next k
    next j
end function

function nextopenchar() as integer
'*****************************************************************
'finds next open char slot in charlist
'*****************************************************************
    dim loopc as long
    dim dale as boolean
    
    loopc = 1
    do while charlist(loopc).active and dale
        loopc = loopc + 1
        dale = (loopc <= ubound(charlist))
    loop
    
    nextopenchar = loopc
end function

''
' loads grh data using the new file format.
'
' @return   true if the load was successfull, false otherwise.

private function loadgrhdata() as boolean
on error goto errorhandler
    dim grh as long
    dim frame as long
    dim grhcount as long
    dim handle as integer
    dim fileversion as long
    
    'open files
    handle = freefile()
    
    open inipath & graphicsfile for binary access read as handle
    seek #1, 1
    
    'get file version
    get handle, , fileversion
    
    'get number of grhs
    get handle, , grhcount
    
    'resize arrays
    redim grhdata(1 to grhcount) as grhdata
    
    while not eof(handle)
        get handle, , grh
        
        with grhdata(grh)
            'get number of frames
            get handle, , .numframes
            if .numframes <= 0 then goto errorhandler
            
            redim .frames(1 to grhdata(grh).numframes)
            
            if .numframes > 1 then
                'read a animation grh set
                for frame = 1 to .numframes
                    get handle, , .frames(frame)
                    if .frames(frame) <= 0 or .frames(frame) > grhcount then
                        goto errorhandler
                    end if
                next frame
                
                get handle, , .speed
                
                if .speed <= 0 then goto errorhandler
                
                'compute width and height
                .pixelheight = grhdata(.frames(1)).pixelheight
                if .pixelheight <= 0 then goto errorhandler
                
                .pixelwidth = grhdata(.frames(1)).pixelwidth
                if .pixelwidth <= 0 then goto errorhandler
                
                .tilewidth = grhdata(.frames(1)).tilewidth
                if .tilewidth <= 0 then goto errorhandler
                
                .tileheight = grhdata(.frames(1)).tileheight
                if .tileheight <= 0 then goto errorhandler
            else
                'read in normal grh data
                get handle, , .filenum
                if .filenum <= 0 then goto errorhandler
                
                get handle, , grhdata(grh).sx
                if .sx < 0 then goto errorhandler
                
                get handle, , .sy
                if .sy < 0 then goto errorhandler
                
                get handle, , .pixelwidth
                if .pixelwidth <= 0 then goto errorhandler
                
                get handle, , .pixelheight
                if .pixelheight <= 0 then goto errorhandler
                
                'compute width and height
                .tilewidth = .pixelwidth / tilepixelheight
                .tileheight = .pixelheight / tilepixelwidth
                
                .frames(1) = grh
            end if
        end with
    wend
    
    close handle
    
    loadgrhdata = true
exit function

errorhandler:
    loadgrhdata = false
end function

function legalpos(byval x as integer, byval y as integer) as boolean
'*****************************************************************
'checks to see if a tile position is legal
'*****************************************************************
    'limites del mapa
    if x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
        exit function
    end if
    
    'tile bloqueado?
    if mapdata(x, y).blocked = 1 then
        exit function
    end if
    
    '�hay un personaje?
    if mapdata(x, y).charindex > 0 then
        exit function
    end if
   
    if usernavegando <> hayagua(x, y) then
        exit function
    end if
    
    legalpos = true
end function

function movetolegalpos(byval x as integer, byval y as integer) as boolean
'*****************************************************************
'author: zama
'last modify date: 01/08/2009
'checks to see if a tile position is legal, including if there is a casper in the tile
'10/05/2009: zama - now you can't change position with a casper which is in the shore.
'01/08/2009: zama - now invisible admins can't change position with caspers.
'*****************************************************************
    dim charindex as integer
    
    'limites del mapa
    if x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
        exit function
    end if
    
    'tile bloqueado?
    if mapdata(x, y).blocked = 1 then
        exit function
    end if
    
    charindex = mapdata(x, y).charindex
    '�hay un personaje?
    if charindex > 0 then
    
        if mapdata(userpos.x, userpos.y).blocked = 1 then
            exit function
        end if
        
        with charlist(charindex)
            ' si no es casper, no puede pasar
            if .ihead <> casper_head and .ibody <> fragata_fantasmal then
                exit function
            else
                ' no puedo intercambiar con un casper que este en la orilla (lado tierra)
                if hayagua(userpos.x, userpos.y) then
                    if not hayagua(x, y) then exit function
                else
                    ' no puedo intercambiar con un casper que este en la orilla (lado agua)
                    if hayagua(x, y) then exit function
                end if
                
                ' los admins no pueden intercambiar pos con caspers cuando estan invisibles
                if charlist(usercharindex).priv > 0 and charlist(usercharindex).priv < 6 then
                    if charlist(usercharindex).invisible = true then exit function
                end if
            end if
        end with
    end if
   
    if usernavegando <> hayagua(x, y) then
        exit function
    end if
    
    movetolegalpos = true
end function

function inmapbounds(byval x as integer, byval y as integer) as boolean
'*****************************************************************
'checks to see if a tile position is in the maps bounds
'*****************************************************************
    if x < xminmapsize or x > xmaxmapsize or y < yminmapsize or y > ymaxmapsize then
        exit function
    end if
    
    inmapbounds = true
end function

private sub ddrawgrhtosurface(byref grh as grh, byval x as integer, byval y as integer, byval center as byte, byval animate as byte)
    dim currentgrhindex as integer
    dim sourcerect as rect
on error goto error
        
    if animate then
        if grh.started = 1 then
            grh.framecounter = grh.framecounter + (timerelapsedtime * grhdata(grh.grhindex).numframes / grh.speed)
            if grh.framecounter > grhdata(grh.grhindex).numframes then
                grh.framecounter = (grh.framecounter mod grhdata(grh.grhindex).numframes) + 1
                
                if grh.loops <> infinite_loops then
                    if grh.loops > 0 then
                        grh.loops = grh.loops - 1
                    else
                        grh.started = 0
                    end if
                end if
            end if
        end if
    end if
    
    'figure out what frame to draw (always 1 if not animated)
    currentgrhindex = grhdata(grh.grhindex).frames(grh.framecounter)
    
    with grhdata(currentgrhindex)
        'center grh over x,y pos
        if center then
            if .tilewidth <> 1 then
                x = x - int(.tilewidth * tilepixelwidth / 2) + tilepixelwidth \ 2
            end if
            
            if .tileheight <> 1 then
                y = y - int(.tileheight * tilepixelheight) + tilepixelheight
            end if
        end if
        
        sourcerect.left = .sx
        sourcerect.top = .sy
        sourcerect.right = sourcerect.left + .pixelwidth
        sourcerect.bottom = sourcerect.top + .pixelheight
        
        'draw
        call backbuffersurface.bltfast(x, y, surfacedb.surface(.filenum), sourcerect, ddbltfast_wait)
    end with
exit sub

error:
    if err.number = 9 and grh.framecounter < 1 then
        grh.framecounter = 1
        resume
    else
        msgbox "ocurri� un error inesperado, por favor comuniquelo a los administradores del juego." & vbcrlf & "descripci�n del error: " & _
        vbcrlf & err.description, vbexclamation, "[ " & err.number & " ] error"
        end
    end if
end sub

sub ddrawtransgrhindextosurface(byval grhindex as integer, byval x as integer, byval y as integer, byval center as byte)
    dim sourcerect as rect
    
    with grhdata(grhindex)
        'center grh over x,y pos
        if center then
            if .tilewidth <> 1 then
                x = x - int(.tilewidth * tilepixelwidth / 2) + tilepixelwidth \ 2
            end if
            
            if .tileheight <> 1 then
                y = y - int(.tileheight * tilepixelheight) + tilepixelheight
            end if
        end if
        
        sourcerect.left = .sx
        sourcerect.top = .sy
        sourcerect.right = sourcerect.left + .pixelwidth
        sourcerect.bottom = sourcerect.top + .pixelheight
        
        'draw
        call backbuffersurface.bltfast(x, y, surfacedb.surface(.filenum), sourcerect, ddbltfast_srccolorkey or ddbltfast_wait)
    end with
end sub

sub ddrawtransgrhtosurface(byref grh as grh, byval x as integer, byval y as integer, byval center as byte, byval animate as byte)
'*****************************************************************
'draws a grh transparently to a x and y position
'*****************************************************************
    dim currentgrhindex as integer
    dim sourcerect as rect
    
on error goto error
    
    if animate then
        if grh.started = 1 then
            grh.framecounter = grh.framecounter + (timerelapsedtime * grhdata(grh.grhindex).numframes / grh.speed)
            
            if grh.framecounter > grhdata(grh.grhindex).numframes then
                grh.framecounter = (grh.framecounter mod grhdata(grh.grhindex).numframes) + 1
                
                if grh.loops <> infinite_loops then
                    if grh.loops > 0 then
                        grh.loops = grh.loops - 1
                    else
                        grh.started = 0
                    end if
                end if
            end if
        end if
    end if
    
    'figure out what frame to draw (always 1 if not animated)
    currentgrhindex = grhdata(grh.grhindex).frames(grh.framecounter)
    
    with grhdata(currentgrhindex)
        'center grh over x,y pos
        if center then
            if .tilewidth <> 1 then
                x = x - int(.tilewidth * tilepixelwidth / 2) + tilepixelwidth \ 2
            end if
            
            if .tileheight <> 1 then
                y = y - int(.tileheight * tilepixelheight) + tilepixelheight
            end if
        end if
                
        sourcerect.left = .sx
        sourcerect.top = .sy
        sourcerect.right = sourcerect.left + .pixelwidth
        sourcerect.bottom = sourcerect.top + .pixelheight
        
        'draw
        call backbuffersurface.bltfast(x, y, surfacedb.surface(.filenum), sourcerect, ddbltfast_srccolorkey or ddbltfast_wait)
    end with
exit sub

error:
    if err.number = 9 and grh.framecounter < 1 then
        grh.framecounter = 1
        resume
    else
        msgbox "ocurri� un error inesperado, por favor comuniquelo a los administradores del juego." & vbcrlf & "descripci�n del error: " & _
        vbcrlf & err.description, vbexclamation, "[ " & err.number & " ] error"
        end
    end if
end sub

#if conalfab = 1 then

sub ddrawtransgrhtosurfacealpha(byref grh as grh, byval x as integer, byval y as integer, byval center as byte, byval animate as byte)
'*****************************************************************
'draws a grh transparently to a x and y position
'*****************************************************************
    dim currentgrhindex as integer
    dim sourcerect as rect
    dim src as directdrawsurface7
    dim rdest as rect
    dim darray() as byte, sarray() as byte
    dim ddsdsrc as ddsurfacedesc2, ddsddest as ddsurfacedesc2
    dim modo as long
    
    if animate then
        if grh.started = 1 then
            grh.framecounter = grh.framecounter + (timerelapsedtime * grhdata(grh.grhindex).numframes / grh.speed)
            
            if grh.framecounter > grhdata(grh.grhindex).numframes then
                grh.framecounter = (grh.framecounter mod grhdata(grh.grhindex).numframes) + 1
                
                if grh.loops <> infinite_loops then
                    if grh.loops > 0 then
                        grh.loops = grh.loops - 1
                    else
                        grh.started = 0
                    end if
                end if
            end if
        end if
    end if
    
    'figure out what frame to draw (always 1 if not animated)
    currentgrhindex = grhdata(grh.grhindex).frames(grh.framecounter)
    
    with grhdata(currentgrhindex)
        'center grh over x,y pos
        if center then
            if .tilewidth <> 1 then
                x = x - int(.tilewidth * tilepixelwidth / 2) + tilepixelwidth \ 2
            end if
            if .tileheight <> 1 then
                y = y - int(.tileheight * tilepixelheight) + tilepixelheight
            end if
        end if
        
        sourcerect.left = .sx
        sourcerect.top = .sy
        sourcerect.right = sourcerect.left + .pixelwidth
        sourcerect.bottom = sourcerect.top + .pixelheight
        
        set src = surfacedb.surface(.filenum)
        
        src.getsurfacedesc ddsdsrc
        backbuffersurface.getsurfacedesc ddsddest
        
        rdest.left = x
        rdest.top = y
        rdest.right = x + .pixelwidth
        rdest.bottom = y + .pixelheight
        
        if rdest.right > ddsddest.lwidth then
            rdest.right = ddsddest.lwidth
        end if
        if rdest.bottom > ddsddest.lheight then
            rdest.bottom = ddsddest.lheight
        end if
    end with
    
    ' 0 -> 16 bits 555
    ' 1 -> 16 bits 565
    ' 2 -> 16 bits raro (sin implementar)
    ' 3 -> 24 bits
    ' 4 -> 32 bits
    
    if ddsddest.ddpfpixelformat.lgbitmask = &h3e0& and ddsdsrc.ddpfpixelformat.lgbitmask = &h3e0& then
        modo = 0
    elseif ddsddest.ddpfpixelformat.lgbitmask = &h7e0& and ddsdsrc.ddpfpixelformat.lgbitmask = &h7e0& then
        modo = 1
'todo : revisar las m�scaras de 24!! quiz�s mirando el campo lrgbbitcount para diferenciar 24 de 32...
    elseif ddsddest.ddpfpixelformat.lgbitmask = &h7e0& and ddsdsrc.ddpfpixelformat.lgbitmask = &h7e0& then
        modo = 3
    elseif ddsddest.ddpfpixelformat.lgbitmask = &hff00& and ddsdsrc.ddpfpixelformat.lgbitmask = &hff00& then
        modo = 4
    else
        'modo = 2 '16 bits raro ?
        call backbuffersurface.bltfast(x, y, src, sourcerect, ddbltfast_srccolorkey or ddbltfast_wait)
        exit sub
    end if
    
    dim srclock as boolean
    dim dstlock as boolean
    
    srclock = false
    dstlock = false
    
on local error goto hayerroralpha
    
    call src.lock(sourcerect, ddsdsrc, ddlock_wait, 0)
    srclock = true
    call backbuffersurface.lock(rdest, ddsddest, ddlock_wait, 0)
    dstlock = true
    
    call backbuffersurface.getlockedarray(darray())
    call src.getlockedarray(sarray())
    
    call bltalphafast(byval varptr(darray(x + x, y)), byval varptr(sarray(sourcerect.left * 2, sourcerect.top)), rdest.right - rdest.left, rdest.bottom - rdest.top, ddsdsrc.lpitch, ddsddest.lpitch, modo)
    
    backbuffersurface.unlock rdest
    dstlock = false
    src.unlock sourcerect
    srclock = false
exit sub

hayerroralpha:
    if srclock then src.unlock sourcerect
    if dstlock then backbuffersurface.unlock rdest
end sub

#end if 'conalfab = 1

function getbitmapdimensions(byval bmpfile as string, byref bmwidth as long, byref bmheight as long)
'*****************************************************************
'gets the dimensions of a bmp
'*****************************************************************
    dim bmheader as bitmapfileheader
    dim binfoheader as bitmapinfoheader
    
    open bmpfile for binary access read as #1
    
    get #1, , bmheader
    get #1, , binfoheader
    
    close #1
    
    bmwidth = binfoheader.biwidth
    bmheight = binfoheader.biheight
end function

sub drawgrhtohdc(byval hdc as long, byval grhindex as integer, byref sourcerect as rect, byref destrect as rect)
'*****************************************************************
'draws a grh's portion to the given area of any device context
'*****************************************************************
    call surfacedb.surface(grhdata(grhindex).filenum).blttodc(hdc, sourcerect, destrect)
end sub

sub renderscreen(byval tilex as integer, byval tiley as integer, byval pixeloffsetx as integer, byval pixeloffsety as integer)
'**************************************************************
'author: aaron perkins
'last modify date: 8/14/2007
'last modified by: juan mart�n sotuyo dodero (maraxus)
'renders everything to the viewport
'**************************************************************
    dim y           as long     'keeps track of where on map we are
    dim x           as long     'keeps track of where on map we are
    dim screenminy  as integer  'start y pos on current screen
    dim screenmaxy  as integer  'end y pos on current screen
    dim screenminx  as integer  'start x pos on current screen
    dim screenmaxx  as integer  'end x pos on current screen
    dim miny        as integer  'start y pos on current map
    dim maxy        as integer  'end y pos on current map
    dim minx        as integer  'start x pos on current map
    dim maxx        as integer  'end x pos on current map
    dim screenx     as integer  'keeps track of where to place tile on screen
    dim screeny     as integer  'keeps track of where to place tile on screen
    dim minxoffset  as integer
    dim minyoffset  as integer
    dim pixeloffsetxtemp as integer 'for centering grhs
    dim pixeloffsetytemp as integer 'for centering grhs
    
    
    'figure out ends and starts of screen
    screenminy = tiley - halfwindowtileheight
    screenmaxy = tiley + halfwindowtileheight
    screenminx = tilex - halfwindowtilewidth
    screenmaxx = tilex + halfwindowtilewidth
    
    miny = screenminy - tilebuffersize
    maxy = screenmaxy + tilebuffersize
    minx = screenminx - tilebuffersize
    maxx = screenmaxx + tilebuffersize
    
    'make sure mins and maxs are allways in map bounds
    if miny < xminmapsize then
        minyoffset = yminmapsize - miny
        miny = yminmapsize
    end if
    
    if maxy > ymaxmapsize then maxy = ymaxmapsize
    
    if minx < xminmapsize then
        minxoffset = xminmapsize - minx
        minx = xminmapsize
    end if
    
    if maxx > xmaxmapsize then maxx = xmaxmapsize
    
    'if we can, we render around the view area to make it smoother
    if screenminy > yminmapsize then
        screenminy = screenminy - 1
    else
        screenminy = 1
        screeny = 1
    end if
    
    if screenmaxy < ymaxmapsize then screenmaxy = screenmaxy + 1
    
    if screenminx > xminmapsize then
        screenminx = screenminx - 1
    else
        screenminx = 1
        screenx = 1
    end if
    
    if screenmaxx < xmaxmapsize then screenmaxx = screenmaxx + 1
    
    'draw floor layer
    for y = screenminy to screenmaxy
        for x = screenminx to screenmaxx
            
            'layer 1 **********************************
            call ddrawgrhtosurface(mapdata(x, y).graphic(1), _
                (screenx - 1) * tilepixelwidth + pixeloffsetx + tilebufferpixeloffsetx, _
                (screeny - 1) * tilepixelheight + pixeloffsety + tilebufferpixeloffsety, _
                0, 1)
            '******************************************
            
            screenx = screenx + 1
        next x
        
        'reset screenx to original value and increment screeny
        screenx = screenx - x + screenminx
        screeny = screeny + 1
    next y
    
    'draw floor layer 2
    screeny = minyoffset
    for y = miny to maxy
        screenx = minxoffset
        for x = minx to maxx
            
            'layer 2 **********************************
            if mapdata(x, y).graphic(2).grhindex <> 0 then
                call ddrawtransgrhtosurface(mapdata(x, y).graphic(2), _
                        (screenx - 1) * tilepixelwidth + pixeloffsetx, _
                        (screeny - 1) * tilepixelheight + pixeloffsety, _
                        1, 1)
            end if
            '******************************************
            
            screenx = screenx + 1
        next x
        screeny = screeny + 1
    next y
    
    'draw transparent layers
    screeny = minyoffset
    for y = miny to maxy
        screenx = minxoffset
        for x = minx to maxx
            pixeloffsetxtemp = (screenx - 1) * tilepixelwidth + pixeloffsetx
            pixeloffsetytemp = (screeny - 1) * tilepixelheight + pixeloffsety
            
            with mapdata(x, y)
                'object layer **********************************
                if .objgrh.grhindex <> 0 then
                    call ddrawtransgrhtosurface(.objgrh, _
                            pixeloffsetxtemp, pixeloffsetytemp, 1, 1)
                end if
                '***********************************************
                
                
                'char layer ************************************
                if .charindex <> 0 then
                    call charrender(.charindex, pixeloffsetxtemp, pixeloffsetytemp)
                end if
                '*************************************************
                
                
                'layer 3 *****************************************
                if .graphic(3).grhindex <> 0 then
                    'draw
                    call ddrawtransgrhtosurface(.graphic(3), _
                            pixeloffsetxtemp, pixeloffsetytemp, 1, 1)
                end if
                '************************************************
            end with
            
            screenx = screenx + 1
        next x
        screeny = screeny + 1
    next y
    
    if not btecho then
        'draw blocked tiles and grid
        screeny = minyoffset
        for y = miny to maxy
            screenx = minxoffset
            for x = minx to maxx
                
                'layer 4 **********************************
                if mapdata(x, y).graphic(4).grhindex then
                    'draw
                    call ddrawtransgrhtosurface(mapdata(x, y).graphic(4), _
                        (screenx - 1) * tilepixelwidth + pixeloffsetx, _
                        (screeny - 1) * tilepixelheight + pixeloffsety, _
                        1, 1)
                end if
                '**********************************
                
                screenx = screenx + 1
            next x
            screeny = screeny + 1
        next y
    end if
    
'todo : check this!!
    if blluvia(usermap) = 1 then
        if brain then
            'figure out what frame to draw
            if lltick < directx.tickcount - 50 then
                iframeindex = iframeindex + 1
                if iframeindex > 7 then iframeindex = 0
                lltick = directx.tickcount
            end if

            for y = 0 to 4
                for x = 0 to 4
                    call backbuffersurface.bltfast(ltlluvia(y), ltlluvia(x), surfacedb.surface(5556), rlluvia(iframeindex), ddbltfast_srccolorkey + ddbltfast_wait)
                next x
            next y
        end if
    end if
end sub

public function rendersounds()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/30/2008
'actualiza todos los sonidos del mapa.
'**************************************************************
    if blluvia(usermap) = 1 then
        if brain then
            if btecho then
                if frmmain.isplaying <> playloop.pllluviain then
                    if rainbufferindex then _
                        call audio.stopwave(rainbufferindex)
                    rainbufferindex = audio.playwave("lluviain.wav", 0, 0, loopstyle.enabled)
                    frmmain.isplaying = playloop.pllluviain
                end if
            else
                if frmmain.isplaying <> playloop.pllluviaout then
                    if rainbufferindex then _
                        call audio.stopwave(rainbufferindex)
                    rainbufferindex = audio.playwave("lluviaout.wav", 0, 0, loopstyle.enabled)
                    frmmain.isplaying = playloop.pllluviaout
                end if
            end if
        end if
    end if
    
    dofogatafx
end function

function hayuserabajo(byval x as integer, byval y as integer, byval grhindex as integer) as boolean
    if grhindex > 0 then
        hayuserabajo = _
            charlist(usercharindex).pos.x >= x - (grhdata(grhindex).tilewidth \ 2) _
                and charlist(usercharindex).pos.x <= x + (grhdata(grhindex).tilewidth \ 2) _
                and charlist(usercharindex).pos.y >= y - (grhdata(grhindex).tileheight - 1) _
                and charlist(usercharindex).pos.y <= y
    end if
end function

sub loadgraphics()
'**************************************************************
'author: juan mart�n sotuyo dodero - complete rewrite
'last modify date: 11/03/2006
'initializes the surfacedb and sets up the rain rects
'**************************************************************
    'new surface manager :d
    call surfacedb.initialize(directdraw, clientsetup.busevideo, dirgraficos, clientsetup.bymemory)
    
    'set up te rain rects
    rlluvia(0).top = 0:      rlluvia(1).top = 0:      rlluvia(2).top = 0:      rlluvia(3).top = 0
    rlluvia(0).left = 0:     rlluvia(1).left = 128:   rlluvia(2).left = 256:   rlluvia(3).left = 384
    rlluvia(0).right = 128:  rlluvia(1).right = 256:  rlluvia(2).right = 384:  rlluvia(3).right = 512
    rlluvia(0).bottom = 128: rlluvia(1).bottom = 128: rlluvia(2).bottom = 128: rlluvia(3).bottom = 128
    
    rlluvia(4).top = 128:    rlluvia(5).top = 128:    rlluvia(6).top = 128:    rlluvia(7).top = 128
    rlluvia(4).left = 0:     rlluvia(5).left = 128:   rlluvia(6).left = 256:   rlluvia(7).left = 384
    rlluvia(4).right = 128:  rlluvia(5).right = 256:  rlluvia(6).right = 384:  rlluvia(7).right = 512
    rlluvia(4).bottom = 256: rlluvia(5).bottom = 256: rlluvia(6).bottom = 256: rlluvia(7).bottom = 256
end sub

public function inittileengine(byval setdisplayformhwnd as long, byval setmainviewtop as integer, byval setmainviewleft as integer, byval settilepixelheight as integer, byval settilepixelwidth as integer, byval setwindowtileheight as integer, byval setwindowtilewidth as integer, byval settilebuffersize as integer, byval pixelstoscrollperframex as integer, pixelstoscrollperframey as integer, byval enginespeed as single) as boolean
'***************************************************
'author: aaron perkins
'last modification: 08/14/07
'last modified by: juan mart�n sotuyo dodero (maraxus)
'creates all dx objects and configures the engine to start running.
'***************************************************
    dim surfacedesc as ddsurfacedesc2
    dim ddck as ddcolorkey
    
    inipath = app.path & "\init\"
    
    'fill startup variables
    mainviewtop = setmainviewtop
    mainviewleft = setmainviewleft
    tilepixelwidth = settilepixelwidth
    tilepixelheight = settilepixelheight
    windowtileheight = setwindowtileheight
    windowtilewidth = setwindowtilewidth
    tilebuffersize = settilebuffersize
    
    halfwindowtileheight = setwindowtileheight \ 2
    halfwindowtilewidth = setwindowtilewidth \ 2
    
    'compute offset in pixels when rendering tile buffer.
    'we diminish by one to get the top-left corner of the tile for rendering.
    tilebufferpixeloffsetx = ((tilebuffersize - 1) * tilepixelwidth)
    tilebufferpixeloffsety = ((tilebuffersize - 1) * tilepixelheight)
    
    enginebasespeed = enginespeed
    
    'set fps value to 60 for startup
    fps = 60
    framesperseccounter = 60
    
    minxborder = xminmapsize + (windowtilewidth \ 2)
    maxxborder = xmaxmapsize - (windowtilewidth \ 2)
    minyborder = yminmapsize + (windowtileheight \ 2)
    maxyborder = ymaxmapsize - (windowtileheight \ 2)
    
    mainviewwidth = tilepixelwidth * windowtilewidth
    mainviewheight = tilepixelheight * windowtileheight
    
    'resize mapdata array
    redim mapdata(xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
    
    'set intial user position
    userpos.x = minxborder
    userpos.y = minyborder
    
    'set scroll pixels per frame
    scrollpixelsperframex = pixelstoscrollperframex
    scrollpixelsperframey = pixelstoscrollperframey
    
    'set the view rect
    with mainviewrect
        .left = mainviewleft
        .top = mainviewtop
        .right = .left + mainviewwidth
        .bottom = .top + mainviewheight
    end with
    
    'set the dest rect
    with maindestrect
        .left = tilepixelwidth * tilebuffersize - tilepixelwidth
        .top = tilepixelheight * tilebuffersize - tilepixelheight
        .right = .left + mainviewwidth
        .bottom = .top + mainviewheight
    end with
    
on error resume next
    set directx = new directx7
    
    if err then
        msgbox "no se puede iniciar directx. por favor asegurese de tener la ultima version correctamente instalada."
        exit function
    end if

    
    '****** init directdraw ******
    ' create the root directdraw object
    set directdraw = directx.directdrawcreate("")
    
    if err then
        msgbox "no se puede iniciar directdraw. por favor asegurese de tener la ultima version correctamente instalada."
        exit function
    end if
    
on error goto 0
    call directdraw.setcooperativelevel(setdisplayformhwnd, ddscl_normal)
    
    'primary surface
    ' fill the surface description structure
    with surfacedesc
        .lflags = ddsd_caps
        .ddscaps.lcaps = ddscaps_primarysurface
    end with
    ' create the surface
    set primarysurface = directdraw.createsurface(surfacedesc)
    
    'create primary clipper
    set primaryclipper = directdraw.createclipper(0)
    call primaryclipper.sethwnd(frmmain.hwnd)
    call primarysurface.setclipper(primaryclipper)
    
    with backbufferrect
        .left = 0
        .top = 0
        .right = tilepixelwidth * (windowtilewidth + 2 * tilebuffersize)
        .bottom = tilepixelheight * (windowtileheight + 2 * tilebuffersize)
    end with
    
    with surfacedesc
        .lflags = ddsd_caps or ddsd_height or ddsd_width
        if clientsetup.busevideo then
            .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_videomemory
        else
            .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
        end if
        .lheight = backbufferrect.bottom
        .lwidth = backbufferrect.right
    end with
    
    ' create surface
    set backbuffersurface = directdraw.createsurface(surfacedesc)
    
    'set color key
    ddck.low = 0
    ddck.high = 0
    call backbuffersurface.setcolorkey(ddckey_srcblt, ddck)
    
    'set font transparency
    call backbuffersurface.setfonttransparency(d_true)
    
    call loadgrhdata
    call cargarcuerpos
    call cargarcabezas
    call cargarcascos
    call cargarfxs
    
    
    ltlluvia(0) = 224
    ltlluvia(1) = 352
    ltlluvia(2) = 480
    ltlluvia(3) = 608
    ltlluvia(4) = 736
    
    call loadgraphics
    
    inittileengine = true
end function

public sub deinittileengine()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/14/07
'destroys all dx objects
'***************************************************
on error resume next
    set primarysurface = nothing
    set primaryclipper = nothing
    set backbuffersurface = nothing
    
    set directdraw = nothing
    
    set directx = nothing
end sub

sub shownextframe(byval displayformtop as integer, byval displayformleft as integer, byval mouseviewx as integer, byval mouseviewy as integer)
'***************************************************
'author: arron perkins
'last modification: 08/14/07
'last modified by: juan mart�n sotuyo dodero (maraxus)
'updates the game's model and renders everything.
'***************************************************
    static offsetcounterx as single
    static offsetcountery as single
    
    '****** set main view rectangle ******
    mainviewrect.left = (displayformleft / screen.twipsperpixelx) + mainviewleft
    mainviewrect.top = (displayformtop / screen.twipsperpixely) + mainviewtop
    mainviewrect.right = mainviewrect.left + mainviewwidth
    mainviewrect.bottom = mainviewrect.top + mainviewheight
    
    if enginerun then
        if usermoving then
            '****** move screen left and right if needed ******
            if addtouserpos.x <> 0 then
                offsetcounterx = offsetcounterx - scrollpixelsperframex * addtouserpos.x * timerticksperframe
                if abs(offsetcounterx) >= abs(tilepixelwidth * addtouserpos.x) then
                    offsetcounterx = 0
                    addtouserpos.x = 0
                    usermoving = false
                end if
            end if
            
            '****** move screen up and down if needed ******
            if addtouserpos.y <> 0 then
                offsetcountery = offsetcountery - scrollpixelsperframey * addtouserpos.y * timerticksperframe
                if abs(offsetcountery) >= abs(tilepixelheight * addtouserpos.y) then
                    offsetcountery = 0
                    addtouserpos.y = 0
                    usermoving = false
                end if
            end if
        end if
        
        'update mouse position within view area
        call convertcptotp(mouseviewx, mouseviewy, mousetilex, mousetiley)
        
        '****** update screen ******
        if userciego then
            call cleanviewport
        else
            call renderscreen(userpos.x - addtouserpos.x, userpos.y - addtouserpos.y, offsetcounterx, offsetcountery)
        end if
        
        if iscombate then call rendertext(260, 260, "modo combate", vbred, frmmain.font)
        
        call dialogos.render
        call dibujarcartel
        
        call dialogosclanes.draw
        
        'display front-buffer!
        call primarysurface.blt(mainviewrect, backbuffersurface, maindestrect, ddblt_wait)
        
        'limit fps to 100 (an easy number higher than monitor's vertical refresh rates)
        while (directx.tickcount - fpslastcheck) \ 10 < framesperseccounter
            sleep 5
        wend
        
        'fps update
        if fpslastcheck + 1000 < directx.tickcount then
            fps = framesperseccounter
            framesperseccounter = 1
            fpslastcheck = directx.tickcount
        else
            framesperseccounter = framesperseccounter + 1
        end if
        
        'get timing info
        timerelapsedtime = getelapsedtime()
        timerticksperframe = timerelapsedtime * enginebasespeed
    end if
end sub

#if conalfab then

public sub efectonoche(byref surface as directdrawsurface7)
    dim darray() as byte
    dim ddsddest as ddsurfacedesc2
    dim modo as long
    dim rrect as rect
    
    surface.getsurfacedesc ddsddest
    
    with rrect
        .left = 0
        .top = 0
        .right = ddsddest.lwidth
        .bottom = ddsddest.lheight
    end with
    
    if ddsddest.ddpfpixelformat.lgbitmask = &h3e0 then
        modo = 0
    elseif ddsddest.ddpfpixelformat.lgbitmask = &h7e0 then
        modo = 1
    else
        modo = 2
    end if
    
    dim dstlock as boolean
    dstlock = false
    
    on local error goto hayerroralpha
    
    surface.lock rrect, ddsddest, ddlock_wait, 0
    dstlock = true
    
    surface.getlockedarray darray()
    call bltefectonoche(byval varptr(darray(0, 0)), _
        ddsddest.lwidth, ddsddest.lheight, ddsddest.lpitch, _
        modo)
    
hayerroralpha:
    if dstlock = true then
        surface.unlock rrect
        dstlock = false
    end if
end sub

#end if

public sub rendertext(byval lngxpos as integer, byval lngypos as integer, byref strtext as string, byval lngcolor as long, byref font as stdfont)
    if strtext <> "" then
        call backbuffersurface.setforecolor(vbblack)
        call backbuffersurface.setfont(font)
        call backbuffersurface.drawtext(lngxpos - 2, lngypos - 1, strtext, false)
        
        call backbuffersurface.setforecolor(lngcolor)
        call backbuffersurface.drawtext(lngxpos, lngypos, strtext, false)
    end if
end sub

public sub rendertextcentered(byval lngxpos as integer, byval lngypos as integer, byref strtext as string, byval lngcolor as long, byref font as stdfont)
    dim hdc as long
    dim ret as size
    
    if strtext <> "" then
        call backbuffersurface.setfont(font)
        
        'get width of text once rendered
        hdc = backbuffersurface.getdc()
        call gettextextentpoint32(hdc, strtext, len(strtext), ret)
        call backbuffersurface.releasedc(hdc)
        
        lngxpos = lngxpos - ret.cx \ 2
        
        call backbuffersurface.setforecolor(vbblack)
        call backbuffersurface.drawtext(lngxpos - 2, lngypos - 1, strtext, false)
        
        call backbuffersurface.setforecolor(lngcolor)
        call backbuffersurface.drawtext(lngxpos, lngypos, strtext, false)
    end if
end sub

private function getelapsedtime() as single
'**************************************************************
'author: aaron perkins
'last modify date: 10/07/2002
'gets the time that past since the last call
'**************************************************************
    dim start_time as currency
    static end_time as currency
    static timer_freq as currency

    'get the timer frequency
    if timer_freq = 0 then
        queryperformancefrequency timer_freq
    end if
    
    'get current time
    call queryperformancecounter(start_time)
    
    'calculate elapsed time
    getelapsedtime = (start_time - end_time) / timer_freq * 1000
    
    'get next end time
    call queryperformancecounter(end_time)
end function

private sub charrender(byval charindex as long, byval pixeloffsetx as integer, byval pixeloffsety as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/03/04
'draw char's to screen without offcentering them
'***************************************************
    dim moved as boolean
    dim pos as integer
    dim line as string
    dim color as long
    
    with charlist(charindex)
        if .moving then
            'if needed, move left and right
            if .scrolldirectionx <> 0 then
                .moveoffsetx = .moveoffsetx + scrollpixelsperframex * sgn(.scrolldirectionx) * timerticksperframe
                
                'start animations
'todo : este parche es para evita los uncornos exploten al moverse!! rever!!!
                if .body.walk(.heading).speed > 0 then _
                    .body.walk(.heading).started = 1
                .arma.weaponwalk(.heading).started = 1
                .escudo.shieldwalk(.heading).started = 1
                
                'char moved
                moved = true
                
                'check if we already got there
                if (sgn(.scrolldirectionx) = 1 and .moveoffsetx >= 0) or _
                        (sgn(.scrolldirectionx) = -1 and .moveoffsetx <= 0) then
                    .moveoffsetx = 0
                    .scrolldirectionx = 0
                end if
            end if
            
            'if needed, move up and down
            if .scrolldirectiony <> 0 then
                .moveoffsety = .moveoffsety + scrollpixelsperframey * sgn(.scrolldirectiony) * timerticksperframe
                
                'start animations
'todo : este parche es para evita los uncornos exploten al moverse!! rever!!!
                if .body.walk(.heading).speed > 0 then _
                    .body.walk(.heading).started = 1
                .arma.weaponwalk(.heading).started = 1
                .escudo.shieldwalk(.heading).started = 1
                
                'char moved
                moved = true
                
                'check if we already got there
                if (sgn(.scrolldirectiony) = 1 and .moveoffsety >= 0) or _
                        (sgn(.scrolldirectiony) = -1 and .moveoffsety <= 0) then
                    .moveoffsety = 0
                    .scrolldirectiony = 0
                end if
            end if
        end if
        
        'if done moving stop animation
        if not moved then
            'stop animations
            .body.walk(.heading).started = 0
            .body.walk(.heading).framecounter = 1
            
            .arma.weaponwalk(.heading).started = 0
            .arma.weaponwalk(.heading).framecounter = 1
            
            .escudo.shieldwalk(.heading).started = 0
            .escudo.shieldwalk(.heading).framecounter = 1
            
            .moving = false
        end if
        
        pixeloffsetx = pixeloffsetx + .moveoffsetx
        pixeloffsety = pixeloffsety + .moveoffsety
        
        if .head.head(.heading).grhindex then
            if not .invisible then
                'draw body
                if .body.walk(.heading).grhindex then _
                    call ddrawtransgrhtosurface(.body.walk(.heading), pixeloffsetx, pixeloffsety, 1, 1)
            
                'draw head
                if .head.head(.heading).grhindex then
                    call ddrawtransgrhtosurface(.head.head(.heading), pixeloffsetx + .body.headoffset.x, pixeloffsety + .body.headoffset.y, 1, 0)
                    
                    'draw helmet
                    if .casco.head(.heading).grhindex then _
                        call ddrawtransgrhtosurface(.casco.head(.heading), pixeloffsetx + .body.headoffset.x, pixeloffsety + .body.headoffset.y, 1, 0)
                    
                    'draw weapon
                    if .arma.weaponwalk(.heading).grhindex then _
                        call ddrawtransgrhtosurface(.arma.weaponwalk(.heading), pixeloffsetx, pixeloffsety, 1, 1)
                    
                    'draw shield
                    if .escudo.shieldwalk(.heading).grhindex then _
                        call ddrawtransgrhtosurface(.escudo.shieldwalk(.heading), pixeloffsetx, pixeloffsety, 1, 1)
                
                
                    'draw name over head
                    if lenb(.nombre) > 0 then
                        if nombres and esgm(usercharindex) or abs(mousetilex - .pos.x) < 2 and (abs(mousetiley - .pos.y)) < 2 then
                            pos = gettagposition(.nombre)
                            'pos = instr(.nombre, "<")
                            'if pos = 0 then pos = len(.nombre) + 2
                            
                            if .priv = 0 then
                                if .criminal then
                                    color = rgb(colorespj(50).r, colorespj(50).g, colorespj(50).b)
                                else
                                    color = rgb(colorespj(49).r, colorespj(49).g, colorespj(49).b)
                                end if
                            else
                                color = rgb(colorespj(.priv).r, colorespj(.priv).g, colorespj(.priv).b)
                            end if
                            
                            'nick
                            line = left$(.nombre, pos - 2)
                            call rendertextcentered(pixeloffsetx + tilepixelwidth \ 2 + 5, pixeloffsety + 30, line, color, frmmain.font)
                            
                            'clan
                            line = mid$(.nombre, pos)
                            call rendertextcentered(pixeloffsetx + tilepixelwidth \ 2 + 5, pixeloffsety + 45, line, color, frmmain.font)
                        end if
                    end if
                end if
            end if
        else
            'draw body
            if .body.walk(.heading).grhindex then _
                call ddrawtransgrhtosurface(.body.walk(.heading), pixeloffsetx, pixeloffsety, 1, 1)
        end if

        
        'update dialogs
        call dialogos.updatedialogpos(pixeloffsetx + .body.headoffset.x, pixeloffsety + .body.headoffset.y, charindex)
        
        'draw fx
        if .fxindex <> 0 then
#if (conalfab = 1) then
            call ddrawtransgrhtosurfacealpha(.fx, pixeloffsetx + fxdata(.fxindex).offsetx, pixeloffsety + fxdata(.fxindex).offsety, 1, 1)
#else
            call ddrawtransgrhtosurface(.fx, pixeloffsetx + fxdata(.fxindex).offsetx, pixeloffsety + fxdata(.fxindex).offsety, 1, 1)
#end if
            
            'check if animation is over
            if .fx.started = 0 then _
                .fxindex = 0
        end if
    end with
end sub

public sub setcharacterfx(byval charindex as integer, byval fx as integer, byval loops as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/03/04
'sets an fx to the character.
'***************************************************
    with charlist(charindex)
        .fxindex = fx
        
        if .fxindex > 0 then
            call initgrh(.fx, fxdata(fx).animacion)
        
            .fx.loops = loops
        end if
    end with
end sub

private sub cleanviewport()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/03/04
'fills the viewport with black.
'***************************************************
    dim r as rect
    call backbuffersurface.bltcolorfill(r, vbblack)
end sub
