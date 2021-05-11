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
   fillcolor       =   &h00000040&
   icon            =   "frmconnect.frx":0000
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   moveable        =   0   'false
   scaleheight     =   600
   scalemode       =   3  'pixel
   scalewidth      =   800
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   visible         =   0   'false
   begin vb.commandbutton downloadserver 
      caption         =   "descargar c�digo del servidor"
      height          =   375
      left            =   240
      tabindex        =   3
      top             =   8280
      width           =   2415
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
      height          =   225
      left            =   3000
      tabindex        =   0
      text            =   "7666"
      top             =   2460
      width           =   1875
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
      height          =   225
      left            =   5340
      tabindex        =   2
      text            =   "localhost"
      top             =   2460
      width           =   3375
   end
   begin vb.image imgservargentina 
      height          =   795
      left            =   -195
      mousepointer    =   99  'custom
      top             =   6765
      visible         =   0   'false
      width           =   2595
   end
   begin vb.image imggetpass 
      height          =   495
      left            =   3600
      mousepointer    =   99  'custom
      top             =   8220
      width           =   4575
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
      left            =   120
      tabindex        =   1
      top             =   120
      width           =   555
   end
   begin vb.image image1 
      height          =   585
      index           =   0
      left            =   8625
      mousepointer    =   99  'custom
      top             =   6705
      width           =   3090
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   8655
      mousepointer    =   99  'custom
      top             =   5400
      width           =   3045
   end
   begin vb.image image1 
      height          =   570
      index           =   2
      left            =   8610
      mousepointer    =   99  'custom
      top             =   8025
      width           =   3120
   end
   begin vb.image fondo 
      height          =   9000
      left            =   0
      top             =   -45
      width           =   12000
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

private sub downloadserver_click()
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
    call shellexecute(0, "open", "http://downloads.sourceforge.net/morgoao/aoserversrc0.12.1.zip?use_mirror=osdn", "", app.path, 0)
end sub

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
    
 dim j
 for each j in image1()
    j.tag = "0"
 next
 porttxt.text = config_inicio.puerto
 
 fondo.picture = loadpicture(app.path & "\graficos\conectar.jpg")


 '[code]:matux
 '
 '  el c�digo para mostrar la versi�n se genera ac� para
 ' evitar que por x razones luego desaparezca, como suele
 ' pasar a veces :)
    version.caption = "v" & app.major & "." & app.minor & " build: " & app.revision
 '[end]'

'recordatorio para cumplir la licencia, por si borr�s el bot�n sin leer el code...
dim i as long

for i = 0 to me.controls.count - 1
    if me.controls(i).name = "downloadserver" then
        exit for
    end if
next i

if i = me.controls.count then
    msgbox "no debe eliminarse la posibilidad de bajar el c�digo de sus servidor. caso contrario estar�an violando la licencia affero gpl y con ella derechos de autor, incurriendo de esta forma en un delito punible por ley." & vbcrlf & vbcrlf & vbcrlf & _
            "argentum online es libre, es de todos. mantengamoslo as�. si tanto te gusta el juego y quer�s los cambios que hacemos nosotros, compart� los tuyos. es un cambio justo. si no est�s de acuerdo, no uses nuestro c�digo, pues nadie te obliga o bien utiliza una versi�n anterior a la 0.12.0.", vbcritical or vbapplicationmodal
end if

end sub

private sub image1_click(index as integer)

call audio.playwave(snd_click)

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

select case index
    case 0
        call audio.playmidi("7.mid")
        
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

    case 1
    
        frmoldpersonaje.show vbmodal
        
    case 2
        on error goto errh
        call shell(app.path & "\recuperar.exe", vbnormalfocus)

end select
exit sub

errh:
    call msgbox("no se encuentra el programa recuperar.exe", vbcritical, "argentum online")
end sub

private sub imggetpass_click()
on error goto errh

    call audio.playwave(snd_click)
    call shell(app.path & "\recuperar.exe", vbnormalfocus)
    exit sub
errh:
    call msgbox("no se encuentra el programa recuperar.exe", vbcritical, "argentum online")
end sub

private sub imgservargentina_click()
    call audio.playwave(snd_click)
    iptxt.text = ipdelservidor
    porttxt.text = puertodelservidor
end sub

