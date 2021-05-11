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
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

option explicit

private inventoryoffset as long             'number of lines we scrolled down from topmost
private invselecteditem as long             'currently selected item

private owntilepixelwidth as integer
private owntilepixelheight as integer
private startdx as integer
private startdy as integer

private showvalue as boolean
private valueformated as boolean

private imgcontainer as boolean

private slotdragged as integer

private draganddropon as boolean

private invsurface as directdrawsurface7            'dd surface used to render everything
private bufferinvsurface as directdrawsurface7

private inventory() as inventory    'user's inventory

private withevents inventorywindow as picturebox    'placeholder where to render the inventory
attribute inventorywindow.vb_varhelpid = -1

public event dragdone(byval originalslot as integer, byval newslot as integer)

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
    set invsurface = nothing
    set bufferinvsurface = nothing
end sub

public sub scrollinventory(byval up as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 14/01/2010
'scrolls the graphical inventory up / down
'14/01/2010: zama - now redraws inventory only if needed
'***************************************************

    'only move if there is something to show up /down
    if canscroll(up) then
        inventoryoffset = inventoryoffset + iif(up, 1, -1)
        
        'redraw the inventory if needed
        drawinventory
    end if

end sub

public function canscroll(byval up as boolean)
'***************************************************
'author: zama
'last modify date: 14/01/2010
'determines wether inventory can be scrolled up / down
'***************************************************
    if up then
        canscroll = (inventoryoffset + (inventorywindow.scaleheight \ owntilepixelheight)) * _
                    (inventorywindow.scalewidth \ owntilepixelwidth) < ubound(inventory)
    else
        canscroll = inventoryoffset > 0
    end if
    
end function

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

public sub deselectitem()
'***************************************************
'author: zama
'last modify date: 30/11/2009
'deselect the currently selected item
'***************************************************
    if invselecteditem = 0 then exit sub
    
    dim clearslot as byte
    
    clearslot = invselecteditem
    
    'select nothing
    invselecteditem = 0
    
    'redraw old item to deselect it
    call drawinventoryslot(clearslot)

end sub

public sub changeslotitemamount(byval slot as byte, byval amount as long)
'***************************************************
'author: zama
'created date: 30/11/2009
'last modify date: 09/12/2009 (budi)
'change the amount of the required item, and update the slot.
'***************************************************
    
    inventory(slot).amount = amount
    
    'update amount
    call drawinventoryslot(slot)

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
    maxhit = inventory(slot).maxhit
end property

public property get minhit(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the min hit of the selected item
'***************************************************
    minhit = inventory(slot).minhit
end property

public property get maxdef(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the defense of the selected item
'***************************************************
    maxdef = inventory(slot).maxdef
end property

public property get mindef(byval slot as byte) as integer
'***************************************************
'author: budi
'last modify date: 02/1209
'retrieves the defense of the selected item
'***************************************************
    mindef = inventory(slot).mindef
end property

public property get grhindex(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the grh index of the selected item
'***************************************************
    grhindex = inventory(slot).grhindex
end property

public property get valor(byval slot as byte) as single
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the value of the selected item
'***************************************************
    valor = inventory(slot).valor
end property

public property get amount(byval slot as byte) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's amount
'***************************************************
    if slot = flagoro then
        amount = usergld
    elseif slot >= lbound(inventory) and slot <= ubound(inventory) then
        amount = inventory(slot).amount
    end if
end property

public property get objindex(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's object index
'***************************************************
    objindex = inventory(slot).objindex
end property

public property get objtype(byval slot as byte) as integer
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's object type
'***************************************************
    objtype = inventory(slot).objtype
end property

public property get itemname(byval slot as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves the selected item's name
'***************************************************
    itemname = inventory(slot).name
end property

public property get equipped(byval slot as byte) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 27/07/04
'retrieves true if the item at the given pos is eqiupped
'***************************************************
    equipped = inventory(slot).equipped
end property

public property get maxobjs() as byte
'***************************************************
'author: torres patricio (pato)
'last modify date: 09/16/09
'retrieves the capacity of the inventory
'***************************************************
    maxobjs = ubound(inventory)
end property

public sub setmaxobjs(byval maxobjs as byte)
'***************************************************
'author: torres patricio (pato)
'last modify date: 09/16/09
'set the capacity of the inventary
'***************************************************
    if ubound(inventory) = maxobjs then exit sub
    
    redim preserve inventory(1 to maxobjs) as inventory
end sub

public sub toggleshowvalue(byval bshow as boolean)
'***************************************************
'author: zama
'last modify date: 11/12
'indicates if the amount of the items in the inventory is shown
'***************************************************
    showvalue = bshow
    
    dim slot as integer
    ' update inventory
    for slot = 1 to me.maxobjs
        drawinventoryslot (slot)
    next slot
end sub

public sub clearallslots()
'***************************************************
'author: zama
'last modify date: 15/03/2011
'clear all slots.
'***************************************************

    dim slot as long
    for slot = 1 to me.maxobjs
        call setitem(slot, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, vbnullstring)
    next slot

end sub

public sub setitem(byval slot as byte, byval eobjindex as integer, byval eamount as long, byval eequipped as byte, _
                        byval egrhindex as integer, byval eobjtype as integer, byval emaxhit as integer, byval eminhit as integer, _
                        byval maxdef as integer, byval mindef as integer, byval evalor as single, byval ename as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/04/06
'sets all data for a given inventory slot
'***************************************************
    if slot < 1 or slot > ubound(inventory) then exit sub
    
    with inventory(slot)
        .amount = eamount
        .maxdef = maxdef
        .mindef = mindef
        .equipped = eequipped
        .grhindex = egrhindex
        .maxhit = emaxhit
        .minhit = eminhit
        .name = ename
        .objindex = eobjindex
        .objtype = eobjtype
        .valor = evalor
    end with
    
    'if inventorywindow.visible = false then inventorywindow.visible = true
    
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
    
    temp_x = x \ owntilepixelwidth
    temp_y = y \ owntilepixelheight
    
    tempitem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
    
    'make sure it's within limits
    if tempitem <= ubound(inventory) then
        'make sure slot isn't empty
        if inventory(tempitem).grhindex then
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
        .bottom = inventorywindow.height
        .right = inventorywindow.width
    end with
    
    with destrect
        .bottom = owntilepixelheight
        .right = owntilepixelwidth
    end with
    
    'clear the inventory window
    inventorywindow.cls
    
    'clear the slot area
    call invsurface.bltcolorfill(temprect, inventorywindow.backcolor)
    
    for loopc = inventoryoffset * (inventorywindow.scalewidth \ owntilepixelwidth) + 1 to ubound(inventory)
    'for loopc = 1 to ubound(inventory)
    
        if inventory(loopc).grhindex then
            'get source rect
            with srcrect
                .left = grhdata(inventory(loopc).grhindex).sx
                .top = grhdata(inventory(loopc).grhindex).sy
                .right = .left + owntilepixelwidth
                .bottom = .top + owntilepixelheight
            end with
            
            'render the item grh and the amount
            invsurface.setforecolor vbwhite
            invsurface.bltfast destrect.left + startdx, destrect.top + startdy, surfacedb.surface(grhdata(inventory(loopc).grhindex).filenum), srcrect, ddbltfast_wait
            invsurface.drawtext destrect.left + startdx / 2, destrect.top + startdy / 2, inventory(loopc).amount, false
            
            'if equipped we render "e"
            if inventory(loopc).equipped then
                invsurface.setforecolor vbyellow
                invsurface.drawtext destrect.left + 20, destrect.top + 20, "e", false
            end if
            
            'render a box around the selected item
            if invselecteditem = loopc then
                if imgcontainer then
                    invsurface.setforecolor vbgreen
                    invsurface.setdrawstyle drawstyleconstants.vbdot
                    invsurface.drawbox destrect.left, destrect.top, destrect.left + owntilepixelwidth, destrect.top + owntilepixelheight
                end if
            end if
        end if
        
        'render the item to the inventory window
        with destrect
            'check if we have reached the right end of the inventory picturebox
            if .left = (inventorywindow.scalewidth - (inventorywindow.scalewidth mod owntilepixelwidth) - owntilepixelwidth) then
                .left = 0
                .right = owntilepixelwidth
                .bottom = .bottom + owntilepixelheight
                .top = .top + owntilepixelheight
            else
                .left = .left + owntilepixelwidth
                .right = .right + owntilepixelwidth
            end if
        end with
    next loopc

    call bufferinvsurface.bltfast(0, 0, invsurface, temprect, ddbltfast_wait)
    call invsurface.blttodc(inventorywindow.hdc, temprect, temprect)
    
    call inventorywindow.refresh
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
    
    'exit if it got outside the control's areanv
    if x < 0 or y < 0 or x > inventorywindow.width or y > inventorywindow.height then _
        exit sub
    
    if button = vbrightbutton then
        if draganddropon then
            call drawfloatingitem(slotdragged, x, y)
        end if
    else
        temp_x = x \ owntilepixelwidth
        temp_y = y \ owntilepixelheight
        
        tempitem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
    
        if tempitem <= ubound(inventory) then
            inventorywindow.tooltiptext = inventory(tempitem).name
        end if
    end if
end sub

private sub inventorywindow_mousedown(button as integer, shift as integer, x as single, y as single)
    dim temp_x as integer
    dim temp_y as integer
    dim tempitem as integer
    
    if draganddropon then
        'exit if it got outside the control's area
        if x < 0 or y < 0 or x > inventorywindow.width or y > inventorywindow.height then exit sub
        
        if button = vbrightbutton then
            temp_x = x \ owntilepixelwidth
            temp_y = y \ owntilepixelheight
        
            tempitem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
            
            slotdragged = tempitem
        end if
    end if
end sub

private sub drawfloatingitem(byval slot as integer, byval x as integer, byval y as integer)
'***************************************************
'author: ignacio mariano tirabasso (budi)
'last modify date: 03/01/11
'renders a floating item
'***************************************************
    dim temprect as rect
    dim srcrectslot as rect
    
    with temprect
        .bottom = inventorywindow.height
        .right = inventorywindow.width
    end with

    call bufferinvsurface.bltfast(0, 0, invsurface, temprect, ddbltfast_donotwait)
    
    dim upperleftslot as integer
    upperleftslot = inventoryoffset * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
    
    'if not in renderable area we exit
    if slot < upperleftslot then exit sub
    
    if inventory(slot).grhindex then
        'get source rect
        with srcrectslot
            .left = grhdata(inventory(slot).grhindex).sx
            .top = grhdata(inventory(slot).grhindex).sy
            .right = .left + tilepixelwidth
            .bottom = .top + tilepixelheight
        end with
        
        'render the item grh and the amount
        bufferinvsurface.setforecolor vbwhite
        call bufferinvsurface.bltfast(x, y, surfacedb.surface(clng(grhdata(inventory(slot).grhindex).filenum)), srcrectslot, ddbltfast_wait or ddbltfast_srccolorkey)
        
        'if equipped we render "e"
        if inventory(slot).equipped then
            bufferinvsurface.setforecolor vbyellow
            bufferinvsurface.drawtext x + 20, y + 20, "e", false
        end if
    end if
    
    'render the item to the inventory window
    call bufferinvsurface.blttodc(inventorywindow.hdc, temprect, temprect)
    
    call inventorywindow.refresh
end sub

private sub drawinventoryslot(byval slot as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 12/04/06
'renders a inventory slot to the given picturebox
'***************************************************
    dim destrect as rect
    dim srcrectslot as rect
    
    dim upperleftslot as integer
    upperleftslot = inventoryoffset * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
    
    'if not in renderable area we exit
    if slot < upperleftslot then exit sub
    
    with destrect
        .top = ((slot - upperleftslot) \ (inventorywindow.scalewidth \ owntilepixelwidth)) * owntilepixelheight
        .left = ((slot - 1) mod (inventorywindow.scalewidth \ owntilepixelwidth)) * owntilepixelwidth
        .bottom = .top + owntilepixelheight
        .right = .left + owntilepixelwidth
    end with
    
    'clear the slot area
    call invsurface.bltcolorfill(destrect, inventorywindow.backcolor)
    
    if inventory(slot).grhindex then
        'get source rect
        with srcrectslot
            .left = grhdata(inventory(slot).grhindex).sx
            .top = grhdata(inventory(slot).grhindex).sy
            .right = .left + tilepixelwidth
            .bottom = .top + tilepixelheight
        end with
        
        'render the item grh and the amount
        invsurface.setforecolor vbwhite
        invsurface.bltfast destrect.left + startdx, destrect.top + startdy, surfacedb.surface(clng(grhdata(inventory(slot).grhindex).filenum)), srcrectslot, ddbltfast_wait or ddbltfast_nocolorkey
        
        if showvalue then
            dim svalue as string
            svalue = iif(valueformated, format(inventory(slot).amount, "#,###,###,###"), inventory(slot).amount)
       '     svalue = inventory(slot).amount
            invsurface.drawtext destrect.left + startdx / 2, destrect.top + startdy / 2, svalue, false
        end if
        
        'if equipped we render "e"
        if inventory(slot).equipped then
            invsurface.setforecolor vbyellow
            invsurface.drawtext destrect.left + 20, destrect.top + 20, "e", false
        end if
        
        'render a box around the selected item
        if invselecteditem = slot then
            if imgcontainer then
                invsurface.setforecolor vbgreen
                invsurface.setdrawstyle drawstyleconstants.vbdot
                invsurface.drawbox destrect.left, destrect.top, destrect.left + owntilepixelwidth, destrect.top + owntilepixelheight
            end if
        end if
    end if
    
    'render the item to the inventory window
    invsurface.blttodc inventorywindow.hdc, destrect, destrect
    
    call inventorywindow.refresh
end sub

#if conmenuesconextuales = 1 then   'argument list varies!!!
    public sub initialize(byref directdraw as directdraw7, byref invpic as picturebox, byval maxobjs as byte, _
    byref popupmenu as menu)

#else   'argument list varies!!!
    public sub initialize(byref directdraw as directdraw7, byref invpic as picturebox, byval maxobjs as byte, _
                            optional byval fontsize as integer = 7, optional byval tilewidth as integer = 32, _
                            optional byval tileheight as integer = 32, optional byval startx as integer = 0, _
                            optional byval starty as integer = 0, optional byval bimgcontainer as boolean = true, _
                            optional byval bshowtext as boolean = true, optional formatvalue as boolean = false, optional byval draganddrop as boolean = false)
#end if
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 03/12/09
'sets the reference to the picture box on which to render the inventory
'03/12/09: i added the optionals args fontsize, tilewidth, tileheight, startx and starty. (budi)
'***************************************************

    dim ddck as ddcolorkey

    set inventorywindow = invpic
    valueformated = formatvalue
    
    'make sure auto-redraw is set to true
    inventorywindow.autoredraw = true
    
    'set apropiate scale (pixel)
    inventorywindow.scalemode = 3
    
    redim inventory(1 to maxobjs) as inventory
    
    'initialize dx stuff
    dim surfacedesc as ddsurfacedesc2
    
    'make sure directdraw was correctly initialized
    if directdraw is nothing then exit sub
            
    'set surface's description
    with surfacedesc
        .lflags = ddsd_caps or ddsd_height or ddsd_width
        .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
        .lheight = inventorywindow.height
        .lwidth = inventorywindow.width
    end with
    
        'create inventory surface
    set invsurface = directdraw.createsurface(surfacedesc)
    set bufferinvsurface = directdraw.createsurface(surfacedesc)
    
    owntilepixelheight = tileheight
    owntilepixelwidth = tilewidth
    startdx = startx
    startdy = starty
    
    imgcontainer = bimgcontainer
    showvalue = bshowtext
   
    draganddropon = draganddrop
    
    'prepare surfaces for text rendering
    invsurface.setfonttransparency true
'todo : fonts should be in a separate class / collection
    dim font as stdfont
    set font = new stdfont
    dim ifnt as ifont
    
    font.name = "verdana"
    font.bold = true
    font.italic = false
    font.size = fontsize
    font.underline = false
    font.strikethrough = false
    
    set ifnt = font
    
    invsurface.setfont ifnt
    bufferinvsurface.setfont ifnt
'\todo
    
    if imgcontainer then _
        invselecteditem = clickitem(1, 1)   'if there is anything there we select the top left item
    
#if conmenuesconextuales = 1 then
    set itemmenu = popupmenu
#end if
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
    dim tempitem as long
    dim temp_x as long
    dim temp_y as long
    
    'exit if it got outside the control's area
    if x < 0 or y < 0 or x > inventorywindow.width or y > inventorywindow.height then _
        exit sub
    
    prevselitem = invselecteditem
    
    if button = vbrightbutton then
        if draganddropon then
            temp_x = x \ owntilepixelwidth
            temp_y = y \ owntilepixelheight
        
            invselecteditem = temp_x + (temp_y + inventoryoffset) * (inventorywindow.scalewidth \ owntilepixelwidth) + 1
            
            call drawinventory
            
            if invselecteditem <> slotdragged then
                raiseevent dragdone(slotdragged, invselecteditem)
            end if
        end if
    else
        'get the currently clickced item
        invselecteditem = clickitem(cint(x), cint(y))
    
        'update needed inventory slots
        if prevselitem <> invselecteditem then
            if prevselitem <> 0 and prevselitem <> flagoro then call drawinventoryslot(prevselitem)
            if invselecteditem then call drawinventoryslot(invselecteditem)
        end if
    end if
#if conmenuesconextuales = 1 then
    'if it was a right click on the same item we had selected before, show popup menu
    if button = vbrightbutton and prevselitem = invselecteditem then
        'show the provided menu as a popup
        call inventorywindow.parent.popupmenu(itemmenu, , x, y)
    end if
#end if
end sub
