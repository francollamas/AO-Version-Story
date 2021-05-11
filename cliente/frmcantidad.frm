version 5.00
begin vb.form frmcantidad 
   backcolor       =   &h00000000&
   borderstyle     =   3  'fixed dialog
   clientheight    =   1500
   clientleft      =   1680
   clienttop       =   4455
   clientwidth     =   3240
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   1500
   scalewidth      =   3240
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.commandbutton command2 
      caption         =   "todo"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   345
      left            =   2025
      mouseicon       =   "frmcantidad.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   1035
      width           =   930
   end
   begin vb.commandbutton command1 
      caption         =   "a&ceptar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   345
      left            =   330
      mouseicon       =   "frmcantidad.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   1035
      width           =   1680
   end
   begin vb.textbox text1 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   330
      tabindex        =   1
      top             =   525
      width           =   2625
   end
   begin vb.label label1 
      backstyle       =   0  'transparent
      caption         =   "escriba la cantidad:"
      beginproperty font 
         name            =   "verdana"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   375
      left            =   585
      tabindex        =   0
      top             =   165
      width           =   2415
   end
end
attribute vb_name = "frmcantidad"
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

private sub command1_click()
frmcantidad.visible = false
senddata "ti" & inventario.selecteditem & "," & frmcantidad.text1.text
frmcantidad.text1.text = "0"
end sub


private sub command2_click()


frmcantidad.visible = false
if inventario.selecteditem <> flagoro then
    senddata "ti" & inventario.selecteditem & "," & inventario.amount(inventario.selecteditem)
else
    senddata "ti" & inventario.selecteditem & "," & usergld
end if

frmcantidad.text1.text = "0"

end sub

private sub form_deactivate()
'unload me
end sub

private sub text1_change()
on error goto errhandler
    if val(text1.text) < 0 then
        text1.text = max_inventory_objs
    end if
    
    if val(text1.text) > max_inventory_objs then
        if inventario.selecteditem <> flagoro or val(text1.text) > usergld then
            text1.text = "1"
        end if
    end if
    
    exit sub
    
errhandler:
    'if we got here the user may have pasted (shift + insert) a really large number, causing an overflow, so we set amount back to 1
    text1.text = "1"
end sub


private sub text1_keypress(keyascii as integer)
if (keyascii <> 8) then
    if (keyascii < 48 or keyascii > 57) then
        keyascii = 0
    end if
end if
end sub
