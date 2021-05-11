version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clssurfacemandyn"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clssurfacemandyn.cls - inherits from clssurfacemanager. is designed to load
'surfaces dynamically without using more than an arbitrary amount of mb.
'for removale it uses lru, attempting to just keep in memory those surfaces
'that are actually usefull.
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

private const bytes_per_mb as long = 1048576                        '1mb = 1024 kb = 1024 * 1024 bytes = 1048576 bytes
private const min_memory_to_use as long = 4 * bytes_per_mb          '4 mb
private const default_memory_to_use as long = 16 * bytes_per_mb     '16 mb

private type surface_entry_dyn
    fileindex as long
    lastaccess as long
    surface as directdrawsurface7
end type

private surfacelist() as surface_entry_dyn
private surfacecount as long

private surfaceindexes() as long
private surfaceindexcount as long

private directdraw as directdraw7

private maxbytestouse as long
private usedbytes as long

private usevideomemory as boolean

private grhpath as string

private declare function gettickcount lib "kernel32" () as long
private declare sub copymemory lib "kernel32" alias "rtlmovememory" (byref dest as any, byref source as any, byval bytecount as long)

private sub class_initialize()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'
'**************************************************************
    usedbytes = 0
    surfacecount = 0
    surfaceindexcount = 0
    redim surfacelist(0) as surface_entry_dyn
    redim surfaceindexes(0) as long
    maxbytestouse = min_memory_to_use
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
    
    'destroy the arrays
    erase surfacelist
    erase surfaceindexes
end sub

private sub clssurfacemanager_initialize(byref dd as directdraw7, byval videomemory as boolean, byval graphicpath as string, optional byval maxmemoryusageinmb as long = -1)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'initializes the manager
'**************************************************************
    set directdraw = dd
    
    usevideomemory = videomemory
    
    grhpath = graphicpath
    
    if maxmemoryusageinmb = -1 then
        maxbytestouse = default_memory_to_use   ' 16 mb by default
    elseif maxmemoryusageinmb * bytes_per_mb < min_memory_to_use then
        maxbytestouse = min_memory_to_use       ' 4 mb is the minimum allowed
    else
        maxbytestouse = maxmemoryusageinmb * bytes_per_mb
    end if
end sub

private property get clssurfacemanager_surface(byval fileindex as long) as directdrawsurface7
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'retrieves the requested texture
'**************************************************************
    dim index as long
    
    ' search the index on the list
    index = binarysearch(fileindex)
    
    if index < 0 then
        'not found, we have to load the file and add it in the position given by the negation of the index
        '(it may be changed by the removal of indexes though, so we let the loadsurface method notify us)
        index = loadsurface(fileindex, not index)
    end if
    
    'return it
    with surfacelist(surfaceindexes(index))
        .lastaccess = gettickcount
        set clssurfacemanager_surface = .surface
    end with
end property

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
    max = surfaceindexcount - 1
    
    do while min <= max
        mid = (min + max) \ 2
        
        if surfacelist(surfaceindexes(mid)).fileindex < fileindex then
            min = mid + 1
        elseif surfacelist(surfaceindexes(mid)).fileindex > fileindex then
            max = mid - 1
        else
            'we found it
            binarysearch = mid
            exit function
        end if
    loop
    
    'not found, return the negation of the position where it should be
    '(all higher values are to the right of the list and lower values are to the left)
    binarysearch = not mid
end function

private function loadsurface(byval fileindex as long, byval listindex as long) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'loads the surface named fileindex + ".bmp" and inserts it to the
'surface list in the listindex position
'**************************************************************
on error goto errhandler

    dim newsurface as surface_entry_dyn
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
        
        'set last access time (if we didn't we would reckon this texture as the one lru)
        .lastaccess = gettickcount
        
        'load surface
        set .surface = directdraw.createsurfacefromfile(filepath, ddsd)
        
        'set colorkey
        ddck.high = 0
        ddck.low = 0
        call .surface.setcolorkey(ddckey_srcblt, ddck)
        
        'retrieve the updated surface desc
        call .surface.getsurfacedesc(ddsd)
    end with
    
    'insert surface to the list at the given pos
    call insertsurface(newsurface, listindex)
    
    'update used bytes
    usedbytes = usedbytes + ddsd.lheight * ddsd.lpitch
    
    dim removedfile as integer
    'check if we have exceeded our allowed share of memory usage
    do while usedbytes > maxbytestouse and surfacecount > 1
        'remove a file
        removedfile = removelru
        
        'if no file could be removed we continue, if the file was previous to our surface we update the index
        if removedfile = 0 then
            exit do
        elseif removedfile < listindex then
            listindex = listindex - 1
        end if
    loop
    
    'return the real index in wich it ended after removing any necessary files
    loadsurface = listindex
