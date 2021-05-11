attribute vb_name = "mod_tileengine"
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

'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'    c       o       n       s      t
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'map sizes in tiles
public const xmaxmapsize = 100
public const xminmapsize = 1
public const ymaxmapsize = 100
public const yminmapsize = 1

public const grhfogata = 1521

'bltbit constant
public const srccopy = &hcc0020 ' (dword) dest = source


'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'    t       i      p      o      s
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

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
    x as integer
    y as integer
end type

'posicion en el mundo
public type worldpos
    map as integer
    x as integer
    y as integer
end type

'contiene info acerca de donde se puede encontrar un grh
'tama�o y animacion
public type grhdata
    sx as integer
    sy as integer
    filenum as integer
    pixelwidth as integer
    pixelheight as integer
    tilewidth as single
    tileheight as single
    
    numframes as integer
    frames(1 to 25) as integer
    speed as integer
end type

'apunta a una estructura grhdata y mantiene la animacion
public type grh
    grhindex as integer
    framecounter as byte
    speedcounter as byte
    started as byte
end type

'lista de cuerpos
public type bodydata
    walk(1 to 4) as grh
    headoffset as position
end type

'lista de cabezas
public type headdata
    head(1 to 4) as grh
end type

'lista de las animaciones de las armas
type weaponanimdata
    weaponwalk(1 to 4) as grh
end type

'lista de las animaciones de los escudos
type shieldanimdata
    shieldwalk(1 to 4) as grh
end type


'lista de cuerpos
public type fxdata
    fx as grh
    offsetx as long
    offsety as long
end type

'apariencia del personaje
public type char
    active as byte
    heading as byte
    pos as position

    body as bodydata
    head as headdata
    casco as headdata
    arma as weaponanimdata
    escudo as shieldanimdata
    usandoarma as boolean
    fx as integer
    fxlooptimes as integer
    criminal as byte
    
    nombre as string
    
    moving as byte
    moveoffset as position
    serverindex as integer
    
    pie as boolean
    muerto as boolean
    invisible as boolean
    
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
    
    'me only
    changed as byte
end type


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

public usermaxagu as integer
public userminagu as integer
public usermaxham as integer
public userminham as integer

public enginerun as boolean
public framespersec as integer
public framesperseccounter as long

'tama�o del la vista en tiles
public windowtilewidth as integer
public windowtileheight as integer

'offset del desde 0,0 del main view
public mainviewtop as integer
public mainviewleft as integer

'cuantos tiles el engine mete en el buffer cuando
'dibuja el mapa. ojo un tama�o muy grande puede
'volver el engine muy lento
public tilebuffersize as integer

'handle to where all the drawing is going to take place
public displayformhwnd as long

'tama�o de los tiles en pixels
public tilepixelheight as integer
public tilepixelwidth as integer

'?�?�?�?�?�?�?�?�?�?�totales?�?�?�?�?�?�?�?�?�?�?

public numbodies as integer
public numheads as integer
public numfxs as integer

public numchars as integer
public lastchar as integer
public numweaponanims as integer
public numshieldanims as integer

'�?�?�?�?�?�?�?�?�?�graficos�?�?�?�?�?�?�?�?�?�?�?

public lasttime as long 'para controlar la velocidad


'[code]:matux'
public maindestrect   as rect
'[end]'
public mainviewrect   as rect
public backbufferrect as rect

public mainviewwidth as integer
public mainviewheight as integer




'�?�?�?�?�?�?�?�?�?�graficos�?�?�?�?�?�?�?�?�?�?�?
public grhdata() as grhdata 'guarda todos los grh
public bodydata() as bodydata
public headdata() as headdata
public fxdata() as fxdata
public weaponanimdata() as weaponanimdata
public shieldanimdata() as shieldanimdata
public cascoanimdata() as headdata
public grh() as grh 'animaciones publicas
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

'�?�?�?�?�?�?�?�?�?�mapa?�?�?�?�?�?�?�?�?�?�?�?
public mapdata() as mapblock ' mapa
public mapinfo as mapinfo ' info acerca del mapa en uso
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

'�?�?�?�?�?�?�?�?�?�usuarios?�?�?�?�?�?�?�?�?�?�?�?�?
public charlist(1 to 10000) as char
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

'�?�?�?�?�?�?�?�?�?�?�api?�?�?�?�?�?�?�?�?�?�?�?�?�?
'blt
public declare function bitblt lib "gdi32" (byval hdestdc as long, byval x as long, byval y as long, byval nwidth as long, byval nheight as long, byval hsrcdc as long, byval xsrc as long, byval ysrc as long, byval dwrop as long) as long
'sonido
declare function mcisendstring lib "winmm.dll" alias "mcisendstringa" (byval lpstrcommand as string, byval lpstrreturnstring as string, byval uretrunlength as long, byval hwndcallback as long) as long
declare function sndplaysound lib "winmm.dll" alias "sndplaysounda" (byval lpszsoundname as string, byval uflags as long) as long
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?


'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'       [code 000]: matux
'
public brain        as boolean 'est� raineando?
public brainst      as boolean
public btecho       as boolean 'hay techo?
public brsttick     as long

private rlluvia(7)  as rect  'rect de la lluvia
private iframeindex as byte  'frame actual de la ll
private lltick      as long  'contador
private ltlluvia(4) as integer
            
'estados internos del surface (read only)
public enum texturestatus
    tsoriginal = 0
    tsnight = 1
    tsfog = 2
end enum

'[code 001]:matux
    public enum playloop
        plnone = 0
        pllluviain = 1
        pllluviaout = 2
        plfogata = 3
    end enum
'[end]'
'
'       [end]
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

sub cargarcabezas()
on error resume next
dim n as integer, i as integer, numheads as integer, index as integer

dim miscabezas() as tindicecabeza

n = freefile
open app.path & "\init\cabezas.ind" for binary access read as #n

'cabecera
get #n, , micabecera

'num de cabezas
get #n, , numheads

'resize array
redim headdata(0 to numheads + 1) as headdata
redim miscabezas(0 to numheads + 1) as tindicecabeza

for i = 1 to numheads
    get #n, , miscabezas(i)
    initgrh headdata(i).head(1), miscabezas(i).head(1), 0
    initgrh headdata(i).head(2), miscabezas(i).head(2), 0
    initgrh headdata(i).head(3), miscabezas(i).head(3), 0
    initgrh headdata(i).head(4), miscabezas(i).head(4), 0
