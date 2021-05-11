attribute vb_name = "mod_dx"
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

option explicit

public const numsoundbuffers = 20

public directx as new directx7
public directdraw as directdraw7
public directsound as directsound

public primarysurface as directdrawsurface7
public primaryclipper as directdrawclipper
public secundaryclipper as directdrawclipper
public backbuffersurface as directdrawsurface7

'public surfacedb() as directdrawsurface7

'### 08/04/03 ###
#if (usardinamico = 1) then
    public surfacedb as new cbmpman
#else
    public surfacedb as new cbmpmannodyn
#end if

public perf as directmusicperformance
public seg as directmusicsegment
public segstate as directmusicsegmentstate
public loader as directmusicloader

public oldresheight as long, oldreswidth as long
public bnoreschange as boolean

public lastsoundbufferused as integer
public dsbuffers(1 to numsoundbuffers) as directsoundbuffer

public ddsd2 as ddsurfacedesc2
public ddsd4 as ddsurfacedesc2
public ddsd5 as ddsurfacedesc2
public ddsalphapicture as directdrawsurface7
public ddsspotlight as directdrawsurface7


private sub iniciardirectsound()
err.clear
on error goto fin
    set directsound = directx.directsoundcreate("")
    if err then
        msgbox "error iniciando directsound"
        end
    end if
    
    lastsoundbufferused = 1
    '<----------------direct music--------------->
    set perf = directx.directmusicperformancecreate()
    call perf.init(nothing, 0)
    perf.setport -1, 80
    call perf.setmasterautodownload(true)
    '<------------------------------------------->
    exit sub
fin:

logerror "error al iniciar iniciardirectsound, asegurese de tener bien configurada la placa de sonido."

musica = 1
fx = 1

end sub

private sub liberardirectsound()
dim cloop as integer
for cloop = 1 to numsoundbuffers
    set dsbuffers(cloop) = nothing
next cloop
set directsound = nothing
end sub

private sub iniciardxobject(dx as directx7)

err.clear

on error resume next

set dx = new directx7

if err then
    msgbox "no se puede iniciar directx. por favor asegurese de tener la ultima version correctamente instalada."
    logerror "error producido por set dx = new directx7"
    end
end if

end sub

private sub iniciarddobject(dd as directdraw7)
err.clear
on error resume next
set dd = directx.directdrawcreate("")
if err then
    msgbox "no se puede iniciar directdraw. por favor asegurese de tener la ultima version correctamente instalada."
    logerror "error producido en private sub iniciarddobject(dd as directdraw7)"
    end
end if
end sub

public sub iniciarobjetosdirectx()

on error resume next

call addtorichtextbox(frmcargando.status, "iniciando directx....", 0, 0, 0, 0, 0, true)
call iniciardxobject(directx)
call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)

call addtorichtextbox(frmcargando.status, "iniciando directdraw....", 0, 0, 0, 0, 0, true)
call iniciarddobject(directdraw)
call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)

if musica = 0 or fx = 0 then
    call addtorichtextbox(frmcargando.status, "iniciando directsound....", 0, 0, 0, 0, 0, true)
    call iniciardirectsound
    call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)
end if

call addtorichtextbox(frmcargando.status, "analizando y preparando la placa de video....", 0, 0, 0, 0, 0, true)

  
    
dim lres as long
dim midevm as typdevmode
lres = enumdisplaysettings(0, 0, midevm)
    
dim intwidth as integer
dim intheight as integer

oldreswidth = screen.width \ screen.twipsperpixelx
oldresheight = screen.height \ screen.twipsperpixely

dim cambiarresolucion as boolean

if nores then
    cambiarresolucion = (oldreswidth < 800 or oldresheight < 600)
else
    cambiarresolucion = (oldreswidth <> 800 or oldresheight <> 600)
end if

if cambiarresolucion then
      with midevm
            .dmfields = dm_pelswidth or dm_pelsheight or dm_bitsperpel
            .dmpelswidth = 800
            .dmpelsheight = 600
            .dmbitsperpel = 16
      end with
      lres = changedisplaysettings(midevm, cds_test)
else
      bnoreschange = true
end if

call addtorichtextbox(frmcargando.status, "�directx ok!", 0, 251, 0, 1, 0)

exit sub

end sub

public sub liberarobjetosdx()
err.clear
on error goto fin:
dim loopc as integer

set primarysurface = nothing
set primaryclipper = nothing
set backbuffersurface = nothing

liberardirectsound

call surfacedb.borrartodo

set directdraw = nothing

for loopc = 1 to numsoundbuffers
    set dsbuffers(loopc) = nothing
next loopc


set loader = nothing
set perf = nothing
set seg = nothing
set directsound = nothing

set directx = nothing
exit sub
fin: logerror "error producido en public sub liberarobjetosdx()"
end sub

