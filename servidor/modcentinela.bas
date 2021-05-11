attribute vb_name = "modcentinela"
'*****************************************************************
'modcentinela.bas - imperiumao - v1.2
'
'funci�nes de control para usuarios que se encuentran trabajando
'
'*****************************************************************
'respective portions copyrighted by contributors listed below.
'
'this library is free software; you can redistribute it and/or
'modify it under the terms of the gnu lesser general public
'license as published by the free software foundation version 2.1 of
'the license
'
'this library is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the gnu
'lesser general public license for more details.
'
'you should have received a copy of the gnu lesser general public
'license along with this library; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa

'*****************************************************************
'augusto rando(barrin@imperiumao.com.ar)
'   - first relase
'
'juan mart�n sotuyo dodero (juansotuyo@gmail.com)
'   - adapted to alkon ao
'   - small improvements and added logs to detect possible cheaters
'*****************************************************************

option explicit

private const npc_centinela_tierra as integer = 16  '�ndice del npc en el .dat
private const npc_centinela_agua as integer = 16     '�dem anterior, pero en mapas de agua

public centinelanpcindex as integer                '�ndice del npc en el servidor

private const tiempo_inicial as byte = 2 'tiempo inicial en minutos. no reducir sin antes revisar el timer que maneja estos datos.

private type tcentinela
    revisandouserindex as integer   '�qu� �ndice revisamos?
    tiemporestante as integer       '�cu�ntos minutos le quedan al usuario?
    clave as integer                'clave que debe escribir
end type

public centinelaactivado as boolean

public centinela as tcentinela

private sub gotonextworkingchar()
'############################################################
'va al siguiente usuario que se encuentre trabajando
'############################################################
    dim loopc as long
    
    for loopc = 1 to lastuser
        if userlist(loopc).name <> "" and userlist(loopc).counters.trabajando > 0 and userlist(loopc).flags.privilegios = playertype.user then
            if not userlist(loopc).flags.centinelaok then
                'inicializamos
                centinela.revisandouserindex = loopc
                centinela.tiemporestante = tiempo_inicial
                centinela.clave = randomnumber(1, 36000)
                
                'ponemos al centinela en posici�n
                call warpcentinela(loopc)
                
                if centinelanpcindex then
                    'mandamos el mensaje (el centinela habla y aparece en consola para que no haya dudas
                    call senddata(sendtarget.toindex, loopc, 0, "||" & vbgreen & "�" & "saludos " & userlist(loopc).name & ", soy el centinela de estas tierras. me gustar�a que escribas /centinela " & centinela.clave & " en no m�s de dos minutos." & "�" & cstr(npclist(centinelanpcindex).char.charindex))
                    call senddata(sendtarget.toindex, loopc, 0, "||" & "saludos " & userlist(loopc).name & ", soy el centinela de estas tierras. me gustar�a que escribas /centinela " & centinela.clave & " en no m�s de dos minutos." & fonttype_centinela)
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
        call senddata(sendtarget.toadmins, 0, 0, "||servidor> el centinela ha baneado a " & name & fonttype_server)
        
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
        centinela.revisandouserindex = 0
        call senddata(sendtarget.toindex, centinela.revisandouserindex, 0, "||" & vbwhite & "�" & "�muchas gracias " & userlist(centinela.revisandouserindex).name & "! espero no haber sido una molestia" & "�" & cstr(npclist(centinelanpcindex).char.charindex))
    else
        call centinelasendclave(userindex)
        
        if userindex <> centinela.revisandouserindex then
            'logueamos el evento
            call logcentinela("el usuario " & userlist(userindex).name & " respondi� aunque no se le hablaba a �l.")
        end if
    end if
end sub

public sub resetcentinelainfo()
'############################################################
'cada determinada cantidad de tiempo, volvemos a revisar
'############################################################
    dim loopc as long
    
    for loopc = 1 to lastuser
        if (userlist(loopc).name <> "" and loopc <> centinela.revisandouserindex) then
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
            call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "�la clave que te he dicho es " & "/centinela " & centinela.clave & " escr�belo r�pido!" & "�" & cstr(npclist(centinelanpcindex).char.charindex))
        else
            'logueamos el evento
            call logcentinela("el usuario " & userlist(centinela.revisandouserindex).name & " respondi� m�s de una vez la contrase�a correcta.")
            call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "te agradezco, pero ya me has respondido. me retirar� pronto." & "�" & cstr(npclist(centinelanpcindex).char.charindex))
        end if
    else
        call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no es a ti a quien estoy hablando, �no ves?" & "�" & cstr(npclist(centinelanpcindex).char.charindex))
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
            call senddata(sendtarget.toindex, centinela.revisandouserindex, 0, "||" & vbred & "��" & userlist(centinela.revisandouserindex).name & ", tienes un minuto m�s para responder! debes escribir /centinela " & centinela.clave & "." & "�" & cstr(npclist(centinelanpcindex).char.charindex))
            call senddata(sendtarget.toindex, centinela.revisandouserindex, 0, "||" & "�" & userlist(centinela.revisandouserindex).name & ", tienes un minuto m�s para responder! debes escribir /centinela " & centinela.clave & "." & fonttype_centinela)
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
        'revisamos si no respondi� ya
        if userlist(centinela.revisandouserindex).flags.centinelaok then exit sub
        
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