next i

close #n

end sub

sub cargarcascos()
on error resume next
dim n as integer, i as integer, numcascos as integer, index as integer

dim miscabezas() as tindicecabeza

n = freefile
open app.path & "\init\cascos.ind" for binary access read as #n

'cabecera
get #n, , micabecera

'num de cabezas
get #n, , numcascos

'resize array
redim cascoanimdata(0 to numcascos + 1) as headdata
redim miscabezas(0 to numcascos + 1) as tindicecabeza

for i = 1 to numcascos
    get #n, , miscabezas(i)
    initgrh cascoanimdata(i).head(1), miscabezas(i).head(1), 0
    initgrh cascoanimdata(i).head(2), miscabezas(i).head(2), 0
    initgrh cascoanimdata(i).head(3), miscabezas(i).head(3), 0
    initgrh cascoanimdata(i).head(4), miscabezas(i).head(4), 0
next i

close #n

end sub

sub cargarcuerpos()
on error resume next
dim n as integer, i as integer
dim numcuerpos as integer
dim miscuerpos() as tindicecuerpo

n = freefile
open app.path & "\init\personajes.ind" for binary access read as #n

'cabecera
get #n, , micabecera

'num de cabezas
get #n, , numcuerpos

'resize array
redim bodydata(0 to numcuerpos + 1) as bodydata
redim miscuerpos(0 to numcuerpos + 1) as tindicecuerpo

for i = 1 to numcuerpos
    get #n, , miscuerpos(i)
    initgrh bodydata(i).walk(1), miscuerpos(i).body(1), 0
    initgrh bodydata(i).walk(2), miscuerpos(i).body(2), 0
    initgrh bodydata(i).walk(3), miscuerpos(i).body(3), 0
    initgrh bodydata(i).walk(4), miscuerpos(i).body(4), 0
    bodydata(i).headoffset.x = miscuerpos(i).headoffsetx
    bodydata(i).headoffset.y = miscuerpos(i).headoffsety
next i

close #n

end sub
sub cargarfxs()
on error resume next
dim n as integer, i as integer
dim numfxs as integer
dim misfxs() as tindicefx

n = freefile
open app.path & "\init\fxs.ind" for binary access read as #n

'cabecera
get #n, , micabecera

'num de cabezas
get #n, , numfxs

'resize array
redim fxdata(0 to numfxs + 1) as fxdata
redim misfxs(0 to numfxs + 1) as tindicefx

for i = 1 to numfxs
    get #n, , misfxs(i)
    call initgrh(fxdata(i).fx, misfxs(i).animacion, 1)
    fxdata(i).offsetx = misfxs(i).offsetx
    fxdata(i).offsety = misfxs(i).offsety
next i

close #n

end sub

sub cargartips()
on error resume next
dim n as integer, i as integer
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
on error resume next
dim n as integer, i as integer
dim nu as integer

n = freefile
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
sub convertcptotp(startpixelleft as integer, startpixeltop as integer, byval cx as single, byval cy as single, tx as integer, ty as integer)
'******************************************
'converts where the user clicks in the main window
'to a tile position
'******************************************
dim hwindowx as integer
dim hwindowy as integer

cx = cx - startpixelleft
cy = cy - startpixeltop

hwindowx = (windowtilewidth \ 2)
hwindowy = (windowtileheight \ 2)

'figure out x and y tiles
cx = (cx \ tilepixelwidth)
cy = (cy \ tilepixelheight)

if cx > hwindowx then
    cx = (cx - hwindowx)

else
    if cx < hwindowx then
        cx = (0 - (hwindowx - cx))
    else
        cx = 0
    end if
end if

if cy > hwindowy then
    cy = (0 - (hwindowy - cy))
else
    if cy < hwindowy then
        cy = (cy - hwindowy)
    else
        cy = 0
    end if
end if

tx = userpos.x + cx
ty = userpos.y + cy

end sub






sub makechar(byval charindex as integer, byval body as integer, byval head as integer, byval heading as byte, byval x as integer, byval y as integer, byval arma as integer, byval escudo as integer, byval casco as integer)

on error resume next

'apuntamos al ultimo char
if charindex > lastchar then lastchar = charindex

numchars = numchars + 1

if arma = 0 then arma = 2
if escudo = 0 then escudo = 2
if casco = 0 then casco = 2

charlist(charindex).head = headdata(head)

charlist(charindex).body = bodydata(body)
charlist(charindex).arma = weaponanimdata(arma)
    
charlist(charindex).escudo = shieldanimdata(escudo)
charlist(charindex).casco = cascoanimdata(casco)

charlist(charindex).heading = heading

'reset moving stats
charlist(charindex).moving = 0
charlist(charindex).moveoffset.x = 0
charlist(charindex).moveoffset.y = 0

'update position
charlist(charindex).pos.x = x
charlist(charindex).pos.y = y

'make active
charlist(charindex).active = 1

'plot on map
mapdata(x, y).charindex = charindex

end sub

sub resetcharinfo(byval charindex as integer)

charlist(charindex).active = 0
charlist(charindex).criminal = 0
charlist(charindex).fx = 0
charlist(charindex).fxlooptimes = 0
charlist(charindex).invisible = false
charlist(charindex).moving = 0
charlist(charindex).muerto = false
charlist(charindex).nombre = ""
charlist(charindex).pie = false
charlist(charindex).pos.x = 0
charlist(charindex).pos.y = 0
charlist(charindex).usandoarma = false

end sub


sub erasechar(byval charindex as integer)
on error resume next

'*****************************************************************
'erases a character from charlist and map
'*****************************************************************

charlist(charindex).active = 0

'update lastchar
if charindex = lastchar then
    do until charlist(lastchar).active = 1
        lastchar = lastchar - 1
        if lastchar = 0 then exit do
    loop
end if


mapdata(charlist(charindex).pos.x, charlist(charindex).pos.y).charindex = 0

call resetcharinfo(charindex)

'update numchars
numchars = numchars - 1

end sub

sub initgrh(byref grh as grh, byval grhindex as integer, optional started as byte = 2)
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
    grh.started = started
end if

