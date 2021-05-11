version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "soundmapinfo"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' soundmapinfo.cls
'
'**************************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the affero general public license;
'either version 1 of the license, or any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the affero general public license
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

option explicit

private type p_tsoundmapinfo
    cantidad as integer
    soundindex() as integer
    flags() as long
    probabilidad() as single
end type

private enum p_esoundflags
    ninguna = 0
    lluvia = 1
end enum

private p_mapas() as p_tsoundmapinfo


'sonidos conocidos, pasados a enum para intelisense
public enum e_soundindex
    muerte_hombre = 11
    muerte_mujer = 74
    flecha_impacto = 65
    conversion_barco = 55
    morfar_manzana = 82
    sound_comida = 7
end enum

private sub class_initialize()
'armar el array
    redim p_mapas(1 to nummaps) as p_tsoundmapinfo
    call loadsoundmapinfo
end sub

public sub loadsoundmapinfo()
    dim i as integer
    dim j as integer
    dim temps as string
    dim mapfile as string
    
    mapfile = app.path & mappath & "mapa"
    
    'usage of val() prevents errors when dats are corrputed or incomplete. all invalid values are assumed to be zero.
    
'todo : log the error in the dat for correction.
    for i = 1 to ubound(p_mapas)
        temps = getvar(mapfile & i & ".dat", "sonidos", "cantidad")
        
        if isnumeric(temps) then
            p_mapas(i).cantidad = val(temps)
            
            redim p_mapas(i).flags(1 to p_mapas(i).cantidad) as long
            redim p_mapas(i).probabilidad(1 to p_mapas(i).cantidad) as single
            redim p_mapas(i).soundindex(1 to p_mapas(i).cantidad) as integer
            
            for j = 1 to p_mapas(i).cantidad
                p_mapas(i).flags(j) = val(getvar(mapfile & i & ".dat", "sonido" & j, "flags"))
                p_mapas(i).probabilidad(j) = val(getvar(mapfile & i & ".dat", "sonido" & j, "probabilidad"))
                p_mapas(i).soundindex(j) = val(getvar(mapfile & i & ".dat", "sonido" & j, "sonido"))
            next j
        else
            p_mapas(i).cantidad = 0
        end if
    next i
end sub

public sub reproducirsonidosdemapas()
    dim i as long
    dim sonidomapa as byte
    dim posx as byte
    dim posy as byte
    
    'sounds are played at a random position
    posx = randomnumber(xminmapsize, xmaxmapsize)
    posy = randomnumber(yminmapsize, ymaxmapsize)
    
    for i = 1 to ubound(p_mapas)
        if p_mapas(i).cantidad > 0 then
            sonidomapa = randomnumber(1, p_mapas(i).cantidad)
            if randomnumber(1, 100) <= p_mapas(i).probabilidad(sonidomapa) then
                'tocarlo
                if lloviendo then
                    if p_mapas(i).flags(sonidomapa) xor p_esoundflags.lluvia then
                        call senddata(sendtarget.tomap, i, preparemessageplaywave(p_mapas(i).soundindex(sonidomapa), posx, posy))
                    end if
                else
                    if p_mapas(i).flags(sonidomapa) xor p_esoundflags.ninguna then
                        call senddata(sendtarget.tomap, i, preparemessageplaywave(p_mapas(i).soundindex(sonidomapa), posx, posy))
                    end if
                end if
            end if
        end if
    next i
end sub

public sub reproducirsonido(byval destino as sendtarget, byval index as integer, byval soundindex as integer)
    call senddata(destino, index, preparemessageplaywave(soundindex, userlist(index).pos.x, userlist(index).pos.y))
end sub
