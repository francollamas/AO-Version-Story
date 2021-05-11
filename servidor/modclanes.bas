attribute vb_name = "modclanes"
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

public guilds as new collection



public sub computevote(byval userindex as integer, byval rdata as string)

dim myguild as cguild

set myguild = fetchguild(userlist(userindex).guildinfo.guildname)
if myguild is nothing then exit sub

if not myguild.elections then
   call senddata(toindex, userindex, 0, "||aun no es periodo de elecciones." & fonttype_guild)
   exit sub
end if

if userlist(userindex).guildinfo.yavoto = 1 then
   call senddata(toindex, userindex, 0, "||ya has votado!!! solo se permite un voto por miembro." & fonttype_guild)
   exit sub
end if

if not myguild.ismember(rdata) then
   call senddata(toindex, userindex, 0, "||no hay ningun miembro con ese nombre." & fonttype_guild)
   exit sub
end if


call myguild.votes.add(rdata)
userlist(userindex).guildinfo.yavoto = 1
call senddata(toindex, userindex, 0, "||tu voto ha sido contabilizado." & fonttype_guild)


end sub

public sub resetuservotes(byref myguild as cguild)

on error goto errh

dim k as integer, index as integer
dim userfile as string
for k = 1 to myguild.members.count
       
    index = dameuserindexconnombre(myguild.members(k))
    if index <> 0 then 'is online
        userlist(index).guildinfo.yavoto = 0
    else
        userfile = charpath & ucase$(myguild.members(k)) & ".chr"
        if fileexist(userfile, vbnormal) then
                call writevar(userfile, "guild", "yavoto", 0)
        end if
    end if
    
next k

errh:

end sub


public sub dayelapsed()

on error goto errh

dim t%
dim memberindex as integer
dim userfile as string

for t% = 1 to guilds.count
    
    if guilds(t%).dayssincelastelection < guilds(t%).electionperiod then
        guilds(t%).dayssincelastelection = guilds(t%).dayssincelastelection + 1
    else
       if guilds(t%).elections = false then
            guilds(t%).resetvotes
            call resetuservotes(guilds(t%))
            guilds(t%).elections = true
            
            memberindex = dameguildmemberindex(guilds(t%).guildname)
            
            if memberindex <> 0 then
                call senddata(toguildmembers, memberindex, 0, "||hoy es la votacion para elegir un nuevo lider para el clan!!." & fonttype_guild)
                call senddata(toguildmembers, memberindex, 0, "||la eleccion durara 24 horas, se puede votar a cualquier miembro del clan." & fonttype_guild)
                call senddata(toguildmembers, memberindex, 0, "||para votar escribe /voto nickname." & fonttype_guild)
                call senddata(toguildmembers, memberindex, 0, "||solo se computara un voto por miembro." & fonttype_guild)
            end if
        else
            if guilds(t%).members.count > 1 then
                    'compute elections results
                    dim leader$, newleaderindex as integer, oldleaderindex as integer
                    leader$ = guilds(t%).nuevolider
                    guilds(t%).elections = false
                    memberindex = dameguildmemberindex(guilds(t%).guildname)
                    newleaderindex = dameuserindexconnombre(leader$)
                    oldleaderindex = dameuserindexconnombre(guilds(t%).leader)
                    
                    if ucase$(leader$) <> ucase$(guilds(t%).leader) then
                        
                        
                        
                        if oldleaderindex <> 0 then
                            userlist(oldleaderindex).guildinfo.esguildleader = 0
                        else
                            userfile = charpath & ucase$(guilds(t%).leader) & ".chr"
                            if fileexist(userfile, vbnormal) then
                                    call writevar(userfile, "guild", "esguildleader", 0)
                            end if
                        end if
                        
                        if newleaderindex <> 0 then
                            userlist(newleaderindex).guildinfo.esguildleader = 1
                            call addtovar(userlist(newleaderindex).guildinfo.vecesfueguildleader, 1, 10000)
                        else
                            userfile = charpath & ucase$(leader$) & ".chr"
                            if fileexist(userfile, vbnormal) then
                                    call writevar(userfile, "guild", "esguildleader", 1)
                            end if
                        end if
                        
                        guilds(t%).leader = leader$
                    end if
                    
                    if memberindex <> 0 then
                            call senddata(toguildmembers, memberindex, 0, "||la elecciones han finalizado!!." & fonttype_guild)
                            call senddata(toguildmembers, memberindex, 0, "||el nuevo lider es " & leader$ & fonttype_guild)
                    end if
                    
                    if newleaderindex <> 0 then
                        call senddata(toindex, newleaderindex, 0, "||���has ganado las elecciones, felicitaciones!!!" & fonttype_guild)
                        call giveguildpoints(400, newleaderindex)
                    end if
                    guilds(t%).dayssincelastelection = 0
            end if
        end if
    end if
    
