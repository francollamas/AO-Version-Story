version 5.00
begin vb.form frmpeaceprop 
   borderstyle     =   1  'fixed single
   caption         =   "ofertas de paz"
   clientheight    =   2895
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4980
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
   scaleheight     =   2895
   scalewidth      =   4980
   startupposition =   1  'centerowner
   begin vb.commandbutton command4 
      caption         =   "rechazar"
      height          =   495
      left            =   3720
      mouseicon       =   "frmpeaceprop.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   4
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton command3 
      caption         =   "aceptar"
      height          =   495
      left            =   2520
      mouseicon       =   "frmpeaceprop.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton command2 
      caption         =   "detalles"
      height          =   495
      left            =   1320
      mouseicon       =   "frmpeaceprop.frx":02a4
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "cerrar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   495
      left            =   120
      mouseicon       =   "frmpeaceprop.frx":03f6
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   2280
      width           =   975
   end
   begin vb.listbox lista 
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2010
      itemdata        =   "frmpeaceprop.frx":0548
      left            =   120
      list            =   "frmpeaceprop.frx":054a
      tabindex        =   0
      top             =   120
      width           =   4695
   end
end
attribute vb_name = "frmpeaceprop"
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

private tipoprop as tipo_propuesta
private enum tipo_propuesta
    alianza = 1
    paz = 2
end enum



private sub command1_click()
unload me
end sub

public sub parsepeaceoffers(byval s as string)

dim t%, r%

t% = val(readfield(1, s, 44))

for r% = 1 to t%
    call lista.additem(readfield(r% + 1, s, 44))
next r%


tipoprop = paz

me.show vbmodeless, frmmain

end sub

public sub parseallieoffers(byval s as string)

dim t%, r%

t% = val(readfield(1, s, 44))

for r% = 1 to t%
    call lista.additem(readfield(r% + 1, s, 44))
next r%

tipoprop = alianza
me.show vbmodeless, frmmain

end sub

private sub command2_click()
'me.visible = false
if tipoprop = paz then
    call senddata("peacedet" & lista.list(lista.listindex))
else
    call senddata("alliedet" & lista.list(lista.listindex))
end if
end sub

private sub command3_click()
'me.visible = false
if tipoprop = paz then
    call senddata("aceppeat" & lista.list(lista.listindex))
else
    call senddata("acepalia" & lista.list(lista.listindex))
end if
me.hide
unload me
end sub

private sub command4_click()
if tipoprop = paz then
    call senddata("recppeat" & lista.list(lista.listindex))
else
    call senddata("recpalia" & lista.list(lista.listindex))
end if
me.hide
unload me
end sub
