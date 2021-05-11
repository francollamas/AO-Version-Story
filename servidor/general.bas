attribute vb_name = "general"
'argentum online 0.11.20
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


global leernpcs as new clsleerinis
global leernpcshostiles as new clsleerinis

option explicit

sub darcuerpodesnudo(byval userindex as integer, optional byval mimetizado as boolean = false)

select case ucase$(userlist(userindex).raza)
    case "humano"
      select case ucase$(userlist(userindex).genero)
                case "hombre"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 21
                    else
                        userlist(userindex).char.body = 21
                    end if
                case "mujer"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 39
                    else
                        userlist(userindex).char.body = 39
                    end if
      end select
    case "elfo oscuro"
      select case ucase$(userlist(userindex).genero)
                case "hombre"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 32
                    else
                        userlist(userindex).char.body = 32
                    end if
                case "mujer"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 40
                    else
                        userlist(userindex).char.body = 40
                    end if
      end select
    case "enano"
      select case ucase$(userlist(userindex).genero)
                case "hombre"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 53
                    else
                        userlist(userindex).char.body = 53
                    end if
                case "mujer"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 60
                    else
                        userlist(userindex).char.body = 60
                    end if
      end select
    case "gnomo"
      select case ucase$(userlist(userindex).genero)
                case "hombre"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 53
                    else
                        userlist(userindex).char.body = 53
                    end if
                case "mujer"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 60
                    else
                        userlist(userindex).char.body = 60
                    end if
      end select
    case else
      select case ucase$(userlist(userindex).genero)
                case "hombre"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 21
                    else
                        userlist(userindex).char.body = 21
                    end if
                case "mujer"
                    if mimetizado then
                        userlist(userindex).charmimetizado.body = 39
                    else
                        userlist(userindex).char.body = 39
                    end if
      end select
    
end select

userlist(userindex).flags.desnudo = 1

end sub


sub bloquear(byval sndroute as byte, byval sndindex as integer, byval sndmap as integer, map as integer, byval x as integer, byval y as integer, b as byte)
'b=1 bloquea el tile en (x,y)
'b=0 desbloquea el tile indicado

call senddata(sndroute, sndindex, sndmap, "bq" & x & "," & y & "," & b)

end sub


function hayagua(map as integer, x as integer, y as integer) as boolean

if map > 0 and map < nummaps + 1 and x > 0 and x < 101 and y > 0 and y < 101 then
    if mapdata(map, x, y).graphic(1) >= 1505 and _
       mapdata(map, x, y).graphic(1) <= 1520 and _
       mapdata(map, x, y).graphic(2) = 0 then
            hayagua = true
    else
            hayagua = false
    end if
else
  hayagua = false
end if

end function




sub limpiarmundo()

on error resume next

dim i as integer

for i = 1 to trashcollector.count
    dim d as cgarbage
    set d = trashcollector(1)
    call eraseobj(tomap, 0, d.map, 1, d.map, d.x, d.y)
    call trashcollector.remove(1)
    set d = nothing
next i



end sub

sub enviarspawnlist(byval userindex as integer)
dim k as integer, sd as string
sd = "spl" & ubound(spawnlist) & ","

for k = 1 to ubound(spawnlist)
    sd = sd & spawnlist(k).npcname & ","
next k

call senddata(toindex, userindex, 0, sd)
end sub

sub configlisteningsocket(byref obj as object, byval port as integer)
#if usarquesocket = 0 then

obj.addressfamily = af_inet
obj.protocol = ipproto_ip
obj.sockettype = sock_stream
obj.binary = false
obj.blocking = false
obj.buffersize = 1024
obj.localport = port
obj.backlog = 5
obj.listen

#end if
end sub




sub main()
on error resume next

chdir app.path
chdrive app.path

call loadmotd
call banipcargar

prision.map = 66
libertad.map = 66

prision.x = 75
prision.y = 47
libertad.x = 75
libertad.y = 65


lastbackup = format(now, "short time")
minutos = format(now, "short time")



redim npclist(1 to maxnpcs) as npc 'npcs
redim charlist(1 to maxchars) as integer
redim parties(1 to max_parties) as clsparty



inipath = app.path & "\"
datpath = app.path & "\dat\"



