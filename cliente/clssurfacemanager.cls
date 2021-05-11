version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clssurfacemanager"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clssurfacemanager.cls - interface for surface managfers regardless of wether
' they use dinamic loading or not.
'
' developed by maraxus (juan mart�n sotuyo dodero - juansotuyo@hotmail.com)
' last modify date: 3/06/2006
'**************************************************************

'**************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'
'argentum online is based on baronsoft's vb6 online rpg
'you can contact the original creator of ore at aaron@baronsoft.com
'for more information about ore please visit http://www.baronsoft.com/
'**************************************************************

option explicit

'this is just an interface, no instances should be created!!!

'only public methods are included since vb won't inherit private ones

public property get surface(byval fileindex as long) as directdrawsurface7
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'used to return a texture
'**************************************************************
end property

public sub initialize(byref dd as directdraw7, byval videomemory as boolean, byval graphicpath as string, optional byval maxmemoryusageinmb as long = -1)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'initializes the object (the dd object is needed to load surfaces)
'**************************************************************
end sub
