version 5.00
begin vb.form frmguildadm 
   borderstyle     =   1  'fixed single
   caption         =   "lista de clanes registrados"
   clientheight    =   3390
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4065
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
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3390
   scalewidth      =   4065
   startupposition =   1  'centerowner
   begin vb.commandbutton command3 
      cancel          =   -1  'true
      caption         =   "cancelar"
      height          =   375
      left            =   120
      mouseicon       =   "frmguildadm.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   4
      top             =   2880
      width           =   855
   end
   begin vb.commandbutton command2 
      caption         =   "solicitar ingreso"
      height          =   375
      left            =   1080
      mouseicon       =   "frmguildadm.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   2880
      visible         =   0   'false
      width           =   1455
   end
   begin vb.commandbutton command1 
      caption         =   "detalles"
      height          =   375
      left            =   2640
      mouseicon       =   "frmguildadm.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2880
      width           =   1335
   end
   begin vb.frame frame1 
      caption         =   "clanes"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2655
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   3855
      begin vb.listbox guildslist 
         height          =   2010
         itemdata        =   "frmguildadm.frx":03f6
         left            =   240
         list            =   "frmguildadm.frx":03f8
         tabindex        =   1
         top             =   360
         width           =   3255
      end
   end
end
attribute vb_name = "frmguildadm"
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

private sub command1_click()
    frmguildbrief.esleader = false
    call writeguildrequestdetails(guildslist.list(guildslist.listindex))
end sub

private sub command3_click()
    unload me
end sub