levelskill(1).levelvalue = 3
levelskill(2).levelvalue = 5
levelskill(3).levelvalue = 7
levelskill(4).levelvalue = 10
levelskill(5).levelvalue = 13
levelskill(6).levelvalue = 15
levelskill(7).levelvalue = 17
levelskill(8).levelvalue = 20
levelskill(9).levelvalue = 23
levelskill(10).levelvalue = 25
levelskill(11).levelvalue = 27
levelskill(12).levelvalue = 30
levelskill(13).levelvalue = 33
levelskill(14).levelvalue = 35
levelskill(15).levelvalue = 37
levelskill(16).levelvalue = 40
levelskill(17).levelvalue = 43
levelskill(18).levelvalue = 45
levelskill(19).levelvalue = 47
levelskill(20).levelvalue = 50
levelskill(21).levelvalue = 53
levelskill(22).levelvalue = 55
levelskill(23).levelvalue = 57
levelskill(24).levelvalue = 60
levelskill(25).levelvalue = 63
levelskill(26).levelvalue = 65
levelskill(27).levelvalue = 67
levelskill(28).levelvalue = 70
levelskill(29).levelvalue = 73
levelskill(30).levelvalue = 75
levelskill(31).levelvalue = 77
levelskill(32).levelvalue = 80
levelskill(33).levelvalue = 83
levelskill(34).levelvalue = 85
levelskill(35).levelvalue = 87
levelskill(36).levelvalue = 90
levelskill(37).levelvalue = 93
levelskill(38).levelvalue = 95
levelskill(39).levelvalue = 97
levelskill(40).levelvalue = 100
levelskill(41).levelvalue = 100
levelskill(42).levelvalue = 100
levelskill(43).levelvalue = 100
levelskill(44).levelvalue = 100
levelskill(45).levelvalue = 100
levelskill(46).levelvalue = 100
levelskill(47).levelvalue = 100
levelskill(48).levelvalue = 100
levelskill(49).levelvalue = 100
levelskill(50).levelvalue = 100


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
listaclases(16) = "sastre"
listaclases(17) = "pirata"

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
skillsnames(10) = "talar arboles"
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


frmcargando.show



'call playwaveapi(app.path & "\wav\harp3.wav")

frmmain.caption = frmmain.caption & " v." & app.major & "." & app.minor & "." & app.revision
endl = chr(13) & chr(10)
endc = chr(1)
inipath = app.path & "\"
charpath = app.path & "\charfile\"

'bordes del mapa
minxborder = xminmapsize + (xwindow \ 2)
maxxborder = xmaxmapsize - (xwindow \ 2)
minyborder = yminmapsize + (ywindow \ 2)
maxyborder = ymaxmapsize - (ywindow \ 2)
doevents

frmcargando.label1(2).caption = "iniciando arrays..."

call loadguildsdb


call cargarspawnlist
call cargarforbidenwords
'�?�?�?�?�?�?�?� cargamos datos desde archivos �??�?�?�?�?�?�?�
frmcargando.label1(2).caption = "cargando server.ini"

maxusers = 0
call loadsini
call cargaapuestas

'*************************************************
call carganpcsdat
'*************************************************

frmcargando.label1(2).caption = "cargando obj.dat"
'call loadobjdata
call loadobjdata
    
frmcargando.label1(2).caption = "cargando hechizos.dat"
call cargarhechizos
    
    
call loadarmasherreria
call loadarmadurasherreria
call loadobjcarpintero

if bootdelbackup then
    
    frmcargando.label1(2).caption = "cargando backup"
    call cargarbackup_nuevo2
else
    frmcargando.label1(2).caption = "cargando mapas"
    call loadmapdata
    'call loadmapdata_nuevo
end if


'comentado porque hay worldsave en ese mapa!
'call crearclanpretoriano(mapa_pretoriano, alcoba2_x, alcoba2_y)
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�

dim loopc as integer

'resetea las conexiones de los usuarios
for loopc = 1 to maxusers
    userlist(loopc).connid = -1
    userlist(loopc).connidvalida = false
next loopc

'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�

