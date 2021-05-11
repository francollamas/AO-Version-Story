version 5.00
begin vb.form frmservidor 
   backcolor       =   &h00ffc0c0&
   caption         =   "configuraci�n del servidor"
   clientheight    =   6000
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   6600
   controlbox      =   0   'false
   beginproperty font 
      name            =   "ms sans serif"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   scaleheight     =   400
   scalemode       =   3  'pixel
   scalewidth      =   440
   startupposition =   2  'centerscreen
   begin vb.commandbutton cmdreiniciar 
      backcolor       =   &h00ffc0c0&
      caption         =   "reiniciar"
      enabled         =   0   'false
      height          =   375
      left            =   1920
      style           =   1  'graphical
      tabindex        =   17
      top             =   5520
      width           =   1695
   end
   begin vb.frame frame3 
      backcolor       =   &h00ffc0c0&
      caption         =   "administraci�n"
      height          =   2415
      left            =   120
      tabindex        =   16
      top             =   2040
      width           =   6375
      begin vb.commandbutton cmdresetlisten 
         backcolor       =   &h00ffc0c0&
         caption         =   "reset listen"
         height          =   375
         left            =   2280
         style           =   1  'graphical
         tabindex        =   28
         top             =   1920
         width           =   1935
      end
      begin vb.commandbutton cmdresetsockets 
         backcolor       =   &h00ffc0c0&
         caption         =   "reset sockets"
         height          =   375
         left            =   240
         style           =   1  'graphical
         tabindex        =   27
         top             =   1920
         width           =   1935
      end
      begin vb.commandbutton cmddebuguserlist 
         backcolor       =   &h00ffc0c0&
         caption         =   "debug userlist"
         height          =   495
         left            =   4320
         style           =   1  'graphical
         tabindex        =   26
         top             =   1320
         width           =   1935
      end
      begin vb.commandbutton cmdunbanallips 
         backcolor       =   &h00ffc0c0&
         caption         =   "unban all ips (peligro!)"
         height          =   495
         left            =   2280
         style           =   1  'graphical
         tabindex        =   25
         top             =   1320
         width           =   1935
      end
      begin vb.commandbutton cmdunbanall 
         backcolor       =   &h00ffc0c0&
         caption         =   "unban all (peligro!)"
         height          =   495
         left            =   240
         style           =   1  'graphical
         tabindex        =   24
         top             =   1320
         width           =   1935
      end
      begin vb.commandbutton cmddebugnpcs 
         backcolor       =   &h00ffc0c0&
         caption         =   "debug npcs"
         height          =   375
         left            =   4320
         style           =   1  'graphical
         tabindex        =   23
         top             =   840
         width           =   1935
      end
      begin vb.commandbutton frmadministracion 
         backcolor       =   &h00ffc0c0&
         caption         =   "administraci�n"
         height          =   375
         left            =   2280
         style           =   1  'graphical
         tabindex        =   22
         top             =   840
         width           =   1935
      end
      begin vb.commandbutton cmdpausarservidor 
         backcolor       =   &h00ffc0c0&
         caption         =   "pausar el servidor"
         height          =   375
         left            =   240
         style           =   1  'graphical
         tabindex        =   21
         top             =   840
         width           =   1935
      end
      begin vb.commandbutton cmdstatsslots 
         backcolor       =   &h00ffc0c0&
         caption         =   "stats de slots"
         height          =   375
         left            =   4320
         style           =   1  'graphical
         tabindex        =   20
         top             =   360
         width           =   1935
      end
      begin vb.commandbutton cmdvertrafico 
         backcolor       =   &h00ffc0c0&
         caption         =   "tr�fico"
         height          =   375
         left            =   2280
         style           =   1  'graphical
         tabindex        =   19
         top             =   360
         width           =   1935
      end
      begin vb.commandbutton cmdconfigintervalos 
         backcolor       =   &h00ffc0c0&
         caption         =   "config. intervalos"
         height          =   375
         left            =   240
         style           =   1  'graphical
         tabindex        =   18
         top             =   360
         width           =   1935
      end
   end
   begin vb.commandbutton cmdcerrar 
      backcolor       =   &h00ffc0c0&
      cancel          =   -1  'true
      caption         =   "salir (esc)"
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   15
      top             =   5520
      width           =   1695
   end
   begin vb.commandbutton cmdapagarserver 
      backcolor       =   &h00c0c0ff&
      caption         =   "apagar server con backup"
      height          =   375
      left            =   3720
      style           =   1  'graphical
      tabindex        =   14
      top             =   5520
      width           =   2775
   end
   begin vb.frame frame2 
      backcolor       =   &h00ffc0c0&
      caption         =   "backup"
      height          =   735
      left            =   120
      tabindex        =   10
      top             =   4560
      width           =   6375
      begin vb.commandbutton cmdloadworldbackup 
         backcolor       =   &h00ffc0c0&
         caption         =   "cargar mapas"
         height          =   375
         left            =   4320
         style           =   1  'graphical
         tabindex        =   13
         top             =   240
         width           =   1935
      end
      begin vb.commandbutton cmdcharbackup 
         backcolor       =   &h00ffc0c0&
         caption         =   "guardar chars"
         height          =   375
         left            =   2280
         style           =   1  'graphical
         tabindex        =   12
         top             =   240
         width           =   1935
      end
      begin vb.commandbutton cmdworldbackup 
         backcolor       =   &h00ffc0c0&
         caption         =   "guardar mapas"
         height          =   375
         left            =   240
         style           =   1  'graphical
         tabindex        =   11
         top             =   240
         width           =   1935
      end
   end
   begin vb.frame frame1 
      backcolor       =   &h00ffc0c0&
      caption         =   "recargar"
      height          =   1815
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   6375
      begin vb.commandbutton cmdrecargaradministradores 
         backcolor       =   &h0080c0ff&
         caption         =   "administradores"
         height          =   375
         left            =   1680
         style           =   1  'graphical
         tabindex        =   29
         top             =   1320
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarguardiasposorig 
         backcolor       =   &h00ffc0c0&
         caption         =   "guardias en pos originales"
         height          =   375
         left            =   3240
         style           =   1  'graphical
         tabindex        =   9
         top             =   1320
         width           =   3015
      end
      begin vb.commandbutton cmdrecargarmotd 
         backcolor       =   &h00ffc0c0&
         caption         =   "motd"
         height          =   375
         left            =   120
         style           =   1  'graphical
         tabindex        =   8
         top             =   1320
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarmd5s 
         backcolor       =   &h00ffc0c0&
         caption         =   "md5s"
         height          =   375
         left            =   3240
         style           =   1  'graphical
         tabindex        =   7
         top             =   360
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarserverini 
         backcolor       =   &h00ffc0c0&
         caption         =   "server.ini"
         height          =   375
         left            =   4800
         style           =   1  'graphical
         tabindex        =   6
         top             =   360
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarnombresinvalidos 
         backcolor       =   &h00ffc0c0&
         caption         =   "nombresinvalidos.txt"
         height          =   375
         left            =   3240
         style           =   1  'graphical
         tabindex        =   5
         top             =   840
         width           =   3015
      end
      begin vb.commandbutton cmdrecargarnpcs 
         backcolor       =   &h00ffc0c0&
         caption         =   "npcs.dat"
         height          =   375
         left            =   120
         style           =   1  'graphical
         tabindex        =   4
         top             =   840
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarbalance 
         backcolor       =   &h00ffc0c0&
         caption         =   "balance.dat"
         height          =   375
         left            =   1680
         style           =   1  'graphical
         tabindex        =   3
         top             =   840
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarhechizos 
         backcolor       =   &h00ffc0c0&
         caption         =   "hechizos.dat"
         height          =   375
         left            =   1680
         style           =   1  'graphical
         tabindex        =   2
         top             =   360
         width           =   1455
      end
      begin vb.commandbutton cmdrecargarobjetos 
         backcolor       =   &h00ffc0c0&
         caption         =   "obj.dat"
         height          =   375
         left            =   120
         style           =   1  'graphical
         tabindex        =   1
         top             =   360
         width           =   1455
      end
   end
