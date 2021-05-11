version 5.00
begin vb.form frmdebugsocket 
   caption         =   "debug socket"
   clientheight    =   6330
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   3945
   linktopic       =   "form1"
   scaleheight     =   6330
   scalewidth      =   3945
   startupposition =   3  'windows default
   begin vb.commandbutton command4 
      caption         =   "reload socket"
      height          =   255
      left            =   120
      tabindex        =   4
      top             =   6000
      width           =   3735
   end
   begin vb.frame frame1 
      caption         =   "state"
      height          =   765
      left            =   165
      tabindex        =   8
      top             =   4350
      width           =   3705
      begin vb.label label3 
         autosize        =   -1  'true
         caption         =   "estado."
         height          =   195
         left            =   195
         tabindex        =   9
         top             =   315
         width           =   540
      end
   end
   begin vb.textbox text2 
      height          =   1455
      left            =   165
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   6
      top             =   2835
      width           =   3690
   end
   begin vb.textbox text1 
      height          =   2280
      left            =   165
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   0
      top             =   225
      width           =   3690
   end
   begin vb.commandbutton command1 
      caption         =   "cerrar"
      height          =   255
      left            =   120
      tabindex        =   1
      top             =   5760
      width           =   3735
   end
   begin vb.commandbutton command2 
      caption         =   "start/stop debug"
      height          =   255
      left            =   120
      tabindex        =   2
      top             =   5520
      width           =   3735
   end
   begin vb.commandbutton command3 
      caption         =   "reset"
      height          =   255
      left            =   120
      tabindex        =   3
      top             =   5280
      width           =   3735
   end
   begin vb.label label2 
      caption         =   "errores:"
      height          =   315
      left            =   150
      tabindex        =   7
      top             =   2610
      width           =   2685
   end
   begin vb.label label1 
      caption         =   "requests"
      height          =   315
      left            =   195
      tabindex        =   5
      top             =   15
      width           =   2685
   end
end
attribute vb_name = "frmdebugsocket"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.2
'copyright (c) 2002 m�rquez pablo ignacio
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



private sub command1_click()
me.visible = false
end sub

private sub command2_click()
debugsocket = not debugsocket
end sub

private sub command3_click()
text1.text = ""
end sub

private sub command4_click()
call reloadsokcet
end sub

