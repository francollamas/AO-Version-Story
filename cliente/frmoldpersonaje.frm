version 5.00
begin vb.form frmoldpersonaje 
   backcolor       =   &h00ffffff&
   borderstyle     =   0  'none
   caption         =   "argentum"
   clientheight    =   3765
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   7200
   linktopic       =   "form1"
   scaleheight     =   251
   scalemode       =   3  'pixel
   scalewidth      =   480
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.textbox nametxt 
      appearance      =   0  'flat
      backcolor       =   &h00800000&
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
      forecolor       =   &h000000ff&
      height          =   285
      left            =   2265
      tabindex        =   0
      top             =   705
      width           =   4530
   end
   begin vb.textbox passwordtxt 
      appearance      =   0  'flat
      backcolor       =   &h00800000&
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
      forecolor       =   &h000000ff&
      height          =   285
      imemode         =   3  'disable
      left            =   2265
      passwordchar    =   "*"
      tabindex        =   1
      top             =   1200
      width           =   4530
   end
   begin vb.label lblinfo 
      alignment       =   2  'center
      backcolor       =   &h00404040&
      borderstyle     =   1  'fixed single
      beginproperty font 
         name            =   "ms serif"
         size            =   12
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   960
      left            =   510
      tabindex        =   2
      top             =   1800
      visible         =   0   'false
      width           =   6120
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   4920
      mouseicon       =   "frmoldpersonaje.frx":0000
      mousepointer    =   99  'custom
      top             =   3090
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   1365
      mouseicon       =   "frmoldpersonaje.frx":0152
      mousepointer    =   99  'custom
      top             =   3105
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   2
      left            =   3120
      mouseicon       =   "frmoldpersonaje.frx":02a4
      mousepointer    =   99  'custom
      top             =   3090
      width           =   960
   end
end
attribute vb_name = "frmoldpersonaje"
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

private const textokeypad = "utilice el teclado como protecci�n contra keyloggers. seleccione el password con el mouse y presione <enter> al finalizar"
private const textoseguir = "conectarse al juego" & vbnewline & "con el usuario y" & vbnewline & "clave seleccionadas"
private const textosalir = "volver a la pantalla principal" & vbnewline & "para crear personajes o recuperar" & vbnewline & "contrase�as"



private sub form_load()
dim j
for each j in image1()
    j.tag = "0"
next

nametxt.text = ""
passwordtxt.text = ""
me.picture = loadpicture(app.path & "\graficos\oldcaracter.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bsiguiente.jpg")
image1(2).picture = loadpicture(app.path & "\graficos\bteclas.jpg")



end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
if image1(0).tag = "1" then
            me.lblinfo.visible = false
            me.lblinfo.caption = vbnullstring
            image1(0).tag = "0"
            image1(0).picture = loadpicture(app.path & "\graficos\bsiguiente.jpg")
end if
if image1(1).tag = "1" then
            me.lblinfo.visible = false
            me.lblinfo.caption = vbnullstring
            image1(1).tag = "0"
            image1(1).picture = loadpicture(app.path & "\graficos\bvolver.jpg")
end if
if image1(2).tag = "1" then
            me.lblinfo.visible = false
            me.lblinfo.caption = vbnullstring
            image1(2).tag = "0"
            image1(2).picture = loadpicture(app.path & "\graficos\bteclas.jpg")
end if

end sub

private sub image1_click(index as integer)

call audio.playwave(snd_click)



select case index
    case 0
       
#if usarwrench = 1 then
        if frmmain.socket1.connected then frmmain.socket1.disconnect
#else
        if frmmain.winsock1.state <> sckclosed then _
            frmmain.winsock1.close
#end if
        if frmconnect.mousepointer = 11 then
            exit sub
        end if
        
        
        'update user info
        username = nametxt.text
        dim aux as string
        aux = passwordtxt.text
#if seguridadalkon then
        userpassword = md5.getmd5string(aux)
        call md5.md5reset
#else
        userpassword = aux
#end if
        if checkuserdata(false) = true then
            'sendnewchar = false
            estadologin = normal
            me.mousepointer = 11
#if usarwrench = 1 then
            frmmain.socket1.hostaddress = curserverip
            frmmain.socket1.remoteport = curserverport
            frmmain.socket1.connect
#else
            if frmmain.winsock1.state <> sckclosed then _
                frmmain.winsock1.close
            frmmain.winsock1.connect curserverip, curserverport
#end if
        end if
        
    case 1
        me.visible = false
    case 2
        load frmkeypad
        frmkeypad.show vbmodal
        unload frmkeypad
        me.passwordtxt.setfocus
        
end select
end sub

private sub image1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
select case index
    case 0
        if image1(0).tag = "0" then
            me.lblinfo.visible = true
            me.lblinfo.caption = textoseguir
            image1(0).tag = "1"
            call audio.playwave(snd_over)
            image1(0).picture = loadpicture(app.path & "\graficos\bsiguientea.jpg")
        end if
    case 1
        if image1(1).tag = "0" then
            me.lblinfo.visible = true
            me.lblinfo.caption = textosalir
            image1(1).tag = "1"
            call audio.playwave(snd_over)
            image1(1).picture = loadpicture(app.path & "\graficos\bvolvera.jpg")
        end if
    case 2
        if image1(2).tag = "0" then
            me.lblinfo.visible = true
            me.lblinfo.caption = textokeypad
            image1(2).tag = "1"
            call audio.playwave(snd_over)
            image1(2).picture = loadpicture(app.path & "\graficos\bteclasa.jpg")
        end if
        
end select
end sub

private sub passwordtxt_keydown(keycode as integer, shift as integer)
    if keycode = vbkeyreturn then
        call image1_click(0)
    end if
end sub
