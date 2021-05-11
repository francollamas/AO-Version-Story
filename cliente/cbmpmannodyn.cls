version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "cbmpmannodyn"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
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


'bmp manager no din�mico
'por alejandro santos
'basado en el bmpman dinamico por federico torres

option explicit

private declare sub zeromemory lib "kernel32.dll" alias "rtlzeromemory" (destination as any, byval length as long)

private type bitmapfileheader
        bftype as integer
        bfsize as long
        bfreserved1 as integer
        bfreserved2 as integer
        bfoffbits as long
end type

private type bitmapinfoheader '40 bytes
        bisize as long
        biwidth as long
        biheight as long
        biplanes as integer 'borrar de aca para abajo?
        bibitcount as integer
        bicompression as long
        bisizeimage as long
        bixpelspermeter as long
        biypelspermeter as long
        biclrused as long
        biclrimportant as long
end type

private type bmp_info
    height as long
    width as long
    size as long
end type

private grhpath as string
private mddraw as directdraw7
private mtotalgraficos as long
private msurfacedb() as directdrawsurface7
private musarmemoriavideo as boolean

'para compatibilidad con el bmpman dinamico
public property get maxentries() as long

end property

public property let maxentries(byval vnewvalue as long)

end property

public property let lpdirectdraw7(byref objdirectdraw7 as directdraw7)
set mddraw = objdirectdraw7
end property

public property let path(byval instring as string)
grhpath = instring
end property

public property get totalgraficos() as long
totalgraficos = mtotalgraficos
end property

public property let totalgraficos(byval lnewvalue as long)
mtotalgraficos = lnewvalue
redim msurfacedb(1 to mtotalgraficos)

end property

private sub class_initialize()
mtotalgraficos = 0
grhpath = app.path
set mddraw = nothing
musarmemoriavideo = true
end sub

public property get esdinamico() as variant
esdinamico = false
end property

private sub class_terminate()
on local error resume next
dim i as long

for i = lbound(msurfacedb) to ubound(msurfacedb)
    set msurfacedb(i) = nothing
next i
end sub

private function getbmpheader(archivo as string, byref lpbmpinfo as bmp_info) as long
dim nfile as integer, h_bmph as bitmapfileheader, h_bmpi as bitmapinfoheader

if fileexist(archivo, vbnormal) then
    nfile = freefile()
    open archivo for binary access read as #nfile
    get #nfile, , h_bmph
    get #nfile, , h_bmpi
    close #nfile
    lpbmpinfo.height = h_bmpi.biheight
    lpbmpinfo.width = h_bmpi.biwidth
    lpbmpinfo.size = h_bmph.bfsize
    getbmpheader = 1
else
    getbmpheader = 0
end if

end function

public function cargargrafico(archivo as integer) as integer
'12/1/3, colorkey
on local error goto hayerror
dim ddsd as ddsurfacedesc2, bmpinfo as bmp_info, retval as long, ddck as ddcolorkey
ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width

'para alto y ancho de la surface
if getbmpheader(grhpath & archivo & ".bmp", bmpinfo) then

    if musarmemoriavideo then
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain
    else
        ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
    end if
    
    ddsd.lheight = bmpinfo.height
    ddsd.lwidth = bmpinfo.width
    
    ddck.high = 0: ddck.low = 0
    
    set msurfacedb(archivo) = mddraw.createsurfacefromfile(grhpath & archivo & ".bmp", ddsd) 'creo la surface
    msurfacedb(archivo).setcolorkey ddckey_srcblt, ddck
    
    cargargrafico = 1
else
hayerror:

    cargargrafico = 0
end if

end function

public function getbmp(byval filename as integer, optional byval nousado as integer) as directdrawsurface7
set getbmp = msurfacedb(filename)
end function

public function init(usarmemoriavideo as boolean) as long
init = 1
musarmemoriavideo = usarmemoriavideo
end function

public function borrartodo() as long
on local error resume next
dim i as long

for i = lbound(msurfacedb) to ubound(msurfacedb)
    set msurfacedb(i) = nothing
next i

end function

public property get efectopred() as integer
efectopred = 0
end property

public property let efectopred(byval inewvalue as integer)

end property

