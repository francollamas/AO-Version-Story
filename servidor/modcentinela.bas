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
'
'zama
'   alkon ao 0.13.0
'   - added several paralel checks
'*****************************************************************

option explicit

private const npc_centinela as integer = 16  '�ndice del npc en el .dat

private const tiempo_inicial as byte = 2 'tiempo inicial en minutos. no reducir sin antes revisar el timer que maneja estos datos.
private const tiempo_pasar_base as integer = 20 'tiempo minimo fijo para volver a pasar
private const tiempo_pasar_random as integer = 10 'tiempo m�ximo para el random para que el centinela vuelva a pasar

private type tcentinela
    npcindex as integer             ' index of centinela en el servidor
    revisandouserindex as integer   '�qu� �ndice revisamos?
    tiemporestante as integer       '�cu�ntos minutos le quedan al usuario?
    clave as integer                'clave que debe escribir
    spawntime as long
    activo as boolean
end type

public centinelaactivado as boolean

'guardo cuando voy a resetear a la lista de usuarios del centinela
private centinelastarttime as long
private centinelainterval as long

private detenerasignacion as boolean

public const nro_centinela as byte = 5
public centinela(1 to nro_centinela) as tcentinela

public sub calluserattention()
'*************************************************
'author: unknown
'last modified: 03/10/2010
'makes noise and fx to call the user's attention.
'03/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************

    'esta el sistema habilitado?
    if not centinelaactivado then exit sub

    dim index as integer
    dim userindex as integer
    
    dim tactual as long
    tactual = (gettickcount() and &h7fffffff)
    
    ' chequea todos los centinelas
    for index = 1 to nro_centinela
        
        with centinela(index)
            
            ' centinela activo?
            if .activo then
            
                userindex = .revisandouserindex
                
                ' esta revisando un usuario?
                if userindex <> 0 then
                    
                    if tactual - .spawntime >= 5000 then
                    
                        if not userlist(userindex).flags.centinelaok then
                            call writeplaywave(userindex, snd_warp, npclist(.npcindex).pos.x, npclist(.npcindex).pos.y)
                            call writecreatefx(userindex, npclist(.npcindex).char.charindex, fxids.fxwarp, 0)
                            
                            'resend the key
                            call centinelasendclave(userindex, index)
                            
                            call flushbuffer(userindex)
                        end if
                    end if
                end if
            end if
        end with
        
    next index
end sub

private sub gotonextworkingchar()
'*************************************************
'author: unknown
'last modified: 03/10/2010
'va al siguiente usuario que se encuentre trabajando
'09/27/2010: c4b3z0n - ahora una vez que termina la lista de usuarios, si se cumplio el tiempo de reset, resetea la info y asigna un nuevo tiempo.
'03/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************

    dim loopc as long
    dim centinelaindex as integer
    
    centinelaindex = getidlecentinela(1)
    
    for loopc = 1 to lastuser
        
        with userlist(loopc)
            
            ' usuario trabajando y no revisado?
            if .flags.userlogged and .counters.trabajando > 0 and (.flags.privilegios and playertype.user) then
                if not .flags.centinelaok and .flags.centinelaindex = 0 then
                    'inicializamos
                    with centinela(centinelaindex)
                        .revisandouserindex = loopc
                        .tiemporestante = tiempo_inicial
                        .clave = randomnumber(1, 32000)
                        .spawntime = gettickcount() and &h7fffffff
                        .activo = true
                    
                    
                        'ponemos al centinela en posici�n
                        call warpcentinela(loopc, centinelaindex)
                        
                        ' spawneo?
                        if .npcindex <> 0 then
                            'mandamos el mensaje (el centinela habla y aparece en consola para que no haya dudas)
                            call writechatoverhead(loopc, "saludos " & userlist(loopc).name & ", soy el centinela de estas tierras. me gustar�a que escribas /centinela " & .clave & " en no m�s de dos minutos.", cstr(npclist(.npcindex).char.charindex), vbgreen)
                            call writeconsolemsg(loopc, "el centinela intenta llamar tu atenci�n. �resp�ndele r�pido!", fonttypenames.fonttype_centinela)
                            call flushbuffer(loopc)
                            
                            ' guardo el indice del centinela
                            userlist(loopc).flags.centinelaindex = centinelaindex
                        end if
                    
                    end with
                        
                    ' si ya se asigno un usuario a cada centinela, me voy
                    centinelaindex = centinelaindex + 1
                    if centinelaindex > nro_centinela then exit sub
                    
                    ' si no queda nadie inactivo, me voy
                    centinelaindex = getidlecentinela(centinelaindex)
                    if centinelaindex = 0 then exit sub
                    
                end if
            end if
            
        end with
        
    next loopc
        
