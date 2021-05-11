version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clstextdrawer"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

private type recto ' xd
    left as long
    top as long
    right as long
    bottom as long
end type

private declare function textout lib "gdi32" alias "textouta" (byval hdc as long, byval x as long, byval y as long, byval lpstring as string, byval ncount as long) as long
private declare function settextcolor lib "gdi32" (byval hdc as long, byval crcolor as long) as long
private declare function setbkmode lib "gdi32" (byval hdc as long, byval nbkmode as long) as long
private declare function setbkcolor lib "gdi32" (byval hdc as long, byval crcolor as long) as long
private declare function selectobject lib "gdi32" (byval hdc as long, byval hobject as long) as long
private declare function deleteobject lib "gdi32" (byval hobject as long) as long
private declare function createfont lib "gdi32" alias "createfonta" (byval h as long, _
    byval w as long, byval e as long, byval o as long, byval w as long, byval i as long, _
    byval u as long, byval s as long, byval c as long, byval op as long, byval cp as long, _
    byval q as long, byval paf as long, byval f as string) as long
private declare function gettextextentpoint32 lib "gdi32" alias "gettextextentpoint32a" (byval hdc as long, byval lpsz as string, byval cbstring as long, lpsize as size) as long
private declare function rectangle lib "gdi32" (byval hdc as long, byval x1 as long, byval y1 as long, byval x2 as long, byval y2 as long) as long
private declare function invalidaterect lib "user32" ( _
    byval hwnd as long, lprect as recto, byval berase as long) as long
private declare function getdc lib "user32" (byval hwnd as long) as long
private declare function releasedc lib "user32" (byval hwnd as long, byval hdc as long) as long
private declare function postmessage lib "user32" alias "postmessagea" (byval hwnd as long, byval wmsg as long, byval wparam as long, byval lparam as long) as long

const wm_paint = &hf

const text_transparent = 1
const text_opaque = 2

const fw_dontcare = 0
const fw_thin = 100
const fw_extralight = 200
const fw_ultralight = 200
const fw_light = 300
const fw_normal = 400
const fw_regular = 400
const fw_medium = 500
const fw_semibold = 600
const fw_demibold = 600
const fw_bold = 700
const fw_extrabold = 800
const fw_ultrabold = 800
const fw_black = 900
const fw_heavy = 900

const ansi_charset = 0
const default_charset = 1
const symbol_charset = 2
const shiftjis_charset = 128
const oem_charset = 255

const out_tt_only_precis = 7
const clip_default_precis = 0
const clip_lh_angles = &h10
const proof_quality = 2
const truetype_fonttype = &h4

const textbuffer_size = 1024

private type textinfo
    x as long
    y as long
    color as long
    centered as boolean
    text as string
end type

private type size
    cx as long
    cy as long
end type

private textbuffer(textbuffer_size) as textinfo
private textcount as long

private lngfont as long
private oldfont as long
private angle as long
private tetireunpaint as boolean

const max_colors = 255

private directdraw as directdraw7
private textsurfaces(max_colors) as long
private surface(max_colors) as directdrawsurface7
private cantcolors as long
private surfacesize as size
private letters as string
private lettersrect(255) as rect

public function inittext(dd as directdraw7)
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************

dim ret as size
dim tsize as integer
dim i as long
set directdraw = dd
dim hdc as long

hdc = getdc(frmmain.hwnd)
lngfont = createfont(13, 0, 0, 0, fw_bold, 0, 0, 0, default_charset, out_tt_only_precis, clip_lh_angles or clip_default_precis, proof_quality, truetype_fonttype, "tahoma") ' hardocodeo la que usan siempre, la de frmmain.
oldfont = selectobject(hdc, lngfont)
tsize = 0
letters = ""

for i = 32 to 255
        letters = letters & chr(i)
        call gettextextentpoint32(hdc, chr(i), 1, ret)
        lettersrect(i).left = tsize
        lettersrect(i).right = tsize + ret.cx
        lettersrect(i).top = 0
        lettersrect(i).bottom = 13
        tsize = tsize + ret.cx
        if i = 126 then i = 160