end
attribute vb_name = "frmservidor"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
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

private sub form_load()

#if usarquesocket = 1 then
    cmdresetsockets.visible = true
    cmdresetlisten.visible = true
#elseif usarquesocket = 0 then
    cmdresetsockets.visible = false
    cmdresetlisten.visible = false
#elseif usarquesocket = 2 then
    cmdresetsockets.visible = true
    cmdresetlisten.visible = false
#end if

end sub

private sub cmdapagarserver_click()
    
    if msgbox("�est� seguro que desea hacer worldsave, guardar pjs y cerrar?", vbyesno, _
        "apagar magicamente") = vbno then exit sub
    
    me.mousepointer = 11
    
    frmstat.show
   
    'worldsave
    call es.dobackup

    'commit experiencia
    call mdparty.actualizaexperiencias

    'guardar pjs
    call guardarusuarios
    
    'chauuu
    unload frmmain

end sub

private sub cmdcerrar_click()
    frmservidor.visible = false
end sub

private sub cmdcharbackup_click()
    me.mousepointer = 11
    call mdparty.actualizaexperiencias
    call guardarusuarios
    me.mousepointer = 0
    msgbox "grabado de personajes ok!"
end sub

private sub cmdconfigintervalos_click()
    frminterv.show
end sub

private sub cmddebugnpcs_click()
    frmdebugnpc.show