exit function

errhandler:
    if err.number = dderr_outofmemory or err.number = dderr_outofvideomemory then
        if surfacecount then
            'remove a surface and try again
            call removelru
            resume next
        else
            msgbox "no hay memoria disponible! el programa abortar�. cierra algunos programas e intenta de nuevo"
            end
        end if
    else
        msgbox "un error inesperado ocurri� al intentar cargar el gr�fico " & filepath & ". " & vbcrlf & _
                "el c�digo de error es " & cstr(err.number) & " - " & err.description & vbcrlf & "copia este mensaje y notifica a los administradores.", _
                vbokonly or vbcritical or vbexclamation, "error"
        end
    end if
end function

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

private sub insertsurface(byref surface as surface_entry_dyn, byval listindex as long)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'inserts the given surface in the requested position of the surface list
'**************************************************************
on error goto errhandler
    dim i as long
    
    'search for an empty spot in the list
    for i = 0 to surfacecount - 1
        if surfacelist(i).surface is nothing then exit for
    next i
    
    'enlarge the list if no empty spot was found
    if i = surfacecount then
        redim preserve surfacelist(surfacecount) as surface_entry_dyn
        
        'increase surface count
        surfacecount = surfacecount + 1
    end if
    
    'insert the new surface
    surfacelist(i) = surface
    
    'resize the list
    redim preserve surfaceindexes(surfaceindexcount) as long
    
    'update the index list
    if surfaceindexcount > listindex then
        'move back the list - copying this way is up to 6 times faster than a for
        dim templist() as long
        redim templist(surfaceindexcount - listindex) as long
        
        copymemory templist(0), surfaceindexes(listindex), (surfaceindexcount - listindex) * 4
        surfaceindexes(listindex) = i
        copymemory surfaceindexes(listindex + 1), templist(0), (surfaceindexcount - listindex) * 4
    else
        'we are inserting at the bottom of the list
        surfaceindexes(listindex) = i
    end if
    
    surfaceindexcount = surfaceindexcount + 1
exit sub

errhandler:
    msgbox "un error irreparable ocurri� al insertar un nuevo gr�fico en la lista." & vbcrlf _
            & "el cliente se cerrar�" & vbcrlf _
            & "intente usar el cliente no din�mico"
    end
end sub

private function removelru() as integer
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'removes the least recently used surface to make some room for new ones
'**************************************************************
    dim lru as long
    dim i as long
    dim ddsd as ddsurfacedesc2
    
    'should never happen, but just in case....
    if surfacecount = 0 then exit function
    
    'initialize with the first element of the list
    lru = 0
    
    'check out through the whole list for the least recently used
    for i = 1 to surfaceindexcount - 1
        if surfacelist(surfaceindexes(lru)).lastaccess > surfacelist(surfaceindexes(i)).lastaccess then
            lru = i
        end if
    next i
    
    'store the index of the surface removed
    removelru = lru
    
    'retrieve the surface desc
    call surfacelist(surfaceindexes(lru)).surface.getsurfacedesc(ddsd)
    
    'remove it
    set surfacelist(surfaceindexes(lru)).surface = nothing
    surfacelist(surfaceindexes(lru)).fileindex = 0
    
    'move back the list (if necessary)
    if lru < surfaceindexcount - 1 then
        copymemory surfaceindexes(lru), surfaceindexes(lru + 1), (surfaceindexcount - lru - 1) * 4
    end if
    
    'resize the list
    redim preserve surfaceindexes(surfaceindexcount - 1) as long
    
    'decrease index count
    surfaceindexcount = surfaceindexcount - 1
    
    'update the used bytes
    usedbytes = usedbytes - ddsd.lheight * ddsd.lpitch
end function
