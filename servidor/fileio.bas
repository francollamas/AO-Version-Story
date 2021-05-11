attribute vb_name = "es"
'argentum online 0.9.0.2
'copyright (c) 2002 m�rquez pablo ignacio
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

public sub cargarspawnlist()

    dim n as integer, loopc as integer
    n = val(getvar(app.path & "\dat\invokar.dat", "init", "numnpcs"))
    redim spawnlist(n) as tcriaturasentrenador
    for loopc = 1 to n
        spawnlist(loopc).npcindex = val(getvar(app.path & "\dat\invokar.dat", "list", "ni" & loopc))
        spawnlist(loopc).npcname = getvar(app.path & "\dat\invokar.dat", "list", "nn" & loopc)
    next loopc


end sub

function esdios(byval name as string) as boolean
dim numwizs as integer
dim wiznum as integer
dim nomb as string
numwizs = val(getvar(inipath & "server.ini", "init", "dioses"))
for wiznum = 1 to numwizs
    nomb = ucase$(getvar(inipath & "server.ini", "dioses", "dios" & wiznum))
    if left(nomb, 1) = "*" or left(nomb, 1) = "+" then nomb = right(nomb, len(nomb) - 1)
    if ucase$(name) = nomb then
        esdios = true
        exit function
    end if
next wiznum
esdios = false
end function

function essemidios(byval name as string) as boolean
dim numwizs as integer
dim wiznum as integer
dim nomb as string
numwizs = val(getvar(inipath & "server.ini", "init", "semidioses"))
for wiznum = 1 to numwizs
    nomb = ucase$(getvar(inipath & "server.ini", "semidioses", "semidios" & wiznum))
    if left(nomb, 1) = "*" or left(nomb, 1) = "+" then nomb = right(nomb, len(nomb) - 1)
    if ucase$(name) = nomb then
        essemidios = true
        exit function
    end if
next wiznum
essemidios = false
end function

function esconsejero(byval name as string) as boolean
dim numwizs as integer
dim wiznum as integer
dim nomb as string
numwizs = val(getvar(inipath & "server.ini", "init", "consejeros"))
for wiznum = 1 to numwizs
    nomb = ucase$(getvar(inipath & "server.ini", "consejeros", "consejero" & wiznum))
    if left(nomb, 1) = "*" or left(nomb, 1) = "+" then nomb = right(nomb, len(nomb) - 1)
    if ucase$(name) = nomb then
        esconsejero = true
        exit function
    end if
next wiznum
esconsejero = false
end function

public function txtdimension(byval name as string) as long
dim n as integer, cad as string, tam as long
n = freefile(1)
open name for input as #n
tam = 0
do while not eof(n)
    tam = tam + 1
    line input #n, cad
loop
close n
txtdimension = tam
end function

public sub cargarforbidenwords()
redim forbidennames(1 to txtdimension(datpath & "nombresinvalidos.txt"))
dim n as integer, i as integer
n = freefile(1)
open datpath & "nombresinvalidos.txt" for input as #n

for i = 1 to ubound(forbidennames)
    line input #n, forbidennames(i)
next i

close n

end sub
public sub cargarhechizos()
on error goto errhandler

if frmmain.visible then frmmain.txstatus.caption = "cargando hechizos."

dim hechizo as integer

'obtiene el numero de hechizos
numerohechizos = val(getvar(datpath & "hechizos.dat", "init", "numerohechizos"))
redim hechizos(1 to numerohechizos) as thechizo

frmcargando.cargar.min = 0
frmcargando.cargar.max = numerohechizos
frmcargando.cargar.value = 0

'llena la lista
for hechizo = 1 to numerohechizos

    hechizos(hechizo).nombre = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "nombre")
    hechizos(hechizo).desc = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "desc")
    hechizos(hechizo).palabrasmagicas = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "palabrasmagicas")
    
    hechizos(hechizo).hechizeromsg = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "hechizeromsg")
    hechizos(hechizo).targetmsg = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "targetmsg")
    hechizos(hechizo).propiomsg = getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "propiomsg")
    
    hechizos(hechizo).tipo = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "tipo"))
    hechizos(hechizo).wav = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "wav"))
    hechizos(hechizo).fxgrh = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "fxgrh"))
    
    hechizos(hechizo).loops = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "loops"))
    
    hechizos(hechizo).resis = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "resis"))
    
    hechizos(hechizo).subehp = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subehp"))
    hechizos(hechizo).minhp = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minhp"))
    hechizos(hechizo).maxhp = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxhp"))
    
    hechizos(hechizo).subemana = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subemana"))
    hechizos(hechizo).mimana = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minmana"))
    hechizos(hechizo).mamana = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxmana"))
    
    hechizos(hechizo).subesta = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subesta"))
    hechizos(hechizo).minsta = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minsta"))
    hechizos(hechizo).maxsta = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxsta"))
    
    hechizos(hechizo).subeham = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subeham"))
    hechizos(hechizo).minham = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minham"))
    hechizos(hechizo).maxham = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxham"))
    
    hechizos(hechizo).subesed = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subesed"))
    hechizos(hechizo).minsed = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minsed"))
    hechizos(hechizo).maxsed = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxsed"))
    
    hechizos(hechizo).subeagilidad = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subeag"))
    hechizos(hechizo).minagilidad = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minag"))
    hechizos(hechizo).maxagilidad = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxag"))
    
    hechizos(hechizo).subefuerza = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subefu"))
    hechizos(hechizo).minfuerza = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minfu"))
    hechizos(hechizo).maxfuerza = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxfu"))
    
    hechizos(hechizo).subecarisma = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "subeca"))
    hechizos(hechizo).mincarisma = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minca"))
    hechizos(hechizo).maxcarisma = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maxca"))
    
    
    hechizos(hechizo).invisibilidad = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "invisibilidad"))
    hechizos(hechizo).paraliza = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "paraliza"))
    hechizos(hechizo).removerparalisis = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "removerparalisis"))
    
    hechizos(hechizo).curaveneno = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "curaveneno"))
    hechizos(hechizo).envenena = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "envenena"))
    hechizos(hechizo).maldicion = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "maldicion"))
    hechizos(hechizo).removermaldicion = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "removermaldicion"))
    hechizos(hechizo).bendicion = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "bendicion"))
    hechizos(hechizo).revivir = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "revivir"))
    
    hechizos(hechizo).ceguera = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "ceguera"))
    hechizos(hechizo).estupidez = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "estupidez"))
    
    hechizos(hechizo).invoca = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "invoca"))
    hechizos(hechizo).numnpc = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "numnpc"))
    hechizos(hechizo).cant = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "cant"))
    
    
    hechizos(hechizo).materializa = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "materializa"))
    hechizos(hechizo).itemindex = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "itemindex"))
    
    hechizos(hechizo).minskill = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "minskill"))
    hechizos(hechizo).manarequerido = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "manarequerido"))
    
    hechizos(hechizo).target = val(getvar(datpath & "hechizos.dat", "hechizo" & hechizo, "target"))
    frmcargando.cargar.value = frmcargando.cargar.value + 1
next
exit sub

errhandler:
 msgbox "error cargando hechizos.dat"
end sub

sub loadmotd()
dim i as integer

maxlines = val(getvar(app.path & "\dat\motd.ini", "init", "numlines"))
redim motd(1 to maxlines)
for i = 1 to maxlines
    motd(i).texto = getvar(app.path & "\dat\motd.ini", "motd", "line" & i)
    motd(i).formato = ""
next i

end sub

public sub dobackup()
'call logtarea("sub dobackup")
haciendobk = true


call senddata(toall, 0, 0, "bkw")

call saveguildsdb
call limpiarmundo
call worldsave

call senddata(toall, 0, 0, "bkw")

call estadisticasweb.informar(evento_nuevo_clan, 0)

haciendobk = false

'log
on error resume next
dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\backups.log" for append shared as #nfile
print #nfile, date & " " & time
close #nfile
end sub


public sub savemapdata(byval n as integer)

'call logtarea("sub savemapdata n:" & n)

dim loopc as integer
dim tempint as integer
dim y as integer
dim x as integer
dim saveas as string

saveas = app.path & "\worldbackup\map" & n & ".map"

if fileexist(saveas, vbnormal) then
    kill saveas
end if

if fileexist(left$(saveas, len(saveas) - 4) & ".inf", vbnormal) then
    kill left$(saveas, len(saveas) - 4) & ".inf"
end if

'open .map file
open saveas for binary as #1
seek #1, 1
saveas = left$(saveas, len(saveas) - 4)
saveas = saveas & ".inf"
'open .inf file
open saveas for binary as #2
seek #2, 1
'map header
        
put #1, , mapinfo(n).mapversion
put #1, , micabecera
put #1, , tempint
put #1, , tempint
put #1, , tempint
put #1, , tempint

'inf header
put #2, , tempint
put #2, , tempint
put #2, , tempint
put #2, , tempint
put #2, , tempint

'write .map file
for y = yminmapsize to ymaxmapsize
    for x = xminmapsize to xmaxmapsize
        
        '.map file
        put #1, , mapdata(n, x, y).blocked
        
        for loopc = 1 to 4
            put #1, , mapdata(n, x, y).graphic(loopc)
        next loopc
        
        'lugar vacio para futuras expansiones
        put #1, , mapdata(n, x, y).trigger
        
        put #1, , tempint
        
        '.inf file
        'tile exit
        put #2, , mapdata(n, x, y).tileexit.map
        put #2, , mapdata(n, x, y).tileexit.x
        put #2, , mapdata(n, x, y).tileexit.y
        
        'npc
        if mapdata(n, x, y).npcindex > 0 then
            put #2, , npclist(mapdata(n, x, y).npcindex).numero
        else
            put #2, , 0
        end if
        'object
        
        if mapdata(n, x, y).objinfo.objindex > 0 then
            if objdata(mapdata(n, x, y).objinfo.objindex).objtype = objtype_fogata then
                mapdata(n, x, y).objinfo.objindex = 0
                mapdata(n, x, y).objinfo.amount = 0
            end if
'            if objdata(mapdata(n, x, y).objinfo.objindex).objtype = objtype_manchas then
'                mapdata(n, x, y).objinfo.objindex = 0
'                mapdata(n, x, y).objinfo.amount = 0
'            end if
        end if
        
        put #2, , mapdata(n, x, y).objinfo.objindex
        put #2, , mapdata(n, x, y).objinfo.amount
        
        'empty place holders for future expansion
        put #2, , tempint
        put #2, , tempint
        
    next x
next y

'close .map file
close #1

'close .inf file
close #2

'write .dat file
saveas = left$(saveas, len(saveas) - 4) & ".dat"
call writevar(saveas, "mapa" & n, "name", mapinfo(n).name)
call writevar(saveas, "mapa" & n, "musicnum", mapinfo(n).music)
call writevar(saveas, "mapa" & n, "startpos", mapinfo(n).startpos.map & "-" & mapinfo(n).startpos.x & "-" & mapinfo(n).startpos.y)

call writevar(saveas, "mapa" & n, "terreno", mapinfo(n).terreno)
call writevar(saveas, "mapa" & n, "zona", mapinfo(n).zona)
call writevar(saveas, "mapa" & n, "restringir", mapinfo(n).restringir)
call writevar(saveas, "mapa" & n, "backup", str(mapinfo(n).backup))

if mapinfo(n).pk then
    call writevar(saveas, "mapa" & n, "pk", "0")
else
    call writevar(saveas, "mapa" & n, "pk", "1")
end if

end sub

sub loadarmasherreria()

dim n as integer, lc as integer

n = val(getvar(datpath & "armasherrero.dat", "init", "numarmas"))

redim preserve armasherrero(1 to n) as integer

for lc = 1 to n
    armasherrero(lc) = val(getvar(datpath & "armasherrero.dat", "arma" & lc, "index"))
