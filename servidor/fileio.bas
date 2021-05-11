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

function esadmin(byval name as string) as boolean
dim numwizs as integer
dim wiznum as integer
dim nomb as string

numwizs = val(getvar(inipath & "server.ini", "init", "admines"))

for wiznum = 1 to numwizs
    nomb = ucase$(getvar(inipath & "server.ini", "admines", "admin" & wiznum))
    if left(nomb, 1) = "*" or left(nomb, 1) = "+" then nomb = right(nomb, len(nomb) - 1)
    if ucase$(name) = nomb then
        esadmin = true
        exit function
    end if
next wiznum
esadmin = false

end function

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

function esrolesmaster(byval name as string) as boolean
dim numwizs as integer
dim wiznum as integer
dim nomb as string

numwizs = val(getvar(inipath & "server.ini", "init", "rolesmasters"))
for wiznum = 1 to numwizs
    nomb = ucase$(getvar(inipath & "server.ini", "rolesmasters", "rm" & wiznum))
    if left(nomb, 1) = "*" or left(nomb, 1) = "+" then nomb = right(nomb, len(nomb) - 1)
    if ucase$(name) = nomb then
        esrolesmaster = true
        exit function
    end if
next wiznum
esrolesmaster = false
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

'###################################################
'#               atencion peligro                  #
'###################################################
'
'  ���� no usar getvar para leer hechizos.dat !!!!
'
'el que ose desafiar esta ley, se las tendr� que ver
'con migo. para leer hechizos.dat se deber� usar
'la nueva clase clsleerinis.
'
'alejo
'
'###################################################

on error goto errhandler

if frmmain.visible then frmmain.txstatus.caption = "cargando hechizos."

dim hechizo as integer
dim leer as new clsinireader

call leer.initialize(datpath & "hechizos.dat")

'obtiene el numero de hechizos
numerohechizos = val(leer.getvalue("init", "numerohechizos"))
redim hechizos(1 to numerohechizos) as thechizo

frmcargando.cargar.min = 0
frmcargando.cargar.max = numerohechizos
frmcargando.cargar.value = 0

'llena la lista
for hechizo = 1 to numerohechizos

    hechizos(hechizo).nombre = leer.getvalue("hechizo" & hechizo, "nombre")
    hechizos(hechizo).desc = leer.getvalue("hechizo" & hechizo, "desc")
    hechizos(hechizo).palabrasmagicas = leer.getvalue("hechizo" & hechizo, "palabrasmagicas")
    
    hechizos(hechizo).hechizeromsg = leer.getvalue("hechizo" & hechizo, "hechizeromsg")
    hechizos(hechizo).targetmsg = leer.getvalue("hechizo" & hechizo, "targetmsg")
    hechizos(hechizo).propiomsg = leer.getvalue("hechizo" & hechizo, "propiomsg")
    
    hechizos(hechizo).tipo = val(leer.getvalue("hechizo" & hechizo, "tipo"))
    hechizos(hechizo).wav = val(leer.getvalue("hechizo" & hechizo, "wav"))
    hechizos(hechizo).fxgrh = val(leer.getvalue("hechizo" & hechizo, "fxgrh"))
    
    hechizos(hechizo).loops = val(leer.getvalue("hechizo" & hechizo, "loops"))
    
    hechizos(hechizo).resis = val(leer.getvalue("hechizo" & hechizo, "resis"))
    
    hechizos(hechizo).subehp = val(leer.getvalue("hechizo" & hechizo, "subehp"))
    hechizos(hechizo).minhp = val(leer.getvalue("hechizo" & hechizo, "minhp"))
    hechizos(hechizo).maxhp = val(leer.getvalue("hechizo" & hechizo, "maxhp"))
    
    hechizos(hechizo).subemana = val(leer.getvalue("hechizo" & hechizo, "subemana"))
    hechizos(hechizo).mimana = val(leer.getvalue("hechizo" & hechizo, "minmana"))
    hechizos(hechizo).mamana = val(leer.getvalue("hechizo" & hechizo, "maxmana"))
    
    hechizos(hechizo).subesta = val(leer.getvalue("hechizo" & hechizo, "subesta"))
    hechizos(hechizo).minsta = val(leer.getvalue("hechizo" & hechizo, "minsta"))
    hechizos(hechizo).maxsta = val(leer.getvalue("hechizo" & hechizo, "maxsta"))
    
    hechizos(hechizo).subeham = val(leer.getvalue("hechizo" & hechizo, "subeham"))
    hechizos(hechizo).minham = val(leer.getvalue("hechizo" & hechizo, "minham"))
    hechizos(hechizo).maxham = val(leer.getvalue("hechizo" & hechizo, "maxham"))
    
    hechizos(hechizo).subesed = val(leer.getvalue("hechizo" & hechizo, "subesed"))
    hechizos(hechizo).minsed = val(leer.getvalue("hechizo" & hechizo, "minsed"))
    hechizos(hechizo).maxsed = val(leer.getvalue("hechizo" & hechizo, "maxsed"))
    
    hechizos(hechizo).subeagilidad = val(leer.getvalue("hechizo" & hechizo, "subeag"))
    hechizos(hechizo).minagilidad = val(leer.getvalue("hechizo" & hechizo, "minag"))
    hechizos(hechizo).maxagilidad = val(leer.getvalue("hechizo" & hechizo, "maxag"))
    
    hechizos(hechizo).subefuerza = val(leer.getvalue("hechizo" & hechizo, "subefu"))
    hechizos(hechizo).minfuerza = val(leer.getvalue("hechizo" & hechizo, "minfu"))
    hechizos(hechizo).maxfuerza = val(leer.getvalue("hechizo" & hechizo, "maxfu"))
    
    hechizos(hechizo).subecarisma = val(leer.getvalue("hechizo" & hechizo, "subeca"))
    hechizos(hechizo).mincarisma = val(leer.getvalue("hechizo" & hechizo, "minca"))
    hechizos(hechizo).maxcarisma = val(leer.getvalue("hechizo" & hechizo, "maxca"))
    
    
    hechizos(hechizo).invisibilidad = val(leer.getvalue("hechizo" & hechizo, "invisibilidad"))
    hechizos(hechizo).paraliza = val(leer.getvalue("hechizo" & hechizo, "paraliza"))
    hechizos(hechizo).inmoviliza = val(leer.getvalue("hechizo" & hechizo, "inmoviliza"))
    hechizos(hechizo).removerparalisis = val(leer.getvalue("hechizo" & hechizo, "removerparalisis"))
    hechizos(hechizo).removerestupidez = val(leer.getvalue("hechizo" & hechizo, "removerestupidez"))
    hechizos(hechizo).removerestupidez = val(leer.getvalue("hechizo" & hechizo, "removerestupidez"))
    hechizos(hechizo).remueveinvisibilidadparcial = val(leer.getvalue("hechizo" & hechizo, "remueveinvisibilidadparcial"))
    
    
    hechizos(hechizo).curaveneno = val(leer.getvalue("hechizo" & hechizo, "curaveneno"))
    hechizos(hechizo).envenena = val(leer.getvalue("hechizo" & hechizo, "envenena"))
    hechizos(hechizo).maldicion = val(leer.getvalue("hechizo" & hechizo, "maldicion"))
    hechizos(hechizo).removermaldicion = val(leer.getvalue("hechizo" & hechizo, "removermaldicion"))
    hechizos(hechizo).bendicion = val(leer.getvalue("hechizo" & hechizo, "bendicion"))
    hechizos(hechizo).revivir = val(leer.getvalue("hechizo" & hechizo, "revivir"))
    
    hechizos(hechizo).ceguera = val(leer.getvalue("hechizo" & hechizo, "ceguera"))
    hechizos(hechizo).estupidez = val(leer.getvalue("hechizo" & hechizo, "estupidez"))
    
    hechizos(hechizo).invoca = val(leer.getvalue("hechizo" & hechizo, "invoca"))
    hechizos(hechizo).numnpc = val(leer.getvalue("hechizo" & hechizo, "numnpc"))
    hechizos(hechizo).cant = val(leer.getvalue("hechizo" & hechizo, "cant"))
    hechizos(hechizo).mimetiza = val(leer.getvalue("hechizo" & hechizo, "mimetiza"))
    
    
    hechizos(hechizo).materializa = val(leer.getvalue("hechizo" & hechizo, "materializa"))
    hechizos(hechizo).itemindex = val(leer.getvalue("hechizo" & hechizo, "itemindex"))
    
    hechizos(hechizo).minskill = val(leer.getvalue("hechizo" & hechizo, "minskill"))
    hechizos(hechizo).manarequerido = val(leer.getvalue("hechizo" & hechizo, "manarequerido"))
    
    'barrin 30/9/03
    hechizos(hechizo).starequerido = val(leer.getvalue("hechizo" & hechizo, "starequerido"))
    
    hechizos(hechizo).target = val(leer.getvalue("hechizo" & hechizo, "target"))
    frmcargando.cargar.value = frmcargando.cargar.value + 1
    
    hechizos(hechizo).needstaff = val(leer.getvalue("hechizo" & hechizo, "needstaff"))
    hechizos(hechizo).staffaffected = cbool(val(leer.getvalue("hechizo" & hechizo, "staffaffected")))
    
