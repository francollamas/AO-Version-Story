attribute vb_name = "mod_tcp"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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
public warping as boolean
public llegaronskills as boolean
public llegaronatrib as boolean
public llegofama as boolean



public function puedoquitarfoco() as boolean
puedoquitarfoco = true
'puedoquitarfoco = not frmestadisticas.visible and _
'                 not frmguildadm.visible and _
'                 not frmguilddetails.visible and _
'                 not frmguildbrief.visible and _
'                 not frmguildfoundation.visible and _
'                 not frmguildleader.visible and _
'                 not frmcharinfo.visible and _
'                 not frmguildnews.visible and _
'                 not frmguildsol.visible and _
'                 not frmcommet.visible and _
'                 not frmpeaceprop.visible
'
end function

sub handledata(byval rdata as string)
    on error resume next
    
    dim retval as variant
    dim x as integer
    dim y as integer
    dim charindex as integer
    dim tempint as integer
    dim tempstr as string
    dim slot as integer
    dim mapnumber as string
    dim i as integer, k as integer
    dim cad$, index as integer, m as integer
    dim t() as string
    
    dim tstr as string
    dim tstr2 as string
    
    
    dim sdata as string
    sdata = ucase$(rdata)
    
    select case sdata
        case "logged"            ' >>>>> login :: logged
            logged = true
            userciego = false
            enginerun = true
            iscombate = false
            userdescansar = false
            nombres = true
            if frmcrearpersonaje.visible then
                unload frmpasswdsinpadrinos
                unload frmcrearpersonaje
                unload frmconnect
                frmmain.show
            end if
            call setconnected
            'mostramos el tip
            if tipf = "1" and primeravez then
                 call cargartip
                 frmtip.visible = true
                 primeravez = false
            end if
            btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
            mapdata(userpos.x, userpos.y).trigger = 2 or _
            mapdata(userpos.x, userpos.y).trigger = 4, true, false)
            exit sub
        case "qtdl"              ' >>>>> quitar dialogos :: qtdl
            call dialogos.borrardialogos
            exit sub
        case "naveg"
            usernavegando = not usernavegando
            exit sub
        case "finok" ' graceful exit ;))
#if usarwrench = 1 then
            frmmain.socket1.disconnect
#else
            if frmmain.winsock1.state <> sckclosed then _
                frmmain.winsock1.close
#end if
            frmmain.visible = false
            logged = false
            userparalizado = false
            iscombate = false
            pausa = false
            usermeditar = false
            userdescansar = false
            usernavegando = false
            frmconnect.visible = true
            call audio.stopwave
            frmmain.isplaying = playloop.plnone
            brain = false
            bfogata = false
            skillpoints = 0
            frmmain.label1.visible = false
            call dialogos.borrardialogos
            for i = 1 to lastchar
                charlist(i).invisible = false
            next i
            
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            
            bk = 0
            exit sub
        case "fincomok"          ' >>>>> finaliza comerciar :: fincomok
            frmcomerciar.list1(0).clear
            frmcomerciar.list1(1).clear
            npcinvdim = 0
            unload frmcomerciar
            comerciando = false
            exit sub
        '[kevin]**************************************************************
        '-----------------------------------------------------------------------------
        case "finbanok"          ' >>>>> finaliza banco :: finbanok
            frmbancoobj.list1(0).clear
            frmbancoobj.list1(1).clear
            npcinvdim = 0
            unload frmbancoobj
            comerciando = false
            exit sub
        '[/kevin]***********************************************************************
        '------------------------------------------------------------------------------
        case "initcom"           ' >>>>> inicia comerciar :: initcom
            i = 1
            do while i <= max_inventory_slots
                if inventario.objindex(i) <> 0 then
                        frmcomerciar.list1(1).additem inventario.itemname(i)
                else
                        frmcomerciar.list1(1).additem "nada"
                end if
                i = i + 1
            loop
            comerciando = true
            frmcomerciar.show , frmmain
            exit sub
        '[kevin]-----------------------------------------------
        '**************************************************************
        case "initbanco"           ' >>>>> inicia comerciar :: initbanco
            dim ii as integer
            ii = 1
            do while ii <= max_inventory_slots
                if inventario.objindex(ii) <> 0 then
                        frmbancoobj.list1(1).additem inventario.itemname(ii)
                else
                        frmbancoobj.list1(1).additem "nada"
                end if
                ii = ii + 1
            loop
            
            
            i = 1
            do while i <= ubound(userbancoinventory)
                if userbancoinventory(i).objindex <> 0 then
                        frmbancoobj.list1(0).additem userbancoinventory(i).name
                else
                        frmbancoobj.list1(0).additem "nada"
                end if
                i = i + 1
            loop
            comerciando = true
            frmbancoobj.show , frmmain
            exit sub
        '---------------------------------------------------------------
        '[/kevin]******************
        '[alejo]
        case "initcomusu"
            if frmcomerciarusu.list1.listcount > 0 then frmcomerciarusu.list1.clear
            if frmcomerciarusu.list2.listcount > 0 then frmcomerciarusu.list2.clear
            
            for i = 1 to max_inventory_slots
                if inventario.objindex(i) <> 0 then
                        frmcomerciarusu.list1.additem inventario.itemname(i)
                        frmcomerciarusu.list1.itemdata(frmcomerciarusu.list1.newindex) = inventario.amount(i)
                else
                        frmcomerciarusu.list1.additem "nada"
                        frmcomerciarusu.list1.itemdata(frmcomerciarusu.list1.newindex) = 0
                end if
            next i
            comerciando = true
            frmcomerciarusu.show , frmmain
        case "fincomusuok"
            frmcomerciarusu.list1.clear
            frmcomerciarusu.list2.clear
            
            unload frmcomerciarusu
            comerciando = false
            '[/alejo]
        case "recpassok"
            call msgbox("���el password fue enviado con �xito!!!", vbapplicationmodal + vbdefaultbutton1 + vbinformation + vbokonly, "envio de password")
            frmrecuperar.mousepointer = 0
#if usarwrench = 1 then
            frmmain.socket1.disconnect
#else
            if frmmain.winsock1.state <> sckclosed then _
                frmmain.winsock1.close
