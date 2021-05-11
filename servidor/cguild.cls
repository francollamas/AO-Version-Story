version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "cguild"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
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


option explicit

'this member variables should be private.. but i
'dont have enough time to write the four methods that
'requires each of them to query and update ....

public electionperiod  as long


public founder as string
public fundationdate as string
public description as string
private codex(0 to 7) as string
public leader as string
public reputation as double
public gold as double
public guildname as string
public url as string
public guildexperience as double
public dayssincelastelection as long
public guildnews as string

public alliedguilds as collection
public enemyguilds as collection
public members as collection
public solicitudes as collection
public peacepropositions as collection
public votes as collection
public elections as boolean

private type tvotes
        name as string
        cant as long
end type


public function getcodex(byval number as byte) as string
getcodex = codex(number)
end function

public function codexlenght() as integer
dim t%
for t% = 0 to 7
    if codex(t%) = "" then exit for
    if t% = 7 then exit for
next t%

codexlenght = t%
end function

public function daystonextelection() as integer
daystonextelection = electionperiod - dayssincelastelection
end function

private function testname(byval cad as string) as boolean
dim car as byte
dim i as integer

cad = lcase$(cad)

for i = 1 to len(cad)
    car = asc(mid$(cad, i, 1))
    
    if (car < 97 or car > 122) and (car <> 255) and (car <> 32) then
        testname = false
        exit function
    end if
    
next i

testname = true

end function

public sub updatecodexanddesc(byval rdata as string)

description = readfield(1, rdata, asc("�"))

dim mandamientos as integer
mandamientos = cint(readfield(2, rdata, asc("�")))

dim i as integer
for i = 1 to mandamientos
    codex(i - 1) = readfield(2 + i, rdata, asc("�"))
next i


end sub

private function parseguildinfo(byref guildinfo as string, byval foundername as string, byval rep as long) as boolean

on err goto errhandler

founder = foundername
leader = founder
fundationdate = now
description = readfield(1, guildinfo, asc("�"))
guildname = readfield(2, guildinfo, asc("�"))

if not testname(guildname) then
    parseguildinfo = false
    exit function
end if

url = readfield(3, guildinfo, asc("�"))
dim mandamientos as integer
mandamientos = cint(readfield(4, guildinfo, asc("�")))
dim i as integer
for i = 1 to mandamientos
    codex(i - 1) = readfield(4 + i, guildinfo, asc("�"))
next i
reputation = rep
gold = 0
guildexperience = 0
dayssincelastelection = 0
guildnews = "clan iniciado."

parseguildinfo = true

exit function

errhandler:

end function

public sub initializeguildfromdisk(byval number as integer)
dim file as string

file = app.path & "\guilds\" & "guildsinfo.inf"

guildname = getvar(file, "guild" & number, "guildname")
founder = getvar(file, "guild" & number, "founder")
fundationdate = getvar(file, "guild" & number, "date")
description = getvar(file, "guild" & number, "desc")
codex(0) = getvar(file, "guild" & number, "codex0")
codex(1) = getvar(file, "guild" & number, "codex1")
codex(2) = getvar(file, "guild" & number, "codex2")
codex(3) = getvar(file, "guild" & number, "codex3")
codex(4) = getvar(file, "guild" & number, "codex4")
codex(5) = getvar(file, "guild" & number, "codex5")
codex(6) = getvar(file, "guild" & number, "codex6")
codex(7) = getvar(file, "guild" & number, "codex7")
leader = getvar(file, "guild" & number, "leader")
reputation = val(getvar(file, "guild" & number, "rep"))
gold = val(getvar(file, "guild" & number, "gold"))
url = getvar(file, "guild" & number, "url")
guildexperience = val(getvar(file, "guild" & number, "exp"))
dayssincelastelection = val(getvar(file, "guild" & number, "dayslast"))
guildnews = getvar(file, "guild" & number, "guildnews")


call loadguildmembers(guildname)
call loadsolicitudes(guildname)
call loadalliedguilds(guildname)
call loadenemyguilds(guildname)
call loadpeacepropositions(guildname)

end sub


