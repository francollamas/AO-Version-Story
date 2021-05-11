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

function esadmin(byref name as string) as boolean
'***************************************************
'author: unknown
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    esadmin = (val(administradores.getvalue("admin", name)) = 1)
end function

function esdios(byref name as string) as boolean
'***************************************************
'author: unknown
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    esdios = (val(administradores.getvalue("dios", name)) = 1)
end function

function essemidios(byref name as string) as boolean
'***************************************************
'author: unknown
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    essemidios = (val(administradores.getvalue("semidios", name)) = 1)
end function

function esgmespecial(byref name as string) as boolean
'***************************************************
'author: zama
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    esgmespecial = (val(administradores.getvalue("especial", name)) = 1)
end function

function esconsejero(byref name as string) as boolean
'***************************************************
'author: unknown
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    esconsejero = (val(administradores.getvalue("consejero", name)) = 1)
end function

function esrolesmaster(byref name as string) as boolean
'***************************************************
'author: unknown
'last modification: 27/03/2011
'27/03/2011 - zama: utilizo la clase para saber los datos.
'***************************************************
    esrolesmaster = (val(administradores.getvalue("rm", name)) = 1)
end function

public function esgmchar(byref name as string) as boolean
'***************************************************
'author: zama
'last modification: 27/03/2011
'returns true if char is administrative user.
'***************************************************
    
    dim esgm as boolean
    
    ' admin?
    esgm = esadmin(name)
    ' dios?
    if not esgm then esgm = esdios(name)
    ' semidios?
    if not esgm then esgm = essemidios(name)
    ' consejero?
    if not esgm then esgm = esconsejero(name)

    esgmchar = esgm

end function


