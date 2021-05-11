version 5.00
object = "{831fdd16-0c5c-11d2-a9fc-0000f8754da1}#2.0#0"; "mscomctl.ocx"
begin vb.form frmopciones 
   backcolor       =   &h00000000&
   borderstyle     =   3  'fixed dialog
   clientheight    =   6315
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   4695
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   icon            =   "frmopciones.frx":0000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   6315
   scalewidth      =   4695
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.commandbutton cmdradioao 
      caption         =   "escuchar radio ao"
      height          =   375
      left            =   960
      tabindex        =   18
      top             =   4800
      width           =   2775
   end
   begin vb.checkbox check1 
      backcolor       =   &h00000000&
      caption         =   "efectos de sonido"
      forecolor       =   &h00ffffff&
      height          =   255
      index           =   2
      left            =   345
      tabindex        =   17
      top             =   1515
      width           =   1695
   end
   begin vb.commandbutton cmdviewmap 
      caption         =   "mapa del juego"
      height          =   375
      left            =   960
      tabindex        =   16
      top             =   4320
      width           =   2775
   end
   begin vb.commandbutton cmdchangepassword 
      caption         =   "cambiar contrase�a"
      height          =   375
      left            =   960
      tabindex        =   15
      top             =   3825
      width           =   2775
   end
   begin vb.commandbutton cmdcustomkeys 
      caption         =   "configurar teclas"
      height          =   375
      left            =   960
      tabindex        =   14
      top             =   3345
      width           =   2775
   end
   begin vb.commandbutton custommsgcmd 
      caption         =   "mensajes personalizados"
      height          =   375
      left            =   960
      tabindex        =   13
      top             =   2865
      width           =   2775
   end
   begin vb.commandbutton cmdmanual 
      caption         =   "manual de argentum online"
      height          =   375
      left            =   960
      tabindex        =   12
      top             =   5280
      width           =   2775
   end
   begin vb.frame frame2 
      backcolor       =   &h00000000&
      caption         =   "audio"
      forecolor       =   &h00ffffff&
      height          =   1260
      left            =   240
      tabindex        =   7
      top             =   600
      width           =   4215
      begin mscomctllib.slider slider1 
         height          =   255
         index           =   0
         left            =   1080
         tabindex        =   10
         top             =   240
         width           =   3015
         _extentx        =   5318
         _extenty        =   450
         _version        =   393216
         borderstyle     =   1
         max             =   100
         tickstyle       =   3
      end
      begin vb.checkbox check1 
         backcolor       =   &h00000000&
         caption         =   "sonidos"
         forecolor       =   &h00ffffff&
         height          =   255
         index           =   1
         left            =   120
         tabindex        =   9
         top             =   600
         width           =   855
      end
      begin vb.checkbox check1 
         backcolor       =   &h00000000&
         caption         =   "musica"
         forecolor       =   &h00ffffff&
         height          =   255
         index           =   0
         left            =   120
         tabindex        =   8
         top             =   240
         width           =   855
      end
      begin mscomctllib.slider slider1 
         height          =   255
         index           =   1
         left            =   1080
         tabindex        =   11
         top             =   600
         width           =   3015
         _extentx        =   5318
         _extenty        =   450
         _version        =   393216
         borderstyle     =   1
         largechange     =   10
         max             =   100
         tickstyle       =   3
      end
   end
   begin vb.frame frame1 
      backcolor       =   &h00000000&
      caption         =   "di�logos de clan"
      forecolor       =   &h00ffffff&
      height          =   750
      left            =   240
      tabindex        =   2
      top             =   1860
      width           =   4230
      begin vb.textbox txtcantmensajes 
         alignment       =   2  'center
         height          =   285
         left            =   2925
         maxlength       =   1
         tabindex        =   5
         text            =   "5"
         top             =   315
         width           =   450
      end
      begin vb.optionbutton optpantalla 
         backcolor       =   &h00000000&
         caption         =   "en pantalla,"
         forecolor       =   &h00ffffff&
         height          =   270
         left            =   1800
         tabindex        =   4
         top             =   315
         value           =   -1  'true
         width           =   1560
      end
      begin vb.optionbutton optconsola 
         backcolor       =   &h00000000&
         caption         =   "en consola"
         forecolor       =   &h00ffffff&
         height          =   270
         left            =   105
         tabindex        =   3
         top             =   315
         width           =   1560
      end
      begin vb.label label2 
         backstyle       =   0  'transparent
         caption         =   "mensajes"
         forecolor       =   &h00ffffff&
         height          =   240
         left            =   3480
         tabindex        =   6
         top             =   345
         width           =   750
      end
   end
   begin vb.commandbutton command2 
      caption         =   "cerrar"
      height          =   345
      left            =   960
      mouseicon       =   "frmopciones.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   5760
      width           =   2790
   end
   begin vb.label label1 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "opciones"
      beginproperty font 
         name            =   "tahoma"
         size            =   14.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   375
      left            =   960
      tabindex        =   1
      top             =   180
      width           =   2775
   end
