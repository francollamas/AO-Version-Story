version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsguilddlg"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

private p_cantidaddialogos as byte
private const p_segundos = 7
private type t_guilddlg
    texto as string
    segundos as byte
end type
private p_dialogos() as t_guilddlg
private p_activo as boolean

public property let cantidaddialogos(byval v as byte)
    if v > 0 then
    redim preserve p_dialogos(1 to v) as t_guilddlg
    end if
    p_cantidaddialogos = v
end property

public property let activo(byval v as boolean)
    p_activo = v
end property

public property get activo() as boolean
    activo = p_activo
end property

public sub class_initialize()
    p_cantidaddialogos = 5
    redim p_dialogos(1 to p_cantidaddialogos) as t_guilddlg
    p_activo = true
end sub

public sub draw(byref c as cdialogos)
dim i as byte
dim y as long

if not p_activo then exit sub

y = 250
'500 600 700 800 900
    for i = 1 to p_cantidaddialogos
        if trim$(p_dialogos(i).texto) <> vbnullstring then
            if left$(p_dialogos(i).texto, 1) = chr(3) then
                call c.drawtext(260, y + (i * 10), mid(p_dialogos(i).texto, 2), vbgreen)
            else
                call c.drawtext(260, y + (i * 10), p_dialogos(i).texto, vbyellow)
            end if
        end if
    next i
end sub

public sub passtimer()
dim i as byte

for i = 1 to p_cantidaddialogos
    if p_dialogos(i).segundos > 0 then
        p_dialogos(i).segundos = p_dialogos(i).segundos - 1
    else
        p_dialogos(i).texto = vbnullstring
    end if
next i
    
end sub

public sub pushbacktext(byval s as string)
dim i as byte
dim vacio as boolean
dim multiplicador as integer
if left$(s, 1) = chr(3) then
    multiplicador = 7
else
    multiplicador = 1
end if

if p_cantidaddialogos > 0 then
    i = p_cantidaddialogos
    vacio = true
    while i > 0 and vacio
        vacio = p_dialogos(i).texto = vbnullstring
        if vacio then i = i - 1
    wend
    if i = p_cantidaddialogos then
        'hay q scrollear, estamos llenos
        i = 1
        while i < p_cantidaddialogos
            p_dialogos(i) = p_dialogos(i + 1)
            i = i + 1
        wend
        p_dialogos(i).texto = s
        p_dialogos(i).segundos = p_segundos * multiplicador
    else
        p_dialogos(i + 1).texto = s
        p_dialogos(i + 1).segundos = p_segundos * multiplicador
    end if
end if

end sub