grh.framecounter = 1
'[code 000]:matux
'
'  la linea generaba un error en la ide, (no ocurr�a debido al
' on error)
'
'   grh.speedcounter = grhdata(grh.grhindex).speed
'
if grh.grhindex <> 0 then grh.speedcounter = grhdata(grh.grhindex).speed
'
'[end]'

end sub

sub movecharbyhead(charindex as integer, nheading as byte)
'*****************************************************************
'starts the movement of a character in nheading direction
'*****************************************************************
dim addx as integer
dim addy as integer
dim x as integer
dim y as integer
dim nx as integer
dim ny as integer

x = charlist(charindex).pos.x
y = charlist(charindex).pos.y

'figure out which way to move
select case nheading

    case north
        addy = -1

    case east
        addx = 1

    case south
        addy = 1
    
    case west
        addx = -1
        
end select

nx = x + addx
ny = y + addy

mapdata(nx, ny).charindex = charindex
charlist(charindex).pos.x = nx
charlist(charindex).pos.y = ny
mapdata(x, y).charindex = 0

charlist(charindex).moveoffset.x = -1 * (tilepixelwidth * addx)
charlist(charindex).moveoffset.y = -1 * (tilepixelheight * addy)

charlist(charindex).moving = 1
charlist(charindex).heading = nheading

if userestado <> 1 then call dopasosfx(charindex)


end sub


public sub dofogatafx()
if fx = 0 then
    if bfogata then
        bfogata = hayfogata()
        if not bfogata then frmmain.stopsound
    else
        bfogata = hayfogata()
        if bfogata then frmmain.play "fuego.wav", true
    end if
end if
end sub

function estapcarea(byval index2 as integer) as boolean

dim x as integer, y as integer

for y = userpos.y - minyborder + 1 to userpos.y + minyborder - 1
  for x = userpos.x - minxborder + 1 to userpos.x + minxborder - 1
            
            if mapdata(x, y).charindex = index2 then
                estapcarea = true
                exit function
            end if
        
  next x
next y

estapcarea = false

end function


sub dopasosfx(byval charindex as integer)
static pie as boolean

if not usernavegando then
        if not charlist(charindex).muerto and estapcarea(charindex) then
            charlist(charindex).pie = not charlist(charindex).pie
            if charlist(charindex).pie then
                call playwaveds(snd_pasos1)
            else
                call playwaveds(snd_pasos2)
            end if
        end if
else
        call playwaveds(snd_navegando)
end if

end sub


sub movecharbypos(charindex as integer, nx as integer, ny as integer)

on error resume next

dim x as integer
dim y as integer
dim addx as integer
dim addy as integer
dim nheading as byte



x = charlist(charindex).pos.x
y = charlist(charindex).pos.y

mapdata(x, y).charindex = 0

addx = nx - x
addy = ny - y

if sgn(addx) = 1 then
    nheading = east
end if

if sgn(addx) = -1 then
    nheading = west
end if

if sgn(addy) = -1 then
    nheading = north
end if

if sgn(addy) = 1 then
    nheading = south
end if

mapdata(nx, ny).charindex = charindex


charlist(charindex).pos.x = nx
charlist(charindex).pos.y = ny

charlist(charindex).moveoffset.x = -1 * (tilepixelwidth * addx)
charlist(charindex).moveoffset.y = -1 * (tilepixelheight * addy)

charlist(charindex).moving = 1
charlist(charindex).heading = nheading




end sub

sub movescreen(heading as byte)
'******************************************
'starts the screen moving in a direction
'******************************************
dim x as integer
dim y as integer
dim tx as integer
dim ty as integer

'figure out which way to move
select case heading

    case north
        y = -1

    case east
        x = 1

    case south
        y = 1
    
    case west
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
   
end if


    

end sub


function hayfogata() as boolean
dim j as integer, k as integer
for j = userpos.x - 8 to userpos.x + 8
    for k = userpos.y - 6 to userpos.y + 6
        if inmapbounds(j, k) then
            if mapdata(j, k).objgrh.grhindex = grhfogata then
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
dim loopc as integer

loopc = 1
do while charlist(loopc).active
    loopc = loopc + 1
loop

nextopenchar = loopc

end function


sub loadgrhdata()
'*****************************************************************
'loads grh.dat
'*****************************************************************

on error goto errorhandler

dim grh as integer
dim frame as integer
dim tempint as integer




'resize arrays
redim grhdata(1 to config_inicio.numerodebmps) as grhdata

'open files
open inipath & "graficos.ind" for binary access read as #1
seek #1, 1

get #1, , micabecera
get #1, , tempint
get #1, , tempint
get #1, , tempint
get #1, , tempint
get #1, , tempint

'fill grh list

'get first grh number
get #1, , grh

do until grh <= 0
        
    'get number of frames
    get #1, , grhdata(grh).numframes
    if grhdata(grh).numframes <= 0 then goto errorhandler
    
    if grhdata(grh).numframes > 1 then
    
        'read a animation grh set
        for frame = 1 to grhdata(grh).numframes
        
            get #1, , grhdata(grh).frames(frame)
            if grhdata(grh).frames(frame) <= 0 or grhdata(grh).frames(frame) > config_inicio.numerodebmps then
                goto errorhandler
            end if
        
        next frame
    
        get #1, , grhdata(grh).speed
        if grhdata(grh).speed <= 0 then goto errorhandler
        
        'compute width and height
        grhdata(grh).pixelheight = grhdata(grhdata(grh).frames(1)).pixelheight
        if grhdata(grh).pixelheight <= 0 then goto errorhandler
        
        grhdata(grh).pixelwidth = grhdata(grhdata(grh).frames(1)).pixelwidth
        if grhdata(grh).pixelwidth <= 0 then goto errorhandler
        
        grhdata(grh).tilewidth = grhdata(grhdata(grh).frames(1)).tilewidth
        if grhdata(grh).tilewidth <= 0 then goto errorhandler
        
        grhdata(grh).tileheight = grhdata(grhdata(grh).frames(1)).tileheight
        if grhdata(grh).tileheight <= 0 then goto errorhandler
    
    else
    
        'read in normal grh data
        get #1, , grhdata(grh).filenum
        if grhdata(grh).filenum <= 0 then goto errorhandler
        
        get #1, , grhdata(grh).sx
        if grhdata(grh).sx < 0 then goto errorhandler
        
        get #1, , grhdata(grh).sy
        if grhdata(grh).sy < 0 then goto errorhandler
            
        get #1, , grhdata(grh).pixelwidth
        if grhdata(grh).pixelwidth <= 0 then goto errorhandler
        
        get #1, , grhdata(grh).pixelheight
        if grhdata(grh).pixelheight <= 0 then goto errorhandler
        
        'compute width and height
        grhdata(grh).tilewidth = grhdata(grh).pixelwidth / tilepixelheight
        grhdata(grh).tileheight = grhdata(grh).pixelheight / tilepixelwidth
        
        grhdata(grh).frames(1) = grh
            
    end if

    'get next grh number
    get #1, , grh