with frmmain
    .autosave.enabled = true
    .tlluvia.enabled = true
    .tpiquetec.enabled = true
    .timer1.enabled = true
    if clientscommandsqueue <> 0 then
        .cmdexec.enabled = true
    else
        .cmdexec.enabled = false
    end if
    .gametimer.enabled = true
    .tlluviaevent.enabled = true
    .fx.enabled = true
    .auditoria.enabled = true
    .killlog.enabled = true
    .timer_ai.enabled = true
    .npcataca.enabled = true
end with

'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'configuracion de los sockets

#if usarquesocket = 1 then

call iniciawsapi(frmmain.hwnd)
socklisten = listenforconnect(puerto, hwndmsg, "")

#elseif usarquesocket = 0 then

frmcargando.label1(2).caption = "configurando sockets"

frmmain.socket2(0).addressfamily = af_inet
frmmain.socket2(0).protocol = ipproto_ip
frmmain.socket2(0).sockettype = sock_stream
frmmain.socket2(0).binary = false
frmmain.socket2(0).blocking = false
frmmain.socket2(0).buffersize = 2048

call configlisteningsocket(frmmain.socket1, puerto)

#elseif usarquesocket = 2 then

frmmain.serv.iniciar puerto

#elseif usarquesocket = 3 then

frmmain.tcpserv.encolar true
frmmain.tcpserv.iniciartabla 1009
frmmain.tcpserv.setqueuelim 51200
frmmain.tcpserv.iniciar puerto

#end if

if frmmain.visible then frmmain.txstatus.caption = "escuchando conexiones entrantes ..."
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�




unload frmcargando


'log
dim n as integer
n = freefile
open app.path & "\logs\main.log" for append shared as #n
print #n, date & " " & time & " server iniciado " & app.major & "."; app.minor & "." & app.revision
close #n

'ocultar
if hideme = 1 then
    call frmmain.initmain(1)
else
    call frmmain.initmain(0)
end if

tinicioserver = gettickcount() and &h7fffffff
call inicializaestadisticas

randomize timer

'resetthread.createnewthread addressof threadresetactions, tpnormal

'call mainthread


end sub



function fileexist(file as string, optional filetype as vbfileattribute = vbnormal) as boolean

on error resume next
'*****************************************************************
'se fija si existe el archivo
'*****************************************************************

if dir(file, filetype) = "" then
    fileexist = false
else
    fileexist = true
end if

end function
function readfield(byval pos as integer, byval text as string, byval sepascii as integer) as string
'all these functions are much faster using the "$" sign
'after the function. this happens for a simple reason:
'the functions return a variant without the $ sign. and
'variants are very slow, you should never use them.

'*****************************************************************
'devuelve el string del campo
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
function mapavalido(byval map as integer) as boolean
mapavalido = map >= 1 and map <= nummaps
end function

sub mostrarnumusers()

frmmain.cantusuarios.caption = "numero de usuarios jugando: " & numusers

end sub


