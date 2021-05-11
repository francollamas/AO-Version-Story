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

public npcs as long
public debugsocket as boolean

public horas as long
public dias as long
public minsrunning as long

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
public intervalomover as integer
public intervalolanzahechizo as integer
public intervalonpcpuedeatacar as integer
public intervalonpcai as integer
public intervaloinvocacion as integer
public intervalouserpuedeatacar as long
public intervalouserpuedecastear as long
public intervalouserpuedetrabajar as long
public intervaloparaconexion as long
public intervalocerrarconexion as long '[gonzalo]
public minutosws as long
public puerto as integer

public maxpasos as long

public bootdelbackup as byte
public lloviendo as boolean

public iplist as new collection
public clientscommandsqueue as byte

'public resetthread as new clsthreading

function versionok(byval ver as string) as boolean
versionok = (ver = ultimaversion)
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
        
        if npclist(i).contadores.tiempoexistencia > 0 then
                call muerenpc(i, 0)
        end if
   end if
   
next i

end sub

sub worldsave()
on error resume next
'call logtarea("sub worldsave")

dim loopx as integer
dim porc as long

call senddata(toall, 0, 0, "||%%%%por favor espere, iniciando worldsave%%%%" & fonttype_info)

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
    
            call savemapdata(loopx)
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

call senddata(toall, 0, 0, "||%%%%worldsave done%%%%" & fonttype_info)


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
                    call senddata(toindex, i, 0, "||has sido liberado!" & fonttype_info)
                end if
                
        end if
        
    end if
next i
end sub


public sub encarcelar(byval userindex as integer, byval minutos as long, optional byval gmname as string = "")
        
        userlist(userindex).counters.pena = minutos
       
        
        call warpuserchar(userindex, prision.map, prision.x, prision.y, true)
        
        if gmname = "" then
            call senddata(toindex, userindex, 0, "||has sido encarcelado, deberas permanecer en la carcel " & minutos & " minutos." & fonttype_info)
        else
            call senddata(toindex, userindex, 0, "||" & gmname & " te ha encarcelado, deberas permanecer en la carcel " & minutos & " minutos." & fonttype_info)
        end if
        
end sub


public sub borrarusuario(byval username as string)
on error resume next
if fileexist(charpath & ucase$(username) & ".chr", vbnormal) then
    kill charpath & ucase$(username) & ".chr"
end if
end sub

public function bancheck(byval name as string) as boolean

bancheck = (val(getvar(app.path & "\charfile\" & name & ".chr", "flags", "ban")) = 1) 'or _
(val(getvar(app.path & "\charfile\" & name & ".chr", "flags", "adminban")) = 1)

end function

public function personajeexiste(byval name as string) as boolean

personajeexiste = fileexist(charpath & ucase$(name) & ".chr", vbnormal)

end function

public function unban(byval name as string) as boolean
'unban the character
call writevar(app.path & "\charfile\" & name & ".chr", "flags", "ban", "0")
'remove it from the banned people database
call writevar(app.path & "\logs\" & "bandetail.dat", name, "bannedby", "nobody")
call writevar(app.path & "\logs\" & "bandetail.dat", name, "reason", "noone")
end function

public function md5ok(byval md5formateado as string) as boolean
    dim i as integer
    for i = 0 to ubound(md5s)
        if (md5formateado = md5s(i)) then
            md5ok = true
            exit function
        end if
    next i
    md5ok = true
end function
