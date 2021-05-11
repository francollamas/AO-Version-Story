version 5.00
object = "{3b7c8863-d78f-101b-b9b5-04021c009402}#1.2#0"; "richtx32.ocx"
object = "{33101c00-75c3-11cf-a8a0-444553540000}#1.0#0"; "cswsk32.ocx"
object = "{48e59290-9880-11cf-9754-00aa00c00908}#1.0#0"; "msinet.ocx"
object = "{248dd890-bb45-11cf-9abc-0080c7e7b78d}#1.0#0"; "mswinsck.ocx"
begin vb.form frmmain 
   backcolor       =   &h00000000&
   borderstyle     =   1  'fixed single
   caption         =   "argentum online"
   clientheight    =   8625
   clientleft      =   390
   clienttop       =   690
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
   visible         =   0   'false
   begin socketwrenchctrl.socket socket1 
      left            =   6750
      top             =   1920
      _version        =   65536
      _extentx        =   741
      _extenty        =   741
      _stockprops     =   0
      autoresolve     =   0   'false
      backlog         =   1
      binary          =   -1  'true
      blocking        =   0   'false
      broadcast       =   0   'false
      buffersize      =   10240
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
      timeout         =   10000
      type            =   1
      urgent          =   0   'false
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
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   19
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   1575
      visible         =   0   'false
      width           =   8160
   end
   begin vb.timer macrotrabajo 
      enabled         =   0   'false
      left            =   7080
      top             =   2520
   end
   begin vb.picturebox picture1 
      height          =   135
      left            =   11760
      scaleheight     =   75
      scalewidth      =   75
      tabindex        =   18
      top             =   8520
      visible         =   0   'false
      width           =   135
   end
   begin vb.timer trainingmacro 
      enabled         =   0   'false
      interval        =   3121
      left            =   6600
      top             =   2520
   end
   begin vb.textbox sendcmstxt 
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
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   15
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   8280
      visible         =   0   'false
      width           =   8160
   end
   begin vb.timer macro 
      interval        =   750
      left            =   5760
      top             =   2520
   end
   begin mswinsocklib.winsock winsock1 
      left            =   6240
      top             =   1920
      _extentx        =   741
      _extenty        =   741
      _version        =   393216
   end
   begin vb.timer second 
      enabled         =   0   'false
      interval        =   1050
      left            =   3600
      top             =   2520
   end
   begin vb.timer spoofcheck 
      enabled         =   0   'false
      interval        =   60000
      left            =   3120
      top             =   2520
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
      scaleheight     =   543
      scalemode       =   3  'pixel
      scalewidth      =   239
      tabindex        =   1
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
         mouseicon       =   "frmmain.frx":030a
         mousepointer    =   99  'custom
         tabindex        =   9
         top             =   4800
         visible         =   0   'false
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
         mouseicon       =   "frmmain.frx":045c
         mousepointer    =   99  'custom
         tabindex        =   8
         top             =   2160
         visible         =   0   'false
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
         scalewidth      =   160
         tabindex        =   7
         top             =   2400
         width           =   2400
      end
      begin vb.listbox hlst 
         backcolor       =   &h00000000&
         forecolor       =   &h00ffffff&
         height          =   2790
         left            =   420
         tabindex        =   14
         tabstop         =   0   'false
         top             =   2040
         visible         =   0   'false
         width           =   2565
      end
      begin vb.label lblporclvl 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "33.33%"
         forecolor       =   &h00ffff00&
         height          =   195
         left            =   1560
         tabindex        =   17
         top             =   450
         width           =   660
      end
      begin vb.image cmdmoverhechi 
         height          =   375
         index           =   1
         left            =   2940
         mouseicon       =   "frmmain.frx":05ae
         mousepointer    =   99  'custom
         top             =   2100
         visible         =   0   'false
         width           =   315
      end
      begin vb.image cmdmoverhechi 
         height          =   375
         index           =   0
         left            =   2940
         mouseicon       =   "frmmain.frx":0700
         mousepointer    =   99  'custom
         top             =   2520
         visible         =   0   'false
         width           =   315
      end
      begin vb.image cmdinfo 
         height          =   405
         left            =   2310
         mouseicon       =   "frmmain.frx":0852
         mousepointer    =   99  'custom
         top             =   4830
         visible         =   0   'false
         width           =   855
      end
      begin vb.image cmdlanzar 
         height          =   405
         left            =   450
         mouseicon       =   "frmmain.frx":09a4
         mousepointer    =   99  'custom
         top             =   4830
         visible         =   0   'false
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
         tabindex        =   13
         top             =   435
         visible         =   0   'false
         width           =   120
      end
      begin vb.label exp 
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "exp:"
         forecolor       =   &h00ffffff&
         height          =   195
         left            =   285
         tabindex        =   12
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
         tabindex        =   11
         top             =   5970
         width           =   105
      end
      begin vb.image image1 
         height          =   300
         index           =   2
         left            =   1905
         mouseicon       =   "frmmain.frx":0af6
         mousepointer    =   99  'custom
         top             =   7575
         width           =   1410
      end
      begin vb.image image1 
         height          =   300
         index           =   1
         left            =   1905
         mouseicon       =   "frmmain.frx":0c48
         mousepointer    =   99  'custom
         top             =   7200
         width           =   1410
      end
      begin vb.image image1 
         height          =   300
         index           =   0
         left            =   1920
         mouseicon       =   "frmmain.frx":0d9a
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
         left            =   420
         tabindex        =   10
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
         mouseicon       =   "frmmain.frx":0eec
         mousepointer    =   99  'custom
         tabindex        =   6
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
         mouseicon       =   "frmmain.frx":103e
         mousepointer    =   99  'custom
         tabindex        =   5
         top             =   1305
         width           =   1605
      end
      begin vb.image invequ 
         height          =   4395
         left            =   120
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
         tabindex        =   4
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
         tabindex        =   3
         top             =   450
         width           =   105
      end
      begin vb.label label6 
         backstyle       =   0  'transparent
         caption         =   "nivel"
         forecolor       =   &h00ffffff&
         height          =   225
         left            =   285
         tabindex        =   2
         top             =   450
         width           =   465
      end
   end
   begin richtextlib.richtextbox rectxt 
      height          =   1500
      left            =   45
      tabindex        =   0
      tabstop         =   0   'false
      tooltiptext     =   "mensajes del servidor"
      top             =   45
      width           =   8175
      _extentx        =   14420
      _extenty        =   2646
      _version        =   393217
      backcolor       =   0
      enabled         =   -1  'true
      readonly        =   -1  'true
      scrollbars      =   2
      disablenoscroll =   -1  'true
      textrtf         =   $"frmmain.frx":1190
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
   begin vb.image picau 
      borderstyle     =   1  'fixed single
      height          =   510
      left            =   9300
      picture         =   "frmmain.frx":120e
      stretch         =   -1  'true
      top             =   8100
      visible         =   0   'false
      width           =   510
   end
   begin vb.image picmh 
      borderstyle     =   1  'fixed single
      height          =   510
      left            =   8790
      picture         =   "frmmain.frx":2480
      stretch         =   -1  'true
      top             =   8100
      visible         =   0   'false
      width           =   510
   end
   begin vb.label coord 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      backstyle       =   0  'transparent
      borderstyle     =   1  'fixed single
      caption         =   "(000,00,00)"
      forecolor       =   &h0000ffff&
      height          =   255
      left            =   10680
      tabindex        =   16
      top             =   8250
      width           =   1035
   end
   begin vb.image picseg 
      borderstyle     =   1  'fixed single
      height          =   510
      left            =   8280
      picture         =   "frmmain.frx":3292
      stretch         =   -1  'true
      top             =   8100
      width           =   510
   end
   begin vb.shape mainviewshp 
      bordercolor     =   &h00404040&
      height          =   6240
      left            =   45
      top             =   1965
      width           =   8190
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
      begin vb.menu mnuequipar 
         caption         =   "equipar"
      end
   end
   begin vb.menu mnunpc 
      caption         =   "npc"
      visible         =   0   'false
      begin vb.menu mnunpcdesc 
         caption         =   "descripcion"
      end
      begin vb.menu mnunpccomerciar 
         caption         =   "comerciar"
         visible         =   0   'false
      end
   end
