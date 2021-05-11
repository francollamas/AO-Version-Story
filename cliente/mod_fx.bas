attribute vb_name = "mod_fx"
option explicit

public const max_fx = 300

type tfx
    vida      as integer
    x         as integer
    y         as integer
    userindex as integer
    grhindex  as integer
end type

'vector que contiene los dialogos
public fxs(1 to max_fx) as tfx

'apunta a el ultimo mensaje
public ultimofx as integer
'contiene la cantidad de mensajes activos
public cantidadfx as integer

function primerindicevaciofx() as integer
dim i as byte
i = 1
do while i <= max_fx and fxs(i).vida <> 0
       i = i + 1
loop
if fxs(i).vida = 0 then primerindicevaciofx = i
end function



public sub crearfx(byval user as integer, byval grhindex as integer, byval vida as integer)
dim miuserindex as integer
dim indicelibre as integer

if buscaruserindexfx(user, miuserindex) then
      fxs(miuserindex).vida = 0
      fxs(miuserindex).userindex = 0
end if
    
indicelibre = primerindicevaciofx
fxs(indicelibre).vida = delay
fxs(indicelibre).userindex = user
fxs(indicelibre).grhindex = grhindex

if ultimofx > indicelibre then
        ultimofx = indicelibre
end if
cantidadfx = cantidadfx + 1
  
end sub

function buscaruserindexfx(user as integer, miuser as integer) as boolean
dim i as integer
i = 1
do while i < max_fx and fxs(i).userindex <> user
       i = i + 1
loop
if fxs(i).userindex = user then
        miuser = i
        buscaruserindexfx = true
else: buscaruserindexfx = false
end if
end function

public sub update_fx_pos(x as integer, y as integer, index as integer)
dim miuserindex as integer
if buscaruserindexfx(index, miuserindex) then
  if fxs(miuserindex).vida > 0 then
            fxs(miuserindex).x = x + 5
            fxs(miuserindex).y = y + 20
        if fxs(miuserindex).vida > 0 then
           fxs(miuserindex).vida = fxs(miuserindex).vida - 1
        end if
        if fxs(miuserindex).vida = 0 then
            if miuserindex = ultimofx then ultimofx = ultimofx - 1
            cantidadfx = cantidadfx - 1
        end if
  end if
end if
end sub


public sub mostrarfx()
dim i as integer
for i = 1 to cantidadfx
    if fxs(i).vida > 0 then
         call ddrawtransgrhtosurface(backbuffersurface, grh(fxs(i).grhindex), fxs(i).x, fxs(i).y, 0, 1)
    end if
next
end sub

public sub quitarfx(charindex as integer)
dim i as integer
i = 1
do while i < max_fx and fxs(i).userindex <> charindex
       i = i + 1
loop
if fxs(i).userindex = charindex then
      fxs(i).vida = 0
end if
end sub

