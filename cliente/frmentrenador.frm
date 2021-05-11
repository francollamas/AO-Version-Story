version 5.00
begin vb.form frmentrenador 
   borderstyle     =   1  'fixed single
   caption         =   "seleccione la criatura"
   clientheight    =   3705
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4230
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
   scaleheight     =   3705
   scalewidth      =   4230
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
      caption         =   "salir"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   2460
      mouseicon       =   "frmentrenador.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   3000
      width           =   870
   end
   begin vb.commandbutton command1 
      caption         =   "luchar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   390
      left            =   780
      mouseicon       =   "frmentrenador.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   3000
      width           =   1710
   end
   begin vb.listbox lstcriaturas 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2400
      left            =   780
      tabindex        =   1
      top             =   540
      width           =   2490
   end
   begin vb.label label1 
      alignment       =   2  'center
      autosize        =   -1  'true
      caption         =   "�con qu� criatura deseas combatir?"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   240
      left            =   375
      tabindex        =   0
      top             =   105
      width           =   3525
   end
end
attribute vb_name = "frmentrenador"
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



'[code]:matux
'
'    le puse el iconito de la manito a los botones ^_^,
'   le puse borde a la ventana y le cambi� la letra a
'   una m�s linda :)
'
'[end]'

option explicit

private sub command1_click()
    call writetrain(lstcriaturas.listindex + 1)
    unload me
end sub

private sub command2_click()
    unload me
end sub