end
attribute vb_name = "frmmain"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

public tx as integer
public ty as integer
public mousex as long
public mousey as long
public mouseboton as long
public mouseshift as long

dim gdsb as directsoundbuffer
dim gd as dsbufferdesc
dim gw as waveformatex
dim gfilename as string
dim dse as directsoundenum
dim pos(0) as dsbpositionnotify
public isplaying as byte

dim puedemacrear as boolean

private sub cmdmoverhechi_click(index as integer)
    if hlst.listindex = -1 then exit sub
    dim stemp as string

    select case index
        case 1 'subir
            if hlst.listindex = 0 then exit sub
        case 0 'bajar
            if hlst.listindex = hlst.listcount - 1 then exit sub
    end select

    call writemovespell(index, hlst.listindex + 1)
    
    select case index
        case 1 'subir
            stemp = hlst.list(hlst.listindex - 1)
            hlst.list(hlst.listindex - 1) = hlst.list(hlst.listindex)
            hlst.list(hlst.listindex) = stemp
            hlst.listindex = hlst.listindex - 1
        case 0 'bajar
            stemp = hlst.list(hlst.listindex + 1)
            hlst.list(hlst.listindex + 1) = hlst.list(hlst.listindex)
            hlst.list(hlst.listindex) = stemp
            hlst.listindex = hlst.listindex + 1
    end select