next lc


end sub

sub loadarmadurasherreria()

dim n as integer, lc as integer

n = val(getvar(datpath & "armadurasherrero.dat", "init", "numarmaduras"))

redim preserve armadurasherrero(1 to n) as integer

for lc = 1 to n
    armadurasherrero(lc) = val(getvar(datpath & "armadurasherrero.dat", "armadura" & lc, "index"))
next lc

end sub

sub loadobjcarpintero()

dim n as integer, lc as integer

n = val(getvar(datpath & "objcarpintero.dat", "init", "numobjs"))

redim preserve objcarpintero(1 to n) as integer

for lc = 1 to n
    objcarpintero(lc) = val(getvar(datpath & "objcarpintero.dat", "obj" & lc, "index"))
next lc

end sub

sub loadobjdata()

'call logtarea("sub loadobjdata")

on error goto errhandler

if frmmain.visible then frmmain.txstatus.caption = "cargando base de datos de los objetos."

'*****************************************************************
'carga la lista de objetos
'*****************************************************************
dim object as integer

'obtiene el numero de obj
numobjdatas = val(getvar(datpath & "obj.dat", "init", "numobjs"))

frmcargando.cargar.min = 0
frmcargando.cargar.max = numobjdatas
frmcargando.cargar.value = 0


redim preserve objdata(1 to numobjdatas) as objdata
  
'llena la lista
for object = 1 to numobjdatas
        
    objdata(object).name = getvar(datpath & "obj.dat", "obj" & object, "name")
    
    objdata(object).grhindex = val(getvar(datpath & "obj.dat", "obj" & object, "grhindex"))
    
    objdata(object).objtype = val(getvar(datpath & "obj.dat", "obj" & object, "objtype"))
    objdata(object).subtipo = val(getvar(datpath & "obj.dat", "obj" & object, "subtipo"))
    
    objdata(object).newbie = val(getvar(datpath & "obj.dat", "obj" & object, "newbie"))
    
    if objdata(object).subtipo = objtype_escudo then
        objdata(object).shieldanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
        objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
        objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
        objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
        objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
    end if
    
    if objdata(object).subtipo = objtype_casco then
        objdata(object).cascoanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
        objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
        objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
        objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
        objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
    end if
    
    objdata(object).ropaje = val(getvar(datpath & "obj.dat", "obj" & object, "numropaje"))
    objdata(object).hechizoindex = val(getvar(datpath & "obj.dat", "obj" & object, "hechizoindex"))
    
    if objdata(object).objtype = objtype_weapon then
            objdata(object).weaponanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
            objdata(object).apu�ala = val(getvar(datpath & "obj.dat", "obj" & object, "apu�ala"))
            objdata(object).envenena = val(getvar(datpath & "obj.dat", "obj" & object, "envenena"))
            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
            objdata(object).real = val(getvar(datpath & "obj.dat", "obj" & object, "real"))
            objdata(object).caos = val(getvar(datpath & "obj.dat", "obj" & object, "caos"))
            objdata(object).proyectil = val(getvar(datpath & "obj.dat", "obj" & object, "proyectil"))
            objdata(object).municion = val(getvar(datpath & "obj.dat", "obj" & object, "municiones"))
    end if
    
    if objdata(object).objtype = objtype_armour then
            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
            objdata(object).real = val(getvar(datpath & "obj.dat", "obj" & object, "real"))
            objdata(object).caos = val(getvar(datpath & "obj.dat", "obj" & object, "caos"))
    end if
    
    if objdata(object).objtype = objtype_herramientas then
            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
    end if
    
    if objdata(object).objtype = objtype_instrumentos then
        objdata(object).snd1 = val(getvar(datpath & "obj.dat", "obj" & object, "snd1"))
        objdata(object).snd2 = val(getvar(datpath & "obj.dat", "obj" & object, "snd2"))
        objdata(object).snd3 = val(getvar(datpath & "obj.dat", "obj" & object, "snd3"))
        objdata(object).minint = val(getvar(datpath & "obj.dat", "obj" & object, "minint"))
    end if
    
    objdata(object).lingoteindex = val(getvar(datpath & "obj.dat", "obj" & object, "lingoteindex"))
    
    if objdata(object).objtype = 31 or objdata(object).objtype = 23 then
        objdata(object).minskill = val(getvar(datpath & "obj.dat", "obj" & object, "minskill"))
    end if
    
    objdata(object).mineralindex = val(getvar(datpath & "obj.dat", "obj" & object, "mineralindex"))
    
    objdata(object).maxhp = val(getvar(datpath & "obj.dat", "obj" & object, "maxhp"))
    objdata(object).minhp = val(getvar(datpath & "obj.dat", "obj" & object, "minhp"))
  
    
    objdata(object).mujer = val(getvar(datpath & "obj.dat", "obj" & object, "mujer"))
    objdata(object).hombre = val(getvar(datpath & "obj.dat", "obj" & object, "hombre"))
    
    objdata(object).minham = val(getvar(datpath & "obj.dat", "obj" & object, "minham"))
    objdata(object).minsed = val(getvar(datpath & "obj.dat", "obj" & object, "minagu"))
    
    
    objdata(object).mindef = val(getvar(datpath & "obj.dat", "obj" & object, "mindef"))
    objdata(object).maxdef = val(getvar(datpath & "obj.dat", "obj" & object, "maxdef"))
    
    objdata(object).respawn = val(getvar(datpath & "obj.dat", "obj" & object, "respawn"))
    
    objdata(object).razaenana = val(getvar(datpath & "obj.dat", "obj" & object, "razaenana"))
    
    objdata(object).valor = val(getvar(datpath & "obj.dat", "obj" & object, "valor"))
    
    objdata(object).crucial = val(getvar(datpath & "obj.dat", "obj" & object, "crucial"))
    
    objdata(object).cerrada = val(getvar(datpath & "obj.dat", "obj" & object, "abierta"))
    if objdata(object).cerrada = 1 then
            objdata(object).llave = val(getvar(datpath & "obj.dat", "obj" & object, "llave"))
            objdata(object).clave = val(getvar(datpath & "obj.dat", "obj" & object, "clave"))
    end if
    
    
    if objdata(object).objtype = objtype_puertas or objdata(object).objtype = objtype_botellavacia or objdata(object).objtype = objtype_botellallena then
        objdata(object).indexabierta = val(getvar(datpath & "obj.dat", "obj" & object, "indexabierta"))
        objdata(object).indexcerrada = val(getvar(datpath & "obj.dat", "obj" & object, "indexcerrada"))
        objdata(object).indexcerradallave = val(getvar(datpath & "obj.dat", "obj" & object, "indexcerradallave"))
    end if
    
    
    'puertas y llaves
    objdata(object).clave = val(getvar(datpath & "obj.dat", "obj" & object, "clave"))
    
    objdata(object).texto = getvar(datpath & "obj.dat", "obj" & object, "texto")
    objdata(object).grhsecundario = val(getvar(datpath & "obj.dat", "obj" & object, "vgrande"))
    
    objdata(object).agarrable = val(getvar(datpath & "obj.dat", "obj" & object, "agarrable"))
    objdata(object).foroid = getvar(datpath & "obj.dat", "obj" & object, "id")
    
    
    dim i as integer
    for i = 1 to numclases
        objdata(object).claseprohibida(i) = getvar(datpath & "obj.dat", "obj" & object, "cp" & i)
    next
            
    objdata(object).resistencia = val(getvar(datpath & "obj.dat", "obj" & object, "resistencia"))
    
    'pociones
    if objdata(object).objtype = 11 then
        objdata(object).tipopocion = val(getvar(datpath & "obj.dat", "obj" & object, "tipopocion"))
        objdata(object).maxmodificador = val(getvar(datpath & "obj.dat", "obj" & object, "maxmodificador"))
        objdata(object).minmodificador = val(getvar(datpath & "obj.dat", "obj" & object, "minmodificador"))
        objdata(object).duracionefecto = val(getvar(datpath & "obj.dat", "obj" & object, "duracionefecto"))
    end if

    objdata(object).skcarpinteria = val(getvar(datpath & "obj.dat", "obj" & object, "skcarpinteria"))
    
    if objdata(object).skcarpinteria > 0 then _
        objdata(object).madera = val(getvar(datpath & "obj.dat", "obj" & object, "madera"))
    
    if objdata(object).objtype = objtype_barcos then
            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
    end if
    
    if objdata(object).objtype = objtype_flechas then
            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
    end if
    
    'bebidas
    objdata(object).minsta = val(getvar(datpath & "obj.dat", "obj" & object, "minst"))
    
    frmcargando.cargar.value = frmcargando.cargar.value + 1

    
    doevents
next object

exit sub

errhandler:
    msgbox "error cargando objetos"


end sub

sub loadobjdata_nuevo()

'call logtarea("sub loadobjdata")

on error goto errhandler
'on error goto 0

if frmmain.visible then frmmain.txstatus.caption = "cargando base de datos de los objetos."

'*****************************************************************
'carga la lista de objetos
'*****************************************************************
dim object as integer

dim a as long, s as long

a = inicarga(datpath & "obj.dat")
call iniconf(a, 0, "", 0)

'obtiene el numero de obj
'numobjdatas = val(getvar(datpath & "obj.dat", "init", "numobjs"))
s = inibuscarseccion(a, "init")
numobjdatas = inidarclaveint(a, s, "numobjs")

frmcargando.cargar.min = 0
frmcargando.cargar.max = numobjdatas
frmcargando.cargar.value = 0


redim preserve objdata(1 to numobjdatas) as objdata
  
'llena la lista
for object = 1 to numobjdatas
    s = inibuscarseccion(a, "obj" & object)
    
    'objdata(object).name = getvar(datpath & "obj.dat", "obj" & object, "name")
    objdata(object).name = inidarclavestr(a, s, "name")
    
    'objdata(object).grhindex = val(getvar(datpath & "obj.dat", "obj" & object, "grhindex"))
    objdata(object).grhindex = inidarclaveint(a, s, "grhindex")
    
    'objdata(object).objtype = val(getvar(datpath & "obj.dat", "obj" & object, "objtype"))
    'objdata(object).subtipo = val(getvar(datpath & "obj.dat", "obj" & object, "subtipo"))
    
    objdata(object).objtype = inidarclaveint(a, s, "objtype")
    objdata(object).subtipo = inidarclaveint(a, s, "subtipo")
    
    'objdata(object).newbie = val(getvar(datpath & "obj.dat", "obj" & object, "newbie"))
    objdata(object).newbie = inidarclaveint(a, s, "newbie")
    
    if objdata(object).subtipo = objtype_escudo then
'        objdata(object).shieldanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
'        objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
'        objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
'        objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
'        objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
        objdata(object).shieldanim = inidarclaveint(a, s, "anim")
        objdata(object).lingh = inidarclaveint(a, s, "lingh")
        objdata(object).lingp = inidarclaveint(a, s, "lingp")
        objdata(object).lingo = inidarclaveint(a, s, "lingo")
        objdata(object).skherreria = inidarclaveint(a, s, "skherreria")
    end if
    
    if objdata(object).subtipo = objtype_casco then
'        objdata(object).cascoanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
'        objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
'        objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
'        objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
'        objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
        objdata(object).cascoanim = inidarclaveint(a, s, "anim")
        objdata(object).lingh = inidarclaveint(a, s, "lingh")
        objdata(object).lingp = inidarclaveint(a, s, "lingp")
        objdata(object).lingo = inidarclaveint(a, s, "lingo")
        objdata(object).skherreria = inidarclaveint(a, s, "skherreria")
    end if
    