end sub

private function getidlecentinela(byval startcheckindex as integer) as integer
'*************************************************
'author: zama
'last modified: 07/10/2010
'returns the index of the first idle centinela found, starting from a given index.
'*************************************************
    dim index as long
    
    for index = startcheckindex to nro_centinela
        
        if not centinela(index).activo then
            getidlecentinela = index
            exit function
        end if
        
    next index

end function

private sub centinelafinalcheck(byval centiindex as integer)
'*************************************************
'author: unknown
'last modified: 02/10/2010
'al finalizar el tiempo, se retira y realiza la acci�n pertinente dependiendo del caso
'03/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************

on error goto error_handler

    dim userindex as integer
    dim username as string
    
    with centinela(centiindex)
    
        userindex = .revisandouserindex
    
        if not userlist(userindex).flags.centinelaok then
        
            username = userlist(userindex).name
        
            'logueamos el evento
            call logcentinela("centinela ejecuto y ech� a " & username & " por uso de macro inasistido.")
            
            'avisamos a los admins
            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("servidor> el centinela ha ejecutado a " & username & " y lo ech� del juego.", fonttypenames.fonttype_server))
            
            ' evitamos loguear el logout
            .revisandouserindex = 0
            
            call writeshowmessagebox(userindex, "has sido ejecutado por macro inasistido y echado del juego.")
            call userdie(userindex)
            call flushbuffer(userindex)
            call closesocket(userindex)
        end if
        
        .clave = 0
        .tiemporestante = 0
        .revisandouserindex = 0
        .activo = false
        
        if .npcindex <> 0 then
            call quitarnpc(.npcindex)
            .npcindex = 0
        end if
        
    end with
    
    exit sub

error_handler:

    with centinela(centiindex)
        .clave = 0
        .tiemporestante = 0
        .revisandouserindex = 0
        .activo = false
        
        if .npcindex then
            call quitarnpc(.npcindex)
            .npcindex = 0
        end if
    end with
    
    call logerror("error en el checkeo del centinela: " & err.description)
end sub

public sub centinelacheckclave(byval userindex as integer, byval clave as integer)
'*************************************************
'author: unknown
'last modified: 02/10/2010
'corrobora la clave que le envia el usuario
'02/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'08/10/2010: zama - agrego algunos logueos mas coherentes.
'*************************************************

    dim centinelaindex as byte

    centinelaindex = userlist(userindex).flags.centinelaindex
    
    ' no esta siendo revisado por ningun centinela? clickeo a alguno?
    if centinelaindex = 0 then
        
        ' si no clickeo a ninguno, simplemente logueo el evento (sino hago hablar al centi)
        centinelaindex = escentinela(userlist(userindex).flags.targetnpc)
        if centinelaindex = 0 then
            call logcentinela("el usuario " & userlist(userindex).name & " respondi� aunque no se le hablaba a �l..")
            exit sub
        end if
    
    end if
    
    with centinela(centinelaindex)
        if clave = .clave and userindex = .revisandouserindex then
        
            if not userlist(userindex).flags.centinelaok then
        
                userlist(userindex).flags.centinelaok = true
                call writechatoverhead(userindex, "�muchas gracias " & userlist(userindex).name & "! espero no haber sido una molestia.", npclist(.npcindex).char.charindex, vbwhite)
                
                .activo = false
                call flushbuffer(userindex)
                
            else
                'logueamos el evento
                call logcentinela("el usuario " & userlist(userindex).name & " respondi� m�s de una vez la contrase�a correcta.")
            end if
            
        else
            
            'logueamos el evento
            if userindex <> .revisandouserindex then
                call writechatoverhead(userindex, "no es a ti a quien estoy hablando, �no ves?", npclist(.npcindex).char.charindex, vbwhite)
                call logcentinela("el usuario " & userlist(userindex).name & " respondi� aunque no se le hablaba a �l.")
            else
            
                if not userlist(userindex).flags.centinelaok then
                    ' clave incorrecta, la reenvio
                    call centinelasendclave(userindex, centinelaindex)
                    call logcentinela("el usuario " & userlist(userindex).name & " respondi� una clave incorrecta: " & clave & " - se esperaba : " & .clave)
                else
                    call logcentinela("el usuario " & userlist(userindex).name & " respondi� una clave incorrecta despu�s de haber respondido una clave correcta.")
                end if
            end if
        end if
    end with
    