end sub

public sub activarmacrohechizos()
    if not hlst.visible then
        call addtorichtextbox(frmmain.rectxt, "debes tener seleccionado el hechizo para activar el auto-lanzar", 0, 200, 200, false, true, false)
        exit sub
    end if
    trainingmacro.interval = int_macro_hechis
    trainingmacro.enabled = true
    call addtorichtextbox(frmmain.rectxt, "auto lanzar hechizos activado", 0, 200, 200, false, true, false)
    picmh.visible = true
end sub

public sub desactivarmacrohechizos()
        picmh.visible = false
        trainingmacro.enabled = false
        call addtorichtextbox(frmmain.rectxt, "auto lanzar hechizos desactivado", 0, 150, 150, false, true, false)
end sub
public sub dibujarmh()
picmh.visible = true
end sub

public sub desdibujarmh()
picmh.visible = false
end sub

public sub dibujarseguro()
picseg.visible = true
end sub

public sub desdibujarseguro()
picseg.visible = false
end sub

public sub dibujarsatelite()
picau.visible = true
end sub

public sub desdibujarsatelite()
picau.visible = false
end sub

private sub form_keyup(keycode as integer, shift as integer)
#if seguridadalkon then
    if logging then call cheatingdeath.storekey(keycode, false)
#end if
    
    if (not sendtxt.visible) and (not sendcmstxt.visible) and _
       ((keycode >= 65 and keycode <= 90) or _
       (keycode >= 48 and keycode <= 57)) then
        
        select case keycode
            case vbkeym
                audio.musicactivated = not audio.musicactivated
            
            case vbkeya
                call agarraritem
            
            case vbkeyc
                call writecombatmodetoggle
                iscombate = not iscombate
            
            case vbkeye
                call equiparitem
            
            case vbkeyn
                nombres = not nombres
            
            case vbkeyd
                call writework(eskill.domar)
            
            case vbkeyr
                call writework(eskill.robar)
            
            case vbkeys
                addtorichtextbox frmmain.rectxt, "para activar o desactivar el seguro utiliza la tecla '*' (asterisco)", 255, 255, 255, false, false, false
            
            case vbkeyo
                call writework(eskill.ocultarse)
            
            case vbkeyt
                call tiraritem
            
            case vbkeyu
                if macrotrabajo.enabled then desactivarmacrotrabajo
                    
                if maintimer.check(timersindex.useitemwithu) then
                    call usaritem
                end if
            
            case vbkeyl
                if maintimer.check(timersindex.sendrpu) then
                    call writerequestpositionupdate
                    beep
                end if
            
            'custom messages!
            case vbkey0, vbkey1, vbkey2, vbkey3, vbkey4, vbkey5, vbkey6, vbkey7, vbkey8, vbkey9
                if lenb(custommessages.message((keycode - 39) mod 10)) <> 0 then
                    call writetalk(custommessages.message((keycode - 39) mod 10))
                end if
        end select
    end if
    
    select case keycode
        case vbkeydelete
            if sendtxt.visible then exit sub
            if not frmcantidad.visible then
                sendcmstxt.visible = true
                sendcmstxt.setfocus
            end if
        
        case vbkeyf2
            call screencapture
        
        case vbkeyf4
            fpsflag = not fpsflag
            if not fpsflag then _
                frmmain.caption = "argentum online" & " v " & app.major & "." & app.minor & "." & app.revision
        
        case vbkeyf5
            call frmopciones.show(vbmodeless, frmmain)
        
        case vbkeyf6
            if userminman = usermaxman then exit sub
            
            if not puedemacrear then
                addtorichtextbox frmmain.rectxt, "no tan r�pido..!", 255, 255, 255, false, false, false
            else
                call writemeditate
                puedemacrear = false
            end if
        
        case vbkeyf7
            if trainingmacro.enabled then
                desactivarmacrohechizos
            else
                activarmacrohechizos
            end if
        
        case vbkeyf8
            if macrotrabajo.enabled then
                desactivarmacrotrabajo
            else
                activarmacrotrabajo
            end if
        
        case vbkeymultiply
            if frmmain.picseg.visible then
                addtorichtextbox frmmain.rectxt, "escribe /seg para quitar el seguro", 255, 255, 255, false, false, false
            else
                call writesafetoggle
            end if
        
        case vbkeycontrol
            if shift <> 0 then exit sub
            
            if not maintimer.check(timersindex.arrows, false) then exit sub 'check if arrows interval has finished.
            if not maintimer.check(timersindex.castspell, false) then  'check if spells interval has finished.
                if not maintimer.check(timersindex.castattack) then exit sub 'corto intervalo golpe-hechizo
            else
                if not maintimer.check(timersindex.attack) or userdescansar or usermeditar then exit sub
            end if
            
            if trainingmacro.enabled then desactivarmacrohechizos
            if macrotrabajo.enabled then desactivarmacrotrabajo
            call writeattack
        
        case vbkeyreturn
            if sendcmstxt.visible then exit sub
            if not frmcantidad.visible then
                sendtxt.visible = true
                sendtxt.setfocus
            end if
    end select