next hechizo

set leer = nothing
exit sub

errhandler:
 msgbox "error cargando hechizos.dat " & err.number & ": " & err.description
 
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
dim i as integer



' lo saco porque elimina elementales y mascotas - maraxus
''''''''''''''lo pongo aca x sugernecia del yind
'for i = 1 to lastnpc
'    if npclist(i).flags.npcactive then
'        if npclist(i).contadores.tiempoexistencia > 0 then
'            call muerenpc(i, 0)
'        end if
'    end if
'next i
'''''''''''/'lo pongo aca x sugernecia del yind



call senddata(sendtarget.toall, 0, 0, "bkw")


call limpiarmundo
call worldsave
call modguilds.v_rutinaelecciones
call resetcentinelainfo     'reseteamos al centinela


call senddata(sendtarget.toall, 0, 0, "bkw")

'call estadisticasweb.informar(evento_nuevo_clan, 0)

haciendobk = false

'log
on error resume next
dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\backups.log" for append shared as #nfile
print #nfile, date & " " & time
close #nfile
end sub

public sub grabarmapa(byval map as long, byval mapfile as string)
on error resume next
    dim freefilemap as long
    dim freefileinf as long
    dim y as long
    dim x as long
    dim byflags as byte
    dim tempint as integer
    dim loopc as long
    
    if fileexist(mapfile & ".map", vbnormal) then
        kill mapfile & ".map"
    end if
    
    if fileexist(mapfile & ".inf", vbnormal) then
        kill mapfile & ".inf"
    end if
    
    'open .map file
    freefilemap = freefile
    open mapfile & ".map" for binary as freefilemap
    seek freefilemap, 1
    
    'open .inf file
    freefileinf = freefile
    open mapfile & ".inf" for binary as freefileinf
    seek freefileinf, 1
    'map header
            
    put freefilemap, , mapinfo(map).mapversion
    put freefilemap, , micabecera
    put freefilemap, , tempint
    put freefilemap, , tempint
    put freefilemap, , tempint
    put freefilemap, , tempint
    
    'inf header
    put freefileinf, , tempint
    put freefileinf, , tempint
    put freefileinf, , tempint
    put freefileinf, , tempint
    put freefileinf, , tempint
    
    'write .map file
    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            
                byflags = 0
                
                if mapdata(map, x, y).blocked then byflags = byflags or 1
                if mapdata(map, x, y).graphic(2) then byflags = byflags or 2
                if mapdata(map, x, y).graphic(3) then byflags = byflags or 4
                if mapdata(map, x, y).graphic(4) then byflags = byflags or 8
                if mapdata(map, x, y).trigger then byflags = byflags or 16
                
                put freefilemap, , byflags
                
                put freefilemap, , mapdata(map, x, y).graphic(1)
                
                for loopc = 2 to 4
                    if mapdata(map, x, y).graphic(loopc) then _
                        put freefilemap, , mapdata(map, x, y).graphic(loopc)
                next loopc
                
                if mapdata(map, x, y).trigger then _
                    put freefilemap, , cint(mapdata(map, x, y).trigger)
                
                '.inf file
                
                byflags = 0
                
                if mapdata(map, x, y).objinfo.objindex > 0 then
                   if objdata(mapdata(map, x, y).objinfo.objindex).objtype = eobjtype.otfogata then
                        mapdata(map, x, y).objinfo.objindex = 0
                        mapdata(map, x, y).objinfo.amount = 0
                    end if
                end if
    
                if mapdata(map, x, y).tileexit.map then byflags = byflags or 1
                if mapdata(map, x, y).npcindex then byflags = byflags or 2
                if mapdata(map, x, y).objinfo.objindex then byflags = byflags or 4
                
                put freefileinf, , byflags
                
                if mapdata(map, x, y).tileexit.map then
                    put freefileinf, , mapdata(map, x, y).tileexit.map
                    put freefileinf, , mapdata(map, x, y).tileexit.x
                    put freefileinf, , mapdata(map, x, y).tileexit.y
                end if
                
                if mapdata(map, x, y).npcindex then _
                    put freefileinf, , npclist(mapdata(map, x, y).npcindex).numero
                
                if mapdata(map, x, y).objinfo.objindex then
                    put freefileinf, , mapdata(map, x, y).objinfo.objindex
                    put freefileinf, , mapdata(map, x, y).objinfo.amount
                end if
            
            
        next x
    next y
    
    'close .map file
    close freefilemap

    'close .inf file
    close freefileinf

    'write .dat file
    call writevar(mapfile & ".dat", "mapa" & map, "name", mapinfo(map).name)
    call writevar(mapfile & ".dat", "mapa" & map, "musicnum", mapinfo(map).music)
    call writevar(mapfile & ".dat", "mapa" & map, "magiasinefecto", mapinfo(map).magiasinefecto)
    call writevar(mapfile & ".dat", "mapa" & map, "startpos", mapinfo(map).startpos.map & "-" & mapinfo(map).startpos.x & "-" & mapinfo(map).startpos.y)

    call writevar(mapfile & ".dat", "mapa" & map, "terreno", mapinfo(map).terreno)
    call writevar(mapfile & ".dat", "mapa" & map, "zona", mapinfo(map).zona)
    call writevar(mapfile & ".dat", "mapa" & map, "restringir", mapinfo(map).restringir)
    call writevar(mapfile & ".dat", "mapa" & map, "backup", str(mapinfo(map).backup))

    if mapinfo(map).pk then
        call writevar(mapfile & ".dat", "mapa" & map, "pk", "0")
    else
        call writevar(mapfile & ".dat", "mapa" & map, "pk", "1")
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

'###################################################
'#               atencion peligro                  #
'###################################################
'
'���� no usar getvar para leer desde el obj.dat !!!!
'
'el que ose desafiar esta ley, se las tendr� que ver
'con migo. para leer desde el obj.dat se deber� usar
'la nueva clase clsleerinis.
'
'alejo
'
'###################################################

'call logtarea("sub loadobjdata")

on error goto errhandler

if frmmain.visible then frmmain.txstatus.caption = "cargando base de datos de los objetos."

'*****************************************************************
'carga la lista de objetos
'*****************************************************************
dim object as integer
dim leer as new clsinireader

call leer.initialize(datpath & "obj.dat")

'obtiene el numero de obj
numobjdatas = val(leer.getvalue("init", "numobjs"))

frmcargando.cargar.min = 0
frmcargando.cargar.max = numobjdatas
frmcargando.cargar.value = 0


redim preserve objdata(1 to numobjdatas) as objdata
  
'llena la lista
for object = 1 to numobjdatas
        
    objdata(object).name = leer.getvalue("obj" & object, "name")
    
    objdata(object).grhindex = val(leer.getvalue("obj" & object, "grhindex"))
    if objdata(object).grhindex = 0 then
        objdata(object).grhindex = objdata(object).grhindex
    end if
    
    objdata(object).objtype = val(leer.getvalue("obj" & object, "objtype"))
    
    objdata(object).newbie = val(leer.getvalue("obj" & object, "newbie"))
    
    select case objdata(object).objtype
        case eobjtype.otarmadura
            objdata(object).real = val(leer.getvalue("obj" & object, "real"))
            objdata(object).caos = val(leer.getvalue("obj" & object, "caos"))
            objdata(object).lingh = val(leer.getvalue("obj" & object, "lingh"))
            objdata(object).lingp = val(leer.getvalue("obj" & object, "lingp"))
            objdata(object).lingo = val(leer.getvalue("obj" & object, "lingo"))
            objdata(object).skherreria = val(leer.getvalue("obj" & object, "skherreria"))
        
        case eobjtype.otescudo
            objdata(object).shieldanim = val(leer.getvalue("obj" & object, "anim"))
            objdata(object).lingh = val(leer.getvalue("obj" & object, "lingh"))
            objdata(object).lingp = val(leer.getvalue("obj" & object, "lingp"))
            objdata(object).lingo = val(leer.getvalue("obj" & object, "lingo"))
            objdata(object).skherreria = val(leer.getvalue("obj" & object, "skherreria"))
            objdata(object).real = val(leer.getvalue("obj" & object, "real"))
            objdata(object).caos = val(leer.getvalue("obj" & object, "caos"))
        
        case eobjtype.otcasco
            objdata(object).cascoanim = val(leer.getvalue("obj" & object, "anim"))
            objdata(object).lingh = val(leer.getvalue("obj" & object, "lingh"))
            objdata(object).lingp = val(leer.getvalue("obj" & object, "lingp"))
            objdata(object).lingo = val(leer.getvalue("obj" & object, "lingo"))
            objdata(object).skherreria = val(leer.getvalue("obj" & object, "skherreria"))
            objdata(object).real = val(leer.getvalue("obj" & object, "real"))
            objdata(object).caos = val(leer.getvalue("obj" & object, "caos"))
        
        case eobjtype.otweapon
            objdata(object).weaponanim = val(leer.getvalue("obj" & object, "anim"))
            objdata(object).apu�ala = val(leer.getvalue("obj" & object, "apu�ala"))
            objdata(object).envenena = val(leer.getvalue("obj" & object, "envenena"))
            objdata(object).maxhit = val(leer.getvalue("obj" & object, "maxhit"))
            objdata(object).minhit = val(leer.getvalue("obj" & object, "minhit"))
            objdata(object).proyectil = val(leer.getvalue("obj" & object, "proyectil"))
            objdata(object).municion = val(leer.getvalue("obj" & object, "municiones"))
            objdata(object).staffpower = val(leer.getvalue("obj" & object, "staffpower"))
            objdata(object).staffdamagebonus = val(leer.getvalue("obj" & object, "staffdamagebonus"))
            objdata(object).refuerzo = val(leer.getvalue("obj" & object, "refuerzo"))
            
            objdata(object).lingh = val(leer.getvalue("obj" & object, "lingh"))
            objdata(object).lingp = val(leer.getvalue("obj" & object, "lingp"))
            objdata(object).lingo = val(leer.getvalue("obj" & object, "lingo"))
            objdata(object).skherreria = val(leer.getvalue("obj" & object, "skherreria"))
            objdata(object).real = val(leer.getvalue("obj" & object, "real"))
            objdata(object).caos = val(leer.getvalue("obj" & object, "caos"))
        
        case eobjtype.otherramientas
            objdata(object).lingh = val(leer.getvalue("obj" & object, "lingh"))
            objdata(object).lingp = val(leer.getvalue("obj" & object, "lingp"))
            objdata(object).lingo = val(leer.getvalue("obj" & object, "lingo"))
            objdata(object).skherreria = val(leer.getvalue("obj" & object, "skherreria"))
        
        case eobjtype.otinstrumentos
            objdata(object).snd1 = val(leer.getvalue("obj" & object, "snd1"))
            objdata(object).snd2 = val(leer.getvalue("obj" & object, "snd2"))
            objdata(object).snd3 = val(leer.getvalue("obj" & object, "snd3"))
        
        case eobjtype.otminerales
            objdata(object).minskill = val(leer.getvalue("obj" & object, "minskill"))
        
        case eobjtype.otpuertas, eobjtype.otbotellavacia, eobjtype.otbotellallena
            objdata(object).indexabierta = val(leer.getvalue("obj" & object, "indexabierta"))
            objdata(object).indexcerrada = val(leer.getvalue("obj" & object, "indexcerrada"))
            objdata(object).indexcerradallave = val(leer.getvalue("obj" & object, "indexcerradallave"))
        
        case otpociones
            objdata(object).tipopocion = val(leer.getvalue("obj" & object, "tipopocion"))
            objdata(object).maxmodificador = val(leer.getvalue("obj" & object, "maxmodificador"))
            objdata(object).minmodificador = val(leer.getvalue("obj" & object, "minmodificador"))
            objdata(object).duracionefecto = val(leer.getvalue("obj" & object, "duracionefecto"))
        
        case eobjtype.otbarcos
            objdata(object).minskill = val(leer.getvalue("obj" & object, "minskill"))
            objdata(object).maxhit = val(leer.getvalue("obj" & object, "maxhit"))
            objdata(object).minhit = val(leer.getvalue("obj" & object, "minhit"))
        
        case eobjtype.otflechas
            objdata(object).maxhit = val(leer.getvalue("obj" & object, "maxhit"))
            objdata(object).minhit = val(leer.getvalue("obj" & object, "minhit"))
            objdata(object).envenena = val(leer.getvalue("obj" & object, "envenena"))
            objdata(object).paraliza = val(leer.getvalue("obj" & object, "paraliza"))
    end select
    
    objdata(object).ropaje = val(leer.getvalue("obj" & object, "numropaje"))
    objdata(object).hechizoindex = val(leer.getvalue("obj" & object, "hechizoindex"))
    
    objdata(object).lingoteindex = val(leer.getvalue("obj" & object, "lingoteindex"))
    
    objdata(object).mineralindex = val(leer.getvalue("obj" & object, "mineralindex"))
    
    objdata(object).maxhp = val(leer.getvalue("obj" & object, "maxhp"))
    objdata(object).minhp = val(leer.getvalue("obj" & object, "minhp"))
    
    objdata(object).mujer = val(leer.getvalue("obj" & object, "mujer"))
    objdata(object).hombre = val(leer.getvalue("obj" & object, "hombre"))
    
    objdata(object).minham = val(leer.getvalue("obj" & object, "minham"))
    objdata(object).minsed = val(leer.getvalue("obj" & object, "minagu"))
    
    objdata(object).mindef = val(leer.getvalue("obj" & object, "mindef"))
    objdata(object).maxdef = val(leer.getvalue("obj" & object, "maxdef"))
    
    objdata(object).razaenana = val(leer.getvalue("obj" & object, "razaenana"))
    
    objdata(object).valor = val(leer.getvalue("obj" & object, "valor"))
    
    objdata(object).crucial = val(leer.getvalue("obj" & object, "crucial"))
    
    objdata(object).cerrada = val(leer.getvalue("obj" & object, "abierta"))
    if objdata(object).cerrada = 1 then
        objdata(object).llave = val(leer.getvalue("obj" & object, "llave"))
        objdata(object).clave = val(leer.getvalue("obj" & object, "clave"))
    end if
    
    'puertas y llaves
    objdata(object).clave = val(leer.getvalue("obj" & object, "clave"))
    
    objdata(object).texto = leer.getvalue("obj" & object, "texto")
    objdata(object).grhsecundario = val(leer.getvalue("obj" & object, "vgrande"))
    
    objdata(object).agarrable = val(leer.getvalue("obj" & object, "agarrable"))
    objdata(object).foroid = leer.getvalue("obj" & object, "id")
    
    dim i as integer
    for i = 1 to numclases
        objdata(object).claseprohibida(i) = leer.getvalue("obj" & object, "cp" & i)
    next i
    
    objdata(object).defensamagicamax = val(leer.getvalue("obj" & object, "defensamagicamax"))
    objdata(object).defensamagicamin = val(leer.getvalue("obj" & object, "defensamagicamin"))
    
    objdata(object).skcarpinteria = val(leer.getvalue("obj" & object, "skcarpinteria"))
    
    if objdata(object).skcarpinteria > 0 then _
        objdata(object).madera = val(leer.getvalue("obj" & object, "madera"))
    
    'bebidas
    objdata(object).minsta = val(leer.getvalue("obj" & object, "minst"))
    
    objdata(object).nosecae = val(leer.getvalue("obj" & object, "nosecae"))
    
    frmcargando.cargar.value = frmcargando.cargar.value + 1
next object

set leer = nothing

exit sub

errhandler:
    msgbox "error cargando objetos " & err.number & ": " & err.description


end sub

sub loaduserstats(byval userindex as integer, byref userfile as clsinireader)

dim loopc as integer


for loopc = 1 to numatributos
  userlist(userindex).stats.useratributos(loopc) = cint(userfile.getvalue("atributos", "at" & loopc))
  userlist(userindex).stats.useratributosbackup(loopc) = userlist(userindex).stats.useratributos(loopc)
next loopc

for loopc = 1 to numskills
  userlist(userindex).stats.userskills(loopc) = cint(userfile.getvalue("skills", "sk" & loopc))
next loopc

for loopc = 1 to maxuserhechizos
  userlist(userindex).stats.userhechizos(loopc) = cint(userfile.getvalue("hechizos", "h" & loopc))
next loopc

userlist(userindex).stats.gld = clng(userfile.getvalue("stats", "gld"))
userlist(userindex).stats.banco = clng(userfile.getvalue("stats", "banco"))

userlist(userindex).stats.met = cint(userfile.getvalue("stats", "met"))
userlist(userindex).stats.maxhp = cint(userfile.getvalue("stats", "maxhp"))
userlist(userindex).stats.minhp = cint(userfile.getvalue("stats", "minhp"))

userlist(userindex).stats.fit = cint(userfile.getvalue("stats", "fit"))
userlist(userindex).stats.minsta = cint(userfile.getvalue("stats", "minsta"))
userlist(userindex).stats.maxsta = cint(userfile.getvalue("stats", "maxsta"))

userlist(userindex).stats.maxman = cint(userfile.getvalue("stats", "maxman"))
userlist(userindex).stats.minman = cint(userfile.getvalue("stats", "minman"))

userlist(userindex).stats.maxhit = cint(userfile.getvalue("stats", "maxhit"))
userlist(userindex).stats.minhit = cint(userfile.getvalue("stats", "minhit"))

userlist(userindex).stats.maxagu = cint(userfile.getvalue("stats", "maxagu"))
userlist(userindex).stats.minagu = cint(userfile.getvalue("stats", "minagu"))

userlist(userindex).stats.maxham = cint(userfile.getvalue("stats", "maxham"))
userlist(userindex).stats.minham = cint(userfile.getvalue("stats", "minham"))

userlist(userindex).stats.skillpts = cint(userfile.getvalue("stats", "skillptslibres"))

userlist(userindex).stats.exp = cdbl(userfile.getvalue("stats", "exp"))
userlist(userindex).stats.elu = clng(userfile.getvalue("stats", "elu"))
userlist(userindex).stats.elv = clng(userfile.getvalue("stats", "elv"))


userlist(userindex).stats.usuariosmatados = cint(userfile.getvalue("muertes", "usermuertes"))
userlist(userindex).stats.criminalesmatados = cint(userfile.getvalue("muertes", "crimmuertes"))
userlist(userindex).stats.npcsmuertos = cint(userfile.getvalue("muertes", "npcsmuertes"))

userlist(userindex).flags.pertalcons = cbyte(userfile.getvalue("consejo", "pertenece"))
userlist(userindex).flags.pertalconscaos = cbyte(userfile.getvalue("consejo", "pertenececaos"))

end sub

sub loaduserreputacion(byval userindex as integer, byref userfile as clsinireader)

userlist(userindex).reputacion.asesinorep = cdbl(userfile.getvalue("rep", "asesino"))
userlist(userindex).reputacion.bandidorep = cdbl(userfile.getvalue("rep", "bandido"))
userlist(userindex).reputacion.burguesrep = cdbl(userfile.getvalue("rep", "burguesia"))
userlist(userindex).reputacion.ladronesrep = cdbl(userfile.getvalue("rep", "ladrones"))
userlist(userindex).reputacion.noblerep = cdbl(userfile.getvalue("rep", "nobles"))
userlist(userindex).reputacion.pleberep = cdbl(userfile.getvalue("rep", "plebe"))
userlist(userindex).reputacion.promedio = cdbl(userfile.getvalue("rep", "promedio"))

end sub

sub loaduserinit(byval userindex as integer, byref userfile as clsinireader)

dim loopc as long
dim ln as string

userlist(userindex).faccion.armadareal = cbyte(userfile.getvalue("facciones", "ejercitoreal"))
userlist(userindex).faccion.fuerzascaos = cbyte(userfile.getvalue("facciones", "ejercitocaos"))
userlist(userindex).faccion.ciudadanosmatados = cdbl(userfile.getvalue("facciones", "ciudmatados"))
userlist(userindex).faccion.criminalesmatados = cdbl(userfile.getvalue("facciones", "crimmatados"))
userlist(userindex).faccion.recibioarmaduracaos = cbyte(userfile.getvalue("facciones", "rarcaos"))
userlist(userindex).faccion.recibioarmadurareal = cbyte(userfile.getvalue("facciones", "rarreal"))
userlist(userindex).faccion.recibioexpinicialcaos = cbyte(userfile.getvalue("facciones", "rexcaos"))
userlist(userindex).faccion.recibioexpinicialreal = cbyte(userfile.getvalue("facciones", "rexreal"))
userlist(userindex).faccion.recompensascaos = clng(userfile.getvalue("facciones", "reccaos"))
userlist(userindex).faccion.recompensasreal = clng(userfile.getvalue("facciones", "recreal"))
userlist(userindex).faccion.reenlistadas = cbyte(userfile.getvalue("facciones", "reenlistadas"))

userlist(userindex).flags.muerto = cbyte(userfile.getvalue("flags", "muerto"))
userlist(userindex).flags.escondido = cbyte(userfile.getvalue("flags", "escondido"))

userlist(userindex).flags.hambre = cbyte(userfile.getvalue("flags", "hambre"))
userlist(userindex).flags.sed = cbyte(userfile.getvalue("flags", "sed"))
userlist(userindex).flags.desnudo = cbyte(userfile.getvalue("flags", "desnudo"))

userlist(userindex).flags.envenenado = cbyte(userfile.getvalue("flags", "envenenado"))
userlist(userindex).flags.paralizado = cbyte(userfile.getvalue("flags", "paralizado"))
if userlist(userindex).flags.paralizado = 1 then
    userlist(userindex).counters.paralisis = intervaloparalizado
end if
userlist(userindex).flags.navegando = cbyte(userfile.getvalue("flags", "navegando"))


userlist(userindex).counters.pena = clng(userfile.getvalue("counters", "pena"))

userlist(userindex).email = userfile.getvalue("contacto", "email")

userlist(userindex).genero = userfile.getvalue("init", "genero")
userlist(userindex).clase = userfile.getvalue("init", "clase")
userlist(userindex).raza = userfile.getvalue("init", "raza")
userlist(userindex).hogar = userfile.getvalue("init", "hogar")
userlist(userindex).char.heading = cint(userfile.getvalue("init", "heading"))


userlist(userindex).origchar.head = cint(userfile.getvalue("init", "head"))
userlist(userindex).origchar.body = cint(userfile.getvalue("init", "body"))
userlist(userindex).origchar.weaponanim = cint(userfile.getvalue("init", "arma"))
userlist(userindex).origchar.shieldanim = cint(userfile.getvalue("init", "escudo"))
userlist(userindex).origchar.cascoanim = cint(userfile.getvalue("init", "casco"))
userlist(userindex).origchar.heading = eheading.south

if userlist(userindex).flags.muerto = 0 then
    userlist(userindex).char = userlist(userindex).origchar
else
    userlist(userindex).char.body = icuerpomuerto
    userlist(userindex).char.head = icabezamuerto
    userlist(userindex).char.weaponanim = ningunarma
    userlist(userindex).char.shieldanim = ningunescudo
    userlist(userindex).char.cascoanim = ninguncasco
end if


userlist(userindex).desc = userfile.getvalue("init", "desc")


userlist(userindex).pos.map = cint(readfield(1, userfile.getvalue("init", "position"), 45))
userlist(userindex).pos.x = cint(readfield(2, userfile.getvalue("init", "position"), 45))
userlist(userindex).pos.y = cint(readfield(3, userfile.getvalue("init", "position"), 45))

userlist(userindex).invent.nroitems = cint(userfile.getvalue("inventory", "cantidaditems"))

'[kevin]--------------------------------------------------------------------
'***********************************************************************************
userlist(userindex).bancoinvent.nroitems = cint(userfile.getvalue("bancoinventory", "cantidaditems"))
'lista de objetos del banco
for loopc = 1 to max_bancoinventory_slots
    ln = userfile.getvalue("bancoinventory", "obj" & loopc)
    userlist(userindex).bancoinvent.object(loopc).objindex = cint(readfield(1, ln, 45))
    userlist(userindex).bancoinvent.object(loopc).amount = cint(readfield(2, ln, 45))
next loopc
'------------------------------------------------------------------------------------
'[/kevin]*****************************************************************************


'lista de objetos
for loopc = 1 to max_inventory_slots
    ln = userfile.getvalue("inventory", "obj" & loopc)
    userlist(userindex).invent.object(loopc).objindex = cint(readfield(1, ln, 45))
    userlist(userindex).invent.object(loopc).amount = cint(readfield(2, ln, 45))
    userlist(userindex).invent.object(loopc).equipped = cbyte(readfield(3, ln, 45))
next loopc

'obtiene el indice-objeto del arma
userlist(userindex).invent.weaponeqpslot = cbyte(userfile.getvalue("inventory", "weaponeqpslot"))
if userlist(userindex).invent.weaponeqpslot > 0 then
    userlist(userindex).invent.weaponeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.weaponeqpslot).objindex
end if

'obtiene el indice-objeto del armadura
userlist(userindex).invent.armoureqpslot = cbyte(userfile.getvalue("inventory", "armoureqpslot"))
if userlist(userindex).invent.armoureqpslot > 0 then
    userlist(userindex).invent.armoureqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.armoureqpslot).objindex
    userlist(userindex).flags.desnudo = 0
else
    userlist(userindex).flags.desnudo = 1
end if

'obtiene el indice-objeto del escudo
userlist(userindex).invent.escudoeqpslot = cbyte(userfile.getvalue("inventory", "escudoeqpslot"))
if userlist(userindex).invent.escudoeqpslot > 0 then
    userlist(userindex).invent.escudoeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.escudoeqpslot).objindex
end if

'obtiene el indice-objeto del casco
userlist(userindex).invent.cascoeqpslot = cbyte(userfile.getvalue("inventory", "cascoeqpslot"))
if userlist(userindex).invent.cascoeqpslot > 0 then
    userlist(userindex).invent.cascoeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.cascoeqpslot).objindex
end if

'obtiene el indice-objeto barco
userlist(userindex).invent.barcoslot = cbyte(userfile.getvalue("inventory", "barcoslot"))
if userlist(userindex).invent.barcoslot > 0 then
    userlist(userindex).invent.barcoobjindex = userlist(userindex).invent.object(userlist(userindex).invent.barcoslot).objindex
end if

'obtiene el indice-objeto municion
userlist(userindex).invent.municioneqpslot = cbyte(userfile.getvalue("inventory", "municionslot"))
if userlist(userindex).invent.municioneqpslot > 0 then
    userlist(userindex).invent.municioneqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.municioneqpslot).objindex
end if

'[alejo]
'obtiene el indice-objeto herramienta
userlist(userindex).invent.herramientaeqpslot = cint(userfile.getvalue("inventory", "herramientaslot"))
if userlist(userindex).invent.herramientaeqpslot > 0 then
    userlist(userindex).invent.herramientaeqpobjindex = userlist(userindex).invent.object(userlist(userindex).invent.herramientaeqpslot).objindex
end if

userlist(userindex).nromacotas = 0

ln = userfile.getvalue("guild", "guildindex")
if isnumeric(ln) then
    userlist(userindex).guildindex = cint(ln)
else
    userlist(userindex).guildindex = 0
end if

end sub

function getvar(byval file as string, byval main as string, byval var as string, optional emptyspaces as long = 1024) as string

dim sspaces as string ' this will hold the input that the program will retrieve
dim szreturn as string ' this will be the defaul value if the string is not found
  
szreturn = ""
  
sspaces = space$(emptyspaces) ' this tells the computer how long the longest string can be
  
  
getprivateprofilestring main, var, szreturn, sspaces, emptyspaces, file
  
getvar = rtrim$(sspaces)
getvar = left$(getvar, len(getvar) - 1)
  
end function

sub cargarbackup()

if frmmain.visible then frmmain.txstatus.caption = "cargando backup."

dim map as integer
dim tempint as integer
dim tfilename as string
dim npcfile as string

on error goto man
    
    nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))
    call initareas
    
    frmcargando.cargar.min = 0
    frmcargando.cargar.max = nummaps
    frmcargando.cargar.value = 0
    
    mappath = getvar(datpath & "map.dat", "init", "mappath")
    
    
    redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
    redim mapinfo(1 to nummaps) as mapinfo
      
    for map = 1 to nummaps
        
        if val(getvar(app.path & mappath & "mapa" & map & ".dat", "mapa" & map, "backup")) <> 0 then
            tfilename = app.path & "\worldbackup\mapa" & map
        else
            tfilename = app.path & mappath & "mapa" & map
        end if
        
        call cargarmapa(map, tfilename)
        
        frmcargando.cargar.value = frmcargando.cargar.value + 1
        doevents
    next map

exit sub

man:
    msgbox ("error durante la carga de mapas, el mapa " & map & " contiene errores")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)
 
end sub

sub loadmapdata()

if frmmain.visible then frmmain.txstatus.caption = "cargando mapas..."

dim map as integer
dim tempint as integer
dim tfilename as string
dim npcfile as string

on error goto man
    
    nummaps = val(getvar(datpath & "map.dat", "init", "nummaps"))
    call initareas
    
    frmcargando.cargar.min = 0
    frmcargando.cargar.max = nummaps
    frmcargando.cargar.value = 0
    
    mappath = getvar(datpath & "map.dat", "init", "mappath")
    
    
    redim mapdata(1 to nummaps, xminmapsize to xmaxmapsize, yminmapsize to ymaxmapsize) as mapblock
    redim mapinfo(1 to nummaps) as mapinfo
      
    for map = 1 to nummaps
        
        tfilename = app.path & mappath & "mapa" & map
        call cargarmapa(map, tfilename)
        
        frmcargando.cargar.value = frmcargando.cargar.value + 1
        doevents
    next map

exit sub

man:
    msgbox ("error durante la carga de mapas, el mapa " & map & " contiene errores")
    call logerror(date & " " & err.description & " " & err.helpcontext & " " & err.helpfile & " " & err.source)

end sub

public sub cargarmapa(byval map as long, byval mapfl as string)
on error goto errh
    dim freefilemap as long
    dim freefileinf as long
    dim y as long
    dim x as long
    dim byflags as byte
    dim npcfile as string
    dim tempint as integer
      
    freefilemap = freefile
    
    open mapfl & ".map" for binary as #freefilemap
    seek freefilemap, 1
    
    freefileinf = freefile
    
    'inf
    open mapfl & ".inf" for binary as #freefileinf
    seek freefileinf, 1

    'map header
    get #freefilemap, , mapinfo(map).mapversion
    get #freefilemap, , micabecera
    get #freefilemap, , tempint
    get #freefilemap, , tempint
    get #freefilemap, , tempint
    get #freefilemap, , tempint
    
    'inf header
    get #freefileinf, , tempint
    get #freefileinf, , tempint
    get #freefileinf, , tempint
    get #freefileinf, , tempint
    get #freefileinf, , tempint

    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            
            '.dat file
            get freefilemap, , byflags

            if byflags and 1 then
                mapdata(map, x, y).blocked = 1
            end if
            
            get freefilemap, , mapdata(map, x, y).graphic(1)
            
            'layer 2 used?
            if byflags and 2 then get freefilemap, , mapdata(map, x, y).graphic(2)
            
            'layer 3 used?
            if byflags and 4 then get freefilemap, , mapdata(map, x, y).graphic(3)
            
            'layer 4 used?
            if byflags and 8 then get freefilemap, , mapdata(map, x, y).graphic(4)
            
            'trigger used?
            if byflags and 16 then
                'enums are 4 byte long in vb, so we make sure we only read 2
                get freefilemap, , tempint
                mapdata(map, x, y).trigger = tempint
            end if
            
            get freefileinf, , byflags
            
            if byflags and 1 then
                get freefileinf, , mapdata(map, x, y).tileexit.map
                get freefileinf, , mapdata(map, x, y).tileexit.x
                get freefileinf, , mapdata(map, x, y).tileexit.y
            end if
            
            if byflags and 2 then
                'get and make npc
                get freefileinf, , mapdata(map, x, y).npcindex
                
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
                            
                    call makenpcchar(sendtarget.tomap, 0, 0, mapdata(map, x, y).npcindex, 1, 1, 1)
                end if
            end if
            
            if byflags and 4 then
                'get and make object
                get freefileinf, , mapdata(map, x, y).objinfo.objindex
                get freefileinf, , mapdata(map, x, y).objinfo.amount
            end if
        next x
    next y
    
    
    close freefilemap
    close freefileinf
    
    mapinfo(map).name = getvar(mapfl & ".dat", "mapa" & map, "name")
    mapinfo(map).music = getvar(mapfl & ".dat", "mapa" & map, "musicnum")
    mapinfo(map).startpos.map = val(readfield(1, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
    mapinfo(map).startpos.x = val(readfield(2, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
    mapinfo(map).startpos.y = val(readfield(3, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
    mapinfo(map).magiasinefecto = val(getvar(mapfl & ".dat", "mapa" & map, "magiasinefecto"))
    mapinfo(map).noencriptarmp = val(getvar(mapfl & ".dat", "mapa" & map, "noencriptarmp"))
    
    if val(getvar(mapfl & ".dat", "mapa" & map, "pk")) = 0 then
        mapinfo(map).pk = true
    else
        mapinfo(map).pk = false
    end if
    
    
    mapinfo(map).terreno = getvar(mapfl & ".dat", "mapa" & map, "terreno")
    mapinfo(map).zona = getvar(mapfl & ".dat", "mapa" & map, "zona")
    mapinfo(map).restringir = getvar(mapfl & ".dat", "mapa" & map, "restringir")
    mapinfo(map).backup = val(getvar(mapfl & ".dat", "mapa" & map, "backup"))
exit sub

errh:
    call logerror("error cargando mapa: " & map & "." & err.description)
end sub

sub loadsini()

dim temporal as long
dim temporal1 as long
dim loopc as integer

if frmmain.visible then frmmain.txstatus.caption = "cargando info de inicio del server."

bootdelbackup = val(getvar(inipath & "server.ini", "init", "iniciardesdebackup"))

'misc
crcsubkey = val(getvar(inipath & "server.ini", "init", "crcsubkey"))

serverip = getvar(inipath & "server.ini", "init", "serverip")
temporal = instr(1, serverip, ".")
temporal1 = (mid(serverip, 1, temporal - 1) and &h7f) * 16777216
serverip = mid(serverip, temporal + 1, len(serverip))
temporal = instr(1, serverip, ".")
temporal1 = temporal1 + mid(serverip, 1, temporal - 1) * 65536
serverip = mid(serverip, temporal + 1, len(serverip))
temporal = instr(1, serverip, ".")
temporal1 = temporal1 + mid(serverip, 1, temporal - 1) * 256
serverip = mid(serverip, temporal + 1, len(serverip))

mixedkey = (temporal1 + serverip) xor &h65f64b42

puerto = val(getvar(inipath & "server.ini", "init", "startport"))
hideme = val(getvar(inipath & "server.ini", "init", "hide"))
allowmultilogins = val(getvar(inipath & "server.ini", "init", "allowmultilogins"))
idlelimit = val(getvar(inipath & "server.ini", "init", "idlelimit"))
'lee la version correcta del cliente
ultimaversion = getvar(inipath & "server.ini", "init", "version")

puedecrearpersonajes = val(getvar(inipath & "server.ini", "init", "puedecrearpersonajes"))
camaralenta = val(getvar(inipath & "server.ini", "init", "camaralenta"))
serversologms = val(getvar(inipath & "server.ini", "init", "serversologms"))

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

vestimentaimperialhumano = val(getvar(inipath & "server.ini", "init", "vestimentaimperialhumano"))
vestimentaimperialenano = val(getvar(inipath & "server.ini", "init", "vestimentaimperialenano"))
tunicaconspicuahumano = val(getvar(inipath & "server.ini", "init", "tunicaconspicuahumano"))
tunicaconspicuaenano = val(getvar(inipath & "server.ini", "init", "tunicaconspicuaenano"))
armaduranobilisimahumano = val(getvar(inipath & "server.ini", "init", "armaduranobilisimahumano"))
armaduranobilisimaenano = val(getvar(inipath & "server.ini", "init", "armaduranobilisimaenano"))
armaduragransacerdote = val(getvar(inipath & "server.ini", "init", "armaduragransacerdote"))

vestimentalegionhumano = val(getvar(inipath & "server.ini", "init", "vestimentalegionhumano"))
vestimentalegionenano = val(getvar(inipath & "server.ini", "init", "vestimentalegionenano"))
tunicalobregahumano = val(getvar(inipath & "server.ini", "init", "tunicalobregahumano"))
tunicalobregaenano = val(getvar(inipath & "server.ini", "init", "tunicalobregaenano"))
tunicaegregiahumano = val(getvar(inipath & "server.ini", "init", "tunicaegregiahumano"))
tunicaegregiaenano = val(getvar(inipath & "server.ini", "init", "tunicaegregiaenano"))
sacerdotedemoniaco = val(getvar(inipath & "server.ini", "init", "sacerdotedemoniaco"))

mapa_pretoriano = val(getvar(inipath & "server.ini", "init", "mapapretoriano"))

clientscommandsqueue = val(getvar(inipath & "server.ini", "init", "clientscommandsqueue"))
entesting = val(getvar(inipath & "server.ini", "init", "testing"))
encriptarprotocoloscriticos = val(getvar(inipath & "server.ini", "init", "encriptar"))

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
intervalouserpuedeusar = val(getvar(inipath & "server.ini", "intervalos", "intervalouserpuedeusar"))
intervaloflechascazadores = val(getvar(inipath & "server.ini", "intervalos", "intervaloflechascazadores"))

intervaloautoreiniciar = val(getvar(inipath & "server.ini", "intervalos", "intervaloautoreiniciar"))


'ressurect pos
respos.map = val(readfield(1, getvar(inipath & "server.ini", "init", "respos"), 45))
respos.x = val(readfield(2, getvar(inipath & "server.ini", "init", "respos"), 45))
respos.y = val(readfield(3, getvar(inipath & "server.ini", "init", "respos"), 45))
  
recordusuarios = val(getvar(inipath & "server.ini", "init", "record"))
  
'max users
temporal = val(getvar(inipath & "server.ini", "init", "maxusers"))
if maxusers = 0 then
    maxusers = temporal
    redim userlist(1 to maxusers) as user
end if

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


call md5scarga

call consultapopular.loaddata

#if seguridadalkon then
encriptacion.stringvalidacion = encriptacion.armarstringvalidacion
#end if

end sub

sub writevar(byval file as string, byval main as string, byval var as string, byval value as string)
'*****************************************************************
'escribe var en un archivo
'*****************************************************************

writeprivateprofilestring main, var, value, file
    
end sub

sub saveuser(byval userindex as integer, byval userfile as string)
on error goto errhandler

dim olduserhead as long


'esto tiene que evitar ese bugazo que no se por que graba usuarios nulos
if userlist(userindex).clase = "" or userlist(userindex).stats.elv = 0 then
    call logcriticevent("estoy intentantdo guardar un usuario nulo de nombre: " & userlist(userindex).name)
    exit sub
end if


if userlist(userindex).flags.mimetizado = 1 then
    userlist(userindex).char.body = userlist(userindex).charmimetizado.body
    userlist(userindex).char.head = userlist(userindex).charmimetizado.head
    userlist(userindex).char.cascoanim = userlist(userindex).charmimetizado.cascoanim
    userlist(userindex).char.shieldanim = userlist(userindex).charmimetizado.shieldanim
    userlist(userindex).char.weaponanim = userlist(userindex).charmimetizado.weaponanim
    userlist(userindex).counters.mimetismo = 0
    userlist(userindex).flags.mimetizado = 0
end if



if fileexist(userfile, vbnormal) then
       if userlist(userindex).flags.muerto = 1 then
        olduserhead = userlist(userindex).char.head
        userlist(userindex).char.head = cstr(getvar(userfile, "init", "head"))
       end if
'       kill userfile
end if

dim loopc as integer


call writevar(userfile, "flags", "muerto", cstr(userlist(userindex).flags.muerto))
call writevar(userfile, "flags", "escondido", cstr(userlist(userindex).flags.escondido))
call writevar(userfile, "flags", "hambre", cstr(userlist(userindex).flags.hambre))
call writevar(userfile, "flags", "sed", cstr(userlist(userindex).flags.sed))
call writevar(userfile, "flags", "desnudo", cstr(userlist(userindex).flags.desnudo))
call writevar(userfile, "flags", "ban", cstr(userlist(userindex).flags.ban))
call writevar(userfile, "flags", "navegando", cstr(userlist(userindex).flags.navegando))

call writevar(userfile, "flags", "envenenado", cstr(userlist(userindex).flags.envenenado))
call writevar(userfile, "flags", "paralizado", cstr(userlist(userindex).flags.paralizado))

call writevar(userfile, "consejo", "pertenece", cstr(userlist(userindex).flags.pertalcons))
call writevar(userfile, "consejo", "pertenececaos", cstr(userlist(userindex).flags.pertalconscaos))


call writevar(userfile, "counters", "pena", cstr(userlist(userindex).counters.pena))

call writevar(userfile, "facciones", "ejercitoreal", cstr(userlist(userindex).faccion.armadareal))
call writevar(userfile, "facciones", "ejercitocaos", cstr(userlist(userindex).faccion.fuerzascaos))
call writevar(userfile, "facciones", "ciudmatados", cstr(userlist(userindex).faccion.ciudadanosmatados))
call writevar(userfile, "facciones", "crimmatados", cstr(userlist(userindex).faccion.criminalesmatados))
call writevar(userfile, "facciones", "rarcaos", cstr(userlist(userindex).faccion.recibioarmaduracaos))
call writevar(userfile, "facciones", "rarreal", cstr(userlist(userindex).faccion.recibioarmadurareal))
call writevar(userfile, "facciones", "rexcaos", cstr(userlist(userindex).faccion.recibioexpinicialcaos))
call writevar(userfile, "facciones", "rexreal", cstr(userlist(userindex).faccion.recibioexpinicialreal))
call writevar(userfile, "facciones", "reccaos", cstr(userlist(userindex).faccion.recompensascaos))
call writevar(userfile, "facciones", "recreal", cstr(userlist(userindex).faccion.recompensasreal))
call writevar(userfile, "facciones", "reenlistadas", cstr(userlist(userindex).faccion.reenlistadas))

'�fueron modificados los atributos del usuario?
if not userlist(userindex).flags.tomopocion then
    for loopc = 1 to ubound(userlist(userindex).stats.useratributos)
        call writevar(userfile, "atributos", "at" & loopc, cstr(userlist(userindex).stats.useratributos(loopc)))
    next
else
    for loopc = 1 to ubound(userlist(userindex).stats.useratributos)
        'userlist(userindex).stats.useratributos(loopc) = userlist(userindex).stats.useratributosbackup(loopc)
        call writevar(userfile, "atributos", "at" & loopc, cstr(userlist(userindex).stats.useratributosbackup(loopc)))
    next
end if

for loopc = 1 to ubound(userlist(userindex).stats.userskills)
    call writevar(userfile, "skills", "sk" & loopc, cstr(userlist(userindex).stats.userskills(loopc)))
next


call writevar(userfile, "contacto", "email", userlist(userindex).email)

call writevar(userfile, "init", "genero", userlist(userindex).genero)
call writevar(userfile, "init", "raza", userlist(userindex).raza)
call writevar(userfile, "init", "hogar", userlist(userindex).hogar)
call writevar(userfile, "init", "clase", userlist(userindex).clase)
call writevar(userfile, "init", "password", userlist(userindex).password)
call writevar(userfile, "init", "desc", userlist(userindex).desc)

call writevar(userfile, "init", "heading", cstr(userlist(userindex).char.heading))

call writevar(userfile, "init", "head", cstr(userlist(userindex).origchar.head))

if userlist(userindex).flags.muerto = 0 then
    call writevar(userfile, "init", "body", cstr(userlist(userindex).char.body))
end if

call writevar(userfile, "init", "arma", cstr(userlist(userindex).char.weaponanim))
call writevar(userfile, "init", "escudo", cstr(userlist(userindex).char.shieldanim))
call writevar(userfile, "init", "casco", cstr(userlist(userindex).char.cascoanim))

call writevar(userfile, "init", "lastip", userlist(userindex).ip)
call writevar(userfile, "init", "position", userlist(userindex).pos.map & "-" & userlist(userindex).pos.x & "-" & userlist(userindex).pos.y)


call writevar(userfile, "stats", "gld", cstr(userlist(userindex).stats.gld))
call writevar(userfile, "stats", "banco", cstr(userlist(userindex).stats.banco))

call writevar(userfile, "stats", "met", cstr(userlist(userindex).stats.met))
call writevar(userfile, "stats", "maxhp", cstr(userlist(userindex).stats.maxhp))
call writevar(userfile, "stats", "minhp", cstr(userlist(userindex).stats.minhp))

call writevar(userfile, "stats", "fit", cstr(userlist(userindex).stats.fit))
call writevar(userfile, "stats", "maxsta", cstr(userlist(userindex).stats.maxsta))
call writevar(userfile, "stats", "minsta", cstr(userlist(userindex).stats.minsta))

call writevar(userfile, "stats", "maxman", cstr(userlist(userindex).stats.maxman))
call writevar(userfile, "stats", "minman", cstr(userlist(userindex).stats.minman))

call writevar(userfile, "stats", "maxhit", cstr(userlist(userindex).stats.maxhit))
call writevar(userfile, "stats", "minhit", cstr(userlist(userindex).stats.minhit))

call writevar(userfile, "stats", "maxagu", cstr(userlist(userindex).stats.maxagu))
call writevar(userfile, "stats", "minagu", cstr(userlist(userindex).stats.minagu))

call writevar(userfile, "stats", "maxham", cstr(userlist(userindex).stats.maxham))
call writevar(userfile, "stats", "minham", cstr(userlist(userindex).stats.minham))

call writevar(userfile, "stats", "skillptslibres", cstr(userlist(userindex).stats.skillpts))
  
call writevar(userfile, "stats", "exp", cstr(userlist(userindex).stats.exp))
call writevar(userfile, "stats", "elv", cstr(userlist(userindex).stats.elv))





call writevar(userfile, "stats", "elu", cstr(userlist(userindex).stats.elu))
call writevar(userfile, "muertes", "usermuertes", cstr(userlist(userindex).stats.usuariosmatados))
call writevar(userfile, "muertes", "crimmuertes", cstr(userlist(userindex).stats.criminalesmatados))
call writevar(userfile, "muertes", "npcsmuertes", cstr(userlist(userindex).stats.npcsmuertos))
  
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

call writevar(app.path & "\logs\" & "bandetail.log", userlist(bannedindex).name, "bannedby", userlist(userindex).name)
call writevar(app.path & "\logs\" & "bandetail.log", userlist(bannedindex).name, "reason", motivo)

'log interno del servidor, lo usa para hacer un unban general de toda la gente banned
dim mifile as integer
mifile = freefile
open app.path & "\logs\gentebanned.log" for append shared as #mifile
print #mifile, userlist(bannedindex).name
close #mifile

end sub


sub logbanfromname(byval bannedname as string, byval userindex as integer, byval motivo as string)

call writevar(app.path & "\logs\" & "bandetail.dat", bannedname, "bannedby", userlist(userindex).name)
call writevar(app.path & "\logs\" & "bandetail.dat", bannedname, "reason", motivo)

'log interno del servidor, lo usa para hacer un unban general de toda la gente banned
dim mifile as integer
mifile = freefile
open app.path & "\logs\gentebanned.log" for append shared as #mifile
print #mifile, bannedname
close #mifile

end sub


sub ban(byval bannedname as string, byval baneador as string, byval motivo as string)

call writevar(app.path & "\logs\" & "bandetail.dat", bannedname, "bannedby", baneador)
call writevar(app.path & "\logs\" & "bandetail.dat", bannedname, "reason", motivo)


'log interno del servidor, lo usa para hacer un unban general de toda la gente banned
dim mifile as integer
mifile = freefile
open app.path & "\logs\gentebanned.log" for append shared as #mifile
print #mifile, bannedname
close #mifile

end sub

public sub cargaapuestas()

    apuestas.ganancias = val(getvar(datpath & "apuestas.dat", "main", "ganancias"))
    apuestas.perdidas = val(getvar(datpath & "apuestas.dat", "main", "perdidas"))
    apuestas.jugadas = val(getvar(datpath & "apuestas.dat", "main", "jugadas"))

end sub
