version 5.00
begin vb.form frmmenusefashion 
   borderstyle     =   3  'fixed dialog
   clientheight    =   1845
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   1410
   controlbox      =   0   'false
   linktopic       =   "form2"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   1845
   scalewidth      =   1410
   showintaskbar   =   0   'false
   startupposition =   3  'windows default
   begin vb.label label2 
      backcolor       =   &h8000000d&
      caption         =   "label2"
      forecolor       =   &h80000014&
      height          =   255
      index           =   1
      left            =   540
      tabindex        =   2
      top             =   900
      visible         =   0   'false
      width           =   195
   end
   begin vb.label label2 
      autosize        =   -1  'true
      backcolor       =   &h8000000d&
      caption         =   "label2"
      height          =   195
      index           =   0
      left            =   540
      tabindex        =   1
      top             =   660
      visible         =   0   'false
      width           =   480
   end
   begin vb.label label1 
      backcolor       =   &h8000000d&
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "arial"
         size            =   9.75
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      index           =   0
      left            =   0
      tabindex        =   0
      top             =   0
      width           =   1395
   end
end
attribute vb_name = "frmmenusefashion"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
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


'super menuse fashion
'creado por alejandro "alejolp" santos
'
'util para evitar el bloqueo de la linea de ejecion
'normal de un programa, caso caracteristico al usar
'los menuses estandar de windows.
'

option explicit

#if (conmenuseconextuales = 1) then

''** funcion callback **''

''public sub callbackmenufashion(byval menuid as long, byval sel as long)
''
''end sub


''** codigo de ejemplo de uso **''

''dim i as long
''dim m as new frmmenusefashion
''
''load m
''m.setcallback me
''m.setmenuid 12
''m.listainit 3, false
''for i = 0 to 2
''    m.listasetitem i, "hgfsg " & i
''next i
''m.listafin
''m.show , me

private type tmenuelemento
    texto as string
    bold as boolean
end type

private type pointapi
    x as long
    y as long
end type

private declare function getcursorpos lib "user32" (lppoint as pointapi) as long

dim difx as long, dify as long
dim ultpos as long
dim callback as object
dim menuid as long
dim elementos() as tmenuelemento
dim mcantidad as long
dim maxancho as long, maxalto as long

dim yacargado as long

private sub form_activate()
if me.left + me.width > screen.width then me.left = screen.width - me.width
if me.top + me.height > screen.height then me.top = screen.height - me.height
end sub

private sub form_deactivate()
unload me
end sub

private sub form_load()
dim p as pointapi
dim i as long

'puajjjj :p shhh... nadie me ve ^_^
if yacargado <> 89345 then
    yacargado = 89345

    call getcursorpos(p)
    me.left = p.x * screen.twipsperpixelx
    me.top = p.y * screen.twipsperpixely
    
    
    difx = me.width - me.scalewidth
    dify = me.height - me.scaleheight
    
    maxancho = 0
    ultpos = -1
    redim elementos(0 to 0)
    
    label2(0).font = label1(0).font
    
end if

end sub

private sub form_lostfocus()
unload me
end sub

private sub label1_click(index as integer)
me.hide

on local error resume next
    call callback.callbackmenufashion(menuid, index)
on local error goto 0

unload me

end sub

private sub label1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
if ultpos <> index then
    if ultpos <> -1 then
        label1(ultpos).backstyle = 0
        label1(ultpos).forecolor = label2(0).forecolor
    end if
    label1(index).backstyle = 1
    label1(index).forecolor = label2(1).forecolor
    ultpos = index
end if

end sub

public sub setmenuid(byval meid as long)
menuid = meid
end sub

public sub listainit(byval cantidad as long, optional byval mantener as boolean = false)
if cantidad >= 1 then
    mcantidad = cantidad
    if mantener = false then
        redim elementos(0 to cantidad - 1)
    else 'true
        redim preserve elementos(0 to cantidad - 1)
    end if
end if
end sub

public sub listasetitem(byval n as long, byval texto as string, optional byval bold as boolean = false)
if n >= lbound(elementos) and n <= ubound(elementos) then
    elementos(n).texto = texto
    elementos(n).bold = bold
    with label1(0)
        .autosize = true
        .fontbold = bold
        .caption = texto
        if .width > maxancho then maxancho = .width
        if .height > maxalto then maxalto = .height
        .autosize = false
    end with
end if
end sub

public sub listafin()
dim i as long

maxancho = maxancho + 2 * screen.twipsperpixelx
maxalto = maxalto + 2 * screen.twipsperpixelx

for i = 0 to mcantidad - 1
    if i <> 0 then
        load label1(i)
    end if
    
    label1(i).visible = true
    label1(i).left = 0
    label1(i).width = maxancho
    label1(i).height = maxalto
    label1(i).top = i * maxalto
    label1(i).caption = elementos(i).texto
    label1(i).fontbold = elementos(i).bold
    label1(i).backstyle = 0
    label1(i).backcolor = label1(0).backcolor
next i

me.height = (ubound(elementos) - lbound(elementos) + 1) * label1(0).height + dify
me.width = maxancho + difx

end sub

public sub setcallback(c as object)
set callback = c
end sub

#end if
