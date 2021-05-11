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

'number of buckets in our hash table. must be a nice prime number.
const hash_table_size as long = 337

private type surface_entry_dyn
    fileindex as long
    lastaccess as long
    surface as directdrawsurface7
end type

private type hashnode
    surfacecount as integer
    surfaceentry() as surface_entry_dyn
end type

private surfacelist(hash_table_size - 1) as hashnode

private directdraw as directdraw7

private maxbytestouse as long
private usedbytes as long

private usevideomemory as boolean

private resourcepath as string

private declare function gettickcount lib "kernel32" () as long

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
    usedbytes = 0
    maxbytestouse = min_memory_to_use
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
        with surfacelist(i)
            for j = 1 to .surfacecount
                set .surfaceentry(j).surface = nothing
            next j
            
            'destroy the arrays
            erase .surfaceentry
        end with
    next i
end sub

private sub clssurfacemanager_initialize(byref dd as directdraw7, byval videomemory as boolean, byval graphicpath as string, optional byval maxmemoryusageinmb as long = -1)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'initializes the manager
'**************************************************************
    set directdraw = dd
    
    usevideomemory = videomemory
    
    resourcepath = graphicpath
    
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
    dim i as long
    
    ' search the index on the list
    with surfacelist(fileindex mod hash_table_size)
        for i = 1 to .surfacecount
            if .surfaceentry(i).fileindex = fileindex then
                .surfaceentry(i).lastaccess = gettickcount
                set clssurfacemanager_surface = .surfaceentry(i).surface
                exit function
            end if
        next i
    end with
    
    'not in memory, load it!
    set clssurfacemanager_surface = loadsurface(fileindex)
end property

private function loadsurface(byval fileindex as long) as directdrawsurface7
'**************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 05/11/2009
'loads the surface named fileindex + ".bmp" and inserts it to the
'surface list in the listindex position
'**************************************************************
on error goto errhandler

    dim newsurface as surface_entry_dyn
    dim ddsd as ddsurfacedesc2
    dim ddck as ddcolorkey
    dim data() as byte
    dim bmpinfo as bitmapinfo
    dim sdc as long
    
    'get bitmap
    call get_bitmap(resourcepath, cstr(fileindex) & ".bmp", bmpinfo, data)

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
        
        'set last access time (if we didn't we would reckon this texture as the one lru)
        .lastaccess = gettickcount
        
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
    
    'insert surface to the list
    with surfacelist(fileindex mod hash_table_size)
        .surfacecount = .surfacecount + 1
        
        redim preserve .surfaceentry(1 to .surfacecount) as surface_entry_dyn
        
        .surfaceentry(.surfacecount) = newsurface
        
        set loadsurface = newsurface.surface
    end with
    
    'update used bytes
    usedbytes = usedbytes + ddsd.lheight * ddsd.lpitch
    
    'check if we have exceeded our allowed share of memory usage
    do while usedbytes > maxbytestouse
        'remove a file. if no file could be removed we continue, if the file was previous to our surface we update the index
        if not removelru() then
            exit do
        end if
    loop
exit function

errhandler:
    if err.number = dderr_outofmemory or err.number = dderr_outofvideomemory then
        'remove a surface and try again
        if removelru() then
            resume
        else
            msgbox "no hay memoria disponible! el programa abortar�. cierra algunos programas e intenta de nuevo"
            end
        end if
    else
        msgbox "un error inesperado ocurri� al intentar cargar el gr�fico " & cstr(fileindex) & ".bmp" & ". " & vbcrlf & _
                "el c�digo de error es " & cstr(err.number) & " - " & err.description & vbcrlf & vbcrlf & "copia este mensaje y notifica a los administradores.", _
                vbokonly or vbcritical or vbexclamation, "error"
        end
    end if
end function

private function removelru() as boolean
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 3/06/2006
'removes the least recently used surface to make some room for new ones
'**************************************************************
    dim lrui as long
    dim lruj as long
    dim lrutime as long
    dim i as long
    dim j as long
    dim ddsd as ddsurfacedesc2
    
    lrutime = gettickcount
    
    'check out through the whole list for the least recently used
    for i = 0 to hash_table_size - 1
        with surfacelist(i)
            for j = 1 to .surfacecount
                if lrutime > .surfaceentry(j).lastaccess then
                    lrui = i
                    lruj = j
                    lrutime = .surfaceentry(j).lastaccess
                end if
            next j
        end with
    next i
    
    if lruj then
        removelru = true
        'retrieve the surface desc
        call surfacelist(lrui).surfaceentry(lruj).surface.getsurfacedesc(ddsd)
        
        'remove it
        set surfacelist(lrui).surfaceentry(lruj).surface = nothing
        surfacelist(lrui).surfaceentry(lruj).fileindex = 0
        
        'move back the list (if necessary)
        with surfacelist(lrui)
            for j = lruj to .surfacecount - 1
                .surfaceentry(j) = .surfaceentry(j + 1)
            next j
            
            .surfacecount = .surfacecount - 1
            if .surfacecount then
                redim preserve .surfaceentry(1 to .surfacecount) as surface_entry_dyn
            else
                erase .surfaceentry
            end if
        end with
        
        'update the used bytes
        usedbytes = usedbytes - ddsd.lheight * ddsd.lpitch
    end if
end function
