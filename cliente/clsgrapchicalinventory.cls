version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsgrapchicalinventory"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'*****************************************************
'graphical inventory for ore 0.4.1
'designed and implemented by juan mart�n sotuyo dodero (maraxus)
'juansotuyo@hotmail.com
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
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

option explicit

dim inventoryoffset as long             'number of lines we scrolled down from topmost
dim invselecteditem as long             'currently selected item

dim invsurface as directdrawsurface7            'dd surface used to render everything

dim userinventory(1 to max_inventory_slots) as inventory    'user's inventory

dim withevents inventorywindow as picturebox    'placeholder where to render the inventory
attribute inventorywindow.vb_varhelpid = -1

#if conmenuesconextuales = 1 then
    dim itemmenu as menu    'menu to be shown as pop up
#end if

private sub class_initialize()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'
'***************************************************
end sub

private sub class_terminate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'
'***************************************************
end sub

public sub scrollinventory(byval up as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'scrolls the graphical inventory up / down
'***************************************************
    'only move if there is something to show up /down
    if up then
        if (inventoryoffset + (inventorywindow.scaleheight \ tilepixelheight)) * (inventorywindow.scalewidth \ tilepixelwidth) < max_inventory_slots then _
            inventoryoffset = inventoryoffset + 1
    else
        if inventoryoffset > 0 then _
            inventoryoffset = inventoryoffset - 1
    end if
    
    'redraw the inventory
    drawinventory
end sub

public sub selectgold()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'sets the gold as the currently selected item
'***************************************************
    dim prevselecteditem as long
    
    'store preivously selected item
    prevselecteditem = invselecteditem
    
    'select the gold
    invselecteditem = flagoro
    
    'redraw old item to deselect it
    if prevselecteditem <> flagoro then
        call drawinventoryslot(prevselecteditem)
    end if
end sub

public property get selecteditem() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item index
'***************************************************
    selecteditem = invselecteditem
end property

public property get maxhit(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the max hit of the selected item
'***************************************************
    maxhit = userinventory(slot).maxhit
end property

public property get minhit(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the min hit of the selected item
'***************************************************
    minhit = userinventory(slot).minhit
end property

public property get def(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the defense of the selected item
'***************************************************
    def = userinventory(slot).def
end property

public property get grhindex(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the grh index of the selected item
'***************************************************
    grhindex = userinventory(slot).grhindex
end property

public property get valor(byval slot as byte) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the value of the selected item
'***************************************************
    valor = userinventory(slot).valor
end property

public property get amount(byval slot as byte) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's amount
'***************************************************
    amount = userinventory(slot).amount
end property

public property get objindex(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's object index
'***************************************************
    objindex = userinventory(slot).objindex
end property

public property get objtype(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's object type
'***************************************************
    objtype = userinventory(slot).objtype
end property

public property get itemname(byval slot as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's name
'***************************************************
    itemname = userinventory(slot).name
end property

public property get equipped(byval slot as byte) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves true if the item at the given pos is eqiupped
'***************************************************
    equipped = userinventory(slot).equipped
end property

public sub setitem(byval slot as byte, byval eobjindex as integer, byval eamount as integer, byval eequipped as byte, _
                        byval egrhindex as integer, byval eobjtype as integer, byval emaxhit as integer, byval eminhit as integer, _
                        byval edef as integer, byval evalor as long, byval ename as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/04/06
'sets all data for a given inventory slot
'***************************************************
    if slot < 1 or slot > max_inventory_slots then exit sub
    
    with userinventory(slot)
        .amount = eamount
        .def = edef
        .equipped = eequipped
        .grhindex = egrhindex
        .maxhit = emaxhit
        .minhit = eminhit
        .name = ename
        .objindex = eobjindex
        .objtype = eobjtype
        .valor = evalor
    end with
    
    'render inventory slot (we don't need to render the whole inventory)
    call drawinventoryslot(slot)
end sub

private function clickitem(byval x as long, byval y as long) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'selects the item clicked if it's valid and return's it's index
'***************************************************
    dim tempitem as long
    dim temp_x as long
    dim temp_y as long
    
    temp_x = x \ tilepixelwidth
    temp_y = y \ tilepixelheight
    
    tempitem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ tilepixelwidth) + 1
    
    'make sure it's within limits
    if tempitem <= max_inventory_slots then
        'make sure slot isn't empty
        if userinventory(tempitem).grhindex then
            clickitem = tempitem
        else
            clickitem = 0
        end if
    end if
end function

private sub drawinventory()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'renders the inventory to the given picturebox
'***************************************************
    dim loopc as long
    dim srcrect as rect
    dim temprect as rect
    dim destrect as rect
    
    with temprect
        .bottom = tilepixelheight
        .right = tilepixelwidth
    end with
    
    destrect = temprect
    
    'clear the inventory window
    inventorywindow.cls
    
    for loopc = inventoryoffset * (inventorywindow.scalewidth \ tilepixelwidth) + 1 to ubound(userinventory)
        'clear the slot area
        call invsurface.bltcolorfill(temprect, inventorywindow.backcolor)
        
        if userinventory(loopc).grhindex then
            'get source rect
            with srcrect
                .left = grhdata(userinventory(loopc).grhindex).sx
                .top = grhdata(userinventory(loopc).grhindex).sy
                .right = .left + tilepixelwidth
                .bottom = .top + tilepixelheight
            end with
            
            'render the item grh and the amount
            invsurface.setforecolor vbwhite
            invsurface.bltfast 0, 0, surfacedb.surface(grhdata(userinventory(loopc).grhindex).filenum), srcrect, ddbltfast_wait or ddbltfast_nocolorkey
            invsurface.drawtext 0, 0, userinventory(loopc).amount, false
            
            'if equipped we render "e"
            if userinventory(loopc).equipped then
                invsurface.setforecolor vbyellow
                invsurface.drawtext 20, 20, "e", false
            end if
            
            'render a box around the selected item
            if invselecteditem = loopc then
                invsurface.setforecolor vbgreen
                invsurface.setdrawstyle drawstyleconstants.vbdot
                invsurface.drawbox 0, 0, tilepixelwidth, tilepixelheight
            end if
        end if
        
        'render the item to the inventory window
        call invsurface.blttodc(inventorywindow.hdc, temprect, destrect)
        
        call inventorywindow.refresh
        
        with destrect
            'check if we have reached the right end of the inventory picturebox
            if .left = (inventorywindow.scalewidth - (inventorywindow.scalewidth mod tilepixelwidth) - tilepixelwidth) then
                .left = 0
                .right = tilepixelwidth
                .bottom = .bottom + tilepixelheight
                .top = .top + tilepixelheight
            else
                .left = .left + tilepixelwidth
                .right = .right + tilepixelwidth
            end if
        end with
    next loopc
end sub

private sub drawinventoryslot(byval slot as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/04/06
'renders a inventory slot to the given picturebox
'***************************************************
    dim loopc as long
    dim srcrect as rect
    dim temprect as rect
    dim destrect as rect
    
    with temprect
        .bottom = tilepixelheight
        .right = tilepixelwidth
    end with
    
    dim upperleftslot as integer
    upperleftslot = inventoryoffset * (inventorywindow.scalewidth \ tilepixelwidth) + 1
    
    'if not in renderable area we exit
    if slot < upperleftslot then exit sub
    
    with destrect
        .top = ((slot - upperleftslot) \ (inventorywindow.scalewidth \ tilepixelwidth)) * tilepixelheight
        .left = ((slot - 1) mod (inventorywindow.scalewidth \ tilepixelwidth)) * tilepixelwidth
        .bottom = .top + tilepixelheight
        .right = .left + tilepixelwidth
    end with
    
    'clear the slot area
    call invsurface.bltcolorfill(temprect, inventorywindow.backcolor)
    
    if userinventory(slot).grhindex then
        'get source rect
        with srcrect
            .left = grhdata(userinventory(slot).grhindex).sx
            .top = grhdata(userinventory(slot).grhindex).sy
            .right = .left + tilepixelwidth
            .bottom = .top + tilepixelheight
        end with
        
        'render the item grh and the amount
        invsurface.setforecolor vbwhite
        invsurface.bltfast 0, 0, surfacedb.surface(clng(grhdata(userinventory(slot).grhindex).filenum)), srcrect, ddbltfast_wait or ddbltfast_nocolorkey
        invsurface.drawtext 0, 0, userinventory(slot).amount, false
        
        'if equipped we render "e"
        if userinventory(slot).equipped then
            invsurface.setforecolor vbyellow
            invsurface.drawtext 20, 20, "e", false
        end if
        
        'render a box around the selected item
        if invselecteditem = slot then
            invsurface.setforecolor vbgreen
            invsurface.setdrawstyle drawstyleconstants.vbdot
            invsurface.drawbox 0, 0, tilepixelwidth, tilepixelheight
        end if
    end if
    
    'render the item to the inventory window
    invsurface.blttodc inventorywindow.hdc, temprect, destrect
    
    call inventorywindow.refresh
end sub

#if conmenuesconextuales = 1 then   'argument list varies!!!
    public sub initialize(byref directdraw as directdraw7, byref invpic as picturebox, byref popupmenu as menu)
#else   'argument list varies!!!
    public sub initialize(byref directdraw as directdraw7, byref invpic as picturebox)
#end if
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'sets the reference to the picture box on which to render the inventory
'***************************************************
    set inventorywindow = invpic
    
    'make sure auto-redraw is set to true
    inventorywindow.autoredraw = true
    
    'set apropiate scale (pixel)
    inventorywindow.scalemode = 3
    
    'initialize dx stuff
    dim surfacedesc as ddsurfacedesc2
    
    'make sure directdraw was correctly initialized
    if directdraw is nothing then exit sub
    
    'set surface's description
    with surfacedesc
        .lflags = ddsd_caps or ddsd_height or ddsd_width
        .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
        .lheight = tilepixelheight
        .lwidth = tilepixelwidth
    end with

    'create inventory surface
    set invsurface = directdraw.createsurface(surfacedesc)
    
    'prepare surfaces for text rendering
    invsurface.setfonttransparency true
'todo : fonts should be in a separate class / collection
    dim font as new stdfont
    dim ifnt as ifont
    
    font.name = "verdana"
    font.bold = true
    font.italic = false
    font.size = 7
    font.underline = false
    font.strikethrough = false
    
    set ifnt = font
    
    invsurface.setfont ifnt
'\todo
    
    invselecteditem = clickitem(1, 1)   'if there is anything there we select the top left item
    
#if conmenuesconextuales = 1 then
    set itemmenu = popupmenu
#end if
end sub

private sub inventorywindow_mousemove(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'implements the mouse move event of the inventory picture box
'displays a tooltip of the item under the mouse
'***************************************************
    dim temp_x as integer
    dim temp_y as integer
    dim tempitem as integer
    
    temp_x = x \ tilepixelwidth
    temp_y = y \ tilepixelheight
    
    tempitem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ tilepixelwidth) + 1
    
    if tempitem <= max_inventory_slots then
        inventorywindow.tooltiptext = userinventory(tempitem).name
    end if
end sub

private sub inventorywindow_mouseup(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'implements the mouse up event of the inventory picture box
'check outs which item was clicked
'***************************************************
    'store previously selected item
    dim prevselitem as long
    
    prevselitem = invselecteditem

    'get the currently clickced item
    invselecteditem = clickitem(cint(x), cint(y))
    
    'update needed inventory slots
    if prevselitem <> invselecteditem then
        if prevselitem <> 0 and prevselitem <> flagoro then call drawinventoryslot(prevselitem)
        if invselecteditem then call drawinventoryslot(invselecteditem)
    end if
    
#if conmenuesconextuales = 1 then
    'if it was a right click on the same item we had selected before, show popup menu
    if button = vbrightbutton and prevselitem = invselecteditem then
        'show the provided menu as a popup
        call inventorywindow.parent.popupmenu(itemmenu, , x, y)
    end if
#end if
end sub