end sub

private sub form_mousedown(button as integer, shift as integer, x as single, y as single)
    mouseboton = button
    mouseshift = shift
end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
    if prgrun = true then
        prgrun = false
        cancel = 1
    end if
end sub

private sub macro_timer()
    puedemacrear = true
end sub

private sub macrotrabajo_timer()
    if inventario.selecteditem = 0 then
        desactivarmacrotrabajo
        exit sub
    end if
    
    'macros are disabled if not using argentum!
    if not api.isappactive() then
        desactivarmacrotrabajo
        exit sub
    end if
    
    if (usingskill = eskill.pesca or usingskill = eskill.talar or usingskill = eskill.mineria or usingskill = fundirmetal or usingskill = eskill.herreria) then
        call writeworkleftclick(tx, ty, usingskill)
        usingskill = 0
    end if
    
    'if inventario.objtype(inventario.selecteditem) = eobjtype.otweapon then
     call usaritem
end sub

public sub activarmacrotrabajo()
    macrotrabajo.interval = int_macro_trabajo
    macrotrabajo.enabled = true
    call addtorichtextbox(frmmain.rectxt, "macro trabajo activado", 0, 200, 200, false, true, false)
end sub

public sub desactivarmacrotrabajo()
    macrotrabajo.enabled = false
    macrobltindex = 0
    call addtorichtextbox(frmmain.rectxt, "macro trabajo desactivado", 0, 200, 200, false, true, false)
end sub


private sub mnuequipar_click()
    call equiparitem
end sub

private sub mnunpccomerciar_click()
    call writeleftclick(tx, ty)
    call writecommercestart
end sub

private sub mnunpcdesc_click()
    call writeleftclick(tx, ty)
end sub

private sub mnutirar_click()
    call tiraritem
end sub

private sub mnuusar_click()
    call usaritem
end sub

private sub picau_click()
    addtorichtextbox frmmain.rectxt, "hay actualizaciones pendientes. cierra el juego y ejecuta el autoupdate. (el mismo debe descargarse del sitio oficial http://ao.alkon.com.ar, y deber�s conectarte al puerto 7667 con la ip tradicional del juego)", 255, 255, 255, false, false, false
end sub

private sub picmh_click()
    addtorichtextbox frmmain.rectxt, "auto lanzar hechizos. utiliza esta habilidad para entrenar �nicamente. para activarlo/desactivarlo utiliza f7.", 255, 255, 255, false, false, false
end sub

private sub picseg_click()
    addtorichtextbox frmmain.rectxt, "el dibujo de la llave indica que tienes activado el seguro, esto evitar� que por accidente ataques a un ciudadano y te conviertas en criminal. para activarlo o desactivarlo utiliza la tecla '*' (asterisco)", 255, 255, 255, false, false, false
end sub

private sub coord_click()
    addtorichtextbox frmmain.rectxt, "estas coordenadas son tu ubicaci�n en el mapa. utiliza la letra l para corregirla si esta no se corresponde con la del servidor por efecto del lag.", 255, 255, 255, false, false, false
end sub

private sub sendtxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        if lenb(stxtbuffer) <> 0 then call parseusercommand(stxtbuffer)
        
        stxtbuffer = ""
        sendtxt.text = ""
        keycode = 0
        sendtxt.visible = false
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
    if not dialogosclanes is nothing then dialogosclanes.passtimer
end sub

'[end]'

''''''''''''''''''''''''''''''''''''''
'     item control                   '
''''''''''''''''''''''''''''''''''''''

private sub tiraritem()
    if (inventario.selecteditem > 0 and inventario.selecteditem < max_inventory_slots + 1) or (inventario.selecteditem = flagoro) then
        if inventario.amount(inventario.selecteditem) = 1 then
            call writedrop(inventario.selecteditem, 1)
        else
           if inventario.amount(inventario.selecteditem) > 1 then
                frmcantidad.show , frmmain
           end if
        end if
    end if
