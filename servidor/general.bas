attribute vb_name = "general"
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

global leernpcs as new clsinireader

sub darcuerpodesnudo(byval userindex as integer, optional byval mimetizado as boolean = false)
'***************************************************
'autor: nacho (integer)
'last modification: 03/14/07
'da cuerpo desnudo a un usuario
'***************************************************
dim cuerpodesnudo as integer
select case userlist(userindex).genero
    case egenero.hombre
        select case userlist(userindex).raza
            case eraza.humano
                cuerpodesnudo = 21
            case eraza.drow
                cuerpodesnudo = 32
            case eraza.elfo
                cuerpodesnudo = 210
            case eraza.gnomo
                cuerpodesnudo = 222
            case eraza.enano
                cuerpodesnudo = 53
        end select
    case egenero.mujer
        select case userlist(userindex).raza
            case eraza.humano
                cuerpodesnudo = 39
            case eraza.drow
                cuerpodesnudo = 40
            case eraza.elfo
                cuerpodesnudo = 259
            case eraza.gnomo
                cuerpodesnudo = 260
            case eraza.enano
                cuerpodesnudo = 60
        end select
end select

if mimetizado then
    userlist(userindex).charmimetizado.body = cuerpodesnudo
else
    userlist(userindex).char.body = cuerpodesnudo
end if

userlist(userindex).flags.desnudo = 1

end sub


sub bloquear(byval tomap as boolean, byval sndindex as integer, byval x as integer, byval y as integer, byval b as boolean)
'b ahora es boolean,
'b=true bloquea el tile en (x,y)
'b=false desbloquea el tile en (x,y)
'tomap = true -> envia los datos a todo el mapa
'tomap = false -> envia los datos al user
'unifique los tres parametros (sndindex,sndmap y map) en sndindex... pero de todas formas, el mapa jamas se indica.. eso esta bien asi?
'puede llegar a ser, que se quiera mandar el mapa, habria que agregar un nuevo parametro y modificar.. lo quite porque no se usaba ni aca ni en el cliente :s

if tomap then
    call senddata(sendtarget.tomap, sndindex, preparemessageblockposition(x, y, b))
else
    call writeblockposition(sndindex, x, y, b)
end if

end sub


function hayagua(byval map as integer, byval x as integer, byval y as integer) as boolean

if map > 0 and map < nummaps + 1 and x > 0 and x < 101 and y > 0 and y < 101 then
    if ((mapdata(map, x, y).graphic(1) >= 1505 and mapdata(map, x, y).graphic(1) <= 1520) or _
    (mapdata(map, x, y).graphic(1) >= 5665 and mapdata(map, x, y).graphic(1) <= 5680) or _
    (mapdata(map, x, y).graphic(1) >= 13547 and mapdata(map, x, y).graphic(1) <= 13562)) and _
       mapdata(map, x, y).graphic(2) = 0 then
            hayagua = true
    else
            hayagua = false
    end if
else
  hayagua = false
end if

end function

private function haylava(byval map as integer, byval x as integer, byval y as integer) as boolean
'***************************************************
'autor: nacho (integer)
'last modification: 03/12/07
'***************************************************
if map > 0 and map < nummaps + 1 and x > 0 and x < 101 and y > 0 and y < 101 then
    if mapdata(map, x, y).graphic(1) >= 5837 and mapdata(map, x, y).graphic(1) <= 5852 then
        haylava = true
    else
        haylava = false
    end if
else
  haylava = false
end if

end function


sub limpiarmundo()
'***************************************************
'author: unknow
'last modification: 04/15/2008
'01/14/2008: marcos martinez (byval) - la funcion for estaba mal. en ves de i habia un 1.
'04/15/2008: (niconz) - la funcion for estaba mal, de la forma que se hacia tiraba error.
'***************************************************
on error goto errhandler

dim i as integer
dim d as new cgarbage

for i = trashcollector.count to 1 step -1
    set d = trashcollector(i)
    call eraseobj(1, d.map, d.x, d.y)
    call trashcollector.remove(i)
    set d = nothing
next i

call securityip.ipsecuritymantenimientolista

exit sub

errhandler:
    call logerror("error producido en el sub limpiarmundo: " & err.description)
end sub

sub enviarspawnlist(byval userindex as integer)
dim k as long
dim npcnames() as string

redim npcnames(1 to ubound(spawnlist)) as string

for k = 1 to ubound(spawnlist)
    npcnames(k) = spawnlist(k).npcname
