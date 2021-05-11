version 5.00
object = "{3b7c8863-d78f-101b-b9b5-04021c009402}#1.2#0"; "richtx32.ocx"
object = "{33101c00-75c3-11cf-a8a0-444553540000}#1.0#0"; "cswsk32.ocx"
object = "{48e59290-9880-11cf-9754-00aa00c00908}#1.0#0"; "msinet.ocx"
begin vb.form frmmain 
   backcolor       =   &h00000000&
   borderstyle     =   1  'fixed single
   caption         =   "argentum online"
   clientheight    =   8625
   clientleft      =   390
   clienttop       =   675
   clientwidth     =   11910
   clipcontrols    =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   forecolor       =   &h00000000&
   icon            =   "frmmain.frx":0000
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   575
   scalemode       =   3  'pixel
   scalewidth      =   794
   startupposition =   2  'centerscreen
   visible         =   0   'false
   begin socketwrenchctrl.socket socket1 
      left            =   6750
      top             =   1905
      _version        =   65536
      _extentx        =   741
      _extenty        =   741
      _stockprops     =   0
      autoresolve     =   0   'false
      backlog         =   1
      binary          =   0   'false
      blocking        =   0   'false
      broadcast       =   0   'false
      buffersize      =   2048
      hostaddress     =   ""
      hostfile        =   ""
      hostname        =   ""
      inline          =   0   'false
      interval        =   0
      keepalive       =   0   'false
      library         =   ""
      linger          =   0
      localport       =   0
      localservice    =   ""
      protocol        =   0
      remoteport      =   0
      remoteservice   =   ""
      reuseaddress    =   0   'false
      route           =   -1  'true
      timeout         =   999999
      type            =   1
      urgent          =   0   'false
   end
   begin vb.timer second 
      enabled         =   0   'false
      interval        =   1050
      left            =   2790
      top             =   2760
   end
   begin vb.timer spoofcheck 
      enabled         =   0   'false
      interval        =   60000
      left            =   1290
      top             =   2220
   end
   begin vb.timer trabajo 
      enabled         =   0   'false
      left            =   7200
      top             =   2760
   end
   begin vb.timer fps 
      interval        =   1000
      left            =   6285
      top             =   2040
   end
   begin inetctlsobjects.inet inet1 
      left            =   7605
      top             =   1905
      _extentx        =   1005
      _extenty        =   1005
      _version        =   393216
      requesttimeout  =   30
   end
   begin vb.picturebox panelder 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   8145
      left            =   8235
      picture         =   "frmmain.frx":030a
      scaleheight     =   543
      scalemode       =   3  'pixel
      scalewidth      =   239
      tabindex        =   2
      top             =   -60
      width           =   3585
      begin vb.commandbutton despinv 
         caption         =   "+"
         beginproperty font 
            name            =   "arial"
            size            =   9
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   240
         index           =   1
         left            =   540
         mouseicon       =   "frmmain.frx":1c77b
         mousepointer    =   99  'custom
         tabindex        =   10
         top             =   4800
         width           =   2430
      end
      begin vb.commandbutton despinv 
         caption         =   "-"
         beginproperty font 
            name            =   "arial"
            size            =   9
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   240
         index           =   0
         left            =   540
         mouseicon       =   "frmmain.frx":1c8cd
         mousepointer    =   99  'custom
         tabindex        =   9
         top             =   2160
         width           =   2430
      end
      begin vb.picturebox picinv 
         appearance      =   0  'flat
         autoredraw      =   -1  'true
         backcolor       =   &h00000000&
         borderstyle     =   0  'none
         causesvalidation=   0   'false
         clipcontrols    =   0   'false
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         forecolor       =   &h80000008&
         height          =   2400
         left            =   555
         scaleheight     =   160
         scalemode       =   3  'pixel
         scalewidth      =   161
         tabindex        =   8
         top             =   2400
         width           =   2415
      end
      begin vb.listbox hlst 
         backcolor       =   &h00000000&
         forecolor       =   &h00ffffff&
         height          =   2790
         left            =   360
         tabindex        =   15
         tabstop         =   0   'false
         top             =   2040
         visible         =   0   'false
         width           =   2745
      end
      begin vb.image cmdinfo 
         height          =   405
         left            =   2310
         mouseicon       =   "frmmain.frx":1ca1f
         mousepointer    =   99  'custom
         top             =   4830
         width           =   855
      end
      begin vb.image cmdlanzar 
         height          =   405
         left            =   450
         mouseicon       =   "frmmain.frx":1cb71
         mousepointer    =   99  'custom
         top             =   4830
         width           =   1770
      end
      begin vb.label label1 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "+"
         beginproperty font 
            name            =   "ms serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         forecolor       =   &h00ffffff&
         height          =   195
         left            =   1185
         tabindex        =   14
         top             =   435
         visible         =   0   'false
         width           =   120
      end
      begin vb.label exp 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "exp:"
         forecolor       =   &h8000000e&
         height          =   195
         left            =   285
         tabindex        =   13
         top             =   675
         width           =   345
      end
      begin vb.image image3 
         height          =   195
         index           =   2
         left            =   2070
         top             =   6540
         width           =   360
      end
      begin vb.image image3 
         height          =   195
         index           =   1
         left            =   2055
         top             =   6255
         width           =   360
      end
      begin vb.image image3 
         height          =   195
         index           =   0
         left            =   2085
         top             =   5955
         width           =   360
      end
      begin vb.label gldlbl 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "1"
         beginproperty font 
            name            =   "ms serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         forecolor       =   &h000000ff&
         height          =   195
         left            =   2595
         tabindex        =   12
         top             =   5970
         width           =   105
      end
      begin vb.image image1 
         height          =   300
         index           =   2
         left            =   1905
         mouseicon       =   "frmmain.frx":1ccc3
         mousepointer    =   99  'custom
         top             =   7575
         width           =   1410
      end
      begin vb.image image1 
         height          =   300
         index           =   1
         left            =   1905
         mouseicon       =   "frmmain.frx":1ce15
         mousepointer    =   99  'custom
         top             =   7200
         width           =   1410
      end
      begin vb.image image1 
         height          =   300
         index           =   0
         left            =   1920
         mouseicon       =   "frmmain.frx":1cf67
         mousepointer    =   99  'custom
         top             =   6840
         width           =   1410
      end
      begin vb.shape aguasp 
         backcolor       =   &h00c00000&
         backstyle       =   1  'opaque
         borderstyle     =   0  'transparent
         fillcolor       =   &h0000ffff&
         height          =   75
         left            =   315
         top             =   7575
         width           =   1290
      end
      begin vb.shape comidasp 
         backcolor       =   &h0000c000&
         backstyle       =   1  'opaque
         borderstyle     =   0  'transparent
         fillcolor       =   &h0000ffff&
         height          =   75
         left            =   315
         top             =   7245
         width           =   1290
      end
      begin vb.shape manshp 
         backcolor       =   &h00ffff00&
         backstyle       =   1  'opaque
         borderstyle     =   0  'transparent
         height          =   75
         left            =   315
         top             =   6585
         width           =   1290
      end
      begin vb.shape stashp 
         backcolor       =   &h0000ffff&
         backstyle       =   1  'opaque
         borderstyle     =   0  'transparent
         fillcolor       =   &h0000ffff&
         height          =   75
         left            =   315
         top             =   6240
         width           =   1290
      end
      begin vb.shape hpshp 
         bordercolor     =   &h8000000d&
         borderstyle     =   0  'transparent
         fillcolor       =   &h000000ff&
         fillstyle       =   0  'solid
         height          =   75
         left            =   330
         top             =   6900
         width           =   1290
      end
      begin vb.label label8 
         backstyle       =   0  'transparent
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         forecolor       =   &h000000ff&
         height          =   195
         left            =   495
         tabindex        =   11
         top             =   180
         width           =   2625
      end
      begin vb.label label7 
         backstyle       =   0  'transparent
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   450
         left            =   1800
         mouseicon       =   "frmmain.frx":1d0b9
         mousepointer    =   99  'custom
         tabindex        =   7
         top             =   1290
         width           =   1605
      end
      begin vb.label label4 
         backstyle       =   0  'transparent
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   435
         left            =   150
         mouseicon       =   "frmmain.frx":1d20b
         mousepointer    =   99  'custom
         tabindex        =   6
         top             =   1305
         width           =   1605
      end
      begin vb.image invequ 
         height          =   4395
         left            =   120
         picture         =   "frmmain.frx":1d35d
         top             =   1320
         width           =   3240
      end
      begin vb.label lbcriatura 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         beginproperty font 
            name            =   "verdana"
            size            =   5.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         forecolor       =   &h000000ff&
         height          =   120
         left            =   555
         tabindex        =   5
         top             =   1965
         width           =   30
      end
      begin vb.label lvllbl 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "1"
         forecolor       =   &h00ffffff&
         height          =   195
         left            =   765
         tabindex        =   4
         top             =   450
         width           =   105
      end
      begin vb.label label6 
         backstyle       =   0  'transparent
         caption         =   "nivel"
         forecolor       =   &h00ffffff&
         height          =   225
         left            =   285
         tabindex        =   3
         top             =   450
         width           =   465
      end
   end
   begin vb.timer attack 
      enabled         =   0   'false
      left            =   7170
      top             =   1920
   end
   begin vb.textbox sendtxt 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   315
      left            =   45
      multiline       =   -1  'true
      tabindex        =   0
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   1575
      visible         =   0   'false
      width           =   8160
   end
   begin richtextlib.richtextbox rectxt 
      height          =   1500
      left            =   45
      tabindex        =   1
      tabstop         =   0   'false
      tooltiptext     =   "mensajes del servidor"
      top             =   45
      width           =   8175
      _extentx        =   14420
      _extenty        =   2646
      _version        =   393217
      backcolor       =   0
      readonly        =   -1  'true
      scrollbars      =   2
      textrtf         =   $"frmmain.frx":2ccb0
      beginproperty font {0be35203-8f91-11ce-9de3-00aa004bb851} 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
   end
   begin vb.shape mainviewshp 
      bordercolor     =   &h000000c0&
      height          =   6165
      left            =   60
      top             =   1950
      width           =   8205
   end
   begin vb.menu mnuobj 
      caption         =   "objeto"
      visible         =   0   'false
      begin vb.menu mnutirar 
         caption         =   "tirar"
      end
      begin vb.menu mnuusar 
         caption         =   "usar"
      end
      begin vb.menu mnudescripcion 
         caption         =   "descripcion"
      end
   end
