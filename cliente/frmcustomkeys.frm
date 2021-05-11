version 5.00
begin vb.form frmcustomkeys 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   6570
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   8220
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   438
   scalemode       =   3  'pixel
   scalewidth      =   548
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.commandbutton command2 
      caption         =   "guardar y salir"
      height          =   375
      left            =   3960
      tabindex        =   46
      top             =   6000
      width           =   4095
   end
   begin vb.commandbutton command1 
      caption         =   "cargar teclas por defecto"
      height          =   375
      left            =   3960
      tabindex        =   45
      top             =   5520
      width           =   4095
   end
   begin vb.frame frame5 
      backcolor       =   &h00000000&
      caption         =   "otros"
      forecolor       =   &h00ffffff&
      height          =   3855
      left            =   3960
      tabindex        =   4
      top             =   1560
      width           =   4095
      begin vb.textbox text1 
         height          =   285
         index           =   9
         left            =   2280
         tabindex        =   57
         text            =   "text1"
         top             =   2760
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   13
         left            =   2280
         tabindex        =   56
         text            =   "text1"
         top             =   3120
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   14
         left            =   2280
         tabindex        =   55
         text            =   "text1"
         top             =   3480
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   27
         left            =   2280
         tabindex        =   53
         text            =   "text1"
         top             =   2400
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   26
         left            =   2280
         tabindex        =   52
         text            =   "text1"
         top             =   2040
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   21
         left            =   2280
         tabindex        =   48
         text            =   "text1"
         top             =   240
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   25
         left            =   2280
         tabindex        =   44
         text            =   "text1"
         top             =   1680
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   24
         left            =   2280
         tabindex        =   43
         text            =   "text1"
         top             =   1320
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   23
         left            =   2280
         tabindex        =   42
         text            =   "text1"
         top             =   960
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   22
         left            =   2280
         tabindex        =   41
         text            =   "text1"
         top             =   600
         width           =   1695
      end
      begin vb.label label9 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "modo combate"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   960
         tabindex        =   60
         top             =   2760
         width           =   1215
      end
      begin vb.label label13 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "modo seguro"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   960
         tabindex        =   59
         top             =   3120
         width           =   1215
      end
      begin vb.label label26 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "seg. de resucitaci�n"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   58
         top             =   3480
         width           =   1695
      end
      begin vb.label label27 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "salir"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   54
         top             =   2400
         width           =   1695
      end
      begin vb.label label25 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "capturar pantalla"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   47
         top             =   600
         width           =   1695
      end
      begin vb.label label24 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "macro trabajo"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   40
         top             =   2040
         width           =   1695
      end
      begin vb.label label23 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "macro hechizos"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   39
         top             =   1680
         width           =   1695
      end
      begin vb.label label22 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "meditar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   38
         top             =   1320
         width           =   1695
      end
      begin vb.label label21 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "mostrar opciones"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   37
         top             =   960
         width           =   1695
      end
      begin vb.label label20 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "mostrar/ocultar fps"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   480
         tabindex        =   36
         top             =   240
         width           =   1695
      end
   end
   begin vb.frame frame4 
      backcolor       =   &h00000000&
      caption         =   "hablar"
      forecolor       =   &h00ffffff&
      height          =   975
      left            =   120
      tabindex        =   3
      top             =   5160
      width           =   3735
      begin vb.textbox text1 
         height          =   285
         index           =   20
         left            =   1920
         tabindex        =   51
         text            =   "text1"
         top             =   600
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   19
         left            =   1920
         tabindex        =   35
         text            =   "text1"
         top             =   240
         width           =   1695
      end
      begin vb.label label19 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "hablar al clan"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   34
         top             =   600
         width           =   1215
      end
      begin vb.label label18 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "hablar a todos"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   33
         top             =   240
         width           =   1215
      end
   end
   begin vb.frame frame3 
      backcolor       =   &h00000000&
      caption         =   "acciones"
      forecolor       =   &h00ffffff&
      height          =   3135
      left            =   120
      tabindex        =   2
      top             =   1920
      width           =   3735
      begin vb.textbox text1 
         height          =   285
         index           =   18
         left            =   1920
         tabindex        =   50
         text            =   "text1"
         top             =   2760
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   17
         left            =   1920
         tabindex        =   32
         text            =   "text1"
         top             =   2400
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   16
         left            =   1920
         tabindex        =   31
         text            =   "text1"
         top             =   2040
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   15
         left            =   1920
         tabindex        =   30
         text            =   "text1"
         top             =   1680
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   12
         left            =   1920
         tabindex        =   29
         text            =   "text1"
         top             =   1320
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   11
         left            =   1920
         tabindex        =   28
         text            =   "text1"
         top             =   960
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   10
         left            =   1920
         tabindex        =   27
         text            =   "text1"
         top             =   600
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   8
         left            =   1920
         tabindex        =   26
         text            =   "text1"
         top             =   240
         width           =   1695
      end
      begin vb.label label17 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "atacar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   25
         top             =   2760
         width           =   1215
      end
      begin vb.label label16 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "usar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   24
         top             =   2400
         width           =   1215
      end
      begin vb.label label15 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "tirar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   23
         top             =   2040
         width           =   1215
      end
      begin vb.label label14 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "ocultar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   22
         top             =   1680
         width           =   1215
      end
      begin vb.label label12 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "robar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   21
         top             =   1320
         width           =   1215
      end
      begin vb.label label11 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "domar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   20
         top             =   960
         width           =   1215
      end
      begin vb.label label10 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "equipar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   19
         top             =   600
         width           =   1215
      end
      begin vb.label label8 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "agarrar"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   18
         top             =   240
         width           =   1215
      end
   end
   begin vb.frame frame2 
      backcolor       =   &h00000000&
      caption         =   "opciones personales"
      forecolor       =   &h00ffffff&
      height          =   1335
      left            =   3960
      tabindex        =   1
      top             =   120
      width           =   4095
      begin vb.textbox text1 
         height          =   285
         index           =   5
         left            =   2280
         tabindex        =   49
         text            =   "text1"
         top             =   240
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   7
         left            =   2280
         tabindex        =   17
         text            =   "text1"
         top             =   960
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   6
         left            =   2280
         tabindex        =   16
         text            =   "text1"
         top             =   600
         width           =   1695
      end
      begin vb.label label7 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "mostrar/ocultar nombres"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   120
         tabindex        =   11
         top             =   960
         width           =   2055
      end
      begin vb.label label6 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "corregir posicion"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   120
         tabindex        =   10
         top             =   600
         width           =   2055
      end
      begin vb.label label5 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "activar/desactivar musica"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   120
         tabindex        =   9
         top             =   240
         width           =   2055
      end
   end
   begin vb.frame frame1 
      backcolor       =   &h00000000&
      caption         =   "movimiento"
      forecolor       =   &h00ffffff&
      height          =   1695
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   3735
      begin vb.textbox text1 
         height          =   285
         index           =   4
         left            =   1920
         tabindex        =   15
         text            =   "text1"
         top             =   1320
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   3
         left            =   1920
         tabindex        =   14
         text            =   "text1"
         top             =   960
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   2
         left            =   1920
         tabindex        =   13
         text            =   "text1"
         top             =   600
         width           =   1695
      end
      begin vb.textbox text1 
         height          =   285
         index           =   1
         left            =   1920
         tabindex        =   12
         text            =   "text1"
         top             =   240
         width           =   1695
      end
      begin vb.label label4 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "derecha"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   8
         top             =   1320
         width           =   1215
      end
      begin vb.label label3 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "izquierda"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   7
         top             =   960
         width           =   1215
      end
      begin vb.label label2 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "abajo"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   6
         top             =   600
         width           =   1215
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         backcolor       =   &h00000000&
         caption         =   "arriba"
         forecolor       =   &h00ffffff&
         height          =   255
         left            =   600
         tabindex        =   5
         top             =   240
         width           =   1215
      end
   end
