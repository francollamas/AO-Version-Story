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
   begin vb.commandbutton command1 
      caption         =   "este server ->"
      height          =   375
      left            =   1530
      tabindex        =   4
      top             =   2430
      width           =   1185
   end
   begin vb.listbox lst_servers 
      backcolor       =   &h00000000&
      forecolor       =   &h0000ff00&
      height          =   5130
      itemdata        =   "frmconnect.frx":000c
      left            =   3150
      list            =   "frmconnect.frx":0013
      tabindex        =   3
      top             =   3060
      width           =   5415
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
   begin vb.image imgservespana 
      height          =   435
      left            =   4560
      mousepointer    =   99  'custom
      top             =   5220
      width           =   2475
   end
   begin vb.image imgservargentina 
      height          =   795
      left            =   4500
      mousepointer    =   99  'custom
      top             =   3720
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
'
'mat�as fernando peque�o
'matux@fibertel.com.ar
'www.noland-studios.com.ar
'acoyte 678 piso 17 dto b
'capital federal, buenos aires - republica argentina
'c�digo postal 1405

option explicit

public sub cargarlst()

dim i as integer

lst_servers.clear

if serversrecibidos then
    for i = 1 to ubound(serverslst)
        lst_servers.additem serverslst(i).ip & ":" & serverslst(i).puerto & " - desc:" & serverslst(i).desc
    next i
end if

end sub

private sub command1_click()
curserver = 0
ipdelservidor = iptxt
puertodelservidor = porttxt
end sub


private sub form_activate()
'on error resume next

if serversrecibidos then
    if curserver <> 0 then
        iptxt = serverslst(curserver).ip
        porttxt = serverslst(curserver).puerto
    else
        iptxt = ipdelservidor
        porttxt = puertodelservidor
    end if
    
    call cargarlst
else
    lst_servers.clear
end if

end sub


private sub form_keydown(keycode as integer, shift as integer)
if keycode = 27 then
        frmcargando.show
        frmcargando.refresh
        addtorichtextbox frmcargando.status, "cerrando argentum online.", 0, 0, 0, 1, 0, 1
        
        call savegameini
        frmconnect.mousepointer = 1
        frmmain.mousepointer = 1
        prgrun = false
        
        addtorichtextbox frmcargando.status, "liberando recursos..."
        frmcargando.refresh
        liberarobjetosdx
        addtorichtextbox frmcargando.status, "hecho", 0, 0, 0, 1, 0, 1
        addtorichtextbox frmcargando.status, "��gracias por jugar argentum online!!", 0, 0, 0, 1, 0, 1
        frmcargando.refresh
        call unloadallforms
end if
end sub

private sub form_keyup(keycode as integer, shift as integer)

'make server ip and port box visible
if keycode = vbkeyi and shift = vbctrlmask then
    
    'port
    porttxt.visible = true
    'label4.visible = true
    
    'server ip
    iptxt.text = "localhost"
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

end sub



private sub image1_click(index as integer)


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


call playwaveds(snd_click)

select case index
    case 0
        
        if musica = 0 then
            curmidi = dirmidi & "7.mid"
            loopmidi = 1
            call cargarmidi(curmidi)
            call play_midi
        end if
        
        
        
        'frmcrearpersonaje.show vbmodal
        estadologin = dados
        frmmain.socket1.hostname = curserverip
        frmmain.socket1.remoteport = curserverport
        me.mousepointer = 11
        frmmain.socket1.connect

        
    case 1
    
        frmoldpersonaje.show vbmodal
        
    case 2

        frmborrar.show vbmodal

end select
end sub

private sub imggetpass_click()
    call playwaveds(snd_click)
    call frmrecuperar.show(vbmodal, frmconnect)
end sub

private sub imgservargentina_click()
    call playwaveds(snd_click)
    iptxt.text = ipdelservidor
    porttxt.text = puertodelservidor
end sub

private sub imgservespana_click()
    call playwaveds(snd_click)
    iptxt.text = "62.42.193.233"
    porttxt.text = "7666"
end sub



private sub lst_servers_click()
if serversrecibidos then
    curserver = lst_servers.listindex + 1
    iptxt = serverslst(curserver).ip
    porttxt = serverslst(curserver).puerto
end if

end sub

