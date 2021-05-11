version 5.00
begin vb.form frmconnect 
   backcolor       =   &h00e0e0e0&
   borderstyle     =   0  'none
   caption         =   "argentum online"
   clientheight    =   9000
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   12000
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   fillcolor       =   &h00000040&
   icon            =   "frmconnect.frx":0000
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   palettemode     =   1  'usezorder
   scaleheight     =   600
   scalemode       =   3  'pixel
   scalewidth      =   800
   startupposition =   2  'centerscreen
   visible         =   0   'false
   begin vb.textbox txtpasswd 
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
      forecolor       =   &h00ffffff&
      height          =   225
      imemode         =   3  'disable
      left            =   4920
      passwordchar    =   "*"
      tabindex        =   1
      top             =   3720
      width           =   2460
   end
   begin vb.textbox txtnombre 
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
      forecolor       =   &h00ffffff&
      height          =   225
      left            =   4905
      tabindex        =   0
      top             =   3210
      width           =   2460
   end
   begin vb.textbox porttxt 
      alignment       =   2  'center
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ff00&
      height          =   195
      left            =   4890
      tabindex        =   2
      text            =   "7666"
      top             =   2760
      width           =   825
   end
   begin vb.textbox iptxt 
      alignment       =   2  'center
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h0000ff00&
      height          =   195
      left            =   5760
      tabindex        =   4
      text            =   "localhost"
      top             =   2760
      width           =   1575
   end
   begin vb.image imgteclas 
      height          =   375
      left            =   6120
      top             =   3960
      width           =   1335
   end
   begin vb.image imgconectarse 
      height          =   375
      left            =   4800
      top             =   3960
      width           =   1335
   end
   begin vb.image imgverforo 
      height          =   465
      left            =   450
      top             =   6120
      width           =   2835
   end
   begin vb.image imgsalir 
      height          =   375
      left            =   9960
      top             =   8400
      width           =   1335
   end
   begin vb.image imgborrarpj 
      height          =   375
      left            =   8400
      top             =   8400
      width           =   1335
   end
   begin vb.image imgcodigofuente 
      height          =   375
      left            =   6840
      top             =   8400
      width           =   1335
   end
   begin vb.image imgreglamento 
      height          =   375
      left            =   5280
      top             =   8400
      width           =   1335
   end
   begin vb.image imgmanual 
      height          =   375
      left            =   3720
      top             =   8400
      width           =   1335
   end
   begin vb.image imgrecuperar 
      height          =   375
      left            =   2160
      top             =   8400
      width           =   1335
   end
   begin vb.image imgcrearpj 
      height          =   375
      left            =   600
      top             =   8400
      width           =   1335
   end
   begin vb.image imgservargentina 
      height          =   795
      left            =   360
      mousepointer    =   99  'custom
      top             =   9240
      visible         =   0   'false
      width           =   2595
   end
   begin vb.label version 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   195
      left            =   240
      tabindex        =   3
      top             =   240
      width           =   555
   end
end
attribute vb_name = "frmconnect"
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
'
'mat�as fernando peque�o
'matux@fibertel.com.ar
'www.noland-studios.com.ar
'acoyte 678 piso 17 dto b
'capital federal, buenos aires - republica argentina
'c�digo postal 1405

option explicit

private cbotoncrearpj as clsgraphicalbutton
private cbotonrecuperarpass as clsgraphicalbutton
private cbotonmanual as clsgraphicalbutton
private cbotonreglamento as clsgraphicalbutton
private cbotoncodigofuente as clsgraphicalbutton
private cbotonborrarpj as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton
private cbotonleermas as clsgraphicalbutton
private cbotonforo as clsgraphicalbutton
private cbotonconectarse as clsgraphicalbutton
private cbotonteclas as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_activate()
'on error resume next

if serversrecibidos then
    if curserver <> 0 then
        iptxt = serverslst(1).ip
        porttxt = serverslst(1).puerto
    else
        iptxt = ipdelservidor
        porttxt = puertodelservidor
    end if
end if

end sub

private sub form_keydown(keycode as integer, shift as integer)
    if keycode = 27 then
        prgrun = false
    end if
end sub

private sub form_keyup(keycode as integer, shift as integer)

'make server ip and port box visible
if keycode = vbkeyi and shift = vbctrlmask then
    
    'port
    porttxt.visible = true
    'label4.visible = true
    
    'server ip
    porttxt.text = "7666"
    iptxt.text = "192.168.0.2"
    iptxt.visible = true
    'label5.visible = true
    
    keycode = 0
    exit sub
end if

end sub