end sub

public sub resetcentinelainfo()
'*************************************************
'author: unknown
'last modified: 02/10/2010
'cada determinada cantidad de tiempo, volvemos a revisar
'07/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************
    dim loopc as long
    
    for loopc = 1 to lastuser
        
        userlist(loopc).flags.centinelaok = false
        userlist(loopc).flags.centinelaindex = 0
        
    next loopc
    
end sub

public sub centinelasendclave(byval userindex as integer, byval centinelaindex as byte)
'*************************************************
'author: unknown
'last modified: 02/10/2010
'enviamos al usuario la clave v�a el personaje centinela
'02/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************

    with centinela(centinelaindex)

        if .npcindex = 0 then exit sub
        
        if .revisandouserindex = userindex then
        
            if not userlist(userindex).flags.centinelaok then
                call writechatoverhead(userindex, "�la clave que te he dicho es /centinela " & .clave & ", escr�belo r�pido!", npclist(.npcindex).char.charindex, vbgreen)
                call writeconsolemsg(userindex, "el centinela intenta llamar tu atenci�n. �respondele r�pido!", fonttypenames.fonttype_centinela)
            else
                call writechatoverhead(userindex, "te agradezco, pero ya me has respondido. me retirar� pronto.", cstr(npclist(.npcindex).char.charindex), vbgreen)
            end if
            
        else
            call writechatoverhead(userindex, "no es a ti a quien estoy hablando, �no ves?", npclist(.npcindex).char.charindex, vbwhite)
        end if
        
    end with
    
end sub

public sub pasarminutocentinela()
'*************************************************
'author: unknown
'last modified: 02/10/2010
'control del timer. llamado cada un minuto.
'03/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************
on error goto errhandler

    dim index as long
    dim userindex as integer
    dim idlecount as integer
    
    if not centinelaactivado then exit sub
    
    ' primero reviso los que estan chequeando usuarios
    for index = 1 to nro_centinela
    
        with centinela(index)
            ' esta activo?
            if .activo then
                .tiemporestante = .tiemporestante - 1
                
                ' temrino el tiempo de chequeo?
                if .tiemporestante = 0 then
                    call centinelafinalcheck(index)
                else
                    
                    userindex = .revisandouserindex
                
                    'recordamos al user que debe escribir
                    if matematicas.distancia(npclist(.npcindex).pos, userlist(userindex).pos) > 5 then
                        call warpcentinela(userindex, index)
                    end if
                    
                    'el centinela habla y se manda a consola para que no quepan dudas
                    call writechatoverhead(userindex, "�" & userlist(userindex).name & ", tienes un minuto m�s para responder! debes escribir /centinela " & .clave & ".", cstr(npclist(.npcindex).char.charindex), vbred)
                    call writeconsolemsg(userindex, "�" & userlist(userindex).name & ", tienes un minuto m�s para responder!", fonttypenames.fonttype_centinela)
                    call flushbuffer(userindex)
                end if
            else
            
                ' lo reseteo aca, para que pueda hablarle al usuario chequeado aunque haya respondido bien.
                if .npcindex <> 0 then
                    if .revisandouserindex <> 0 then
                        userlist(.revisandouserindex).flags.centinelaindex = 0
                        .revisandouserindex = 0
                    end if
                    call quitarnpc(.npcindex)
                    .npcindex = 0
                end if
                
                idlecount = idlecount + 1
            end if
            
        end with
    next index
    
    'verificamos si ya debemos resetear la lista
    dim tactual as long
    tactual = gettickcount() and &h7fffffff
    
    if checkinterval(centinelastarttime, tactual, centinelainterval) then
        detenerasignacion = true ' espero a que terminen de controlar todos los centinelas
    end if

    ' si hay algun centinela libre, se fija si no hay trabajadores disponibles para chequear
    if idlecount <> 0 then
    
        ' si es tiempo de resetear flags, chequeo que no quede nadie activo
        if detenerasignacion then
            
            ' no se completaron los ultimos chequeos
            if idlecount < nro_centinela then exit sub
            
            ' resetea todos los flags
            call resetcentinelainfo
            detenerasignacion = false
            
            ' renuevo el contador de reseteo
            renovarresettimer
            
        end if
        
        call gotonextworkingchar
        
    end if
    
    exit sub