end sub

private sub agarraritem()
    call writepickup
end sub

private sub usaritem()
    if trainingmacro.enabled then desactivarmacrohechizos
    
    if (inventario.selecteditem > 0) and (inventario.selecteditem < max_inventory_slots + 1) then _
        call writeuseitem(inventario.selecteditem)
end sub

private sub equiparitem()
    if (inventario.selecteditem > 0) and (inventario.selecteditem < max_inventory_slots + 1) then _
        call writeequipitem(inventario.selecteditem)
end sub

''''''''''''''''''''''''''''''''''''''
'     hechizos control               '
''''''''''''''''''''''''''''''''''''''

private sub trainingmacro_timer()
    if not hlst.visible then
        desactivarmacrohechizos
        exit sub
    end if
    
    'macros are disabled if focus is not on argentum!
    if not api.isappactive() then
        desactivarmacrohechizos
        exit sub
    end if
    
    if comerciando then exit sub
    
    if hlst.list(hlst.listindex) <> "(none)" and maintimer.check(timersindex.castspell, false) then
        call writecastspell(hlst.listindex + 1)
        call writework(eskill.magia)
    end if
    
    call convertcptotp(mainviewshp.left, mainviewshp.top, mousex, mousey, tx, ty)
    
    if usingskill = magia and not maintimer.check(timersindex.castspell) then exit sub
    
    if usingskill = proyectiles and not maintimer.check(timersindex.attack) then exit sub
    
    call writeworkleftclick(tx, ty, usingskill)
    usingskill = 0
end sub

private sub cmdlanzar_click()
    if hlst.list(hlst.listindex) <> "(none)" and maintimer.check(timersindex.work, false) then
        if userestado = 1 then
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
        else
            call writecastspell(hlst.listindex + 1)
            call writework(eskill.magia)
            usamacro = true
        end if
    end if
end sub

private sub cmdlanzar_mousemove(button as integer, shift as integer, x as single, y as single)
    usamacro = false
    cntd = 0
end sub

private sub cmdinfo_click()
    if hlst.listindex <> -1 then
        call writespellinfo(hlst.listindex + 1)
    end if
end sub

private sub despinv_click(index as integer)
    inventario.scrollinventory (index = 0)
end sub

private sub form_click()
    if cartel then cartel = false

#if seguridadalkon then
    if logging then call cheatingdeath.storekey(mouseboton, true)
#end if

    if not comerciando then
        call convertcptotp(mainviewshp.left, mainviewshp.top, mousex, mousey, tx, ty)

        if mouseshift = 0 then
            if mouseboton <> vbrightbutton then
                '[ybarra]
                if usamacro then
                    cntd = cntd + 1
                    if cntd = 3 then
                        call writeusespellmacro
                        cntd = 0
                    end if
                    usamacro = false
                end if
                '[/ybarra]
                if usingskill = 0 then
                    call writeleftclick(tx, ty)
                else
                    if trainingmacro.enabled then desactivarmacrohechizos
                    if macrotrabajo.enabled then desactivarmacrotrabajo
                    
                    if not maintimer.check(timersindex.arrows, false) then exit sub 'check if arrows interval has finished.
                    'if not maintimer.check(timersindex.attack, false) then exit sub 'check if attack interval has finished.
                    'if not maintimer.check(timersindex.castspell, false) then exit sub 'check if spells interval has finished.
                    
                    'splitted because vb isn't lazy!
                    if usingskill = proyectiles then
                        if not maintimer.check(timersindex.arrows) then
                            exit sub
                        end if
                    end if
                    
                    'splitted because vb isn't lazy!
                    if usingskill = magia then
                        if not maintimer.check(timersindex.attack, false) then 'check if attack interval has finished.
                            if not maintimer.check(timersindex.castattack) then exit sub 'corto intervalo de golpe-magia
                        else
                            if not maintimer.check(timersindex.castspell) then exit sub 'check if spells interval has finished.
                        end if
                    end if
                    
                    'splitted because vb isn't lazy!
                    if (usingskill = pesca or usingskill = robar or usingskill = talar or usingskill = mineria or usingskill = fundirmetal) then
                        if not maintimer.check(timersindex.work) then
                            exit sub
                        end if
                    end if
                    
                    frmmain.mousepointer = vbdefault
                    call writeworkleftclick(tx, ty, usingskill)
                    usingskill = 0
                end if
            else
                call abrirmenuviewport
            end if
        elseif (mouseshift and 1) = 1 then
            if mouseboton = vbleftbutton then
                call writewarpchar("yo", usermap, tx, ty)
            end if
        end if
    end if
