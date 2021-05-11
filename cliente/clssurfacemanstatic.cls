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

'size to which we resize the list when we start loading textures to prevent redim preserve on each add
'once done the list is trimmed to the proper size if it's larger than needed.
'a redim preserve is executed for each surface after default_list_size + 1
private const default_list_size as integer = 1500

private type surface_entry_static
    fileindex as long
    surface as directdrawsurface7
end type

private surfacelist() as surface_entry_static
private surfacecount as long

private directdraw as directdraw7

private usevideomemory as boolean

private sub class_initialize()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'
'**************************************************************
    surfacecount = 0
    redim surfacelist(0) as surface_entry_static
end sub

private sub class_terminate()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'clean up
'**************************************************************
    dim i  as long
    
    'destroy every surface in memory
    for i = 0 to surfacecount - 1
        set surfacelist(i).surface = nothing
    next i
    
    'destroy the array
    erase surfacelist
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
    dim index as long
    
    ' search the index on the list
    index = binarysearch(fileindex)
    
    'return it
    set clssurfacemanager_surface = surfacelist(index).surface
exit property

errhandler:
    if index < 0 then
        msgbox "no se encuentra el archivo " & cstr(fileindex) & ".bmp. reinstale el juego, " _
                & "y si el problema persiste contactese con los adminsitradores", vbokonly or vbcritical or vbexclamation, "error"
    else
        msgbox "un error inesperado ocurri� a intentar cargar el archivo " & cstr(fileindex) & ".bmp. & vbcrlf" _
                & "error: " & cstr(err.number), vbokonly or vbcritical or vbexclamation, "error"
    end if
    
    end
end property

private sub loadsurfaces(byval grhpath as string)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'loads all surfaces in random order and then sorts them
'**************************************************************
on error resume next
    dim filename as string
    dim surfaceindex as long
    
    'set up the list at a standard value big enough to prevent using redim preserve constantly (which is slow)
    redim surfacelist(default_list_size) as surface_entry_static
    
    filename = dir$(grhpath & "*.bmp", vbarchive)
    
    while filename <> ""
        'get the surface index (numeric part of the number) - never use val() here or the error won't be raised!!! - don't use isnumeric or hexa strings will be accepted
        surfaceindex = clng(left$(filename, len(filename) - 4))
        
        if err.number = 13 then
            'type mysmatch - the name of the file isn't numneric, therefore it isn't a surface
            err.clear
        else
            'increase surface count and resize list if needed
            surfacecount = surfacecount + 1
            if surfacecount > default_list_size + 1 then
                redim preserve surfacelist(surfacecount - 1) as surface_entry_static
            end if
            
            call loadsurface(grhpath, surfaceindex, surfacecount - 1)
        end if
        
        'get next .bmp file
        filename = dir$()
    wend
    
    'trim the list if needed
    if surfacecount <> ubound(surfacelist) + 1 then
        redim preserve surfacelist(surfacecount - 1) as surface_entry_static
    end if
    
    'sort the list
    call sortsurfaces(0, surfacecount - 1)
end sub

private function binarysearch(byval fileindex as long) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'returns the index of the surface in the list, or the negation
'of the position were it should be if not found (for binary insertion)
'**************************************************************
    dim min as long
    dim max as long
    dim mid as long
    
    min = 0
    max = surfacecount - 1
    
    do while min <= max
        mid = (min + max) \ 2
        
        if surfacelist(mid).fileindex < fileindex then
            min = mid + 1
        elseif surfacelist(mid).fileindex > fileindex then
            max = mid - 1
        else
            'we found it
            binarysearch = mid
            exit function
        end if
    loop
    
    'not found, return the negation of the position where it should be
    '(all higher values are to the right of the list and lower values are to the left)
    binarysearch = not min
end function

private sub loadsurface(byval grhpath as string, byval fileindex as long, byval listindex as long)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'loads the surface named fileindex + ".bmp" and inserts it to the
'surface list in the listindex position
'**************************************************************
on error goto errhandler

    dim newsurface as surface_entry_static
    dim ddsd as ddsurfacedesc2
    dim ddck as ddcolorkey
    dim filepath as string
    
    'store complete file path
    filepath = grhpath & cstr(fileindex) & ".bmp"
    
    'set up the surface desc
    ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width
    
    if usevideomemory then
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain
    else
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
    end if
    
    call surfacedimensions(filepath, ddsd.lheight, ddsd.lwidth)
    
    with newsurface
        .fileindex = fileindex
        
        'load surface
        set .surface = directdraw.createsurfacefromfile(filepath, ddsd)
        
        'set colorkey
        ddck.high = 0
        ddck.low = 0
        call .surface.setcolorkey(ddckey_srcblt, ddck)
    end with
    
    'store the surface in the given index (it must be empty or data will be lost)
    surfacelist(listindex) = newsurface
exit sub

errhandler:
    msgbox "un error inesperado ocurri� al intentar cargar el gr�fico " & filepath & ". " & vbcrlf & _
            "el c�digo de error es " & cstr(err.number) & " - " & err.description & vbcrlf & "copia este mensaje y notifica a los administradores.", _
            vbokonly or vbcritical or vbexclamation, "error"
        end
end sub

private sub surfacedimensions(byval archivo as string, byref height as long, byref width as long)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'loads the headers of a bmp file to retrieve it's dimensions at rt
'**************************************************************
    dim handle as integer
    dim bmpfilehead as bitmapfileheader
    dim bmpinfohead as bitmapinfoheader
    
    handle = freefile()
    open archivo for binary access read lock write as handle
        get handle, , bmpfilehead
        get handle, , bmpinfohead
    close handle
    
    height = bmpinfohead.biheight
    width = bmpinfohead.biwidth
end sub

private sub sortsurfaces(byval first as integer, byval last as integer)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/04/2005
'sorts the list using quicksort, this allows the use of binarysearch for faster searches
'**************************************************************
    dim min as integer      'first item in the list
    dim max as integer      'last item in the list
    dim comp as long        'item used to compare
    dim temp as surface_entry_static
    
    min = first
    max = last
    
    comp = surfacelist((min + max) \ 2).fileindex
    
    do while min <= max
        do while surfacelist(min).fileindex < comp and min < last
            min = min + 1
        loop
        do while surfacelist(max).fileindex > comp and max > first
            max = max - 1
        loop
        if min <= max then
            temp = surfacelist(min)
            surfacelist(min) = surfacelist(max)
            surfacelist(max) = temp
            min = min + 1
            max = max - 1
        end if
    loop
    
    if first < max then sortsurfaces first, max
    if min < last then sortsurfaces min, last
end sub