errhandler:
    call logerror("error en pasarminutocentinela. error: " & err.number & " - " & err.description)
end sub

private sub warpcentinela(byval userindex as integer, byval centinelaindex as byte)
'*************************************************
'author: unknown
'last modified: 02/10/2010
'inciamos la revisi�n del usuario userindex
'02/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'*************************************************

    with centinela(centinelaindex)

        'evitamos conflictos de �ndices
        if .npcindex <> 0 then
            call quitarnpc(.npcindex)
            .npcindex = 0
        end if
        
        ' spawn it
        .npcindex = spawnnpc(npc_centinela, userlist(userindex).pos, true, false)
        
        'si no pudimos crear el npc, seguimos esperando a poder hacerlo
        if .npcindex = 0 then
            .revisandouserindex = 0
            .activo = false
        end if
        
    end with
    
end sub

public sub centinelauserlogout(byval centinelaindex as byte)
'*************************************************
'author: unknown
'last modified: 02/11/2010
'el usuario al que revisabamos se desconect�
'02/10/2010: zama - adaptado para que funcione mas de un centinela en paralelo.
'02/11/2010: zama - ahora no loguea que el usuario cerro si puso bien la clave.
'*************************************************
    
    with centinela(centinelaindex)
    
        if .revisandouserindex <> 0 then
        
            'logueamos el evento
            if not userlist(.revisandouserindex).flags.centinelaok then _
                call logcentinela("el usuario " & userlist(.revisandouserindex).name & " se desolgue� al pedirsele la contrase�a.")
            
            'reseteamos y esperamos a otro pasarminuto para ir al siguiente user
            .clave = 0
            .tiemporestante = 0
            .revisandouserindex = 0
            .activo = false
            
            if .npcindex <> 0 then
                call quitarnpc(.npcindex)
                .npcindex = 0
            end if
            
        end if
        
    end with
    
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

public sub resetcentinelas()
'*************************************************
'author: zama
'last modified: 02/10/2010
'resetea todos los centinelas
'*************************************************
    dim index as long
    dim userindex as integer
    
    for index = lbound(centinela) to ubound(centinela)
        
        with centinela(index)
            
            ' si esta activo, reseteo toda la info y quito el npc
            if .activo then
                
                .activo = false
                
                userindex = .revisandouserindex
                if userindex <> 0 then
                    userlist(userindex).flags.centinelaindex = 0
                    userlist(userindex).flags.centinelaok = false
                    .revisandouserindex = 0
                end if
                
                
                .clave = 0
                .tiemporestante = 0
                
                if .npcindex <> 0 then
                    call quitarnpc(.npcindex)
                    .npcindex = 0
                end if
                
            end if
            
        end with
    
    next index
    
    detenerasignacion = false
    renovarresettimer
    
end sub

public function escentinela(byval npcindex as integer) as integer
'*************************************************
'author: zama
'last modified: 07/10/2010
'devuelve true si el indice pertenece a un centinela.
'*************************************************

    dim index as long
    
    if npcindex = 0 then exit function
    
    for index = 1 to nro_centinela
    
        if centinela(index).npcindex = npcindex then
            escentinela = index
            exit function
        end if
        
    next index

end function

private sub renovarresettimer()
'*************************************************
'author: zama
'last modified: 07/10/2010
'renueva el timer que resetea el flag "centinelaok" de todos los usuarios.
'*************************************************

    dim tactual as long
    tactual = gettickcount() and &h7fffffff
    
    centinelainterval = (randomnumber(0, tiempo_pasar_random) + tiempo_pasar_base) * 60 * 1000
end sub