#end if
            unload frmrecuperar
            exit sub
        case "recpasser"
            call msgbox("���no coinciden los datos con los del personaje en el servidor, el password no ha sido enviado.!!!", vbapplicationmodal + vbdefaultbutton1 + vbinformation + vbokonly, "envio de password")
            frmrecuperar.mousepointer = 0
#if usarwrench = 1 then
            frmmain.socket1.disconnect
#else
            if frmmain.winsock1.state <> sckclosed then _
                frmmain.winsock1.close
#end if
            unload frmrecuperar
            exit sub
        case "borrok"
            call msgbox("el personaje ha sido borrado.", vbapplicationmodal + vbdefaultbutton1 + vbinformation + vbokonly, "borrado de personaje")
            frmborrar.mousepointer = 0
#if usarwrench = 1 then
            frmmain.socket1.disconnect
#else
            if frmmain.winsock1.state <> sckclosed then _
                frmmain.winsock1.close
#end if
            unload frmborrar
            exit sub
        case "sfh"
            frmherrero.show , frmmain
            exit sub
        case "sfc"
            frmcarp.show , frmmain
            exit sub
        case "n1" ' <--- npc ataco y fallo
            call addtorichtextbox(frmmain.rectxt, mensaje_criatura_falla_golpe, 255, 0, 0, true, false, false)
            exit sub
        case "6" ' <--- npc mata al usuario
            call addtorichtextbox(frmmain.rectxt, mensaje_criatura_matado, 255, 0, 0, true, false, false)
            exit sub
        case "7" ' <--- ataque rechazado con el escudo
            call addtorichtextbox(frmmain.rectxt, mensaje_rechazo_ataque_escudo, 255, 0, 0, true, false, false)
            exit sub
        case "8" ' <--- ataque rechazado con el escudo
            call addtorichtextbox(frmmain.rectxt, mensaje_usuario_rechazo_ataque_escudo, 255, 0, 0, true, false, false)
            exit sub
        case "u1" ' <--- user ataco y fallo el golpe
            call addtorichtextbox(frmmain.rectxt, mensaje_fallado_golpe, 255, 0, 0, true, false, false)
            exit sub
        case "reau" '<--- requiere autoupdate
            call frmmain.dibujarsatelite
            exit sub
        case "segon" '  <--- activa el seguro
            call frmmain.dibujarseguro
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_activado, 0, 255, 0, true, false, false)
            exit sub
        case "segoff" ' <--- desactiva el seguro
            call frmmain.desdibujarseguro
            call addtorichtextbox(frmmain.rectxt, mensaje_seguro_desactivado, 255, 0, 0, true, false, false)
            exit sub
        case "pn"     ' <--- pierde nobleza
            call addtorichtextbox(frmmain.rectxt, mensaje_pierde_nobleza, 255, 0, 0, false, false, false)
            exit sub
        case "m!"     ' <--- usa meditando
            call addtorichtextbox(frmmain.rectxt, mensaje_usar_meditando, 255, 0, 0, false, false, false)
            exit sub
    end select

    select case left(sdata, 1)
        case "+"              ' >>>>> mover char >>> +
            rdata = right$(rdata, len(rdata) - 1)

#if seguridadalkon then
            'obtengo todo
            call cheatingdeath.movechardecrypt(rdata, charindex, x, y)
#else
            charindex = val(readfield(1, rdata, asc(",")))
            x = val(readfield(2, rdata, asc(",")))
            y = val(readfield(3, rdata, asc(",")))
#end if

            'antigua codificacion del mensaje (decodificada x un chitero)
            'charindex = asc(mid$(rdata, 1, 1)) * 64 + (asc(mid$(rdata, 2, 1)) and &hfc&) / 4

            ' constantes todo: de donde sale el 40-49 ?
            
            if charlist(charindex).fx >= 40 and charlist(charindex).fx <= 49 then   'si esta meditando
                charlist(charindex).fx = 0
                charlist(charindex).fxlooptimes = 0
            end if
            
            ' constantes todo: que es .priv ?
            
            if charlist(charindex).priv = 0 then
                call dopasosfx(charindex)
            end if

            call movecharbypos(charindex, x, y)
            
            call refreshallchars
            exit sub
        case "*", "_"             ' >>>>> mover npc >>> *
            rdata = right$(rdata, len(rdata) - 1)
            
#if seguridadalkon then
            'obtengo todo
            call cheatingdeath.movenpcdecrypt(rdata, charindex, x, y, left$(sdata, 1) <> "*")
#else
            charindex = val(readfield(1, rdata, asc(",")))
            x = val(readfield(2, rdata, asc(",")))
            y = val(readfield(3, rdata, asc(",")))
#end if
            
            'antigua codificacion del mensaje (decodificada x un chitero)
            'charindex = asc(mid$(rdata, 1, 1)) * 64 + (asc(mid$(rdata, 2, 1)) and &hfc&) / 4
            
'            if charlist(charindex).body.walk(1).grhindex = 4747 then
'                debug.print "hola"
'            end if
            
            ' constantes todo: de donde sale el 40-49 ?
            
            if charlist(charindex).fx >= 40 and charlist(charindex).fx <= 49 then   'si esta meditando
                charlist(charindex).fx = 0
                charlist(charindex).fxlooptimes = 0
            end if
            
            ' constantes todo: que es .priv ?
            
            if charlist(charindex).priv = 0 then
                call dopasosfx(charindex)
            end if
            
            call movecharbypos(charindex, x, y)
            'call movecharbypos(charindex, asc(mid$(rdata, 3, 1)), asc(mid$(rdata, 4, 1)))
            
            call refreshallchars
            exit sub
    
    end select

    select case left$(sdata, 2)
        case "as"
            tstr = mid$(sdata, 3, 1)
            k = val(right$(sdata, len(sdata) - 3))
            
            select case tstr
                case "m": userminman = val(right$(sdata, len(sdata) - 3))
                case "h": userminhp = val(right$(sdata, len(sdata) - 3))
                case "s": userminsta = val(right$(sdata, len(sdata) - 3))
                case "g": usergld = val(right$(sdata, len(sdata) - 3))
                case "e": userexp = val(right$(sdata, len(sdata) - 3))
            end select
            
            frmmain.exp.caption = "exp: " & userexp & "/" & userpasarnivel
            frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
            frmmain.hpshp.width = (((userminhp / 100) / (usermaxhp / 100)) * 94)
            
            if usermaxman > 0 then
                frmmain.manshp.width = (((userminman + 1 / 100) / (usermaxman + 1 / 100)) * 94)
            else
                frmmain.manshp.width = 0
            end if
            
            frmmain.stashp.width = (((userminsta / 100) / (usermaxsta / 100)) * 94)
        
            frmmain.gldlbl.caption = usergld
            frmmain.lvllbl.caption = userlvl
            
            if userminhp = 0 then
                userestado = 1
            else
                userestado = 0
            end if
            
            exit sub
        case "cm"              ' >>>>> cargar mapa :: cm
            rdata = right$(rdata, len(rdata) - 2)
            usermap = readfield(1, rdata, 44)
            'obtiene la version del mapa

