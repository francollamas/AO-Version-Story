attribute vb_name = "admin"
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

public tinicioserver as long
public estadisticasweb as new clsestadisticasipc

'intervalos
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
public intervalooculto as integer '[nacho]
public intervalouserpuedeatacar as long
public intervalogolpeusar as long
public intervalomagiagolpe as long
public intervalogolpemagia as long
public intervalouserpuedecastear as long
public intervalouserpuedetrabajar as long
public intervaloparaconexion as long
public intervalocerrarconexion as long '[gonzalo]
public intervalouserpuedeusar as long
public intervaloflechascazadores as long
public intervalopuedeseratacado as long
public intervaloatacable as long
public intervaloownednpc as long

'balance

public porcentajerecuperomana as integer

public minutosws as long
public puerto as integer

public bootdelbackup as byte
public lloviendo as boolean
public denoche as boolean

function versionok(byval ver as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    versionok = (ver = ultimaversion)
end function

sub respawnorigposnpcs()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next

    dim loopx as integer
    dim porc as long
    
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> iniciando worldsave", fonttypenames.fonttype_server))
    
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
    'if fileexist(datpath & "\bknpcs-hostiles.dat", vbnormal) then kill (datpath & "bknpcs-hostiles.dat")
    
    for loopx = 1 to lastnpc
        if npclist(loopx).flags.backup = 1 then
                call backupnpc(loopx)
        end if
    next
    
    call saveforums
    
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> worldsave ha conclu�do.", fonttypenames.fonttype_server))

end sub

public sub purgarpenas()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim i as long
    
    for i = 1 to lastuser
        if userlist(i).flags.userlogged then
            if userlist(i).counters.pena > 0 then
                userlist(i).counters.pena = userlist(i).counters.pena - 1
                
                if userlist(i).counters.pena < 1 then
                    userlist(i).counters.pena = 0
                    call warpuserchar(i, libertad.map, libertad.x, libertad.y, true)
                    call writeconsolemsg(i, "�has sido liberado!", fonttypenames.fonttype_info)
                    
                    call flushbuffer(i)
                end if
            end if
        end if
    next i
end sub


public sub encarcelar(byval userindex as integer, byval minutos as long, optional byval gmname as string = vbnullstring)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    userlist(userindex).counters.pena = minutos
    
    
    call warpuserchar(userindex, prision.map, prision.x, prision.y, true)
    
    if lenb(gmname) = 0 then
        call writeconsolemsg(userindex, "has sido encarcelado, deber�s permanecer en la c�rcel " & minutos & " minutos.", fonttypenames.fonttype_info)
    else
        call writeconsolemsg(userindex, gmname & " te ha encarcelado, deber�s permanecer en la c�rcel " & minutos & " minutos.", fonttypenames.fonttype_info)
    end if
    if userlist(userindex).flags.traveling = 1 then
        userlist(userindex).flags.traveling = 0
        userlist(userindex).counters.gohome = 0
        call writemultimessage(userindex, emessages.cancelhome)
    end if
end sub


public sub borrarusuario(byval username as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error resume next
    if fileexist(charpath & ucase$(username) & ".chr", vbnormal) then
        kill charpath & ucase$(username) & ".chr"
    end if
end sub

public function bancheck(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    bancheck = (val(getvar(app.path & "\charfile\" & name & ".chr", "flags", "ban")) = 1)

end function

public function personajeexiste(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    personajeexiste = fileexist(charpath & ucase$(name) & ".chr", vbnormal)

end function

public function unban(byval name as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'unban the character
    call writevar(app.path & "\charfile\" & name & ".chr", "flags", "ban", "0")
    
    'remove it from the banned people database
    call writevar(app.path & "\logs\" & "bandetail.dat", name, "bannedby", "nobody")
    call writevar(app.path & "\logs\" & "bandetail.dat", name, "reason", "no reason")
end function

public function md5ok(byval md5formateado as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    banips.add ip
    
    call banipguardar
end sub

public function banipbuscar(byval ip as string) as long
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

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

public function userdarprivilegiolevel(byval name as string) as playertype
'***************************************************
'author: unknown
'last modification: 03/02/07
'last modified by: juan mart�n sotuyo dodero (maraxus)
'***************************************************

    if esadmin(name) then
        userdarprivilegiolevel = playertype.admin
    elseif esdios(name) then
        userdarprivilegiolevel = playertype.dios
    elseif essemidios(name) then
        userdarprivilegiolevel = playertype.semidios
    elseif esconsejero(name) then
        userdarprivilegiolevel = playertype.consejero
    else
        userdarprivilegiolevel = playertype.user
    end if
end function

public sub bancharacter(byval banneruserindex as integer, byval username as string, byval reason as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/02/07
'
'***************************************************

    dim tuser as integer
    dim userpriv as byte
    dim cantpenas as byte
    dim rank as integer
    
    if instrb(username, "+") then
        username = replace(username, "+", " ")
    end if
    
    tuser = nameindex(username)
    
    rank = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero
    
    with userlist(banneruserindex)
        if tuser <= 0 then
            call writeconsolemsg(banneruserindex, "el usuario no est� online.", fonttypenames.fonttype_talk)
            
            if fileexist(charpath & username & ".chr", vbnormal) then
                userpriv = userdarprivilegiolevel(username)
                
                if (userpriv and rank) > (.flags.privilegios and rank) then
                    call writeconsolemsg(banneruserindex, "no puedes banear a al alguien de mayor jerarqu�a.", fonttypenames.fonttype_info)
                else
                    if getvar(charpath & username & ".chr", "flags", "ban") <> "0" then
                        call writeconsolemsg(banneruserindex, "el personaje ya se encuentra baneado.", fonttypenames.fonttype_info)
                    else
                        call logbanfromname(username, banneruserindex, reason)
                        call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("servidor> " & .name & " ha baneado a " & username & ".", fonttypenames.fonttype_server))
                        
                        'ponemos el flag de ban a 1
                        call writevar(charpath & username & ".chr", "flags", "ban", "1")
                        'ponemos la pena
                        cantpenas = val(getvar(charpath & username & ".chr", "penas", "cant"))
                        call writevar(charpath & username & ".chr", "penas", "cant", cantpenas + 1)
                        call writevar(charpath & username & ".chr", "penas", "p" & cantpenas + 1, lcase$(.name) & ": ban por " & lcase$(reason) & " " & date & " " & time)
                        
                        if (userpriv and rank) = (.flags.privilegios and rank) then
                            .flags.ban = 1
                            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(.name & " banned by the server por bannear un administrador.", fonttypenames.fonttype_fight))
                            call closesocket(banneruserindex)
                        end if
                        
                        call loggm(.name, "ban a " & username)
                    end if
                end if
            else
                call writeconsolemsg(banneruserindex, "el pj " & username & " no existe.", fonttypenames.fonttype_info)
            end if
        else
            if (userlist(tuser).flags.privilegios and rank) > (.flags.privilegios and rank) then
                call writeconsolemsg(banneruserindex, "no puedes banear a al alguien de mayor jerarqu�a.", fonttypenames.fonttype_info)
            end if
            
            call logban(tuser, banneruserindex, reason)
            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("servidor> " & .name & " ha baneado a " & userlist(tuser).name & ".", fonttypenames.fonttype_server))
            
            'ponemos el flag de ban a 1
            userlist(tuser).flags.ban = 1
            
            if (userlist(tuser).flags.privilegios and rank) = (.flags.privilegios and rank) then
                .flags.ban = 1
                call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(.name & " banned by the server por bannear un administrador.", fonttypenames.fonttype_fight))
                call closesocket(banneruserindex)
            end if
            
            call loggm(.name, "ban a " & username)
            
            'ponemos el flag de ban a 1
            call writevar(charpath & username & ".chr", "flags", "ban", "1")
            'ponemos la pena
            cantpenas = val(getvar(charpath & username & ".chr", "penas", "cant"))
            call writevar(charpath & username & ".chr", "penas", "cant", cantpenas + 1)
            call writevar(charpath & username & ".chr", "penas", "p" & cantpenas + 1, lcase$(.name) & ": ban por " & lcase$(reason) & " " & date & " " & time)
            
            call closesocket(tuser)
        end if
    end with
end sub