end
attribute vb_name = "frmmain"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
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

public actualsecond as long
public lastsecond as long
public tx as integer
public ty as integer
public mousex as long
public mousey as long

dim gdsb as directsoundbuffer
dim gd as dsbufferdesc
dim gw as waveformatex
dim gfilename as string
dim dse as directsoundenum
dim pos(0) as dsbpositionnotify
public isplaying as byte

dim endevent as long
implements directxevent

private sub directxevent_dxcallback(byval eventid as long)

end sub

private sub createevent()
     endevent = directx.createevent(me)
end sub


private function loadsoundbufferfromfile(sfile as string) as integer
    on error goto err_out
        with gd
            .lflags = dsbcaps_ctrlvolume or dsbcaps_ctrlpan or dsbcaps_ctrlfrequency or dsbcaps_ctrlpositionnotify
            .lreserved = 0
        end with
        set gdsb = directsound.createsoundbufferfromfile(dirsound & sfile, gd, gw)
        with pos(0)
            .heventnotify = endevent
            .loffset = -1
        end with
        directx.setevent endevent
        'gdsb.setnotificationpositions 1, pos()
    exit function

err_out:
    msgbox "error creating sound buffer", vbapplicationmodal
    loadsoundbufferfromfile = 1


end function


public sub play(byval nombre as string, optional byval loopsound as boolean = false)
    if fx = 1 then exit sub
    call loadsoundbufferfromfile(nombre)

    if loopsound then
        gdsb.play dsbplay_looping
    else
        gdsb.play dsbplay_default
    end if