loop
'************************************************

close #1

exit sub

errorhandler:
close #1
msgbox "error while loading the grh.dat! stopped at grh number: " & grh

end sub

function legalpos(x as integer, y as integer) as boolean
'*****************************************************************
'checks to see if a tile position is legal
'*****************************************************************

'limites del mapa
if x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
    legalpos = false
    exit function
end if

    'tile bloqueado?
    if mapdata(x, y).blocked = 1 then
        legalpos = false
        exit function
    end if
    
    '�hay un personaje?
    if mapdata(x, y).charindex > 0 then
        legalpos = false
        exit function
    end if
   
    if not usernavegando then
        if hayagua(x, y) then
            legalpos = false
            exit function
        end if
    else
        if not hayagua(x, y) then
            legalpos = false
            exit function
        end if
    end if
    
legalpos = true

end function




function inmaplegalbounds(x as integer, y as integer) as boolean
'*****************************************************************
'checks to see if a tile position is in the maps
'legal/walkable bounds
'*****************************************************************

if x < minxborder or x > maxxborder or y < minyborder or y > maxyborder then
    inmaplegalbounds = false
    exit function
end if

inmaplegalbounds = true

end function

function inmapbounds(x as integer, y as integer) as boolean
'*****************************************************************
'checks to see if a tile position is in the maps bounds
'*****************************************************************

if x < xminmapsize or x > xmaxmapsize or y < yminmapsize or y > ymaxmapsize then
    inmapbounds = false
    exit function
end if

inmapbounds = true

end function

sub ddrawgrhtosurface(surface as directdrawsurface7, grh as grh, byval x as integer, byval y as integer, center as byte, animate as byte)

dim currentgrh as grh
dim destrect as rect
dim sourcerect as rect
dim surfacedesc as ddsurfacedesc2

if animate then
    if grh.started = 1 then
        if grh.speedcounter > 0 then
            grh.speedcounter = grh.speedcounter - 1
            if grh.speedcounter = 0 then
                grh.speedcounter = grhdata(grh.grhindex).speed
                grh.framecounter = grh.framecounter + 1
                if grh.framecounter > grhdata(grh.grhindex).numframes then
                    grh.framecounter = 1
                end if
            end if
        end if
    end if
end if
'figure out what frame to draw (always 1 if not animated)
currentgrh.grhindex = grhdata(grh.grhindex).frames(grh.framecounter)
'center grh over x,y pos
if center then
    if grhdata(currentgrh.grhindex).tilewidth <> 1 then
        x = x - int(grhdata(currentgrh.grhindex).tilewidth * 16) + 16 'hard coded for speed
    end if
    if grhdata(currentgrh.grhindex).tileheight <> 1 then
        y = y - int(grhdata(currentgrh.grhindex).tileheight * 32) + 32 'hard coded for speed
    end if
end if
with sourcerect
        .left = grhdata(currentgrh.grhindex).sx
        .top = grhdata(currentgrh.grhindex).sy
        .right = .left + grhdata(currentgrh.grhindex).pixelwidth
        .bottom = .top + grhdata(currentgrh.grhindex).pixelheight
end with
surface.bltfast x, y, surfacedb(grhdata(currentgrh.grhindex).filenum), sourcerect, ddbltfast_wait
end sub

sub ddrawtransgrhindextosurface(surface as directdrawsurface7, grh as integer, byval x as integer, byval y as integer, center as byte, animate as byte)
dim currentgrh as grh
dim destrect as rect
dim sourcerect as rect
dim surfacedesc as ddsurfacedesc2

with destrect
    .left = x
    .top = y
    .right = .left + grhdata(grh).pixelwidth
    .bottom = .top + grhdata(grh).pixelheight
end with

surface.getsurfacedesc surfacedesc

'draw
if destrect.left >= 0 and destrect.top >= 0 and destrect.right <= surfacedesc.lwidth and destrect.bottom <= surfacedesc.lheight then
    with sourcerect
        .left = grhdata(grh).sx
        .top = grhdata(grh).sy
        .right = .left + grhdata(grh).pixelwidth
        .bottom = .top + grhdata(grh).pixelheight
    end with
    
    surface.bltfast destrect.left, destrect.top, surfacedb.getbmp(grhdata(grh).filenum), sourcerect, ddbltfast_srccolorkey or ddbltfast_wait
end if

end sub

'sub ddrawtransgrhtosurface(surface as directdrawsurface7, grh as grh, x as integer, y as integer, center as byte, animate as byte, optional byval killanim as integer = 0)
'[code 000]:matux
    sub ddrawtransgrhtosurface(surface as directdrawsurface7, grh as grh, byval x as integer, byval y as integer, center as byte, animate as byte, optional byval killanim as integer = 0)
'[end]'
'*****************************************************************
'draws a grh transparently to a x and y position
'*****************************************************************
'[code]:matux
'
'  currentgrh.grhindex = igrhindex
'
'[end]

'dim currentgrh as grh
dim igrhindex as integer
'dim destrect as rect
dim sourcerect as rect
'dim surfacedesc as ddsurfacedesc2
dim quitaranimacion as boolean


if animate then
    if grh.started = 1 then
        if grh.speedcounter > 0 then
            grh.speedcounter = grh.speedcounter - 1
            if grh.speedcounter = 0 then
                grh.speedcounter = grhdata(grh.grhindex).speed
                grh.framecounter = grh.framecounter + 1
                if grh.framecounter > grhdata(grh.grhindex).numframes then
                    grh.framecounter = 1
                    if killanim then
                        if charlist(killanim).fxlooptimes <> loopadeternum then
                            
                            if charlist(killanim).fxlooptimes > 0 then charlist(killanim).fxlooptimes = charlist(killanim).fxlooptimes - 1
                            if charlist(killanim).fxlooptimes < 1 then 'matamos la anim del fx ;))
                                charlist(killanim).fx = 0
                                exit sub
                            end if
                            
                        end if
                    end if
               end if
            end if
        end if
    end if
