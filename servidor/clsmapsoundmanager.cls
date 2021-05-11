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
    
    for i = 1 to ubound(p_mapas)
        temps = getvar(mapfile & i & ".dat", "sonidos", "cantidad")
        if isnumeric(temps) then
            p_mapas(i).cantidad = cint(getvar(mapfile & i & ".dat", "sonidos", "cantidad"))
            redim p_mapas(i).flags(1 to p_mapas(i).cantidad) as long
            redim p_mapas(i).probabilidad(1 to p_mapas(i).cantidad) as single
            redim p_mapas(i).soundindex(1 to p_mapas(i).cantidad) as integer
            for j = 1 to p_mapas(i).cantidad
                p_mapas(i).flags(j) = cint(getvar(mapfile & i & ".dat", "sonido" & j, "flags"))
                p_mapas(i).probabilidad(j) = csng(getvar(mapfile & i & ".dat", "sonido" & j, "probabilidad"))
                p_mapas(i).soundindex(j) = cint(getvar(mapfile & i & ".dat", "sonido" & j, "sonido"))
            next j
        else
            p_mapas(i).cantidad = 0
        end if
    next i
end sub


public sub reproducirsonidosdemapas()
dim i as integer
dim sonidosmapa as byte
dim sonidomapa as byte

    for i = 1 to ubound(p_mapas)
        if p_mapas(i).cantidad > 0 then
            sonidomapa = randomnumber(1, p_mapas(i).cantidad)
            if randomnumber(1, 100) <= p_mapas(i).probabilidad(sonidomapa) then
                'tocarlo
                if lloviendo then
                    if p_mapas(i).flags(sonidomapa) xor p_esoundflags.lluvia then
                        call senddata(sendtarget.tomap, 0, i, "tw" & p_mapas(i).soundindex(sonidomapa))
                    end if
                else
                    if p_mapas(i).flags(sonidomapa) xor p_esoundflags.ninguna then
                        call senddata(sendtarget.tomap, 0, i, "tw" & p_mapas(i).soundindex(sonidomapa))
                    end if
                end if
            end if
        end if
    next i
    
end sub

public sub reproducirsonido(byval destino as byte, byval userindex as integer, byval mapa as integer, byval soundindex as integer)
    call senddata(destino, userindex, mapa, "tw" & soundindex)
end sub