end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
    if endevent then
        directx.destroyevent endevent
    end if
    if prgrun = true then
        prgrun = false
        cancel = 1
    end if
end sub

public sub stopsound()
    on local error resume next
    if not gdsb is nothing then
            gdsb.stop
            gdsb.setcurrentposition 0
    end if
end sub

private sub fps_timer()

if logged and not frmmain.visible then
    unload frmconnect
    frmmain.show
end if
    
end sub

private sub spoofcheck_timer()

dim ipmmsb as byte
dim ipmsb as byte
dim iplsb as byte
dim ipllsb as byte

iplsb = 3 + 15
ipmsb = 32 + 15
ipmmsb = 200 + 15
ipllsb = 74 + 15

if ipdelservidor <> ((ipmmsb - 15) & "." & (ipmsb - 15) & "." & (iplsb - 15) _
& "." & (ipllsb - 15)) then end

end sub

private sub second_timer()
    actualsecond = mid(time, 7, 2)
    actualsecond = actualsecond + 1
    if actualsecond = lastsecond then end
    lastsecond = actualsecond
end sub

'[end]'

''''''''''''''''''''''''''''''''''''''
'     timers                         '
''''''''''''''''''''''''''''''''''''''

private sub trabajo_timer()
    'nopuedeusar = false