end sub

private sub form_dblclick()
    if not frmforo.visible then
        call writedoubleclick(tx, ty)
    end if
end sub

private sub form_load()
    
    
    frmmain.caption = "argentum online" & " v " & app.major & "." & _
    app.minor & "." & app.revision
    panelder.picture = loadpicture(app.path & _
    "\graficos\principalnuevo_sin_energia.jpg")
    
    invequ.picture = loadpicture(app.path & _
    "\graficos\centronuevoinventario.jpg")
    
   me.left = 0
   me.top = 0
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
    call audio.playwave(snd_click)

    select case index
        case 0
            call frmopciones.show(vbmodeless, frmmain)
            
        case 1
            llegaronatrib = false
            llegaronskills = false
            llegofama = false
            call writerequestatributes
            call writerequestskills
            call writerequestministats
            call writerequestfame
            call flushbuffer
            
            do while not llegaronskills or not llegaronatrib or not llegofama
                doevents 'esperamos a que lleguen y mantenemos la interfaz viva
            loop
            frmestadisticas.iniciar_labels
            frmestadisticas.show , frmmain
            llegaronatrib = false
            llegaronskills = false
            llegofama = false
        
        case 2
            if frmguildleader.visible then unload frmguildleader
            
            call writerequestguildleaderinfo
    end select
end sub

private sub image3_click(index as integer)
    select case index
        case 0
            inventario.selectgold
            if usergld > 0 then
                frmcantidad.show , frmmain
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
    frmskills3.show , frmmain
end sub

