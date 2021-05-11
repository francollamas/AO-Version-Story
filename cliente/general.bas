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

public bo as integer
public bk as long
public brk as long

public iplst as string
public banners as string


public binvmod     as boolean  'el inventario se modific�?

public bfogata as boolean

public blluvia() as byte ' array para determinar si
'debemos mostrar la animacion de la lluvia

private lframelimiter as long

public lframemodlimiter as long
public lframetimer as long
public shkeys() as string

public bfps as boolean

public declare function sndplaysound lib "winmm.dll" alias "sndplaysounda" (byval lpszsoundname as string, byval uflags as long) as long

public function dirgraficos() as string
dirgraficos = app.path & "\" & config_inicio.dirgraficos & "\"
end function

public function dirsound() as string
dirsound = app.path & "\" & config_inicio.dirsonidos & "\"
end function

public function dirmidi() as string
dirmidi = app.path & "\" & config_inicio.dirmusica & "\"
end function
public function sd(byval n as integer) as integer
'suma digitos
dim auxint as integer
dim digit as byte
dim suma as integer
auxint = n

do
    digit = (auxint mod 10)
    suma = suma + digit
    auxint = auxint \ 10

loop while (auxint <> 0)

sd = suma

end function

public function sdm(byval n as integer) as integer
'suma digitos cada digito menos dos
dim auxint as integer
dim digit as integer
dim suma as integer
auxint = n

do
    digit = (auxint mod 10)
    
    digit = digit - 1
    
    suma = suma + digit
    
    auxint = auxint \ 10

loop while (auxint <> 0)

sdm = suma

end function

public function complex(byval n as integer) as integer

if n mod 2 <> 0 then
    complex = n * sd(n)
else
    complex = n * sdm(n)
end if

end function

public function validarloginmsg(byval n as integer) as integer
dim auxinteger as integer
dim auxinteger2 as integer
auxinteger = sd(n)
auxinteger2 = sdm(n)
validarloginmsg = complex(auxinteger + auxinteger2)
end function

sub playwaveapi(file as string)

on error resume next
dim rc as integer

rc = sndplaysound(file, snd_async)

end sub


function randomnumber(byval lowerbound as variant, byval upperbound as variant) as single

randomize timer

randomnumber = (upperbound - lowerbound + 1) * rnd + lowerbound
if randomnumber > upperbound then randomnumber = upperbound

end function

sub cargaranimarmas()

on error resume next

dim loopc as integer
dim arch as string
arch = app.path & "\init\" & "armas.dat"
doevents

numweaponanims = val(getvar(arch, "init", "numarmas"))

redim weaponanimdata(1 to numweaponanims) as weaponanimdata

for loopc = 1 to numweaponanims
    initgrh weaponanimdata(loopc).weaponwalk(1), val(getvar(arch, "arma" & loopc, "dir1")), 0
    initgrh weaponanimdata(loopc).weaponwalk(2), val(getvar(arch, "arma" & loopc, "dir2")), 0
    initgrh weaponanimdata(loopc).weaponwalk(3), val(getvar(arch, "arma" & loopc, "dir3")), 0
    initgrh weaponanimdata(loopc).weaponwalk(4), val(getvar(arch, "arma" & loopc, "dir4")), 0
next loopc

end sub

sub cargaranimescudos()

on error resume next

dim loopc as integer
dim arch as string
arch = app.path & "\init\" & "escudos.dat"
doevents

numescudosanims = val(getvar(arch, "init", "numescudos"))

redim shieldanimdata(1 to numescudosanims) as shieldanimdata

for loopc = 1 to numescudosanims
    initgrh shieldanimdata(loopc).shieldwalk(1), val(getvar(arch, "esc" & loopc, "dir1")), 0
    initgrh shieldanimdata(loopc).shieldwalk(2), val(getvar(arch, "esc" & loopc, "dir2")), 0
    initgrh shieldanimdata(loopc).shieldwalk(3), val(getvar(arch, "esc" & loopc, "dir3")), 0
    initgrh shieldanimdata(loopc).shieldwalk(4), val(getvar(arch, "esc" & loopc, "dir4")), 0