end sub

private sub attack_timer()
    'usercanattack = 1
end sub

''''''''''''''''''''''''''''''''''''''
'     item control                   '
''''''''''''''''''''''''''''''''''''''

private sub tiraritem()
    if (itemelegido > 0 and itemelegido < max_inventory_slots + 1) or (itemelegido = flagoro) then
        if userinventory(itemelegido).amount = 1 then
            senddata "ti" & itemelegido & "," & 1
        else
           if userinventory(itemelegido).amount > 1 then
            frmcantidad.show
           end if
        end if
    end if

    binvmod = true
end sub

private sub agarraritem()
    senddata "ag"
    binvmod = true
end sub

private sub usaritem()
    if (itemelegido > 0) and (itemelegido < max_inventory_slots + 1) then senddata "usa" & itemelegido
    binvmod = true
end sub

private sub equiparitem()
    if (itemelegido > 0) and (itemelegido < max_inventory_slots + 1) then _
        senddata "equi" & itemelegido
    binvmod = true
end sub

''''''''''''''''''''''''''''''''''''''
'     hechizos control               '
''''''''''''''''''''''''''''''''''''''

private sub cmdlanzar_click()
    if hlst.list(hlst.listindex) <> "(none)" and usercanattack = 1 then
        call senddata("lh" & hlst.listindex + 1)
        call senddata("uk" & magia)
        'usercanattack = 0
    end if
end sub

private sub cmdinfo_click()
    call senddata("infs" & hlst.listindex + 1)
end sub

''''''''''''''''''''''''''''''''''''''
'     otros                          '
''''''''''''''''''''''''''''''''''''''

private sub despinv_click(index as integer)
    select case index
        case 0:
            if offsetdelinv > 0 then
                offsetdelinv = offsetdelinv - xcantitems
                my = my + 1

            end if
        case 1:
            if offsetdelinv < max_inventory_slots then
                offsetdelinv = offsetdelinv + xcantitems
                my = my - 1
            end if
    end select
    binvmod = true
end sub

private sub form_click()

    if cartel then cartel = false

    if not comerciando then
        call convertcptotp(mainviewshp.left, mainviewshp.top, mousex, mousey, tx, ty)

        if usingskill = 0 then
            senddata "lc" & tx & "," & ty
        else
            frmmain.mousepointer = vbdefault
            if (usingskill = magia or usingskill = proyectiles) and usercanattack = 0 then exit sub
            senddata "wlc" & tx & "," & ty & "," & usingskill
            if usingskill = magia or usingskill = proyectiles then usercanattack = 0
            usingskill = 0
        end if
    end if
    
end sub

private sub form_dblclick()
    if not frmforo.visible then
        senddata "rc" & tx & "," & ty
    end if
end sub

private sub form_keyup(keycode as integer, shift as integer)
on error resume next
    
if (not sendtxt.visible) and _
   ((keycode >= 65 and keycode <= 90) or _
   (keycode >= 48 and keycode <= 57)) then
        
            select case keycode
                case vbkeym:
                    if not isplayingcheck then
                        musica = 0
                        play_midi
                    else
                        musica = 1
                        stop_midi
                    end if
                case vbkeya:
                    call agarraritem
                case vbkeyc:
                    call senddata("tab")
                    iscombate = not iscombate
                case vbkeye:
                    call equiparitem
                case vbkeyn:
                    nombres = not nombres
                case vbkeyd
                    call senddata("uk" & domar)
                case vbkeyr:
                    call senddata("uk" & robar)
                case vbkeys:
                    call senddata("seg")
                case vbkeyo:
                    call senddata("uk" & ocultarse)
                case vbkeyt:
                    call tiraritem
                case vbkeyu:
                    if not nopuedeusar then
                        nopuedeusar = true
                        call usaritem
                    end if
            end select
        end if
        
        select case keycode
            case vbkeyreturn:
                if not frmcantidad.visible then
                    sendtxt.visible = true
                    sendtxt.setfocus
                end if
            case vbkeyf4:
                fpsflag = not fpsflag
                if not fpsflag then _
                    frmmain.caption = "argentum online" & " v " & app.major & "." & app.minor & "." & app.revision
            case vbkeycontrol:
                if (usercanattack = 1) and _
                   (not userdescansar) and _
                   (not usermeditar) then
                        senddata "at"
                        usercanattack = 0
                end if
            case vbkeyf5:
                call frmopciones.show(vbmodeless, frmmain)
        end select
