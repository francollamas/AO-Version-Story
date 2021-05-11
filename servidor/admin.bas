attribute vb_name = "admin"
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

public type tmotd
    texto as string
    formato as string
end type

public maxlines as integer
public motd() as tmotd

public type tapuestas
    ganancias as long
    perdidas as long
    jugadas as long
end type
public apuestas as tapuestas

public npcs as long
public debugsocket as boolean

public horas as long
public dias as long
public minsrunning as long

public reiniciarserver as long

public tinicioserver as long
public estadisticasweb as new clsestadisticasipc

public sanaintervalosindescansar as integer
public staminaintervalosindescansar as integer
public sanaintervalodescansar as integer
public staminaintervalodescansar as integer
public intervalosed as integer
public intervalohambre as integer
public intervaloveneno as integer
public intervaloparalizado as integer
public intervaloinvisible as integer
public intervalofrio as integer
public intervalowavfx as integer
public intervalolanzahechizo as integer
public intervalonpcpuedeatacar as integer
public intervalonpcai as integer
public intervaloinvocacion as integer
public intervalouserpuedeatacar as long
public intervalouserpuedecastear as long
public intervalouserpuedetrabajar as long
public intervaloparaconexion as long
public intervalocerrarconexion as long '[gonzalo]
public intervalouserpuedeusar as long
public intervaloflechascazadores as long
public intervaloautoreiniciar as long   'segundos

public minutosws as long
public puerto as integer

public maxpasos as long

public bootdelbackup as byte
public lloviendo as boolean
public denoche as boolean

public iplist as new collection
public clientscommandsqueue as byte

public type tcpesstats
    bytesenviados as double
    bytesrecibidos as double
    bytesenviadosxseg as long
    bytesrecibidosxseg as long
    bytesenviadosxsegmax as long
    bytesrecibidosxsegmax as long
    bytesenviadosxsegcuando as date
    bytesrecibidosxsegcuando as date
end type

public tcpesstats as tcpesstats

'public resetthread as new clsthreading

function versionok(byval ver as string) as boolean
versionok = (ver = ultimaversion)
end function

public function versionesactuales(byval v1 as integer, byval v2 as integer, byval v3 as integer, byval v4 as integer, byval v5 as integer, byval v6 as integer, byval v7 as integer) as boolean
dim rv as boolean
dim i as integer
dim f as string

rv = val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "graficos")) = v1
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "wavs")) = v2
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "midis")) = v3
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "init")) = v4
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "mapas")) = v5
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "aoexe")) = v6
rv = rv and val(getvar(app.path & "\autoupdater\versiones.ini", "actuales", "extras")) = v7
versionesactuales = rv

end function


public function validarloginmsg(byval n as integer) as integer
on error resume next
dim auxinteger as integer
dim auxinteger2 as integer
auxinteger = sd(n)
auxinteger2 = sdm(n)
validarloginmsg = complex(auxinteger + auxinteger2)
end function


sub respawnorigposnpcs()
on error resume next

dim i as integer
dim minpc as npc
   
for i = 1 to lastnpc
   'ojo
   if npclist(i).flags.npcactive then
        
        if inmapbounds(npclist(i).orig.map, npclist(i).orig.x, npclist(i).orig.y) and npclist(i).numero = guardias then
                minpc = npclist(i)
                call quitarnpc(i)
                call respawnnpc(minpc)
        end if
        
        'tildada por sugerencia de yind
        'if npclist(i).contadores.tiempoexistencia > 0 then
        '        call muerenpc(i, 0)
        'end if
   end if
   
next i

end sub

sub worldsave()
on error resume next
'call logtarea("sub worldsave")

dim loopx as integer
dim porc as long

call senddata(sendtarget.toall, 0, 0, "||servidor> iniciando worldsave" & fonttype_server)

#if seguridadalkon then
    encriptacion.stringvalidacion = encriptacion.armarstringvalidacion
#end if

call respawnorigposnpcs 'respawn de los guardias en las pos originales

dim j as integer, k as integer

for j = 1 to nummaps
    if mapinfo(j).backup = 1 then k = k + 1
next j

frmstat.progressbar1.min = 0
frmstat.progressbar1.max = k
frmstat.progressbar1.value = 0

for loopx = 1 to nummaps
    'doevents
    
    if mapinfo(loopx).backup = 1 then
    
            call grabarmapa(loopx, app.path & "\worldbackup\mapa" & loopx)
            frmstat.progressbar1.value = frmstat.progressbar1.value + 1
    end if

next loopx

frmstat.visible = false

if fileexist(datpath & "\bknpc.dat", vbnormal) then kill (datpath & "bknpc.dat")
if fileexist(datpath & "\bknpcs-hostiles.dat", vbnormal) then kill (datpath & "bknpcs-hostiles.dat")

for loopx = 1 to lastnpc
    if npclist(loopx).flags.backup = 1 then
            call backupnpc(loopx)
    end if
next

call senddata(sendtarget.toall, 0, 0, "||servidor> worldsave ha conclu�do" & fonttype_server)

end sub

public sub purgarpenas()
dim i as integer
for i = 1 to lastuser
    if userlist(i).flags.userlogged then
    
        if userlist(i).counters.pena > 0 then
                
                userlist(i).counters.pena = userlist(i).counters.pena - 1
                
                if userlist(i).counters.pena < 1 then
                    userlist(i).counters.pena = 0
                    call warpuserchar(i, libertad.map, libertad.x, libertad.y, true)
                    call senddata(sendtarget.toindex, i, 0, "||has sido liberado!" & fonttype_info)
                end if
                
        end if
        
    end if