end sub

private sub cmddebuguserlist_click()
    frmuserlist.show
end sub

private sub cmdloadworldbackup_click()
'se asegura de que los sockets estan cerrados e ignora cualquier err
on error resume next

    if frmmain.visible then frmmain.txstatus.caption = "reiniciando."
    
    frmstat.show
    
    if fileexist(app.path & "\logs\errores.log", vbnormal) then kill app.path & "\logs\errores.log"
    if fileexist(app.path & "\logs\connect.log", vbnormal) then kill app.path & "\logs\connect.log"
    if fileexist(app.path & "\logs\hackattemps.log", vbnormal) then kill app.path & "\logs\hackattemps.log"
    if fileexist(app.path & "\logs\asesinatos.log", vbnormal) then kill app.path & "\logs\asesinatos.log"
    if fileexist(app.path & "\logs\resurrecciones.log", vbnormal) then kill app.path & "\logs\resurrecciones.log"
    if fileexist(app.path & "\logs\teleports.log", vbnormal) then kill app.path & "\logs\teleports.log"


#if usarquesocket = 1 then
    call apiclosesocket(socklisten)
#elseif usarquesocket = 0 then
    frmmain.socket1.cleanup
    frmmain.socket2(0).cleanup
#elseif usarquesocket = 2 then
    frmmain.serv.detener
#end if

    dim loopc as integer
    
    for loopc = 1 to maxusers
        call closesocket(loopc)
    next
      
    
    lastuser = 0
    numusers = 0
    
    call freenpcs
    call freecharindexes
    
    call loadsini
    call cargarbackup
    call loadobjdata

#if usarquesocket = 1 then
    socklisten = listenforconnect(puerto, hwndmsg, "")

#elseif usarquesocket = 0 then
    frmmain.socket1.addressfamily = af_inet
    frmmain.socket1.protocol = ipproto_ip
    frmmain.socket1.sockettype = sock_stream
    frmmain.socket1.binary = false
    frmmain.socket1.blocking = false
    frmmain.socket1.buffersize = 1024
    
    frmmain.socket2(0).addressfamily = af_inet
    frmmain.socket2(0).protocol = ipproto_ip
    frmmain.socket2(0).sockettype = sock_stream
    frmmain.socket2(0).blocking = false
    frmmain.socket2(0).buffersize = 2048
    
    'escucha
    frmmain.socket1.localport = puerto
    frmmain.socket1.listen
#end if

    if frmmain.visible then frmmain.txstatus.caption = "escuchando conexiones entrantes ..."

end sub

private sub cmdpausarservidor_click()
    if enpausa = false then
        enpausa = true
        call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
        cmdpausarservidor.caption = "reanudar el servidor"
    else
        enpausa = false
        call senddata(sendtarget.toall, 0, preparemessagepausetoggle())
        cmdpausarservidor.caption = "pausar el servidor"
    end if
