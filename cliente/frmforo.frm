version 5.00
begin vb.form frmforo 
   backcolor       =   &h00404080&
   borderstyle     =   3  'fixed dialog
   clientheight    =   6855
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   6150
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   6855
   scalewidth      =   6150
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.commandbutton command3 
      backcolor       =   &h000000c0&
      caption         =   "lista de mensajes"
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
      left            =   2205
      mouseicon       =   "frmforo.frx":0000
      mousepointer    =   99  'custom
      style           =   1  'graphical
      tabindex        =   8
      top             =   6330
      width           =   1560
   end
   begin vb.textbox mimensaje 
      backcolor       =   &h00000000&
      forecolor       =   &h80000005&
      height          =   5070
      index           =   1
      left            =   330
      multiline       =   -1  'true
      tabindex        =   5
      top             =   1005
      visible         =   0   'false
      width           =   5400
   end
   begin vb.textbox mimensaje 
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h80000005&
      height          =   345
      index           =   0
      left            =   330
      tabindex        =   4
      top             =   285
      visible         =   0   'false
      width           =   5400
   end
   begin vb.commandbutton command2 
      backcolor       =   &h000000c0&
      caption         =   "cerrar"
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
      left            =   4200
      mouseicon       =   "frmforo.frx":0152
      mousepointer    =   99  'custom
      style           =   1  'graphical
      tabindex        =   3
      top             =   6330
      width           =   1560
   end
   begin vb.commandbutton command1 
      backcolor       =   &h000000c0&
      caption         =   "dejar mensaje"
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
      left            =   345
      mouseicon       =   "frmforo.frx":02a4
      mousepointer    =   99  'custom
      style           =   1  'graphical
      tabindex        =   2
      top             =   6330
      width           =   1560
   end
   begin vb.textbox text 
      backcolor       =   &h00000000&
      forecolor       =   &h80000005&
      height          =   5505
      index           =   0
      left            =   330
      locked          =   -1  'true
      multiline       =   -1  'true
      tabindex        =   1
      text            =   "frmforo.frx":03f6
      top             =   285
      visible         =   0   'false
      width           =   5430
   end
   begin vb.listbox list 
      backcolor       =   &h00000000&
      forecolor       =   &h80000005&
      height          =   5520
      left            =   330
      tabindex        =   0
      top             =   285
      width           =   5430
   end
   begin vb.label label2 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "mensaje"
      forecolor       =   &h8000000e&
      height          =   195
      left            =   330
      tabindex        =   7
      top             =   765
      visible         =   0   'false
      width           =   600
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "t�tulo"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h8000000e&
      height          =   195
      left            =   330
      tabindex        =   6
      top             =   45
      visible         =   0   'false
      width           =   480
   end
end
attribute vb_name = "frmforo"
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

public foroindex as integer
private sub command1_click()
dim i
for each i in text
    i.visible = false
next

if not mimensaje(0).visible then
    list.visible = false
    mimensaje(0).visible = true
    mimensaje(1).visible = true
    mimensaje(0).setfocus
    command1.enabled = false
    label1.visible = true
    label2.visible = true
else
    call writeforumpost(mimensaje(0).text, left$(mimensaje(1).text, 450))
    list.additem mimensaje(0).text
    load text(list.listcount)
    text(list.listcount - 1).text = mimensaje(1).text
    list.visible = true
    
    mimensaje(0).visible = false
    mimensaje(1).visible = false
    'limpio los textboxs (niconz) 04/24/08
    mimensaje(0).text = vbnullstring
    mimensaje(1).text = vbnullstring
    
    command1.enabled = true
    label1.visible = false
    label2.visible = false
end if
end sub

private sub command2_click()
unload me
end sub

private sub command3_click()

mimensaje(0).visible = false
mimensaje(1).visible = false
command1.enabled = true
label1.visible = false
label2.visible = false
dim i
for each i in text
    i.visible = false
next
list.visible = true
end sub

private sub form_deactivate()
'me.setfocus
end sub


private sub list_click()
list.visible = false
text(list.listindex).visible = true

end sub

private sub mimensaje_change(index as integer)
if len(mimensaje(0).text) <> 0 and len(mimensaje(1).text) <> 0 then
command1.enabled = true
end if

end sub