#if seguridadalkon then
            call initmi
#end if
            
            if fileexist(dirmapas & "mapa" & usermap & ".map", vbnormal) then
                open dirmapas & "mapa" & usermap & ".map" for binary as #1
                seek #1, 1
                get #1, , tempint
                close #1
'                if tempint = val(readfield(2, rdata, 44)) then
                    'si es la vers correcta cambiamos el mapa
                    call switchmap(usermap)
                    if blluvia(usermap) = 0 then
                        if brain then
                            call audio.stopwave(rainbufferindex)
                            rainbufferindex = 0
                            frmmain.isplaying = playloop.plnone
                        end if
                    end if
'                else
'                    'vers incorrecta
'                    msgbox "error en los mapas, algun archivo ha sido modificado o esta da�ado."
'                    call liberarobjetosdx
'                    call unloadallforms
'                    end
'                end if
            else
                'no encontramos el mapa en el hd
                msgbox "error en los mapas, algun archivo ha sido modificado o esta da�ado."
                call liberarobjetosdx
                call unloadallforms
                call escribirgameini(config_inicio)
                end
            end if
            exit sub
        
        case "pu"                 ' >>>>> actualiza posici�n usuario :: pu
            rdata = right$(rdata, len(rdata) - 2)
            mapdata(userpos.x, userpos.y).charindex = 0
            userpos.x = cint(readfield(1, rdata, 44))
            userpos.y = cint(readfield(2, rdata, 44))
            mapdata(userpos.x, userpos.y).charindex = usercharindex
            charlist(usercharindex).pos = userpos
            frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
            exit sub
        
        case "n2" ' <<--- npc nos impacto (ahorramos ancho de banda)
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_cabeza & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_torso & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "u2" ' <<--- el user ataco un npc e impacato
            rdata = right$(rdata, len(rdata) - 2)
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_criatura_1 & rdata & mensaje_2, 255, 0, 0, true, false, false)
            exit sub
        case "u3" ' <<--- el user ataco un user y falla
            rdata = right$(rdata, len(rdata) - 2)
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & rdata & mensaje_ataque_fallo, 255, 0, 0, true, false, false)
            exit sub
        case "n4" ' <<--- user nos impacto
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_cabeza & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_brazo_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_brazo_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_pierna_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_pierna_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & readfield(3, rdata, 44) & mensaje_recive_impacto_torso & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "n5" ' <<--- impactamos un user
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_cabeza & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_brazo_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_brazo_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_pierna_izq & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_pierna_der & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & readfield(3, rdata, 44) & mensaje_produce_impacto_torso & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "||"                 ' >>>>> dialogo de usuarios y npcs :: ||
            rdata = right$(rdata, len(rdata) - 2)
            dim iuser as integer
            iuser = val(readfield(3, rdata, 176))
            
            if iuser > 0 then
                dialogos.creardialogo readfield(2, rdata, 176), iuser, val(readfield(1, rdata, 176))
            else
                if puedoquitarfoco then
                    addtorichtextbox frmmain.rectxt, readfield(1, rdata, 126), val(readfield(2, rdata, 126)), val(readfield(3, rdata, 126)), val(readfield(4, rdata, 126)), val(readfield(5, rdata, 126)), val(readfield(6, rdata, 126))
                end if
            end if

            exit sub
        case "|+"                 ' >>>>> consola de clan y npcs :: |+
            rdata = right$(rdata, len(rdata) - 2)
            
            iuser = val(readfield(3, rdata, 176))

            if iuser = 0 then
                if puedoquitarfoco and not dialogosclanes.activo then
                    addtorichtextbox frmmain.rectxt, readfield(1, rdata, 126), val(readfield(2, rdata, 126)), val(readfield(3, rdata, 126)), val(readfield(4, rdata, 126)), val(readfield(5, rdata, 126)), val(readfield(6, rdata, 126))
                elseif dialogosclanes.activo then
                    dialogosclanes.pushbacktext readfield(1, rdata, 126)
                end if
            end if

            exit sub

        case "!!"                ' >>>>> msgbox :: !!
            if puedoquitarfoco then
                rdata = right$(rdata, len(rdata) - 2)
                frmmensaje.msg.caption = rdata
                frmmensaje.show
            end if
            exit sub
        case "iu"                ' >>>>> indice de usuario en server :: iu
            rdata = right$(rdata, len(rdata) - 2)
            userindex = val(rdata)
            exit sub
        case "ip"                ' >>>>> indice de personaje de usuario :: ip
            rdata = right$(rdata, len(rdata) - 2)
            usercharindex = val(rdata)
            userpos = charlist(usercharindex).pos
            frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
            exit sub
        case "cc"              ' >>>>> crear un personaje :: cc
            rdata = right$(rdata, len(rdata) - 2)
            charindex = readfield(4, rdata, 44)
            x = readfield(5, rdata, 44)
            y = readfield(6, rdata, 44)
            'debug.print "cc"
            'if charlist(charindex).pos.x or charlist(charindex).pos.y then
            '    debug.print "char duplicado: " & charindex
            '    call erasechar(charindex)
           ' end if
            
            charlist(charindex).fx = val(readfield(9, rdata, 44))
            charlist(charindex).fxlooptimes = val(readfield(10, rdata, 44))
            charlist(charindex).nombre = readfield(12, rdata, 44)
            charlist(charindex).criminal = val(readfield(13, rdata, 44))
            charlist(charindex).priv = val(readfield(14, rdata, 44))
            
            call makechar(charindex, readfield(1, rdata, 44), readfield(2, rdata, 44), readfield(3, rdata, 44), x, y, val(readfield(7, rdata, 44)), val(readfield(8, rdata, 44)), val(readfield(11, rdata, 44)))
            
            call refreshallchars
            exit sub
            
        case "bp"             ' >>>>> borrar un personaje :: bp
            rdata = right$(rdata, len(rdata) - 2)
            call erasechar(val(rdata))
            call dialogos.quitardialogo(val(rdata))
            call refreshallchars
            exit sub
        case "mp"             ' >>>>> mover un personaje :: mp
            rdata = right$(rdata, len(rdata) - 2)
            charindex = val(readfield(1, rdata, 44))
            
            if charlist(charindex).fx >= 40 and charlist(charindex).fx <= 49 then   'si esta meditando
                charlist(charindex).fx = 0
                charlist(charindex).fxlooptimes = 0
            end if
            
            if charlist(charindex).priv = 0 then
                call dopasosfx(charindex)
            end if
            
            call movecharbypos(charindex, readfield(2, rdata, 44), readfield(3, rdata, 44))
            
            call refreshallchars
            exit sub
        case "cp"             ' >>>>> cambiar apariencia personaje :: cp
            rdata = right$(rdata, len(rdata) - 2)
            
            charindex = val(readfield(1, rdata, 44))
            charlist(charindex).muerto = val(readfield(3, rdata, 44)) = 500
            charlist(charindex).body = bodydata(val(readfield(2, rdata, 44)))
            charlist(charindex).head = headdata(val(readfield(3, rdata, 44)))
            charlist(charindex).heading = val(readfield(4, rdata, 44))
            charlist(charindex).fx = val(readfield(7, rdata, 44))
            charlist(charindex).fxlooptimes = val(readfield(8, rdata, 44))
            tempint = val(readfield(5, rdata, 44))
            if tempint <> 0 then charlist(charindex).arma = weaponanimdata(tempint)
            tempint = val(readfield(6, rdata, 44))
            if tempint <> 0 then charlist(charindex).escudo = shieldanimdata(tempint)
            tempint = val(readfield(9, rdata, 44))
            if tempint <> 0 then charlist(charindex).casco = cascoanimdata(tempint)

            call refreshallchars
            exit sub
        case "ho"            ' >>>>> crear un objeto
            rdata = right$(rdata, len(rdata) - 2)
            x = val(readfield(2, rdata, 44))
            y = val(readfield(3, rdata, 44))
            'id del obj en el cliente
            mapdata(x, y).objgrh.grhindex = val(readfield(1, rdata, 44))
            initgrh mapdata(x, y).objgrh, mapdata(x, y).objgrh.grhindex
            exit sub
        case "bo"           ' >>>>> borrar un objeto
            rdata = right$(rdata, len(rdata) - 2)
            x = val(readfield(1, rdata, 44))
            y = val(readfield(2, rdata, 44))
            mapdata(x, y).objgrh.grhindex = 0
            exit sub
        case "bq"           ' >>>>> bloquear posici�n
            dim b as byte
            rdata = right$(rdata, len(rdata) - 2)
            mapdata(val(readfield(1, rdata, 44)), val(readfield(2, rdata, 44))).blocked = val(readfield(3, rdata, 44))
            exit sub
        case "tm"           ' >>>>> play un midi :: tm
            rdata = right$(rdata, len(rdata) - 2)
            currentmidi = val(readfield(1, rdata, 45))
            
            if musica then
                if currentmidi <> 0 then
                    rdata = right$(rdata, len(rdata) - len(readfield(1, rdata, 45)))
                    if len(rdata) > 0 then
                        call audio.playmidi(cstr(currentmidi) & ".mid", val(right$(rdata, len(rdata) - 1)))
                    else
                        call audio.playmidi(cstr(currentmidi) & ".mid")
                    end if
                end if
            end if
            exit sub
        case "tw"          ' >>>>> play un wav :: tw
            if sound then
                rdata = right$(rdata, len(rdata) - 2)
                 call audio.playwave(rdata & ".wav")
            end if
            exit sub
        case "gl" 'lista de guilds
            rdata = right$(rdata, len(rdata) - 2)
            call frmguildadm.parseguildlist(rdata)
            exit sub
        case "fo"          ' >>>>> play un wav :: tw
            bfogata = true
            if fogatabufferindex = 0 then
                fogatabufferindex = audio.playwave("fuego.wav", loopstyle.enabled)
            end if
            exit sub
        case "ca"
            cambiodearea asc(mid$(sdata, 3, 1)), asc(mid$(sdata, 4, 1))
            exit sub
    end select

    select case left$(sdata, 3)
        case "val"                  ' >>>>> validar cliente :: val
            dim valstring as string
            rdata = right$(rdata, len(rdata) - 3)
            bk = clng(readfield(1, rdata, asc(",")))
            brk = readfield(2, rdata, asc(","))
            valstring = readfield(3, rdata, asc(","))
            cargarcabezas
            
