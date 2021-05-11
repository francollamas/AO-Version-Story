attribute vb_name = "mod_tcp"
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
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
private enum sentidorotacion
    rotizquierda = 0
    rotderecha = 1
end enum


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
    sdata = ucase(rdata)
    
    debug.print "begin>>> " & rdata
    
   
    select case sdata
        case "logged"            ' >>>>> login :: logged
            logged = true
            userciego = false
            enginerun = true
            iscombate = false
            userdescansar = false
            nombres = true
            if frmcrearpersonaje.visible then
                   unload frmpasswd
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
            call dofogatafx
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
            call frmmain.stopsound
            frmmain.isplaying = plnone
            brain = false
            bnoche = false
            bfogata = false
            skillpoints = 0
            frmmain.label1.visible = false
            call dialogos.borrardialogos
            for i = 1 to lastchar
                charlist(i).invisible = false
            next i

            bo = 0
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
            do while i <= ubound(userinventory)
                if userinventory(i).objindex <> 0 then
                        frmcomerciar.list1(1).additem userinventory(i).name
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
            do while ii <= ubound(userinventory)
                if userinventory(ii).objindex <> 0 then
                        frmbancoobj.list1(1).additem userinventory(ii).name
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
            
            for i = 1 to ubound(userinventory)
                if userinventory(i).objindex <> 0 then
                        frmcomerciarusu.list1.additem userinventory(i).name
                        frmcomerciarusu.list1.itemdata(frmcomerciarusu.list1.newindex) = userinventory(i).amount
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
            call addtorichtextbox(frmmain.rectxt, "la criatura fallo el golpe!!!", 255, 0, 0, true, false, false)
            exit sub
        case "6" ' <--- npc mata al usuario
            call addtorichtextbox(frmmain.rectxt, "la criatura te ha matado!!!", 255, 0, 0, true, false, false)
            exit sub
        case "7" ' <--- ataque rechazado con el escudo
            call addtorichtextbox(frmmain.rectxt, "has rechazado el ataque con el escudo!!!", 255, 0, 0, true, false, false)
            exit sub
        case "8" ' <--- ataque rechazado con el escudo
            call addtorichtextbox(frmmain.rectxt, "el usuario rechazo el ataque con su escudo!!!", 255, 0, 0, true, false, false)
            exit sub
        case "u1" ' <--- user ataco y fallo el golpe
            call addtorichtextbox(frmmain.rectxt, "has fallado el golpe!!!", 255, 0, 0, true, false, false)
            exit sub
        case "reau" '<--- requiere autoupdate
            call frmmain.dibujarsatelite
            exit sub
        case "segon" '  <--- activa el seguro
            call frmmain.dibujarseguro
            call addtorichtextbox(frmmain.rectxt, ">>seguro activado<<", 0, 255, 0, true, false, false)
            exit sub
        case "segoff" ' <--- desactiva el seguro
            call frmmain.desdibujarseguro
            call addtorichtextbox(frmmain.rectxt, ">>seguro desactivado<<", 255, 0, 0, true, false, false)
            exit sub
        case "pn"     ' <--- pierde nobleza
            call addtorichtextbox(frmmain.rectxt, "��has perdido puntaje de nobleza y ganado puntaje de criminalidad!! si sigues ayudando a criminales te convertir�s en uno de ellos y ser�s perseguido por las tropas de las ciudades.", 255, 0, 0, false, false, false)
            exit sub
        case "m!"     ' <--- usa meditando
            call addtorichtextbox(frmmain.rectxt, "�est�s meditando! debes dejar de meditar para usar objetos.", 255, 0, 0, false, false, false)
            exit sub
    end select


    select case left(sdata, 2)
        case "cm"              ' >>>>> cargar mapa :: cm
            rdata = right$(rdata, len(rdata) - 2)
            usermap = readfield(1, rdata, 44)
            'obtiene la version del mapa
                        
            call initmi
            
            if fileexist(dirmapas & "mapa" & usermap & ".map", vbnormal) then
                open dirmapas & "mapa" & usermap & ".map" for binary as #1
                seek #1, 1
                get #1, , tempint
                close #1
                if tempint = val(readfield(2, rdata, 44)) then
                    'si es la vers correcta cambiamos el mapa
                    call switchmap(usermap)
                    if blluvia(usermap) = 0 then
                        if brain then
                            'call stopsound("lluviain.mp3")
                            'call stopsound("lluviaout.mp3")
                            '[code 001]:matux'
                                frmmain.stopsound
                                frmmain.isplaying = plnone
                            '[end]'
                        end if
                    end if
                else
                    'vers incorrecta
                    msgbox "error en los mapas, algun archivo ha sido modificado o esta da�ado."
                    call liberarobjetosdx
                    call unloadallforms
                    end
                end if
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
            exit sub
        case "n2" ' <<--- npc nos impacto (ahorramos ancho de banda)
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado en la cabeza por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado el brazo izquierdo por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado el brazo derecho por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado la pierna izquierda por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado la pierna derecha por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, "��la criatura te ha pegado en el torso por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "u2" ' <<--- el user ataco un npc e impacato
            rdata = right$(rdata, len(rdata) - 2)
            call addtorichtextbox(frmmain.rectxt, "��le has pegado a la criatura por " & rdata & "!!", 255, 0, 0, true, false, false)
            exit sub
        case "u3" ' <<--- el user ataco un user y falla
            rdata = right$(rdata, len(rdata) - 2)
            call addtorichtextbox(frmmain.rectxt, "��" & rdata & " te ataco y fallo!!", 255, 0, 0, true, false, false)
            exit sub
        case "n4" ' <<--- user nos impacto
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado en la cabeza por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado el brazo izquierdo por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado el brazo derecho por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado la pierna izquierda por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado la pierna derecha por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, "��" & readfield(3, rdata, 44) & " te ha pegado en el torso por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "n5" ' <<--- impactamos un user
            rdata = right$(rdata, len(rdata) - 2)
            i = val(readfield(1, rdata, 44))
            select case i
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en la cabeza por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en el brazo izquierdo por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en el brazo derecho por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en la pierna izquierda por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en la pierna derecha por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
                case btorso
                    call addtorichtextbox(frmmain.rectxt, "��le has pegado a " & readfield(3, rdata, 44) & " en el torso por " & val(readfield(2, rdata, 44)), 255, 0, 0, true, false, false)
            end select
            exit sub
        case "||"                 ' >>>>> dialogo de usuarios y npcs :: ||
            rdata = right$(rdata, len(rdata) - 2)
            dim iuser as integer
            iuser = val(readfield(3, rdata, 176))
            if iuser > 0 then
                dialogos.creardialogo readfield(2, rdata, 176), iuser, val(readfield(1, rdata, 176))
                'i = 1
                'do while i <= iuser
                '    dialogos.creardialogo readfield(2, rdata, 176), i, val(readfield(1, rdata, 176))
                '    i = i + 1
                'loop
            else
                  if puedoquitarfoco then _
                    addtorichtextbox frmmain.rectxt, readfield(1, rdata, 126), val(readfield(2, rdata, 126)), val(readfield(3, rdata, 126)), val(readfield(4, rdata, 126)), val(readfield(5, rdata, 126)), val(readfield(6, rdata, 126))
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
            exit sub
        case "cc"              ' >>>>> crear un personaje :: cc
            rdata = right$(rdata, len(rdata) - 2)
            charindex = readfield(4, rdata, 44)
            x = readfield(5, rdata, 44)
            y = readfield(6, rdata, 44)
            
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
            
            if fx = 0 then
                'if not usernavegando and val(readfield(4, rdata, 44)) <> 0 then
                        if charlist(charindex).priv <> 1 and charlist(charindex).priv <> 2 and charlist(charindex).priv <> 3 then
                            call dopasosfx(charindex)
                        end if
                'else
                        'fx navegando
                'end if
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
            if musica = 0 then
                rdata = right$(rdata, len(rdata) - 2)
                if val(readfield(1, rdata, 45)) <> 0 then
                    'stop_midi
                    if musica = 0 then
                        curmidi = val(readfield(1, rdata, 45)) & ".mid"
                        loopmidi = val(readfield(2, rdata, 45))
                        call cargarmidi(dirmidi & curmidi)
                        call play_midi
                    end if
                end if
            end if
            exit sub
        case "tw"          ' >>>>> play un wav :: tw
            if fx = 0 then
                rdata = right$(rdata, len(rdata) - 2)
                 call playwaveds(rdata & ".wav")
            end if
            exit sub
        case "gl" 'lista de guilds
            rdata = right$(rdata, len(rdata) - 2)
            call frmguildadm.parseguildlist(rdata)
            exit sub
        case "fo"          ' >>>>> play un wav :: tw
            bfogata = true
            '[code 001]:matux
                if frmmain.isplaying <> plfogata then
                    frmmain.stopsound
                    call frmmain.play("fuego.wav", true)
                    frmmain.isplaying = plfogata
                end if
            '[end]'
            exit sub
    end select

    select case left(sdata, 3)
        case "val"                  ' >>>>> validar cliente :: val
            rdata = right$(rdata, len(rdata) - 3)
            'if frmborrar.visible then
            bk = clng(readfield(1, rdata, asc(",")))
            bo = 100 'cint(readfield(1, rdata, asc(",")))
            brk = readfield(2, rdata, asc(","))
            if estadologin = borrarpj then
                call senddata("borr" & frmborrar.txtnombre.text & "," & frmborrar.txtpasswd.text & "," & validarloginmsg(cint(rdata)))
            elseif estadologin = normal or estadologin = crearnuevopj then
                call login(0)
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
               if blluvia(usermap) <> 0 then
                    if btecho then
                        'call stopsound("lluviain.mp3")
                        'call playsound("lluviainend.mp3")
                        '[code 001]:matux'
                        call frmmain.stopsound
                        call frmmain.play("lluviainend.wav", false)
                        frmmain.isplaying = plnone
                        '[end]'
                   else
                        'call stopsound("lluviaout.mp3")
                        'call playsound("lluviaoutend.mp3")
                        '[code 001]:matux'
                        call frmmain.stopsound
                        call frmmain.play("lluviaoutend.wav", false)
                        frmmain.isplaying = plnone
                        '[end]'
                    end if
               end if
               brain = false
            end if
                        
            exit sub
        case "noc" 'nocheeeee