end if

if grh.grhindex = 0 then exit sub

'figure out what frame to draw (always 1 if not animated)
igrhindex = grhdata(grh.grhindex).frames(grh.framecounter)

'center grh over x,y pos
if center then
    if grhdata(igrhindex).tilewidth <> 1 then
        x = x - int(grhdata(igrhindex).tilewidth * 16) + 16 'hard coded for speed
    end if
    if grhdata(igrhindex).tileheight <> 1 then
        y = y - int(grhdata(igrhindex).tileheight * 32) + 32 'hard coded for speed
    end if
end if

with sourcerect
    .left = grhdata(igrhindex).sx
    .top = grhdata(igrhindex).sy
    .right = .left + grhdata(igrhindex).pixelwidth
    .bottom = .top + grhdata(igrhindex).pixelheight
end with

surface.bltfast x, y, surfacedb.getbmp(grhdata(igrhindex).filenum), sourcerect, ddbltfast_srccolorkey or ddbltfast_wait

end sub

sub drawbackbuffersurface()
primarysurface.blt mainviewrect, backbuffersurface, maindestrect, ddblt_wait
end sub

function getbitmapdimensions(bmpfile as string, byref bmwidth as long, byref bmheight as long)
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



sub drawgrhtohdc(hwnd as long, hdc as long, grh as integer, sourcerect as rect, destrect as rect)
if grh <= 0 then exit sub

secundaryclipper.sethwnd hwnd
surfacedb.getbmp(grhdata(grh).filenum).blttodc hdc, sourcerect, destrect
end sub


sub playwaveapi(file as string)
'*****************************************************************
'plays a wave using windows apis
'*****************************************************************
dim rc as integer

rc = sndplaysound(file, snd_async)

end sub
sub renderscreen(tilex as integer, tiley as integer, pixeloffsetx as integer, pixeloffsety as integer)


on error resume next

if userciego then exit sub

dim y        as integer 'keeps track of where on map we are
dim x        as integer 'keeps track of where on map we are
dim miny     as integer 'start y pos on current map
dim maxy     as integer 'end y pos on current map
dim minx     as integer 'start x pos on current map
dim maxx     as integer 'end x pos on current map
dim screenx  as integer 'keeps track of where to place tile on screen
dim screeny  as integer 'keeps track of where to place tile on screen
dim moved    as byte
dim grh      as grh     'temp grh for show tile and blocked
dim tempchar as char
dim textx    as integer
dim texty    as integer
dim ippx     as integer 'usado en el layer de chars
dim ippy     as integer 'usado en el layer de chars
dim rsourcerect      as rect    'usado en el layer 1
dim igrhindex        as integer 'usado en el layer 1
dim pixeloffsetxtemp as integer 'for centering grhs
dim pixeloffsetytemp as integer 'for centering grhs

'figure out ends and starts of screen
' hardcodeado para speed!
miny = (tiley - 15)
maxy = (tiley + 15)
minx = (tilex - 17)
maxx = (tilex + 17)

'draw floor layer
screeny = 8 + rendermod.iimagesize
for y = (miny + 8) + rendermod.iimagesize to (maxy - 8) - rendermod.iimagesize
    screenx = 8 + rendermod.iimagesize
    for x = (minx + 8) + rendermod.iimagesize to (maxx - 8) - rendermod.iimagesize
        if x > 100 or y < 1 then exit for
        'layer 1 **********************************
        with mapdata(x, y).graphic(1)
            if (.started = 1) then
                if (.speedcounter > 0) then
                    .speedcounter = .speedcounter - 1
                    if (.speedcounter = 0) then
                        .speedcounter = grhdata(.grhindex).speed
                        .framecounter = .framecounter + 1
                        if (.framecounter > grhdata(.grhindex).numframes) then _
                            .framecounter = 1
                    end if
                end if
            end if

            'figure out what frame to draw (always 1 if not animated)
            igrhindex = grhdata(.grhindex).frames(.framecounter)
        end with

        rsourcerect.left = grhdata(igrhindex).sx
        rsourcerect.top = grhdata(igrhindex).sy
        rsourcerect.right = rsourcerect.left + grhdata(igrhindex).pixelwidth
        rsourcerect.bottom = rsourcerect.top + grhdata(igrhindex).pixelheight

        'el width fue hardcodeado para speed!
        call backbuffersurface.bltfast( _
                ((32 * screenx) - 32) + pixeloffsetx, _
                ((32 * screeny) - 32) + pixeloffsety, _
                surfacedb.getbmp(grhdata(igrhindex).filenum), _
                rsourcerect, _
                ddbltfast_wait)
        '******************************************
        if not rendermod.bnocostas then
            'layer 2 **********************************
            if mapdata(x, y).graphic(2).grhindex <> 0 then
                call ddrawtransgrhtosurface( _
                        backbuffersurface, _
                        mapdata(x, y).graphic(2), _
                        ((32 * screenx) - 32) + pixeloffsetx, _
                        ((32 * screeny) - 32) + pixeloffsety, _
                        1, _
                        1)
            end if
            '******************************************
        end if
        screenx = screenx + 1
    next x
    screeny = screeny + 1
    if y > 100 then exit for
next y