next i

    surfacesize.cy = ret.cy
    surfacesize.cx = tsize
    if oldfont <> 0 then
        call selectobject(hdc, oldfont)
    end if
    
deleteobject lngfont
call releasedc(frmmain.hwnd, hdc)

set surface(0) = createsurface(0) ' creo el color negro
cantcolors = 1
end function

private function gettextsurface(color as long) as directdrawsurface7
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************
dim i as long

for i = 0 to cantcolors
    if textsurfaces(i) = color then
        set gettextsurface = surface(i)
        exit function
    end if
next i

if cantcolors < max_colors then 'creo la nueva surface
    set surface(cantcolors) = createsurface(color)
    textsurfaces(cantcolors) = color
    set gettextsurface = surface(cantcolors)
    cantcolors = cantcolors + 1
end if

end function

private function createsurface(byval color as long) as directdrawsurface7
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************
on error goto errhandler

    dim newsurface as directdrawsurface7
    dim ddsd as ddsurfacedesc2
    dim ddck as ddcolorkey
    dim bkcolor as long
    dim hdc as long
    
     'set up the surface desc
    ddsd.lflags = ddsd_caps or ddsd_height or ddsd_width
    ddsd.ddscaps.lcaps = ddscaps_offscreenplain or ddscaps_videomemory
    ddsd.lwidth = surfacesize.cx
    ddsd.lheight = surfacesize.cy
        
    set newsurface = directdraw.createsurface(ddsd)
    bkcolor = &h0
    if color = vbblack then bkcolor = &h10101
    
    'dibujo el texto
    hdc = newsurface.getdc
    lngfont = createfont(13, 0, 0, 0, fw_bold, 0, 0, 0, default_charset, out_tt_only_precis, clip_lh_angles or clip_default_precis, proof_quality, truetype_fonttype, "tahoma") ' hardocodeo la que usan siempre, la de frmmain.
    oldfont = selectobject(hdc, lngfont)
    setbkmode hdc, text_opaque
    setbkcolor hdc, bkcolor
    settextcolor hdc, color
    textout hdc, 0, 0, letters, len(letters)
    if oldfont <> 0 then call selectobject(hdc, oldfont)
    deleteobject lngfont
    newsurface.releasedc hdc
    'podria haber usado el drawtext del dx aca, pero soy jodido
    
    ddck.high = bkcolor
    ddck.low = bkcolor
    call newsurface.setcolorkey(ddckey_srcblt, ddck)
    set createsurface = newsurface
    
exit function

errhandler:
    if err.number = dderr_outofmemory or err.number = dderr_outofvideomemory then
            msgbox "no hay memoria disponible! el programa abortar�. cierra algunos programas e intenta de nuevo"
            end
    else
        msgbox "un error inesperado ocurri� al intentar crear el texto" & ". " & vbcrlf & _
                "el c�digo de error es " & cstr(err.number) & " - " & err.description & vbcrlf & vbcrlf & "copia este mensaje y notifica a los administradores.", _
                vbokonly or vbcritical or vbexclamation, "error"
        end
    end if
end function

public function drawtext(byval x as long, byval y as long, byval text as string, byval color as long, byval surface as directdrawsurface7)
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************
    dim i as integer
    dim tx as long
    dim textsurface as directdrawsurface7
    dim bytestring() as byte
    if x > 120 and x < 799 and y > 246 and y < 668 then
        bytestring = strconv(text, vbfromunicode)
        tx = x
        set textsurface = gettextsurface(color)
        for i = 0 to ubound(bytestring) ' - 1
            call surface.bltfast(tx, y, textsurface, lettersrect(bytestring(i)), ddbltfast_srccolorkey or ddbltfast_wait)
            tx = tx + lettersrect(bytestring(i)).right - lettersrect(bytestring(i)).left
        next i
    end if
end function

public function drawtexttodc(hdc as long, optional fontsize as long = 13) as long
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************

'forma alternativa de dibujar texto con gdi
'la forma de usarla es llamando a la funcion addtext de ahi abajo
dim i as long
dim lastcolor as long
dim ret as size
dim trect as recto

