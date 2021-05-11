attribute vb_name = "modcentinela"
'*****************************************************************
'modcentinela.bas - imperiumao - v1.2
'
'funci�nes de control para usuarios que se encuentran trabajando
'
'*****************************************************************
'respective portions copyrighted by contributors listed below.
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

'*****************************************************************
'augusto rando(barrin@imperiumao.com.ar)
'   imperiumao 1.2
'   - first relase
'
'juan mart�n sotuyo dodero (juansotuyo@gmail.com)
'   alkon ao 0.11.5
'   - small improvements and added logs to detect possible cheaters
'
'juan mart�n sotuyo dodero (juansotuyo@gmail.com)
'   alkon ao 0.12.0
'   - added several messages to spam users until they reply
'*****************************************************************

option explicit

private const npc_centinela_tierra as integer = 16  '�ndice del npc en el .dat
private const npc_centinela_agua as integer = 16    '�dem anterior, pero en mapas de agua

public centinelanpcindex as integer                '�ndice del npc en el servidor

private const tiempo_inicial as byte = 2 'tiempo inicial en minutos. no reducir sin antes revisar el timer que maneja estos datos.

private type tcentinela
    revisandouserindex as integer   '�qu� �ndice revisamos?
    tiemporestante as integer       '�cu�ntos minutos le quedan al usuario?
    clave as integer                'clave que debe escribir
    spawntime as long
end type

public centinelaactivado as boolean

public centinela as tcentinela

public sub calluserattention()
'############################################################
'makes noise and fx to call the user's attention.
'############################################################
    if (gettickcount() and &h7fffffff) - centinela.spawntime >= 5000 then
        if centinela.revisandouserindex <> 0 and centinelaactivado then
            if not userlist(centinela.revisandouserindex).flags.centinelaok then
                call writeplaywave(centinela.revisandouserindex, snd_warp, npclist(centinelanpcindex).pos.x, npclist(centinelanpcindex).pos.y)
                call writecreatefx(centinela.revisandouserindex, npclist(centinelanpcindex).char.charindex, fxids.fxwarp, 0)
                
                'resend the key
                call centinelasendclave(centinela.revisandouserindex)
                
                call flushbuffer(centinela.revisandouserindex)
            end if
        end if
    end if
end sub

private sub gotonextworkingchar()
'############################################################
'va al siguiente usuario que se encuentre trabajando
'############################################################
    dim loopc as long
    
    for loopc = 1 to lastuser
        if userlist(loopc).flags.userlogged and userlist(loopc).counters.trabajando > 0 and (userlist(loopc).flags.privilegios and playertype.user) then
            if not userlist(loopc).flags.centinelaok then
                'inicializamos
                centinela.revisandouserindex = loopc
                centinela.tiemporestante = tiempo_inicial
                centinela.clave = randomnumber(1, 32000)
                centinela.spawntime = gettickcount() and &h7fffffff
                
                'ponemos al centinela en posici�n
                call warpcentinela(loopc)
                
                if centinelanpcindex then
                    'mandamos el mensaje (el centinela habla y aparece en consola para que no haya dudas)
                    call writechatoverhead(loopc, "saludos " & userlist(loopc).name & ", soy el centinela de estas tierras. me gustar�a que escribas /centinela " & centinela.clave & " en no m�s de dos minutos.", cstr(npclist(centinelanpcindex).char.charindex), vbgreen)
                    call writeconsolemsg(loopc, "el centinela intenta llamar tu atenci�n. �resp�ndele r�pido!", fonttypenames.fonttype_centinela)
                    call flushbuffer(loopc)
                end if
                exit sub
            end if
        end if
    next loopc
    
    'no hay chars trabajando, eliminamos el npc si todav�a estaba en alg�n lado y esperamos otro minuto
    if centinelanpcindex then
        call quitarnpc(centinelanpcindex)
        centinelanpcindex = 0
    end if
    
    'no estamos revisando a nadie
    centinela.revisandouserindex = 0
end sub

private sub centinelafinalcheck()
'############################################################
'al finalizar el tiempo, se retira y realiza la acci�n
'pertinente dependiendo del caso
'############################################################
on error goto error_handler
    dim name as string
    dim numpenas as integer
    
    if not userlist(centinela.revisandouserindex).flags.centinelaok then
        'logueamos el evento
        call logcentinela("centinela baneo a " & userlist(centinela.revisandouserindex).name & " por uso de macro inasistido")
        
        'ponemos el ban
        userlist(centinela.revisandouserindex).flags.ban = 1
        
        name = userlist(centinela.revisandouserindex).name
        
        'avisamos a los admins
        call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("servidor> el centinela ha baneado a " & name, fonttypenames.fonttype_server))
        
        'ponemos el flag de ban a 1
        call writevar(charpath & name & ".chr", "flags", "ban", "1")
        'ponemos la pena
        numpenas = val(getvar(charpath & name & ".chr", "penas", "cant"))
        call writevar(charpath & name & ".chr", "penas", "cant", numpenas + 1)
        call writevar(charpath & name & ".chr", "penas", "p" & numpenas + 1, "centinela : ban por macro inasistido " & date & " " & time)
        
        'evitamos loguear el logout
        dim index as integer
        index = centinela.revisandouserindex
        centinela.revisandouserindex = 0
        
        call closesocket(index)
    end if
    
    centinela.clave = 0
    centinela.tiemporestante = 0
    centinela.revisandouserindex = 0
    
    if centinelanpcindex then
        call quitarnpc(centinelanpcindex)
        centinelanpcindex = 0
    end if
exit sub

error_handler:
    centinela.clave = 0
    centinela.tiemporestante = 0
    centinela.revisandouserindex = 0
    
    if centinelanpcindex then
        call quitarnpc(centinelanpcindex)
        centinelanpcindex = 0
    end if
    
    call logerror("error en el checkeo del centinela: " & err.description)