public sub logcriticevent(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\eventos.log" for append shared as #nfile
print #nfile, date & " " & time & " " & desc
close #nfile

exit sub

errhandler:

end sub

public sub logejercitoreal(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\ejercitoreal.log" for append shared as #nfile
print #nfile, desc
close #nfile

exit sub

errhandler:

end sub

public sub logejercitocaos(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\ejercitocaos.log" for append shared as #nfile
print #nfile, desc
close #nfile

exit sub

errhandler:

end sub


public sub logindex(byval index as integer, byval desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\" & index & ".log" for append shared as #nfile
print #nfile, date & " " & time & " " & desc
close #nfile

exit sub

errhandler:

end sub


public sub logerror(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\errores.log" for append shared as #nfile
print #nfile, date & " " & time & " " & desc
close #nfile

exit sub

errhandler:

end sub

public sub logstatic(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\stats.log" for append shared as #nfile
print #nfile, date & " " & time & " " & desc
close #nfile

exit sub

errhandler:

end sub

public sub logtarea(desc as string)
on error goto errhandler

dim nfile as integer
nfile = freefile(1) ' obtenemos un canal
open app.path & "\logs\haciendo.log" for append shared as #nfile
print #nfile, date & " " & time & " " & desc
close #nfile

exit sub

errhandler:


end sub



public sub logdesarrollo(byval str as string)

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\desarrollo.log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

end sub



public sub loggm(nombre as string, texto as string, consejero as boolean)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
if consejero then
    open app.path & "\logs\consejeros\" & nombre & ".log" for append shared as #nfile
else
    open app.path & "\logs\" & nombre & ".log" for append shared as #nfile
end if
print #nfile, date & " " & time & " " & texto
close #nfile

exit sub

errhandler:

end sub

public sub savedaystats()
''on error goto errhandler
''
''dim nfile as integer
''nfile = freefile ' obtenemos un canal
''open app.path & "\logs\" & replace(date, "/", "-") & ".log" for append shared as #nfile
''
''print #nfile, "<stats>"
''print #nfile, "<ao>"
''print #nfile, "<dia>" & date & "</dia>"
''print #nfile, "<hora>" & time & "</hora>"
''print #nfile, "<segundos_total>" & daystats.segundos & "</segundos_total>"
''print #nfile, "<max_user>" & daystats.maxusuarios & "</max_user>"
''print #nfile, "</ao>"
''print #nfile, "</stats>"
''
''
''close #nfile
exit sub

errhandler:

end sub


public sub logasesinato(texto as string)
on error goto errhandler
dim nfile as integer

nfile = freefile ' obtenemos un canal

open app.path & "\logs\asesinatos.log" for append shared as #nfile
print #nfile, date & " " & time & " " & texto
close #nfile

exit sub

errhandler:

end sub
public sub logventacasa(byval texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal

open app.path & "\logs\propiedades.log" for append shared as #nfile
print #nfile, "----------------------------------------------------------"
print #nfile, date & " " & time & " " & texto
print #nfile, "----------------------------------------------------------"
close #nfile

exit sub

errhandler:


end sub
public sub loghackattemp(texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\hackattemps.log" for append shared as #nfile
print #nfile, "----------------------------------------------------------"
print #nfile, date & " " & time & " " & texto
print #nfile, "----------------------------------------------------------"
close #nfile

exit sub

errhandler:

end sub

public sub logcheating(texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\ch.log" for append shared as #nfile
print #nfile, date & " " & time & " " & texto
close #nfile

exit sub

errhandler:

end sub


public sub logcriticalhackattemp(texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\criticalhackattemps.log" for append shared as #nfile
print #nfile, "----------------------------------------------------------"
print #nfile, date & " " & time & " " & texto
print #nfile, "----------------------------------------------------------"
close #nfile

exit sub

errhandler:

end sub

public sub loganticheat(texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\anticheat.log" for append shared as #nfile
print #nfile, date & " " & time & " " & texto
print #nfile, ""
close #nfile

exit sub

errhandler:

end sub

function validinputnp(byval cad as string) as boolean
dim arg as string
dim i as integer


for i = 1 to 33

arg = readfield(i, cad, 44)

if arg = "" then exit function

next i

validinputnp = true

end function


sub restart()


'se asegura de que los sockets estan cerrados e ignora cualquier err
on error resume next

if frmmain.visible then frmmain.txstatus.caption = "reiniciando."

dim loopc as integer
  
#if usarquesocket = 0 then

    frmmain.socket1.cleanup
    frmmain.socket1.startup
      
    frmmain.socket2(0).cleanup
    frmmain.socket2(0).startup

#elseif usarquesocket = 1 then

    'cierra el socket de escucha
    if socklisten >= 0 then call apiclosesocket(socklisten)
    
    'inicia el socket de escucha
    socklisten = listenforconnect(puerto, hwndmsg, "")

#elseif usarquesocket = 2 then

#end if

for loopc = 1 to maxusers
    call closesocket(loopc)
next

redim userlist(1 to maxusers)

for loopc = 1 to maxusers
    userlist(loopc).connid = -1
    userlist(loopc).connidvalida = false
next loopc

lastuser = 0
numusers = 0

redim npclist(1 to maxnpcs) as npc 'npcs
redim charlist(1 to maxchars) as integer

call loadsini
call loadobjdata

call loadmapdata

call cargarhechizos

#if usarquesocket = 0 then

'*****************setup socket
frmmain.socket1.addressfamily = af_inet
frmmain.socket1.protocol = ipproto_ip
frmmain.socket1.sockettype = sock_stream
frmmain.socket1.binary = false
frmmain.socket1.blocking = false
frmmain.socket1.buffersize = 1024

frmmain.socket2(0).addressfamily = af_inet
frmmain.socket2(0).protocol = ipproto_ip
frmmain.socket2(0).sockettype = sock_stream
frmmain.socket2(0).blocking = false
frmmain.socket2(0).buffersize = 2048

'escucha
frmmain.socket1.localport = val(puerto)
frmmain.socket1.listen

#elseif usarquesocket = 1 then

#elseif usarquesocket = 2 then

#end if

if frmmain.visible then frmmain.txstatus.caption = "escuchando conexiones entrantes ..."

'log it
dim n as integer
n = freefile
open app.path & "\logs\main.log" for append shared as #n
print #n, date & " " & time & " servidor reiniciado."
close #n

'ocultar

if hideme = 1 then
    call frmmain.initmain(1)
else
    call frmmain.initmain(0)
end if

  
end sub


public function intemperie(byval userindex as integer) as boolean
    
    if mapinfo(userlist(userindex).pos.map).zona <> "dungeon" then
        if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger <> 1 and _
           mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger <> 2 and _
           mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger <> 4 then intemperie = true
    else
        intemperie = false
    end if
    
end function

public sub efectolluvia(byval userindex as integer)
on error goto errhandler


if userlist(userindex).flags.userlogged then
    if intemperie(userindex) then
                dim modifi as long
                modifi = porcentaje(userlist(userindex).stats.maxsta, 3)
                call quitarsta(userindex, modifi)
'                call senddata(toindex, userindex, 0, "||��has perdido stamina, busca pronto refugio de la lluvia!!." & fonttype_info)
                call senduserstatsbox(userindex)
    end if
end if

exit sub
errhandler:
 logerror ("error en efectolluvia")
end sub


public sub tiempoinvocacion(byval userindex as integer)
dim i as integer
for i = 1 to maxmascotas
    if userlist(userindex).mascotasindex(i) > 0 then
        if npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia > 0 then
           npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia = _
           npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia - 1
           if npclist(userlist(userindex).mascotasindex(i)).contadores.tiempoexistencia = 0 then call muerenpc(userlist(userindex).mascotasindex(i), 0)
        end if
    end if
next i
end sub

public sub efectofrio(byval userindex as integer)

dim modifi as integer

if userlist(userindex).counters.frio < intervalofrio then
  userlist(userindex).counters.frio = userlist(userindex).counters.frio + 1
else
  if mapinfo(userlist(userindex).pos.map).terreno = nieve then
    call senddata(toindex, userindex, 0, "||��estas muriendo de frio, abrigate o moriras!!." & fonttype_info)
    modifi = porcentaje(userlist(userindex).stats.maxhp, 5)
    userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - modifi
    if userlist(userindex).stats.minhp < 1 then
            call senddata(toindex, userindex, 0, "||��has muerto de frio!!." & fonttype_info)
            userlist(userindex).stats.minhp = 0
            call userdie(userindex)
    end if
  else
    modifi = porcentaje(userlist(userindex).stats.maxsta, 5)
    call quitarsta(userindex, modifi)
    'call senddata(toindex, userindex, 0, "||��has perdido stamina, si no te abrigas rapido perderas toda!!." & fonttype_info)
  end if
  
  userlist(userindex).counters.frio = 0
  call senduserstatsbox(userindex)
end if

end sub

public sub efectomimetismo(byval userindex as integer)

if userlist(userindex).counters.mimetismo < intervaloinvisible then
    userlist(userindex).counters.mimetismo = userlist(userindex).counters.mimetismo + 1
else
    'restore old char
    call senddata(toindex, userindex, 0, "||recuperas tu apariencia normal." & fonttype_info)
    
    userlist(userindex).char.body = userlist(userindex).charmimetizado.body
    userlist(userindex).char.head = userlist(userindex).charmimetizado.head
    userlist(userindex).char.cascoanim = userlist(userindex).charmimetizado.cascoanim
    userlist(userindex).char.shieldanim = userlist(userindex).charmimetizado.shieldanim
    userlist(userindex).char.weaponanim = userlist(userindex).charmimetizado.weaponanim
        
    
    userlist(userindex).counters.mimetismo = 0
    userlist(userindex).flags.mimetizado = 0
    call changeuserchar(tomap, userindex, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
end if
            
end sub



public sub efectoinvisibilidad(byval userindex as integer)

if userlist(userindex).counters.invisibilidad < intervaloinvisible then
  
  'cazador con armadura de cazador oculto no se hace visible
  'mersada de inmediata direccion pero no me importa pq esta
  'version ya fue :d
  if ucase$(userlist(userindex).clase) = "cazador" and userlist(userindex).flags.oculto > 0 and userlist(userindex).stats.userskills(ocultarse) > 90 then
    if userlist(userindex).invent.armoureqpobjindex = 648 or userlist(userindex).invent.armoureqpobjindex = 360 then
        exit sub
    end if
  end if
  
  userlist(userindex).counters.invisibilidad = userlist(userindex).counters.invisibilidad + 1
else
  call senddata(toindex, userindex, 0, "||has vuelto a ser visible." & fonttype_info)
  userlist(userindex).counters.invisibilidad = 0
  userlist(userindex).flags.invisible = 0
  userlist(userindex).flags.oculto = 0
'   no ecripto los noverx,0
'  if encriptarprotocoloscriticos then
'    call sendcrypteddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
'  else
    call senddata(tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
'  end if
    
end if
            
end sub


public sub efectoparalisisnpc(byval npcindex as integer)

if npclist(npcindex).contadores.paralisis > 0 then
    npclist(npcindex).contadores.paralisis = npclist(npcindex).contadores.paralisis - 1
else
    npclist(npcindex).flags.paralizado = 0
    npclist(npcindex).flags.inmovilizado = 0
end if

end sub

public sub efectocegueestu(byval userindex as integer)

if userlist(userindex).counters.ceguera > 0 then
    userlist(userindex).counters.ceguera = userlist(userindex).counters.ceguera - 1
else
    if userlist(userindex).flags.ceguera = 1 then
        userlist(userindex).flags.ceguera = 0
        call senddata(toindex, userindex, 0, "nsegue")
    end if
    if userlist(userindex).flags.estupidez = 1 then
        userlist(userindex).flags.estupidez = 0
        call senddata(toindex, userindex, 0, "nestup")
    end if

end if


end sub


public sub efectoparalisisuser(byval userindex as integer)

if userlist(userindex).counters.paralisis > 0 then
    userlist(userindex).counters.paralisis = userlist(userindex).counters.paralisis - 1
else
    userlist(userindex).flags.paralizado = 0
    'userlist(userindex).flags.administrativeparalisis = 0
    call senddata(toindex, userindex, 0, "paradok")
end if

end sub
public sub recstamina(userindex as integer, enviarstats as boolean, intervalo as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 1 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 2 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 4 then exit sub
       
      
dim massta as integer
if userlist(userindex).stats.minsta < userlist(userindex).stats.maxsta then
   if userlist(userindex).counters.stacounter < intervalo then
       userlist(userindex).counters.stacounter = userlist(userindex).counters.stacounter + 1
   else
       userlist(userindex).counters.stacounter = 0
       massta = cint(randomnumber(1, porcentaje(userlist(userindex).stats.maxsta, 5)))
       userlist(userindex).stats.minsta = userlist(userindex).stats.minsta + massta
       if userlist(userindex).stats.minsta > userlist(userindex).stats.maxsta then userlist(userindex).stats.minsta = userlist(userindex).stats.maxsta
'           call senddata(toindex, userindex, 0, "||te sentis menos cansado." & fonttype_info)
           enviarstats = true
       end if
end if

end sub

public sub efectoveneno(userindex as integer, enviarstats as boolean)
dim n as integer

if userlist(userindex).counters.veneno < intervaloveneno then
  userlist(userindex).counters.veneno = userlist(userindex).counters.veneno + 1
else
  call senddata(toindex, userindex, 0, "||estas envenenado, si no te curas moriras." & fonttype_veneno)
  userlist(userindex).counters.veneno = 0
  n = randomnumber(1, 5)
  userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - n
  if userlist(userindex).stats.minhp < 1 then call userdie(userindex)
  enviarstats = true
end if

end sub

public sub duracionpociones(userindex as integer)

'controla la duracion de las pociones
if userlist(userindex).flags.duracionefecto > 0 then
   userlist(userindex).flags.duracionefecto = userlist(userindex).flags.duracionefecto - 1
   if userlist(userindex).flags.duracionefecto = 0 then
        userlist(userindex).flags.tomopocion = false
        userlist(userindex).flags.tipopocion = 0
        'volvemos los atributos al estado normal
        dim loopx as integer
        for loopx = 1 to numatributos
              userlist(userindex).stats.useratributos(loopx) = userlist(userindex).stats.useratributosbackup(loopx)
        next
   end if
end if

end sub

public sub hambreysed(userindex as integer, fenviarays as boolean)
'sed
if userlist(userindex).stats.minagu > 0 then
    if userlist(userindex).counters.aguacounter < intervalosed then
          userlist(userindex).counters.aguacounter = userlist(userindex).counters.aguacounter + 1
    else
          userlist(userindex).counters.aguacounter = 0
          userlist(userindex).stats.minagu = userlist(userindex).stats.minagu - 10
                            
          if userlist(userindex).stats.minagu <= 0 then
               userlist(userindex).stats.minagu = 0
               userlist(userindex).flags.sed = 1
          end if
                            
          fenviarays = true
                            
    end if
end if

'hambre
if userlist(userindex).stats.minham > 0 then
   if userlist(userindex).counters.comcounter < intervalohambre then
        userlist(userindex).counters.comcounter = userlist(userindex).counters.comcounter + 1
   else
        userlist(userindex).counters.comcounter = 0
        userlist(userindex).stats.minham = userlist(userindex).stats.minham - 10
        if userlist(userindex).stats.minham < 0 then
               userlist(userindex).stats.minham = 0
               userlist(userindex).flags.hambre = 1
        end if
        fenviarays = true
    end if
end if

end sub

public sub sanar(userindex as integer, enviarstats as boolean, intervalo as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 1 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 2 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 4 then exit sub
       

dim mashit as integer
'con el paso del tiempo va sanando....pero muy lentamente ;-)
if userlist(userindex).stats.minhp < userlist(userindex).stats.maxhp then
   if userlist(userindex).counters.hpcounter < intervalo then
      userlist(userindex).counters.hpcounter = userlist(userindex).counters.hpcounter + 1
   else
      mashit = cint(randomnumber(2, porcentaje(userlist(userindex).stats.maxsta, 5)))
                           
      userlist(userindex).counters.hpcounter = 0
      userlist(userindex).stats.minhp = userlist(userindex).stats.minhp + mashit
      if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
         call senddata(toindex, userindex, 0, "||has sanado." & fonttype_info)
         enviarstats = true
      end if
end if

end sub

public sub carganpcsdat()
'dim npcfile as string
'
'npcfile = datpath & "npcs.dat"
'anpc = inicarga(npcfile)
'call iniconf(anpc, 0, "", 0)
'
'npcfile = datpath & "npcs-hostiles.dat"
'anpc_host = inicarga(npcfile)
'call iniconf(anpc_host, 0, "", 0)

dim npcfile as string

npcfile = datpath & "npcs.dat"
leernpcs.abrir npcfile

npcfile = datpath & "npcs-hostiles.dat"
leernpcshostiles.abrir npcfile

end sub

public sub descarganpcsdat()
'if anpc <> 0 then call inidescarga(anpc)
'if anpc_host <> 0 then call inidescarga(anpc_host)

end sub

sub pasarsegundo()
    dim i as integer
    for i = 1 to lastuser
        'cerrar usuario
        if userlist(i).counters.saliendo then
            userlist(i).counters.salir = userlist(i).counters.salir - 1
            if userlist(i).counters.salir <= 0 then
                'if numusers <> 0 then numusers = numusers - 1
                'call ados.restarconexion(frmmain.socket2(i).peeraddress)
                call senddata(toindex, i, 0, "||gracias por jugar argentum online" & fonttype_info)
                call senddata(toindex, i, 0, "finok")
                
                call closesocket(i)
                exit sub
'                call closeuser(i)
'                userlist(i).connid = -1: userlist(i).numeropaquetespormilisec = 0
'                frmmain.socket2(i).disconnect
'                frmmain.socket2(i).cleanup
'                'unload frmmain.socket2(i)
'                call resetuserslot(i)
'            else
'                call senddata(toindex, i, 0, "||en " & userlist(i).counters.salir & " segundos se cerrar� el juego..." & fonttype_info)
            end if
        
        'antiempollos
        elseif userlist(i).flags.estaempo = 1 then
             userlist(i).empocont = userlist(i).empocont + 1
             if userlist(i).empocont = 30 then
                 
                 'if fileexist(charpath & userlist(z).name & ".chr", vbnormal) then
                 'esto siempre existe! sino no estaria logueado ;p
                 
                 'tmpp = val(getvar(charpath & userlist(z).name & ".chr", "penas", "cant"))
                 'call writevar(charpath & userlist(z).name & ".chr", "penas", "cant", tmpp + 1)
                 'call writevar(charpath & userlist(z).name & ".chr", "penas", "p" & tmpp + 1, lcase$(userlist(z).name) & ": carcel " & 30 & "m, motivo: empollando" & " " & date & " " & time)

                 'call encarcelar(z, 30, "el sistema anti empollo")
                 call senddata(toindex, i, 0, "!! fuiste expulsado por permanecer muerto sobre un item")
                 'call senddata(toadmins, z, 0, "|| " & userlist(z).name & " fue encarcelado por empollar" & fonttype_info)
                 userlist(i).empocont = 0
                 call closesocket(i)
                 exit sub
             elseif userlist(i).empocont = 15 then
                 call senddata(toindex, i, 0, "|| llevas 15 segundos bloqueando el item, mu�vete o ser�s desconectado." & fonttype_warning)
             end if
         end if
    next i
    
    'revisamos auto reiniciares
    if intervaloautoreiniciar <> -1 then
        intervaloautoreiniciar = intervaloautoreiniciar - 1
                
        if intervaloautoreiniciar <= 1200 then
            select case intervaloautoreiniciar
            
                case 1200, 600, 240, 120, 180, 60, 30
                    call senddata(toall, 0, 0, "|| servidor> el servidor se reiniciar� por mantenimiento autom�tico en " & intervaloautoreiniciar & " segundos. tomen las debidas precauciones" & fonttype_server)
                case 300
                    call senddata(toall, 0, 0, "!! el servidor se reiniciar� por mantenimiento autom�tico en " & intervaloautoreiniciar & " segundos. tomen las debidas precauciones")
                case is < 30
                    call senddata(toall, 0, 0, "|| servidor> el servidor se reiniciar� en " & intervaloautoreiniciar & " segundos." & fonttype_talk)
            end select
        
            if intervaloautoreiniciar = 0 then
                call reiniciarservidor(true)
            end if
        end if
    end if
end sub
 
public function reiniciarautoupdate() as double

    reiniciarautoupdate = shell(app.path & "\autoupdater\aoau.exe", vbminimizednofocus)

end function
 
public sub reiniciarservidor(optional byval ejecutarlauncher as boolean = true)
    'worldsave
    call dobackup

    'commit experiencias
    call mdparty.actualizaexperiencias

    'guardar pjs
    call guardarusuarios
    
    'guilds
    call saveguildsdb

    if ejecutarlauncher then shell (app.path & "\launcher.exe")

    'chauuu
    unload frmmain

end sub

 
sub guardarusuarios()
    haciendobk = true
    
    call senddata(toall, 0, 0, "bkw")
    call senddata(toall, 0, 0, "||servidor> grabando personajes" & fonttype_server)
    
    dim i as integer
    for i = 1 to lastuser
        if userlist(i).flags.userlogged then
            call saveuser(i, charpath & ucase$(userlist(i).name) & ".chr")
        end if
    next i
    
    call senddata(toall, 0, 0, "||servidor> personajes grabados" & fonttype_server)
    call senddata(toall, 0, 0, "bkw")

    haciendobk = false
end sub


sub inicializaestadisticas()
dim ta as long
ta = gettickcount() and &h7fffffff

call estadisticasweb.inicializa(frmmain.hwnd)
call estadisticasweb.informar(cantidad_mapas, nummaps)
call estadisticasweb.informar(cantidad_online, numusers)
call estadisticasweb.informar(uptime_server, (ta - tinicioserver) / 1000)
call estadisticasweb.informar(record_usuarios, recordusuarios)

end sub