#if seguridadalkon then
            cheatingdeath.inputk
            
            if not cheatingdeath.validararchivoscriticos(valstring) then end
#end if

            if estadologin = borrarpj then
                call senddata("borr" & frmborrar.txtnombre.text & "," & frmborrar.txtpasswd.text & "," & validarloginmsg(cint(rdata)))
            elseif estadologin = normal or estadologin = crearnuevopj then
                call login(validarloginmsg(cint(brk)))
            elseif estadologin = dados then
                frmcrearpersonaje.show vbmodal
            end if
            exit sub
        case "bkw"                  ' >>>>> pausa :: bkw
            pausa = not pausa
            exit sub
        case "llu"                  ' >>>>> lluvia!
            if not inmapbounds(userpos.x, userpos.y) then exit sub
            btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
            mapdata(userpos.x, userpos.y).trigger = 2 or _
            mapdata(userpos.x, userpos.y).trigger = 4, true, false)
            if not brain then
                brain = true
            else
                if blluvia(usermap) <> 0 and sound then
                    'stop playing the rain sound
                    call audio.stopwave(rainbufferindex)
                    rainbufferindex = 0
                    if btecho then
                        call audio.playwave("lluviainend.wav", loopstyle.disabled)
                    else
                        call audio.playwave("lluviaoutend.wav", loopstyle.disabled)
                    end if
                    frmmain.isplaying = playloop.plnone
                end if
                brain = false
            end if
            
            exit sub
        case "qdl"                  ' >>>>> quitar dialogo :: qdl
            rdata = right$(rdata, len(rdata) - 3)
            call dialogos.quitardialogo(val(rdata))
            exit sub
        case "cfx"                  ' >>>>> mostrar fx sobre personaje :: cfx
            rdata = right$(rdata, len(rdata) - 3)
            charindex = val(readfield(1, rdata, 44))
            charlist(charindex).fx = val(readfield(2, rdata, 44))
            charlist(charindex).fxlooptimes = val(readfield(3, rdata, 44))
            exit sub
        case "aym"                  ' >>>>> pone mensaje en cola gm :: aym
            dim n as string, n2 as string
            rdata = right$(rdata, len(rdata) - 3)
            n = readfield(2, rdata, 176)
            n2 = readfield(1, rdata, 176)
            frmmsg.creargmmsg n, n2
            frmmsg.show , frmmain
            exit sub
        case "est"                  ' >>>>> actualiza estadisticas de usuario :: est
            rdata = right$(rdata, len(rdata) - 3)
            usermaxhp = val(readfield(1, rdata, 44))
            userminhp = val(readfield(2, rdata, 44))
            usermaxman = val(readfield(3, rdata, 44))
            userminman = val(readfield(4, rdata, 44))
            usermaxsta = val(readfield(5, rdata, 44))
            userminsta = val(readfield(6, rdata, 44))
            usergld = val(readfield(7, rdata, 44))
            userlvl = val(readfield(8, rdata, 44))
            userpasarnivel = val(readfield(9, rdata, 44))
            userexp = val(readfield(10, rdata, 44))
            frmmain.exp.caption = "exp: " & userexp & "/" & userpasarnivel
            frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
            frmmain.hpshp.width = (((userminhp / 100) / (usermaxhp / 100)) * 94)
            
            if usermaxman > 0 then
                frmmain.manshp.width = (((userminman + 1 / 100) / (usermaxman + 1 / 100)) * 94)
            else
                frmmain.manshp.width = 0
            end if
            
            frmmain.stashp.width = (((userminsta / 100) / (usermaxsta / 100)) * 94)
        
            frmmain.gldlbl.caption = usergld
            frmmain.lvllbl.caption = userlvl
            
            if userminhp = 0 then
                userestado = 1
            else
                userestado = 0
            end if
        
            exit sub
        case "t01"                  ' >>>>> trabajando :: tra
            rdata = right$(rdata, len(rdata) - 3)
            usingskill = val(rdata)
            frmmain.mousepointer = 2
            select case usingskill
                case magia
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_magia, 100, 100, 120, 0, 0)
                case pesca
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_pesca, 100, 100, 120, 0, 0)
                case robar
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_robar, 100, 100, 120, 0, 0)
                case talar
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_talar, 100, 100, 120, 0, 0)
                case mineria
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_mineria, 100, 100, 120, 0, 0)
                case fundirmetal
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_fundirmetal, 100, 100, 120, 0, 0)
                case proyectiles
                    call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_proyectiles, 100, 100, 120, 0, 0)
            end select
            exit sub
        case "csi"                 ' >>>>> actualiza slot inventario :: csi
            rdata = right$(rdata, len(rdata) - 3)
            slot = readfield(1, rdata, 44)
            call inventario.setitem(slot, readfield(2, rdata, 44), readfield(4, rdata, 44), readfield(5, rdata, 44), val(readfield(6, rdata, 44)), val(readfield(7, rdata, 44)), _
                                    val(readfield(8, rdata, 44)), val(readfield(9, rdata, 44)), val(readfield(10, rdata, 44)), val(readfield(11, rdata, 44)), readfield(3, rdata, 44))
            
            exit sub
        '[kevin]-------------------------------------------------------
        '**********************************************************************
        case "sbo"                 ' >>>>> actualiza inventario banco :: sbo
            rdata = right$(rdata, len(rdata) - 3)
            slot = readfield(1, rdata, 44)
            userbancoinventory(slot).objindex = readfield(2, rdata, 44)
            userbancoinventory(slot).name = readfield(3, rdata, 44)
            userbancoinventory(slot).amount = readfield(4, rdata, 44)
            userbancoinventory(slot).grhindex = val(readfield(5, rdata, 44))
            userbancoinventory(slot).objtype = val(readfield(6, rdata, 44))
            userbancoinventory(slot).maxhit = val(readfield(7, rdata, 44))
            userbancoinventory(slot).minhit = val(readfield(8, rdata, 44))
            userbancoinventory(slot).def = val(readfield(9, rdata, 44))
        
            tempstr = ""
            
            if userbancoinventory(slot).amount > 0 then
                tempstr = tempstr & "(" & userbancoinventory(slot).amount & ") " & userbancoinventory(slot).name
            else
                tempstr = tempstr & userbancoinventory(slot).name
            end if
            
            exit sub
        '************************************************************************
        '[/kevin]-------
        case "shs"                ' >>>>> agrega hechizos a lista spells :: shs
            rdata = right$(rdata, len(rdata) - 3)
            slot = readfield(1, rdata, 44)
            userhechizos(slot) = readfield(2, rdata, 44)
            if slot > frmmain.hlst.listcount then
                frmmain.hlst.additem readfield(3, rdata, 44)
            else
                frmmain.hlst.list(slot - 1) = readfield(3, rdata, 44)
            end if
            exit sub
        case "atr"               ' >>>>> recibir atributos del personaje :: atr
            rdata = right$(rdata, len(rdata) - 3)
            for i = 1 to numatributos
                useratributos(i) = val(readfield(i, rdata, 44))
            next i
            llegaronatrib = true
            exit sub
        case "lah"
            rdata = right$(rdata, len(rdata) - 3)
            
            for m = 0 to ubound(armasherrero)
                armasherrero(m) = 0
            next m
            i = 1
            m = 0
            do
                cad$ = readfield(i, rdata, 44)
                armasherrero(m) = val(readfield(i + 1, rdata, 44))
                if cad$ <> "" then frmherrero.lstarmas.additem cad$
                i = i + 2
                m = m + 1
            loop while cad$ <> ""
            exit sub
         case "lar"
            rdata = right$(rdata, len(rdata) - 3)
            
            for m = 0 to ubound(armadurasherrero)
                armadurasherrero(m) = 0
            next m
            i = 1
            m = 0
            do
                cad$ = readfield(i, rdata, 44)
                armadurasherrero(m) = val(readfield(i + 1, rdata, 44))
                if cad$ <> "" then frmherrero.lstarmaduras.additem cad$
                i = i + 2
                m = m + 1
            loop while cad$ <> ""
            exit sub
            
         case "obr"
            rdata = right$(rdata, len(rdata) - 3)
            
            for m = 0 to ubound(objcarpintero)
                objcarpintero(m) = 0
            next m
            i = 1
            m = 0
            do
                cad$ = readfield(i, rdata, 44)
                objcarpintero(m) = val(readfield(i + 1, rdata, 44))
                if cad$ <> "" then frmcarp.lstarmas.additem cad$
                i = i + 2
                m = m + 1
            loop while cad$ <> ""
            exit sub
            
        case "dok"               ' >>>>> descansar ok :: dok
            userdescansar = not userdescansar
            exit sub
        case "spl"
            rdata = right(rdata, len(rdata) - 3)
            for i = 1 to val(readfield(1, rdata, 44))
                frmspawnlist.lstcriaturas.additem readfield(i + 1, rdata, 44)
            next i
            frmspawnlist.show , frmmain
            exit sub
        case "err"
            rdata = right$(rdata, len(rdata) - 3)
            frmoldpersonaje.mousepointer = 1
            frmpasswdsinpadrinos.mousepointer = 1
            if not frmcrearpersonaje.visible then