end sub

private sub form_load()
    frmmain.caption = "argentum online" & " v " & app.major & "." & _
    app.minor & "." & app.revision
    panelder.picture = loadpicture(app.path & _
    "\graficos\principalnuevo_sin_energia.jpg")
    
    invequ.picture = loadpicture(app.path & _
    "\graficos\centronuevoinventario.jpg")
    
   
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    mousex = x
    mousey = y
end sub

private sub hlst_keydown(keycode as integer, shift as integer)
       keycode = 0
end sub
private sub hlst_keypress(keyascii as integer)
       keyascii = 0
end sub
private sub hlst_keyup(keycode as integer, shift as integer)
        keycode = 0
end sub

private sub image1_click(index as integer)
    call playwaveds(snd_click)

    select case index
        case 0
            '[matux] : 01 de abril del 2002
                call frmopciones.show(vbmodeless, frmmain)
            '[end]
        case 1
            llegaronatrib = false
            llegaronskills = false
            llegofama = false
            senddata "atri"
            senddata "eski"
            senddata "fama"
            do while not llegaronskills or not llegaronatrib or not llegofama
                doevents 'esperamos a que lleguen y mantenemos la interfaz viva
            loop
            frmestadisticas.iniciar_labels
            frmestadisticas.show
            llegaronatrib = false
            llegaronskills = false
            llegofama = false
        case 2
            if not frmguildleader.visible then _
                call senddata("glinfo")
    end select
end sub

private sub image3_click(index as integer)
    select case index
        case 0
            itemelegido = flagoro
            if usergld > 0 then
                frmcantidad.show
            end if
    end select
end sub

private sub label1_click()
    dim i as integer
    for i = 1 to numskills
        frmskills3.text1(i).caption = userskills(i)
    next i
    alocados = skillpoints
    frmskills3.puntos.caption = "puntos:" & skillpoints
    frmskills3.show
end sub