next k

call writespawnlist(userindex, npcnames())

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
dim f as date

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


listarazas(eraza.humano) = "humano"
listarazas(eraza.elfo) = "elfo"
listarazas(eraza.drow) = "drow"
listarazas(eraza.gnomo) = "gnomo"
listarazas(eraza.enano) = "enano"

listaclases(eclass.mage) = "mago"
listaclases(eclass.cleric) = "clerigo"
listaclases(eclass.warrior) = "guerrero"
listaclases(eclass.assasin) = "asesino"
listaclases(eclass.thief) = "ladron"
listaclases(eclass.bard) = "bardo"
listaclases(eclass.druid) = "druida"
listaclases(eclass.bandit) = "bandido"
listaclases(eclass.paladin) = "paladin"
listaclases(eclass.hunter) = "cazador"
listaclases(eclass.fisher) = "pescador"
listaclases(eclass.blacksmith) = "herrero"
listaclases(eclass.lumberjack) = "le�ador"
listaclases(eclass.miner) = "minero"
listaclases(eclass.carpenter) = "carpintero"
listaclases(eclass.pirat) = "pirata"

skillsnames(eskill.suerte) = "suerte"
skillsnames(eskill.magia) = "magia"
skillsnames(eskill.robar) = "robar"
skillsnames(eskill.tacticas) = "tacticas de combate"
skillsnames(eskill.armas) = "combate con armas"
skillsnames(eskill.meditar) = "meditar"
skillsnames(eskill.apu�alar) = "apu�alar"
skillsnames(eskill.ocultarse) = "ocultarse"
skillsnames(eskill.supervivencia) = "supervivencia"
skillsnames(eskill.talar) = "talar arboles"
skillsnames(eskill.comerciar) = "comercio"
skillsnames(eskill.defensa) = "defensa con escudos"
skillsnames(eskill.pesca) = "pesca"
skillsnames(eskill.mineria) = "mineria"
skillsnames(eskill.carpinteria) = "carpinteria"
skillsnames(eskill.herreria) = "herreria"
skillsnames(eskill.liderazgo) = "liderazgo"
skillsnames(eskill.domar) = "domar animales"
skillsnames(eskill.proyectiles) = "armas de proyectiles"
skillsnames(eskill.wrestling) = "wrestling"
skillsnames(eskill.navegacion) = "navegacion"

listaatributos(eatributos.fuerza) = "fuerza"
listaatributos(eatributos.agilidad) = "agilidad"
listaatributos(eatributos.inteligencia) = "inteligencia"
listaatributos(eatributos.carisma) = "carisma"
listaatributos(eatributos.constitucion) = "constitucion"


frmcargando.show

'call playwaveapi(app.path & "\wav\harp3.wav")

frmmain.caption = frmmain.caption & " v." & app.major & "." & app.minor & "." & app.revision
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
frmcargando.label1(2).caption = "cargando npcs.dat"
call carganpcsdat
'*************************************************

frmcargando.label1(2).caption = "cargando obj.dat"
'call loadobjdata
call loadobjdata
    
frmcargando.label1(2).caption = "cargando hechizos.dat"
call cargarhechizos
    
    
frmcargando.label1(2).caption = "cargando objetos de herrer�a"
call loadarmasherreria
call loadarmadurasherreria

frmcargando.label1(2).caption = "cargando objetos de carpinter�a"
call loadobjcarpintero

frmcargando.label1(2).caption = "cargando balance.dat"
call loadbalance    '4/01/08 pablo toxicwaste

if bootdelbackup then
    
    frmcargando.label1(2).caption = "cargando backup"
    call cargarbackup
else
    frmcargando.label1(2).caption = "cargando mapas"
    call loadmapdata
end if


call sonidosmapas.loadsoundmapinfo


'comentado porque hay worldsave en ese mapa!
'call crearclanpretoriano(mapa_pretoriano, alcoba2_x, alcoba2_y)
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�

dim loopc as integer

'resetea las conexiones de los usuarios
for loopc = 1 to maxusers
    userlist(loopc).connid = -1
    userlist(loopc).connidvalida = false
    set userlist(loopc).incomingdata = new clsbytequeue
    set userlist(loopc).outgoingdata = new clsbytequeue
next loopc

'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�

with frmmain
    .autosave.enabled = true
    .tlluvia.enabled = true
    .tpiquetec.enabled = true
    .gametimer.enabled = true
    .tlluviaevent.enabled = true
    .fx.enabled = true
    .auditoria.enabled = true
    .killlog.enabled = true
    .timer_ai.enabled = true
    .npcataca.enabled = true
    
#if seguridadalkon then
    .securitytimer.enabled = true
#end if
end with

'�?�?�?�?�?�?�?�?�?�?�?�?�?�?��?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'configuracion de los sockets

call securityip.initiptables(1000)

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

end sub

function fileexist(byval file as string, optional filetype as vbfileattribute = vbnormal) as boolean
'*****************************************************************
'se fija si existe el archivo
'*****************************************************************
    fileexist = lenb(dir$(file, filetype)) <> 0
end function

function readfield(byval pos as integer, byref text as string, byval sepascii as byte) as string
'*****************************************************************
'gets a field from a string
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/15/2004
'gets a field from a delimited string
'*****************************************************************
    dim i as long
    dim lastpos as long
    dim currentpos as long
    dim delimiter as string * 1
    
    delimiter = chr$(sepascii)
    
    for i = 1 to pos
        lastpos = currentpos
        currentpos = instr(lastpos + 1, text, delimiter, vbbinarycompare)
    next i
    
    if currentpos = 0 then
        readfield = mid$(text, lastpos + 1, len(text) - lastpos)
    else
        readfield = mid$(text, lastpos + 1, currentpos - lastpos - 1)
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


public sub logclanes(byval str as string)

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\clanes.log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

end sub

public sub logip(byval str as string)

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\ip.log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

end sub


public sub logdesarrollo(byval str as string)

dim nfile as integer
nfile = freefile ' obtenemos un canal
open app.path & "\logs\desarrollo" & month(date) & year(date) & ".log" for append shared as #nfile
print #nfile, date & " " & time & " " & str
close #nfile

end sub



public sub loggm(nombre as string, texto as string)
on error goto errhandler

dim nfile as integer
nfile = freefile ' obtenemos un canal
'guardamos todo en el mismo lugar. pablo (toxicwaste) 18/05/07
open app.path & "\logs\" & nombre & ".log" for append shared as #nfile
print #nfile, date & " " & time & " " & texto
close #nfile

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

if lenb(arg) = 0 then exit function

next i

validinputnp = true

end function


sub restart()


'se asegura de que los sockets estan cerrados e ignora cualquier err
on error resume next

if frmmain.visible then frmmain.txstatus.caption = "reiniciando."

dim loopc as long
  
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

'initialize statistics!!
call statistics.initialize

for loopc = 1 to ubound(userlist())
    set userlist(loopc).incomingdata = nothing
    set userlist(loopc).outgoingdata = nothing
next loopc

redim userlist(1 to maxusers) as user

for loopc = 1 to maxusers
    userlist(loopc).connid = -1
    userlist(loopc).connidvalida = false
    set userlist(loopc).incomingdata = new clsbytequeue
    set userlist(loopc).outgoingdata = new clsbytequeue
next loopc

lastuser = 0
numusers = 0

call freenpcs
call freecharindexes

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
                call flushbuffer(userindex)
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
            call writeconsolemsg(userindex, "��estas muriendo de frio, abrigate o moriras!!.", fonttypenames.fonttype_info)
            modifi = porcentaje(userlist(userindex).stats.maxhp, 5)
            userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - modifi
            
            if userlist(userindex).stats.minhp < 1 then
                call writeconsolemsg(userindex, "��has muerto de frio!!.", fonttypenames.fonttype_info)
                userlist(userindex).stats.minhp = 0
                call userdie(userindex)
            end if
            
            call writeupdatehp(userindex)
        else
            modifi = porcentaje(userlist(userindex).stats.maxsta, 5)
            call quitarsta(userindex, modifi)
            call writeupdatesta(userindex)
        end if
        
        userlist(userindex).counters.frio = 0
    end if
end sub

public sub efectolava(byval userindex as integer)
'***************************************************
'autor: nacho (integer)
'last modification: 03/12/07
'if user is standing on lava, take health points from him
'***************************************************
    if userlist(userindex).counters.lava < intervalofrio then 'usamos el mismo intervalo que el del frio
        userlist(userindex).counters.lava = userlist(userindex).counters.lava + 1
    else
        if haylava(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y) then
            call writeconsolemsg(userindex, "��quitate de la lava, te est�s quemando!!.", fonttypenames.fonttype_info)
            userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - porcentaje(userlist(userindex).stats.maxhp, 5)
            
            if userlist(userindex).stats.minhp < 1 then
                call writeconsolemsg(userindex, "��has muerto quemado!!.", fonttypenames.fonttype_info)
                userlist(userindex).stats.minhp = 0
                call userdie(userindex)
            end if
            
            call writeupdatehp(userindex)
        end if
        
        userlist(userindex).counters.lava = 0
    end if
