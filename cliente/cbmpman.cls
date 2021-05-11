version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "cbmpman"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
attribute vb_ext_key = "savedwithclassbuilder6" ,"yes"
attribute vb_ext_key = "top_level" ,"yes"
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


'=============================================================================
'
'   nombre: cbmpman.cls
'   autor: federico torres
'   fecha: 11/01/03
'   contacto: fede_jt@hotmail.com
'
'   descripcion:
'       clase para manejar los graficos, evita tener que cargarlos todos en memoria
'
'
'
'
'       primero hay que setear los miembros de la clase. maxentries indica la cantidad maxima de graficos a cargar.
'       lpdirectdraw7 es un puntero a un objeto de tipo directdraw7, se usa para cargar las surface.
'       con los valores asignados hay que ejecutar el metodo init().
'       getbmp devuelve un objeto tipo directdrawsurface7, si el grafico que se pide no esta cargado se carga.
'       al llegar al limite de graficos permitidos, al pedir el proximo grafico que no este cargado se borra el que menos
'       se uso (de los que ya estaban cargados).
'
'
'   revision por federico torres:
'       12/01/03: agregado color key.
'
'   revision por gulfas morgolock:
'       04/04/03: agregu� el array mkeys(). este vector
'       mapea un filename a su respectiva posici�n en el
'       vector de surfaces msurfacedb(). si mkey(index) es
'       cero el filename de valor index no est� en memoria.
'       bmpman originalmente hacia una busqueda lineal para
'       obtener un surface, con esta t�cnica el tiempo de
'       acceso es constante!
'
'   revision por gulfas morgolock:
'       01/04/03: arregl� un bug en borrarmenosusado().
'       no se reseteaba la referencia al bmp.
'
'
'
'   falta:
'       -comprobar errores.
'       -elegir si se quiere colorkey y que color.
'
'
'=============================================================================

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

private type bmp_db_entry
    filename as integer
    height as long
    width as long
    size as long
    accesos as long
    cont as long
    efecto as long
end type

private type bmp_info
    height as long
    width as long
    size as long
end type


private mbmpdb() as bmp_db_entry
private mddraw as directdraw7
private msurfacedb() as directdrawsurface7
private mkeys() as integer

private mmaxentries as long
private mcontador as long
private mcantidadgraficos as long

private musarmemoriavideo  as boolean

private mefectopred as integer

private grhpath as string

public property let path(byval instring as string)
grhpath = instring
end property

public function getbmp(byval filename as integer, optional byval efecto as integer = -1) as directdrawsurface7

dim retval as integer

if efecto < 0 then
    efecto = mefectopred
end if

if mkeys(efecto, filename) <> 0 then 'esta el surface en memoria?
    mbmpdb(mkeys(efecto, filename)).accesos = mbmpdb(mkeys(efecto, filename)).accesos + 1 'sumo un acceso
    set getbmp = msurfacedb(mkeys(efecto, filename)) 'y devuelvo una surface con el grafico cargado
else 'grafico no cargado
    retval = buscavacio() 'busco espacio para cargarlo
    if retval = -1 then 'todas las surface ocupadas
        retval = 1
        retval = borramenosusado() 'borro el grafico menos usado
    end if
    call creargrafico(filename, retval) 'y creo la textura
    mbmpdb(retval).accesos = mbmpdb(retval).accesos + 1 'sumo un acceso
    mbmpdb(retval).efecto = efecto
    mkeys(efecto, filename) = retval
    
#if conalfab = 1 then
    if efecto = 1 then
        efectonoche msurfacedb(retval)
    end if
#end if

    set getbmp = msurfacedb(retval) 'y devuelvo una surface con el grafico cargado
end if


end function


public function init(byval usarmemoriavideo as boolean) as long   'inicializa todo, ejecutar antes de usar el objeto
on error goto errhandler

if mmaxentries < 1 then 'por lo menos 1 grafico
    init = -1
    exit function
end if

redim mbmpdb(0 to mmaxentries)
redim msurfacedb(0 to mmaxentries)
redim mkeys(0 to 1, 0 to 15000) as integer

mefectopred = 0
musarmemoriavideo = usarmemoriavideo
mcantidadgraficos = 0
mcontador = 0
init = 1

exit function

errhandler:
    init = -1
end function

public function borrartodo() as long
'vacia la lista de graficos
dim i as integer
for i = 1 to mmaxentries
    if mbmpdb(i).filename > 0 then
        call borrar(mbmpdb(i).filename, mbmpdb(i).efecto)
    end if
next
borrartodo = 1
mcantidadgraficos = 0
end function