'    objdata(object).ropaje = val(getvar(datpath & "obj.dat", "obj" & object, "numropaje"))
'    objdata(object).hechizoindex = val(getvar(datpath & "obj.dat", "obj" & object, "hechizoindex"))
    objdata(object).ropaje = inidarclaveint(a, s, "numropaje")
    objdata(object).hechizoindex = inidarclaveint(a, s, "hechizoindex")
    
    if objdata(object).objtype = objtype_weapon then
'            objdata(object).weaponanim = val(getvar(datpath & "obj.dat", "obj" & object, "anim"))
'            objdata(object).apu�ala = val(getvar(datpath & "obj.dat", "obj" & object, "apu�ala"))
'            objdata(object).envenena = val(getvar(datpath & "obj.dat", "obj" & object, "envenena"))
'            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
'            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
'            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
'            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
'            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
'            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
'            objdata(object).real = val(getvar(datpath & "obj.dat", "obj" & object, "real"))
'            objdata(object).caos = val(getvar(datpath & "obj.dat", "obj" & object, "caos"))
'            objdata(object).proyectil = val(getvar(datpath & "obj.dat", "obj" & object, "proyectil"))
'            objdata(object).municion = val(getvar(datpath & "obj.dat", "obj" & object, "municiones"))
            
            objdata(object).weaponanim = inidarclaveint(a, s, "anim")
            objdata(object).apu�ala = inidarclaveint(a, s, "apu�ala")
            objdata(object).envenena = inidarclaveint(a, s, "envenena")
            objdata(object).maxhit = inidarclaveint(a, s, "maxhit")
            objdata(object).minhit = inidarclaveint(a, s, "minhit")
            objdata(object).lingh = inidarclaveint(a, s, "lingh")
            objdata(object).lingp = inidarclaveint(a, s, "lingp")
            objdata(object).lingo = inidarclaveint(a, s, "lingo")
            objdata(object).skherreria = inidarclaveint(a, s, "skherreria")
            objdata(object).real = inidarclaveint(a, s, "real")
            objdata(object).caos = inidarclaveint(a, s, "caos")
            objdata(object).proyectil = inidarclaveint(a, s, "proyectil")
            objdata(object).municion = inidarclaveint(a, s, "municiones")
    end if
    
    if objdata(object).objtype = objtype_armour then
'            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
'            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
'            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
'            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
'            objdata(object).real = val(getvar(datpath & "obj.dat", "obj" & object, "real"))
'            objdata(object).caos = val(getvar(datpath & "obj.dat", "obj" & object, "caos"))
            objdata(object).lingh = inidarclaveint(a, s, "lingh")
            objdata(object).lingp = inidarclaveint(a, s, "lingp")
            objdata(object).lingo = inidarclaveint(a, s, "lingo")
            objdata(object).skherreria = inidarclaveint(a, s, "skherreria")
            objdata(object).real = inidarclaveint(a, s, "real")
            objdata(object).caos = inidarclaveint(a, s, "caos")
    end if
    
    if objdata(object).objtype = objtype_herramientas then
'            objdata(object).lingh = val(getvar(datpath & "obj.dat", "obj" & object, "lingh"))
'            objdata(object).lingp = val(getvar(datpath & "obj.dat", "obj" & object, "lingp"))
'            objdata(object).lingo = val(getvar(datpath & "obj.dat", "obj" & object, "lingo"))
'            objdata(object).skherreria = val(getvar(datpath & "obj.dat", "obj" & object, "skherreria"))
            objdata(object).lingh = inidarclaveint(a, s, "lingh")
            objdata(object).lingp = inidarclaveint(a, s, "lingp")
            objdata(object).lingo = inidarclaveint(a, s, "lingo")
            objdata(object).skherreria = inidarclaveint(a, s, "skherreria")
    end if
    
    if objdata(object).objtype = objtype_instrumentos then
'        objdata(object).snd1 = val(getvar(datpath & "obj.dat", "obj" & object, "snd1"))
'        objdata(object).snd2 = val(getvar(datpath & "obj.dat", "obj" & object, "snd1"))
'        objdata(object).snd3 = val(getvar(datpath & "obj.dat", "obj" & object, "snd3"))
'        objdata(object).minint = val(getvar(datpath & "obj.dat", "obj" & object, "minint"))
        objdata(object).snd1 = inidarclaveint(a, s, "snd1")
        objdata(object).snd2 = inidarclaveint(a, s, "snd2")
        objdata(object).snd3 = inidarclaveint(a, s, "snd3")
        objdata(object).minint = inidarclaveint(a, s, "minint")
    end if
    
    'objdata(object).lingoteindex = val(getvar(datpath & "obj.dat", "obj" & object, "lingoteindex"))
    objdata(object).lingoteindex = inidarclaveint(a, s, "lingoteindex")
    
    if objdata(object).objtype = 31 or objdata(object).objtype = 23 then
        'objdata(object).minskill = val(getvar(datpath & "obj.dat", "obj" & object, "minskill"))
        objdata(object).minskill = inidarclaveint(a, s, "minskill")
    end if
    
'    objdata(object).mineralindex = val(getvar(datpath & "obj.dat", "obj" & object, "mineralindex"))
'
'    objdata(object).maxhp = val(getvar(datpath & "obj.dat", "obj" & object, "maxhp"))
'    objdata(object).minhp = val(getvar(datpath & "obj.dat", "obj" & object, "minhp"))
'
'
'    objdata(object).mujer = val(getvar(datpath & "obj.dat", "obj" & object, "mujer"))
'    objdata(object).hombre = val(getvar(datpath & "obj.dat", "obj" & object, "hombre"))
'
'    objdata(object).minham = val(getvar(datpath & "obj.dat", "obj" & object, "minham"))
'    objdata(object).minsed = val(getvar(datpath & "obj.dat", "obj" & object, "minagu"))
    
    objdata(object).mineralindex = inidarclaveint(a, s, "mineralindex")
    
    objdata(object).maxhp = inidarclaveint(a, s, "maxhp")
    objdata(object).minhp = inidarclaveint(a, s, "minhp")
  
    objdata(object).mujer = inidarclaveint(a, s, "mujer")
    objdata(object).hombre = inidarclaveint(a, s, "hombre")
    
    objdata(object).minham = inidarclaveint(a, s, "minham")
    objdata(object).minsed = inidarclaveint(a, s, "minagu")

    
'    objdata(object).mindef = val(getvar(datpath & "obj.dat", "obj" & object, "mindef"))
'    objdata(object).maxdef = val(getvar(datpath & "obj.dat", "obj" & object, "maxdef"))
'
'    objdata(object).respawn = val(getvar(datpath & "obj.dat", "obj" & object, "respawn"))
'
'    objdata(object).razaenana = val(getvar(datpath & "obj.dat", "obj" & object, "razaenana"))
'
'    objdata(object).valor = val(getvar(datpath & "obj.dat", "obj" & object, "valor"))
'
'    objdata(object).crucial = val(getvar(datpath & "obj.dat", "obj" & object, "crucial"))
'
'    objdata(object).cerrada = val(getvar(datpath & "obj.dat", "obj" & object, "abierta"))

    objdata(object).mindef = inidarclaveint(a, s, "mindef")
    objdata(object).maxdef = inidarclaveint(a, s, "maxdef")
    
    objdata(object).respawn = inidarclaveint(a, s, "respawn")
    
    objdata(object).razaenana = inidarclaveint(a, s, "razaenana")
    
    objdata(object).valor = inidarclaveint(a, s, "valor")
    
    objdata(object).crucial = inidarclaveint(a, s, "crucial")
    
    objdata(object).cerrada = inidarclaveint(a, s, "abierta")

    if objdata(object).cerrada = 1 then
'            objdata(object).llave = val(getvar(datpath & "obj.dat", "obj" & object, "llave"))
'            objdata(object).clave = val(getvar(datpath & "obj.dat", "obj" & object, "clave"))
            objdata(object).llave = inidarclaveint(a, s, "llave")
            objdata(object).clave = inidarclaveint(a, s, "clave")
    end if
    
    
    if objdata(object).objtype = objtype_puertas or objdata(object).objtype = objtype_botellavacia or objdata(object).objtype = objtype_botellallena then
'        objdata(object).indexabierta = val(getvar(datpath & "obj.dat", "obj" & object, "indexabierta"))
'        objdata(object).indexcerrada = val(getvar(datpath & "obj.dat", "obj" & object, "indexcerrada"))
'        objdata(object).indexcerradallave = val(getvar(datpath & "obj.dat", "obj" & object, "indexcerradallave"))
        objdata(object).indexabierta = inidarclaveint(a, s, "indexabierta")
        objdata(object).indexcerrada = inidarclaveint(a, s, "indexcerrada")
        objdata(object).indexcerradallave = inidarclaveint(a, s, "indexcerradallave")
    end if
    
    
    'puertas y llaves
'    objdata(object).clave = val(getvar(datpath & "obj.dat", "obj" & object, "clave"))
'
'    objdata(object).texto = getvar(datpath & "obj.dat", "obj" & object, "texto")
'    objdata(object).grhsecundario = val(getvar(datpath & "obj.dat", "obj" & object, "vgrande"))
'
'    objdata(object).agarrable = val(getvar(datpath & "obj.dat", "obj" & object, "agarrable"))
'    objdata(object).foroid = getvar(datpath & "obj.dat", "obj" & object, "id")
    objdata(object).clave = inidarclaveint(a, s, "clave")
    
    objdata(object).texto = inidarclavestr(a, s, "texto")
    objdata(object).grhsecundario = inidarclaveint(a, s, "vgrande")
    
    objdata(object).agarrable = inidarclaveint(a, s, "agarrable")
    objdata(object).foroid = inidarclavestr(a, s, "id")

    
    dim i as integer
    for i = 1 to numclases
        'objdata(object).claseprohibida(i) = getvar(datpath & "obj.dat", "obj" & object, "cp" & i)
        objdata(object).claseprohibida(i) = inidarclavestr(a, s, "cp" & i)
    next
            
    'objdata(object).resistencia = val(getvar(datpath & "obj.dat", "obj" & object, "resistencia"))
    objdata(object).resistencia = inidarclaveint(a, s, "resistencia")
    
    'pociones
    if objdata(object).objtype = 11 then
'        objdata(object).tipopocion = val(getvar(datpath & "obj.dat", "obj" & object, "tipopocion"))
'        objdata(object).maxmodificador = val(getvar(datpath & "obj.dat", "obj" & object, "maxmodificador"))
'        objdata(object).minmodificador = val(getvar(datpath & "obj.dat", "obj" & object, "minmodificador"))
'        objdata(object).duracionefecto = val(getvar(datpath & "obj.dat", "obj" & object, "duracionefecto"))
        objdata(object).tipopocion = inidarclaveint(a, s, "tipopocion")
        objdata(object).maxmodificador = inidarclaveint(a, s, "maxmodificador")
        objdata(object).minmodificador = inidarclaveint(a, s, "minmodificador")
        objdata(object).duracionefecto = inidarclaveint(a, s, "duracionefecto")
    
    end if

'    objdata(object).skcarpinteria = val(getvar(datpath & "obj.dat", "obj" & object, "skcarpinteria"))
    objdata(object).skcarpinteria = inidarclaveint(a, s, "skcarpinteria")
    
    if objdata(object).skcarpinteria > 0 then
        'objdata(object).madera = val(getvar(datpath & "obj.dat", "obj" & object, "madera"))
        objdata(object).madera = inidarclaveint(a, s, "madera")
    end if
    
    if objdata(object).objtype = objtype_barcos then
'            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
'            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
            objdata(object).maxhit = inidarclaveint(a, s, "maxhit")
            objdata(object).minhit = inidarclaveint(a, s, "minhit")
    end if
    
    if objdata(object).objtype = objtype_flechas then