end sub

''
' maneja el tiempo y el efecto del mimetismo
'
' @param userindex  el index del usuario a ser afectado por el mimetismo
'

public sub efectomimetismo(byval userindex as integer)
'******************************************************
'author: unknown
'last update: 04/11/2008 (niconz)
'
'******************************************************
    dim barco as objdata
    
    with userlist(userindex)
        if .counters.mimetismo < intervaloinvisible then
            .counters.mimetismo = .counters.mimetismo + 1
        else
            'restore old char
            call writeconsolemsg(userindex, "recuperas tu apariencia normal.", fonttypenames.fonttype_info)
            
            if .flags.navegando then
                if .flags.muerto = 0 then
                    if .faccion.armadareal = 1 then
                        .char.body = ifragatareal
                    elseif .faccion.fuerzascaos = 1 then
                        .char.body = ifragatacaos
                    else
                        barco = objdata(userlist(userindex).invent.barcoobjindex)
                        if criminal(userindex) then
                            if barco.ropaje = ibarca then .char.body = ibarcapk
                            if barco.ropaje = igalera then .char.body = igalerapk
                            if barco.ropaje = igaleon then .char.body = igaleonpk
                        else
                            if barco.ropaje = ibarca then .char.body = ibarcaciuda
                            if barco.ropaje = igalera then .char.body = igaleraciuda
                            if barco.ropaje = igaleon then .char.body = igaleonciuda
                        end if
                    end if
                else
                    .char.body = ifragatafantasmal
                end if
                
                .char.shieldanim = ningunescudo
                .char.weaponanim = ningunarma
                .char.cascoanim = ninguncasco
            else
                .char.body = .charmimetizado.body
                .char.head = .charmimetizado.head
                .char.cascoanim = .charmimetizado.cascoanim
                .char.shieldanim = .charmimetizado.shieldanim
                .char.weaponanim = .charmimetizado.weaponanim
            end if
            
            with .char
                call changeuserchar(userindex, .body, .head, .heading, .weaponanim, .shieldanim, .cascoanim)
            end with
            
            .counters.mimetismo = 0
            .flags.mimetizado = 0
        end if
    end with
end sub

public sub efectoinvisibilidad(byval userindex as integer)

if userlist(userindex).counters.invisibilidad < intervaloinvisible then
    userlist(userindex).counters.invisibilidad = userlist(userindex).counters.invisibilidad + 1
else
    userlist(userindex).counters.invisibilidad = 0
    userlist(userindex).flags.invisible = 0
    if userlist(userindex).flags.oculto = 0 then
        call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
        call setinvisible(userindex, userlist(userindex).char.charindex, false)
        'call senddata(sendtarget.topcarea, userindex, preparemessagesetinvisible(userlist(userindex).char.charindex, false))
    end if
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
        call writeblindnomore(userindex)
    end if
    if userlist(userindex).flags.estupidez = 1 then
        userlist(userindex).flags.estupidez = 0
        call writedumbnomore(userindex)
    end if

end if


end sub


public sub efectoparalisisuser(byval userindex as integer)

if userlist(userindex).counters.paralisis > 0 then
    userlist(userindex).counters.paralisis = userlist(userindex).counters.paralisis - 1
else
    userlist(userindex).flags.paralizado = 0
    userlist(userindex).flags.inmovilizado = 0
    'userlist(userindex).flags.administrativeparalisis = 0
    call writeparalizeok(userindex)
end if

end sub