'aplico mi font
lngfont = createfont(fontsize, 0, 0, 0, fw_bold, 0, 0, 0, default_charset, out_tt_only_precis, clip_lh_angles or clip_default_precis, proof_quality, truetype_fonttype, "tahoma") ' hardocodeo la que usan siempre, la de frmmain.
oldfont = selectobject(hdc, lngfont)

'le doy fondo transparente
setbkmode hdc, text_transparent

'primero dibujo toda la capa en negro
settextcolor hdc, vbblack
for i = 0 to textcount - 1
    with (textbuffer(i))
        if .centered then ' ya lo dejo acomodado
            call gettextextentpoint32(hdc, .text, len(.text), ret)
            .x = .x - ret.cx \ 2
        end if
        textout hdc, .x - 2, .y - 1, .text, len(.text)
    end with
next i

'y ahora toda la capa en color
for i = 0 to textcount - 1
    with (textbuffer(i))
        if .color <> lastcolor then ' si es igual me ahorro una llamada a un api, costo beneficio me va
            settextcolor hdc, .color
            lastcolor = .color
        end if
        textout hdc, .x, .y, .text, len(.text)
    end with
next i


textcount = 0 ' se resetea
if oldfont <> 0 then call selectobject(hdc, oldfont)
deleteobject lngfont

drawtexttodc = 0
end function

public function addtext(xpos as integer, ypos as integer, fontcolor as long, strtext as string, optional centered as boolean = false) as long
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************

if strtext <> "" then
    if xpos > 120 and xpos < 799 and ypos > 246 and ypos < 668 then 'te la hago corta, mas alla de esto no lo veo.
        if textcount < textbuffer_size then
            with textbuffer(textcount)
                .x = xpos
                .y = ypos
                .color = fontcolor
                .text = strtext
                .centered = centered
            end with
            textcount = textcount + 1
            addtext = textcount
        else
            addtext = -1
        end if
    end if
end if

end function

private sub class_terminate()
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************

dim i as long

for i = 0 to cantcolors
    set surface(i) = nothing
next i

end sub

public function drawdice(optional refresh as boolean = true) as long
'**************************************************************
'author: alejandro salvo (salvito)
'last modify date: 07/31/2010
'
'**************************************************************

    dim i as long
    dim hdc as long
    dim tesmpstring as string
    
    dim thdc as long
    dim temprect as recto

    if refresh = false then
        angle = randomnumber(0, 1) * (3440) + randomnumber(0, 160)
    end if

    temprect.top = 218
    temprect.bottom = 338
    temprect.left = 295
    temprect.right = 380
    
    call invalidaterect(frmcrearpersonaje.hwnd, temprect, 0)
    tetireunpaint = true
    
    call postmessage(frmcrearpersonaje.hwnd, wm_paint, 0, 0)
    doevents ' como es esto que usa un doevents afuera de un loop? jajaja
    
    hdc = getdc(frmcrearpersonaje.hwnd)
    
    lngfont = createfont(13, 0, angle, 0, fw_bold, 0, 0, 0, default_charset, out_tt_only_precis, clip_lh_angles or clip_default_precis, proof_quality, truetype_fonttype, "ms sans serif")
    oldfont = selectobject(hdc, lngfont)


    setbkmode hdc, text_transparent
    setbkcolor hdc, vbblack
    settextcolor hdc, vbwhite
    
    for i = 1 to numatributos
        textout hdc, frmcrearpersonaje.lblatributos(i).left, frmcrearpersonaje.lblatributos(i).top, frmcrearpersonaje.lblatributos(i).caption, len(frmcrearpersonaje.lblatributos(i).caption)
        textout hdc, frmcrearpersonaje.lblatributofinal(i).left, frmcrearpersonaje.lblatributofinal(i).top, frmcrearpersonaje.lblatributofinal(i).caption, len(frmcrearpersonaje.lblatributofinal(i).caption)
    next i

    if oldfont <> 0 then
        call selectobject(hdc, oldfont)
    end if
    
    deleteobject lngfont
    releasedc frmcrearpersonaje.hwnd, hdc
  
end function

public property get sentpaint() as boolean
    sentpaint = tetireunpaint
    tetireunpaint = false
end property