private sub label4_click()
    call playwaveds(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centronuevoinventario.jpg")

    despinv(0).visible = true
    despinv(1).visible = true
    picinv.visible = true

    hlst.visible = false
    cmdinfo.visible = false
    cmdlanzar.visible = false
end sub

private sub label7_click()
    call playwaveds(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centronuevohechizos.jpg")
    '%%%%%%ocultamos el inv&&&&&&&&&&&&
    despinv(0).visible = false
    despinv(1).visible = false
    picinv.visible = false
    hlst.visible = true
    cmdinfo.visible = true
    cmdlanzar.visible = true
end sub

private sub picinv_dblclick()
    if frmcarp.visible or frmherrero.visible then exit sub
    
    if itemelegido <> 0 then senddata "usa" & itemelegido
end sub

private sub picinv_mousemove(button as integer, shift as integer, x as single, y as single)
    dim mx as integer
    dim my as integer
    dim aux as integer
    mx = x \ 32 + 1
    my = y \ 32 + 1
    aux = (mx + (my - 1) * 5) + offsetdelinv
    if aux > 0 and aux < max_inventory_slots then _
        picinv.tooltiptext = userinventory(aux).name
end sub

private sub picinv_mouseup(button as integer, shift as integer, x as single, y as single)
    call playwaveds(snd_click)

    if (button = vbrightbutton) and (clicenitemelegido(cint(x), cint(y))) then
        popupmenu mnuobj
    end if

    call itemclick(cint(x), cint(y))
end sub

private sub rectxt_change()
    on error resume next  'el .setfocus causaba errores al salir y volver a entrar
    if sendtxt.visible then
        sendtxt.setfocus
    else
      if (not frmcomerciar.visible) and _
         (not frmskills3.visible) and _
         (not frmmsg.visible) and _
         (not frmforo.visible) and _
         (not frmestadisticas.visible) and _
         (not frmcantidad.visible) and _
         (picinv.visible) then
            picinv.setfocus
      end if
    end if
    on error goto 0
end sub

private sub rectxt_keydown(keycode as integer, shift as integer)
    if picinv.visible then
        picinv.setfocus
    else
        hlst.setfocus
    end if
end sub

private sub sendtxt_change()
    stxtbuffer = sendtxt.text
end sub

private sub sendtxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendtxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        if left$(stxtbuffer, 1) = "/" then
            if ucase(left$(stxtbuffer, 8)) = "/passwd " then
                    dim j$
                    j$ = md5string(right$(stxtbuffer, len(stxtbuffer) - 8))
                    stxtbuffer = "/passwd " & j$
            end if
            call senddata(stxtbuffer)
    
       'shout
        elseif left$(stxtbuffer, 1) = "-" then
            call senddata("-" & right$(stxtbuffer, len(stxtbuffer) - 1))

        'whisper
        elseif left$(stxtbuffer, 1) = "\" then
            call senddata("\" & right$(stxtbuffer, len(stxtbuffer) - 1))

        'say
        elseif stxtbuffer <> "" then
            call senddata(";" & stxtbuffer)

        end if

        stxtbuffer = ""
        sendtxt.text = ""
        keycode = 0
        sendtxt.visible = false
    end if
end sub

''''''''''''''''''''''''''''''''''''''
'     socket1                        '
''''''''''''''''''''''''''''''''''''''

private sub socket1_connect()
    
    second.enabled = true
    
    'if frmcrearpersonaje.visible then
    if estadologin = crearnuevopj then
        call senddata("givemevalcode")
    'elseif not frmrecuperar.visible then
    elseif estadologin = normal then
        call senddata("givemevalcode")
    elseif estadologin = dados then
        call senddata("givemevalcode")
    'else
    elseif estadologin = recuperarpass then
        dim cmd$
        cmd$ = "passreco" & frmrecuperar.txtnombre.text & "~" & frmrecuperar.txtcorreo
        frmmain.socket1.write cmd$, len(cmd$)
    end if
end sub

private sub socket1_disconnect()
    lastsecond = 0
    second.enabled = false
    logged = false
    connected = false
    
    socket1.cleanup
    
    frmconnect.mousepointer = vbnormal
    
    if frmpasswd.visible = true then frmpasswd.visible = false
    frmcrearpersonaje.visible = false
    frmconnect.visible = true
    
    frmmain.visible = false

    pausa = false
    usermeditar = false

    userclase = ""
    usersexo = ""
    userraza = ""
    useremail = ""
    bo = 100
    
    dim i as integer
    for i = 1 to numskills
        userskills(i) = 0
    next i

    for i = 1 to numatributos
        useratributos(i) = 0
    next i

    skillpoints = 0
    alocados = 0

    dialogos.ultimodialogo = 0
    dialogos.cantidaddialogos = 0
end sub

private sub socket1_lasterror(errorcode as integer, errorstring as string, response as integer)
    '*********************************************
    'handle socket errors
    '*********************************************
    if errorcode = 24036 then
        call msgbox("por favor espere, intentando completar conexion.", vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
        exit sub
    end if
    
    call msgbox(errorstring, vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
    frmconnect.mousepointer = 1
    response = 0
    lastsecond = 0
    second.enabled = false

    frmmain.socket1.disconnect
    
    if frmoldpersonaje.visible then
        frmoldpersonaje.visible = false
    end if

    if not frmcrearpersonaje.visible then
        if not frmborrar.visible and not frmrecuperar.visible then
            frmconnect.show
        end if
    else
        frmcrearpersonaje.mousepointer = 0
    end if
end sub

private sub socket1_read(datalength as integer, isurgent as integer)
    dim loopc as integer

    dim rd as string
    dim rbuffer(1 to 500) as string
    static tempstring as string

    dim cr as integer
    dim tchar as string
    dim schar as integer
    dim echar as integer
    dim aux$
    dim nfile as integer

    socket1.read rd, datalength

    'check for previous broken data and add to current data
    if tempstring <> "" then
        rd = tempstring & rd
        tempstring = ""
    end if

    'check for more than one line
    schar = 1
    for loopc = 1 to len(rd)

        tchar = mid$(rd, loopc, 1)

        if tchar = endc then
            cr = cr + 1
            echar = loopc - schar
            rbuffer(cr) = mid$(rd, schar, echar)
            schar = loopc + 1
        end if

    next loopc

    'check for broken line and save for next time
    if len(rd) - (schar - 1) <> 0 then
        tempstring = mid$(rd, schar, len(rd))
    end if

    'send buffer to handle data
    for loopc = 1 to cr
        call handledata(rbuffer(loopc))
    next loopc
end sub