'draw transparent layers  (layer 2, 3)
screeny = 8 + rendermod.iimagesize
for y = (miny + 8) + rendermod.iimagesize to (maxy - 1) - rendermod.iimagesize
    screenx = 5 + rendermod.iimagesize
    for x = (minx + 5) + rendermod.iimagesize to (maxx - 5) - rendermod.iimagesize
        if x > 100 or x < -3 then exit for
        ippx = ((32 * screenx) - 32) + pixeloffsetx
        ippy = ((32 * screeny) - 32) + pixeloffsety

        'object layer **********************************
        if mapdata(x, y).objgrh.grhindex <> 0 then
            call ddrawtransgrhtosurface( _
                    backbuffersurface, _
                    mapdata(x, y).objgrh, _
                    ippx, ippy, 1, 1)
        end if
        '***********************************************
        'char layer ************************************
        if mapdata(x, y).charindex <> 0 then
            tempchar = charlist(mapdata(x, y).charindex)
            pixeloffsetxtemp = pixeloffsetx
            pixeloffsetytemp = pixeloffsety

            moved = 0
            'if needed, move left and right
            if tempchar.moveoffset.x <> 0 then
                tempchar.body.walk(tempchar.heading).started = 1
                tempchar.arma.weaponwalk(tempchar.heading).started = 1
                tempchar.escudo.shieldwalk(tempchar.heading).started = 1
                pixeloffsetxtemp = pixeloffsetxtemp + tempchar.moveoffset.x
                tempchar.moveoffset.x = tempchar.moveoffset.x - (8 * sgn(tempchar.moveoffset.x))
                moved = 1
            end if
            'if needed, move up and down
            if tempchar.moveoffset.y <> 0 then
                tempchar.body.walk(tempchar.heading).started = 1
                tempchar.arma.weaponwalk(tempchar.heading).started = 1
                tempchar.escudo.shieldwalk(tempchar.heading).started = 1
                pixeloffsetytemp = pixeloffsetytemp + tempchar.moveoffset.y
                tempchar.moveoffset.y = tempchar.moveoffset.y - (8 * sgn(tempchar.moveoffset.y))
                moved = 1
            end if
            'if done moving stop animation
            if moved = 0 and tempchar.moving = 1 then
                tempchar.moving = 0
                tempchar.body.walk(tempchar.heading).framecounter = 1
                tempchar.body.walk(tempchar.heading).started = 0
                tempchar.arma.weaponwalk(tempchar.heading).framecounter = 1
                tempchar.arma.weaponwalk(tempchar.heading).started = 0
                tempchar.escudo.shieldwalk(tempchar.heading).framecounter = 1
                tempchar.escudo.shieldwalk(tempchar.heading).started = 0
            end if

            'dibuja solamente players
            ippx = ((32 * screenx) - 32) + pixeloffsetxtemp
            ippy = ((32 * screeny) - 32) + pixeloffsetytemp
            if tempchar.head.head(tempchar.heading).grhindex <> 0 then
                if not charlist(mapdata(x, y).charindex).invisible then
                    '[cuerpo]'
                        call ddrawtransgrhtosurface(backbuffersurface, tempchar.body.walk(tempchar.heading), _
                                (((32 * screenx) - 32) + pixeloffsetxtemp), _
                                (((32 * screeny) - 32) + pixeloffsetytemp), _
                                1, 1)
                    '[end]'
                    '[cabeza]'
                        call ddrawtransgrhtosurface( _
                                backbuffersurface, _
                                tempchar.head.head(tempchar.heading), _
                                ippx + tempchar.body.headoffset.x, _
                                ippy + tempchar.body.headoffset.y, _
                                1, 0)
                    '[end]'
                    '[casco]'
                        if tempchar.casco.head(tempchar.heading).grhindex <> 0 then
                            call ddrawtransgrhtosurface( _
                                    backbuffersurface, _
                                    tempchar.casco.head(tempchar.heading), _
                                    ippx + tempchar.body.headoffset.x, _
                                    ippy + tempchar.body.headoffset.y, _
                                    1, 0)
                        end if
                    '[end]'
                    '[arma]'
                        if tempchar.arma.weaponwalk(tempchar.heading).grhindex <> 0 then
                            call ddrawtransgrhtosurface( _
                                    backbuffersurface, _
                                    tempchar.arma.weaponwalk(tempchar.heading), _
                                    ippx, ippy, 1, 1)
                        end if
                    '[end]'
                    '[escudo]'
                        if tempchar.escudo.shieldwalk(tempchar.heading).grhindex <> 0 then
                            call ddrawtransgrhtosurface( _
                                    backbuffersurface, _
                                    tempchar.escudo.shieldwalk(tempchar.heading), _
                                    ippx, ippy, 1, 1)
                        end if
                    '[end]'
                end if

                if dialogos.cantidaddialogos > 0 then
                    call dialogos.update_dialog_pos( _
                            (ippx + tempchar.body.headoffset.x), _
                            (ippy + tempchar.body.headoffset.y), _
                            mapdata(x, y).charindex)
                end if
                
                if nombres then
                    if tempchar.invisible = false then
                        if tempchar.nombre <> "" then
                                dim lcenter as long
                                lcenter = len(tempchar.nombre) \ 2
                                if instr(tempchar.nombre, "<") > 0 and instr(tempchar.nombre, ">") > 0 then
                                    dim sclan as string: sclan = mid(tempchar.nombre, instr(tempchar.nombre, "<"))
                                    if tempchar.criminal then
                                        call dialogos.drawtext(ippx - lcenter, ippy + 30, left(tempchar.nombre, instr(tempchar.nombre, "<") - 1), rgb(255, 0, 0))
                                        lcenter = len(sclan) \ 2
                                        call dialogos.drawtext(ippx - lcenter, ippy + 45, sclan, rgb(255, 0, 0))
                                    else
                                        call dialogos.drawtext(ippx - lcenter, ippy + 30, left(tempchar.nombre, instr(tempchar.nombre, "<") - 1), rgb(0, 128, 255))
                                        lcenter = len(sclan) * 2
                                        call dialogos.drawtext(ippx - lcenter, ippy + 45, sclan, rgb(0, 128, 255))
                                    end if
                                else
                                    if tempchar.criminal then
                                        call dialogos.drawtext(ippx - lcenter, ippy + 30, tempchar.nombre, rgb(255, 0, 0))
                                    else
                                        call dialogos.drawtext(ippx - lcenter, ippy + 30, tempchar.nombre, rgb(0, 128, 255))
                                    end if
                                end if
                        end if
                    end if
                end if
                
            else '<-> if tempchar.head.head(tempchar.heading).grhindex <> 0 then

                if dialogos.cantidaddialogos > 0 then
                    call dialogos.update_dialog_pos( _
                            (ippx + tempchar.body.headoffset.x), _
                            (ippy + tempchar.body.headoffset.y), _
                            mapdata(x, y).charindex)
                end if

                call ddrawtransgrhtosurface( _
                        backbuffersurface, _
                        tempchar.body.walk(tempchar.heading), _
                        ippx, ippy, 1, 1)
                        
            end if '<-> if tempchar.head.head(tempchar.heading).grhindex <> 0 then

            
            'refresh charlist
            charlist(mapdata(x, y).charindex) = tempchar

            'blitfx (tm)
            if charlist(mapdata(x, y).charindex).fx <> 0 then
                call ddrawtransgrhtosurface( _
                        backbuffersurface, _
                        fxdata(tempchar.fx).fx, _
                        ippx + fxdata(tempchar.fx).offsetx, _
                        ippy + fxdata(tempchar.fx).offsety, _
                        1, 1, mapdata(x, y).charindex)
            end if
        end if '<-> if mapdata(x, y).charindex <> 0 then
        '*************************************************
        'layer 3 *****************************************
        if mapdata(x, y).graphic(3).grhindex <> 0 then
            'draw
            call ddrawtransgrhtosurface( _
                    backbuffersurface, _
                    mapdata(x, y).graphic(3), _
                    ((32 * screenx) - 32) + pixeloffsetx, _
                    ((32 * screeny) - 32) + pixeloffsety, _
                    1, 1)
        end if
        '************************************************
        screenx = screenx + 1
    next x
    screeny = screeny + 1
    if y >= 100 or y < 1 then exit for