public sub loadadministrativeusers()
'admines     => admin
'dioses      => dios
'semidioses  => semidios
'especiales  => especial
'consejeros  => consejero
'rolemasters => rm

    'si esta mierda tuviese array asociativos el c�digo ser�a tan lindo.
    dim buf as integer
    dim i as long
    dim name as string
       
    ' public container
    set administradores = new clsinimanager
    
    ' server ini info file
    dim serverini as clsinimanager
    set serverini = new clsinimanager
    
    call serverini.initialize(inipath & "server.ini")
    
       
    ' admines
    buf = val(serverini.getvalue("init", "admines"))
    
    for i = 1 to buf
        name = ucase$(serverini.getvalue("admines", "admin" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("admin", name, "1")

    next i
    
    ' dioses
    buf = val(serverini.getvalue("init", "dioses"))
    
    for i = 1 to buf
        name = ucase$(serverini.getvalue("dioses", "dios" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("dios", name, "1")
        
    next i
    
    ' especiales
    buf = val(serverini.getvalue("init", "especiales"))
    
    for i = 1 to buf
        name = ucase$(serverini.getvalue("especiales", "especial" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("especial", name, "1")
        
    next i
    
    ' semidioses
    buf = val(serverini.getvalue("init", "semidioses"))
    
    for i = 1 to buf
        name = ucase$(serverini.getvalue("semidioses", "semidios" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("semidios", name, "1")
        
    next i
    
    ' consejeros
    buf = val(serverini.getvalue("init", "consejeros"))
        
    for i = 1 to buf
        name = ucase$(serverini.getvalue("consejeros", "consejero" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("consejero", name, "1")
        
    next i
    
    ' rolesmasters
    buf = val(serverini.getvalue("init", "rolesmasters"))
        
    for i = 1 to buf
        name = ucase$(serverini.getvalue("rolesmasters", "rm" & i))
        
        if left$(name, 1) = "*" or left$(name, 1) = "+" then name = right$(name, len(name) - 1)
        
        ' add key
        call administradores.changevalue("rm", name, "1")
    next i
    
    set serverini = nothing
    
end sub

public function getcharprivs(byref username as string) as playertype
'****************************************************
'author: zama
'last modification: 18/11/2010
'reads the user's charfile and retrieves its privs.
'***************************************************

    dim privs as playertype

    if esadmin(username) then
        privs = playertype.admin
        
    elseif esdios(username) then
        privs = playertype.dios

    elseif essemidios(username) then
        privs = playertype.semidios
        
    elseif esconsejero(username) then
        privs = playertype.consejero
    
    else
        privs = playertype.user
    end if

    getcharprivs = privs

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
    dim leer as clsinimanager
    set leer = new clsinimanager
    
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
    'call resetcentinelainfo     'reseteamos al centinela 'lo saco porque ahora el reset lo maneja el modcentinela [c4b3z0n]
    
    
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

public sub grabarmapa(byval map as long, byref mapfile as string)
'***************************************************
'author: unknown
'last modification: 12/01/2011
'10/08/2010 - pato: implemento el clsbytebuffer para el grabado de mapas
'28/10/2010:zama - ahora no se hace backup de los pretorianos.
'12/01/2011 - amraphen: ahora no se hace backup de npcs prohibidos (pretorianos, mascotas, invocados y centinela)
'***************************************************

on error resume next
    dim freefilemap as long
    dim freefileinf as long
    dim y as long
    dim x as long
    dim byflags as byte
    dim loopc as long
    dim mapwriter as clsbytebuffer
    dim infwriter as clsbytebuffer
    dim inimanager as clsinimanager
    dim npcinvalido as boolean
    
    set mapwriter = new clsbytebuffer
    set infwriter = new clsbytebuffer
    set inimanager = new clsinimanager
    
    if fileexist(mapfile & ".map", vbnormal) then
        kill mapfile & ".map"
    end if
    
    if fileexist(mapfile & ".inf", vbnormal) then
        kill mapfile & ".inf"
    end if
    
    'open .map file
    freefilemap = freefile
    open mapfile & ".map" for binary as freefilemap
    
    call mapwriter.initializewriter(freefilemap)
    
    'open .inf file
    freefileinf = freefile
    open mapfile & ".inf" for binary as freefileinf
    
    call infwriter.initializewriter(freefileinf)
    
    'map header
    call mapwriter.putinteger(mapinfo(map).mapversion)
        
    call mapwriter.putstring(micabecera.desc, false)
    call mapwriter.putlong(micabecera.crc)
    call mapwriter.putlong(micabecera.magicword)
    
    call mapwriter.putdouble(0)
    
    'inf header
    call infwriter.putdouble(0)
    call infwriter.putinteger(0)
    
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
                
                call mapwriter.putbyte(byflags)
                
                call mapwriter.putinteger(.graphic(1))
                
                for loopc = 2 to 4
                    if .graphic(loopc) then _
                        call mapwriter.putinteger(.graphic(loopc))
                next loopc
                
                if .trigger then _
                    call mapwriter.putinteger(cint(.trigger))
                
                '.inf file
                byflags = 0
                
                if .objinfo.objindex > 0 then
                   if objdata(.objinfo.objindex).objtype = eobjtype.otfogata then
                        .objinfo.objindex = 0
                        .objinfo.amount = 0
                    end if
                end if
    
                if .tileexit.map then byflags = byflags or 1
                
                ' no hacer backup de los npcs inv�lidos (pretorianos, mascotas, invocados y centinela)
                if .npcindex then
                    npcinvalido = (npclist(.npcindex).npctype = enpctype.pretoriano) or (npclist(.npcindex).maestrouser > 0) or escentinela(.npcindex)
                    
                    if not npcinvalido then byflags = byflags or 2
                end if
                
                if .objinfo.objindex then byflags = byflags or 4
                
                call infwriter.putbyte(byflags)
                
                if .tileexit.map then
                    call infwriter.putinteger(.tileexit.map)
                    call infwriter.putinteger(.tileexit.x)
                    call infwriter.putinteger(.tileexit.y)
                end if
                
                if .npcindex and not npcinvalido then _
                    call infwriter.putinteger(npclist(.npcindex).numero)
                
                if .objinfo.objindex then
                    call infwriter.putinteger(.objinfo.objindex)
                    call infwriter.putinteger(.objinfo.amount)
                end if
                
                npcinvalido = false
            end with
        next x
    next y
    
    call mapwriter.savebuffer
    call infwriter.savebuffer
    
    'close .map file
    close freefilemap

    'close .inf file
    close freefileinf
    
    set mapwriter = nothing
    set infwriter = nothing

    with mapinfo(map)
        'write .dat file
        call inimanager.changevalue("mapa" & map, "name", .name)
        call inimanager.changevalue("mapa" & map, "musicnum", .music)
        call inimanager.changevalue("mapa" & map, "magiasinefecto", .magiasinefecto)
        call inimanager.changevalue("mapa" & map, "invisinefecto", .invisinefecto)
        call inimanager.changevalue("mapa" & map, "resusinefecto", .resusinefecto)
        call inimanager.changevalue("mapa" & map, "startpos", .startpos.map & "-" & .startpos.x & "-" & .startpos.y)
        call inimanager.changevalue("mapa" & map, "ondeathgoto", .ondeathgoto.map & "-" & .ondeathgoto.x & "-" & .ondeathgoto.y)

    
        call inimanager.changevalue("mapa" & map, "terreno", terrainbytetostring(.terreno))
        call inimanager.changevalue("mapa" & map, "zona", .zona)
        call inimanager.changevalue("mapa" & map, "restringir", restrictbytetostring(.restringir))
        call inimanager.changevalue("mapa" & map, "backup", str(.backup))
    
        if .pk then
            call inimanager.changevalue("mapa" & map, "pk", "0")
        else
            call inimanager.changevalue("mapa" & map, "pk", "1")
        end if
        
        call inimanager.changevalue("mapa" & map, "ocultarsinefecto", .ocultarsinefecto)
        call inimanager.changevalue("mapa" & map, "invocarsinefecto", .invocarsinefecto)
        call inimanager.changevalue("mapa" & map, "noencriptarmp", .noencriptarmp)
        call inimanager.changevalue("mapa" & map, "robonpcspermitido", .robonpcspermitido)
    
        call inimanager.dumpfile(mapfile & ".dat")
    end with
    
    set inimanager = nothing
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
    dim leer as clsinimanager
    set leer = new clsinimanager
    
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

sub loaduserstats(byval userindex as integer, byref userfile as clsinimanager)
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
            .userskills(loopc) = val(userfile.getvalue("skills", "sk" & loopc))
            .eluskills(loopc) = val(userfile.getvalue("skills", "elusk" & loopc))
            .expskills(loopc) = val(userfile.getvalue("skills", "expsk" & loopc))
        next loopc
        
        for loopc = 1 to maxuserhechizos
            .userhechizos(loopc) = val(userfile.getvalue("hechizos", "h" & loopc))
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

sub loaduserreputacion(byval userindex as integer, byref userfile as clsinimanager)
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

sub loaduserinit(byval userindex as integer, byref userfile as clsinimanager)
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
            .lastmap = val(userfile.getvalue("flags", "lastmap"))
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
            .invent.object(loopc).objindex = val(readfield(1, ln, 45))
            .invent.object(loopc).amount = val(readfield(2, ln, 45))
            .invent.object(loopc).equipped = val(readfield(3, ln, 45))
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
        
        .invent.mochilaeqpslot = val(userfile.getvalue("inventory", "mochilaslot"))
        if .invent.mochilaeqpslot > 0 then
            .invent.mochilaeqpobjindex = .invent.object(.invent.mochilaeqpslot).objindex
        end if
        
        .nromascotas = cint(userfile.getvalue("mascotas", "nromascotas"))
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
    dim tfilename as string
    
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
    dim tfilename as string
    
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

public sub cargarmapa(byval map as long, byref mapfl as string)
'***************************************************
'author: unknown
'last modification: 10/08/2010
'10/08/2010 - pato: implemento el clsbytebuffer y el clsinimanager para la carga de mapa
'***************************************************

on error goto errh
    dim hfile as integer
    dim x as long
    dim y as long
    dim byflags as byte
    dim npcfile as string
    dim leer as clsinimanager
    dim mapreader as clsbytebuffer
    dim infreader as clsbytebuffer
    dim buff() as byte
    
    set mapreader = new clsbytebuffer
    set infreader = new clsbytebuffer
    set leer = new clsinimanager
    
    npcfile = datpath & "npcs.dat"
    
    hfile = freefile

    open mapfl & ".map" for binary as #hfile
        seek hfile, 1

        redim buff(lof(hfile) - 1) as byte
    
        get #hfile, , buff
    close hfile
    
    call mapreader.initializereader(buff)

    'inf
    open mapfl & ".inf" for binary as #hfile
        seek hfile, 1

        redim buff(lof(hfile) - 1) as byte
    
        get #hfile, , buff
    close hfile
    
    call infreader.initializereader(buff)
    
    'map header
    mapinfo(map).mapversion = mapreader.getinteger
    
    micabecera.desc = mapreader.getstring(len(micabecera.desc))
    micabecera.crc = mapreader.getlong
    micabecera.magicword = mapreader.getlong
    
    call mapreader.getdouble

    'inf header
    call infreader.getdouble
    call infreader.getinteger

    for y = yminmapsize to ymaxmapsize
        for x = xminmapsize to xmaxmapsize
            with mapdata(map, x, y)
                '.map file
                byflags = mapreader.getbyte

                if byflags and 1 then .blocked = 1

                .graphic(1) = mapreader.getinteger

                'layer 2 used?
                if byflags and 2 then .graphic(2) = mapreader.getinteger

                'layer 3 used?
                if byflags and 4 then .graphic(3) = mapreader.getinteger

                'layer 4 used?
                if byflags and 8 then .graphic(4) = mapreader.getinteger

                'trigger used?
                if byflags and 16 then .trigger = mapreader.getinteger

                '.inf file
                byflags = infreader.getbyte

                if byflags and 1 then
                    .tileexit.map = infreader.getinteger
                    .tileexit.x = infreader.getinteger
                    .tileexit.y = infreader.getinteger
                end if

                if byflags and 2 then
                    'get and make npc
                     .npcindex = infreader.getinteger

                    if .npcindex > 0 then
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
                    .objinfo.objindex = infreader.getinteger
                    .objinfo.amount = infreader.getinteger
                end if
            end with
        next x
    next y
    
    call leer.initialize(mapfl & ".dat")
    
    with mapinfo(map)
        .name = leer.getvalue("mapa" & map, "name")
        .music = leer.getvalue("mapa" & map, "musicnum")
        .startpos.map = val(readfield(1, leer.getvalue("mapa" & map, "startpos"), asc("-")))
        .startpos.x = val(readfield(2, leer.getvalue("mapa" & map, "startpos"), asc("-")))
        .startpos.y = val(readfield(3, leer.getvalue("mapa" & map, "startpos"), asc("-")))
        
        .ondeathgoto.map = val(readfield(1, leer.getvalue("mapa" & map, "ondeathgoto"), asc("-")))
        .ondeathgoto.x = val(readfield(2, leer.getvalue("mapa" & map, "ondeathgoto"), asc("-")))
        .ondeathgoto.y = val(readfield(3, leer.getvalue("mapa" & map, "ondeathgoto"), asc("-")))
        
        .magiasinefecto = val(leer.getvalue("mapa" & map, "magiasinefecto"))
        .invisinefecto = val(leer.getvalue("mapa" & map, "invisinefecto"))
        .resusinefecto = val(leer.getvalue("mapa" & map, "resusinefecto"))
        .ocultarsinefecto = val(leer.getvalue("mapa" & map, "ocultarsinefecto"))
        .invocarsinefecto = val(leer.getvalue("mapa" & map, "invocarsinefecto"))
        
        .noencriptarmp = val(leer.getvalue("mapa" & map, "noencriptarmp"))

        .robonpcspermitido = val(leer.getvalue("mapa" & map, "robonpcspermitido"))
        
        if val(leer.getvalue("mapa" & map, "pk")) = 0 then
            .pk = true
        else
            .pk = false
        end if
        
        .terreno = terrainstringtobyte(leer.getvalue("mapa" & map, "terreno"))
        .zona = leer.getvalue("mapa" & map, "zona")
        .restringir = restrictstringtobyte(leer.getvalue("mapa" & map, "restringir"))
        .backup = val(leer.getvalue("mapa" & map, "backup"))
    end with
    
    set mapreader = nothing
    set infreader = nothing
    set leer = nothing
    
    erase buff
exit sub

errh:
    call logerror("error cargando mapa: " & map & " - pos: " & x & "," & y & "." & err.description)

    set mapreader = nothing
    set infreader = nothing
    set leer = nothing
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
    
    minutosguardarusuarios = val(getvar(inipath & "server.ini", "intervalos", "intervaloguardarusuarios"))
    
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
    
    arkhein.map = getvar(datpath & "ciudades.dat", "arkhein", "mapa")
    arkhein.x = getvar(datpath & "ciudades.dat", "arkhein", "x")
    arkhein.y = getvar(datpath & "ciudades.dat", "arkhein", "y")
    
    nemahuak.map = getvar(datpath & "ciudades.dat", "nemahuak", "mapa")
    nemahuak.x = getvar(datpath & "ciudades.dat", "nemahuak", "x")
    nemahuak.y = getvar(datpath & "ciudades.dat", "nemahuak", "y")

    
    ciudades(eciudad.cullathorpe) = ullathorpe
    ciudades(eciudad.cnix) = nix
    ciudades(eciudad.cbanderbill) = banderbill
    ciudades(eciudad.clindos) = lindos
    ciudades(eciudad.carghal) = arghal
    ciudades(eciudad.carkhein) = arkhein
    
    call md5scarga
    
    set consultapopular = new consultaspopulares
    call consultapopular.loaddata

#if seguridadalkon then
    encriptacion.stringvalidacion = encriptacion.armarstringvalidacion
#end if
    
    ' admins
    call loadadministrativeusers
    
end sub

sub writevar(byval file as string, byval main as string, byval var as string, byval value as string)
'***************************************************
'author: unknown
'last modification: -
'escribe var en un archivo
'***************************************************

writeprivateprofilestring main, var, value, file
    
end sub

sub saveuser(byval userindex as integer, byval userfile as string, optional byval savetimeonline as boolean = true)
'*************************************************
'author: unknown
'last modified: 10/10/2010 (pato)
'saves the users records
'23/01/2007 pablo (toxicwaste) - agrego nivelingreso, fechaingreso, matadosingreso y nextrecompensa.
'11/19/2009: pato - save the eluskills and expskills
'12/01/2010: zama - los druidas pierden la inmunidad de ser atacados cuando pierden el efecto del mimetismo.
'10/10/2010: pato - saco el writevar e implemento la clase clsinimanager
'*************************************************

on error goto errhandler

dim manager as clsinimanager
dim existe as boolean

with userlist(userindex)

    'esto tiene que evitar ese bugazo que no se por que graba usuarios nulos
    'clase=0 es el error, porq el enum empieza de 1!!
    if .clase = 0 or .stats.elv = 0 then
        call logcriticevent("estoy intentantdo guardar un usuario nulo de nombre: " & .name)
        exit sub
    end if
    
    set manager = new clsinimanager
    
    if fileexist(userfile) then
        call manager.initialize(userfile)
        
        if fileexist(userfile & ".bk") then call kill(userfile & ".bk")
        name userfile as userfile & ".bk"
        
        existe = true
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
    
    dim loopc as integer
    
    
    call manager.changevalue("flags", "muerto", cstr(.flags.muerto))
    call manager.changevalue("flags", "escondido", cstr(.flags.escondido))
    call manager.changevalue("flags", "hambre", cstr(.flags.hambre))
    call manager.changevalue("flags", "sed", cstr(.flags.sed))
    call manager.changevalue("flags", "desnudo", cstr(.flags.desnudo))
    call manager.changevalue("flags", "ban", cstr(.flags.ban))
    call manager.changevalue("flags", "navegando", cstr(.flags.navegando))
    call manager.changevalue("flags", "envenenado", cstr(.flags.envenenado))
    call manager.changevalue("flags", "paralizado", cstr(.flags.paralizado))
    'matrix
    call manager.changevalue("flags", "lastmap", cstr(.flags.lastmap))
    
    call manager.changevalue("consejo", "pertenece", iif(.flags.privilegios and playertype.royalcouncil, "1", "0"))
    call manager.changevalue("consejo", "pertenececaos", iif(.flags.privilegios and playertype.chaoscouncil, "1", "0"))
    
    
    call manager.changevalue("counters", "pena", cstr(.counters.pena))
    call manager.changevalue("counters", "skillsasignados", cstr(.counters.asignedskills))
    
    call manager.changevalue("facciones", "ejercitoreal", cstr(.faccion.armadareal))
    call manager.changevalue("facciones", "ejercitocaos", cstr(.faccion.fuerzascaos))
    call manager.changevalue("facciones", "ciudmatados", cstr(.faccion.ciudadanosmatados))
    call manager.changevalue("facciones", "crimmatados", cstr(.faccion.criminalesmatados))
    call manager.changevalue("facciones", "rarcaos", cstr(.faccion.recibioarmaduracaos))
    call manager.changevalue("facciones", "rarreal", cstr(.faccion.recibioarmadurareal))
    call manager.changevalue("facciones", "rexcaos", cstr(.faccion.recibioexpinicialcaos))
    call manager.changevalue("facciones", "rexreal", cstr(.faccion.recibioexpinicialreal))
    call manager.changevalue("facciones", "reccaos", cstr(.faccion.recompensascaos))
    call manager.changevalue("facciones", "recreal", cstr(.faccion.recompensasreal))
    call manager.changevalue("facciones", "reenlistadas", cstr(.faccion.reenlistadas))
    call manager.changevalue("facciones", "nivelingreso", cstr(.faccion.nivelingreso))
    call manager.changevalue("facciones", "fechaingreso", .faccion.fechaingreso)
    call manager.changevalue("facciones", "matadosingreso", cstr(.faccion.matadosingreso))
    call manager.changevalue("facciones", "nextrecompensa", cstr(.faccion.nextrecompensa))
    
    
    '�fueron modificados los atributos del usuario?
    if not .flags.tomopocion then
        for loopc = 1 to ubound(.stats.useratributos)
            call manager.changevalue("atributos", "at" & loopc, cstr(.stats.useratributos(loopc)))
        next loopc
    else
        for loopc = 1 to ubound(.stats.useratributos)
            '.stats.useratributos(loopc) = .stats.useratributosbackup(loopc)
            call manager.changevalue("atributos", "at" & loopc, cstr(.stats.useratributosbackup(loopc)))
        next loopc
    end if
    
    for loopc = 1 to ubound(.stats.userskills)
        call manager.changevalue("skills", "sk" & loopc, cstr(.stats.userskills(loopc)))
        call manager.changevalue("skills", "elusk" & loopc, cstr(.stats.eluskills(loopc)))
        call manager.changevalue("skills", "expsk" & loopc, cstr(.stats.expskills(loopc)))
    next loopc
    
    
    call manager.changevalue("contacto", "email", .email)
    
    call manager.changevalue("init", "genero", .genero)
    call manager.changevalue("init", "raza", .raza)
    call manager.changevalue("init", "hogar", .hogar)
    call manager.changevalue("init", "clase", .clase)
    call manager.changevalue("init", "desc", .desc)
    
    call manager.changevalue("init", "heading", cstr(.char.heading))
    call manager.changevalue("init", "head", cstr(.origchar.head))
    
    if .flags.muerto = 0 then
        if .char.body <> 0 then
            call manager.changevalue("init", "body", cstr(.char.body))
        end if
    end if
    
    call manager.changevalue("init", "arma", cstr(.char.weaponanim))
    call manager.changevalue("init", "escudo", cstr(.char.shieldanim))
    call manager.changevalue("init", "casco", cstr(.char.cascoanim))
    
#if conuptime then
    
    if savetimeonline then
        dim tempdate as date
        tempdate = now - .logontime
        .logontime = now
        .uptime = .uptime + (abs(day(tempdate) - 30) * 24 * 3600) + hour(tempdate) * 3600 + minute(tempdate) * 60 + second(tempdate)
        .uptime = .uptime
        call manager.changevalue("init", "uptime", .uptime)
    end if
#end if
    
    'first time around?
    if manager.getvalue("init", "lastip1") = vbnullstring then
        call manager.changevalue("init", "lastip1", .ip & " - " & date & ":" & time)
    'is it a different ip from last time?
    elseif .ip <> left$(manager.getvalue("init", "lastip1"), instr(1, manager.getvalue("init", "lastip1"), " ") - 1) then
        dim i as integer
        for i = 5 to 2 step -1
            call manager.changevalue("init", "lastip" & i, manager.getvalue("init", "lastip" & cstr(i - 1)))
        next i
        call manager.changevalue("init", "lastip1", .ip & " - " & date & ":" & time)
    'same ip, just update the date
    else
        call manager.changevalue("init", "lastip1", .ip & " - " & date & ":" & time)
    end if
    
    
    
    call manager.changevalue("init", "position", .pos.map & "-" & .pos.x & "-" & .pos.y)
    
    
    call manager.changevalue("stats", "gld", cstr(.stats.gld))
    call manager.changevalue("stats", "banco", cstr(.stats.banco))
    
    call manager.changevalue("stats", "maxhp", cstr(.stats.maxhp))
    call manager.changevalue("stats", "minhp", cstr(.stats.minhp))
    
    call manager.changevalue("stats", "maxsta", cstr(.stats.maxsta))
    call manager.changevalue("stats", "minsta", cstr(.stats.minsta))
    
    call manager.changevalue("stats", "maxman", cstr(.stats.maxman))
    call manager.changevalue("stats", "minman", cstr(.stats.minman))
    
    call manager.changevalue("stats", "maxhit", cstr(.stats.maxhit))
    call manager.changevalue("stats", "minhit", cstr(.stats.minhit))
    
    call manager.changevalue("stats", "maxagu", cstr(.stats.maxagu))
    call manager.changevalue("stats", "minagu", cstr(.stats.minagu))
    
    call manager.changevalue("stats", "maxham", cstr(.stats.maxham))
    call manager.changevalue("stats", "minham", cstr(.stats.minham))
    
    call manager.changevalue("stats", "skillptslibres", cstr(.stats.skillpts))
      
    call manager.changevalue("stats", "exp", cstr(.stats.exp))
    call manager.changevalue("stats", "elv", cstr(.stats.elv))
    
    
    call manager.changevalue("stats", "elu", cstr(.stats.elu))
    call manager.changevalue("muertes", "usermuertes", cstr(.stats.usuariosmatados))
    'call manager.changevalue( "muertes", "crimmuertes", cstr(.stats.criminalesmatados))
    call manager.changevalue("muertes", "npcsmuertes", cstr(.stats.npcsmuertos))
      
    '[kevin]----------------------------------------------------------------------------
    '*******************************************************************************************
    call manager.changevalue("bancoinventory", "cantidaditems", val(.bancoinvent.nroitems))
    dim loopd as integer
    for loopd = 1 to max_bancoinventory_slots
        call manager.changevalue("bancoinventory", "obj" & loopd, .bancoinvent.object(loopd).objindex & "-" & .bancoinvent.object(loopd).amount)
    next loopd
    '*******************************************************************************************
    '[/kevin]-----------
      
    'save inv
    call manager.changevalue("inventory", "cantidaditems", val(.invent.nroitems))
    
    for loopc = 1 to max_inventory_slots
        call manager.changevalue("inventory", "obj" & loopc, .invent.object(loopc).objindex & "-" & .invent.object(loopc).amount & "-" & .invent.object(loopc).equipped)
    next loopc
    
    call manager.changevalue("inventory", "weaponeqpslot", cstr(.invent.weaponeqpslot))
    call manager.changevalue("inventory", "armoureqpslot", cstr(.invent.armoureqpslot))
    call manager.changevalue("inventory", "cascoeqpslot", cstr(.invent.cascoeqpslot))
    call manager.changevalue("inventory", "escudoeqpslot", cstr(.invent.escudoeqpslot))
    call manager.changevalue("inventory", "barcoslot", cstr(.invent.barcoslot))
    call manager.changevalue("inventory", "municionslot", cstr(.invent.municioneqpslot))
    call manager.changevalue("inventory", "mochilaslot", cstr(.invent.mochilaeqpslot))
    '/nacho
    
    call manager.changevalue("inventory", "anilloslot", cstr(.invent.anilloeqpslot))
    
    
    'reputacion
    call manager.changevalue("rep", "asesino", cstr(.reputacion.asesinorep))
    call manager.changevalue("rep", "bandido", cstr(.reputacion.bandidorep))
    call manager.changevalue("rep", "burguesia", cstr(.reputacion.burguesrep))
    call manager.changevalue("rep", "ladrones", cstr(.reputacion.ladronesrep))
    call manager.changevalue("rep", "nobles", cstr(.reputacion.noblerep))
    call manager.changevalue("rep", "plebe", cstr(.reputacion.pleberep))
    
    dim l as long
    l = (-.reputacion.asesinorep) + _
        (-.reputacion.bandidorep) + _
        .reputacion.burguesrep + _
        (-.reputacion.ladronesrep) + _
        .reputacion.noblerep + _
        .reputacion.pleberep
    l = l / 6
    call manager.changevalue("rep", "promedio", cstr(l))
    
    dim cad as string
    
    for loopc = 1 to maxuserhechizos
        cad = .stats.userhechizos(loopc)
        call manager.changevalue("hechizos", "h" & loopc, cad)
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
            call manager.changevalue("mascotas", "mas" & loopc, cad)
        else
            cad = .mascotastype(loopc)
            call manager.changevalue("mascotas", "mas" & loopc, cad)
        end if
    
    next
    
    call manager.changevalue("mascotas", "nromascotas", cstr(nromascotas))
    
    'devuelve el head de muerto
    if .flags.muerto = 1 then
        .char.head = icabezamuerto
    end if
end with

call manager.dumpfile(userfile)

set manager = nothing

if existe then call kill(userfile & ".bk")

exit sub

errhandler:
call logerror("error en saveuser")
set manager = nothing

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

sub backupnpc(byval npcindex as integer, byval hfile as integer)
'***************************************************
'author: unknown
'last modification: 10/09/2010
'10/09/2010 - pato: optimice el backup de npcs
'***************************************************

    dim loopc as integer
    
    print #hfile, "[npc" & npclist(npcindex).numero & "]"
    
    with npclist(npcindex)
        'general
        print #hfile, "name=" & .name
        print #hfile, "desc=" & .desc
        print #hfile, "head=" & val(.char.head)
        print #hfile, "body=" & val(.char.body)
        print #hfile, "heading=" & val(.char.heading)
        print #hfile, "movement=" & val(.movement)
        print #hfile, "attackable=" & val(.attackable)
        print #hfile, "comercia=" & val(.comercia)
        print #hfile, "tipoitems=" & val(.tipoitems)
        print #hfile, "hostil=" & val(.hostile)
        print #hfile, "giveexp=" & val(.giveexp)
        print #hfile, "givegld=" & val(.givegld)
        print #hfile, "invrespawn=" & val(.invrespawn)
        print #hfile, "npctype=" & val(.npctype)
        
        'stats
        print #hfile, "alineacion=" & val(.stats.alineacion)
        print #hfile, "def=" & val(.stats.def)
        print #hfile, "maxhit=" & val(.stats.maxhit)
        print #hfile, "maxhp=" & val(.stats.maxhp)
        print #hfile, "minhit=" & val(.stats.minhit)
        print #hfile, "minhp=" & val(.stats.minhp)
        
        'flags
        print #hfile, "respawn=" & val(.flags.respawn)
        print #hfile, "backup=" & val(.flags.backup)
        print #hfile, "domable=" & val(.flags.domable)
        
        'inventario
        print #hfile, "nroitems=" & val(.invent.nroitems)
        if .invent.nroitems > 0 then
           for loopc = 1 to .invent.nroitems
                print #hfile, "obj" & loopc & "=" & .invent.object(loopc).objindex & "-" & .invent.object(loopc).amount
           next loopc
        end if
        
        print #hfile, ""
    end with

end sub

sub cargarnpcbackup(byval npcindex as integer, byval npcnumber as integer)
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
dim x as long
dim y as long

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