end sub

public sub centinelacheckclave(byval userindex as integer, byval clave as integer)
'############################################################
'corrobora la clave que le envia el usuario
'############################################################
    if clave = centinela.clave and userindex = centinela.revisandouserindex then
        userlist(centinela.revisandouserindex).flags.centinelaok = true
        call writechatoverhead(userindex, "�muchas gracias " & userlist(centinela.revisandouserindex).name & "! espero no haber sido una molestia", cstr(npclist(centinelanpcindex).char.charindex), vbwhite)
        centinela.revisandouserindex = 0
        call flushbuffer(userindex)
    else
        call centinelasendclave(userindex)
        
        'logueamos el evento
        if userindex <> centinela.revisandouserindex then
            call logcentinela("el usuario " & userlist(userindex).name & " respondi� aunque no se le hablaba a �l.")
        else
            call logcentinela("el usuario " & userlist(userindex).name & " respondi� una clave incorrecta: " & clave & " - se esperaba : " & centinela.clave)
        end if
    end if
end sub

public sub resetcentinelainfo()
'############################################################
'cada determinada cantidad de tiempo, volvemos a revisar
'############################################################
    dim loopc as long
    
    for loopc = 1 to lastuser
        if (lenb(userlist(loopc).name) <> 0 and loopc <> centinela.revisandouserindex) then
            userlist(loopc).flags.centinelaok = false
        end if
    next loopc
end sub

public sub centinelasendclave(byval userindex as integer)
'############################################################
'enviamos al usuario la clave v�a el personaje centinela
'############################################################
    if centinelanpcindex = 0 then exit sub
    
    if userindex = centinela.revisandouserindex then
        if not userlist(userindex).flags.centinelaok then
            call writechatoverhead(userindex, "�la clave que te he dicho es /centinela " & centinela.clave & ", escr�belo r�pido!", cstr(npclist(centinelanpcindex).char.charindex), vbgreen)
            call writeconsolemsg(userindex, "el centinela intenta llamar tu atenci�n. �respondele r�pido!", fonttypenames.fonttype_centinela)
        else
            'logueamos el evento
            call logcentinela("el usuario " & userlist(centinela.revisandouserindex).name & " respondi� m�s de una vez la contrase�a correcta.")
            call writechatoverhead(userindex, "te agradezco, pero ya me has respondido. me retirar� pronto.", cstr(npclist(centinelanpcindex).char.charindex), vbgreen)
        end if
    else
        call writechatoverhead(userindex, "no es a ti a quien estoy hablando, �no ves?", cstr(npclist(centinelanpcindex).char.charindex), vbwhite)
    end if
end sub

public sub pasarminutocentinela()
'############################################################
'control del timer. llamado cada un minuto.
'############################################################
    if not centinelaactivado then exit sub
    
    if centinela.revisandouserindex = 0 then
        call gotonextworkingchar
    else
        centinela.tiemporestante = centinela.tiemporestante - 1
        
        if centinela.tiemporestante = 0 then
            call centinelafinalcheck
            call gotonextworkingchar
        else
            'recordamos al user que debe escribir
            if matematicas.distancia(npclist(centinelanpcindex).pos, userlist(centinela.revisandouserindex).pos) > 5 then
                call warpcentinela(centinela.revisandouserindex)
            end if
            
            'el centinela habla y se manda a consola para que no quepan dudas
            call writechatoverhead(centinela.revisandouserindex, "�" & userlist(centinela.revisandouserindex).name & ", tienes un minuto m�s para responder! debes escribir /centinela " & centinela.clave & ".", cstr(npclist(centinelanpcindex).char.charindex), vbred)
            call writeconsolemsg(centinela.revisandouserindex, "�" & userlist(centinela.revisandouserindex).name & ", tienes un minuto m�s para responder!", fonttypenames.fonttype_centinela)
            call flushbuffer(centinela.revisandouserindex)
        end if
    end if
end sub

private sub warpcentinela(byval userindex as integer)
'############################################################
'inciamos la revisi�n del usuario userindex
'############################################################
    'evitamos conflictos de �ndices
    if centinelanpcindex then
        call quitarnpc(centinelanpcindex)
        centinelanpcindex = 0
    end if
    
    if hayagua(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y) then
        centinelanpcindex = spawnnpc(npc_centinela_agua, userlist(userindex).pos, true, false)
    else
        centinelanpcindex = spawnnpc(npc_centinela_tierra, userlist(userindex).pos, true, false)
    end if
    
    'si no pudimos crear el npc, seguimos esperando a poder hacerlo
    if centinelanpcindex = 0 then _
        centinela.revisandouserindex = 0
end sub

public sub centinelauserlogout()
'############################################################
'el usuario al que revisabamos se desconect�
'############################################################
    if centinela.revisandouserindex then
        'logueamos el evento
        call logcentinela("el usuario " & userlist(centinela.revisandouserindex).name & " se desolgue� al pedirsele la contrase�a")
        
        'reseteamos y esperamos a otro pasarminuto para ir al siguiente user
        centinela.clave = 0
        centinela.tiemporestante = 0
        centinela.revisandouserindex = 0
        
        if centinelanpcindex then
            call quitarnpc(centinelanpcindex)
            centinelanpcindex = 0
        end if
    end if
end sub

private sub logcentinela(byval texto as string)
'*************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modified: 03/15/2006
'loguea un evento del centinela
'*************************************************
on error goto errhandler

    dim nfile as integer
    nfile = freefile ' obtenemos un canal
    
    open app.path & "\logs\centinela.log" for append shared as #nfile
    print #nfile, date & " " & time & " " & texto
    close #nfile
exit sub

errhandler:
end sub