'            debug.print rdata
            rdata = right$(rdata, len(rdata) - 3)
            bnoche = iif(rdata = "1", true, false)
            surfacedb.efectopred = iif(bnoche, 1, 0)
            
            call surfacedb.borrartodo
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
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre el objetivo...", 100, 100, 120, 0, 0)
                case pesca
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre el sitio donde quieres pescar...", 100, 100, 120, 0, 0)
                case robar
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre la victima...", 100, 100, 120, 0, 0)
                case talar
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre el �rbol...", 100, 100, 120, 0, 0)
                case mineria
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre el yacimiento...", 100, 100, 120, 0, 0)
                case fundirmetal
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre la fragua...", 100, 100, 120, 0, 0)
                case proyectiles
                    call addtorichtextbox(frmmain.rectxt, "haz click sobre la victima...", 100, 100, 120, 0, 0)
            end select
            exit sub
        case "csi"                 ' >>>>> actualiza slot inventario :: csi
            rdata = right$(rdata, len(rdata) - 3)
            slot = readfield(1, rdata, 44)
            userinventory(slot).objindex = readfield(2, rdata, 44)
            userinventory(slot).name = readfield(3, rdata, 44)
            userinventory(slot).amount = readfield(4, rdata, 44)
            userinventory(slot).equipped = readfield(5, rdata, 44)
            userinventory(slot).grhindex = val(readfield(6, rdata, 44))
            userinventory(slot).objtype = val(readfield(7, rdata, 44))
            userinventory(slot).maxhit = val(readfield(8, rdata, 44))
            userinventory(slot).minhit = val(readfield(9, rdata, 44))
            userinventory(slot).def = val(readfield(10, rdata, 44))
            userinventory(slot).valor = val(readfield(11, rdata, 44))
        
            tempstr = ""
            if userinventory(slot).equipped = 1 then
                tempstr = tempstr & "(eqp)"
            end if
            
            if userinventory(slot).amount > 0 then
                tempstr = tempstr & "(" & userinventory(slot).amount & ") " & userinventory(slot).name
            else
                tempstr = tempstr & userinventory(slot).name
            end if
            
            binvmod = true
            
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
            
            binvmod = true
            
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
            frmpasswd.mousepointer = 1
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
    
    
    select case left(sdata, 4)
        case "part"
            call addtorichtextbox(frmmain.rectxt, "si deseas entrar en una party con " & readfield(1, rdata, 44) & ", escribe /entrarparty", 0, 255, 0, false, false, false)
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
            
            binvmod = true
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
            addtorichtextbox frmmain.rectxt, "hay " & rdata & " npcs.", 255, 255, 255, 0, 0
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
        case "cose"
            usandosistemapadrinos = readfield(1, rdata, 44)
            puedecrearpjs = readfield(1, rdata, 44)
            exit sub
    end select

    select case left(sdata, 5)
        case "nover"
            rdata = right$(rdata, len(rdata) - 5)
            charindex = val(readfield(1, rdata, 44))
            charlist(charindex).invisible = (val(readfield(2, rdata, 44)) = 1)
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
                    
                    tempstr = readfield(6, rdata, 44)
                    if tempstr <> "" then usandosistemapadrinos = val(tempstr)
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
    
    select case left(sdata, 7)
        case "guildne"
            rdata = right(rdata, len(rdata) - 7)
            call frmguildnews.parseguildnews(rdata)
            exit sub
        case "peacede"
            rdata = right(rdata, len(rdata) - 7)
            call frmuserrequest.recievepeticion(rdata)
            exit sub
        case "peacepr"
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
                do while i <= ubound(userinventory)
                    if userinventory(i).objindex <> 0 then
                            frmcomerciar.list1(1).additem userinventory(i).name
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
                do while i <= ubound(userinventory)
                    if userinventory(i).objindex <> 0 then
                            frmbancoobj.list1(1).additem userinventory(i).name
                    else
                            frmbancoobj.list1(1).additem "nada"
                    end if
                    i = i + 1
                loop
                
                ii = 1
                do while ii <= ubound(userbancoinventory)
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
            frmpanelgm.show , frmmain
            exit sub
        case "listusu"
            rdata = right(rdata, len(rdata) - 7)
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
    select case ucase(left(rdata, 9))
    case "comusuinv"
        rdata = right(rdata, len(rdata) - 9)
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
    
