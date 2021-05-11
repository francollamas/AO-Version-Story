version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clssurfacemanstatic"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clssurfacemanstatic.cls - inherits from clssurfacemanager. is designed to load
' surfaces at startup, and never deallocating them.
' this grants high performance can use a lot of ram.
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

'inherit from the surface manager
implements clssurfacemanager

'number of buckets in our hash table. must be a nice prime number.
const hash_table_size as long = 541

private type surface_entry_static
    fileindex as long
    surface as directdrawsurface7
end type

private type hashbucket
    sufracecount as integer
    surfaceentry() as surface_entry_static
end type

private surfacelist(hash_table_size - 1) as hashbucket

private directdraw as directdraw7

private usevideomemory as boolean

private const dib_pal_colors as long = 1
private const dib_rgb_colors as long = 0
private declare function setdibitstodevice lib "gdi32.dll" _
    (byval hdc as long, byval xdest as long, byval ydest as long, _
    byval dwwidth as long, byval dwheight as long, byval xsrc as long, _
    byval ysrc as long, byval ustartscan as long, byval cscanline as long, _
    lpbits as any, lpbmi as bitmapinfo, byval fucoloruse as long) as long
    
private sub class_initialize()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'
'**************************************************************
end sub

private sub class_terminate()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'clean up
'**************************************************************
    dim i as long
    dim j as long
    
    'destroy every surface in memory
    for i = 0 to hash_table_size - 1
        for j = 1 to surfacelist(i).sufracecount
            set surfacelist(i).surfaceentry(j).surface = nothing
        next j
        
        'destroy the array
        erase surfacelist(i).surfaceentry
    next i
end sub

private sub clssurfacemanager_initialize(byref dd as directdraw7, byval videomemory as boolean, byval graphicpath as string, optional byval maxmemoryusageinmb as long = -1&)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'
'**************************************************************
    set directdraw = dd
    
    usevideomemory = videomemory
    
    call loadsurfaces(graphicpath)
end sub

private property get clssurfacemanager_surface(byval fileindex as long) as directdrawsurface7
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'retrieves the requested texture
'**************************************************************
on error goto errhandler:
    dim i as long
    
    ' search for it and return it
    with surfacelist(fileindex mod hash_table_size)
        for i = 1 to .sufracecount
            if .surfaceentry(i).fileindex = fileindex then
                set clssurfacemanager_surface = .surfaceentry(i).surface
                exit function
            end if
        next i
    end with
    
    'we have a missing bmp!
    msgbox "no se encuentra el archivo " & cstr(fileindex) & ".bmp. reinstale el juego, " _
        & "y si el problema persiste contactese con los adminsitradores", vbokonly or vbcritical or vbexclamation, "error"
    
    end
exit property

errhandler:
    msgbox "un error inesperado ocurri� a intentar cargar el archivo " & cstr(fileindex) & ".bmp. & vbcrlf" _
        & "error: " & cstr(err.number), vbokonly or vbcritical or vbexclamation, "error"
    
    end
end property

private sub loadsurfaces(byval resourcepath as string)
'**************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 12/02/2007
'loads all surfaces in random order and then sorts them
'**************************************************************
on error resume next
    dim surfaceindex as long
    dim bmpinfo as bitmapinfo
    dim data() as byte
    dim i as long
    
    while getnext_bitmap(resourcepath, i, bmpinfo, data(), surfaceindex)
        call loadsurface(bmpinfo, data(), surfaceindex)
    wend
end sub

private sub loadsurface(byref bmpinfo as bitmapinfo, byref data() as byte, byval fileindex as long)
'**************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 11/30/2007
'loads the surface named fileindex + ".bmp" and inserts it to the
'surface list in the listindex position
'**************************************************************
on error goto errhandler

    dim newsurface as surface_entry_static
    dim ddsd as ddsurfacedesc2
    dim ddck as ddcolorkey
    dim sdc as long
    
    'set up the surface desc
    ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width
    if usevideomemory then
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_videomemory
    else
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
    end if
    ddsd.lwidth = bmpinfo.bmiheader.biwidth
    ddsd.lheight = bmpinfo.bmiheader.biheight
    
    with newsurface
        .fileindex = fileindex
        
        'load surface
        set .surface = directdraw.createsurface(ddsd)
        sdc = .surface.getdc
        
        call setdibitstodevice(sdc, 0, 0, bmpinfo.bmiheader.biwidth, bmpinfo.bmiheader.biheight, 0, 0, 0, bmpinfo.bmiheader.biheight, data(0), bmpinfo, dib_rgb_colors)
        
        call .surface.releasedc(sdc)
        
        'set colorkey
        ddck.high = 0
        ddck.low = 0
        call .surface.setcolorkey(ddckey_srcblt, ddck)
        
        'retrieve the updated surface desc
        call .surface.getsurfacedesc(ddsd)
    end with
    
    'store the surface in the given index (it must be empty or data will be lost)
    with surfacelist(fileindex mod hash_table_size)
        .sufracecount = .sufracecount + 1
        redim preserve .surfaceentry(1 to .sufracecount) as surface_entry_static
        
        .surfaceentry(.sufracecount) = newsurface
    end with
exit sub

errhandler:
    if err.number = dderr_outofvideomemory then
        ' no video memory? try system memory! we want all surfaces loaded!
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
        resume
    end if
    
    msgbox "un error inesperado ocurri� al intentar cargar el gr�fico " & cstr(fileindex) & ".bmp" & ". " & vbcrlf & _
            "el c�digo de error es " & cstr(err.number) & " - " & err.description & vbcrlf & vbcrlf & "copia este mensaje y notifica a los administradores.", _
            vbokonly or vbcritical or vbexclamation, "error"
        end
end sub