end
attribute vb_name = "frmopciones"
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

private loading as boolean

private sub check1_click(index as integer)
    if not loading then _
        call audio.playwave(snd_click)
    
    select case index
        case 0
            if check1(0).value = vbunchecked then
                audio.musicactivated = false
                slider1(0).enabled = false
            elseif not audio.musicactivated then  'prevent the music from reloading
                audio.musicactivated = true
                slider1(0).enabled = true
                slider1(0).value = audio.musicvolume
            end if
        
        case 1
            if check1(1).value = vbunchecked then
                audio.soundactivated = false
                rainbufferindex = 0
                frmmain.isplaying = playloop.plnone
                slider1(1).enabled = false
            else
                audio.soundactivated = true
                slider1(1).enabled = true
                slider1(1).value = audio.soundvolume
            end if
            
        case 2
            if check1(2).value = vbunchecked then
                audio.soundeffectsactivated = false
            else
                audio.soundeffectsactivated = true
            end if
    end select
end sub

private sub cmdcustomkeys_click()
    if not loading then _
        call audio.playwave(snd_click)
    call frmcustomkeys.show(vbmodal, me)
end sub

private sub cmdmanual_click()
    if not loading then _
        call audio.playwave(snd_click)
    call shellexecute(0, "open", "http://ao.alkon.com.ar/aomanual/", "", app.path, sw_shownormal)
end sub

private sub cmdchangepassword_click()
    call frmnewpassword.show(vbmodal, me)
end sub

private sub cmdradioao_click()
    if not loading then _
        call audio.playwave(snd_click)
        call shellexecute(0, "open", "http://radio.radioargentum.com/", "", app.path, sw_shownormal)
end sub

private sub cmdviewmap_click()
    call frmmapa.show(vbmodal, me)
end sub

private sub command2_click()
    unload me
    frmmain.setfocus
end sub

private sub custommsgcmd_click()
    call frmmessagetxt.show(vbmodeless, me)
end sub

private sub form_load()
    loading = true      'prevent sounds when setting check's values
    
    if audio.musicactivated then
        check1(0).value = vbchecked
        slider1(0).enabled = true
        slider1(0).value = audio.musicvolume
    else
        check1(0).value = vbunchecked
        slider1(0).enabled = false
    end if
    
    if audio.soundactivated then
        check1(1).value = vbchecked
        slider1(1).enabled = true
        slider1(1).value = audio.soundvolume
    else
        check1(1).value = vbunchecked
        slider1(1).enabled = false
    end if
    
    if audio.soundeffectsactivated then
        check1(2).value = vbchecked
    else
        check1(2).value = vbunchecked
    end if
    
    txtcantmensajes.text = cstr(dialogosclanes.cantidaddialogos)
    
    if dialogosclanes.activo then
        optconsola.value = false
        optpantalla.value = true
    else
        optconsola.value = true
        optpantalla.value = false
    end if
    
    loading = false     'enable sounds when setting check's values
end sub

private sub optconsola_click()
    dialogosclanes.activo = false
end sub

private sub optpantalla_click()
    dialogosclanes.activo = true
end sub

private sub slider1_change(index as integer)
    select case index
        case 0
            audio.musicvolume = slider1(0).value
        case 1
            audio.soundvolume = slider1(1).value
    end select
end sub

private sub slider1_scroll(index as integer)
    select case index
        case 0
            audio.musicvolume = slider1(0).value
        case 1
            audio.soundvolume = slider1(1).value
    end select
end sub

private sub txtcantmensajes_lostfocus()
    txtcantmensajes.text = trim$(txtcantmensajes.text)
    if isnumeric(txtcantmensajes.text) then
        dialogosclanes.cantidaddialogos = trim$(txtcantmensajes.text)
    else
        txtcantmensajes.text = 5
    end if
end sub