#if usarwrench = 1 then
                frmmain.socket1.disconnect
#else
                if frmmain.winsock1.state <> sckclosed then _
                    frmmain.winsock1.close
#end if
            end if
            msgbox rdata
            exit sub
    end select
    
    
    select case left$(sdata, 4)
        case "part"
            call addtorichtextbox(frmmain.rectxt, mensaje_entrar_party_1 & readfield(1, rdata, 44) & mensaje_entrar_party_2, 0, 255, 0, false, false, false)
            exit sub
        case "cegu"
            userciego = true
            dim r as rect
            backbuffersurface.bltcolorfill r, 0
            exit sub
        case "dumb"
            userestupido = true
            exit sub
        case "natr" ' >>>>> recibe atributos para el nuevo personaje
            rdata = right$(rdata, len(rdata) - 4)
            useratributos(1) = readfield(1, rdata, 44)
            useratributos(2) = readfield(2, rdata, 44)
            useratributos(3) = readfield(3, rdata, 44)
            useratributos(4) = readfield(4, rdata, 44)
            useratributos(5) = readfield(5, rdata, 44)
            
            frmcrearpersonaje.lbfuerza.caption = useratributos(1)
            frmcrearpersonaje.lbinteligencia.caption = useratributos(2)
            frmcrearpersonaje.lbagilidad.caption = useratributos(3)
            frmcrearpersonaje.lbcarisma.caption = useratributos(4)
            frmcrearpersonaje.lbconstitucion.caption = useratributos(5)
            
            exit sub
        case "mcar"              ' >>>>> mostrar cartel :: mcar
            rdata = right$(rdata, len(rdata) - 4)
            call initcartel(readfield(1, rdata, 176), cint(readfield(2, rdata, 176)))
            exit sub
        case "npci"              ' >>>>> recibe item del inventario de un npc :: npci
            rdata = right(rdata, len(rdata) - 4)
            npcinvdim = npcinvdim + 1
            npcinventory(npcinvdim).name = readfield(1, rdata, 44)
            npcinventory(npcinvdim).amount = readfield(2, rdata, 44)
            npcinventory(npcinvdim).valor = readfield(3, rdata, 44)
            npcinventory(npcinvdim).grhindex = readfield(4, rdata, 44)
            npcinventory(npcinvdim).objindex = readfield(5, rdata, 44)
            npcinventory(npcinvdim).objtype = readfield(6, rdata, 44)
            npcinventory(npcinvdim).maxhit = readfield(7, rdata, 44)
            npcinventory(npcinvdim).minhit = readfield(8, rdata, 44)
            npcinventory(npcinvdim).def = readfield(9, rdata, 44)
            npcinventory(npcinvdim).c1 = readfield(10, rdata, 44)
            npcinventory(npcinvdim).c2 = readfield(11, rdata, 44)
            npcinventory(npcinvdim).c3 = readfield(12, rdata, 44)
            npcinventory(npcinvdim).c4 = readfield(13, rdata, 44)
            npcinventory(npcinvdim).c5 = readfield(14, rdata, 44)
            npcinventory(npcinvdim).c6 = readfield(15, rdata, 44)
            npcinventory(npcinvdim).c7 = readfield(16, rdata, 44)
            frmcomerciar.list1(0).additem npcinventory(npcinvdim).name
            exit sub
        case "ehys"              ' actualiza hambre y sed :: ehys
            rdata = right$(rdata, len(rdata) - 4)
            usermaxagu = val(readfield(1, rdata, 44))
            userminagu = val(readfield(2, rdata, 44))
            usermaxham = val(readfield(3, rdata, 44))
            userminham = val(readfield(4, rdata, 44))
            frmmain.aguasp.width = (((userminagu / 100) / (usermaxagu / 100)) * 94)
            frmmain.comidasp.width = (((userminham / 100) / (usermaxham / 100)) * 94)
            exit sub
        case "fama"             ' >>>>> recibe fama de personaje :: fama
            rdata = right$(rdata, len(rdata) - 4)
            userreputacion.asesinorep = val(readfield(1, rdata, 44))
            userreputacion.bandidorep = val(readfield(2, rdata, 44))
            userreputacion.burguesrep = val(readfield(3, rdata, 44))
            userreputacion.ladronesrep = val(readfield(4, rdata, 44))
            userreputacion.noblerep = val(readfield(5, rdata, 44))
            userreputacion.pleberep = val(readfield(6, rdata, 44))
            userreputacion.promedio = val(readfield(7, rdata, 44))
            llegofama = true
            exit sub
        case "mest" ' >>>>>> mini estadisticas :: mest
            rdata = right$(rdata, len(rdata) - 4)
            with userestadisticas
                .ciudadanosmatados = val(readfield(1, rdata, 44))
                .criminalesmatados = val(readfield(2, rdata, 44))
                .usuariosmatados = val(readfield(3, rdata, 44))
                .npcsmatados = val(readfield(4, rdata, 44))
                .clase = readfield(5, rdata, 44)
                .penacarcel = val(readfield(6, rdata, 44))
            end with
            exit sub
        case "suni"             ' >>>>> subir nivel :: suni
            rdata = right$(rdata, len(rdata) - 4)
            skillpoints = skillpoints + val(rdata)
            frmmain.label1.visible = true
            exit sub
        case "nene"             ' >>>>> nro de personajes :: nene
            rdata = right$(rdata, len(rdata) - 4)
            addtorichtextbox frmmain.rectxt, mensaje_nene & rdata, 255, 255, 255, 0, 0
            exit sub
        case "rsos"             ' >>>>> mensaje :: rsos
            rdata = right$(rdata, len(rdata) - 4)
            frmmsg.list1.additem rdata
            exit sub
        case "msos"             ' >>>>> mensaje :: msos
            frmmsg.show , frmmain
            exit sub
        case "fmsg"             ' >>>>> foros :: fmsg
            rdata = right$(rdata, len(rdata) - 4)
            frmforo.list.additem readfield(1, rdata, 176)
            frmforo.text(frmforo.list.listcount - 1).text = readfield(2, rdata, 176)
            load frmforo.text(frmforo.list.listcount)
            exit sub
        case "mfor"             ' >>>>> foros :: mfor
            if not frmforo.visible then
                  frmforo.show , frmmain
            end if
            exit sub
    end select

    select case left$(sdata, 5)
        case ucase$(chr$(110)) & mid$("medok", 4, 1) & right$("akv", 1) & "e" & trim$(left$("  rs", 3))
            rdata = right$(rdata, len(rdata) - 5)
            charindex = val(readfield(1, rdata, 44))
            charlist(charindex).invisible = (val(readfield(2, rdata, 44)) = 1)
            