'            objdata(object).maxhit = val(getvar(datpath & "obj.dat", "obj" & object, "maxhit"))
'            objdata(object).minhit = val(getvar(datpath & "obj.dat", "obj" & object, "minhit"))
            objdata(object).maxhit = inidarclaveint(a, s, "maxhit")
            objdata(object).minhit = inidarclaveint(a, s, "minhit")
    end if
    
    'bebidas
    'objdata(object).minsta = val(getvar(datpath & "obj.dat", "obj" & object, "minst"))
    objdata(object).minsta = inidarclaveint(a, s, "minst")
    
    frmcargando.cargar.value = frmcargando.cargar.value + 1

    
    'doevents
next object


call inidescarga(a)

exit sub

errhandler:

call inidescarga(a)

    msgbox "error cargando objetos: " & err.number & " : " & err.description


end sub


sub loaduserstats(userindex as integer, userfile as string)



dim loopc as integer

for loopc = 1 to numatributos
  userlist(userindex).stats.useratributos(loopc) = getvar(userfile, "atributos", "at" & loopc)
  userlist(userindex).stats.useratributosbackup(loopc) = userlist(userindex).stats.useratributos(loopc)
next

for loopc = 1 to numskills
  userlist(userindex).stats.userskills(loopc) = val(getvar(userfile, "skills", "sk" & loopc))
next

for loopc = 1 to maxuserhechizos
  userlist(userindex).stats.userhechizos(loopc) = val(getvar(userfile, "hechizos", "h" & loopc))
next

userlist(userindex).stats.gld = val(getvar(userfile, "stats", "gld"))
userlist(userindex).stats.banco = val(getvar(userfile, "stats", "banco"))

userlist(userindex).stats.met = val(getvar(userfile, "stats", "met"))
userlist(userindex).stats.maxhp = val(getvar(userfile, "stats", "maxhp"))
userlist(userindex).stats.minhp = val(getvar(userfile, "stats", "minhp"))

userlist(userindex).stats.fit = val(getvar(userfile, "stats", "fit"))
userlist(userindex).stats.minsta = val(getvar(userfile, "stats", "minsta"))
userlist(userindex).stats.maxsta = val(getvar(userfile, "stats", "maxsta"))

userlist(userindex).stats.maxman = val(getvar(userfile, "stats", "maxman"))
userlist(userindex).stats.minman = val(getvar(userfile, "stats", "minman"))

userlist(userindex).stats.maxhit = val(getvar(userfile, "stats", "maxhit"))
userlist(userindex).stats.minhit = val(getvar(userfile, "stats", "minhit"))

userlist(userindex).stats.maxagu = val(getvar(userfile, "stats", "maxagu"))
userlist(userindex).stats.minagu = val(getvar(userfile, "stats", "minagu"))

userlist(userindex).stats.maxham = val(getvar(userfile, "stats", "maxham"))
userlist(userindex).stats.minham = val(getvar(userfile, "stats", "minham"))

userlist(userindex).stats.skillpts = val(getvar(userfile, "stats", "skillptslibres"))

userlist(userindex).stats.exp = val(getvar(userfile, "stats", "exp"))
userlist(userindex).stats.elu = val(getvar(userfile, "stats", "elu"))
userlist(userindex).stats.elv = val(getvar(userfile, "stats", "elv"))


userlist(userindex).stats.usuariosmatados = val(getvar(userfile, "muertes", "usermuertes"))
userlist(userindex).stats.criminalesmatados = val(getvar(userfile, "muertes", "crimmuertes"))
userlist(userindex).stats.npcsmuertos = val(getvar(userfile, "muertes", "npcsmuertes"))

end sub

sub loaduserreputacion(userindex as integer, userfile as string)

userlist(userindex).reputacion.asesinorep = val(getvar(userfile, "rep", "asesino"))
userlist(userindex).reputacion.bandidorep = val(getvar(userfile, "rep", "dandido"))
userlist(userindex).reputacion.burguesrep = val(getvar(userfile, "rep", "burguesia"))
userlist(userindex).reputacion.ladronesrep = val(getvar(userfile, "rep", "ladrones"))
userlist(userindex).reputacion.noblerep = val(getvar(userfile, "rep", "nobles"))
userlist(userindex).reputacion.pleberep = val(getvar(userfile, "rep", "plebe"))
userlist(userindex).reputacion.promedio = val(getvar(userfile, "rep", "promedio"))

end sub


sub loaduserinit(userindex as integer, userfile as string)


dim loopc as integer
dim ln as string
dim ln2 as string

userlist(userindex).faccion.armadareal = val(getvar(userfile, "facciones", "ejercitoreal"))
userlist(userindex).faccion.fuerzascaos = val(getvar(userfile, "facciones", "ejercitocaos"))
userlist(userindex).faccion.ciudadanosmatados = val(getvar(userfile, "facciones", "ciudmatados"))
userlist(userindex).faccion.criminalesmatados = val(getvar(userfile, "facciones", "crimmatados"))
userlist(userindex).faccion.recibioarmaduracaos = val(getvar(userfile, "facciones", "rarcaos"))
userlist(userindex).faccion.recibioarmadurareal = val(getvar(userfile, "facciones", "rarreal"))
userlist(userindex).faccion.recibioexpinicialcaos = val(getvar(userfile, "facciones", "rexcaos"))
userlist(userindex).faccion.recibioexpinicialreal = val(getvar(userfile, "facciones", "rexreal"))
userlist(userindex).faccion.recompensascaos = val(getvar(userfile, "facciones", "reccaos"))
userlist(userindex).faccion.recompensasreal = val(getvar(userfile, "facciones", "recreal"))

userlist(userindex).flags.muerto = val(getvar(userfile, "flags", "muerto"))
userlist(userindex).flags.escondido = val(getvar(userfile, "flags", "escondido"))

userlist(userindex).flags.hambre = val(getvar(userfile, "flags", "hambre"))
userlist(userindex).flags.sed = val(getvar(userfile, "flags", "sed"))
userlist(userindex).flags.desnudo = val(getvar(userfile, "flags", "desnudo"))

userlist(userindex).flags.envenenado = val(getvar(userfile, "flags", "envenenado"))
userlist(userindex).flags.paralizado = val(getvar(userfile, "flags", "paralizado"))
if userlist(userindex).flags.paralizado = 1 then
    userlist(userindex).counters.paralisis = intervaloparalizado
end if
userlist(userindex).flags.navegando = val(getvar(userfile, "flags", "navegando"))


userlist(userindex).counters.pena = val(getvar(userfile, "counters", "pena"))

userlist(userindex).email = getvar(userfile, "contacto", "email")

userlist(userindex).genero = getvar(userfile, "init", "genero")
userlist(userindex).clase = getvar(userfile, "init", "clase")
userlist(userindex).raza = getvar(userfile, "init", "raza")
userlist(userindex).hogar = getvar(userfile, "init", "hogar")
userlist(userindex).char.heading = val(getvar(userfile, "init", "heading"))


userlist(userindex).origchar.head = val(getvar(userfile, "init", "head"))
userlist(userindex).origchar.body = val(getvar(userfile, "init", "body"))
userlist(userindex).origchar.weaponanim = val(getvar(userfile, "init", "arma"))
userlist(userindex).origchar.shieldanim = val(getvar(userfile, "init", "escudo"))
userlist(userindex).origchar.cascoanim = val(getvar(userfile, "init", "casco"))
userlist(userindex).origchar.heading = south

if userlist(userindex).flags.muerto = 0 then
        userlist(userindex).char = userlist(userindex).origchar
else
        userlist(userindex).char.body = icuerpomuerto
        userlist(userindex).char.head = icabezamuerto
        userlist(userindex).char.weaponanim = ningunarma
        userlist(userindex).char.shieldanim = ningunescudo
        userlist(userindex).char.cascoanim = ninguncasco
end if


userlist(userindex).desc = getvar(userfile, "init", "desc")


userlist(userindex).pos.map = val(readfield(1, getvar(userfile, "init", "position"), 45))
userlist(userindex).pos.x = val(readfield(2, getvar(userfile, "init", "position"), 45))
userlist(userindex).pos.y = val(readfield(3, getvar(userfile, "init", "position"), 45))

userlist(userindex).invent.nroitems = getvar(userfile, "inventory", "cantidaditems")

dim loopd as integer

'[kevin]--------------------------------------------------------------------
'***********************************************************************************
userlist(userindex).bancoinvent.nroitems = val(getvar(userfile, "bancoinventory", "cantidaditems"))
'lista de objetos del banco
for loopd = 1 to max_bancoinventory_slots
    ln2 = getvar(userfile, "bancoinventory", "obj" & loopd)
    userlist(userindex).bancoinvent.object(loopd).objindex = val(readfield(1, ln2, 45))
    userlist(userindex).bancoinvent.object(loopd).amount = val(readfield(2, ln2, 45))
next loopd
'------------------------------------------------------------------------------------
'[/kevin]*****************************************************************************


'lista de objetos
for loopc = 1 to max_inventory_slots
    ln = getvar(userfile, "inventory", "obj" & loopc)
    userlist(userindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
    userlist(userindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
    userlist(userindex).invent.object(loopc).equipped = val(readfield(3, ln, 45))
next loopc

'obtiene el indice-objeto del arma
userlist(userindex).invent.weaponeqpslot = val(getvar(userfile, "inventory", "weaponeqpslot"))
if userlist(userindex).invent.weaponeqpslot > 0 then
    userlist(userindex).invent.weaponeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.weaponeqpslot).objindex
end if

'obtiene el indice-objeto del armadura
userlist(userindex).invent.armoureqpslot = val(getvar(userfile, "inventory", "armoureqpslot"))
if userlist(userindex).invent.armoureqpslot > 0 then
    userlist(userindex).invent.armoureqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.armoureqpslot).objindex
    userlist(userindex).flags.desnudo = 0
else
    userlist(userindex).flags.desnudo = 1
end if

'obtiene el indice-objeto del escudo
userlist(userindex).invent.escudoeqpslot = val(getvar(userfile, "inventory", "escudoeqpslot"))
if userlist(userindex).invent.escudoeqpslot > 0 then
    userlist(userindex).invent.escudoeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.escudoeqpslot).objindex
end if

'obtiene el indice-objeto del casco
userlist(userindex).invent.cascoeqpslot = val(getvar(userfile, "inventory", "cascoeqpslot"))
if userlist(userindex).invent.cascoeqpslot > 0 then
    userlist(userindex).invent.cascoeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.cascoeqpslot).objindex
end if

'obtiene el indice-objeto barco
userlist(userindex).invent.barcoslot = val(getvar(userfile, "inventory", "barcoslot"))
if userlist(userindex).invent.barcoslot > 0 then
    userlist(userindex).invent.barcoobjindex = userlist(userindex).invent.object(userlist(userindex).invent.barcoslot).objindex
end if

'obtiene el indice-objeto municion
userlist(userindex).invent.municioneqpslot = val(getvar(userfile, "inventory", "municionslot"))
if userlist(userindex).invent.municioneqpslot > 0 then
    userlist(userindex).invent.municioneqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.municioneqpslot).objindex
end if

'[alejo]
'obtiene el indice-objeto herramienta
userlist(userindex).invent.herramientaeqpslot = val(getvar(userfile, "inventory", "herramientaslot"))
if userlist(userindex).invent.herramientaeqpslot > 0 then
    userlist(userindex).invent.herramientaeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.herramientaeqpslot).objindex
end if

userlist(userindex).nromacotas = val(getvar(userfile, "mascotas", "nromascotas"))

'lista de objetos
for loopc = 1 to maxmascotas
    userlist(userindex).mascotastype(loopc) = val(getvar(userfile, "mascotas", "mas" & loopc))
next loopc