next i
end sub


public sub encarcelar(byval userindex as integer, byval minutos as long, optional byval gmname as string = "")
        
        userlist(userindex).counters.pena = minutos
       
        
        call warpuserchar(userindex, prision.map, prision.x, prision.y, true)
        
        if gmname = "" then
            call senddata(sendtarget.toindex, userindex, 0, "||has sido encarcelado, deberas permanecer en la carcel " & minutos & " minutos." & fonttype_info)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||" & gmname & " te ha encarcelado, deberas permanecer en la carcel " & minutos & " minutos." & fonttype_info)
        end if
        
end sub


public sub borrarusuario(byval username as string)
on error resume next
if fileexist(charpath & ucase$(username) & ".chr", vbnormal) then
    kill charpath & ucase$(username) & ".chr"
end if
end sub

public function bancheck(byval name as string) as boolean

bancheck = (val(getvar(app.path & "\charfile\" & name & ".chr", "flags", "ban")) = 1)

end function

public function personajeexiste(byval name as string) as boolean

personajeexiste = fileexist(charpath & ucase$(name) & ".chr", vbnormal)

end function

public function unban(byval name as string) as boolean
'unban the character
call writevar(app.path & "\charfile\" & name & ".chr", "flags", "ban", "0")

'remove it from the banned people database
call writevar(app.path & "\logs\" & "bandetail.dat", name, "bannedby", "nobody")
call writevar(app.path & "\logs\" & "bandetail.dat", name, "reason", "no reason")
end function

public function md5ok(byval md5formateado as string) as boolean
dim i as integer

if md5clientesactivado = 1 then
    for i = 0 to ubound(md5s)
        if (md5formateado = md5s(i)) then
            md5ok = true
            exit function
        end if
    next i
    md5ok = false
else
    md5ok = true
end if

end function

public sub md5scarga()
dim loopc as integer

md5clientesactivado = val(getvar(inipath & "server.ini", "md5hush", "activado"))

if md5clientesactivado = 1 then
    redim md5s(val(getvar(inipath & "server.ini", "md5hush", "md5aceptados")))
    for loopc = 0 to ubound(md5s)
        md5s(loopc) = getvar(inipath & "server.ini", "md5hush", "md5aceptado" & (loopc + 1))
        md5s(loopc) = txtoffset(hexmd52asc(md5s(loopc)), 55)
    next loopc
end if

end sub

public sub banipagrega(byval ip as string)
banips.add ip

call banipguardar
end sub

public function banipbuscar(byval ip as string) as long
dim dale as boolean
dim loopc as long

dale = true
loopc = 1
do while loopc <= banips.count and dale
    dale = (banips.item(loopc) <> ip)
    loopc = loopc + 1
loop

if dale then
    banipbuscar = 0
else
    banipbuscar = loopc - 1
end if
end function

public function banipquita(byval ip as string) as boolean

on error resume next

dim n as long

n = banipbuscar(ip)
if n > 0 then
    banips.remove n
    banipguardar
    banipquita = true
else
    banipquita = false
end if

end function

public sub banipguardar()
dim archivobanip as string
dim archn as long
dim loopc as long

archivobanip = app.path & "\dat\banips.dat"

archn = freefile()
open archivobanip for output as #archn

for loopc = 1 to banips.count
    print #archn, banips.item(loopc)
next loopc

close #archn

end sub

public sub banipcargar()
dim archn as long
dim tmp as string
dim archivobanip as string

archivobanip = app.path & "\dat\banips.dat"

do while banips.count > 0
    banips.remove 1
loop

archn = freefile()
open archivobanip for input as #archn

do while not eof(archn)
    line input #archn, tmp
    banips.add tmp
loop

close #archn

end sub

public sub actualizaestadisticasweb()

static andando as boolean
static contador as long
dim tmp as boolean

contador = contador + 1

if contador >= 10 then
    contador = 0
    tmp = estadisticasweb.estadisticasandando()
    
    if andando = false and tmp = true then
        call inicializaestadisticas
    end if
    
    andando = tmp
end if

end sub

public sub actualizastatses()

static tult as single
dim transcurrido as single

transcurrido = timer - tult

if transcurrido >= 5 then
    tult = timer
    with tcpesstats
        .bytesenviadosxseg = clng(.bytesenviados / transcurrido)
        .bytesrecibidosxseg = clng(.bytesrecibidos / transcurrido)
        .bytesenviados = 0
        .bytesrecibidos = 0
        
        if .bytesenviadosxseg > .bytesenviadosxsegmax then
            .bytesenviadosxsegmax = .bytesenviadosxseg
            .bytesenviadosxsegcuando = cdate(now)
        end if
        
        if .bytesrecibidosxseg > .bytesrecibidosxsegmax then
            .bytesrecibidosxsegmax = .bytesrecibidosxseg
            .bytesrecibidosxsegcuando = cdate(now)
        end if
        
        if frmestadisticas.visible then
            call frmestadisticas.actualizastats
        end if
    end with
end if

end sub


public function userdarprivilegiolevel(byval name as string) as long
if esdios(name) then
    userdarprivilegiolevel = 3
elseif essemidios(name) then
    userdarprivilegiolevel = 2
elseif esconsejero(name) then
    userdarprivilegiolevel = 1
else
    userdarprivilegiolevel = 0
end if
end function