next loopc

end sub

sub addtostatus(richtextbox as richtextbox, text as string, red as byte, green as byte, blue as byte, bold as byte, italic as byte)
'******************************************
'adds text to a richtext box at the bottom.
'automatically scrolls to new text.
'text box must be multiline and have a 3d
'apperance!
'******************************************

frmcargando.status.selstart = len(richtextbox.text)
frmcargando.status.sellength = 0
frmcargando.status.selcolor = rgb(red, green, blue)

if bold then
    frmcargando.status.selbold = true
else
    frmcargando.status.selbold = false
end if

if italic then
    frmcargando.status.selitalic = true
else
    frmcargando.status.selitalic = false
end if

frmcargando.status.seltext = chr(13) & chr(10) & text

end sub

    sub addtorichtextbox(richtextbox as richtextbox, text as string, optional red as integer = -1, optional green as integer, optional blue as integer, optional bold as boolean, optional italic as boolean, optional bcrlf as boolean)
        with richtextbox
            if (len(.text)) > 2000 then .text = ""
            .selstart = len(richtextbox.text)
            .sellength = 0
        
            .selbold = iif(bold, true, false)
            .selitalic = iif(italic, true, false)
            
            if not red = -1 then .selcolor = rgb(red, green, blue)
    
            .seltext = iif(bcrlf, text, text & vbcrlf)
            
            richtextbox.refresh
        end with
    end sub
'[end]'


sub addtotextbox(textbox as textbox, text as string)
'******************************************
'adds text to a text box at the bottom.
'automatically scrolls to new text.
'******************************************

textbox.selstart = len(textbox.text)
textbox.sellength = 0


textbox.seltext = chr(13) & chr(10) & text

end sub
sub refreshallchars()
'*****************************************************************
'goes through the charlist and replots all the characters on the map
'used to make sure everyone is visible
'*****************************************************************

dim loopc as integer

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
dim i as integer

cad = lcase$(cad)

for i = 1 to len(cad)
    car = asc(mid$(cad, i, 1))
    
    if ((car < 97 or car > 122) or car = asc("�")) and (car <> 255) and (car <> 32) then
        asciivalidos = false
        exit function
    end if
    
next i

asciivalidos = true

end function



function checkuserdata(checkemail as boolean) as boolean
'validamos los datos del user
dim loopc as integer
dim charascii as integer

'if ipdelservidor = frmmain.socket1.localaddress then
'    msgbox ("ip del server incorrecto")
'    exit function
'end if
'
'if ipdelservidor = "localhost" then
'    msgbox ("ip del server incorrecto")
'    exit function
'end if
'
'if ipdelservidor = frmmain.socket1.localname then
'    msgbox ("ip del server incorrecto")
'    exit function
'end if
'
'if ipdelservidor = "" then
'    msgbox ("ip del server incorrecto")
'    exit function
'end if
'
'if puertodelservidor = "" then
'    msgbox ("puerto invalido.")
'    exit function
'end if

if checkemail then
 if useremail = "" then
    msgbox ("direccion de email invalida")
    exit function
 end if
end if

if userpassword = "" then
    msgbox ("ingrese un password.")
    exit function
end if

for loopc = 1 to len(userpassword)
    charascii = asc(mid$(userpassword, loopc, 1))
    if legalcharacter(charascii) = false then
        msgbox ("password invalido.")
        exit function
    end if
next loopc

if username = "" then
    msgbox ("nombre invalido.")
    exit function
end if

if len(username) > 30 then
    msgbox ("el nombre debe tener menos de 30 letras.")
    exit function
end if

for loopc = 1 to len(username)

    charascii = asc(mid$(username, loopc, 1))
    if legalcharacter(charascii) = false then
        msgbox ("nombre invalido.")
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

function legalcharacter(keyascii as integer) as boolean
'*****************************************************************
'only allow characters that are win 95 filename compatible
'*****************************************************************

'if backspace allow
if keyascii = 8 then
    legalcharacter = true
    exit function
end if

'only allow space,numbers,letters and special characters
if keyascii < 32 or keyascii = 44 then
    legalcharacter = false
    exit function
