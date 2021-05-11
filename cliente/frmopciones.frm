version 5.00
begin vb.form frmopciones 
   backcolor       =   &h00000000&
   borderstyle     =   3  'fixed dialog
   clientheight    =   3195
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   4680
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
   scaleheight     =   3195
   scalewidth      =   4680
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.frame frame1 
      backcolor       =   &h00000000&
      caption         =   "di�logos de clan"
      forecolor       =   &h00ffffff&
      height          =   750
      left            =   255
      tabindex        =   4
      top             =   1665
      width           =   4230
      begin vb.textbox txtcantmensajes 
         alignment       =   2  'center
         height          =   285
         left            =   2925
         maxlength       =   1
         tabindex        =   7
         text            =   "5"
         top             =   315
         width           =   450
      end
      begin vb.optionbutton optpantalla 
         backcolor       =   &h00000000&
         caption         =   "en pantalla,"
         forecolor       =   &h00ffffff&
         height          =   270
         left            =   1770
         tabindex        =   6
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
         tabindex        =   5
         top             =   315
         width           =   1560
      end
      begin vb.label label2 
         backstyle       =   0  'transparent
         caption         =   "mensajes"
         forecolor       =   &h00ffffff&
         height          =   240
         left            =   3480
         tabindex        =   8
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
      tabindex        =   2
      top             =   2700
      width           =   2790
   end
   begin vb.commandbutton command1 
      caption         =   "sonidos activados"
      height          =   345
      index           =   1
      left            =   960
      mouseicon       =   "frmopciones.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   1200
      width           =   2790
   end
   begin vb.commandbutton command1 
      caption         =   "musica activada"
      height          =   345
      index           =   0
      left            =   960
      mouseicon       =   "frmopciones.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   780
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
      tabindex        =   3
      top             =   180
      width           =   2775
   end
end
attribute vb_name = "frmopciones"
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

private sub command1_click(index as integer)

call audio.playwave(snd_click)

select case index
    case 0
        if musica then
            musica = false
            command1(0).caption = "musica desactivada"
            audio.stopmidi
        else
            musica = true
            command1(0).caption = "musica activada"
            call audio.playmidi(cstr(currentmidi) & ".mid")
        end if
    case 1
    
        if sound then
            sound = false
            command1(1).caption = "sonidos desactivados"
            call audio.stopwave
            rainbufferindex = 0
            frmmain.isplaying = playloop.plnone
        else
            sound = true
            command1(1).caption = "sonidos activados"
        end if
end select
end sub

private sub command2_click()
me.visible = false
end sub

private sub form_load()
    if musica then
        command1(0).caption = "musica activada"
    else
        command1(0).caption = "musica desactivada"
    end if
    
    if sound then
        command1(1).caption = "sonidos activados"
    else
        command1(1).caption = "sonidos desactivados"
    end if
end sub

private sub optconsola_click()
    dialogosclanes.activo = false
end sub

private sub optpantalla_click()
    dialogosclanes.activo = true
end sub

private sub txtcantmensajes_lostfocus()
    txtcantmensajes.text = trim$(txtcantmensajes.text)
    if isnumeric(txtcantmensajes.text) then
        dialogosclanes.cantidaddialogos = trim$(txtcantmensajes.text)
    else
        txtcantmensajes.text = 5
    end if
end sub