private sub loadguildmembers(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-members" & ".mem"


dim t as long
t = val(getvar(f, "init", "nromembers"))

dim j as integer

for j = 1 to t
    call members.add(getvar(f, "members", "member" & j))
next j


end sub

private sub loadsolicitudes(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-solicitudes" & ".sol"


dim t as long
t = val(getvar(f, "init", "nro"))

if t > 25 then exit sub

dim j as integer
dim sol as csolicitud
for j = 1 to t
    set sol = new csolicitud
    sol.username = getvar(f, "sol" & j, "name")
    sol.desc = getvar(f, "sol" & j, "desc")
    call solicitudes.add(sol)
next j


end sub

private sub loadpeacepropositions(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-propositions" & ".pro"

dim t as long

t = val(getvar(f, "init", "nro"))

dim j as integer
dim sol as csolicitud
for j = 1 to t
    set sol = new csolicitud
    sol.username = getvar(f, "sol" & j, "name")
    sol.desc = getvar(f, "sol" & j, "desc")
    call peacepropositions.add(sol)
next j


end sub




private sub savealliedguilds(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-allied" & ".all"

if fileexist(f, vbnormal) then kill f

call writevar(f, "init", "nroallies", alliedguilds.count)

dim j as integer

for j = 1 to alliedguilds.count
    call writevar(f, "allies", "allie" & j, alliedguilds(j))
next j

end sub


private sub loadalliedguilds(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-allied" & ".all"


dim t as long
t = val(getvar(f, "init", "nroallies"))

dim j as integer

for j = 1 to t
    call alliedguilds.add(getvar(f, "allies", "allie" & j))
next j


end sub



private sub saveenemyguilds(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-enemys" & ".ene"

if fileexist(f, vbnormal) then kill f

call writevar(f, "init", "nroenemys", enemyguilds.count)

dim j as integer

for j = 1 to enemyguilds.count
    call writevar(f, "enemys", "enemy" & j, enemyguilds(j))
next j

end sub


private sub loadenemyguilds(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-enemys" & ".ene"


dim t as long
t = val(getvar(f, "init", "nroenemys"))

dim j as integer

for j = 1 to t
    call alliedguilds.add(getvar(f, "enemys", "enemy" & j))
next j


end sub


private sub saveguildmembers(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-members" & ".mem"

if fileexist(f, vbnormal) then kill f

call writevar(f, "init", "nromembers", members.count)

dim j as integer

for j = 1 to members.count
    call writevar(f, "members", "member" & j, members(j))
next j


end sub

private sub savesolicitudes(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-solicitudes" & ".sol"

if fileexist(f, vbnormal) then kill f

call writevar(f, "init", "nro", solicitudes.count)

dim j as integer

for j = 1 to solicitudes.count
    call writevar(f, "sol" & j, "name", solicitudes(j).username)
    call writevar(f, "sol" & j, "desc", solicitudes(j).desc)
next j


end sub

private sub savepeacepropositions(byval guildname as string)

dim f as string

f = app.path & "\guilds\" & guildname & "-propositions" & ".pro"

if fileexist(f, vbnormal) then kill f

call writevar(f, "init", "nro", peacepropositions.count)

dim j as integer

for j = 1 to peacepropositions.count
    call writevar(f, "pro" & j, "name", peacepropositions(j).username)
    call writevar(f, "pro" & j, "desc", peacepropositions(j).desc)
next j


end sub


public sub saveguild(byval file as string, byval guildnumber)

on error goto errhandler



call writevar(file, "guild" & guildnumber, "guildname", guildname)
call writevar(file, "guild" & guildnumber, "founder", founder)
call writevar(file, "guild" & guildnumber, "guildname", guildname)
call writevar(file, "guild" & guildnumber, "date", fundationdate)
call writevar(file, "guild" & guildnumber, "desc", description)
call writevar(file, "guild" & guildnumber, "codex0", codex(0))
call writevar(file, "guild" & guildnumber, "codex1", codex(1))
call writevar(file, "guild" & guildnumber, "codex2", codex(2))
call writevar(file, "guild" & guildnumber, "codex3", codex(3))
call writevar(file, "guild" & guildnumber, "codex4", codex(4))
call writevar(file, "guild" & guildnumber, "codex5", codex(5))
call writevar(file, "guild" & guildnumber, "codex6", codex(6))
call writevar(file, "guild" & guildnumber, "codex7", codex(7))
call writevar(file, "guild" & guildnumber, "leader", leader)
call writevar(file, "guild" & guildnumber, "url", url)
call writevar(file, "guild" & guildnumber, "guildexp", str(guildexperience))
call writevar(file, "guild" & guildnumber, "dayslast", str(dayssincelastelection))
call writevar(file, "guild" & guildnumber, "guildnews", guildnews)
call writevar(file, "guild" & guildnumber, "rep", str(reputation))

call savealliedguilds(guildname)
call saveenemyguilds(guildname)
call saveguildmembers(guildname)
call savesolicitudes(guildname)
call savepeacepropositions(guildname)

exit sub

errhandler:


end sub

public function initialize(byval guildinfo as string, byval foundername as string, byval rep as long) as boolean
initialize = parseguildinfo(guildinfo, foundername, rep)
end function

private sub class_initialize()

set alliedguilds = new collection
set enemyguilds = new collection
set members = new collection
set solicitudes = new collection
set peacepropositions = new collection
set votes = new collection

electionperiod = 45

end sub

public function isenemy(byval guildname as string) as boolean

dim k as integer

guildname = ucase$(guildname)

for k = 1 to enemyguilds.count
    if ucase$(enemyguilds(k)) = guildname then
            isenemy = true
            exit function
    end if
next k

end function


public function isallie(byval guildname as string) as boolean

dim k as integer

guildname = ucase$(guildname)

for k = 1 to alliedguilds.count
    if ucase$(alliedguilds(k)) = guildname then
            isallie = true
            exit function
    end if
next k

end function

public function solicitudesincludes(byval username as string) as boolean

dim k as integer


username = ucase$(username)

for k = 1 to solicitudes.count
    if ucase$(solicitudes(k).username) = username then
            solicitudesincludes = true
            exit function
    end if
next k


end function

public sub removesolicitud(byval username as string)

dim k as integer


username = ucase$(username)

for k = 1 to solicitudes.count
    if ucase$(solicitudes(k).username) = username then
            call solicitudes.remove(k)
            exit sub
    end if
next k



end sub

public sub removeproposition(byval username as string)

dim k as integer


username = ucase$(username)

for k = 1 to peacepropositions.count
    if ucase$(peacepropositions(k).username) = username then
            call peacepropositions.remove(k)
            exit sub
    end if
next k



end sub


public sub removeallie(byval name as string)
dim k as integer
name = ucase$(name)
for k = 1 to alliedguilds.count
    if ucase$(alliedguilds(k)) = name then
            call alliedguilds.remove(k)
            exit sub
    end if
next k
end sub

public sub removeenemy(byval name as string)
dim k as integer
name = ucase$(name)
for k = 1 to enemyguilds.count
    if ucase$(enemyguilds(k)) = name then
            call enemyguilds.remove(k)
            exit sub
    end if
next k
end sub


public sub removemember(byval username as string)

dim k as integer


username = ucase$(username)

for k = 1 to members.count
    if ucase$(members(k)) = username then
            call members.remove(k)
            exit sub
    end if
next k



end sub





public function getpeacerequest(byval username as string) as csolicitud

dim k as integer


username = ucase$(username)

for k = 1 to peacepropositions.count
    if ucase$(peacepropositions(k).username) = username then
            set getpeacerequest = peacepropositions(k)
            exit function
    end if
next k


end function


public sub testsolicitudbound()
'nos aseguramos que no halla m�s de 25 solicitudes
if me.solicitudes.count > 25 then
    dim i as integer
    for i = 1 to me.solicitudes.count
        solicitudes.remove 1
    next i
end if
end sub

public function getsolicitud(byval username as string) as csolicitud

dim k as integer


username = ucase$(username)

for k = 1 to solicitudes.count
    if ucase$(solicitudes(k).username) = username then
            set getsolicitud = solicitudes(k)
            exit function
    end if
next k


end function

public function includespeaceoffer(byval name as string) as boolean

dim k as integer

name = ucase$(name)

for k = 1 to peacepropositions.count
    if ucase$(peacepropositions(k).username) = name then
            includespeaceoffer = true
            exit function
    end if
next k



end function

public sub resetvotes()

dim k as integer
for k = 1 to votes.count
    call votes.remove(1)
next k

end sub


public function ismember(byval name as string) as boolean

dim k as integer

name = ucase$(name)

for k = 1 to members.count
    if ucase$(members(k)) = name then
            ismember = true
            exit function
    end if
next k

end function


public function nuevolider() as string

dim j as integer, c as integer

dim totals() as tvotes

if members.count = 0 then
    nuevolider = "clanclausurado"
    exit function
end if

redim totals(1 to members.count)


for j = 1 to members.count

    totals(j).name = members(j)
    totals(j).cant = 0
    
next j


for j = 1 to votes.count
    
    for c = 1 to members.count
        if ucase$(totals(c).name) = ucase$(votes(j)) then
            totals(c).cant = totals(c).cant + 1
            exit for
        end if
    next c
    
next j

dim max as integer
max = -1

for j = 1 to members.count
    if totals(j).cant > max then
            max = totals(j).cant
            nuevolider = totals(j).name
    end if
next j

end function