userlist(userindex).guildinfo.fundoclan = val(getvar(userfile, "guild", "fundoclan"))
userlist(userindex).guildinfo.esguildleader = val(getvar(userfile, "guild", "esguildleader"))
userlist(userindex).guildinfo.echadas = val(getvar(userfile, "guild", "echadas"))
userlist(userindex).guildinfo.solicitudes = val(getvar(userfile, "guild", "solicitudes"))
userlist(userindex).guildinfo.solicitudesrechazadas = val(getvar(userfile, "guild", "solicitudesrechazadas"))
userlist(userindex).guildinfo.vecesfueguildleader = val(getvar(userfile, "guild", "vecesfueguildleader"))
userlist(userindex).guildinfo.yavoto = val(getvar(userfile, "guild", "yavoto"))
userlist(userindex).guildinfo.clanesparticipo = val(getvar(userfile, "guild", "clanesparticipo"))
userlist(userindex).guildinfo.guildpoints = val(getvar(userfile, "guild", "guildpts"))

userlist(userindex).guildinfo.clanfundado = getvar(userfile, "guild", "clanfundado")
userlist(userindex).guildinfo.guildname = getvar(userfile, "guild", "guildname")

end sub





function getvar(file as string, main as string, var as string) as string

dim sspaces as string ' this will hold the input that the program will retrieve
dim szreturn as string ' this will be the defaul value if the string is not found
  
szreturn = ""
  
sspaces = space(5000) ' this tells the computer how long the longest string can be
  
  
getprivateprofilestring main, var, szreturn, sspaces, len(sspaces), file
  
getvar = rtrim(sspaces)
getvar = left$(getvar, len(getvar) - 1)
  
end function

sub cargarbackup_nuevo()

'call logtarea("sub cargarbackup")

if frmmain.visible then frmmain.txstatus.caption = "cargando backup."

dim map as integer
dim loopc as integer
dim x as integer
dim y as integer
dim dummyint as integer
dim tempint as integer
dim saveas as string
dim npcfile as string
dim porc as long
dim filename as string
dim c$

dim archmap as string, archinf as string

on error goto man

 
nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))
frmcargando.cargar.min = 0
frmcargando.cargar.max = nummaps
frmcargando.cargar.value = 0

mappath = getvar(datpath & "map.dat", "init", "mappath")

redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
redim mapinfo(1 to nummaps) as mapinfo
  
for map = 1 to nummaps
    
    filename = app.path & "\worldbackup\map" & map & ".map"
    
    if fileexist(filename, vbnormal) then
        archmap = app.path & "\worldbackup\map" & map & ".map"
        archinf = app.path & "\worldbackup\map" & map & ".inf"
        c$ = app.path & "\worldbackup\map" & map & ".dat"
    else
        archmap = app.path & mappath & "mapa" & map & ".map"
        archinf = app.path & mappath & "mapa" & map & ".inf"
        c$ = app.path & mappath & "mapa" & map & ".dat"
    end if
    
        call cargarunmapa(map, archmap, archinf)
        
          frmcargando.cargar.value = frmcargando.cargar.value + 1
          
          doevents
next map

frmstat.visible = false

exit sub

man:
    msgbox ("error durante la carga de mapas.")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)

  

end sub

sub cargarbackup()

'call logtarea("sub cargarbackup")

if frmmain.visible then frmmain.txstatus.caption = "cargando backup."

dim map as integer
dim loopc as integer
dim x as integer
dim y as integer
dim dummyint as integer
dim tempint as integer
dim saveas as string
dim npcfile as string
dim porc as long
dim filename as string
dim c$
    
on error goto man

 
nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))
frmcargando.cargar.min = 0
frmcargando.cargar.max = nummaps
frmcargando.cargar.value = 0

mappath = getvar(datpath & "map.dat", "init", "mappath")

redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
redim mapinfo(1 to nummaps) as mapinfo
  
for map = 1 to nummaps
    
    filename = app.path & "\worldbackup\map" & map & ".map"
    
    if fileexist(filename, vbnormal) then
        open app.path & "\worldbackup\map" & map & ".map" for binary as #1
        open app.path & "\worldbackup\map" & map & ".inf" for binary as #2
        c$ = app.path & "\worldbackup\map" & map & ".dat"
    else
        open app.path & mappath & "mapa" & map & ".map" for binary as #1
        open app.path & mappath & "mapa" & map & ".inf" for binary as #2
        c$ = app.path & mappath & "mapa" & map & ".dat"
    end if
    
        seek #1, 1
        seek #2, 1
        'map header
        get #1, , mapinfo(map).mapversion
        get #1, , micabecera
        get #1, , tempint
        get #1, , tempint
        get #1, , tempint
        get #1, , tempint
        'inf header
        get #2, , tempint
        get #2, , tempint
        get #2, , tempint
        get #2, , tempint
        get #2, , tempint
        'load arrays
                    doevents
        for y = yminmapsize to ymaxmapsize
            for x = xminmapsize to xmaxmapsize
                    '.dat file
                    get #1, , mapdata(map, x, y).blocked
                    
                    'get grh number
                    for loopc = 1 to 4
                        get #1, , mapdata(map, x, y).graphic(loopc)
                    next loopc
                    
                    'space holder for future expansion
                    get #1, , mapdata(map, x, y).trigger
                    get #1, , tempint
                    
                                        
                    '.inf file
                    get #2, , mapdata(map, x, y).tileexit.map
                    get #2, , mapdata(map, x, y).tileexit.x
                    get #2, , mapdata(map, x, y).tileexit.y
                    
                    'get and make npc
                    get #2, , mapdata(map, x, y).npcindex
                    if mapdata(map, x, y).npcindex > 0 then
                        mapdata(map, x, y).npcindex = opennpc(mapdata(map, x, y).npcindex)
                        'si el npc debe hacer respawn en la pos
                        'original la guardamos
                        
                        if npclist(mapdata(map, x, y).npcindex).numero > 499 then
                            npcfile = datpath & "npcs-hostiles.dat"
                        else
                            npcfile = datpath & "npcs.dat"
                        end if
                        
                        dim fl as byte
                        fl = val(getvar(npcfile, "npc" & npclist(mapdata(map, x, y).npcindex).numero, "posorig"))
                        if fl = 1 then
                            npclist(mapdata(map, x, y).npcindex).orig.map = map
                            npclist(mapdata(map, x, y).npcindex).orig.x = x
                            npclist(mapdata(map, x, y).npcindex).orig.y = y
                        else
                            npclist(mapdata(map, x, y).npcindex).orig.map = 0
                            npclist(mapdata(map, x, y).npcindex).orig.x = 0
                            npclist(mapdata(map, x, y).npcindex).orig.y = 0
                        end if
        
                        npclist(mapdata(map, x, y).npcindex).pos.map = map
                        npclist(mapdata(map, x, y).npcindex).pos.x = x
                        npclist(mapdata(map, x, y).npcindex).pos.y = y
                        
                        
                        'si existe el backup lo cargamos
                        if npclist(mapdata(map, x, y).npcindex).flags.backup = 1 then
                                'cargamos el nuevo del backup
                                call cargarnpcbackup(mapdata(map, x, y).npcindex, npclist(mapdata(map, x, y).npcindex).numero)
                                
                        end if
                        
                        call makenpcchar(tonone, 0, 0, mapdata(map, x, y).npcindex, map, x, y)
                    end if

                    'get and make object
                    get #2, , mapdata(map, x, y).objinfo.objindex
                    get #2, , mapdata(map, x, y).objinfo.amount
        
                    'space holder for future expansion (objects, ect.
                    get #2, , dummyint
                    get #2, , dummyint
            next x
        next y
        close #1
        close #2
          mapinfo(map).name = getvar(c$, "mapa" & map, "name")
          mapinfo(map).music = getvar(c$, "mapa" & map, "musicnum")
          mapinfo(map).startpos.map = val(readfield(1, getvar(c$, "mapa" & map, "startpos"), 45))
          mapinfo(map).startpos.x = val(readfield(2, getvar(c$, "mapa" & map, "startpos"), 45))
          mapinfo(map).startpos.y = val(readfield(3, getvar(c$, "mapa" & map, "startpos"), 45))
          if val(getvar(c$, "mapa" & map, "pk")) = 0 then
                mapinfo(map).pk = true
          else
                mapinfo(map).pk = false
          end if
          mapinfo(map).restringir = getvar(c$, "mapa" & map, "restringir")
          mapinfo(map).backup = val(getvar(c$, "mapa" & map, "backup"))
          mapinfo(map).terreno = getvar(c$, "mapa" & map, "terreno")
          mapinfo(map).zona = getvar(c$, "mapa" & map, "zona")
          
          frmcargando.cargar.value = frmcargando.cargar.value + 1
          
          doevents
next map

frmstat.visible = false

exit sub

man:
    msgbox ("error durante la carga de mapas.")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)

  

end sub

sub loadmapdata()


'call logtarea("sub loadmapdata")

if frmmain.visible then frmmain.txstatus.caption = "cargando mapas."

dim map as integer
dim loopc as integer
dim x as integer
dim y as integer
dim dummyint as integer
dim tempint as integer
dim npcfile as string

on error goto man

nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))

frmcargando.cargar.min = 0
frmcargando.cargar.max = nummaps
frmcargando.cargar.value = 0

mappath = getvar(datpath & "map.dat", "init", "mappath")

redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
redim mapinfo(1 to nummaps) as mapinfo
  
for map = 1 to nummaps
    doevents
    
    
    open app.path & mappath & "mapa" & map & ".map" for binary as #1
    seek #1, 1
    
    'inf
    open app.path & mappath & "mapa" & map & ".inf" for binary as #2
    seek #2, 1
    
     'map header
    get #1, , mapinfo(map).mapversion
    get #1, , micabecera
    get #1, , tempint
    get #1, , tempint
    get #1, , tempint
    get #1, , tempint

    'inf header
    get #2, , tempint
    get #2, , tempint
    get #2, , tempint
    get #2, , tempint
    get #2, , tempint
        
    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            '.dat file
            get #1, , mapdata(map, x, y).blocked
            
            for loopc = 1 to 4
                get #1, , mapdata(map, x, y).graphic(loopc)
            next loopc
            
            get #1, , mapdata(map, x, y).trigger
            get #1, , tempint
            
                                
            '.inf file
            get #2, , mapdata(map, x, y).tileexit.map
            get #2, , mapdata(map, x, y).tileexit.x
            get #2, , mapdata(map, x, y).tileexit.y
            
            'get and make npc
            get #2, , mapdata(map, x, y).npcindex
            if mapdata(map, x, y).npcindex > 0 then
                
                if mapdata(map, x, y).npcindex > 499 then
                        npcfile = datpath & "npcs-hostiles.dat"
                else
                        npcfile = datpath & "npcs.dat"
                end if
                
                'si el npc debe hacer respawn en la pos
                'original la guardamos
                if val(getvar(npcfile, "npc" & mapdata(map, x, y).npcindex, "posorig")) = 1 then
                    mapdata(map, x, y).npcindex = opennpc(mapdata(map, x, y).npcindex)
                    npclist(mapdata(map, x, y).npcindex).orig.map = map
                    npclist(mapdata(map, x, y).npcindex).orig.x = x
                    npclist(mapdata(map, x, y).npcindex).orig.y = y
                else
                    mapdata(map, x, y).npcindex = opennpc(mapdata(map, x, y).npcindex)
                end if
                
                npclist(mapdata(map, x, y).npcindex).pos.map = map
                npclist(mapdata(map, x, y).npcindex).pos.x = x
                npclist(mapdata(map, x, y).npcindex).pos.y = y
                
                call makenpcchar(tonone, 0, 0, mapdata(map, x, y).npcindex, map, x, y)
            end if

            'get and make object
            get #2, , mapdata(map, x, y).objinfo.objindex
            get #2, , mapdata(map, x, y).objinfo.amount

            'space holder for future expansion (objects, ect.
            get #2, , dummyint
            get #2, , dummyint
        
        next x
    next y

   
    close #1
    close #2

  
    mapinfo(map).name = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "name")
    mapinfo(map).music = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "musicnum")
    mapinfo(map).startpos.map = val(readfield(1, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    mapinfo(map).startpos.x = val(readfield(2, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    mapinfo(map).startpos.y = val(readfield(3, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    
    if val(getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "pk")) = 0 then
        mapinfo(map).pk = true
    else
        mapinfo(map).pk = false
    end if
    
    
    mapinfo(map).terreno = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "terreno")

    mapinfo(map).zona = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "zona")
    
    mapinfo(map).restringir = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "restringir")
    
    mapinfo(map).backup = val(getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "backup"))

    frmcargando.cargar.value = frmcargando.cargar.value + 1
next map


exit sub

man:
    msgbox ("error durante la carga de mapas, el mapa " & map & " contiene errores")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)

    