next y

if not btecho then
    'draw blocked tiles and grid
    screeny = 5 + rendermod.iimagesize
    for y = (miny + 5) + rendermod.iimagesize to (maxy - 1) - rendermod.iimagesize
        screenx = 5 + rendermod.iimagesize
        for x = (minx + 5) + rendermod.iimagesize to (maxx - 0) - rendermod.iimagesize
            'check to see if in bounds
            if x < 101 and x > 0 and y < 101 and y > 0 then
            if mapdata(x, y).graphic(4).grhindex <> 0 then
                'draw
                call ddrawtransgrhtosurface( _
                    backbuffersurface, _
                    mapdata(x, y).graphic(4), _
                    ((32 * screenx) - 32) + pixeloffsetx, _
                    ((32 * screeny) - 32) + pixeloffsety, _
                    1, 1)
            end if
            end if
            screenx = screenx + 1
        next x
        screeny = screeny + 1
    next y
end if

if blluvia(usermap) = 1 then
    if brain or brainst then
                'figure out what frame to draw
                if lltick < directx.tickcount - 50 then
                    iframeindex = iframeindex + 1
                    if iframeindex > 7 then iframeindex = 0
                    lltick = directx.tickcount
                end if
    
                for y = 0 to 4
                    for x = 0 to 4
                        call backbuffersurface.bltfast(ltlluvia(y), ltlluvia(x), surfacedb.getbmp(5556), rlluvia(iframeindex), ddbltfast_srccolorkey + ddbltfast_wait)
                    next x
                next y
    end if
end if

'[useless]:el codigo para llamar a la noche, nublado, etc.
'            if btecho then
'                dim bbarray() as byte, nnarray() as byte
'                dim ddsdbb as ddsurfacedesc2 'backbuffer
'                dim ddsdnn as ddsurfacedesc2 'nnublado
'                dim r as rect, r2 as rect
'                dim retval as long
'                '[lock]:backbuffersurface
'                    backbuffersurface.getsurfacedesc ddsdbb
'                    'backbuffersurface.lock r, ddsdbb, ddlock_nosyslock + ddlock_writeonly + ddlock_wait, 0
'                    backbuffersurface.lock r, ddsdbb, ddlock_writeonly + ddlock_wait, 0
'                    backbuffersurface.getlockedarray bbarray()
''                '[lock]:bbmask
''                    surfacexu(2).getsurfacedesc ddsdnn
''                    'surfacexu(2).lock r2, ddsdnn, ddlock_readonly + ddlock_nosyslock + ddlock_wait, 0
''                    surfacexu(2).lock r2, ddsdnn, ddlock_readonly + ddlock_wait, 0
''                    surfacexu(2).getlockedarray nnarray()
'                '[blit]'
'                    'retval = blitnoche(bbarray(0, 0), ddsdbb.lheight, ddsdbb.lwidth, 0)
'                    'retval = blitnublar(bbarray(0, 0), ddsdbb.lheight, ddsdbb.lwidth)
'                    'retval = blitnublarmmx(bbarray(0, 0), nnarray(0, 0), ddsdbb.lheight, ddsdbb.lwidth, ddsdbb.lpitch, ddsdnn.lheight, ddsdnn.lwidth, ddsdnn.lpitch)
'                '[unlock]'
'                    backbuffersurface.unlock r
'                    'surfacexu(2).unlock r2
'                '[end]'
'                if retval = -1 then msgbox "error!"
'            end if
'[end]'
end sub
public function rendersounds()
'[code 001]:matux'
    if blluvia(usermap) = 1 then
        if brain then
            if btecho then
                if frmmain.isplaying <> pllluviain then
                    call frmmain.stopsound
                    call frmmain.play("lluviain.wav", true)
                    frmmain.isplaying = pllluviain
                end if
                'call stopsound("lluviaout.mp3")
                'call playsound("lluviain.mp3", true)
            else
                if frmmain.isplaying <> pllluviaout then
                    call frmmain.stopsound
                    call frmmain.play("lluviaout.wav", true)
                    frmmain.isplaying = pllluviaout
                end if
                'call stopsound("lluviain.mp3")
                'call playsound("lluviaout.mp3", true)
            end if
        end if
    end if
'[end]'
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



function pixelpos(x as integer) as integer
'*****************************************************************
'converts a tile position to a screen position
'*****************************************************************

pixelpos = (tilepixelwidth * x) - tilepixelwidth

end function


sub loadgraphics()
        dim loopc as integer
        dim surfacedesc as ddsurfacedesc2
        dim ddck as ddcolorkey
        dim ddsd as ddsurfacedesc2
        dim iloopupdate as integer

        surfacedb.maxentries = 150
        surfacedb.lpdirectdraw7 = directdraw
        surfacedb.path = dirgraficos
        call surfacedb.init
        

        'bmp de la lluvia
        call getbitmapdimensions(dirgraficos & "5556.bmp", ddsd.lwidth, ddsd.lheight)
              
        rlluvia(0).top = 0:      rlluvia(1).top = 0:      rlluvia(2).top = 0:      rlluvia(3).top = 0
        rlluvia(0).left = 0:     rlluvia(1).left = 128:   rlluvia(2).left = 256:   rlluvia(3).left = 384
        rlluvia(0).right = 128:  rlluvia(1).right = 256:  rlluvia(2).right = 384:  rlluvia(3).right = 512
        rlluvia(0).bottom = 128: rlluvia(1).bottom = 128: rlluvia(2).bottom = 128: rlluvia(3).bottom = 128
    
        rlluvia(4).top = 128:    rlluvia(5).top = 128:    rlluvia(6).top = 128:    rlluvia(7).top = 128
        rlluvia(4).left = 0:     rlluvia(5).left = 128:   rlluvia(6).left = 256:   rlluvia(7).left = 384
        rlluvia(4).right = 128:  rlluvia(5).right = 256:  rlluvia(6).right = 384:  rlluvia(7).right = 512
        rlluvia(4).bottom = 256: rlluvia(5).bottom = 256: rlluvia(6).bottom = 256: rlluvia(7).bottom = 256
        addtorichtextbox frmcargando.status, "hecho.", , , , 1, , false
