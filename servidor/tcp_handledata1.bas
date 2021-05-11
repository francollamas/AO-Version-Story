attribute vb_name = "tcp_handledata1"
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

public sub handledata_1(byval userindex as integer, rdata as string, byref procesado as boolean)


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

    select case ucase$(left$(rdata, 1))
        case ";" 'hablar
            rdata = right$(rdata, len(rdata) - 1)
            if instr(rdata, "�") then
                exit sub
            end if
        
            '[consejeros]
            if userlist(userindex).flags.privilegios = playertype.consejero then
                call loggm(userlist(userindex).name, "dijo: " & rdata, true)
            end if
            
            ind = userlist(userindex).char.charindex
            
            'piedra libre para todos los compas!
            if userlist(userindex).flags.oculto > 0 then
                userlist(userindex).flags.oculto = 0
                if userlist(userindex).flags.invisible = 0 then
                    call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
                    call senddata(sendtarget.toindex, userindex, 0, "||�has vuelto a ser visible!" & fonttype_info)
                end if
            end if
            
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.todeadarea, userindex, userlist(userindex).pos.map, "||12632256�" & rdata & "�" & cstr(ind))
            else
                call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & rdata & "�" & cstr(ind))
            end if
            exit sub
        case "-" 'gritar
            if userlist(userindex).flags.muerto = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! los muertos no pueden comunicarse con el mundo de los vivos. " & fonttype_info)
                    exit sub
            end if
            rdata = right$(rdata, len(rdata) - 1)
            if instr(rdata, "�") then
                exit sub
            end if
            '[consejeros]
            if userlist(userindex).flags.privilegios = playertype.consejero then
                call loggm(userlist(userindex).name, "grito: " & rdata, true)
            end if
    
            'piedra libre para todos los compas!
            if userlist(userindex).flags.oculto > 0 then
                userlist(userindex).flags.oculto = 0
                if userlist(userindex).flags.invisible = 0 then
                    call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
                    call senddata(sendtarget.toindex, userindex, 0, "||�has vuelto a ser visible!" & fonttype_info)
                end if
            end if
    
    
            ind = userlist(userindex).char.charindex
            call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & vbred & "�" & rdata & "�" & str(ind))
            exit sub
        case "\" 'susurrar al oido
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! los muertos no pueden comunicarse con el mundo de los vivos. " & fonttype_info)
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 1)
            tname = readfield(1, rdata, 32)
            
            'a los dioses y admins no vale susurrarles si no sos uno vos mismo (as� no pueden ver si est�n conectados o no)
            if (esdios(tname) or esadmin(tname)) and userlist(userindex).flags.privilegios < playertype.dios then
                call senddata(sendtarget.toindex, userindex, 0, "||no puedes susurrarle a los dioses y admins." & fonttype_info)
                exit sub
            end if
            
            'a los consejeros y semidioses no vale susurrarles si sos un pj com�n.
            if userlist(userindex).flags.privilegios = playertype.user and (essemidios(tname) or esconsejero(tname)) then
                call senddata(sendtarget.toindex, userindex, 0, "||no puedes susurrarle a los gms" & fonttype_info)
                exit sub
            end if
            
            tindex = nameindex(tname)
            if tindex <> 0 then
                if len(rdata) <> len(tname) then
                    tmessage = right$(rdata, len(rdata) - (1 + len(tname)))
                else
                    tmessage = " "
                end if
                if not estapcarea(userindex, tindex) then
                    call senddata(sendtarget.toindex, userindex, 0, "||estas muy lejos del usuario." & fonttype_info)
                    exit sub
                end if
                ind = userlist(userindex).char.charindex
                if instr(tmessage, "�") then
                    exit sub
                end if
                
                '[consejeros]
                if userlist(userindex).flags.privilegios = playertype.consejero then
                    call loggm(userlist(userindex).name, "le dijo a '" & userlist(tindex).name & "' " & tmessage, true)
                end if
    
                call senddata(sendtarget.toindex, userindex, userlist(userindex).pos.map, "||" & vbblue & "�" & tmessage & "�" & str(ind))
                call senddata(sendtarget.toindex, tindex, userlist(userindex).pos.map, "||" & vbblue & "�" & tmessage & "�" & str(ind))
                '[cdt 17-02-2004]
                if userlist(userindex).flags.privilegios < playertype.semidios then
                    call senddata(sendtarget.toadminsareabutconsejeros, userindex, userlist(userindex).pos.map, "||" & vbyellow & "�" & "a " & userlist(tindex).name & "> " & tmessage & "�" & str(ind))
                end if
                '[/cdt]
                exit sub
            end if
            call senddata(sendtarget.toindex, userindex, 0, "||usuario inexistente. " & fonttype_info)
            exit sub
        case "m" 'moverse
            dim dummy as long
            dim temptick as long
            if userlist(userindex).flags.timeswalk >= 30 then
                temptick = gettickcount and &h7fffffff
                dummy = (temptick - userlist(userindex).flags.startwalk)
                if dummy < 6050 then
                    if temptick - userlist(userindex).flags.countsh > 90000 then
                        userlist(userindex).flags.countsh = 0
                    end if
                    if not userlist(userindex).flags.countsh = 0 then
                        dummy = 126000 \ dummy
                        call loghackattemp("tramposo sh: " & userlist(userindex).name & " , " & dummy)
                        call senddata(sendtarget.toadmins, 0, 0, "||servidor> " & userlist(userindex).name & " ha sido echado por el servidor por posible uso de sh." & fonttype_server)
                        call closesocket(userindex)
                        exit sub
                    else
                        userlist(userindex).flags.countsh = temptick
                    end if
                end if
                userlist(userindex).flags.startwalk = temptick
                userlist(userindex).flags.timeswalk = 0
            end if
            
            userlist(userindex).flags.timeswalk = userlist(userindex).flags.timeswalk + 1
            
            rdata = right$(rdata, len(rdata) - 1)
            
            'salida parche
            if userlist(userindex).counters.saliendo then
                call senddata(sendtarget.toindex, userindex, 0, "||/salir cancelado." & fonttype_warning)
                userlist(userindex).counters.saliendo = false
                userlist(userindex).counters.salir = 0
            end if
            
            if userlist(userindex).flags.paralizado = 0 then
                if not userlist(userindex).flags.descansar and not userlist(userindex).flags.meditando then
                    call moveuserchar(userindex, val(rdata))
                elseif userlist(userindex).flags.descansar then
                    userlist(userindex).flags.descansar = false
                    call senddata(sendtarget.toindex, userindex, 0, "dok")
                    call senddata(sendtarget.toindex, userindex, 0, "||has dejado de descansar." & fonttype_info)
                    call moveuserchar(userindex, val(rdata))
                elseif userlist(userindex).flags.meditando then
                    userlist(userindex).flags.meditando = false
                    call senddata(sendtarget.toindex, userindex, 0, "medok")
                    call senddata(sendtarget.toindex, userindex, 0, "||dejas de meditar." & fonttype_info)
                    userlist(userindex).char.fx = 0
                    userlist(userindex).char.loops = 0
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "cfx" & userlist(userindex).char.charindex & "," & 0 & "," & 0)
                end if
            else    'paralizado
                '[cdt 17-02-2004] (<- emmmmm ?????)
                if not userlist(userindex).flags.ultimomensaje = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||no podes moverte porque estas paralizado." & fonttype_info)
                    userlist(userindex).flags.ultimomensaje = 1
                end if
                '[/cdt]
                userlist(userindex).flags.countsh = 0
            end if
            
            if userlist(userindex).flags.oculto = 1 then
                if ucase$(userlist(userindex).clase) <> "ladron" then
                    userlist(userindex).flags.oculto = 0
                    if userlist(userindex).flags.invisible = 0 then
                        call senddata(sendtarget.toindex, userindex, 0, "||has vuelto a ser visible." & fonttype_info)
                        call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
                    end if
                end if
            end if
            
            if userlist(userindex).flags.muerto = 1 then
                call empollando(userindex)
            else
                userlist(userindex).flags.estaempo = 0
                userlist(userindex).empocont = 0
            end if
            exit sub
    end select
    
    select case ucase$(rdata)
        case "rpu" 'pedido de actualizacion de la posicion
            call senddata(sendtarget.toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
            exit sub
        case "at"
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��no podes atacar a nadie porque estas muerto!!. " & fonttype_info)
                exit sub
            end if
            if not userlist(userindex).flags.modocombate then
                call senddata(sendtarget.toindex, userindex, 0, "||no estas en modo de combate, presiona la tecla ""c"" para pasar al modo combate. " & fonttype_info)
            else
                if userlist(userindex).invent.weaponeqpobjindex > 0 then
                    if objdata(userlist(userindex).invent.weaponeqpobjindex).proyectil = 1 then
                        call senddata(sendtarget.toindex, userindex, 0, "||no pod�s usar asi esta arma." & fonttype_info)
                        exit sub
                    end if
                end if
                call usuarioataca(userindex)
                
                'piedra libre para todos los compas!
                if userlist(userindex).flags.oculto > 0 and userlist(userindex).flags.admininvisible = 0 then
                    userlist(userindex).flags.oculto = 0
                    if userlist(userindex).flags.invisible = 0 then
                        call senddata(sendtarget.tomap, 0, userlist(userindex).pos.map, "nover" & userlist(userindex).char.charindex & ",0")
                        call senddata(sendtarget.toindex, userindex, 0, "||�has vuelto a ser visible!" & fonttype_info)
                    end if
                end if
                
            end if
            exit sub
        case "ag"
            if userlist(userindex).flags.muerto = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! los muertos no pueden tomar objetos. " & fonttype_info)
                    exit sub
            end if
            '[consejeros]
            if userlist(userindex).flags.privilegios = playertype.consejero and not userlist(userindex).flags.esrolesmaster then
                call senddata(sendtarget.toindex, userindex, 0, "||no puedes tomar ningun objeto. " & fonttype_info)
                exit sub
            end if
            call getobj(userindex)
            exit sub
        case "tab" 'entrar o salir modo combate
            if userlist(userindex).flags.modocombate then
                senddata sendtarget.toindex, userindex, 0, "||has salido del modo de combate. " & fonttype_info
            else
                senddata sendtarget.toindex, userindex, 0, "||has pasado al modo de combate. " & fonttype_info
            end if
            userlist(userindex).flags.modocombate = not userlist(userindex).flags.modocombate
            exit sub
        case "seg" 'activa / desactiva el seguro
            if userlist(userindex).flags.seguro then
                call senddata(sendtarget.toindex, userindex, 0, "||escribe /seg para quitar el seguro" & fonttype_fight)
            else
                call senddata(sendtarget.toindex, userindex, 0, "segon")
                userlist(userindex).flags.seguro = not userlist(userindex).flags.seguro
            end if
            exit sub
        case "actualizar"
            call senddata(sendtarget.toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
            exit sub
        case "glinfo"
            tstr = sendguildleaderinfo(userindex)
            if tstr = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "gl" & sendguildslist(userindex))
            else
                call senddata(sendtarget.toindex, userindex, 0, "leaderi" & tstr)
            end if
            exit sub
        case "atri"
            call enviaratrib(userindex)
            exit sub
        case "fama"
            call enviarfama(userindex)
            exit sub
        case "eski"
            call enviarskills(userindex)
            exit sub
        case "fest" 'mini estadisticas :)
            call enviarminiestadisticas(userindex)
            exit sub
        '[alejo]
        case "fincom"
            'user sale del modo comercio
            userlist(userindex).flags.comerciando = false
            call senddata(sendtarget.toindex, userindex, 0, "fincomok")
            exit sub
        case "fincomusu"
            'sale modo comercio usuario
            if userlist(userindex).comusu.destusu > 0 and _
                userlist(userlist(userindex).comusu.destusu).comusu.destusu = userindex then
                call senddata(sendtarget.toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha dejado de comerciar con vos." & fonttype_talk)
                call fincomerciarusu(userlist(userindex).comusu.destusu)
            end if
            
            call fincomerciarusu(userindex)
            exit sub
        '[kevin]---------------------------------------
        '******************************************************
        case "finban"
            'user sale del modo banco
            userlist(userindex).flags.comerciando = false
            call senddata(sendtarget.toindex, userindex, 0, "finbanok")
            exit sub
        '-------------------------------------------------------
        '[/kevin]**************************************
        case "comusuok"
            'aceptar el cambio
            call aceptarcomerciousu(userindex)
            exit sub
        case "comusuno"
            'rechazar el cambio
            if userlist(userindex).comusu.destusu > 0 then
                if userlist(userlist(userindex).comusu.destusu).flags.userlogged then
                    call senddata(sendtarget.toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha rechazado tu oferta." & fonttype_talk)
                    call fincomerciarusu(userlist(userindex).comusu.destusu)
                end if
            end if
            call senddata(sendtarget.toindex, userindex, 0, "||has rechazado la oferta del otro usuario." & fonttype_talk)
            call fincomerciarusu(userindex)
            exit sub
        '[/alejo]
    
    
    end select
    
    
    
    select case ucase$(left$(rdata, 2))
    '    case "/z"
    '        dim pos as worldpos, pos2 as worldpos
    '        dim o as obj
    '
    '        for loopc = 1 to 100
    '            pos = userlist(userindex).pos
    '            o.amount = 1
    '            o.objindex = ioro
    '            'exit for
    '            call tiraroro(100000, userindex)
    '            'call tilelibre(pos, pos2)
    '            'if pos2.x = 0 or pos2.y = 0 then exit for
    '
    '            'call makeobj(sendtarget.tomap, 0, userlist(userindex).pos.map, o, pos2.map, pos2.x, pos2.y)
    '        next loopc
    '
    '        exit sub
        case "ti" 'tirar item
                if userlist(userindex).flags.navegando = 1 or _
                   userlist(userindex).flags.muerto = 1 or _
                   (userlist(userindex).flags.privilegios = playertype.consejero and not userlist(userindex).flags.esrolesmaster) then exit sub
                   '[consejeros]
                
                rdata = right$(rdata, len(rdata) - 2)
                arg1 = readfield(1, rdata, 44)
                arg2 = readfield(2, rdata, 44)
                if val(arg1) = flagoro then
                    
                    call tiraroro(val(arg2), userindex)
                    
                    call senduserstatsbox(userindex)
                    exit sub
                else
                    if val(arg1) <= max_inventory_slots and val(arg1) > 0 then
                        if userlist(userindex).invent.object(val(arg1)).objindex = 0 then
                                exit sub
                        end if
                        call dropobj(userindex, val(arg1), val(arg2), userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
                    else
                        exit sub
                    end if
                end if
                exit sub
        case "lh" ' lanzar hechizo
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!." & fonttype_info)
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 2)
            userlist(userindex).flags.hechizo = val(rdata)
            exit sub
        case "lc" 'click izquierdo
            rdata = right$(rdata, len(rdata) - 2)
            arg1 = readfield(1, rdata, 44)
            arg2 = readfield(2, rdata, 44)
            if not numeric(arg1) or not numeric(arg2) then exit sub
            x = cint(arg1)
            y = cint(arg2)
            call lookattile(userindex, userlist(userindex).pos.map, x, y)
            exit sub
        case "rc" 'click derecho
            rdata = right$(rdata, len(rdata) - 2)
            arg1 = readfield(1, rdata, 44)
            arg2 = readfield(2, rdata, 44)
            if not numeric(arg1) or not numeric(arg2) then exit sub
            x = cint(arg1)
            y = cint(arg2)
            call accion(userindex, userlist(userindex).pos.map, x, y)
            exit sub
        case "uk"
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!." & fonttype_info)
                exit sub
            end if
    
            rdata = right$(rdata, len(rdata) - 2)
            select case val(rdata)
                case robar
                    call senddata(sendtarget.toindex, userindex, 0, "t01" & robar)
                case magia
                    call senddata(sendtarget.toindex, userindex, 0, "t01" & magia)
                case domar
                    call senddata(sendtarget.toindex, userindex, 0, "t01" & domar)
                case ocultarse
                    if userlist(userindex).flags.navegando = 1 then
                        '[cdt 17-02-2004]
                        if not userlist(userindex).flags.ultimomensaje = 3 then
                            call senddata(sendtarget.toindex, userindex, 0, "||no podes ocultarte si estas navegando." & fonttype_info)
                            userlist(userindex).flags.ultimomensaje = 3
                        end if
                        '[/cdt]
                        exit sub
                    end if
                    
                    if userlist(userindex).flags.oculto = 1 then
                        '[cdt 17-02-2004]
                        if not userlist(userindex).flags.ultimomensaje = 2 then
                            call senddata(sendtarget.toindex, userindex, 0, "||ya estas oculto." & fonttype_info)
                            userlist(userindex).flags.ultimomensaje = 2
                        end if
                        '[/cdt]
                        exit sub
                    end if
                    
                    call doocultarse(userindex)
            end select
            exit sub
    
    end select
    
    select case ucase$(left$(rdata, 3))
         case "umh" ' usa macro de hechizos
            call senddata(sendtarget.toadmins, userindex, 0, "||" & userlist(userindex).name & " fue expulsado por anti-macro de hechizos " & fonttype_veneno)
            call senddata(sendtarget.toindex, userindex, 0, "err has sido expulsado por usar macro de hechizos. recomendamos leer el reglamento sobre el tema macros" & fonttype_info)
            call closesocket(userindex)
            exit sub
        case "usa"
            rdata = right$(rdata, len(rdata) - 3)
            if val(rdata) <= max_inventory_slots and val(rdata) > 0 then
                if userlist(userindex).invent.object(val(rdata)).objindex = 0 then exit sub
            else
                exit sub
            end if
            if userlist(userindex).flags.meditando then
                call senddata(sendtarget.toindex, userindex, 0, "m!")
                exit sub
            end if
            call useinvitem(userindex, val(rdata))
            exit sub
        case "cns" ' construye herreria
            rdata = right$(rdata, len(rdata) - 3)
            x = cint(rdata)
            if x < 1 then exit sub
            if objdata(x).skherreria = 0 then exit sub
            call herreroconstruiritem(userindex, x)
            exit sub
        case "cnc" ' construye carpinteria
            rdata = right$(rdata, len(rdata) - 3)
            x = cint(rdata)
            if x < 1 or objdata(x).skcarpinteria = 0 then exit sub
            call carpinteroconstruiritem(userindex, x)
            exit sub
        case "wlc" 'click izquierdo en modo trabajo
            rdata = right$(rdata, len(rdata) - 3)
            arg1 = readfield(1, rdata, 44)
            arg2 = readfield(2, rdata, 44)
            arg3 = readfield(3, rdata, 44)
            if arg3 = "" or arg2 = "" or arg1 = "" then exit sub
            if not numeric(arg1) or not numeric(arg2) or not numeric(arg3) then exit sub
            
            x = cint(arg1)
            y = cint(arg2)
            tlong = cint(arg3)
            
            if userlist(userindex).flags.muerto = 1 or _
               userlist(userindex).flags.descansar or _
               userlist(userindex).flags.meditando or _
               not inmapbounds(userlist(userindex).pos.map, x, y) then exit sub
            
            if not inrangovision(userindex, x, y) then
                call senddata(sendtarget.toindex, userindex, 0, "pu" & userlist(userindex).pos.x & "," & userlist(userindex).pos.y)
                exit sub
            end if
            
            select case tlong
            
            case proyectiles
                dim tu as integer, tn as integer
                'nos aseguramos que este usando un arma de proyectiles
                if not intervalopermiteatacar(userindex, false) or not intervalopermiteusararcos(userindex) then
                    exit sub
                end if

                dummyint = 0

                if userlist(userindex).invent.weaponeqpobjindex = 0 then
                    dummyint = 1
                elseif userlist(userindex).invent.weaponeqpslot < 1 or userlist(userindex).invent.weaponeqpslot > max_inventory_slots then
                    dummyint = 1
                elseif userlist(userindex).invent.municioneqpslot < 1 or userlist(userindex).invent.municioneqpslot > max_inventory_slots then
                    dummyint = 1
                elseif userlist(userindex).invent.municioneqpobjindex = 0 then
                    dummyint = 1
                elseif objdata(userlist(userindex).invent.weaponeqpobjindex).proyectil <> 1 then
                    dummyint = 2
                elseif objdata(userlist(userindex).invent.municioneqpobjindex).objtype <> eobjtype.otflechas then
                    dummyint = 1
                elseif userlist(userindex).invent.object(userlist(userindex).invent.municioneqpslot).amount < 1 then
                    dummyint = 1
                end if
                
                if dummyint <> 0 then
                    if dummyint = 1 then
                        call senddata(sendtarget.toindex, userindex, 0, "||no tenes municiones." & fonttype_info)
                    end if
                    call desequipar(userindex, userlist(userindex).invent.municioneqpslot)
                    call desequipar(userindex, userlist(userindex).invent.weaponeqpslot)
                    exit sub
                end if
                
                dummyint = 0
                'quitamos stamina
                if userlist(userindex).stats.minsta >= 10 then
                     call quitarsta(userindex, randomnumber(1, 10))
                else
                     call senddata(sendtarget.toindex, userindex, 0, "||estas muy cansado para luchar." & fonttype_info)
                     exit sub
                end if
                 
                call lookattile(userindex, userlist(userindex).pos.map, arg1, arg2)
                
                tu = userlist(userindex).flags.targetuser
                tn = userlist(userindex).flags.targetnpc
                
                's�lo permitimos atacar si el otro nos puede atacar tambi�n
                if tu > 0 then
                    if abs(userlist(userlist(userindex).flags.targetuser).pos.y - userlist(userindex).pos.y) > rango_vision_y then
                        call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos para atacar." & fonttype_warning)
                        exit sub
                    end if
                elseif tn > 0 then
                    if abs(npclist(userlist(userindex).flags.targetnpc).pos.y - userlist(userindex).pos.y) > rango_vision_y then
                        call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos para atacar." & fonttype_warning)
                        exit sub
                    end if
                end if
                
                
                if tu > 0 then
                    'previene pegarse a uno mismo
                    if tu = userindex then
                        call senddata(sendtarget.toindex, userindex, 0, "||�no puedes atacarte a vos mismo!" & fonttype_info)
                        dummyint = 1
                        exit sub
                    end if
                end if
    
                if dummyint = 0 then
                    'saca 1 flecha
                    dummyint = userlist(userindex).invent.municioneqpslot
                    call quitaruserinvitem(userindex, userlist(userindex).invent.municioneqpslot, 1)
                    if dummyint < 1 or dummyint > max_inventory_slots then exit sub
                    if userlist(userindex).invent.object(dummyint).amount > 0 then
                        userlist(userindex).invent.object(dummyint).equipped = 1
                        userlist(userindex).invent.municioneqpslot = dummyint
                        userlist(userindex).invent.municioneqpobjindex = userlist(userindex).invent.object(dummyint).objindex
                        call updateuserinv(false, userindex, userlist(userindex).invent.municioneqpslot)
                    else
                        call updateuserinv(false, userindex, dummyint)
                        userlist(userindex).invent.municioneqpslot = 0
                        userlist(userindex).invent.municioneqpobjindex = 0
                    end if
                    '-----------------------------------
                end if

                if tn > 0 then
                    if npclist(tn).attackable <> 0 then
                        call usuarioatacanpc(userindex, tn)
                    end if
                elseif tu > 0 then
                    if userlist(userindex).flags.seguro then
                        if not criminal(tu) then
                            call senddata(sendtarget.toindex, userindex, 0, "||�para atacar ciudadanos desactiva el seguro!" & fonttype_fight)
                            exit sub
                        end if
                    end if
                    call usuarioatacausuario(userindex, tu)
                end if
                
            case magia
                if mapinfo(userlist(userindex).pos.map).magiasinefecto > 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||una fuerza oscura te impide canalizar tu energ�a" & fonttype_fight)
                    exit sub
                end if
                call lookattile(userindex, userlist(userindex).pos.map, x, y)
                
                'mmmmmmmmmm
                dim wp2 as worldpos
                wp2.map = userlist(userindex).pos.map
                wp2.x = x
                wp2.y = y
                                
                if userlist(userindex).flags.hechizo > 0 then
                    if intervalopermitelanzarspell(userindex) then
                        call lanzarhechizo(userlist(userindex).flags.hechizo, userindex)
                    '    userlist(userindex).flags.puedelanzarspell = 0
                        userlist(userindex).flags.hechizo = 0
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||�primero selecciona el hechizo que quieres lanzar!" & fonttype_info)
                end if
                
                'if distancia(userlist(userindex).pos, wp2) > 10 then
                if (abs(userlist(userindex).pos.x - wp2.x) > 9 or abs(userlist(userindex).pos.y - wp2.y) > 8) then
                    dim txt as string
                    txt = "ataque fuera de rango de " & userlist(userindex).name & "(" & userlist(userindex).pos.map & "/" & userlist(userindex).pos.x & "/" & userlist(userindex).pos.y & ") ip: " & userlist(userindex).ip & " a la posicion (" & wp2.map & "/" & wp2.x & "/" & wp2.y & ") "
                    if userlist(userindex).flags.hechizo > 0 then
                        txt = txt & ". hechizo: " & hechizos(userlist(userindex).stats.userhechizos(userlist(userindex).flags.hechizo)).nombre
                    end if
                    if mapdata(wp2.map, wp2.x, wp2.y).userindex > 0 then
                        txt = txt & " hacia el usuario: " & userlist(mapdata(wp2.map, wp2.x, wp2.y).userindex).name
                    elseif mapdata(wp2.map, wp2.x, wp2.y).npcindex > 0 then
                        txt = txt & " hacia el npc: " & npclist(mapdata(wp2.map, wp2.x, wp2.y).npcindex).name
                    end if
                    
                    call logcheating(txt)
                end if
                
            
            
            
            case pesca
                        
                auxind = userlist(userindex).invent.herramientaeqpobjindex
                if auxind = 0 then exit sub
                
                'if userlist(userindex).flags.puedetrabajar = 0 then exit sub
                if not intervalopermitetrabajar(userindex) then exit sub
                
                if auxind <> ca�a_pesca and auxind <> red_pesca then
                    'call cerrar_usuario(userindex)
                    ' podemos llegar ac� si el user equip� el anillo dsp de la u y antes del click
                    exit sub
                end if
                
                'basado en la idea de barrin
                'comentario por barrin: jah, "basado", caradura ! ^^
                if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||no puedes pescar desde donde te encuentras." & fonttype_info)
                    exit sub
                end if
                
                if hayagua(userlist(userindex).pos.map, x, y) then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_pescar)
                    
                    select case auxind
                    case ca�a_pesca
                        call dopescar(userindex)
                    case red_pesca
                        with userlist(userindex)
                            wpaux.map = .pos.map
                            wpaux.x = x
                            wpaux.y = y
                        end with
                        
                        if distancia(userlist(userindex).pos, wpaux) > 2 then
                            call senddata(sendtarget.toindex, userindex, 0, "||est�s demasiado lejos para pescar." & fonttype_info)
                            exit sub
                        end if
                        
                        call dopescarred(userindex)
                    end select
    
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||no hay agua donde pescar busca un lago, rio o mar." & fonttype_info)
                end if
                
            case robar
               if mapinfo(userlist(userindex).pos.map).pk then
                    'if userlist(userindex).flags.puedetrabajar = 0 then exit sub
                    if not intervalopermitetrabajar(userindex) then exit sub
                    
                    call lookattile(userindex, userlist(userindex).pos.map, x, y)
                    
                    if userlist(userindex).flags.targetuser > 0 and userlist(userindex).flags.targetuser <> userindex then
                       if userlist(userlist(userindex).flags.targetuser).flags.muerto = 0 then
                            wpaux.map = userlist(userindex).pos.map
                            wpaux.x = val(readfield(1, rdata, 44))
                            wpaux.y = val(readfield(2, rdata, 44))
                            if distancia(wpaux, userlist(userindex).pos) > 2 then
                                call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                                exit sub
                            end if
                            '17/09/02
                            'no aseguramos que el trigger le permite robar
                            if mapdata(userlist(userlist(userindex).flags.targetuser).pos.map, userlist(userlist(userindex).flags.targetuser).pos.x, userlist(userlist(userindex).flags.targetuser).pos.y).trigger = etrigger.zonasegura then
                                call senddata(sendtarget.toindex, userindex, 0, "||no podes robar aqu�." & fonttype_warning)
                                exit sub
                            end if
                            if mapdata(userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y).trigger = etrigger.zonasegura then
                                call senddata(sendtarget.toindex, userindex, 0, "||no podes robar aqu�." & fonttype_warning)
                                exit sub
                            end if
                            
                            call dorobar(userindex, userlist(userindex).flags.targetuser)
                       end if
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||no a quien robarle!." & fonttype_info)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||�no podes robarle en zonas seguras!." & fonttype_info)
                end if
            case talar
                
                'if userlist(userindex).flags.puedetrabajar = 0 then exit sub
                if not intervalopermitetrabajar(userindex) then exit sub
                
                if userlist(userindex).invent.herramientaeqpobjindex = 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||deber�as equiparte el hacha." & fonttype_info)
                    exit sub
                end if
                
                if userlist(userindex).invent.herramientaeqpobjindex <> hacha_le�ador then
                    ' call cerrar_usuario(userindex)
                    ' podemos llegar ac� si el user equip� el anillo dsp de la u y antes del click
                    exit sub
                end if
                
                auxind = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
                if auxind > 0 then
                    wpaux.map = userlist(userindex).pos.map
                    wpaux.x = x
                    wpaux.y = y
                    if distancia(wpaux, userlist(userindex).pos) > 2 then
                        call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                        exit sub
                    end if
                    
                    'barrin 29/9/03
                    if distancia(wpaux, userlist(userindex).pos) = 0 then
                        call senddata(sendtarget.toindex, userindex, 0, "||no podes talar desde all�." & fonttype_info)
                        exit sub
                    end if
                    
                    '�hay un arbol donde clickeo?
                    if objdata(auxind).objtype = eobjtype.otarboles then
                        call senddata(sendtarget.topcarea, cint(userindex), userlist(userindex).pos.map, "tw" & snd_talar)
                        call dotalar(userindex)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||no hay ningun arbol ahi." & fonttype_info)
                end if
            case mineria
                
                'if userlist(userindex).flags.puedetrabajar = 0 then exit sub
                if not intervalopermitetrabajar(userindex) then exit sub
                                
                if userlist(userindex).invent.herramientaeqpobjindex = 0 then exit sub
                
                if userlist(userindex).invent.herramientaeqpobjindex <> piquete_minero then
                    ' call cerrar_usuario(userindex)
                    ' podemos llegar ac� si el user equip� el anillo dsp de la u y antes del click
                    exit sub
                end if
                
                call lookattile(userindex, userlist(userindex).pos.map, x, y)
                
                auxind = mapdata(userlist(userindex).pos.map, x, y).objinfo.objindex
                if auxind > 0 then
                    wpaux.map = userlist(userindex).pos.map
                    wpaux.x = x
                    wpaux.y = y
                    if distancia(wpaux, userlist(userindex).pos) > 2 then
                        call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                        exit sub
                    end if
                    '�hay un yacimiento donde clickeo?
                    if objdata(auxind).objtype = eobjtype.otyacimiento then
                        call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_minero)
                        call domineria(userindex)
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ningun yacimiento." & fonttype_info)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ningun yacimiento." & fonttype_info)
                end if
            case domar
              'modificado 25/11/02
              'optimizado y solucionado el bug de la doma de
              'criaturas hostiles.
              dim ci as integer
              
              call lookattile(userindex, userlist(userindex).pos.map, x, y)
              ci = userlist(userindex).flags.targetnpc
              
              if ci > 0 then
                       if npclist(ci).flags.domable > 0 then
                            wpaux.map = userlist(userindex).pos.map
                            wpaux.x = x
                            wpaux.y = y
                            if distancia(wpaux, npclist(userlist(userindex).flags.targetnpc).pos) > 2 then
                                  call senddata(sendtarget.toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
                                  exit sub
                            end if
                            if npclist(ci).flags.attackedby <> "" then
                                  call senddata(sendtarget.toindex, userindex, 0, "||no pod�s domar una criatura que est� luchando con un jugador." & fonttype_info)
                                  exit sub
                            end if
                            call dodomar(userindex, ci)
                        else
                            call senddata(sendtarget.toindex, userindex, 0, "||no podes domar a esa criatura." & fonttype_info)
                        end if
              else
                     call senddata(sendtarget.toindex, userindex, 0, "||no hay ninguna criatura alli!." & fonttype_info)
              end if
              
            case fundirmetal
                'call lookattile(userindex, userlist(userindex).pos.map, x, y)
                if not intervalopermitetrabajar(userindex) then exit sub
                
                if userlist(userindex).flags.targetobj > 0 then
                    if objdata(userlist(userindex).flags.targetobj).objtype = eobjtype.otfragua then
                        ''chequeamos que no se zarpe duplicando oro
                        if userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).objindex <> userlist(userindex).flags.targetobjinvindex then
                            if userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).objindex = 0 or userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount = 0 then
                                call senddata(sendtarget.toindex, userindex, 0, "||no tienes mas minerales" & fonttype_info)
                                exit sub
                            end if
                            
                            ''fuiste
                            'call ban(userlist(userindex).name, "sistema anti cheats", "intento de duplicacion de items")
                            'call logcheating(userlist(userindex).name & " intento crear minerales a partir de otros: flagslot/usaba/usoconclick/cantidad/ip:" & userlist(userindex).flags.targetobjinvslot & "/" & userlist(userindex).flags.targetobjinvindex & "/" & userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).objindex & "/" & userlist(userindex).invent.object(userlist(userindex).flags.targetobjinvslot).amount & "/" & userlist(userindex).ip)
                            'userlist(userindex).flags.ban = 1
                            'call senddata(sendtarget.toall, 0, 0, "||>>>> el sistema anti-cheats bane� a " & userlist(userindex).name & " (intento de duplicaci�n). ip logged. " & fonttype_fight)
                            call senddata(sendtarget.toindex, userindex, 0, "errhas sido expulsado por el sistema anti cheats. recon�ctate.")
                            call closesocket(userindex)
                            exit sub
                        end if
                        call fundirmineral(userindex)
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ninguna fragua." & fonttype_info)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ninguna fragua." & fonttype_info)
                end if
                
            case herreria
                call lookattile(userindex, userlist(userindex).pos.map, x, y)
                
                if userlist(userindex).flags.targetobj > 0 then
                    if objdata(userlist(userindex).flags.targetobj).objtype = eobjtype.otyunque then
                        call enivararmasconstruibles(userindex)
                        call enivararmadurasconstruibles(userindex)
                        call senddata(sendtarget.toindex, userindex, 0, "sfh")
                    else
                        call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ningun yunque." & fonttype_info)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||ahi no hay ningun yunque." & fonttype_info)
                end if
                
            end select
            
            'userlist(userindex).flags.puedetrabajar = 0
            exit sub
        case "cig"
            rdata = right$(rdata, len(rdata) - 3)
            
            if modguilds.crearnuevoclan(rdata, userindex, userlist(userindex).fundandoguildalineacion, tstr) then
                call senddata(sendtarget.toall, 0, 0, "||" & userlist(userindex).name & " fund� el clan " & guilds(userlist(userindex).guildindex).guildname & " de alineaci�n " & alineacion2string(guilds(userlist(userindex).guildindex).alineacion) & "." & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            end if
            
            exit sub
    end select
    
    
    
    
    
    select case ucase$(left$(rdata, 4))
        case "infs" 'informacion del hechizo
                rdata = right$(rdata, len(rdata) - 4)
                if val(rdata) > 0 and val(rdata) < maxuserhechizos + 1 then
                    dim h as integer
                    h = userlist(userindex).stats.userhechizos(val(rdata))
                    if h > 0 and h < numerohechizos + 1 then
                        call senddata(sendtarget.toindex, userindex, 0, "||%%%%%%%%%%%% info del hechizo %%%%%%%%%%%%" & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||nombre:" & hechizos(h).nombre & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||descripcion:" & hechizos(h).desc & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||skill requerido: " & hechizos(h).minskill & " de magia." & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||mana necesario: " & hechizos(h).manarequerido & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||stamina necesaria: " & hechizos(h).starequerido & fonttype_info)
                        call senddata(sendtarget.toindex, userindex, 0, "||%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" & fonttype_info)
                    end if
                else
                    call senddata(sendtarget.toindex, userindex, 0, "||�primero selecciona el hechizo.!" & fonttype_info)
                end if
                exit sub
        case "equi"
                if userlist(userindex).flags.muerto = 1 then
                    call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!! solo podes usar items cuando estas vivo. " & fonttype_info)
                    exit sub
                end if
                rdata = right$(rdata, len(rdata) - 4)
                if val(rdata) <= max_inventory_slots and val(rdata) > 0 then
                     if userlist(userindex).invent.object(val(rdata)).objindex = 0 then exit sub
                else
                    exit sub
                end if
                call equiparinvitem(userindex, val(rdata))
                exit sub
        case "chea" 'cambiar heading ;-)
            rdata = right$(rdata, len(rdata) - 4)
            if val(rdata) > 0 and val(rdata) < 5 then
                userlist(userindex).char.heading = rdata
                call changeuserchar(sendtarget.tomap, 0, userlist(userindex).pos.map, userindex, userlist(userindex).char.body, userlist(userindex).char.head, userlist(userindex).char.heading, userlist(userindex).char.weaponanim, userlist(userindex).char.shieldanim, userlist(userindex).char.cascoanim)
            end if
            exit sub
        case "skse" 'modificar skills
            dim sumatoria as integer
            dim incremento as integer
            rdata = right$(rdata, len(rdata) - 4)
            
            'codigo para prevenir el hackeo de los skills
            '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            for i = 1 to numskills
                incremento = val(readfield(i, rdata, 44))
                
                if incremento < 0 then
                    'call senddata(sendtarget.toall, 0, 0, "||los dioses han desterrado a " & userlist(userindex).name & fonttype_info)
                    call loghackattemp(userlist(userindex).name & " ip:" & userlist(userindex).ip & " trato de hackear los skills.")
                    userlist(userindex).stats.skillpts = 0
                    call closesocket(userindex)
                    exit sub
                end if
                
                sumatoria = sumatoria + incremento
            next i
            
            if sumatoria > userlist(userindex).stats.skillpts then
                'userlist(userindex).flags.administrativeban = 1
                'call senddata(sendtarget.toall, 0, 0, "||los dioses han desterrado a " & userlist(userindex).name & fonttype_info)
                call loghackattemp(userlist(userindex).name & " ip:" & userlist(userindex).ip & " trato de hackear los skills.")
                call closesocket(userindex)
                exit sub
            end if
            '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            
            for i = 1 to numskills
                incremento = val(readfield(i, rdata, 44))
                userlist(userindex).stats.skillpts = userlist(userindex).stats.skillpts - incremento
                userlist(userindex).stats.userskills(i) = userlist(userindex).stats.userskills(i) + incremento
                if userlist(userindex).stats.userskills(i) > 100 then userlist(userindex).stats.userskills(i) = 100
            next i
            exit sub
        case "entr" 'entrena hombre!
            
            if userlist(userindex).flags.targetnpc = 0 then exit sub
            
            if npclist(userlist(userindex).flags.targetnpc).npctype <> 3 then exit sub
            
            rdata = right$(rdata, len(rdata) - 4)
            
            if npclist(userlist(userindex).flags.targetnpc).mascotas < maxmascotasentrenador then
                if val(rdata) > 0 and val(rdata) < npclist(userlist(userindex).flags.targetnpc).nrocriaturas + 1 then
                        dim spawnednpc as integer
                        spawnednpc = spawnnpc(npclist(userlist(userindex).flags.targetnpc).criaturas(val(rdata)).npcindex, npclist(userlist(userindex).flags.targetnpc).pos, true, false)
                        if spawnednpc > 0 then
                            npclist(spawnednpc).maestronpc = userlist(userindex).flags.targetnpc
                            npclist(userlist(userindex).flags.targetnpc).mascotas = npclist(userlist(userindex).flags.targetnpc).mascotas + 1
                        end if
                end if
            else
                call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "no puedo traer mas criaturas, mata las existentes!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
            end if
            
            exit sub
        case "comp"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                exit sub
            end if
            
            '�el target es un npc valido?
            if userlist(userindex).flags.targetnpc > 0 then
                '�el npc puede comerciar?
                if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & fonttype_talk & "�" & "no tengo ningun interes en comerciar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
            else
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 5)
            'user compra el item del slot rdata
            if userlist(userindex).flags.comerciando = false then
                call senddata(sendtarget.toindex, userindex, 0, "||no estas comerciando " & fonttype_info)
                exit sub
            end if
            'listindex+1, cantidad
            call npcventaitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)), userlist(userindex).flags.targetnpc)
            exit sub
        '[kevin]*********************************************************************
        '------------------------------------------------------------------------------------
        case "reti"
             '�esta el user muerto? si es asi no puede comerciar
             if userlist(userindex).flags.muerto = 1 then
                       call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                       exit sub
             end if
             '�el target es un npc valido?
             if userlist(userindex).flags.targetnpc > 0 then
                   '�es el banquero?
                   if npclist(userlist(userindex).flags.targetnpc).npctype <> 4 then
                       exit sub
                   end if
             else
               exit sub
             end if
             rdata = right(rdata, len(rdata) - 5)
             'user retira el item del slot rdata
             call userretiraitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
             exit sub
        '-----------------------------------------------------------------------------------
        '[/kevin]****************************************************************************
        case "vend"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                exit sub
            end if
            rdata = right$(rdata, len(rdata) - 5)
            '�el target es un npc valido?
            tint = val(readfield(1, rdata, 44))
            if userlist(userindex).flags.targetnpc > 0 then
                '�el npc puede comerciar?
                if npclist(userlist(userindex).flags.targetnpc).comercia = 0 then
                    call senddata(sendtarget.topcarea, userindex, userlist(userindex).pos.map, "||" & fonttype_talk & "�" & "no tengo ningun interes en comerciar." & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                    exit sub
                end if
            else
                exit sub
            end if
'           rdata = right$(rdata, len(rdata) - 5)
            'user compra el item del slot rdata
            call npccompraitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
            exit sub
        '[kevin]-------------------------------------------------------------------------
        '****************************************************************************************
        case "depo"
            '�esta el user muerto? si es asi no puede comerciar
            if userlist(userindex).flags.muerto = 1 then
                call senddata(sendtarget.toindex, userindex, 0, "||��estas muerto!!" & fonttype_info)
                exit sub
            end if
            '�el target es un npc valido?
            if userlist(userindex).flags.targetnpc > 0 then
                '�el npc puede comerciar?
                if npclist(userlist(userindex).flags.targetnpc).npctype <> enpctype.banquero then
                    exit sub
                end if
            else
                exit sub
            end if
            rdata = right(rdata, len(rdata) - 5)
            'user deposita el item del slot rdata
            call userdepositaitem(userindex, val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44)))
            exit sub
        '****************************************************************************************
        '[/kevin]---------------------------------------------------------------------------------
    end select

    select case ucase$(left$(rdata, 5))
        case "demsg"
            if userlist(userindex).flags.targetobj > 0 then
            rdata = right$(rdata, len(rdata) - 5)
            dim f as string, titu as string, msg as string, f2 as string
            f = app.path & "\foros\"
            f = f & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & ".for"
            titu = readfield(1, rdata, 176)
            msg = readfield(2, rdata, 176)
            dim n2 as integer, loopme as integer
            if fileexist(f, vbnormal) then
                dim num as integer
                num = val(getvar(f, "info", "cantmsg"))
                if num > max_mensajes_foro then
                    for loopme = 1 to num
                        kill app.path & "\foros\" & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & loopme & ".for"
                    next
                    kill app.path & "\foros\" & ucase$(objdata(userlist(userindex).flags.targetobj).foroid) & ".for"
                    num = 0
                end if
                n2 = freefile
                f2 = left$(f, len(f) - 4)
                f2 = f2 & num + 1 & ".for"
                open f2 for output as n2
                print #n2, titu
                print #n2, msg
                call writevar(f, "info", "cantmsg", num + 1)
            else
                n2 = freefile
                f2 = left$(f, len(f) - 4)
                f2 = f2 & "1" & ".for"
                open f2 for output as n2
                print #n2, titu
                print #n2, msg
                call writevar(f, "info", "cantmsg", 1)
            end if
            close #n2
            end if
            exit sub
    end select
    
    
    select case ucase$(left$(rdata, 6))
        case "desphe" 'mover hechizo de lugar
            rdata = right(rdata, len(rdata) - 6)
            call desplazarhechizo(userindex, cint(readfield(1, rdata, 44)), cint(readfield(2, rdata, 44)))
            exit sub
        case "descod" 'informacion del hechizo
                rdata = right$(rdata, len(rdata) - 6)
                call modguilds.actualizarcodexydesc(rdata, userlist(userindex).guildindex)
                exit sub
    end select
    
    '[alejo]
    select case ucase$(left$(rdata, 7))
    case "ofrecer"
            rdata = right$(rdata, len(rdata) - 7)
            arg1 = readfield(1, rdata, asc(","))
            arg2 = readfield(2, rdata, asc(","))

            if val(arg1) <= 0 or val(arg2) <= 0 then
                exit sub
            end if
            if userlist(userlist(userindex).comusu.destusu).flags.userlogged = false then
                'sigue vivo el usuario ?
                call fincomerciarusu(userindex)
                exit sub
            else
                'esta vivo ?
                if userlist(userlist(userindex).comusu.destusu).flags.muerto = 1 then
                    call fincomerciarusu(userindex)
                    exit sub
                end if
                '//tiene la cantidad que ofrece ??//'
                if val(arg1) = flagoro then
                    'oro
                    if val(arg2) > userlist(userindex).stats.gld then
                        call senddata(sendtarget.toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
                        exit sub
                    end if
                else
                    'inventario
                    if val(arg2) > userlist(userindex).invent.object(val(arg1)).amount then
                        call senddata(sendtarget.toindex, userindex, 0, "||no tienes esa cantidad." & fonttype_talk)
                        exit sub
                    end if
                end if
                if userlist(userindex).comusu.objeto > 0 then
                    call senddata(sendtarget.toindex, userindex, 0, "||no puedes cambiar tu oferta." & fonttype_talk)
                    exit sub
                end if
                'no permitimos vender barcos mientras est�n equipados (no pod�s desequiparlos y causa errores)
                if userlist(userindex).flags.navegando = 1 then
                    if userlist(userindex).invent.barcoslot = val(arg1) then
                        call senddata(sendtarget.toindex, userindex, 0, "||no pod�s vender tu barco mientras lo est�s usando." & fonttype_talk)
                        exit sub
                    end if
                end if
                
                userlist(userindex).comusu.objeto = val(arg1)
                userlist(userindex).comusu.cant = val(arg2)
                if userlist(userlist(userindex).comusu.destusu).comusu.destusu <> userindex then
                    call fincomerciarusu(userindex)
                    exit sub
                else
                    '[corregido]
                    if userlist(userlist(userindex).comusu.destusu).comusu.acepto = true then
                        'no no no vos te estas pasando de listo...
                        userlist(userlist(userindex).comusu.destusu).comusu.acepto = false
                        call senddata(sendtarget.toindex, userlist(userindex).comusu.destusu, 0, "||" & userlist(userindex).name & " ha cambiado su oferta." & fonttype_talk)
                    end if
                    '[/corregido]
                    'es la ofrenda de respuesta :)
                    call enviarobjetotransaccion(userlist(userindex).comusu.destusu)
                end if
            end if
            exit sub
    end select
    '[/alejo]
    
    select case ucase$(left$(rdata, 8))
        'clanesnuevo
        case "aceppeat" 'aceptar paz
            rdata = right$(rdata, len(rdata) - 8)
            tint = modguilds.r_aceptarpropuestadepaz(userindex, rdata, tstr)
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||tu clan ha firmado la paz con " & rdata & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "||tu clan ha firmado la paz con " & userlist(userindex).name & fonttype_guild)
            end if
            exit sub
        case "recpalia" 'rechazar alianza
            rdata = right$(rdata, len(rdata) - 8)
            tint = modguilds.r_rechazarpropuestadealianza(userindex, rdata, tstr)
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||tu clan rechazado la propuesta de alianza de " & rdata & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "||" & userlist(userindex).name & " ha rechazado nuestra propuesta de alianza con su clan." & fonttype_guild)
            end if
            exit sub
        case "recppeat" 'rechazar propuesta de paz
            rdata = right$(rdata, len(rdata) - 8)
            tint = modguilds.r_rechazarpropuestadepaz(userindex, rdata, tstr)
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||tu clan rechazado la propuesta de paz de " & rdata & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "||" & userlist(userindex).name & " ha rechazado nuestra propuesta de paz con su clan." & fonttype_guild)
            end if
            exit sub
        case "acepalia" 'aceptar alianza
            rdata = right$(rdata, len(rdata) - 8)
            tint = modguilds.r_aceptarpropuestadealianza(userindex, rdata, tstr)
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||tu clan ha firmado la alianza con " & rdata & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "||tu clan ha firmado la paz con " & userlist(userindex).name & fonttype_guild)
            end if
            exit sub
        case "peaceoff"
            'un clan solicita propuesta de paz a otro
            rdata = right$(rdata, len(rdata) - 8)
            arg1 = readfield(1, rdata, asc(","))
            arg2 = readfield(2, rdata, asc(","))
            if modguilds.r_clangenerapropuesta(userindex, arg1, paz, arg2, arg3) then
                call senddata(sendtarget.toindex, userindex, 0, "||propuesta de paz enviada" & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||" & arg3 & fonttype_guild)
            end if
            exit sub
        case "allieoff" 'un clan solicita propuesta de alianza a otro
            rdata = right$(rdata, len(rdata) - 8)
            arg1 = readfield(1, rdata, asc(","))
            arg2 = readfield(2, rdata, asc(","))
            if modguilds.r_clangenerapropuesta(userindex, arg1, aliados, arg2, arg3) then
                call senddata(sendtarget.toindex, userindex, 0, "||propuesta de alianza enviada" & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "||" & arg3 & fonttype_guild)
            end if
            exit sub
        case "alliedet"
            'un clan pide los detalles de una propuesta de alianza
            rdata = right$(rdata, len(rdata) - 8)
            tstr = modguilds.r_verpropuesta(userindex, rdata, aliados, arg1)
            if tstr = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "||" & arg1 & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "alliede" & tstr)
            end if
            exit sub
        case "peacedet" '-"alliedet"
            'un clan pide los detalles de una propuesta de paz
            rdata = right$(rdata, len(rdata) - 8)
            tstr = modguilds.r_verpropuesta(userindex, rdata, paz, arg1)
            if tstr = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "||" & arg1 & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "peacede" & tstr)
            end if
            exit sub
        case "envcomen"
            rdata = trim$(right$(rdata, len(rdata) - 8))
            if rdata = vbnullstring then exit sub
            tstr = modguilds.a_detallesaspirante(userindex, rdata)
            if tstr = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "|| el personaje no ha mandado solicitud, o no est�s habilitado para verla." & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "peticio" & tstr)
            end if
            exit sub
        case "envalpro" 'enviame la lista de propuestas de alianza
            tindex = modguilds.r_cantidaddepropuestas(userindex, aliados)
            tstr = "alliepr" & tindex & ","
            if tindex > 0 then
                tstr = tstr & modguilds.r_listadepropuestas(userindex, aliados)
            end if
            call senddata(sendtarget.toindex, userindex, 0, tstr)
            exit sub
        case "envpropp" 'enviame la lista de propuestas de paz
            tindex = modguilds.r_cantidaddepropuestas(userindex, paz)
            tstr = "peacepr" & tindex & ","
            if tindex > 0 then
                tstr = tstr & modguilds.r_listadepropuestas(userindex, paz)
            end if
            call senddata(sendtarget.toindex, userindex, 0, tstr)
            exit sub
        case "decguerr" 'declaro la guerra
            rdata = right$(rdata, len(rdata) - 8)
            tint = modguilds.r_declararguerra(userindex, rdata, tstr)
            if tint = 0 then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                'war shall be!
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "|| tu clan ha entrado en guerra con " & rdata & fonttype_guild)
                call senddata(sendtarget.toguildmembers, tint, 0, "|| " & userlist(userindex).name & " le declara la guerra a tu clan" & fonttype_guild)
            end if
            exit sub
        case "newwebsi"
            rdata = right$(rdata, len(rdata) - 8)
            call modguilds.actualizarwebsite(userindex, rdata)
            exit sub
        case "aceptari"
            rdata = right$(rdata, len(rdata) - 8)
            if not modguilds.a_aceptaraspirante(userindex, rdata, tstr) then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                tint = nameindex(rdata)
                if tint > 0 then
                    call modguilds.m_conectarmiembroaclan(tint, userlist(userindex).guildindex)
                end if
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||" & rdata & " ha sido aceptado como miembro del clan." & fonttype_guild)
            end if
            exit sub
        case "rechazar"
            rdata = trim$(right$(rdata, len(rdata) - 8))
            arg1 = readfield(1, rdata, asc(","))
            arg2 = readfield(2, rdata, asc(","))
            if not modguilds.a_rechazaraspirante(userindex, arg1, arg2, arg3) then
                call senddata(sendtarget.toindex, userindex, 0, "|| " & arg3 & fonttype_guild)
            else
                tint = nameindex(arg1)
                tstr = arg3 & ": " & arg2       'el mensaje de rechazo
                if tint > 0 then
                    call senddata(sendtarget.toindex, tint, 0, "|| " & tstr & fonttype_guild)
                else
                    'hay que grabar en el char su rechazo
                    call modguilds.a_rechazaraspirantechar(arg1, userlist(userindex).guildindex, arg2)
                end if
            end if
            exit sub
        case "echarcla"
            'el lider echa de clan a alguien
            rdata = trim$(right$(rdata, len(rdata) - 8))
            tint = modguilds.m_echarmiembrodeclan(userindex, rdata)
            if tint > 0 then
                call senddata(sendtarget.toguildmembers, tint, 0, "||" & rdata & " fue expulsado del clan." & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "|| no puedes expulsar ese personaje del clan." & fonttype_guild)
            end if
            exit sub
        case "actgnews"
            rdata = right$(rdata, len(rdata) - 8)
            call modguilds.actualizarnoticias(userindex, rdata)
            exit sub
        case "1hrinfo<"
            rdata = right$(rdata, len(rdata) - 8)
            if trim$(rdata) = vbnullstring then exit sub
            tstr = modguilds.a_detallespersonaje(userindex, rdata, arg1)
            if tstr = vbnullstring then
                call senddata(sendtarget.toindex, userindex, 0, "||" & arg1 & fonttype_guild)
            else
                call senddata(sendtarget.toindex, userindex, 0, "chrinfo" & tstr)
            end if
            exit sub
        case "abreelec"
            if not modguilds.v_abrirelecciones(userindex, tstr) then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
            else
                call senddata(sendtarget.toguildmembers, userlist(userindex).guildindex, 0, "||�han comenzado las elecciones del clan! puedes votar escribiendo /voto seguido del nombre del personaje, por ejemplo: /voto " & userlist(userindex).name & fonttype_guild)
            end if
            exit sub
    end select
    

    select case ucase$(left$(rdata, 9))
        case "solicitud"
             rdata = right$(rdata, len(rdata) - 9)
             arg1 = readfield(1, rdata, asc(","))
             arg2 = readfield(2, rdata, asc(","))
             if not modguilds.a_nuevoaspirante(userindex, arg1, arg2, tstr) then
                call senddata(sendtarget.toindex, userindex, 0, "||" & tstr & fonttype_guild)
             else
                call senddata(sendtarget.toindex, userindex, 0, "||tu solicitud ha sido enviada. espera prontas noticias del l�der de " & arg1 & "." & fonttype_guild)
             end if
             exit sub
    end select
    
    select case ucase$(left$(rdata, 11))
        case "clandetails"
            rdata = right$(rdata, len(rdata) - 11)
            if trim$(rdata) = vbnullstring then exit sub
            call senddata(sendtarget.toindex, userindex, 0, "clandet" & modguilds.sendguilddetails(rdata))
            exit sub
    end select
    
procesado = false
    
end sub