#if seguridadalkon then
            if (10 * val(readfield(2, rdata, 44)) = 10) then
                call mi(cualmi).setinvisible(charindex)
            else
                call mi(cualmi).resetinvisible(charindex)
            end if
#end if

            exit sub
        case "zmotd"
            rdata = right$(rdata, len(rdata) - 5)
            frmcambiamotd.show , frmmain
            frmcambiamotd.txtmotd.text = rdata
            exit sub
        case "dados"
            rdata = right$(rdata, len(rdata) - 5)
            with frmcrearpersonaje
                if .visible then
                    .lbfuerza.caption = readfield(1, rdata, 44)
                    .lbagilidad.caption = readfield(2, rdata, 44)
                    .lbinteligencia.caption = readfield(3, rdata, 44)
                    .lbcarisma.caption = readfield(4, rdata, 44)
                    .lbconstitucion.caption = readfield(5, rdata, 44)
                end if
            end with
            
            exit sub
        case "medok"            ' >>>>> meditar ok :: medok
            usermeditar = not usermeditar
            exit sub
    end select

    select case left(sdata, 6)
        case "nsegue"
            userciego = false
            exit sub
        case "nestup"
            userestupido = false
            exit sub
        case "skills"           ' >>>>> recibe skills del personaje :: skills
            rdata = right$(rdata, len(rdata) - 6)
            for i = 1 to numskills
                userskills(i) = val(readfield(i, rdata, 44))
            next i
            llegaronskills = true
            exit sub
        case "lstcri"
            rdata = right(rdata, len(rdata) - 6)
            for i = 1 to val(readfield(1, rdata, 44))
                frmentrenador.lstcriaturas.additem readfield(i + 1, rdata, 44)
            next i
            frmentrenador.show , frmmain
            exit sub
    end select
    
    select case left$(sdata, 7)
        case "guildne"
            rdata = right(rdata, len(rdata) - 7)
            call frmguildnews.parseguildnews(rdata)
            exit sub
        case "peacede"  'detalles de paz
            rdata = right(rdata, len(rdata) - 7)
            call frmuserrequest.recievepeticion(rdata)
            exit sub
        case "alliede"  'detalles de paz
            rdata = right(rdata, len(rdata) - 7)
            call frmuserrequest.recievepeticion(rdata)
            exit sub
        case "alliepr"  'lista de prop de alianzas
            rdata = right(rdata, len(rdata) - 7)
            call frmpeaceprop.parseallieoffers(rdata)
        case "peacepr"  'lista de prop de paz
            rdata = right(rdata, len(rdata) - 7)
            call frmpeaceprop.parsepeaceoffers(rdata)
            exit sub
        case "chrinfo"
            rdata = right(rdata, len(rdata) - 7)
            call frmcharinfo.parsecharinfo(rdata)
            exit sub
        case "leaderi"
            rdata = right(rdata, len(rdata) - 7)
            call frmguildleader.parseleaderinfo(rdata)
            exit sub
        case "clandet"
            rdata = right(rdata, len(rdata) - 7)
            call frmguildbrief.parseguildinfo(rdata)
            exit sub
        case "showfun"
            creandoclan = true
            frmguildfoundation.show , frmmain
            exit sub
        case "paradok"         ' >>>>> paralizar ok :: paradok
            userparalizado = not userparalizado
            exit sub
        case "peticio"         ' >>>>> paralizar ok :: paradok
            rdata = right(rdata, len(rdata) - 7)
            call frmuserrequest.recievepeticion(rdata)
            call frmuserrequest.show(vbmodeless, frmmain)
            exit sub
        case "transok"           ' transacci�n ok :: transok
            if frmcomerciar.visible then
                i = 1
                do while i <= max_inventory_slots
                    if inventario.objindex(i) <> 0 then
                        frmcomerciar.list1(1).additem inventario.itemname(i)
                    else
                        frmcomerciar.list1(1).additem "nada"
                    end if
                    i = i + 1
                loop
                rdata = right(rdata, len(rdata) - 7)
                
                if readfield(2, rdata, 44) = "0" then
                    frmcomerciar.list1(0).listindex = frmcomerciar.lastindex1
                else
                    frmcomerciar.list1(1).listindex = frmcomerciar.lastindex2
                end if
            end if
            exit sub
        '[kevin]------------------------------------------------------------------
        '*********************************************************************************
        case "bancook"           ' banco ok :: bancook
            if frmbancoobj.visible then
                i = 1
                do while i <= max_inventory_slots
                    if inventario.objindex(i) <> 0 then
                            frmbancoobj.list1(1).additem inventario.itemname(i)
                    else
                            frmbancoobj.list1(1).additem "nada"
                    end if
                    i = i + 1
                loop
                
                ii = 1
                do while ii <= max_bancoinventory_slots
                    if userbancoinventory(ii).objindex <> 0 then
                            frmbancoobj.list1(0).additem userbancoinventory(ii).name
                    else
                            frmbancoobj.list1(0).additem "nada"
                    end if
                    ii = ii + 1
                loop
                
                rdata = right(rdata, len(rdata) - 7)
                
                if readfield(2, rdata, 44) = "0" then
                        frmbancoobj.list1(0).listindex = frmbancoobj.lastindex1
                else
                        frmbancoobj.list1(1).listindex = frmbancoobj.lastindex2
                end if
            end if
            exit sub
        '[/kevin]************************************************************************
        '----------------------------------------------------------------------------------
        case "abpanel"
            frmpanelgm.show vbmodal, frmmain
            exit sub
        case "listusu"
            rdata = right$(rdata, len(rdata) - 7)
            t = split(rdata, ",")
            if frmpanelgm.visible then
                frmpanelgm.cbolistausus.clear
                for i = lbound(t) to ubound(t)
                    'frmpanelgm.cbolistausus.additem iif(left(t(i), 1) = " ", right(t(i), len(t(i)) - 1), t(i))
                    frmpanelgm.cbolistausus.additem t(i)
                next i
                if frmpanelgm.cbolistausus.listcount > 0 then frmpanelgm.cbolistausus.listindex = 0
            end if
            exit sub
    end select
    
    '[alejo]
    select case ucase$(left$(rdata, 9))
        case "comusuinv"
            rdata = right$(rdata, len(rdata) - 9)
            otroinventario(1).objindex = readfield(2, rdata, 44)
            otroinventario(1).name = readfield(3, rdata, 44)
            otroinventario(1).amount = readfield(4, rdata, 44)
            otroinventario(1).equipped = readfield(5, rdata, 44)
            otroinventario(1).grhindex = val(readfield(6, rdata, 44))
            otroinventario(1).objtype = val(readfield(7, rdata, 44))
            otroinventario(1).maxhit = val(readfield(8, rdata, 44))
            otroinventario(1).minhit = val(readfield(9, rdata, 44))
            otroinventario(1).def = val(readfield(10, rdata, 44))
            otroinventario(1).valor = val(readfield(11, rdata, 44))
            
            frmcomerciarusu.list2.clear
            
            frmcomerciarusu.list2.additem otroinventario(1).name
            frmcomerciarusu.list2.itemdata(frmcomerciarusu.list2.newindex) = otroinventario(1).amount
            
            frmcomerciarusu.lblestadoresp.visible = false
    end select
    