end if

if keyascii > 126 then
    legalcharacter = false
    exit function
end if

'check for bad special characters in between
if keyascii = 34 or keyascii = 42 or keyascii = 47 or keyascii = 58 or keyascii = 60 or keyascii = 62 or keyascii = 63 or keyascii = 92 or keyascii = 124 then
    legalcharacter = false
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
if n > ubound(tips) then n = ubound(tips)
frmtip.tip.caption = tips(n)

end sub

sub movenorth()
if cartel then cartel = false

if legalpos(userpos.x, userpos.y - 1) then
    call senddata("m" & north)
    if not userdescansar and not usermeditar and not userparalizado then
        call movecharbyhead(usercharindex, north)
        call movescreen(north)
        dofogatafx
    end if
else
    if charlist(usercharindex).heading <> north then
            call senddata("chea" & north)
    end if
end if
end sub

sub moveeast()
if cartel then cartel = false
if legalpos(userpos.x + 1, userpos.y) then
    call senddata("m" & east)
    if not userdescansar and not usermeditar and not userparalizado then
        call movecharbyhead(usercharindex, east)
        call movescreen(east)
        call dofogatafx
    end if
else
    if charlist(usercharindex).heading <> east then
            call senddata("chea" & east)
    end if
end if
end sub

sub movesouth()
if cartel then cartel = false

if legalpos(userpos.x, userpos.y + 1) then
    call senddata("m" & south)
    if not userdescansar and not usermeditar and not userparalizado then
        movecharbyhead usercharindex, south
        movescreen south
        dofogatafx
    end if
else
    if charlist(usercharindex).heading <> south then
            call senddata("chea" & south)
    end if
end if
end sub

sub movewest()
if cartel then cartel = false
if legalpos(userpos.x - 1, userpos.y) then
    call senddata("m" & west)
    if not userdescansar and not usermeditar and not userparalizado then
            movecharbyhead usercharindex, west
            movescreen west
            dofogatafx
    end if
else
    if charlist(usercharindex).heading <> west then
            call senddata("chea" & west)
    end if
end if
end sub

sub randommove()

dim j as integer

j = randomnumber(1, 4)

select case j
    case 1
        call moveeast
    case 2
        call movenorth
    case 3
        call movewest
    case 4
        call movesouth
end select

end sub

sub checkkeys()
on error resume next

'*****************************************************************
'checks keys and respond
'*****************************************************************
static keytimer as integer

'makes sure keys aren't being pressed to fast
if keytimer > 0 then
    keytimer = keytimer - 1
    exit sub
end if



'don't allow any these keys during movement..
if usermoving = 0 then
    if not userestupido then
            'move up
            if getkeystate(vbkeyup) < 0 then
                call movenorth
                exit sub
            end if
        
            'move right
            if getkeystate(vbkeyright) < 0 and getkeystate(vbkeyshift) >= 0 then
                call moveeast
                exit sub
            end if
        
            'move down
            if getkeystate(vbkeydown) < 0 then
                call movesouth
                exit sub
            end if
        
            'move left
            if getkeystate(vbkeyleft) < 0 and getkeystate(vbkeyshift) >= 0 then
                  call movewest
                  exit sub
            end if
    else
        dim kp as boolean
        kp = (getkeystate(vbkeyup) < 0) or _
        getkeystate(vbkeyright) < 0 or _
        getkeystate(vbkeydown) < 0 or _
        getkeystate(vbkeyleft) < 0
        if kp then call randommove
    end if
end if

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
stop
    '[code 001]:matux'
        ' frame checker para el cheat ese
        select case framesperseccounter
            case 18 to 19
                lframemodlimiter = 60
            case 17
                lframemodlimiter = 60
            case 16
                lframemodlimiter = 120
            case 15
                lframemodlimiter = 240
            case 14
                lframemodlimiter = 480
            case 15
                lframemodlimiter = 960
            case 14
                lframemodlimiter = 1920
            case 13
                lframemodlimiter = 3840
            case 12
            case 11
            case 10
            case 9
            case 8
            case 7
            case 6
            case 5
            case 4
            case 3
            case 2
            case 1
                lframemodlimiter = 60 * 256
            case 0
            
        end select
    '[end]'

    call dofogatafx
