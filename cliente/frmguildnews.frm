version 5.00
begin vb.form frmguildnews 
   borderstyle     =   1  'fixed single
   caption         =   "guildnews"
   clientheight    =   6315
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4935
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   6315
   scalewidth      =   4935
   startupposition =   1  'centerowner
   begin vb.frame frame3 
      caption         =   "clanes aliados"
      height          =   1455
      left            =   120
      tabindex        =   5
      top             =   4320
      width           =   4575
      begin vb.listbox aliados 
         height          =   1035
         itemdata        =   "frmguildnews.frx":0000
         left            =   120
         list            =   "frmguildnews.frx":0002
         tabindex        =   6
         top             =   240
         width           =   4335
      end
   end
   begin vb.frame frame2 
      caption         =   "clanes con los que estamos en guerra"
      height          =   1455
      left            =   120
      tabindex        =   3
      top             =   2760
      width           =   4575
      begin vb.listbox guerra 
         height          =   1035
         itemdata        =   "frmguildnews.frx":0004
         left            =   120
         list            =   "frmguildnews.frx":0006
         tabindex        =   4
         top             =   240
         width           =   4335
      end
   end
   begin vb.frame frame1 
      caption         =   "guildnews"
      height          =   2535
      left            =   120
      tabindex        =   1
      top             =   120
      width           =   4575
      begin vb.textbox news 
         height          =   2175
         left            =   120
         multiline       =   -1  'true
         tabindex        =   2
         top             =   240
         width           =   4335
      end
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "aceptar"
      height          =   375
      left            =   240
      mouseicon       =   "frmguildnews.frx":0008
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   5880
      width           =   4335
   end
end
attribute vb_name = "frmguildnews"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
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
on error resume next
unload me
frmmain.setfocus
end sub

public sub parseguildnews(byval s as string)

news = replace(readfield(1, s, asc("�")), "�", vbcrlf)

dim h%, j%

h% = val(readfield(2, s, asc("�")))

for j% = 1 to h%
    
    guerra.additem readfield(j% + 2, s, asc("�"))
    
next j%

j% = j% + 2

h% = val(readfield(j%, s, asc("�")))

for j% = j% + 1 to j% + h%
    
    aliados.additem readfield(j%, s, asc("�"))
    
next j%

me.show , frmmain

end sub