private sub label4_click()
    call audio.playwave(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centronuevoinventario.jpg")

    'despinv(0).visible = true
    'despinv(1).visible = true
    picinv.visible = true

    hlst.visible = false
    cmdinfo.visible = false
    cmdlanzar.visible = false
    
    cmdmoverhechi(0).visible = true
    cmdmoverhechi(1).visible = true
    
    cmdmoverhechi(0).enabled = false
    cmdmoverhechi(1).enabled = false
end sub

private sub label7_click()
    call audio.playwave(snd_click)

    invequ.picture = loadpicture(app.path & "\graficos\centronuevohechizos.jpg")
    '%%%%%%ocultamos el inv&&&&&&&&&&&&
    'despinv(0).visible = false
    'despinv(1).visible = false
    picinv.visible = false
    hlst.visible = true
    cmdinfo.visible = true
    cmdlanzar.visible = true
    
    cmdmoverhechi(0).visible = true
    cmdmoverhechi(1).visible = true
    
    cmdmoverhechi(0).enabled = true
    cmdmoverhechi(1).enabled = true
end sub

private sub picinv_dblclick()
    if frmcarp.visible or frmherrero.visible then exit sub
    
    if not maintimer.check(timersindex.useitemwithdblclick) then exit sub
    
    if macrotrabajo.enabled then _
                     desactivarmacrotrabajo
    
    call usaritem
end sub

private sub picinv_mouseup(button as integer, shift as integer, x as single, y as single)
    call audio.playwave(snd_click)
end sub

private sub rectxt_change()
on error resume next  'el .setfocus causaba errores al salir y volver a entrar
    if not api.isappactive() then exit sub
    
    if sendtxt.visible then
        sendtxt.setfocus
    elseif me.sendcmstxt.visible then
        sendcmstxt.setfocus
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
end sub

private sub rectxt_keydown(keycode as integer, shift as integer)
    if picinv.visible then
        picinv.setfocus
    else
        hlst.setfocus
    end if
end sub

private sub sendtxt_change()
'**************************************************************
'author: unknown
'last modify date: 3/06/2006
'3/06/2006: maraxus - imped� se inserten caract�res no imprimibles
'**************************************************************
    if len(sendtxt.text) > 160 then
        stxtbuffer = "soy un cheater, avisenle a un gm"
    else
        'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
        dim i as long
        dim tempstr as string
        dim charascii as integer
        
        for i = 1 to len(sendtxt.text)
            charascii = asc(mid$(sendtxt.text, i, 1))
            if charascii >= vbkeyspace and charascii <= 250 then
                tempstr = tempstr & chr$(charascii)
            end if
        next i
        
        if tempstr <> sendtxt.text then
            'we only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            sendtxt.text = tempstr
        end if
        
        stxtbuffer = sendtxt.text
    end if
end sub

private sub sendtxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendcmstxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        'say
        if stxtbuffercmsg <> "" then
            call parseusercommand("/cmsg " & stxtbuffercmsg)
        end if

        stxtbuffercmsg = ""
        sendcmstxt.text = ""
        keycode = 0
        me.sendcmstxt.visible = false
    end if
end sub

private sub sendcmstxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendcmstxt_change()
    if len(sendcmstxt.text) > 160 then
        stxtbuffercmsg = "soy un cheater, avisenle a un gm"
    else
        'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
        dim i as long
        dim tempstr as string
        dim charascii as integer
        
        for i = 1 to len(sendcmstxt.text)
            charascii = asc(mid$(sendcmstxt.text, i, 1))
            if charascii >= vbkeyspace and charascii <= 250 then
                tempstr = tempstr & chr$(charascii)
            end if
        next i
        
        if tempstr <> sendcmstxt.text then
            'we only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            sendcmstxt.text = tempstr
        end if
        
        stxtbuffercmsg = sendcmstxt.text
    end if
end sub


''''''''''''''''''''''''''''''''''''''
'     socket1                        '
''''''''''''''''''''''''''''''''''''''
#if usarwrench = 1 then

private sub socket1_connect()
    dim serverip as string
    dim temporal1 as long
    dim temporal as long
    
#if seguridadalkon then
    call connectionstablished
#end if
    
    serverip = socket1.peeraddress
    temporal = instr(1, serverip, ".")
    temporal1 = ((mid$(serverip, 1, temporal - 1) xor &h65) and &h7f) * 16777216
    serverip = mid$(serverip, temporal + 1, len(serverip))
    temporal = instr(1, serverip, ".")
    temporal1 = temporal1 + (mid$(serverip, 1, temporal - 1) xor &hf6) * 65536
    serverip = mid$(serverip, temporal + 1, len(serverip))
    temporal = instr(1, serverip, ".")
    temporal1 = temporal1 + (mid$(serverip, 1, temporal - 1) xor &h4b) * 256
    serverip = mid$(serverip, temporal + 1, len(serverip)) xor &h42
    mixedkey = (temporal1 + serverip)
    
    second.enabled = true

    select case estadologin
        case e_modo.crearnuevopj
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login
        
        case e_modo.normal
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login
        
        case e_modo.dados
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            frmcrearpersonaje.show vbmodal
            
#if seguridadalkon then
            call protectform(frmcrearpersonaje)
#end if
    end select
end sub

private sub socket1_disconnect()
    dim i as long
    
    second.enabled = false
    connected = false
    
    socket1.cleanup
    
    frmconnect.mousepointer = vbnormal
    
    if not frmpasswd.visible and not frmcrearpersonaje.visible then
        frmconnect.visible = true
    end if
    
    on local error resume next
    for i = 0 to forms.count - 1
        if forms(i).name <> me.name and forms(i).name <> frmconnect.name and forms(i).name <> frmoldpersonaje.name and forms(i).name <> frmcrearpersonaje.name and forms(i).name <> frmpasswd.name then
            unload forms(i)
        end if
    next i
    on local error goto 0
    
    frmmain.visible = false
    
    pausa = false
    usermeditar = false
    
#if seguridadalkon then
    logging = false
    logstring = false
    lastpressed = 0
    lastmouse = false
    lastamount = 0
#end if

    userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    
    for i = 1 to numskills
        userskills(i) = 0
    next i

    for i = 1 to numatributos
        useratributos(i) = 0
    next i
    
    macrotrabajo.enabled = false

    skillpoints = 0
    alocados = 0
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
    second.enabled = false

    frmmain.socket1.disconnect
    
    if frmoldpersonaje.visible then
        frmoldpersonaje.visible = false
    end if
    
    if not frmcrearpersonaje.visible then
        frmconnect.show
    else
        frmcrearpersonaje.mousepointer = 0
    end if
end sub

private sub socket1_read(datalength as integer, isurgent as integer)
    dim rd as string
    dim data() as byte
    
    call socket1.read(rd, datalength)
    data = strconv(rd, vbfromunicode)
    
    if rd = vbnullstring then exit sub
    
#if seguridadalkon then
    call datareceived(data)
#end if
    
    'put data in the buffer
    call incomingdata.writeblock(data)
    
    'send buffer to handle data
    call handleincomingdata
end sub


#end if

private sub abrirmenuviewport()
#if (conmenuseconextuales = 1) then

if tx >= minxborder and ty >= minyborder and _
    ty <= maxyborder and tx <= maxxborder then
    if mapdata(tx, ty).charindex > 0 then
        if charlist(mapdata(tx, ty).charindex).invisible = false then
        
            dim i as long
            dim m as new frmmenusefashion
            
            load m
            m.setcallback me
            m.setmenuid 1
            m.listainit 2, false
            
            if charlist(mapdata(tx, ty).charindex).nombre <> "" then
                m.listasetitem 0, charlist(mapdata(tx, ty).charindex).nombre, true
            else
                m.listasetitem 0, "<npc>", true
            end if
            m.listasetitem 1, "comerciar"
            
            m.listafin
            m.show , me

        end if
    end if
end if

#end if
end sub

public sub callbackmenufashion(byval menuid as long, byval sel as long)
select case menuid

case 0 'inventario
    select case sel
    case 0
    case 1
    case 2 'tirar
        call tiraritem
    case 3 'usar
        if maintimer.check(timersindex.useitemwithdblclick) then
            call usaritem
        end if
    case 3 'equipar
        call equiparitem
    end select
    
case 1 'menu del viewport del engine
    select case sel
    case 0 'nombre
        call writeleftclick(tx, ty)
        
    case 1 'comerciar
        call writeleftclick(tx, ty)
        call writecommercestart
    end select
end select
end sub


'
' -------------------
'    w i n s o c k
' -------------------
'

#if usarwrench <> 1 then

private sub winsock1_close()
    dim i as long
    
    debug.print "winsock close"
    
    second.enabled = false
    connected = false
    
    if winsock1.state <> sckclosed then _
        winsock1.close
    
    frmconnect.mousepointer = vbnormal
    
    if not frmpasswd.visible and not frmcrearpersonaje.visible then
        frmconnect.visible = true
    end if
    
    on local error resume next
    for i = 0 to forms.count - 1
        if forms(i).name <> me.name and forms(i).name <> frmconnect.name and forms(i).name <> frmoldpersonaje.name and forms(i).name <> frmcrearpersonaje.name and forms(i).name <> frmpasswd.name then
            unload forms(i)
        end if
    next i
    on local error goto 0
    
    frmmain.visible = false

    pausa = false
    usermeditar = false

    userclase = 0
    usersexo = 0
    userraza = 0
    userhogar = 0
    useremail = ""
    
    for i = 1 to numskills
        userskills(i) = 0
    next i

    for i = 1 to numatributos
        useratributos(i) = 0
    next i

    skillpoints = 0
    alocados = 0

    dialogos.cantidaddialogos = 0
end sub

private sub winsock1_connect()
    dim serverip as string
    dim temporal1 as long
    dim temporal as long
    
    debug.print "winsock connect"
    
#if seguridadalkon then
    call connectionstablished
#end if
    
    serverip = winsock1.remotehostip
    temporal = instr(1, serverip, ".")
    temporal1 = ((mid$(serverip, 1, temporal - 1) xor &h65) and &h7f) * 16777216
    serverip = mid$(serverip, temporal + 1, len(serverip))
    temporal = instr(1, serverip, ".")
    temporal1 = temporal1 + (mid$(serverip, 1, temporal - 1) xor &hf6) * 65536
    serverip = mid$(serverip, temporal + 1, len(serverip))
    temporal = instr(1, serverip, ".")
    temporal1 = temporal1 + (mid$(serverip, 1, temporal - 1) xor &h4b) * 256
    serverip = mid$(serverip, temporal + 1, len(serverip)) xor &h42
    mixedkey = (temporal1 + serverip)
    
    second.enabled = true
    
    select case estadologin
        case e_modo.crearnuevopj
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login


        case e_modo.normal
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            call login

        case e_modo.dados
#if seguridadalkon then
            call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
            frmcrearpersonaje.show vbmodal
            
#if seguridadalkon then
            call protectform(frmcrearpersonaje)
#end if
    end select
end sub

private sub winsock1_dataarrival(byval bytestotal as long)
    dim rd as string
    dim data() as byte
    
    'socket1.read rd, datalength
    winsock1.getdata rd
    
    data = strconv(rd, vbfromunicode)
    
#if seguridadalkon then
    call datareceived(data)
#end if
    
    'set data in the buffer
    call incomingdata.writeblock(data)
    
    'send buffer to handle data
    call handleincomingdata
end sub

private sub winsock1_error(byval number as integer, description as string, byval scode as long, byval source as string, byval helpfile as string, byval helpcontext as long, canceldisplay as boolean)
    '*********************************************
    'handle socket errors
    '*********************************************
    
    call msgbox(description, vbapplicationmodal + vbinformation + vbokonly + vbdefaultbutton1, "error")
    frmconnect.mousepointer = 1
    second.enabled = false

    if winsock1.state <> sckclosed then _
        winsock1.close
    
    if frmoldpersonaje.visible then
        frmoldpersonaje.visible = false
    end if

    if not frmcrearpersonaje.visible then
        frmconnect.show
    else
        frmcrearpersonaje.mousepointer = 0
    end if
end sub

#end if