public sub recstamina(byval userindex as integer, byref enviarstats as boolean, byval intervalo as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 1 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 2 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 4 then exit sub


dim massta as integer
if userlist(userindex).stats.minsta < userlist(userindex).stats.maxsta then
    if userlist(userindex).counters.stacounter < intervalo then
        userlist(userindex).counters.stacounter = userlist(userindex).counters.stacounter + 1
    else
        enviarstats = true
        userlist(userindex).counters.stacounter = 0
        if userlist(userindex).flags.desnudo then exit sub 'desnudo no sube energ�a. (toxicwaste)
       
        massta = randomnumber(1, porcentaje(userlist(userindex).stats.maxsta, 5))
        userlist(userindex).stats.minsta = userlist(userindex).stats.minsta + massta
        if userlist(userindex).stats.minsta > userlist(userindex).stats.maxsta then
            userlist(userindex).stats.minsta = userlist(userindex).stats.maxsta
        end if
    end if
end if

end sub

public sub efectoveneno(byval userindex as integer)
dim n as integer

if userlist(userindex).counters.veneno < intervaloveneno then
  userlist(userindex).counters.veneno = userlist(userindex).counters.veneno + 1
else
  call writeconsolemsg(userindex, "est�s envenenado, si no te curas morir�s.", fonttypenames.fonttype_veneno)
  userlist(userindex).counters.veneno = 0
  n = randomnumber(1, 5)
  userlist(userindex).stats.minhp = userlist(userindex).stats.minhp - n
  if userlist(userindex).stats.minhp < 1 then call userdie(userindex)
  call writeupdatehp(userindex)
end if

end sub

public sub duracionpociones(byval userindex as integer)

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

public sub hambreysed(byval userindex as integer, byref fenviarays as boolean)

if not userlist(userindex).flags.privilegios and playertype.user then exit sub

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
        if userlist(userindex).stats.minham <= 0 then
               userlist(userindex).stats.minham = 0
               userlist(userindex).flags.hambre = 1
        end if
        fenviarays = true
    end if
end if

end sub

public sub sanar(byval userindex as integer, byref enviarstats as boolean, byval intervalo as integer)

if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 1 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 2 and _
   mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 4 then exit sub

dim mashit as integer
'con el paso del tiempo va sanando....pero muy lentamente ;-)
if userlist(userindex).stats.minhp < userlist(userindex).stats.maxhp then
    if userlist(userindex).counters.hpcounter < intervalo then
        userlist(userindex).counters.hpcounter = userlist(userindex).counters.hpcounter + 1
    else
        mashit = randomnumber(2, porcentaje(userlist(userindex).stats.maxsta, 5))
        
        userlist(userindex).counters.hpcounter = 0
        userlist(userindex).stats.minhp = userlist(userindex).stats.minhp + mashit
        if userlist(userindex).stats.minhp > userlist(userindex).stats.maxhp then userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
        call writeconsolemsg(userindex, "has sanado.", fonttypenames.fonttype_info)
        enviarstats = true
    end if
end if

end sub

public sub carganpcsdat()
    dim npcfile as string
    
    npcfile = datpath & "npcs.dat"
    call leernpcs.initialize(npcfile)
end sub

sub pasarsegundo()
on error goto errhandler
    dim i as long
    
    for i = 1 to lastuser
        if userlist(i).flags.userlogged then
            'cerrar usuario
            if userlist(i).counters.saliendo then
                userlist(i).counters.salir = userlist(i).counters.salir - 1
                if userlist(i).counters.salir <= 0 then
                    call writeconsolemsg(i, "gracias por jugar argentum online", fonttypenames.fonttype_info)
                    call writedisconnect(i)
                    call flushbuffer(i)
                    
                    call closesocket(i)
                end if
            end if
        end if
    next i
exit sub

errhandler:
    call logerror("error en pasarsegundo. err: " & err.description & " - " & err.number & " - userindex: " & i)
    resume next
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
    
    if ejecutarlauncher then shell (app.path & "\launcher.exe")

    'chauuu
    unload frmmain

end sub

 
sub guardarusuarios()
    haciendobk = true
    
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> grabando personajes", fonttypenames.fonttype_server))
    
    dim i as integer
    for i = 1 to lastuser
        if userlist(i).flags.userlogged then
            call saveuser(i, charpath & ucase$(userlist(i).name) & ".chr")
        end if
    next i
    
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> personajes grabados", fonttypenames.fonttype_server))
    call senddata(sendtarget.toall, 0, preparemessagepausetoggle())

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

public sub freenpcs()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'releases all npc indexes
'***************************************************
    dim loopc as long
    
    ' free all npc indexes
    for loopc = 1 to maxnpcs
        npclist(loopc).flags.npcactive = false
    next loopc
end sub

public sub freecharindexes()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'releases all char indexes
'***************************************************
    ' free all char indexes (set them all to 0)
    call zeromemory(charlist(1), maxchars * len(charlist(1)))
end sub
