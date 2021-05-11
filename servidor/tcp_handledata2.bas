attribute vb_name = "tcp_handledata2"
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

public sub handledata_2(byval userindex as integer, rdata as string, byref procesado as boolean)


dim loopc as integer
dim npos as worldpos
dim tstr as string
dim tint as integer
dim tlong as long
dim tindex as integer
dim tname as string
dim tmessage as string
dim auxind as integer
dim arg1 as string
dim arg2 as string
dim arg3 as string
dim arg4 as string
dim ver as string
dim encpass as string
dim pass as string
dim mapa as integer
dim name as string
dim ind
dim n as integer
dim wpaux as worldpos
dim mifile as integer
dim x as integer
dim y as integer
dim dummyint as integer
dim t() as string
dim i as integer

procesado = true 'ver al final del sub


    select case ucase$(rdata)
        case "/online"
            'no se envia m�s la lista completa de usuarios
            n = 0
            for loopc = 1 to lastuser
                if userlist(loopc).name <> "" and userlist(loopc).flags.privilegios <= playertype.consejero then
                    n = n + 1
                end if
            next loopc
            call senddata(sendtarget.toindex, userindex, 0, "||n�mero de usuarios: " & n & fonttype_info)
            exit sub
        
        case "/salir"
            if userlist(userindex).flags.paralizado = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||no puedes salir estando paralizado." & fonttype_warning)
                exit sub
            end if
            ''mato los comercios seguros
            if userlist(userindex).comusu.destusu > 0 then
                if userlist(userlist(userindex).comusu.destusu).flags.userlogged then
                    if userlist(userlist(userindex).comusu.destusu).comusu.destusu = userindex then
                        call senddata(sendtarget.toindex, userlist(userindex).comusu.destusu, 0, "||comercio cancelado por el otro usuario" & fonttype_talk)
                        call fincomerciarusu(userlist(userindex).comusu.destusu)
                    end if
                end if
                call senddata(sendtarget.toindex, userindex, 0, "||comercio cancelado. " & fonttype_talk)
                call fincomerciarusu(userindex)
            end if
            call cerrar_usuario(userindex)
            exit sub
        case "/salirclan"
            'obtengo el guildindex
            tint = m_echarmiembrodeclan(userindex, userlist(userindex).name)
            
            if tint > 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||dejas el clan." & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "||" & userlist(userindex).name & " deja el clan." & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||tu no puedes salir de ning�n clan." & fonttype_guild)
            end if
            
            
            exit sub

            
        case "/balance"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                      call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
            end if
            'se asegura que el target es un npc
            if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
            end if
            if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                      call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                      exit sub
            end if
            select case npclist(userlist(userindex).flags.targetnpc).npctype
            case enpctype.banquero
                if fileexist(charpath & ucase$(userlist(userindex).name) & ".chr", vbnormal) = false then
                      call senddata(sendtarget.toindex, userindex, 0, "!!el personaje no existe, cree uno nuevo.")
                      closesocket (userindex)
                      exit sub
                end if
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
            case enpctype.timbero
                if userlist(userindex).flags.privilegios > playertype.user then
                    tlong = apuestas.ganancias - apuestas.perdidas
                    n = 0
                    if tlong >= 0 and apuestas.ganancias <> 0 then
                        n = int(tlong * 100 / apuestas.ganancias)
                    end if
                    if tlong < 0 and apuestas.perdidas <> 0 then
                        n = int(tlong * 100 / apuestas.perdidas)
                    end if
                    call senddata(sendtarget.toindex, userindex, 0, "||entradas: " & apuestas.ganancias & " salida: " & apuestas.perdidas & " ganancia neta: " & tlong & " (" & n & "%) jugadas: " & apuestas.jugadas & fonttype_info)
                end if
            end select
            exit sub
        case "/quieto" ' << comando a mascotas
             '�esta el user muerto? si es asi no puede comerciar
             if userlist(userindex).flags.muerto = 1 then
                          call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                          exit sub
             end if
             'se asegura que el target es un npc
             if userlist(userindex).flags.targetnpc = 0 then
                      call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                      exit sub
             end if
             if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                          call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                          exit sub
             end if
             if npclist(userlist(userindex).flags.targetnpc).maestrouser <> _
                userindex then exit sub
             npclist(userlist(userindex).flags.targetnpc).movement = tipoai.estatico
             call expresar(userlist(userindex).flags.targetnpc, userindex)
             exit sub
        case "/acompa�ar"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                      call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
            end if
            'se asegura que el target es un npc
            if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
            end if
            if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                      call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                      exit sub
            end if
            if npclist(userlist(userindex).flags.targetnpc).maestrouser <> _
              userindex then exit sub
            call followamo(userlist(userindex).flags.targetnpc)
            call expresar(userlist(userindex).flags.targetnpc, userindex)
            exit sub
        case "/entrenar"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                      call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
            end if
            'se asegura que el target es un npc
            if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
            end if
            if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                      call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                      exit sub
            end if
            if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.entrenador then exit sub
            call enviarlistacriaturas(userindex, userlist(userindex).flags.targetnpc)
            exit sub
        case "/descansar"
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
                exit sub
            end if
            if hayobjarea(userlist(userindex).pos, fogata) then
                    call senddata(sendtarget.toindex, userindex, 0, "dok")
                    if not userlist(userindex).flags.descansar then
                        call senddata(sendtarget.toindex, userindex, 0, "||te acomodas junto a la fogata y comenzas a descansar." & fonttype_info)
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||te levantas." & fonttype_info)
                    end if
                    userlist(userindex).flags.descansar = not userlist(userindex).flags.descansar
            else
                    if userlist(userindex).flags.descansar then
                        call senddata(sendtarget.toindex, userindex, 0, "||te levantas." & fonttype_info)
                        
                        userlist(userindex).flags.descansar = false
                        call senddata(sendtarget.toindex, userindex, 0, "dok")
                        exit sub
                    end if
                    call senddata(sendtarget.toindex, userindex, 0, "||no hay ninguna fogata junto a la cual descansar." & fonttype_info)
            end if
            exit sub
        case "/meditar"
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
                exit sub
            end if
            if userlist(userindex).stats.maxman = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||solo las clases m�gicas conocen el arte de la meditaci�n" & fonttype_info)
                exit sub
            end if
            if userlist(userindex).flags.privilegios > playertype.user then
                userlist(userindex).stats.minman = userlist(userindex).stats.maxman
                call senddata(sendtarget.toindex, userindex, 0, "||mana restaurado" & fonttype_veneno)
                call senduserstatsbox(val(userindex))
                exit sub
            end if
            call senddata(sendtarget.toindex, userindex, 0, "medok")
            if not userlist(userindex).flags.meditando then
               call senddata(sendtarget.toindex, userindex, 0, "||comenzas a meditar." & fonttype_info)
            else
               call senddata(sendtarget.toindex, userindex, 0, "||dejas de meditar." & fonttype_info)
            end if
           userlist(userindex).flags.meditando = not userlist(userindex).flags.meditando
            'barrin 3/10/03 tiempo de inicio al meditar
            if userlist(userindex).flags.meditando then
                userlist(userindex).counters.tiniciomeditar = gettickcount() and &h7fffffff
                call senddata(sendtarget.toindex, userindex, 0, "||te est�s concentrando. en " & tiempo_iniciomeditar & " segundos comenzar�s a meditar." & fonttype_info)
                
                userlist(userindex).char.loops = loopadeternum
                if userlist(userindex).stats.elv < 15 then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxmeditarchico & "," & loopadeternum)
                    userlist(userindex).char.fx = fxids.fxmeditarchico
                elseif userlist(userindex).stats.elv < 30 then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxmeditarmediano & "," & loopadeternum)
                    userlist(userindex).char.fx = fxids.fxmeditarmediano
                elseif userlist(userindex).stats.elv < 45 then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxmeditargrande & "," & loopadeternum)
                    userlist(userindex).char.fx = fxids.fxmeditargrande
                else
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & fxids.fxmeditarxgrande & "," & loopadeternum)
                    userlist(userindex).char.fx = fxids.fxmeditarxgrande
                end if
            else
                userlist(userindex).counters.bpuedemeditar = false
                
                userlist(userindex).char.fx = 0
                userlist(userindex).char.loops = 0
                call senddata(sendtarget.tomap, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
            end if
            exit sub
        case "/resucitar"
           'se asegura que el target es un npc
           if userlist(userindex).flags.targetnpc = 0 then
               call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
               exit sub
           end if
           if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.revividor _
           or userlist(userindex).flags.muerto <> 1 then exit sub
           if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
               call senddata(sendtarget.toindex, userindex, 0, "||el sacerdote no puede resucitarte debido a que estas demasiado lejos." & fonttype_info)
               exit sub
           end if
           call revivirusuario(userindex)
           call senddata(sendtarget.toindex, userindex, 0, "||��h�s sido resucitado!!" & fonttype_info)
           exit sub
        case "/curar"
           'se asegura que el target es un npc
           if userlist(userindex).flags.targetnpc = 0 then
               call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
               exit sub
           end if
           if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.revividor _
           or userlist(userindex).flags.muerto <> 0 then exit sub
           if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
               call senddata(sendtarget.toindex, userindex, 0, "||el sacerdote no puede curarte debido a que estas demasiado lejos." & fonttype_info)
               exit sub
           end if
           userlist(userindex).stats.minhp = userlist(userindex).stats.maxhp
           call senduserstatsbox(userindex)
           call senddata(sendtarget.toindex, userindex, 0, "||��h�s sido curado!!" & fonttype_info)
           exit sub
        case "/ayuda"
           call sendhelp(userindex)
           exit sub
                  
        case "/est"
            call senduserstatstxt(userindex, userindex)
            exit sub
        
        case "/seg"
            if userlist(userindex).flags.seguro then
                call senddata(sendtarget.toindex, userindex, 0, "segoff")
            else
                call senddata(sendtarget.toindex, userindex, 0, "segon")
            end if
            userlist(userindex).flags.seguro = not userlist(userindex).flags.seguro
            exit sub
    
    
        case "/comerciar"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.comerciando then
                call senddata(sendtarget.toindex, userindex, 0, "||ya est�s comerciando" & fonttype_info)
                exit sub
            end if
            
            if userlist(userindex).flags.privilegios = playertype.consejero then
                exit sub
            end if
            '�el target es un npc valido?
            if userlist(userindex).flags.targetnpc > 0 then
                '�el npc puede comerciar?
                if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                    if len(npclist(userlist(userindex).flags.targetnpc).desc) > 0 then call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "no tengo ningun interes en comerciar." & "�" & cstr(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
                if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                    call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                    exit sub
                end if
                'iniciamos la rutina pa' comerciar.
                call iniciarcomercionpc(userindex)
            '[alejo]
            elseif userlist(userindex).flags.targetuser > 0 then
                'comercio con otro usuario
                'puede comerciar ?
                if userlist(userlist(userindex).flags.targetuser).flags.muerto = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||��no puedes comerciar con los muertos!!" & fonttype_info)
                    exit sub
                end if
                'soy yo ?
                if userlist(userindex).flags.targetuser = userindex then
                    call senddata(sendtarget.toindex, userindex, 0, "||no puedes comerciar con vos mismo..." & fonttype_info)
                    exit sub
                end if
                'ta muy lejos ?
                if distancia(userlist(userlist(userindex).flags.targetuser).pos, userlist(userindex).pos) > 3 then
                    call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos del usuario." & fonttype_info)
                    exit sub
                end if
                'ya ta comerciando ? es conmigo o con otro ?
                if userlist(userlist(userindex).flags.targetuser).flags.comerciando = true and _
                    userlist(userlist(userindex).flags.targetuser).comusu.destusu <> userindex then
                    call senddata(sendtarget.toindex, userindex, 0, "||no puedes comerciar con el usuario en este momento." & fonttype_info)
                    exit sub
                end if
                'inicializa unas variables...
                userlist(userindex).comusu.destusu = userlist(userindex).flags.targetuser
                userlist(userindex).comusu.destnick = userlist(userlist(userindex).flags.targetuser).name
                userlist(userindex).comusu.cant = 0
                userlist(userindex).comusu.objeto = 0
                userlist(userindex).comusu.acepto = false
                
                'rutina para comerciar con otro usuario
                call iniciarcomercioconusuario(userindex, userlist(userindex).flags.targetuser)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||primero hace click izquierdo sobre el personaje." & fonttype_info)
            end if
            exit sub
        '[/alejo]
        '[kevin]------------------------------------------
        case "/boveda"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                exit sub
            end if
            '�el target es un npc valido?
            if userlist(userindex).flags.targetnpc > 0 then
                if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                    call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                    exit sub
                end if
                if npclist(userlist(userindex).flags.targetnpc).npctype = enpctype.banquero then
                    call iniciardeposito(userindex)
                end if
            else
                call senddata(sendtarget.toindex, userindex, 0, "||primero hace click izquierdo sobre el personaje." & fonttype_info)
            end if
            exit sub
        '[/kevin]------------------------------------
    
        case "/enlistar"
            'se asegura que el target es un npc
           if userlist(userindex).flags.targetnpc = 0 then
               call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
               exit sub
           end if
           
           if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
           or userlist(userindex).flags.muerto <> 0 then exit sub
           
           if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
               call senddata(sendtarget.toindex, userindex, 0, "||debes acercarte m�s." & fonttype_info)
               exit sub
           end if
           
           if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
                  call enlistararmadareal(userindex)
           else
                  call enlistarcaos(userindex)
           end if
           
           exit sub
        case "/informacion"
           'se asegura que el target es un npc
           if userlist(userindex).flags.targetnpc = 0 then
               call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
               exit sub
           end if
           
           if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
           or userlist(userindex).flags.muerto <> 0 then exit sub
           
           if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
               call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
               exit sub
           end if
           
           if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
                if userlist(userindex).faccion.armadareal = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las tropas reales!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "tu deber es combatir criminales, cada 100 criminales que derrotes te dare una recompensa." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
           else
                if userlist(userindex).faccion.fuerzascaos = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a la legi�n oscura!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "tu deber es sembrar el caos y la desesperanza, cada 100 ciudadanos que derrotes te dare una recompensa." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
           end if
           exit sub
        case "/recompensa"
           'se asegura que el target es un npc
           if userlist(userindex).flags.targetnpc = 0 then
               call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
               exit sub
           end if
           if npclist(userlist(userindex).flags.targetnpc).npctype <> 5 _
           or userlist(userindex).flags.muerto <> 0 then exit sub
           if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 4 then
               call senddata(sendtarget.toindex, userindex, 0, "||el sacerdote no puede curarte debido a que estas demasiado lejos." & fonttype_info)
               exit sub
           end if
           if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
                if userlist(userindex).faccion.armadareal = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a las tropas reales!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
                call recompensaarmadareal(userindex)
           else
                if userlist(userindex).faccion.fuerzascaos = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no perteneces a la legi�n oscura!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
                call recompensacaos(userindex)
           end if
           exit sub
           
        case "/motd"
            call sendmotd(userindex)
            exit sub
            
        case "/uptime"
            tlong = int(((gettickcount() and &h7fffffff) - tinicioserver) / 1000)
            tstr = (tlong mod 60) & " segundos."
            tlong = int(tlong / 60)
            tstr = (tlong mod 60) & " minutos, " & tstr
            tlong = int(tlong / 60)
            tstr = (tlong mod 24) & " horas, " & tstr
            tlong = int(tlong / 24)
            tstr = (tlong) & " dias, " & tstr
            call senddata(sendtarget.toindex, userindex, 0, "||uptime: " & tstr & fonttype_info)
            
            tlong = intervaloautoreiniciar
            tstr = (tlong mod 60) & " segundos."
            tlong = int(tlong / 60)
            tstr = (tlong mod 60) & " minutos, " & tstr
            tlong = int(tlong / 60)
            tstr = (tlong mod 24) & " horas, " & tstr
            tlong = int(tlong / 24)
            tstr = (tlong) & " dias, " & tstr
            call senddata(sendtarget.toindex, userindex, 0, "||pr�ximo mantenimiento autom�tico: " & tstr & fonttype_info)
            exit sub
        
        case "/salirparty"
            call mdparty.salirdeparty(userindex)
            exit sub
        
        case "/crearparty"
            if not mdparty.puedecrearparty(userindex) then exit sub
            call mdparty.crearparty(userindex)
            exit sub
        case "/party"
            call mdparty.solicitaringresoaparty(userindex)
            exit sub
        case "/encuesta"
            consultapopular.sendinfoencuesta (userindex)
    end select

    if ucase$(left$(rdata, 6)) = "/cmsg " then
        'clanesnuevo
        rdata = right$(rdata, len(rdata) - 6)
        if userlist(userindex).guildindex > 0 then
            call senddata(sendtarget.todiosesyclan, userlist(userindex).guildindex, 0, "|+" & userlist(userindex).name & "> " & rdata & fonttype_guildmsg)
            call senddata(sendtarget.toclanarea, userindex, userlist(userindex).pos.map, "||" & vbyellow & "�< " & rdata & " >�" & cstr(userlist(userindex).char.charindex))
        end if
        
        exit sub
    end if
    
    if ucase$(left$(rdata, 6)) = "/pmsg " then
        if len(rdata) > 6 then
            call mdparty.broadcastparty(userindex, mid$(rdata, 7))
            call senddata(sendtarget.topartyarea, userindex, userlist(userindex).pos.map, "||" & vbyellow & "�< " & mid$(rdata, 7) & " >�" & cstr(userlist(userindex).char.charindex))
        end if
        exit sub
    end if
    
    if ucase$(left$(rdata, 11)) = "/centinela " then
        'evitamos overflow y underflow
        if val(right$(rdata, len(rdata) - 11)) > &h7fff or val(right$(rdata, len(rdata) - 11)) < &h8000 then exit sub
        
        tint = val(right$(rdata, len(rdata) - 11))
        call centinelacheckclave(userindex, tint)
        exit sub
    end if
    
    if ucase$(rdata) = "/onlineclan" then
        tstr = modguilds.m_listademiembrosonline(userindex, userlist(userindex).guildindex)
        if userlist(userindex).guildindex <> 0 then
            call senddata(sendtarget.toindex, userindex, 0, "||compa�eros de tu clan conectados: " & tstr & fonttype_guildmsg)
        else
            call senddata(sendtarget.toindex, userindex, 0, "||no pertences a ning�n clan." & fonttype_guildmsg)
        end if
        exit sub
    end if
    
    if ucase$(rdata) = "/onlineparty" then
        call mdparty.onlineparty(userindex)
        exit sub
    end if
    
    '[yb]
    if ucase$(left$(rdata, 6)) = "/bmsg " then
        rdata = right$(rdata, len(rdata) - 6)
        if userlist(userindex).flags.pertalcons = 1 then
            call senddata(sendtarget.toconsejo, userindex, 0, "|| (consejero) " & userlist(userindex).name & "> " & rdata & fonttype_consejo)
        end if
        if userlist(userindex).flags.pertalconscaos = 1 then
            call senddata(sendtarget.toconsejocaos, userindex, 0, "|| (consejero) " & userlist(userindex).name & "> " & rdata & fonttype_consejocaos)
        end if
        exit sub
    end if
    '[/yb]
    
    if ucase$(left$(rdata, 5)) = "/rol " then
        rdata = right$(rdata, len(rdata) - 5)
        call senddata(sendtarget.toindex, 0, 0, "|| " & "su solicitud ha sido enviada" & fonttype_info)
        call senddata(sendtarget.torolesmasters, 0, 0, "|| " & lcase$(userlist(userindex).name) & " pregunta rol: " & rdata & fonttype_guildmsg)
        exit sub
    end if
    
    
    'mensaje del servidor a gms - lo ubico aqui para que no se confunda con /gm [gonzalo]
    if ucase$(left$(rdata, 6)) = "/gmsg " and userlist(userindex).flags.privilegios > playertype.user then
        rdata = right$(rdata, len(rdata) - 6)
        call loggm(userlist(userindex).name, "mensaje a gms:" & rdata, (userlist(userindex).flags.privilegios = playertype.consejero))
        if rdata <> "" then
            call senddata(sendtarget.toadmins, 0, 0, "||" & userlist(userindex).name & "> " & rdata & "~255~255~255~0~1")
        end if
        exit sub
    end if
    
    select case ucase$(left$(rdata, 3))
        case "/gm"
            if not ayuda.existe(userlist(userindex).name) then
                call senddata(sendtarget.toindex, userindex, 0, "||el mensaje ha sido entregado, ahora solo debes esperar que se desocupe algun gm." & fonttype_info)
                call ayuda.push(rdata, userlist(userindex).name)
            else
                call ayuda.quitar(userlist(userindex).name)
                call ayuda.push(rdata, userlist(userindex).name)
                call senddata(sendtarget.toindex, userindex, 0, "||ya habias mandado un mensaje, tu mensaje ha sido movido al final de la cola de mensajes." & fonttype_info)
            end if
            exit sub
    end select
    
    
    
    select case ucase(left(rdata, 5))
        case "/_bug "
            n = freefile
            open app.path & "\logs\bugs.log" for append shared as n
            print #n,
            print #n,
            print #n, "########################################################################"
            print #n, "########################################################################"
            print #n, "usuario:" & userlist(userindex).name & "  fecha:" & date & "    hora:" & time
            print #n, "########################################################################"
            print #n, "bug:"
            print #n, right$(rdata, len(rdata) - 5)
            print #n, "########################################################################"
            print #n, "########################################################################"
            print #n,
            print #n,
            close #n
            exit sub
    
    end select
    
    select case ucase$(left$(rdata, 6))
        case "/desc "
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||no puedes cambiar la descripci�n estando muerto." & fonttype_info)
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 6)
            if not asciivalidos(rdata) then
                call senddata(sendtarget.toindex, userindex, 0, "||la descripcion tiene caracteres invalidos." & fonttype_info)
                exit sub
            end if
            userlist(userindex).desc = trim$(rdata)
            call senddata(sendtarget.toindex, userindex, 0, "||la descripcion a cambiado." & fonttype_info)
            exit sub
        case "/voto "
                rdata = right$(rdata, len(rdata) - 6)
                if not modguilds.v_usuariovota(userindex, rdata, tstr) then
                    call senddata(sendtarget.toindex, userindex, 0, "||voto no contabilizado: " & tstr & fonttype_guild)
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||voto contabilizado." & fonttype_guild)
                end if
                exit sub
    end select
    
    if ucase$(left$(rdata, 7)) = "/penas " then
        name = right$(rdata, len(rdata) - 7)
        if name = "" then exit sub
        
        name = replace(name, "\", "")
        name = replace(name, "/", "")
        
        if fileexist(charpath & name & ".chr", vbnormal) then
            tint = val(getvar(charpath & name & ".chr", "penas", "cant"))
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||sin prontuario.." & fonttype_info)
            else
                while tint > 0
                    call senddata(sendtarget.toindex, userindex, 0, "||" & tint & "- " & getvar(charpath & name & ".chr", "penas", "p" & tint) & fonttype_info)
                    tint = tint - 1
                wend
            end if
        else
            call senddata(sendtarget.toindex, userindex, 0, "||personaje """ & name & """ inexistente." & fonttype_info)
        end if
        exit sub
    end if
    
    
    
    
    
    select case ucase$(left$(rdata, 8))
        case "/passwd "
            rdata = right$(rdata, len(rdata) - 8)
            if len(rdata) < 6 then
                 call senddata(sendtarget.toindex, userindex, 0, "||el password debe tener al menos 6 caracteres." & fonttype_info)
            else
                 call senddata(sendtarget.toindex, userindex, 0, "||el password ha sido cambiado." & fonttype_info)
                 userlist(userindex).password = rdata
            end if
            exit sub
    end select
    
    select case ucase$(left$(rdata, 9))
            'comando /apostar basado en la idea de darklight,
            'pero con distinta probabilidad de exito.
        case "/apostar "
            rdata = right(rdata, len(rdata) - 9)
            tlong = clng(val(rdata))
            if tlong > 32000 then tlong = 32000
            n = tlong
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
            elseif userlist(userindex).flags.targetnpc = 0 then
                'se asegura que el target es un npc
                call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
            elseif distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
            elseif npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.timbero then
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no tengo ningun interes en apostar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            elseif n < 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "el minimo de apuesta es 1 moneda." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            elseif n > 5000 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "el maximo de apuesta es 5000 monedas." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            elseif userlist(userindex).stats.gld < n then
                call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "no tienes esa cantidad." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            else
                if randomnumber(1, 100) <= 47 then
                    userlist(userindex).stats.gld = userlist(userindex).stats.gld + n
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "felicidades! has ganado " & cstr(n) & " monedas de oro!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    
                    apuestas.perdidas = apuestas.perdidas + n
                    call writevar(datpath & "apuestas.dat", "main", "perdidas", cstr(apuestas.perdidas))
                else
                    userlist(userindex).stats.gld = userlist(userindex).stats.gld - n
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "lo siento, has perdido " & cstr(n) & " monedas de oro." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                
                    apuestas.ganancias = apuestas.ganancias + n
                    call writevar(datpath & "apuestas.dat", "main", "ganancias", cstr(apuestas.ganancias))
                end if
                apuestas.jugadas = apuestas.jugadas + 1
                call writevar(datpath & "apuestas.dat", "main", "jugadas", cstr(apuestas.jugadas))
                
                call senduserstatsbox(userindex)
            end if
            exit sub
    end select
    
    select case ucase$(left$(rdata, 10))
            'consultas populares muchacho'
        case "/encuesta "
            rdata = right(rdata, len(rdata) - 10)
            if len(rdata) = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "|| aca va la info de la encuesta" & fonttype_guild)
                exit sub
            end if
            dummyint = clng(val(rdata))
            call senddata(sendtarget.toindex, userindex, 0, "|| " & consultapopular.dovotar(userindex, dummyint) & fonttype_guild)
            exit sub
    end select
    
    
    select case ucase$(left$(rdata, 8))
        case "/retirar" 'retira oro en el banco o te saca de la armada
             '�esta el user muerto? si es asi no puede comerciar
             if userlist(userindex).flags.muerto = 1 then
                      call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
             end if
             'se asegura que el target es un npc
             if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
             end if
             
             if npclist(userlist(userindex).flags.targetnpc).npctype = 5 then
                
                'se quiere retirar de la armada
                if userlist(userindex).faccion.armadareal = 1 then
                    if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 0 then
                        call expulsarfaccionreal(userindex)
                        call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "ser�s bienvenido a las fuerzas imperiales si deseas regresar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                        debug.print "||" & vbwhite & "�" & "ser�s bienvenido a las fuerzas imperiales si deseas regresar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex)
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "���sal de aqu� buf�n!!!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    end if
                elseif userlist(userindex).faccion.fuerzascaos = 1 then
                    if npclist(userlist(userindex).flags.targetnpc).flags.faccion = 1 then
                        call expulsarfaccioncaos(userindex)
                        call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "ya volver�s arrastrandote." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "sal de aqu� maldito criminal" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "�no perteneces a ninguna fuerza!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                end if
                exit sub
             
             end if
             
             if len(rdata) = 8 then
                call senddata(sendtarget.toindex, userindex, 0, "||debes indicar el monto de cuanto quieres retirar" & fonttype_info)
                exit sub
             end if
             
             rdata = right$(rdata, len(rdata) - 9)
             if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.banquero _
             or userlist(userindex).flags.muerto = 1 then exit sub
             if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
                  call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                  exit sub
             end if
             if fileexist(charpath & ucase$(userlist(userindex).name) & ".chr", vbnormal) = false then
                  call senddata(sendtarget.toindex, userindex, 0, "!!el personaje no existe, cree uno nuevo.")
                  closesocket (userindex)
                  exit sub
             end if
             if val(rdata) > 0 and val(rdata) <= userlist(userindex).stats.banco then
                  userlist(userindex).stats.banco = userlist(userindex).stats.banco - val(rdata)
                  userlist(userindex).stats.gld = userlist(userindex).stats.gld + val(rdata)
                  call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
             else
                  call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & " no tenes esa cantidad." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
             end if
             call senduserstatsbox(val(userindex))
             exit sub
    end select
    
    select case ucase$(left$(rdata, 11))
        case "/depositar " 'depositar oro en el banco
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                      call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                      exit sub
            end if
            'se asegura que el target es un npc
            if userlist(userindex).flags.targetnpc = 0 then
                  call senddata(sendtarget.toindex, userindex, 0, "||primero tenes que seleccionar un personaje, hace click izquierdo sobre el." & fonttype_info)
                  exit sub
            end if
            if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 10 then
                      call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                      exit sub
            end if
            rdata = right$(rdata, len(rdata) - 11)
            if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.banquero _
            or userlist(userindex).flags.muerto = 1 then exit sub
            if distancia(userlist(userindex).pos, npclist(userlist(userindex).flags.targetnpc).pos) > 10 then
                  call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                  exit sub
            end if
            if clng(val(rdata)) > 0 and clng(val(rdata)) <= userlist(userindex).stats.gld then
                  userlist(userindex).stats.banco = userlist(userindex).stats.banco + val(rdata)
                  userlist(userindex).stats.gld = userlist(userindex).stats.gld - val(rdata)
                  call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & "tenes " & userlist(userindex).stats.banco & " monedas de oro en tu cuenta." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
            else
                  call senddata(sendtarget.toindex, userindex, 0, "||" & vbwhite & "�" & " no tenes esa cantidad." & "�" & npclist(userlist(userindex).flags.targetnpc).char.charindex & fonttype_info)
            end if
            call senduserstatsbox(val(userindex))
            exit sub
        case "/denunciar "
            if userlist(userindex).flags.silenciado = 1 then
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 11)
            call senddata(sendtarget.toadmins, 0, 0, "|| " & lcase$(userlist(userindex).name) & " denuncia: " & rdata & fonttype_guildmsg)
            call senddata(sendtarget.toindex, userindex, 0, "|| denuncia enviada, espere.." & fonttype_info)
            exit sub
        case "/fundarclan"
        
            rdata = right$(rdata, len(rdata) - 11)
            if trim$(rdata) = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "|| para fundar un clan debes especificar la alineaci�n del mismo." & fonttype_guild)
                call senddata(sendtarget.toindex, userindex, 0, "|| atenci�n, que la misma no podr� cambiar luego, te aconsejamos leer las reglas sobre clanes antes de fundar." & fonttype_guild)
                exit sub
            else
                select case ucase$(trim(rdata))
                    case "armada"
                        userlist(userindex).fundandoguildalineacion = alineacion_armada
                    case "mal"
                        userlist(userindex).fundandoguildalineacion = alineacion_legion
                    case "neutro"
                        userlist(userindex).fundandoguildalineacion = alineacion_neutro
                    case "gm"
                        userlist(userindex).fundandoguildalineacion = alineacion_master
                    case "legal"
                        userlist(userindex).fundandoguildalineacion = alineacion_ciuda
                    case "criminal"
                        userlist(userindex).fundandoguildalineacion = alineacion_criminal
                    case else
                        call senddata(sendtarget.toindex, userindex, 0, "|| alineaci�n inv�lida." & fonttype_guild)
                        exit sub
                end select
            end if

            if modguilds.puedefundarunclan(userindex, userlist(userindex).fundandoguildalineacion, tstr) then
                call senddata(sendtarget.toindex, userindex, 0, "showfun")
            else
                userlist(userindex).fundandoguildalineacion = 0
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            end if
            
            exit sub
    
    end select

    select case ucase$(left$(rdata, 12))
        case "/echarparty "
            rdata = right$(rdata, len(rdata) - 12)
            tint = nameindex(rdata)
            if tint > 0 then
                call mdparty.expulsardeparty(userindex, tint)
            else
                call senddata(sendtarget.toindex, userindex, 0, "|| el personaje no est� online." & fonttype_info)
            end if
            exit sub
        case "/partylider "
            rdata = right$(rdata, len(rdata) - 12)
            tint = nameindex(rdata)
            if tint > 0 then
                call mdparty.transformarenlider(userindex, tint)
            else
                call senddata(sendtarget.toindex, userindex, 0, "|| el personaje no est� online." & fonttype_info)
            end if
            exit sub
    
    end select

    select case ucase$(left$(rdata, 13))
        case "/acceptparty "
            rdata = right$(rdata, len(rdata) - 13)
            tint = nameindex(rdata)
            if tint > 0 then
                call mdparty.aprobaringresoaparty(userindex, tint)
            else
                call senddata(sendtarget.toindex, userindex, 0, "|| el personaje no est� online." & fonttype_info)
            end if
            exit sub
    
    end select
    

    select case ucase$(left$(rdata, 14))
        case "/miembrosclan "
            rdata = trim(right(rdata, len(rdata) - 14))
            name = replace(rdata, "\", "")
            name = replace(rdata, "/", "")
    
            if not fileexist(app.path & "\guilds\" & rdata & "-members.mem") then
                call senddata(sendtarget.toindex, userindex, 0, "|| no existe el clan: " & rdata & fonttype_info)
                exit sub
            end if
            
            tint = val(getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "init", "nromembers"))
            
            for i = 1 to tint
                tstr = getvar(app.path & "\guilds\" & rdata & "-members" & ".mem", "members", "member" & i)
                'tstr es la victima
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & "<" & rdata & ">." & fonttype_info)
            next i
        
            exit sub
    end select
    
    procesado = false
end sub