next t%

exit sub

errh:
    call logerror(err.description & " error en dayelapsed.")

end sub

public sub giveguildpoints(byval pts as integer, byval userindex as integer, optional byval sendnotice as boolean = true)

if sendnotice then _
   call senddata(toindex, userindex, 0, "||���has recibido " & pts & " guildpoints!!!" & fonttype_guild)

call addtovar(userlist(userindex).guildinfo.guildpoints, pts, 9000000)

end sub

public sub dropguildpoints(byval pts as integer, byval userindex as integer, optional byval sendnotice as boolean = true)

userlist(userindex).guildinfo.guildpoints = userlist(userindex).guildinfo.guildpoints - pts

'if userlist(userindex).guildinfo.guildpoints < (-5000) then
'
'end if

end sub


public sub acceptpeaceoffer(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(rdata)

if oguild is nothing then exit sub

if not oguild.isenemy(userlist(userindex).guildinfo.guildname) then
    call senddata(toindex, userindex, 0, "||no estas en guerra con el clan." & fonttype_guild)
    exit sub
end if

call oguild.removeenemy(userlist(userindex).guildinfo.guildname)

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

call oguild.removeenemy(rdata)
call oguild.removeproposition(rdata)

dim memberindex as integer

memberindex = dameuserindexconnombre(rdata)

if memberindex <> 0 then _
    call senddata(toguildmembers, memberindex, 0, "||el clan firm� la paz con " & userlist(userindex).guildinfo.guildname & fonttype_guild)
    
call senddata(toguildmembers, userindex, 0, "||el clan firm� la paz con " & rdata & fonttype_guild)




end sub


public sub sendpeacerequest(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim soli as csolicitud

set soli = oguild.getpeacerequest(rdata)

if soli is nothing then exit sub

call senddata(toindex, userindex, 0, "peacede" & soli.desc)

end sub


public sub recievepeaceoffer(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim h$

h$ = ucase$(readfield(1, rdata, 44))

if ucase$(userlist(userindex).guildinfo.guildname) = ucase$(h$) then exit sub

dim oguild as cguild

set oguild = fetchguild(h$)

if oguild is nothing then exit sub

if not oguild.isenemy(userlist(userindex).guildinfo.guildname) then
    call senddata(toindex, userindex, 0, "||no estas en guerra con el clan." & fonttype_guild)
    exit sub
end if

if oguild.isallie(userlist(userindex).guildinfo.guildname) then
    call senddata(toindex, userindex, 0, "||ya estas en paz con el clan." & fonttype_guild)
    exit sub
end if

dim peaceoffer as new csolicitud

peaceoffer.desc = readfield(2, rdata, 44)
peaceoffer.username = userlist(userindex).guildinfo.guildname

if not oguild.includespeaceoffer(peaceoffer.username) then
    call oguild.peacepropositions.add(peaceoffer)
    call senddata(toindex, userindex, 0, "||la propuesta de paz ha sido entregada." & fonttype_guild)
else
    call senddata(toindex, userindex, 0, "||ya has enviado una propuesta de paz." & fonttype_guild)
end if


end sub


public sub sendpeacepropositions(byval userindex as integer)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim l%, k$

if oguild.peacepropositions.count = 0 then exit sub

k$ = "peacepr" & oguild.peacepropositions.count & ","

for l% = 1 to oguild.peacepropositions.count
    k$ = k$ & oguild.peacepropositions(l%).username & ","
next l%

call senddata(toindex, userindex, 0, k$)

end sub



public sub eacharmember(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then
    exit sub
elseif (ucase(userlist(userindex).guildref.leader) <> ucase(userlist(userindex).name)) and (ucase(rdata) <> ucase(userlist(userindex).name)) then
    exit sub
end if

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim memberindex as integer

memberindex = dameuserindexconnombre(rdata)

if memberindex <> 0 then 'esta online
    if userlist(memberindex).guildinfo.esguildleader = 1 then
        call senddata(toguildmembers, memberindex, 0, "||�no pueden expulsar al l�der del clan!" & fonttype_guild)
        exit sub
    end if
    call senddata(toindex, memberindex, 0, "||has sido expulsado del clan." & fonttype_guild)
    call addtovar(userlist(memberindex).guildinfo.echadas, 1, 1000)
    userlist(memberindex).guildinfo.guildpoints = 0
    userlist(memberindex).guildinfo.guildname = ""
    call senddata(toguildmembers, userindex, 0, "||" & rdata & " fue expulsado del clan." & fonttype_guild)
else
    call senddata(toindex, userindex, 0, "||el usuario no esta online." & fonttype_guild)
    exit sub
end if

call oguild.removemember(userlist(memberindex).name)

end sub

public sub denyrequest(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim soli as csolicitud

set soli = oguild.getsolicitud(rdata)

if soli is nothing then exit sub

dim memberindex as integer

memberindex = dameuserindexconnombre(soli.username)

if memberindex <> 0 then 'esta online
    call senddata(toindex, memberindex, 0, "||tu solicitud ha sido rechazada." & fonttype_guild)
    call addtovar(userlist(memberindex).guildinfo.solicitudesrechazadas, 1, 10000)
end if

call oguild.removesolicitud(soli.username)

end sub


public sub acceptclanmember(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim soli as csolicitud

set soli = oguild.getsolicitud(rdata)

if soli is nothing then exit sub

dim memberindex as integer

memberindex = dameuserindexconnombre(soli.username)

if memberindex <> 0 then 'esta online
    
    if userlist(memberindex).guildinfo.guildname <> "" then
        call senddata(toindex, userindex, 0, "||no pod�s aceptar esa solicitud, el pesonaje es lider de otro clan." & fonttype_guild)
        exit sub
    end if
    
    userlist(memberindex).guildinfo.guildname = userlist(userindex).guildinfo.guildname
    call addtovar(userlist(memberindex).guildinfo.clanesparticipo, 1, 1000)
    call senddata(toindex, memberindex, 0, "||felicitaciones, tu solicitud ha sido aceptada." & fonttype_guild)
    call senddata(toindex, memberindex, 0, "||ahora sos un miembro activo del clan " & userlist(userindex).guildinfo.guildname & fonttype_guild)
    call giveguildpoints(25, memberindex)
else
    call senddata(toindex, userindex, 0, "||solo podes aceptar solicitudes cuando el solicitante esta online." & fonttype_guild)
    exit sub
end if

call oguild.members.add(soli.username)
call oguild.removesolicitud(soli.username)
call senddata(toguildmembers, userindex, 0, "tw" & snd_aceptadoclan)
call senddata(toguildmembers, userindex, 0, "||" & rdata & " ha sido aceptado en el clan." & fonttype_guild)


end sub


public sub sendpeticion(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub
    
dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

  
dim soli as csolicitud

set soli = oguild.getsolicitud(rdata)

if soli is nothing then exit sub

call senddata(toindex, userindex, 0, "peticio" & soli.desc)


end sub


public sub solicitudingresoclan(byval userindex as integer, byval data as string)

if esnewbie(userindex) then
   call senddata(toindex, userindex, 0, "||los newbies no pueden conformar clanes." & fonttype_guild)
   exit sub
end if

dim misol as new csolicitud

misol.desc = readfield(2, data, 44)
misol.username = userlist(userindex).name

dim clan$

clan$ = readfield(1, data, 44)


dim oguild as cguild

set oguild = fetchguild(clan$)

if oguild is nothing then exit sub

if oguild.ismember(userlist(userindex).name) then exit sub


if not oguild.solicitudesincludes(misol.username) then
        call addtovar(userlist(userindex).guildinfo.solicitudes, 1, 1000)
        
        call oguild.testsolicitudbound
        call oguild.solicitudes.add(misol)
        
        call senddata(toindex, userindex, 0, "||la solicitud fue recibida por el lider del clan, ahora debes esperar la respuesta." & fonttype_guild)
        exit sub
else
        call senddata(toindex, userindex, 0, "||tu solicitud ya fue recibida por el lider del clan, ahora debes esperar la respuesta." & fonttype_guild)
end if


end sub


public sub sendcharinfo(byval username as string, byval userindex as integer)

'�existe el personaje?

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub


dim userfile as string
userfile = charpath & ucase$(username) & ".chr"

if fileexist(userfile, vbnormal) = false then exit sub

dim miuser as user

miuser.name = username
miuser.raza = getvar(userfile, "init", "raza")
miuser.clase = getvar(userfile, "init", "clase")
miuser.genero = getvar(userfile, "init", "genero")
miuser.stats.elv = val(getvar(userfile, "stats", "elv"))
miuser.stats.gld = val(getvar(userfile, "stats", "gld"))
miuser.stats.banco = val(getvar(userfile, "stats", "banco"))
miuser.reputacion.promedio = val(getvar(userfile, "rep", "promedio"))

dim h$
h$ = "chrinfo" & username & ","
h$ = h$ & miuser.raza & ","
h$ = h$ & miuser.clase & ","
h$ = h$ & miuser.genero & ","
h$ = h$ & miuser.stats.elv & ","
h$ = h$ & miuser.stats.gld & ","
h$ = h$ & miuser.stats.banco & ","
h$ = h$ & miuser.reputacion.promedio & ","


miuser.guildinfo.fundoclan = val(getvar(userfile, "guild", "fundoclan"))
miuser.guildinfo.esguildleader = val(getvar(userfile, "guild", "esguildleader"))
miuser.guildinfo.echadas = val(getvar(userfile, "guild", "echadas"))
miuser.guildinfo.solicitudes = val(getvar(userfile, "guild", "solicitudes"))
miuser.guildinfo.solicitudesrechazadas = val(getvar(userfile, "guild", "solicitudesrechazadas"))
miuser.guildinfo.vecesfueguildleader = val(getvar(userfile, "guild", "vecesfueguildleader"))
'miuser.guildinfo.yavoto = val(getvar(userfile, "guild", "yavoto"))
miuser.guildinfo.clanesparticipo = val(getvar(userfile, "guild", "clanesparticipo"))

h$ = h$ & miuser.guildinfo.fundoclan & ","
h$ = h$ & miuser.guildinfo.esguildleader & ","
h$ = h$ & miuser.guildinfo.echadas & ","
h$ = h$ & miuser.guildinfo.solicitudes & ","
h$ = h$ & miuser.guildinfo.solicitudesrechazadas & ","
h$ = h$ & miuser.guildinfo.vecesfueguildleader & ","
h$ = h$ & miuser.guildinfo.clanesparticipo & ","


miuser.guildinfo.clanfundado = getvar(userfile, "guild", "clanfundado")
miuser.guildinfo.guildname = getvar(userfile, "guild", "guildname")


h$ = h$ & miuser.guildinfo.clanfundado & ","
h$ = h$ & miuser.guildinfo.guildname & ","


miuser.faccion.armadareal = val(getvar(userfile, "facciones", "ejercitoreal"))
miuser.faccion.fuerzascaos = val(getvar(userfile, "facciones", "ejercitocaos"))
miuser.faccion.ciudadanosmatados = val(getvar(userfile, "facciones", "ciudmatados"))
miuser.faccion.criminalesmatados = val(getvar(userfile, "facciones", "crimmatados"))

h$ = h$ & miuser.faccion.armadareal & ","
h$ = h$ & miuser.faccion.fuerzascaos & ","
h$ = h$ & miuser.faccion.ciudadanosmatados & ","


call senddata(toindex, userindex, 0, h$)


end sub



public sub updateguildnews(byval rdata as string, byval userindex as integer)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

oguild.guildnews = rdata

end sub


public sub updatecodexanddesc(byval rdata as string, byval userindex as integer)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

call oguild.updatecodexanddesc(rdata)

end sub

public sub sendguildleaderinfo(byval userindex as integer)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub


dim cad$, t%

'<-------lista de guilds ---------->

cad$ = "leaderi" & guilds.count & "�"

for t% = 1 to guilds.count
    cad$ = cad$ & guilds(t%).guildname & "�"
next t%

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub


'<-------lista de miembros ---------->

cad$ = cad$ & oguild.members.count & "�"

for t% = 1 to oguild.members.count
    cad$ = cad$ & oguild.members.item(t%) & "�"
next t%


'<------- guild news -------->

dim gn$

gn$ = replace(oguild.guildnews, vbcrlf, "�")

cad$ = cad$ & gn$ & "�"

'<------- solicitudes ------->

cad$ = cad$ & oguild.solicitudes.count & "�"

for t% = 1 to oguild.solicitudes.count
    cad$ = cad$ & oguild.solicitudes.item(t%).username & "�"
next t%

call senddata(toindex, userindex, 0, cad$)


end sub

public sub setnewurl(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

oguild.url = rdata

call senddata(toindex, userindex, 0, "||la direccion de la web ha sido actualizada" & fonttype_info)

end sub

public sub declareallie(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

if ucase$(userlist(userindex).guildinfo.guildname) = ucase$(rdata) then exit sub


dim leaderguild as cguild, enemyguild as cguild

set leaderguild = fetchguild(userlist(userindex).guildinfo.guildname)

if leaderguild is nothing then exit sub

set enemyguild = fetchguild(rdata)

if enemyguild is nothing then exit sub

if leaderguild.isenemy(enemyguild.guildname) then
        call senddata(toindex, userindex, 0, "||estas en guerra con �ste clan, antes debes firmar la paz." & fonttype_guild)
else
   if not leaderguild.isallie(enemyguild.guildname) then
        call leaderguild.alliedguilds.add(enemyguild.guildname)
        call enemyguild.alliedguilds.add(leaderguild.guildname)
        
        call senddata(toguildmembers, userindex, 0, "||tu clan ha firmado una alianza con " & enemyguild.guildname & fonttype_guild)
        call senddata(toguildmembers, userindex, 0, "tw" & snd_declarewar)
        
        dim index as integer
        index = dameguildmemberindex(enemyguild.guildname)
        if index <> 0 then
            call senddata(toguildmembers, index, 0, "||" & leaderguild.guildname & " firmo una alianza con tu clan." & fonttype_guild)
            call senddata(toguildmembers, index, 0, "tw" & snd_declarewar)
        end if
   else
        call senddata(toindex, userindex, 0, "||ya estas aliado con �ste clan." & fonttype_guild)
   end if
end if

    


end sub


public sub declarewar(byval userindex as integer, byval rdata as string)

if userlist(userindex).guildinfo.esguildleader = 0 then exit sub

if ucase$(userlist(userindex).guildinfo.guildname) = ucase$(rdata) then exit sub


dim leaderguild as cguild, enemyguild as cguild

set leaderguild = fetchguild(userlist(userindex).guildinfo.guildname)

if leaderguild is nothing then exit sub

set enemyguild = fetchguild(rdata)

if enemyguild is nothing then exit sub

if not leaderguild.isenemy(enemyguild.guildname) then
        
        call leaderguild.removeallie(enemyguild.guildname)
        call enemyguild.removeallie(leaderguild.guildname)
        
        call leaderguild.enemyguilds.add(enemyguild.guildname)
        call enemyguild.enemyguilds.add(leaderguild.guildname)
        
        
        call senddata(toguildmembers, userindex, 0, "||tu clan le declar� la guerra a " & enemyguild.guildname & fonttype_guild)
        call senddata(toguildmembers, userindex, 0, "tw" & snd_declarewar)
        
        dim index as integer
        index = dameguildmemberindex(enemyguild.guildname)
        if index <> 0 then
            call senddata(toguildmembers, index, 0, "||" & leaderguild.guildname & " le declarad� la guerra a tu clan." & fonttype_guild)
            call senddata(toguildmembers, index, 0, "tw" & snd_declarewar)
        end if
else
   call senddata(toindex, userindex, 0, "||tu clan ya esta en guerra con " & enemyguild.guildname & fonttype_guild)
end if


end sub

public function dameguildmemberindex(byval guildname as string) as integer

dim loopc as integer
  
loopc = 1
  
guildname = ucase$(guildname)
  
do until ucase$(userlist(loopc).guildinfo.guildname) = guildname

    loopc = loopc + 1
    
    if loopc > maxusers then
        dameguildmemberindex = 0
        exit function
    end if
    
loop
  
dameguildmemberindex = loopc



end function


public sub sendguildnews(byval userindex as integer)

if userlist(userindex).guildinfo.guildname = "" then exit sub


dim oguild as cguild

set oguild = fetchguild(userlist(userindex).guildinfo.guildname)

if oguild is nothing then exit sub

dim k$

k$ = "guildne" & oguild.guildnews & "�"

dim t%

k$ = k$ & oguild.enemyguilds.count & "�"

for t% = 1 to oguild.enemyguilds.count

    k$ = k$ & oguild.enemyguilds(t%) & "�"
    
next t%

k$ = k$ & oguild.alliedguilds.count & "�"

for t% = 1 to oguild.alliedguilds.count

    k$ = k$ & oguild.alliedguilds(t%) & "�"
    
next t%



call senddata(toindex, userindex, 0, k$)

if oguild.elections then
    call senddata(toindex, userindex, 0, "||hoy es la votacion para elegir un nuevo lider para el clan!!." & fonttype_guild)
    call senddata(toindex, userindex, 0, "||la eleccion durara 24 horas, se puede votar a cualquier miembro del clan." & fonttype_guild)
    call senddata(toindex, userindex, 0, "||para votar escribe /voto nickname." & fonttype_guild)
    call senddata(toindex, userindex, 0, "||solo se computara un voto por miembro." & fonttype_guild)
end if


end sub

public sub sendguildslist(byval userindex as integer)

dim cad$, t%

cad$ = "gl" & guilds.count & ","

for t% = 1 to guilds.count
    cad$ = cad$ & guilds(t%).guildname & ","
next t%

call senddata(toindex, userindex, 0, cad$)

end sub

public function fetchguild(byval guildname as string) as object
dim k as integer
for k = 1 to guilds.count
    if ucase$(guilds.item(k).guildname) = ucase$(guildname) then
            set fetchguild = guilds.item(k)
            exit function
    end if
next k

set fetchguild = nothing

end function

public sub loadguildsdb()

dim file as string, cant as integer

file = app.path & "\guilds\" & "guildsinfo.inf"

if not fileexist(file, vbnormal) then exit sub

cant = val(getvar(file, "init", "nroguilds"))


dim newguild as cguild
dim k%

for k% = 1 to cant
    set newguild = new cguild
    call newguild.initializeguildfromdisk(k%)
    call guilds.add(newguild)
next k%


end sub

public sub sendguilddetails(byval userindex as integer, byval guildname as string)
on error goto errhandler

dim oguild as cguild

if guilds.count = 0 then exit sub

set oguild = fetchguild(guildname)

if oguild is nothing then exit sub

dim cad$

cad$ = "clandet"

cad$ = cad$ & oguild.guildname
cad$ = cad$ & "�" & oguild.founder
cad$ = cad$ & "�" & oguild.fundationdate
cad$ = cad$ & "�" & oguild.leader
cad$ = cad$ & "�" & oguild.url
cad$ = cad$ & "�" & oguild.members.count
cad$ = cad$ & "�" & oguild.daystonextelection
cad$ = cad$ & "�" & oguild.gold
cad$ = cad$ & "�" & oguild.enemyguilds.count
cad$ = cad$ & "�" & oguild.alliedguilds.count

dim codex$

codex$ = oguild.codexlenght()

dim k%

for k% = 0 to oguild.codexlenght()
    codex$ = codex$ & "�" & oguild.getcodex(k%)
next k%


cad$ = cad$ & "�" & codex$ & oguild.description


call senddata(toindex, userindex, 0, cad$)

errhandler:

end sub


public function cancreateguild(byval userindex as integer) as boolean

if userlist(userindex).stats.elv < 25 then
    cancreateguild = false
    call senddata(toindex, userindex, 0, "||para fundar un clan debes de ser nivel 25 o superior." & fonttype_guild)
    exit function
end if

if userlist(userindex).stats.userskills(liderazgo) < 90 then
    cancreateguild = false
    call senddata(toindex, userindex, 0, "||para fundar un clan necesitas al menos 90 pts en liderazgo" & fonttype_guild)
    exit function
end if

cancreateguild = true

end function

public function existeguild(byval name as string) as boolean

dim k as integer
name = ucase$(name)

for k = 1 to guilds.count
    if ucase$(guilds(k).guildname) = name then
            existeguild = true
            exit function
    end if
next k

end function

public function createguild(byval name as string, byval rep as long, byval index as integer, byval guildinfo as string) as boolean

if not cancreateguild(index) then
    createguild = false
    exit function
end if

dim miclan as new cguild

if not miclan.initialize(guildinfo, name, rep) then
    createguild = false
    call senddata(toindex, index, 0, "||los datos del clan son invalidos, asegurate que no contiene caracteres invalidos." & fonttype_guild)
    exit function
end if

if existeguild(miclan.guildname) then
    createguild = false
    call senddata(toindex, index, 0, "||ya ex�ste un clan con ese nombre." & fonttype_guild)
    exit function
end if

call miclan.members.add(ucase$(userlist(index).name))

call guilds.add(miclan, miclan.guildname)

userlist(index).guildinfo.fundoclan = 1
userlist(index).guildinfo.esguildleader = 1

call addtovar(userlist(index).guildinfo.vecesfueguildleader, 1, 10000)
call addtovar(userlist(index).guildinfo.clanesparticipo, 1, 10000)

userlist(index).guildinfo.clanfundado = miclan.guildname
userlist(index).guildinfo.guildname = userlist(index).guildinfo.clanfundado


call giveguildpoints(5000, index)

call senddata(toall, 0, 0, "tw" & snd_creacionclan)
call senddata(toall, 0, 0, "||���" & userlist(index).name & " fundo el clan '" & userlist(index).guildinfo.guildname & "'!!!" & fonttype_guild)

createguild = true

end function


public sub saveguildsdb()

dim j as integer
dim file as string

file = app.path & "\guilds\" & "guildsinfo.inf"

if fileexist(file, vbnormal) then kill file

call writevar(file, "init", "nroguilds", str(guilds.count))

for j = 1 to guilds.count
    
    call guilds(j).saveguild(file, j)
    
next j

end sub
