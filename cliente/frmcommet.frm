version 5.00
begin vb.form frmcommet 
   borderstyle     =   1  'fixed single
   caption         =   "oferta de paz o alianza"
   clientheight    =   2820
   clientleft      =   45
   clienttop       =   330
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
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   2820
   scalewidth      =   4680
   startupposition =   1  'centerowner
   begin vb.commandbutton command2 
      cancel          =   -1  'true
      caption         =   "cancelar"
      height          =   495
      left            =   120
      mouseicon       =   "frmcommet.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2160
      width           =   2055
   end
   begin vb.commandbutton command1 
      caption         =   "enviar"
      height          =   495
      left            =   2400
      mouseicon       =   "frmcommet.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   2160
      width           =   2055
   end
   begin vb.textbox text1 
      height          =   1935
      left            =   120
      multiline       =   -1  'true
      tabindex        =   0
      top             =   120
      width           =   4335
   end
end
attribute vb_name = "frmcommet"
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

public nombre as string
public t as tipo
public enum tipo
    alianza = 1
    paz = 2
    rechazopj = 3
end enum

public sub settipo(byval t as tipo)
    select case t
        case tipo.alianza
            me.caption = "detalle de solicitud de alianza"
            me.text1.maxlength = 200
        case tipo.paz
            me.caption = "detalle de solicitud de paz"
            me.text1.maxlength = 200
        case tipo.rechazopj
            me.caption = "detalle de rechazo de membres�a"
            me.text1.maxlength = 50
    end select
end sub


private sub command1_click()


if text1 = "" then
    if t = paz or t = alianza then
        msgbox "debes redactar un mensaje solicitando la paz o alianza al l�der de " & nombre
    else
        msgbox "debes indicar el motivo por el cual rechazas la membres�a de " & nombre
    end if
    exit sub
end if

if t = paz then
    call senddata("peaceoff" & nombre & "," & replace(text1, vbcrlf, "�"))
elseif t = alianza then
    call senddata("allieoff" & nombre & "," & replace(text1, vbcrlf, "�"))
elseif t = rechazopj then
    call senddata("rechazar" & nombre & "," & replace(replace(text1.text, ",", " "), vbcrlf, " "))
    'sacamos el char de la lista de aspirantes
    dim i as long
    for i = 0 to frmguildleader.solicitudes.listcount - 1
        if frmguildleader.solicitudes.list(i) = nombre then
            frmguildleader.solicitudes.removeitem i
            exit for
        end if
    next i
    
    me.hide
    unload frmcharinfo
    'call senddata("glinfo")
end if
unload me

end sub

private sub command2_click()
unload me
end sub