end
attribute vb_name = "frmcustomkeys"
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

''
'frmcustomkeys - allows the user to customize keys.
'implements class clscustomkeys
'
'@author rapsodius
'@date 20070805
'@version 1.0.0
'@see clscustomkeys

option explicit

private sub command1_click()
call customkeys.loaddefaults
dim i as long

for i = 1 to customkeys.count
    text1(i).text = customkeys.readablename(customkeys.bindedkey(i))
next i
end sub

private sub command2_click()

dim i as long

for i = 1 to customkeys.count
    if lenb(text1(i).text) = 0 then
        call msgbox("hay una o mas teclas no validas, por favor verifique.", vbcritical or vbokonly or vbapplicationmodal or vbdefaultbutton1, "argentum online")
        exit sub
    end if
next i

unload me
end sub

private sub form_load()
    dim i as long
    
    for i = 1 to customkeys.count
        text1(i).text = customkeys.readablename(customkeys.bindedkey(i))
    next i
end sub

private sub text1_keydown(index as integer, keycode as integer, shift as integer)
    dim i as long
    
    if lenb(customkeys.readablename(keycode)) = 0 then exit sub
    'if key is not valid, we exit
    
    text1(index).text = customkeys.readablename(keycode)
    text1(index).selstart = len(text1(index).text)
    
    for i = 1 to customkeys.count
        if i <> index then
            if customkeys.bindedkey(i) = keycode then
                text1(index).text = "" 'if the key is already assigned, simply reject it
                call beep 'alert the user
                keycode = 0
                exit sub
            end if
        end if
    next i
    
    customkeys.bindedkey(index) = keycode
end sub

private sub text1_keypress(index as integer, keyascii as integer)
keyascii = 0
end sub

private sub text1_keyup(index as integer, keycode as integer, shift as integer)
call text1_keydown(index, keycode, shift)
end sub
