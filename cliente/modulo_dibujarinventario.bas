attribute vb_name = "dibujarinventario"
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

'[code]:matux
'
'  casi todo recodeado menos los calculos
'
'[end]'

public const xcantitems = 5

public offsetdelinv as integer
public itemelegido as integer
public mx as integer
public my as integer

private auxsurface   as directdrawsurface7
private boxsurface   as directdrawsurface7
private selsurface   as directdrawsurface7
private bstaticinit  as boolean   'se inicializaron las statics?
private r1           as rect, r2 as rect, auxr as rect
private rbox         as rect  'pos del cuadradito rojo
private rboxframe(2) as rect
private iframemod    as integer


function clicenitemelegido(x as integer, y as integer) as boolean
binvmod = true
mx = x \ 32 + 1
my = y \ 32 + 1
if itemelegido = 0 or flagoro then
    clicenitemelegido = false
else
    clicenitemelegido = (userinventory(itemelegido).objindex > 0) and (itemelegido = (mx + (my - 1) * 5) + offsetdelinv)
end if
end function

sub itemclick(x as integer, y as integer)
dim lpreitem as long

binvmod = false
mx = x \ 32 + 1
my = y \ 32 + 1

lpreitem = (mx + (my - 1) * 5) + offsetdelinv

if lpreitem <= max_inventory_slots then _
if userinventory(lpreitem).grhindex > 0 then _
    itemelegido = lpreitem: binvmod = true
end sub

public sub dibujarinvbox()
    on error resume next
    if bstaticinit and itemelegido <> 0 then
        call boxsurface.bltcolorfill(auxr, vbblack)
        call boxsurface.bltfast(0, 0, selsurface, auxr, ddbltfast_srccolorkey)
        
        with grh(1)
            .framecounter = 2
            call boxsurface.bltfast(0, 0, surfacedb.getbmp(grhdata(grhdata(.grhindex).frames(.framecounter)).filenum), rboxframe(.framecounter - 1), ddbltfast_srccolorkey or ddbltfast_wait)
        end with
        call boxsurface.blttodc(frmmain.picinv.hdc, auxr, rbox)
        call frmmain.picinv.refresh
    end if
end sub

sub dibujarinv()
dim ix as integer

if not bstaticinit then _
    call initmem

r1.top = 0: r1.left = 0: r1.right = 32: r1.bottom = 32
r2.top = 0: r2.left = 0: r2.right = 32: r2.bottom = 32

frmmain.picinv.cls

for ix = offsetdelinv + 1 to ubound(userinventory)
    if userinventory(ix).grhindex > 0 then
        auxsurface.bltcolorfill auxr, vbblack
        auxsurface.bltfast 0, 0, surfacedb.getbmp(grhdata(userinventory(ix).grhindex).filenum), auxr, ddbltfast_nocolorkey
        auxsurface.drawtext 0, 0, userinventory(ix).amount, false

        if userinventory(ix).equipped then
            auxsurface.setforecolor vbyellow
            auxsurface.drawtext 20, 20, "+", false
            auxsurface.setforecolor vbwhite
        end if

        if itemelegido = ix then
            with r2: .left = (mx - 1) * 32: .right = r2.left + 32: .top = (my - 1) * 32: .bottom = r2.top + 32: end with
            call auxsurface.bltfast(0, 0, surfacedb.getbmp(grhdata(grhdata(grh(1).grhindex).frames(2)).filenum), rboxframe(2), ddbltfast_srccolorkey or ddbltfast_wait)
        end if
        auxsurface.blttodc frmmain.picinv.hdc, auxr, r2
    end if

    r2.left = r2.left + 32
    r2.right = r2.right + 32
    r1.left = r1.left + 32
    r1.right = r1.right + 32
    if r2.left >= 160 then
        r2.left = 0
        r1.left = 0
        r1.right = 32
        r2.right = 32
        r2.top = r2.top + 32
        r1.top = r1.top + 32
        r2.bottom = r2.bottom + 32
        r1.bottom = r1.bottom + 32
    end if
next ix

binvmod = false

if itemelegido = 0 then _
    call itemclick(2, 2)

end sub
private sub initmem()
    dim ddck        as ddcolorkey
    dim surfacedesc as ddsurfacedesc2
    
    'back buffer surface
    r1.right = 32: r1.bottom = 32
    r2.right = 32: r2.bottom = 32
    
    with surfacedesc
        .lflags = ddsd_caps or ddsd_height or ddsd_width
        .ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
        .lheight = r1.bottom
        .lwidth = r1.right
    end with

    ' create surface
    set auxsurface = directdraw.createsurface(surfacedesc)
    set boxsurface = directdraw.createsurface(surfacedesc)
    set selsurface = directdraw.createsurface(surfacedesc)

    'set color key
    auxsurface.setcolorkey ddckey_srcblt, ddck
    boxsurface.setcolorkey ddckey_srcblt, ddck
    selsurface.setcolorkey ddckey_srcblt, ddck

    auxr.right = 32: auxr.bottom = 32

    auxsurface.setfonttransparency true
    auxsurface.setfont frmmain.font
    selsurface.setfonttransparency true
    selsurface.setfont frmmain.font

    'redbox frame position list
    with rboxframe(0): .left = 0:  .top = 0: .right = 32: .bottom = 32: end with
    with rboxframe(1): .left = 32: .top = 0: .right = 64: .bottom = 32: end with
    with rboxframe(2): .left = 64: .top = 0: .right = 96: .bottom = 32: end with
    iframemod = 1

    bstaticinit = true
end sub