end sub

sub loadmapdata_nuevo()


'call logtarea("sub loadmapdata")

if frmmain.visible then frmmain.txstatus.caption = "cargando mapas."

dim map as integer
dim loopc as integer
dim x as integer
dim y as integer
dim dummyint as integer
dim tempint as integer
dim npcfile as string

dim archmap as string, archinf as string

on error goto man

nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))

frmcargando.cargar.min = 0
frmcargando.cargar.max = nummaps
frmcargando.cargar.value = 0

mappath = getvar(datpath & "map.dat", "init", "mappath")

redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
redim mapinfo(1 to nummaps) as mapinfo
  
for map = 1 to nummaps
    doevents
    
    archmap = app.path & mappath & "mapa" & map & ".map"
    archinf = app.path & mappath & "mapa" & map & ".inf"

    call cargarunmapa(map, archmap, archinf)
    
    frmcargando.cargar.value = frmcargando.cargar.value + 1
next map


exit sub

man:
    msgbox ("error durante la carga de mapas, el mapa " & map & " contiene errores")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)

    
end sub


sub loadsini()

dim temporal as long
dim temporal1 as long
dim loopc as integer

if frmmain.visible then frmmain.txstatus.caption = "cargando info de inicio del server."

bootdelbackup = val(getvar(inipath & "server.ini", "init", "iniciardesdebackup"))

serverip = getvar(inipath & "server.ini", "init", "serverip")

puerto = val(getvar(inipath & "server.ini", "init", "startport"))
hideme = val(getvar(inipath & "server.ini", "init", "hide"))
allowmultilogins = val(getvar(inipath & "server.ini", "init", "allowmultilogins"))
idlelimit = val(getvar(inipath & "server.ini", "init", "idlelimit"))
'lee la version correcta del cliente
ultimaversion = getvar(inipath & "server.ini", "init", "version")

puedecrearpersonajes = val(getvar(inipath & "server.ini", "init", "puedecrearpersonajes"))

armaduraimperial1 = val(getvar(inipath & "server.ini", "init", "armaduraimperial1"))
armaduraimperial2 = val(getvar(inipath & "server.ini", "init", "armaduraimperial2"))
armaduraimperial3 = val(getvar(inipath & "server.ini", "init", "armaduraimperial3"))
tunicamagoimperial = val(getvar(inipath & "server.ini", "init", "tunicamagoimperial"))
tunicamagoimperialenanos = val(getvar(inipath & "server.ini", "init", "tunicamagoimperialenanos"))

armaduracaos1 = val(getvar(inipath & "server.ini", "init", "armaduracaos1"))
armaduracaos2 = val(getvar(inipath & "server.ini", "init", "armaduracaos2"))
armaduracaos3 = val(getvar(inipath & "server.ini", "init", "armaduracaos3"))
tunicamagocaos = val(getvar(inipath & "server.ini", "init", "tunicamagocaos"))
tunicamagocaosenanos = val(getvar(inipath & "server.ini", "init", "tunicamagocaosenanos"))


clientscommandsqueue = val(getvar(inipath & "server.ini", "init", "clientscommandsqueue"))

if clientscommandsqueue <> 0 then
        frmmain.cmdexec.enabled = true
else
        frmmain.cmdexec.enabled = false
end if

'start pos
startpos.map = val(readfield(1, getvar(inipath & "server.ini", "init", "startpos"), 45))
startpos.x = val(readfield(2, getvar(inipath & "server.ini", "init", "startpos"), 45))
startpos.y = val(readfield(3, getvar(inipath & "server.ini", "init", "startpos"), 45))

'intervalos
sanaintervalosindescansar = val(getvar(inipath & "server.ini", "intervalos", "sanaintervalosindescansar"))
frminterv.txtsanaintervalosindescansar.text = sanaintervalosindescansar

staminaintervalosindescansar = val(getvar(inipath & "server.ini", "intervalos", "staminaintervalosindescansar"))
frminterv.txtstaminaintervalosindescansar.text = staminaintervalosindescansar

sanaintervalodescansar = val(getvar(inipath & "server.ini", "intervalos", "sanaintervalodescansar"))
frminterv.txtsanaintervalodescansar.text = sanaintervalodescansar

staminaintervalodescansar = val(getvar(inipath & "server.ini", "intervalos", "staminaintervalodescansar"))
frminterv.txtstaminaintervalodescansar.text = staminaintervalodescansar

intervalosed = val(getvar(inipath & "server.ini", "intervalos", "intervalosed"))
frminterv.txtintervalosed.text = intervalosed

intervalohambre = val(getvar(inipath & "server.ini", "intervalos", "intervalohambre"))
frminterv.txtintervalohambre.text = intervalohambre

intervaloveneno = val(getvar(inipath & "server.ini", "intervalos", "intervaloveneno"))
frminterv.txtintervaloveneno.text = intervaloveneno

intervaloparalizado = val(getvar(inipath & "server.ini", "intervalos", "intervaloparalizado"))
frminterv.txtintervaloparalizado.text = intervaloparalizado

intervaloinvisible = val(getvar(inipath & "server.ini", "intervalos", "intervaloinvisible"))
frminterv.txtintervaloinvisible.text = intervaloinvisible

intervalofrio = val(getvar(inipath & "server.ini", "intervalos", "intervalofrio"))
frminterv.txtintervalofrio.text = intervalofrio

intervalowavfx = val(getvar(inipath & "server.ini", "intervalos", "intervalowavfx"))
frminterv.txtintervalowavfx.text = intervalowavfx

intervaloinvocacion = val(getvar(inipath & "server.ini", "intervalos", "intervaloinvocacion"))
frminterv.txtinvocacion.text = intervaloinvocacion

intervaloparaconexion = val(getvar(inipath & "server.ini", "intervalos", "intervaloparaconexion"))
frminterv.txtintervaloparaconexion.text = intervaloparaconexion

'&&&&&&&&&&&&&&&&&&&&& timers &&&&&&&&&&&&&&&&&&&&&&&


intervalouserpuedecastear = val(getvar(inipath & "server.ini", "intervalos", "intervalolanzahechizo"))
frminterv.txtintervalolanzahechizo.text = intervalouserpuedecastear

frmmain.timer_ai.interval = val(getvar(inipath & "server.ini", "intervalos", "intervalonpcai"))
frminterv.txtai.text = frmmain.timer_ai.interval

frmmain.npcataca.interval = val(getvar(inipath & "server.ini", "intervalos", "intervalonpcpuedeatacar"))
frminterv.txtnpcpuedeatacar.text = frmmain.npcataca.interval

intervalouserpuedetrabajar = val(getvar(inipath & "server.ini", "intervalos", "intervalotrabajo"))
frminterv.txttrabajo.text = intervalouserpuedetrabajar

intervalouserpuedeatacar = val(getvar(inipath & "server.ini", "intervalos", "intervalouserpuedeatacar"))
frminterv.txtpuedeatacar.text = intervalouserpuedeatacar

frmmain.tlluvia.interval = val(getvar(inipath & "server.ini", "intervalos", "intervaloperdidastaminalluvia"))
frminterv.txtintervaloperdidastaminalluvia.text = frmmain.tlluvia.interval

frmmain.cmdexec.interval = val(getvar(inipath & "server.ini", "intervalos", "intervalotimerexec"))
frminterv.txtcmdexec.text = frmmain.cmdexec.interval

minutosws = val(getvar(inipath & "server.ini", "intervalos", "intervalows"))
if minutosws < 60 then minutosws = 180

intervalocerrarconexion = val(getvar(inipath & "server.ini", "intervalos", "intervalocerrarconexion"))

'ressurect pos
respos.map = val(readfield(1, getvar(inipath & "server.ini", "init", "respos"), 45))
respos.x = val(readfield(2, getvar(inipath & "server.ini", "init", "respos"), 45))
respos.y = val(readfield(3, getvar(inipath & "server.ini", "init", "respos"), 45))
  
recordusuarios = val(getvar(inipath & "server.ini", "init", "record"))
  
'max users
maxusers = val(getvar(inipath & "server.ini", "init", "maxusers"))
redim userlist(1 to maxusers) as user


nix.map = getvar(datpath & "ciudades.dat", "nix", "mapa")
nix.x = getvar(datpath & "ciudades.dat", "nix", "x")
nix.y = getvar(datpath & "ciudades.dat", "nix", "y")

ullathorpe.map = getvar(datpath & "ciudades.dat", "ullathorpe", "mapa")
ullathorpe.x = getvar(datpath & "ciudades.dat", "ullathorpe", "x")
ullathorpe.y = getvar(datpath & "ciudades.dat", "ullathorpe", "y")

banderbill.map = getvar(datpath & "ciudades.dat", "banderbill", "mapa")
banderbill.x = getvar(datpath & "ciudades.dat", "banderbill", "x")
banderbill.y = getvar(datpath & "ciudades.dat", "banderbill", "y")

lindos.map = getvar(datpath & "ciudades.dat", "lindos", "mapa")
lindos.x = getvar(datpath & "ciudades.dat", "lindos", "x")
lindos.y = getvar(datpath & "ciudades.dat", "lindos", "y")

redim md5s(val(getvar(inipath & "server.ini", "md5hush", "md5aceptados")))
for loopc = 0 to ubound(md5s)
    md5s(loopc) = getvar(inipath & "server.ini", "md5hush", "md5aceptado" & (loopc + 1))
    md5s(loopc) = txtoffset(hexmd52asc(md5s(loopc)), 53)
next loopc

end sub

sub writevar(file as string, main as string, var as string, value as string)
'*****************************************************************
'escribe var en un archivo
'*****************************************************************

writeprivateprofilestring main, var, value, file
    
end sub

sub saveuser(userindex as integer, userfile as string)
on error goto errhandler

dim olduserhead as long

if fileexist(userfile, vbnormal) then
       if userlist(userindex).flags.muerto = 1 then
        olduserhead = userlist(userindex).char.head
        userlist(userindex).char.head = val(getvar(userfile, "init", "head"))
       end if
       kill userfile
end if

dim loopc as integer


call writevar(userfile, "flags", "muerto", val(userlist(userindex).flags.muerto))
call writevar(userfile, "flags", "escondido", val(userlist(userindex).flags.escondido))
call writevar(userfile, "flags", "hambre", val(userlist(userindex).flags.hambre))
call writevar(userfile, "flags", "sed", val(userlist(userindex).flags.sed))
call writevar(userfile, "flags", "desnudo", val(userlist(userindex).flags.desnudo))
call writevar(userfile, "flags", "ban", val(userlist(userindex).flags.ban))
call writevar(userfile, "flags", "navegando", val(userlist(userindex).flags.navegando))

call writevar(userfile, "flags", "envenenado", val(userlist(userindex).flags.envenenado))
call writevar(userfile, "flags", "paralizado", val(userlist(userindex).flags.paralizado))