end if

end sub

function nextopenchar()
'******************************************
'finds next open char
'******************************************

dim loopc as integer

loopc = 1
do while charlist(loopc).active
    loopc = loopc + 1
loop

nextopenchar = loopc

end function

public function dirmapas() as string
dirmapas = app.path & "\" & config_inicio.dirmapas & "\"
end function

sub switchmap(map as integer)

dim loopc as integer
dim y as integer
dim x as integer
dim tempint as integer
      

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

        '.dat file
        get #1, , mapdata(x, y).blocked
        for loopc = 1 to 4
            get #1, , mapdata(x, y).graphic(loopc).grhindex
            
            'set up grh
            if mapdata(x, y).graphic(loopc).grhindex > 0 then
                initgrh mapdata(x, y).graphic(loopc), mapdata(x, y).graphic(loopc).grhindex
            end if
            
        next loopc
        
        
        get #1, , mapdata(x, y).trigger
        
        get #1, , tempint
        
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

public function readfield(pos as integer, text as string, sepascii as integer) as string
'*****************************************************************
'gets a field from a string
'*****************************************************************

dim i as integer
dim lastpos as integer
dim curchar as string * 1
dim fieldnum as integer
dim seperator as string

seperator = chr(sepascii)
lastpos = 0
fieldnum = 0

for i = 1 to len(text)
    curchar = mid(text, i, 1)
    if curchar = seperator then
        fieldnum = fieldnum + 1
        if fieldnum = pos then
            readfield = mid(text, lastpos + 1, (instr(lastpos + 1, text, seperator, vbtextcompare) - 1) - (lastpos))
            exit function
        end if
        lastpos = i
    end if
next i
fieldnum = fieldnum + 1

if fieldnum = pos then
    readfield = mid(text, lastpos + 1)
end if


end function

function fileexist(file as string, filetype as vbfileattribute) as boolean
if dir(file, filetype) = "" then
    fileexist = false
else
    fileexist = true
end if
end function

sub writeclientver()

dim hfile as integer
    
hfile = freefile()
open app.path & "\init\ver.bin" for binary access write as #hfile
put #hfile, , clng(777)
put #hfile, , clng(777)
put #hfile, , clng(777)

put #hfile, , cint(app.major)
put #hfile, , cint(app.minor)
put #hfile, , cint(app.revision)

close #hfile

end sub


public function isip(byval ip as string) as boolean

dim i as integer
for i = 1 to ubound(serverslst)
    if serverslst(i).ip = ip then
        isip = true
        exit function
    end if
next i

end function

public sub initserverslist(byval lst as string)

on error resume next

dim numservers as integer
dim i as integer, cont as integer
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
    curserverpasrecport = serverslst(curserver).passrecport
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
on error resume next

call writeclientver

if app.previnstance then
    call msgbox("argentum online ya esta corriendo! no es posible correr otra instancia del juego. haga click en aceptar para salir.", vbapplicationmodal + vbinformation + vbokonly, "error al ejecutar")
    end
end if

dim f as boolean
dim ulttick as long, esttick as long
dim timers(1 to 5) as integer

chdrive app.path
chdir app.path