end sub


sub senddata(byval sddata as string)
dim retcode

dim auxcmd as string
auxcmd = ucase(left(sddata, 5))

'debug.print ">> " & sddata

bk = gencrc(bk, sddata)

bo = bo + 1
if bo > 10000 then bo = 100


'agregamos el fin de linea
sddata = sddata & "~" & bk & endc

'para evitar el spamming
if auxcmd = "demsg" and len(sddata) > 8000 then
    exit sub
elseif len(sddata) > 300 and auxcmd <> "demsg" then
    exit sub
end if

#if usarwrench = 1 then
    retcode = frmmain.socket1.write(sddata, len(sddata))
#else
    call frmmain.winsock1.senddata(sddata)
#end if

end sub

sub login(byval valcode as integer)

'personaje grabado
'if sendnewchar = false then

if estadologin = normal then
    senddata ("ologin" & username & "," & userpassword & "," & app.major & "." & app.minor & "." & app.revision & "," & valcode & md5hushyo & "," & versiones(1) & "," & versiones(2) & "," & versiones(3) & "," & versiones(4) & "," & versiones(5) & "," & versiones(6) & "," & versiones(7))
'end if
'crear personaje
'if sendnewchar = true then
'barrin 3/10/03
'mandamos diferentes datos de login nuevo a partir de si se esta usando o no el sistema de
'padrinos en el servidor
elseif estadologin = crearnuevopj and usandosistemapadrinos = 1 then
    senddata ("nlogin" & username & "," & userpassword _
    & "," & 0 & "," & 0 & "," _
    & app.major & "." & app.minor & "." & app.revision & _
    "," & userraza & "," & usersexo & "," & userclase & "," & _
    useratributos(1) & "," & useratributos(2) & "," & useratributos(3) _
    & "," & useratributos(4) & "," & useratributos(5) _
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
     & "," & userskills(21) & "," & useremail & "," _
     & userhogar & "," & padrinoname & "," & padrinopassword & "," & versiones(1) & "," & versiones(2) & "," & versiones(3) & "," & versiones(4) & "," & versiones(5) & "," & versiones(6) & "," & versiones(7) & "," & valcode & md5hushyo)
elseif estadologin = crearnuevopj and usandosistemapadrinos = 0 then
    senddata ("nlogin" & username & "," & userpassword _
    & "," & 0 & "," & 0 & "," _
    & app.major & "." & app.minor & "." & app.revision & _
    "," & userraza & "," & usersexo & "," & userclase & "," & _
    useratributos(1) & "," & useratributos(2) & "," & useratributos(3) _
    & "," & useratributos(4) & "," & useratributos(5) _
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
     & "," & userskills(21) & "," & useremail & "," _
     & userhogar & "," & versiones(1) & "," & versiones(2) & "," & versiones(3) & "," & versiones(4) & "," & versiones(5) & "," & versiones(6) & "," & versiones(7) & "," & valcode & md5hushyo)
end if
end sub
