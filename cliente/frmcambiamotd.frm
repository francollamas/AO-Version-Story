version 5.00
begin vb.form frmcambiamotd 
   borderstyle     =   1  'fixed single
   caption         =   """zmotd"""
   clientheight    =   5415
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   5175
   clipcontrols    =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   5415
   scalewidth      =   5175
   startupposition =   3  'windows default
   begin vb.checkbox chkitalic 
      caption         =   "cursiva"
      height          =   255
      left            =   2880
      tabindex        =   12
      top             =   4320
      width           =   855
   end
   begin vb.checkbox chkbold 
      caption         =   "negrita"
      height          =   255
      left            =   1080
      tabindex        =   11
      top             =   4320
      width           =   855
   end
   begin vb.commandbutton cmdmarron 
      caption         =   "marron"
      height          =   375
      left            =   3480
      tabindex        =   10
      top             =   3840
      width           =   855
   end
   begin vb.commandbutton cmdverde 
      caption         =   "verde"
      height          =   375
      left            =   2520
      tabindex        =   9
      top             =   3840
      width           =   855
   end
   begin vb.commandbutton cmdmorado 
      caption         =   "morado"
      height          =   375
      left            =   1560
      tabindex        =   8
      top             =   3840
      width           =   855
   end
   begin vb.commandbutton cmdamarillo 
      caption         =   "amarillo"
      height          =   375
      left            =   600
      tabindex        =   7
      top             =   3840
      width           =   855
   end
   begin vb.commandbutton cmdgris 
      caption         =   "gris"
      height          =   375
      left            =   3480
      tabindex        =   6
      top             =   3240
      width           =   855
   end
   begin vb.commandbutton cmdblanco 
      caption         =   "blanco"
      height          =   375
      left            =   2520
      tabindex        =   5
      top             =   3240
      width           =   855
   end
   begin vb.commandbutton cmdrojo 
      caption         =   "rojo"
      height          =   375
      left            =   1560
      tabindex        =   4
      top             =   3240
      width           =   855
   end
   begin vb.commandbutton cmdazul 
      backcolor       =   &h00ff0000&
      caption         =   "azul"
      height          =   375
      left            =   600
      maskcolor       =   &h00ff0000&
      tabindex        =   3
      top             =   3240
      width           =   855
   end
   begin vb.commandbutton cmdok 
      caption         =   "aceptar"
      height          =   375
      left            =   600
      tabindex        =   2
      top             =   4800
      width           =   3855
   end
   begin vb.textbox txtmotd 
      height          =   2415
      left            =   360
      multiline       =   -1  'true
      scrollbars      =   3  'both
      tabindex        =   0
      top             =   660
      width           =   4455
   end
   begin vb.label label1 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "no olvides agregar los colores al final de cada l�nea (ver tabla de abajo)"
      beginproperty font 
         name            =   "arial"
         size            =   9.75
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   -1  'true
         strikethrough   =   0   'false
      endproperty
      height          =   495
      left            =   360
      tabindex        =   1
      top             =   60
      width           =   4455
   end
end
attribute vb_name = "frmcambiamotd"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmcambiarmotd.frm
'
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

private sub cmdok_click()
    dim t() as string
    dim i as long, n as long, pos as long
    
    if len(txtmotd.text) >= 2 then
        if right$(txtmotd.text, 2) = vbcrlf then txtmotd.text = left$(txtmotd.text, len(txtmotd.text) - 2)
    end if
    
    t = split(txtmotd.text, vbcrlf)
    
    'hola~1~1~1~1~1
    
    for i = lbound(t) to ubound(t)
        n = 0
        pos = instr(1, t(i), "~")
        do while pos > 0 and pos < len(t(i))
            n = n + 1
            pos = instr(pos + 1, t(i), "~")
        loop
        if n <> 5 then
            msgbox "error en el formato de la linea " & i + 1 & "."
            exit sub
        end if
    next i
    
    call writesetmotd(txtmotd.text)
    unload me
end sub

'a partir de command2_click son todos buttons para agregar color al texto
private sub cmdazul_click()
    txtmotd.text = txtmotd & "~50~70~250~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdrojo_click()
    txtmotd.text = txtmotd & "~255~0~0~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdblanco_click()
    txtmotd.text = txtmotd & "~255~255~255~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdgris_click()
    txtmotd.text = txtmotd & "~157~157~157~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdamarillo_click()
    txtmotd.text = txtmotd & "~244~244~0~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdmorado_click()
    txtmotd.text = txtmotd & "~128~0~128~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdverde_click()
  txtmotd.text = txtmotd & "~23~104~26~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub

private sub cmdmarron_click()
    txtmotd.text = txtmotd & "~97~58~31~" & cstr(chkbold.value) & "~" & cstr(chkitalic.value)
end sub