'obtengo mi md5 hash
'obtener el hushmd5
dim fmd5hushyo as string * 32
fmd5hushyo = md5file(app.path & "\" & app.exename & ".exe")
'fmd5hushyo = md5file(app.path & "\" & "argentum.exe")

md5hushyo = txtoffset(hexmd52asc(fmd5hushyo), 53)

'cargamos el archivo de configuracion inicial
if fileexist(app.path & "\init\inicio.con", vbnormal) then
    config_inicio = leergameini()
end if


if fileexist(app.path & "\init\ao.dat", vbnormal) then
    open app.path & "\init\ao.dat" for binary as #53
        get #53, , rendermod
    close #53

    musica = iif(rendermod.bnomusic = 1, 1, 0)
    fx = iif(rendermod.bnosound = 1, 1, 0)
    
    'rendermod.iimagesize = 0
    select case rendermod.iimagesize
        case 4
            rendermod.iimagesize = 0
        case 3
            rendermod.iimagesize = 1
        case 2
            rendermod.iimagesize = 2
        case 1
            rendermod.iimagesize = 3
        case 0
            rendermod.iimagesize = 4
    end select
end if


tipf = config_inicio.tip

frmcargando.show
frmcargando.refresh

userparalizado = false

frmconnect.version = "v" & app.major & "." & app.minor & " build: " & app.revision
addtorichtextbox frmcargando.status, "buscando servidores....", 0, 0, 0, 0, 0, 1

frmmain.inet1.url = "http://www.argentum-online.com.ar/admin/iplist2.txt"
rawserverslist = frmmain.inet1.openurl

if rawserverslist = "" then
    frmmain.inet1.url = "http://www.argentum-online.com.ar/admin/iplist2.txt"
end if

frmmain.socket1.startup

if rawserverslist = "" then
    serversrecibidos = false
    redim serverslst(1)
else
    serversrecibidos = true
end if

call initserverslist(rawserverslist)

'ipdelservidor =
'puertodelservidor = 7666

addtorichtextbox frmcargando.status, "encontrado", , , , 1
addtorichtextbox frmcargando.status, "iniciando constantes...", 0, 0, 0, 0, 0, 1

redim ciudades(1 to numciudades) as string
ciudades(1) = "ullathorpe"
ciudades(2) = "nix"
ciudades(3) = "banderbill"

redim citydesc(1 to numciudades) as string
citydesc(1) = "ullathorpe est� establecida en el medio de los grandes bosques de argentum, es principalmente un pueblo de campesinos y le�adores. su ubicaci�n hace de ullathorpe un punto de paso obligado para todos los aventureros ya que se encuentra cerca de los lugares m�s legendarios de este mundo."
citydesc(2) = "nix es una gran ciudad. edificada sobre la costa oeste del principal continente de argentum."
citydesc(3) = "banderbill se encuentra al norte de ullathorpe y nix, es una de las ciudades m�s importantes de todo el imperio."

redim listarazas(1 to numrazas) as string
listarazas(1) = "humano"
listarazas(2) = "elfo"
listarazas(3) = "elfo oscuro"
listarazas(4) = "gnomo"
listarazas(5) = "enano"



redim listaclases(1 to numclases) as string
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

redim skillsnames(1 to numskills) as string
skillsnames(1) = "suerte"
skillsnames(2) = "magia"
skillsnames(3) = "robar"
skillsnames(4) = "tacticas de combate"
skillsnames(5) = "combate con armas"
skillsnames(6) = "meditar"
skillsnames(7) = "apu�alar"
skillsnames(8) = "ocultarse"
skillsnames(9) = "supervivencia"
skillsnames(10) = "talar �rboles"
skillsnames(11) = "comercio"
skillsnames(12) = "defensa con escudos"
skillsnames(13) = "pesca"
skillsnames(14) = "mineria"
skillsnames(15) = "carpinteria"
skillsnames(16) = "herreria"
skillsnames(17) = "liderazgo"
skillsnames(18) = "domar animales"
skillsnames(19) = "armas de proyectiles"
skillsnames(20) = "wresterling"
skillsnames(21) = "navegacion"

redim userskills(1 to numskills) as integer
redim useratributos(1 to numatributos) as integer
redim atributosnames(1 to numatributos) as string
atributosnames(1) = "fuerza"
atributosnames(2) = "agilidad"
atributosnames(3) = "inteligencia"
atributosnames(4) = "carisma"
atributosnames(5) = "constitucion"


frmoldpersonaje.nametxt.text = config_inicio.name
frmoldpersonaje.passwordtxt.text = ""

addtorichtextbox frmcargando.status, "hecho", , , , 1

iniciarobjetosdirectx

addtorichtextbox frmcargando.status, "cargando sonidos....", 0, 0, 0, 0, 0, 1
addtorichtextbox frmcargando.status, "hecho", , , , 1

dim loopc as integer

lasttime = gettickcount

endl = chr(13) & chr(10)
endc = chr(1)

call inittileengine(frmmain.hwnd, 152, 7, 32, 32, 13, 17, 9)
                                  

'call addtorichtextbox(frmcargando.status, "creando animaciones extras.", 2, 51, 223, 1, 1)
call addtorichtextbox(frmcargando.status, "creando animaciones extra....")


call cargaranimsextra
call cargartips
usermap = 1
call cargararraylluvia
call cargaranimarmas
call cargaranimescudos


addtorichtextbox frmcargando.status, "                    �bienvenido a argentum online!", , , , 1


unload frmcargando

loopmidi = true

if musica = 0 then
    call cargarmidi(dirmidi & midi_inicio & ".mid")
    play_midi
end if

frmpres.picture = loadpicture(app.path & "\graficos\noland.jpg")
frmpres.windowstate = vbmaximized
frmpres.show

do while not finpres
    doevents
loop

unload frmpres

frmconnect.visible = true

'loop principal!
'[code]:matux'
    mainviewrect.left = mainviewleft + 32 * rendermod.iimagesize
    mainviewrect.top = mainviewtop + 32 * rendermod.iimagesize
    mainviewrect.right = (mainviewrect.left + mainviewwidth) - 32 * (rendermod.iimagesize * 2)
    mainviewrect.bottom = (mainviewrect.top + mainviewheight) - 32 * (rendermod.iimagesize * 2)

    maindestrect.left = ((tilepixelwidth * tilebuffersize) - tilepixelwidth) + 32 * rendermod.iimagesize
    maindestrect.top = ((tilepixelheight * tilebuffersize) - tilepixelheight) + 32 * rendermod.iimagesize
    maindestrect.right = (maindestrect.left + mainviewwidth) - 32 * (rendermod.iimagesize * 2)
    maindestrect.bottom = (maindestrect.top + mainviewheight) - 32 * (rendermod.iimagesize * 2)

    dim offsetcounterx as integer
    dim offsetcountery as integer
'[end]'



primeravez = true
prgrun = true
pausa = false
binvmod = true
lframelimiter = directx.tickcount
'[code 001]:matux'
    lframemodlimiter = 60
'[end]'
do while prgrun

    if requestpostimer > 0 then
        requestpostimer = requestpostimer - 1
        if requestpostimer = 0 then
            'pedimos que nos envie la posicion
            call senddata("rpu")
        end if
    end if

    call refreshallchars

    '[code 001]:matux
    '
    '   enginerun
    if enginerun then
        '[do]:dibuja el siguiente frame'
        '[code 000]:matux'
        'if frmmain.windowstate <> 1 and curmap > 0 and enginerun then
        if frmmain.windowstate <> 1 then
        '[end]'
            'call shownextframe(frmmain.top, frmmain.left)
            '****** move screen left, right, up and down if needed ******
            if addtouserpos.x <> 0 then
                offsetcounterx = (offsetcounterx - (8 * sgn(addtouserpos.x)))
                if abs(offsetcounterx) >= abs(tilepixelwidth * addtouserpos.x) then
                    offsetcounterx = 0
                    addtouserpos.x = 0
                    usermoving = 0
                end if
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
            '[code 000]:matux
                'call mostrarflags
                if iscombate then call dialogos.drawtext(260, 260, "modo combate", vbred)
                if dialogos.cantidaddialogos <> 0 then call dialogos.mostrartexto
                if cartel then call dibujarcartel
                if binvmod then dibujarinv
    
                call drawbackbuffersurface
                
                call rendersounds
                
                '[do]:inventario'
                'call dibujarinv(frmmain.picinv.hwnd, 0)
                'if binvmod then dibujarinv  'lo mov� arriba para
                '                             que est� mas ordenadito
                '[end]'
    
            '[end]'
            
            framesperseccounter = framesperseccounter + 1
        end if
    end if
    
    '[code 000]:matux'
    'if controlvelocidad(lasttime) then
    if (gettickcount - lasttime > 20) then
        if not pausa and frmmain.visible and not frmforo.visible then
            checkkeys
            lasttime = gettickcount
        end if
    end if
    
    if musica = 0 then
        if not segstate is nothing then
            if not perf.isplaying(seg, segstate) then play_midi
        end if
    end if
         'musica = 0
    'end if
    '[end]'
    
    '[code 001]:matux
    ' frame limiter
        'framespersec = framespersec + 1
        if directx.tickcount - lframetimer > 1000 then
            framespersec = framesperseccounter
            if fpsflag then frmmain.caption = framespersec
            framesperseccounter = 0
            lframetimer = directx.tickcount
        end if
        
        'while directx.tickcount - lframelimiter < lframemodlimiter: wend
        
        '[alejo]
        'if bfps = false then
            while directx.tickcount - lframelimiter < 55 '< 55
                sleep 5
            wend
        'end if
        '[/alejo]
        

        lframelimiter = directx.tickcount
    
    '[end]'
    
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
        end if
    next loopc
    ulttick = gettickcount
    
    
    doevents
loop

enginerun = false
frmcargando.show
addtorichtextbox frmcargando.status, "liberando recursos...", 0, 0, 0, 0, 0, 1
liberarobjetosdx


if bnoreschange = false then
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


call unloadallforms

config_inicio.tip = tipf
call escribirgameini(config_inicio)

end

manejadorerrores:
    logerror "contexto:" & err.helpcontext & " desc:" & err.description & " fuente:" & err.source
    end
    
end sub



sub writevar(file as string, main as string, var as string, value as string)
'*****************************************************************
'writes a var to a text file
'*****************************************************************

writeprivateprofilestring main, var, value, file

end sub

function getvar(file as string, main as string, var as string) as string
'*****************************************************************
'gets a var from a text file
'*****************************************************************

dim l as integer
dim char as string
dim sspaces as string ' this will hold the input that the program will retrieve
dim szreturn as string ' this will be the defaul value if the string is not found

szreturn = ""

sspaces = space(5000) ' this tells the computer how long the longest string can be. if you want, you can change the number 75 to any number you wish


getprivateprofilestring main, var, szreturn, sspaces, len(sspaces), file

getvar = rtrim(sspaces)
getvar = left(getvar, len(getvar) - 1)

end function


'[code 002]:matux
'
'  funci�n para chequear el email
'
    public function checkmailstring(byref sstring as string) as boolean
        on error goto errhnd:
        dim lpos  as long, lx    as long
        dim iasc  as integer
    
        '1er test: busca un simbolo @
        lpos = instr(sstring, "@")
        if (lpos <> 0) then
            '2do test: busca un simbolo . despu�s de @ + 1
            if not (iif((instr(lpos, sstring, ".", vbbinarycompare) > (lpos + 1)), true, false)) then _
                exit function
    
            '3er test: val�da el ultimo caracter
            if not (cmsvalidatechar_(asc(right(sstring, 1)))) then _
                exit function
    
            '4to test: recorre todos los caracteres y los val�da
            for lx = 0 to len(sstring) - 1 'el ultimo no porque ya lo probamos
                if not (lx = (lpos - 1)) then
                    iasc = asc(mid(sstring, (lx + 1), 1))
                    if not (iasc = 46 and lx > (lpos - 1)) then _
                        if not cmsvalidatechar_(iasc) then _
                            exit function
                end if
            next lx
    
            'finale
            checkmailstring = true
        end if
    
errhnd:
        'error handle
    end function
    
private function cmsvalidatechar_(byref iasc as integer) as boolean
cmsvalidatechar_ = iif( _
                    (iasc >= 48 and iasc <= 57) or _
                    (iasc >= 65 and iasc <= 90) or _
                    (iasc >= 97 and iasc <= 122) or _
                    (iasc = 95) or (iasc = 45), true, false)
end function


function hayagua(x as integer, y as integer) as boolean

if mapdata(x, y).graphic(1).grhindex >= 1505 and _
   mapdata(x, y).graphic(1).grhindex <= 1520 and _
   mapdata(x, y).graphic(2).grhindex = 0 then
            hayagua = true
else
            hayagua = false
end if

end function



    public sub showsendtxt()
        if not frmcantidad.visible then
            frmmain.sendtxt.visible = true
            frmmain.sendtxt.setfocus
        end if
    end sub
    