private sub form_load()
    '[code 002]:matux
    enginerun = false
    '[end]

    porttxt.text = config_inicio.puerto
 
     '[code]:matux
    '
    '  el c�digo para mostrar la versi�n se genera ac� para
    ' evitar que por x razones luego desaparezca, como suele
    ' pasar a veces :)
       version.caption = "v" & app.major & "." & app.minor & " build: " & app.revision
    '[end]'
    
    me.picture = loadpicture(app.path & "\graficos\ventanaconectar.jpg")
    
    call loadbuttons

    call checklicenseagreement
        
end sub

private sub checklicenseagreement()
    'recordatorio para cumplir la licencia, por si borr�s el boton sin leer el code...
    dim i as long
    
    for i = 0 to me.controls.count - 1
        if me.controls(i).name = "imgcodigofuente" then
            exit for
        end if
    next i
    
    if i = me.controls.count then
        msgbox "no debe eliminarse la posibilidad de bajar el c�digo de sus servidor. caso contrario estar�an violando la licencia affero gpl y con ella derechos de autor, incurriendo de esta forma en un delito punible por ley." & vbcrlf & vbcrlf & vbcrlf & _
                "argentum online es libre, es de todos. mantengamoslo as�. si tanto te gusta el juego y quer�s los cambios que hacemos nosotros, compart� los tuyos. es un cambio justo. si no est�s de acuerdo, no uses nuestro c�digo, pues nadie te obliga o bien utiliza una versi�n anterior a la 0.12.0.", vbcritical or vbapplicationmodal
    end if

end sub