end sub

private sub cmdrecargarbalance_click()
    call loadbalance
end sub

private sub cmdrecargarguardiasposorig_click()
    call respawnorigposnpcs
end sub

private sub cmdrecargarhechizos_click()
    call cargarhechizos
end sub

private sub cmdrecargarmd5s_click()
    call md5scarga
end sub

private sub cmdrecargarmotd_click()
    call loadmotd
end sub

private sub cmdrecargarnombresinvalidos_click()
    call cargarforbidenwords
end sub

private sub cmdrecargarnpcs_click()
    call carganpcsdat
end sub

private sub cmdrecargarobjetos_click()
    call resetforums
    call loadobjdata
end sub

private sub cmdrecargarserverini_click()
    call loadsini
end sub

private sub cmdreiniciar_click()

    if msgbox("��atencion!! si reinicia el servidor puede provocar la p�rdida de datos de los usarios. " & _
    "�desea reiniciar el servidor de todas maneras?", vbyesno) = vbno then exit sub
    
    me.visible = false
    call general.restart

end sub

private sub cmdresetlisten_click()

#if usarquesocket = 1 then
    'cierra el socket de escucha
    if socklisten >= 0 then call apiclosesocket(socklisten)
    
    'inicia el socket de escucha
    socklisten = listenforconnect(puerto, hwndmsg, "")
#end if

end sub

private sub cmdresetsockets_click()

#if usarquesocket = 1 then

    if msgbox("�est� seguro que desea reiniciar los sockets? se cerrar�n todas las conexiones activas.", vbyesno, "reiniciar sockets") = vbyes then
        call wsapireiniciarsockets
    end if

#elseif usarquesocket = 2 then

    dim loopc as integer
    
    if msgbox("�est� seguro que desea reiniciar los sockets? se cerrar�n todas las conexiones activas.", vbyesno, "reiniciar sockets") = vbyes then
        for loopc = 1 to maxusers
            if userlist(loopc).connid <> -1 and userlist(loopc).connidvalida then
                call closesocket(loopc)
            end if
        next loopc
        
        call frmmain.serv.detener
        call frmmain.serv.iniciar(puerto)
    end if

#end if

end sub

private sub cmdstatsslots_click()
    frmconid.show
end sub

private sub cmdunbanall_click()
on error resume next

    dim fn as string
    dim cad$
    dim n as integer, k as integer
    
    dim sentrada as string
    
    sentrada = inputbox("escribe ""estoy de acuerdo"" entre comillas y con distinci�n de may�sculas min�sculas para desbanear a todos los personajes.", "unban", "hola")
    if sentrada = "estoy de acuerdo" then
    
        fn = app.path & "\logs\gentebanned.log"
        
        if fileexist(fn, vbnormal) then
            n = freefile
            open fn for input shared as #n
            do while not eof(n)
                k = k + 1
                input #n, cad$
                call unban(cad$)
                
            loop
            close #n
            msgbox "se han habilitado " & k & " personajes."
            kill fn
        end if
    end if
end sub

private sub cmdunbanallips_click()
    dim i as long, n as long
    
    dim sentrada as string
    
    sentrada = inputbox("escribe ""estoy de acuerdo"" sin comillas y con distinci�n de may�sculas min�sculas para desbanear a todos los personajes", "unban", "hola")
    if sentrada = "estoy de acuerdo" then
        
        n = banips.count
        for i = 1 to banips.count
            banips.remove 1
        next i
        
        msgbox "se han habilitado " & n & " ipes"
    end if
end sub

private sub cmdvertrafico_click()
    frmtrafic.show
end sub

private sub cmdworldbackup_click()
on error goto errhandler

    me.mousepointer = 11
    frmstat.show
    call es.dobackup
    me.mousepointer = 0
    msgbox "worldsave ok!!"
    
    exit sub

errhandler:
    call logerror("error en worldsave")
end sub

private sub form_deactivate()
    frmservidor.visible = false
end sub

private sub frmadministracion_click()
    me.visible = false
    frmadmin.show
end sub

private sub cmdrecargaradministradores_click()
    loadadministrativeusers
end sub

