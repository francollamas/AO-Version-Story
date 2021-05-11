version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsformmovementmanager"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'*****************************************************
'form movement manager
'designed and implemented by zama
'zaxtor@gmail.com
'*****************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'(at your option) any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************
option explicit

dim withevents formulario as form
attribute formulario.vb_varhelpid = -1

private dragx as single
private dragy as single

private limity as integer

public sub initialize(byref tform as form, optional byval verticallimit as integer = 0)
'***************************************************
'author: zama
'last modify date: 29/12/09
'sets the reference to the form
'***************************************************
    set formulario = tform
    
    limity = verticallimit
end sub

private sub formulario_mousedown(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: zama
'last modify date: 29/12/09
'implements the mouse down event of the form.
'***************************************************
    if limity > 0 then
        if y > limity then exit sub
    end if

    dragx = x
    dragy = y
end sub

private sub formulario_mousemove(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: zama
'last modify date: 01/07/10
'implements the mouse move event of the form.
'***************************************************
    if limity > 0 then
        if y > limity then exit sub
    end if
    
    if button > 0 then
        formulario.left = formulario.left + (x - dragx)
        formulario.top = formulario.top + (y - dragy)
    end if
end sub