private sub loadbuttons()
    
    dim grhpath as string
    
    grhpath = dirgraficos
    
    set cbotoncrearpj = new clsgraphicalbutton
    set cbotonrecuperarpass = new clsgraphicalbutton
    set cbotonmanual = new clsgraphicalbutton
    set cbotonreglamento = new clsgraphicalbutton
    set cbotoncodigofuente = new clsgraphicalbutton
    set cbotonborrarpj = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    set cbotonleermas = new clsgraphicalbutton
    set cbotonforo = new clsgraphicalbutton
    set cbotonconectarse = new clsgraphicalbutton
    set cbotonteclas = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton

        
    call cbotoncrearpj.initialize(imgcrearpj, grhpath & "botoncrearpersonajeconectar.jpg", _
                                    grhpath & "botoncrearpersonajerolloverconectar.jpg", _
                                    grhpath & "botoncrearpersonajeclickconectar.jpg", me)
                                    
    call cbotonrecuperarpass.initialize(imgrecuperar, grhpath & "botonrecuperarpass.jpg", _
                                    grhpath & "botonrecuperarpassrollover.jpg", _
                                    grhpath & "botonrecuperarpassclick.jpg", me)
                                    
    call cbotonmanual.initialize(imgmanual, grhpath & "botonmanual.jpg", _
                                    grhpath & "botonmanualrollover.jpg", _
                                    grhpath & "botonmanualclick.jpg", me)
                                    
    call cbotonreglamento.initialize(imgreglamento, grhpath & "botonreglamento.jpg", _
                                    grhpath & "botonreglamentorollover.jpg", _
                                    grhpath & "botonreglamentoclick.jpg", me)
                                    
    call cbotoncodigofuente.initialize(imgcodigofuente, grhpath & "botoncodigofuente.jpg", _
                                    grhpath & "botoncodigofuenterollover.jpg", _
                                    grhpath & "botoncodigofuenteclick.jpg", me)
                                    
    call cbotonborrarpj.initialize(imgborrarpj, grhpath & "botonborrarpersonaje.jpg", _
                                    grhpath & "botonborrarpersonajerollover.jpg", _
                                    grhpath & "botonborrarpersonajeclick.jpg", me)
                                    
    call cbotonsalir.initialize(imgsalir, grhpath & "botonsalirconnect.jpg", _
                                    grhpath & "botonbotonsalirrolloverconnect.jpg", _
                                    grhpath & "botonsalirclickconnect.jpg", me)
                                    
    call cbotonforo.initialize(imgverforo, grhpath & "botonverforo.jpg", _
                                    grhpath & "botonverfororollover.jpg", _
                                    grhpath & "botonverforoclick.jpg", me)
                                    
    call cbotonconectarse.initialize(imgconectarse, grhpath & "botonconectarse.jpg", _
                                    grhpath & "botonconectarserollover.jpg", _
                                    grhpath & "botonconectarseclick.jpg", me)
                                    
    call cbotonteclas.initialize(imgteclas, grhpath & "botonteclas.jpg", _
                                    grhpath & "botonteclasrollover.jpg", _
                                    grhpath & "botonteclasclick.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub checkservers()
    if serversrecibidos then
        if not isip(iptxt) and curserver <> 0 then
            if msgbox("atencion, est� intentando conectarse a un servidor no oficial, noland studios no se hace responsable de los posibles problemas que estos servidores presenten. �desea continuar?", vbyesno) = vbno then
                if curserver <> 0 then
                    iptxt = serverslst(curserver).ip
                    porttxt = serverslst(curserver).puerto
                else
                    iptxt = ipdelservidor
                    porttxt = puertodelservidor
                end if
                exit sub
            end if
        end if
    end if
    curserver = 0
    ipdelservidor = iptxt
    puertodelservidor = porttxt
end sub

private sub imgborrarpj_click()

on error goto errh
    call shell(app.path & "\recuperar.exe", vbnormalfocus)

    exit sub

errh:
    call msgbox("no se encuentra el programa recuperar.exe", vbcritical, "argentum online")
end sub

private sub imgcodigofuente_click()
'***********************************
'importante!
'
'no debe eliminarse la posibilidad de bajar el c�digo de sus servidor de esta forma.
'caso contrario estar�an violando la licencia affero gpl y con ella derechos de autor,
'incurriendo de esta forma en un delito punible por ley.
'
'argentum online es libre, es de todos. mantengamoslo as�. si tanto te gusta el juego y quer�s los
'cambios que hacemos nosotros, compart� los tuyos. es un cambio justo. si no est�s de acuerdo,
'no uses nuestro c�digo, pues nadie te obliga o bien utiliza una versi�n anterior a la 0.12.0.
'***********************************
    call shellexecute(0, "open", "https://sourceforge.net/project/downloading.php?group_id=67718&filename=aoserversrc0.12.2.zip&a=42868900", "", app.path, sw_shownormal)

end sub

private sub imgconectarse_click()
    call checkservers
    
#if usarwrench = 1 then
    if frmmain.socket1.connected then
        frmmain.socket1.disconnect
        frmmain.socket1.cleanup
        doevents
    end if
#else
    if frmmain.winsock1.state <> sckclosed then
        frmmain.winsock1.close
        doevents
    end if
#end if
    
    'update user info
    username = txtnombre.text
    
    dim aux as string
    aux = txtpasswd.text
    
#if seguridadalkon then
    userpassword = md5.getmd5string(aux)
    call md5.md5reset
#else
    userpassword = aux
#end if
    if checkuserdata(false) = true then
        estadologin = normal
        
#if usarwrench = 1 then
    frmmain.socket1.hostname = curserverip
    frmmain.socket1.remoteport = curserverport
    frmmain.socket1.connect
#else
    frmmain.winsock1.connect curserverip, curserverport
#end if

    end if
    
end sub

private sub imgcrearpj_click()
    
    call checkservers
    
    estadologin = e_modo.dados
#if usarwrench = 1 then
    if frmmain.socket1.connected then
        frmmain.socket1.disconnect
        frmmain.socket1.cleanup
        doevents
    end if
    frmmain.socket1.hostname = curserverip
    frmmain.socket1.remoteport = curserverport
    frmmain.socket1.connect
#else
    if frmmain.winsock1.state <> sckclosed then
        frmmain.winsock1.close
        doevents
    end if
    frmmain.winsock1.connect curserverip, curserverport
#end if

end sub

private sub imgleermas_click()
    call shellexecute(0, "open", "http://ao.alkon.com.ar", "", app.path, sw_shownormal)
end sub

private sub imgmanual_click()
    call shellexecute(0, "open", "http://ao.alkon.com.ar/manual/", "", app.path, sw_shownormal)
end sub

private sub imgrecuperar_click()
on error goto errh

    call audio.playwave(snd_click)
    call shell(app.path & "\recuperar.exe", vbnormalfocus)
    exit sub
errh:
    call msgbox("no se encuentra el programa recuperar.exe", vbcritical, "argentum online")
end sub

private sub imgreglamento_click()
    call shellexecute(0, "open", "http://ao.alkon.com.ar/reglamento.html", "", app.path, sw_shownormal)
end sub

private sub imgsalir_click()
    prgrun = false
end sub

private sub imgservargentina_click()
    call audio.playwave(snd_click)
    iptxt.text = ipdelservidor
    porttxt.text = puertodelservidor
end sub

private sub imgteclas_click()
    load frmkeypad
    frmkeypad.show vbmodal
    unload frmkeypad
    txtpasswd.setfocus
end sub

private sub imgverforo_click()
    call shellexecute(0, "open", "http://www.alkon.com.ar/foro/argentum-online.53/", "", app.path, sw_shownormal)
end sub

private sub txtpasswd_keypress(keyascii as integer)
    if keyascii = vbkeyreturn then imgconectarse_click
end sub

private sub webauxiliar_beforenavigate2(byval pdisp as object, url as variant, flags as variant, targetframename as variant, postdata as variant, headers as variant, cancel as boolean)
    
    if instr(1, url, "alkon") <> 0 then
        call shellexecute(hwnd, "open", url, vbnullstring, vbnullstring, sw_shownormal)
        cancel = true
    end if
    
end sub