end sub


'[end]'
function inittileengine(byref setdisplayformhwnd as long, setmainviewtop as integer, setmainviewleft as integer, settilepixelheight as integer, settilepixelwidth as integer, setwindowtileheight as integer, setwindowtilewidth as integer, settilebuffersize as integer) as boolean
'*****************************************************************
'initengine
'*****************************************************************


dim surfacedesc as ddsurfacedesc2
dim ddck as ddcolorkey

inipath = app.path & "\init\"

'set intial user position
userpos.x = minxborder
userpos.y = minyborder

'fill startup variables

displayformhwnd = setdisplayformhwnd
mainviewtop = setmainviewtop
mainviewleft = setmainviewleft
tilepixelwidth = settilepixelwidth
tilepixelheight = settilepixelheight
windowtileheight = setwindowtileheight
windowtilewidth = setwindowtilewidth
tilebuffersize = settilebuffersize

minxborder = xminmapsize + (windowtilewidth \ 2)
maxxborder = xmaxmapsize - (windowtilewidth \ 2)
minyborder = yminmapsize + (windowtileheight \ 2)
maxyborder = ymaxmapsize - (windowtileheight \ 2)

mainviewwidth = (tilepixelwidth * windowtilewidth)
mainviewheight = (tilepixelheight * windowtileheight)


redim mapdata(xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock





directdraw.setcooperativelevel displayformhwnd, ddscl_normal

if musica = 0 or fx = 0 then
    directsound.setcooperativelevel displayformhwnd, dsscl_priority
end if

'primary surface
' fill the surface description structure
with surfacedesc
    .lflags = ddsd_caps
    .ddscaps.lcaps = ddscaps_primarysurface
end with



set primarysurface = directdraw.createsurface(surfacedesc)

set primaryclipper = directdraw.createclipper(0)
primaryclipper.sethwnd frmmain.hwnd
primarysurface.setclipper primaryclipper

set secundaryclipper = directdraw.createclipper(0)

with backbufferrect
    .left = 0 + 32 * rendermod.iimagesize
    .top = 0 + 32 * rendermod.iimagesize
    .right = (tilepixelwidth * (windowtilewidth + (2 * tilebuffersize))) - 32 * rendermod.iimagesize
    .bottom = (tilepixelheight * (windowtileheight + (2 * tilebuffersize))) - 32 * rendermod.iimagesize
end with
with surfacedesc
    .lflags = ddsd_caps or ddsd_height or ddsd_width
    if rendermod.busevideo then
        .ddscaps.lcaps = ddscaps_offscreenplain
    else
        .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
    end if
    .lheight = backbufferrect.bottom
    .lwidth = backbufferrect.right
end with

set backbuffersurface = directdraw.createsurface(surfacedesc)

ddck.low = 0
ddck.high = 0
backbuffersurface.setcolorkey ddckey_srcblt, ddck



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

addtorichtextbox frmcargando.status, "cargando gr�ficos....", 0, 0, 0, , , true
call loadgraphics

inittileengine = true

end function




'sub shownextframe(displayformtop as integer, displayformleft as integer)
sub shownextframe()

'[code]:matux'
'
'  esta funci�n fue movida al loop principal en mod_general
'  para que sea inline. en otras palabras, lo que est� ac�
'  ya no es llamado por ninguna rutina.
'
'[end]'

'***********************************************
'updates and draws next frame to screen
'***********************************************
    static offsetcounterx as integer
    static offsetcountery as integer

    if enginerun then
        '  '****** move screen left and right if needed ******
            if addtouserpos.x <> 0 then
                offsetcounterx = (offsetcounterx - (8 * sgn(addtouserpos.x)))
                if abs(offsetcounterx) >= abs(tilepixelwidth * addtouserpos.x) then
                    offsetcounterx = 0
                    addtouserpos.x = 0
                    usermoving = 0
                end if
            'end if

            '****** move screen up and down if needed ******
            'if addtouserpos.y <> 0 then
            elseif addtouserpos.y <> 0 then
                offsetcountery = offsetcountery - (8 * sgn(addtouserpos.y))
                if abs(offsetcountery) >= abs(tilepixelheight * addtouserpos.y) then
                    offsetcountery = 0
                    addtouserpos.y = 0
                    usermoving = 0
                end if
            end if

            '****** update screen ******
            call renderscreen(userpos.x - addtouserpos.x, userpos.y - addtouserpos.y, offsetcounterx, offsetcountery)
            'call donightfx
            'call dolightfogata(userpos.x - addtouserpos.x, userpos.y - addtouserpos.y, offsetcounterx, offsetcountery)
            call mostrarflags
            call dialogos.mostrartexto
            call dibujarcartel
            
            call drawbackbuffersurface
            
            'call dibujarinv(frmmain.picinv.hwnd, 0)
            framesperseccounter = framesperseccounter + 1
    end if
end sub
'[code 000]:matux
' la hice inline
sub mostrarflags()
if iscombate then
    call dialogos.drawtext(260, 260, "modo combate", vbred)
end if
'[end]'
end sub
sub creargrh(grhindex as integer, index as integer)
redim preserve grh(1 to index) as grh
grh(index).framecounter = 1
grh(index).grhindex = grhindex
grh(index).speedcounter = grhdata(grhindex).speed
grh(index).started = 1
end sub

sub cargaranimsextra()
call creargrh(6580, 1) 'anim invent
call creargrh(534, 2) 'animacion de teleport
end sub

function controlvelocidad(byval lasttime as long) as boolean
controlvelocidad = (gettickcount - lasttime > 20)
end function