call writevar(userfile, "counters", "pena", val(userlist(userindex).counters.pena))

call writevar(userfile, "facciones", "ejercitoreal", val(userlist(userindex).faccion.armadareal))
call writevar(userfile, "facciones", "ejercitocaos", val(userlist(userindex).faccion.fuerzascaos))
call writevar(userfile, "facciones", "ciudmatados", val(userlist(userindex).faccion.ciudadanosmatados))
call writevar(userfile, "facciones", "crimmatados", val(userlist(userindex).faccion.criminalesmatados))
call writevar(userfile, "facciones", "rarcaos", val(userlist(userindex).faccion.recibioarmaduracaos))
call writevar(userfile, "facciones", "rarreal", val(userlist(userindex).faccion.recibioarmadurareal))
call writevar(userfile, "facciones", "rexcaos", val(userlist(userindex).faccion.recibioexpinicialcaos))
call writevar(userfile, "facciones", "rexreal", val(userlist(userindex).faccion.recibioexpinicialreal))
call writevar(userfile, "facciones", "reccaos", val(userlist(userindex).faccion.recompensascaos))
call writevar(userfile, "facciones", "recreal", val(userlist(userindex).faccion.recompensasreal))


call writevar(userfile, "guild", "esguildleader", val(userlist(userindex).guildinfo.esguildleader))
call writevar(userfile, "guild", "echadas", val(userlist(userindex).guildinfo.echadas))
call writevar(userfile, "guild", "solicitudes", val(userlist(userindex).guildinfo.solicitudes))
call writevar(userfile, "guild", "solicitudesrechazadas", val(userlist(userindex).guildinfo.solicitudesrechazadas))
call writevar(userfile, "guild", "vecesfueguildleader", val(userlist(userindex).guildinfo.vecesfueguildleader))
call writevar(userfile, "guild", "yavoto", val(userlist(userindex).guildinfo.yavoto))
call writevar(userfile, "guild", "fundoclan", val(userlist(userindex).guildinfo.fundoclan))

call writevar(userfile, "guild", "guildname", userlist(userindex).guildinfo.guildname)
call writevar(userfile, "guild", "clanfundado", userlist(userindex).guildinfo.clanfundado)
call writevar(userfile, "guild", "clanesparticipo", str(userlist(userindex).guildinfo.clanesparticipo))
call writevar(userfile, "guild", "guildpts", str(userlist(userindex).guildinfo.guildpoints))

'�fueron modificados los atributos del usuario?
if not userlist(userindex).flags.tomopocion then
    for loopc = 1 to ubound(userlist(userindex).stats.useratributos)
        call writevar(userfile, "atributos", "at" & loopc, val(userlist(userindex).stats.useratributos(loopc)))
    next
else
    for loopc = 1 to ubound(userlist(userindex).stats.useratributos)
        'userlist(userindex).stats.useratributos(loopc) = userlist(userindex).stats.useratributosbackup(loopc)
        call writevar(userfile, "atributos", "at" & loopc, val(userlist(userindex).stats.useratributosbackup(loopc)))
    next
end if

for loopc = 1 to ubound(userlist(userindex).stats.userskills)
    call writevar(userfile, "skills", "sk" & loopc, val(userlist(userindex).stats.userskills(loopc)))
next


call writevar(userfile, "contacto", "email", userlist(userindex).email)

call writevar(userfile, "init", "genero", userlist(userindex).genero)
call writevar(userfile, "init", "raza", userlist(userindex).raza)
call writevar(userfile, "init", "hogar", userlist(userindex).hogar)
call writevar(userfile, "init", "clase", userlist(userindex).clase)
call writevar(userfile, "init", "password", userlist(userindex).password)
call writevar(userfile, "init", "desc", userlist(userindex).desc)

call writevar(userfile, "init", "heading", str(userlist(userindex).char.heading))

call writevar(userfile, "init", "head", str(userlist(userindex).origchar.head))

if userlist(userindex).flags.muerto = 0 then
    call writevar(userfile, "init", "body", str(userlist(userindex).char.body))
end if

call writevar(userfile, "init", "arma", str(userlist(userindex).char.weaponanim))
call writevar(userfile, "init", "escudo", str(userlist(userindex).char.shieldanim))
call writevar(userfile, "init", "casco", str(userlist(userindex).char.cascoanim))

call writevar(userfile, "init", "lastip", userlist(userindex).ip)
call writevar(userfile, "init", "position", userlist(userindex).pos.map & "-" & userlist(userindex).pos.x & "-" & userlist(userindex).pos.y)


call writevar(userfile, "stats", "gld", str(userlist(userindex).stats.gld))
call writevar(userfile, "stats", "banco", str(userlist(userindex).stats.banco))

call writevar(userfile, "stats", "met", str(userlist(userindex).stats.met))
call writevar(userfile, "stats", "maxhp", str(userlist(userindex).stats.maxhp))
call writevar(userfile, "stats", "minhp", str(userlist(userindex).stats.minhp))

call writevar(userfile, "stats", "fit", str(userlist(userindex).stats.fit))
call writevar(userfile, "stats", "maxsta", str(userlist(userindex).stats.maxsta))
call writevar(userfile, "stats", "minsta", str(userlist(userindex).stats.minsta))

call writevar(userfile, "stats", "maxman", str(userlist(userindex).stats.maxman))
call writevar(userfile, "stats", "minman", str(userlist(userindex).stats.minman))

call writevar(userfile, "stats", "maxhit", str(userlist(userindex).stats.maxhit))
call writevar(userfile, "stats", "minhit", str(userlist(userindex).stats.minhit))

call writevar(userfile, "stats", "maxagu", str(userlist(userindex).stats.maxagu))
call writevar(userfile, "stats", "minagu", str(userlist(userindex).stats.minagu))

call writevar(userfile, "stats", "maxham", str(userlist(userindex).stats.maxham))
call writevar(userfile, "stats", "minham", str(userlist(userindex).stats.minham))

call writevar(userfile, "stats", "skillptslibres", str(userlist(userindex).stats.skillpts))
  
call writevar(userfile, "stats", "exp", str(userlist(userindex).stats.exp))
call writevar(userfile, "stats", "elv", str(userlist(userindex).stats.elv))
call writevar(userfile, "stats", "elu", str(userlist(userindex).stats.elu))
call writevar(userfile, "muertes", "usermuertes", val(userlist(userindex).stats.usuariosmatados))
call writevar(userfile, "muertes", "crimmuertes", val(userlist(userindex).stats.criminalesmatados))
call writevar(userfile, "muertes", "npcsmuertes", val(userlist(userindex).stats.npcsmuertos))
  
'[kevin]----------------------------------------------------------------------------
'*******************************************************************************************
call writevar(userfile, "bancoinventory", "cantidaditems", val(userlist(userindex).bancoinvent.nroitems))
dim loopd as integer
for loopd = 1 to max_bancoinventory_slots
    call writevar(userfile, "bancoinventory", "obj" & loopd, userlist(userindex).bancoinvent.object(loopd).objindex & "-" & userlist(userindex).bancoinvent.object(loopd).amount)
next loopd
'*******************************************************************************************
'[/kevin]-----------
  
'save inv
call writevar(userfile, "inventory", "cantidaditems", val(userlist(userindex).invent.nroitems))

for loopc = 1 to max_inventory_slots
    call writevar(userfile, "inventory", "obj" & loopc, userlist(userindex).invent.object(loopc).objindex & "-" & userlist(userindex).invent.object(loopc).amount & "-" & userlist(userindex).invent.object(loopc).equipped)
next

call writevar(userfile, "inventory", "weaponeqpslot", str(userlist(userindex).invent.weaponeqpslot))
call writevar(userfile, "inventory", "armoureqpslot", str(userlist(userindex).invent.armoureqpslot))
call writevar(userfile, "inventory", "cascoeqpslot", str(userlist(userindex).invent.cascoeqpslot))
call writevar(userfile, "inventory", "escudoeqpslot", str(userlist(userindex).invent.escudoeqpslot))
call writevar(userfile, "inventory", "barcoslot", str(userlist(userindex).invent.barcoslot))
call writevar(userfile, "inventory", "municionslot", str(userlist(userindex).invent.municioneqpslot))
call writevar(userfile, "inventory", "herramientaslot", str(userlist(userindex).invent.herramientaeqpslot))


'reputacion
call writevar(userfile, "rep", "asesino", val(userlist(userindex).reputacion.asesinorep))
call writevar(userfile, "rep", "bandido", val(userlist(userindex).reputacion.bandidorep))
call writevar(userfile, "rep", "burguesia", val(userlist(userindex).reputacion.burguesrep))
call writevar(userfile, "rep", "ladrones", val(userlist(userindex).reputacion.ladronesrep))
call writevar(userfile, "rep", "nobles", val(userlist(userindex).reputacion.noblerep))
call writevar(userfile, "rep", "plebe", val(userlist(userindex).reputacion.pleberep))

dim l as long
l = (-userlist(userindex).reputacion.asesinorep) + _
    (-userlist(userindex).reputacion.bandidorep) + _
    userlist(userindex).reputacion.burguesrep + _
    (-userlist(userindex).reputacion.ladronesrep) + _
    userlist(userindex).reputacion.noblerep + _
    userlist(userindex).reputacion.pleberep
l = l / 6
call writevar(userfile, "rep", "promedio", val(l))

dim cad as string

for loopc = 1 to maxuserhechizos
    cad = userlist(userindex).stats.userhechizos(loopc)
    call writevar(userfile, "hechizos", "h" & loopc, cad)
next

dim nromascotas as long
nromascotas = userlist(userindex).nromacotas

for loopc = 1 to maxmascotas
    ' mascota valida?
    if userlist(userindex).mascotasindex(loopc) > 0 then
        ' nos aseguramos que la criatura no fue invocada
        if npclist(userlist(userindex).mascotasindex(loopc)).contadores.tiempoexistencia = 0 then
            cad = userlist(userindex).mascotastype(loopc)
        else 'si fue invocada no la guardamos
            cad = "0"
            nromascotas = nromascotas - 1
        end if
        call writevar(userfile, "mascotas", "mas" & loopc, cad)
    end if

next

call writevar(userfile, "mascotas", "nromascotas", str(nromascotas))

'devuelve el head de muerto
if userlist(userindex).flags.muerto = 1 then
    userlist(userindex).char.head = icabezamuerto
end if

exit sub

errhandler:
call logerror("error en saveuser")

end sub

function criminal(byval userindex as integer) as boolean

dim l as long
l = (-userlist(userindex).reputacion.asesinorep) + _
    (-userlist(userindex).reputacion.bandidorep) + _
    userlist(userindex).reputacion.burguesrep + _
    (-userlist(userindex).reputacion.ladronesrep) + _
    userlist(userindex).reputacion.noblerep + _
    userlist(userindex).reputacion.pleberep
l = l / 6
criminal = (l < 0)

end function




sub backupnpc(npcindex as integer)

'call logtarea("sub backupnpc npcindex:" & npcindex)

dim npcnumero as integer
dim npcfile as string
dim loopc as integer


npcnumero = npclist(npcindex).numero

if npcnumero > 499 then
    npcfile = datpath & "bknpcs-hostiles.dat"
else
    npcfile = datpath & "bknpcs.dat"
end if

