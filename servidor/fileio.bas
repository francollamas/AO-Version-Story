attribute vb_name = "es"
'argentum online 0.12.2
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

public sub cargarspawnlist()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim n as integer, loopc as integer
    n = val(getvar(app.path & "\dat\invokar.dat", "init", "numnpcs"))
    redim spawnlist(n) as tcriaturasentrenador
    for loopc = 1 to n
        spawnlist(loopc).npcindex = val(getvar(app.path & "\dat\invokar.dat", "list", "ni" & loopc))
        spawnlist(loopc).npcname = getvar(app.path & "\dat\invokar.dat", "list", "nn" & loopc)
    next loopc
    
end sub

function esadmin(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim numwizs as integer
    dim wiznum as integer
    dim nomb as string
    
    numwizs = val(getvar(inipath & "server.ini", "init", "admines"))
    
    for wiznum = 1 to numwizs
        nomb = ucase$(getvar(inipath & "server.ini", "admines", "admin" & wiznum))
        
        if left$(nomb, 1) = "*" or left$(nomb, 1) = "+" then nomb = right$(nomb, len(nomb) - 1)
        if ucase$(name) = nomb then
            esadmin = true
            exit function
        end if
    next wiznum
    esadmin = false

end function

function esdios(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim numwizs as integer
    dim wiznum as integer
    dim nomb as string
    
    numwizs = val(getvar(inipath & "server.ini", "init", "dioses"))
    for wiznum = 1 to numwizs
        nomb = ucase$(getvar(inipath & "server.ini", "dioses", "dios" & wiznum))
        
        if left$(nomb, 1) = "*" or left$(nomb, 1) = "+" then nomb = right$(nomb, len(nomb) - 1)
        if ucase$(name) = nomb then
            esdios = true
            exit function
        end if
    next wiznum
    esdios = false
end function

function essemidios(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim numwizs as integer
    dim wiznum as integer
    dim nomb as string
    
    numwizs = val(getvar(inipath & "server.ini", "init", "semidioses"))
    for wiznum = 1 to numwizs
        nomb = ucase$(getvar(inipath & "server.ini", "semidioses", "semidios" & wiznum))
        
        if left$(nomb, 1) = "*" or left$(nomb, 1) = "+" then nomb = right$(nomb, len(nomb) - 1)
        if ucase$(name) = nomb then
            essemidios = true
            exit function
        end if
    next wiznum
    essemidios = false

end function

function esconsejero(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim numwizs as integer
    dim wiznum as integer
    dim nomb as string
    
    numwizs = val(getvar(inipath & "server.ini", "init", "consejeros"))
    for wiznum = 1 to numwizs
        nomb = ucase$(getvar(inipath & "server.ini", "consejeros", "consejero" & wiznum))
        
        if left$(nomb, 1) = "*" or left$(nomb, 1) = "+" then nomb = right$(nomb, len(nomb) - 1)
        if ucase$(name) = nomb then
            esconsejero = true
            exit function
        end if
    next wiznum
    esconsejero = false
end function

function esrolesmaster(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim numwizs as integer
    dim wiznum as integer
    dim nomb as string
    
    numwizs = val(getvar(inipath & "server.ini", "init", "rolesmasters"))
    for wiznum = 1 to numwizs
        nomb = ucase$(getvar(inipath & "server.ini", "rolesmasters", "rm" & wiznum))
        
        if left$(nomb, 1) = "*" or left$(nomb, 1) = "+" then nomb = right$(nomb, len(nomb) - 1)
        if ucase$(name) = nomb then
            esrolesmaster = true
            exit function
        end if
    next wiznum
    esrolesmaster = false
end function


public function txtdimension(byval name as string) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
        with hechizos(hechizo)
            .nombre = leer.getvalue("hechizo" & hechizo, "nombre")
            .desc = leer.getvalue("hechizo" & hechizo, "desc")
            .palabrasmagicas = leer.getvalue("hechizo" & hechizo, "palabrasmagicas")
            
            .hechizeromsg = leer.getvalue("hechizo" & hechizo, "hechizeromsg")
            .targetmsg = leer.getvalue("hechizo" & hechizo, "targetmsg")
            .propiomsg = leer.getvalue("hechizo" & hechizo, "propiomsg")
            
            .tipo = val(leer.getvalue("hechizo" & hechizo, "tipo"))
            .wav = val(leer.getvalue("hechizo" & hechizo, "wav"))
            .fxgrh = val(leer.getvalue("hechizo" & hechizo, "fxgrh"))
            
            .loops = val(leer.getvalue("hechizo" & hechizo, "loops"))
            
        '    .resis = val(leer.getvalue("hechizo" & hechizo, "resis"))
            
            .subehp = val(leer.getvalue("hechizo" & hechizo, "subehp"))
            .minhp = val(leer.getvalue("hechizo" & hechizo, "minhp"))
            .maxhp = val(leer.getvalue("hechizo" & hechizo, "maxhp"))
            
            .subemana = val(leer.getvalue("hechizo" & hechizo, "subemana"))
            .mimana = val(leer.getvalue("hechizo" & hechizo, "minmana"))
            .mamana = val(leer.getvalue("hechizo" & hechizo, "maxmana"))
            
            .subesta = val(leer.getvalue("hechizo" & hechizo, "subesta"))
            .minsta = val(leer.getvalue("hechizo" & hechizo, "minsta"))
            .maxsta = val(leer.getvalue("hechizo" & hechizo, "maxsta"))
            
            .subeham = val(leer.getvalue("hechizo" & hechizo, "subeham"))
            .minham = val(leer.getvalue("hechizo" & hechizo, "minham"))
            .maxham = val(leer.getvalue("hechizo" & hechizo, "maxham"))
            
            .subesed = val(leer.getvalue("hechizo" & hechizo, "subesed"))
            .minsed = val(leer.getvalue("hechizo" & hechizo, "minsed"))
            .maxsed = val(leer.getvalue("hechizo" & hechizo, "maxsed"))
            
            .subeagilidad = val(leer.getvalue("hechizo" & hechizo, "subeag"))
            .minagilidad = val(leer.getvalue("hechizo" & hechizo, "minag"))
            .maxagilidad = val(leer.getvalue("hechizo" & hechizo, "maxag"))
            
            .subefuerza = val(leer.getvalue("hechizo" & hechizo, "subefu"))
            .minfuerza = val(leer.getvalue("hechizo" & hechizo, "minfu"))
            .maxfuerza = val(leer.getvalue("hechizo" & hechizo, "maxfu"))
            
            .subecarisma = val(leer.getvalue("hechizo" & hechizo, "subeca"))
            .mincarisma = val(leer.getvalue("hechizo" & hechizo, "minca"))
            .maxcarisma = val(leer.getvalue("hechizo" & hechizo, "maxca"))
            
            
            .invisibilidad = val(leer.getvalue("hechizo" & hechizo, "invisibilidad"))
            .paraliza = val(leer.getvalue("hechizo" & hechizo, "paraliza"))
            .inmoviliza = val(leer.getvalue("hechizo" & hechizo, "inmoviliza"))
            .removerparalisis = val(leer.getvalue("hechizo" & hechizo, "removerparalisis"))
            .removerestupidez = val(leer.getvalue("hechizo" & hechizo, "removerestupidez"))
            .remueveinvisibilidadparcial = val(leer.getvalue("hechizo" & hechizo, "remueveinvisibilidadparcial"))
            
            
            .curaveneno = val(leer.getvalue("hechizo" & hechizo, "curaveneno"))
            .envenena = val(leer.getvalue("hechizo" & hechizo, "envenena"))
            .maldicion = val(leer.getvalue("hechizo" & hechizo, "maldicion"))
            .removermaldicion = val(leer.getvalue("hechizo" & hechizo, "removermaldicion"))
            .bendicion = val(leer.getvalue("hechizo" & hechizo, "bendicion"))
            .revivir = val(leer.getvalue("hechizo" & hechizo, "revivir"))
            
            .ceguera = val(leer.getvalue("hechizo" & hechizo, "ceguera"))
            .estupidez = val(leer.getvalue("hechizo" & hechizo, "estupidez"))
            
            .warp = val(leer.getvalue("hechizo" & hechizo, "warp"))
            
            .invoca = val(leer.getvalue("hechizo" & hechizo, "invoca"))
            .numnpc = val(leer.getvalue("hechizo" & hechizo, "numnpc"))
            .cant = val(leer.getvalue("hechizo" & hechizo, "cant"))
            .mimetiza = val(leer.getvalue("hechizo" & hechizo, "mimetiza"))
            
        '    .materializa = val(leer.getvalue("hechizo" & hechizo, "materializa"))
        '    .itemindex = val(leer.getvalue("hechizo" & hechizo, "itemindex"))
            
            .minskill = val(leer.getvalue("hechizo" & hechizo, "minskill"))
            .manarequerido = val(leer.getvalue("hechizo" & hechizo, "manarequerido"))
            
            'barrin 30/9/03
            .starequerido = val(leer.getvalue("hechizo" & hechizo, "starequerido"))
            
            .target = val(leer.getvalue("hechizo" & hechizo, "target"))
            frmcargando.cargar.value = frmcargando.cargar.value + 1
            
            .needstaff = val(leer.getvalue("hechizo" & hechizo, "needstaff"))
            .staffaffected = cbool(val(leer.getvalue("hechizo" & hechizo, "staffaffected")))
        end with
    next hechizo
    
    set leer = nothing
    
    exit sub

errhandler:
    msgbox "error cargando hechizos.dat " & err.number & ": " & err.description
 
end sub

sub loadmotd()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim i as integer
    
    maxlines = val(getvar(app.path & "\dat\motd.ini", "init", "numlines"))
    
    redim motd(1 to maxlines)
    for i = 1 to maxlines
        motd(i).texto = getvar(app.path & "\dat\motd.ini", "motd", "line" & i)
        motd(i).formato = vbnullstring
    next i

end sub

public sub dobackup()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
    
    
    
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    
    
    call limpiarmundo
    call worldsave
    call modguilds.v_rutinaelecciones
    call resetcentinelainfo     'reseteamos al centinela
    
    
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
            with mapdata(map, x, y)
                byflags = 0
                
                if .blocked then byflags = byflags or 1
                if .graphic(2) then byflags = byflags or 2
                if .graphic(3) then byflags = byflags or 4
                if .graphic(4) then byflags = byflags or 8
                if .trigger then byflags = byflags or 16
                
                put freefilemap, , byflags
                
                put freefilemap, , .graphic(1)
                
                for loopc = 2 to 4
                    if .graphic(loopc) then _
                        put freefilemap, , .graphic(loopc)
                next loopc
                
                if .trigger then _
                    put freefilemap, , cint(.trigger)
                
                '.inf file
                
                byflags = 0
                
                if .objinfo.objindex > 0 then
                   if objdata(.objinfo.objindex).objtype = eobjtype.otfogata then
                        .objinfo.objindex = 0
                        .objinfo.amount = 0
                    end if
                end if
    
                if .tileexit.map then byflags = byflags or 1
                if .npcindex then byflags = byflags or 2
                if .objinfo.objindex then byflags = byflags or 4
                
                put freefileinf, , byflags
                
                if .tileexit.map then
                    put freefileinf, , .tileexit.map
                    put freefileinf, , .tileexit.x
                    put freefileinf, , .tileexit.y
                end if
                
                if .npcindex then _
                    put freefileinf, , npclist(.npcindex).numero
                
                if .objinfo.objindex then
                    put freefileinf, , .objinfo.objindex
                    put freefileinf, , .objinfo.amount
                end if
            end with
        next x
    next y
    
    'close .map file
    close freefilemap

    'close .inf file
    close freefileinf

    with mapinfo(map)
    
        'write .dat file
        call writevar(mapfile & ".dat", "mapa" & map, "name", .name)
        call writevar(mapfile & ".dat", "mapa" & map, "musicnum", .music)
        call writevar(mapfile & ".dat", "mapa" & map, "magiasinefecto", .magiasinefecto)
        call writevar(mapfile & ".dat", "mapa" & map, "invisinefecto", .invisinefecto)
        call writevar(mapfile & ".dat", "mapa" & map, "resusinefecto", .resusinefecto)
        call writevar(mapfile & ".dat", "mapa" & map, "startpos", .startpos.map & "-" & .startpos.x & "-" & .startpos.y)
        
    
        call writevar(mapfile & ".dat", "mapa" & map, "terreno", .terreno)
        call writevar(mapfile & ".dat", "mapa" & map, "zona", .zona)
        call writevar(mapfile & ".dat", "mapa" & map, "restringir", .restringir)
        call writevar(mapfile & ".dat", "mapa" & map, "backup", str(.backup))
    
        if .pk then
            call writevar(mapfile & ".dat", "mapa" & map, "pk", "0")
        else
            call writevar(mapfile & ".dat", "mapa" & map, "pk", "1")
        end if
    end with

end sub
sub loadarmasherreria()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim n as integer, lc as integer
    
    n = val(getvar(datpath & "armasherrero.dat", "init", "numarmas"))
    
    redim preserve armasherrero(1 to n) as integer
    
    for lc = 1 to n
        armasherrero(lc) = val(getvar(datpath & "armasherrero.dat", "arma" & lc, "index"))
    next lc

end sub

sub loadarmadurasherreria()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim n as integer, lc as integer
    
    n = val(getvar(datpath & "armadurasherrero.dat", "init", "numarmaduras"))
    
    redim preserve armadurasherrero(1 to n) as integer
    
    for lc = 1 to n
        armadurasherrero(lc) = val(getvar(datpath & "armadurasherrero.dat", "armadura" & lc, "index"))
    next lc

end sub

sub loadbalance()
'***************************************************
'author: unknown
'last modification: 15/04/2010
'15/04/2010: zama - agrego recompensas faccionarias.
'***************************************************

    dim i as long
    
    'modificadores de clase
    for i = 1 to numclases
        with modclase(i)
            .evasion = val(getvar(datpath & "balance.dat", "modevasion", listaclases(i)))
            .ataquearmas = val(getvar(datpath & "balance.dat", "modataquearmas", listaclases(i)))
            .ataqueproyectiles = val(getvar(datpath & "balance.dat", "modataqueproyectiles", listaclases(i)))
            .ataquewrestling = val(getvar(datpath & "balance.dat", "modataquewrestling", listaclases(i)))
            .da�oarmas = val(getvar(datpath & "balance.dat", "modda�oarmas", listaclases(i)))
            .da�oproyectiles = val(getvar(datpath & "balance.dat", "modda�oproyectiles", listaclases(i)))
            .da�owrestling = val(getvar(datpath & "balance.dat", "modda�owrestling", listaclases(i)))
            .escudo = val(getvar(datpath & "balance.dat", "modescudo", listaclases(i)))
        end with
    next i
    
    'modificadores de raza
    for i = 1 to numrazas
        with modraza(i)
            .fuerza = val(getvar(datpath & "balance.dat", "modraza", listarazas(i) + "fuerza"))
            .agilidad = val(getvar(datpath & "balance.dat", "modraza", listarazas(i) + "agilidad"))
            .inteligencia = val(getvar(datpath & "balance.dat", "modraza", listarazas(i) + "inteligencia"))
            .carisma = val(getvar(datpath & "balance.dat", "modraza", listarazas(i) + "carisma"))
            .constitucion = val(getvar(datpath & "balance.dat", "modraza", listarazas(i) + "constitucion"))
        end with
    next i
    
    'modificadores de vida
    for i = 1 to numclases
        modvida(i) = val(getvar(datpath & "balance.dat", "modvida", listaclases(i)))
    next i
    
    'distribuci�n de vida
    for i = 1 to 5
        distribucionenteravida(i) = val(getvar(datpath & "balance.dat", "distribucion", "e" + cstr(i)))
    next i
    for i = 1 to 4
        distribucionsemienteravida(i) = val(getvar(datpath & "balance.dat", "distribucion", "s" + cstr(i)))
    next i
    
    'extra
    porcentajerecuperomana = val(getvar(datpath & "balance.dat", "extra", "porcentajerecuperomana"))

    'party
    exponentenivelparty = val(getvar(datpath & "balance.dat", "party", "exponentenivelparty"))
    
    ' recompensas faccionarias
    for i = 1 to num_rangos_faccion
        recompensafacciones(i - 1) = val(getvar(datpath & "balance.dat", "recompensafaccion", "rango" & i))
    next i
    
end sub

sub loadobjcarpintero()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim n as integer, lc as integer
    
    n = val(getvar(datpath & "objcarpintero.dat", "init", "numobjs"))
    
    redim preserve objcarpintero(1 to n) as integer
    
    for lc = 1 to n
        objcarpintero(lc) = val(getvar(datpath & "objcarpintero.dat", "obj" & lc, "index"))
    next lc

end sub



sub loadobjdata()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
        with objdata(object)
            .name = leer.getvalue("obj" & object, "name")
            
            'pablo (toxicwaste) log de objetos.
            .log = val(leer.getvalue("obj" & object, "log"))
            .nolog = val(leer.getvalue("obj" & object, "nolog"))
            '07/09/07
            
            .grhindex = val(leer.getvalue("obj" & object, "grhindex"))
            if .grhindex = 0 then
                .grhindex = .grhindex
            end if
            
            .objtype = val(leer.getvalue("obj" & object, "objtype"))
            
            .newbie = val(leer.getvalue("obj" & object, "newbie"))
            
            select case .objtype
                case eobjtype.otarmadura
                    .real = val(leer.getvalue("obj" & object, "real"))
                    .caos = val(leer.getvalue("obj" & object, "caos"))
                    .lingh = val(leer.getvalue("obj" & object, "lingh"))
                    .lingp = val(leer.getvalue("obj" & object, "lingp"))
                    .lingo = val(leer.getvalue("obj" & object, "lingo"))
                    .skherreria = val(leer.getvalue("obj" & object, "skherreria"))
                
                case eobjtype.otescudo
                    .shieldanim = val(leer.getvalue("obj" & object, "anim"))
                    .lingh = val(leer.getvalue("obj" & object, "lingh"))
                    .lingp = val(leer.getvalue("obj" & object, "lingp"))
                    .lingo = val(leer.getvalue("obj" & object, "lingo"))
                    .skherreria = val(leer.getvalue("obj" & object, "skherreria"))
                    .real = val(leer.getvalue("obj" & object, "real"))
                    .caos = val(leer.getvalue("obj" & object, "caos"))
                
                case eobjtype.otcasco
                    .cascoanim = val(leer.getvalue("obj" & object, "anim"))
                    .lingh = val(leer.getvalue("obj" & object, "lingh"))
                    .lingp = val(leer.getvalue("obj" & object, "lingp"))
                    .lingo = val(leer.getvalue("obj" & object, "lingo"))
                    .skherreria = val(leer.getvalue("obj" & object, "skherreria"))
                    .real = val(leer.getvalue("obj" & object, "real"))
                    .caos = val(leer.getvalue("obj" & object, "caos"))
                
                case eobjtype.otweapon
                    .weaponanim = val(leer.getvalue("obj" & object, "anim"))
                    .apu�ala = val(leer.getvalue("obj" & object, "apu�ala"))
                    .envenena = val(leer.getvalue("obj" & object, "envenena"))
                    .maxhit = val(leer.getvalue("obj" & object, "maxhit"))
                    .minhit = val(leer.getvalue("obj" & object, "minhit"))
                    .proyectil = val(leer.getvalue("obj" & object, "proyectil"))
                    .municion = val(leer.getvalue("obj" & object, "municiones"))
                    .staffpower = val(leer.getvalue("obj" & object, "staffpower"))
                    .staffdamagebonus = val(leer.getvalue("obj" & object, "staffdamagebonus"))
                    .refuerzo = val(leer.getvalue("obj" & object, "refuerzo"))
                    
                    .lingh = val(leer.getvalue("obj" & object, "lingh"))
                    .lingp = val(leer.getvalue("obj" & object, "lingp"))
                    .lingo = val(leer.getvalue("obj" & object, "lingo"))
                    .skherreria = val(leer.getvalue("obj" & object, "skherreria"))
                    .real = val(leer.getvalue("obj" & object, "real"))
                    .caos = val(leer.getvalue("obj" & object, "caos"))
                    
                    .weaponrazaenanaanim = val(leer.getvalue("obj" & object, "razaenanaanim"))
                
                case eobjtype.otinstrumentos
                    .snd1 = val(leer.getvalue("obj" & object, "snd1"))
                    .snd2 = val(leer.getvalue("obj" & object, "snd2"))
                    .snd3 = val(leer.getvalue("obj" & object, "snd3"))
                    'pablo (toxicwaste)
                    .real = val(leer.getvalue("obj" & object, "real"))
                    .caos = val(leer.getvalue("obj" & object, "caos"))
                
                case eobjtype.otminerales
                    .minskill = val(leer.getvalue("obj" & object, "minskill"))
                
                case eobjtype.otpuertas, eobjtype.otbotellavacia, eobjtype.otbotellallena
                    .indexabierta = val(leer.getvalue("obj" & object, "indexabierta"))
                    .indexcerrada = val(leer.getvalue("obj" & object, "indexcerrada"))
                    .indexcerradallave = val(leer.getvalue("obj" & object, "indexcerradallave"))
                
                case otpociones
                    .tipopocion = val(leer.getvalue("obj" & object, "tipopocion"))
                    .maxmodificador = val(leer.getvalue("obj" & object, "maxmodificador"))
                    .minmodificador = val(leer.getvalue("obj" & object, "minmodificador"))
                    .duracionefecto = val(leer.getvalue("obj" & object, "duracionefecto"))
                
                case eobjtype.otbarcos
                    .minskill = val(leer.getvalue("obj" & object, "minskill"))
                    .maxhit = val(leer.getvalue("obj" & object, "maxhit"))
                    .minhit = val(leer.getvalue("obj" & object, "minhit"))
                
                case eobjtype.otflechas
                    .maxhit = val(leer.getvalue("obj" & object, "maxhit"))
                    .minhit = val(leer.getvalue("obj" & object, "minhit"))
                    .envenena = val(leer.getvalue("obj" & object, "envenena"))
                    .paraliza = val(leer.getvalue("obj" & object, "paraliza"))
                    
                case eobjtype.otanillo 'pablo (toxicwaste)
                    .lingh = val(leer.getvalue("obj" & object, "lingh"))
                    .lingp = val(leer.getvalue("obj" & object, "lingp"))
                    .lingo = val(leer.getvalue("obj" & object, "lingo"))
                    .skherreria = val(leer.getvalue("obj" & object, "skherreria"))
                    .maxhit = val(leer.getvalue("obj" & object, "maxhit"))
                    .minhit = val(leer.getvalue("obj" & object, "minhit"))
                    
                case eobjtype.otteleport
                    .radio = val(leer.getvalue("obj" & object, "radio"))
                    
                case eobjtype.otmochilas
                    .mochilatype = val(leer.getvalue("obj" & object, "mochilatype"))
                    
                case eobjtype.otforos
                    call addforum(leer.getvalue("obj" & object, "id"))
                    
            end select
            
            .ropaje = val(leer.getvalue("obj" & object, "numropaje"))
            .hechizoindex = val(leer.getvalue("obj" & object, "hechizoindex"))
            
            .lingoteindex = val(leer.getvalue("obj" & object, "lingoteindex"))
            
            .mineralindex = val(leer.getvalue("obj" & object, "mineralindex"))
            
            .maxhp = val(leer.getvalue("obj" & object, "maxhp"))
            .minhp = val(leer.getvalue("obj" & object, "minhp"))
            
            .mujer = val(leer.getvalue("obj" & object, "mujer"))
            .hombre = val(leer.getvalue("obj" & object, "hombre"))
            
            .minham = val(leer.getvalue("obj" & object, "minham"))
            .minsed = val(leer.getvalue("obj" & object, "minagu"))
            
            .mindef = val(leer.getvalue("obj" & object, "mindef"))
            .maxdef = val(leer.getvalue("obj" & object, "maxdef"))
            .def = (.mindef + .maxdef) / 2
            
            .razaenana = val(leer.getvalue("obj" & object, "razaenana"))
            .razadrow = val(leer.getvalue("obj" & object, "razadrow"))
            .razaelfa = val(leer.getvalue("obj" & object, "razaelfa"))
            .razagnoma = val(leer.getvalue("obj" & object, "razagnoma"))
            .razahumana = val(leer.getvalue("obj" & object, "razahumana"))
            
            .valor = val(leer.getvalue("obj" & object, "valor"))
            
            .crucial = val(leer.getvalue("obj" & object, "crucial"))
            
            .cerrada = val(leer.getvalue("obj" & object, "abierta"))
            if .cerrada = 1 then
                .llave = val(leer.getvalue("obj" & object, "llave"))
                .clave = val(leer.getvalue("obj" & object, "clave"))
            end if
            
            'puertas y llaves
            .clave = val(leer.getvalue("obj" & object, "clave"))
            
            .texto = leer.getvalue("obj" & object, "texto")
            .grhsecundario = val(leer.getvalue("obj" & object, "vgrande"))
            
            .agarrable = val(leer.getvalue("obj" & object, "agarrable"))
            .foroid = leer.getvalue("obj" & object, "id")
            
            .acuchilla = val(leer.getvalue("obj" & object, "acuchilla"))
            
            .guante = val(leer.getvalue("obj" & object, "guante"))
            
            'check: !!! esto es provisorio hasta que los de dateo cambien los valores de string a numerico
            dim i as integer
            dim n as integer
            dim s as string
            for i = 1 to numclases
                s = ucase$(leer.getvalue("obj" & object, "cp" & i))
                n = 1
                do while lenb(s) > 0 and ucase$(listaclases(n)) <> s
                    n = n + 1
                loop
                .claseprohibida(i) = iif(lenb(s) > 0, n, 0)
            next i
            
            .defensamagicamax = val(leer.getvalue("obj" & object, "defensamagicamax"))
            .defensamagicamin = val(leer.getvalue("obj" & object, "defensamagicamin"))
            
            .skcarpinteria = val(leer.getvalue("obj" & object, "skcarpinteria"))
            
            if .skcarpinteria > 0 then _
                .madera = val(leer.getvalue("obj" & object, "madera"))
                .maderaelfica = val(leer.getvalue("obj" & object, "maderaelfica"))
            
            'bebidas
            .minsta = val(leer.getvalue("obj" & object, "minst"))
            
            .nosecae = val(leer.getvalue("obj" & object, "nosecae"))
            
            .upgrade = val(leer.getvalue("obj" & object, "upgrade"))
            
            frmcargando.cargar.value = frmcargando.cargar.value + 1
        end with
    next object
    
    
    set leer = nothing
    
    ' inicializo los foros faccionarios
    call addforum(foro_caos_id)
    call addforum(foro_real_id)
    
    exit sub

errhandler:
    msgbox "error cargando objetos " & err.number & ": " & err.description


end sub

sub loaduserstats(byval userindex as integer, byref userfile as clsinireader)
'*************************************************
'author: unknown
'last modified: 11/19/2009
'11/19/2009: pato - load the eluskills and expskills
'*************************************************
dim loopc as long

with userlist(userindex)
    with .stats
        for loopc = 1 to numatributos
            .useratributos(loopc) = cint(userfile.getvalue("atributos", "at" & loopc))
            .useratributosbackup(loopc) = .useratributos(loopc)
        next loopc
        
        for loopc = 1 to numskills
            .userskills(loopc) = cint(userfile.getvalue("skills", "sk" & loopc))
            .eluskills(loopc) = cint(userfile.getvalue("skills", "elusk" & loopc))
            .expskills(loopc) = cint(userfile.getvalue("skills", "expsk" & loopc))
        next loopc
        
        for loopc = 1 to maxuserhechizos
            .userhechizos(loopc) = cint(userfile.getvalue("hechizos", "h" & loopc))
        next loopc
        
        .gld = clng(userfile.getvalue("stats", "gld"))
        .banco = clng(userfile.getvalue("stats", "banco"))
        
        .maxhp = cint(userfile.getvalue("stats", "maxhp"))
        .minhp = cint(userfile.getvalue("stats", "minhp"))
        
        .minsta = cint(userfile.getvalue("stats", "minsta"))
        .maxsta = cint(userfile.getvalue("stats", "maxsta"))
        
        .maxman = cint(userfile.getvalue("stats", "maxman"))
        .minman = cint(userfile.getvalue("stats", "minman"))
        
        .maxhit = cint(userfile.getvalue("stats", "maxhit"))
        .minhit = cint(userfile.getvalue("stats", "minhit"))
        
        .maxagu = cbyte(userfile.getvalue("stats", "maxagu"))
        .minagu = cbyte(userfile.getvalue("stats", "minagu"))
        
        .maxham = cbyte(userfile.getvalue("stats", "maxham"))
        .minham = cbyte(userfile.getvalue("stats", "minham"))
        
        .skillpts = cint(userfile.getvalue("stats", "skillptslibres"))
        
        .exp = cdbl(userfile.getvalue("stats", "exp"))
        .elu = clng(userfile.getvalue("stats", "elu"))
        .elv = cbyte(userfile.getvalue("stats", "elv"))
        
        
        .usuariosmatados = clng(userfile.getvalue("muertes", "usermuertes"))
        .npcsmuertos = cint(userfile.getvalue("muertes", "npcsmuertes"))
    end with
    
    with .flags
        if cbyte(userfile.getvalue("consejo", "pertenece")) then _
            .privilegios = .privilegios or playertype.royalcouncil
        
        if cbyte(userfile.getvalue("consejo", "pertenececaos")) then _
            .privilegios = .privilegios or playertype.chaoscouncil
    end with
end with
end sub

sub loaduserreputacion(byval userindex as integer, byref userfile as clsinireader)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    with userlist(userindex).reputacion
        .asesinorep = val(userfile.getvalue("rep", "asesino"))
        .bandidorep = val(userfile.getvalue("rep", "bandido"))
        .burguesrep = val(userfile.getvalue("rep", "burguesia"))
        .ladronesrep = val(userfile.getvalue("rep", "ladrones"))
        .noblerep = val(userfile.getvalue("rep", "nobles"))
        .pleberep = val(userfile.getvalue("rep", "plebe"))
        .promedio = val(userfile.getvalue("rep", "promedio"))
    end with
    
end sub

sub loaduserinit(byval userindex as integer, byref userfile as clsinireader)
'*************************************************
'author: unknown
'last modified: 19/11/2006
'loads the users records
'23/01/2007 pablo (toxicwaste) - agrego nivelingreso, fechaingreso, matadosingreso y nextrecompensa.
'23/01/2007 pablo (toxicwaste) - quito criminalesmatados de stats porque era redundante.
'*************************************************
    dim loopc as long
    dim ln as string
    
    with userlist(userindex)
        with .faccion
            .armadareal = cbyte(userfile.getvalue("facciones", "ejercitoreal"))
            .fuerzascaos = cbyte(userfile.getvalue("facciones", "ejercitocaos"))
            .ciudadanosmatados = clng(userfile.getvalue("facciones", "ciudmatados"))
            .criminalesmatados = clng(userfile.getvalue("facciones", "crimmatados"))
            .recibioarmaduracaos = cbyte(userfile.getvalue("facciones", "rarcaos"))
            .recibioarmadurareal = cbyte(userfile.getvalue("facciones", "rarreal"))
            .recibioexpinicialcaos = cbyte(userfile.getvalue("facciones", "rexcaos"))
            .recibioexpinicialreal = cbyte(userfile.getvalue("facciones", "rexreal"))
            .recompensascaos = clng(userfile.getvalue("facciones", "reccaos"))
            .recompensasreal = clng(userfile.getvalue("facciones", "recreal"))
            .reenlistadas = cbyte(userfile.getvalue("facciones", "reenlistadas"))
            .nivelingreso = cint(userfile.getvalue("facciones", "nivelingreso"))
            .fechaingreso = userfile.getvalue("facciones", "fechaingreso")
            .matadosingreso = cint(userfile.getvalue("facciones", "matadosingreso"))
            .nextrecompensa = cint(userfile.getvalue("facciones", "nextrecompensa"))
        end with
        
        with .flags
            .muerto = cbyte(userfile.getvalue("flags", "muerto"))
            .escondido = cbyte(userfile.getvalue("flags", "escondido"))
            
            .hambre = cbyte(userfile.getvalue("flags", "hambre"))
            .sed = cbyte(userfile.getvalue("flags", "sed"))
            .desnudo = cbyte(userfile.getvalue("flags", "desnudo"))
            .navegando = cbyte(userfile.getvalue("flags", "navegando"))
            .envenenado = cbyte(userfile.getvalue("flags", "envenenado"))
            .paralizado = cbyte(userfile.getvalue("flags", "paralizado"))
            
            'matrix
            .lastmap = cint(userfile.getvalue("flags", "lastmap"))
        end with
        
        if .flags.paralizado = 1 then
            .counters.paralisis = intervaloparalizado
        end if
        
        
        .counters.pena = clng(userfile.getvalue("counters", "pena"))
        .counters.asignedskills = cbyte(val(userfile.getvalue("counters", "skillsasignados")))
        
        .email = userfile.getvalue("contacto", "email")
        
        .genero = userfile.getvalue("init", "genero")
        .clase = userfile.getvalue("init", "clase")
        .raza = userfile.getvalue("init", "raza")
        .hogar = userfile.getvalue("init", "hogar")
        .char.heading = cint(userfile.getvalue("init", "heading"))
        
        
        with .origchar
            .head = cint(userfile.getvalue("init", "head"))
            .body = cint(userfile.getvalue("init", "body"))
            .weaponanim = cint(userfile.getvalue("init", "arma"))
            .shieldanim = cint(userfile.getvalue("init", "escudo"))
            .cascoanim = cint(userfile.getvalue("init", "casco"))
            
            .heading = eheading.south
        end with
        
        #if conuptime then
            .uptime = clng(userfile.getvalue("init", "uptime"))
        #end if
        
        if .flags.muerto = 0 then
            .char = .origchar
        else
            .char.body = icuerpomuerto
            .char.head = icabezamuerto
            .char.weaponanim = ningunarma
            .char.shieldanim = ningunescudo
            .char.cascoanim = ninguncasco
        end if
        
        
        .desc = userfile.getvalue("init", "desc")
        
        .pos.map = cint(readfield(1, userfile.getvalue("init", "position"), 45))
        .pos.x = cint(readfield(2, userfile.getvalue("init", "position"), 45))
        .pos.y = cint(readfield(3, userfile.getvalue("init", "position"), 45))
        
        .invent.nroitems = cint(userfile.getvalue("inventory", "cantidaditems"))
        
        '[kevin]--------------------------------------------------------------------
        '***********************************************************************************
        .bancoinvent.nroitems = cint(userfile.getvalue("bancoinventory", "cantidaditems"))
        'lista de objetos del banco
        for loopc = 1 to max_bancoinventory_slots
            ln = userfile.getvalue("bancoinventory", "obj" & loopc)
            .bancoinvent.object(loopc).objindex = cint(readfield(1, ln, 45))
            .bancoinvent.object(loopc).amount = cint(readfield(2, ln, 45))
        next loopc
        '------------------------------------------------------------------------------------
        '[/kevin]*****************************************************************************
        
        
        'lista de objetos
        for loopc = 1 to max_inventory_slots
            ln = userfile.getvalue("inventory", "obj" & loopc)
            .invent.object(loopc).objindex = cint(readfield(1, ln, 45))
            .invent.object(loopc).amount = cint(readfield(2, ln, 45))
            .invent.object(loopc).equipped = cbyte(readfield(3, ln, 45))
        next loopc
        
        'obtiene el indice-objeto del arma
        .invent.weaponeqpslot = cbyte(userfile.getvalue("inventory", "weaponeqpslot"))
        if .invent.weaponeqpslot > 0 then
            .invent.weaponeqpobjindex = .invent.object(.invent.weaponeqpslot).objindex
        end if
        
        'obtiene el indice-objeto del armadura
        .invent.armoureqpslot = cbyte(userfile.getvalue("inventory", "armoureqpslot"))
        if .invent.armoureqpslot > 0 then
            .invent.armoureqpobjindex = .invent.object(.invent.armoureqpslot).objindex
            .flags.desnudo = 0
        else
            .flags.desnudo = 1
        end if
        
        'obtiene el indice-objeto del escudo
        .invent.escudoeqpslot = cbyte(userfile.getvalue("inventory", "escudoeqpslot"))
        if .invent.escudoeqpslot > 0 then
            .invent.escudoeqpobjindex = .invent.object(.invent.escudoeqpslot).objindex
        end if
        
        'obtiene el indice-objeto del casco
        .invent.cascoeqpslot = cbyte(userfile.getvalue("inventory", "cascoeqpslot"))
        if .invent.cascoeqpslot > 0 then
            .invent.cascoeqpobjindex = .invent.object(.invent.cascoeqpslot).objindex
        end if
        
        'obtiene el indice-objeto barco
        .invent.barcoslot = cbyte(userfile.getvalue("inventory", "barcoslot"))
        if .invent.barcoslot > 0 then
            .invent.barcoobjindex = .invent.object(.invent.barcoslot).objindex
        end if
        
        'obtiene el indice-objeto municion
        .invent.municioneqpslot = cbyte(userfile.getvalue("inventory", "municionslot"))
        if .invent.municioneqpslot > 0 then
            .invent.municioneqpobjindex = .invent.object(.invent.municioneqpslot).objindex
        end if
        
        '[alejo]
        'obtiene el indice-objeto anilo
        .invent.anilloeqpslot = cbyte(userfile.getvalue("inventory", "anilloslot"))
        if .invent.anilloeqpslot > 0 then
            .invent.anilloeqpobjindex = .invent.object(.invent.anilloeqpslot).objindex
        end if
        
        .invent.mochilaeqpslot = cbyte(userfile.getvalue("inventory", "mochilaslot"))
        if .invent.mochilaeqpslot > 0 then
            .invent.mochilaeqpobjindex = .invent.object(.invent.mochilaeqpslot).objindex
        end if
        
        .nromascotas = cint(userfile.getvalue("mascotas", "nromascotas"))
        dim npcindex as integer
        for loopc = 1 to maxmascotas
            .mascotastype(loopc) = val(userfile.getvalue("mascotas", "mas" & loopc))
        next loopc
        
        ln = userfile.getvalue("guild", "guildindex")
        if isnumeric(ln) then
            .guildindex = cint(ln)
        else
            .guildindex = 0
        end if
    end with

end sub

function getvar(byval file as string, byval main as string, byval var as string, optional emptyspaces as long = 1024) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim sspaces as string ' this will hold the input that the program will retrieve
    dim szreturn as string ' this will be the defaul value if the string is not found
      
    szreturn = vbnullstring
      
    sspaces = space$(emptyspaces) ' this tells the computer how long the longest string can be
      
      
    getprivateprofilestring main, var, szreturn, sspaces, emptyspaces, file
      
    getvar = rtrim$(sspaces)
    getvar = left$(getvar, len(getvar) - 1)
  
end function

sub cargarbackup()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
                
                if not fileexist(tfilename & ".*") then 'miramos que exista al menos uno de los 3 archivos, sino lo cargamos de la carpeta de los mapas
                    tfilename = app.path & mappath & "mapa" & map
                end if
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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
            with mapdata(map, x, y)

                '.dat file
                get freefilemap, , byflags

                if byflags and 1 then
                    .blocked = 1
                end if

                get freefilemap, , .graphic(1)

                'layer 2 used?
                if byflags and 2 then get freefilemap, , .graphic(2)

                'layer 3 used?
                if byflags and 4 then get freefilemap, , .graphic(3)

                'layer 4 used?
                if byflags and 8 then get freefilemap, , .graphic(4)

                'trigger used?
                if byflags and 16 then
                    'enums are 4 byte long in vb, so we make sure we only read 2
                    get freefilemap, , tempint
                    .trigger = tempint
                end if

                get freefileinf, , byflags

                if byflags and 1 then
                    get freefileinf, , .tileexit.map
                    get freefileinf, , .tileexit.x
                    get freefileinf, , .tileexit.y
                end if

                if byflags and 2 then
                    'get and make npc
                    get freefileinf, , .npcindex

                    if .npcindex > 0 then
                        npcfile = datpath & "npcs.dat"

                        'si el npc debe hacer respawn en la pos
                        'original la guardamos
                        if val(getvar(npcfile, "npc" & .npcindex, "posorig")) = 1 then
                            .npcindex = opennpc(.npcindex)
                            npclist(.npcindex).orig.map = map
                            npclist(.npcindex).orig.x = x
                            npclist(.npcindex).orig.y = y
                        else
                            .npcindex = opennpc(.npcindex)
                        end if

                        npclist(.npcindex).pos.map = map
                        npclist(.npcindex).pos.x = x
                        npclist(.npcindex).pos.y = y

                        call makenpcchar(true, 0, .npcindex, map, x, y)
                    end if
                end if

                if byflags and 4 then
                    'get and make object
                    get freefileinf, , .objinfo.objindex
                    get freefileinf, , .objinfo.amount
                end if
            end with
        next x
    next y


    close freefilemap
    close freefileinf

    with mapinfo(map)
        .name = getvar(mapfl & ".dat", "mapa" & map, "name")
        .music = getvar(mapfl & ".dat", "mapa" & map, "musicnum")
        .startpos.map = val(readfield(1, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
        .startpos.x = val(readfield(2, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
        .startpos.y = val(readfield(3, getvar(mapfl & ".dat", "mapa" & map, "startpos"), asc("-")))
        .magiasinefecto = val(getvar(mapfl & ".dat", "mapa" & map, "magiasinefecto"))
        .invisinefecto = val(getvar(mapfl & ".dat", "mapa" & map, "invisinefecto"))
        .resusinefecto = val(getvar(mapfl & ".dat", "mapa" & map, "resusinefecto"))
        .noencriptarmp = val(getvar(mapfl & ".dat", "mapa" & map, "noencriptarmp"))

        .robonpcspermitido = val(getvar(mapfl & ".dat", "mapa" & map, "robonpcspermitido"))
        
        if val(getvar(mapfl & ".dat", "mapa" & map, "pk")) = 0 then
            .pk = true
        else
            .pk = false
        end if

        
        .terreno = getvar(mapfl & ".dat", "mapa" & map, "terreno")
        .zona = getvar(mapfl & ".dat", "mapa" & map, "zona")
        .restringir = getvar(mapfl & ".dat", "mapa" & map, "restringir")
        .backup = val(getvar(mapfl & ".dat", "mapa" & map, "backup"))
    end with
exit sub

errh:
    call logerror("error cargando mapa: " & map & " - pos: " & x & "," & y & "." & err.description)
end sub

sub loadsini()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim temporal as long
    
    if frmmain.visible then frmmain.txstatus.caption = "cargando info de inicio del server."
    
    bootdelbackup = val(getvar(inipath & "server.ini", "init", "iniciardesdebackup"))
    
    'misc
    #if seguridadalkon then
    
    call security.setserverip(getvar(inipath & "server.ini", "init", "serverip"))
    
    #end if
    
    
    puerto = val(getvar(inipath & "server.ini", "init", "startport"))
    hideme = val(getvar(inipath & "server.ini", "init", "hide"))
    allowmultilogins = val(getvar(inipath & "server.ini", "init", "allowmultilogins"))
    idlelimit = val(getvar(inipath & "server.ini", "init", "idlelimit"))
    'lee la version correcta del cliente
    ultimaversion = getvar(inipath & "server.ini", "init", "version")
    
    puedecrearpersonajes = val(getvar(inipath & "server.ini", "init", "puedecrearpersonajes"))
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
    
    entesting = val(getvar(inipath & "server.ini", "init", "testing"))
    
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
    
    intervalopuedeseratacado = 5000 ' cargar desde balance.dat
    intervaloatacable = 60000 ' cargar desde balance.dat
    intervaloownednpc = 18000 ' cargar desde balance.dat
    
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
    
    'todo : agregar estos intervalos al form!!!
    intervalomagiagolpe = val(getvar(inipath & "server.ini", "intervalos", "intervalomagiagolpe"))
    intervalogolpemagia = val(getvar(inipath & "server.ini", "intervalos", "intervalogolpemagia"))
    intervalogolpeusar = val(getvar(inipath & "server.ini", "intervalos", "intervalogolpeusar"))
    
    frmmain.tlluvia.interval = val(getvar(inipath & "server.ini", "intervalos", "intervaloperdidastaminalluvia"))
    frminterv.txtintervaloperdidastaminalluvia.text = frmmain.tlluvia.interval
    
    minutosws = val(getvar(inipath & "server.ini", "intervalos", "intervalows"))
    if minutosws < 60 then minutosws = 180
    
    intervalocerrarconexion = val(getvar(inipath & "server.ini", "intervalos", "intervalocerrarconexion"))
    intervalouserpuedeusar = val(getvar(inipath & "server.ini", "intervalos", "intervalouserpuedeusar"))
    intervaloflechascazadores = val(getvar(inipath & "server.ini", "intervalos", "intervaloflechascazadores"))
    
    intervalooculto = val(getvar(inipath & "server.ini", "intervalos", "intervalooculto"))
    
    '&&&&&&&&&&&&&&&&&&&&& fin timers &&&&&&&&&&&&&&&&&&&&&&&
      
    recordusuarios = val(getvar(inipath & "server.ini", "init", "record"))
      
    'max users
    temporal = val(getvar(inipath & "server.ini", "init", "maxusers"))
    if maxusers = 0 then
        maxusers = temporal
        redim userlist(1 to maxusers) as user
    end if
    
    '&&&&&&&&&&&&&&&&&&&&& balance &&&&&&&&&&&&&&&&&&&&&&&
    'se agreg� en loadbalance y en el balance.dat
    'porcentajerecuperomana = val(getvar(inipath & "server.ini", "balance", "porcentajerecuperomana"))
    
    ''&&&&&&&&&&&&&&&&&&&&& fin balance &&&&&&&&&&&&&&&&&&&&&&&
    call statistics.initialize
    
    ullathorpe.map = getvar(datpath & "ciudades.dat", "ullathorpe", "mapa")
    ullathorpe.x = getvar(datpath & "ciudades.dat", "ullathorpe", "x")
    ullathorpe.y = getvar(datpath & "ciudades.dat", "ullathorpe", "y")
    
    nix.map = getvar(datpath & "ciudades.dat", "nix", "mapa")
    nix.x = getvar(datpath & "ciudades.dat", "nix", "x")
    nix.y = getvar(datpath & "ciudades.dat", "nix", "y")
    
    banderbill.map = getvar(datpath & "ciudades.dat", "banderbill", "mapa")
    banderbill.x = getvar(datpath & "ciudades.dat", "banderbill", "x")
    banderbill.y = getvar(datpath & "ciudades.dat", "banderbill", "y")
    
    lindos.map = getvar(datpath & "ciudades.dat", "lindos", "mapa")
    lindos.x = getvar(datpath & "ciudades.dat", "lindos", "x")
    lindos.y = getvar(datpath & "ciudades.dat", "lindos", "y")
    
    arghal.map = getvar(datpath & "ciudades.dat", "arghal", "mapa")
    arghal.x = getvar(datpath & "ciudades.dat", "arghal", "x")
    arghal.y = getvar(datpath & "ciudades.dat", "arghal", "y")
    
    ciudades(eciudad.cullathorpe) = ullathorpe
    ciudades(eciudad.cnix) = nix
    ciudades(eciudad.cbanderbill) = banderbill
    ciudades(eciudad.clindos) = lindos
    ciudades(eciudad.carghal) = arghal
    
    call md5scarga
    
    call consultapopular.loaddata

#if seguridadalkon then
    encriptacion.stringvalidacion = encriptacion.armarstringvalidacion
#end if

end sub

sub writevar(byval file as string, byval main as string, byval var as string, byval value as string)
'***************************************************
'author: unknown
'last modification: -
'escribe var en un archivo
'***************************************************

writeprivateprofilestring main, var, value, file
    
end sub

sub saveuser(byval userindex as integer, byval userfile as string)
'*************************************************
'author: unknown
'last modified: 12/01/2010 (zama)
'saves the users records
'23/01/2007 pablo (toxicwaste) - agrego nivelingreso, fechaingreso, matadosingreso y nextrecompensa.
'11/19/2009: pato - save the eluskills and expskills
'12/01/2010: zama - los druidas pierden la inmunidad de ser atacados cuando pierden el efecto del mimetismo.
'*************************************************

on error goto errhandler

dim olduserhead as long

with userlist(userindex)

    'esto tiene que evitar ese bugazo que no se por que graba usuarios nulos
    'clase=0 es el error, porq el enum empieza de 1!!
    if .clase = 0 or .stats.elv = 0 then
        call logcriticevent("estoy intentantdo guardar un usuario nulo de nombre: " & .name)
        exit sub
    end if
    
    
    if .flags.mimetizado = 1 then
        .char.body = .charmimetizado.body
        .char.head = .charmimetizado.head
        .char.cascoanim = .charmimetizado.cascoanim
        .char.shieldanim = .charmimetizado.shieldanim
        .char.weaponanim = .charmimetizado.weaponanim
        .counters.mimetismo = 0
        .flags.mimetizado = 0
        ' se fue el efecto del mimetismo, puede ser atacado por npcs
        .flags.ignorado = false
    end if
    
    if fileexist(userfile, vbnormal) then
        if .flags.muerto = 1 then
            olduserhead = .char.head
            .char.head = getvar(userfile, "init", "head")
        end if
    '       kill userfile
    end if
    
    dim loopc as integer
    
    
    call writevar(userfile, "flags", "muerto", cstr(.flags.muerto))
    call writevar(userfile, "flags", "escondido", cstr(.flags.escondido))
    call writevar(userfile, "flags", "hambre", cstr(.flags.hambre))
    call writevar(userfile, "flags", "sed", cstr(.flags.sed))
    call writevar(userfile, "flags", "desnudo", cstr(.flags.desnudo))
    call writevar(userfile, "flags", "ban", cstr(.flags.ban))
    call writevar(userfile, "flags", "navegando", cstr(.flags.navegando))
    call writevar(userfile, "flags", "envenenado", cstr(.flags.envenenado))
    call writevar(userfile, "flags", "paralizado", cstr(.flags.paralizado))
    'matrix
    call writevar(userfile, "flags", "lastmap", cstr(.flags.lastmap))
    
    call writevar(userfile, "consejo", "pertenece", iif(.flags.privilegios and playertype.royalcouncil, "1", "0"))
    call writevar(userfile, "consejo", "pertenececaos", iif(.flags.privilegios and playertype.chaoscouncil, "1", "0"))
    
    
    call writevar(userfile, "counters", "pena", cstr(.counters.pena))
    call writevar(userfile, "counters", "skillsasignados", cstr(.counters.asignedskills))
    
    call writevar(userfile, "facciones", "ejercitoreal", cstr(.faccion.armadareal))
    call writevar(userfile, "facciones", "ejercitocaos", cstr(.faccion.fuerzascaos))
    call writevar(userfile, "facciones", "ciudmatados", cstr(.faccion.ciudadanosmatados))
    call writevar(userfile, "facciones", "crimmatados", cstr(.faccion.criminalesmatados))
    call writevar(userfile, "facciones", "rarcaos", cstr(.faccion.recibioarmaduracaos))
    call writevar(userfile, "facciones", "rarreal", cstr(.faccion.recibioarmadurareal))
    call writevar(userfile, "facciones", "rexcaos", cstr(.faccion.recibioexpinicialcaos))
    call writevar(userfile, "facciones", "rexreal", cstr(.faccion.recibioexpinicialreal))
    call writevar(userfile, "facciones", "reccaos", cstr(.faccion.recompensascaos))
    call writevar(userfile, "facciones", "recreal", cstr(.faccion.recompensasreal))
    call writevar(userfile, "facciones", "reenlistadas", cstr(.faccion.reenlistadas))
    call writevar(userfile, "facciones", "nivelingreso", cstr(.faccion.nivelingreso))
    call writevar(userfile, "facciones", "fechaingreso", .faccion.fechaingreso)
    call writevar(userfile, "facciones", "matadosingreso", cstr(.faccion.matadosingreso))
    call writevar(userfile, "facciones", "nextrecompensa", cstr(.faccion.nextrecompensa))
    
    
    '�fueron modificados los atributos del usuario?
    if not .flags.tomopocion then
        for loopc = 1 to ubound(.stats.useratributos)
            call writevar(userfile, "atributos", "at" & loopc, cstr(.stats.useratributos(loopc)))
        next loopc
    else
        for loopc = 1 to ubound(.stats.useratributos)
            '.stats.useratributos(loopc) = .stats.useratributosbackup(loopc)
            call writevar(userfile, "atributos", "at" & loopc, cstr(.stats.useratributosbackup(loopc)))
        next loopc
    end if
    
    for loopc = 1 to ubound(.stats.userskills)
        call writevar(userfile, "skills", "sk" & loopc, cstr(.stats.userskills(loopc)))
        call writevar(userfile, "skills", "elusk" & loopc, cstr(.stats.eluskills(loopc)))
        call writevar(userfile, "skills", "expsk" & loopc, cstr(.stats.expskills(loopc)))
    next loopc
    
    
    call writevar(userfile, "contacto", "email", .email)
    
    call writevar(userfile, "init", "genero", .genero)
    call writevar(userfile, "init", "raza", .raza)
    call writevar(userfile, "init", "hogar", .hogar)
    call writevar(userfile, "init", "clase", .clase)
    call writevar(userfile, "init", "desc", .desc)
    
    call writevar(userfile, "init", "heading", cstr(.char.heading))
    
    call writevar(userfile, "init", "head", cstr(.origchar.head))
    
    if .flags.muerto = 0 then
        call writevar(userfile, "init", "body", cstr(.char.body))
    end if
    
    call writevar(userfile, "init", "arma", cstr(.char.weaponanim))
    call writevar(userfile, "init", "escudo", cstr(.char.shieldanim))
    call writevar(userfile, "init", "casco", cstr(.char.cascoanim))
    
    #if conuptime then
        dim tempdate as date
        tempdate = now - .logontime
        .logontime = now
        .uptime = .uptime + (abs(day(tempdate) - 30) * 24 * 3600) + hour(tempdate) * 3600 + minute(tempdate) * 60 + second(tempdate)
        .uptime = .uptime
        call writevar(userfile, "init", "uptime", .uptime)
    #end if
    
    'first time around?
    if getvar(userfile, "init", "lastip1") = vbnullstring then
        call writevar(userfile, "init", "lastip1", .ip & " - " & date & ":" & time)
    'is it a different ip from last time?
    elseif .ip <> left$(getvar(userfile, "init", "lastip1"), instr(1, getvar(userfile, "init", "lastip1"), " ") - 1) then
        dim i as integer
        for i = 5 to 2 step -1
            call writevar(userfile, "init", "lastip" & i, getvar(userfile, "init", "lastip" & cstr(i - 1)))
        next i
        call writevar(userfile, "init", "lastip1", .ip & " - " & date & ":" & time)
    'same ip, just update the date
    else
        call writevar(userfile, "init", "lastip1", .ip & " - " & date & ":" & time)
    end if
    
    
    
    call writevar(userfile, "init", "position", .pos.map & "-" & .pos.x & "-" & .pos.y)
    
    
    call writevar(userfile, "stats", "gld", cstr(.stats.gld))
    call writevar(userfile, "stats", "banco", cstr(.stats.banco))
    
    call writevar(userfile, "stats", "maxhp", cstr(.stats.maxhp))
    call writevar(userfile, "stats", "minhp", cstr(.stats.minhp))
    
    call writevar(userfile, "stats", "maxsta", cstr(.stats.maxsta))
    call writevar(userfile, "stats", "minsta", cstr(.stats.minsta))
    
    call writevar(userfile, "stats", "maxman", cstr(.stats.maxman))
    call writevar(userfile, "stats", "minman", cstr(.stats.minman))
    
    call writevar(userfile, "stats", "maxhit", cstr(.stats.maxhit))
    call writevar(userfile, "stats", "minhit", cstr(.stats.minhit))
    
    call writevar(userfile, "stats", "maxagu", cstr(.stats.maxagu))
    call writevar(userfile, "stats", "minagu", cstr(.stats.minagu))
    
    call writevar(userfile, "stats", "maxham", cstr(.stats.maxham))
    call writevar(userfile, "stats", "minham", cstr(.stats.minham))
    
    call writevar(userfile, "stats", "skillptslibres", cstr(.stats.skillpts))
      
    call writevar(userfile, "stats", "exp", cstr(.stats.exp))
    call writevar(userfile, "stats", "elv", cstr(.stats.elv))
    
    
    call writevar(userfile, "stats", "elu", cstr(.stats.elu))
    call writevar(userfile, "muertes", "usermuertes", cstr(.stats.usuariosmatados))
    'call writevar(userfile, "muertes", "crimmuertes", cstr(.stats.criminalesmatados))
    call writevar(userfile, "muertes", "npcsmuertes", cstr(.stats.npcsmuertos))
      
    '[kevin]----------------------------------------------------------------------------
    '*******************************************************************************************
    call writevar(userfile, "bancoinventory", "cantidaditems", val(.bancoinvent.nroitems))
    dim loopd as integer
    for loopd = 1 to max_bancoinventory_slots
        call writevar(userfile, "bancoinventory", "obj" & loopd, .bancoinvent.object(loopd).objindex & "-" & .bancoinvent.object(loopd).amount)
    next loopd
    '*******************************************************************************************
    '[/kevin]-----------
      
    'save inv
    call writevar(userfile, "inventory", "cantidaditems", val(.invent.nroitems))
    
    for loopc = 1 to max_inventory_slots
        call writevar(userfile, "inventory", "obj" & loopc, .invent.object(loopc).objindex & "-" & .invent.object(loopc).amount & "-" & .invent.object(loopc).equipped)
    next loopc
    
    call writevar(userfile, "inventory", "weaponeqpslot", cstr(.invent.weaponeqpslot))
    call writevar(userfile, "inventory", "armoureqpslot", cstr(.invent.armoureqpslot))
    call writevar(userfile, "inventory", "cascoeqpslot", cstr(.invent.cascoeqpslot))
    call writevar(userfile, "inventory", "escudoeqpslot", cstr(.invent.escudoeqpslot))
    call writevar(userfile, "inventory", "barcoslot", cstr(.invent.barcoslot))
    call writevar(userfile, "inventory", "municionslot", cstr(.invent.municioneqpslot))
    call writevar(userfile, "inventory", "mochilaslot", cstr(.invent.mochilaeqpslot))
    '/nacho
    
    call writevar(userfile, "inventory", "anilloslot", cstr(.invent.anilloeqpslot))
    
    
    'reputacion
    call writevar(userfile, "rep", "asesino", cstr(.reputacion.asesinorep))
    call writevar(userfile, "rep", "bandido", cstr(.reputacion.bandidorep))
    call writevar(userfile, "rep", "burguesia", cstr(.reputacion.burguesrep))
    call writevar(userfile, "rep", "ladrones", cstr(.reputacion.ladronesrep))
    call writevar(userfile, "rep", "nobles", cstr(.reputacion.noblerep))
    call writevar(userfile, "rep", "plebe", cstr(.reputacion.pleberep))
    
    dim l as long
    l = (-.reputacion.asesinorep) + _
        (-.reputacion.bandidorep) + _
        .reputacion.burguesrep + _
        (-.reputacion.ladronesrep) + _
        .reputacion.noblerep + _
        .reputacion.pleberep
    l = l / 6
    call writevar(userfile, "rep", "promedio", cstr(l))
    
    dim cad as string
    
    for loopc = 1 to maxuserhechizos
        cad = .stats.userhechizos(loopc)
        call writevar(userfile, "hechizos", "h" & loopc, cad)
    next
    
    dim nromascotas as long
    nromascotas = .nromascotas
    
    for loopc = 1 to maxmascotas
        ' mascota valida?
        if .mascotasindex(loopc) > 0 then
            ' nos aseguramos que la criatura no fue invocada
            if npclist(.mascotasindex(loopc)).contadores.tiempoexistencia = 0 then
                cad = .mascotastype(loopc)
            else 'si fue invocada no la guardamos
                cad = "0"
                nromascotas = nromascotas - 1
            end if
            call writevar(userfile, "mascotas", "mas" & loopc, cad)
        else
            cad = .mascotastype(loopc)
            call writevar(userfile, "mascotas", "mas" & loopc, cad)
        end if
    
    next
    
    call writevar(userfile, "mascotas", "nromascotas", cstr(nromascotas))
    
    'devuelve el head de muerto
    if .flags.muerto = 1 then
        .char.head = icabezamuerto
    end if
end with

exit sub

errhandler:
call logerror("error en saveuser")

end sub

function criminal(byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim l as long
    
    with userlist(userindex).reputacion
        l = (-.asesinorep) + _
            (-.bandidorep) + _
            .burguesrep + _
            (-.ladronesrep) + _
            .noblerep + _
            .pleberep
        l = l / 6
        criminal = (l < 0)
    end with

end function

sub backupnpc(npcindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim npcnumero as integer
    dim npcfile as string
    dim loopc as integer
    
    
    npcnumero = npclist(npcindex).numero
    
    'if npcnumero > 499 then
    '    npcfile = datpath & "bknpcs-hostiles.dat"
    'else
        npcfile = datpath & "bknpcs.dat"
    'end if
    
    with npclist(npcindex)
        'general
        call writevar(npcfile, "npc" & npcnumero, "name", .name)
        call writevar(npcfile, "npc" & npcnumero, "desc", .desc)
        call writevar(npcfile, "npc" & npcnumero, "head", val(.char.head))
        call writevar(npcfile, "npc" & npcnumero, "body", val(.char.body))
        call writevar(npcfile, "npc" & npcnumero, "heading", val(.char.heading))
        call writevar(npcfile, "npc" & npcnumero, "movement", val(.movement))
        call writevar(npcfile, "npc" & npcnumero, "attackable", val(.attackable))
        call writevar(npcfile, "npc" & npcnumero, "comercia", val(.comercia))
        call writevar(npcfile, "npc" & npcnumero, "tipoitems", val(.tipoitems))
        call writevar(npcfile, "npc" & npcnumero, "hostil", val(.hostile))
        call writevar(npcfile, "npc" & npcnumero, "giveexp", val(.giveexp))
        call writevar(npcfile, "npc" & npcnumero, "givegld", val(.givegld))
        call writevar(npcfile, "npc" & npcnumero, "hostil", val(.hostile))
        call writevar(npcfile, "npc" & npcnumero, "invrespawn", val(.invrespawn))
        call writevar(npcfile, "npc" & npcnumero, "npctype", val(.npctype))
        
        
        'stats
        call writevar(npcfile, "npc" & npcnumero, "alineacion", val(.stats.alineacion))
        call writevar(npcfile, "npc" & npcnumero, "def", val(.stats.def))
        call writevar(npcfile, "npc" & npcnumero, "maxhit", val(.stats.maxhit))
        call writevar(npcfile, "npc" & npcnumero, "maxhp", val(.stats.maxhp))
        call writevar(npcfile, "npc" & npcnumero, "minhit", val(.stats.minhit))
        call writevar(npcfile, "npc" & npcnumero, "minhp", val(.stats.minhp))
        
        
        
        
        'flags
        call writevar(npcfile, "npc" & npcnumero, "respawn", val(.flags.respawn))
        call writevar(npcfile, "npc" & npcnumero, "backup", val(.flags.backup))
        call writevar(npcfile, "npc" & npcnumero, "domable", val(.flags.domable))
        
        'inventario
        call writevar(npcfile, "npc" & npcnumero, "nroitems", val(.invent.nroitems))
        if .invent.nroitems > 0 then
           for loopc = 1 to max_inventory_slots
                call writevar(npcfile, "npc" & npcnumero, "obj" & loopc, .invent.object(loopc).objindex & "-" & .invent.object(loopc).amount)
           next loopc
        end if
    end with

end sub

sub cargarnpcbackup(npcindex as integer, byval npcnumber as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'status
    if frmmain.visible then frmmain.txstatus.caption = "cargando backup npc"
    
    dim npcfile as string
    
    'if npcnumber > 499 then
    '    npcfile = datpath & "bknpcs-hostiles.dat"
    'else
        npcfile = datpath & "bknpcs.dat"
    'end if
    
    with npclist(npcindex)
    
        .numero = npcnumber
        .name = getvar(npcfile, "npc" & npcnumber, "name")
        .desc = getvar(npcfile, "npc" & npcnumber, "desc")
        .movement = val(getvar(npcfile, "npc" & npcnumber, "movement"))
        .npctype = val(getvar(npcfile, "npc" & npcnumber, "npctype"))
        
        .char.body = val(getvar(npcfile, "npc" & npcnumber, "body"))
        .char.head = val(getvar(npcfile, "npc" & npcnumber, "head"))
        .char.heading = val(getvar(npcfile, "npc" & npcnumber, "heading"))
        
        .attackable = val(getvar(npcfile, "npc" & npcnumber, "attackable"))
        .comercia = val(getvar(npcfile, "npc" & npcnumber, "comercia"))
        .hostile = val(getvar(npcfile, "npc" & npcnumber, "hostile"))
        .giveexp = val(getvar(npcfile, "npc" & npcnumber, "giveexp"))
        
        
        .givegld = val(getvar(npcfile, "npc" & npcnumber, "givegld"))
        
        .invrespawn = val(getvar(npcfile, "npc" & npcnumber, "invrespawn"))
        
        .stats.maxhp = val(getvar(npcfile, "npc" & npcnumber, "maxhp"))
        .stats.minhp = val(getvar(npcfile, "npc" & npcnumber, "minhp"))
        .stats.maxhit = val(getvar(npcfile, "npc" & npcnumber, "maxhit"))
        .stats.minhit = val(getvar(npcfile, "npc" & npcnumber, "minhit"))
        .stats.def = val(getvar(npcfile, "npc" & npcnumber, "def"))
        .stats.alineacion = val(getvar(npcfile, "npc" & npcnumber, "alineacion"))
        
        
        
        dim loopc as integer
        dim ln as string
        .invent.nroitems = val(getvar(npcfile, "npc" & npcnumber, "nroitems"))
        if .invent.nroitems > 0 then
            for loopc = 1 to max_inventory_slots
                ln = getvar(npcfile, "npc" & npcnumber, "obj" & loopc)
                .invent.object(loopc).objindex = val(readfield(1, ln, 45))
                .invent.object(loopc).amount = val(readfield(2, ln, 45))
               
            next loopc
        else
            for loopc = 1 to max_inventory_slots
                .invent.object(loopc).objindex = 0
                .invent.object(loopc).amount = 0
            next loopc
        end if
        
        for loopc = 1 to max_npc_drops
            ln = getvar(npcfile, "npc" & npcnumber, "drop" & loopc)
            .drop(loopc).objindex = val(readfield(1, ln, 45))
            .drop(loopc).amount = val(readfield(2, ln, 45))
        next loopc
        
        .flags.npcactive = true
        .flags.respawn = val(getvar(npcfile, "npc" & npcnumber, "respawn"))
        .flags.backup = val(getvar(npcfile, "npc" & npcnumber, "backup"))
        .flags.domable = val(getvar(npcfile, "npc" & npcnumber, "domable"))
        .flags.respawnorigpos = val(getvar(npcfile, "npc" & npcnumber, "origpos"))
        
        'tipo de items con los que comercia
        .tipoitems = val(getvar(npcfile, "npc" & npcnumber, "tipoitems"))
    end with

end sub


sub logban(byval bannedindex as integer, byval userindex as integer, byval motivo as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    apuestas.ganancias = val(getvar(datpath & "apuestas.dat", "main", "ganancias"))
    apuestas.perdidas = val(getvar(datpath & "apuestas.dat", "main", "perdidas"))
    apuestas.jugadas = val(getvar(datpath & "apuestas.dat", "main", "jugadas"))

end sub

public sub generatematrix(byval mapa as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i as integer
dim j as integer
dim x as integer
dim y as integer

redim distancetocities(1 to nummaps) as homedistance

for j = 1 to numciudades
    for i = 1 to nummaps
        distancetocities(i).distancetocity(j) = -1
    next i
next j

for j = 1 to numciudades
    for i = 1 to 4
        select case i
            case eheading.north
                call setdistance(getlimit(ciudades(j).map, eheading.north), j, i, 0, 1)
            case eheading.east
                call setdistance(getlimit(ciudades(j).map, eheading.east), j, i, 1, 0)
            case eheading.south
                call setdistance(getlimit(ciudades(j).map, eheading.south), j, i, 0, 1)
            case eheading.west
                call setdistance(getlimit(ciudades(j).map, eheading.west), j, i, -1, 0)
        end select
    next i
next j

end sub

public sub setdistance(byval mapa as integer, byval city as byte, byval side as integer, optional byval x as integer = 0, optional byval y as integer = 0)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i as integer
dim lim as integer

if mapa <= 0 or mapa > nummaps then exit sub

if distancetocities(mapa).distancetocity(city) >= 0 then exit sub

if mapa = ciudades(city).map then
    distancetocities(mapa).distancetocity(city) = 0
else
    distancetocities(mapa).distancetocity(city) = abs(x) + abs(y)
end if

for i = 1 to 4
    lim = getlimit(mapa, i)
    if lim > 0 then
        select case i
            case eheading.north
                call setdistance(lim, city, i, x, y + 1)
            case eheading.east
                call setdistance(lim, city, i, x + 1, y)
            case eheading.south
                call setdistance(lim, city, i, x, y - 1)
            case eheading.west
                call setdistance(lim, city, i, x - 1, y)
        end select
    end if
next i
end sub

public function getlimit(byval mapa as integer, byval side as byte) as integer
'***************************************************
'author: budi
'last modification: 31/01/2010
'retrieves the limit in the given side in the given map.
'todo: this should be set in the .inf map file.
'***************************************************
dim i, x, y as integer

if mapa <= 0 then exit function

for x = 15 to 87
    for y = 0 to 3
        select case side
            case eheading.north
                getlimit = mapdata(mapa, x, 7 + y).tileexit.map
            case eheading.east
                getlimit = mapdata(mapa, 92 - y, x).tileexit.map
            case eheading.south
                getlimit = mapdata(mapa, x, 94 - y).tileexit.map
            case eheading.west
                getlimit = mapdata(mapa, 9 + y, x).tileexit.map
        end select
        if getlimit > 0 then exit function
    next y
next x
end function


public sub loadarmadurasfaccion()
'***************************************************
'author: zama
'last modification: 15/04/2010
'
'***************************************************
    dim classindex as long
    dim raceindex as long
    
    dim armaduraindex as integer
    
    
    for classindex = 1 to numclases
    
        ' defensa minima para armadas altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defminarmyalto"))
        
        armadurasfaccion(classindex, eraza.drow).armada(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).armada(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).armada(etipodefarmors.iebaja) = armaduraindex
        
        ' defensa minima para armadas bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defminarmybajo"))
        
        armadurasfaccion(classindex, eraza.enano).armada(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).armada(etipodefarmors.iebaja) = armaduraindex
        
        ' defensa minima para caos altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmincaosalto"))
        
        armadurasfaccion(classindex, eraza.drow).caos(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).caos(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).caos(etipodefarmors.iebaja) = armaduraindex
        
        ' defensa minima para caos bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmincaosbajo"))
        
        armadurasfaccion(classindex, eraza.enano).caos(etipodefarmors.iebaja) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).caos(etipodefarmors.iebaja) = armaduraindex
    
    
        ' defensa media para armadas altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmedarmyalto"))
        
        armadurasfaccion(classindex, eraza.drow).armada(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).armada(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).armada(etipodefarmors.iemedia) = armaduraindex
        
        ' defensa media para armadas bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmedarmybajo"))
        
        armadurasfaccion(classindex, eraza.enano).armada(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).armada(etipodefarmors.iemedia) = armaduraindex
        
        ' defensa media para caos altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmedcaosalto"))
        
        armadurasfaccion(classindex, eraza.drow).caos(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).caos(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).caos(etipodefarmors.iemedia) = armaduraindex
        
        ' defensa media para caos bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defmedcaosbajo"))
        
        armadurasfaccion(classindex, eraza.enano).caos(etipodefarmors.iemedia) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).caos(etipodefarmors.iemedia) = armaduraindex
    
    
        ' defensa alta para armadas altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defaltaarmyalto"))
        
        armadurasfaccion(classindex, eraza.drow).armada(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).armada(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).armada(etipodefarmors.iealta) = armaduraindex
        
        ' defensa alta para armadas bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defaltaarmybajo"))
        
        armadurasfaccion(classindex, eraza.enano).armada(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).armada(etipodefarmors.iealta) = armaduraindex
        
        ' defensa alta para caos altos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defaltacaosalto"))
        
        armadurasfaccion(classindex, eraza.drow).caos(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.elfo).caos(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.humano).caos(etipodefarmors.iealta) = armaduraindex
        
        ' defensa alta para caos bajos
        armaduraindex = val(getvar(datpath & "armadurasfaccionarias.dat", "clase" & classindex, "defaltacaosbajo"))
        
        armadurasfaccion(classindex, eraza.enano).caos(etipodefarmors.iealta) = armaduraindex
        armadurasfaccion(classindex, eraza.gnomo).caos(etipodefarmors.iealta) = armaduraindex
    
    next classindex
    
end sub