public function borrar(byval filename as integer, byval efecto as integer) as integer
'borra un grafico
borrar = -1
call zeromemory(mbmpdb(mkeys(efecto, filename)), len(mbmpdb(mkeys(efecto, filename))))
set msurfacedb(mkeys(efecto, filename)) = nothing
mkeys(efecto, filename) = 0
borrar = 1
mcantidadgraficos = mcantidadgraficos - 1
end function

private function creargrafico(byval archivo as integer, byval bindex as integer) as integer
'12/1/3, colorkey
on error resume next
dim ddsd as ddsurfacedesc2, bmpinfo as bmp_info, retval as long, ddck as ddcolorkey
ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width

call getbmpheader(grhpath & archivo & ".bmp", bmpinfo)  'para alto y ancho de la surface

if musarmemoriavideo then
    ddsd.ddscaps.lcaps = ddscaps_offscreenplain
else
    ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_systemmemory
end if
ddsd.lheight = bmpinfo.height
ddsd.lwidth = bmpinfo.width

ddck.high = 0: ddck.low = 0

with mbmpdb(bindex)
    .filename = archivo
    .accesos = 0
    .height = bmpinfo.height
    .width = bmpinfo.width
    .size = bmpinfo.size
    .cont = mcontador
end with
mcontador = mcontador + 1

set msurfacedb(bindex) = mddraw.createsurfacefromfile(grhpath & archivo & ".bmp", ddsd) 'creo la surface
msurfacedb(bindex).setcolorkey ddckey_srcblt, ddck

creargrafico = 1
mcantidadgraficos = mcantidadgraficos + 1

end function

private sub class_initialize()
mmaxentries = 0
musarmemoriavideo = true
mefectopred = 0
end sub



private function buscavacio() as integer
'si esta todo lleno devuelve -1 (llamar borramenosusado)
dim i as integer
for i = 1 to mmaxentries
    if (msurfacedb(i) is nothing) then
        buscavacio = i
        exit function
    end if
next

buscavacio = -1
end function

private function borramenosusado() as integer
'borra el grafico menos usado
'devuelve el index al borrado

borramenosusado = 1

dim lvalor as long
dim lcont as long

lvalor = mbmpdb(1).accesos
lcont = mbmpdb(1).cont

dim i as integer

for i = 1 to mmaxentries
    if mbmpdb(i).accesos < lvalor and mbmpdb(i).cont < lcont then
        lvalor = mbmpdb(i).accesos
        lcont = mbmpdb(i).cont
        borramenosusado = i
    end if
next
mcantidadgraficos = mcantidadgraficos - 1

mkeys(mbmpdb(borramenosusado).efecto, mbmpdb(borramenosusado).filename) = 0
set msurfacedb(borramenosusado) = nothing
call zeromemory(mbmpdb(borramenosusado), len(mbmpdb(borramenosusado)))

end function

private sub class_terminate()
on error resume next 'no me importa, estoy cerrando

'erase mbmpdb()
dim i as integer

for i = 1 to mmaxentries
    set msurfacedb(i) = nothing
next

end sub

public property let lpdirectdraw7(byref objdirectdraw7 as directdraw7)
set mddraw = objdirectdraw7
end property

private function getbmpheader(archivo as string, byref lpbmpinfo as bmp_info) as long
'if fileexist
dim nfile as integer, h_bmph as bitmapfileheader, h_bmpi as bitmapinfoheader
nfile = freefile()
open archivo for binary access read as #nfile
get #nfile, , h_bmph
get #nfile, , h_bmpi
close #nfile
lpbmpinfo.height = h_bmpi.biheight
lpbmpinfo.width = h_bmpi.biwidth
lpbmpinfo.size = h_bmph.bfsize
getbmpheader = 1
end function

public property get maxentries() as long
maxentries = mmaxentries
end property

public property let maxentries(byval vnewvalue as long)
mmaxentries = vnewvalue
end property

public property get cantidadgraficos() as variant
cantidadgraficos = mcantidadgraficos
end property

'*******************************************************
'*******************************************************
'*******************************************************
'*******************************************************
'*******************************************************

'para compatibilidad con el bmpman no dyn
public property get totalgraficos() as variant

end property

public property let totalgraficos(byval vnewvalue as variant)

end property

public property get esdinamico() as variant
esdinamico = true
end property

public function cargargrafico(archivo as integer) as integer

end function

public property get efectopred() as integer
efectopred = mefectopred
end property

public property let efectopred(byval inewvalue as integer)
mefectopred = inewvalue
end property