#if seguridadalkon then
    if handlecrypteddata(rdata) then exit sub
    
    if handledataex(rdata) then exit sub
#end if
    
    ';call logcustom("unhandled data: " & rdata)
    
end sub

sub senddata(byval sddata as string)

    'no enviamos nada si no estamos conectados
#if usarwrench = 1 then
    if not frmmain.socket1.connected then exit sub
#else
    if frmmain.winsock1.state <> sckconnected then exit sub
#end if

    dim auxcmd as string
    auxcmd = ucase$(left$(sddata, 5))
    
    'debug.print ">> " & sddata

#if seguridadalkon then
    bk = checksum(bk, sddata)


    'agregamos el fin de linea
    sddata = sddata & "~" & bk & endc
#else
    sddata = sddata & endc
#end if

    'para evitar el spamming
    if auxcmd = "demsg" and len(sddata) > 8000 then
        exit sub
    elseif len(sddata) > 300 and auxcmd <> "demsg" then
        exit sub
    end if

#if usarwrench = 1 then
    call frmmain.socket1.write(sddata, len(sddata))
#else
    call frmmain.winsock1.senddata(sddata)
#end if

end sub

sub login(byval valcode as integer)
    if estadologin = normal then
        senddata ("ologin" & username & "," & userpassword & "," & app.major & "." & app.minor & "." & app.revision & "," & versiones(1) & "," & versiones(2) & "," & versiones(3) & "," & versiones(4) & "," & versiones(5) & "," & versiones(6) & "," & versiones(7) & "," & valcode & md5hushyo)
    elseif estadologin = crearnuevopj then
        senddata ("nlogin" & username & "," & userpassword _
                & "," & app.major & "." & app.minor & "." & app.revision _
                & "," & userraza & "," & usersexo & "," & userclase _
                & "," & userskills(1) & "," & userskills(2) _
                & "," & userskills(3) & "," & userskills(4) _
                & "," & userskills(5) & "," & userskills(6) _
                & "," & userskills(7) & "," & userskills(8) _
                & "," & userskills(9) & "," & userskills(10) _
                & "," & userskills(11) & "," & userskills(12) _
                & "," & userskills(13) & "," & userskills(14) _
                & "," & userskills(15) & "," & userskills(16) _
                & "," & userskills(17) & "," & userskills(18) _
                & "," & userskills(19) & "," & userskills(20) _
                & "," & userskills(21) & "," & useremail _
                & "," & userhogar & "," & versiones(1) & "," & versiones(2) & "," & versiones(3) & "," & versiones(4) & "," & versiones(5) & "," & versiones(6) & "," & versiones(7) & "," & valcode & md5hushyo)
    end if
end sub