'general
call writevar(npcfile, "npc" & npcnumero, "name", npclist(npcindex).name)
call writevar(npcfile, "npc" & npcnumero, "desc", npclist(npcindex).desc)
call writevar(npcfile, "npc" & npcnumero, "head", val(npclist(npcindex).char.head))
call writevar(npcfile, "npc" & npcnumero, "body", val(npclist(npcindex).char.body))
call writevar(npcfile, "npc" & npcnumero, "heading", val(npclist(npcindex).char.heading))
call writevar(npcfile, "npc" & npcnumero, "movement", val(npclist(npcindex).movement))
call writevar(npcfile, "npc" & npcnumero, "attackable", val(npclist(npcindex).attackable))
call writevar(npcfile, "npc" & npcnumero, "comercia", val(npclist(npcindex).comercia))
call writevar(npcfile, "npc" & npcnumero, "tipoitems", val(npclist(npcindex).tipoitems))
call writevar(npcfile, "npc" & npcnumero, "hostil", val(npclist(npcindex).hostile))
call writevar(npcfile, "npc" & npcnumero, "giveexp", val(npclist(npcindex).giveexp))
call writevar(npcfile, "npc" & npcnumero, "givegld", val(npclist(npcindex).givegld))
call writevar(npcfile, "npc" & npcnumero, "hostil", val(npclist(npcindex).hostile))
call writevar(npcfile, "npc" & npcnumero, "inflacion", val(npclist(npcindex).inflacion))
call writevar(npcfile, "npc" & npcnumero, "invrespawn", val(npclist(npcindex).invrespawn))
call writevar(npcfile, "npc" & npcnumero, "npctype", val(npclist(npcindex).npctype))


'stats
call writevar(npcfile, "npc" & npcnumero, "alineacion", val(npclist(npcindex).stats.alineacion))
call writevar(npcfile, "npc" & npcnumero, "def", val(npclist(npcindex).stats.def))
call writevar(npcfile, "npc" & npcnumero, "maxhit", val(npclist(npcindex).stats.maxhit))
call writevar(npcfile, "npc" & npcnumero, "maxhp", val(npclist(npcindex).stats.maxhp))
call writevar(npcfile, "npc" & npcnumero, "minhit", val(npclist(npcindex).stats.minhit))
call writevar(npcfile, "npc" & npcnumero, "minhp", val(npclist(npcindex).stats.minhp))
call writevar(npcfile, "npc" & npcnumero, "def", val(npclist(npcindex).stats.usuariosmatados))




'flags
call writevar(npcfile, "npc" & npcnumero, "respawn", val(npclist(npcindex).flags.respawn))
call writevar(npcfile, "npc" & npcnumero, "backup", val(npclist(npcindex).flags.backup))
call writevar(npcfile, "npc" & npcnumero, "domable", val(npclist(npcindex).flags.domable))

'inventario
call writevar(npcfile, "npc" & npcnumero, "nroitems", val(npclist(npcindex).invent.nroitems))
if npclist(npcindex).invent.nroitems > 0 then
   for loopc = 1 to max_inventory_slots
        call writevar(npcfile, "npc" & npcnumero, "obj" & loopc, npclist(npcindex).invent.object(loopc).objindex & "-" & npclist(npcindex).invent.object(loopc).amount)
   next
end if


end sub



sub cargarnpcbackup(npcindex as integer, byval npcnumber as integer)

'call logtarea("sub cargarnpcbackup npcindex:" & npcindex & " npcnumber:" & npcnumber)

'status
if frmmain.visible then frmmain.txstatus.caption = "cargando backup npc"


dim npcfile as string

if npcnumber > 499 then
        npcfile = datpath & "bknpcs-hostiles.dat"
else
        npcfile = datpath & "bknpcs.dat"
end if

npclist(npcindex).numero = npcnumber
npclist(npcindex).name = getvar(npcfile, "npc" & npcnumber, "name")
npclist(npcindex).desc = getvar(npcfile, "npc" & npcnumber, "desc")
npclist(npcindex).movement = val(getvar(npcfile, "npc" & npcnumber, "movement"))
npclist(npcindex).npctype = val(getvar(npcfile, "npc" & npcnumber, "npctype"))

npclist(npcindex).char.body = val(getvar(npcfile, "npc" & npcnumber, "body"))
npclist(npcindex).char.head = val(getvar(npcfile, "npc" & npcnumber, "head"))
npclist(npcindex).char.heading = val(getvar(npcfile, "npc" & npcnumber, "heading"))

npclist(npcindex).attackable = val(getvar(npcfile, "npc" & npcnumber, "attackable"))
npclist(npcindex).comercia = val(getvar(npcfile, "npc" & npcnumber, "comercia"))
npclist(npcindex).hostile = val(getvar(npcfile, "npc" & npcnumber, "hostile"))
npclist(npcindex).giveexp = val(getvar(npcfile, "npc" & npcnumber, "giveexp"))


npclist(npcindex).givegld = val(getvar(npcfile, "npc" & npcnumber, "givegld"))

npclist(npcindex).invrespawn = val(getvar(npcfile, "npc" & npcnumber, "invrespawn"))

npclist(npcindex).stats.maxhp = val(getvar(npcfile, "npc" & npcnumber, "maxhp"))
npclist(npcindex).stats.minhp = val(getvar(npcfile, "npc" & npcnumber, "minhp"))
npclist(npcindex).stats.maxhit = val(getvar(npcfile, "npc" & npcnumber, "maxhit"))
npclist(npcindex).stats.minhit = val(getvar(npcfile, "npc" & npcnumber, "minhit"))
npclist(npcindex).stats.def = val(getvar(npcfile, "npc" & npcnumber, "def"))
npclist(npcindex).stats.alineacion = val(getvar(npcfile, "npc" & npcnumber, "alineacion"))
npclist(npcindex).stats.impactrate = val(getvar(npcfile, "npc" & npcnumber, "impactrate"))


dim loopc as integer
dim ln as string
npclist(npcindex).invent.nroitems = val(getvar(npcfile, "npc" & npcnumber, "nroitems"))
if npclist(npcindex).invent.nroitems > 0 then
    for loopc = 1 to max_inventory_slots
        ln = getvar(npcfile, "npc" & npcnumber, "obj" & loopc)
        npclist(npcindex).invent.object(loopc).objindex = val(readfield(1, ln, 45))
        npclist(npcindex).invent.object(loopc).amount = val(readfield(2, ln, 45))
       
    next loopc
else
    for loopc = 1 to max_inventory_slots
        npclist(npcindex).invent.object(loopc).objindex = 0
        npclist(npcindex).invent.object(loopc).amount = 0
    next loopc
end if

npclist(npcindex).inflacion = val(getvar(npcfile, "npc" & npcnumber, "inflacion"))


npclist(npcindex).flags.npcactive = true
npclist(npcindex).flags.useainow = false
npclist(npcindex).flags.respawn = val(getvar(npcfile, "npc" & npcnumber, "respawn"))
npclist(npcindex).flags.backup = val(getvar(npcfile, "npc" & npcnumber, "backup"))
npclist(npcindex).flags.domable = val(getvar(npcfile, "npc" & npcnumber, "domable"))
npclist(npcindex).flags.respawnorigpos = val(getvar(npcfile, "npc" & npcnumber, "origpos"))

'tipo de items con los que comercia
npclist(npcindex).tipoitems = val(getvar(npcfile, "npc" & npcnumber, "tipoitems"))

end sub


sub logban(byval bannedindex as integer, byval userindex as integer, byval motivo as string)

call writevar(app.path & "\logs\" & "bandetail.dat", userlist(bannedindex).name, "bannedby", userlist(userindex).name)
call writevar(app.path & "\logs\" & "bandetail.dat", userlist(bannedindex).name, "reason", motivo)

'log interno del servidor, lo usa para hacer un unban general de toda la gente banned
dim mifile as integer
mifile = freefile
open app.path & "\logs\gentebanned.log" for append shared as #mifile
print #mifile, userlist(bannedindex).name
close #mifile

end sub



public sub cargarunmapa(map as integer, archmap as string, archinf as string)
dim dm as long
dim tm as tilemap, ti as tileinf
dim x as integer, y as integer
dim loopc as integer
dim npcfile as string

    dm = mapcargamapa(archmap, archinf)
    if dm = 0 then
        debug.print "kk " & map
    end if
    
    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            call mapleemapa(dm, tm, ti)
            
            '.dat file
            'get #1, , mapdata(map, x, y).blocked
            mapdata(map, x, y).blocked = tm.bloqueado
            
'            for loopc = 1 to 4
'                'get #1, , mapdata(map, x, y).graphic(loopc)
'                mapdata(map, x, y).graphic(loopc) = tm.grafs(loopc)
'                if tm.grafs(loopc) <> 0 then
'                    tm.grafs(loopc) = tm.grafs(loopc)
'                end if
'            next loopc
            mapdata(map, x, y).graphic(1) = tm.grafs1
            mapdata(map, x, y).graphic(2) = tm.grafs2
            mapdata(map, x, y).graphic(3) = tm.grafs3
            mapdata(map, x, y).graphic(4) = tm.grafs4
            
            'get #1, , mapdata(map, x, y).trigger
            'get #1, , tempint
            mapdata(map, x, y).trigger = tm.trigger
            if tm.trigger <> 0 then
                tm.trigger = tm.trigger
            end if
            
            '.inf file
            'get #2, , mapdata(map, x, y).tileexit.map
            'get #2, , mapdata(map, x, y).tileexit.x
            'get #2, , mapdata(map, x, y).tileexit.y
            
            mapdata(map, x, y).tileexit.map = ti.dest_mapa
            mapdata(map, x, y).tileexit.x = ti.dest_x
            mapdata(map, x, y).tileexit.y = ti.dest_y
            
            'get and make npc
            'get #2, , mapdata(map, x, y).npcindex
            mapdata(map, x, y).npcindex = ti.npc
            
            if mapdata(map, x, y).npcindex > 0 then
                
                if mapdata(map, x, y).npcindex > 499 then
                        npcfile = datpath & "npcs-hostiles.dat"
                else
                        npcfile = datpath & "npcs.dat"
                end if
                
                'si el npc debe hacer respawn en la pos
                'original la guardamos
                if val(getvar(npcfile, "npc" & mapdata(map, x, y).npcindex, "posorig")) = 1 then
                    mapdata(map, x, y).npcindex = opennpc(mapdata(map, x, y).npcindex)
                    npclist(mapdata(map, x, y).npcindex).orig.map = map
                    npclist(mapdata(map, x, y).npcindex).orig.x = x
                    npclist(mapdata(map, x, y).npcindex).orig.y = y
                else
                    mapdata(map, x, y).npcindex = opennpc(mapdata(map, x, y).npcindex)
                end if
                
                npclist(mapdata(map, x, y).npcindex).pos.map = map
                npclist(mapdata(map, x, y).npcindex).pos.x = x
                npclist(mapdata(map, x, y).npcindex).pos.y = y
                
                call makenpcchar(tonone, 0, 0, mapdata(map, x, y).npcindex, map, x, y)
            end if

            'get and make object
            'get #2, , mapdata(map, x, y).objinfo.objindex
            'get #2, , mapdata(map, x, y).objinfo.amount
            mapdata(map, x, y).objinfo.objindex = ti.obj_ind
            mapdata(map, x, y).objinfo.amount = ti.obj_cant
            
            'space holder for future expansion (objects, ect.
            'get #2, , dummyint
            'get #2, , dummyint
        
        next x
    next y

    call mapcierramapa(dm)
    ''close #1
    ''close #2

  
    mapinfo(map).name = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "name")
    mapinfo(map).music = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "musicnum")
    mapinfo(map).startpos.map = val(readfield(1, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    mapinfo(map).startpos.x = val(readfield(2, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    mapinfo(map).startpos.y = val(readfield(3, getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "startpos"), 45))
    
    if val(getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "pk")) = 0 then
        mapinfo(map).pk = true
    else
        mapinfo(map).pk = false
    end if
    
    
    mapinfo(map).terreno = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "terreno")

    mapinfo(map).zona = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "zona")
    
    mapinfo(map).restringir = getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "restringir")
    
    mapinfo(map).backup = val(getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "backup"))

end sub
