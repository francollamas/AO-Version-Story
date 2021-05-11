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

private grhpath as string

public property let path(byval instring as string)
grhpath = instring
end property

public function getbmp(filename as integer) as directdrawsurface7

dim retval as integer

if mkeys(filename) <> 0 then 'esta el surface en memoria?
    mbmpdb(mkeys(filename)).accesos = mbmpdb(mkeys(filename)).accesos + 1 'sumo un acceso
    set getbmp = msurfacedb(mkeys(filename)) 'y devuelvo una surface con el grafico cargado
else 'grafico no cargado
    retval = buscavacio() 'busco espacio para cargarlo
    if retval = -1 then 'todas las surface ocupadas
        retval = 1
        retval = borramenosusado() 'borro el grafico menos usado
    end if
    call creargrafico(filename, retval) 'y creo la textura
    mbmpdb(retval).accesos = mbmpdb(retval).accesos + 1 'sumo un acceso
    mkeys(filename) = retval
    set getbmp = msurfacedb(retval) 'y devuelvo una surface con el grafico cargado
end if


end function


public function init() as long 'inicializa todo, ejecutar antes de usar el objeto
on error goto errhandler

if mmaxentries < 1 then 'por lo menos 1 grafico
    init = -1
    exit function
end if

redim mbmpdb(0 to mmaxentries)
redim msurfacedb(0 to mmaxentries)
redim mkeys(0 to 15000) as integer

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
    call zeromemory(mbmpdb(i), len(mbmpdb(i)))
    set msurfacedb(i) = nothing
next
borrartodo = 1
mcantidadgraficos = 0
end function

public function borrar(filename as integer) as integer
'borra un grafico
borrar = -1
call zeromemory(mbmpdb(mkeys(filename)), len(mbmpdb(mkeys(filename))))
set msurfacedb(mkeys(filename)) = nothing
mkeys(filename) = 0
borrar = 1
mcantidadgraficos = mcantidadgraficos - 1
end function

private function creargrafico(archivo as integer, bindex as integer) as integer
'12/1/3, colorkey
dim ddsd as ddsurfacedesc2, bmpinfo as bmp_info, retval as long, ddck as ddcolorkey
ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width

call getbmpheader(grhpath & archivo & ".bmp", bmpinfo)  'para alto y ancho de la surface

ddsd.ddscaps.lcaps = ddscaps_offscreenplain
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

mkeys(mbmpdb(borramenosusado).filename) = 0
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

